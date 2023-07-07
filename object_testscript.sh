#!/bin/bash

estatus=0

cmdPath='./gcscmd'

testCases() {

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 对象操作 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '对象操作 => 查看对象 => 桶内所有文件查询-有此桶 => gcscmd ls cs://bbb start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-object-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  execCmd '对象操作' '查看对象' '桶内所有文件查询-有此桶' 'gcscmd ls cs://'$bucketName 'ls cs://'$bucketName ''
  echo '2、数据清理'
  $cmdPath rb cs://$bucketName --force
  echo '对象操作 => 查看对象 => 桶内所有文件查询-有此桶 => gcscmd ls cs://bbb end'
  echo ''

  echo '对象操作 => 查看对象 => 桶内所有文件查询-无此桶 => gcscmd ls cs://bbb start'
  echo '此操作应给出错误提示'
  execCmdFail '对象操作' '查看对象' '桶内所有文件查询-无此桶' 'gcscmd ls cs://'$bucketName 'ls cs://'$bucketName ''
  echo '对象操作 => 查看对象 => 桶内所有文件查询-无此桶 => gcscmd ls cs://bbb end'
  echo ''

  echo '对象操作 => 查看对象 => 桶内对应 cid 查询-cid正确 => gcscmd ls cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-object-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1024
  resp=$($cmdPath put $testDataFileName cs://$bucketName)
  echo '3、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  execCmd '对象操作' '查看对象' '桶内对应 cid 查询-cid正确' 'gcscmd ls cs://'$bucketName' --cid '$cid 'ls cs://'$bucketName' --cid '$cid ''
  echo '4、数据清理'
  rm -rf $testDataFileName
  echo '对象操作 => 查看对象 => 桶内对应 cid 查询-cid正确 => gcscmd ls cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo end'
  echo ''

  echo '对象操作 => 查看对象 => 桶内对象名查询-对象名正确 => gcscmd ls cs://bbb --name Tarkov.mp4 start'
  echo '设置对象名称'
  objectName=$testDataFileName
  execCmd '对象操作' '查看对象' '桶内对象名查询-对象名正确' 'gcscmd ls cs://'$bucketName' --name '$objectName 'ls cs://'$bucketName' --name '$objectName ''
  echo '对象操作 => 查看对象 => 桶内对象名查询-对象名正确 => gcscmd ls cs://bbb --name Tarkov.mp4 end'
  echo ''

  echo '对象操作测试数据清理'
  $cmdPath rb cs://$bucketName --force
  #  rm -rf $testDataFileName

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 对象操作 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
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
