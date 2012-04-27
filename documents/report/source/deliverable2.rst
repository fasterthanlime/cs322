-------------
Deliverable 2
-------------

    *The students should accommodate the situation where new data is inserted in any table. Moreover, a simple query which can search for a keyword in any table should be implemented. The user should be able to see more details of the result of the query (e.g., if someone searches for Michael Jordan's regular season statistics and the result has multiple seasons, he/she should be able to see statistics for individual seasons - for example, through a hyperlink).*

Import the data from the given CSV files into the created database
==================================================================

*Nothing to see here, move along*

Accommodate the import of new data in the database they created in the 1st deliverable
======================================================================================

*TODO*

Implement the simple search queries 
===================================

The SQL command is right below. Without any external fulltext search engine, we have to perform a `LIKE '%term%'` on any candidates fields of each tables we would like to be searchable. As it's basically *n* queries, we join them together with the table name to be able to figure out where does it come from.

.. literalinclude:: ../../../queries/search.sql
   :language: sql
   :lines: 1-

Implement the follow-up search queries of the result of the initial search
--------------------------------------------------------------------------

The result of the initial search may look like this.

+------------+-------+-----------------------+
| table name | id    | string                |
+============+=======+=======================+
| people     | 4050  | JAMESMA01 Max Jameson |
+------------+-------+-----------------------+
| teams      | 20    | CHI Bulls             |
+------------+-------+-----------------------+
| …          | …     | …                     |
+------------+-------+-----------------------+

From there, we can display something directly and add a link to the proper view for each line.

Implement using SQL the following queries
=========================================

Query A
-------

Print the last and first name of players/coaches who participated in NBA both as a player and as a coach.

.. literalinclude:: ../../../queries/basic_a.sql
   :language: sql
   :lines: 4-

Query B
-------

Print the last and first name of those who participated in NBA as both a player and a coach in the same season.

.. literalinclude:: ../../../queries/basic_b.sql
   :language: sql
   :lines: 4-

Query C
-------

Print the name of the school with the highest number of players sent to the NBA.

.. literalinclude:: ../../../queries/basic_c.sql
   :language: sql
   :lines: 4-

Query D
-------

Print the names of coaches who participated in both leagues (NBA and ABA).

.. literalinclude:: ../../../queries/basic_d.sql
   :language: sql
   :lines: 3-

Query E
-------

Compute the highest scoring and lowest scoring player for each season.

.. literalinclude:: ../../../queries/basic_e.sql
   :language: sql
   :lines: 3-

Query F
-------

Print the names of oldest and youngest player that have participated in the playoffs for each season.

.. literalinclude:: ../../../queries/basic_f.sql
   :language: sql
   :lines: 4-

Build an interface to access and visualize the data
===================================================

*TODO: put some awesome screenshots here*
