#!/usr/bin/perl


open (my $maj, "<", "../dat/major.dat") or die $!;
open (my $lsj, "<", "../../lsj/dat/grc-lsj-defs.dat") or die $!;

my %lsj;
while (<$lsj>) {
  chomp;
  my ($lemma, $def) = split /\|/;
  $def =~ s/\n|\r//;
  $lsj{$lemma} = $def;
}

my %maj;
while (<$maj>) {
  chomp;
  my ($lemma, $def, $source) = split /\|/;
  $def =~ s/\n|\r//;
  $maj{$lemma} = [ $def, 'Major' ];
}

for my $lemma (keys %lsj) {
  $lemma =~ s/\d+$//;
  $lemma =~ s/$\@//;
  if ($lsj{$lemma} && ! exists $maj{$lemma} && $lsj{$lemma} ne '@') {
    $maj{$lemma} = [ $lsj{$lemma}, 'LSJ' ];
  }
}

for my $lemma (sort keys %maj) {
  print "$lemma|$maj{$lemma}[0]|$maj{$lemma}[1]\n";
}

