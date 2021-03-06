#!/usr/bin/perl
use strict; 
use warnings; 
use LogInforSunhh; 

use Getopt::Long; 
my %opts; 
GetOptions(\%opts, 
	"help!", 
	"faF:s", "gffF:s", 
	"scfID:s", "suff:s", 
); 
sub usage {
	print <<HH; 
################################################################################
# perl $0 -scfID scfID -suff ''
# 
# -faF    [input.scf.fa]
# -gffF   [all.gff3]
################################################################################
HH
	exit 1; 
}

$opts{'help'} and &usage(); 

my $faF  = $opts{'faF'} // 'PG1All_v2_Scf.unmsk.fa'; 
my $gffF = $opts{'gffF'} // 'r2_all.gff3'; 

my $id = $opts{'scfID'} // shift; 
my $add = $opts{'suff'} // ''; 

defined $id or &usage(); 

open F,'<',"$gffF" or die; 
open O,'>',"cur$add.gff3" or die; 
while (<F>) {
	m/^$id\t/o or next; 
	chomp; 
	my @ta = split(/\t/, $_); 
#	unless ($ta[1] =~ m/^pred_gff:augustus|maker|pred_gff:augustus_masked|pred_gff:snap_masked$/) {
#		$ta[8] =~ s!Name=[^;\s]+;?!!g; 
		$ta[8] =~ s!Target=[^;\s]+;?!!g; 
#	}
	print O join("\t", @ta)."\n"; 
}
close O; 
close F; 
exeCmd( "deal_fasta.pl $faF -res $id > cur$add.fasta" ); 
