DOCKER_IMAGE := {{ .project }}
DOCKER_IMAGE := mjc/ats

## Build image
docker.build:
	docker build \
        --pull \
        --tag $(DOCKER_IMAGE) \
        --file .manala/docker/Dockerfile.ci \
        .

## Access to image sh
docker.sh:
	docker run \
        --rm \
        --tty --interactive \
        --mount type=bind,source=$(HOME)/.gitconfig,target=/home/app/.gitconfig \
        --mount type=bind,source=$(HOME)/.ssh/id_rsa,target=/home/app/.ssh/id_rsa \
        --mount type=bind,source=$(PWD),target=/srv \
        $(DOCKER_IMAGE) \
        bash

release@production:
	docker run \
        --rm \
        --tty \
        --mount type=bind,source=$(PWD),target=/srv \
        $(DOCKER_IMAGE) \
        ansible-playbook .manala/ansible/release.yaml --inventory .manala/ansible/release.inventory.yaml --limit production

release@staging:
	docker run \
        --rm \
        --tty \
        --mount type=bind,source=$(PWD),target=/srv \
        $(DOCKER_IMAGE) \
        ansible-playbook .manala/ansible/release.yaml --inventory .manala/ansible/release.inventory.yaml --limit staging
