@echo off
rem -*- coding: cp932 -*-
setlocal EnableDelayedExpansion
rem setlocal

rem javac �̃I�v�V����
set options=-encoding utf-8

goto main
:help
  echo;
  echo ����
  echo   �N���X�����w�肵 %%CLASSPATH%% ����\�z����� .java �t�@�C����T���A����΃R���p�C���A�Ȃ���΃X���[����.
  echo;
  echo ����
  echo   say.exe, cat.exe ���g�p���Ă���
  echo;
  echo �g�p�@
  echo;
  echo   ^$ jc [-h] [class_name ...]
  echo;
  echo       class_name: �R���p�C�������� .java �t�@�C���̃N���X��
  echo;
  echo �g�p��
  echo   ^$ jc
  echo   ^=^= javac �� java �̃o�[�W������W���o�͂ɏo�͂��ďI��
  echo   ^$ jc -h
  echo   ^=^= �w���v�h�L�������g��W���o�͂ɏo�͂��ďI��
  echo   ^$ jc abc.Hello
  echo   ^=^= �N���X�p�X�v�f\abc\Hello.java ��T���A����΃R���p�C���A�Ȃ���΃X���[����
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
      echo [jc.bat:main] �G���[�����������̂Œ��f���܂�
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
      echo [jc.bat:jc] �R���p�C���G���[���������܂���
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
