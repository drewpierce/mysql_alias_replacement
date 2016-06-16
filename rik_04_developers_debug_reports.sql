-- These queries are for help in debugging the current state of things
-- ad hoc run by developer. Most should work unless I tweaked the structures.
--
-- Note that some of the sample output is minimal that occurred during early
-- stages of ETL testing (meaning, very few rows were present in my materials2 tables)
--
-- Some of the below doesn't even matter anymore after I created the 
-- function `fCodeD_ShowCounts()` . As such this is developer notes and gibberish.
--
-- INSTR(str,substr);
-- select instr('b','abc'); -- 0
-- select instr('abc','b'); -- 2

-- for the following, don't trust it. It was why I had four versions
-- of Code leading up to `Code-D` to get the commas right with the concat
-- so the below is B.S., rely on the function `fCodeD_ShowCounts()`
select ma.material,ma.alias,m.active,ma.ais,count(pi.id) as csvCount 
from materials2 m 
join materials2_alias ma 
on ma.material=m.material 
left join productinfo pi 
on instr(pi.material,ma.alias)>0 
where m.active=true 
group by ma.material,ma.alias 
order by ma.material,ma.alias; 
+----------+--------+--------------+
| material | alias  | count(pi.id) |
+----------+--------+--------------+
| KARTON   | Cotton |            1 |
| KARTON   | Katoen |         3886 |
| KARTON   | Pima   |            2 |
+----------+--------+--------------+
-- read notes above and the new function. Do not rely on this instr().
-- See new code elsewhere for the instr with commas before and after.

select ma.material,ma.alias,m.active,count(pi.id) 
from materials2 m 
join materials2_alias ma 
on ma.material=m.material 
left join productinfo pi 
on instr(pi.material,ma.alias)>0
where m.active=true 
group by ma.material,ma.alias 
order by ma.material,ma.alias;
+-----------+----------+--------+--------------+
| material  | alias    | active | count(pi.id) |
+-----------+----------+--------+--------------+
| KARTON    | Cotton   |      1 |            1 |
| KARTON    | Katoen   |      1 |         3886 |
| KARTON    | Pima     |      1 |            2 |
| Lyocell   | Lycocell |      0 |            3 |
| Lyocell   | Lyocel   |      0 |           77 |
| Polyester | Polyster |      0 |            2 |
+-----------+----------+--------+--------------+
-- read notes above and the new function. Do not rely on this instr().
-- See new code elsewhere for the instr with commas before and after.

-- a few good visuals:
select material,alias,ais
from materials2_alias
order by material,alias;
-- 41 rows
select material,active
from materials2;
-- 21 rows

select ma.material,ma.alias,m.active,count(pi.id) 
from materials2 m 
join materials2_alias ma 
on ma.material=m.material 
left join productinfo pi 
on instr(pi.material_original,concat(',',ma.alias,','))>0 
group by ma.material,ma.alias 
order by ma.material,ma.alias; 
+------------------+-------------------+--------+--------------+
| material         | alias             | active | count(pi.id) |
+------------------+-------------------+--------+--------------+
| Acetaat          | Lamsleder         |      1 |            5 |
| Acetaat          | Leder             |      1 |          367 |
| Elastan          | Elastaan          |      1 |         2210 |
| Elastan          | Elastane          |      1 |           11 |
| Elastan          | Elataan           |      1 |            3 |
| Elastan          | Spandex           |      1 |           51 |
| Elastomultiester | Elasomultiester   |      1 |            2 |
| Elastomultiester | elastomutltiester |      1 |            1 |
| KARTON           | Cotton            |      1 |            1 |
| KARTON           | Katoen            |      1 |         3882 |
| KARTON           | Pima              |      1 |            1 |
| Leer             | Geitenleder       |      1 |            1 |
| Leer             | Lamsleder         |      1 |            5 |
| Leer             | Leder             |      1 |          367 |
| Leer             | Schapenleder      |      1 |            3 |
| Leer             | Varkensleder      |      1 |            3 |
| Linnen           | Linen             |      1 |           20 |
| Lyocell          | Lycocell          |      0 |            3 |
| Lyocell          | Lyocel            |      0 |            4 |
| Polyacryl        | Polyacrylic       |      1 |            4 |
| Polyamide        | Poliamide         |      1 |            2 |
| Polyamide        | Polyamid          |      1 |            5 |
| Polyamide        | Polyamie          |      1 |            1 |
| Polyester        | Polyster          |      0 |            2 |
| Polyurethaan     | Polyueretaan      |      1 |            1 |
| Polyurethaan     | Polyurathane      |      1 |            1 |
| Polyurethaan     | Polyuretaan       |      1 |            7 |
| Polyurethaan     | Polyurethan       |      1 |           24 |
| Polyurethaan     | Polyurtaan        |      1 |            1 |
| Polyurethaan     | PU                |      1 |            3 |
| Viscose          | Viscoe            |      1 |            1 |
| Viscose          | Viskose           |      1 |            1 |
| Viscose          | Visose            |      1 |            3 |
| Viscose          | Voscose           |      1 |            1 |
| Wol              | Scheerwol         |      1 |            4 |
| Wol              | Schuurwol         |      1 |            1 |
| Wol              | WO                |      1 |            0 |
| Wol              | Wool              |      1 |            1 |
| Wol-Merino       | Merino            |      1 |            1 |
| Zijde            | Sede              |      1 |            0 |
| Zijde            | Silk              |      1 |            3 |
+------------------+-------------------+--------+--------------+
41 rows in set (0.27 sec)
