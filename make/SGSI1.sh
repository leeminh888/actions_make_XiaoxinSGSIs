#!/bin/bash

# Copyright (C) 2020 Xiaoxindada <2245062854@qq.com>

LOCALDIR=`cd "$( dirname $0 )" && pwd`
cd $LOCALDIR
source ./bin.sh

systemdir="$LOCALDIR/out/system/system"
configdir="$LOCALDIR/out/config"

if [ "$1" = "" ];then
  echo -e "\033[33m
  error!
  
  Usage:
  $0 A or AB 
  \033[0m"
  exit
fi

rm -rf ./out
rm -rf ./SGSI
mkdir ./out

if [ -e ./vendor.img ];then
  echo "解压vendor.img中..."
  python3 $bin/imgextractor.py ./vendor.img ./out
  if [ ! -d ./out/vendor ];then
    echo "vendor.img解压失败！"
    exit
  fi
fi
echo "解压system.img中..."
python3 $bin/imgextractor.py ./system.img ./out
if [ ! -d ./out/system ];then
  echo "system.img解压失败！"
  exit
fi

model="$(cat $systemdir/build.prop | grep 'model')"
echo "当前原包机型为:"
echo "$model"
