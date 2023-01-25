@echo off
rem -*- coding: cp932 -*-
rem setlocal EnableDelayedExpansion
setlocal

goto main
:help
  echo;
  echo ����
  echo   �Z�~�R������؂�ŕ��� (sep) ���āA�v�f���������� (map) ����
  echo;
  echo �g�p�@
  echo;
  echo   ^$ sepmap delim str [command]
  echo;
  echo       delim    ��؂蕶��
  echo       str:     ��؂蕶���ŋ�؂�ꂽ������
  echo       command: �v�f����������R�}���h������ 
  echo;
  echo �g�p��
  echo   ^$ sepmap ";" "%%PATH%%"
  echo   =^>  C:\WINDOWS\system32
  echo   =^>  C:\WINDOWS
  echo   =^>  ...
  echo;
  echo ���̑��̎g�p��
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

rem ����
rem   �f�t�H���g�Ŏg�p����R�}���h�B������ echo ���邾���B
:no_quote_echo
  echo %~1
  exit /b 0

rem ����
rem   ���������؂蕶����2��������. behead �͎a��̈�.
rem �g�p�@
rem   call :behead delim string head_var_name rest_var_name
rem     delim: ��؂蕶��
rem     string: ��؂肽��������
rem     head_var_name: �ŏ��̗v�f���i�[������ϐ�*��*
rem     rest_var_name: �c��̗v�f���i�[������ϐ�*��*
rem �g�p��
rem   call :behead ";" "AAA;B is B;C" head rest
rem   echo %head% %rest%
rem   => AAA B is B;C
:behead
  for /F "tokens=1* delims=%~1" %%i in ("%~2") do (
    set "%3=%%i"
    set "%4=%%j"
  )
  exit /b 0

rem ����
rem   ���������؂蕶���ɂ���ċ�؂�ꂽ���X�g�Ɍ����āA
rem   Lisp, Scheme, ���̑��� map �֐��̂悤�ɁA�v�f���ɃR�}���h�ŏ�������
rem ����
rem   ��L :behead �R�}���h���g�p���Ă���
rem �g�p�@
rem   call :sepmap ��؂蕶�� ���X�g������ �v�f������������������R�}���h
rem �g�p��
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
