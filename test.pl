use Test::More tests => 20;
BEGIN { use_ok( 'B::Flags' ); }

ok B::main_root->flagspv =~ /VOID/, "main_root VOID";
ok B::main_root->privatepv =~ /REFCOUNTED/, "main_root->privatepv REFCOUNTED";
ok B::svref_2object(\3)->flagspv =~ /READONLY/, "warning 3 READONLY";

# for AV, CV and GV print its flags combined and splitted
my @a = (0..4);
my $SVt_PVAV = $] < 5.010 ? 10 : 11;
my $EVALED = $] < 5.010 ? '' : 'EVALED';
my $AVFlags = $] < 5.021007 ? 'PAD' : 'REAL';
my $av = B::svref_2object( \@a );
ok $av->flagspv =~ /^$AVFlags/, "AV default ".$av->flagspv." both flags";
ok $av->flagspv($SVt_PVAV) eq $EVALED, $av->flagspv($SVt_PVAV)." AvFLAGS only";
ok $av->flagspv(0) eq $av->flagspv, $av->flagspv(0)." SvFLAGS only";

sub mycv { my $n=1; 1}
my $cv = B::svref_2object( \&main::mycv );
my $pad = ($cv->PADLIST->ARRAY)[1];
SKIP: {
  skip "need AvFLAGS for pad",3 if $] < 5.010;
  ok $pad->flagspv =~ /REAL,EVALED$/, "PAD default ".$pad->flagspv." both flags";
  ok $pad->flagspv($SVt_PVAV) eq 'EVALED', $pad->flagspv($SVt_PVAV)." AvFLAG only";
  ok $pad->flagspv(0) =~ /REAL,EVALED$/, $pad->flagspv(0)." SvFLAGS only - fallthrough";
}

sub lvalcv:lvalue {my $n=1;}
my $SVt_PVCV = $] < 5.010 ? 12 : 13;
my $cv = B::svref_2object( \&main::lvalcv );
ok $cv->flagspv =~ /LVALUE/, "LVCV ".$cv->flagspv." SvFLAGS+CvFLAGS";
ok $cv->flagspv($SVt_PVCV) =~ /^LVALUE/, $cv->flagspv($SVt_PVCV)." CvFLAGS only";
ok $cv->flagspv(0) !~ /LVALUE/, "LVCV ".$cv->flagspv(0)." SvFLAGS only";

my $SVt_PVGV = $] < 5.010 ? 13 : 9;
my $gv = B::svref_2object( \*mycv );
ok $gv->flagspv =~ /MULTI/, "GV ".$gv->flagspv." SvFLAGS+GvFLAGS";
ok $gv->flagspv($SVt_PVGV) =~ /^(MULTI|THINKFIRST,MULTI)/, $gv->flagspv($SVt_PVGV)." GvFLAGS only";
ok $gv->flagspv(0) !~ /MULTI/, $gv->flagspv(0)." SvFLAGS only";

my $padnl = ($cv->PADLIST->ARRAY)[0];
my $result = $] < 5.010 ? "" : ($] < 5.022 ? 'PADNAME,REAL,EVALED' : 'PADNAME');
is $padnl->flagspv, $result, "PADNAMELIST: ".$padnl->flagspv;

my $padn1 = ($padnl->ARRAY)[0];
my $padl1 = (($cv->PADLIST->ARRAY)[1]->ARRAY)[0];
SKIP: {
  skip "empty PADNAME", 1 if ref $padn1 eq 'B::SPECIAL';
  is $padn1->flagspv, 'PADNAME', "PADNAME: ".$padn1->flagspv;
}
SKIP: {
  skip "empty PAD", 1 if ref $padl1 eq 'B::SPECIAL';
  $result = $] < 5.010 ? "" : "REIFY,IsUV";
  is $padl1->flagspv, $result, "PAD: ".$padl1->flagspv;
}

my $pado = ((B::main_cv->PADLIST->ARRAY)[0]->ARRAY)[0];
SKIP: {
  skip "empty PADNAME", 1 if ref $pado eq 'B::SPECIAL';
  is $pado->flagspv, 'PADNAME', "PADNAME: ".$pado->flagspv;
}
