release@production:
	docker run \
        --rm \
        --tty \
        --mount type=bind,source=$(PWD),target=/srv \
        --mount type=bind,source=$(HOME)/.ssh/id_rsa,target=/home/app/.ssh/id_rsa \
        --mount type=bind,source=$(HOME)/.gitconfig,target=/home/app/.gitconfig \
        $(DOCKER_IMAGE) \
        ansible-playbook .manala/ansible/release.yaml --inventory .manala/ansible/release.inventory.yaml --limit production

release@staging:
	docker run \
        --rm \
        --tty \
        --mount type=bind,source=$(PWD),target=/srv \
        --mount type=bind,source=$(HOME)/.ssh/id_rsa,target=/home/app/.ssh/id_rsa \
        --mount type=bind,source=$(HOME)/.gitconfig,target=/home/app/.gitconfig \
        $(DOCKER_IMAGE) \
        ansible-playbook .manala/ansible/release.yaml --inventory .manala/ansible/release.inventory.yaml --limit staging
