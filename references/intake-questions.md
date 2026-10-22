# 開場提問範本

開口問使用者之前讀這份。每種語言的題號、順序、預設值都一樣：繁中、英文附完整範本。使用者用其他語言開口時，照範本的意思用他的語言問。回覆怎麼解讀（最多兩輪、「交給你」、預設值）見 `SKILL.md` 第 2 步。

行程語言不用問：網頁一律同時附繁中和英文兩份內容，使用者可以在網頁上切換；日本、韓國這類地方，兩種版本的店名和地址都會多一行當地原文。第 10 題順便告知這件事。

## 範本怎麼用

- **A｜只說要排**：用 A 範本，10 題全列，★ 必答題在前。
- **B｜一句話給了細節**：用 B 範本。先複述聽懂的部分，只列缺的題目，題號從 1 重新編。缺 ★ 題就排最前面；住宿和交通沒提到，一定要列。
- 使用者講過的事不要再問。題目文字可以依情境微調，但預設值照寫，讓使用者知道不回答會怎樣。
- 同行有小孩、卻沒給年齡：第二輪一定要問（規則見 `SKILL.md` 第 2 步）。
- 第 10 題沒回答：依出發地推定護照（台灣、香港、澳門），放進第二輪那一則訊息請使用者確認，並問同行有沒有人持其他護照；其他出發地就直接問（規則見 `SKILL.md` 第 2 步）。
- 行程有滑雪、潛水、登山、主題樂園這類活動：第二輪追問程度或經驗、教練、裝備租借、保險、身高或年齡限制。
- 不能提問的環境（非互動模式、排程執行）：不問，照預設直接排，交件訊息第一段列「需要你回覆」（規則見 `SKILL.md` 第 2 步，範本見下面「不能提問的環境」）。

## 每題的答案寫進哪裡

| # | 問什麼 | 寫進哪裡 |
|---|---|---|
| 1 ★ | 去哪裡；多個城市照順序 | `journey.destination`（填住最多晚的城市）、`stays`、`days[].area` |
| 2 ★ | 哪天出發、玩幾天 | `journey.startDate`、`journey.endDate` |
| 3 ★ | 出發地；去程抵達當地、回程起飛的時間；航班號 | `journey.origin`、`journey.arrival`、`journey.departure`（航班號和查到的航空公司、航廈寫進 `flight`、`airline`、`terminal`） |
| 4 | 人數；小孩年齡；長輩、行動不便、嬰兒車 | `traveler.party`（`children`、`childAges`、`seniors`、`mobility`） |
| 5 | 住宿：已訂的名稱或地址、各住哪幾晚；沒訂的話想住哪區、預算 | `stays`（想住的區和住宿預算寫進 `area`、`why`；沒訂的那一段附候選 `options`） |
| 6 | 已訂好的門票、餐廳、演唱會、一日遊 | 寫成 Item，標 `fixed: true`、`booking.status: "booked"` |
| 7 | 必去、想做；不想去、不吃、飲食限制 | `traveler.mustDo`、`traveler.avoid`、`traveler.diet` |
| 8 | 交通；自駕的日子與取車、還車地點 | `journey.transport`、`journey.carRental`、`days[].transport` |
| 9 | 步調、預算、總預算上限（選填）、每天出門和回飯店的時間、夜生活偏好（夜市／夜景／酒吧小酌／夜店／18+ 成人紅燈區） | `traveler.pace`、`budgetLevel`、`budget.cap`、`dayStart`、`dayEnd`、`interests` |
| 10 | 護照（同行者有沒有持其他護照）、生日或紀念日；告知網頁附繁中和英文版 | `traveler.passport`（其他護照寫進 `party.note`）、`traveler.specialDates`。`meta.userLanguage` 不用問，看使用者開口用的語言（見 `SKILL.md`「先記住」） |

- 第 8 題：使用者自己選的交通，`journey.transport.decidedBy` 寫 `"user"`；沒回或交給你，寫 `"ai"`。使用者指定開車的日子，`journey.carRental.decidedBy` 寫 `"user"`；回「租車天數交給你」（英文 "you pick the driving days"），寫 `"ai"`。
- 給了航班號：有上網工具就查是哪家航空公司，查得到也查航廈；沒給時間的，連表定時間一起查。查到的時刻在下一則訊息複述，請使用者確認，確認後才開排；「其他都用預設」抵不掉這一步，只有使用者明講「不用確認，直接排」才跳過（規則見 `SKILL.md` 第 2 步）。查不到就不要猜。不能上網的話，第 3 題拿掉「我會幫你查……」那半句。

## A｜只說要排

### 繁中

> 好，我們來排！照編號回就好。標 ★ 的一定要回答；其他題沒想法，寫「交給你」或「用預設」都行。
>
> 1. ★ **去哪裡？** 多個城市就照順序寫。
> 2. ★ **哪天出發、玩幾天？** 例：10/19 出發，5 天 4 夜。
> 3. ★ **從哪裡出發？去程幾點抵達當地、回程幾點起飛？** 有航班號也可以直接給我，我會幫你查是哪家航空、哪個航廈。
> 4. **幾個人去？** 有小孩的話幾歲？有沒有長輩、行動不便，或要推嬰兒車？（預設：2 位大人）
> 5. **住宿訂了嗎？** 訂了請給飯店名稱或地址，中途換飯店就寫各住哪幾晚；還沒訂就說想住哪一區、預算多少。（預設：我依路線推薦住宿區，每段附 3 家候選飯店）
> 6. **有沒有已經訂好的行程？** 門票、餐廳、演唱會、一日遊，請寫日期和時間，這些我不會動。（預設：全部交給我排）
> 7. **一定要去的地方、想做的事？** 不想去的、不吃的、飲食限制也寫這裡。（預設：由我挑）
> 8. **在當地怎麼移動？** A 大眾運輸　B 計程車　C 自駕　D 混搭。選 C 或 D，請寫哪幾天開車、在哪裡取車還車，或寫「租車天數交給你」。（預設：A）
> 9. **步調、預算、作息、夜生活？** 步調：放鬆／適中／緊湊；預算：省錢／標準／舒適，有總預算上限也可以說（例如一家三口不含機票 NT$80,000）；每天最早幾點出門、最晚幾點回飯店；晚上想不想排夜市、夜景、酒吧／居酒屋小酌，或滿 18 歲的成人夜生活／紅燈區巡禮？（預設：適中、標準、沒有上限、09:00–21:30、一般夜景／夜市，不主動排 18+ 成人區）
> 10. **其他：** 用哪一本護照（查入境規定和駐外單位用）？同行者有沒有人持其他護照？旅途中有沒有生日或紀念日？行程網頁會同時附繁中和英文版，可以在網頁上切換，店名和地址也會附當地文字，方便到當地拿給人看。（預設：依出發地推定，開排前我會跟你確認）
>
> 回一行就好，例如：
>
> 1 釜山　2 10/19 出發 5 天　3 台北，17:00 到、回程 13:00　4 2 大人　5 還沒訂，想住西面　6 全部交給你　7 一定要去甘川洞　8 大眾運輸
>
> 沒寫到的第 4～10 題，我都用預設。

### English

> Let's plan it. Reply by number. Questions marked ★ need an answer; for the rest, "up to you" or "default" is fine.
>
> 1. ★ **Where to?** More than one city? List them in order.
> 2. ★ **When do you leave, and for how long?** e.g. Oct 19, 5 days / 4 nights.
> 3. ★ **Where are you flying from? When do you land, and when does your flight home take off?** A flight number works too, and I'll look up the airline and terminal for you.
> 4. **Who's going?** Kids' ages? Any seniors, mobility needs, or a stroller? (Default: 2 adults)
> 5. **Hotel booked?** If yes, send the name or address, plus which nights if you're switching hotels. If not, tell me the area and budget you have in mind. (Default: I'll pick where to stay based on your route, with 3 hotel options for each base)
> 6. **Anything already booked?** Tickets, restaurants, concerts, day tours. Give me the date and time and I won't move them. (Default: I'll plan everything)
> 7. **Must-sees or must-dos?** Also anything to skip, food you don't eat, or dietary needs. (Default: I'll pick)
> 8. **Getting around?** A public transit · B taxis · C driving · D a mix. For C or D, tell me which days you'll drive and where you'll pick up and drop off the car, or say "you pick the driving days". (Default: A)
> 9. **Pace, budget, daily hours, nightlife?** Pace: relaxed / balanced / packed. Budget: saver / standard / comfort; a total budget cap works too, e.g. NT$80,000 for a family of three, flights not included. Earliest start and latest return to the hotel each day. Any nightlife preferences — night markets, night views, bars/izakayas, clubs, or 18+ adult entertainment / red-light districts (for all-adult groups)? (Default: balanced, standard, no cap, 09:00–21:30, general night views/markets only)
> 10. **Anything else?** Which passport (for entry rules and consular contacts), and does anyone in your group hold a different one? Any birthdays or anniversaries on the trip? Your itinerary page comes in both English and Traditional Chinese, and you can switch between them on the page. Place names and addresses also show the local script, so you can show them to a driver or staff on the spot. (Default: I'll go by where you fly from and check with you before planning)
>
> One line is enough, e.g.:
>
> 1 Busan · 2 Oct 19, 5 days · 3 Taipei, land 17:00, fly home 13:00 · 4 2 adults · 5 not yet, thinking Seomyeon · 6 up to you · 7 must see Gamcheon Culture Village · 8 public transit
>
> Anything you skip in 4–10 gets the default.

## B｜一句話給了細節

### 繁中（以釜山那句為例）

使用者說：「10/19 從台北出發到韓國釜山，當日 17:00 到，共 5 天，回程下午 1 點的班機」。第 1～3 題都有了，只問其他題，住宿和交通排最前面：

> 收到！先確認我聽懂的：10/19（一）從台北出發，17:00 抵達釜山；10/23（五）搭 13:00 的班機回台北。一共 5 天 4 夜，時間都以當地時間算。有記錯直接說。
>
> 還差幾件事，照編號回就好，沒想法就寫「交給你」：
>
> 1. **住宿訂了嗎？** 訂了請給飯店名稱或地址，中途換飯店就寫各住哪幾晚；還沒訂就說想住哪一區、預算多少。（預設：我依路線推薦住宿區，每段附 3 家候選飯店）
> 2. **在當地怎麼移動？** A 大眾運輸　B 計程車　C 自駕　D 混搭。選 C 或 D，請寫哪幾天開車、在哪裡取車還車，或寫「租車天數交給你」。（預設：A）
> 3. **幾個人去？** 有小孩的話幾歲？有沒有長輩、行動不便，或要推嬰兒車？（預設：2 位大人）
> 4. **有沒有已經訂好的行程？** 門票、餐廳、演唱會、一日遊，請寫日期和時間，這些我不會動。（預設：全部交給我排）
> 5. **一定要去的地方、想做的事？** 不想去的、不吃的、飲食限制也寫這裡。（預設：由我挑）
> 6. **步調、預算、作息、夜生活？** 步調：放鬆／適中／緊湊；預算：省錢／標準／舒適，有總預算上限也可以說（例如一家三口不含機票 NT$80,000）；每天最早幾點出門、最晚幾點回飯店；晚上想不想排夜市、夜景、酒吧／居酒屋小酌，或滿 18 歲的成人夜生活／紅燈區巡禮？（預設：適中、標準、沒有上限、09:00–21:30、一般夜景／夜市，不主動排 18+ 成人區）
> 7. **其他：** 用哪一本護照（查入境規定和駐外單位用）？同行者有沒有人持其他護照？旅途中有沒有生日或紀念日？行程網頁會同時附繁中和英文版，可以在網頁上切換，店名和地址也會附當地文字，方便到當地拿給人看。（預設：從台北出發，先當作大家都持台灣護照，開排前我會再確認）
>
> 回一行就好，例如：1 還沒訂，想住西面　2 A　3 2 大人　其他交給你

### English

> Got it. Quick check: you fly out of Taipei, land in Busan at 17:00 on Mon, Oct 19, and fly home at 13:00 on Fri, Oct 23. That's 5 days and 4 nights, all in local time. Tell me if I got anything wrong.
>
> A few more things. Reply by number, or just say "up to you":

接著列 A 英文範本的第 5、8、4、6、7、9、10 題，題號從 1 重新編；最後一題的預設改成 "Taiwan passport since you're flying from Taipei (I'll confirm before planning)"。回覆範例：`1 not yet, thinking Seomyeon · 2 A · 3 2 adults · rest up to you`。

## 第二輪：只追問缺的 ★ 題，只問一次

> 還差一件事就能開排：**回程是幾點起飛？** 給我時間或航班號都可以。

> One more thing and I can start: **what time does your flight home leave?** A time or a flight number works.

> 還差一件事：**小孩幾歲？** 會影響門票價格，有些設施也有年齡或身高限制。

> One more thing: **how old is your child?** It affects ticket prices, and some attractions have age or height limits.

> 我先假設你們都持香港特區護照（從香港出發），查入境規定和駐外單位用；不對，或同行有人持其他護照，請說。另外這幾天我預計這樣分區：D1 西面入住與豬肉湯飯 → D2 海雲台與膠囊列車 → D3 甘川洞與南浦洞 → D4 廣安里與百貨 → D5 回程，方向 OK 或想換哪一區也請跟我說。

> I'll assume you all hold Hong Kong SAR passports since you're flying from Hong Kong; I use this for entry rules and consular contacts. Also, here is the daily area outline I have in mind: D1 Seomyeon check-in & gukbap -> D2 Haeundae & Capsule Train -> D3 Gamcheon & Nampo-dong -> D4 Gwangalli & shopping -> D5 fly home. Let me know if that looks good or if you'd like to swap anything.

出發地不是台灣、香港、澳門時，直接問：

> 你們持哪一國的護照？同行有沒有人持不同的護照？入境規定是逐人看的。

> Which passport do you hold, and does anyone in your group hold a different one? Entry rules apply person by person.

> 行程裡有滑雪：大家的程度如何？要不要請教練、租裝備？旅遊保險有沒有包含滑雪？小孩有沒有年齡或身高限制要注意？

> Skiing is on the plan: what level is everyone at? Do you want lessons or rental gear? Does your travel insurance cover skiing? Any age or height limits for the kids?

### 確認查到的航班時刻

時刻是查來的，就要先確認才開排。有第二輪追問的話，放在同一則訊息。下面的時刻是示意，要換成查到的。

> CI186 表定 15:45 從桃園起飛、19:00 抵達釜山；CI187 表定 20:00 從釜山起飛。時間對的話回「對」，我就開排。

> CI186 is scheduled to leave Taoyuan at 15:45 and land in Busan at 19:00, and CI187 leaves Busan at 20:00. If those times are right, reply "yes" and I'll start planning.

## 開排前的固定結尾

問題問完、航班時刻也確認了，開始查證和排程之前，先回一句。項目數和時間照實際要查的估，說完就開始。

> 好，資料齊了。接下來我會查 20 多項資訊再排，大約需要 10–60 分鐘，看你用的模型。

> Got everything I need. I'll check 20-plus things before planning, which takes about 10–60 minutes depending on the model you're using.

不能提問的環境不發這一句，改在交件訊息寫「這次查證與排程約花了 N 分鐘」。

工具不夠時（不能上網、不能寫檔、不能執行指令），開排前先講，例如：

> 我目前不能上網，排出來的會全部標未查證，建議換能上網的模型或環境。

> I can't browse the web right now, so everything in the plan will be marked unverified. A model or environment with web access would do better.

## 不能提問的環境

非互動模式、排程執行這類問了也等不到回覆的環境，照預設和查到的資料直接排，交件訊息第一段先列需要回覆的事。下面的航班時刻和活動是示意，要換成這次實際的內容；只列這次真的有、而且還沒確認的項目。

> 這次是在不能提問的環境排的，下面幾件事我先照推定排了，請你回覆確認：
> 1. 航班時刻是查來的：CI186 表定 15:45 從桃園起飛、19:00 抵達釜山；CI187 表定 20:00 從釜山起飛。對嗎？
> 2. 我先假設你們都持台灣護照（從台北出發）。同行有人持其他護照嗎？
> 3. 兒童票價和設施限制依年齡而定，行程裡列了各年齡段的規定。小孩幾歲？
> 4. 滑雪：大家的程度、要不要教練和租裝備、保險有沒有包含滑雪？
>
> 回覆後，我照你的答案更新行程。

> This plan was made somewhere I couldn't ask you questions, so I went with my best assumptions on a few things. Please confirm:
> 1. I looked up the flight times: CI186 leaves Taoyuan at 15:45 and lands in Busan at 19:00; CI187 leaves Busan at 20:00. Is that right?
> 2. I assumed you all hold Taiwan passports since you're flying from Taipei. Does anyone hold a different one?
> 3. Kids' ticket prices and attraction limits depend on age, so the plan lists the rules for each age band. How old are the kids?
> 4. Skiing: what level is everyone at, do you want lessons or rental gear, and does your insurance cover skiing?
>
> Once you reply, I'll update the plan.

## 香港用語

使用者是香港人（從香港出發，或用香港用語）時，對話和繁中那份資料（`#trip-data`）改用香港用語；台灣使用者照舊。這只套用在繁中那份，英文那份（`#trip-data-en`）照一般英文寫，不受影響。

示意（台灣 → 香港）：計程車 → 的士、飯店 → 酒店、公車 → 巴士、捷運／地鐵 → 港鐵（香港境內）或地鐵、悠遊卡這類交通卡 → 「像八達通那樣的儲值卡」、結帳 → 埋單、餐廳訂位 → 訂座、便利商店 → 便利店。
