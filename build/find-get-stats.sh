#!/usr/bin/env bash

if [[ -z "$DIR" ]]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
fi

GITBASE="${DIR}/../.git"

repo=$(git config --get remote.origin.url)
version=$(cat VERSION)
commit=
branch=

branch_name="$(git --git-dir="${GITBASE}" symbolic-ref HEAD 2>/dev/null)" ||
branch_name="(unnamed branch)"
branch_name=${branch_name##refs/heads/}

if [ -e "${GITBASE}" ];
then
  commit="@$(git --git-dir=${GITBASE} rev-parse --short HEAD)"
fi

echo "${repo} v:${version} ${branch_name}${commit}"
