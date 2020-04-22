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

CUR_VERSION="0.0.0"
if [ $? -eq 0 ]
then
  info "Version picked from repository file: $CUR_VERSION"
else
  error "version file not found"
  exit 1
fi

git tag | grep -q $CUR_VERSION
tag_exists=$?

if [ $tag_exists -eq 0 ]
then
  new_version=$(semvertag bump minor)
  info "Automatically updating version to: $new_version"
  git tag | grep $new_version

  set -e
  echo $new_version > version
  git add version
  git commit -q -m "Jenkins automated version update [skip ci]"
  git tag -a $new_version -m "Release"
  git push -q origin master
  git push -q --tags

  set +e

else
  new_version=${CUR_VERSION}
  info "New custom version: ${new_version}"
  
  set -e
  git tag -a $new_version -m "Release"
  git push -q origin master
  git push -q --tags
  set +e
fi

success "Version: $new_version for $MICROSERVICE tagged and pushed."
echo "${new_version}"
