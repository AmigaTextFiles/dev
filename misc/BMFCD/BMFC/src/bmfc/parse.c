/**************************************/
/* parse.c                            */
/* for BMFC 0.00                      */
/* Copyright 1992 by Adam M. Costello */
/**************************************/


#include <limits.h>

#if UCHAR_MAX != 255
#error ---------------------------------------
#error Danger!  Danger!  UCHAR_MAX is not 255!
#error ---------------------------------------
#endif

#include "parse.h"  /* Makes sure we're consistent with the */
                    /* prototypes.  Also includes <stdio.h> */
#include "error.h"
#include <ctype.h>


static FILE *f = NULL;

static unsigned long line, pos;

static unsigned char *word = NULL, *wordend = NULL, *wordlimit = NULL;

static int wordsize = 128, chr, prevchr, escaped;

static const char

  /* Error messages: */

  *const endwithescape = "Input file ends with an escape.\n",
  *const endinsidecom  = "Input file ends inside a comment.\n",
  *const endnobegin    = "end-comment with no matching begin-comment.\n";

static unsigned char digvaltable[UCHAR_MAX + 1];


#define isEOF(c)       ((c) == EOF)
#define isnewline(c)   ((c) == '\n')
#define isescape(c)    ((c) == '\\')
#define isbegincom(c)  ((c) == '{')
#define isendcom(c)    ((c) == '}')
#define isinstrsep(c)  ((c) == ';')
#define isblank(c)     isspace(c)


static void verynextchr(void)  /* Reads next character, taking */
{                              /* care of line and pos.        */
  int prevchr;

  prevchr = chr;
  chr = fgetc(f);

  if (!isEOF(chr)) {
    if (isnewline(prevchr)) {
      ++line;
      pos = 1;
    } else ++pos;
  }
}


static void skipcomment(void);


static void nextchr(void)  /* Reads the next character, skipping comments,  */
{                          /* taking care of escapes by setting the escaped */
  verynextchr();           /* flag and reading another character.           */

  while (isbegincom(chr)) skipcomment();

  if (isescape(chr)) {
    verynextchr();
    escaped = 1;
    if (isEOF(chr)) parsefailf(endwithescape);
  } else escaped = 0;
}


static void skipcomment(void)  /* Reads up to the character following */
{                              /* the next unmatched end-comment.     */
  do {
    nextchr();
    if (isEOF(chr)) parsefailf(endinsidecom);
  } while (escaped || !isendcom(chr));

  verynextchr();
}
                    

static void nextvisiblechr(void)
  /* Calls nextchr() and checks for end-comment. After calling           */
  /* nextvisiblechr(), chr cannot be an escape or begin- or end-comment. */
{
  nextchr();
  if (isendcom(chr)) parsefailf(endnobegin);
}


void beginparsing(FILE *infile)
{
  /* The following table is necessary because we can't assume we're using */
  /* the ASCII character set.  Theoretically, this source could have been */
  /* translated to another character set in which the digits are not      */
  /* adjacent, so a table is necessary to find their values.              */

  if (!digvaltable['1']) {
    digvaltable['1'] =  1;
    digvaltable['2'] =  2;
    digvaltable['3'] =  3;
    digvaltable['4'] =  4;
    digvaltable['5'] =  5;
    digvaltable['6'] =  6;
    digvaltable['7'] =  7;
    digvaltable['8'] =  8;
    digvaltable['9'] =  9;
    digvaltable['A'] = 10;
    digvaltable['B'] = 11;
    digvaltable['C'] = 12;
    digvaltable['D'] = 13;
    digvaltable['E'] = 14;
    digvaltable['F'] = 15;
    digvaltable['a'] = 10;
    digvaltable['b'] = 11;
    digvaltable['c'] = 12;
    digvaltable['d'] = 13;
    digvaltable['e'] = 14;
    digvaltable['f'] = 15;
  }

  f = infile;
  line = 1;
  pos = 0;
  chr = EOF;
  escaped = 0;
  nextvisiblechr();
}


#define clearword()  { wordend = word; }


static void appendword(int c)  /* Puts character c at the end of word. */
{
  if (wordend == wordlimit)
  {
    char *oldword = word, *oldwordend = wordend;

    wordsize *= 2;
    word = (char *) malloc(wordsize * sizeof (char));
    if (!word) failf(outofmem);
    wordlimit = word + wordsize;
    wordend = word;
    while (oldword != oldwordend) *wordend++ = *oldword++;
  }

  *wordend++ = c;
}


const unsigned char *nextword(void)
{
  clearword();

  /* Look for beginning of word: */

  while (!escaped) {
    if (isinstrsep(chr) || isEOF(chr)) {
      appendword(0);
      return word;
    }
    if (!isblank(chr)) break;
    nextvisiblechr();
  }

  /* Beginning found.  Now look for end: */

  do {
    appendword(chr);
    nextvisiblechr();
  } while (escaped || !isEOF(chr) && !isinstrsep(chr) && !isblank(chr));

  /* End found. */

  appendword(0);
  return word;
}


int nextinstr(void)
{
  while (escaped || !isEOF(chr) && !isinstrsep(chr)) nextvisiblechr();
  if (isEOF(chr)) return 0;
  nextvisiblechr();
  return 1;
}


#define maxint         4294967295
#define isdollar(c)    ((c) == '$')
#define ispercent(c)   ((c) == '%')
#define isbit(c)       ((c) == '0' || (c) == '1')
#define digval(c)      digvaltable[c]


int wordtoul(const unsigned char *word, unsigned long *ulptr)
{
  unsigned long value = 0, dv;
  int c;

  c = *word;

  if (isdigit(c)) {

    do {
      if (value > maxint / 10) return 0;
      value *= 10;
      dv = digval(c);
      if (value > maxint - dv) return 0;
      value += dv;
      c = *++word;
    } while (isdigit(c));
    if (c) return 0;

  } else if (isdollar(c)) {

    c = *++word;
    if (!isxdigit(c)) return 0;
    do {
      if (value > maxint / 16) return 0;
      value *= 16;
      dv = digval(c);
      if (value > maxint - dv) return 0;
      value += dv;
      c = *++word;
    } while (isxdigit(c));
    if (c) return 0;

  } else if (ispercent(c)) {

    c = *++word;
    if (!isbit(c)) return 0;
    do {
      if (value > maxint / 2) return 0;
      value *= 2;
      dv = digval(c);
      if (value > maxint - dv) return 0;
      value += dv;
      c = *++word;
    } while (isbit(c));
    if (c) return 0;

  } else return 0;

  *ulptr = value;
  return 1;
}


unsigned long linenum(void)
{
  return line;
}


unsigned long position(void)
{
  return pos;
}
