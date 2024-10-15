DOCKER_FILE   = Dockerfile
REGISTRY      = thucon/avr-gcc

.PHONY: clean all

###################
# STANDARD COMMANDS
###################
all: build

build:
	docker build --no-cache -t $(REGISTRY) -f $(DOCKER_FILE) .

clean:
	docker rmi -f $(REGISTRY)

push:
	docker push $(REGISTRY)

run:
	docker run -it --rm $(REGISTRY) bash

logs:
	docker logs $(CONTAINER_NAME) -f

