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

git config --global user.name "arjunan4"
hello=$(git branch)
info "Git Branch ==> $hello"
# get latest tag
git fetch --all --tags
tag=$(git describe --tags `git rev-list --tags --max-count=1`)

info "Git Tag ==> $tag"

if [ -n "$tag" ]; then
    info "Git Tag exists for this repository ==> $tag"
else
    info "No Git Tag found for this repository"
    tag="0.0.0"
fi

#set the IFS value
OIFS=$IFS
IFS='.'
read -ra ADDR <<< "$tag"

info "Existing Tag version details => $tag" 
info "Git Tag is splitted by . and array length is ==> ${#ADDR[@]}"

if [ ${#ADDR[@]} = 3 ]; then
  current_major_ver=${ADDR[0]}
  current_minor_ver=${ADDR[1]}
  current_patch_ver=${ADDR[2]}
  if [[ ${ADDR[0]} == *"v"* ]]; then
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
  new_tag_version="$new_major_ver.$new_minor_ver.$new_patch_ver"
  info "New Tag version details => $new_tag_version" 
  info "Major => $new_major_ver ; Minor => $new_minor_ver ; Patch => $new_patch_ver"
else
  info "Git tag format is NOT as expcted,hence exiting version script"
  exit 1
fi

#unset the IFS value
IFS=$OIFS
new_tag_version="$new_major_ver.$new_minor_ver.$new_patch_ver"
info "bumping Git Tag to => ${new_tag_version} new version"

commit=$(git rev-parse HEAD)
info "commit message SHA => $commit"
# get repo name from git
remote=$(git config --get remote.origin.url)
repo=$(basename $remote .git)


github_repo_url="https://api.github.com/repos/$REPO_OWNER/$repo/git/refs"
info "Github Repo URL => $github_repo_url"

generate_post_data()
{
  cat <<EOF
{
  "ref": "refs/tags/$new_tag_version",
  "sha": "$commit"
}
EOF
}

hello=generate_post_data
info "Data Parameters => $(generate_post_data)"
info "First Attempt"
curl_post_response=$(curl -s -X POST $github_repo_url -H "Authorization: token $GITHUB_TOKEN" -d "$(generate_post_data)")

info "First Attempt Result $?"

info "Curl post response is => $curl_post_response"

ref=$(echo "$curl_post_response" | jq  -r '.ref')
info "Ref -> $ref"

sha=$(echo "$curl_post_response" | jq -r '.object.sha')
info "sha -> $sha"