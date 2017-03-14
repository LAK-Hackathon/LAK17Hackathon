#!/usr/bin/perl;

# Link to JISC Data. Yes nice and fragile code
#

use DateTime::Event::Random;

# Configuration
my $file="/Users/Alan/Desktop/ZZ-LAK17/LAK17Hackathon/groups/group3/data/udd_students_by_module_instance.blue.json";
$limit = 20000;

## MAIN
#
open(TMP,$file)|| die;
$line=<TMP>;
my @string = split /"MOD_INSTANCE_ID"/, $line;

foreach(@string) {
	$piece=$_;
    $piece =~ /^:"(.*?)"/g;
    $section=$1;
    #print "$section\n";
    while($piece =~ /"STUDENT_ID":"(.*?)"/g ) {
    	$user=$1;
		#print "\t".$user."\n";
		$counter++;
		$user{$counter}=$user;
		$section{$counter}=$section;
    } 
}

$counter_max=$counter;

srand( time() ^ ( $$ + ( $$ << 15 ) ) );
$url_start = "https://www.youtube.com/watch?v=";
@urls      = (
	"w6z2JsTV1AY", "p6z2JsTV1WY", "Q6z2JsTV1WY", "w6a2JsTV1WY",
	"w6z22sTV1WY", "Z6z2JsTV1WY", "a6z2JsTV1WY"
);
@staffs = ("Mr.Angry","Mr.Ben","Mr.Man","Mrs.Perfect","Miss.Read");
@videos =
  ( "carry", "lift", "safely drop", "evacuate a building", "coordinate" );


$header =
"STUDENT_ID	ACTIVITY_DATE_TIME	DURATION	FROM_DATE_TIME	VIDEO_URL	VIDEO_NAME	VIDEO_DESCRIPTION	STAFF_ID	MOD_INSTANCE_ID	ACTIVITY_MANDATORY";
print $header. "\n";

my $counter=0;

while ($counter++ < $limit ) {
	$choice=int(rand($counter_max))+1;
	$id               = $user{$choice};
	my $dt = DateTime->today + DateTime::Event::Random->duration( days => 1 );
    $timestamp = $dt->datetime;
	#$timestamp        = "2017-01-30T00:00:00 PT2M17S";
	$const=int( rand(60) );
	$const_2=$const+int( rand(60) );
	$duration         = "PT2M" .$const_2."S";
	$from = "PT1M" . $const."S";
	$url              = $url_start . $urls[ rand @urls ];
	$description_part = $videos[ rand @videos ];
	$video_name       = "Learning How to " . $description_part;
	$description =
	  "Video on how to " . $description_part . " during a fire rescue.";
	$staff_id        = $staffs[ rand @staffs ];
	$homepage        = "http://www.jisc.ac.uk";
	$mod_instance_id = $section{$choice};
	$activity        = int( rand(2) );
	print
"$id\t$timestamp\t$duration\t$from\t$url\t$video_name\t$description\t$staff_id\t$mod_instance_id\t$activity\n";
}

sub generate_id {
	my @v = qw ( a e i o u y );
	my @c = qw ( b c d f g h j k l m n p q r s t v w x z );
	my ( $flip, $str ) = ( 0, '' );
	$str .= ( $flip++ % 2 ) ? $v[ rand(6) ] : $c[ rand(20) ] for 1 .. 9;
	$str =~ s/(....)/$1 . int rand(10)/e;
	$str = ucfirst $str if rand() > 0.5;
	return $str;
}