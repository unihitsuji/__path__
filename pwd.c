/*  -*- coding: utf-8 -*- */
/*  for Windows and Microsoft C Compiler *ONLY*
    概要
        カレントワーキングディレクトリを表示する pwd の発展版
    注意
        一般の pwd コマンドにある -P, -L オプションはない
    コンパイル方法
        $ cl /utf-8 /W3 pwd.c
    使用方法
        $ pwd -h
 */
#include <stdio.h>    //  printf fopen
#include <stdbool.h>  //  bool
#include <stdlib.h>   //  malloc perror
#include <string.h>   //  strlen strcpy_s strcat_s
#include <direct.h>   //  _getcwd _chdir
#include <sys/stat.h> //  stat
#include <process.h>  //  _spwnvp system
#include <errno.h>
#define PATH_SIZE 1024  //  可変だが、足りなきゃ進まないようにしてある
#define BUF_SIZE    64  //  不変で足りてる
#define START "start"
#define SHELL "notepad"

/*
  引数 path が示す文字列の最初のディレクトリ区切り文字を含む長さを返す
  例 "C:\\" -> 3, "/" -> 1
 */
size_t path_min(const char *path) {
  size_t i;
  size_t len = strlen(path);
  for (i = 0; i < len; i++) {
    if (path[i] == '/' || path[i] == '\\') break;
  }
  return i + 1;
}
/*
  引数 path が示すディレクトリ名の一番後ろのディレクトリ区切り文字を "\0" にして
  path の親ディレクトリを得る。path の中身が変更されることに注意せよ。
 */
void path_cut(char *path) {
  size_t i;
  size_t len = strlen(path);
  size_t min = path_min(path);
  for (i = len ; i > min ; i--) {
    if (path[i] == '/' || path[i] == '\\') break;
  }
  path[i] = '\0';
}
/*
  引数 path が示すディレクトリで file ファイルの有無を調べる
  file ファイルがある true
  file ファイルがない false
  注意
    errno = 0 している
 */
bool is_file(const char *delim, const char *file, const char *path) {
  FILE *fp;
  bool ret = false;
  size_t len = strlen(path) + strlen(delim) + strlen(file) + 1;
  char *buf = (char *)malloc(sizeof(char) * len);
  if (buf == NULL) {
    fprintf(stderr, "malloc error in is_file");
    return false;
  }
  strcpy_s(buf, len, path);
  strcat_s(buf, len, delim);
  strcat_s(buf, len, file);
  if (fopen_s(&fp, buf, "r") == 0) { //  ファイル有り
    ret = true;
    fclose(fp);
  }
  errno = 0;
  free(buf);
  return ret;
}
/*
  引数 path が示すディレクトリで dir ディレクトリの有無を調べる
  dir ディレクトリがある true
  dir ディレクトリがない false
  注意
    errno = 0 している
 */
bool is_dir(const char *delim, const char *dir, const char *path) {
  struct stat sbuf;
  bool ret = false;
  size_t len = strlen(path) + strlen(delim) + strlen(dir) + 1;
  char *buf = (char *)malloc(sizeof(char) * len);
  if (buf == NULL) {
    fprintf(stderr, "malloc error in is_dir");
    return false;
  }
  strcpy_s(buf, len, path);
  strcat_s(buf, len, delim);
  strcat_s(buf, len, dir);
  if (stat(buf, &sbuf) == 0) ret = true; //  ディレクトリ有り
  errno = 0;
  free(buf);
  return ret;
}
/*
 */
bool is_exist(const char *delim, const char *file, const char *path) {
  if (is_file(delim, file, path) || is_dir(delim, file, path)) return true;
  return false;
}
/*
  コマンドラインオプションを判別するのに使う
 */
bool is_option(const char *arg, const char *str1, const char *str2) {
  if (strcmp(arg, str1) == 0 || strcmp(arg, str2) == 0) return true;
  return false;
}
/*
  _spawnvp のラッパー
  別ウィンドウでコマンドプロンプトを起動するときは
  const char *args[] = { "cmd.exe", "/C", "start", "cmd.exe", NULL);
  spawn(args);
 */
void spawn(const char **args) {
  int saved_errno = errno;
  _spawnvp( _P_NOWAIT, args[0], args );
  if (errno != 0) {
    fprintf(stderr, "errno E2BIG = %d, EINVAL = %d, ENOENT = %d, ENOEXEC = %d, ENOMEM = %d\n",
            E2BIG, EINVAL, ENOENT, ENOEXEC, ENOMEM );
    fprintf(stderr, "errno %d before _spawnvp\n", saved_errno );
    fprintf(stderr, "errno %d after  _spawnvp\n", errno );
  }
}
int main (int argc, char **argv) {
  char path[PATH_SIZE], build_buf[BUF_SIZE];
  size_t i, len;
  int chk;
  bool quiet = false;
  const char *delim = "\\";
  const char *dir   = ".git";
  const char *file  = ".git\\config";
  const char *source  = "pwd.c";
  const char *spawn_args[] = { "cmd.exe", "/C start cmd.exe", NULL };
  const char *make_args[]  = { "cmd.exe", "/C start cmd.exe /K \"pause && nmake\"", NULL };
  char *buf = _getcwd(path, PATH_SIZE);
  if (buf == NULL) {
    fprintf(stderr, "_getcwd error or too large ( > %d ) length\n", PATH_SIZE);
    return 1;
  }
  sprintf_s(build_buf, BUF_SIZE, "/C start cmd.exe /K \"pause && cl /utf-8 /W3 %s\"", source);
  const char *build_args[3] = { "cmd.exe", build_buf, NULL };
  if (argc > 1) {
    for (i = 1; i < (size_t)argc ; i++) {
      if (is_option(argv[i], "-q", "--quiet") == true) {
        quiet = true;
      } else if (is_option(argv[i], "-p", "--parent") == true) {
        //  親ディレクトリ
        path_cut(buf);
      } else if (is_option(argv[i], "-f", "--file") == true) {
        //  特定ファイル
        for ( ; is_exist(delim, argv[i + 1], buf) == false ; ) {
          len = strlen(buf);
          path_cut(buf);
          if (len == strlen(buf)) {
            fprintf(stderr, "not found %s\n", file);
            return 1;
          }
        }
        i++;
      } else if (is_option(argv[i], "-g", "--git") == true) {
        //  .git ディレクトリ
        for ( ; is_dir(delim, dir, buf) == false ; ) {
          len = strlen(buf);
          path_cut(buf);
          if (len == strlen(buf)) {
            fprintf(stderr, "not found %s\n", dir);
            return 1;
          }
        }
      } else if (is_option(argv[i], "-c", "--config") == true) {
        //  .git\config ファイル
        for ( ; is_file(delim, file, buf) == false ; ) {
          len = strlen(buf);
          path_cut(buf);
          if (len == strlen(buf)) {
            fprintf(stderr, "not found %s\n", file);
            return 1;
          }
        }
      } else if (is_option(argv[i], "-m", "--make") == true) {
        // Makefile のあるディレクトリ
        for ( ; is_file(delim, "Makefile", buf) == false ; ) {
          len = strlen(buf);
          path_cut(buf);
          if (len == strlen(buf)) {
            fprintf(stderr, "not found Makefile\n");
            return 1;
          }
        }
        chk = _chdir(buf);
        if (chk != 0) { /* error */
          fprintf(stderr, "errno %d: _chdir(\"%s\")\n", errno, buf);
          return 1;
        }
        // system だと pwd.exe がファイルロックされているから spawn
        // spawn だけでも十分なはずだが念のため make_args 内で pause している
        spawn(make_args);
      } else if (is_option(argv[i], "-b", "--build") == true) {
        // 本コードのあるディレクトリ
        for ( ; is_file(delim, source, buf) == false ; ) {
          len = strlen(buf);
          path_cut(buf);
          if (len == strlen(buf)) {
            fprintf(stderr, "not found %s\n", source);
            return 1;
          }
        }
        chk = _chdir(buf);
        if (chk != 0) { /* error */
          fprintf(stderr, "errno %d: _chdir(\"%s\")\n", errno, buf);
          return 1;
        }
        // system だと pwd.exe がファイルロックされているから spawn
        // spawn だけでも十分なはずだが念のため build_args 内で pause している
        spawn(build_args);
      } else if (is_option(argv[i], "-s", "--spawn") == true) {
        // spawn する
        chk = _chdir(buf);
        if (chk != 0) { /* error */
          fprintf(stderr, "errno %d: _chdir(\"%s\")\n", errno, buf);
          return 1;
        }
        spawn(spawn_args);
      } else if (is_option(argv[i], "-x", "--exec") == true) {
        // system する
        chk = _chdir(buf);
        if (chk != 0) { /* error */
          fprintf(stderr, "errno %d: _chdir(\"%s\")\n", errno, buf);
          return 1;
        }
        if (strcmp(argv[i + 1], "") != 0) {
          system(argv[i + 1]);
          i++;
        }
      } else if (is_option(argv[i], "-h", "--help") == true) {
        printf("SYNOPSIS:\n");
        printf("  PWD and more\n");
        printf("\n");
        printf("USAGE:\n");
        printf("  pwd [-h] [-qpgcmbs] ... [-f FILE] ... [-x CMD] ...\n");
        printf("\n");
        printf("OPTIONS\n");
        printf("  -h, --help:      this help\n");
        printf("  -q, --quiet:     quiet, suppress output\n");
        printf("  -p, --parent:    parent directory\n");
        printf("  -g, --git:       search %s directory\n", dir);
        printf("  -c, --config:    search %s file\n", file);
        printf("  -m, --make:      search Makefile and nmake\n");
        printf("  -b, --build:     search %s source and compile and link it\n", source);
        printf("  -s, --spawn:     open command prompt in another window\n");
        printf("  -f, --file FILE: search specified file or directory FILE\n");
        printf("  -x, --exec CMD:  execute specified command CMD\n");
        printf("\n");
        printf("EXAMPLES\n");
        printf("\n");
        printf("  ### In C:\\your\\current\\directory\\here\n");
        printf("  $ pwd -p -p -p\n");
        printf("  #=> C:\\your\n");
        printf("\n");
        printf("  ### In C:\\your\\current\\.git exists\n");
        printf("  $pwd -g -s\n");
        printf("  #== Open command prompt in C:\\your\\current and ...\n");
        printf("  #=> C:\\your\\current\n");
        printf("\n");
        printf("  $ pwd -p -x dir\n");
        printf("  #== Execute command dir in C:\\your\\current\\directory and ...\n");
        printf("  #=> C:\\your\\current\\directory\n");
        return 0;
      } else {
        // unknown option
        fprintf(stderr, "unknown option: %s\n", argv[i]);
        return 1;
      }
    }
  }
  if (quiet == false) printf("%s\n", buf);
  return 0;
}
