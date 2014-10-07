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

环境初始化1 <br />
环境初始化2 <br />
