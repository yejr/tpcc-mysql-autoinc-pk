tpcc-mysql - A fork of percona tpcc-mysql
=============

简介
=============

从 Percona tpcc-mysql 中派生二来, 主要修改有以下几点：<br />
1、所有表都加上自增列做主键；<br />
2、取消外键，仅保留普通索引；<br />
3、降低tpcc测试过程中的输出频率，避免刷屏；<br />
4、修改了表结构初始化DDL脚本以及load.c文件；<br />

快速使用
==========

1、环境初始化 <br />
1.1 创建tpcc数据库
mysqladmin -S path/mysql.sock -u user -p passwd create tpcc

1.2 初始化表结构
mysql -S path/mysql.sock -u user -p passwd -f tpcc < create_table-aidpk.sql

2、编译tpcc-mysql
2.1 进入tpcc-mysql源码目录，执行 make，编译过程无报错即可
cd path/tpcc-mysql
cd src
make

编译完成后，会在上一级目录下生成 tpcc_load、tpcc_start这2个可执行文件。

3、开始测试 <br />
3.1 利用tpcc_load初始化测试数据，用法和原先的一样
usage: tpcc_load [server] [DB] [user] [pass] [warehouse]

3.2 利用tpcc_start开始测试，用法也和原先的一样

关于tpcc-mysql的详细用法，可参考文章：http://imysql.com/2012/08/04/tpcc-for-mysql-manual.html
