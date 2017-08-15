# display help
# =============================================================
display_help() {
  echo " TODO"
  echo " ================ "
  echo " - sync parallel when possible"
  echo " - add timestamps for how long the sync has ran"
  echo " - move help into markdown file "
  echo
  echo " 4 kinds of syncs"
  echo " ================ "
  echo "   - (hh) hd to hd"
  echo "   - (lh) local to hd"
  echo "   - (dl) device to local"
  echo "   - (dh) device to hd"
  echo
  echo " devices"
  echo " ================ "
  echo "    x device-canon-750d"
  echo "    todo device-s7: https://askubuntu.com/questions/664089/wheres-my-phone-mounted-to-browse-it-from-shell"
  echo "    todo device-s2"
  echo "    todo device-s3"
  echo "    todo device-s5"
  echo "    todo device-canon-300d: find adapter for flash card and add meta.txt"
  echo "    todo device-ixus70-linus: rename to CAM02 and add meta.txt"
  echo "    todo device-ixus70-yamo: rename to CAM03 and add meta.txt"
  echo "    todo device-ixus70-arvid: rename to CAM04 and add meta.txt"
  echo
  echo " possible Parametercontruction"
  echo " ===================="
  echo "   snc --cam type-name_type-name"
  echo "   x cam-all_hd-all"
  echo "   x cam-all_hd-12"
  echo "   x cam-all_local"
  echo "   x cam-01_hd-all"
  echo "   x cam-01_hd-12"
  echo "   x cam-01_local"
  echo "   x local_hd-11"
  echo "   x local_hd-all"
  echo "   x hd-all_hd-all"
  echo "   x hd-11_hd-12"
  echo "   x hd-11_hd-all"
  echo "   todo hd-11_local"
  echo "   todo hd-11_cam-01"
  echo "   todo hd-11_cam-all"
  echo "   todo local_cam-01"
  echo "   todo local_cam-all"
  echo
  echo " EXAMPLES"
  echo " ===================="
  echo "   snc --cam cam-all_hd-all"

  exit 1
}
if [ "$1" == "help" ]; then
  display_help
fi

# RUN
# =============================================================
TIME=$(date +%Y%m%d-%H%M%S)
DAY=$(date +%Y%m%d)

IFS='_' read -r -a ACTION <<< "$1"
IFS='-' read -r -a SRC <<< "${ACTION[0]}"
IFS='-' read -r -a DEST <<< "${ACTION[1]}"

SRC_TYPE="${SRC[0]}"
SRC_NAME="${SRC[1]}"
DEST_TYPE="${DEST[0]}"
DEST_NAME="${DEST[1]}"

# echo "st: $SRC_TYPE sn: $SRC_NAME"
# echo "dt: $DEST_TYPE dn: $DEST_NAME"
# echo "action: $1"

# create source array
# =============================================================
SRC_ARRAY=()

if [ "$SRC_TYPE" == "cam" ]; then
  if ! [ "$SRC_NAME" == "all" ]; then
      SRC_ARRAY=("${SRC_ARRAY[@]}" "/media/$USER/CAM$SRC_NAME")
  else
      for line in `find /media/mod -maxdepth 1 -name 'CAM*' -type d`; do
          SRC_ARRAY=("${SRC_ARRAY[@]}" "$line")
      done
  fi
fi

if [ "$SRC_TYPE" == "hd" ]; then
  if ! [ "$SRC_NAME" == "all" ]; then
      SRC_ARRAY=("${SRC_ARRAY[@]}" "/media/$USER/HD$SRC_NAME")
  else
      for line in `find /media/mod -maxdepth 1 -name 'HD*' -type d`; do
          SRC_ARRAY=("${SRC_ARRAY[@]}" "$line")
      done
  fi
fi

if [ "$SRC_TYPE" == "local" ]; then
  SRC_ARRAY=("${SRC_ARRAY[@]}" "/home/$USER/cam")
fi

echo "src_arr: ${SRC_ARRAY[@]}"

# create destination array
# =============================================================
DEST_ARRAY=()

# if DEST_TYPE === hd
if [ "$DEST_TYPE" == "hd" ]; then
  if ! [ "$DEST_NAME" == "all" ]; then
      DEST_ARRAY=("${DEST_ARRAY[@]}" "/media/$USER/HD$DEST_NAME/me")
  else
      for line in `find /media/mod -maxdepth 1 -name 'HD*' -type d`; do
          DEST_ARRAY=("${DEST_ARRAY[@]}" "$line/me")
      done
  fi
fi

if [ "$DEST_TYPE" == "local" ]; then
  DEST_ARRAY=("${DEST_ARRAY[@]}" "/home/$USER/cam")
fi

echo "dest_arr: ${DEST_ARRAY[@]}"

# create rsync commands
# =============================================================
# todo create folder name from meta.txt

if [[ "$SRC_TYPE" == "cam" ]]; then
  for SRC_PATH in "${SRC_ARRAY[@]}"; do
    echo "from: $SRC_PATH"
    META_TXT_PATH="$SRC_PATH/meta.txt"
    if [[ -f "$META_TXT_PATH" ]]; then
      DEVICE_NAME=$(<$META_TXT_PATH)
    else
      DEVICE_NAME=`CAM01`
    fi
    for DEST_DEVICE_PATH in "${DEST_ARRAY[@]}"; do
      if ! [[ "$SRC_PATH" == "$DEST_DEVICE_PATH" ]]; then
        if [[ "$DEST_TYPE" == "hd" ]]; then
          DEST_PATH="$DEST_DEVICE_PATH/cam/$DAY""_$DEVICE_NAME"
        fi
        if [[ "$DEST_TYPE" == "local" ]]; then
          DEST_PATH="$DEST_DEVICE_PATH/$DAY""_$DEVICE_NAME"
        fi
        echo "  to: $DEST_PATH"
        if ! [[ -d $DEST_PATH ]]; then
          mkdir -p $DEST_PATH
        fi

        RSYNC_CMD="rsync -avzP $SRC_PATH/* $DEST_PATH"
        echo "  $RSYNC_CMD"
        eval $RSYNC_CMD
      fi
    done
  done
fi

if [ "$SRC_TYPE" == "local" ] && [ "$DEST_TYPE" == "hd" ]; then
  for SRC_PATH in "${SRC_ARRAY[@]}"; do
    for DEST_DEVICE_PATH in "${DEST_ARRAY[@]}"; do
      RSYNC_CMD="rsync -avzP $SRC_PATH $DEST_DEVICE_PATH"
      echo "  $RSYNC_CMD"
      eval $RSYNC_CMD
    done
  done
fi

if [ "$SRC_TYPE" == "hd" ] && [ "$DEST_TYPE" == "hd" ]; then
  for SRC_PATH in "${SRC_ARRAY[@]}"; do
    for DEST_DEVICE_PATH in "${DEST_ARRAY[@]}"; do
      if ! [[ "$SRC_PATH/me" == "$DEST_DEVICE_PATH" ]]; then
        RSYNC_CMD="rsync -avzP $SRC_PATH/me/cam $DEST_DEVICE_PATH"
        echo "  $RSYNC_CMD"
        eval $RSYNC_CMD
      fi
    done
  done
fi
