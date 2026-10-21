<div align="center">

# ✈️ trip-planner

**Tell Copilot where you're going and when. Get a complete, verified travel itinerary in a single HTML file you can double-click to open.**

🌐 **[English](./README.en.md) ｜ [繁體中文](./README.md)**

[![Version](https://img.shields.io/badge/version-v1.9-D6246E?style=flat-square)](./CHANGELOG.md)
[![Bilingual](https://img.shields.io/badge/language-English%20%7C%20繁中-2563EB?style=flat-square)](#)
[![Zero Dependency](https://img.shields.io/badge/output-Single%20HTML%20(Zero%20Install)-059669?style=flat-square)](#)
[![Quality Check](https://img.shields.io/badge/self--check-16%20Rules%20%2B%20Google%20★%20Filter-D97706?style=flat-square)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-4F46E5?style=flat-square)](./LICENSE)

<br/>

<table>
  <tr>
    <td align="center" width="25%">
      <img src="assets/landmarks/kr-busan.webp" alt="Busan Seaside Capsule Train" width="160"/><br/>
      <sub><b>🇰🇷 Busan Seaside Capsule Train</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="assets/landmarks/jp-fuji.webp" alt="Mount Fuji" width="160"/><br/>
      <sub><b>🇯🇵 Mount Fuji & Lake Kawaguchi</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="assets/landmarks/de.webp" alt="Neuschwanstein Castle" width="160"/><br/>
      <sub><b>🇩🇪 Neuschwanstein Castle</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="assets/landmarks/no.webp" alt="Norwegian Stave Church" width="160"/><br/>
      <sub><b>🇳🇴 Norwegian Stave Church</b></sub>
    </td>
  </tr>
</table>

<sub>▲ Comes with 29 original Blender 3D cover illustrations (Asia-Pacific, all 5 Nordic countries, Europe, US & Australia), embedded directly into the HTML so they work offline.</sub>

</div>

---

## 💡 What is this?

`trip-planner` is a GitHub Copilot skill. Say **"plan a trip for me"** or drop a one-liner like **"5 days in Busan starting Oct 19"**.

It asks at most two quick rounds of questions, looks up real flight schedules, opening hours, and Google ratings, and hands you **one self-contained `.html` file**. No Python, no Node, no server, no API keys — just double-click it in any browser on your laptop or phone:

- 🗓️ **Stop-by-stop daily timeline + sunset guardrails (v1.9)**: Exact arrival/departure times, transit lines, walking distances, ticket costs, and rain backups for every stop. It checks local sunset times so you don't end up visiting an unlit shrine at 6 PM in November — and won't lazily tell you to "head back to the hotel and relax" at 4 PM on a regular city day.
- ⭐ **Google rating filters, local tips & 🎁 snack/souvenir checklist (v1.7–v1.9)**: Hotel picks prioritize **Google 4.0★+ (100+ reviews)**; restaurants prioritize **Google 4.2★+ (100+ reviews)** with signature dishes, how to order/pay, and 1–2 nearby backup spots. Sightseeing stops include practical walking routes, photo spots, and must-try local street food or souvenirs (automatically collected into a checkable **🎁 Local snacks & souvenirs** list).
- 🌤️ **Live weather + 3-year historical fallback + 💴 bill splitter (v1.9)**: Trips within 16 days pull live Open-Meteo forecasts. Trips further out (>16 days) automatically query the Open-Meteo Historical Archive API for the **past 3 years' same-day weather** (plus a mandatory built-in `climate` fallback when completely offline), so the weather strip is never blank. The Budget tab also includes an offline 2-way currency converter and per-person bill splitter.
- ⚡ **Live "Plan B" rerouting & 🔋 daily energy meter (v1.9)**: Running 30 or 60 minutes late? Raining? Kids out of energy? Tap a button on any day to shift flexible stops while keeping booked restaurants and flights locked, swap outdoor stops for indoor rain backups, or trade an afternoon sight for a café recharge break.
- 🌐 **True bilingual switch (English / 繁體中文) + local script cards**: Toggle the entire page between English and Traditional Chinese anytime. Every stop keeps its local-language name and address (`Korean: …`, `Japanese: …`) right below the title so you can show your phone screen to a taxi driver or staff.
- 🛡️ **16-rule self-check + browser verification**: When you open the HTML file, the browser independently verifies coordinates, travel speeds, missing transit legs (`#4`), restaurants lazily sharing hotel coordinates (`#5`), after-dark outdoor stops (`#7`), and back-to-back exhausting outdoor stops (`#15`).

---

## ✨ What it handles for you

| Area | How it works |
|---|---|
| 🎯 **2-round intake + day-by-day preview** | Asks at most 2 rounds of questions (only 3 required ★ questions; everything else has sensible defaults). Before it starts building the full schedule, it confirms your flight times/passport and shows a **1-line-per-day area outline** so you can sanity-check the route first. |
| 🏨 **Rated hotel recommendations** | Routes each day as a closed loop starting and ending at your hotel — including luggage drop-offs, returning to your old hotel to pick up stored bags, and kimono/gear returns. If you haven't booked a hotel yet, each stay includes **3 distinct options** (top pick, budget-friendly, best location/view) filtered for **Google 4.0★+ and 100+ reviews**. |
| 🍜 **Vetted restaurants with real coordinates** | Picks restaurants within a 10-minute detour and outside peak queue hours, prioritizing **Google 4.2★+ (100+ reviews)**. Every meal has a primary restaurant with its own exact street coordinates (never copied from the hotel) plus **1–2 nearby high-rated backups**. |
| 🚶 **Realistic walking & queue times** | Uses actual sightseeing walking speeds (4 km/h in cities, 3 km/h on trails/markets), bakes theme-park/cable-car queue times into stop durations, caps daily transit at 150 minutes, and works backward from a 3-hour airport arrival buffer. |
| 🍁 **Seasonality & rain backups** | Checks foliage, cherry blossoms, ski seasons, festivals, and seasonal closures for your exact dates. Every outdoor stop (`indoor: false`) gets a same-neighborhood indoor rain backup (`rainAlt`). |
| 🚇 **Mode-aware routing** | **Public transit**: compares rail passes/IC cards against single tickets and checks last trains. **Driving**: checks parking at every stop and hotel, cross-border drop-offs, and IDP rules. **Taxis**: includes local-script address cards and ride-hailing apps. In South Korea, navigation defaults to Naver Map & KakaoMap first. |
| 👨‍👩‍👧 **Family, stroller & senior pacing** | Traveling with young kids, seniors, or a stroller? It automatically multiplies walking and subway transfer times by **1.3×**, calls out elevator exits, warns about steep stairs, and prevents back-to-back 90+ minute outdoor marches. |
| 🔍 **Sourced facts & Wikimedia photos** | Prints progress updates while researching, fetches 800px attraction photos with full author/license attribution from the public Wikimedia Commons API, and flags anything it can't verify as `Unverified` instead of making things up. |

---

## 📦 Installation

> [!TIP]
> **No Python, Node.js, or package installs needed.** Just drop the folder into `~/.copilot/skills/trip-planner/` once — GitHub Copilot App, Copilot CLI, and VS Code Copilot will all pick it up.

### Supported Platforms

| Platform | Install Location | Status |
|---|---|---|
| **GitHub Copilot App** | `~/.copilot/skills/trip-planner/` (Option 1) | ✅ Tested (Windows) |
| **GitHub Copilot CLI** | Same as above | ✅ Tested (Windows, CLI 1.0.95+) |
| **VS Code GitHub Copilot** | Same as above ([official docs](https://code.visualstudio.com/docs/agent-customization/agent-skills) also support `~/.claude/skills/` and `~/.agents/skills/`) | 📘 Per official docs |
| **Copilot Cowork (M365)** | Upload ZIP in the Cowork UI (Option 3) | 🧪 Cloud sandbox |

### Check the folder layout

Make sure `SKILL.md` sits directly inside `trip-planner/` — **not nested an extra folder deep** (i.e., avoid `trip-planner/trip-planner/SKILL.md`):

```text
trip-planner/
├── SKILL.md                      # Skill workflow & trigger rules
├── README.md                     # Documentation (Traditional Chinese)
├── README.en.md                  # Documentation (English)
├── CHANGELOG.md                  # Release notes
├── assets/
│   ├── trip-template.html        # Bilingual interactive HTML template (MapLibre + Open-Meteo)
│   ├── set-cover.ps1             # Cover illustration & bilingual JSON validator (Windows PowerShell)
│   ├── set-cover.sh              # Cover illustration & bilingual JSON validator (macOS / Linux bash + perl)
│   └── landmarks/
│       ├── index.json            # Landmark matching index
│       └── *.webp                # 29 original Blender landmark illustrations
└── references/
    ├── intake-questions.md       # 10 intake questions & templates
    ├── planning-rules.md         # 12 planning rules & 16 self-check criteria
    └── trip-data-contract.md     # Bilingual JSON schema contract (schemaVersion "1")
```

---

### Option 1: Personal install (Recommended — works across all projects)

Copy the `trip-planner` folder to `~/.copilot/skills/trip-planner/`.

> [!NOTE]
> If you downloaded the repo via GitHub's **Code → Download ZIP**, the unzipped folder will be named `trip-planner-main`. Rename it to `trip-planner` before moving it into `skills/` so that `skills/trip-planner/SKILL.md` exists.

#### 🪟 Windows
1. Open File Explorer, paste `%USERPROFILE%\.copilot\skills` into the address bar, and press `Enter` (create `.copilot\skills` under `%USERPROFILE%` if it doesn't exist yet).
2. Drag the `trip-planner` folder inside.
3. Verify that `C:\Users\<you>\.copilot\skills\trip-planner\SKILL.md` exists.

#### 🍎 macOS / Linux
```bash
mkdir -p ~/.copilot/skills
git clone https://github.com/kaichunghsueh/trip-planner.git ~/.copilot/skills/trip-planner
```

---

### Option 2: Repository install (Shared with your team)

Copy the `trip-planner` folder into `.github/skills/trip-planner/` inside your project repository and commit it. Anyone working in that repo gets the skill automatically.

---

### Option 3: Copilot Cowork (Microsoft 365)

In Cowork, go to **Customize** → **Skills** → **arrow next to Add** → **Upload skill**, and upload a password-free ZIP where `SKILL.md` is at the top level ([official guide](https://learn.microsoft.com/en-us/microsoft-365/copilot/cowork/cowork-customize), max 10 MB / 100 files):

- Open the `trip-planner` folder, select `SKILL.md`, `README.md`, `assets`, and `references`, and compress them directly into `trip-planner.zip` so `SKILL.md` sits at the root of the archive.

---

### ✅ Verify it works

1. **Restart Copilot**: Close and reopen the CLI or App, or run `Developer: Reload Window` in VS Code.
2. Ask: **"Do you have the trip-planner skill?"** or jump straight in with **"Plan a trip for me"**.

---

## 🚀 How to use

Three ways to kick off a trip:

### 1. Just say "Plan a trip for me"
It will list 10 quick questions. Reply on a single line by number — anything you skip uses the default:
```text
1 Busan  2 Oct 19, 5 days  3 Taipei, land 17:00, fly home 13:00  4 2 adults  5 not booked yet, thinking Seomyeon  6 up to you  7 must see Gamcheon Culture Village  8 public transit
```

### 2. Put everything in one sentence (fastest)
```text
Flying from Taipei to Busan on Oct 19, landing at 17:00, flying back Oct 23 at 13:00. Staying in Seomyeon, taking the subway, 2 adults and a 5-year-old, relaxed pace.
```
It will echo back what it understood and only ask about what's missing.

### 3. Call the skill by name
```text
Use trip-planner to plan a 5-day trip to Busan starting Oct 19.
```

### 📋 The 10 Intake Questions & Defaults

| # | Question | Req. | Default if skipped or "up to you" |
|:---:|---|:---:|---|
| **1** | **Where to?** (list multiple cities in order) | ★ | — (Required) |
| **2** | **Start date & trip length** | ★ | — (Required) |
| **3** | **Departure city; arrival & return flight times** (or flight numbers) | ★ | — (Required) |
| **4** | Group size, kids' ages, seniors, mobility needs, stroller | | `2 adults` |
| **5** | Hotel booked? If not, preferred area & budget | | Recommends best area per base + **3 Google 4.0★+ hotel options** |
| **6** | Already booked tickets, restaurants, concerts, or day tours | | AI plans the full schedule |
| **7** | Must-sees, places to skip, dietary restrictions | | AI curates highlights; no dietary restrictions |
| **8** | Local transport (public transit / taxi / driving / mix) | | `Public transit` |
| **9** | Pace, budget tier, total budget cap, daily start/end hours, night views | | `Balanced`, `Standard`, no cap, `09:00–21:30` |
| **10** | Passport nationality, different passports in group, birthdays/anniversaries | | Inferred from departure city for TW/HK/MO (confirmed before planning); asked otherwise |

> [!IMPORTANT]
> **Things it always confirms before building the full itinerary** (even if you say "use defaults for the rest"):
> 1. **Looked-up flight times** (when you give flight numbers without times)
> 2. **Inferred passport + 1-line-per-day area outline** (so you can approve the daily routing before the deep lookup starts)
> 3. **Kids' ages** (when traveling with children without specifying ages, since tickets and ride limits depend on it)
> 4. **Special activity details** (experience level, gear rental, and insurance for skiing, diving, hiking, or theme parks)

---

## 🖥️ What's inside the generated HTML file

Once finished, you get a standalone file like `trip-busan-2026-10-19.html` in your working directory:

| Feature | Details |
|---|---|
| 💻 **Opens anywhere** | Double-click on desktop, or open on iPhone/Android (works inside mobile previewers like Teams/QuickLook; if an in-app viewer blocks external links or downloads, open in your system browser). |
| 🌐 **English / 繁中 toggle** | Click `繁 / EN` at the top right to switch the entire UI and itinerary content. Every stop displays local script (`Korean: …`, `Japanese: …`) underneath so you can point at it in person. |
| 🗺️ **Interactive map & 1-tap navigation** | View the whole trip or filter by day. Each stop has direct navigation buttons (Naver Map & KakaoMap first for South Korea; Google Maps & Apple Maps elsewhere). When offline or inside a sandboxed previewer, it falls back to a **built-in interactive SVG route map** plus local addresses. |
| 🌤️ **Live forecast + 3-year archive weather** | Pulls live 16-day forecasts from Open-Meteo when online; **for trips >16 days out, automatically averages the past 3 years' same-day historical weather from the Open-Meteo Archive API**, with a mandatory built-in `climate` fallback for offline use. |
| ⚡ **Live Plan B, 📍 Near Me Stash & 🔋 Energy meter** | One-click **Delay +30m/+60m**, **Rain swap**, **Low-energy recharge**, and **📍 Near Me Stash** buttons on every day (locks 🔒 booked meals/flights, filters backup spots within a 10-min walk that are open during your target slot, and swaps them in with one tap). The day header shows a live **🔋 Daily Energy Load %**. |
| 💴 **FX splitter + 🎁 Souvenir checklist** | The Budget tab has an offline 2-way currency converter, per-person bill splitter, and **click-to-expand category bars** showing every line item. The Lists tab gathers all `🎁` local snacks and souvenirs into a checkable shopping list. |
| ✅ **Browser quality check & ⛔ Hours / L.O. guard** | Independently audits overlapping times, missing stays, unrealistic travel speeds, **missing transit legs >80m (`#4`)**, **restaurants sharing coordinates with hotels/sights (`#5`)**, **closed-day / past-Last-Order (`L.O.`) / after-dark outdoor conflicts (`#7`)**, and **back-to-back 90+ min outdoor stops or sightseeing while carrying unstored luggage (`#15`)**. Every stop also includes a 1-tap `🔍 Live status / closures` check. |
| 🔒 **1-click Shareable copy** | Click **Shareable copy** to strip out **hotel names/options, budget numbers, traveler details, flight numbers, or booking info** and export a clean `-share.html` (redacted fields are completely removed from the file's source code and map). |

### 🔄 Want to tweak something? Just ask — no need to replan from scratch

Tell Copilot anytime:
- 💬 `"Only change Day 3 — I want more shopping"`
- 💬 `"Switch transport to a rental car"`
- 💬 `"Change our hotel to [new hotel name or address]"`
- 💬 `"Check for last-minute closures"` / `"Re-verify this itinerary"` (great 24–48 hours before departure: checks Google Maps live status and official Instagram/X posts for independent cafés, ramen shops, and key sights, swapping in a nearby Stash backup if a spot is unexpectedly closed)
- 💬 `"Add an English version to this itinerary"` (upgrades pre-v1.5 single-language HTML files into a bilingual `-v2` file)

---

## 🎨 29 Original Blender Cover Illustrations

The `set-cover` script automatically embeds a ≤ 60 KB original Blender `.webp` illustration matching your destination (**City → Region → Country → Generic fallback**), with zero third-party assets:

| Illustration | Auto-matches when… | Illustration | Auto-matches when… |
|---|---|---|---|
| **Busan Seaside Capsule Train** | City is Busan (`Busan`, `釜山`, `부산`) | **Mount Fuji** | Mt. Fuji area (Kawaguchiko, Fujiyoshida, Fujinomiya, Yamanashi, Shizuoka) |
| **Torii Gate** | Elsewhere in Japan (`JP`, Tokyo, Osaka, Kyoto, Hokkaido, Okinawa…) | **Korean Palace Gate** | Elsewhere in South Korea (`KR`, Seoul, Jeju, Daegu, Gyeongju…) |
| **Taiwan Sky Lantern** | Taiwan (`TW`, Taipei, Pingxi, Jiufen, Taichung, Tainan, Kaohsiung…) | **Hong Kong Junk Boat** | Hong Kong (`HK`, Victoria Harbour, Tsim Sha Tsui, Central, Kowloon…) |
| **Ruins of St. Paul's** | Macau (`MO`, Taipa, Coloane) | **Singapore Shophouse** | Singapore (`SG`, Katong, Joo Chiat) |
| **Thai Pavilion** | Thailand (`TH`, Bangkok, Chiang Mai, Ayutthaya, Phuket) | **Ha Long Bay & Conical Hat** | Vietnam (`VN`, Ha Long Bay, Hanoi, Ho Chi Minh City, Da Nang, Hoi An) |
| **Great Wall** | China (`CN`, Beijing, Shanghai, Chengdu, Xi'an, Hangzhou…) | **Kangaroo** | Australia (`AU`, Sydney, Melbourne, Brisbane, Gold Coast…) |
| **Nyhavn Canal** | Denmark (`DK`, Copenhagen, Nyhavn, Odense, Aarhus) | **Norwegian Stave Church** | Norway (`NO`, Oslo, Bergen, Tromsø, Lofoten, Flåm) |
| **Stockholm City Hall & Dala Horse** | Sweden (`SE`, Stockholm, Gothenburg, Malmö, Kiruna) | **Helsinki Cathedral** | Finland (`FI`, Helsinki, Rovaniemi, Lapland, Turku) |
| **Hallgrímskirkja** | Iceland (`IS`, Reykjavik, Vík, Akureyri, Blue Lagoon) | **Statue of Liberty** | United States (`US`, New York, Los Angeles, San Francisco, Seattle, Hawaii…) |
| **Eiffel Tower** | France (`FR`, Paris, Nice, Lyon, Marseille, Strasbourg) | **Big Ben** | United Kingdom (`GB`, London, Edinburgh, Manchester, Oxford, Cambridge) |
| **Colosseum** | Italy (`IT`, Rome, Milan, Venice, Florence, Naples) | **Neuschwanstein Castle** | Germany (`DE`, Neuschwanstein, Munich, Füssen, Berlin, Frankfurt) |
| **Prague Charles Bridge & Towers** | Czechia (`CZ`, Prague, Charles Bridge, Český Krumlov, Karlovy Vary) | **Dutch Windmill & Tulips** | Netherlands (`NL`, Amsterdam, Rotterdam, Giethoorn, Zaanse Schans) |
| **Sagrada Família** | Spain (`ES`, Barcelona, Madrid, Seville, Granada) | **Matterhorn & Alpine Train** | Switzerland (`CH`, Matterhorn, Zermatt, Zurich, Lucerne, Jungfrau) |
| **Hallstatt Lakeside Village** | Austria (`AT`, Hallstatt, Vienna, Salzburg, Innsbruck) | **Santorini Cliffside Dome Church** | Greece (`GR`, Santorini, Oia, Athens, Mykonos, Crete) |
| **Ready to Travel (Generic)** | Any other destination | — | — |

---

## 🛠️ FAQ & Troubleshooting

<details>
<summary><b>Q1: What happens if I open the HTML file offline?</b></summary>

Everything in your itinerary — the timeline, stop details, addresses, budget converter, and checklists — works completely offline and can be printed.
When there's no internet connection (or a corporate firewall / in-app previewer blocks external map tiles), the map panel automatically switches to a **built-in interactive SVG coordinate route map** alongside local addresses and navigation links. Hit **Retry** once you're back online to load the full vector map.
</details>

<details>
<summary><b>Q2: How does the weather forecast work?</b></summary>

It uses a 4-tier fallback so the weather strip is never empty:
1. **Online & within 16 days of departure**: Fetches the live daily forecast from Open-Meteo and caches it in your browser.
2. **Online & more than 16 days out**: Automatically queries the Open-Meteo Historical Archive API for the **past 3 years' same-day observed weather** (high/low temps, weather icon, precipitation) and caches it locally. When you reopen the same file within 16 days of your trip, it automatically upgrades to the live forecast!
3. **Offline (opened online at least once before)**: Shows the most recently cached forecast or 3-year historical average.
4. **Completely offline & never opened online**: Displays the mandatory `climate` normals embedded in the file.
</details>

<details>
<summary><b>Q3: Why are some stops marked "Unverified" or missing photos?</b></summary>

- **Unverified**: Either the AI environment had no internet access when generating the file, or the venue's closing days/prices weren't published on public web pages. You can ask Copilot to `"Re-verify this itinerary"` closer to your trip.
- **No photo**: Attraction photos only come from Wikimedia Commons with verified author and license metadata. If a confirmed match isn't found, the photo slot is left blank rather than pulling unverified images from random sites.
</details>

<details>
<summary><b>Q4: Why doesn't the budget match the cash exchange rate at my bank?</b></summary>

Budget estimates use the **mid-market rate (`mid`)** with a cited source. Buying physical cash at a bank or airport counter uses the bank's cash selling rate (which includes a spread), and credit cards settle at network rates.
</details>

<details>
<summary><b>Q5: The cover illustration didn't appear — how do I add it manually?</b></summary>

If the AI environment couldn't run shell commands, the page hides the empty cover block automatically. You can embed it manually anytime:
```powershell
# Windows PowerShell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.copilot\skills\trip-planner\assets\set-cover.ps1" -Html "trip-busan-2026-10-19.html" -City "Busan" -Country "KR"
```
```bash
# macOS / Linux
bash ~/.copilot/skills/trip-planner/assets/set-cover.sh -Html "trip-busan-2026-10-19.html" -City "Busan" -Country "KR"
```
</details>

<details>
<summary><b>Q6: I see a bilingual warning banner at the top of the page, or switching to EN still shows Chinese</b></summary>

> ⚠️ **Note**: Always start a **brand-new chat session** after updating the skill so Copilot loads the latest rules.

1. **No language toggle button at all (files generated before v1.5)**:
   Start a new session and say:
   ```text
   Use trip-planner to add an English version to C:\Users\<you>\Downloads\trip-busan-2026-10-19.html — only add English, don't replan the itinerary, and save as a new file.
   ```
2. **Bilingual warning banner at the top (structure mismatch or leftover CJK characters in `#trip-data-en`)**:
   Start a new session and say:
   ```text
   Use trip-planner to fix the bilingual warning in C:\Users\<you>\Downloads\trip-busan-2026-10-19.html: align the English JSON structure with the Chinese JSON at the paths listed in the banner. Only fix the data; do not replan or re-verify.
   ```
3. **Only the `Korean: …` / `Japanese: …` lines under stop names are in another script**:
   That's intentional! Those are `nameLocal` and `addressLocal`, kept in the local script so you can show them to drivers or staff on the ground.
</details>

<details>
<summary><b>Q7: Copilot isn't triggering the `trip-planner` skill</b></summary>

1. Check that the folder isn't double-nested (it must be `…/skills/trip-planner/SKILL.md`).
2. Restart Copilot CLI / App, or run `Developer: Reload Window` in VS Code.
3. Call it explicitly: `"Use trip-planner to plan a 5-day trip to Busan starting Oct 19"`.
</details>

---

## 🔒 Privacy, Terms & Attribution

- **Zero API keys, zero tracking**: The generated HTML file contains no API keys, analytics, or login requirements.
- **External requests on open**: When you open the HTML file online, your browser fetches weather, map tiles, and photos directly from Open-Meteo, OpenFreeMap, jsDelivr, and Wikimedia Commons.
- **Sharing safely**: Use the built-in **Shareable copy** button before sending your file to others if you want to strip out hotels, budget numbers, or personal details.
- **Disclaimer**: Itineraries are AI-assisted. Always double-check opening hours, reservations, and visa requirements with official sources before booking or paying.

| Purpose | Source | License & Attribution |
|---|---|---|
| **Weather & historical archive** | [Open-Meteo.com](https://open-meteo.com/) | CC BY 4.0 (free tier for non-commercial use) |
| **Map data & vector tiles** | © OpenStreetMap contributors / OpenMapTiles / OpenFreeMap | Displayed automatically in the map footer |
| **Map rendering engine** | MapLibre GL JS (via jsDelivr / unpkg) | BSD-3-Clause |
| **Attraction photos** | Wikimedia Commons | Per-photo license & author credited under each image |
| **Cover illustrations** | Original procedural Blender models in this repo | Embedded directly in the HTML, no third-party assets |

---

## 📋 Release History & Known Limitations

### Recent Releases
- **v1.9 (2026-10-19)**: **3-year historical same-day weather for >16d trips, sunset guardrails, Live Plan B rerouting, Energy Load meter, luggage transit state machine, offline FX splitter, souvenir checklist, route/coordinate checks & 29 landmarks**. ① Queries Open-Meteo Historical Archive API for 3-year same-day weather when trips are >16 days out + enforces `climate` in `set-cover`; ② Adds sunset checks (`#7`) and evening city schedule transitions; ③ Adds daily **⚡ Live Plan B** (`+30m/+60m` delay with locked bookings, rain swap, low-energy recharge) and **🔋 Daily Energy Load %** (`#15` stamina & `🧳` luggage transit state-machine check + 1.3× stroller/senior buffer); ④ Enforces primary restaurant coordinates (`#5` `<15m` shared-coordinate check) and full-stage transit continuity (`#4` `>80m` missing-`move` check); ⑤ Adds an offline 2-way FX converter/bill splitter and expandable budget category bars; ⑥ Adds a checkable **🎁 Local snacks & souvenirs** card on the Lists tab; ⑦ Adds 12 Nordic & European Blender cover illustrations (29 total). (See [`CHANGELOG.md`](./CHANGELOG.md))
- **v1.8.1 (2026-10-18)**: **Mobile & email preview compatibility**. Instant 0ms interactive SVG route map fallback for Teams/iOS QuickLook, multi-CDN MapLibre fallback, and static HTML pre-rendering for Gmail attachment previews.
- **v1.8 (2026-10-16)**: **Bilingual JSON auto-validation & insider depth**. `set-cover.ps1`/`set-cover.sh` auto-normalizes full-width punctuation in `#trip-data-en` and validates bilingual parity; requires specific walking routes, photo spots, signature dishes, and ordering tips; adds public Wikimedia Commons API formula, pre-plan daily area outline, and progress heartbeats.
- **v1.7 (2026-10-16)**: **Google rating & review-count filters**. Prioritizes Google 4.0★+ (100+ reviews) for hotel options and 4.2★+ (100+ reviews) for restaurants/cafés with 1–2 nearby backups.
- **v1.6 (2026-10-15)**: **True bilingual pages (Traditional Chinese / English)**. Every file carries aligned `#trip-data` and `#trip-data-en` payloads with one-click switching.

### Known Limitations
- Multi-timezone and multi-currency trips (added in v1.5) are continuously refined based on real-world trips.
- In English mode, the vector map basemap displays Latin/English place labels where available in OpenStreetMap; local-script names (`nameLocal` / `addressLocal`) on every stop card are unaffected.
