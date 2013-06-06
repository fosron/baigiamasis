SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;


CREATE TABLE `cms_content` (
  `page_id` int(2) NOT NULL auto_increment,
  `name` varchar(255) character set utf8 collate utf8_lithuanian_ci NOT NULL,
  `slug` varchar(255) collate ucs2_lithuanian_ci NOT NULL,
  `content` text character set utf8 collate utf8_lithuanian_ci NOT NULL,
  `editor_allowed` tinyint(1) NOT NULL,
  `created` datetime NOT NULL,
  `edited` datetime NOT NULL,
  `created_by` int(11) NOT NULL,
  `status` int(11) NOT NULL,
  PRIMARY KEY  (`page_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=ucs2 COLLATE=ucs2_lithuanian_ci AUTO_INCREMENT=10 ;

CREATE TABLE `cms_log` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL,
  `action` varchar(255) character set utf8 collate utf8_lithuanian_ci NOT NULL,
  `commit` datetime NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=17 ;

CREATE TABLE `cms_settings` (
  `id` int(11) NOT NULL auto_increment,
  `label` varchar(255) character set utf8 collate utf8_lithuanian_ci NOT NULL,
  `prettyname` varchar(255) character set utf8 collate utf8_lithuanian_ci NOT NULL,
  `value` varchar(255) character set utf8 collate utf8_lithuanian_ci NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=8 ;

CREATE TABLE `cms_users` (
  `user_id` int(11) NOT NULL auto_increment,
  `username` varchar(255) collate utf8_lithuanian_ci NOT NULL,
  `password` varchar(255) collate utf8_lithuanian_ci NOT NULL,
  `fullname` varchar(255) collate utf8_lithuanian_ci NOT NULL,
  `type` int(1) NOT NULL,
  `lastlogin` datetime NOT NULL,
  `ucreated` datetime NOT NULL,
  PRIMARY KEY  (`user_id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_lithuanian_ci AUTO_INCREMENT=3 ;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
