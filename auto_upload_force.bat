@echo off
REM ===============================
REM GitHub Auto Upload Script
REM Developer: ! ＧＡＭＥＲ ＳＡＢＢＩＲ
REM Discord: sabbirtop111
REM Server: https://discord.gg/SfuFVPnNCu
REM Server Name: GAMER CORPORATION
REM Description: Upload all files in current folder EXCEPT .bat
REM Force push → overwrite remote, no pull, no merge, no Vim
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

REM --- Add all files from CURRENT folder except this .bat ---
for %%f in (*.*) do (
    if /I not "%%~nxF"=="auto_upload_force.bat" git add "%%f"
)

REM --- Commit only if there are changes ---
git diff-index --quiet HEAD || git commit -m "Auto Upload %DATE% %TIME%"

REM --- Force push changes to overwrite remote ---
git push -f https://%GIT_TOKEN%@%REPO_URL% main

echo.
echo ===============================
echo Upload Finished! All local files uploaded (except .bat), remote overwritten.
echo ===============================
pause
