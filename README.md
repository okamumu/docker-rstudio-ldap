# docker-rstudio-base

A Docker container for Rstudio server.

This provides a container for Rstudio server.

## Installation

### Build a Docker image in your own PC

- Execute the following command in the directory that there exists Dockerfile.

```
docker build -t rstudio-server-base .
```

That's it.

### Download from DockerHub

```
docker pull okamumu/rstudio-server-base
```

## Usage

```
docker run --rm -it -h hostname -p 8787:8787 \
    -e RS_USER=username \
    -e RS_UID=1000 \
    -e RS_PASSWORD=mypassword \
    -e RS_GID=10000 \
    -t rstudio-server-base
```

Visit at `http://localhost:8787` and login
    - user: username
    - password: mypassword
