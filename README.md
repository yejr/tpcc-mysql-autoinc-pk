tpcc-mysql - A fork of percona tpcc-mysql
==========
简介
从 Percona tpcc-mysql 中派生二来, 主要修改有以下几点：
1、所有表都加上自增列做主键；
2、取消外键，仅保留普通索引；
3、降低tpcc测试过程中的输出频率，避免刷屏；
4、修改了表结构初始化DDL脚本以及load.c文件；

快速使用
环境初始化
