use strict;
use 5.10.0;

my $convert = 'convert/';
my $download = 'convert/';

while (<>){
	chomp;
	my(
		$Country, $Survey, $Tag, $Type, $Phase, $Manual,
		$Births, $Children, $Couples, $GPS, $HIV, $Household,
		$Members, $Men, $Women
	) = split /,\s*/;

	if ($Country eq "Country"){
		say STDERR;
		die "Mismatched header $_" unless $Women eq "Women";
		next;
	}

	say "$convert$Tag.women.Rout: " .
		$download . $Women . "fl.sav"
	if $Women;

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

