@echo off
set OLDDIR=%CD%
cd /d %~dp0

:begin

IF "%~1"=="" GOTO MissingParameters
IF "%~1"=="x86" GOTO init32
IF "%~1"=="x64" GOTO init64
goto MissingParameters


:init32
set MSCV_ARCH=Win32
set DEST=..\lib\win32\release\
goto nghttp2


:init64
set MSCV_ARCH=x64
set DEST=..\lib\x64\release\
goto nghttp2


:nghttp2
cd nghttp2

echo Please run this script inside a Visual Studio tools command line with cmake in the PATH

echo Building lib...

del CMakeCache.txt
cmake . -A %MSCV_ARCH% -DENABLE_STATIC_LIB=1 -DENABLE_STATIC_CRT=0 -DENABLE_SHARED_LIB=0
cmake --build . --target clean
cmake --build . --config Release



:docopy
echo Copying lib...
copy lib\Release\nghttp2.lib %DEST%

echo All done. Run CopyLibs2Public.bat and copy lib\includes\nghttp2 to gpac extra_lib\include if needed.
goto done


:MissingParameters
echo "Specify argument x86 or x64. 2nd argument can be path to vcvarsall.bat"

:done
cd /d %OLDDIR%