#!/bin/sh

query = $1;

sqlplus DB2012_G06/DB2012_G06 < basic_${query}.sql
echo "SELECT * FROM query_${query};" | sqlplus DB2012_G06/DB2012_G06
