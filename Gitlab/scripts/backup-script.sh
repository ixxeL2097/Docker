#!/bin/bash

sourceAppDir=/home/fred/Documents/TEST/docker/gitlab/backup/app/
sourceSecretDir=/home/fred/Documents/TEST/docker/gitlab/backup/secret/
targetAppDir=/home/fred/Documents/TEST/docker/gitlab/archive/app/
targetSecretDir=/home/fred/Documents/TEST/docker/gitlab/archive/secret/

echo "PROCESSING > Creating DATA gitlab backup..."
set -x
docker exec gitlab gitlab-backup
set +x
echo "FINISHED >"

echo "PROCESSING > Creating SECRETS gitlab backup..."
set -x
#docker exec gitlab /bin/sh -c 'umask 0077; tar cfz /secret/gitlab/backups/$(date "+etc-gitlab-\%F-%H:%M:%S.tgz") -C / etc/gitlab'
docker exec gitlab /bin/sh -c 'umask 0077; tar cfz /secret/gitlab/backups/$(date "+etc-gitlab-\%s.tgz") -C / etc/gitlab'
set +x
echo "FINISHED >"

echo "PROCESSING > Moving files to archive directory..."
set -x
mv $sourceAppDir*.tar $targetAppDir
mv $sourceSecretDir*tgz $targetSecretDir
set +x
echo "FINISHED >"

echo "PROCESSING > Setting proper permissions on archive files..."
set -x
chown -R fred:fred $targetAppDir*
chown -R fred:fred $targetSecretDir*
set +x
echo "FINISHED >"

echo "PROCESSING > deleting old backups..."
set -x
#ls -1 $targetAppDir | sort -r | tail -n +6 | xargs -d '\n' -tI "$" rm $targetAppDir"$"
#ls -1 $targetSecretDir | sort -r | tail -n +6 | xargs -d '\n' -tI "$" rm $targetSecretDir"$"
find $targetAppDir* -mmin +5 | xargs -d '\n' -tI "$" rm "$"
find $targetSecretDir* -mmin +5 | xargs -d '\n' -tI "$" rm "$"
set +x
echo "FINISHED >"
