@echo off
rem -*- coding: cp932 -*-
setlocal EnableDelayedExpansion
rem setlocal

goto main
:help
  echo;
  echo �T�v
  echo   �F�t���ŕ������W���o�͂ɏo�͂���
  call :usage
  echo;
  echo ����
  echo   ���s�Ȃ��̏o�� [-s] �� say.exe say.c ���g�p���Ă���
  call :example
  exit /b 0

:usage
  echo;
  echo �g�p�@
  echo;
  echo   ^$ color-echo [-h^|-hu^|-hx] [-s] �F �e�L�X�g
  echo;
  echo     �F 30: ��, 31: ��, 32: ��, 33: ��, 34: ��, 37: ��
  exit /b

:example
  echo;
  echo �g�p��
  echo   ^$ color-echo -h
  echo   ^=^= �S�Ẵw���v�h�L�������g
  echo   ^$ color-echo -hx
  echo   ^=^= �g�p��h�L�������g�̂�
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
  rem ESC �ϐ��̃Z�b�g
  for /f %%i in ('cmd /k prompt $e^<NUL') do set ESC=%%i
  rem -s �I�v�V�����̏���
  set cmd=echo
  if "%~1" == "-s" (
    set cmd=say
    shift
  )
  rem �F�̐ݒ�
  set color=%~1
  shift
  rem �c��̈�����A������
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
