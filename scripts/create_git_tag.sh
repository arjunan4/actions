#!/bin/bash

function success {
  echo -e "\033[1;32m$1\033[m" >&2
}

function info {
  echo -e "\033[1;36m$1\033[m" >&2
}

function error {
  echo -e "\033[1;31m$1\033[m" >&2
}


# get latest tag
git fetch --all --tags
tag=$(git describe --tags `git rev-list --tags --max-count=1`)
info "Git Latest Tag is ==> $tag"

if [ -z "$tag" ]
then
    log=$(git log --pretty=oneline)
    tag=0.0.0
else
    log=$(git log $t..HEAD --pretty=oneline)
fi

info "Git Tag exists for this repository ==> $tag"
info "Git Log this repository ==> $log"

if [ -n $tag ]; then
    info "Git Tag exists for this repository ==> $tag"
    new_version=$(semver bump minor $tag)
    info "New Git Tag is ==>  $new_version"
else
    info "No Git Tag found for this repository"
fi

case "$log" in
    *#major* ) new=$(semver bump major $tag);;
    *#patch* ) new=$(semver bump patch $tag);;
    * ) new=$(semver bump minor $tag);;
esac

info "After case statement ==> $tag"