# ManimGL 簡短使用說明

> 這是 3Blue1Brown 作者的 **ManimGL**（套件名 `manimgl`），不是社群版 Manim Community（套件名 `manim`）。
> 兩者 API 與指令不同，範例程式碼不能混用。
> 官方文件：https://3b1b.github.io/manim/ ；中文文件：https://docs.manim.org.cn/

## 1. 安裝結果（本機）

| 項目 | 狀態 |
|---|---|
| Python | 3.10.9 (Anaconda base) |
| manimgl | v1.7.2，可編輯模式安裝自 `C:\mypython\manim` |
| ffmpeg | 4.3.1 (conda-forge) |
| LaTeX | MiKTeX + dvisvgm 3.4.3，已加裝 `cm-super` |

完整安裝過程與踩到的坑見 `install.log`。

## 2. 最小範例

在任意資料夾建立 `start.py`：

```python
from manimlib import *

class SquareToCircle(Scene):
    def construct(self):
        circle = Circle()
        circle.set_fill(BLUE, opacity=0.5)
        circle.set_stroke(BLUE_E, width=4)
        square = Square()

        self.play(ShowCreation(square))
        self.wait()
        self.play(ReplacementTransform(square, circle))
        self.wait()
```

執行：

```bash
manimgl start.py SquareToCircle
```

會跳出一個即時預覽視窗。視窗內操作（依本機這一版的原始碼，與官方 quickstart 文件寫的不同）：

- 滑鼠滾輪：縮放
- 按住 `f` + 移動滑鼠：平移
- 按住 `d` + 移動滑鼠：旋轉 3D 視角
- 按 `r`：畫面回到原位
- 按 `Ctrl` + `Q`，或直接按視窗的 ✕：關閉視窗離開

## 3. 常用指令

```bash
manimgl 檔案.py 場景名            # 開視窗即時預覽（預設）
manimgl 檔案.py 場景名 -w         # 輸出 mp4，不開視窗
manimgl 檔案.py 場景名 -o         # 輸出 mp4 並自動開啟
manimgl 檔案.py 場景名 -s         # 跳到最後一格只顯示結果
manimgl 檔案.py 場景名 -so        # 存最後一格為 png 並開啟
manimgl 檔案.py 場景名 -w -l      # 低畫質 480p（快速測試）
manimgl 檔案.py 場景名 -w -m      # 720p
manimgl 檔案.py 場景名 -w --hd    # 1080p
manimgl 檔案.py 場景名 -w --uhd   # 4K
manimgl 檔案.py 場景名 -i         # 輸出 gif
manimgl 檔案.py 場景名 -t         # 透明背景 (含 alpha)
manimgl 檔案.py 場景名 -n 3       # 從第 3 個動畫開始（跳過前面）
manimgl 檔案.py 場景名 -e 20      # 在第 20 行插入中斷點進入 iPython 互動
manimgl 檔案.py -a -w             # 輸出檔案內所有場景
manimgl 檔案.py                   # 不給場景名會列出清單讓你選
manimgl --clear-cache             # 清除 Tex / Text 快取（LaTeX 出錯時先試這個）
manimgl -h                        # 完整參數
```

輸出預設在執行目錄下的 `videos/`（影片）與 `images/`（圖片）。

## 4. 內建範例

在 `C:\mypython\manim` 目錄下：

```bash
manimgl example_scenes.py OpeningManimExample
```

`example_scenes.py` 內含 12 個範例場景，涵蓋文字 (`TextExample`)、LaTeX 公式 (`TexTransformExample`, `TexIndexing`)、
座標系與函數圖 (`CoordinateSystemExample`, `GraphExample`)、更新器 (`UpdatersExample`)、3D 曲面 (`SurfaceExample`)、
互動開發 (`InteractiveDevelopment`) 等，是學語法最快的入口。

## 5. 核心概念

- **Scene**：一支影片 = 一個 `Scene` 子類別，所有內容寫在 `construct(self)` 裡。
- **Mobject**：畫面上的物件（`Circle`, `Square`, `Text`, `Tex`, `Axes`, `NumberPlane`…）。
  - `self.add(mob)` 直接放上畫面；`self.remove(mob)` 移除。
  - 位置/樣式：`.shift(UP)`, `.move_to(ORIGIN)`, `.next_to(other, RIGHT)`, `.scale(2)`, `.set_color(RED)`。
- **Animation**：`self.play(...)` 播放動畫，例如 `ShowCreation`, `Write`, `FadeIn`, `FadeOut`, `Transform`, `ReplacementTransform`；
  `self.wait(秒數)` 停頓。
- **方法動畫**：`self.play(mob.animate.shift(UP).scale(2))` 讓任何屬性變化以動畫呈現。
- **Text vs Tex**：`Text("中文也可以")` 用系統字型（不需 LaTeX）；`Tex(R"\frac{a}{b}")` 走 LaTeX（需 MiKTeX）。
- **Updater**：`mob.add_updater(lambda m, dt: ...)` 讓物件每幀依時間或其他物件更新。

## 6. 設定檔

在執行目錄放 `custom_config.yml` 即可覆蓋預設（範本見 `manimlib/default_config.yml`），
常改的項目：輸出目錄 `directories.output`、解析度 `camera.resolution`、`camera.fps`、背景色 `camera.background_color`、
LaTeX 範本 `tex`。也可用 `--config_file 路徑` 指定。

## 7. 常見問題

- **`ModuleNotFoundError: No module named 'av'`**：`pip install -r requirements.txt`（setup.cfg 未列入 av）。
- **LaTeX 場景報 `SVG has no content to measure`**：
  1. MiKTeX 補裝字型：`miktex packages install cm-super`
  2. 清快取：`manimgl --clear-cache`
- **找不到 ffmpeg**：`conda install -c conda-forge ffmpeg`，或自行安裝並加入 PATH。
- **舊教學程式碼跑不動**：多半是社群版 (`from manim import *`) 或舊版 manimgl 語法，本版本用 `from manimlib import *`。
