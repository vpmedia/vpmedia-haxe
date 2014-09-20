#!/bin/bash
set -e
set -x
if [[ "$(uname -s)" == 'Darwin' ]]; then
	DARWIN=true
else
	DARWIN=false
fi

if [[ "$DARWIN" = true ]]; then
	brew update
	brew install haxe
	brew install caskroom/cask/brew-cask
	brew cask install flash-player-debugger
	export FLASHPLAYER_DEBUGGER="$HOME/Applications/Flash Player Debugger.app/Contents/MacOS/Flash Player Debugger"
	export FLASH_PLAYER_EXE="$HOME/Applications/Flash Player Debugger.app/Contents/MacOS/Flash Player Debugger"
else
	export DISPLAY=:99.0
	sh -e /etc/init.d/xvfb start
	sudo add-apt-repository ppa:eyecreate/haxe -y
	sudo apt-get update -y
	sudo apt-get install haxe -y
fi

mkdir -p ~/.haxe/lib
mkdir -p bin
echo ~/.haxe/lib | haxelib setup
haxelib install munit || true
haxelib install lime || true
haxelib install box2d || true
haxelib install nape || true