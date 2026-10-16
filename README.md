<div align="center">

# ✈️ trip-planner

**說一句話，排好整趟旅行 —— 免安裝、真雙語、高口碑篩選的互動式旅遊行程 Skill**

[![Version](https://img.shields.io/badge/version-v1.7-D6246E?style=flat-square)](./CHANGELOG.md)
[![Bilingual](https://img.shields.io/badge/language-繁中%20%7C%20English-2563EB?style=flat-square)](#)
[![Zero Dependency](https://img.shields.io/badge/output-Single%20HTML%20(Zero%20Install)-059669?style=flat-square)](#)
[![Quality Check](https://img.shields.io/badge/self--check-16%20Rules%20%2B%20Google%20★%20Filter-D97706?style=flat-square)](#)
[![Origin](https://img.shields.io/badge/from-AI%20First%20Delivery%20%23027-4F46E5?style=flat-square)](#)

<br/>

<table>
  <tr>
    <td align="center" width="25%">
      <img src="assets/landmarks/kr-busan.webp" alt="釜山海岸膠囊列車" width="160"/><br/>
      <sub><b>🇰🇷 釜山海岸膠囊列車</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="assets/landmarks/jp-fuji.webp" alt="富士山" width="160"/><br/>
      <sub><b>🇯🇵 富士山與河口湖</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="assets/landmarks/tw.webp" alt="台灣" width="160"/><br/>
      <sub><b>🇹🇼 台灣天燈</b></sub>
    </td>
    <td align="center" width="25%">
      <img src="assets/landmarks/fr.webp" alt="艾菲爾鐵塔" width="160"/><br/>
      <sub><b>🇫🇷 巴黎艾菲爾鐵塔</b></sub>
    </td>
  </tr>
</table>

<sub>▲ 內建 17 款 Blender 程式建模原創地標封面插圖，直接嵌入單一 HTML 離線可看</sub>

</div>

---

## 💡 這是什麼？

跟 GitHub Copilot 說一句**「幫我安排出國行程」**，或直接丟出**「哪幾天、去哪裡」**。
它最多問兩輪問題、上網查證真實班次與評價後，就會交給你一個**雙擊就能打開的單一 HTML 行程檔**：

- 🗓️ **逐日逐站時間軸**：每天幾點到哪、怎麼過去、走多久、花多少錢、下雨怎麼辦，全部排好。
- ⭐ **Google 高分篩選（v1.7）**：候選飯店優先挑 **Google 4.0★+（評論 > 100 則）**；餐廳與咖啡店優先挑 **Google 4.2★+（評論 > 100 則）** 並附同區高分備選店。
- 🌐 **真・雙語切換（繁中／English）**：一鍵切換整頁語言，店名與地址自動保留當地原文（韓文／日文等），現場直接拿給司機或店員看。
- 🛡️ **16 條量化自評 + 網頁即時驗算**：打開網頁時自動用經緯度與時間軸驗算動線、緩衝與預算，杜絕「紙上排得通、現場走不完」。

---

## ✨ 核心特色一覽

| 領域 | 它會幫你做什麼 |
|---|---|
| 🎯 **極簡提問** | 最多問兩輪。只說要排時列出 10 題（僅 3 題 ★ 必答，其餘皆有聰明預設）；一句話給了細節就只追問缺漏項。 |
| 🏨 **高分住宿推薦** | 以飯店為中心不走回頭路。還沒訂房時，每段推薦住宿區並附 **3 家差異化候選飯店**（首選、實惠、位置/景觀更好），**優先挑 Google 4.0★+ 且評論 > 100 則**，標明評分與評論則數。 |
| 🍜 **高口碑餐廳與備選** | 餐廳挑在順路 10 分鐘內、避開尖峰排隊，**優先挑 Google 4.2★+ 且評論 > 100 則**的高口碑名店，標明星等、評論數與招牌菜，每餐再附 **1～2 家同區高分備選餐廳**。 |
| 🚶 **現場真實度量化** | 用觀光速度算步行（市區 4 km/h、步道/市場 3 km/h）、把熱門設施排隊時間（平日 15–20 分、假日 30–40 分）算進結束時間、單日市區移動 ≤ 150 分鐘、回程起飛前 3 小時到機場倒推。 |
| 🍁 **當季亮點與天氣備案** | 查出發期間的賞楓、櫻花、滑雪、祭典與季節性關閉設施；每站戶外行程都有同區室內的雨天備案（`rainAlt`），開檔自動抓 Open-Meteo 即時預報或歷年同期氣候。 |
| 🚇 **依交通方式換排法** | **大眾運輸**算周遊券/交通卡划不划算並對末班車；**自駕**查每站停車場、跨國還車與國際駕照；**計程車**附當地文字地址卡與叫車 App；韓國自動優先排 Naver Map / KakaoMap。 |
| 👨‍👩‍👧 **全齡與飲食照顧** | 同行有小孩、長輩、推車或飲食限制會自動調整步調、排午後休息、查兒童票價與無障礙設施；有生日或紀念日會安排慶祝餐廳並提醒開放訂位時間。 |
| 🔍 **嚴格查證不編造** | 營業時間、公休日、預約、票價、國際中間價匯率、各國護照入境規定皆附來源與查證日期；查不到一律標「未查證」，「最大／最高／唯一」無官方一手來源必改寫或刪除。 |

---

## 📦 安裝指南

> [!TIP]
> **完全不需要安裝 Python、Node.js 或任何套件！** 只要把資料夾放進對應路徑即可。放入 `~/.copilot/skills/` 一次，GitHub Copilot app、CLI、VS Code 三個環境都讀得到。

### 支援平台

| 平台 | 安裝位置 | 實測狀態 |
|---|---|---|
| **GitHub Copilot app** | `~/.copilot/skills/trip-planner/`（方法一） | ✅ 已實測（2026-10-14，Windows） |
| **GitHub Copilot CLI** | 同上 | ✅ 已實測（2026-10-14，Windows，CLI 1.0.95） |
| **VS Code GitHub Copilot** | 同上（[官方文件](https://code.visualstudio.com/docs/agent-customization/agent-skills)亦支援 `~/.claude/skills/`、`~/.agents/skills/`） | 📘 依官方文件（未實測） |
| **Copilot Cowork (M365)** | 於 Cowork 介面直接上傳 ZIP（方法三） | 🧪 未實測（雲端執行環境） |

### 確認資料夾結構

請確認 `SKILL.md` 直接位於 `trip-planner/` 底下，**不要多包一層**（避免解壓縮後變成 `trip-planner/trip-planner/SKILL.md`）：

```text
trip-planner/
├── SKILL.md                      # Skill 核心流程與觸發定義
├── README.md                     # 使用說明書
├── CHANGELOG.md                  # 版本更新記錄
├── assets/
│   ├── trip-template.html        # 雙語互動式行程網頁範本（MapLibre + Open-Meteo）
│   ├── set-cover.ps1             # Windows 封面插圖嵌入腳本
│   ├── set-cover.sh              # macOS / Linux 封面插圖嵌入腳本
│   └── landmarks/
│       ├── index.json            # 地標配對索引
│       └── *.webp                # 17 張原創 Blender 地標插圖
└── references/
    ├── intake-questions.md       # 開場 10 題提問範本與台港用語對照
    ├── planning-rules.md         # 12 大排程規則與 16 條自我檢查清單
    └── trip-data-contract.md     # 雙語 JSON 資料契約（schemaVersion "1"）
```

---

### 方法一：個人範圍安裝（推薦，所有專案皆可用）

把整個 `trip-planner` 資料夾複製到 `~/.copilot/skills/trip-planner/`。

> [!NOTE]
> 從典藏館網站下載的 `trip-planner.zip` 打開直接是 `SKILL.md`，請先在 `skills` 裡建一個 `trip-planner` 資料夾再解壓進去；電子報附件解壓後已有外層 `trip-planner` 資料夾，直接整個拖過去即可。

#### 🪟 Windows
1. 打開「檔案總管」，在上方網址列輸入 `%USERPROFILE%\.copilot\skills` 並按 `Enter`。
2. **打得開**：把 `trip-planner` 資料夾整個拖進去即完成。
3. **打不開**：代表資料夾尚未建立。網址列改輸入 `%USERPROFILE%`，依序新增 `.copilot` → `skills` 資料夾，再把 `trip-planner` 拖進去。
4. 完成後確認此路徑存在：`C:\Users\<你的帳號>\.copilot\skills\trip-planner\SKILL.md`。

#### 🍎 macOS【待實測】
1. 打開「終端機（Terminal）」，執行：
   ```bash
   mkdir -p ~/.copilot/skills
   ```
2. 在 Finder 按 `Shift` + `Command` + `G`，輸入 `~/.copilot/skills` 按 `Enter`。
3. 把 `trip-planner` 資料夾整個拖進去。

---

### 方法二：專案範圍安裝（團隊共用）【待實測】

把整個 `trip-planner` 資料夾複製到該專案 repo 的 `.github/skills/trip-planner/`。推上 GitHub 後，同一個 repo 的同事開 Copilot 就能直接使用。

---

### 方法三：Copilot Cowork（Microsoft 365）【待實測】

Cowork 不讀本機資料夾，需在介面左選 **Customize** → **Skills** → **Add 旁箭頭** → **Upload skill** 上傳無密碼、且 `SKILL.md` 在最外層的 ZIP（[官方說明](https://learn.microsoft.com/en-us/microsoft-365/copilot/cowork/cowork-customize)，單一 ZIP 上限 10 MB、100 個檔案）：

- **典藏館網站下載的 `trip-planner.zip`**：無密碼且 `SKILL.md` 在最外層，可直接上傳。
- **電子報附件版**：有密碼且多包一層資料夾，請先解壓縮、進入 `trip-planner` 資料夾內，全選 `SKILL.md`、`README.md`、`assets`、`references` 重新壓成無密碼 ZIP 再上傳。

---

### ✅ 驗證安裝成功

1. **重開 Copilot**：CLI 關掉重開；App 重新啟動；VS Code 執行 `Developer: Reload Window`（若無反應請確認設定中已開啟 Agent Skills）。
2. 輸入：**「你有 trip-planner 這個 skill 嗎？」** 或直接說 **「幫我安排出國行程」**。

---

## 🚀 怎麼開始使用？

三種開口方式都可以：

### 方式 1：直接說「幫我安排出國行程」
它會一次列出 10 個問題，你只要照編號回一行就好（沒寫到的題目自動套用預設）：
```text
1 釜山　2 10/19 出發 5 天　3 台北，17:00 到、回程 13:00　4 2 大人　5 還沒訂，想住西面　6 全部交給你　7 一定要去甘川洞　8 大眾運輸
```

### 方式 2：一句話把細節講完（最快！）
```text
10/19 從台北出發到釜山，17:00 到，10/23 搭 13:00 的飛機回來。住西面的○○飯店，搭地鐵，兩大一小，步調放鬆
```
它會先複述聽懂的部分，只補問缺漏的關鍵題。

### 方式 3：直接點名觸發
```text
用 trip-planner 幫我排 10/19 去釜山 5 天的行程
```

### 📋 開場 10 題與預設值對照表

| # | 題目內容 | 必答 | 沒回答或回「交給你」時的預設值 |
|:---:|---|:---:|---|
| **1** | **去哪裡**（多個城市照順序寫） | ★ | —（必答） |
| **2** | **哪天出發、玩幾天** | ★ | —（必答） |
| **3** | **從哪裡出發；去程抵達、回程起飛時間**（或給航班號） | ★ | —（必答） |
| **4** | 同行人數、小孩年齡、長輩／行動不便／嬰兒車 | | `2 位大人` |
| **5** | 住宿訂了沒；沒訂的話想住哪區、預算 | | 依路線推薦住宿區，每段附 **3 家 Google 4.0★+ 候選飯店** |
| **6** | 已經訂好的門票、餐廳、演唱會、一日遊 | | 全部交給 AI 排 |
| **7** | 一定要去的、不想去的、飲食限制 | | 由 AI 挑選，無飲食限制 |
| **8** | 當地交通（大眾運輸／計程車／自駕／混搭） | | `大眾運輸` |
| **9** | 步調、預算、總預算上限、每天出門與回飯店時間、夜市夜景 | | `適中`、`標準`、無上限、`09:00–21:30` |
| **10** | 護照國籍、同行者不同護照、旅途中的生日或紀念日 | | 台灣/香港/澳門出發依出發地推定（開排前會確認）；其他直接問 |

> [!IMPORTANT]
> **開排前必確認的 4 件事**（就算你回「其他都用預設」也會先跟你確認）：
> 1. **查到的航班表定時刻**（當你只給航班號、沒給時間時）
> 2. **推定的護照國籍**（依出發地推定時）
> 3. **小孩年齡**（同行有小孩卻沒給年齡時，因影響門票與設施限制）
> 4. **特殊活動細節**（行程含滑雪、潛水、登山、主題樂園時的程度、裝備與保險）

---

## 🖥️ 產出網頁功能與修改行程

排完後，你會在目前資料夾拿到一個 HTML 檔（例如 `trip-busan-2026-10-19.html`）：

| 功能 | 說明 |
|---|---|
| 💻 **電腦／手機直接開** | 電腦雙擊即可用瀏覽器開啟；手機支援 RWD（iPhone / Android 皆實測通過，可透過 Teams 傳給自己點開，外部導航或下載若被 App 內預覽器擋住改用系統瀏覽器開啟即可）。 |
| 🌐 **繁中／English 雙語切換** | 點擊右上角「繁／EN」整頁切換語言。店名與地址下方固定顯示當地原文（如 `韓文：…` / `Korean: …`），現場直接拿給司機看。從香港出發或用香港用語時，繁中版自動改用香港說法（的士、酒店、港鐵）。 |
| 🗺️ **互動地圖與導航按鈕** | 總覽看全部天數，也可單看某一天；每站附一鍵導航按鈕（韓國預設 Naver Map / KakaoMap 優先，其他國家 Google Maps / Apple Maps）。離線時自動改列文字地址與導航連結。 |
| 🌤️ **即時天氣與氣候退路** | 連網自動抓 Open-Meteo 預報；超過 16 天預報範圍或離線時，自動顯示內建的歷年同期氣候資料。 |
| ✅ **品質檢查面板** | 自動檢查時間重疊、住宿缺漏、移動時速是否合理、單日交通是否超時，並清楚列出未查證項目；資料查證超過 14 天會自動提醒。 |
| 🔒 **一鍵「產生分享版」** | 點擊網頁上的「產生分享版」，可勾選隱藏**住宿名稱與候選飯店、預算金額、同行者個資、航班號、預約資訊**，另存為乾淨的 `-share.html`（被隱藏的資料會從檔案原始碼徹底移除，不會出現在地圖上）。 |

### 🔄 想修改行程？直接講，不用重排整份！

你可以隨時對 Copilot 說：
- 💬 `「只改第 3 天，想多一點購物」`
- 💬 `「改成租車」`
- 💬 `「換飯店：（新飯店名稱或地址）」`
- 💬 `「重新查證這份行程」`（建議出發前一週跑一次：只更新營業時間與票價，不重排動線）
- 💬 `「幫這份行程補英文版」`（將 v1.5 以前的舊版單語檔案無損升級為雙語 `-v2` 檔）

---

## 🎨 原創 Blender 封面插圖庫（17 款）

行程封面會由 `set-cover` 工具依 **「城市 → 地區 → 國家 → 通用圖」** 順序，自動嵌入一張 ≤ 60 KB 的原創 Blender 建模 `.webp` 插圖（無第三方素材，離線可看）：

| 插圖名稱 | 自動配對條件 | 插圖名稱 | 自動配對條件 |
|---|---|---|---|
| **釜山海岸膠囊列車** | 城市為釜山（Busan、부산） | **新加坡店屋** | 新加坡（`SG`） |
| **富士山** | 富士山一帶（河口湖、富士吉田、富士宮、山梨、靜岡） | **萬里長城** | 中國（`CN`） |
| **鳥居** | 日本其他地區（`JP`） | **艾菲爾鐵塔** | 法國（`FR`） |
| **韓式宮殿門樓** | 韓國其他地區（`KR`） | **大笨鐘** | 英國（`GB`） |
| **台灣天燈** | 台灣（`TW`） | **羅馬競技場** | 義大利（`IT`） |
| **香港帆船** | 香港（`HK`） | **自由女神像** | 美國（`US`） |
| **澳門大三巴** | 澳門（`MO`） | **澳洲袋鼠** | 澳洲（`AU`） |
| **泰國泰式涼亭** | 泰國（`TH`） | **啟程旅行（通用圖）** | 其他未列出的目的地 |
| **越南下龍灣與斗笠** | 越南（`VN`） | | |

---

## 🛠️ 疑難排解（FAQ）

<details>
<summary><b>Q1：沒網路時打開 HTML 檔會怎樣？</b></summary>

檔案照樣能打開，完整行程、時間軸、各站地址與說明都看得到，也能列印。
地圖需要連網；沒網路或公司網路阻擋時，地圖區會自動改列各站的當地地址與導航連結，連上網路後按「重試」即可。
</details>

<details>
<summary><b>Q2：天氣預報是怎麼顯示的？</b></summary>

依照手邊能取得的資料順序顯示：
1. **有網路（且在出發前 16 天內）**：抓 Open-Meteo 即時預報並快取在本機。
2. **沒網路（但這台裝置之前開過）**：顯示上次存下的預報。
3. **出發日還太遠（超過 16 天）或從未連網開過**：顯示行程內附的「歷年同期平均氣候」。等接近出發日再打開同一個檔案，就會自動換成即時預報，不用重排！
</details>

<details>
<summary><b>Q3：為什麼有些項目標示「未查證」或沒有景點照片？</b></summary>

- **未查證**：代表當時 AI 環境無法連網，或該店家的公休日/票價在公開網頁查不到。可換到能上網的環境請它「重新查證未查證的項目」。
- **沒有照片**：景點照片嚴格只用 Wikimedia Commons 且必須查得到作者與授權，找不到就留空，絕不拿其他網站的圖片充數。
</details>

<details>
<summary><b>Q4：為什麼預算金額跟我去銀行換到的現鈔對不上？</b></summary>

預算一律使用**國際中間價（`mid`）**換算並標明來源。去銀行換外幣現鈔用的是「現鈔賣出價」，會比中間價貴；刷卡則依信用卡結算匯率計算。實際價差請以銀行牌價為準。
</details>

<details>
<summary><b>Q5：封面插圖沒出現怎麼辦？</b></summary>

代表產生行程時環境無法執行指令，網頁已自動把空白封面隱藏，不影響行程。想手動補上，可在 Windows PowerShell 執行（以個人範圍安裝為例）：
```powershell
powershell -ExecutionPolicy Bypass -File "$env:USERPROFILE\.copilot\skills\trip-planner\assets\set-cover.ps1" -Html "trip-busan-2026-10-19.html" -City "釜山" -Country "KR"
```
macOS／Linux 改用 `bash` 執行 `set-cover.sh`，參數相同（需系統內建 `perl`、`JSON::PP`、`MIME::Base64`）。
</details>

<details>
<summary><b>Q6：切到 English 還是看到中文、沒有切換按鈕，或頁面頂端出現雙語警示條？</b></summary>

> ⚠️ **注意**：更新 skill 後，請務必**開一個全新的對話**（舊對話會記得舊版規則）。

1. **沒有切換按鈕、頂端也沒有警示條（v1.5 以前的舊檔）**：
   開新對話輸入：
   ```text
   用 trip-planner 幫 C:\Users\<你的帳號>\Downloads\trip-busan-2026-10-19.html 補英文版，只補英文、不重排行程，另存新檔、原檔保留
   ```
2. **頂端出現雙語警示條（兩份資料結構對不上或英文版殘留中文字）**：
   開新對話輸入：
   ```text
   用 trip-planner 修 C:\Users\<你的帳號>\Downloads\trip-busan-2026-10-19.html 的雙語警示：照頂端警示條列出的原因和位置，把英文那份修好、結構對齊繁中那份。只修資料，不重排行程、不重新查證，也不要另外補一份英文版
   ```
3. **只有店名與地址下方的 `Korean: …` / `Japanese: …` 是當地文字**：
   這是刻意保留給你在當地指給司機或店員看的 `nameLocal` / `addressLocal`，屬於正常設計。
</details>

<details>
<summary><b>Q7：沒有觸發 trip-planner skill 怎麼辦？</b></summary>

1. 檢查路徑是否多包了一層（正確應為 `…\skills\trip-planner\SKILL.md`）。
2. 重開 Copilot CLI / App，或在 VS Code 執行 `Developer: Reload Window`。
3. 開頭直接點名：`「用 trip-planner 幫我排 10/19 去釜山 5 天的行程」`。
</details>

---

## 🔒 隱私、條款與資料來源授權

- **無金鑰、無追蹤**：產出的 HTML 檔內不含任何 API 金鑰，無須登入帳號。
- **外部連線說明**：打開 HTML 查天氣、載入地圖與照片時，瀏覽器會將目的地座標與你的 IP 傳送至 Open-Meteo、OpenFreeMap、jsDelivr 與 Wikimedia。
- **轉傳提醒**：轉傳檔案前請善用網頁上的「產生分享版」隱藏住宿、預算與同行者個資。
- **免責聲明**：行程由 AI 協助規劃與查證，訂位、買票與付款前請再次向官方確認（特別是標註「未查證」之項目）。

| 用途 | 資料來源 | 授權與署名規範 |
|---|---|---|
| **天氣預報與氣候** | [Open-Meteo.com](https://open-meteo.com/) | CC BY 4.0（免費版限非商業用途；公務出差請自行評估） |
| **地圖資料與底圖** | © OpenStreetMap contributors／OpenMapTiles／OpenFreeMap | 網頁自動顯示署名 |
| **地圖渲染引擎** | MapLibre GL JS（由 jsDelivr 載入） | BSD-3-Clause |
| **景點照片** | Wikimedia Commons | 依各張照片授權，於照片下方自動標示作者與授權條款 |
| **封面地標插圖** | 本 Skill 原創（Blender 程式建模） | 無第三方素材，直接嵌入 HTML |

---

## 📋 版本紀錄與已知限制

### 版本更新
- **v1.7（2026-10-16）**：**新增飯店與餐廳 Google 評價篩選與標註規範**。候選飯店（`stays[].options`）優先挑 Google 4.0★ 以上且評論數 > 100 則，3 家候選具明確定位區隔（首選、實惠、位置/景觀更好），並於推薦理由標明 Google 評分與評論則數；餐廳與咖啡店（`food`、`cafe`）優先挑 Google 4.2★ 以上且評論數 > 100 則的高口碑店家，標明評分、評論數與招牌餐點，每餐 `tips` 再附 1～2 家同區高分備選餐廳。查不到評分時標「評分未查證」，嚴禁編造星等。（詳見 [`CHANGELOG.md`](./CHANGELOG.md)）
- **v1.6（2026-10-15）**：**行程網頁改為真雙語（繁中／English）**。每份行程同時帶繁中與英文兩份內容，切換至 English 時整頁皆為英文，僅店名與地址下方的當地原文（如 `"Korean: …"`）保留當地文字；移除簡中；封面工具一次寫入雙語名稱。支援將 v1.5 以前舊檔無損補上英文版。

### 已知限制
- 跨時區與多幣別換算為 v1.5 新增功能，實際表現依實測持續更新。
- English 模式的地圖底圖僅顯示具英文或拉丁字母名稱的地名；各站行程內的當地原文不受影響。
- 當地原文（`nameLocal`、`addressLocal`）為 AI 查證後填入，查不到時會留空，問路時請改用英文名稱或導航按鈕。
