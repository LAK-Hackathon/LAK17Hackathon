# Rough and ready GUUID CSV generator
# perl -MCPAN -e shell
# install Data::UUID
my $limit=1000;

use Data::GUID;
  
while ($count++ < $limit){
	my $guid = Data::GUID->new;
	my $string = $guid->as_string;
	print "$string\n";
}
