use strict;
use 5.10.0;

my @var;
my ($varname) = @ARGV;
$varname =~ s/.csv$// or die "What up with input filename?";

while(<>){
	chomp;
	next if /^country/;
	my ($country, $survey, $type, $phase,
		$recode, $data, $gps, $bio, $spa)
		= split /,\s*/;
	next unless $data =~ /\.cfm/;
	if ($bio =~ /\.cfm/){
		die "Dataset $bio does not match $data" unless $bio eq $data;
	}
	push @var, $data;
}

print "$varname = ";
say join " ", @var;
