COMMON_FILE='./common.txt'
if [ ! -d $COMMON_FILE ]; then
  source $COMMON_FILE
fi

CURRENT_DIR=$(cd $(dirname $0);pwd)
PROJECT_DIR=$(cd $CURRENT_DIR;cd ..;pwd)

if [ ! $GIVEN_DIR ]; then
  MYSQL_DIR=$(cd $PROJECT_DIR;cd ..;pwd)/mysql
else
  MYSQL_DIR=${GIVEN_DIR}/mysql
fi