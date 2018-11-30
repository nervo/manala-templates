.PHONY: build

##########
# Manala #
##########

MANALA_MAKE_DIR := $(abspath $(patsubst %/Makefile,%,$(lastword $(MAKEFILE_LIST))))

include \
	$(MANALA_MAKE_DIR)/Makefile.manala \
	$(MANALA_MAKE_DIR)/Makefile.packer \
	$(MANALA_MAKE_DIR)/Makefile.debian \
	$(MANALA_MAKE_DIR)/Makefile.ansible \
	$(MANALA_MAKE_DIR)/Makefile.vagrant \
	$(MANALA_MAKE_DIR)/Makefile.docker

-include \
	$(MANALA_CURRENT_DIR)/../.env \
	$(MANALA_CURRENT_DIR)/.env

############
# Template #
############

TEMPLATE_DIR        := $(MANALA_CURRENT_DIR)
TEMPLATE_DIST_DIR    = $(TEMPLATE_DIR)/dist
TEMPLATE_CACHE_DIR   = $(TEMPLATE_DIR)/.cache
TEMPLATE_VAGRANT_BOX = $(TEMPLATE_DIST_DIR)/$(TEMPLATE)-$(TEMPLATE_VERSION)-$(PLATFORM_VARIANT).box

############
# Platform #
############

PLATFORM_VARIANT = $(call list_split_last,.,$(PLATFORM))

##########
# Packer #
##########

MANALA_PACKER_TEMPLATE := template.json
MANALA_PACKER_FORCE    := 1
MANALA_PACKER_ONLY      = $(PLATFORM)
MANALA_PACKER_VAR       = \
	template=$(TEMPLATE) \
	template_description=$(call escape_spaces,$(TEMPLATE_DESCRIPTION)) \
	template_version=$(TEMPLATE_VERSION) \
	template_author=$(call escape_spaces,$(MANALA_CONTACT)) \
	template_dist_dir=$(TEMPLATE_DIST_DIR) \
	manala_dir=$(MANALA_DIR) \
	platform_variant=$(PLATFORM_VARIANT) \
	builder_headless=$(if $(DEBUG),false,true)

export PACKER_CACHE_DIR = $(TEMPLATE_CACHE_DIR)/packer

###########
# Vagrant #
###########

MANALA_VAGRANT_FORCE := 1
MANALA_VAGRANT_BOX    = $(TEMPLATE_VAGRANT_BOX)

export VAGRANT_CWD          = $(TEMPLATE_DIR)/vagrant
export VAGRANT_DOTFILE_PATH = $(TEMPLATE_CACHE_DIR)/vagrant

##########
# Docker #
##########

MANALA_DOCKER_IMAGE     = manala/$(TEMPLATE)
MANALA_DOCKER_IMAGE_TAG = $(TEMPLATE_VERSION)
MANALA_DOCKER_MOUNT_DIR = $(if $(TEMPLATE_MOUNT_DIR),$(TEMPLATE_MOUNT_DIR),/srv/template)
MANALA_DOCKER_HOST      = $(TEMPLATE).$(PLATFORM)

#########
# Build #
#########

MANALA_HELP += $(BUILD_HELP)\n

BUILD_HELP = \
	$(call help_section,Build) \
	$(call help,build,                   Build template across platforms)

build:
	$(call list_loop,PLATFORM,$(if $(PLATFORMS),$(PLATFORMS),$(TEMPLATE_PLATFORMS)), \
		$$(call if_in,$$(PLATFORM),$$(TEMPLATE_PLATFORMS), \
			$$(call log,Build \"$$(TEMPLATE)\" for \"$$(PLATFORM)\") ; \
				$$(call packer_build), \
			$$(call log_warning,Build \"$$(TEMPLATE)\" for \"$$(PLATFORM)\" platform is not supported) \
		) \
	)

BUILD_HELP += $(call if_in,vagrant.virtualbox,$(TEMPLATE_PLATFORMS),$(call help,build.vagrant.virtualbox,Build template - Vagrant/VirtualBox))
build.vagrant.virtualbox: PLATFORMS = vagrant.virtualbox
build.vagrant.virtualbox: build

BUILD_HELP += $(call if_in,docker,$(TEMPLATE_PLATFORMS),$(call help,build.docker,            Build template - Docker))
build.docker: PLATFORMS = docker
build.docker: build

######
# Sh #
######

MANALA_HELP += $(SH_HELP)\n

SH_HELP = \
	$(call help_section,Template platform shell)

SH_HELP += $(call if_in,vagrant.virtualbox,$(TEMPLATE_PLATFORMS),$(call help,sh.vagrant.virtualbox,Open shell on template platform - Vagrant/VirtualBox))
sh.vagrant.virtualbox: PLATFORM = vagrant.virtualbox
sh.vagrant.virtualbox: MANALA_VAGRANT_BOX_NAME = $(TEMPLATE).$(call semver_major,$(TEMPLATE_VERSION))
sh.vagrant.virtualbox:
	$(call fail_if_not_in,$(PLATFORM),$(TEMPLATE_PLATFORMS),Sh for \"$(PLATFORM)\" platform is not supported)
	$(call log,Vagrant box add)
	$(call vagrant_box_add)
	$(call log,Vagrant up)
	-$(call vagrant_destroy)
	$(call vagrant_up)
	$(call log,Vagrant ssh)
	$(call vagrant_ssh)
	$(call vagrant_destroy)

SH_HELP += $(call if_in,docker,$(TEMPLATE_PLATFORMS),$(call help,sh.docker,            Open shell on template platform - Docker))
sh.docker: PLATFORM = docker
sh.docker:
	$(call fail_if_not_in,$(PLATFORM),$(TEMPLATE_PLATFORMS),Sh for \"$(PLATFORM)\" platform is not supported)
	$(call docker_run)

##########
# Deploy #
##########

MANALA_HELP += $(DEPLOY_HELP)

DEPLOY_HELP = \
	$(call help_section,Deploy)

DEPLOY_HELP += $(call if_in,vagrant.virtualbox,$(TEMPLATE_PLATFORMS),$(call help,deploy.vagrant.virtualbox,Deploy - Vagrant/VirtualBox))
deploy.vagrant.virtualbox: PLATFORM = vagrant.virtualbox
deploy.vagrant.virtualbox:
	$(call fail_if_not_in,$(PLATFORM),$(TEMPLATE_PLATFORMS),Deploy for \"$(PLATFORM)\" platform is not supported)
	$(call fail_if_not,$(DEPLOY_VAGRANT_HOST),DEPLOY_VAGRANT_HOST is empty or not set)
	scp $(TEMPLATE_VAGRANT_BOX) $(DEPLOY_VAGRANT_HOST)

DEPLOY_HELP += $(call if_in,docker,$(TEMPLATE_PLATFORMS),$(call help,deploy.docker,            Deploy - Docker))
deploy.docker: PLATFORM = docker
deploy.docker:
	$(call fail_if_not_in,$(PLATFORM),$(TEMPLATE_PLATFORMS),Deploy for \"$(PLATFORM)\" platform is not supported)
	$(call docker_push,$(MANALA_DOCKER_IMAGE):$(TEMPLATE_VERSION))
	$(call docker_push,$(MANALA_DOCKER_IMAGE):$(call semver_major_minor,$(TEMPLATE_VERSION)))
	$(call docker_push,$(MANALA_DOCKER_IMAGE):$(call semver_major,$(TEMPLATE_VERSION)))
	$(if $(TEMPLATE_VERSION_LATEST),$(call docker_push,$(MANALA_DOCKER_IMAGE):latest))
