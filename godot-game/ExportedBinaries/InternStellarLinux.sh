#!/bin/sh
printf '\033c\033]0;%s\a' GodotGame
base_path="$(dirname "$(realpath "$0")")"
"$base_path/InternStellarLinux.x86_64" "$@"
