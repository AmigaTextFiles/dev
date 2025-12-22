#ifndef STDIO_H
#define STDIO_H

struct __FILE
{
  long file; /* long = BPTR */
  int error; /* Fehlerwert */
  int uc;    /* ungetc pending */
};

#define EOF (-1)

typedef struct __FILE FILE;

extern FILE *fopen(const char *filename,const char *mode);
extern int fclose(FILE *stream);
extern int fgetc(FILE *stream);
extern int fputc(int c,FILE *stream);
extern int ungetc(int c,FILE *stream);

#endif
