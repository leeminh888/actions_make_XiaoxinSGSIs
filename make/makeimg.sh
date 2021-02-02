#!/bin/bash

# Copyright (C) 2020 Xiaoxindada <2245062854@qq.com>

LOCALDIR=`cd "$( dirname $0 )" && pwd`
cd $LOCALDIR
source ./bin.sh

if [ "$1" = "" ];then
  echo -e "\033[33m
  error!
  
  Usage:
  $0 A or AB 
  \033[0m"
  exit
fi

system_name=$1

if [ "$system_name" = "A" ];then
  systemdir="./out/system/system"
else
  systemdir="./out/system"
fi

if [ "$system_name" = "A" ];then
  echo "/ u:object_r:system_file:s0" > ./out/config/system_A_contexts
  echo "/system u:object_r:system_file:s0" >> ./out/config/system_A_contexts
  echo "/system(/.*)? u:object_r:system_file:s0" >> ./out/config/system_A_contexts
  echo "/system/lost+found u:object_r:system_file:s0" >> ./out/config/system_A_contexts

  echo "/ 0 0 0755" > ./out/config/system_A_fs
  echo "system 0 0 0755" >> ./out/config/system_A_fs
  echo "system/lost+found 0 0 0700" >> ./out/config/system_A_fs

  cat ./out/config/system_file_contexts | grep "system_ext" >> ./out/config/system_ext_contexts
  cat ./out/config/system_fs_config | grep "system_ext" >> ./out/config/system_ext_fs
  cat ./out/config/system_file_contexts | grep "/system/system/" >> ./out/config/system_A_contexts
  cat ./out/config/system_fs_config | grep "system/system/" >> ./out/config/system_A_fs

  sed -i 's#/system/system/system_ext#/system/system_ext#' ./out/config/system_ext_contexts
  sed -i 's#system/system/system_ext#system/system_ext#' ./out/config/system_ext_fs
  sed -i 's#/system/system#/system#' ./out/config/system_A_contexts
  sed -i 's#system/system#system#' ./out/config/system_A_fs

  cat ./out/config/system_ext_contexts >> ./out/config/system_A_contexts
  cat ./out/config/system_ext_fs >> ./out/config/system_A_fs
fi

echo "
当前img大小为: 

_________________

`du -sh $systemdir | awk '{print $1}'`

`du -sm $systemdir | awk '{print $1}' | sed 's/$/&M/'`

`du -sb $systemdir | awk '{print $1}' | sed 's/$/&B/'`
_________________
"

size="$((`du -sb $systemdir | awk '{print $1}'`+136314880))"
echo "当前打包大小：${size}B"

echo ""
read -p "按任意键开始打包" var
#mke2fs+e2fsdroid打包
#$bin/mke2fs -L / -t ext4 -b 4096 ./out/system.img $size
#$bin/e2fsdroid -e -T 0 -S ./out/config/system_file_contexts -C ./out/config/system_fs_config  -a /system -f ./out/system ./out/system.img

if [ "$system_name" = "A" ];then
  $bin/mkuserimg_mke2fs.sh "$systemdir" "./out/system.img" ext4 "/system" $size -j "0" -T "1230768000" -C "./out/config/system_A_fs" -L "system" -I "256" -M "/system" -m "0" "./out/config/system_A_contexts"
else
  $bin/mkuserimg_mke2fs.sh "$systemdir" "./out/system.img" ext4 "/system" $size -j "0" -T "1230768000" -C "./out/config/system_fs_config" -L "system" -I "256" -M "/system" -m "0" "./out/config/system_file_contexts"
fi

if [ -s ./out/system.img ];then
  echo "打包完成"
  echo "输出至SGSI文件夹"
else
  echo "打包失败，错误日志如上"
fi

if [ -e ./SGSI ];then
  rm -rf ./SGSI
  mkdir ./SGSI
  chmod -R 777 ./SGSI
else
  mkdir ./SGSI
  chmod -R 777 ./SGSI
fi

if [ -e ./SGSI ];then
  mv ./out/system.img ./SGSI
  ./copy.sh
  # 检测精简app的zip
  if [ -e ./out/delete.zip ];then
    mv ./out/delete.zip ./SGSI
  fi
fi
