#!/usr/bin/perl
#simple HTTP-GET Generator
#written by dni
#shoutz to #bhf irc.bluehell.org
#
#  i.e:   ./get-url.pl http://host.com [number of req.]


use LWP::Simple;

$ARGC = @ARGV;

while ($ARGC != 2) {
print "Usage: $0 http://host.com 5555 n" ;
exit();}

for ($i = 1; $i <= $ARGV[1]; $i++) {
print (get $ARGV[0]);}