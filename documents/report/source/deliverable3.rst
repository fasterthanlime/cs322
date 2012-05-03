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

    *List the last and first name of the players which are shorter than the average height of players who have at least 10,000 rebounds and have more than 12,000 rebounds (if any).*

**TODO**

Query K
-------

    *List the last and first name of the players who played for a Chicago team and Houston team.*

**TODO**

Query L
-------

    *List the top 20 career scorers of NBA.*

**TODO**

Query M
-------

    *For coaches who coached at most 7 seasons but more than 1 season, who are the three more successful? (Success rate is season win percentage:* ``season_win / (season_win + season_loss))`` *. Be sure to count all seasons when computing the percentage.*

**TODO**

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
