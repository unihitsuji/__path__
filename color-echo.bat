@echo off
rem -*- coding: cp932 -*-
setlocal EnableDelayedExpansion
rem setlocal

goto main
:help
  echo;
  echo 概要
  echo   色付きで文字列を標準出力に出力する
  call :usage
  echo;
  echo 注意
  echo   改行なしの出力 [-s] に say.exe say.c を使用している
  call :example
  exit /b 0

:usage
  echo;
  echo 使用法
  echo;
  echo   ^$ color-echo [-h^|-hu^|-hx] [-s] 色 テキスト
  echo;
  echo     色 30: 黒, 31: 赤, 32: 緑, 33: 黄, 34: 青, 37: 白
  exit /b

:example
  echo;
  echo 使用例
  echo   ^$ color-echo -h
  echo   ^=^= 全てのヘルプドキュメント
  echo   ^$ color-echo -hx
  echo   ^=^= 使用例ドキュメントのみ
  echo   ^$ color-echo 31 "Hello, world"
  say "  => "
  call :color-echo 31 "Hello, world"
  echo   ^$ color-echo -s 32 "Hello, world" ^& echo and human
  say "  => "
  call :color-echo -s 32 "Hello, world" & echo and human
  echo   ^$ color-echo -s 33 "Hello, world " ^& echo and human
  say "  => "
  call :color-echo -s 33 "Hello, world " & echo and human
  exit /b 0

:main
  if "%~1" == "-h"  goto help
  if "%~1" == "-hu" goto usage
  if "%~1" == "-hx" goto example
  call :color-echo %*
  rem call :color-echo red          "Hello,     world" and     human
  rem call :color-echo "light blue" "Hello,     world" and     human
  exit /b

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
