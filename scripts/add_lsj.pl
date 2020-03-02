#!/usr/bin/perl
use Data::Dumper;


open (my $maj, "<", "../dat/grc-mjp-defs.dat") or die $!;
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
  $maj{$lemma} = [ $def, $source ];
}

for my $lemma (keys %lsj) {
  my $maj_lemma = $lemma;
  $maj_lemma =~ s/\d+$//;
  $maj_lemma =~ s/^\@//;
  if ($lsj{$lemma} && ! exists $maj{$maj_lemma} && $lsj{$lemma} ne '@') {
    $maj{$maj_lemma} = [ $lsj{$lemma}, 'LSJ' ];
  } elsif (! $lsj{$lemma}) {
    warn "Skipping $lemma $lsj{$lemma}\n";
  }
}

for my $lemma (sort keys %maj) {
  print "$lemma|$maj{$lemma}[0]|$maj{$lemma}[1]\n";
}


