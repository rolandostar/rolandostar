:: Run in Command Prompt (cmd.exe)
:: This script will install both the Chocolately .exe file and add the
:: choco command to your PATH variable

@echo off
echo Administrative permissions required. Detecting permissions ...

net session >nul 2>&1
if %ERRORLEVEL% EQU 0 (
ECHO Okay ...
IF EXIST "C:\ProgramData\chocolatey\bin\chocolatey.exe" (
ECHO Chocolatey is already installed ...
choco upgrade chocolatey chocolatey-core.extension -y
) ELSE (
ECHO Installing Chocolatey ...
@PowerShell -NoProfile -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"
)
ECHO Checking packages ...
SET downloaded=
IF NOT EXIST packages.txt (
  SET downloaded=true
  ECHO packages.txt file not found, downloading from repo ...
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://gitcdn.link/repo/rolandostar/rolandostar/master/packages.txt', 'packages.txt')"
)
ECHO Installing packages ...
for /F "eol=#" %%G in (packages.txt) do choco upgrade %%G -y

IF defined downloaded DEL "packages.txt"
SET downloaded=
IF NOT EXIST packages.txt (
  SET downloaded=true
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://gitcdn.link/repo/rolandostar/rolandostar/master/additional.txt', 'additional.txt')"
)
ECHO Remember to install additional packages!
for /F "eol=#" %%G in (additional.txt) do (echo %%G)
IF defined downloaded DEL "additional.txt"
) else (
echo Failure: Current permissions inadequate.
)