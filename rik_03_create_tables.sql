drop table if exists materials2;
create table materials2
(	material varchar(100) primary key, -- let's go with a natural key
	active bool not null -- turn it LIVE and ON for string replacement of alias back to material name
	-- so active is TRUE for ones to do replacement, or FALSE for skip
    -- facilitates your testing of your synonyms, translations, slangs, etc
)engine=INNODB;

insert materials2 (material,active) values
('KARTON',true),
('Polyester',false),
('Lyocell',false),
('Linnen',true),
('Viscose',true),
('Scheerwol',false),
('Nylon',false),
('Leer',true),
('Polyurethaan',true),
('Polyacryl',true),
('Acryl',false),
('Modal',true),
('Acetaat',true),
('Papier',false),
('Wol',true),
('Zijde',true),
('Temcal',false),
('Polyamide',true),
('Wol-Merino',true),
('Elastan',true),
('Elastomultiester',true);
-- 21 rows
-- a few rows were skipped. The intent of them read as gibberish to me. Please review.

-- we need to restructure the materials2_alias table (after the first attempt)
-- 1. it might need special handling when `alias` is a legitimage substring of `material` (those 2 columns)
-- 2. it needs a unique composite index
drop table if exists materials2_alias;
create table materials2_alias
(	id int auto_increment primary key,
	material varchar(100) not null,
	alias varchar(100) not null,
    ais bool not null, -- Alias is Substring (alias is a legitimate substring of material, like Wo and Wol, respectively)
    unique key(material,alias), -- Composite Index, do not allow dupe combos (only 1 row per combo)
    foreign key `m2alias_m2` (material) references materials2(material)
)engine=INNODB;

insert materials2_alias (material,alias,ais) values
('KARTON','Cotton',false),('KARTON','Katoen',false),('KARTON','Pima',false),
('Polyester','Polyster',false),
('Lyocell','Lycocell',false),('Lyocell','Lyocel',false),
('Linnen','Linen',false),
('Viscose','Visose',false),('Viscose','Viskose',false),('Viscose','Viscoe',false),('Viscose','Voscose',false),
('Leer','Leder',false),('Leer','Lamsleder',false),('Leer','Varkensleder',false),('Leer','Schapenleder',false),('Leer','Geitenleder',false),
('Polyurethaan','Polyurethan',false),('Polyurethaan','PU',false),('Polyurethaan','Polyuretaan',false),('Polyurethaan','Polyurathane',false),('Polyurethaan','Polyurtaan',false),('Polyurethaan','Polyueretaan',false),
('Polyacryl','Polyacrylic',false),
('Acetaat','Leder',false),('Acetaat','Lamsleder',false),
('Wol','Schuurwol',false),('Wol','Wool',false),('Wol','WO',false),('Wol','Scheerwol',false),
('Zijde','Silk',false),('Zijde','Sede',false),
('Polyamide','Polyamie',false),('Polyamide','Polyamid',false),('Polyamide','Poliamide',false),
('Wol-Merino','Merino',false),
('Elastan','Elastaan',false),('Elastan','Spandex',false),('Elastan','Elataan',false),('Elastan','Elastane',false),
('Elastomultiester','elastomutltiester',false),('Elastomultiester','Elasomultiester',false);

-- this cleans up the above, where false should have been true
update materials2_alias
set ais=true 
where instr(material,alias)>0;
-- 4 rows

/*
select * from materials2_alias 
where ais=true 
order by material,alias;
+----+------------+----------+-----+
| id | material   | alias    | ais |
+----+------------+----------+-----+
|  6 | Lyocell    | Lyocel   |   1 |
| 33 | Polyamide  | Polyamid |   1 |
| 28 | Wol        | WO       |   1 |
| 35 | Wol-Merino | Merino   |   1 |
+----+------------+----------+-----+
-- those above are the Pain in the arse ones. Well, they were.
-- so we forced a comma at the end of productinfo.material. Seems to have worked.
-- At the moment the `ais` column is just ones to keep an eye on for problems.
*/


