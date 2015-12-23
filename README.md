# tpcc-mysql - A fork of percona tpcc-mysql
---
基于Percona tpcc-mysql的衍生版本，增加了自增列主键，去掉外键等特性。


# 为什么有这个分支
tpcc-mysql是percona基于TPC-C(下面简写成TPCC)衍生出来的产品，专用于MySQL基准测试。

它生成的测试表我认为有2个问题：
1、没有自增列作为主键。如果仅作为基准测试问题不大，但和我们实际生产中的设计模式可能有一定区别，相信大多数人还是习惯使用自增列作为主键的，如果你没这个习惯，那么可以忽略本文了；
2、使用外键。个人认为MySQL对外键支持并不是太好，并且一定程度上影响并发性能，因此建议取消外键，仅保留一般的索引。

主要原因在于InnoDB引擎的特性，因为以下几点：
* InnoDB是索引组织表，更进一步说，是聚集索引组织表；
* 索引组织表的特点是该表数据存储顺序和索引的逻辑顺序完全一致；
* InnoDB默认优先选择主键作为聚集索引，否则会选择第一个定义为NOT NULL的唯一索引，若也没有的话则选择InnoDB引擎内置的rowid作为聚集索引；
* 因此最好要有显式声明一个主键，而且该主键具备顺序特性，所以选择自增列作为主键最为合适；
* 如果没有自增列做主键，那么写入的数据有可能是在物理及逻辑上都是随机离散存储的，相对更容易导致行锁等待或者死锁的问题。

基于上面几点，才有了这个分支版本。
因为只是增加了一个没有业务用途的自增主键列，可以放心使用，正常情况下，不会影响tpcc压测结果的相对准确性。
我微调了下tpcc-mysql的源码，主要改动有下面几个地方：
1、所有表都加上自增列做主键；
2、取消外键，仅保留普通索引；
3、降低tpcc测试过程中的输出频率，避免刷屏；
4、修改了表结构初始化DDL脚本以及load.c文件；

利用该分支版本进行tpcc压力测试的结果表明，有自增列主键时，**其TpmC相比没有自增列主键约提升了10%**，还是比较可观的。


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

# 关于作者
* 叶金荣
* CMUG副主席
* Oracle MySQL ACE
* 国内最早的MySQL推广者之一
* 2006年创办首个MySQL中文网站 http://imysql.com	
* 10余年MySQL经验，擅长MySQL性能优化、架构设计、故障排查


微信公众号：<strong><span style="color: #000000;"><a title="MySQL中文网微信公众号" href="http://weixin.sogou.com/weixin?query=MySQL%E4%B8%AD%E6%96%87%E7%BD%91&amp;_asf=www.sogou.com&amp;_ast=1412034599&amp;w=01019900&amp;p=40040100&amp;ie=utf8&amp;type=2&amp;sut=3805&amp;sst0=1412034598512&amp;lkt=5%2C1412034594859%2C1412034595433">MySQL中文网</a></span></strong>、微博：<strong><span style="color: #000000;"><a href="http://weibo.com/yejinrong">@叶金荣</a></span></strong>、QQ：<strong><a href="tencent://message/?uin=4700963&amp;Site=叶金荣&amp;Menu=yes">4700963</a></strong>

QQ群：<strong><a href="http://shang.qq.com/wpa/qunwpa?idkey=20035ccbe9967180cee2acf170029527c8638f962047ec49774f6b0fe978d265" target="_blank">125572178</a></strong>、<strong><a href="http://shang.qq.com/wpa/qunwpa?idkey=58a42571a4d9fffa338516723d1caec545af3d073438acb434f47ebbb7b2ba54" target="_blank">272675472</a></strong>

邮箱：<a href="mailto:imysql@gmail.com?subject=关于MySQL技术咨询">imysql@gmail.com</a>

搜索引擎中的我：<a title="搜素引擎中的我：谷歌Google" href="https://www.google.com.hk/search?q=MySQL+叶金荣&amp;oq=MySQL+叶金荣" target="_blank">谷歌Google</a>、<a title="搜素引擎中的我：360搜索" href="http://www.so.com/s?q=MySQL+叶金荣" target="_blank">360搜索</a>、<a title="搜素引擎中的我：百度" href="http://www.baidu.com/#wd=MySQL+叶金荣" target="_blank">百度</a>、<a title="搜素引擎中的我：搜狗" href="http://www.sogou.com/web?query=MySQL+叶金荣" target="_blank">搜狗</a>。
