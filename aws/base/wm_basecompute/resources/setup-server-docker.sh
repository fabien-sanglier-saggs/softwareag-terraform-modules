#############################################
########## Prep new disk for user homes
#############################################

DISK_ID_USER_HOME=$(lsblk -o +SERIAL | grep ${VOLUME_ID_USER_HOME//-} | tr -s " " | cut -d ' ' -f 1)
if [ "$DISK_ID_USER_HOME" != "" ] ; then
    echo "Formatting Disk $DISK_ID_USER_HOME"

    mkfs -t ext4 /dev/$DISK_ID_USER_HOME
    e2label /dev/$DISK_ID_USER_HOME home
    
    ##temp - move the current homes to this new disk
    mkdir -p /srv/home
    mount /dev/$DISK_ID_USER_HOME /srv/home
    cp -aR /home/* /srv/home/
    rm -rf /home/*
    umount /srv/home
    rm -rf /srv/home
    mount /dev/$DISK_ID_USER_HOME /home

    echo "LABEL=home /home ext4 defaults,nofail 0 2" >> /etc/fstab
else
    echo "Disk VOLUME_ID_USER_HOME = ${VOLUME_ID_USER_HOME} does not exist"
fi

#############################################
########## Prep new disk for docker data
#############################################

# Prep new disk for docker data (ie. nvme1n1, etc...)
DISK_ID_DOCKER_DATA=$(lsblk -o +SERIAL | grep ${VOLUME_ID_DOCKER_DATA//-} | tr -s " " | cut -d ' ' -f 1)
if [ "$DISK_ID_DOCKER_DATA" != "" ] ; then
    DOCKER_DIR="/var/lib/docker"
    mkdir -p $DOCKER_DIR

    mkfs -t ext4 /dev/$DISK_ID_DOCKER_DATA
    e2label /dev/$DISK_ID_DOCKER_DATA docker
    mount /dev/$DISK_ID_DOCKER_DATA $DOCKER_DIR

    echo "LABEL=docker $DOCKER_DIR ext4 defaults,nofail 0 2" >> /etc/fstab
else
    echo "Disk VOLUME_ID_DOCKER_DATA = ${VOLUME_ID_DOCKER_DATA} does not exist"
fi

# initial yum update to the latest
echo "Updating all OS base packages"
yum update -y

# epel
yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# install common utils packages
yum install -y nano unzip telnet jq wget 

# fix systemctl
/bin/sh -c 'echo -e "vm.max_map_count=262144" > /etc/sysctl.d/60-softwareag.conf'
sysctl --system

# install aws cli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
./aws/install

# install Azure CLI
rpm --import https://packages.microsoft.com/keys/microsoft.asc

/bin/sh -c 'echo -e "[azure-cli]
name=Azure CLI
baseurl=https://packages.microsoft.com/yumrepos/azure-cli
enabled=1
gpgcheck=1
gpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/azure-cli.repo'

yum install -y azure-cli

# install docker
yum install -y yum-utils \
  device-mapper-persistent-data \
  lvm2

yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

yum install -y docker-ce docker-ce-cli containerd.io

usermod -a -G docker $ADMIN_USER
systemctl daemon-reload
systemctl enable docker
systemctl restart docker

# docker-compose install
curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# create docker cleanup cron job
echo "0 3 * * * docker system prune -f" >> /var/spool/cron/root

# kubernetes repo
bash -c "cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=0
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
"
yum install -y kubectl

# kubernets kops
curl -LO https://github.com/kubernetes/kops/releases/download/$(curl -s https://api.github.com/repos/kubernetes/kops/releases/latest | grep tag_name | cut -d '"' -f 4)/kops-linux-amd64
chmod +x kops-linux-amd64
mv -i kops-linux-amd64 /usr/local/bin/kops

# kubernets helm 3
export HELM_INSTALL_DIR=/usr/local/bin
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# final reboot
reboot