/**************************************/
/* build.c                            */
/* for BMFC 0.00                      */
/* Copyright 1992 by Adam M. Costello */
/**************************************/


#include <limits.h>

#if UCHAR_MAX != 255
#error ---------------------------------------
#error Danger!  Danger!  UCHAR_MAX is not 255!
#error ---------------------------------------
#endif

#include "build.h"  /* Makes sure we're consistent with the    */
                    /* prototypes and also includes <stdio.h>. */
#include "parse.h"
#include "error.h"
#include <stdlib.h>


static void checkgeneric(enum paramindex);
static void checkbaseline(enum paramindex);
static void checkhigh(enum paramindex);
static void checklow(enum paramindex);
static void checkproportional(enum paramindex);
static void checkxsize(enum paramindex);

static void (*const paramchecker[])(enum paramindex) = {
  checkgeneric, checkbaseline, checkgeneric, checkgeneric, checkgeneric,
  checkgeneric, checkgeneric, checkgeneric, checkgeneric, checkhigh,
  checkgeneric, checklow, checkgeneric, checkgeneric, checkproportional,
  checkgeneric, checkgeneric, checkgeneric, checkgeneric, checkgeneric,
  checkgeneric, checkxsize
};

#define check(param)  { paramchecker[param](param); }

static struct font    *thefont;
static unsigned long  *theparams;
static unsigned char **theglyphs;
static unsigned short *thewidths;

enum instrindex {
  bitmapfont, xydpi, colors, colorsym, glyph, nullglyph, dupglyph, numinstrs
};

static void readbitmapfont(void);
static void readxydpi(void);
static void readcolors(void);
static void readcolorsym(void);
static void readglyph(void);
static void readnullglyph(void);
static void readdupglyph(void);

static void (*const instrreader[])(void) = {
  readbitmapfont, readxydpi, readcolors, readcolorsym, readglyph, readnullglyph,
  readdupglyph
};

/* Some parameters have constant min/max and/or default values: */

#define special  0           /* So humans can tell which don't. */

static const unsigned long parammin[] = {
/* antialias baseline bold boldsmear colorfont depth extended fgcolor    */
           0, special,   0,        0,        0,    1,       0,      0,
/* greyfont     high italic      low planeonoff planepick proportional   */
          0, special,     0, special,         0,        0,           0,
/* returncode revision revpath talldot underlined widedot    xsize       */
            0,       0,      0,      0,         0,      0,       0
};

static const unsigned long parammax[] = {
/* antialias baseline bold boldsmear colorfont depth extended fgcolor    */
           1, special,   1,    65535,        1,    8,       1,    255,
/* greyfont     high italic      low planeonoff planepick proportional   */
          1, special,     1, special,       255,      255,           1,
/* returncode revision revpath talldot underlined widedot    xsize       */
          127,   65535,      1,      1,         1,      1,   65535
};

static const unsigned long paramdefault[] = {
/* antialias baseline bold boldsmear colorfont depth extended fgcolor    */
           0, special,   0,        1,        0,    1,       0,    255,
/* greyfont     high italic      low planeonoff planepick proportional   */
          0, special,     0, special,         0,      255,     special,
/* returncode revision revpath talldot underlined widedot    xsize       */
          100,       0,      0,      0,         0,      0, special
};

/* Some parameters apply only to color fonts: */

static const boolean colorparam[] =
  { 1, 0, 0, 0, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0 };

enum assignstatus { unassigned, assigned, checked, defaulted };

/* Note, the above is a progression.  That is,       */
/* defaulted implies checked which implies assigned. */

static enum assignstatus paramstatus[numparams];

static unsigned char map[UCHAR_MAX + 1];

static const char

  /* Error messages: */ 

  *const bmfexpected   = "Instruction bitmapfont expected.\n",
  *const intexpected   = "Integer expected.\n",
  *const badysize      = "ysize is out of range [1,65535].\n",
  *const toomanywords  = "Too many words for this instruction.\n",
  *const toofewwords   = "Too few words for this instruction.\n",
  *const unknowninstr  = "Unknown instruction: %s\n",
  *const noglyph256    = "Glyph 256 not defined.\n",
  *const norealglyphs  = "No glyphs defined (except glyph 256).\n",
  *const paramrange    = "Parameter %s is out of range [%u,%u].\n",
  *const customprange  = "Parameter %s is out of range [%s].\n",
  *const badglyphcolor = "Glyph %u uses color %u > 2^depth - 1.\n",
  *const instragain    = "Instruction %s used more than once.\n",
  *const paramagain    = "Parameter %s assigned more than once.\n",
  *const dpirange      = "dpi value out of range [1,32767].\n",
  *const toomanycolors = "At most 256 colors may be defined.\n",
  *const colortoobig   = "An RGB color value exceeded $FFF.\n",
  *const onecharexp    = "This word must have length 1.\n",
  *const colornumrange = "Color number out of range [0,255].\n",
  *const glyphrange    = "Glyph number out of range [0,256].\n",
  *const glyphorder    = "Second glyph number is less than first.\n",
  *const glyphagain    = "Glyph %u defined twice.\n",
  *const glyphwidth    = "Rows of glyph %u not all same width.\n",

  /* Warning messages: */

  *const nametrunc    = "name \"%s\" truncated to \"%.32s\".\n",
  *const noteparam    = "(note parameter %s = %lu)\n",
  *const paramdefto   = "Parameter %s defaults to %lu.\n",
  *const mootparam    = "Parameter %s was assigned, but is ignored.\n",
  *const mootinstr    = "Instruction %s was issued, but doesn't apply.\n";

static const unsigned char

  /* Instruction names: Must be in same order as in enum instrindex. */

  *const instrname[] = {
    "bitmapfont", "xydpi", "colors", "colorsym", "glyph", "nullglyph",
    "dupglyph"
  },

  /* Parameter names: Must be in same order as in enum paramindex. */

  *const paramname[] = {
    "antialias", "baseline", "bold", "boldsmear", "colorfont", "depth",
    "extended", "fgcolor", "greyfont", "high", "italic", "low", "planeonoff",
    "planepick", "proportional", "returncode", "revision", "revpath",
    "talldot", "underlined", "widedot", "xsize"
  };


static unsigned long getul(void)  /* Reads next word and returns value. */
{                                 /* Doesn't return if unsuccessful.    */
  const unsigned char *word;
  unsigned long ul;

  word = nextword();
  if (!*word) parsefailf(toofewwords);
  if (!wordtoul(word,&ul)) parsefailf(intexpected);
  return ul;
}


static int streq(const unsigned char *s1, const unsigned char *s2)
/* Returns 1 if strings s1 and s2 are equal, 0 otherwise. */
/* s1 and s2 must both point to '\0'-terminated strings.  */
{
  while (*s1) {
    if (*s1 != *s2) return 0;
    ++s1;
    ++s2;
  }
  return (*s2 == '\0');
}


static void readparam(unsigned long param)  /* Reads the value of param. */
{
  if (paramstatus[param] >= assigned) parsefailf(paramagain, paramname[param]);
  theparams[param] = getul();
  if (*nextword()) parsefailf(toomanywords);
  paramstatus[param] = assigned;
}


void build(FILE *srcfile, struct font *f)  /* This is long, but not deep. */
{
  const unsigned char *word;
  enum assignstatus *pstat, *laststat;
  unsigned char *ppix, *lastpix, **pglyph, **lastglyph;
  unsigned short *pwidth;
  int i,j;
  unsigned long ys;
  enum instrindex instr;
  enum paramindex param;
  boolean cf;
  unsigned char maxcolor;

  thefont   = f;
  theparams = f->parameters;
  theglyphs = f->glyphs;
  thewidths = f->widths;

  for (pstat = paramstatus, laststat = paramstatus + numparams;
       pstat < laststat;
       *pstat++ = unassigned);                /* Initialize parameter stati. */

  for (pglyph = theglyphs, lastglyph = theglyphs + 256;
       pglyph <= lastglyph;
       *pglyph++ = NULL);                     /* Clear glyph pointers.       */

  for (ppix = map, lastpix = map + UCHAR_MAX;
       ppix <= lastpix;
       *ppix++ = 0);                          /* Clear color symbol map.     */

  map['@'] = map['#'] = map['*'] = map['1'] = 1;
  map['2'] = 2;
  map['3'] = 3;
  map['4'] = 4;
  map['5'] = 5;
  map['6'] = 6;
  map['7'] = 7;
  map['8'] = 8;
  map['9'] = 9;
  map['A'] = map['a'] = 10;
  map['B'] = map['b'] = 11;
  map['C'] = map['c'] = 12;
  map['D'] = map['d'] = 13;
  map['E'] = map['e'] = 14;
  map['F'] = map['f'] = 15;

  thefont->usedcolors = 0;
  thefont->usedxydpi = 0;

  beginparsing(srcfile);
  word = nextword();
  if (!streq(word, instrname[bitmapfont])) parsefailf(bmfexpected);
  word = nextword();
  for (i = 0; i < 32 && word[i]; ++i) thefont->name[i] = word[i];
  if (i == 32 && word[32]) warnf(nametrunc,word,word);
  for (j = i; j < 32; ++j) thefont->name[j] = 0;
  ys = getul();
  if (ys < 1 || ys > 65535) parsefailf(badysize);
  thefont->ysize = ys;
  if (*nextword()) parsefailf(toomanywords);

  while (nextinstr()) {

    word = nextword();
    if (!*word) continue;
    for (instr = 0; instr < numinstrs; ++instr)
      if (streq(word,instrname[instr])) {
        instrreader[instr]();
        break;
      }
    if (instr < numinstrs) continue;
    for (param = 0; param < numparams; ++param)
      if (streq(word,paramname[param])) {
        readparam(param);
        break;
      }
    if (param < numparams) continue;
    parsefailf(unknowninstr,word);

  }

  if (!theglyphs[256]) failf(noglyph256);
  for (pglyph = theglyphs; !*pglyph; ++pglyph);
  if (pglyph == theglyphs + 256) failf(norealglyphs);

  for (param = 0; param < numparams; ++param) check(param);

  cf = theparams[colorfont];
  maxcolor = cf ? ((1 << theparams[depth]) - 1) : 1;

  for (pglyph = theglyphs, pwidth = thewidths, lastglyph = theglyphs + 257;
       pglyph < lastglyph;
       ++pglyph, ++pwidth)
    if (*pglyph)
      for (ppix = *pglyph, lastpix = ppix + ys * (unsigned long) *pwidth;
           ppix < lastpix;
           ++ppix)
        if (*ppix > maxcolor) {
          warnf(noteparam, paramname[depth], theparams[depth]);
          failf(badglyphcolor, pglyph - theglyphs, *ppix);
        }

  for (param = 0; param < numparams; ++param)
    if (paramstatus[param] >= defaulted && (!colorparam[param] || cf))
      warnf(paramdefto, paramname[param], theparams[param]);

  if (!cf)
    for (param = 0; param < numparams; ++param)
      if (colorparam[param] && paramstatus[param] < defaulted)
        warnf(mootparam, paramname[param]);

  if (thefont->usedcolors) {
    if (!cf) warnf(mootinstr, instrname[colors]);
  } else thefont->numcolors = 0;
}


static void readbitmapfont(void)
{
  parsefailf(instragain, instrname[bitmapfont]);
}


static void readxydpi(void)
{
  unsigned long dpi;

  if (thefont->usedxydpi) parsefailf(instragain, instrname[xydpi]);
  thefont->usedxydpi = 1;

  dpi = getul();
  if (dpi < 1 || dpi > 32767) parsefailf(dpirange);
  thefont->xdpi = dpi;

  dpi = getul();
  if (dpi < 1 || dpi > 32767) parsefailf(dpirange);
  thefont->ydpi = dpi;

  if (*nextword()) parsefailf(toomanywords);
}


static void readcolors(void)
{
  unsigned long nc, c;
  int i;

  if (thefont->usedcolors) parsefailf(instragain, instrname[colors]);
  thefont->usedcolors = 1;

  nc = getul();
  if (nc > 256) parsefailf(toomanycolors);
  thefont->numcolors = nc;

  for (i = 0; i < nc; ++i) {
    c = getul();
    if (c > 0xFFF) parsefailf(colortoobig);
    thefont->colorvals[i] = c;
  }

  if (*nextword()) parsefailf(toomanywords);
}


static void readcolorsym(void)
{
  const unsigned char *word;
  unsigned char sym;
  unsigned long cn;

  word = nextword();
  if (!*word) parsefailf(toofewwords);
  if (word[1]) parsefailf(onecharexp);
  sym = *word;
  cn = getul();
  if (cn > 255) parsefailf(colornumrange);
  map[sym] = cn;
}


static int slen(const unsigned char *s)  /* Returns length of string s,    */
{                                        /* which must be '\0'-terminated. */
  const unsigned char *p = s;

  while (*p) ++p;
  return p - s;
}


static unsigned char *allocglyph(unsigned short width)
/* Allocates memory for a glyph given its width.  Returns a */
/* pointer to the glyph.  Doesn't return if unsuccessful.   */
{
  unsigned short ys = thefont->ysize;
  unsigned char *g;

  g = (unsigned char *) malloc(2 + ys * width * sizeof (unsigned char));
  if (!g) failf(outofmem);
  g[0] = 0;
  g[1] = 0;
  return g + 2;
}


static void readglyph(void)
{
  const unsigned char *word;
  unsigned char *ppix, *lastpix, **pglyph, **lastglyph;
  unsigned long first, last;
  int row, w;
  unsigned short ys = thefont->ysize, *pwidth;

  first = getul();
  if (first > 256) parsefailf(glyphrange);
  last = getul();
  if (last > 256) parsefailf(glyphrange);
  if (last < first) parsefailf(glyphorder);

  for (pglyph = theglyphs + first, pwidth = thewidths + first,
         lastglyph = theglyphs + last;
       pglyph <= lastglyph;
       ++pglyph, ++pwidth) {
    if (*pglyph) parsefailf(glyphagain, pglyph - theglyphs);
    word = nextword();
    if (!*word) parsefailf(toofewwords);
    *pwidth = w = slen(word);
    *pglyph = allocglyph(w);
    for (ppix = *pglyph, lastpix = ppix + w;
         ppix < lastpix;
         ++ppix, ++word)
      *ppix = map[*word];
  }

  for (row = 1; row < ys; ++row)
    for (pglyph = theglyphs + first, pwidth = thewidths + first,
           lastglyph = theglyphs + last;
         pglyph <= lastglyph;
         ++pglyph, ++pwidth) {
      word = nextword();
      if (!*word) parsefailf(toofewwords);
      w = *pwidth;
      if (slen(word) != w) parsefailf(glyphwidth, pglyph - theglyphs);
      for (ppix = *pglyph + row * w, lastpix = ppix + w;
           ppix < lastpix;
           ++ppix, ++word)
        *ppix = map[*word];
    }

  if (*nextword()) parsefailf(toomanywords);
}


static void readnullglyph(void)
{
  /* Defined glyphs can't be NULL, so here's a place for them to point: */
  static unsigned char nullgmarker[3];
  unsigned char **pglyph, **lastglyph;
  unsigned short *pwidth;
  unsigned long first, last;

  first = getul();
  if (first > 256) parsefailf(glyphrange);
  last = getul();
  if (last > 256) parsefailf(glyphrange);
  if (last < first) parsefailf(glyphorder);
  if (*nextword()) parsefailf(toomanywords);

  for (pglyph = theglyphs + first, pwidth = thewidths + first,
         lastglyph = theglyphs + last;                           
       pglyph <= lastglyph;                          
       ++pglyph, ++pwidth) {                        
    *pglyph = nullgmarker+2;
    *pwidth = 0;
  }
}


static void readdupglyph(void)
{
  unsigned char **pglyph;
  unsigned long orig, dup;

  orig = getul();
  if (orig > 256) parsefailf(glyphrange);
  dup = getul();
  if (dup > 256) parsefailf(glyphrange);
  if (*nextword()) parsefailf(toomanywords);

  pglyph = theglyphs + orig;

  if (!*pglyph) parsefailf("Glyph %d not yet defined\n", orig);
  if (theglyphs[dup]) warnf("dupglyph overrides previous definition of glyph %d\n", dup);

  theglyphs[dup] = *pglyph;
  thewidths[dup] = thewidths[orig];
}


static void checkgeneric(enum paramindex param)
{
  if (paramstatus[param] < assigned) {
    theparams[param] = paramdefault[param];
    paramstatus[param] = defaulted;
  } else if (paramstatus[param] < checked) {
    if (   theparams[param] > parammax[param]
        || theparams[param] < parammin[param])
      failf(paramrange, paramname[param], parammin[param], parammax[param]);
    paramstatus[param] = checked;
  }
}


static void checkbaseline(enum paramindex param)  /* param must be baseline */
{
  unsigned long ys = thefont->ysize;

  if (paramstatus[param] < assigned) {                                   
    theparams[param] = (ys > 1) ? (ys - 2) : 0;
    paramstatus[param] = defaulted;  
  } else if (paramstatus[param] < checked) {    
    if (theparams[param] > ys - 1)  
      failf(customprange, paramname[param], "0, <ysize> - 1");
    paramstatus[param] = checked;       
  }
}


static void checkhigh(enum paramindex param)  /* param must be high */
{
  unsigned long d;
  unsigned char m;

  check(depth);
  check(low);

  d = theparams[depth];
  m = (1 << d) - 1;

  if (paramstatus[param] < assigned) {
    theparams[param] = m;
    paramstatus[param] = defaulted;
  } else if (paramstatus[param] < checked)
    if (theparams[high] < theparams[low] || theparams[high] > m) {
      warnf(noteparam, paramname[low], theparams[low]);
      warnf(noteparam, paramname[depth], d);
      failf(customprange, paramname[high], "low, 2^depth - 1");
    }
}


static void checklow(enum paramindex param)  /* param must be low */
{
  unsigned long d;
  unsigned char m;

  check(depth);

  d = theparams[depth];
  m = (1 << d) - 1;

  if (paramstatus[low] < assigned) {
    theparams[low] = 0;
    paramstatus[low] = defaulted;
  } else if (paramstatus[low] < checked) {
    if (theparams[low] > m) {
      warnf(noteparam, paramname[depth], d);
      failf(customprange, paramname[low], "0, 2^depth - 1");
    }
    paramstatus[low] = checked;
  }
}


static void checkproportional(enum paramindex param)  /* param must be */
{                                                     /* proportional  */
  checkgeneric(param);

  if (paramstatus[param] >= defaulted) {

    unsigned short w = thewidths[256], *pwidth, *lastwidth;
    unsigned char **pglyph;

    for (pwidth = thewidths, pglyph = theglyphs, lastwidth = thewidths + 256;
         pwidth < lastwidth;
         ++pwidth, ++pglyph)
      if (*pglyph && *pwidth != w) break;
    theparams[proportional] = (pwidth < lastwidth) ? 1 : 0;

  }
}


static void checkxsize(enum paramindex param)  /* param must be xsize */
{
  checkgeneric(xsize);

  if (paramstatus[param] >= defaulted) {

    unsigned char **pglyph;
    unsigned short x = 0, *pwidth, *lastwidth;

    for (pwidth = thewidths, pglyph = theglyphs, lastwidth = thewidths + 257;
         pwidth < lastwidth;
         ++pwidth, ++pglyph)
      if (*pglyph && *pwidth > x) x = *pwidth;
    theparams[xsize] = x;

  }
}
