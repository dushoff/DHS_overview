use strict;
use 5.10.0;

my @dhs;
my $header;

my $pat = shift @ARGV or die "pattern argument needed";

while(<>){
	print if /^Country/;
	my ($Country, $Survey, $Type, @rest) = split /,\s*/;
	print if $Type =~ /$pat/;
}
