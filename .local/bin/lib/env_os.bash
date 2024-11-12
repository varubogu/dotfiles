#!/bin/bash

is_linux() { [ "$(uname)" = "Linux" ]; }

is_mac() { [ "$(uname)" = "Darwin" ];}

is_wsl() { grep -qEi "(Microsoft|WSL)" /proc/version; }

is_windows() {
  case "$(uname -r)" in
    *Microsoft*)
      return 0
      ;;
    *CYGWIN*|*MINGW*|*MSYS*)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}


echo_env() {
  echo "TERM: $TERM Shell: $SHELL"
  echo "OS: $(uname)"
  echo "LANG: $LANG"
  echo "Home: $HOME PWD: $PWD"
  echo "User: $USER"
  echo "Editor: $EDITOR"
}