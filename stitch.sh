#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
IFS=$'\n\t\v'
cd `dirname "${BASH_SOURCE[0]:-$0}"`

if [[ ! -d "tiles" ]]; then
  echo "run scrape.sh first"
  exit 1
fi

X_TILES_CNT=`find tiles/0 -type f | wc -l`
Y_TILES_CNT=`find tiles -mindepth 1 -maxdepth 1 -type d | wc -l`

echo "generating a ${X_TILES_CNT}x${Y_TILES_CNT} grid"

gm montage +frame +shadow -tile ${X_TILES_CNT}x${Y_TILES_CNT} -geometry +0+0 `find tiles -type f | sort -V` out.png
echo "written to out.png"
