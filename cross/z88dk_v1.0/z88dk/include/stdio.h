#ifndef STDIO_H
#define STDIO_H


#define NULL 0
#define EOF (-1)
#define FILE int

/*
 * Is 128 characters enough for a filename + path?
 * Comments please
 */
#define FILENAME_MAX 128

/*
 * Now stuff for stdin/out/err this block is in z88_crt0.asm
 */

extern  FILE  *sgoioblk[3];

#define stdin  (sgoioblk[0])
#define stdout (sgoioblk[1])
#define sdderr (sgoioblk[2])



/* Our kludgy prototypes */

/* HDRPRTYPE is a rather kludgey way to indicate to the compiler that these
 * functions are to be found in the library and not in other modules
 */

#pragma proto HDRPRTYPE


extern FILE *fopen(char *, char *);
extern int fclose(FILE *);
extern char *fgets(char *, int, FILE *);
extern fputc(unsigned char, FILE *);
extern char fgetc(FILE *);
extern char getc(void);
extern fputs(char *, FILE *);
extern feof(FILE *);
extern long ftell(FILE *);
extern int fgetpos(FILE *,long *);

/* putc is a macro, try this method! 

#define putc(bp) fputc(bp,stdout)

*/

/* gets is a macro, this may change in the future!! */

#define gets(s,n) fgets(s,n,stdin)

/* slightly more streamline putc now! */

#define putc(c) putchar(c)




extern printf(char *,...);
extern fprintf(FILE *,char *,...);
extern sprintf(char *,char *,...);

extern scanf(char *,...);
extern fscanf(FILE *, char *,...);
extern sscanf(char *, char *,...);


extern int remove(char *);
extern int rename(char *, char *);



/* Keyboard operations */

extern char getk(void);
extern char getkey(void);

/* Screen operations */

extern putchar(char);
extern putn(int);
extern puts(char *);
extern settxy(int, int);

/*
 * These functions are used for printf etc - don't use them yourself!
 */

extern int getarg(void);
extern int printf1();
extern int scanf1();

#pragma unproto HDRPRTYPE 

#endif

