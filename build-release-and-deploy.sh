#!/bin/sh

if ! [ -x "$(command -v elm)" ]; then
  echo "Please install elm first: npm -g install elm"
  exit -1
fi

if ! [ -x "$(command -v elm-test)" ]; then
  echo "Please install elm-test first: npm -g install elm-test"
  exit -1
fi

if ! [ -x "$(command -v uglifyjs)" ]; then
  echo "Please install uglify-js first: npm -g install uglify-js"
  exit -1
fi

if ! [ -x "$(command -v firebase)" ]; then
  echo "Please install firebase-tools first: npm -g install firebase-tools"
  exit -1
fi

if [[ `git status --porcelain` ]]; then
  echo "Your local version is different from the remote. Please commit/push/stash and try again."
  exit -1
fi

set -e

elm-test

mkdir -p build/js
js="build/js/meeting-price-counter.js"
min="build/js/meeting-price-counter.min.js"

elm make src/Main.elm --optimize --output $js
uglifyjs $js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output $min

echo "Copying resource/index.html to build folder"
cp resources/index.html build/index.html

echo "Compiled size:$(cat $js | wc -c) bytes  ($js)"
echo "Minified size:$(cat $min | wc -c) bytes  ($min)"
echo "Gzipped size: $(cat $min | gzip -c | wc -c) bytes"
echo "Files available at build folder."

echo "Deploying to firebase..."
firebase deploy
