.PHONY: all build push

all: build push

build:
	docker build . -t okamumu/rstudio-server-base

push:
	docker push okamumu/rstudio-server-base

clean:
	docker rmi okamumu/rstudio-server-base

server:
	docker run --rm -it -h hostname -p 8787:8787 \
		-e RS_USER=user \
		-e RS_UID=1000 \
		-e RS_PASSWORD=password \
		-e RS_GID=10000 \
		-t okamumu/rstudio-server-base
