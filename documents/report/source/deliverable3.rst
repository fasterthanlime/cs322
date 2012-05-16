-------------
Deliverable 3
-------------

    *A series of more interesting queries should be implemented with SQL and/or using the preferred application programming language:*

    * *Explain the necessities of indexes based on the queries and the query plans that you can find from the system;*
    * *Report the performance of all queries and explain the distribution of the cost (based again on the plans;*
    * *Visualize the results of the queries (in case they are not scalar);*
    * *Build an interface to run queries/insert data/delete data giving as parameters the details of the queries.*

**TODO**

Post-mortem deliverable 2
=========================

    *Good job with the queries. Is there a reason why all queries are expressed as views? Please include the explanation for this decision in the report.*

It seemed easier for us to reuse them automagically from the web UI, but we were mistaken and the final code doesn't do that anymore. Both the SQL queries and the web application were simplified following that change.

    *Can you explain the remark about “different join order not giving any results” in query D? Please include this explanation in the final version of the report. Keep in mind that you're not getting the correct result (should be indeed 0 rows).*

**TODO**

    *Keep up the good work! (at least you're gonna read this...)*

Indeed!

Changes to the schema
---------------------

**TODO**

Importing data
--------------

    *As per your comment, the logic in `import.rake` is quite hardcore. I'm not questioning at all your choice—as a matter of fact, in the same scenario I tend to attack the problem in the very same way (especially because the code plays the role of implicit documentation for each data transformation). Still, for the sake of completeness, I've to mention two other options:*

    * *manipulating the .csv with Excel/LibreOffice Calc is a viable and usually quicker solution (but worse in terms of maintainability).*
    * *instead of importing directly into the tables of your final DB schema, you could create a temporary table for each .csv file (same schema, no constraints) and ALTER them progressively. This usually leads to less LOC (being SQL more expressive than Ruby).*

**TODO**

Denormalization
---------------

Coach
'''''

**TODO**

The queries
===========

**TODO**

Query G
-------

    *List the name of the schools according to the number of players they sent to the NBA. Sort them in descending order by number of drafted players.*

**TODO**

Query H
-------

    *List the name of the schools according to the number of players they sent to the ABA. Sort them in descending order by number of drafted players.*

**TODO**

Query I
-------

    *List the average weight, average height and average age, of teams of coaches with more than* ``XXX`` *season career wins and more than* ``YYY`` *win percentage, in each season they coached. (* ``XXX`` *and* ``YYY`` *are parameters. Try with combinations:* ``{XXX,YYY}={<1000,70%>,<1000,60%>,<1000,50%>,<700,55%>,<700,45%>}`` *. Sort the result by year in ascending order.*

**TODO**

Query J
-------

    *List the last and first name of the players which are shorter than the average height of players who have at least 10,000 rebounds and have no more than 12,000 rebounds (if any).*

**TODO**

.. literalinclude:: ../../../queries/basic_j.sql
   :language: sql
   :lines: 4-

Query K
-------

    *List the last and first name of the players who played for a Chicago team and Houston team.*

**TODO**

Query L
-------

    *List the top 20 career scorers of NBA.*

**TODO**

.. literalinclude:: ../../../queries/basic_l.sql
   :language: sql
   :lines: 3-

Query M
-------

    *For coaches who coached at most 7 seasons but more than 1 season, who are the three more successful? (Success rate is season win percentage:* ``season_win / (season_win + season_loss))`` *. Be sure to count all seasons when computing the percentage.*

Here, we are using the table `coaches` which contains denormalized data built from the `coach_seasons` table and filled via a `TRIGGER`.

.. literalinclude:: ../../../queries/basic_m.sql
   :language: sql
   :lines: 8-

Query N
-------

    *List the last and first names of the top 30* ``TENDEX`` *players, ordered by descending* ``TENDEX`` *value (Use season stats). (* ``TENDEX=(points+reb+ass+st+blk‐missedFT‐missedFG‐TO)/minutes)`` *)*

**TODO**

Query O
-------

    *List the last and first names of the top 10* ``TENDEX`` *players, ordered by descending* ``TENDEX`` *value (Use playoff stats). (* ``TENDEX=(points+reb+ass+st+blk-­missedFT‐missedFG-­TO)/minutes`` *)*

**TODO**

Query P
-------

    *Compute the least successful draft year – the year when the largest percentage of drafted players never played in any of the leagues.*

**TODO**

Query Q
-------

    *Compute the best teams according to statistics: for each season and for each team compute* ``TENDEX`` *values for its best 5 players. Sum these values for each team to compute* ``TEAM TENDEX`` *value. For each season list the team with the best win/loss percentage and the team with the highest* ``TEAM TENDEX`` *value.*

**TODO**

Query R
-------

    *List the best 10 schools for each of the following categories: scorers, rebounders, blockers. Each school’s category ranking is computed as the average of the statistical value for 5 best players that went to that school. Use player’s career average for inputs.*

**TODO**

Query S
-------

    *Compute which was the team with most wins in regular season during which it changed 2, 3 and 4 coaches.*

**TODO**

Query T
-------

    *List all players which never played for the team that drafted them.*

**TODO**
