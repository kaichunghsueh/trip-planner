# 行程資料契約（schemaVersion "1"）

寫 JSON 前讀這份。網頁範本只認這個格式。每份行程寫兩份 JSON：繁中那份放進 `<script type="application/json" id="trip-data">` 和下一個 `</script>` 之間，英文那份放進 `<script type="application/json" id="trip-data-en">` 和下一個 `</script>` 之間。畫面全部由範本從這兩份資料畫出來，切到哪個語言就用哪一份。

v1.1 起新增的欄位都標了版本，全部選填，`schemaVersion` 維持 `"1"`，舊資料不用改。

## 兩份資料：繁中和英文（v1.6）

| 區塊 | 語言 | `meta.language` |
|---|---|---|
| `#trip-data` | 繁中 | 固定 `"zh-TW"` |
| `#trip-data-en` | 英文 | 固定 `"en"` |

兩份照下面的規則對齊。網頁開檔時會逐項比對，對不上就在頁面頂端顯示警示條，列出最多 5 個出錯的路徑（例如 `days[2].items[4].start`、`en: days[1].items[0].title contains CJK`），繁中和英文模式都看得到。這是資料完整性檢查，不算品質規則：AI 自評仍是 16 條，網頁開檔自動驗仍是 13 項。

1. **結構完全相同**：同樣的 key、同樣的 key 順序、同樣的陣列長度和順序。選填欄位要嘛兩份都有，要嘛兩份都省略。
2. **非字串值完全相同**：所有數字（座標、分鐘、金額、匯率、人數、年齡）和 `true`／`false`。
3. **這些字串兩份一字不差**（`meta.language` 除外）：

   | 類別 | 欄位 |
   |---|---|
   | 版本與產出 | `schemaVersion`、`meta.generatedAt`、`meta.generator`、`meta.shareUrl`、`meta.userLanguage` |
   | id 與參照 | `stays[].id`、`days[].stayId`、Item 的 `id`、`traveler.mustDo[].itemId` |
   | 代碼值（契約裡寫成 `"a"\|"b"` 的欄位） | `traveler.passport`、`pace`、`budgetLevel`；`journey.transport.primary`、`transport.decidedBy`、`carRental.decidedBy`、`fx.kind`、`currencies[].kind`；`days[].transport`；Item 的 `kind`、`move.mode`、`booking.status`；`Money.per`；`budget.lines[].category`、`budget.cap.scope`、`budget.cap.per`；`checklists.before[].when`；`navigation.apps[]`；`selfCheck[].result` |
   | 日期與時間 | 所有 `date`、`time`、`localDateTime` 型別的欄位，包括 `SourceRef.checked`、`fx.asOf`、`currencies[].asOf` |
   | 國家、時區 | `journey.destination.country`，以及所有 `timezone` |
   | 機場與航班號 | `origin.airport`、`arrival.airport`、`departure.airport`、`arrival.flight`、`departure.flight` |
   | 幣別代碼 | `homeCurrency`、`localCurrency`、`currencies[].code`、`Money.currency`、`budget.cap.currency` |
   | 網址 | 所有 `url`，以及 `photo.licenseUrl`、`photo.sourceUrl` |
   | 電話與護照代碼 | `emergency.numbers[].number`、`consular[].phone`、`consular[].for`、`hospitals[].phone` |
   | 照片授權 | `photo.license` |
   | 當地原文 | 所有 `nameLocal`、`addressLocal` |

   `selfCheck[].rule` 開頭的編號（例如 `3.`）兩份相同，後面的短名各寫各的語言。上表以外的字串（`title`、`name`、`address`、`detail`、`tips`、`note`、`hours`、`line`、`from`、`airline`、`terminal`、`label`、`text`、`reason`、`sources[].title`、`photo.credit` 等）都要翻成英文。

4. **英文那份只有兩欄能放當地文字**：除了 `nameLocal`、`addressLocal`（網頁會標成當地原文，例如 "Korean: …"）和網址欄位，英文那份的其他字串都不能含下面這些字元。日文名稱裡的漢字也算日文，一樣只能出現在這兩欄：
   - CJK 漢字：U+3400–U+9FFF、U+F900–U+FAFF
   - 日文假名：U+3040–U+30FF（含 `・`）
   - 韓文：U+AC00–U+D7AF、U+1100–U+11FF、U+3130–U+318F
   - 全形標點與全形字元：U+3000–U+303F、U+FF00–U+FFEF（含 `（）`、`、`、`「」`、`～`、`￦`）

   可以用這個正規表示式搜尋殘留，排除 `nameLocal`、`addressLocal` 和網址欄位後要一筆都找不到：

   ```text
   [\u1100-\u11FF\u3000-\u303F\u3040-\u30FF\u3130-\u318F\u3400-\u9FFF\uAC00-\uD7AF\uF900-\uFAFF\uFF00-\uFFEF]
   ```

   網址欄位（`url`、`sourceUrl`、`licenseUrl` 等）不在掃描範圍：網址不會直接顯示在畫面上，兩份照抄、一字不差即可。

英文那份怎麼寫（地名、地址、菜名、固定說法），見 `planning-rules.md` 第 11 節。

**舊檔**：v1.5 以前的檔案只有 `#trip-data`。網頁不顯示語言切換按鈕，介面跟著 `meta.language` 走，舊值 `zh-CN` 會當成繁中，不會報錯。要補英文版，照 `SKILL.md` 第 8 步。

## 型別

- `date`＝`YYYY-MM-DD`
- `localDateTime`＝`YYYY-MM-DDTHH:mm`（目的地當地時間，不帶時區）
- `time`＝`HH:mm`（24 小時制）
- `?`＝選填。沒有資料就整個欄位省略，不要填 `null` 或空字串。

## 契約全文

```text
schemaVersion: "1"
meta: { title, subtitle?, language: "zh-TW"|"en"（#trip-data 固定 "zh-TW"，#trip-data-en 固定 "en"）, userLanguage?: "zh-TW"|"en"（v1.6 新增）, generatedAt: ISO 8601（帶時區）, generator, assumptions: string[], shareUrl? }
traveler: {
  party: { adults, children?, seniors?, note?, childAges?: number[]（v1.1 新增）, mobility?（v1.1 新增） },
  passport?: "TW"|"HK"|"MO"|"other", pace: "relaxed"|"balanced"|"packed", interests?: string[], avoid?: string[], budgetLevel?: "saver"|"standard"|"comfort",
  diet?: string[]（v1.1 新增）,
  mustDo?: [ { text, itemId?, reason? } ]（v1.1 新增）,
  dayStart?: time（v1.1 新增）, dayEnd?: time（v1.1 新增）,
  specialDates?: [ { date, note } ]（v1.1 新增）
}
journey: {
  origin: { city, airport? },
  destination: { city, country（ISO 3166-1 alpha-2）, lat, lon, timezone（IANA） },
  startDate: date, endDate: date,
  arrival:   { at: localDateTime, airport?, airline?（v1.2 新增）, flight?, terminal?, timezone?（v1.5 新增） },
  departure: { at: localDateTime, airport?, airline?（v1.2 新增）, flight?, terminal?, airportArriveBy: localDateTime, timezone?（v1.5 新增） },
  transport: { primary: "transit"|"car"|"taxi"|"mixed", note?, decidedBy?: "user"|"ai"（v1.1 新增） },
  carRental?: { pickup: { at: localDateTime, place: Place }, dropoff: { at: localDateTime, place: Place }, decidedBy: "user"|"ai", reason?, licenseNote?, sources?: SourceRef[], verified: boolean }（v1.1 新增）,
  homeCurrency, localCurrency, fx?: { rate（1 單位當地幣＝多少本國幣）, kind?: "mid"|"cash-sell"|"card", asOf: date, source: SourceRef },
  currencies?: [ { code（ISO 4217）, rate（1 單位該幣＝多少 homeCurrency）, kind?: "mid"|"cash-sell"|"card", asOf: date, source: SourceRef } ]（v1.5 新增）
}
stays: [ { id, name, nameLocal?, address?, addressLocal?, lat, lon, checkIn: date, checkOut: date, checkInTime?: time, checkOutTime?: time, booked: boolean, area?, why?, parking?, sources?: SourceRef[], verified: boolean, options?: HotelOption[]（v1.4 新增，最多 3 筆） } ]
days: [ { date, title, area?, stayId?（當晚住哪；最後一天可省略）, summary?, rainPlan?, transport?: "transit"|"car"|"taxi"|"mixed"（v1.1 新增；沒填就沿用 journey.transport.primary）, timezone?（v1.5 新增；沒填就用 journey.destination.timezone）, items: Item[] } ]
Item: {
  id（全域唯一）, start: time, end: time,
  kind: "flight"|"transfer"|"sight"|"food"|"cafe"|"shopping"|"activity"|"stay"|"rest"|"other",
  title, place?: { name, nameLocal?, address?, addressLocal?, lat, lon },
  move?: { mode: "walk"|"subway"|"bus"|"rail"|"light-rail"|"taxi"|"car"|"ferry"|"flight"|"other", line?, from?, minutes, distanceKm?, cost?: Money, note? },   // 從上一站到這一站
  detail?, tips?: string[], hours?, booking?: { required: boolean, how?, opensAt?, url?, status?: "booked"|"todo"（v1.1 新增） },
  cost?: Money, photo?: { url, credit, license, licenseUrl?, sourceUrl }, rainAlt?, indoor?: boolean,
  fixed?: boolean（v1.1 新增）, sources?: SourceRef[], verified: boolean
}
Money: { amount, currency（ISO 4217）, per: "person"|"group"|"car", note? }
SourceRef: { title, url, checked: date }
Place: { name, nameLocal?, address?, addressLocal?, lat, lon }（v1.1 新增；格式同 Item.place）
HotelOption: { name, nameLocal?, address?, lat, lon, priceNote?, why?, url?, sources: SourceRef[], verified: boolean }（v1.4 新增）
budget?: { lines: [ { category: "transport"|"stay"|"food"|"tickets"|"shopping"|"other"|"flight"（"flight" 為 v1.5 新增）, label, amount: Money } ], hidden?: string[], note?, cap?: { amount, currency（必須是 homeCurrency）, scope: "trip-excl-flights"|"trip-incl-flights", per: "group"|"person", note? }（v1.5 新增） }
checklists?: { before: [ { when: "T-14"|"T-7"|"T-3"|"T-1"|"D0", text } ], packing?: string[] }
emergency?: { numbers: [ { label, number } ], consular?: [ { for, name, phone?, address?, note?, source?: SourceRef } ], hospitals?: [ { name, phone?, address?, lat?, lon? } ], note? }
navigation: { apps: ("naver"|"kakao"|"google"|"apple")[]（順序＝優先）, note? }
climate?: { basis（例：「2021–2025 年同期平均」）, tempMaxC, tempMinC, precipMm?, rainDays?, source: SourceRef }
selfCheck?: [ { rule, result: "pass"|"warn"|"fail"|"n/a"（"n/a" 為 v1.5 新增）, note? } ]
unverified?: string[]
```

## 寫法規則

- 必須是合法 JSON：一律用雙引號，不加註解，最後一個元素後面不留逗號，存成 UTF-8。上面全文裡的 `//` 註解只是說明，不要寫進 JSON。
- 字串裡的每一個 `<` 都寫成 `\u003c`，避免 `</script>` 把資料提早截斷。
- 數字就寫數字（座標、分鐘、金額），不加引號，也不加千分位逗號。
- 網址只能是 `http://` 或 `https://` 開頭。
- 不放 API 金鑰，也不放 base64 圖片。封面插圖是唯一的例外，而且它不在 JSON 裡（見下一節）。
- `stays[].id` 和每一個 Item 的 `id` 在整份資料裡都不能重複。

## 封面插圖區塊 `#trip-cover`

範本裡除了 `#trip-data`、`#trip-data-en`，還有一個 `<script type="text/plain" id="trip-cover">` 區塊，放封面插圖。

- 它不屬於行程 JSON，兩份資料裡都沒有對應的欄位。
- 內容和屬性都由 `assets/set-cover.ps1`（macOS／Linux 用 `set-cover.sh`）寫入。工具照城市 → 地區 → 國家 → 通用圖的順序，從 `assets/landmarks/` 挑一張插圖嵌進去。你不要自己寫，也不要改。
- 工具會一次寫入兩個屬性：`data-subject` 是插圖的繁中名稱，`data-subject-en` 是英文名稱。網頁依目前的語言挑一個當圖片的替代文字。不用再給 `-Lang`；舊的 `-Lang zh-CN` 已經移除，傳了會報錯。
- 這是整份檔案唯一允許的 base64 圖片：只能是 `assets/landmarks/` 裡的一張原創插圖，≤ 60 KB。這些插圖是本 skill 用 Blender 程式建模的原創作品，沒有第三方素材。照片仍然只能用線上連結（`photo.url`）。
- 區塊是空的（例如沒辦法執行工具），網頁會自動隱藏封面。

## 欄位說明

### meta

- `title`：行程名稱，例如「釜山 5 天 4 夜」。`subtitle` 可以放一句副標。
- `language`：這份資料的語言。`#trip-data` 固定寫 `"zh-TW"`，`#trip-data-en` 固定寫 `"en"`。舊檔的 `"zh-CN"` 網頁會當成繁中。
- `userLanguage`（v1.6 新增）：使用者開口用的語言，網頁照它決定預設顯示哪一份。用中文開口（不分繁簡）寫 `"zh-TW"`，用其他語言開口寫 `"en"`。兩份同一個值。skill 產出時一律要寫。
- `generatedAt`：產出時間，ISO 8601 要帶時區，例如 `2026-10-14T10:52:00+08:00`。
- `generator`：寫 `trip-planner skill`。
- `assumptions`：用到的預設和推定，一條一句，只寫不含同行者個資的假設，例如「護照：依出發地推定為台灣護照，使用者已確認」「步調：適中（預設）」「航班時刻由查詢取得」。同行者的預設不寫在這裡，`traveler.party` 已經有。沒有就給空陣列 `[]`。
- `shareUrl`：通常省略。

### traveler

- `party.adults` 是數字；`children`、`seniors` 也是數字；`note` 放其他補充。
- `party.childAges`（v1.1 新增）：小孩年齡，數字陣列，例如 `[6, 3]`。
- `party.mobility`（v1.1 新增）：行動限制，文字，例如「推嬰兒車」「長輩膝蓋不好，少走樓梯」「輪椅」。
- `passport`：`TW`、`HK`、`MO`、`other`。決定 `emergency.consular` 要列哪個駐外單位。
- `pace`：`relaxed` 放鬆、`balanced` 適中、`packed` 緊湊。
- `interests`、`avoid`：字串陣列，放想去、不想去的地方或活動。不吃的東西和飲食限制寫在 `diet`。
- `budgetLevel`：`saver` 省錢、`standard` 標準、`comfort` 舒適。
- `diet`（v1.1 新增）：不吃的東西和飲食限制，字串陣列，例如「不吃牛」「蛋奶素」「花生過敏」。
- `mustDo`（v1.1 新增）：一定要去、想做的事。`text` 寫使用者的原話；排進去了，`itemId` 填那一站的 `id`；排不進去，`reason` 寫原因（公休、太遠、和固定行程衝突）。每一項至少要有 `itemId` 或 `reason`。
- `dayStart`、`dayEnd`（v1.1 新增）：每天最早出門、最晚回到飯店的時間（`time`）。
- `specialDates`（v1.1 新增）：旅途中的生日、紀念日。`date` 是日期，`note` 寫是什麼日子。

### journey

- `destination.country`：ISO 3166-1 alpha-2 兩碼，例如 `KR`、`JP`。導航 App 的預設順序看這個欄位。
- `destination.timezone`：IANA 時區名稱，例如 `Asia/Seoul`。網頁用它抓天氣，也用它算「今天是旅程第幾天」。
- `destination.lat`、`lon`：目的地的中心座標。某一晚找不到住宿座標時，天氣改用這組。
- `startDate`、`endDate`：抵達日和回程日，兩天都算在行程內。
- `arrival.at`、`departure.at`：當地時間的 `localDateTime`。
- `arrival.airline`、`departure.airline`（v1.2 新增）：航空公司名稱，字串，例如「長榮航空」。使用者給了航班號才查，查到才填；來源附在首、末兩筆 `flight` 項目的 `sources`。網頁的總覽標籤會顯示「航空公司＋航班號」。
- `departure.airportArriveBy`：至少比 `departure.at` 早 3 小時。
- `arrival.timezone`、`departure.timezone`（v1.5 新增）：抵達地、回程起飛地的 IANA 時區。`arrival` 沒填就用第 1 天的時區，`departure` 沒填就用最後一天的時區；再沒有就用 `destination.timezone`。
- `transport.primary`：`transit` 大眾運輸、`car` 租車、`taxi` 計程車、`mixed` 混搭。`note` 寫混搭的原則。
- `transport.decidedBy`（v1.1 新增）：交通是誰決定的。使用者自己選的寫 `user`；沒回答、回「交給你」或「用預設」的寫 `ai`。
- `carRental`（v1.1 新增）：有租車才寫。`pickup`、`dropoff` 是取車、還車的時間（`localDateTime`）和地點（`Place`）。`decidedBy`：使用者指定日子的是 `user`，交給 AI 挑的是 `ai`。`reason` 寫為什麼租這幾天；`licenseNote` 寫駕照要準備什麼（依護照與目的地查證）；`sources`、`verified` 的用法同 Item。
- `homeCurrency`、`localCurrency`：ISO 4217 幣別，例如 `TWD`、`KRW`。
- `fx.rate`：1 單位當地幣等於多少本國幣。
- `fx.kind`：匯率種類，選填，只能是下表三個值之一。預算一律用 `mid` 算，所以 skill 產出時寫 `"mid"`。網頁會顯示這個欄位。

  | 值 | 意思 |
  |---|---|
  | `mid` | 國際中間價 |
  | `cash-sell` | 銀行現鈔賣出價，也就是在本國換外幣現金的價格 |
  | `card` | 信用卡結算匯率 |

- `fx.asOf`：查價日期。`fx.source`：必填，寫查到這個匯率的來源（SourceRef）。
- `currencies`（v1.5 新增）：行程裡出現的其他幣別。每筆有 `code`（ISO 4217）、`rate`（1 單位該幣等於多少 `homeCurrency`）、`kind`、`asOf`、`source`。原本的 `localCurrency`、`fx` 保留，當作主要的當地幣；主要當地幣也可以重複列進來，網頁以 `currencies` 為準。每一筆 `Money.currency` 都要能換算回 `homeCurrency`，換算不了的，網頁會列出來提醒。

### stays[]

- `id`：自己取，例如 `stay-1`。
- `checkIn`、`checkOut`：日期。`checkOut` 是離開那天，那一晚不算在這間。
- `booked`：使用者已經訂好的是 `true`；skill 推薦的區域是 `false`。
- `name`、`lat`、`lon`：還沒訂房時，寫區域或首選飯店，座標用區域中心或首選飯店；行程照這個座標排。
- `area`、`why`：住哪一區、為什麼推薦；分段住的話，也寫為什麼在這裡換飯店。
- `parking`：停車資訊（文字）。租車時每一間都要有。
- `verified`、`sources`：有查證就 `true` 並附來源。
- `options`（v1.4 新增）：還沒訂房的那一段，附最多 3 家候選飯店（HotelOption），讓使用者選 1 家；已經訂好的那一段不給。
  - 必填：`name`、`lat`、`lon`、`sources`、`verified`。
  - 選填：`nameLocal`、`address`、`priceNote`（價位帶，例如「每晚約 NT$4,000–5,500」，查不到就不填）、`why`（一句：包含查證過的 Google 評分與評論則數，如「Google 4.3★（約 1,200 則評論），離哪裡近、適合誰」；有小孩時提房型或床型，查不到就不寫）、`url`（官方網站或訂房頁）。
  - 優先挑 Google 評分 4.0★ 以上且評論數 > 100 則的飯店，只寫上網確認過名稱、位置、營業狀態與評分的飯店，所以 `verified` 應該是 `true`。湊不滿 3 家就照實際查到的家數給，不准編造。

### days[]

- 從 `startDate` 到 `endDate` 每天一筆，照日期排序。
- `title`：當天主題，例如「海邊與市場」。`area` 寫當天主要區域。
- `stayId`：當晚住哪一間，對到 `stays[].id`；最後一天可以省略。
- `summary`：一兩句話講這天。`rainPlan`：下雨時這天怎麼改。
- `transport`（v1.1 新增）：當天的主要交通，值同 `journey.transport.primary`。沒填就沿用 `journey.transport.primary`；有租車或混搭時，每天都寫。
- `timezone`（v1.5 新增）：IANA 時區名稱，這一天所有 Item 的 `start`、`end` 都是這個時區的當地時間。沒填就用 `journey.destination.timezone`。移動到另一個時區的那天，填當晚住宿城市的時區；跨時區那段 `move.note` 寫「抵達時間為當地時間」。網頁的 .ics 匯出、日出日落和天氣日期，都照每一天的時區算。
- `items`：照時間排序。

### Item（`days[].items[]` 裡的每一筆）

- `id`：整份唯一，建議用 `d{第幾天}-{兩位數序號}`，例如 `d2-03`。
- `start`、`end`：`time`。同一天的項目不要跨過午夜。
- `kind`：

  | 值 | 意思 |
  |---|---|
  | `flight` | 航班（抵達、離境） |
  | `transfer` | 純移動、接駁 |
  | `sight` | 景點 |
  | `food` | 正餐 |
  | `cafe` | 咖啡、甜點 |
  | `shopping` | 購物 |
  | `activity` | 活動、體驗 |
  | `stay` | 入住、退房 |
  | `rest` | 休息 |
  | `other` | 其他 |

- `place`：有地點就要有 `lat`、`lon`。`nameLocal`、`addressLocal` 用當地文字，兩份資料照抄同一個值；網頁在繁中和 English 模式都會顯示，放在名稱或地址下面，標明是哪種語言（繁中寫「韓文：…」「日文：…」，English 寫 "Korean: …" "Japanese: …"，其他國家用該國語言的名稱）。這兩欄只放當地的正式名稱和地址，不放說明或翻譯；什麼時候要填，見 `planning-rules.md` 第 7 節「當地原文」。英文那份的 `name`、`address` 寫英文或羅馬拼音。KakaoMap 連結優先用 `nameLocal`，計程車模式每一站都要有 `addressLocal`。海邊列車、纜車、遊船、觀光巴士這類搭乘本身就是行程的項目，`place` 填下車點，上車點寫在 `detail`；網頁會用座標檢查下一站的交通時間，填成上車點會被誤判。
- `move`：**從上一站到這一站**的移動。當天第一站的 `from` 寫出發的飯店。
  - `mode`：`walk`、`subway`、`bus`、`rail`、`light-rail`、`taxi`、`car`、`ferry`、`flight`、`other`。
  - `line`：路線名，搭大眾運輸時要寫，例如「地鐵 2 號線」。
  - `minutes` 是數字；`distanceKm`、`cost`、`note` 選填。估算的數字在 `note` 寫「估算」。
- `detail`：看什麼、做什麼。`tips`：小提醒，字串陣列。`kind` 為 `food`、`cafe` 時（優先挑 Google 4.2★ 以上且評論數 > 100 則），在 `detail` 或 `tips` 寫出查證過的 Google 評分與評論則數，並在 `tips` 附 1～2 家同區高分備選餐廳。
- `hours`：營業時間，文字，例如「10:00–18:00，週一公休」。
- `booking`：`required` 是否要預約；`how` 怎麼預約；`opensAt` 什麼時候開放預約（文字，寫清楚時區）；`url` 預約網址。
- `booking.status`（v1.1 新增）：`booked` 已訂好；`todo` 還要去訂。
- `fixed`（v1.1 新增）：使用者自己訂好、不能移動的行程寫 `true`。時間和地點照使用者給的，`booking.status` 一定是 `booked`。
- `cost`：這一站的花費（門票、餐費），格式是 Money。
- `photo`：`kind` 為 `sight`、`activity` 的項目盡量各附 1 張，其他類型可放可不放。只用 Wikimedia Commons 的線上縮圖：`url` 是圖片網址，`credit` 作者，`license` 授權名稱（例如 `CC BY-SA 4.0`），`licenseUrl` 授權條款網址，`sourceUrl` 照片在 Commons 的檔案頁面。`credit`、`license`、`sourceUrl` 一定要填。找不到，或作者、授權確認不了，就整個省略，不改用其他來源。
- `rainAlt`：下雨時的替代方案。`indoor`：室內是 `true`。
- `sources`、`verified`：查證過的事實附來源並標 `true`；查不到的標 `false`，同時列進 `unverified`。

### 共用格式

- **Money**：`amount` 是數字；`currency` 是 ISO 4217；`per` 是 `person`（每人）、`group`（整團）、`car`（每台車）；`note` 可以寫「預估」。
- **SourceRef**：`title` 來源名稱；`url` 網址；`checked` 查證日期。
- **Place**（v1.1 新增）：`{ name, nameLocal?, address?, addressLocal?, lat, lon }`，格式同 Item 的 `place`，目前給 `carRental` 用。
- **HotelOption**（v1.4 新增）：`stays[].options` 的每一筆，欄位說明見上面 `stays[]`。

### 其他頂層欄位

- `budget`：`lines` 每一條有 `category`（`transport`、`stay`、`food`、`tickets`、`shopping`、`other`，以及 v1.5 新增的 `flight`）、`label`、`amount`（Money）。機票一律用 `flight` 類別。`hidden` 是字串陣列，列容易漏算、沒放進 `lines` 的花費，例如押金、手續費。`note` 放補充，例如匯率日期。換算成本國幣一律用中間價（`journey.fx`，`kind:"mid"`），並在 `hidden` 或 `note` 提醒「換現鈔會比中間價貴，價差請以銀行牌價為準」。`cap`（v1.5 新增）是總預算上限：`amount` 是數字；`currency` 必須是 `homeCurrency`；`scope` 是 `trip-excl-flights`（不含機票）或 `trip-incl-flights`（含機票）；`per` 是 `group`（整團）或 `person`（每人）；`note` 寫補充。網頁會把 `budget.lines` 加總、換算成本國幣（`per:"person"` 的金額乘上總人數），跟上限比較，超過就在品質面板警告；`scope` 是 `trip-excl-flights` 時，加總會排除 `flight` 這一類。
- `checklists`：`before` 每一條有 `when` 和 `text`。`when` 的意思：`T-14`、`T-7`、`T-3`、`T-1` 是出發前 14、7、3、1 天，`D0` 是出發當天。`packing` 是行李清單。
- `emergency`：`numbers` 是當地緊急電話（`label`、`number`）；`consular` 是駐外單位，`for` 寫適用哪一本護照（例如 `TW`）；`hospitals` 是附近的大醫院。全部要查證。
- `navigation`：`apps` 的順序就是優先順序，韓國預設 `["naver", "kakao", "google"]`，其他國家預設 `["google", "apple"]`。`note` 寫導航現況的查證結果和日期。
- `climate`：歷年同期的氣候。`basis` 寫統計範圍，例如「2021–2025 年同期平均」；`tempMaxC`、`tempMinC`、`precipMm`、`rainDays` 是數字；`source` 一定要有。出發日還在預報範圍外、或離線又沒有存過的預報時，網頁顯示這份資料；沒有這份資料，網頁就顯示沒有天氣資料。
- `selfCheck`：自我檢查結果，每一條有 `rule`、`result`（`pass`、`warn`、`fail`，或 v1.5 新增的 `n/a`）和 `note`。`rule` 一定要**以規則編號開頭**，例如「3. 同一天時間不重疊」；網頁會用這個編號，拿 AI 的自評和網頁自己重算的結果比對，不一致就標出來。目前共 16 條。`n/a` 表示這一條不適用：第 16 條「預算在上限內」沒有 `budget.cap` 時填 `n/a`；其他條遇到不適用的情況也可以用，`note` 補一句原因。
- `unverified`：沒查證的項目，一條一句，寫清楚哪一天、哪一站、哪一項。

## 範例 JSON

以下全部是**範例**：店名、飯店名、路線名、金額、匯率、營業時間都是虛構的，座標只是放在釜山一帶。為了簡短，`days` 只放第 1 天（抵達日）的 3 站，也省略了抵達航班那一筆，`budget` 只放一條；`d1-03` 是虛構景點，所以沒附 `photo`。實際行程要從 `startDate` 排到 `endDate`，每天一筆，`selfCheck` 也要寫滿 16 條。下面這份是繁中那份（`#trip-data`）；英文那份的寫法見最後的對照節錄。

```json
{
  "schemaVersion": "1",
  "meta": {
    "title": "範例：釜山抵達日",
    "subtitle": "範例資料，店名與飯店名都是虛構的",
    "language": "zh-TW",
    "userLanguage": "zh-TW",
    "generatedAt": "2026-10-14T10:00:00+08:00",
    "generator": "trip-planner skill",
    "assumptions": [
      "範例：護照依出發地推定為台灣護照，使用者已確認",
      "範例：步調適中、預算標準（預設）"
    ]
  },
  "traveler": {
    "party": { "adults": 2 },
    "passport": "TW",
    "pace": "balanced",
    "budgetLevel": "standard",
    "mustDo": [
      { "text": "範例：晚上去河邊散步", "itemId": "d1-03" },
      { "text": "範例：示範市場（虛構）", "reason": "範例：行程期間公休，排不進去" }
    ]
  },
  "journey": {
    "origin": { "city": "台北", "airport": "TPE" },
    "destination": { "city": "釜山", "country": "KR", "lat": 35.1796, "lon": 129.0756, "timezone": "Asia/Seoul" },
    "startDate": "2026-10-19",
    "endDate": "2026-10-20",
    "arrival": { "at": "2026-10-19T17:00", "airport": "PUS" },
    "departure": { "at": "2026-10-20T13:00", "airport": "PUS", "airportArriveBy": "2026-10-20T10:00" },
    "transport": { "primary": "transit", "decidedBy": "user" },
    "homeCurrency": "TWD",
    "localCurrency": "KRW",
    "fx": {
      "rate": 0.0235,
      "kind": "mid",
      "asOf": "2026-10-14",
      "source": { "title": "範例匯率來源（虛構）", "url": "https://example.com/sample-fx", "checked": "2026-10-14" }
    }
  },
  "stays": [
    {
      "id": "stay-1",
      "name": "範例飯店（虛構）",
      "nameLocal": "예시 호텔",
      "lat": 35.1578,
      "lon": 129.06,
      "checkIn": "2026-10-19",
      "checkOut": "2026-10-20",
      "checkInTime": "15:00",
      "checkOutTime": "11:00",
      "booked": true,
      "area": "範例區（虛構）",
      "verified": false
    }
  ],
  "days": [
    {
      "date": "2026-10-19",
      "title": "範例：抵達、入住、晚餐",
      "stayId": "stay-1",
      "summary": "範例：落地後直接到飯店，晚餐在附近吃。",
      "rainPlan": "範例：下雨就改在飯店一樓的範例餐廳（虛構）吃晚餐。",
      "transport": "transit",
      "items": [
        {
          "id": "d1-01",
          "start": "19:00",
          "end": "19:15",
          "kind": "stay",
          "title": "範例：入住範例飯店",
          "place": { "name": "範例飯店（虛構）", "nameLocal": "예시 호텔", "lat": 35.1578, "lon": 129.06 },
          "move": {
            "mode": "bus",
            "line": "範例機場巴士（虛構）",
            "from": "機場",
            "minutes": 50,
            "cost": { "amount": 5000, "currency": "KRW", "per": "person", "note": "範例金額，不是真實票價" }
          },
          "tips": ["範例：17:00 落地＋60 分鐘入境領行李＋50 分鐘車程，19:00 前後到飯店"],
          "indoor": true,
          "verified": false
        },
        {
          "id": "d1-02",
          "start": "19:30",
          "end": "20:30",
          "kind": "food",
          "title": "範例：晚餐吃湯飯（已訂位）",
          "place": { "name": "範例湯飯店（虛構）", "nameLocal": "예시 국밥집", "addressLocal": "예시 주소 (가상)", "lat": 35.161, "lon": 129.064 },
          "move": { "mode": "walk", "from": "範例飯店（虛構）", "minutes": 10, "distanceKm": 0.7 },
          "detail": "範例：飯店走路 10 分鐘的湯飯店。",
          "tips": ["範例：步行 \u003c 15 分鐘，不用搭車"],
          "hours": "範例：11:00–22:00（虛構）",
          "booking": { "required": true, "how": "範例：使用者已自行訂位（虛構）", "opensAt": "範例：前 30 天開放訂位（虛構）", "status": "booked" },
          "fixed": true,
          "cost": { "amount": 12000, "currency": "KRW", "per": "person", "note": "範例金額" },
          "rainAlt": "範例：飯店一樓的範例餐廳（虛構）",
          "indoor": true,
          "sources": [{ "title": "範例來源（虛構）", "url": "https://example.com/sample-hours", "checked": "2026-10-14" }],
          "verified": false
        },
        {
          "id": "d1-03",
          "start": "20:45",
          "end": "21:15",
          "kind": "sight",
          "title": "範例：河岸步道散步",
          "place": { "name": "範例河岸步道（虛構）", "nameLocal": "예시 산책로", "lat": 35.1592, "lon": 129.0625 },
          "move": { "mode": "walk", "from": "範例湯飯店（虛構）", "minutes": 10, "distanceKm": 0.6 },
          "detail": "範例：飯後散步半小時，走完直接回飯店。",
          "rainAlt": "範例：下雨就直接回飯店休息",
          "indoor": false,
          "verified": false
        }
      ]
    }
  ],
  "budget": {
    "lines": [
      { "category": "food", "label": "範例：第 1 天晚餐", "amount": { "amount": 24000, "currency": "KRW", "per": "group", "note": "範例金額" } }
    ],
    "hidden": ["換現鈔會比中間價貴，價差請以銀行牌價為準"]
  },
  "navigation": { "apps": ["naver", "kakao", "google"], "note": "範例：韓國以 Naver Map、KakaoMap 為主" },
  "selfCheck": [
    { "rule": "1. 每晚都有住宿", "result": "pass" },
    { "rule": "4. 移動接得上", "result": "pass", "note": "範例：19:15＋10 分鐘＝19:25，早於 19:30" },
    { "rule": "11. 必去清單都有交代", "result": "pass", "note": "範例：一項排在 d1-03，一項寫了排不進去的原因" },
    { "rule": "12. 固定行程沒被動到", "result": "pass" }
  ],
  "unverified": ["範例資料：所有名稱、時間、金額都是虛構的，沒有查證"]
}
```

### 英文那份對照（節錄）

上面那份的英文版要放進 `#trip-data-en`，結構、key 順序、數字、id、時間、網址、`nameLocal`、`addressLocal` 都跟繁中那份一樣，只有文字換成英文。下面節錄 `meta` 和 `d1-02` 兩段；`nameLocal`、`addressLocal` 照抄，裡面是韓文，網頁會標成 "Korean: …"；其他字串沒有任何中文、韓文或全形字元。

```json
"meta": {
  "title": "Sample: Arrival Day in Busan",
  "subtitle": "Sample data; restaurant and hotel names are fictional",
  "language": "en",
  "userLanguage": "zh-TW",
  "generatedAt": "2026-10-14T10:00:00+08:00",
  "generator": "trip-planner skill",
  "assumptions": [
    "Sample: Taiwan passport assumed from the departure city, confirmed by the traveler",
    "Sample: balanced pace, standard budget (defaults)"
  ]
}
```

```json
{
  "id": "d1-02",
  "start": "19:30",
  "end": "20:30",
  "kind": "food",
  "title": "Sample: gukbap dinner (booked)",
  "place": { "name": "Sample Gukbap House (fictional)", "nameLocal": "예시 국밥집", "addressLocal": "예시 주소 (가상)", "lat": 35.161, "lon": 129.064 },
  "move": { "mode": "walk", "from": "Sample Hotel (fictional)", "minutes": 10, "distanceKm": 0.7 },
  "detail": "Sample: a gukbap (pork and rice soup) place a 10-minute walk from the hotel.",
  "tips": ["Sample: \u003c 15 minutes on foot, no need to ride"],
  "hours": "Sample: 11:00–22:00 (fictional)",
  "booking": { "required": true, "how": "Sample: booked by the traveler (fictional)", "opensAt": "Sample: bookings open 30 days ahead (fictional)", "status": "booked" },
  "fixed": true,
  "cost": { "amount": 12000, "currency": "KRW", "per": "person", "note": "Sample amount" },
  "rainAlt": "Sample: the sample restaurant on the hotel's ground floor (fictional)",
  "indoor": true,
  "sources": [{ "title": "Sample source (fictional)", "url": "https://example.com/sample-hours", "checked": "2026-10-14" }],
  "verified": false
}
```
