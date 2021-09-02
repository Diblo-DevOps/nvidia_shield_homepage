#!/bin/sh
if [ -z "${dir}" ]; then
    dir=$(find . -path '*/vendor/bundle' -prune -false -o -type d -name '_site' | head -n 1 | sed -E "s/^\.\/?//g")
fi

if [ -z "${custom_word_list}" ]; then
    custom_word_list="ci_cd/custom_words.txt"
fi

echo "Setting variables :: dir: ${dir},  custom_word_list: ${custom_word_list}"

if [ ! -f /bin/aspell ]; then
    apt-get update && apt-get install aspell aspell-da
fi

aspell --encoding=utf-8 --lang=da create master "/usr/lib/aspell/custom.rws" < "${GITHUB_WORKSPACE}/${custom_word_list}"

cd "${GITHUB_WORKSPACE}/${dir}"

error=0
while read file; do
    echo "Validate ${file}"
    res=$(cat index.html | aspell -l da,en -H list)
    if [ -z "${res}" ]; then
        echo "OK"
    else
        echo "Unknown word(s) :: ${res}"
        error=1
    fi
done <<< "$(find . -path '*/vendor/bundle' -prune -false -o -type f -name '*.htm' -o -name '*.html')"

exit ${error}
