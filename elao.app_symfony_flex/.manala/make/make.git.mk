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
	$(shell \
		for ext in $(if $(1),$(1),"") ; \
		do \
			for dir in $(if $(2),$(2),"") ; \
			do \
				git --no-pager diff --name-status "$$(git merge-base HEAD origin/master)" \
					| grep "$${ext}\$$" \
					| grep "\\s$${dir}" \
					| grep -v '^D' \
					| awk '{ print $$NF }' || true ; \
			done ; \
		done \
	)
endef
