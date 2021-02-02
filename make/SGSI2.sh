LOCALDIR=`cd "$( dirname $0 )" && pwd`
systemdir="$LOCALDIR/out/system/system"

echo "启用亮度修复"
cp -frp $(find ./out/system/ -type f -name 'services.jar') ./fixbug/light_fix/
cd ./fixbug/light_fix
./brightness_fix.sh
dist="$(find ./services.jar.out/ -type d -name 'dist')"
if [ ! $dist = "" ];then
cp -frp $dist/services.jar $systemdir/framework/
fi
cd $LOCALDIR