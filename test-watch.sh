if ! [ -x "$(command -v elm)" ]; then
  echo "Please install elm first: npm -g install elm"
fi

if ! [ -x "$(command -v elm-test)" ]; then
  echo "Please install elm-test first: npm -g install elm-test"
fi

elm-test --watch
