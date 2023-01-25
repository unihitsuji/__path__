@echo off
rem -*- coding: cp932 -*-
setlocal EnableDelayedExpansion

rem 概要
rem   クラスパス内の .class ファイルを全て削除する
rem 使用法
rem   jd [classpath ...]
rem     classpath
:main
  if "%1"=="" (
    call :sepmap ";" "%CLASSPATH%" "call :del_class"
  ) else (
    for %%i in ("%*") do (
      del /s "%%i\*.class"
    )
  )
  exit /b

:del_class
  del /s "%~1\*.class"
  exit /b

:behead
  for /F "tokens=1* delims=%~1" %%i in (%2) do (
    set %3="%%i"
    set %4="%%j"
  )
  exit /b

:sepmap
  set tmp_rest=%2
:sepmap_loop
  if %tmp_rest%=="" goto :sepmap_end
  call :behead %1 %tmp_rest% tmp_head tmp_rest
  %~3 %tmp_head%
  goto :sepmap_loop
:sepmap_end
  exit /b
