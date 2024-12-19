REGISTRY      = thucon/avr-gcc
VERSION       = 1.1

.PHONY: clean all

###################
# STANDARD COMMANDS
###################
all: build

build:
	docker build --target final -t $(REGISTRY):ubuntu -f ${VERSION}/Dockerfile.ubuntu .
	docker build --target final -t $(REGISTRY):arch -f ${VERSION}/Dockerfile.arch .
	docker build --target final -t $(REGISTRY):alpine -f ${VERSION}/Dockerfile.alpine .

clean:
	docker rmi -f $(REGISTRY):ubuntu $(REGISTRY):$(VERSION)-ubuntu
	docker rmi -f $(REGISTRY):arch $(REGISTRY):$(VERSION)-arch
	docker rmi -f $(REGISTRY):alpine $(REGISTRY):$(VERSION)-alpine

push:
	docker image tag $(REGISTRY):ubuntu $(REGISTRY):$(VERSION)-ubuntu
	docker image tag $(REGISTRY):arch $(REGISTRY):$(VERSION)-arch
	docker image tag $(REGISTRY):alpine $(REGISTRY):$(VERSION)-alpine
	docker image tag $(REGISTRY):arch $(REGISTRY):latest
	docker image push --all-tags $(REGISTRY)

