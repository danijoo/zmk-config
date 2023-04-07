#!/bin/bash
set -ex

CONTROLLER=nice_nano_v2
SHIELDS=(sofle_left sofle_right)

CONFIG_FOLDER="/workspaces/zmk-config/config"
APP_FOLDER="/workspaces/zmk/app"
BUILD_FOLDER="${APP_FOLDER}/build"
DEST_FOLDER="/workspaces/zmk-config"

for shield in ${SHIELDS[@]}; do
    echo "building for $shield ..."	
    west build -s $APP_FOLDER -d $BUILD_FOLDER/$shield -b $CONTROLLER -- -DSHIELD=$shield -DZMK_CONFIG=$CONFIG_FOLDER  -Wno-dev

    # copy artifact
    DEST=$DEST_FOLDER/$shield.uf2

    # backup old build if exists
    if [ -f $DEST ]; then
        mv $DEST $DEST.old
    fi
    mv $BUILD_FOLDER/$shield/zephyr/zmk.uf2 $DEST
done
