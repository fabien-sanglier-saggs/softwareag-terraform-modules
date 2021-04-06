#!/bin/bash -ex
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1
echo BEGIN
date '+%Y-%m-%d %H:%M:%S'

## variables declaration (if any) with possible terraform var substitutions
VOLUME_ID_USER_HOME="${volume_id_user_home}"
VOLUME_ID_SOFTWARE="${volume_id_software}"
VOLUME_ID_DATA="${volume_id_data}"

## mount dirs
VOLUME_USER_HOME_MOUNT_DIR="/home"
VOLUME_SOFTWARE_MOUNT_DIR="${mount_dir_software}"
VOLUME_DATA_MOUNT_DIR="${mount_dir_data}"

## users
BUILT_IN_ADMIN_USER="${adminuser}"

## for software dir
SOFTWARE_DIR_USERNAME="${software_username}"
SOFTWARE_DIR_USERID="${software_userid}"
SOFTWARE_DIR_GROUP="${software_groupname}"
SOFTWARE_DIR_GROUPID="${software_groupid}"

## for data dir
DATA_DIR_USERNAME="${data_username}"
DATA_DIR_USERID="${data_userid}"
DATA_DIR_GROUP="${data_groupname}"
DATA_DIR_GROUPID="${data_groupid}"

## load logic content
echo "users bootstrapping"
${logic_content_users}

echo "disks bootstrapping"
${logic_content_disks}

echo "default bootstrapping"
${logic_content_defaults}

echo "optional bootstrapping"
${logic_content_custom}

echo "DONE!!"