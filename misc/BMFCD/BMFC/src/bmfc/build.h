/**************************************/
/* build.h                            */
/* for BMFC 0.00                      */
/* Copyright 1992 by Adam M. Costello */
/**************************************/


#include <stdio.h>


typedef char boolean;

enum paramindex {
  antialias, baseline, bold, boldsmear, colorfont, depth, extended, fgcolor,
  greyfont, high, italic, low, planeonoff, planepick, proportional, returncode,
  revision, revpath, talldot, underlined, widedot, xsize, numparams
};

struct font {
  unsigned char  name[32], *glyphs[257];
  unsigned long  parameters[numparams];
  unsigned short widths[257], ysize, numcolors, colorvals[256];
  short          xdpi, ydpi;
  boolean        usedcolors, usedxydpi;
};


void build(FILE *srcfile, struct font *f);

/* Fills in the struct font pointed to by f by */
/* interpreting the source code in srcfile.    */
