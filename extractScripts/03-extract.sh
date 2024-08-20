. ./common/comm.sh

TEMPLATE_DIR="$PROJECT_DIR/templates"
CONFIG_DIR="$MYSQL_DIR/configs"
SCRIPT_DIR="$MYSQL_DIR/scripts"
DATA_DIR="$MYSQL_DIR/data"

if [ ! -d $CONFIG_DIR ]; then
  mkdir -p $CONFIG_DIR
else
  if [ -n "$(ls -A $CONFIG_DIR)" ]; then
    echo "File existed in '$CONFIG_DIR' please check and remove them first."
    exit 1
  fi
fi

config_extract () {
  while read line || [ -n "${line}" ]
  do
    echo $(eval echo "''${line}")
  done < $TEMPLATE_DIR/configs/my$1.cnf > $CONFIG_DIR/my$1.cnf
}

config_extract "57"
config_extract "57_gtid"
config_extract "80"
config_extract "80_clone"
config_extract "84"
config_extract "90"

if [ -d $SCRIPT_DIR ]; then
  if [ -n "$(ls -A $SCRIPT_DIR)" ]; then
    echo "File existed in '$SCRIPT_DIR' please check and remove them first."
    exit 1
  fi
fi

cp -r "$TEMPLATE_DIR/scripts" $SCRIPT_DIR

echo "MYSQL_DIR=${MYSQL_DIR}" > $SCRIPT_DIR/comm.sh

if [ ! -d $DATA_DIR ]; then
  mkdir -p $DATA_DIR
else
  if [ -n "$(ls -A $DATA_DIR)" ]; then
    echo "File existed in '$DATA_DIR' please check and remove them first."
    exit 1
  fi
fi

mkdir $DATA_DIR/57
mkdir $DATA_DIR/80
mkdir $DATA_DIR/84
mkdir $DATA_DIR/90