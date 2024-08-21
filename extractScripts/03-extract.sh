. ./common/comm.sh

TEMPLATE_DIR="$PROJECT_DIR/templates"
CONFIG_DIR="$MYSQL_DIR/configs"
SCRIPT_DIR="$MYSQL_DIR/scripts"
DATA_DIR="$MYSQL_DIR/data"

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

mkdir $CONFIG_DIR
mkdir $SCRIPT_DIR
mkdir $DATA_DIR
echo "Directories ($CONFIG_DIR, $SCRIPT_DIR, $DATA_DIR) are created."

config_extract () {
  LOOP_TEMPLATE_FILE="$TEMPLATE_DIR/$1/$2"
  LOOP_TARGET_DIR="$MYSQL_DIR/$1"
  LOOP_TARGET_FILE="$LOOP_TARGET_DIR/$2"
  if [ ! -d $LOOP_TARGET_DIR ]; then
    mkdir $LOOP_TARGET_DIR
  fi
  while read line || [ -n "${line}" ]
  do
    echo $(eval echo "''${line}")
  done < $LOOP_TEMPLATE_FILE > $LOOP_TARGET_FILE
  [ `basename $LOOP_TARGET_FILE .sh` = `basename $LOOP_TARGET_FILE` ] || {
    chmod +x $LOOP_TARGET_FILE
  }
}

config_extract "configs" "my57.cnf"
config_extract "configs" "my57_gtid.cnf"
config_extract "configs" "my80.cnf"
config_extract "configs" "my80_clone.cnf"
config_extract "configs" "my84.cnf"
config_extract "configs" "my90.cnf"
config_extract "scripts/01_init" "01_5.7_init.sh"
config_extract "scripts/01_init" "02_8.0_init.sh"
config_extract "scripts/01_init" "03_5.7_start.sh"
config_extract "scripts/01_init" "04_8.0_start.sh"
config_extract "scripts/01_init" "05_5.7_dbload.sh"

#cp -r "$TEMPLATE_DIR/scripts" $SCRIPT_DIR

#echo "MYSQL_DIR=${MYSQL_DIR}" > $SCRIPT_DIR/comm.sh

mkdir $DATA_DIR/57
mkdir $DATA_DIR/80
mkdir $DATA_DIR/84
mkdir $DATA_DIR/90
