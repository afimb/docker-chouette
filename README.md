# docker-chouette

```
docker build -t afimb/docker-chouette .
```

```
docker run -d --link smtp -e SMTP_HOST=smtp -e TZ=Europe/Paris -p 3000:3000 -it --name docker-chouette afimb/docker-chouette
```

```
docker start docker-chouette
```
