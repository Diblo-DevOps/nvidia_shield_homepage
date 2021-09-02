#!/bin/sh
if [ -z "${dir}" ]; then
    dir=$(find . -path '*/vendor/bundle' -prune -false -o -type d -name '_site' | head -n 1 | sed -E "s/^\.\/?//g")
fi

echo "Setting variables :: dir: ${dir}"

if [ ! -f /bin/minify ]; then
    apt-get update && apt-get install minify
fi

cd "${GITHUB_WORKSPACE}/${dir}"

error=0
while read file; do
    echo "${file}"
    minify "${file}" |  sed -E "s/ 50% 100% no-repeat/ center right no-repeat/g" > "${file}.mini"
    if [ "$?" == "0" ]; then
        echo "OK"
        mv "${file}.mini" "${file}"
    else
        echo "ERROR"
        error=1
    fi
done <<< $(find . -path '*/vendor/bundle' -prune -false -o -type f -name '*.htm' -o -name '*.html')

exit ${error}
