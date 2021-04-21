#!/usr/bin/env bash

set -e

# We need this script to convert our otf fonts to multiple web font formats
# in order to support most browsers out-of-the-box

# 1. check and prepare variables and fail if the parameters are not configured
# correctly. We need an .otf file as input and a target folder as output
SOURCE=$1
DESTINATION=$2
FILENAME=$(basename "${SOURCE%.otf}")

# we omit mime check since we use this script only locally and assume it's otf
if [[ ${SOURCE: -4} != ".otf" ]]; then
  echo "usage: convertOtf input.otf /path/to/output/"
  exit 1
fi

# check the destination is a folder
if [[ ! -d "$DESTINATION" ]]; then
  echo "usage: convertOtf input.otf /path/to/output/"
  exit 1
fi

# check if all tools are installed. We need all tools to be installed in order
ALLCOMMANDS=(
  mkeot
  eot2ttf
  sfnt2woff
  woff2_compress
)

for CMD in "${ALLCOMMANDS[@]}"
do
   :
   if [[ ! -f $(command -v "$CMD") ]];then
        echo "Cannot convert ($CMD). The following packages are required: eot-utils eot2ttf woff-tools woff2"
        exit 1
    fi
done

# EOT EXPORT
EOT_PATH="$DESTINATION/$FILENAME.eot"
echo "[OTF ---> EOT]: (over-)write to $EOT_PATH"
mkeot ${SOURCE} > ${EOT_PATH}

# TTF EXPORT
TTF_PATH="$DESTINATION/$FILENAME.ttf"
echo "[EOT ---> TTF]: (over-)write to $TTF_PATH"
eot2ttf ${EOT_PATH} ${TTF_PATH}

# WOFF export
WOFF_PATH="$DESTINATION/$FILENAME.woff"
echo "[OTF --> WOFF]: (over-)write to $WOFF_PATH"
sfnt2woff ${SOURCE} > ${WOFF_PATH}

# WOFF2 export
WOFF2_PATH="$DESTINATION/$FILENAME.woff2"
echo "[TTF -> WOFF2]: (over-)write to $WOFF2_PATH"
woff2_compress ${TTF_PATH} > ${WOFF2_PATH}

exit 0
