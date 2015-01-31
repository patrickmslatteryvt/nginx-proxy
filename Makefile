USER = registry.mywebgrocer.com/mywebgrocer
IMAGE = nginx-reverse-proxy
TAG = 1.7.8
TIMEOUT = 60

all: build tag-latest run logs url
kill: stop rm

.PHONY: clean

clean:
	-@docker rmi $(USER)/$(IMAGE):$(TAG)
	-@docker rmi $(USER)/$(IMAGE):latest
	
cleanimages:
	-docker images -q --filter "dangling=true" | xargs docker rmi

build: Dockerfile
	@docker \
		build \
		--tag=$(USER)/$(IMAGE):$(TAG) .

tag-latest: 
	@docker \
		tag -f \
		$(USER)/$(IMAGE):$(TAG) $(USER)/$(IMAGE):latest

run:
	@docker \
		run \
		--detach \
		--hostname=$(IMAGE) \
		--name=$(IMAGE) \
		$(USER)/$(IMAGE):$(TAG)

logs:
	-@timeout $(TIMEOUT) docker logs -f $(IMAGE)

stop:
	@docker \
		stop $(IMAGE)

rm:
	@docker \
		rm $(IMAGE)

push:
	@docker \
		push \
		$(USER)/$(IMAGE)
