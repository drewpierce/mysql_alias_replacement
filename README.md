# mysql_alias_replacement

This is not related to normal alias usage always thought of, but rather mappings of strings (the final desired string, and its variants (aliases, synonyms, etc) that need to be changed.

Stackoverflow question http://stackoverflow.com/q/37841364

With this you can dynamically do word changes to a destination word from related and associated "other" words.

Note, however, that the OP had a string such as ",abc,def,pdq,xyz," so you will have to tweak the code to deal with that, to meet your situation.

For the OP in that question, it was for changing foreign language names to the Dutch equivalent, I believe.

The problem was his non-extendable table design. That was changed to a normalized one, that is also extendable. Also, each set at the level of table `materials2` can have it turned to active=true or active=false for use during your testing. Only the active ones are affected. That can be extended by you to the child table `materials2_alias` if you wish. At that level. But I had to put the brakes on somewhere.

Always avoid CSV data saved in one column, or table designs where one thinks, oh, I can always add another column. Please see an answer of mine here http://stackoverflow.com/a/32620163 .


Files
----

rik_02c_general_public.sql - OP gives schema and ETL is performed by him and myself.
    The top part of this is not shown due to potential proprietary info of the OP. That info is not relevant.

rik_03_create_tables.sql - Two simple tables of my creation. Run once before much of anything.

rik_04_developers_debug_reports.sql - A script to capture some things I was running, somewhat outdated, but didn't want to lose it.

rik_05_actual_workflow.sql - A workflow top to bottom on how to test. I hope it is clear (I doubt it)

visual_touchcount_depletion.JPG - A visual showing how the rowcounts cease after 3 or 4 runs.

Any reference to the line numbers in a file "rik_02b" mentioned in the "rik_05" file is relevant to a file I had to email him due to potential proprietary stuff. So those line numbers won't match up to the rik_02c given here on github.
