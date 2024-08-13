#!/bin/bash

safe_env() {
    local var_name=$1
    local var_value=$2
    local is_make_dir=${3:-true}

    # Check if variable is exist
    if [ ! -z "${var_name}" ]; then
        export $var_name="$var_value"

        # Split the value by colon and create each directory
        echo "$var_value" | tr ':' '\n' | while read -r dir; do
            if [ ! -d "$dir" ] && $is_make_dir; then
                mkdir -p "$dir"
                echo "Created directory: $dir"
            fi
        done
    else
        echo "warn: \`$var_name\` is exist"
    fi
}

# XDG Base Directory Specification
safe_env "XDG_RUNTIME_DIR" "/run/user/$(id -u)" false
safe_env "XDG_CONFIG_DIRS" "/etc/xdg" false
safe_env "XDG_DATA_DIRS" "/usr/local/share:/usr/share" false
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
