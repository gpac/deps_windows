@echo off
set OLDDIR=%CD%
cd /d %~dp0

:begin
IF "%~2"=="" set MSCV_INIT="C:\Program Files (x86)\Microsoft Visual Studio 10.0\VC\vcvarsall.bat"
IF not "%~2"=="" set MSCV_INIT="%~2"

IF "%~3"=="" set BASH_EXE=bash
IF not "%~3"=="" set BASH_EXE=%~3

IF "%~1"=="" GOTO MissingParameters
IF "%~1"=="x86" GOTO init32
IF "%~1"=="x64" GOTO init64
goto MissingParameters


:init32
set MSCV_ARCH=x86
set TARGET=win32
set DEST=..\lib\win32\release\
goto openhevc


:init64
set MSCV_ARCH=amd64
set TARGET=win64
set DEST=..\lib\x64\release\
goto openhevc

:openhevc
set GIT=
for %%e in (%PATHEXT%) do (
  for %%X in (git%%e) do (
    if not defined GIT (
      set GIT=%%~$PATH:X
    )
  )
)

if not defined GIT goto git_not_found


IF EXIST ./openHEVC/ goto update_openhevc
git clone -b ffmpeg_update https://github.com/OpenHEVC/openHEVC.git
cd openHEVC
goto build_openhevc

:update_openhevc
cd openHEVC
"%GIT%" checkout --force ffmpeg_update
"%GIT%" fetch
"%GIT%" reset --hard FETCH_HEAD
goto build_openhevc


:build_openhevc
call %MSCV_INIT% %MSCV_ARCH%

if not exist ffbuild\config.mak (
	echo Running make clean...
	"%BASH_EXE%" -c "export PATH=$PATH:/usr/local/bin:/usr/bin ; make clean"

	echo Running configure...
	"%BASH_EXE%" -c "export PATH=$PATH:/usr/local/bin:/usr/bin ; ./configure --toolchain=msvc --ld=link.exe  --target-os=%TARGET% --disable-iconv --disable-debug"
)

echo Running make...
"%BASH_EXE%" -c "export PATH=$PATH:/usr/local/bin:/usr/bin ; make openhevc-shared"

:docopy
echo Copying libs...
copy libopenhevc\openhevc.lib %DEST%
copy libopenhevc\openhevc-1.dll %DEST%

echo All done. Run CopyLibs2Public.bat
goto done


:git_not_found
echo git not found
goto done


:MissingParameters
echo "Specify argument x86 or x64. 2nd argument can be path to vcvarsall.bat"

:done
cd /d %OLDDIR%
