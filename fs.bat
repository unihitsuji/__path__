@echo off
rem -*- coding: cp932 -*-
setlocal

set file=%USERPROFILE%\findstr.txt
if "%1"=="-e" (
  vim %file%
) else (
  findstr /sg:%file%
)
endlocal
