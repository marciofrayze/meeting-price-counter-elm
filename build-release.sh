#!/bin/sh

if ! [ -x "$(command -v elm)" ]; then
  echo "Please install elm first: npm -g install elm"
fi

if ! [ -x "$(command -v elm-test)" ]; then
  echo "Please install elm-test first: npm -g install elm-test"
fi

if ! [ -x "$(command -v uglifyjs)" ]; then
  echo "Please install uglify-js first: npm -g install uglify-js"
fi

set -e

elm-test

mkdir -p build
js="build/meeting-price-counter.js"
min="build/meeting-price-counter.min.js"

elm make src/Main.elm --optimize --output $js
uglifyjs $js --compress 'pure_funcs="F2,F3,F4,F5,F6,F7,F8,F9,A2,A3,A4,A5,A6,A7,A8,A9",pure_getters,keep_fargs=false,unsafe_comps,unsafe' | uglifyjs --mangle --output $min

echo "Compiled size:$(cat $js | wc -c) bytes  ($js)"
echo "Minified size:$(cat $min | wc -c) bytes  ($min)"
echo "Gzipped size: $(cat $min | gzip -c | wc -c) bytes"
echo "Files available at build folder."
