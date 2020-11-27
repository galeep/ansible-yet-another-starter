#!/bin/bash

# Uses the ansible-galaxy utility to update external Ansible roles.
# Works with privately hosted external roles in git repositories, too. 

COLOR_END='\e[0m'
COLOR_RED='\e[0;31m'

ANSIBLE_ROOT="$HOME/ansible"
ROLES_DIR_BASENAME="roles"
PATH_TO_ROLES="${ANSIBLE_ROOT}/${ROLES_DIR_BASENAME}"  
EXTERNAL_ROLES_DIR="${PATH_TO_ROLES}/external"
ROLES_REQUIREMENTS="${PATH_TO_ROLES}/roles_requirements.yml"
# Explicitly acquire the basename in case we change things
EXTERNAL_ROLES_DIR_BASENAME=$(basename "${EXTERNAL_ROLES_DIR}")
ANSIBLE_GALAXY_BIN=$(which ansible-galaxy)
THIS_CALLER=$(basename $0)
MYID=${THIS_CALLER%.*}
DEBUG_ME=0
DRY_RUN=0

# Exit msg
msg_exit() {
    printf "$COLOR_RED$@$COLOR_END"
    printf "\n"
    printf "Exiting...\n"
    exit 1
}

copy_dirs() {
    echo "Copying $1 to $2"
    _dirSrc="${1}"
    _dirDest="${2}"
    
    if [[ -d "${_dirSrc}" && -w "${_dirDest}" ]]; then
        echo "Copying ${_dirSrc} to ${_dirDest}"
        cp -r "${_dirSrc}" "${_dirDest}/"
    else
        echo "Could not copy ${_dirSrc} to ${_dirDest}"
        exit 1
    fi
}

# Trap if something bad happened, and try to bail gracefully
cleanitup() {
    # Move the partial update back into place
    if [[ -d "${TEMP_ROLES_DIR}" ]]; then 
	# Poor man's debug. Should test if DEBUG_ME
        echo "Cleaning up ${TEMP_ROLES_DIR} in two seconds..."
        sleep 2 
        rm -ri "${TEMP_ROLES_DIR}" 
   fi 
    _msg="$*"
    msg_exit "${_msg}"
}
trap "cleanitup"  ERR INT TERM

# Check ansible-galaxy
[[ ! -d "${ANSIBLE_ROOT}" || ! -r "${ANSIBLE_ROOT}/ansible.cfg" ]] && msg_exit \
  "Please set your personal ANSIBLE_ROOT or nothing will work."

[[ -z "${ANSIBLE_GALAXY_BIN}" ]] && msg_exit \
  "Ansible is not installed or not in your path."

# Check roles req file
[[ ! -f "${ROLES_REQUIREMENTS}" ]] && msg_exit \
  "roles_requirements file '${ROLES_REQUIREMENTS}' does not seem to exist, or is not readable."

# No roles to replace :-/ 
[[ ! -d "${EXTERNAL_ROLES_DIR}" ]] && msg_exit \
  "could not find an external roles directory at '${EXTERNAL_ROLES_DIR}'"

TEMP_ROLES_DIR=$(mktemp -q -d /tmp/${MYID}.XXXXXXXX)
if [ $? -ne 0 ]; then
    echo "$0: Can't create temp dir, exiting..."
    cleanitup
fi

# Pull down new roles in a temporary directory 

TEMP_ROLES_EXTDIR="${TEMP_ROLES_DIR}/${EXTERNAL_ROLES_DIR_BASENAME}"
mkdir ${TEMP_ROLES_EXTDIR}
POO="$?" 

if [[ "${POO}" != "0" ]]; then 
    # sigh
    rmdir ${TEMP_ROLES_DIR} 
    cleanitup "Something is rotten in tempdir..." 
fi

# copy_dirs "${EXTERNAL_ROLES_DIR}" "${TEMP_ROLES_EXTDIR}"
# if not being smart about extra work, no need to move these :-/ 

"${ANSIBLE_GALAXY_BIN}" install -r "${ROLES_REQUIREMENTS}" --force --no-deps -p "${TEMP_ROLES_EXTDIR}"
GALAXY_STATUS=$?

# Some very stupid roles install recursive symlinks. Delete these. 
# FIXME: Delete and warn. 
echo "Cleansing symbolic links from new roles..." 
find "${TEMP_ROLES_DIR}" -type l -print -delete

# Remove existing roles
if [[ "${GALAXY_STATUS}" == 0 ]]; then
  # construct a shiny new directory
  TSTAMP=$(/bin/date -u +'%Y%m%d-%H%M%SZ')
  OLD_ROLES_BACKUP_DEST="/tmp/${MYID}-backup-${EXTERNAL_ROLES_DIR_BASENAME}-${TSTAMP}"  
  echo "Backing up old roles..." 
  mv -v ${EXTERNAL_ROLES_DIR} ${OLD_ROLES_BACKUP_DEST}
  echo "Moving freshly updated roles into place..." 
  mv -v ${TEMP_ROLES_EXTDIR} ${EXTERNAL_ROLES_DIR}
  printf "\n\nOld roles backed up. If you wish:\n\n\trm -rf ${OLD_ROLES_BACKUP_DEST}\n\n"
  
  echo "Update complete." 

  else
  cleanitup "There was a problem with Galaxy. Your roles are at ${EXTERNAL_ROLES_DIR}." 
fi

exit 0
