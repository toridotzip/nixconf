#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash exiftool

c="$(exiftool -s3 -ShutterCount "$1")"
if [[ $c -gt 0 ]]; then
    printf '%s\n' "ShutterCount: $c"
else
    c="$(exiftool -s3 -ImageCount "$1")"
    if [[ $c -gt 0 ]]; then
        printf '%s\n' "ImageCount: $c"
    else
        c="$(exiftool -s3 -ImageNumber "$1")"
        if [[ $c -gt 0 ]]; then
            printf '%s\n' "ImageNumber: $c"
        else
            printf '%s\n' "Unknown"
        fi
    fi
fi
