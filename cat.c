/* -*- coding: utf-8 -*- */
/**
   説明
     cat のパチモン
   使用法
     $ cat [-n] [ファイル名 ...]
     ファイル名: "-" は標準入力を意味する。指定が全くないときは標準入力を入力とする。
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

size_t line = 0;
bool line_disp = false;

void cat(FILE *fp) {
  int c;
  bool head = true;
  for ( ; (c = fgetc(fp)) != EOF; ) {
    if (head == true) {
      head = false;
      line++;
      if (line_disp == true) printf("%5d: ", (int)line);
    }
    fputc(c, stdout);
    if (c == '\n') head = true;
  }
}

int count(int argc, char **argv) {
  int i, sum = 0;
  for ( i = 0; i < argc; i++ ) {
    if (argv[i] != NULL) sum++;
  }
  return sum;
}

int main (int argc, char **argv) {
  size_t i;
  char **args;
  FILE *fp;
  /* 引数をコピー */
  args = (char **)malloc(argc * sizeof(char *));
  for (i = 0; i < argc; i++) args[i] = argv[i];
  /* オプションチェック */
  for (i = 1; i < argc; i++) {
    if (strcmp(args[i], "-n") == 0) {
      line_disp = true;
      args[i] = NULL;
    }
  }
  /* メイン */
  if (count(argc, args) == 1) {
    cat(stdin);
  } else {
    for ( i = 1; i < argc; i++) {
      if (args[i] == NULL) continue;
      if (strcmp(args[i], "-") == 0) {
        cat(stdin);
      } else {
        fopen_s(&fp, args[i], "r");
        if (fp == NULL) {
          fprintf(stderr, "not found: %sn", args[i]);
          return 1;
        }
        cat(fp);
      }
    }
  }
  return 0;
}
