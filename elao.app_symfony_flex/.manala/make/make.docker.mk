##########
# Docker #
##########

# Run docker container.
#
# Examples:
#
# Example #1:
#
#   $(call docker_run)
#
# Example #2:
#
#   $(call docker_run, whoami)

define docker_run
	ID=$$( \
		docker build \
			--quiet \
			--file .manala/docker/Dockerfile \
			.manala/docker \
	) \
	&& mkdir -p $(PWD)/.manala/.cache \
	&& docker run \
		--rm \
		--tty \
		--interactive \
		--mount type=bind,consistency=delegated,source=$(PWD),target=/srv/app \
		--mount type=bind,consistency=delegated,source=$(PWD)/.manala/.cache,target=/srv/.cache \
		--mount type=bind,consistency=cached,source=$(HOME)/.ssh/id_rsa,target=/home/app/.ssh/id_rsa \
		--mount type=bind,consistency=cached,source=$(HOME)/.gitconfig,target=/home/app/.gitconfig \
		$${ID} \
		ssh-agent \
			$(if $(1),$(strip $(1)),bash)
endef

ifneq ($(container),docker)
DOCKER_SHELL = $(call docker_run,$(SHELL))
endif
