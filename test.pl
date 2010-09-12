use Test::More tests => 16;
BEGIN { use_ok( 'B::Flags' ); }

ok B::main_root->flagspv =~ /VOID/, "main_root VOID";
ok B::main_root->privatepv =~ /REFCOUNTED/, "main_root->privatepv REFCOUNTED";
ok B::svref_2object(\3)->flagspv =~ /READONLY/, "warning 3 READONLY";

# for AV, CV and GV print its flags combined and splitted
my @a = (0..4);
my $SVt_PVAV = $] < 5.010 ? 10 : 11;
my $EVALED = $] < 5.010 ? '' : 'EVALED';
my $av = B::svref_2object( \@a );
ok $av->flagspv =~ /^PAD/, "default ".$av->flagspv." both flags";
ok $av->flagspv($SVt_PVAV) eq $EVALED, $av->flagspv($SVt_PVAV)." AvFLAGS only";
ok $av->flagspv(0) eq $av->flagspv, $av->flagspv(0)." SvFLAGS only";

sub mycv {my $n=1; 1}
my $cv = B::svref_2object( \&main::mycv );
my $pad = ($cv->PADLIST->ARRAY)[1];
SKIP: {
  skip "need AvFLAGS for pad",3 if $] < 5.010;
  ok $pad->flagspv eq 'REAL,EVALED', "default ".$pad->flagspv." both flags";
  ok $pad->flagspv($SVt_PVAV) =~ /^EVALED/, $pad->flagspv($SVt_PVAV)." AvFLAG only";
  ok $pad->flagspv(0) eq 'REAL,EVALED', $pad->flagspv(0)." SvFLAGS only - fallthrough";
}

sub lvalcv:lvalue {my $n=1;}
my $SVt_PVCV = $] < 5.010 ? 12 : 13;
my $cv = B::svref_2object( \&main::lvalcv );
ok $cv->flagspv =~ /LVALUE/, $cv->flagspv." SvFLAGS+CvFLAGS";
ok $cv->flagspv($SVt_PVCV) =~ /^LVALUE/, $cv->flagspv($SVt_PVCV)." CvFLAGS only";
ok $cv->flagspv(0) !~ /LVALUE/, $cv->flagspv(0)." SvFLAGS only";

my $SVt_PVGV = $] < 5.010 ? 13 : 9;
my $gv = B::svref_2object( \*mycv );
ok $gv->flagspv =~ /MULTI/, $gv->flagspv." SvFLAGS+GvFLAGS";
ok $gv->flagspv($SVt_PVGV) =~ /^MULTI/, $gv->flagspv($SVt_PVGV)." GvFLAGS only";
ok $gv->flagspv(0) !~ /MULTI/, $gv->flagspv(0)." SvFLAGS only";
