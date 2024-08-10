#!/bin/bash

is_command_available() { command -v "$1" &> /dev/null; }

is_brew_available() { is_command_available brew; }
is_apt_available() { is_command_available apt; }
is_yum_available() { is_command_available yum; }
is_pacman_available() { is_command_available pacman; }

is_linux() { [ "$(uname)" = "Linux" ]; }

is_macos() { [ "$(uname)" = "Darwin" ];}

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

wsl_ssh_forwarding() {
    export SSH_AUTH_SOCK=$HOME/.ssh/agent.sock
    # need `ps -ww` to get non-truncated command for matching
    # use square brackets to generate a regex match for the process we want but that doesn't match the grep command running it!
    ALREADY_RUNNING=$(ps -auxww | grep -q "[n]piperelay.exe -ei -s //./pipe/openssh-ssh-agent"; echo $?)
    if [[ $ALREADY_RUNNING != "0" ]]; then
        if [[ -S $SSH_AUTH_SOCK ]]; then
            # not expecting the socket to exist as the forwarding command isn't running (http://www.tldp.org/LDP/abs/html/fto.html)
            echo "removing previous socket..."
            rm $SSH_AUTH_SOCK
        fi
        echo "Starting SSH-Agent relay..."
        # setsid to force new session to keep running
        # set socat to listen on $SSH_AUTH_SOCK and forward to npiperelay which then forwards to openssh-ssh-agent on windows
        (setsid socat UNIX-LISTEN:$SSH_AUTH_SOCK,fork EXEC:"npiperelay.exe -ei -s //./pipe/openssh-ssh-agent",nofork &) >/dev/null 2>&1
    fi
}


echo_env() {
  echo "TERM: $TERM Shell: $SHELL"
  echo "OS: $(uname)"
  echo "LANG: $LANG"
  echo "Home: $HOME PWD: $PWD"
  echo "User: $USER"
  echo "Editor: $EDITOR"
}