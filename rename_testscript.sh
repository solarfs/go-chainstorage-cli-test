#!/bin/bash

estatus=0

cmdPath='./gcscmd'

testCases() {

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 重命名对象 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '重命名对象 => 使用对象名 => 替换的文件无冲突 => gcscmd rn cs://bbb --name Tarkov.mp4 --rename aaa.mp4 start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-rename-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=10240 count=1024
  $cmdPath put $testDataFileName cs://$bucketName
  # 设置对象名称
  objectName=$testDataFileName
  #  rename=$objectName"_renamed"
  rename=$(echo ${objectName/.dat/_renamed.dat})
  execCmd '重命名对象' '使用对象名' '替换的文件无冲突' 'gcscmd rn cs://'$bucketName' --name '$objectName' --rename '$rename 'rn cs://'$bucketName' --name '$objectName' --rename '$rename ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  echo '重命名对象 => 使用对象名 => 替换的文件无冲突 => gcscmd rn cs://bbb --name Tarkov.mp4 --rename aaa.mp4 end'
  echo ''

  echo '重命名对象 => 使用对象名 => 替换的文件有冲突-有force， => gcscmd rn cs://bbb --name Tarkov.mp4 --rename aaa.mp4 --force start'
  echo '数据准备'
  echo '1、添加对象1，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=10240 count=1024
  $cmdPath put $testDataFileName cs://$bucketName
  echo '2、添加对象2，5MB'
  testDataFileName2="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName2 bs=5120 count=1024
  $cmdPath put $testDataFileName2 cs://$bucketName
  # 设置对象名称
  objectName=$testDataFileName
  rename=$testDataFileName2
  echo '重命名后，应仅存名称为testDataFileName2大小为10MB的对象，被覆盖的对象逻辑删除'
  execCmd '重命名对象' '使用对象名' '替换的文件有冲突-有force' 'gcscmd rn cs://'$bucketName' --name '$objectName' --rename '$rename' --force' 'rn cs://'$bucketName' --name '$objectName' --rename '$rename' --force' ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  rm -rf $testDataFileName2
  echo '重命名对象 => 使用对象名 => 替换的文件有冲突-有force， => gcscmd rn cs://bbb --name Tarkov.mp4 --rename aaa.mp4 --force end'
  echo ''

  echo '重命名对象 => 使用CID => cid单对象-无冲突 => gcscmd rn cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo --rename aaa.mp4 start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=10240 count=1024
  resp=$($cmdPath put $testDataFileName cs://$bucketName)
  echo '2、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  # 设置对象名称
  rename=$testDataFileName"_renamed"
  execCmd '重命名对象' '使用CID' 'cid单对象-无冲突' 'gcscmd rn cs://'$bucketName' --cid '$cid' --rename '$rename 'rn cs://'$bucketName' --cid '$cid' --rename '$rename ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  echo '重命名对象 => 使用CID => cid单对象-无冲突 => gcscmd rn cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo --rename aaa.mp4 end'
  echo ''

  echo '重命名对象 => 使用CID => cid多对象-无冲突（是否分此情况）start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=10240 count=1024
  $cmdPath put $testDataFileName cs://$bucketName
  echo '2、复制对象，10MB'
  testDataFileName2="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName2
  cp $testDataFileName $testDataFileName2
  resp=$($cmdPath put $testDataFileName2 cs://$bucketName)
  echo '3、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  execCmdFail '重命名对象' '使用CID' 'cid多对象-无冲突（是否分此情况）' 'gcscmd rn cs://'$bucketName' --cid '$cid' --rename '$rename 'rn cs://'$bucketName' --cid '$cid' --rename '$rename ''
  echo '4、数据清理'
  rm -rf $testDataFileName
  rm -rf $testDataFileName2
  echo '重命名对象 => 使用CID => cid多对象-无冲突（是否分此情况）end'
  echo ''

  echo '重命名对象测试数据清理'
  $cmdPath rb cs://$bucketName --force
  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 重命名对象 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
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

  #  echo $testModule"=>"$testFunction"=>"$testCase"=>"$testDescription
  cmdStr=$cmdPath' '$testCmd
  echo 'executing '$cmdStr
  eval $cmdStr

  exitCode=$?
  echo ''
  if [ $exitCode -eq 0 ]; then
    echo -e "\033[32mSuccess: $cmdStr test pass. \033[0m"
  else
    echo -e "\033[31mFailure: $cmdStr test fail. \033[0m"
    estatus=$(($etatus + 1))
  fi

  echo "exitcode:"$exitCode
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

  #  echo $testModule"=>"$testFunction"=>"$testCase"=>"$testDescription
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
