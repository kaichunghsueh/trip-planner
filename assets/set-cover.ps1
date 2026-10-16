<#
.SYNOPSIS
  Embed the destination's landmark illustration as the cover of a trip HTML file.

.DESCRIPTION
  Picks one illustration from landmarks\index.json (next to this script), converts the WebP
  to base64 and writes it into the <script type="text/plain" id="trip-cover"> block of the
  HTML as data:image/webp;base64,... It also sets data-subject (Traditional Chinese name) and
  data-subject-en (English name) from name.zh-TW / name.en; the page picks the one for its
  current language. Running it again replaces the previous cover. The file is written back
  as UTF-8 without BOM.

  -Lang is no longer needed (v1.6: the page is Traditional Chinese + English and both names are
  always written). zh-TW and en are accepted and change nothing; zh-CN was removed and is an error.

  Pick order:
    1. -Key, if given.
    2. -City against match.places of entries whose match.level is city, then region, then
       country (case-insensitive, trimmed, exact match).
    3. -Country against match.countries of entries whose match.level is country.
    4. The fallback entry ("generic").

  Works on Windows PowerShell 5.1 and PowerShell 7+. This file is ASCII-only on purpose.

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File set-cover.ps1 -Html .\trip-busan-2026-10-19.html -City Busan -Country KR
.EXAMPLE
  pwsh -File set-cover.ps1 -Html .\trip.html -Key it

.NOTES
  Exit codes: 0 ok; 1 no #trip-cover block in the HTML; 2 bad input (missing file, unknown key, broken index).
#>
[CmdletBinding()]
param(
  [Parameter(Mandatory = $true)][string]$Html,
  [string]$City = '',
  [string]$Country = '',
  [string]$Lang = 'zh-TW',
  [string]$Key = ''
)
$ErrorActionPreference = 'Stop'

function Fail([int]$code, [string]$msg) {
  [Console]::Error.WriteLine('set-cover: ' + $msg)
  exit $code
}

if ($Lang -eq 'zh-CN') { Fail 2 '-Lang zh-CN was removed in v1.6: trip pages are Traditional Chinese (zh-TW) + English (en) only, and both names are always written. Drop -Lang.' }
if (@('zh-TW', 'en') -notcontains $Lang) { Fail 2 ('-Lang must be zh-TW or en (and is not needed any more: both names are always written); got "' + $Lang + '"') }

$here = if ($PSScriptRoot) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
$dir = Join-Path $here 'landmarks'
$indexPath = Join-Path $dir 'index.json'
if (-not (Test-Path -LiteralPath $Html -PathType Leaf)) { Fail 2 ('HTML file not found: ' + $Html) }
if (-not (Test-Path -LiteralPath $indexPath -PathType Leaf)) { Fail 2 ('index.json not found: ' + $indexPath) }

$utf8 = New-Object System.Text.UTF8Encoding($false)
try {
  $index = [System.IO.File]::ReadAllText($indexPath, [System.Text.Encoding]::UTF8) | ConvertFrom-Json
} catch {
  Fail 2 ('index.json could not be parsed: ' + $_.Exception.Message)
}
$entries = @($index.PSObject.Properties | Where-Object { $_.Value -and $_.Value.file })
if ($entries.Count -eq 0) { Fail 2 'index.json has no entries' }

function Norm([string]$s) { if ($null -eq $s) { return '' } return $s.Trim().ToLowerInvariant() }

$pick = $null
$why = ''
if ($Key.Trim()) {
  $pick = $entries | Where-Object { $_.Name -eq $Key.Trim() } | Select-Object -First 1
  if (-not $pick) { Fail 2 ('unknown -Key "' + $Key + '". Known keys: ' + (($entries | ForEach-Object { $_.Name }) -join ', ')) }
  $why = 'key'
}
if (-not $pick -and $City.Trim()) {
  $c = Norm $City
  foreach ($level in @('city', 'region', 'country')) {
    $pick = $entries | Where-Object {
      $_.Value.match -and $_.Value.match.level -eq $level -and (@($_.Value.match.places) | Where-Object { (Norm ([string]$_)) -eq $c })
    } | Select-Object -First 1
    if ($pick) { $why = $level + ' place'; break }
  }
}
if (-not $pick -and $Country.Trim()) {
  $k = Norm $Country
  $pick = $entries | Where-Object {
    $_.Value.match -and $_.Value.match.level -eq 'country' -and (@($_.Value.match.countries) | Where-Object { (Norm ([string]$_)) -eq $k })
  } | Select-Object -First 1
  if ($pick) { $why = 'country' }
}
if (-not $pick) {
  $pick = $entries | Where-Object { $_.Value.match -and $_.Value.match.level -eq 'fallback' } | Select-Object -First 1
  if (-not $pick) { $pick = $entries | Where-Object { $_.Name -eq 'generic' } | Select-Object -First 1 }
  if (-not $pick) { Fail 2 'no fallback entry in index.json' }
  $why = 'fallback'
}

$entry = $pick.Value
$webp = Join-Path $dir ([string]$entry.file)
if (-not (Test-Path -LiteralPath $webp -PathType Leaf)) { Fail 2 ('illustration file missing: ' + $webp) }
$bytes = [System.IO.File]::ReadAllBytes($webp)
$dataUrl = 'data:image/webp;base64,' + [System.Convert]::ToBase64String($bytes)

function Attr([string]$s) { return $s.Replace('&', '&amp;').Replace('"', '&quot;').Replace('<', '&lt;').Replace('>', '&gt;') }
$nameZh = ''; $nameEn = ''
if ($entry.name) { $nameZh = [string]$entry.name.'zh-TW'; $nameEn = [string]$entry.name.en }
if (-not $nameZh -or -not $nameEn) { Fail 2 ('index.json entry "' + $pick.Name + '" needs both name.zh-TW and name.en') }
$subject = Attr $nameZh
$subjectEn = Attr $nameEn

$htmlPath = (Resolve-Path -LiteralPath $Html).ProviderPath
$text = [System.IO.File]::ReadAllText($htmlPath, [System.Text.Encoding]::UTF8)

# Validate and auto-normalize #trip-data and #trip-data-en if present
$rxZh = New-Object System.Text.RegularExpressions.Regex('<script\s+type="application/json"\s+id="trip-data"[^>]*>([\s\S]*?)</script>')
$rxEn = New-Object System.Text.RegularExpressions.Regex('<script\s+type="application/json"\s+id="trip-data-en"[^>]*>([\s\S]*?)</script>')
$mZh = $rxZh.Match($text)
$mEn = $rxEn.Match($text)
$bilingualStatus = 'skipped'

if ($mZh.Success) {
  $rawZh = $mZh.Groups[1].Value.Trim()
  try {
    $dataZh = $rawZh | ConvertFrom-Json
  } catch {
    Fail 3 ('#trip-data is not valid JSON: ' + $_.Exception.Message)
  }
  if ($mEn.Success -and $mEn.Groups[1].Value.Trim()) {
    $rawEn = $mEn.Groups[1].Value
    # Auto-normalize accidental full-width punctuation in #trip-data-en outside nameLocal / addressLocal
    $rxSan = New-Object System.Text.RegularExpressions.Regex('"(?:nameLocal|addressLocal)"\s*:\s*"(?:\\.|[^"\\])*"|([\uFF08\uFF09\uFF5E\u3001\uFF0C\uFF1A\uFFE6\u201C\u201D\u2018\u2019])')
    $sanEn = $rxSan.Replace($rawEn, {
      param($match)
      if (-not $match.Groups[1].Success) { return $match.Value }
      switch ([int][char]$match.Groups[1].Value[0]) {
        0xFF08 { return ' (' }
        0xFF09 { return ')' }
        0xFF5E { return '-' }
        0x3001 { return ', ' }
        0xFF0C { return ', ' }
        0xFF1A { return ': ' }
        0xFFE6 { return 'KRW ' }
        0x201C { return '\"' }
        0x201D { return '\"' }
        0x2018 { return "'" }
        0x2019 { return "'" }
        default { return $match.Value }
      }
    })
    if ($sanEn -ne $rawEn) {
      $rawEn = $sanEn
      $newEnBlock = '<script type="application/json" id="trip-data-en">' + $rawEn + '</script>'
      $text = $text.Substring(0, $mEn.Index) + $newEnBlock + $text.Substring($mEn.Index + $mEn.Length)
    }
    try {
      $dataEn = $rawEn.Trim() | ConvertFrom-Json
    } catch {
      Fail 3 ('#trip-data-en is not valid JSON: ' + $_.Exception.Message)
    }
    $genZh = if ($dataZh.meta -and $dataZh.meta.generator) { [string]$dataZh.meta.generator } else { '' }
    $genEn = if ($dataEn.meta -and $dataEn.meta.generator) { [string]$dataEn.meta.generator } else { '' }
    if ($genZh -notmatch 'template-demo') {
      if ($genEn -match 'template-demo') {
        Fail 3 '#trip-data-en still contains template demo data (meta.generator is trip-template-demo). Replace #trip-data-en with the English JSON.'
      }
      $langZh = if ($dataZh.meta -and $dataZh.meta.language) { [string]$dataZh.meta.language } else { '' }
      $langEn = if ($dataEn.meta -and $dataEn.meta.language) { [string]$dataEn.meta.language } else { '' }
      $errs = New-Object System.Collections.Generic.List[string]
      if ($langZh -ne 'zh-TW') { $errs.Add('zh: meta.language must be "zh-TW" (got "' + $langZh + '")') }
      if ($langEn -ne 'en') { $errs.Add('en: meta.language must be "en" (got "' + $langEn + '")') }
      $rxSameK = New-Object System.Text.RegularExpressions.Regex('^(schemaVersion|generatedAt|generator|shareUrl|userLanguage|id|stayId|itemId|passport|pace|budgetLevel|primary|decidedBy|kind|transport|mode|status|per|category|scope|when|apps|result|date|start|end|at|airportArriveBy|checkIn|checkOut|checkInTime|checkOutTime|startDate|endDate|dayStart|dayEnd|asOf|checked|country|timezone|airport|flight|homeCurrency|localCurrency|code|currency|url|licenseUrl|sourceUrl|number|phone|for|license|nameLocal|addressLocal|redacted)$')
      $rxCjkOk = New-Object System.Text.RegularExpressions.Regex('^(nameLocal|addressLocal|url|sourceUrl|licenseUrl|shareUrl)$')
      $rxCjk = New-Object System.Text.RegularExpressions.Regex('[\u1100-\u11FF\u3000-\u303F\u3040-\u30FF\u3130-\u318F\u3400-\u9FFF\uAC00-\uD7AF\uF900-\uFAFF\uFF00-\uFFEF]')

      function Get-Kind($v) {
        if ($null -eq $v) { return 'null' }
        if ($v -is [bool]) { return 'boolean' }
        if ($v -is [string]) { return 'string' }
        if ($v -is [int] -or $v -is [long] -or $v -is [double] -or $v -is [decimal]) { return 'number' }
        if ($v -is [System.Array]) { return 'array' }
        if ($v -is [pscustomobject]) { return 'object' }
        return 'other'
      }

      function Walk-Pair($a, $b, [string]$p, [string]$k) {
        $ta = Get-Kind $a
        $tb = Get-Kind $b
        if ($ta -ne $tb) { $errs.Add($p + ': ' + $ta + ' vs ' + $tb); return }
        if ($ta -eq 'array') {
          if ($a.Count -ne $b.Count) { $errs.Add($p + ': length ' + $a.Count + ' vs ' + $b.Count) }
          $min = [Math]::Min($a.Count, $b.Count)
          for ($i = 0; $i -lt $min; $i++) { Walk-Pair $a[$i] $b[$i] ($p + '[' + $i + ']') $k }
          return
        }
        if ($ta -eq 'object') {
          $ka = @($a.PSObject.Properties | ForEach-Object { $_.Name })
          $kb = @($b.PSObject.Properties | ForEach-Object { $_.Name })
          if (($ka -join "`n") -ne ($kb -join "`n")) {
            $lackEn = @($ka | Where-Object { $kb -notcontains $_ } | ForEach-Object { 'en lacks ' + $_ })
            $lackZh = @($kb | Where-Object { $ka -notcontains $_ } | ForEach-Object { 'zh lacks ' + $_ })
            $diff = @($lackEn + $lackZh)
            $whyDiff = if ($diff.Count -gt 0) { ($diff | Select-Object -First 3) -join ', ' } else { 'order' }
            $errs.Add($(if ($p) { $p } else { '(root)' }) + ': keys differ (' + $whyDiff + ')')
          }
          foreach ($prop in $ka) {
            if ($kb -contains $prop) {
              $np = if ($p) { $p + '.' + $prop } else { $prop }
              Walk-Pair $a.$prop $b.$prop $np $prop
            }
          }
          return
        }
        if ($ta -eq 'string') {
          if ($k -eq 'rule') {
            $ma = [regex]::Match($a, '^\s*(\d+)')
            $mb = [regex]::Match($b, '^\s*(\d+)')
            $na = if ($ma.Success) { [int]$ma.Groups[1].Value } else { -1 }
            $nb = if ($mb.Success) { [int]$mb.Groups[1].Value } else { -2 }
            if ($na -ne $nb) { $errs.Add($p + ': rule number differs') }
          } elseif ($rxSameK.IsMatch($k) -and ([string]$a -cne [string]$b)) {
            $errs.Add($p + ': must be identical')
          }
          if (-not $rxCjkOk.IsMatch($k) -and $rxCjk.IsMatch([string]$b)) {
            $errs.Add('en: ' + $p + ' contains CJK or full-width char')
          }
          return
        }
        if ($a -ne $b) { $errs.Add($p + ': value differs') }
      }

      Walk-Pair $dataZh $dataEn '' ''
      if ($errs.Count -gt 0) {
        $top5 = ($errs | Select-Object -First 5) -join '; '
        Fail 3 ('bilingual consistency check failed (' + $errs.Count + ' issue(s)): ' + $top5)
      }
      $bilingualStatus = 'ok'
    }
  }
}

$rx = New-Object System.Text.RegularExpressions.Regex('<script\s+type="text/plain"\s+id="trip-cover"[^>]*>[\s\S]*?</script>')
$m = $rx.Match($text)
if (-not $m.Success) { Fail 1 ('no <script type="text/plain" id="trip-cover"> block in ' + $htmlPath) }
$block = '<script type="text/plain" id="trip-cover" data-subject="' + $subject + '" data-subject-en="' + $subjectEn + '">' + $dataUrl + '</script>'
$text = $text.Substring(0, $m.Index) + $block + $text.Substring($m.Index + $m.Length)
[System.IO.File]::WriteAllText($htmlPath, $text, $utf8)

$out = 'set-cover: key={0} ({1}) file={2} webp={3} bytes base64={4} chars html={5} bytes bilingual={6}' -f $pick.Name, $why, $entry.file, $bytes.Length, $dataUrl.Length, (Get-Item -LiteralPath $htmlPath).Length, $bilingualStatus
Write-Output $out
exit 0
