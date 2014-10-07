tpcc-mysql - A fork of percona tpcc-mysql
=============

简介
=============
tpcc-mysql是percona基于TPC-C(下面简写成TPCC)衍生出来的产品，专用于MySQL基准测试。<br />
它生成的测试表我认为有2个问题：<br />
1、没有自增列作为主键。如果仅作为基准测试问题不大，但和我们实际生产中的设计模式可能有一定区别，相信大多数人还是习惯使用自增列作为主键的，如果你没这个习惯，那么可以忽略本文了；<br />
2、使用外键。个人认为MySQL对外键支持并不是太好，并且一定程度上影响并发性能，因此建议取消外键，仅保留一般的索引。<br />
<br />
基于上面这2点，我微调了下tpcc-mysql的源码，主要改动有下面几个地方：<br />
1、所有表都加上自增列做主键；<br />
2、取消外键，仅保留普通索引；<br />
3、降低tpcc测试过程中的输出频率，避免刷屏；<br />
4、修改了表结构初始化DDL脚本以及load.c文件；<br />
<br />
利用该分支版本进行tpcc压力测试的结果表明，有自增列主键时，其TpmC相比没有自增列主键约提升了10%，还是比较可观的。<br />


快速使用
==========

1、环境初始化<br />
1.1 创建tpcc数据库<br />
mysqladmin -S path/mysql.sock -u user -p passwd create tpcc<br />
<br />
1.2 初始化表结构<br />
mysql -S path/mysql.sock -u user -p passwd -f tpcc < create_table-aidpk.sql<br />
<br />
2、编译tpcc-mysql<br />
2.1 进入tpcc-mysql源码目录，执行 make，编译过程无报错即可<br />
cd path/tpcc-mysql<br />
cd src<br />
make<br />
<br />
编译完成后，会在上一级目录下生成 tpcc_load、tpcc_start这2个可执行文件。<br />
<br />
3、开始测试 <br />
3.1 利用tpcc_load初始化测试数据，用法和原先的一样<br />
usage: tpcc_load [server] [DB] [user] [pass] [warehouse]<br />
<br />
3.2 利用tpcc_start开始测试，用法也和原先的一样<br />
<br />
关于tpcc-mysql的详细用法，可参考文章：http://imysql.com/2012/08/04/tpcc-for-mysql-manual.html
<br />
