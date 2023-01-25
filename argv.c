/* -*- coding: utf-8 -*- */
/* for Microsoft C Compiler
  $ cl /utf-8 /W3 argv.c
  warning C5045 が出るけど気にすんな
 */
#include <stdio.h>

int main (int argc, char **argv) {
  int i;
  for (i = 0; i < argc ; i++) {
    printf("%2d: %s\n", i, argv[i]);
  }
}
