# docker-chouette

```
docker build -t afimb/chouette2 .
```

```
docker create --link smtp -e SMTP_HOST=smtp -e TZ=Europe/Paris --publish=8080:8080 --publish=9990:9990 --publish=3000:3000 --publish=5432:5432 --volume $(pwd)/data/postgresql/:/var/lib/pgsql/9.3 -it --name=chouette2 afimb/chouette2
```

```
docker start chouette2
```
