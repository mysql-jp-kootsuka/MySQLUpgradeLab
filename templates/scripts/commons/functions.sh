extractFile () {
  LOCAL_FILE_PATH="${MYSQL_DIR}/$1"
  LOCAL_FILE_NAME=`basename $LOCAL_FILE_PATH`
  echo 
  echo "* $LOCAL_FILE_NAME"
  echo "===="
  cat $LOCAL_FILE_PATH
  echo "===="
  echo
}

waitRun () {
  echo
  echo "ENTER キーを押すと実行します:"
  echo

  read tmp
}

runAndTrapError () {
  COMMAND="${MYSQL_DIR}/$1"
  echo
  echo "Execute $COMMAND ..."
  eval $COMMAND
  if [ $? -gt 0 ]; then
    echo "エラーが発生しました、環境を確認してください。"
    exit 1
  fi
  echo "Finished."
  echo
}
