#!/bin/sh
echo -ne '\033c\033]0;TwilightServer\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/TwilightServer.x86_64" "$@"
