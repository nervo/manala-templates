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
