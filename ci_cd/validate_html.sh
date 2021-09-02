#!/bin/sh
if [ -z "${dir}" ]; then
    dir=$(find . -path '*/vendor/bundle' -prune -false -o -type d -name '_site' | head -n 1 | sed -E "s/^\.\/?//g")
fi

echo "Setting variables :: dir: ${dir}"

if [ ! -f /bin/tidy ]; then
    sudo apt-get update && sudo apt-get install tidy || exit 1
fi

cd "${GITHUB_WORKSPACE}/${dir}"

error=0
while read file; do
    echo "Validate ${file}"
    tidy -errors -quiet "${file}"
    if [ "$?" == "0" ]; then
        echo "OK"
    else
        echo "ERROR"
        error=1
    fi
done <<< $(find . -path '*/vendor/bundle' -prune -false -o -type f -name '*.htm' -o -name '*.html')

exit ${error}
