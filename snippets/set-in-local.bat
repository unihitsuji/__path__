@echo off

setlocal

set VAR_IN_BAT=YES
echo --------------------------- in  bat
set | findstr VAR_IN_BAT

endlocal

echo --------------------------- out bat
set | findstr VAR_IN_BAT
