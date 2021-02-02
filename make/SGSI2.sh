LOCALDIR=`cd "$( dirname $0 )" && pwd`
systemdir="$LOCALDIR/out/system/system"
source ./bin.sh
configdir="$LOCALDIR/out/config"

function dynamic() {
  rm -rf ./make/add_dynamic_fs
  mkdir ./make/add_dynamic_fs

  # 复制fs至make目录
  rm -rf ./make/config
  mkdir ./make/config
  cp -frp $configdir/* ./make/config/
  mv ./make/config/system_fs_config ./make/config/system_fs
  mv ./make/config/system_file_contexts ./make/config/system_contexts
  if [ -L $systemdir/system_ext ] && [ -d $systemdir/../system_ext ];then
    mv ./make/config/system_ext_fs_config ./make/config/system_ext_fs 
    mv ./make/config/system_ext_file_contexts ./make/config/system_ext_contexts
  fi
  if [ -L $systemdir/product ] && [ -d $systemdir/../product ];then
    mv ./make/config/product_file_contexts ./make/config/product_contexts
    mv ./make/config/product_fs_config ./make/config/product_fs
  fi

  # 复制makefs至dynamic_fs目录
  cp -frp ./make/config/* ./make/add_dynamic_fs/
  mv ./make/add_dynamic_fs/system_contexts ./make/add_dynamic_fs/contexts
  mv ./make/add_dynamic_fs/system_fs ./make/add_dynamic_fs/fs
  rm -rf ./make/config

  merge_system_ext() {
    # 合并system_ext
    rm -rf $systemdir/system_ext
    rm -rf ./out/system_ext/lost+found
    mv ./out/system_ext $systemdir/

    # fs分段
    cat ./make/add_dynamic_fs/system_ext_fs | grep 'system_ext/lib' > ./make/add_dynamic_fs/system_ext_lib_fs
    sed -i '/system_ext\/lib/d' ./make/add_dynamic_fs/system_ext_fs
    cat ./make/add_dynamic_fs/system_ext_lib_fs | grep '0 0 0644 /system_ext' > ./make/add_dynamic_fs/system_ext_symlink_fs
    sed -i '/0 0 0644 \/system_ext/d' ./make/add_dynamic_fs/system_ext_lib_fs
 
    ## fs数据处理
    sed -i '1d' ./make/add_dynamic_fs/system_ext_contexts
    sed -i '1d' ./make/add_dynamic_fs/system_ext_fs
 
    # contexts
    sed -i 's#/system_ext #/system/system/system_ext #g' ./make/add_dynamic_fs/system_ext_contexts
    sed -i 's#/system_ext/#/system/system/system_ext/#g' ./make/add_dynamic_fs/system_ext_contexts
    sed -i '/build/d' ./make/add_dynamic_fs/system_ext_contexts
    echo "/system/system/system_ext/build\.prop u:object_r:system_file:s0" >> ./make/add_dynamic_fs/system_ext_contexts

    # fs
    sed -i 's#system_ext #system/system/system_ext #g' ./make/add_dynamic_fs/system_ext_fs
    sed -i 's#system_ext/#system/system/system_ext/#g' ./make/add_dynamic_fs/system_ext_fs
 
    # lib_fs
    sed -i 's#system_ext/#system/system/system_ext/#g' ./make/add_dynamic_fs/system_ext_lib_fs

    # symlink_fs
    sed -i 's#/system_ext/#/system/system_ext/#g' ./make/add_dynamic_fs/system_ext_symlink_fs
    sed -i 's#system_ext/#system/system/system_ext/#g' ./make/add_dynamic_fs/system_ext_symlink_fs
    sed -i 's#/system/system/system/system_ext/#/system/system_ext/#g' ./make/add_dynamic_fs/system_ext_symlink_fs

    # 合并system_ext_fs
    cat ./make/add_dynamic_fs/system_ext_contexts >> ./make/add_dynamic_fs/contexts
    cat ./make/add_dynamic_fs/system_ext_symlink_fs >> ./make/add_dynamic_fs/fs
    cat ./make/add_dynamic_fs/system_ext_lib_fs >> ./make/add_dynamic_fs/fs
    cat ./make/add_dynamic_fs/system_ext_fs >> ./make/add_dynamic_fs/fs
  }

  merge_product() {
    # 合并product
    rm -rf $systemdir/product
    rm -rf ./out/product/lost+found
    mv ./out/product $systemdir/
 
    # fs分段
    cat ./make/add_dynamic_fs/product_fs | grep 'product/lib' > ./make/add_dynamic_fs/product_lib_fs
    sed -i '/product\/lib/d' ./make/add_dynamic_fs/product_fs
    cat ./make/add_dynamic_fs/product_lib_fs | grep '0 0 0644 /product' > ./make/add_dynamic_fs/product_symlink_fs
    sed -i '/0 0 0644 \/product/d' ./make/add_dynamic_fs/product_lib_fs
 
    # fs数据处理
    sed -i '1d' ./make/add_dynamic_fs/product_contexts
    sed -i '1d' ./make/add_dynamic_fs/product_fs
 
    # contexts
    sed -i 's#/product #/system/system/product #g' ./make/add_dynamic_fs/product_contexts
    sed -i 's#/product/#/system/system/product/#g' ./make/add_dynamic_fs/product_contexts
    sed -i '/build/d' ./make/add_dynamic_fs/product_contexts
    echo "/system/system/product/build\.prop u:object_r:system_file:s0" >> ./make/add_dynamic_fs/product_contexts

    # fs
    sed -i 's#product #system/system/product #g' ./make/add_dynamic_fs/product_fs
    sed -i 's#product/#system/system/product/#g' ./make/add_dynamic_fs/product_fs
 
    # lib_fs
    sed -i 's#product/#system/system/product/#g' ./make/add_dynamic_fs/product_lib_fs

    # symlink_fs
    sed -i 's#/product/#/system/product/#g' ./make/add_dynamic_fs/product_symlink_fs
    sed -i 's#product/#system/system/product/#g' ./make/add_dynamic_fs/product_symlink_fs
    sed -i 's#/system/system/system/product/#/system/product/#g' ./make/add_dynamic_fs/product_symlink_fs

    # 合并product_fs
    cat ./make/add_dynamic_fs/product_contexts >> ./make/add_dynamic_fs/contexts
    cat ./make/add_dynamic_fs/product_symlink_fs >> ./make/add_dynamic_fs/fs
    cat ./make/add_dynamic_fs/product_lib_fs >> ./make/add_dynamic_fs/fs
    cat ./make/add_dynamic_fs/product_fs >> ./make/add_dynamic_fs/fs
  }
  if [ -L $systemdir/system_ext ] && [ -d $systemdir/../system_ext ];then
    merge_system_ext
  fi
  if [ -L $systemdir/product ] && [ -d $systemdir/../product ];then
    merge_product
  fi

  # 替换原fs
  mv ./make/add_dynamic_fs/contexts ./make/add_dynamic_fs/system_file_contexts 
  mv ./make/add_dynamic_fs/fs ./make/add_dynamic_fs/system_fs_config
  cp -frp ./make/add_dynamic_fs/system_file_contexts $configdir/system_file_contexts
  cp -frp ./make/add_dynamic_fs/system_fs_config $configdir/system_fs_config  
}

echo "启用动态原包处理"

if [ -e ./product.img ];then
  echo "解压product.img中......"
  python3 $bin/imgextractor.py ./product.img ./out
  echo "解压完成"
fi
if [ -e ./system_ext.img ];then
  echo "解压system_ext.img中......"
  python3 $bin/imgextractor.py ./system_ext.img ./out
  echo "解压完成" 
fi 
dynamic
echo "处理完成"
