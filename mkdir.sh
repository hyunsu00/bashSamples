#!/usr/bin/env bash

documents_path="$HOME/documents"
if [ ! -d "$documents_path" ]; then
    echo "directory \"$documents_path\" is not exists"
    mkdir -p "$documents_path"
else
    echo "directory \"$documents_path\" is exists"
fi
