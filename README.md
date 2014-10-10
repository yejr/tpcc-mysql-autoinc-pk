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

3、开始测试<br />
3.1 利用tpcc_load初始化测试数据，用法和原先的一样<br />
usage: tpcc_load [server] [DB] [user] [pass] [warehouse]<br />

3.2 利用tpcc_start开始测试，用法也和原先的一样<br />

3.3 自动化测试脚本<br />
根据各自的测试环境，调整 run_tpcc.sh 脚本里的相应参数，运行该脚本可进行自动化测试。<br />

关于tpcc-mysql的详细用法，可参考文章：<br />
1、TPCC-MySQL使用手册：http://imysql.com/2012/08/04/tpcc-for-mysql-manual.html
<br />

最后
=======
可以和percona官方分支版本进行对比测试，看看二者的TpmC结果相差多少。<br />
有任何问题请联系我。<br />

About yejr
=======
叶金荣（常用ID：<strong>yejr</strong>）早期混迹于linuxforum、linuxsir等社区，后来转移到chinaunix。2006年建站至今，差不多是国内最早的MySQL技术博客。

从事过LAMP开发，后成为专职MySQL DBA，现围绕运维领域打杂，擅长MySQL优化、数据库架构设计及对比基准压测。

目前仍以<strong>MySQL DBA</strong>自居，偶尔也会作为<strong>Consultant</strong>，2012年被提名成为ORACLE ACE(MySQL)，目前仍不遗余力推广MySQL。

和几位同行发起成立 <strong><a href="http://acmug.com/">ACMUG</a></strong> 以及 <strong><a href="http://www.zhdba.com/">中华数据库协会</a></strong>。

微信公众号：<strong><span style="color: #000000;"><a title="MySQL中文网微信公众号" href="http://weixin.sogou.com/weixin?query=MySQL%E4%B8%AD%E6%96%87%E7%BD%91&amp;_asf=www.sogou.com&amp;_ast=1412034599&amp;w=01019900&amp;p=40040100&amp;ie=utf8&amp;type=2&amp;sut=3805&amp;sst0=1412034598512&amp;lkt=5%2C1412034594859%2C1412034595433">MySQL中文网</a></span></strong>、微博：<strong><span style="color: #000000;"><a href="http://weibo.com/yejinrong">@叶金荣</a></span></strong>、QQ：<strong><a href="tencent://message/?uin=4700963&amp;Site=叶金荣&amp;Menu=yes">4700963</a></strong>

QQ群：<strong><a href="http://shang.qq.com/wpa/qunwpa?idkey=20035ccbe9967180cee2acf170029527c8638f962047ec49774f6b0fe978d265" target="_blank">125572178</a></strong>、<strong><a href="http://shang.qq.com/wpa/qunwpa?idkey=58a42571a4d9fffa338516723d1caec545af3d073438acb434f47ebbb7b2ba54" target="_blank">272675472</a></strong>

邮箱：<a href="mailto:imysql@gmail.com?subject=关于MySQL技术咨询">imysql@gmail.com</a>

搜索引擎中的我：<a title="搜素引擎中的我：谷歌Google" href="https://www.google.com.hk/search?q=MySQL+叶金荣&amp;oq=MySQL+叶金荣" target="_blank">谷歌Google</a>、<a title="搜素引擎中的我：360搜索" href="http://www.so.com/s?q=MySQL+叶金荣" target="_blank">360搜索</a>、<a title="搜素引擎中的我：百度" href="http://www.baidu.com/#wd=MySQL+叶金荣" target="_blank">百度</a>、<a title="搜素引擎中的我：搜狗" href="http://www.sogou.com/web?query=MySQL+叶金荣" target="_blank">搜狗</a>。
