
#!/usr/bin/env bash
set -o errexit -o nounset -o pipefail
IFS=$'\n\t\v'
cd `dirname "${BASH_SOURCE[0]:-$0}"`

TILE_URL_TEMPLATE="https://tiles.telegeography.com/maps/submarine-cable-map-2015/{z}/{x}/{y}.png"
Z=6

getTile() {
  local Z=$1
  local Y=$2
  local X=$3
  URL=`echo $TILE_URL_TEMPLATE | sed -E "s|\{z\}|$Z|" | sed -E "s|\{x\}|$X|" | sed -E "s|\{y\}|$Y|"`

  ! curl --silent --fail -o tile.png $URL
  if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    return 1
  else
    mkdir -p tiles/$Y
    mv tile.png tiles/$Y/$X.png
    return 0
  fi
}

getRow() {
  local Z=$1
  local Y=$2
  echo -n "Row $Y: "
  local X=0
  while true; do
    echo -n "$X "
    ! getTile $Z $Y $X
    if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
      echo "done"
      break
    fi
    X=$((X+1))
  done
  if [[ $X -eq 0 ]]; then
    return 1
  fi
  return 0
}

getAllRows() {
  local Z=$1
  local Y=0
  while true; do
    ! getRow $Z $Y
    if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
      echo "done"
      break
    fi
    Y=$((Y+1))
  done
  if [[ $Y -eq 0 ]]; then
    return 1
  fi
  return 0
}

getAllRows $Z
