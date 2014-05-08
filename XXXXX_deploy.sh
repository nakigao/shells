#!/bin/sh

# ========================================
# Change permissions, owner and group command shell
#
# [FEATURES]
# - Change permissions for files and directories
# - Change owner and group for files and directories
#
# [RESTRICTIONS]
# - :)
#  
# [USAGES]
# - sh /path/to/XXXXX_deploy.sh
# ========================================

USER="XXXXX"
TARGET_USER="YYYYY"
TARGET_GROUP="ZZZZZ"
FILE_PERMISSION="0664"
DIRECTORY_PERMISSION="0775"
DIST_DIR="/path/to/dist/directory/"

sudo find ${DIST_DIR} -user ${USER} -type f -print | xargs sudo chmod ${FILE_PERMISSION}
sudo find ${DIST_DIR} -user ${USER} -type d -print | xargs sudo chmod ${DIRECTORY_PERMISSION}

sudo find ${DIST_DIR} -user ${USER} -type f -print | xargs sudo chown ${TARGET_USER}:${TARGET_GROUP}
sudo find ${DIST_DIR} -user ${USER} -type d -print | xargs sudo chown ${TARGET_USER}:${TARGET_GROUP}