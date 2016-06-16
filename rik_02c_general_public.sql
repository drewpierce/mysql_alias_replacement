create database testbed123z;
use testbed123z;

drop table if exists materials;
CREATE Table `materials` 
(`id` int(11)  auto_increment primary key,
`material` varchar(264) NOT NULL ,
`alias01` varchar(264) NOT NULL  ,
`alias02` varchar(264) NOT NULL  ,
`alias03` varchar(264) NOT NULL  ,
`alias04` varchar(264) NOT NULL  ,
`alias05` varchar(264) NOT NULL  ,
`alias06` varchar(264) NOT NULL  ,
`alias07` varchar(264) NOT NULL  ,
`alias08` varchar(264) NOT NULL  ,
`alias09` varchar(264) NOT NULL  ,
`alias10` varchar(264) NOT NULL  ,
`alias11` varchar(264) NOT NULL  ,
`alias12` varchar(264) NOT NULL  
)engine=INNODB;

INSERT INTO `materials`
(material,alias01,alias02,alias03,alias04,alias05,alias06,alias07,alias08,alias09,alias10,alias11,alias12)
VALUES
('KARTON','Cotton','Katoen','Pima','','','','','','','','',''),
('Polyester','Polyster','','','','','','','','','','',''),
('Lyocell','Lycocell','Lyocel','','','','','','','','','',''),
('Linnen','Linen','','','','','','','','','','',''),
('Viscose','Visose','Viskose','Viscoe','Voscose','','','','','','','',''),
('Scheerwol','','','','','','','','','','','',''),
('Polyamide','','','','','','','','','','','',''),
('Nylon','','','','','','','','','','','',''),
('Leer','Leder','Lamsleder','Varkensleder','Schapenleder','Geitenleder','','','','','','',''),
('Polyurethaan','Polyurethan','PU','Polyuretaan','Polyurathane','Polyurtaan','Polyueretaan','','','','','',''),
('Polyacryl','Polyacrylic','','','','','','','','','','',''),
('Acryl','','','','','','','','','','','',''),
('Modal','Modaal','Micromodal','Micromodaal','','','','','','','','',''),
('Acetaat','Triacetaat','Triaceto','','','','','','','','','',''),
('Papier','','','','','','','','','','','',''),
('Wol','Schuurwol','Wool','WO','Scheerwol','','','','','','','',''),
('Zijde','Silk','','','','','','','','','','',''),
('Tencel','','','','','','','','','','','',''),
('Cupro','','','','','','','','','','','',''),
('Polyamide','Polyamie','Polyamid','Poliamide','','','','','','','','',''),
('Wol-Merino','Merino','','','','','','','','','','',''),
('Rubber','','','','','','','','','','','',''),
('Zijde','Seda','','','','','','','','','','',''),
('Elastan','Elastaan','Spandex','Elataan','Elastane','','','','','','','',''),
('Elastomultiester','elastomutltiester','Elasomultiester','','','','','','','','','',''),
('Lycra','','','','','','','','','','','',''),
('Polypropyleen','','','','','','','','','','','',''),
('','','','','','','','','','','','',''),
(',','Bovenmateriaal','Leder','Voering','Voetbed','Leder','Loopzool','Overig','Materiaal','in','','','')
;

-- note that the above table is created only for reference purposes, and is not used
-- it was provided for by the OP in the question

-- There was an import of data, but as that contains potentially proprietary OP data, it is not provided
-- but a minimized schema to work is provided

DROP TABLE IF EXISTS `productinfo`;
CREATE TABLE `productinfo` (
  `title` text,
  `material` text,
  `internal_id` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- there was a LOAD DATA INFILE and perhaps some private ETL, so that part is skipped

-- Drew's stuff starts
-- Drew's stuff starts
-- Drew's stuff starts
-- Drew's stuff starts
-- Drew's stuff starts

-- be careful around here, think what versioning and safety you want.
-- versioning meaning if you run this daily or weekly, how you want the below to be named.
-- worst case, no big deal, you just start your ETL over from the beginning. But a pain.
DROP TABLE if exists productinfo_snapshot01;
CREATE TABLE IF NOT EXISTS `productinfo_snapshot01` 
SELECT *
FROM `productinfo`;
-- 9122 rows 

-- *****************************************************************************************
-- Begin Block `TotalRedo`
-- Purpose: To start clean back at the point at the end of Rik's ETL
-- https://en.wikipedia.org/wiki/Extract,_transform,_load
drop table if exists productinfo;
CREATE TABLE IF NOT EXISTS `productinfo` 
SELECT *
FROM `productinfo_snapshot01`;
-- End Block `TotalRedo`
-- *****************************************************************************************

-- *****************************************************************************************
-- Begin Block `TwoPatchesAtBeginning`
-- Purpose: two patches to begin with. All `material` will begin and end with a comma
--          I am not sure how perfect this is. It is real late at night.
--          To mitigate the ill effects of Wol - Wo and those `ais`=true rows.
--          Seems to do the trick (see data model for materials2_alias.ais)
--          So as it stands now, this seems to work, and we are not using `ais` column for much.
update productinfo
set material=concat(material,',')
where right(material,1)!=',';
-- 9071 row

update productinfo
set material=concat(',',material)
where left(material,1)!=',' and length(material)>1;
-- 750 rows
-- End Block `TwoPatchesAtBeginning`
-- *****************************************************************************************



-- followed by:
-- *****************************************************************************************
-- Begin Block `TheAlters`
-- Purpose: create some needed columns (ADD COLUMN)
ALTER TABLE `productinfo` ADD `id` INT AUTO_INCREMENT PRIMARY KEY;
-- AI's are primary keys and therefore NOT NULL is a given
-- select min(id),max(id) from productinfo;
-- 1 ... 9122

ALTER TABLE `productinfo` 
  ADD COLUMN `material_original` TEXT NOT NULL, 
  ADD COLUMN `touchCount` INT NOT NULL DEFAULT 0;

update productinfo set material_original=material,touchCount=0; -- _before is our safety net

ALTER TABLE `productinfo` 
  ADD COLUMN `debug_material_save_just_before_a_change` TEXT NOT NULL;
-- End Block `TheAlters`
-- *****************************************************************************************

-- *****************************************************************************************
-- So here are two common update statements often used during testings
-- to reset the state and start fresh. Run one or the other.
-- Begin Block `LocalRestartFresh`
-- Purpose: Two common update statements used ocassionally during testing.
--          You will probably use just the first one
update productinfo set material=material_original,touchCount=0; -- _original is our safety net
-- or
update productinfo set touchCount=0;
-- End Block `LocalRestartFresh`
-- mostly you would use the first one to do a quick minor reset to the beginning state
-- *****************************************************************************************



-- *****************************************************************************************
-- Begin Block `CodeRadar` a.k.a. Turn On The Radar
-- Purpose: A specialty "save the state right before a change"
--          Useful for debugging your aliases and what exactly was just performed.
update productinfo set debug_material_save_just_before_a_change=material;
-- Begin Block `CodeRadar`
-- *****************************************************************************************
-- *****************************************************************************************

-- ****************************************************************************************************
-- Begin Block `touchCounts` 
-- Purpose: The main driver for determining if a change occurred after a looped
--          run of yours, successively trying to whittle down all the alias replacements.
--
--          Very important: the update statement in `CodeD` performs just one replacement 
--          per row (just one alias swap) at a time even if it would seem intuitive that all should
--          occur at once. This forces the interative loop that you will need to create
--          and why there is a `touchCount` column in the first place
--
-- I assume you will end up just using the function version of the below. Seems more useful.
--
DROP PROCEDURE if exists touchCounts;
DELIMITER $$
CREATE PROCEDURE touchCounts(OUT out_rowCount INT)
BEGIN
	select count(distinct touchCount) into out_rowCount from productinfo;
	
    select touchCount,count(*) as rowCount 
	from productinfo 
	group by touchCount 
	order by touchCount;
END $$
DELIMITER ;

--

DROP FUNCTION if exists fTouchCounts;
DELIMITER $$
CREATE FUNCTION fTouchCounts()
RETURNS INT
BEGIN
	select count(distinct touchCount) into @xyz from productinfo;
	return @xyz;
END $$
DELIMITER ;
-- test:
-- set @whatItIs=fTouchCounts();
-- select @whatItIs;
-- The above may belong over in the 04_developers_debug_reports.sql but it is use
-- often so I kept it here.
--
-- test:
-- call touchCounts(); -- the stored proc version (not there is a fcn version and a sp version)
-- END Block `touchCounts` 
-- ****************************************************************************************************

-- ****************************************************************************************************
-- Begin Block `Code-D` 

-- Purpose: the "update with a join" pattern routine that does a swap. It's use must be iterative.
-- Note, pi.material starts with a comma at the beginning and end. But `ma.alias` does not.
-- so add the comma with a concat below

-- instr() not case sensitive except for binary strings
-- REPLACE(str,from_str,to_str); -- case sensitive
-- http://dev.mysql.com/doc/refman/5.7/en/string-functions.html#function_replace
--
-- so the following uses lower() or this won't work due to replace() case sensitivity
--
DROP PROCEDURE if exists CodeD;
DELIMITER $$
CREATE PROCEDURE CodeD()
BEGIN
	UPDATE productinfo pi
	join materials2_alias ma 
	on instr(  pi.material,  concat(',',ma.alias,',')  )>0 
	join materials2 m
	on m.material=ma.material and m.active=true
	set pi.material=replace(lower(pi.material),lower(ma.alias),lower(ma.material)),
	pi.touchCount=pi.touchCount+1;
END$$
DELIMITER ;
-- END Block Code-D 
-- test:
-- call CodeD();
-- ****************************************************************************************************

-- ****************************************************************************************************
-- Begin Block `Code-D-ShowCounts` 
-- Purpose: To return the count of `productinfo` rows that will definitely have a swap
--          occur "were we" to call the `Code-D` block. So this is just a rip-off of its code
--          without actually doing the update, but rather returning the rowcount.
--
--          0 means we are done with alias swapping. n>0 means we have more swaps to occur
DROP FUNCTION if exists fCodeD_ShowCounts;
DELIMITER $$
CREATE FUNCTION fCodeD_ShowCounts()
RETURNS INT
BEGIN
	select count(pi.id) into @definiteAliasSwaps
	from productinfo pi
	join materials2_alias ma 
	on instr(  pi.material,  concat(',',ma.alias,',')  )>0 
	join materials2 m
	on m.material=ma.material and m.active=true;
	
    return @definiteAliasSwaps;
END $$
DELIMITER ;
-- END Block `Code-D-ShowCounts`
-- test:
-- set @tryItOut:=fCodeD_ShowCounts();
-- select @tryItOut;
-- ****************************************************************************************************

-- Drew's stuff Ends
-- Drew's stuff Ends
-- Drew's stuff Ends
-- Drew's stuff Ends
-- Drew's stuff Ends
-- Drew's stuff Ends
-- Drew's stuff Ends

-- the rest is just for visualization

-- At this point, touchCount=0 for all
-- and productinfo.material is set back to the beginning of script from Rik
-- except a comma is at the end of productinfo.material for every row
-- (a change from Rik's stuff)
--
-- and materials2_alias has ais set to true for only 4 rows (but we are hoping not to ever use that column)
-- but we identified those 4 rows that were causing all the problems

-- run `Code-D`, 1st time, 5468 rows, 5.5 seconds, now run `touchCounts`
+------------+----------+
| touchCount | rowCount | 
+------------+----------+ 
|          0 |     3654 | 
|          1 |     5468 | 
+------------+----------+ 

-- run `Code-D`, 2nd time, 1152 rows, 4.8 seconds, now run `touchCounts`
+------------+----------+ 
| touchCount | rowCount | 
+------------+----------+ 
|          0 |     3654 | 
|          1 |     4316 | 
|          2 |     1152 | 
+------------+----------+ 

-- run `Code-D`, 3rd time, 6 rows, 4.8 seconds, now run `touchCounts`
+------------+----------+ 
| touchCount | rowCount | 
+------------+----------+ 
|          0 |     3654 | 
|          1 |     4316 |  
|          2 |     1146 | 
|          3 |        6 | 
+------------+----------+ 

-- run `Code-D`, 4th time, 0 rows, 4.6 seconds, now run `touchCounts`
+------------+----------+ 
| touchCount | rowCount | 
+------------+----------+ 
|          0 |     3654 | 
|          1 |     4316 | 
|          2 |     1146 | 
|          3 |        6 | 
+------------+----------+ 
-- 4 rows came out again. Same as previous attempt. So we are truly done.
-- Work that into a loop of your creation. Save a prevRowCount variable and compare.

-- note, we know the following is not necessary to run again
-- but we will anyway.
-- run `Code-D`, 5th time, 0 rows, 4.6 seconds, now run `touchCounts`
+------------+----------+ 
| touchCount | rowCount | 
+------------+----------+ 
|          0 |     3654 | 
|          1 |     4316 |  
|          2 |     1146 |  
|          3 |        6 | 
+------------+----------+ 

-- to view some rows:
select id,material,material_original
from productinfo 
where touchCount=3;


-- ****************************************************************************************************
-- For closer debugging to see the before and after of a Code-D execution ...
-- turn on the radar to see before and after changes you would do a:
-- 
-- First run `CodeRadar` (note it uses column `debug_material_save_just_before_a_change`)
-- 
-- then run `Code-D`. Run `touchCounts` to get the max(touchCount). (The stored proc version not the function version)
-- Let's Call that number 3.
select id,material,debug_material_save_just_before_a_change 
from productinfo 
where touchCount=3;
-- ****************************************************************************************************
select pi.id
from productinfo pi
join materials2_alias ma 
on instr(  pi.material,  concat(',',ma.alias,',')  )>0 
join materials2 m
on m.material=ma.material and m.active=true;

