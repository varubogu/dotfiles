safe_env() {
    local var_name=$1
    local value=$2

    if [ -z "${!var_name}" ]; then
        export $var_name="$value"
    else
        echo "warn: \`$var_name\` is exist"
    fi
}

# XDG Base Directory Specification
safe_env "XDG_RUNTIME_DIR" "/run/user/$(id -u)"
safe_env "XDG_CONFIG_DIRS" "/etc/xdg"
safe_env "XDG_DATA_DIRS" "/usr/local/share:/usr/share"
safe_env "XDG_CONFIG_HOME" "$HOME/.config"
safe_env "XDG_CACHE_HOME" "$HOME/.cache"
safe_env "XDG_DATA_HOME" "$HOME/.local/share"
safe_env "XDG_STATE_HOME" "$HOME/.local/state"
safe_env "XDG_AUTOSTART_DIR" "$XDG_CONFIG_HOME/autostart"

# XDG user directories
safe_env "XDG_DESKTOP_DIR" "$HOME/Desktop"
safe_env "XDG_DOCUMENTS_DIR" "$HOME/Documents"
safe_env "XDG_DOWNLOAD_DIR" "$HOME/Downloads"
safe_env "XDG_MUSIC_DIR" "$HOME/Music"
safe_env "XDG_PICTURES_DIR" "$HOME/Pictures"
safe_env "XDG_PUBLICSHARE_DIR" "$HOME/Public"
safe_env "XDG_TEMPLATES_DIR" "$HOME/Templates"
safe_env "XDG_VIDEOS_DIR" "$HOME/Videos"
