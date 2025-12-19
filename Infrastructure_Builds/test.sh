#!/usr/bin/env bash

remote_url=($(git remote -v))
remote_url=${remote_url[1]}
echo $remote_url

if [[ $remote_url == "git@github.com"* ]]; then
    echo "good$remote_url"
else
    echo 'bad$remote_url'
fi
