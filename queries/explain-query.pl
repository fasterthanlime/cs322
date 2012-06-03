#!/usr/bin/perl -w
use strict;

if ($#ARGV < 0) {
    print "Usage: $0 [a-t]\n";
    exit 1;
}
my $q = shift;

# Slurping the file
open(my $fh, "<basic_$q.sql");
my $t = $/;
undef $/;
my $s = <$fh>;
$/ = $t;
close($fh);

# http://prsync.com/oracle/displaying-the-execution-plan-for-a-sql-statement-26490/
$s .= "
SELECT plan_table_output
FROM table(dbms_xplan.display('plan_table', NULL, 'typical -cost -bytes'))
";

$s =~ s/--.*$//gm;
$s =~ s/\n/ /g;
$s =~ s/  +/ /g;
my @sql = split ';', $s;

$s = join '', map { 
    my ($l, $rh) = ($_, \$_);
    my $last = $rh == \$sql[-2];
    chomp($l);
    $l = "EXPLAIN PLAN FOR $l" if $last;
    "$l;\n";
} @sql;

print `echo "$s" | sqlplus DB2012_G06/DB2012_G06`;
