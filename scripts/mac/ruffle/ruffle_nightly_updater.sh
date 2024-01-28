#!/bin/bash

aoeDate=$(date -u -v-12H +"%Y-%m-%d")
downloadDateFormatted=$(date -u -v-12H +"%Y_%m_%d")
tempDownloadPath="/tmp/ruffle-download.tar.gz"
extractionPath="/tmp/ruffle-build"
ruffleURL="https://github.com/ruffle-rs/ruffle/releases/download/nightly-$aoeDate/ruffle-nightly-$downloadDateFormatted-macos-universal.tar.gz"

ensure_directory() {
    if [ ! -d "$1" ]; then
        mkdir -p "$1"
    fi
}

# Main script
{
    ensure_directory "$extractionPath"
    curl -L "$ruffleURL" -o "$tempDownloadPath"
    tar -xzf "$tempDownloadPath" -C "$extractionPath"
    mv "$extractionPath/Ruffle.app" /Applications/Ruffle.app
} || {
    echo "An error occurred."
    exit 1
}

if [ -f "$tempDownloadPath" ]; then
    rm "$tempDownloadPath"
fi

if [ -d "$extractionPath" ]; then
    rm -r "$extractionPath"
fi