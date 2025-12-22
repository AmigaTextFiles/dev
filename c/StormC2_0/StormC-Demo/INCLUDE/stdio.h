#ifndef _INCLUDE_STDIO_H
#define _INCLUDE_STDIO_H

/*
**  $VER: stdio.h 1.01 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif

typedef struct filehandle FILE;
extern FILE std__in, std__out, std__err;

#ifndef NULL
#define NULL 0
#endif

typedef unsigned size_t;

#define stdin (&std__in)
#define stdout (&std__out)
#define stderr (&std__err)

#define EOF (-1)

int getc(FILE *);
int fgetc(FILE *);
int getchar (void);
int ungetc(int, FILE *);

char *fgets(char *, int, FILE *);
char *gets(char *);

int fputc(int, FILE *);
int putc(int, FILE *);
int putchar(int);
int fputs(const char *, FILE *);
int puts(const char *);
void perror(const char *);

#define FILENAME_MAX 126
#define FOPEN_MAX (unsigned int) -1
FILE *fopen(const char *, const char *);
FILE *freopen(const char *, const char *, FILE *);
int fclose(FILE *);
int feof(FILE *);
int ferror(FILE *);
void clearerr(FILE *);

#define _IOFBF 1
#define _IOLBF (-1)
#define _IONBF 0
#define BUFSIZ 2048
int setvbuf(FILE *, char *, int, unsigned int);
void setbuf(FILE *, char *);
int fflush(FILE *);

int printf(const char *, ...);
int fprintf(FILE *, const char *, ...);
int sprintf(char *, const char *, ...);

typedef unsigned va_list;
int vprintf(const char *, va_list);
int vfprintf(FILE *, const char *, va_list);
int vsprintf(char *, const char *, va_list);

int scanf(const char *, ...);
int fscanf(FILE *, const char *, ...);
int sscanf(const char *, const char *, ...);

int remove(const char *);
int rename(const char *, const char *);

#define L_tmpnam 40
#define TMP_MAX ((unsigned int) -1)
char *tmpnam (char *);
FILE *tmpfile (void);

size_t fread(void *, size_t, size_t, FILE *);
size_t fwrite(const void *, size_t, size_t, FILE *);

#define SEEK_CUR 0
#define SEEK_END 1
#define SEEK_SET (-1)
typedef int fpos_t;
int fseek(FILE *, long, int);
long ftell(FILE *);
void rewind(FILE *);
int fgetpos(FILE *, int *);
int fsetpos(FILE *, const int *);

void exit(int);

#ifdef __cplusplus
}
#endif

#endif
