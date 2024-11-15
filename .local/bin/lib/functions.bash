#!/bin/bash

echo_log() {
    echo "***dotfiles[$1] $2"
}

echo_log_info() {
    echo_log "INFO" "$1"
}

echo_log_error() {
    echo_log "ERROR" "$1"
}

echo_log_warn() {
    echo_log "WARN" "$1"
}

is_command_available() { command -v "$1" &> /dev/null; }


is_linux() { [ "$(uname)" = "Linux" ]; }

is_mac() { [ "$(uname)" = "Darwin" ];}

is_wsl() {
    [ -n "${WSL_DISTRO_NAME}" ] || \
    [ -n "${WSLG_DIR}" ] || \
    (grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null && \
    [ -r "/mnt/c/Users" ])
}

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
    echo_log_info "TERM: $TERM Shell: $SHELL"
    echo_log_info "OS: $(uname)"
    echo_log_info "LANG: $LANG"
    echo_log_info "Home: $HOME PWD: $PWD"
    echo_log_info "User: $USER"
    echo_log_info "Editor: $EDITOR"
}
