IMAGE_NAME := lukin/code-server
IMAGE_TAG := $(shell date +%Y%m%d)

run:
	docker run -d --name code-server -p 127.0.0.1:4040:8080 \
		-v "$$HOME/.ssh:/home/coder/.ssh" \
		-v "$$HOME/.gitconfig:/home/coder/.gitconfig" \
  		-v "$$HOME/.config:/home/coder/.config" \
  		-v "$$HOME/projects:/home/coder" \
  		-u "$$(id -u):$$(id -g)" \
  		-e "DOCKER_USER=$$USER" \
  		$(IMAGE_NAME):latest

logs:
	docker logs -f --tail 100 code-server

stop:
	docker stop code-server
	docker rm code-server

upgrade: stop
	docker pull $(IMAGE_NAME):latest

restart: stop run

build:
	docker build --platform=linux/amd64 -t $(IMAGE_NAME):$(IMAGE_TAG) ./docker
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(IMAGE_NAME):latest

publish:
	docker push $(IMAGE_NAME):$(IMAGE_TAG)
	docker push $(IMAGE_NAME):latest

release: build publish
