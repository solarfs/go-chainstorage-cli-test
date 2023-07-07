#!/bin/bash

estatus=0

cmdPath='./gcscmd'

testCases() {

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 帮助 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  #  # 帮助 => 帮助功能 => gcscmd -h [--help]
  #  execCmd '帮助' '帮助功能' '' 'gcscmd -h [--help]' '-h' ''
  #
  #  # 帮助 => Basic command => gcscmd ls --help
  #  execCmd '帮助' 'Basic command' '' 'gcscmd ls --help' 'ls --help' ''
  #
  #  # 帮助 => Basic command => gcscmd mb --help
  #  execCmd '帮助' 'Basic command' '' 'gcscmd mb --help' 'mb --help' ''
  #
  #  # 帮助 => Basic command => gcscmd rb --help
  #  execCmd '帮助' 'Basic command' '' 'gcscmd rb --help' 'rb --help' ''
  #
  #  # 帮助 => Basic command => gcscmd get --help
  #  execCmd '帮助' 'Basic command' '' 'gcscmd get --help' 'get --help' ''
  #
  #  # 帮助 => Basic command => gcscmd put --help
  #  execCmd '帮助' 'Basic command' '' 'gcscmd put --help' 'put --help' ''
  #
  #  # 帮助 => Basic command => gcscmd rm --help
  #  execCmd '帮助' 'Basic command' '' 'gcscmd rm --help' 'rm --help' ''
  #
  #  # 帮助 => Basic command => gcscmd rn --help
  #  execCmd '帮助' 'Basic command' '' 'gcscmd rn --help' 'rn --help' ''
  #
  #  # 帮助 => Basic command => gcscmd import --help
  #  execCmd '帮助' 'Basic command' '' 'gcscmd import --help' 'import --help' ''
  #
  #  # 帮助 => Tool Command => config => gcscmd config
  #  execCmd '帮助' 'Basic command' '' 'gcscmd config --help' 'config --help' ''
  #
  #  # 帮助 => Tool Command => version => gcscmd version
  #  execCmd '帮助' 'Basic command' '' 'gcscmd version --help' 'version --help' ''
  #
  #  # 帮助 => Tool Command => log => gcscmd log
  #  execCmd '帮助' 'Basic command' '' 'gcscmd log --help' 'log --help' ''

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 帮助 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo ''

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 桶操作 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  # todo: 数据准备，删除所有桶，还是切换APIKEY？
  echo '桶操作 => 列出桶对象 => 无桶 => gcscmd ls start'
  execCmd '桶操作' '列出桶对象' '无桶' 'gcscmd ls' 'ls' ''
  echo '桶操作 => 列出桶对象 => 无桶 => gcscmd ls end'
  echo ''

  echo '桶操作 => 创建桶 => 正常创建 => gcscmd mb cs://bbb start'
  echo '数据准备'
  echo '创建新桶'
  bucketName="bucket-create-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  execCmd '桶操作' '创建桶' '正常创建' 'gcscmd mb cs://'$bucketName 'mb cs://'$bucketName ''
  echo '桶操作 => 创建桶 => 正常创建 => gcscmd mb cs://bbb end'
  echo ''

  echo '桶操作 => 创建桶 => 非正常创建-桶名重复 => gcscmd mb cs://bbb start'
  echo '此操作应给出错误提示'
  execCmdFail '桶操作' '创建桶' '非正常创建-桶名重复' 'gcscmd mb cs://'$bucketName 'mb cs://'$bucketName ''
  echo '桶操作 => 创建桶 => 非正常创建-桶名重复 => gcscmd mb cs://bbb end'
  echo ''

  #  # todo: 测试意图？
  #  # 桶操作 => 创建桶 => 非正常创建-创建多个桶 => gcscmd mb cs://aaa
  #  execCmdFail '桶操作' '创建桶' '非正常创建-创建多个桶' 'gcscmd mb cs://'$bucketName 'mb cs://'$bucketName ''

  echo '桶操作 => 列出桶对象 => 有桶 => gcscmd ls start'
  # 返回对应bucketName桶数据
  execCmd '桶操作' '列出桶对象' '有桶' 'gcscmd ls' 'ls' ''
  echo '桶操作 => 列出桶对象 => 有桶 => gcscmd ls end'
  echo ''

  echo '桶操作 => 移除桶 => 正常删除-无数据删除 => gcscmd rb cs://bbb start'
  execCmd '桶操作' '移除桶' '正常删除-无数据删除' 'gcscmd rb cs://'$bucketName 'rb cs://'$bucketName ''
  echo '桶操作 => 移除桶 => 正常删除-无数据删除 => gcscmd rb cs://bbb end'
  echo ''

  echo '桶操作 => 移除桶 => 重复删除-继续删除已删除的桶 => gcscmd rb cs://bbb start'
  echo '此操作应给出错误提示'
  execCmdFail '桶操作' '移除桶' '重复删除-继续删除已删除的桶' 'gcscmd rb cs://'$bucketName 'rb cs://'$bucketName ''
  echo '桶操作 => 移除桶 => 重复删除-继续删除已删除的桶 => gcscmd rb cs://bbb end'
  echo ''

  echo '桶操作 => 移除桶 => 正常删除-有数据删除 => gcscmd rb cs://bbb start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-create-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  $cmdPath put $testDataFileName cs://$bucketName
  echo '此操作应给出错误提示'
  execCmdFail '桶操作' '移除桶' '正常删除-有数据删除' 'gcscmd rb cs://'$bucketName 'rb cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  echo '桶操作 => 移除桶 => 正常删除-有数据删除 => gcscmd rb cs://bbb end'
  echo ''

  echo '桶操作 => 移除桶 => 正常删除-有数据强制删除 => gcscmd rb cs://bbb --force start'
  execCmd '桶操作' '移除桶' '正常删除-有数据强制删除' 'gcscmd rb cs://'$bucketName' --force' 'rb cs://'$bucketName' --force' ''
  echo '桶操作 => 移除桶 => 正常删除-有数据强制删除 => gcscmd rb cs://bbb --force end'
  echo ''

  echo '桶操作 => 清空桶 => 正常清空-有数据清空 => gcscmd rm cs://bbb start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-create-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  $cmdPath put $testDataFileName cs://$bucketName
  echo '此操作应给出错误提示'
  execCmdFail '桶操作' '清空桶' '正常清空-有数据清空' 'gcscmd rm cs://'$bucketName 'rm cs://'$bucketName ''
  echo '桶操作 => 清空桶 => 正常清空-有数据清空 => gcscmd rm cs://bbb end'
  echo ''

  echo '桶操作测试数据清理'
  $cmdPath rb cs://$bucketName --force
  rm -rf $testDataFileName

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 桶操作 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo ''

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
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
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

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 对象上传 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '对象上传 => 上传文件-当前目录 => 在当前目录上传文件 => gcscmd put ./aaa.mp4 cs://bbb start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-upload-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  # 设置当前目录
  dataPath=''$testDataFileName
  execCmd '对象上传' '上传文件-当前目录' '在当前目录上传文件' 'gcscmd put '$dataPath' cs://'$bucketName 'put '$dataPath' cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  echo '对象上传 => 上传文件-当前目录 => 在当前目录上传文件 => gcscmd put ./aaa.mp4 cs://bbb end'
  echo ''

  echo '对象上传 => 上传文件-当前目录 => 绝对路径上传文件 => gcscmd put /home/pz/aaa.mp4 cs://bbb start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  # 设置绝对路径
  dataPath=$(pwd)'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1
  execCmd '对象上传' '上传文件-当前目录' '绝对路径上传文件' 'gcscmd put '$dataPath' cs://'$bucketName 'put '$dataPath' cs://'$bucketName ''
  echo '2、数据清理'
  rm -rf $dataPath
  echo '对象上传 => 上传文件-当前目录 => 绝对路径上传文件 => gcscmd put /home/pz/aaa.mp4 cs://bbb end'
  echo ''

  echo '对象上传 => 上传文件-当前目录 => 相对路径上传文件 => gcscmd put ../pz/aaa.mp4 cs://bbb start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  # 设置相对路径
  dataPath='tmp/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1
  execCmd '对象上传' '上传文件-当前目录' '相对路径上传文件' 'gcscmd put '$dataPath' cs://'$bucketName 'put '$dataPath' cs://'$bucketName ''
  echo '2、数据清理'
  rm -rf $dataPath
  echo '对象上传 => 上传文件-当前目录 => 相对路径上传文件 => gcscmd put ../pz/aaa.mp4 cs://bbb end'
  echo ''

  echo '对象上传 => 上传文件-当前目录 => 错误上传-任意方式上传到不存在的桶 => gcscmd put ./aaa.mp4 cs://不存在的桶名 start'
  echo '数据准备'
  echo '1、创建新桶'
  wrongBucketName="bucket-upload-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  # 设置当前目录
  dataPath=''$testDataFileName
  execCmdFail '对象上传' '上传文件-当前目录' '错误上传-任意方式上传到不存在的桶' 'gcscmd put '$dataPath' cs://'$wrongBucketName 'put '$dataPath' cs://'$wrongBucketName ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  echo '对象上传 => 上传文件-当前目录 => 错误上传-任意方式上传到不存在的桶 => gcscmd put ./aaa.mp4 cs://不存在的桶名 end'
  echo ''

  # 不考虑空目录的情况，若上传空目录会报错：Uploading folder is empty, or uploading data is invalid in the folder
  #  echo '对象上传 => 上传目录 => 正确上传目录-空目录上传 => gcscmd put ./aaaa cs://bbb start'
  #  echo '数据准备'
  #  # 1、添加目录
  #  testDataFolderName="testfolder_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #  #echo $testDataFolderName
  #  mkdir $testDataFolderName
  #  $cmdPath put $testDataFolderName cs://$bucketName
  #  # 设置对象名称
  #  dataPath=''$testDataFolderName
  #  execCmdFail '对象上传' '上传文件-当前目录' '正确上传目录-空目录上传' 'gcscmd put '$dataPath' cs://'$bucketName 'put '$dataPath' cs://'$bucketName ''
  #  echo '2、数据清理'
  #  rm -rf $dataPath
  #  echo '对象上传 => 上传目录 => 正确上传目录-空目录上传 => gcscmd put ./aaaa cs://bbb end'
  #  echo ''

  echo '对象上传 => 上传目录 => 正确上传目录-目录有文件上传 => gcscmd put ./aaaa cs://bbb start'
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
  dd if=/dev/urandom of=$dataPath bs=1024 count=1
  execCmd '对象上传' '上传文件-当前目录' '正确上传目录-目录有文件上传' 'gcscmd put '$testDataFolderName' cs://'$bucketName 'put '$testDataFolderName' cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $testDataFolderName
  echo '对象上传 => 上传目录 => 正确上传目录-目录有文件上传 => gcscmd put ./aaaa cs://bbb end'
  echo ''

  # 目前暂时不使用--carfile参数
  #  # 对象上传 => 上传carfile => 正确上传car文件 => gcscmd put ./aaa.car cs://bbb --carfile
  #  echo '数据准备'
  #  echo '1、添加对象，10MB'
  #  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #  #echo $testDataFileName
  #  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  #  # 2、生成CAR文件(测试环境需要安装car命令行程序)
  #  carFilename=$(echo ${testDataFileName/.dat/.car})
  #  car c --version 1 -f $carFilename $testDataFileName
  #  # 设置当前目录
  #  dataPath=''$carFilename
  #  execCmd '对象上传' '上传carfile' '正确上传car文件' 'gcscmd put '$dataPath' cs://'$bucketName' --carfile' 'put '$dataPath' cs://'$bucketName' --carfile' ''
  #  #  echo '3、数据清理'
  #  #  rm -rf $testDataFileName
  #  #  rm -rf $dataPath
  #
  #  # 对象上传 => 上传carfile => 重复上传-上传已经存在的car文件 => gcscmd put ./aaa.car cs://bbb --carfile
  #  execCmd '对象上传' '上传carfile' '重复上传-上传已经存在的car文件' 'gcscmd put '$dataPath' cs://'$bucketName' --carfile' 'put '$dataPath' cs://'$bucketName' --carfile' ''

  # 对象上传测试数据清理
  $cmdPath rb cs://$bucketName --force
  #  rm -rf $testDataFileName
  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 对象上传 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo ''

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 导入car文件 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '导入 car 文件 => 正确导入car文件 => 当前目录导入 => gcscmd import ./aaa.car cs://bbb start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-import-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  echo '3、生成CAR文件(测试环境需要安装car命令行程序)'
  carFilename=$(echo ${testDataFileName/.dat/.car})
  car c --version 1 -f $carFilename $testDataFileName
  # 设置当前目录
  dataPath=''$carFilename
  execCmd '导入 car 文件' '正确导入car文件' '当前目录导入' 'gcscmd import '$dataPath' cs://'$bucketName 'import '$dataPath' cs://'$bucketName ''
  echo '4、数据清理'
  rm -rf $testDataFileName
  rm -rf $dataPath
  echo '导入 car 文件 => 正确导入car文件 => 当前目录导入 => gcscmd import ./aaa.car cs://bbb end'
  echo ''

  echo '导入 car 文件 => 正确导入car文件 => 绝对路径导入 => gcscmd import /home/pz/aaa.car cs://bbb start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  # 设置绝对路径
  dataPath=$(pwd)'/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1
  echo '2、生成CAR文件(测试环境需要安装car命令行程序)'
  carDataPath=$(echo ${dataPath/.dat/.car})
  car c --version 1 -f $carDataPath $dataPath
  execCmd '导入 car 文件' '正确导入car文件' '绝对路径导入' 'gcscmd import '$carDataPath' cs://'$bucketName 'import '$carDataPath' cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $dataPath
  rm -rf $carDataPath
  echo '导入 car 文件 => 正确导入car文件 => 绝对路径导入 => gcscmd import /home/pz/aaa.car cs://bbb end'
  echo ''

  echo '导入 car 文件 => 正确导入car文件 => 相对路径 => gcscmd import ../pz/aaa.car cs://bbb start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  # 设置相对路径
  dataPath='tmp/'$testDataFileName
  dd if=/dev/urandom of=$dataPath bs=1024 count=1
  echo '2、生成CAR文件(测试环境需要安装car命令行程序)'
  carDataPath=$(echo ${dataPath/.dat/.car})
  car c --version 1 -f $carDataPath $dataPath
  execCmd '导入 car 文件' '正确导入car文件' '相对路径' 'gcscmd import '$carDataPath' cs://'$bucketName 'import '$carDataPath' cs://'$bucketName ''
  echo '3、数据清理'
  rm -rf $dataPath
  rm -rf $carDataPath
  echo '导入 car 文件 => 正确导入car文件 => 相对路径 => gcscmd import ../pz/aaa.car cs://bbb end'
  echo ''

  echo '导入car文件测试数据清理'
  $cmdPath rb cs://$bucketName --force
  #  rm -rf $testDataFileName
  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 导入car文件 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo ''

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 下载对象 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '下载对象 => 根据cid下载 => cid正确下载 => gcscmd get cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-download-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  resp=$($cmdPath put $testDataFileName cs://$bucketName)
  echo '3、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  echo '4、清理上传数据'
  rm -rf $testDataFileName
  execCmd '下载对象' '根据cid下载' 'cid正确下载' 'gcscmd get cs://'$bucketName' --cid '$cid 'get cs://'$bucketName' --cid '$cid ''
  echo '5、数据清理'
  rm -rf $testDataFileName
  echo '下载对象 => 根据cid下载 => cid正确下载 => gcscmd get cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo end'
  echo ''

  echo '下载对象 => 根据对象名下载 => 对象名正确下载 => gcscmd get cs://bbb --name Tarkov.mp4 start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  resp=$($cmdPath put $testDataFileName cs://$bucketName)
  echo '2、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  echo '3、清理上传数据'
  rm -rf $testDataFileName
  # 设置对象名称
  objectName=$testDataFileName
  execCmd '下载对象' '根据对象名下载' '对象名正确下载' 'gcscmd get cs://'$bucketName' --name '$objectName 'get cs://'$bucketName' --name '$objectName ''
  echo '4、数据清理'
  rm -rf $testDataFileName
  echo '下载对象 => 根据对象名下载 => 对象名正确下载 => gcscmd get cs://bbb --name Tarkov.mp4 end'
  echo ''

  echo '下载对象目录 => 根据cid下载 => cid正确下载 => gcscmd get cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo start'
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

  execCmd '下载对象目录' '根据cid下载' 'cid正确下载' 'gcscmd get cs://'$bucketName' --cid '$cid 'get cs://'$bucketName' --cid '$cid ''
  echo '5、数据清理'
  rm -rf $testRootDataFolderName

  echo '下载对象目录 => 根据cid下载 => cid正确下载 => gcscmd get cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo end'
  echo ''

  echo '下载对象目录 => 根据对象名下载 => 对象名正确下载 => gcscmd get cs://bbb --name folder start'
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
  # 设置对象名称
  objectName=$testRootDataFolderName
  execCmd '下载对象目录' '根据对象名下载' '对象名正确下载' 'gcscmd get cs://'$bucketName' --name '$objectName 'get cs://'$bucketName' --name '$objectName ''
  echo '5、数据清理'
  rm -rf $testRootDataFolderName

  echo '下载对象目录 => 根据对象名下载 => 对象名正确下载 => gcscmd get cs://bbb --name folder end'
  echo ''

  echo '下载对象测试数据清理'
  $cmdPath rb cs://$bucketName --force
  #  rm -rf $testDataFileName
  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 下载对象 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo ''

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 导出car文件 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '导出 car 文件 => 根据cid下载 => cid正确下载 => gcscmd get cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-export-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加目录'
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
  echo '3、添加对象'
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

  echo '4、生成CAR文件(测试环境需要安装car命令行程序)'
  carFilename=$testRootDataFolderName'.car'
  car c --version 1 -f $carFilename $testRootDataFolderName
  dataPath=$carFilename
  # import car file
  resp=$($cmdPath import $dataPath cs://$bucketName)
  #  echo $resp
  echo '5、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  echo '6、数据清理'
  rm -rf $testRootDataFolderName
  rm -rf $dataPath

  execCmd '导出对象' '根据cid下载' 'cid正确下载' 'gcscmd get cs://'$bucketName' --cid '$cid 'get cs://'$bucketName' --cid '$cid ''
  echo '7、数据清理'
  rm -rf $testRootDataFolderName

  echo '导出 car 文件 => 根据cid下载 => cid正确下载 => gcscmd get cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo end'
  echo ''

  echo '导出 car 文件 => 根据对象名下载 => 对象名正确下载 => gcscmd get cs://bbb --name folder start'
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
  execCmd '导出对象' '根据对象名下载' '对象名正确下载' 'gcscmd get cs://'$bucketName' --name '$objectName 'get cs://'$bucketName' --name '$objectName ''
  echo '6、数据清理'
  rm -rf $testRootDataFolderName

  echo '导出 car 文件 => 根据对象名下载 => 对象名正确下载 => gcscmd get cs://bbb --name folder end'
  echo ''

  echo '导出car文件测试数据清理'
  $cmdPath rb cs://$bucketName --force
  #  rm -rf $testDataFileName
  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 导出car文件 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo ''

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 删除对象 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '删除对象 => 清空桶 => 有文件清空桶 => gcscmd rm cs://bbb --force start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-delete-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  $cmdPath put $testDataFileName cs://$bucketName
  execCmd '删除对象' '清空桶' '有文件清空桶' 'gcscmd rm cs://'$bucketName' --force' 'rm cs://'$bucketName' --force' ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  echo '删除对象 => 清空桶 => 有文件清空桶 => gcscmd rm cs://bbb --force end'
  echo ''

  echo '删除对象 => 使用对象名删除单文件 => 正确删除 => gcscmd rm cs://bbb --name Tarkov.mp4 start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  $cmdPath put $testDataFileName cs://$bucketName
  # 设置对象名称
  objectName=$testDataFileName
  execCmd '删除对象' '使用对象名删除单文件' '正确删除' 'gcscmd rm cs://'$bucketName' --name '$objectName 'rm cs://'$bucketName' --name '$objectName ''
  echo '2、数据清理'
  rm -rf $testDataFileName
  echo '删除对象 => 使用对象名删除单文件 => 正确删除 => gcscmd rm cs://bbb --name Tarkov.mp4 end'
  echo ''

  echo '删除对象 => 使用模糊查询删除对象 => 正常模糊删除 => gcscmd rm cs://bbb --name .mp4 --force start'
  echo '1、添加对象1，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  $cmdPath put $testDataFileName cs://$bucketName
  echo '2、添加对象2，5MB'
  testDataFileName2="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName2 bs=512 count=1
  $cmdPath put $testDataFileName2 cs://$bucketName
  # 设置对象名称
  objectName="testdata"
  execCmd '删除对象' '使用模糊查询删除对象' '正常模糊删除' 'gcscmd rm cs://'$bucketName' --name '$objectName' --force' 'rm cs://'$bucketName' --name '$objectName' --force' ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  rm -rf $testDataFileName2
  echo '删除对象 => 使用模糊查询删除对象 => 正常模糊删除 => gcscmd rm cs://bbb --name .mp4 --force end'
  echo ''

  # 不考虑空目录的情况，若上传空目录会报错：Uploading folder is empty, or uploading data is invalid in the folder
  #  echo '删除对象 => 使用对象名删除单目录 => 正确删除-目录中无文件 => gcscmd rm cs://bbb --name aaa start'
  #  echo '1、添加对象'
  #  testDataFolderName="testfolder_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  #  #echo $testDataFolderName
  #  mkdir $testDataFolderName
  #  $cmdPath put $testDataFolderName cs://$bucketName
  #  # 设置对象名称
  #  objectName=$testDataFolderName
  #  execCmd '删除对象' '使用对象名删除单目录' '正确删除-目录中无文件' 'gcscmd rm cs://'$bucketName' --name '$objectName 'rm cs://'$bucketName' --name '$objectName ''
  #  echo '2、数据清理'
  #  rm -rf $testDataFolderName
  #  echo '删除对象 => 使用对象名删除单目录 => 正确删除-目录中无文件 => gcscmd rm cs://bbb --name aaa end'
  #  echo ''

  echo '删除对象 => 使用CID删除单对象 => 正确删除-对应的桶中有此CID删除 => gcscmd rm cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  resp=$($cmdPath put $testDataFileName cs://$bucketName)
  echo '2、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  execCmd '删除对象' '使用CID删除单对象' '正确删除-对应的桶中有此CID删除' 'gcscmd rm cs://'$bucketName' --cid '$cid 'rm cs://'$bucketName' --cid '$cid ''
  echo '3、数据清理'
  rm -rf $testDataFileName
  echo '删除对象 => 使用CID删除单对象 => 正确删除-对应的桶中有此CID删除 => gcscmd rm cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo end'
  echo ''

  echo '删除对象 => 使用 CID 删除多个对象(命中多个对象时加) => 一个cid有多个对象 => gcscmd rm cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo --force start'
  echo '数据准备'
  echo '1、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  $cmdPath put $testDataFileName cs://$bucketName
  echo '2、复制对象，10MB'
  testDataFileName2="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName2
  cp $testDataFileName $testDataFileName2
  resp=$($cmdPath put $testDataFileName2 cs://$bucketName)
  echo '3、获取CID'
  cid=$(echo "$resp" | awk '/CID:/{print $2}')
  execCmd '删除对象' '使用 CID 删除多个对象(命中多个对象时加)' '一个cid有多个对象' 'gcscmd rm cs://'$bucketName' --cid '$cid' --force' 'rm cs://'$bucketName' --cid '$cid' --force' ''
  echo '4、数据清理'
  rm -rf $testDataFileName
  rm -rf $testDataFileName2
  echo '删除对象 => 使用 CID 删除多个对象(命中多个对象时加) => 一个cid有多个对象 => gcscmd rm cs://bbb --cid QmWgnG7pPjG31w328hZyALQ2BgW5aQrZyKpT47jVpn8CNo --force end'
  echo ''

  echo '删除对象测试数据清理'
  $cmdPath rb cs://$bucketName --force
  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 删除对象 结束 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo ''

  echo "_/_/_/_/_/_/_/_/_/_/_/_/_/ 重命名对象 开始 _/_/_/_/_/_/_/_/_/_/_/_/_/"
  echo '重命名对象 => 使用对象名 => 替换的文件无冲突 => gcscmd rn cs://bbb --name Tarkov.mp4 --rename aaa.mp4 start'
  echo '数据准备'
  echo '1、创建新桶'
  bucketName="bucket-rename-"$(date "+%Y%m%d%H%M%S")"-"$RANDOM
  $cmdPath mb cs://$bucketName
  echo '2、添加对象，10MB'
  testDataFileName="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
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
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
  $cmdPath put $testDataFileName cs://$bucketName
  echo '2、添加对象2，5MB'
  testDataFileName2="testdata_"$(date "+%Y%m%d%H%M%S")"-"$RANDOM".dat"
  #echo $testDataFileName
  dd if=/dev/urandom of=$testDataFileName2 bs=512 count=1
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
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
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
  dd if=/dev/urandom of=$testDataFileName bs=1024 count=1
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
