#!/bin/bash

SYNC_DIR='./share'
TMP_DIR='../tmp-share'

# symblic linkのエラーを回避するために以下コマンドを実行して起動する
# devディレクトリのファイルを退避
echo 'start evacuation dev directory...'
mkdir $TMP_DIR
if [ "$(ls $SYNC_DIR)" ]; then
  mv $SYNC_DIR/* $TMP_DIR
fi
echo 'evacuation files are as follows:'
ls -l $TMP_DIR
echo 'end evacuation dev directory.'
