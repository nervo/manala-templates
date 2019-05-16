###########
# Release #
###########

# Build and publish a release for a given environment target.
#
# @param $1 The environment target, eg production, preprod, staging
#
# Examples:
#
# Example #1: make a release for the production environment
#
#   $(call release,production)

define release
        docker build \
                --pull \
                --iidfile .manala/docker/.cache/release.$(1).id \
                --file .manala/docker/Dockerfile.ci \
                .manala/docker \
        && docker run \
                --rm \
                --tty \
                --interactive \
                --mount type=bind,consistency=delegated,source=$(shell pwd -P),target=/srv \
                --mount type=bind,consistency=cached,source=$(HOME)/.ssh/id_rsa,target=/home/app/.ssh/id_rsa \
                --mount type=bind,consistency=cached,source=$(HOME)/.gitconfig,target=/home/app/.gitconfig \
                `cat .manala/docker/.cache/release.$(1).id` \
                ssh-agent ansible-playbook .manala/ansible/release.yaml --inventory .manala/ansible/release.inventory.yaml --limit $(1)
endef
