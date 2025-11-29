@echo off
REM ===============================
REM GitHub Auto Upload Script
REM Upload all files in current folder EXCEPT .bat
REM Old remote files kept, auto pull & merge
REM ===============================

REM --- Current folder ---
set REPO_DIR=%~dp0
cd /d "%REPO_DIR%"

REM --- Manual input: GitHub Repo URL ---
set /p REPO_URL="Enter your GitHub Repo URL (e.g., https://github.com/username/repo.git): "
set REPO_URL=%REPO_URL:https://=%

REM --- Manual input: GitHub Token ---
set /p GIT_TOKEN="Enter your GitHub Token: "

REM --- Initialize Git if not already a git repo ---
git rev-parse --is-inside-work-tree >nul 2>&1
IF ERRORLEVEL 1 (
    echo Initializing new Git repo...
    git init
    git remote add origin https://%GIT_TOKEN%@%REPO_URL%
)

REM --- Set branch to main ---
git branch -M main

REM --- Ignore this .bat file to prevent conflicts ---
echo auto_upload.bat > .gitignore
git add .gitignore
git commit -m "Add gitignore to exclude .bat" 2>nul

REM --- Stash any local changes to .bat temporarily ---
git stash push -m "Stash .bat" --keep-index 2>nul

REM --- Pull remote changes first (auto merge, old files safe) ---
git pull https://%GIT_TOKEN%@%REPO_URL% main --allow-unrelated-histories --no-edit

REM --- Add all files from CURRENT folder except .bat ---
for %%f in (*.*) do (
    if /I not "%%~nxF"=="auto_upload.bat" git add "%%f"
)

REM --- Commit only if there are changes ---
git diff-index --quiet HEAD || git commit -m "Auto Upload %DATE% %TIME%"

REM --- Push changes ---
git push https://%GIT_TOKEN%@%REPO_URL% main

REM --- Restore stash if exists ---
git stash pop 2>nul

echo.
echo ===============================
echo Upload Finished! Old files kept, new files uploaded, .bat excluded.
echo ===============================
pause