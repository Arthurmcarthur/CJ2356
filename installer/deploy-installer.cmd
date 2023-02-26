@echo off
mkdir "..\Installer\system32.x86"
mkdir "..\Installer\system32.x64"
mkdir "..\Installer\system32.arm64"
copy ..\Release\CJ2356Settings.exe ..\Installer\
copy ..\Release\x64\CJ2356.dll ..\Installer\system32.x64\
copy ..\Release\arm64ec\CJ2356.dll ..\Installer\system32.arm64\
copy ..\Release\Win32\CJ2356.dll ..\Installer\system32.x86\
"c:\Program Files (x86)\NSIS\makensis.exe" CJ2356-x86armUniversal.nsi
REM use the following line instead for buiding on x86 platform
REM "c:\Program Files\NSIS\makensis.exe" CJ2356-x86armUniversal.nsi
echo ===============================================================================
echo Deployment and Installer packaging done!!
echo ===============================================================================
pause
