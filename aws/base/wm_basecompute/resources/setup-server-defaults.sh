# initial yum update to the latest
echo "Updating all OS base packages"
yum update -y

# epel - install if not present
if [ "`yum repolist | grep 'epelasd: dl.fedoraproject.org'`" == "" ] ; then
    echo "Installing yum repo for epel"
    yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
fi