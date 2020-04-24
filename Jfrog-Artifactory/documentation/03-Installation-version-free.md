[Retour menu principal](../README.md)

## 3. Installation via Docker-Compose (Free version)

Vous trouverez les packages JFrog Artifactory pour docker-compose sur le lien suivant:

- https://bintray.com/jfrog/artifactory

La documentation pour l'installation est disponible sur les liens suivants:

- https://www.jfrog.com/confluence/display/JFROG/Installing+Artifactory
- https://www.jfrog.com/confluence/display/JFROG/Installing+Artifactory#InstallingArtifactory-ProductConfiguration


Choisissez le package **jfrog-artifactory-<oss|cpp-ce|jcr>-<version>-compose.tar.gz** de votre choix.

Décompressez l'archive:

```shell
tar -xvf jfrog-artifactory-<pro|oss|cpp-ce>-<version>-compose.tar.gz
```

Notez le fichier ```.env``` fournit dans le dossier extrait (contient des variables pour le docker-compose):

```diff
 artifactory-oss-7.2.1/
 ├── bin
 ├── config.sh
+├── .env
 ├── README.md
 ├── templates
 └── third-party
```

Créer un dossier **HOME** pour JFrog Artifactory (ex: ```/home/user/Jfrog``` )et créer la structure de dossier suivante:

```console
var/
├── data
│   ├── nginx           - seulement en cas d'ajout de NGINX
│   └── postgres        - seulement en cas d'ajout de PostgreSQL
└── etc
```

Au niveau des permissions, configurer comme ceci:

```console
[1030:1030] var/
├── [1030:1030] data
│   ├── [104:107] nginx
│   └── [999:999] postgres
└── [1030:1030] etc
```

une fois la structure de dossiers créée, choisir un template docker-compose situé dans le dossier décompréssé répertoire **template**.

_P.S: L'image NGINX est indisponible en version non PRO._

```diff
 templates/
+├── docker-compose-nginx.yaml       --> Artifactory + NGINX
+├── docker-compose-postgres.yaml    --> Artifactory + PostgreSQL
+├── docker-compose.yaml             --> Artifactory + Derby (BDD intégrée)
 ├── system.basic-template.yaml
 └── system.full-template.yaml
```

Copier le template docker-compose dans le répertoire decompressé (normalement répertoire parent) et renommer en ```docker-compose.yaml```.

```diff
artifactory-oss-7.2.1/
 ├── bin
 │   ├── dockerComposeHelper.sh
 │   ├── migrate.sh
 │   ├── migrationComposeInfo.yaml
 │   ├── systemDiagnostics.sh
 │   └── systemYamlHelper.sh
 ├── config.sh
+├── docker-compose.yaml                <-- Template docker-compose renommé et copié dans la dossier décompressé
 ├── README.md
 ├── templates
!│   ├── docker-compose-nginx.yaml       <-- choix 1
!│   ├── docker-compose-postgres.yaml    <-- choix 2
!│   ├── docker-compose.yaml             <-- choix 3
 │   ├── system.basic-template.yaml
 │   └── system.full-template.yaml
 └── third-party
     ├── logrotate
     │   └── logrotate
     └── yq
         ├── LICENSE
         ├── yq_darwin
         └── yq_linux
```

Mettre à jour le fichier ```.env``` en renseignant le chemin du dossier **HOME** de JFrog préalablement créé (par défaut ```/root/.jfrog/artifactory```):

```yml
ROOT_DATA_DIR=/root/.jfrog/artifactory
```

Il ne reste plus qu'à lancer l'application:

```shell
docker-compose up -d
```

---------------------------------------------------------------------------------------------------------------------------------

[Retour menu principal](../README.md)

[Suivant](04-Installation-version-pro.md)
