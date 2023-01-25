@echo off
chcp 65001

rem "30 黒"
rem "31 赤"
rem "32 緑"
rem "33 暗めの黄色"
rem "34 青"
rem "35 紫"
rem "36 暗めの水色"
rem "37 白"
rem "38 RGB指定できる 38;2;R;G;Bm"

set PROMPT=$E[m$E[32m$E]9;8;"USERNAME"$E\@$E]9;8;"COMPUTERNAME"$E\$S$E[92m$P$E[90m$_$E[90m$$$E[m$S$E]9;12$E\

rem set prompt=$e[36m$D$S$T$S$P$e[m$_$$$S
