#!/bin/sh

# ========================================
# Rsync command shell
#   with ssh connection and pem file
#
# [FEATURES]
# - Dry run mode
# - local to remote sync
# - remote to local sync
# - check conflict file
#
# [RESTRICTIONS]
# - necessary to disable requiretty setting
#   sudo vim /etc/sudoers
#   >>Defaults    requiretty
#   <<#Defaults    requiretty
#  
# [USAGES]
# - Dryun mode      : sh /path/to/XXXXX_rsync.sh -d -t local
# - Local to remote : sh /path/to/XXXXX_rsync.sh -t local
# - Remote to local : sh /path/to/XXXXX_rsync.sh -t remote
# - Check Conflict  : sh /path/to/XXXXX_rsync.sh -c -t remote
# ========================================

SSH_LOGIN_USER="XXXXXXXXXX"
SSH_HOST="XXXXXXXXXX"

usage_exit() {
  echo "INVALID ARGUMENTS"
  exit 1
}

while getopts dct: OPT
do
  case $OPT in
    d)  FLAG_DRYRUN=TRUE;
        DRY_RUN=--dry-run;
        ;;
    c)  FLAG_CONFLICT_CHECK=TRUE;
        ;;
    t)  FLAG_TARGET=TRUE;
        TARGET="$OPTARG";
        ;;
    \?) usage_exit
        ;;
    esac
done

if [ "${FLAG_TARGET}" = "TRUE" ]; then

  if [ "${TARGET}" = "local" ]; then
    FLAG_LOCAL2REMOTE="TRUE";
    FROM_DIR="/path/to/local/directory/"
    TO_DIR="${SSH_LOGIN_USER}@${SSH_HOST}:/path/to/remote/directory/"
  elif [[ "${TARGET}" = "remote" ]]; then
    FLAG_REMOTE2LOCAL="TRUE";
    FROM_DIR="${SSH_LOGIN_USER}@${SSH_HOST}:/path/to/remote/directory/"
    TO_DIR="/path/to/local/directory/"
  else
    usage_exit
  fi

fi

PEM_FILE="/path/to/file.pem"
IGNORE_FILE="/path/to/XXXXX_rsync_ignore"

if [ "${FLAG_CONFLICT_CHECK}" = "TRUE" ]; then
  echo "----- CONFLICT CHECKING( from ${TARGET} )"
  CONFLICT_CHECK_LIST=`rsync -zcrlD --log-format='%f' --dry-run --update --checksum --rsync-path="sudo rsync" --delete --exclude-from=${IGNORE_FILE} -e "ssh -i ${PEM_FILE}" ${TO_DIR} ${FROM_DIR}`
  if [ -z "${CONFLICT_CHECK_LIST}" ]; then
    echo "INFO: Conflict files not exist."
  else
    echo "INFO: Conflict files exist in '${TO_DIR}'"
    echo "${CONFLICT_CHECK_LIST}"
    echo "END(NG)"
    echo ""
    exit
  fi
fi

echo "----- RSYNC START( from ${TARGET} ):" `date` ": ${DRY_RUN}"
rsync -zvcrlD ${DRY_RUN} --update --checksum --rsync-path="sudo rsync" --delete --exclude-from=${IGNORE_FILE} -e "ssh -i ${PEM_FILE}" ${FROM_DIR} ${TO_DIR}

echo "END(OK)"
echo ""
