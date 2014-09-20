#!/bin/bash
set -e
set -x
if [[ "$(uname -s)" == 'Darwin' ]]; then
    DARWIN=true
else
    DARWIN=false
fi

if [[ "$DARWIN" = true ]]; then
    brew install haxe
fi
else
    "export DISPLAY=:99.0"
    "sh -e /etc/init.d/xvfb start"
    sudo add-apt-repository ppa:eyecreate/haxe -y
    sudo apt-get update -y
    sudo apt-get install haxe -y
    mkdir -p ~/.haxe/lib
    mkdir -p bin
    echo ~/.haxe/lib | haxelib setup
    haxelib install munit || true
    haxelib install lime || true
    haxelib install box2d || true
    haxelib install nape || true
fi