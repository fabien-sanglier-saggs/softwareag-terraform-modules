# create new group and user for softwares
if [ "$SOFTWARE_DIR_USERNAME" != "" ] ; then
    echo "Creating user $SOFTWARE_DIR_USERNAME for softwares dir"

    groupadd -f -g $SOFTWARE_DIR_GROUPID $SOFTWARE_DIR_GROUP
    id -u $SOFTWARE_DIR_USERNAME >/dev/null 2>&1 || useradd -m -s /bin/bash -c "Software User" -u $SOFTWARE_DIR_USERID -g $SOFTWARE_DIR_GROUPID $SOFTWARE_DIR_USERNAME
else
    echo "No user specified for softwares dir"
fi

# create new group and user for data
if [ "$DATA_DIR_USERNAME" != "" ] ; then
    echo "Creating user $DATA_DIR_USERNAME for data dir"

    groupadd -f -g $DATA_DIR_GROUPID $DATA_DIR_GROUP
    id -u $DATA_DIR_USERNAME >/dev/null 2>&1 || useradd -m -s /bin/bash -c "Data User" -u $DATA_DIR_USERID -g $DATA_DIR_GROUPID $DATA_DIR_USERNAME
else
    echo "No user specified for data dir"
fi