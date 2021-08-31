#!/bin/sh
set -e # stop executing after error

if [ -z "${dir}" ]; then
    dir=$(find . -path '*/vendor/bundle' -prune -false -o -type d -name '_site' | head -n 1 | sed -E "s/^\.\/?//g")
fi

if [ -z "${branch}" ]; then
    branch="gh_pages"
fi

if [ -z "${token}" ]; then
    echo "Personal access token to github is required!"
    exit 1
fi

echo "Setting variables :: dir: ${dir}, branch: ${branch}, token: ${token}"

cd "${GITHUB_WORKSPACE}/${dir}"

touch .nojekyll # No need to have GitHub Pages to run Jekyll

git init -b main
git config user.name "${GITHUB_ACTOR}"
git config user.email "${GITHUB_ACTOR}@users.noreply.github.com"
git add .
git commit -m "jekyll build from Github Action ${GITHUB_SHA}"
git push --force "https://${GITHUB_ACTOR}:${token}@github.com/${GITHUB_REPOSITORY}.git" "main:${branch}"
