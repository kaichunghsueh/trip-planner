#!/usr/bin/env bash
# set-cover.sh - embed the destination's landmark illustration as the cover of a trip HTML file.
#
# macOS / Linux twin of set-cover.ps1 (same options, same pick order, same output).
# Needs only bash and the system perl with core modules JSON::PP and MIME::Base64.
#
# Usage:
#   ./set-cover.sh -Html trip.html [-City Busan] [-Country KR] [-Key kr-busan]
#   (--html / --city / --country / --lang / --key also work)
#
# Pick order: 1) -Key  2) -City vs match.places of level city, region, country (case-insensitive,
# trimmed, exact)  3) -Country vs match.countries of level country  4) the fallback entry (generic).
# Writes data:image/webp;base64,... into <script type="text/plain" id="trip-cover"> and sets
# data-subject (name.zh-TW) and data-subject-en (name.en). Re-running replaces the old cover. UTF-8, no BOM.
# -Lang is no longer needed (v1.6: zh-TW + English pages, both names always written); zh-TW / en are
# accepted and change nothing, zh-CN was removed and is an error.
# Exit codes: 0 ok; 1 no #trip-cover block; 2 bad input.
set -eu

HTML=""; CITY=""; COUNTRY=""; LANG_OPT="zh-TW"; KEY=""
while [ $# -gt 0 ]; do
  case "$1" in
    -Html|--html|-html) HTML="${2-}"; shift 2 ;;
    -City|--city|-city) CITY="${2-}"; shift 2 ;;
    -Country|--country|-country) COUNTRY="${2-}"; shift 2 ;;
    -Lang|--lang|-lang) LANG_OPT="${2-}"; shift 2 ;;
    -Key|--key|-key) KEY="${2-}"; shift 2 ;;
    -h|--help) sed -n '2,18p' "$0"; exit 0 ;;
    *) echo "set-cover: unknown option: $1" >&2; exit 2 ;;
  esac
done
[ -n "$HTML" ] || { echo "set-cover: -Html is required" >&2; exit 2; }
case "$LANG_OPT" in
  zh-TW|en) ;;
  zh-CN) echo "set-cover: -Lang zh-CN was removed in v1.6: trip pages are Traditional Chinese (zh-TW) + English (en) only, and both names are always written. Drop -Lang." >&2; exit 2 ;;
  *) echo "set-cover: -Lang must be zh-TW or en (and is not needed any more: both names are always written); got \"$LANG_OPT\"" >&2; exit 2 ;;
esac
command -v perl >/dev/null 2>&1 || { echo "set-cover: perl not found" >&2; exit 2; }

HERE="$(cd "$(dirname "$0")" && pwd)"
export SC_HTML="$HTML" SC_CITY="$CITY" SC_COUNTRY="$COUNTRY" SC_LANG="$LANG_OPT" SC_KEY="$KEY" SC_DIR="$HERE/landmarks"

exec perl -e '
use strict; use warnings;
use JSON::PP (); use MIME::Base64 ();
sub fail { my ($c, $m) = @_; print STDERR "set-cover: $m\n"; exit $c; }
sub slurp { my ($p) = @_; open(my $fh, "<:raw", $p) or fail(2, "cannot read $p"); local $/; my $d = <$fh>; close $fh; return $d; }
sub norm { my ($s) = @_; $s = "" unless defined $s; utf8::decode($s) unless utf8::is_utf8($s); $s =~ s/^\s+|\s+$//g; return lc $s; }
my ($html, $city, $country, $lang, $key, $dir) = @ENV{qw(SC_HTML SC_CITY SC_COUNTRY SC_LANG SC_KEY SC_DIR)};
-f $html or fail(2, "HTML file not found: $html");
my $ixp = "$dir/index.json";
-f $ixp or fail(2, "index.json not found: $ixp");
my $ix = eval { JSON::PP->new->utf8->relaxed->decode(slurp($ixp)) } or fail(2, "index.json could not be parsed: $@");
my $order = slurp($ixp);   # keep the file order of keys (JSON::PP hashes are unordered); nested objects are filtered out below
my @keys = grep { ref $ix->{$_} eq "HASH" && $ix->{$_}{file} } ($order =~ /"([^"\\]+)"\s*:\s*\{/g);
my %seen; @keys = grep { !$seen{$_}++ } @keys;
push @keys, sort grep { !$seen{$_} && ref $ix->{$_} eq "HASH" && $ix->{$_}{file} } keys %$ix;
my ($pick, $why);
if (length norm($key)) {
  my $k = $key; $k =~ s/^\s+|\s+$//g;
  fail(2, "unknown -Key \"$key\". Known keys: " . join(", ", @keys)) unless grep { $_ eq $k } @keys;
  ($pick, $why) = ($k, "key");
}
if (!$pick && length norm($city)) {
  my $c = norm($city);
  LEVEL: for my $lv (qw(city region country)) {
    for my $k (@keys) {
      my $m = $ix->{$k}{match} or next;
      next unless ($m->{level} // "") eq $lv;
      if (grep { norm($_) eq $c } @{ $m->{places} || [] }) { ($pick, $why) = ($k, "$lv place"); last LEVEL; }
    }
  }
}
if (!$pick && length norm($country)) {
  my $c = norm($country);
  for my $k (@keys) {
    my $m = $ix->{$k}{match} or next;
    next unless ($m->{level} // "") eq "country";
    if (grep { norm($_) eq $c } @{ $m->{countries} || [] }) { ($pick, $why) = ($k, "country"); last; }
  }
}
if (!$pick) {
  ($pick) = grep { (($ix->{$_}{match} || {})->{level} // "") eq "fallback" } @keys;
  $pick //= (grep { $_ eq "generic" } @keys)[0];
  fail(2, "no fallback entry in index.json") unless $pick;
  $why = "fallback";
}
my $e = $ix->{$pick};
my $webp = "$dir/$e->{file}";
-f $webp or fail(2, "illustration file missing: $webp");
my $bin = slurp($webp);
my $data = "data:image/webp;base64," . MIME::Base64::encode_base64($bin, "");
sub attr { my ($s) = @_; $s = "" unless defined $s; utf8::encode($s) if utf8::is_utf8($s); $s =~ s/&/&amp;/g; $s =~ s/"/&quot;/g; $s =~ s/</&lt;/g; $s =~ s/>/&gt;/g; return $s; }
my $nm = (ref $e->{name} eq "HASH") ? $e->{name} : {};
fail(2, "index.json entry \"$pick\" needs both name.zh-TW and name.en") unless length($nm->{"zh-TW"} // "") && length($nm->{en} // "");
my ($name, $name_en) = (attr($nm->{"zh-TW"}), attr($nm->{en}));
my $doc = slurp($html);
my $block = "<script type=\"text/plain\" id=\"trip-cover\" data-subject=\"$name\" data-subject-en=\"$name_en\">$data</script>";
$doc =~ s{<script\s+type="text/plain"\s+id="trip-cover"[^>]*>.*?</script>}{$block}s
  or fail(1, "no <script type=\"text/plain\" id=\"trip-cover\"> block in $html");
open(my $out, ">:raw", $html) or fail(2, "cannot write $html");
print $out $doc; close $out;
printf "set-cover: key=%s (%s) file=%s webp=%d bytes base64=%d chars html=%d bytes\n", $pick, $why, $e->{file}, length($bin), length($data), -s $html;
exit 0;
'
