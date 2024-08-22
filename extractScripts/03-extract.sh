. ./common/comm.sh

TEMPLATE_DIR="$PROJECT_DIR/templates"
CONFIG_DIR="$MYSQL_DIR/configs"
SCRIPT_DIR="$MYSQL_DIR/scripts"
DATA_DIR="$MYSQL_DIR/data"
DUMP_DIR="$MYSQL_DIR/dump"

if [ -d $CONFIG_DIR ]; then
  if [ -n "$(ls -A $CONFIG_DIR)" ]; then
    echo "File existed in '$CONFIG_DIR' please check and remove them first."
    exit 1
  fi
  rm -r $CONFIG_DIR
fi

if [ -d $SCRIPT_DIR ]; then
  if [ -n "$(ls -A $SCRIPT_DIR)" ]; then
    echo "File existed in '$SCRIPT_DIR' please check and remove them first."
    exit 1
  fi
  rm -r $SCRIPT_DIR
fi

if [ -d $DATA_DIR ]; then
  if [ -n "$(ls -A $DATA_DIR)" ]; then
    echo "File existed in '$DATA_DIR' please check and remove them first."
    exit 1
  fi
  rm -r $DATA_DIR
fi

if [ -d $DUMP_DIR ]; then
  if [ -n "$(ls -A $DUMP_DIR)" ]; then
    echo "File existed in '$DUMP_DIR' please check and remove them first."
    exit 1
  fi
  rm -r $DUMP_DIR
fi

mkdir $CONFIG_DIR
echo "Directory ($CONFIG_DIR) is created."
mkdir $SCRIPT_DIR
echo "Directory ($SCRIPT_DIR) is created."
mkdir $DATA_DIR
echo "Directory ($DATA_DIR) is created."
mkdir $DUMP_DIR
echo "Directory ($DUMP_DIR) is created."

config_extract () {
  LOOP_TEMPLATE_FILE="$TEMPLATE_DIR/$1/$2"
  LOOP_TARGET_DIR="$MYSQL_DIR/$1"
  LOOP_TARGET_FILE="$LOOP_TARGET_DIR/$2"
  if [ ! -d $LOOP_TARGET_DIR ]; then
    mkdir $LOOP_TARGET_DIR
  fi
  echo "Extract script $LOOP_TEMPLATE_FILE"
  export MYSQL_DIR="$MYSQL_DIR";cat $LOOP_TEMPLATE_FILE | envsubst '$MYSQL_DIR' > $LOOP_TARGET_FILE
  [ `basename $LOOP_TARGET_FILE .sh` = `basename $LOOP_TARGET_FILE` ] || {
    chmod +x $LOOP_TARGET_FILE
  }
}

config_traversal () {
  LOOP_DIR="$1"
  LOOP_PATH="$TEMPLATE_DIR"
  if [ -n $LOOP_DIR ]; then
    LOOP_PATH="$LOOP_PATH/$LOOP_DIR"
  fi
  for item in $LOOP_PATH/*; do
    LOOP_ITEMBASE=`basename $item`
    if [ -d $item ]; then
      config_traversal "$1/$LOOP_ITEMBASE"
    else
      config_extract $1 $LOOP_ITEMBASE
    fi
  done
}

config_traversal

mkdir $DATA_DIR/57
mkdir $DATA_DIR/80
mkdir $DATA_DIR/84
mkdir $DATA_DIR/90
