@echo off
rem Builds out\MoreOptionsSRTT.asi (32-bit). Run from this folder.
call "C:\Program Files (x86)\Microsoft Visual Studio\2022\BuildTools\VC\Auxiliary\Build\vcvars32.bat" >nul 2>&1
if not exist out\obj mkdir out\obj
cl /nologo /O2 /LD /EHsc /W3 /D_CRT_SECURE_NO_WARNINGS /Isrc /Fo:out\obj\ /Fe:out\MoreOptionsSRTT.asi src\moreoptions.cpp user32.lib kernel32.lib d3d11.lib dxgi.lib
if errorlevel 1 exit /b 1
echo built: out\MoreOptionsSRTT.asi
