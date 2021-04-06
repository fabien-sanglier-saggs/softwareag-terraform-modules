#############################################
########## Prep new disk for user homes
#############################################

DISK_ID_USER_HOME=$(lsblk -o +SERIAL | grep ${VOLUME_ID_USER_HOME//-} | tr -s " " | cut -d ' ' -f 1)
if [ "$DISK_ID_USER_HOME" != "" ] ; then
    echo "Formatting Disk $DISK_ID_USER_HOME"

    # formatting and labelling
    DISK_LABEL_HOMES="home"
    mkfs -t ext4 /dev/$DISK_ID_USER_HOME
    e2label /dev/$DISK_ID_USER_HOME $DISK_LABEL_HOMES

    # check if path already exists...if so, move files to the new disk
    if [ -d $VOLUME_USER_HOME_MOUNT_DIR ] ; then
        mkdir -p /srv/tmp_homes
        mount /dev/$DISK_ID_USER_HOME /srv/tmp_homes
        cp -aR $VOLUME_USER_HOME_MOUNT_DIR/* /srv/tmp_homes/
        rm -rf $VOLUME_USER_HOME_MOUNT_DIR/*
        umount /srv/tmp_homes
        rm -rf /srv/tmp_homes
    else
        #create the dir if it does not exist
        mkdir -p $VOLUME_USER_HOME_MOUNT_DIR
    fi

    # mount and set to automount on further reboots
    mount /dev/$DISK_ID_USER_HOME $VOLUME_USER_HOME_MOUNT_DIR
    echo "LABEL=$DISK_LABEL_HOMES $VOLUME_USER_HOME_MOUNT_DIR ext4 defaults,nofail 0 2" >> /etc/fstab
else
    echo "Disk VOLUME_ID_USER_HOME = ${VOLUME_ID_USER_HOME} does not exist"
fi

#############################################
########## Prep new disk for software
#############################################

# Prep new disk for softwareag software (ie. nvme1n1, etc...)
DISK_ID_SOFTWARE=$(lsblk -o +SERIAL | grep ${VOLUME_ID_SOFTWARE//-} | tr -s " " | cut -d ' ' -f 1)
if [ "$DISK_ID_SOFTWARE" != "" ] ; then
    echo "Formatting Disk $DISK_ID_SOFTWARE"

    # formatting and labelling
    DISK_LABEL_SOFTWARE="software"
    mkfs -t ext4 /dev/$DISK_ID_SOFTWARE
    e2label /dev/$DISK_ID_SOFTWARE $DISK_LABEL_SOFTWARE

    # check if path already exists...if so, move files to the new disk
    if [ -d $VOLUME_SOFTWARE_MOUNT_DIR ] ; then
        mkdir -p /srv/tmp_software
        mount /dev/$DISK_ID_SOFTWARE /srv/tmp_software
        cp -aR $VOLUME_SOFTWARE_MOUNT_DIR/* /srv/tmp_software/
        rm -rf $VOLUME_SOFTWARE_MOUNT_DIR/*
        umount /srv/tmp_software
        rm -rf /srv/tmp_software
    else
        #create the dir if it does not exist
        mkdir -p $VOLUME_SOFTWARE_MOUNT_DIR
    fi

    # mount and set to automount on further reboots
    mount /dev/$DISK_ID_SOFTWARE $VOLUME_SOFTWARE_MOUNT_DIR
    echo "LABEL=$DISK_LABEL_SOFTWARE $VOLUME_SOFTWARE_MOUNT_DIR ext4 defaults,nofail 0 2" >> /etc/fstab
else
    echo "Disk VOLUME_ID_SOFTWARE = ${VOLUME_ID_SOFTWARE} does not exist"
    if [ ! -d $VOLUME_SOFTWARE_MOUNT_DIR ] ; then
        mkdir -p $VOLUME_SOFTWARE_MOUNT_DIR
    fi
fi

#set ownership on softwares folders if user is found
if id "$SOFTWARE_DIR_USERNAME" &>/dev/null; then
    echo "user $SOFTWARE_DIR_USERNAME found, will set ownership on $VOLUME_SOFTWARE_MOUNT_DIR"
    chown -R $SOFTWARE_DIR_USERNAME:$SOFTWARE_DIR_GROUP $VOLUME_SOFTWARE_MOUNT_DIR
else
    echo "user $SOFTWARE_DIR_USERNAME not found"
fi

#############################################
########## Prep new disk for data
#############################################

# Prep new disk for softwareag software (ie. nvme1n1, etc...)
DISK_ID_DATA=$(lsblk -o +SERIAL | grep ${VOLUME_ID_DATA//-} | tr -s " " | cut -d ' ' -f 1)
if [ "$DISK_ID_DATA" != "" ] ; then
    echo "Formatting Disk $DISK_ID_DATA"

    # formatting and labelling
    DISK_LABEL_DATA="data"
    mkfs -t ext4 /dev/$DISK_ID_DATA
    e2label /dev/$DISK_ID_DATA $DISK_LABEL_DATA

    # check if path already exists...if so, move files to the new disk
    if [ -d $VOLUME_DATA_MOUNT_DIR ] ; then
        mkdir -p /srv/tmp_data
        mount /dev/$DISK_ID_DATA /srv/tmp_data
        cp -aR $VOLUME_DATA_MOUNT_DIR/* /srv/tmp_data/
        rm -rf $VOLUME_DATA_MOUNT_DIR/*
        umount /srv/tmp_data
        rm -rf /srv/tmp_data
    else
        #create the dir if it does not exist
        mkdir -p $VOLUME_DATA_MOUNT_DIR
    fi

    # mount and set to automount on further reboots
    mount /dev/$DISK_ID_DATA $VOLUME_DATA_MOUNT_DIR
    echo "LABEL=$DISK_LABEL_DATA $VOLUME_DATA_MOUNT_DIR ext4 defaults,nofail 0 2" >> /etc/fstab
else
    echo "Disk VOLUME_ID_DATA = ${VOLUME_ID_DATA} does not exist"
    if [ ! -d $VOLUME_DATA_MOUNT_DIR ] ; then
        mkdir -p $VOLUME_DATA_MOUNT_DIR
    fi
fi

#set ownership on data folders if user is found
if id "$DATA_DIR_USERNAME" &>/dev/null; then
    echo "user $DATA_DIR_USERNAME found, will set ownership on $VOLUME_DATA_MOUNT_DIR"
    chown -R $DATA_DIR_USERNAME:$DATA_DIR_GROUP $VOLUME_DATA_MOUNT_DIR
else
    echo "user $DATA_DIR_USERNAME not found"
fi