#!/bin/bash

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 [a-t]"
    exit
fi

query=$1;
SQL="sqlplus DB2012_G06/DB2012_G06"

${SQL} < basic_${query}.sql
