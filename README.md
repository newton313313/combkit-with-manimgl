# combkit ＋ ManimGL 1.7.2 安裝包

（本文的相對路徑都以這個 repo 的根目錄為基準。）

把 [combkit](https://github.com/newton313313/combkit)（組合數學 × ManimGL 動畫工具包）和它測試過的 ManimGL 版本放在一起，
附上環境文件、固定版本清單與一鍵安裝腳本。

## 1. 下載

ManimGL 與 combkit 都是 **git submodule**（指向原作者的 repo 與固定的 commit），所以要加 `--recursive`：

```bash
git clone --recursive https://github.com/newton313313/combkit-with-manimgl.git
```

已經 clone 但 `manimgl\`、`combkit\` 是空的，就在 repo 裡補抓：

```bash
git submodule update --init --recursive
```

## 2. 內容

| 資料夾／檔案 | 內容 |
|---|---|
| `manimgl\` | submodule → [3b1b/manim](https://github.com/3b1b/manim) 的 commit `fafa083`（ManimGL 1.7.2，3Blue1Brown 版）。**不是** Manim Community。沒有任何修改。 |
| `combkit\` | submodule → [newton313313/combkit](https://github.com/newton313313/combkit)（1.35.2）：數學模組、`combkit.draw` 畫圖工具、`examples\`、`tests\`、`tools\`；說明在 `combkit\README.md` |
| `docs\` | 原機器的環境與交接說明、ManimGL 使用說明、新計畫起步指南（裡面提到的 `C:\mypython\...` 是原機器的位置） |
| `requirements_pinned.txt` | 原機器上能正常運作的套件版本（Python 3.10.9） |
| `install.bat` | 一鍵安裝＋自我測試（Windows） |

不包含：各計畫的影片與桌布、參考書的 PDF 與轉檔（只供個人學習，不散布）。

## 3. 需要先裝好的東西

- **Python 3.10**（原機器是 Anaconda 的 3.10.9）。3.12 也能跑，但 `requirements_pinned.txt` 裡的 numpy、scipy、Pillow、matplotlib、contourpy、PyYAML 要換成有 3.12 版本的新版；
  scipy 1.11 起 `walk_eps` 的自我測試會失敗（`special.factorial2(-1, exact=True)` 改成回傳 0）。
- **LaTeX**：MiKTeX 或 TeX Live，要有 `latex`／`xelatex`、`dvisvgm` 與 `cm-super`。MiKTeX 請開啟「自動安裝缺少的套件」；
  裝了 `cm-super` 之後執行一次 `initexmf --mkmaps`，不然 `\text{}` 會是空白。
- **ffmpeg** 放在 PATH 上。
- 字型：中文字幕用 Microsoft JhengHei；藝術桌布用 Garamond、Corbel（Windows 內建）。

## 4. 安裝

在 repo 根目錄（建議在新的 conda 環境）執行：

```bat
install.bat
```

它依序做：裝 `requirements_pinned.txt` 的固定版本 → `pip install --no-deps -e manimgl` → `pip install --no-deps -e combkit`
→ `python combkit\tests\run_selftests.py --draw`。`--no-deps` 是故意的：不讓 pip 把 ManimGL 換成別的版本。

## 5. 試跑

```bat
cd combkit\examples
python ex28_young_wallpaper.py
```

其他範例見 `combkit\README.md` 第 5 節；做新計畫的步驟見 `docs\新計畫起步指南_NEW_PROJECT_GUIDE.md`。

## 6. 常見問題（細節見 `docs\`）

- 每個場景資料夾放一個 `custom_config.yml`，內容必須是純 ASCII（中文 Windows 會用 cp950 讀）；從該資料夾執行 `manimgl`。
- 這版 `manimgl -s`（只存最後一格）不能用；靜態圖用 `combkit.draw.art_kit.render_png()`。
- `Tex` 裡不要用 `\;`、`\!`、`\:`；`Tex(color=)` 無效，要 `.set_color()`／`.set_fill()`。
- 公式出錯或大小怪怪的：刪掉場景資料夾的 `latex_cache\working.dvi`，再 `manimgl --clear-cache`。
  （ManimGL 編譯失敗時會沿用舊的 `working.dvi`，錯的結果還會存進快取。）
- 中文 Windows 上設 `PYTHONUTF8=1`，避免 latex 輸出用 cp950 解碼出錯。

## 7. 第三方軟體與授權

- **ManimGL** — Copyright (c) 2020-2026 3Blue1Brown LLC，[MIT License](https://github.com/3b1b/manim/blob/master/LICENSE.md)。
  本 repo 沒有複製它的程式碼，只用 submodule 指向原 repo 的 commit
  [`fafa083`](https://github.com/3b1b/manim/commit/fafa083a4fb274bba9cabde0b6e2f50ba6da0622)；
  下載後授權全文在 `manimgl\LICENSE.md`。combkit 只 `import manimlib`，也不包含 ManimGL 的程式碼。
- `requirements_pinned.txt` 列的套件各自有自己的授權，由 pip 從 PyPI 安裝，不包含在本 repo。
