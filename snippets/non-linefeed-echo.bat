@echo off
rem -*- coding: utf-8 -*-

rem https://qiita.com/koryuohproject/items/f53ace4bcd3bf0b261be
rem "改行しないエコー
rem

rem set ERRORLEVEL=0
echo hello %ERRORLEVEL%
set /p x=ABC<NUL
echo %ERRORLEVEL%
set ERRORLEVEL=0
echo %ERRORLEVEL%
rem 入力リダイレクト前にスペースを入れると、スペースも出力される
set /p x=DEF <NUL
rem 入力リダイレクト前にスペースを入れないと、変数展開できない
set /p x=UVW %ERRORLEVEL% <NUL
echo XYZ %ERRORLEVEL%
