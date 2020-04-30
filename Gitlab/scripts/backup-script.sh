#!/bin/bash

################################# VARIABLES ########################################
sourceAppDir=/home/fred/Documents/TEST/docker/gitlab/backup/app/
sourceSecretDir=/home/fred/Documents/TEST/docker/gitlab/backup/secret/
targetAppDir=/home/fred/Documents/TEST/docker/gitlab/archive/app/
targetSecretDir=/home/fred/Documents/TEST/docker/gitlab/archive/secret/
containerName=gitlab
retention="-mmin +60"
keepBackup=5
today=$(date +%d-%m-%Y)
#####################################################################################

################################# FUNCTIONS #########################################

# This function checks if the "$containerName" container is running
function check_DockerRun ()
{
  echo "[CHECKING] > $containerName container is running..."
  if [[ $(docker ps --filter name=$containerName --format '{{.Names}}') == $containerName ]]; then
    echo "[OK] >>> $containerName is running"
  else
    echo "[ERROR] >>> $containerName is NOT running"
    exit 1
  fi
}

# This function creates a gitlab backup for app & secrets in the directories specified by docker-compose.yml/gitlab.rb file
function create_gitlabFullBackup ()
{
  echo "[PROCESSING] > Creating APP DATA & SECRET DATA gitlab backup..."
  docker exec $containerName gitlab-backup
  docker exec $containerName /bin/sh -c 'umask 0077; tar cfz /secret/gitlab/backups/$(date "+etc-gitlab-\%s.tgz") -C / etc/gitlab'
  echo "> [DONE]"
}

# This function checks if an app backup tarball is found in gitlab app backup directory
function check_gitlabAppBackup ()
{
  echo "[CHECKING] > App backup file was created..."
  if [ -f $sourceAppDir*ee_gitlab_backup.tar ]; then
    echo "[OK] >>> gitlab app backup tarball found"
  else
    echo "[ERROR] >>> app backup tarball not found !!!"
    exit 1
  fi
}

# This function checks if a secret backup tarball is found in gitlab secret backup directory
function check_gitlabSecretBackup ()
{
  echo "[CHECKING] > Secret backup file was created..."
  if [ -f $sourceSecretDir"etc-gitlab*.tgz" ]; then
    echo "[OK] >>> gitlab secret backup tarball found"
  else
    echo "[ERROR] >>> secret backup tarball not found !!!"
    exit 1
  fi
}

function check_oneFile ()
{
  echo "[CHECKING] > Only 1 file in $1..."
  if [[ $(find $1 -maxdepth 1 -type f -print0 | xargs -0 -n1 basename | wc -l) -eq 1 ]]; then
    echo "[OK] >>> directory $1 owns only 1 backup file"
  else
    echo "[ERROR] >>> more than 1 backup file found in $1 !!!"
    exit 1
  fi
}

# This function checks if the given file has been created/modified today
function check_FileMatchToday ()
{
  backupTarball=$(find $1 -maxdepth 1 -type f -print0 | xargs -0 -n1 basename)
  echo "[CHECKING] > Backup file is timestamped today..."
  if [[ $(date -r $1$backupTarball +%d-%m-%Y) -eq $today ]]; then
    echo "[OK] >>> $backupTarball backup is timestamped today"
    return 0
  else
    echo "[WARNING] >>> $backupTarball file is not timestamped today"
    return 1
  fi
}

function move_backupsToDir ()
{
  echo "[PROCESSING] > Moving $1 tarball to $2 archive directory..."
  mv $1* $2
  echo "> [DONE]"
}

function set_permissions ()
{
  echo "[PROCESSING] > Setting proper permissions on $1 tarball files..."
  chown -R fred:fred $1*
  echo "> [DONE]"
}

function check_enoughBackup ()
{
  echo "[CHECKING] > Required number of backup files..."
  totalBackup=$(find $1* -maxdepth 1 -type f  2> /dev/null | wc -l)
  if [[ $totalBackup -gt $keepBackup ]]; then
    echo "[OK] >>> more than $keepBackup backup files found"
    deleteBackup=$((totalBackup-keepBackup))
    echo $deleteBackup
    return 0
  else
    echo "[WARNING] >>> not enough backup files found. Not deleting files."
    return 1
  fi
}

function delete_oldBackups()
{
  echo "[PROCESSING] > deleting old backups..."
  #find $1* -maxdepth 1 -type f $retention | sort -n | head -n $deleteBackup | xargs -d '\n' -tI "$" echo "$"
  find $1 -maxdepth 1 -type f $retention -exec ls -t "{}" + | head -n $deleteBackup | xargs  -d '\n' -tI "$" rm "$"
  #find $1* $retention | xargs -d '\n' -tI "$" rm "$"
  #totalBck=$(find $1* -maxdepth 1 -type f  2> /dev/null | wc -l)
  #ls -1 $1 | sort -r | tail -n +6 | xargs -tI "$" echo $1"$"
  echo "> [DONE]"
}

#####################################################################################

################################## PROGRAM ##########################################

echo "[STARTING] > SCRIPT IS EXECUTING $(date +%d-%m-%Y_%H:%M:%S)"

check_DockerRun
create_gitlabFullBackup
check_gitlabAppBackup

check_oneFile $sourceAppDir
if check_FileMatchToday $sourceAppDir; then
  move_backupsToDir $sourceAppDir $targetAppDir
  set_permissions $targetAppDir
else
  :
fi

check_oneFile $sourceSecretDir
if check_FileMatchToday $sourceSecretDir; then
  move_backupsToDir $sourceSecretDir $targetSecretDir
  set_permissions $targetSecretDir
else
  :
fi

if check_enoughBackup $targetAppDir; then
  delete_oldBackups $targetAppDir
else
  :
fi

if check_enoughBackup $targetSecretDir; then
  delete_oldBackups $targetSecretDir
else
  :
fi

echo "[ENDING] > SCRIPT IS ENDING SUCCESSFULLY $(date +%d-%m-%Y_%H:%M:%S)"

#####################################################################################



# echo "[CHECKING] > Gitlab container is running..."
# if [[ $(docker ps --filter name=$containerName --format '{{.Names}}') == $containerName ]]; then
#   echo "[OK] >>> gitlab is running"
#   echo "[PROCESSING] > Creating APP DATA gitlab backup..."
#   set -x
#   docker exec $containerName gitlab-backup
#   set +x
#   echo "> [DONE]"
#   echo "[PROCESSING] > Creating SECRETS DATA gitlab backup..."
#   set -x
#   docker exec $containerName /bin/sh -c 'umask 0077; tar cfz /secret/gitlab/backups/$(date "+etc-gitlab-\%s.tgz") -C / etc/gitlab'
#   set +x
#   echo "> [DONE]"
# else
#   echo "[ERROR] >>> gitlab is NOT running"
#   exit 1
# fi

# echo "[CHECKING] > Backup file was created..."
# if [ -f $sourceAppDir*ee_gitlab_backup.tar ]; then
#   echo "[OK] >>> gitlab backup tar file found"
 
 
#   echo "[CHECKING] > Backup file is timestamped today..."
#   if [[ $(find $sourceAppDir -maxdepth 1 -type f -print0 | xargs -0 -n1 basename | wc -l) -eq 1 ]]; then
#     backupTarball=$(find $sourceAppDir -maxdepth 1 -type f -print0 | xargs -0 -n1 basename)
    
#     if [[ $(date -r $sourceAppDir$backupTarball +%d-%m-%Y) -eq $today ]]; then
#       echo "[OK] >>> backup is timestamped today"
#       echo "[PROCESSING] > Moving files to archive directory..."
#       set -x
#       mv $sourceAppDir*.tar $targetAppDir
#       mv $sourceSecretDir*tgz $targetSecretDir
#       set +x
#       echo "> [DONE]"    
#     else
#       echo "[WARNING] >>> Backup file is not timestamped today"
#     fi
#   else
#     echo "[ERROR] >>> more than 1 backup APP file found !!!"
#     exit 1
#   fi
# else
#   echo "[ERROR] >>> backup file not found !!!"
#   exit 1
# fi

# echo "[PROCESSING] > Setting proper permissions on archive files..."
# set -x
# chown -R fred:fred $targetAppDir*
# chown -R fred:fred $targetSecretDir*
# set +x
# echo "> [DONE]"

# echo "[CHECKING] > Required number of backup files..."
# if [[ $(find $targetAppDir -maxdepth 1 -type f 2> /dev/null | wc -l) -gt 5 ]]; then
#   echo "[OK] >>> more than 5 backup files found"
#   echo "[PROCESSING] > deleting old backups..."
#   set -x
#   find $targetAppDir* $retention | xargs -d '\n' -tI "$" rm "$"
#   find $targetSecretDir* $retention | xargs -d '\n' -tI "$" rm "$"
#   set +x
#   echo "> [DONE]"
# else
#   echo "[WARNING] >>> not enough backup files found. Not deleting files."
# fi


# echo "[ENDING] > SCRIPT IS ENDING SUCCESSFULLY $(date +%d-%m-%Y_%H:%M:%S)"

# #####################################################################################
