@echo off
:: Windows 10 Privacy & Tracking Cleanup Script - Updated Version
echo.
echo ======================================================
echo   RUNNING PRIVACY CLEANUP (ADMIN PRIVILEGES REQUIRED)
echo ======================================================
echo.

echo [+] Disabling Prefetch and SysMain (Superfetch)...
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management\PrefetchParameters" /v "EnablePrefetcher" /t REG_DWORD /d 0 /f >nul
sc stop "SysMain" >nul 2>&1
sc config "SysMain" start=disabled >nul
del /q /f /s "C:\Windows\Prefetch\*.*" >nul 2>&1

echo [+] Disabling Activity History and Timeline...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t REG_DWORD /d 0 /f >nul
del /q /f /s "%AppData%\Microsoft\Windows\Recent\*.*" >nul 2>&1

echo [+] Disabling Telemetry and Tracking Services...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t REG_DWORD /d 0 /f >nul
sc stop "DiagTrack" >nul 2>&1
sc config "DiagTrack" start=disabled >nul
sc stop "dmwappushservice" >nul 2>&1
sc config "dmwappushservice" start=disabled >nul
sc stop "DPS" >nul 2>&1
sc config "DPS" start=disabled >nul

echo [+] Disabling Ad ID, Location, and WiFi Sense...
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" /v "Value" /t REG_SZ /d "Deny" /f >nul
reg add "HKCU\Software\Microsoft\Input\TIPC" /v "Enabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t REG_DWORD /d 0 /f >nul

echo [+] Disabling Cortana and Bing Web Search...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Speech_OneCore\Settings\OnlineSpeechPrivacy" /v "HasAccepted" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t REG_DWORD /d 0 /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CloudSearchEnabled" /t REG_DWORD /d 0 /f >nul

echo [+] Disabling Error Reporting and Feedback Hub...
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableUAR" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" /v "Disabled" /t REG_DWORD /d 1 /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t REG_DWORD /d 0 /f >nul
powershell -command "Get-AppxPackage *feedbackhub* | Remove-AppxPackage" >nul 2>&1

echo [+] Clearing Event Logs (and fixing Access Denied errors)...
:: Granting permissions to restricted LiveId logs before clearing
wevtutil sl Microsoft-Windows-LiveId/Operational /ca:O:BAG:SYD:(A;;0x1;;;SY)(A;;0x5;;;BA)(A;;0x1;;;LA) >nul 2>&1
wevtutil sl Microsoft-Windows-LiveId/Analytic /ca:O:BAG:SYD:(A;;0x1;;;SY)(A;;0x5;;;BA)(A;;0x1;;;LA) >nul 2>&1

:: Loop through all logs and clear them; hide errors for buggy entries
for /F "tokens=*" %%1 in ('wevtutil.exe el') do wevtutil.exe cl "%%1" 2>nul

echo.
echo ======================================================
echo   FINISHED! PLEASE RESTART YOUR COMPUTER.
echo ======================================================
pause
