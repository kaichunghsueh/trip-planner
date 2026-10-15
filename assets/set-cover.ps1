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
$rx = New-Object System.Text.RegularExpressions.Regex('<script\s+type="text/plain"\s+id="trip-cover"[^>]*>[\s\S]*?</script>')
$m = $rx.Match($text)
if (-not $m.Success) { Fail 1 ('no <script type="text/plain" id="trip-cover"> block in ' + $htmlPath) }
$block = '<script type="text/plain" id="trip-cover" data-subject="' + $subject + '" data-subject-en="' + $subjectEn + '">' + $dataUrl + '</script>'
$text = $text.Substring(0, $m.Index) + $block + $text.Substring($m.Index + $m.Length)
[System.IO.File]::WriteAllText($htmlPath, $text, $utf8)

$out = 'set-cover: key={0} ({1}) file={2} webp={3} bytes base64={4} chars html={5} bytes' -f $pick.Name, $why, $entry.file, $bytes.Length, $dataUrl.Length, (Get-Item -LiteralPath $htmlPath).Length
Write-Output $out
exit 0
