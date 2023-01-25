@echo off
rem -*- coding: cp932 -*-
setlocal EnableDelayedExpansion

rem javadoc �R�}���h�̃I�v�V����
set javadoc_opts=-encoding utf-8
rem javadoc �̏o�͐�
set javadoc_dir=%USERPROFILE%\javadoc

for %%i in (%*) do (
  rmdir /s /q %javadoc_dir%\%%i
  javadoc %javadoc_opts% -d %javadoc_dir%\%%i -cp %CLASSPATH% %%i
)
