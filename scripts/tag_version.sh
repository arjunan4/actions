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

tag=$(git describe --tags `git rev-list --tags --max-count=1`)
info "Git Tag ==> $tag"


IFS='.'
read -ra ADDR <<< "$tag"

info "Existing Tag version details => $tag" 
info "Git Tag is splitted by . and array length is ==> ${#ADDR[@]}"

if [ ${#ADDR[@]} = 3 ]; then
  current_major_ver=${ADDR[0]}
  current_minor_ver=${ADDR[1]}
  current_patch_ver=${ADDR[2]}
  if [[ ${ADDR[0]} == *"v"* ]];then
    current_major_ver=${ADDR[0]#"v"}
  fi
  info "Major => $current_major_ver ; Minor => $current_minor_ver ; Patch => $current_patch_ver"
  if [ $current_minor_ver = 9 ]; then
    new_minor_ver="0"
    new_patch_ver="0"
    let "new_major_ver=$current_major_ver+1"
  else
    let "new_minor_ver=$current_minor_ver + 1"
    new_patch_ver="0"
    new_major_ver="$current_major_ver" 
  fi
  new_tag_version="v$new_major_ver.$new_minor_ver.$new_patch_ver"
  new_tag_version=$new_tag_version | sed -e 's/^[[:space:]]*//'
  info "New Tag version details => $new_tag_version" 
  info "Major => $new_major_ver ; Minor => $new_minor_ver ; Patch => $new_patch_ver"
else
  info "Git tag format is NOT as expcted,hence exiting version script"
  exit 1
fi

info "New tag Version maping to Cur_Version $new_tag_version"

CUR_VERSION=$new_tag_version
if [ $? -eq 0 ]
then
  info "Version picked from repository file: $CUR_VERSION"
else
  error "version file not found"
  exit 1
fi

git tag | grep -q $CUR_VERSION
tag_exists=$?

info "Git tag exists is => $tag_exists"
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
