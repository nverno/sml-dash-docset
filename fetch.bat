@echo off
setlocal EnableExtensions
pushd "%~dp0"

:: Download the SMLNJ manual pages using httrack
set "outdir=%~1"

:check
where /q httrack
if errorlevel == 1 (
    where /q locate.bat || (
        echo ------------------------------------------------------------
        echo. httrack.exe needed to download docs.
        echo. ^> choco install -y httrack
        echo ------------------------------------------------------------
        goto :exit
    )
    call :search httrack httrack.exe
)

:dl
:: download sml-basis manpages from sml-family.org
set "manpages=http://sml-family.org/Basis/manpages.html#section:sec:man-pages"
call "%httrack%" "%manpages%" --path "%outdir%"

goto :exit

:search
:: find httrack.exe if not on path
set "index=%APPDATA%\exe-index"
for /f "tokens=*" %%a in ('locate.bat -f "%index%" -o "/i" "%~2"') do (
    set ^"%1^=%%a"
    goto :EOF
)

:exit
popd &goto :EOF
