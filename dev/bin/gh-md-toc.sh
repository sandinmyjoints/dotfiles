#!/usr/bin/env bash

#
# Steps:
#
#  1. Download corresponding html file for some README.md:
#       curl -s $1
#
#  2. Discard rows where no substring 'user-content-' (github's markup):
#       awk '/user-content-/ { ...
#
#  3. Get header level and insert corresponding number of spaces before '*':
#       sprintf("%*s", substr($NF, length($NF)-1, 1)*2, " ")
#
#  4. Find head's text and insert it inside "* [ ... ]":
#       substr($0, match($0, /a>.*<\/h/)+2, RLENGTH-5)
#
#  5. Find anchor and insert it inside "(...)":
#       substr($4, 7)
#

gh_toc_version="0.4.0"

gh_user_agent="gh-md-toc v$gh_toc_version"

#
# Download rendered into html README.md by its url.
#
#
gh_toc_load() {
    local gh_url=$1

    if type curl &>/dev/null; then
        curl --user-agent "$gh_user_agent" -s "$gh_url"
    elif type wget &>/dev/null; then
        wget --user-agent="$gh_user_agent" -qO- "$gh_url"
    else
        echo "Please, install 'curl' or 'wget' and try again."
        exit 1
    fi
}

# 
# Converts local md file into html by GitHub
#
# ➥ curl -X POST --data '{"text": "Hello world github/linguist#1 **cool**, and #1!"}' https://api.github.com/markdown
# <p>Hello world github/linguist#1 <strong>cool</strong>, and #1!</p>'"
gh_toc_md2html() {
    local gh_file_md=$1
    curl -s --user-agent "$gh_user_agent" \
        --data-binary @$gh_file_md -H "Content-Type:text/plain" \
        https://api.github.com/markdown/raw
}

#
# Is passed string url
#
gh_is_url() {
    if [[ $1 == https* || $1 == http* ]]; then
        echo "yes"
    else
        echo "no"
    fi
}

#
# TOC generator
#
gh_toc(){
    local gh_src=$1
    local gh_src_copy=$1
    local gh_ttl_docs=$2

    if [ "$gh_src" = "" ]; then
        echo "Please, enter URL or local path for a README.md"
        exit 1
    fi


    # Show "TOC" string only if working with one document
    if [ "$gh_ttl_docs" = "1" ]; then

        echo "Table of Contents"
        echo "================="
        echo ""
        gh_src_copy=""

    fi

    if [ "$(gh_is_url $gh_src)" == "yes" ]; then
        gh_toc_load "$gh_src" | gh_toc_grab "$gh_src_copy"
    else
        gh_toc_md2html "$gh_src" | gh_toc_grab "$gh_src_copy"
    fi
}

#
# Grabber of the TOC from rendered html
#
# $1 — a source url of document.
# It's need if TOC is generated for multiple documents.
#
gh_toc_grab() {
    awk -v "gh_url=$1" '/user-content-/ {
    print sprintf("%*s", substr($NF, length($NF)-1, 1)*2, " ") "* [" substr($0, match($0, /a>.*<\/h/)+2, RLENGTH-5)"](" gh_url substr($4, 7, length($4)-7) ")"}'
}

#
# Returns filename only from full path or url
#
gh_toc_get_filename() {
    echo "${1##*/}"
}

#
# Options hendlers
#
gh_toc_app() {
    local app_name="gh-md-toc"

    if [ "$1" = '--help' ]; then
        echo "GitHub TOC generator ($app_name): $gh_toc_version"
        echo ""
        echo "Usage:"
        echo "  $app_name src [src]     Create TOC for a README file (url or local path)"
        echo "  $app_name -             Create TOC for markdown from STDIN"
        echo "  $app_name --help        Show help"
        echo "  $app_name --version     Show help"
        return
    fi

    if [ "$1" = '--version' ]; then
        echo "$gh_toc_version"
        return
    fi

    if [ "$1" = "-" ]; then
        local gh_tmp_md=$(mktemp)
        while read input; do
            echo $input >> $gh_tmp_md
        done
        gh_toc_md2html "$gh_tmp_md" | gh_toc_grab ""
        return
    fi

    for md in "$@"
    do
        echo ""
        gh_toc "$md" "$#"
    done

    echo ""
    echo "Created by [gh-md-toc](https://github.com/ekalinin/github-markdown-toc)"
}

#
# Entry point
#
gh_toc_app "$@"
