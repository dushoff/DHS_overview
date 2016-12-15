use strict;
use 5.10.0;

my $convert = 'convert/';
my $download = 'convert/';

while (<>){
	chomp;
	my(
		$Country, $Survey, $Tag, $Type, $Phase, $Manual,
		$Births, $Children, $Couples, $GPS, $HIV, $Household,
		$Individual, $Members, $Men
	) = split /,\s*/;

	if ($Country eq "Country"){
		die "Mismatched header $_" unless $Members eq "Members";
		next;
	}

	say "$convert$Tag.women.Rout: " .
		$download . $Individual . "fl.sav"
	if $Individual;

	say "$convert$Tag.men.Rout: " .
		$download . $Men . "fl.sav"
	if $Men;

	say "$convert$Tag.hiv.Rout: " .
		$download . $HIV . "fl.sav"
	if $HIV;

	say "$convert$Tag.cr.Rout: " .
		$download . $Couples . "fl.sav"
	if $Couples;

	say "$convert$Tag.gps.Rout: " .
		$download . $GPS . "fl.dbf"
	if $GPS;
}

