@echo off
rem -*- coding: cp932 -*-
setlocal EnableDelayedExpansion
rem setlocal

rem javac のオプション
set options=-encoding utf-8

goto main
:help
  echo;
  echo 説明
  echo   クラス名を指定し %%CLASSPATH%% から予想される .java ファイルを探し、あればコンパイル、なければスルーする.
  echo;
  echo 注意
  echo   say.exe, cat.exe を使用している
  echo;
  echo 使用法
  echo;
  echo   ^$ jc [-h] [class_name ...]
  echo;
  echo       class_name: コンパイルしたい .java ファイルのクラス名
  echo;
  echo 使用例
  echo   ^$ jc
  echo   ^=^= javac と java のバージョンを標準出力に出力して終了
  echo   ^$ jc -h
  echo   ^=^= ヘルプドキュメントを標準出力に出力して終了
  echo   ^$ jc abc.Hello
  echo   ^=^= クラスパス要素\abc\Hello.java を探し、あればコンパイル、なければスルーする
  exit /b 0

:main
  if "%~1" == "-h" goto :help
  javac -version
  java  -version 2>&1 | cat
  for %%i in (%*) do (
    set "cn=%%i"
    set "fn=!cn:.=\!"
    call :sepmap ";" "%CLASSPATH%" "call :jc !fn!.java"
    if ERRORLEVEL 1 (
      echo [jc.bat:main] エラーが発生したので中断します
      exit /b 1
    )
  )
  exit /b 0

:jc
  set filename="%~2\%~1"
  say "%filename% ...... "
  rem set /p "dummy=%filename%" <NUL
  rem set /p "dummy= ......" <NUL
  if exist %filename% (
    call :color-echo 31 found
    javac %options% %filename%
    if ERRORLEVEL 1 (
      echo [jc.bat:jc] コンパイルエラーが発生しました
      exit /b 1
    )
  ) else (
    call :color-echo 37 not found
  )
  exit /b 0

:behead
  for /F "tokens=1* delims=%~1" %%i in ("%~2") do (
    set "%3=%%i"
    set "%4=%%j"
  )
  exit /b 0

:sepmap
  set "tmp_rest=%~2"
  :sepmap_loop
    if "%tmp_rest%" == "" exit /b 0
    call :behead "%~1" "%tmp_rest%" tmp_head tmp_rest
    %~3 "%tmp_head%"
    if ERRORLEVEL 1 exit /b 1
    goto :sepmap_loop
  exit /b 0

:color-echo
  rem ESC 変数のセット
  for /f %%i in ('cmd /k prompt $e^<NUL') do set ESC=%%i
  rem -s オプションの処理
  set cmd=echo
  if "%~1" == "-s" (
    set cmd=say
    shift
  )
  rem 色の設定
  set color=%~1
  shift
  rem 残りの引数を連結する
  if "%~1" == "" goto color-echo-next
  set "text=%~1"
  :color-echo-loop
    shift
    if "%~1" == "" goto color-echo-next
    set "text=%text% %~1"
    goto color-echo-loop
  :color-echo-next
    %cmd% %ESC%[%color%m%text%%ESC%[0m
  exit /b
