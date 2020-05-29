[Main menu](../README.md)

## 3. Installation from Docker-Compose (Free version)

You can find Jfrog Artifactory packages for docker-compose on the following link :

- https://bintray.com/jfrog/artifactory

Documentation for installation is available here :

- https://www.jfrog.com/confluence/display/JFROG/Installing+Artifactory
- https://www.jfrog.com/confluence/display/JFROG/Installing+Artifactory#InstallingArtifactory-ProductConfiguration

Pick the desired package **jfrog-artifactory-<oss|cpp-ce|jcr>-<version>-compose.tar.gz**.

Untar the archive :

```shell
tar -xvf jfrog-artifactory-<pro|oss|cpp-ce>-<version>-compose.tar.gz
```

Notice the ```.env``` file provided in the extracted folder :

```diff
 artifactory-oss-7.2.1/
 ├── bin
 ├── config.sh
+├── .env
 ├── README.md
 ├── templates
 └── third-party
```

Create a **HOME** directory for your Jfrog Artifactory installation (ex: ```/home/user/Jfrog``` ) and create the following directory structure :

```console
var/
├── data
│   ├── nginx           - seulement en cas d'ajout de NGINX
│   └── postgres        - seulement en cas d'ajout de PostgreSQL
└── etc
```

Configure permissions like this (```chown -R 1030:1030 var/```, ```chown -R 104:107 var/data/nginx/```, ```chown -R 999:999 var/data/postgres/```):

```console
[1030:1030] var/
├── [1030:1030] data
│   ├── [104:107] nginx
│   └── [999:999] postgres
└── [1030:1030] etc
```

Once the directory structure created, choose a docker-compose template from the extracted folder **template** :

_P.S: NGINX option is actually not available for non PRO version._

```diff
 templates/
-├── docker-compose-nginx.yaml       --> Artifactory + NGINX
+├── docker-compose-postgres.yaml    --> Artifactory + PostgreSQL
+├── docker-compose.yaml             --> Artifactory + Derby (BDD intégrée)
 ├── system.basic-template.yaml
 └── system.full-template.yaml
```

Copy the template in the parent directory and rename it as ```docker-compose.yaml```.

```diff
artifactory-oss-7.2.1/
 ├── bin
 │   ├── dockerComposeHelper.sh
 │   ├── migrate.sh
 │   ├── migrationComposeInfo.yaml
 │   ├── systemDiagnostics.sh
 │   └── systemYamlHelper.sh
 ├── config.sh
+├── docker-compose.yaml                <-- docker-compose template renamed and copied in the parent directory
 ├── README.md
 ├── templates
!│   ├── docker-compose-nginx.yaml       <-- Choice 1
!│   ├── docker-compose-postgres.yaml    <-- Choice 2
!│   ├── docker-compose.yaml             <-- Choice 3
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

Update the ```.env``` file with the **HOME** path of your Jfrog installation (by default, it will automatically choose ```/root/.jfrog/artifactory```) :

```yml
ROOT_DATA_DIR=/root/.jfrog/artifactory
```

Launch the application :

```shell
docker-compose up -d
```

### HealthCheck

Healthchecks can be useful to monitor your containers. You can add HealthCheck to Artifactory and PostgreSQL docker-compose.
For Artifactory, just add these lines to the docker-compose.yaml file :

```yaml
healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:8081/artifactory/api/system/ping"]
      interval: 30s
      timeout: 5s
      retries: 5
```

You can obviously tweak values for interval, timeout and retries.

For PostgreSQL, just add these lines :

```yaml
healthcheck:
      test: ["CMD-SHELL", "pg_isready -U ${DB_USER}"]
      interval: 30s
      timeout: 5s
      retries: 5
```

You can verify healthcheck status with the following commands :

```
docker inspect --format "{{json .State.Health }}" <CONTAINER-NAME> | jq
docker inspect --format "{{json .State.Health }}" <CONTAINER-NAME> | jq '.Log[].Output'
```


---------------------------------------------------------------------------------------------------------------------------------

[Main menu](../README.md)

[Next](04-Installation-version-pro.md)
