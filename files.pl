use strict;
use 5.10.0;

my %recodes;
my %countries;

while(<>){
	chomp;
	# Header line

	my ($Country, $Survey, $Type, $Phase, $Manual, $Data, $GPS, $Bio, $SPA, $Tag) = split /,\s*/;

	next if $Country eq "Country";

	# Looking for Standard DHS with a data link
	next unless $Data =~ /\.cfm/;

	# India has a completely different format
	next if $Country =~ /India\b/;

	# Store the survey information
	$countries{$Country}->{$Survey}->{Tag}=$Tag;
	$countries{$Country}->{$Survey}->{Type}=$Type;
	$countries{$Country}->{$Survey}->{Phase}=$Phase;
	$countries{$Country}->{$Survey}->{Manual}=$Manual;

	# Get a page dump (generated above) and parse in an ugly fashion.
	open (PAGE, $Data) or die "Could not open file $Data";
	while (<PAGE>) {last if /<table.*Survey Data/};
	my $Recode="";
	while (<PAGE>){
		chomp;

		# Recognize category banners and set recode codes
		$Recode="" if /td_style32/;
		if (/td_style32/../\/td/){
			# Non-standard codings (there's a lot now; rationalize somehow)
			next if /Child\b/;
			next if /Village/;
			next if /Adult/;
			next if /Expenditure/;
			next if /Other/;
			next if /Service/;
			next if /Verbal/;
			next if /Wealth/;
			## next if /Women/; ## Is this the same as Individual?
			if (/^[A-Z]/){
				s/Individual/Women/;
				s/Household Member/Members/;
				s/\W.*//s;
				$Recode=$_;
				$recodes{$Recode} = 0;
			}
		}

		# Another kind of banner
		if (/datasetType/){
			s/[^>]*>//;
			s/<.*//;
			next if /Other/;
			next if /SPA/;
			s/Geographic/GPS/;
			s/\W.*//s;
			$Recode=$_;
			$recodes{$Recode} = 0;
		}

		$Recode = "" if (/datasetType/i);

		if (/zip/ and $Recode){
			s/\s*<[^>]*>\s*$//;
			s/\.zip$//s or die ("did not understand zip name $_");
			s/^\s*//;
			s/[a-z]{2}$//;

			$countries{$Country}->{$Survey}->{$Recode}->{$_}=0;
		}
		# last if /Geographic Data/;
	}
	close(PAGE);
}

my @recodes = sort keys %recodes;
print "Country, Survey, Tag, Type, Phase, Manual, ";
say join ", ", @recodes;

foreach my $Country (sort keys %countries){
	my %Country = %{$countries{$Country}};
	foreach my $Survey (sort keys %Country){
		print "$Country, $Survey, ";
		my %Survey = %{$Country{$Survey}};
		print
			"$Survey{Tag}, $Survey{Type}, $Survey{Phase}, $Survey{Manual}";
		foreach my $Recode (@recodes){
			my @sets = keys %{$Survey{$Recode}};
			say STDERR 
				"Wrong number of sets $Survey, $Country, $Recode, @sets"
				if $#sets>0;

			{no warnings 'uninitialized';
				print ", " . join "..", @sets;
			}
		}
		say "";
	}
}
