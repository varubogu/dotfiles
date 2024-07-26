def_env() {
    local var_name=$1
    local value=$2

    if [ -z "${!var_name}" ]; then
        export $var_name="$value"
    else
        echo "warn: \`$var_name\` is exist"
    fi
}

# XDG Base Directory Specification
def_env "XDG_RUNTIME_DIR" "/run/user/$(id -u)"
def_env "XDG_CONFIG_DIRS" "/etc/xdg"
def_env "XDG_DATA_DIRS" "/usr/local/share:/usr/share"
def_env "XDG_CONFIG_HOME" "$HOME/.config"
def_env "XDG_CACHE_HOME" "$HOME/.cache"
def_env "XDG_DATA_HOME" "$HOME/.local/share"
def_env "XDG_STATE_HOME" "$HOME/.local/state"
def_env "XDG_AUTOSTART_DIR" "$XDG_CONFIG_HOME/autostart"

# XDG user directories
def_env "XDG_DESKTOP_DIR" "$HOME/Desktop"
def_env "XDG_DOCUMENTS_DIR" "$HOME/Documents"
def_env "XDG_DOWNLOAD_DIR" "$HOME/Downloads"
def_env "XDG_MUSIC_DIR" "$HOME/Music"
def_env "XDG_PICTURES_DIR" "$HOME/Pictures"
def_env "XDG_PUBLICSHARE_DIR" "$HOME/Public"
def_env "XDG_TEMPLATES_DIR" "$HOME/Templates"
def_env "XDG_VIDEOS_DIR" "$HOME/Videos"
