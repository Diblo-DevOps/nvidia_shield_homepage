#!/bin/sh
set -e # stop executing after error

if [ -z "${gem_dir}" ]; then
    gem_dir=$(find . -path '*/vendor/bundle' -prune -false -o -type f -name 'Gemfile' -exec dirname {} \; 2>&1 | head -n 1 | sed -E "s/^\.\/?//g")
fi

if [ -z "${dest_dir}" ]; then
    dest_dir="${gem_dir}/_site"
fi

if [ -z "${config_file}" ]; then
    config_file=$(find . -path '*/vendor/bundle' -prune -false -o -type f -name '_config.y*ml' | head -n 1 | sed -E "s/^\.\/?//g")
fi

if [ -z "${src_dir}" ]; then
    src_dir=$(dirname ${config_file})
fi

echo "Setting variables :: gem_dir: ${gem_dir}, dest_dir: ${dest_dir}, config_file: ${config_file}, src_dir: ${src_dir}"

cd "${GITHUB_WORKSPACE}/${gem_dir}"

bundle install
echo "Install done :: $?"

bundle exec jekyll build --trace --config "${GITHUB_WORKSPACE}/${config_file}" --source "${GITHUB_WORKSPACE}/${src_dir}" --destination "${GITHUB_WORKSPACE}/${dest_dir}"
echo "Build done :: $?"
