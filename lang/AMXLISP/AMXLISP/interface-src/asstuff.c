/* asstuff.c - Amiga specific routines */

#include "xlisp.h"

#ifndef MANX
#define agetc getc   /* Not sure if this will work in all cases (fnf) */
#define aputc putc   /* Not sure if this will work in all cases (fnf) */
#endif

#define LBSIZE 200

/* external routines */
extern double ran();

/* external variables */
extern LVAL s_unbound,true;
extern int prompt;
extern int errno;

/* line buffer variables */
static char lbuf[LBSIZE];
static int  lpos[LBSIZE];
static int lindex;
static int lcount;
static int lposition;

#define NEW 1006
static long xlispwindow;
extern FILE *tfp;

/* osinit - initialize */
osinit(banner)
  char *banner;
{
/* rouaix    extern int Enable_Abort;  */

/*    Enable_Abort = 0;     Turn off ^C interrupt in case it's on */
    xlispwindow = Open("RAW:1/1/639/199/Xlisp by David Betz", NEW);
    while (*banner != '\000') {
   xputc (*banner++);
    }
    xputc ('\n');
    lposition = 0;
    lindex = 0;
    lcount = 0;
}

osfinish ()
{
    Close (xlispwindow);
}

/* osrand - return a random number between 0 and n-1 */
int osrand(n)
  int n;
{
    n = (int)(ran() * (double)n);
    return (n < 0 ? -n : n);
}



/* oscheck - check for control characters during execution */
oscheck()
{
    int ch;
    if (ch = xcheck())
   switch (ch) {
   case '\002':   osflush(); xlbreak("BREAK",s_unbound); break;
   case '\004':   osflush(); xltoplevel(); break;
   }
}

/* osflush - flush the input line buffer */
osflush()
{
    lindex = lcount = 0;
}

/* xgetc - get a character from the terminal without echo */
static int xgetc()
{
    char ch;

    Read (xlispwindow, &ch, 1);
    return (ch & 0xFF);
}

/* xputc - put a character to the terminal */
static xputc(ch)
  int ch;
{
    char chout;

    chout = ch;
    Write (xlispwindow, &chout, 1L);
}

/* xcheck - check for a character */
static int xcheck()
{
    if (WaitForChar (xlispwindow, 0L) == 0L)
   return (0);
    return (xgetc() & 0xFF);
}



double ran ()   /* Just punt for now, not in Manx C; FIXME!!*/
{
   static long seed = 654321;
   long lval;
   double dval;

   seed *= ((8 * (123456) - 3));
   lval = seed & 0xFFFF;
   dval = ((double) lval) / ((double) (0x10000));
   return (dval);
}







/* ADDED FOR V2.0 */
/* osclose - close a file */
int osclose(fp)
  FILE *fp;
{
    return (fclose(fp));
}

/* ostputc - put a character to the terminal */
ostputc(ch)
  int ch;
{
    /* check for control characters */
    oscheck();

    /* output the character */
    if (ch == '\n') {
   xputc('\r'); xputc('\n');
   lposition = 0;
    }
    else {
   xputc(ch);
   lposition++;
   }

   /* output the character to the transcript file */
   if (tfp)
   osaputc(ch,tfp);
}
/* ostgetc - get a character from the terminal */
int ostgetc()
{
    int ch;

    /* check for a buffered character */
    if (lcount--)
   return (lbuf[lindex++]);

    /* get an input line */
    for (lcount = 0; ; )
   switch (ch = xgetc()) {
   case '\r':
      lbuf[lcount++] = '\n';
      xputc('\r'); xputc('\n'); lposition = 0;
      if (tfp)
          for (lindex = 0; lindex < lcount; ++lindex)
         osaputc(lbuf[lindex],tfp);
      lindex = 0; lcount--;
      return (lbuf[lindex++]);
   case '\010':
   case '\177':
      if (lcount) {
          lcount--;
          while (lposition > lpos[lcount]) {
         xputc('\010'); xputc(' '); xputc('\010');
         lposition--;
          }
      }
      break;
   case '\032':
      xflush();
      return (EOF);
   default:
      if (ch == '\t' || (ch >= 0x20 && ch < 0x7F)) {
          lbuf[lcount] = ch;
          lpos[lcount] = lposition;
          if (ch == '\t')
         do {
             xputc(' ');
         } while (++lposition & 7);
          else {
         xputc(ch); lposition++;
          }
          lcount++;
      }
      else {
          xflush();
          switch (ch) {
          case '\003':   xltoplevel();   /* control-c */
          case '\007':   xlcleanup();   /* control-g */
          case '\020':   xlcontinue();   /* control-p */
          case '\032':   return (EOF);   /* control-z */
          default:      return (ch);
          }
      }
   }
}
/* xflush - flush the input line buffer */
static xflush()
{
    ostputc('\n');
    osflush();
}

/* osaopen - open an ascii file */
FILE *osaopen(name,mode)
  char *name,*mode;
{
    return (fopen(name,mode));
}
/* oserror - print an error message */
oserror(msg)
  char *msg;
{
    printf("error: %s\n",msg);
}

/* xsystem - the built-in function 'system' */
LVAL xsystem()
{
    char *str;
    int result;

    /* get the command string */
    str = getstring(xlgastring());
    xllastarg();
    result = Execute(str,0L,xlispwindow);
    return (cvfixnum((FIXTYPE)result));
}

/* osagetc - get a character from an ascii file */
int osagetc(fp)
  FILE *fp;
{
    return (getc(fp));
}
/* osaputc - put a character to an ascii file */
int osaputc(ch,fp)
  int ch; FILE *fp;
{
    return (putc(ch,fp));
}
/* ossymbols - lookup important symbols */
ossymbols()
{
}

