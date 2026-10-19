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
# Exit codes: 0 ok; 1 no #trip-cover block; 2 bad input; 3 JSON syntax or bilingual/climate validation failure.
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
use B (); use JSON::PP (); use MIME::Base64 ();
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
my $bilingual = "skipped";
if ($doc =~ m{<script\s+type="application/json"\s+id="trip-data"[^>]*>(.*?)</script>}s) {
  my $raw_zh = $1;
  my $zh = eval { JSON::PP->new->utf8->decode($raw_zh) } or fail(3, "#trip-data is not valid JSON: $@");
  if ($doc =~ m{<script\s+type="application/json"\s+id="trip-data-en"[^>]*>(.*?)</script>}s) {
    my $raw_en = $1;
    if ($raw_en =~ /\S/) {
      my $u_en = $raw_en; utf8::decode($u_en) unless utf8::is_utf8($u_en);
      my %fw = ("\x{FF08}" => " (", "\x{FF09}" => ")", "\x{FF5E}" => "-", "\x{3001}" => ", ", "\x{FF0C}" => ", ", "\x{FF1A}" => ": ", "\x{FFE6}" => "KRW ", "\x{201C}" => "\\\"", "\x{201D}" => "\\\"", "\x{2018}" => "\x27", "\x{2019}" => "\x27");
      my $san = $u_en;
      $san =~ s{("(?:nameLocal|addressLocal)"\s*:\s*"(?:\\.|[^"\\])*")|([\x{FF08}\x{FF09}\x{FF5E}\x{3001}\x{FF0C}\x{FF1A}\x{FFE6}\x{201C}\x{201D}\x{2018}\x{2019}])}{defined $1 ? $1 : $fw{$2}}ge;
      if ($san ne $u_en) {
        utf8::encode($san) if utf8::is_utf8($san);
        $raw_en = $san;
        $doc =~ s{<script\s+type="application/json"\s+id="trip-data-en"[^>]*>.*?</script>}{<script type="application/json" id="trip-data-en">$raw_en</script>}s;
      }
      my $en = eval { JSON::PP->new->utf8->decode($raw_en) } or fail(3, "#trip-data-en is not valid JSON: $@");
      my $gz = (ref $zh->{meta} eq "HASH") ? ($zh->{meta}{generator} // "") : "";
      my $ge = (ref $en->{meta} eq "HASH") ? ($en->{meta}{generator} // "") : "";
      if ($gz !~ /template-demo/) {
        fail(3, "#trip-data-en still contains template demo data (meta.generator is trip-template-demo)") if $ge =~ /template-demo/;
        my $lz = (ref $zh->{meta} eq "HASH") ? ($zh->{meta}{language} // "") : "";
        my $le = (ref $en->{meta} eq "HASH") ? ($en->{meta}{language} // "") : "";
        my @errs;
        push @errs, "zh: meta.language must be \"zh-TW\" (got \"$lz\")" if $lz ne "zh-TW";
        push @errs, "en: meta.language must be \"en\" (got \"$le\")" if $le ne "en";
        my $cl = $zh->{climate};
        if (ref $cl ne "HASH" || !defined $cl->{tempMaxC} || !defined $cl->{tempMinC}) {
          push @errs, "climate: missing climate.tempMaxC / tempMinC (required for >16-day and offline weather display)";
        }
        my $rx_same = qr/^(?:schemaVersion|generatedAt|generator|shareUrl|userLanguage|id|stayId|itemId|passport|pace|budgetLevel|primary|decidedBy|kind|transport|mode|status|per|category|scope|when|apps|result|date|start|end|at|airportArriveBy|checkIn|checkOut|checkInTime|checkOutTime|startDate|endDate|dayStart|dayEnd|asOf|checked|country|timezone|airport|flight|homeCurrency|localCurrency|code|currency|url|licenseUrl|sourceUrl|number|phone|for|license|nameLocal|addressLocal|redacted)$/;
        my $rx_cjk_ok = qr/^(?:nameLocal|addressLocal|url|sourceUrl|licenseUrl|shareUrl)$/;
        my $rx_cjk = qr/[\x{1100}-\x{11FF}\x{3000}-\x{303F}\x{3040}-\x{30FF}\x{3130}-\x{318F}\x{3400}-\x{9FFF}\x{AC00}-\x{D7AF}\x{F900}-\x{FAFF}\x{FF00}-\x{FFEF}]/;
        sub kind_of {
          my ($v) = @_;
          return "null" unless defined $v;
          return "boolean" if JSON::PP::is_bool($v);
          return "array" if ref $v eq "ARRAY";
          return "object" if ref $v eq "HASH";
          my $f = B::svref_2object(\$_[0])->FLAGS;
          return "number" if ($f & (B::SVp_IOK | B::SVp_NOK)) && !($f & B::SVp_POK);
          return "string";
        }
        sub walk_pair {
          my ($a, $b, $p, $k, $er, $rs, $ro, $rc) = @_;
          my ($ta, $tb) = (kind_of($a), kind_of($b));
          if ($ta ne $tb) { push @$er, "$p: $ta vs $tb"; return; }
          if ($ta eq "array") {
            push @$er, "$p: length " . scalar(@$a) . " vs " . scalar(@$b) if @$a != @$b;
            my $min = @$a < @$b ? scalar(@$a) : scalar(@$b);
            for (my $i = 0; $i < $min; $i++) { walk_pair($a->[$i], $b->[$i], "${p}[$i]", $k, $er, $rs, $ro, $rc); }
            return;
          }
          if ($ta eq "object") {
            my %hb = map { $_ => 1 } keys %$b;
            my %ha = map { $_ => 1 } keys %$a;
            my @lack_en = map { "en lacks $_" } grep { !$hb{$_} } sort keys %$a;
            my @lack_zh = map { "zh lacks $_" } grep { !$ha{$_} } sort keys %$b;
            if (@lack_en || @lack_zh) {
              my @d = (@lack_en, @lack_zh);
              splice(@d, 3) if @d > 3;
              push @$er, ($p || "(root)") . ": keys differ (" . join(", ", @d) . ")";
            }
            for my $prop (sort keys %$a) {
              next unless $hb{$prop};
              my $np = $p ? "$p.$prop" : $prop;
              walk_pair($a->{$prop}, $b->{$prop}, $np, $prop, $er, $rs, $ro, $rc);
            }
            return;
          }
          if ($ta eq "boolean") {
            push @$er, "$p: value differs" if ($a ? 1 : 0) != ($b ? 1 : 0);
            return;
          }
          if ($ta eq "number") {
            push @$er, "$p: value differs" if $a != $b;
            return;
          }
          if ($ta eq "string") {
            my ($sa, $sb) = ("$a", "$b");
            utf8::decode($sa) unless utf8::is_utf8($sa);
            utf8::decode($sb) unless utf8::is_utf8($sb);
            if ($k eq "rule") {
              my ($na) = ($sa =~ /^\s*(\d+)/); $na //= -1;
              my ($nb) = ($sb =~ /^\s*(\d+)/); $nb //= -2;
              push @$er, "$p: rule number differs" if $na != $nb;
            } elsif ($k =~ $rs && $sa ne $sb) {
              push @$er, "$p: must be identical";
            }
            if ($k !~ $ro && $sb =~ $rc) {
              push @$er, "en: $p contains CJK or full-width char";
            }
          }
        }
        walk_pair($zh, $en, "", "", \@errs, $rx_same, $rx_cjk_ok, $rx_cjk);
        if (@errs) {
          my @top = @errs; splice(@top, 5) if @top > 5;
          fail(3, "bilingual consistency check failed (" . scalar(@errs) . " issue(s)): " . join("; ", @top));
        }
        $bilingual = "ok";
        sub hesc { my ($s) = @_; $s = "" unless defined $s; utf8::encode($s) if utf8::is_utf8($s); $s =~ s/&/&amp;/g; $s =~ s/</&lt;/g; $s =~ s/>/&gt;/g; $s =~ s/"/&quot;/g; return $s; }
        my $banner = "\x{1F4E7} \x{90F5}\x{4EF6}\x{9644}\x{4EF6}\x{9810}\x{89BD}\x{6A21}\x{5F0F}\x{FF08}Gmail \x{7B49}\x{90F5}\x{4EF6} App \x{6703}\x{505C}\x{7528} JavaScript \x{4E92}\x{52D5}\x{5206}\x{9801}\x{8207}\x{5730}\x{5716}\x{FF09}\x{3002}\x{82E5}\x{8981}\x{4F7F}\x{7528}\x{5B8C}\x{6574}\x{4E92}\x{52D5}\x{5730}\x{5716}\x{8207}\x{96D9}\x{8A9E}\x{5207}\x{63DB}\x{FF0C}\x{8ACB}\x{9EDE}\x{53F3}\x{4E0A}\x{89D2}\x{300C}\x{5206}\x{4EAB}\x{300D}\x{6539}\x{7528} Teams\x{3001}\x{6A94}\x{6848}\x{6216}\x{700F}\x{89BD}\x{5668}\x{958B}\x{555F}\x{3002}\x{4EE5}\x{4E0B}\x{70BA}\x{5B8C}\x{6574}\x{884C}\x{7A0B}\x{7E3D}\x{89BD}\x{FF1A}";
        utf8::encode($banner) if utf8::is_utf8($banner);
        my $app = "<div style=\"max-width:760px;margin:0 auto;padding:16px;font-family:system-ui,-apple-system,sans-serif;line-height:1.55\">"
          . "<div style=\"padding:10px 12px;border:1px solid #c08a1e;border-radius:8px;background:#fffbeb;color:#5a4300;font-size:13px;margin-bottom:16px\">$banner</div>"
          . "<h1 style=\"font-size:22px;margin:0 0 4px\">" . hesc($zh->{meta}{title}) . "</h1>";
        my $msub = hesc($zh->{meta}{subtitle});
        $app .= "<p style=\"color:#5a5a56;font-size:14px;margin:0 0 16px\">$msub</p>" if length $msub;
        my $didx = 0;
        for my $dy (@{ $zh->{days} || [] }) {
          $didx++;
          my ($dd, $dt, $ds) = (hesc($dy->{date}), hesc($dy->{title}), hesc($dy->{summary}));
          $app .= "<section style=\"border:1px solid #e6e6e2;border-radius:10px;padding:12px 14px;margin-bottom:14px;background:#fff\"><h2 style=\"font-size:17px;margin:0 0 4px\">D$didx ($dd) - $dt</h2>";
          $app .= "<p style=\"font-size:13px;color:#5a5a56;margin:0 0 10px\">$ds</p>" if length $ds;
          $app .= "<ol style=\"margin:0;padding-left:20px;font-size:13.5px\">";
          for my $it (@{ $dy->{items} || [] }) {
            my ($is, $ie, $it_t, $id_t) = (hesc($it->{start}), hesc($it->{end}), hesc($it->{title}), hesc($it->{detail}));
            my $pl = "";
            if (ref $it->{place} eq "HASH") {
              my $pn = hesc($it->{place}{nameLocal});
              my $pa = hesc($it->{place}{addressLocal} || $it->{place}{address});
              $pl = join(" / ", grep { length } ($pn, $pa));
            }
            $app .= "<li style=\"margin-bottom:8px\"><strong>$is-$ie $it_t</strong>";
            $app .= "<div style=\"font-size:12px;color:#5a5a56\">$pl</div>" if length $pl;
            $app .= "<div style=\"font-size:12.5px;margin-top:2px\">$id_t</div>" if length $id_t;
            $app .= "</li>";
          }
          $app .= "</ol></section>";
        }
        $app .= "</div>";
        $doc =~ s{<div\s+id="app">.*?</div>\s*(?=<noscript>)}{<div id="app">$app</div>\n}s;
      }
    }
  }
}
my $block = "<script type=\"text/plain\" id=\"trip-cover\" data-subject=\"$name\" data-subject-en=\"$name_en\">$data</script>";
$doc =~ s{<script\s+type="text/plain"\s+id="trip-cover"[^>]*>.*?</script>}{$block}s
  or fail(1, "no <script type=\"text/plain\" id=\"trip-cover\"> block in $html");
open(my $out, ">:raw", $html) or fail(2, "cannot write $html");
print $out $doc; close $out;
printf "set-cover: key=%s (%s) file=%s webp=%d bytes base64=%d chars html=%d bytes bilingual=%s\n", $pick, $why, $e->{file}, length($bin), length($data), -s $html, $bilingual;
exit 0;
'
