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

if [ $tag -eq 0] then
    info "No Git Tag found for this repository"
else
    info "Git Tag exists for this repository"
fi