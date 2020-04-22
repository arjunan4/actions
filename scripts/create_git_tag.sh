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
tag=$(git describe --tags `git rev-list --tags --max-count=1`)

echo "$tag"

info "Git Latest Tag is ==> $tag"
