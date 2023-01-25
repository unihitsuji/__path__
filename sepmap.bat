@echo off
rem -*- coding: cp932 -*-
rem setlocal EnableDelayedExpansion
setlocal

goto main
:help
  echo;
  echo 説明
  echo   セミコロン区切りで分割 (sep) して、要素を順次処理 (map) する
  echo;
  echo 使用法
  echo;
  echo   ^$ sepmap delim str [command]
  echo;
  echo       delim    区切り文字
  echo       str:     区切り文字で区切られた文字列
  echo       command: 要素を処理するコマンド文字列 
  echo;
  echo 使用例
  echo   ^$ sepmap ";" "%%PATH%%"
  echo   =^>  C:\WINDOWS\system32
  echo   =^>  C:\WINDOWS
  echo   =^>  ...
  echo;
  echo その他の使用例
  echo   ^$ sepmap ";" "%%CLASSPATH%%" "dir /s /b"
  exit /b 0

:main
  if "%~1" == "-h" (
    goto help
  ) else if "%~3" == "" (
    call :sepmap "%~1" "%~2" "call :no_quote_echo"
  ) else (
    call :sepmap "%~1" "%~2" "%~2"
  )
  exit /b

rem 説明
rem   デフォルトで使用するコマンド。引数を echo するだけ。
:no_quote_echo
  echo %~1
  exit /b 0

rem 説明
rem   文字列を区切り文字で2分割する. behead は斬首の意.
rem 使用法
rem   call :behead delim string head_var_name rest_var_name
rem     delim: 区切り文字
rem     string: 区切りたい文字列
rem     head_var_name: 最初の要素を格納する環境変数*名*
rem     rest_var_name: 残りの要素を格納する環境変数*名*
rem 使用例
rem   call :behead ";" "AAA;B is B;C" head rest
rem   echo %head% %rest%
rem   => AAA B is B;C
:behead
  for /F "tokens=1* delims=%~1" %%i in ("%~2") do (
    set "%3=%%i"
    set "%4=%%j"
  )
  exit /b 0

rem 説明
rem   文字列を区切り文字によって区切られたリストに見立て、
rem   Lisp, Scheme, その他の map 関数のように、要素順にコマンドで処理する
rem 注意
rem   上記 :behead コマンドを使用している
rem 使用法
rem   call :sepmap 区切り文字 リスト文字列 要素文字列を処理したいコマンド
rem 使用例
rem   call :sepmap ";" "AAA;B is B;C" "call :pp"
:sepmap
  set "tmp_rest=%~2"
  :sepmap_loop
    if "%tmp_rest%" == "" exit /b 0
    call :behead "%~1" "%tmp_rest%" tmp_head tmp_rest
    %~3 "%tmp_head%"
    if ERRORLEVEL 1 exit /b 1
    goto :sepmap_loop
  exit /b 0
