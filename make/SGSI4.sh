LOCALDIR=`cd "$( dirname $0 )" && pwd`

echo "启用bug修复"
cd ./fixbug
./fixbug.sh
cd $LOCALDIR