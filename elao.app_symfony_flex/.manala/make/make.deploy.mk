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
        docker build \
                --pull \
                --iidfile .manala/docker/.cache/deploy.$(1).id \
                --file .manala/docker/Dockerfile.ci \
                .manala/docker \
        && docker run \
                --rm \
                --tty \
                --mount type=bind,consistency=delegated,source=$(PWD),target=/srv \
                --mount type=bind,consistency=cached,source=$(HOME)/.ssh/id_rsa,target=/home/app/.ssh/id_rsa \
                --mount type=bind,consistency=cached,source=$(HOME)/.gitconfig,target=/home/app/.gitconfig \
                `cat .manala/docker/.cache/deploy.$(1).id` \
                ssh-agent ansible-playbook .manala/ansible/deploy.yaml --inventory .manala/ansible/deploy.inventory.yaml --limit $(1)
endef
