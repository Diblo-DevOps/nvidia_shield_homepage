#!/bin/sh
if [ -z "${dir}" ]; then
    dir="."
fi

echo "Setting variables :: dir: ${dir}"

cd "${GITHUB_WORKSPACE}/${dir}"

error=0
while read file; do
    echo "Validate ${file}"
    ruby -ryaml -e "p YAML.load(STDIN.read)" < "${file}" > /dev/null
    if [ "$?" == "0" ]; then
        echo "OK"
    else
        echo "ERROR"
        error=1
    fi
done <<< "$(find . -path '*/vendor/bundle' -prune -false -o -type f -name '*.yml' -o -name '*.yaml')"

exit ${error}
