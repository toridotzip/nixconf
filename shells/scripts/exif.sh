#! /usr/bin/env nix-shell
#! nix-shell -i bash -p bash exiftool

set -euo pipefail

case "${1:-}" in
  photo)
    shift
    exiftool -s -FileName -Directory -FileSize -CreateDate -Model -FullImageSize \
      -ExposureTime -FNumber -ISO -FocalLength -WB_RGBLevels -PictureProfile \
      -LensID -Megapixels "$@"
    ;;
  camera)
    shift
    exiftool -s -FileName -Directory -FileSize -CreateDate -Make -Model \
      -LensID -Megapixels -ShutterCount "$@"
    ;;
  *)
    echo "Usage: $0 {photo|camera} <file(s)>"
    exit 1
    ;;
esac
