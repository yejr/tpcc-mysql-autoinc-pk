--
-- tpcc DDL script
-- created by yejr(imysql@imysql.com, http://imysql.com, QQ: 4700963, QQ群: 125572178、272675472)
-- MySQL中文网: http://imysql.com
-- ## 叶金荣(yejr)
-- ## 小叶子她爹,装过Linux,写过PHP,优化过MySQL,目前围绕运维领域打杂
-- ## 新浪微博: @叶金荣, 微信公众号: MYSQL中文网
-- ## QQ群: 125572178、272675472
-- 

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `aid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `c_id` int(11) NOT NULL,
  `c_d_id` tinyint(4) NOT NULL,
  `c_w_id` smallint(6) NOT NULL,
  `c_first` varchar(16) NOT NULL,
  `c_middle` char(2) NOT NULL,
  `c_last` varchar(16) NOT NULL,
  `c_street_1` varchar(20) NOT NULL,
  `c_street_2` varchar(20) NOT NULL,
  `c_city` varchar(20) NOT NULL,
  `c_state` char(2) NOT NULL,
  `c_zip` char(9) NOT NULL,
  `c_phone` char(16) NOT NULL,
  `c_since` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `c_credit` char(2) NOT NULL,
  `c_credit_lim` bigint(20) NOT NULL,
  `c_discount` decimal(4,2) NOT NULL,
  `c_balance` decimal(12,2) NOT NULL,
  `c_ytd_payment` decimal(12,2) NOT NULL,
  `c_payment_cnt` smallint(6) NOT NULL,
  `c_delivery_cnt` smallint(6) NOT NULL,
  `c_data` text NOT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `c_w_id` (`c_w_id`,`c_d_id`,`c_id`),
  KEY `idx_customer` (`c_w_id`,`c_d_id`,`c_last`,`c_first`)
) ENGINE=InnoDB;

--
-- Table structure for table `district`
--

DROP TABLE IF EXISTS `district`;
CREATE TABLE `district` (
  `aid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `d_id` tinyint(4) NOT NULL,
  `d_w_id` smallint(6) NOT NULL,
  `d_name` varchar(10) NOT NULL,
  `d_street_1` varchar(20) NOT NULL,
  `d_street_2` varchar(20) NOT NULL,
  `d_city` varchar(20) NOT NULL,
  `d_state` char(2) NOT NULL,
  `d_zip` char(9) NOT NULL,
  `d_tax` decimal(4,2) NOT NULL,
  `d_ytd` decimal(12,2) NOT NULL,
  `d_next_o_id` int(11) NOT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `d_w_id` (`d_w_id`,`d_id`)
) ENGINE=InnoDB;

--
-- Table structure for table `history`
--

DROP TABLE IF EXISTS `history`;
CREATE TABLE `history` (
  `aid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `h_c_id` int(11) NOT NULL,
  `h_c_d_id` tinyint(4) NOT NULL,
  `h_c_w_id` smallint(6) NOT NULL,
  `h_d_id` tinyint(4) NOT NULL,
  `h_w_id` smallint(6) NOT NULL,
  `h_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `h_amount` decimal(6,2) NOT NULL,
  `h_data` varchar(24) NOT NULL,
  PRIMARY KEY (`aid`),
  KEY `idx_history_1` (`h_c_w_id`,`h_c_d_id`,`h_c_id`),
  KEY `idx_history_2` (`h_w_id`,`h_d_id`)
) ENGINE=InnoDB;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `aid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `i_id` int(11) NOT NULL,
  `i_im_id` int(11) NOT NULL,
  `i_name` varchar(24) NOT NULL,
  `i_price` decimal(5,2) NOT NULL,
  `i_data` varchar(50) NOT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `i_id` (`i_id`)
) ENGINE=InnoDB;

--
-- Table structure for table `new_orders`
--

DROP TABLE IF EXISTS `new_orders`;
CREATE TABLE `new_orders` (
  `aid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `no_o_id` int(11) NOT NULL,
  `no_d_id` tinyint(4) NOT NULL,
  `no_w_id` smallint(6) NOT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `no_w_id` (`no_w_id`,`no_d_id`,`no_o_id`)
) ENGINE=InnoDB;

--
-- Table structure for table `order_line`
--

DROP TABLE IF EXISTS `order_line`;
CREATE TABLE `order_line` (
  `aid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `ol_o_id` int(11) NOT NULL,
  `ol_d_id` tinyint(4) NOT NULL,
  `ol_w_id` smallint(6) NOT NULL,
  `ol_number` tinyint(4) NOT NULL,
  `ol_i_id` int(11) NOT NULL,
  `ol_supply_w_id` smallint(6) DEFAULT NULL,
  `ol_delivery_d` timestamp,
  `ol_quantity` tinyint(4) NOT NULL,
  `ol_amount` decimal(6,2) NOT NULL,
  `ol_dist_info` char(24) NOT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `ol_w_id` (`ol_w_id`,`ol_d_id`,`ol_o_id`,`ol_number`),
  KEY `idx_order_line_2` (`ol_supply_w_id`,`ol_i_id`)
) ENGINE=InnoDB;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
CREATE TABLE `orders` (
  `aid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `o_id` int(11) NOT NULL,
  `o_d_id` tinyint(4) NOT NULL,
  `o_w_id` smallint(6) NOT NULL,
  `o_c_id` int(11) NOT NULL,
  `o_entry_d` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `o_carrier_id` tinyint(4) DEFAULT NULL,
  `o_ol_cnt` tinyint(4) NOT NULL,
  `o_all_local` tinyint(4) NOT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `o_w_id` (`o_w_id`,`o_d_id`,`o_id`),
  KEY `idx_orders` (`o_w_id`,`o_d_id`,`o_c_id`,`o_id`)
) ENGINE=InnoDB;

--
-- Table structure for table `stock`
--

DROP TABLE IF EXISTS `stock`;
CREATE TABLE `stock` (
  `aid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `s_i_id` int(11) NOT NULL,
  `s_w_id` smallint(6) NOT NULL,
  `s_quantity` smallint(6) DEFAULT NULL,
  `s_dist_01` char(24) NOT NULL,
  `s_dist_02` char(24) NOT NULL,
  `s_dist_03` char(24) NOT NULL,
  `s_dist_04` char(24) NOT NULL,
  `s_dist_05` char(24) NOT NULL,
  `s_dist_06` char(24) NOT NULL,
  `s_dist_07` char(24) NOT NULL,
  `s_dist_08` char(24) NOT NULL,
  `s_dist_09` char(24) NOT NULL,
  `s_dist_10` char(24) NOT NULL,
  `s_ytd` decimal(8,0) NOT NULL,
  `s_order_cnt` smallint(6) NOT NULL,
  `s_remote_cnt` smallint(6) NOT NULL,
  `s_data` varchar(50) NOT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `s_w_id` (`s_w_id`,`s_i_id`),
  KEY `idx_stock_2` (`s_i_id`)
) ENGINE=InnoDB;

--
-- Table structure for table `warehouse`
--

DROP TABLE IF EXISTS `warehouse`;
CREATE TABLE `warehouse` (
  `aid` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `w_id` smallint(6) NOT NULL,
  `w_name` varchar(10) NOT NULL,
  `w_street_1` varchar(20) NOT NULL,
  `w_street_2` varchar(20) NOT NULL,
  `w_city` varchar(20) NOT NULL,
  `w_state` char(2) NOT NULL,
  `w_zip` char(9) NOT NULL,
  `w_tax` decimal(4,2) NOT NULL,
  `w_ytd` decimal(12,2) NOT NULL,
  PRIMARY KEY (`aid`),
  UNIQUE KEY `w_id` (`w_id`)
) ENGINE=InnoDB;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
