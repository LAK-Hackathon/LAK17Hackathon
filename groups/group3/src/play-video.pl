#!/usr/bin/perl;

# Play Video randam data generator
# Initial POC
# Alan Berg
# LAK17
# With plentiful help from cut and paste and Google search

use DateTime::Event::Random;

srand( time() ^ ( $$ + ( $$ << 15 ) ) );
$url_start = "https://www.youtube.com/watch?v=";
@urls      = (
	"w6z2JsTV1AY", "p6z2JsTV1WY", "Q6z2JsTV1WY", "w6a2JsTV1WY",
	"w6z22sTV1WY", "Z6z2JsTV1WY", "a6z2JsTV1WY"
);
@staffs = ("Mr.Angry","Mr.Ben","Mr.Man","Mrs.Perfect","Miss.Read");
@videos =
  ( "carry", "lift", "safely drop", "evacuate a building", "coordinate" );
$limit = 1000;

$header =
"STUDENT_ID	ACTIVITY_DATE_TIME	DURATION	FROM_DATE_TIME	VIDEO_URL	VIDEO_NAME	VIDEO_DESCRIPTION	STAFF_ID	HOMEPAGE	MOD_INSTANCE_ID	ACTIVITY_MANDATORY";
print $header. "\n";

my $counter=0;

while ($counter++ < $limit ) {
	$id               = generate_id();
	my $dt = DateTime->today + DateTime::Event::Random->duration( days => 1 );
    $timestamp = $dt->datetime;
	#$timestamp        = "2017-01-30T00:00:00 PT2M17S";
	$duration         = "PT1M" . int( rand(60) );
	$url              = $url_start . $urls[ rand @urls ];
	$description_part = $videos[ rand @videos ];
	$video_name       = "Learning How to " . $description_part;
	$description =
	  "Video on how to " . $description_part . " during a fire rescue.";
	$staff_id        = $staffs[ rand @staffs ];
	$homepage        = "http://www.jisc.ac.uk";
	$mod_instance_id = "L1." . int( rand(999999999) );
	$activity        = int( rand(2) );
	print
"$id\t$timestamp\t$duration\t$url\t$video_name\t$description\t$staff_id\t$homepage\t$mod_instance_id\t$activity\n";
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
