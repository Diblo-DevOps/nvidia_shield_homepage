#!/bin/sh
if [ -z "${dir}" ]; then
    dir=$(find . -path '*/vendor/bundle' -prune -false -o -type d -name '_site' | head -n 1 | sed -E "s/^\.\/?//g")
fi

echo "Setting variables :: dir: ${dir}"

if [ ! -f /bin/tidy ]; then
    apt-get update && apt-get install tidy
fi

cd "${GITHUB_WORKSPACE}/${dir}"

error=0
while read file; do
    echo "${file}"
    tidy -indent --indent-spaces 2 -quiet --tidy-mark no -wrap 0 "${file}" > "${file}.full"
    if [ "$?" == "0" ]; then
        echo "OK"
        mv "${file}.full" "${file}"
    else
        echo "ERROR"
        error=1
    fi
done <<< $(find . -path '*/vendor/bundle' -prune -false -o -type f -name '*.htm' -o -name '*.html')

exit ${error}
