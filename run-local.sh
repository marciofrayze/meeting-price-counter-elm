if ! [ -x "$(command -v elm)" ]; then
  echo "Please install elm first: npm -g install elm"
fi

echo "Go to: http://localhost:8000/src/Main.elm"
sleep 1 && open http://localhost:8000/src/Main.elm &&
elm reactor
