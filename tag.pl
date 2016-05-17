use strict;
use 5.10.0;
my %entries;

while(<>){
	my $tag;
	chomp;
	my ($Country, $Survey, $Type, $Phase, $Manual, @rest) = split /,\s*/;
	if ($Country eq "Country"){
		$tag= "Tag";
		say $_ . ", $tag";
	} else {
		$Country =~ s/ /_/g;
		$Type =~ s/Standard //
			or die($Type . ': Why is this not a "Standard" survey?');
		unless ($Manual =~ s/DHS-//){
			say STDERR
				"Excluding unrecognized manual $Country:$Manual:$Survey";
			next;
		}
		unless ($Phase =~ s/DHS-//){
			say STDERR
				"Excluding unrecognized phase $Country:$Phase:$Survey";
			next;
		}
		$tag = "$Country" . "_$Phase.$Type.$Manual";
		push @{$entries{$tag}}, $_;
	}
}

my @letters = qw(a b c d);
foreach my $tag (sort keys %entries){
	my @entries=@{$entries{$tag}};
	my $len=$#entries;
	for (my $l=0; $l<=$len;$l++){
		my $nt = $tag;
		$nt =~ s/.DHS/$letters[$l]$&/
			if $len>0;
		say $entries{$tag}->[$l] . ", $nt";
	}
}

