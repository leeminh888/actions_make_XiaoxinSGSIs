#!/bin/bash

LOCALDIR=`cd "$( dirname $0 )" && pwd`
cd $LOCALDIR

#rm -rf $1/data-app/*
#vndk29 vndk28
rm -rf $1/system_ext/apex

#data
rm -rf $1/data-app/com.zhihu.android_28
rm -rf $1/data-app/Youpin
rm -rf $1/data-app/VipAccount
rm -rf $1/data-app/Userguide
rm -rf $1/data-app/MiShop
rm -rf $1/data-app/GameCenter
rm -rf $1/data-app/Email
rm -rf $1/data-app/com.dragon.read_104
rm -rf $1/data-app/com.smile.gifmaker_13
rm -rf $1/data-app/com.taobao.taobao_24

