# Couchbase
Couchbase latest community server pre-configured with single node cluster and a default bucket "todo". 


# Building
```sh
docker build -t chandanghosh/couchbase-configured .
```
Building with no-cache

```sh
docker build --rm --no-cache -t chandanghosh/couchbase-configured .
```

# Pulling the image

```sh
docker pull chandanghosh/couchbase-configured
```

# Running

## Run container
The below command run couchbase server with default username and password (Administrator/password) and default bucket "todo"
```sh
# Run container
docker run -it --name db \
  -p 8091-8094:8091-8094 \
  -p 11210:11210 \
  chandanghosh/couchbase-configured
```

To pass a different username, password and a bucket please use:

```sh
# Run container
docker run -it -d --name db \
  -e USERNAME=Admin \
  -e PASSWORD=admin@password \
  -e BUCKET=demo \
  -p 8091-8094:8091-8094 \
  -p 11210:11210 \
  chandanghosh/couchbase-configured
```

Cleanup resources

```sh
docker rm -f db
```