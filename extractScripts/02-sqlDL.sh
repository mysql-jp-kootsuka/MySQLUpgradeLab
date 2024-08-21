. ./common/comm.sh

# Databases
export WORLD_DB='https://downloads.mysql.com/docs/world-db.zip'

# Path to wget command
WGET=/usr/bin/wget

# Log directory and file
LOGFILE=$PROJECT_DIR/wgetlog-$(date +%m-%d-%y-%H:%M).log
echo $LOGFILE                                                                                                                                         ~                                                                                                                                                                                           # Output directory and file

DOWNLOAD_DIR=$MYSQL_DIR/sql
DOWNLOADED_FILE=${DOWNLOAD_DIR}/$( basename ${WORLD_DB} )

if [ ! -d $DOWNLOAD_DIR ]; then
  mkdir -p $DOWNLOAD_DIR
else
  # 存在して空でない場合は警告を出して終了
  if [ -n "$(ls -A $DOWNLOAD_DIR)" ]; then
    echo "File existed in '$DOWNLOAD_DIR' please check and remove them first."
    exit 1
  fi
fi

echo "$(date) - INFO - Download of sample database (world)... please wait..."
$WGET -nv --progress=dot:giga ${WORLD_DB} -P "${DOWNLOAD_DIR}/"
echo "$(date) - INFO - Unzip world database" | tee -a ${LOGFILE}
unzip -d ${DOWNLOAD_DIR} ${DOWNLOADED_FILE}

mv ${DOWNLOAD_DIR}/world-db/*.sql ${DOWNLOAD_DIR}/.
rm ${DOWNLOADED_FILE}
rm -r ${DOWNLOAD_DIR}/world-db