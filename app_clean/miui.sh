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

#fps
sed -i "/<\/features>/d" $1/etc/device_features/*
echo '<!-- whether support fps change -->
    <integer-array name="fpsList">
        <item>120</item>
        <item>60</item>
    </integer-array>
    <integer name="defaultFps">60</integer>' >> $1/etc/device_features/*
    
echo "</features>" >> $1/etc/device_features/*
mv $1/etc/device_features/* $1/etc/device_features/oppo6853.xml

echo "#property for fps switch mode type
      ro.vendor.fps.switch.default=true
      #for CTS fps
      ro.vendor.display.default_fps=60
      #property for dfps
      ro.vendor.smart_dfps.enable=true
      #property for display fps switch
      persist.vendor.power.dfps.level=0" >> $1/build.prop

