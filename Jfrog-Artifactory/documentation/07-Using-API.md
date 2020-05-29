[Retour menu principal](../README.md)

## 7. Using API

Using API in Jfrog can be very useful. Jfrog supply a list of several commands through its API. Here you can find related URLs :

- https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API
- https://www.jfrog.com/confluence/display/JFROG/Artifactory+REST+API+V2
- https://www.jfrog.com/confluence/display/JCR6X/JFrog+Container+Registry+REST+API

You can also use Jfrog CLI client. Documentation is available here :

- https://www.jfrog.com/confluence/display/CLI/JFrog+CLI
- https://www.jfrog.com/confluence/display/JFROG/Artifactory+Query+Language

JFrog Platform uses only 2 external ports: **8081** for Artifactory REST APIs, **8082** for everything else (UI, and all other product’s APIs).

To use the REST api, the command needs to be executed against the JFrog Platform Deployment (JDP) IP with port 8082 and then append the service context:

```
<JFrog Base URL>:<Router Port>/<Service Context>/api/<Version>
```

I.e:

http://SERVER_HOSTNAME:8082/xray/api/v2

For Artifactory API, use port 8081:

http://SERVER_HOSTNAME:8081/artifactory/api/repositories


Here are some useful commands :

**Check system version**
```
curl -u admin:password -X GET http://localhost:8081/artifactory/api/system/version
```

**Check existing repositories**
```
curl -u admin:password -X GET http://localhost:8081/artifactory/api/repositories
```

**Get ReverseProxy setup**
```
curl -u admin:password -X GET http://localhost:8081/artifactory/api/system/configuration/webServer
```

**Get ReverseProxy configuration**
```
curl -u admin:password -X GET http://localhost:8081/artifactory/api/system/configuration/reverseProxy/nginx
```

**Search for a particular artefact**
```
curl -u admin:password -X GET http://localhost:8081/artifactory/api/search/artifact?name=<NAME>
```

**Download artefact**
```
curl -u admin:password -O "http://localhost:8081/artifactory/<REPO>/<FILENAME>"
```

**Upload artefact**
```
curl -u admin:password -X PUT "http://localhost:8081/artifactory/<REPO>/<FILENAME>" -T <FILENAME>
```

### API with Reverse Proxy

If you are using a Reverse Proxy like NGINX, you can directly send requests to API through the Reverse Proxy by using its URL path.

**Proxy:** NGINX, **Protocol:** HTTPS, **Server redirecting port:** 3443, **NGINX listening port:** 443

```console
[root@workstation ~ ]$ curl -k -u admin:password -X GET https://localhost:3443/artifactory/api/system/configuration/webServer
{
  "key" : "nginx",
  "webServerType" : "NGINX",
  "artifactoryAppContext" : "artifactory",
  "publicAppContext" : "artifactory",
  "serverName" : "jfrog.example.com",
  "serverNameExpression" : "*.jfrog.example.com",
  "artifactoryServerName" : "artifactory",
  "artifactoryPort" : 8081,
  "routerPort" : 8082,
  "sslCertificate" : "/etc/nginx/ssl/example.crt",
  "sslKey" : "/etc/nginx/ssl/example.key",
  "dockerReverseProxyMethod" : "SUBDOMAIN",
  "useHttps" : true,
  "useHttp" : false,
  "httpsPort" : 443,
  "httpPort" : 80,
  "upStreamName" : "artifactory"
}
```

```console
[root@workstation ~ ]$ curl -k -u admin:password -X GET https://localhost:3443/artifactory/api/repositories
[ {
  "key" : "TESTREPO",
  "type" : "LOCAL",
  "url" : "https://localhost:443/artifactory/TESTREPO",
  "packageType" : "Generic"
}, {
  "key" : "example-repo-local",
  "description" : "Example artifactory repository",
  "type" : "LOCAL",
  "url" : "https://localhost:443/artifactory/example-repo-local",
  "packageType" : "Generic"
} ]
```

```console
[root@workstation ~ ]$ curl -k -u admin:password -X PUT https://localhost:3443/artifactory/TESTREPO/TestREADME.md -T /home/fred/Documents/TEST/README.md 
{
  "repo" : "TESTREPO",
  "path" : "/TestREADME.md",
  "created" : "2020-05-28T13:34:43.103Z",
  "createdBy" : "admin",
  "downloadUri" : "https://localhost:443/artifactory/TESTREPO/TestREADME.md",
  "mimeType" : "application/octet-stream",
  "size" : "642",
  "checksums" : {
    "sha1" : "5c5f1ba828ccae4b143613f4a7ebda96fcbc56f9",
    "md5" : "ab5f2821c833d1eafd7edf4dbc8efd1a",
    "sha256" : "4bd61bd66b9b767fc00818d96d1d4a0589a0c4882334f60ebe9d50ad02f636d7"
  },
  "originalChecksums" : {
    "sha256" : "4bd61bd66b9b767fc00818d96d1d4a0589a0c4882334f60ebe9d50ad02f636d7"
  },
  "uri" : "https://localhost:443/artifactory/TESTREPO/TestREADME.md"
}
```

```console
[root@workstation ~ ]$ curl -k -u admin:password -O "https://localhost:3443/artifactory/TESTREPO/TestREADME.md"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   642  100   642    0     0   4201      0 --:--:-- --:--:-- --:--:--  4223
```

---------------------------------------------------------------------------------------------------------------------------------

[Main menu](../README.md)
