/* -*- coding: utf-8 -*- */
#include <stdio.h>

/**
   説明
     改行しない echo
*/
int main (int argc, char **argv) {
  size_t i;
  for ( i = 1; i < argc ; i++ ) {
    if ( i == 1 ) {
      printf("%s", argv[i]);
    } else {
      printf(" %s", argv[i]);
    }
  }
  return 0;
}
