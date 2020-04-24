[Retour menu principal](../README.md)

## 4. Installation via Docker-Compose (version Pro)

Vous trouverez les packages JFrog Artifactory pour docker-compose sur le lien suivant:

- https://bintray.com/jfrog/artifactory-pro

La documentation pour l'installation est disponible sur les liens suivants:

- https://www.jfrog.com/confluence/display/JFROG/Installing+Artifactory
- https://www.jfrog.com/confluence/display/JFROG/Installing+Artifactory#InstallingArtifactory-ProductConfiguration

L'installation pour la version **PRO** ne diffère par de celle de la version **Free**. Suivez la même procédure que pour la version Free, mais vous pouvez en plus ajouter un serveur NGINX qui fera office de Reverse Proxy dans cette version PRO:

![](../pictures/jfrog-reverse-proxy.png)

pour obtenir à la fois le reverse proxy NGINX et la BDD PostgreSQL, il est possible de combiner les deux fichiers docker-compose du répertoire template du dossier décompressé:

```diff
 artifactory-pro-7.2.1/
 ├── bin
 │   ├── dockerComposeHelper.sh
 │   ├── migrate.sh
 │   ├── migrationComposeInfo.yaml
 │   ├── systemDiagnostics.sh
 │   └── systemYamlHelper.sh
 ├── config.sh
+├── docker-compose.yaml 
 ├── .env
 ├── README.md
 ├── templates
-│   ├── docker-compose-nginx.yaml
-│   ├── docker-compose-postgres.yaml
 │   ├── docker-compose.yaml
 │   ├── system.basic-template.yaml
 │   └── system.full-template.yaml
 └── third-party
     ├── logrotate
     └── yq
```
Le fichier est disponible ici : [fichier docker-compose.yaml (combinaison Postegre et NGINX)](../ressources/docker-compose.yaml)

Penser à mettre à jour le fichier ```.env``` en renseignant le chemin du dossier **HOME** de JFrog (par défaut ```/root/.jfrog/artifactory```):

```yml
ROOT_DATA_DIR=/root/.jfrog/artifactory
```

Vous pouvez également télécharger le fichier ```.env``` que je fournis et remplacer celui d'origine [fichier .env (modifié)](../ressources/.env)

Et enfin lancer le fichier docker-compose:

```shell
docker-compose up -d
```

Le dossier NGINX se compose comme ceci:

```console
nginx/
├── conf.d
│   └── artifactory.conf
├── logs
│   ├── access.log
│   └── error.log
└── ssl
    ├── example.crt
    └── example.key
```

Un certificat et une clef sont créés par défaut mais vous pouvez remplacer avec celui que vous utilisez. La configuration peut être modifiez via ```artifactory.conf```.

---------------------------------------------------------------------------------------------------------------------------------

[Retour menu principal](../README.md)

[Suivant](05-LDAP-settings.md)
