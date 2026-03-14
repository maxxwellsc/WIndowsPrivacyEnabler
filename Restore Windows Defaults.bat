@echo off
:: Windows 10 Privacy Restore Script (Undo Changes)
echo.
echo ======================================================
echo   RESTORING WINDOWS DEFAULTS (ADMIN REQUIRED)
echo ======================================================
echo.

echo [+] Re-enabling Prefetch and SysMain...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 3 /f >nul
sc config "SysMain" start=auto >nul
sc start "SysMain" >nul 2>&1

echo [+] Re-enabling Activity History and Search...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 1 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 1 /f >nul

echo [+] Re-enabling Telemetry Services...
sc config "DiagTrack" start=auto >nul
sc start "DiagTrack" >nul 2>&1
sc config "DPS" start=auto >nul
sc start "DPS" >nul 2>&1

echo.
echo ======================================================
echo   RESTORE FINISHED! PLEASE RESTART YOUR COMPUTER.
echo ======================================================
pause
