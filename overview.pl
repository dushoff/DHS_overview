use strict;
use 5.10.0;

undef $/;

my @f = split /<h5>/, <>;
shift @f;

say ("Country, Survey, Type, Phase, Manual, Data, GPS, Bio, SPA");

foreach my $rec (@f){
	$rec =~ s/ \(([\w ]*)\)/ $1/g;
	my ($country, $tab) = 
		$rec =~ m|(.*)</h5>(.*)|s;
		next if $country =~ /Ondo State/;

	foreach my $record (split /<tr>/, $tab){
		next unless $record =~ /<td/;
		$record =~ s|</tr>||;

		my @cell = split /<td[^>]*?>/, $record;
		shift @cell;
		my $survey = shift @cell;
		$survey =~ s/.*cfm">//;

		$survey =~ s/.*$country//s
			or die "country $country not matched by survey $survey";
		$survey=~ s/\s*<.*//s;
		foreach my $cell (@cell){
			$cell =~ s/<[^>]*what-we-do[^>]*>//;
			$cell =~ s|\s*</td>.*||s;
			$cell =~ s|.*href="/data/dataset/([^?]*).*|$1|;
		}
		say join ", ", ($country, $survey, @cell);
		# say "SURVEY: $survey";
	}
}
