#!/bin/sh

query=$1;
SQL="sqlplus DB2012_G06/DB2012_G06"

${SQL} < basic_${query}.sql
echo "SELECT * FROM query_${query};" | ${SQL} 
