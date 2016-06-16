-- Step 1
--   run your ETL all the way up to the "Drew's stuff starts" from file
--   rik_02b near line 195.alter
--   You can rem out my little block around line 95 for `productinfo_original`

-- Step 2
--   Run my `productinfo_snapshot01` little block around line 205. It is about 4 lines.

-- Step 3
--   Run the 4 lines of code in Block `TotalRedo`

-- Step 4
--   Run the 2 update statements in Block `TwoPatchesAtBeginning`

-- Step 5
--   Run the 4 statements in Block `TheAlters` (the alter alter update alter).
--   This concludes your ETL plus my schema changes that are minor
--   Obvious do an alter table drop column on my stuff when done
--   except for perhaps the PK of id that I added.

-- Step 6
--   For a sanity check, run the store proc and the function for `touchCounts`
--   -- call touchCounts(@writeToMe);
--      +------------+----------+
--      | touchCount | rowCount |
--      +------------+----------+
--      |          0 |     9122 |
--      +------------+----------+

--      what this means at this point is we know we are just starting and potentially 9122 rows need some tuning
--      with alias swaps
--
--   set @whatItIs=fTouchCounts();
--   select @whatItIs; -- returns just 1 (meaning the info had you run the stored proc for detail)
--   
--   Important: save that value into a @prevRowCount variable

-- Step 6
--   write a while loop. You will be calling the stored proc `CodeD()`. Ie: call CodeD();
--   after that call, call the function `@whatItIs=fTouchCounts();`
--   When --@whatItIs = @prevRowCount, you are done in your while loop
--
--   Sprinkle in calls to the helper function `fCodeD_ShowCounts()` or frankly use its output 
--   to determine while loop bail out

A visual from the start of data.

-- label_GoTo1:
set @whatXYZ:= fCodeD_ShowCounts();
select @whatXYZ;	-- 6998
-- greater than 0, call CodeD
call CodeD();	-- 1st Call 1st Call 1st Call
-- for kicks look at touchCounts
-- set @someVar:=0;
-- call touchCounts(@someVar);
+------------+----------+
| touchCount | rowCount | 
+------------+----------+ 
|          0 |     3654 | 
|          1 |     5468 | 
+------------+----------+ 
-- select @someVar; -- output is 2
-- obviously you could to the Turn on the Radar thing if you want. See bottom of rik_02b.sql for that
--
-- or just call the function, with set @whatItIs=fTouchCounts();
-- if @whatItIs = @prevRowCount you are done, if not, continue your while
-- which is equivalent to me saying "goto label_GoTo1:" 10 lines above in this pseudo-code
-- set @prevRowCount to that variable

-- another useful function is the one below, that I added late in the game here, to make
-- getting out of your while loop easier, maybe. When it returns 0, you are done
-- set @tryItOut123:=fCodeD_ShowCounts();
-- select @tryItOut123; -- 1158

-- so here are some notes on calling 2nd time and after (I think like 4 calls in total are necessary
-- and we have already done 1.
call CodeD();	-- 2nd Call 2nd Call 2nd Call
-- set @tryItOut123:=fCodeD_ShowCounts();
-- select @tryItOut123; -- 6

call CodeD();	-- 3rd Call 3rd Call 3rd Call
-- set @tryItOut123:=fCodeD_ShowCounts();
-- select @tryItOut123; -- 0

we are done. See also the JPG for a visual on the touchCounts and row counts.

