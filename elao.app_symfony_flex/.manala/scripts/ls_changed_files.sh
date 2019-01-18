#!/usr/bin/env bash

set -euo pipefail
IFS=$'\n\t'

declare    project_dir
project_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )/../.." && pwd )"
declare -a file_extensions=()
declare -a directories=()
declare    debug=false
declare    use_git=false

cd "$project_dir"

# parse this script option
function parse_opt
{
    while [[ "$#" -gt 0 ]]
    do
        declare key="$1"
        case "$key" in
            --ext)
                if [[ $# -eq 1 ]]
                then
                    >&2 printf '\n\n'
                    >&2 printf '\e[31m  [ERROR] option %s requires a value.\e[39m\n' "$key"
                    >&2 printf '\n\n'

                    exit 1
                fi

                file_extensions+=("$2")
                shift
            ;;
            --ext=*)
                file_extensions+=("${1#*=}")
            ;;
            --debug)
                debug=true
            ;;
            --*)
                >&2 printf '\n\n'
                >&2 printf '\e[31m  [ERROR] Unknown option %s.\e[39m\n' "$key"
                >&2 printf '\n\n'

                exit 1
            ;;
            *)
                if ! [[ -d "$1" ]] && ! [[ -f "$1" ]]
                then
                    >&2 printf '\n\n'
                    >&2 printf '\e[31m  [ERROR] File or directory %s does not exists.\e[39m\n' "$key"
                    >&2 printf '\n\n'

                    exit 1
                fi
                directories+=("$1")
            ;;
        esac
        shift
    done

    if [[ "${#file_extensions[@]}" -eq 0 ]]
    then
        >&2 printf '\n\n'
        >&2 printf '\e[31m  [ERROR] You need to specify at least one file extension.\e[39m\n'
        >&2 printf '\n\n'

        printf '\e[32m%s --ext=[FILE_EXTENSION] [DIRECTORY]\e[39m\n' "$0"

        exit 1
    fi

    if [[ "${#directories[@]}" -eq 0 ]]
    then
        directories+=("")
    fi
}

parse_opt "$@"

# not a git repository
if ! git rev-parse &>/dev/null
then
    ${debug} && >&2 printf '[WARN] not a git repository\n'
elif ! git rev-parse HEAD &>/dev/null
then
    ${debug} && >&2 printf '[WARN] git repository has no commit yet\n'
elif ! git rev-parse origin/master &>/dev/null
then
    ${debug} && >&2 printf '[WARN] git repository has no remote named origin\n'
else
    use_git=true
fi

for file_ext in "${file_extensions[@]}"
do
    for dir in "${directories[@]}"
    do
        ${debug} && >&2 printf '[DEBUG] file_ext: %s\n[DEBUG] dir: %s\n\n' "$file_ext" "$dir"
        if ${use_git}
        then
            git --no-pager diff --name-status "$(git merge-base HEAD origin/master)" |
                grep "${file_ext}\$" |
                grep "\\s${dir}" |
                grep -v '^D' |
                awk '{ print $NF }' || true
        else
            find "$dir" -name "*${file_ext}"
        fi
    done
done
