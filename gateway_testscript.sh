#!/bin/bash

estatus=0

cmdPath='./gcscmd'

testCases() {

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 绑定网关 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '绑定网关 => 上传 => 已绑定网关的桶上传文件 => gcscmd put ./aaa.mp4 cs://bucket-bind-gateway start'
  echo '数据准备'
  echo '1、设置桶名称，手工绑定网关'
  bucketName="bucket-bind-gateway"
  $cmdPath mb cs://$bucketName
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=10240 count=1024
  # 设置当前目录
  dataPath=''$testDataFileName
  execCmd '绑定网关' '上传' '已绑定网关的桶上传文件' 'gcscmd put '$dataPath' cs://'$bucketName 'put '$dataPath' cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  echo '绑定网关桶数据清理'
  $cmdPath rm cs://$bucketName --name $testDataFileName
  echo '绑定网关 => 上传 => 已绑定网关的桶上传文件 => gcscmd put ./aaa.mp4 cs://bucket-bind-gateway end'
  echo ''

  echo '绑定网关 => 上传 => 已绑定网关的桶上传文件夹 => gcscmd put ./aaaa cs://bucket-bind-gateway start'
  echo '数据准备'
  # 1、添加目录
  testDataFolderName="testfolder_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testDataFolderName
  mkdir $testDataFolderName
  #  $cmdPath put $testDataFolderName cs://$bucketName
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  # 设置相对路径
  dataPath=$testDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=10240 count=1024
  execCmd '绑定网关' '上传' '已绑定网关的桶上传文件夹' 'gcscmd put '$testDataFolderName' cs://'$bucketName 'put '$testDataFolderName' cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $testDataFolderName
  echo '绑定网关桶数据清理'
  $cmdPath rm cs://$bucketName --name $testDataFolderName
  echo '绑定网关 => 上传 => 已绑定网关的桶上传文件夹 => gcscmd put ./aaaa cs://bucket-bind-gateway end'
  echo ''

  echo '绑定网关 => 上传 => 已绑定网的桶上传car文件 => gcscmd put ./aaa.car cs://bucket-bind-gateway start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  # 设置绝对路径
  dataPath=$(pwd)'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=10240 count=1024
  echo '2、生成CAR文件(测试环境需要安装car命令行程序)'
  carDataPath=$(echo ${dataPath/.dat/.car})
  car c --version 1 -f $carDataPath $dataPath
  execCmd '绑定网关' '上传' '已绑定网的桶上传car文件' 'gcscmd import '$carDataPath' cs://'$bucketName 'import '$carDataPath' cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $dataPath
  rm -rf $carDataPath
  echo '绑定网关桶数据清理'
  objectName=${testDataFileName%%.dat*}
  $cmdPath rm cs://$bucketName --name $objectName
  echo '绑定网关 => 上传 => 已绑定网的桶上传car文件 => gcscmd put ./aaa.car cs://bucket-bind-gateway end'
  echo ''

  echo '绑定网关 => 下载 => 已绑定网关的桶下载文件 => gcscmd get cs://bucket-bind-gateway --name Tarkov.mp4 start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=10240 count=1024
  resp=$($cmdPath put $testDataFileName cs://$bucketName)
  echo '2、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  echo '3、清理上传数据'
  rm -rf $testDataFileName
  # 设置对象名称
  objectName=$testDataFileName
  execCmd '绑定网关' '下载' '已绑定网关的桶下载文件' 'gcscmd get cs://'$bucketName' --name '$objectName 'get cs://'$bucketName' --name '$objectName ''
  echo '4、数据清理'
  rm -rf $testDataFileName
  echo '绑定网关桶数据清理'
  $cmdPath rm cs://$bucketName --name $objectName
  echo '绑定网关 => 下载 => 已绑定网关的桶下载文件 => gcscmd get cs://bucket-bind-gateway --name Tarkov.mp4 end'
  echo ''

  echo '绑定网关 => 下载 => 已绑定网关的桶下载文件夹 => gcscmd get cs://bucket-bind-gateway --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo start'
  echo '数据准备'
  echo '1、添加目录'
  # root folder
  testRootDataFolderName="testRootFolder_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testRootDataFolderName
  # child folders
  testChildDataFolderName1="testChildFolder_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testChildDataFolderName2="testChildFolder_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testChildDataFolderName1
  #echo $testChildDataFolderName2
  # grandchild folders
  testGrandchildDataFolderName1="testGrandchildFolder_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testGrandchildDataFolderName2="testGrandchildFolder_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testGrandchildDataFolderName3="testGrandchildFolder_2_3_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testGrandchildDataFolderName1
  #echo $testGrandchildDataFolderName2
  #echo $testGrandchildDataFolderName3
  # grandchild folder path
  testGrandchildDataFolderPath1=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName1
  testGrandchildDataFolderPath2=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName2
  testGrandchildDataFolderPath3=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName3
  mkdir -p $testGrandchildDataFolderPath1
  mkdir -p $testGrandchildDataFolderPath2
  mkdir -p $testGrandchildDataFolderPath3
  mkdir -p $testRootDataFolderName'/'$testChildDataFolderName1
  #  $cmdPath put $testRootDataFolderName cs://$bucketName
  echo '2、添加对象'
  # add files in grandchild folders
  testDataFileName="testdata_2_1_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_1_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_3_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath3'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  # add files in child folders
  testDataFileName="testdata_1_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  # add files in root folder
  testDataFileName="testdata_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_3_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  # upload data folder
  resp=$($cmdPath put $testRootDataFolderName cs://$bucketName)
  #  echo $resp
  echo '3、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  echo '4、清理上传数据'
  rm -rf $testRootDataFolderName

  execCmd '绑定网关' '下载' '已绑定网关的桶下载文件夹' 'gcscmd get cs://'$bucketName' --cid '$cid 'get cs://'$bucketName' --cid '$cid ''
  echo '5、数据清理'
  rm -rf $testRootDataFolderName
  echo '绑定网关桶数据清理'
  $cmdPath rm cs://$bucketName --name $testRootDataFolderName

  echo '绑定网关 => 下载 => 已绑定网关的桶下载文件夹 => gcscmd get cs://bucket-bind-gateway --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo end'
  echo ''

  echo '绑定网关 => 下载 => 已绑定网关的桶下载car文件 => gcscmd get cs://bucket-bind-gateway --name folder start'
  echo '数据准备'
  echo '1、添加目录'
  # root folder
  testRootDataFolderName="testRootFolder_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testRootDataFolderName
  # child folders
  testChildDataFolderName1="testChildFolder_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testChildDataFolderName2="testChildFolder_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testChildDataFolderName1
  #echo $testChildDataFolderName2
  # grandchild folders
  testGrandchildDataFolderName1="testGrandchildFolder_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testGrandchildDataFolderName2="testGrandchildFolder_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  testGrandchildDataFolderName3="testGrandchildFolder_2_3_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #echo $testGrandchildDataFolderName1
  #echo $testGrandchildDataFolderName2
  #echo $testGrandchildDataFolderName3
  # grandchild folder path
  testGrandchildDataFolderPath1=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName1
  testGrandchildDataFolderPath2=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName2
  testGrandchildDataFolderPath3=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testGrandchildDataFolderName3
  mkdir -p $testGrandchildDataFolderPath1
  mkdir -p $testGrandchildDataFolderPath2
  mkdir -p $testGrandchildDataFolderPath3
  mkdir -p $testRootDataFolderName'/'$testChildDataFolderName1
  #  $cmdPath put $testRootDataFolderName cs://$bucketName
  echo '2、添加对象'
  # add files in grandchild folders
  testDataFileName="testdata_2_1_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_1_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_3_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testGrandchildDataFolderPath3'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  # add files in child folders
  testDataFileName="testdata_1_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName1'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testChildDataFolderName2'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  # add files in root folder
  testDataFileName="testdata_1_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_2_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  testDataFileName="testdata_3_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dataPath=$testRootDataFolderName'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1

  echo '3、生成CAR文件(测试环境需要安装car命令行程序)'
  carFilename=$testRootDataFolderName'.car'
  car c --version 1 -f $carFilename $testRootDataFolderName
  dataPath=$carFilename
  # import car file
  resp=$($cmdPath import $dataPath cs://$bucketName)
  #  echo $resp
  echo '4、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  echo '5、数据清理'
  rm -rf $testRootDataFolderName
  rm -rf $dataPath

  # 设置对象名称
  #  objectName=$carFilename
  objectName=$testRootDataFolderName
  execCmd '绑定网关' '下载' '已绑定网关的桶下载car文件' 'gcscmd get cs://'$bucketName' --name '$objectName 'get cs://'$bucketName' --name '$objectName ''
  echo '6、数据清理'
  rm -rf $testRootDataFolderName
  echo '绑定网关桶数据清理'
  $cmdPath rm cs://$bucketName --name $testRootDataFolderName

  echo '绑定网关 => 下载 => 已绑定网关的桶下载car文件 => gcscmd get cs://bucket-bind-gateway --name folder end'
  echo ''

  echo '绑定网关 => 下载 => 已绑定网关的桶下载已绑定网关的文件 => gcscmd get cs://bucket-bind-gateway --name test_file_bind_gateway.dat start'
  echo '数据准备'
  echo '1、设置对象名称，手工绑定网关'
  testDataFileName="test_file_bind_gateway.dat"
  #echo $testDataFileName
  objectName=$testDataFileName
  execCmd '绑定网关' '下载' '已绑定网关的桶下载已绑定网关的文件' 'gcscmd get cs://'$bucketName' --name '$objectName 'get cs://'$bucketName' --name '$objectName ''
  echo '2、数据清理'
  rm -rf $testDataFileName
  echo '绑定网关 => 下载 => 已绑定网关的桶下载已绑定网关的文件 => gcscmd get cs://bucket-bind-gateway --name test_file_bind_gateway.dat end'
  echo ''

  echo '绑定网关 => 下载 => 已绑定网关的桶下载已绑定网关的文件夹 => gcscmd get cs://bucket-bind-gateway --name test_folder_bind_gateway start'
  echo '数据准备'
  echo '1、设置对象名称，手工绑定网关'
  testRootDataFolderName="test_folder_bind_gateway"
  #echo $testRootDataFolderName
  objectName=$testRootDataFolderName
  execCmd '绑定网关' '下载' '已绑定网关的桶下载已绑定网关的文件夹' 'gcscmd get cs://'$bucketName' --name '$objectName 'get cs://'$bucketName' --name '$objectName ''
  echo '2、数据清理'
  rm -rf $testRootDataFolderName
  echo '绑定网关 => 下载 => 已绑定网关的桶下载已绑定网关的文件夹 => gcscmd get cs://bucket-bind-gateway --name test_folder_bind_gateway end'
  echo ''

  echo '绑定网关 => 下载 => 已绑定网关的桶下载已绑定网关的car文件 => gcscmd get cs://bucket-bind-gateway --name test_car_file_bind_gateway start'
  echo '数据准备'
  echo '1、设置对象名称，手工绑定网关'
  testRootDataFolderName="test_car_file_bind_gateway"
  #echo $testRootDataFolderName
  #carFilename=$testRootDataFolderName'.car'
  #objectName=$carFilename
  objectName=$testRootDataFolderName
  execCmd '绑定网关' '下载' '已绑定网关的桶下载已绑定网关的car文件' 'gcscmd get cs://'$bucketName' --name '$objectName 'get cs://'$bucketName' --name '$objectName ''
  echo '2、数据清理'
  rm -rf $testRootDataFolderName
  echo '绑定网关 => 下载 => 已绑定网关的桶下载已绑定网关的car文件 => gcscmd get cs://bucket-bind-gateway --name test_car_file_bind_gateway end'
  echo ''

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 绑定网关 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo ''
}

execCmd() {
  testModule=$1
  testFunction=$2
  testCase=$3
  testDescription=$4
  testCmd=$5
  testExpectation=$6
  testFail=$7

  echo $testModule"=>"$testFunction"=>"$testCase"=>"$testDescription
  cmdStr=$cmdPath' '$testCmd
  echo 'executing '$cmdStr
  eval $cmdStr

  echo ''
  if [ $? -eq 0 ]; then
    echo -e "\033[32mSuccess: $cmdStr test pass.\033[0m"
  else
    echo -e "\033[31mFailure: $cmdStr test fail. \033[0m"
    estatus=$(($etatus + 1))
  fi
  echo ""
}

execCmdFail() {
  testModule=$1
  testFunction=$2
  testCase=$3
  testDescription=$4
  testCmd=$5
  testExpectation=$6
  testFail=$7

  echo $testModule"=>"$testFunction"=>"$testCase"=>"$testDescription
  cmdStr=$cmdPath' '$testCmd
  echo 'executing '$cmdStr
  eval $cmdStr

  exitCode=$?
  echo ''
  if [ $exitCode -eq 0 ]; then
    echo -e "\033[31mFailure: $cmdStr test should be prompt error message. \033[0m"
    estatus=$(($etatus + 1))
  else
    echo -e "\033[32mSuccess: $cmdStr test pass, return error message and exit code is not equal zero. \033[0m"
  #  estatus=$?
  fi

  echo "exitcode:"$exitCode
  echo ""
}

echo "===========================Chainstorage cli Test start=========================="
echo ''

testCases

echo "===========================Chainstorage cli Test end============================="

echo "Test status code:"$estatus
exit $estatus
