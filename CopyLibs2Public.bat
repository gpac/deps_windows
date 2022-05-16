@echo on
set OLDDIR=%CD%
cd /d %~dp0

:begin

IF "%~2"=="" set GPAC_PUBLIC=gpac_public
IF not "%~2"=="" set GPAC_PUBLIC=%~2

IF "%~1"=="" GOTO MissingParameters
IF "%~1"=="all" GOTO win32
IF "%~1"=="x86" GOTO win32
IF "%~1"=="x64" GOTO win64
goto MissingParameters

:win32
echo Copying x86 extralibs
if not exist ..\%GPAC_PUBLIC%\extra_lib\lib\win32\debug\ mkdir ..\%GPAC_PUBLIC%\extra_lib\lib\win32\debug\
if not exist ..\%GPAC_PUBLIC%\extra_lib\lib\win32\release\ mkdir ..\%GPAC_PUBLIC%\extra_lib\lib\win32\release\
if not exist ..\%GPAC_PUBLIC%\bin\win32\debug\ mkdir ..\%GPAC_PUBLIC%\bin\win32\debug\
if not exist ..\%GPAC_PUBLIC%\bin\win32\release\ mkdir ..\%GPAC_PUBLIC%\bin\win32\release\
copy lib\win32\release\*eay* lib\win32\debug\
copy lib\win32\release\av* lib\win32\debug\
copy lib\win32\release\swscale* lib\win32\debug\
copy lib\win32\debug\*.lib ..\%GPAC_PUBLIC%\extra_lib\lib\win32\debug\
copy lib\win32\release\*.lib ..\%GPAC_PUBLIC%\extra_lib\lib\win32\release\
copy lib\win32\debug\*.dll ..\%GPAC_PUBLIC%\bin\win32\debug\
copy lib\win32\release\*.dll ..\%GPAC_PUBLIC%\bin\win32\release\
copy lib\win32\release\*.manifest ..\%GPAC_PUBLIC%\bin\win32\release\
copy lib\win32\debug\*.plg ..\%GPAC_PUBLIC%\bin\win32\debug\
copy lib\win32\release\*.plg ..\%GPAC_PUBLIC%\bin\win32\release\

copy build\msvc\2015\vc_redist.x86.exe ..\%GPAC_PUBLIC%\packagers\win32_64\nsis\

if exist xulrunner-7.0.1.en-US.win32.sdk.zip goto XULSDK_copy
wget --no-check-certificate https://ftp.mozilla.org/pub/xulrunner/releases/7.0.1/sdk/xulrunner-7.0.1.en-US.win32.sdk.zip
unzip -n xulrunner-7.0.1.en-US.win32.sdk.zip
:XULSDK_copy
xcopy /i /e /q /y xulrunner-sdk ..\%GPAC_PUBLIC%\extra_lib\include\xulrunner-sdk\
:DekTec_copy
REM unzip -n dektec_dtapi_201505.zip
if exist SDL2-devel-2.0.20-VC.zip goto SDL_copy
wget http://www.libsdl.org/release/SDL2-devel-2.0.20-VC.zip
unzip SDL2-devel-2.0.20-VC.zip
:SDL_copy
if not exist ..\%GPAC_PUBLIC%\extra_lib\include\SDL\ mkdir ..\%GPAC_PUBLIC%\extra_lib\include\SDL\
copy SDL2-2.0.20\include\ ..\%GPAC_PUBLIC%\extra_lib\include\SDL\
copy SDL2-2.0.20\lib\x86\*.lib ..\%GPAC_PUBLIC%\extra_lib\lib\win32\debug\
copy SDL2-2.0.20\lib\x86\*.lib ..\%GPAC_PUBLIC%\extra_lib\lib\win32\release\
copy SDL2-2.0.20\lib\x86\*.dll ..\%GPAC_PUBLIC%\bin\win32\debug\
copy SDL2-2.0.20\lib\x86\*.dll ..\%GPAC_PUBLIC%\bin\win32\release\
IF "%~1"=="all" GOTO win64
GOTO done

:win64
echo Copying x64 extralibs
if not exist ..\%GPAC_PUBLIC%\extra_lib\lib\x64\debug\ mkdir ..\%GPAC_PUBLIC%\extra_lib\lib\x64\debug\
if not exist ..\%GPAC_PUBLIC%\extra_lib\lib\x64\release\ mkdir ..\%GPAC_PUBLIC%\extra_lib\lib\x64\release\
if not exist ..\%GPAC_PUBLIC%\bin\x64\debug\ mkdir ..\%GPAC_PUBLIC%\bin\win32\debug\
if not exist ..\%GPAC_PUBLIC%\bin\x64\release\ mkdir ..\%GPAC_PUBLIC%\bin\x64\release\
copy lib\x64\release\*eay* lib\x64\debug\
copy lib\x64\release\av* lib\x64\debug\
copy lib\x64\release\swscale* lib\x64\debug\
copy lib\x64\debug\*.lib ..\%GPAC_PUBLIC%\extra_lib\lib\x64\debug\
copy lib\x64\release\*.lib ..\%GPAC_PUBLIC%\extra_lib\lib\x64\release\
copy lib\x64\debug\*.dll ..\%GPAC_PUBLIC%\bin\x64\debug\
copy lib\x64\release\*.dll ..\%GPAC_PUBLIC%\bin\x64\release\
copy lib\x64\release\*.manifest ..\%GPAC_PUBLIC%\bin\x64\release\

copy build\msvc\2015\vc_redist.x64.exe ..\%GPAC_PUBLIC%\packagers\win32_64\nsis\

if exist xulrunner-7.0.1.en-US.win32.sdk.zip goto XULSDK_copy
wget --no-check-certificate https://ftp.mozilla.org/pub/xulrunner/releases/7.0.1/sdk/xulrunner-7.0.1.en-US.win32.sdk.zip
unzip -n xulrunner-7.0.1.en-US.win32.sdk.zip
:XULSDK_copy
xcopy /i /e /q /y xulrunner-sdk ..\%GPAC_PUBLIC%\extra_lib\include\xulrunner-sdk\
:DekTec_copy
REM unzip -n dektec_dtapi_201505.zip
if exist SDL2-devel-2.0.20-VC.zip goto SDL_copy
wget http://www.libsdl.org/release/SDL2-devel-2.0.20-VC.zip
unzip SDL2-devel-2.0.20-VC.zip
:SDL_copy
if not exist ..\%GPAC_PUBLIC%\extra_lib\include\SDL\ mkdir ..\%GPAC_PUBLIC%\extra_lib\include\SDL\
copy SDL2-2.0.20\include\ ..\%GPAC_PUBLIC%\extra_lib\include\SDL\
copy SDL2-2.0.20\lib\x64\*.lib ..\%GPAC_PUBLIC%\extra_lib\lib\x64\debug\
copy SDL2-2.0.20\lib\x64\*.lib ..\%GPAC_PUBLIC%\extra_lib\lib\x64\release\
copy SDL2-2.0.20\lib\x64\*.dll ..\%GPAC_PUBLIC%\bin\x64\debug\
copy SDL2-2.0.20\lib\x64\*.dll ..\%GPAC_PUBLIC%\bin\x64\release\
GOTO done


:MissingParameters
Echo You must specified target architecture : either x86, x64 or all

:done
cd /d %OLDDIR%
