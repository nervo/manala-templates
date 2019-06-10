########
# Diff #
########

# Returns the list of changed files for a given extension and some given folders.
#
# @param $1 The file extension of changed files
# @param $2 The relative folders to parse for changed files
#
# Examples:
#
# Example #1: list PHP files changed in the src and test folders
#
#   $(call git_diff,php,src test)

define git_diff
    $(shell .manala/scripts/ls_changed_files.sh --ext=.$(1) $(2))
endef
