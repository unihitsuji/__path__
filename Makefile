TARGET = pwd.exe cat.exe argv.exe say.exe
OBJS = pwd.obj cat.obj argv.obj say.obj

all: $(TARGET)

clean:
	del $(TARGET)
	del $(OBJS)

pwd.exe: pwd.c
	cl /utf-8 /W3 pwd.c

cat.exe: cat.c
	cl /utf-8 /W3 cat.c

argv.exe: argv.c
	cl /utf-8 /W3 argv.c

say.exe: say.c
	cl /utf-8 /W3 say.c
