
-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 16-05-2016 a las 05:00:40
-- Versión del servidor: 10.0.20-MariaDB
-- Versión de PHP: 5.2.17

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `u582370692_car`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE  PROCEDURE `borraEvent`(
	cod char(5)
)
delete from eventos where eve_cod=cod$$

CREATE  PROCEDURE `borraSlider`(
cod char(5)
)
delete from slider where sli_cod=cod$$

CREATE  PROCEDURE `editaEvent`(
cod char(5),
titu varchar(100),
lugar varchar(100),
fecha TIMESTAMP,
est varchar(1),
cuer mediumtext
)
update eventos set eve_titulo=titu, eve_lugar=lugar, eve_fecha=fecha,eve_estado=est, eve_cuerpo=cuer where eve_cod=cod$$

CREATE  PROCEDURE `editaSlider`(
cod varchar(5),
tit varchar(100),
ext varchar(5)
)
BEGIN
	IF isnull(ext) THEN
		update slider set  sli_titulo=tit where sli_cod=cod;
	ELSE
		set @foto:= concat(cod,'_', TRUNCATE(rand() *100 ,0 ),'.',ext);
		update slider set  sli_titulo=tit, sli_foto=@foto where sli_cod=cod;
		select @foto img;
	END IF;
END$$

CREATE  PROCEDURE `insertEvent`(	
	nom varchar(100),/*titulo*/
	lug varchar(100),/*lugar*/
	fec TIMESTAMP,/*fecha*/
	est varchar(1),
	des mediumtext/*cuerpo*/
 )
BEGIN
     DECLARE co CHAR(5);
     DECLARE foto varchar(50);
     DECLARE foto2 varchar(50);
     DECLARE foto3 varchar(50);
     DECLARE foto4 varchar(50);
	    SET co = (select concat('ev',right(concat('000',right(IFNULL(max(eve_cod),0),3)+1),3)) AS COD from eventos);
       SET foto =(select concat('ev',right(concat('00',right(IFNULL(max(eve_cod),'00'),2)+1),3),'.jpg') AS img from eventos);
       SET foto2 =(select concat('ev',right(concat('00',right(IFNULL(max(eve_cod),'00'),2)+1),3),'b.jpg') AS img from eventos);
       SET foto3 =(select concat('ev',right(concat('00',right(IFNULL(max(eve_cod),'00'),2)+1),3),'c.jpg') AS img from eventos);
       SET foto4 =(select concat('ev',right(concat('00',right(IFNULL(max(eve_cod),'00'),2)+1),3),'d.jpg') AS img from eventos);
       insert into eventos (eve_cod,eve_titulo,eve_lugar,eve_fecha,eve_estado,eve_cuerpo,eve_foto1,eve_foto2,eve_foto3,eve_foto4) values(co,nom,lug,fec,est,des,foto,foto2,foto3,foto4);
       select co,foto,foto2,foto3,foto4;
END$$

CREATE  PROCEDURE `insertSli`(	
 nom varchar(200),
 ext varchar(5)
 )
BEGIN
     DECLARE co CHAR(5);
     DECLARE img varchar(15);
       SET co = (select concat('sl',right(concat('000',right(IFNULL(max(sli_cod),0),3)+1),3)) AS COD from slider);
       SET img = (select concat(co,'.',ext));
       insert into slider(sli_cod,sli_titulo,sli_foto) values(co,nom,img);
       select img;
END$$

CREATE  PROCEDURE `mostEvent`()
select * from eventos$$

CREATE  PROCEDURE `mostEventAct`()
select * from eventos where eve_estado='1'$$

CREATE  PROCEDURE `mostEventDetalle`(
cod char(5)
)
select * from eventos where eve_cod=cod$$

CREATE  PROCEDURE `mostSlider`()
select * from slider$$

CREATE  PROCEDURE `sp_login`(
us VARCHAR(50),
ps VARCHAR(20)
)
BEGIN
		declare resul varchar(100);
		declare rola char(3);
		set resul = (select nomusu from usuario where email=us and pass=ps);
		set rola = (select rol from usuario where email=us and pass=ps);
		IF (resul <> '') THEN
       		 select 'success' res,resul,rola;	       
     ELSE     
        select 'fail' res;
     END IF;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `eventos`
--

CREATE TABLE IF NOT EXISTS `eventos` (
  `eve_cod` char(5) COLLATE utf8_bin NOT NULL,
  `eve_titulo` varchar(100) COLLATE utf8_bin NOT NULL,
  `eve_lugar` varchar(100) COLLATE utf8_bin NOT NULL,
  `eve_fecha` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `eve_estado` varchar(1) COLLATE utf8_bin NOT NULL,
  `eve_cuerpo` mediumtext COLLATE utf8_bin NOT NULL,
  `eve_foto1` varchar(50) COLLATE utf8_bin NOT NULL,
  `eve_foto2` varchar(50) COLLATE utf8_bin NOT NULL,
  `eve_foto3` varchar(50) COLLATE utf8_bin NOT NULL,
  `eve_foto4` varchar(50) COLLATE utf8_bin NOT NULL,
  `eve_creacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`eve_cod`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `eventos`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `register`
--

CREATE TABLE IF NOT EXISTS `register` (
  `userid` varchar(50) COLLATE utf8_bin NOT NULL COMMENT 'userid',
  `name` varchar(50) COLLATE utf8_bin NOT NULL COMMENT 'name',
  `email` varchar(50) COLLATE utf8_bin NOT NULL COMMENT 'email',
  `password` varchar(50) COLLATE utf8_bin NOT NULL COMMENT 'password',
  `address` varchar(500) COLLATE utf8_bin NOT NULL COMMENT 'address',
  `contact` varchar(50) COLLATE utf8_bin NOT NULL COMMENT 'contact',
  `message` varchar(500) COLLATE utf8_bin NOT NULL COMMENT 'Message'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `seat`
--

CREATE TABLE IF NOT EXISTS `seat` (
  `userid` varchar(50) COLLATE utf8_bin NOT NULL COMMENT 'userid',
  `number` int(10) NOT NULL COMMENT 'seat number',
  `PNR` varchar(30) COLLATE utf8_bin NOT NULL COMMENT 'PNR',
  `date` varchar(20) COLLATE utf8_bin NOT NULL COMMENT 'date of booking'
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `seat`
--


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `slider`
--

CREATE TABLE IF NOT EXISTS `slider` (
  `sli_cod` char(5) NOT NULL,
  `sli_titulo` varchar(100) NOT NULL,
  `sli_foto` varchar(50) NOT NULL,
  PRIMARY KEY (`sli_cod`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `user_id` int(5) NOT NULL AUTO_INCREMENT,
  `user_name` varchar(25) NOT NULL,
  `user_email` varchar(35) NOT NULL,
  `user_pass` varchar(255) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `user_email` (`user_email`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=19 ;

--
-- Volcado de datos para la tabla `users`
--




-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

CREATE TABLE IF NOT EXISTS `usuario` (
  `codusu` char(9) COLLATE utf8_bin NOT NULL,
  `nomusu` varchar(40) COLLATE utf8_bin NOT NULL,
  `rol` char(3) COLLATE utf8_bin NOT NULL DEFAULT 'U',
  `email` varchar(50) COLLATE utf8_bin NOT NULL,
  `pass` varchar(20) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`codusu`),
  UNIQUE KEY `email` (`email`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`codusu`, `nomusu`, `rol`, `email`, `pass`) VALUES
('us0001', 'Administrador', 'A', 'carajo@admin.com', 'carajo123');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
