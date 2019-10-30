##########
# Deploy #
##########

# Deploy a release to a given environment target.
#
# @param $1 The environment target, eg production, preprod, staging
#
# Examples:
#
# Example #1: deploy to the production environment
#
#   $(call deploy,production)

define deploy
        ID=.manala/docker/.cache/deploy.$(1).id \
        && mkdir -p `dirname $${ID}` \
        && docker build \
                --pull \
                --iidfile $${ID} \
                --file .manala/docker/Dockerfile.ci \
                .manala/docker \
        && docker run \
                --rm \
                --tty \
                --interactive \
                --mount type=bind,consistency=delegated,source=$(shell pwd -P),target=/srv \
                --mount type=bind,consistency=cached,source=$(HOME)/.ssh/id_rsa,target=/home/app/.ssh/id_rsa \
                --mount type=bind,consistency=cached,source=$(HOME)/.gitconfig,target=/home/app/.gitconfig \
                `cat $${ID}` \
                ssh-agent ansible-playbook .manala/ansible/deploy.yaml --inventory .manala/ansible/deploy.inventory.yaml --limit $(1)
endef
