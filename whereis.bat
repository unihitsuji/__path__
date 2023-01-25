@echo off
rem -*- coding: cp932 -*-

rem http://sgry.jp/pgarticles/batch.html

rem chcp 932
setlocal

for %%i in (%*) do (
  echo %%~$PATH:i
)
