##########
# Docker #
##########

# Run interactive bash in Docker
#
# Examples:
#
# Example #1:
#
#   $(call docker_sh)

define docker_sh
        docker build \
                --pull \
                --iidfile .manala/docker/.cache/sh.id \
                --file .manala/docker/Dockerfile.ci \
                .manala/docker \
        && docker run \
                --rm \
                --tty \
                --interactive \
                --mount type=bind,consistency=delegated,source=$(PWD),target=/srv \
                --mount type=bind,consistency=cached,source=$(HOME)/.ssh/id_rsa,target=/home/app/.ssh/id_rsa \
                --mount type=bind,consistency=cached,source=$(HOME)/.gitconfig,target=/home/app/.gitconfig \
                `cat .manala/docker/.cache/sh.id` \
                ssh-agent bash
endef
