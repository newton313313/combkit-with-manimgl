# ManimGL 新計畫起步指南（給下一個 AI 與繼任者）

整理日期：2026-10-16。寫給要在這台電腦上**開一個新的 ManimGL 動畫計畫**的人或 AI。讀完這一份就能開工；
細節再查第 2 節列的文件。

**路徑的寫法：** 本文件裡沒有寫磁碟機的相對路徑，一律相對於 `C:\mypython\manim`（本文件所在的資料夾）。
例如 `projects/combkit` 就是 `C:\mypython\manim\projects\combkit`。

---

## 0. 三十秒摘要

- 用的是 **ManimGL v1.7.2**（3Blue1Brown 版，git commit **fafa083**，`manimgl` 指令、`from manimlib import *`），**不是 Manim Community**。不要升級、重裝、`pip install manimgl` 或 `git pull`。
- 系統是**繁體中文 Windows**（cp950）。設定檔只能寫英文；中文用 `Text`／`zh()`，不要放進 `Tex`。
- 已經有一個做得很完整的範本專案 `projects/catalan930`（134 支影片、119 個場景、4 份講義），和一個可重複使用的工具包 `projects/combkit`（1.35.0）。另一個照同樣流程做的計畫是 `projects/walk017`（隨機漫步，逐章進行中）。**新計畫照它們的做法，不要從零開始。**
- 使用者要求：**繁體中文**、**每一步都省 token**、**舊影片不刪不覆寫**、**參考文獻不散布**、**新演示的共用程式收進 combkit**。完整清單在第 7 節。
- 標準流程（第 4 節）：大綱 → 生動度檢討 → 例子檢討 → 程式大綱 → 省 token 檢討 → 定稿 → 先寫數學模組（自我測試）→ 代理人平行做場景 → 看總覽圖 → 逐支輸出 1080p → 文件、combkit、git、進度紀錄。

---

## 1. 環境（2026-10-16 實測，全部已裝好）

| 項目 | 版本／位置 | 備註 |
|---|---|---|
| Windows 11 Home（繁中，cp950） | — | 終端機輸出中文前設 `PYTHONIOENCODING=utf-8` |
| Python | 3.10.9，Anaconda base `C:\Users\User\anaconda3\python.exe` | |
| ManimGL | 1.7.2，commit fafa083，原始碼就是 `C:\mypython\manim`（`pip install -e .`） | `import manimlib` 載入 `C:\mypython\manim\manimlib` |
| 繪圖後端 | `wgpu` 0.31.0、`rendercanvas` 2.7.2、`glfw` 2.10.2 | |
| 套件 | numpy 1.23.5、scipy、sympy 1.11.1、Pillow 9.4.0、`av` 17.1.0、PyMuPDF 1.28.2 | PyMuPDF 用來把 PDF 轉文字、截圖 |
| ffmpeg／ffprobe | 4.3.1（conda-forge） | 量影片長度、抽畫面 |
| LaTeX | MiKTeX 25.12：`latex`＋`dvisvgm` 3.4.3＋**`cm-super`**；講義用 `xelatex`＋`xeCJK`、`tcolorbox`、`tikz`、`ytableau` | |
| 字型 | 微軟正黑體 `Microsoft JhengHei`；講義的斜體用標楷體 `DFKai-SB` | |
| git | 2.44.0 | |

完整說明（重建環境、檔案結構、注意事項）：`環境與交接_ENVIRONMENT.md`（本資料夾）。安裝紀錄與**每天的進度紀錄**：`install.log`（本資料夾，混合編碼，見 6.4）。

---

## 2. 現有資源地圖（先看這些，不要重做）

| 東西 | 位置 | 用途 |
|---|---|---|
| 範本專案 | `projects/catalan930/` | 卡塔蘭數、Chu 1987、MIT 18.212、Fulton《Young Tableaux》全書、Raney 1960 的動畫與講義。權威說明 `projects/catalan930/交接說明_HANDOFF.md`、`projects/catalan930/codes/README.md` |
| 工具包 | `projects/combkit/` | 數學（純 Python）＋畫圖（ManimGL）＋TikZ；`README.md`（§10＝加入新演示的步驟）、`API.md`；`tools/render_check.py`（試渲染＋總覽圖）、`tools/strict_render.py`、`tools/make_zip.py`；13 個範例 `examples/ex01…ex13` |
| 計畫檔範例 | `projects/catalan930/notes/fulton_plan_ch9-10.md`、`fulton_plan_appAB.md` | 第 4 節流程的實際成品，照抄格式 |
| 講義範例 | `projects/catalan930/notes/young_tableaux_導讀.tex`（主檔）＋`notes/fulton/part*.tex`＋`notes/fulton/make_figs.py` | xelatex 中文講義、程式產生圖表並先核對數字 |
| 可攜版 | `projects/catalan_portable_106/`（＋`.zip`） | 拿到別台電腦用；重做方法在交接說明第 2 節 |
| 另一個用 combkit 的計畫 | `C:\mypython\spglass` | 把自己的共用程式（`rmt_moments`、`tikz_trees`）直接加進 combkit 的例子 |
| 逐章做一本書的計畫 | `projects/walk017/` | Rudnick & Gaspari《Elements of the Random Walk》：全書分章轉 md（`ref/convert_to_md.py` 會還原數學字型、產生小節索引 `ref/md/00_INDEX.md`）、逐式校對與筆誤表、全書第 1–12 章 W101–W1206＋導讀講義；權威說明 `projects/walk017/交接說明_HANDOFF.md`。共用模組用 combkit 的 `tools/sync_from_walk017.py` 同步 |
| 靜態藝術圖（桌布）的計畫 | `projects/walkart/` | 用 walk017 的數學模組做 60 張 4K 藝術桌布（每章 5 張）：`Plate` 基底類別只寫 `art()`、`codes/stills.py` 直接從相機存 PNG（不用 `-s`）、先出 960×540 預覽與接觸表再出 4K、成品已存在就跳過；每張再做成 5 秒動畫（`animate_plate` 照 `art()` 自動排出「長出來」的動畫，`codes/anims.py` 預覽→抽格接觸表→1080p→章節卡→ffmpeg 合成）；kit 也在 combkit 的 `combkit/draw/art_kit.py` |
| 掃描書（沒有文字層）的計畫 | `projects/harter_sym/` | Harter PSDS 前三章：`ref/page_png.py` 裁切頁面影像 → 代理人看圖轉寫成結構化 md → 照 walk017 流程；`codes/scene_list.py` 一張登記表供 `main.py`（動態建同名子類別與 ChNDemo）、`render_all.py`、`check_env.py` 共用 |

---

## 3. 建一個新計畫（一步步）

以新計畫 `projects/<新計畫>` 為例（名稱自訂，用英數字）。

### 3.1 資料夾結構

```text
projects/<新計畫>/
├── 交接說明_HANDOFF.md      權威說明（做什麼、怎麼跑、場景清單、踩過的坑）——每完成一件事就更新
├── codes/                   manimgl 一律在這裡執行
│   ├── README.md            給使用者看的說明（環境、指令、場景表、資料夾結構）
│   ├── custom_config.yml    只能寫英文（見 3.2）
│   ├── main.py              每個場景的同名子類別＋連續播放（見 3.5）
│   ├── render_all.py        批次輸出（見 3.6）
│   ├── check_env.py         環境檢查（可從 catalan930 複製後刪改）
│   ├── scenes/              一個檔案一個場景：sceneXX_主題.py（放一個空的 __init__.py）
│   ├── utils/               本計畫的數學（純 Python，附自我測試）與畫圖模組（放一個空的 __init__.py）
│   └── renders/             影片（不進 git）
├── notes/                   計畫檔 plan_*.md、講義 .tex/.pdf、make_figs.py
└── ref/                     參考文獻 PDF 與轉出的 md（僅供個人研讀，不可散布）
```

### 3.2 `codes/custom_config.yml`（直接照抄；不能有中文，包括註解）

```yaml
directories:
  base: ""
  subdirs:
    output: "renders"
camera:
  background_color: "#1C1C1E"
  fps: 30
text:
  font: "Microsoft JhengHei"
```

### 3.3 git

```bash
git -C C:/mypython/manim/projects/<新計畫> init
```

`.gitignore` 照抄 catalan930 的（`codes/renders/`、`*_temp.mp4`、`codes/latex_cache/`、`__pycache__/`、`*.pyc`、LaTeX 的 `*.aux *.log *.out *.toc *.xdv …`；講義 PDF **要**追蹤）。
`.gitattributes` 只寫一行 `* -text`（這台電腦 `core.autocrlf=true`，不設會改動換行）。**每完成一件事就 commit 一次**；
commit 訊息結尾加 `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`（PowerShell 裡把訊息寫進檔案再 `git commit -F 檔案`）。
這個 repo 位在 `C:\mypython\manim`（ManimGL 自己的 repo）裡面，兩者無關，不要把計畫加進外層 repo。

### 3.4 用 combkit（兩種方式擇一）

- 不安裝：程式開頭 `sys.path.insert(0, r"C:\mypython\manim\projects\combkit")`，再 `from combkit.X import …`、`from combkit.draw.X import …`。
- 安裝：`python -m pip install -e C:/mypython/manim/projects/combkit`（`pyproject.toml` 刻意不列 manimgl，不會動到固定版本）。

常用：`combkit.draw.scene_base.ChuScene`（`show_header(文字)` 左上標題；`say(*段落, wait=秒)` 底部字幕，以 `$` 開頭的段落是 LaTeX；
`clear_stage()`、`fade_all()`）、`combkit.draw.styles`（`zh()` 中文、`mixed()` 中文＋公式混排、`boxed()`、`MUTED_COLOR`）、
`combkit.draw.fulton_draw.assert_in_frame(*mobs)`／`assert_apart(a, b)`（版面檢查）。各模組的 API 看 `projects/combkit/README.md` §4 與 `API.md`。

### 3.5 場景骨架與 `main.py`

**場景檔** `codes/scenes/scene01_hello.py`：

```python
"""
Scene 01 —— 主題（來源與頁碼）
執行（在 codes/ 內）：manimgl scenes/scene01_hello.py Scene01Hello
"""
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent.parent))   # codes/，讓 utils.* 可以 import
sys.path.insert(0, r"C:\mypython\manim\projects\combkit")          # combkit（已 pip install 就不需要）

from manimlib import *

from combkit.draw.fulton_draw import assert_in_frame
from combkit.draw.scene_base import ChuScene
from combkit.draw.styles import zh
from utils.mymath import answer                                    # 本計畫的數學模組


def check_math():
    assert answer(3) == 5                                          # 畫面上出現的每一個數字都要 assert


def part_one(scene):                                               # 輔助函式寫成「模組層級」，不要寫成方法（見 6.1）
    scene.say("開頭先問一個問題：", "$n=3$", " 時有幾個？")
    t = Tex(r"C_3=5", font_size=60).set_color(YELLOW)              # Tex 的 color= 參數無效，用 set_color
    assert_in_frame(t)
    scene.play(Write(t), run_time=1.0)
    scene.wait(1.0)


class Scene01Hello(ChuScene):
    def construct(self):
        self.show_header("標題（中文）")
        check_math()
        part_one(self)
        self.clear_stage()
        self.say("收束：一句話總結")
        self.wait(1.0)
```

**`codes/main.py`**（ManimGL 只列出「定義在該檔案裡」的場景，所以每個場景都要一個同名子類別）：

```python
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))          # codes/，讓 scenes.*、utils.* 可以 import
sys.path.insert(0, r"C:\mypython\manim\projects\combkit")

from manimlib import *

from scenes import scene01_hello as s01
from scenes import scene02_next as s02


def play_sequence(scene, classes):
    """依序借用各場景的 construct 連續播放；場景之間清空畫面、鏡頭歸位。"""
    for k, cls in enumerate(classes):
        cls.construct(scene)
        if k < len(classes) - 1:
            scene.fade_all(run_time=0.8)
            scene.frame.to_default_state()
            scene.wait(0.4)


class Scene01Hello(s01.Scene01Hello):
    pass


class Scene02Next(s02.Scene02Next):
    pass


ALL_SCENES = [s01.Scene01Hello, s02.Scene02Next]


class FullDemo(s01.Scene01Hello):
    """全部連續播放。"""

    def construct(self):
        play_sequence(self, ALL_SCENES)
```

連續播放是「拿 FullDemo 這個物件去跑別的場景的 construct」，所以場景只能用 ChuScene 的方法與模組層級函式。
以上骨架（`custom_config.yml`、`utils/mymath.py`、兩個場景、`main.py`）2026-10-16 實際建過一個測試計畫：
`manimgl main.py FullDemo -w -l` 與 `render_check.py` 都成功，中文字幕、標題、公式都正常。

### 3.6 `codes/render_all.py`（最小版；也可複製 catalan930 的完整版再改清單）

```python
"""一次輸出全部 1080p 影片（在 codes/ 裡執行）。一次只跑一個 manimgl。"""
import subprocess
import sys

SCENES = [("scenes/scene01_hello.py", "Scene01Hello"), ("scenes/scene02_next.py", "Scene02Next")]
DEMOS = [("main.py", "FullDemo")]
quality = "-l" if "-l" in sys.argv else "--hd"
for f, cls in SCENES + (DEMOS if "--demos" in sys.argv else []):
    print("輸出", cls, flush=True)
    subprocess.run(["manimgl", f, cls, "-w", quality], check=True)
```

catalan930 另有 `codes/render_all.bat`（按兩下的選單，會自動啟用 conda）；它必須是**純 ASCII＋CRLF**，要改請用 Python 讀寫 bytes。

### 3.7 數學模組 `codes/utils/<主題>.py`

純 Python、不 import manim；檔頭 docstring 就是 API 說明（代理人只讀這一段）；檔尾：

```python
def check():
    assert ...            # 用兩種獨立方法算同一件事（公式 vs 暴力列舉）、重現書上的例子
    return True


if __name__ == "__main__":
    check()
    print("<主題>：…全部驗證通過")
```

把它加進 `check_env.py`（比對最後那句話）。可重複使用的部分照 `projects/combkit/README.md` §10 收進 combkit（見 4.4）。

---

## 4. 工作流程（使用者指定，照做）

### 4.1 計畫檔（`notes/plan_<主題>.md`），一份檔案裡依序寫

1. **草稿大綱**：每幕一行（主題、來源節次與頁碼）。
2. **生動度檢討**：哪幾幕只會堆定義？改成問題開場、遊戲、謎題、「先猜再揭曉」、並排對照、拆積木式的逐步動畫；每幕開頭一個問題、結尾一句收束；找一條貫穿全系列的主例。
3. **例子檢討**：每幕至少一個「從頭算到尾的小例子」＋一個「書上的例子或較大的例子」，列成表。
4. **程式大綱**：數學模組要哪些函式、畫圖模組要哪些元件、哪些現成的 combkit 可以用。
5. **省 token 檢討**：哪些幕可以合併、不做 3D、不另建資料檔、代理人不讀原始文獻、幾個代理人、每幕最多幾次試渲染。
6. **定稿場景卡**（代理人只讀這一節）：每幕 3–5 個步驟，寫明畫面上要出現的**每個數字**；再加製作規則、檔名與分工表。

範例：`projects/catalan930/notes/fulton_plan_ch9-10.md`（最完整）。

### 4.2 執行

1. **先寫數學模組**並跑自我測試（書上的例子要逐格重現；用第二種方法交叉驗證）。
2. 需要新圖形就**先寫畫圖模組**，用一個小範例跑一次 `render_check` 確認元件真的畫得出來。
3. **派代理人**（Agent 工具，背景執行）：每個代理人 5 幕左右，2 個平行；提示詞用 4.3 的範本。
4. 代理人回報後，**自己看每一幕的總覽圖**（`projects/combkit/runs/<類別>/sheet.png`），核對數字與版面；有疑問就用 ffmpeg 抽畫面。
5. **全部回報完才**接進 `main.py`／`render_all.py`，**一次一支**輸出 1080p（背景執行，不要輪詢）。
6. 抽查成片（`ffmpeg -sseof -1 -i 影片 -frames:v 1 x.png`）。
7. 更新文件（README、交接說明；用 4.5 的腳本法）、combkit（加模組或範例、升版、`make_zip.py`）、`install.log` 進度紀錄、git commit。
8. 講義（若使用者要）：見 5.2。

### 4.3 代理人提示詞範本（照填）

```text
Build ManimGL scenes for a Traditional-Chinese math video series (<主題>). You are agent A: scenes <F..>, <F..>.
Another agent (B) builds <F..> at the same time; never touch its files. Minimize tokens: read only what is listed; short report.

Read first:
1. <計畫檔路徑> sections 6, 7, 8 only (scene cards, rules, file names). The cards contain all the math you need; do NOT read the sources.
2. Module docstrings only (top ~30 lines): <本計畫的數學模組>, <畫圖模組>, combkit/combkit/draw/scene_base.py, combkit/combkit/draw/fulton_draw.py.
   Skim ONE finished scene for style only if necessary.

Environment: ManimGL 1.7.2 (3b1b, `from manimlib import *`), NOT Manim Community; Windows; set PYTHONIOENCODING=utf-8.
Project root <codes 路徑>. Never run manimgl directly in codes/; only via
`python tools/render_check.py <場景檔> <類別> --config <codes>/custom_config.yml --tile 480` run inside C:\mypython\manim\projects\combkit
(each run has its own cache and TEMP, so running alongside the other agent is fine, but run your own renders one at a time).
Do not modify shared files (utils/, main.py, render_all.py); only create your scene files. Write Python containing backslashes with
the Write/Edit tools, not shell heredocs. Max 2 render_checks per scene; look at each contact sheet yourself and fix overlaps,
out-of-frame text, missing glyphs. Do not commit.
Report (≤ 8 lines): per scene file, duration, STATUS, deviations.
```

規模參考：一個代理人做 5 幕約用 20–24 萬 token、25–30 分鐘；每幕 2–3 分鐘、250–450 行；1080p 每幕約 1–1.5 分鐘輸出。

### 4.4 combkit 規則（使用者的長期要求）

今後新演示的**可重複使用程式**都收進 combkit：數學放 `projects/combkit/combkit/<主題>.py`、畫圖放 `combkit/draw/<主題>_draw.py`、
範例 `examples/exNN_<主題>.py`（先算、assert、再畫）；README §4、§5、§9 各加一行；`combkit/__init__.py` 的 `__version__` 升一版
（新功能 1.x → 1.(x+1)；只改文件或修錯升最後一位）；在 `projects/combkit` 裡跑 `python tests/run_selftests.py --draw` 與 `python tools/make_zip.py`
（產生 `projects/combkit_v<版本>.zip`，舊版不覆寫）。目前 1.32.0。
注意：`tools/sync_from_catalan930.py` 只會覆寫「來自 catalan930 `codes/utils/` 的同名模組」；新計畫的模組名稱不要和它們撞名
（`counting`、`tableaux`、`rep_data`、`raney`、`raney_examples`、`schubert`、`fulton_appendix` 與畫圖的 `*_draw` 等）。

### 4.5 改文件用腳本，不要一個一個 Edit

```python
from pathlib import Path


def apply(path, reps):
    """依序做字串取代；每個舊字串必須剛好出現一次。保留原本的換行（CRLF 或 LF）。"""
    raw = Path(path).read_bytes().decode("utf-8")
    crlf = "\r\n" in raw
    s = raw.replace("\r\n", "\n")
    for a, b in reps:
        assert s.count(a) == 1, a[:60]
        s = s.replace(a, b)
    Path(path).write_bytes((s.replace("\n", "\r\n") if crlf else s).encode("utf-8"))
```

腳本寫進 scratchpad 再執行；影片長度用 `ffprobe -v error -show_entries format=duration -of csv=p=0 檔案` 自動量。

---

## 5. 講義（xelatex）

### 5.1 寫法（使用者的要求）

- 繁體中文，**初學者也看得懂**：每章開頭一個「先看這裡」框；先直觀、再定義、定義後馬上舉例；抽象的東西翻成「數格子」「數交點」；每節最後附練習與答案。
- **例子越多越好**，每個例子都從頭算到尾；書上的例子標頁碼（例如〔書 p.184〕）。
- **每一個數字都由程式核對**：`make_figs.py` 裡寫 `check_numbers_xxx()` 逐一 assert，表格與圖（TikZ／ytableau）由程式產生成 `figs.tex`，正文 `\input`。

### 5.2 導言區（照 `projects/catalan930/notes/young_tableaux_導讀.tex` 前 52 行）

重點：`\documentclass[11pt,a4paper]{article}`、`geometry`（2.2cm）、`amsmath,amssymb,mathtools`、
`xeCJK` 加 `\setCJKmainfont[BoldFont={Microsoft JhengHei Bold},ItalicFont={DFKai-SB}]{Microsoft JhengHei}`、`\linespread{1.28}`、
`xcolor`、`tikz`、`tcolorbox`（定義 `keybox`、`thmbox`、`notebox` 三種框）、`booktabs`、`enumitem`、`float`、`caption`、`hyperref`、
`ytableau`（`\ytableausetup{boxsize=1.25em,aligntableaux=center}`，行內小表 `\newcommand{\yts}[1]{{\ytableausetup{smalltableaux}\ytableaushort{#1}}}`）。
編譯：在 notes 裡先 `python make_figs.py`，再跑兩次 `xelatex 主檔.tex`。附錄用 `\appendix`。

---

## 6. 踩過的坑（每一條都曾造成失敗的渲染或錯誤的畫面）

### 6.1 ManimGL

1. 使用者給的大綱常是 Manim Community 寫法（`manim -pql`、`Create`）：改成 `manimgl`、`ShowCreation`，並告訴使用者。
2. `custom_config.yml` 只能寫英文（cp950 讀檔）；它必須在執行 `manimgl` 的資料夾裡。
3. `manimgl main.py` 只列出定義在 `main.py` 裡的場景 → 每個 import 進來的場景都要同名子類別。
4. 連續播放（`play_sequence`）借用別的場景的 `construct`：**輔助函式一律寫成模組層級函式**，寫成方法會 AttributeError。
5. **`Tex(..., color=X)` 在這版無效**，要 `.set_color(X)`。
6. **同一個 `play` 裡不要同時動畫父物件與它的子物件**（例如 `FadeIn(mat)` 加 `LaggedStartMap(FadeIn, mat.stars())`）：子物件會消失。分兩個 play。
7. Tex 字串開頭／結尾不要放 `\,`、`\;`；用 `t2c` 時不要用 `\left(…\right)`（改 `\Big(`）。否則上色版的編譯失敗卻不報錯，會沿用上一個公式（畫面顯示成別的公式）。修好字串後 `manimgl --clear-cache`。`combkit/tools/strict_render.py`（render_check 內建）會讓這種錯誤直接報出來。
8. `\iff` 會編譯失敗，用 `\Leftrightarrow`。中文不要放進 `Tex`（用 `Text`／`zh()`／`mixed()`）。
9. `Tex("a", "b")[1]` 是第 2 個**字形**，不是第 2 段；`t2c` 上色要整個因子一起（`x_1^{n_1}`，只上 `x_1` 指數會跑位）。
10. `mob.get_center()` 回傳的是「活的」陣列，要存下來請 `.copy()`。自訂屬性不要和 ManimGL 撞名（`.parents`、`.color`、`.stroke_width`）；放在 dict／list 裡的子物件不會跟著 `.copy()`。`.scale()` 不會縮線寬。
11. **不要同時跑兩個 `manimgl`**：會共用 `latex_cache/working.tex` 與 `%TEMP%` 裡 `Text` 的暫存 .svg，互相覆蓋。平行試渲染一律用 `render_check.py`（各自的資料夾、公式快取與 TEMP）；正式輸出一次一支。
12. 全機共用的公式快取 `%LOCALAPPDATA%\manim\manim\Cache`（SQLite）曾因平行寫入損毀（`database disk image is malformed`）：把那個資料夾改名或刪掉，ManimGL 會重建。
13. 輸出最後偶爾 `PermissionError: [WinError 32]`（把 `X_temp.mp4` 改名成 `X.mp4` 時被防毒軟體擋住）：重新輸出那一支，刪掉留下的 `_temp.mp4`。
14. `-s`（存 PNG）在這台的 Pillow 9.4 會出錯：要看畫面就 `-w -l` 輸出後用 ffmpeg 抽格，或看 render_check 的總覽圖。
15. 預覽視窗按鍵：Ctrl+Q 結束、滾輪縮放、按住 `f` 平移、`r` 重設。

### 6.2 LaTeX（講義）

1. 這版 `ytableau` 沒有 `enableskew` 選項；空格子要寫 `{}`（例如 `\yts{{}2,3}`）。
2. 文字模式裡的 ✓、↔、↦ 在 Latin Modern 字型裡沒有字形（會「Missing character」而消失）：改用 `$\checkmark$`、`$\leftrightarrow$`、`$\mapsto$`。
3. 編譯中途失敗可能留下壞掉的 `.aux`，之後一直報 `File ended while scanning use of \@newl@bel`：刪掉 `.aux .toc .out` 再編譯。
4. 表格裡放多列的小 Young 表會上下重疊：在表格前加 `\renewcommand{\arraystretch}{2.6}`；太寬的矩陣改 `smallmatrix`。
5. MiKTeX 每次都會警告「尚未檢查更新」，可忽略。

### 6.3 命令列（Claude Code 的 Bash／PowerShell 工具）

1. Git Bash 的 heredoc 會吃掉反斜線（`\r`、`\n`、`\c` 都出過事）、很長的 heredoc 會失敗：**含反斜線的檔案一律用 Write／Edit 工具寫**，或先寫成 .py 再執行。
2. PowerShell 的雙引號裡 `$變數` 會被展開（`python -c "…$v_T$…"` 的 `$v_T` 消失了）、`&` 不能出現在未加引號的參數裡：複雜的 python 一律寫成檔案。
3. PowerShell 5.1 的 `Set-Content -Encoding utf8` 會加 BOM；要寫 UTF-8（無 BOM）請用 `[IO.File]::WriteAllText(path, s, (New-Object Text.UTF8Encoding $false))` 或 Python。PowerShell 的 `[IO.File]` 用的目前目錄和 `cd` 不同，請給完整路徑。
6. `python -I`（處理外來檔案時建議用）會忽略 `PYTHONIOENCODING`：在程式裡 `sys.stdout.reconfigure(encoding="utf-8")`，否則印中文或連字（ﬁ）會 cp950 錯誤。
4. PowerShell 不能用 `git commit -F -` 接 here-string：把訊息寫進檔案再 `-F 檔案`。
5. `.bat` 必須純 ASCII＋CRLF，用 Python bytes 寫；Git Bash 呼叫 Windows 指令時加 `MSYS_NO_PATHCONV=1`；本地 .bat 用 `.\x.bat` 執行。

### 6.4 檔案的換行與編碼

- CRLF 的檔案：catalan930 的 `codes/README.md`、`main.py`、`render_all.py`、`check_env.py`、講義主檔 `.tex`、`.bat`，以及 `環境與交接_ENVIRONMENT.md`。改的時候保留換行（用 4.5 的 `apply`）。
- `install.log`（本資料夾）是**混合編碼**：不能用 `read_text`；要附加進度時讀 bytes、接上 UTF-8 bytes 再寫回。
- 終端機輸出中文前設 `PYTHONIOENCODING=utf-8`。

### 6.5 讀參考文獻（省 token）

- PDF 先用 PyMuPDF 轉成 md（catalan930 的 `projects/ref/*/convert_to_md.py`，每頁加〔p. N〕標記），只讀需要的段落：先 `Select-String` 找小節、定理與頁碼標記的行號，再讀那幾段。
- OCR 的數學式常是亂碼：需要書上的例子或圖時，用 PyMuPDF 把那一頁截一小塊成 PNG 再看。
- 掃描版的全書 PDF 只作參考，不轉。
- 有文字層、數學用 MathTime 等 Type 1 字型的 PDF（例如 Cambridge 的書）：照 `projects/walk017/ref/convert_to_md.py` 的做法——字碼用各字型物件 /Encoding 的 /Differences 字形名稱還原成 Unicode（各章的字型子集不同）、獨立式依座標排成文字圖、頁首用「本頁最上面一行」判斷、緊排沒有空白的行依字距補空白；再寫一份逐式校對的 `chNN_formulas.md`（書上常有筆誤）。

---

## 7. 使用者的偏好與規則（必須遵守）

1. 文件、字幕、README、講義一律**繁體中文**；文件裡的相對路徑要寫明相對於哪個資料夾；被要求找錯時要機械式地逐項核對。
2. **每一步都省 token**：只讀需要的部分；計畫先寫好再動手；代理人只讀定稿卡與模組說明；用腳本批次改文件；背景工作不要輪詢。
3. **已完成的影片不刪除、不覆寫**；新影片用新名稱。
4. 只用 ManimGL；不升級、不重裝。
5. 參考文獻 PDF 與它們的轉檔僅供個人研讀，**不可散布**（不放進公開的壓縮檔或網路）。
6. 不要把使用者的 email 送到任何外部服務。
7. 多代理人的 Workflow 工具只在使用者明確要求時才用；平常用 Agent 工具派代理人。
8. 新演示的共用程式收進 combkit、升版、重新打包（4.4）。
9. 每完成一件事：更新 `codes/README.md` 與交接說明（兩者一起改）、在 `install.log` 附一行進度、git commit。
10. 動畫要生動：問題開場、收束一句話、例子多、每個數字都由程式 assert；做完要自己看總覽圖。
11. 講義寫給初學者、例子越多越好、數字由程式核對（第 5 節）。
12. 可攜版（另一台電腦用）只在使用者要求時做，方法照 catalan930 交接說明第 2 節。

---

## 8. 常用指令速查

| 做什麼 | 指令（在哪裡執行） |
|---|---|
| 預覽某場景 | `manimgl scenes/scene01_hello.py Scene01Hello`（`codes/`） |
| 輸出 1080p | `manimgl scenes/scene01_hello.py Scene01Hello -w --hd`（`codes/`）；低畫質把 `--hd` 換 `-l` |
| 試渲染＋總覽圖 | `python tools/render_check.py <場景檔完整路徑> <類別> --config <codes>/custom_config.yml --tile 480`（`projects/combkit/`），看 `runs/<類別>/sheet.png`；`--frames 3,8` 抽原尺寸畫面 |
| 量影片長度 | `ffprobe -v error -show_entries format=duration -of csv=p=0 影片.mp4` |
| 抽最後一格 | `ffmpeg -loglevel error -y -sseof -1 -i 影片.mp4 -frames:v 1 x.png` |
| 公式出錯 | `manimgl --clear-cache` |
| 數學自我測試 | `python utils/<主題>.py`（`codes/`） |
| 環境檢查 | `python check_env.py --render`（`codes/`；catalan930 的版本可以直接參考） |
| combkit 測試／打包 | `python tests/run_selftests.py --draw`、`python tools/make_zip.py`（`projects/combkit/`） |
| 講義 | `python make_figs.py` 後 `xelatex 主檔.tex` 兩次（`notes/`） |

---

## 9. 做完一件事的檢查清單

- [ ] 數學模組自我測試通過，並已加進 `check_env.py`
- [ ] 每一幕的總覽圖都看過（數字、重疊、出框、缺字）
- [ ] 全部場景接進 `main.py`、`render_all.py`（與 `.bat`），1080p 一支一支輸出完成、抽查過成片
- [ ] `codes/README.md`、交接說明已更新（場景表含影片長度、指令、資料夾結構、檢查方法）
- [ ] 共用程式收進 combkit、升版、`make_zip.py`
- [ ] `install.log` 附上進度、git commit
- [ ] 給使用者的回報：做了什麼、偏離計畫的地方、還沒做的事
