[Retour menu principal](../README.md)

## 9. Backup
### Backup&Restore Ominbus Gitlab configuration
Il est recommandé de garder une copie de _**'/etc/gitlab'**_ ou au moins de _**'/etc/gitlab/gitlab-secrets.json'**_ dans un endroit sûr. En cas de restauration d'une application Gitlab, il faut aussi restaurer _**'gitlab-secrets.json'**_. Si vous ne le faites pas, les utilisateurs Gitlab utilisant un login 2FA perdront l'accès au serveur Gitlab et les **'secure variables'** stockées dans Gitlab CI seront perdues.

Il est recommandé de stocker le backup de vos configurations dans un autre endroit que le backup de votre application.

https://docs.gitlab.com/omnibus/settings/backups.html

Toutes les configurations pour Omnibus sont stockées dans _**'/etc/gitlab'**_. Pour backuper votre configuration, simplement exécuter la commande 
```bash
gitlab-ctl backup-etc
```
Une archive tar sera créée dans _**'/etc/gitlab/config_backup'**_. Le répertoire et les fichiers de backup seront lisible seulement pour root.

En exécutant:
```bash
gitla-ctl backup-etc <directory>
```
vos backups seront placés dans le dossier spécifié. Le dossier est créé si il n'existe pas. Un chemin absolu est nécessaire.

Pou créer un backup quotidien de l'application, éditer la cron table avec root:
```bash
sudo crontab -e -u root
```
Renseigner la commande pour créer un fichier tar contenant _**'/etc/gitlab'**_. Par exemple, planifier le backup tous les matin après un jour de la semaine (Mardi jour 2 jusque samedi jour 6):
```bash
15 04 * * 2-6  gitlab-ctl backup-etc && cd /etc/gitlab/config_backup && cp $(ls -t | head -n1) /secret/gitlab/backups/
```
Pour restaurer, suivre cette procédure:
```bash
# Renommer l'existant /etc/gitlab
sudo mv /etc/gitlab /etc/gitlab.$(date +%s)
sudo tar -xf gitlab_config_1487687824_2017_02_21.tar -C /
```
Penser à exécuter cette commande après la restauration d'une configuration backup:
```bash
 sudo gitlab-ctl reconfigure
```
Les SSh host keys de la machine sont stockées dans un répertoire différent _**'/etc/ssh'**_. Assurez-vous d'aussi restaurer ces clefs pour éviter des attaques de type man-in-the-middle.

### Backup applicatif
Pour créer un backup des repos et des metadatas Gitlab, suivre la documentation sur ce lien:

https://docs.gitlab.com/ee/raketasks/backup_restore.html#creating-a-backup-of-the-gitlab-system

Les backups seront stockés dans _**'/var/opt/gitlab/backups'**_.

Si vous souhaitez sstocker les backups Gitlab dans un répertoire différent, ajoutez le paramètre suivant à _**'/etc/gitlab/gitlab.rb'**_ et exécutez **sudo gitlab-ctl reconfigure**:
```bash
gitlab_rails['backup_path'] = '/mnt/backups'
```

-----------------------------------------------------------------------------------------------------------------------------------

[Retour menu principal](../README.md)

[Suivant](10-Installation-process.md)