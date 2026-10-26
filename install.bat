@echo off
chcp 65001 >nul
rem 在 repo 根目錄執行；建議先開一個乾淨的 Python 3.10 環境（例：conda create -n manimgl python=3.10）
rem manimgl\ 與 combkit\ 是 git submodule：clone 時沒加 --recursive 的話先補抓
if not exist manimgl\setup.py git submodule update --init --recursive || goto :fail
if not exist combkit\pyproject.toml git submodule update --init --recursive || goto :fail
python -m pip install -r requirements_pinned.txt || goto :fail
python -m pip install --no-deps -e manimgl || goto :fail
python -m pip install --no-deps -e combkit || goto :fail
python combkit\tests\run_selftests.py --draw || goto :fail
echo.
echo 安裝完成，自我測試全部通過。
goto :eof
:fail
echo.
echo 安裝或測試失敗，請看上面的訊息與 README.md 的「常見問題」。
exit /b 1
