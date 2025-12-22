/**************************************/
/* bmfc.c			      */
/* for BMFC 0.00		      */
/* Copyright 1992 by Adam M. Costello */
/*				      */
/* Modified Oct 1993 - Copyright 1993 */
/* by Olaf Rhialto 'Rhialto' Seibert  */
/**************************************/


#include <limits.h>

#if UCHAR_MAX != 255
#error ---------------------------------------
#error Danger!	Danger!  UCHAR_MAX is not 255!
#error ---------------------------------------
#endif

#include "build.h"
#include "error.h"
#include <stdlib.h>


static const char

  /* Error messages: */

  *const cantopenread  = "Unable to open file \"%s\" for reading.\n",
  *const cantopenwrite = "Unable to open file \"%s\" for writing.\n",
  *const cantwrite     = "Unable to write to file.\n",

  /* Warning messages: */

  *const cantclose     = "Unable to close file \"%s\".\n",
  *const success       = "Compilation successful.\n",
  *const outputto      = "Output written to \"%s\".\n";

static FILE *writefile;  /* Only for use by write...() functions. */
static int hunkoffset;
static int fixedwidth;

static void writeubyte(unsigned char b)  /* Writes b to writefile. */
{
  if (putc(b,writefile) == EOF) failf(cantwrite);
  hunkoffset++;
}


static void writeubytes(int n, unsigned char *b)  /* Writes n bytes from */
{						  /* *b to writefile.	 */
  while (n--) writeubyte(*b++);
}


static void writeuword(unsigned short w)  /* Write w to writefile, */
{					  /* high byte first.	   */
  writeubyte((w & 0xFF00) >> 8);
  writeubyte(w & 0xFF);
}


static void writeword(short w)  /* Write w to writefile, high byte first. */
{
  writeuword(w >= 0 ? w : w + 0x10000);
}


static void writeulong(unsigned long L)   /* Write L to writefile, */
{					  /* high byte first.	   */
  writeubyte((L & 0xFF000000) >> 24);
  writeubyte((L & 0xFF0000) >> 16);
  writeubyte((L & 0xFF00) >> 8);
  writeubyte(L & 0xFF);
}

#define MAX_RELOCS	32
static unsigned long relocs[MAX_RELOCS];
static unsigned int relocptr;

static void writeptr(unsigned long L)     /* Write L to writefile, */
					  /* remembering to	   */
					  /* relocate it later	   */
{
  relocs[relocptr++] = hunkoffset;
  writeulong(L);
}

static void writerelocs(void)             /* write the relocations */
{
  writeulong(relocptr); /* this many */
  writeulong(0);        /* references to hunk 0 */
  while (relocptr > 0)
      writeulong(relocs[--relocptr]);
}


static void writeloadfile(FILE *loadfile, struct font *thefont)
{
  unsigned long  *theparams = thefont->parameters, cf = theparams[colorfont],
		 d = theparams[depth], rp = theparams[revpath], plane, p,
		 pixmapwidth, roundedpmw, fontname, fontdata, fontloc,
		 fontspace, fontkern, fontcolors, colortable, fontend, codeend;
  unsigned short *thewidths = thefont->widths, *A, *B, *C, *offset, *pwidth,
		 *pA, *lastA, *pB, *pC, *poffset, *lastoffset, defA, defB,
		 defC, defoffset, ys = thefont->ysize, modulo, w;
  unsigned char  **theglyphs = thefont->glyphs, **pglyph, **lastglyph,
		 *prow, *lastrow, *pmrow, *ppix, *lastpix, *pmpix, *pixmap,
		 lowchar, highchar, bitmask;
  unsigned int	 numglyphs, defchar;
  unsigned long  tags;
  int		 needkern = !fixedwidth || rp || theparams[proportional];

  for (pglyph = theglyphs; !*pglyph; ++pglyph);
  lowchar = pglyph - theglyphs;
  for (pglyph = theglyphs + 255; !*pglyph; --pglyph);
  highchar = pglyph - theglyphs;
  defchar = highchar + 1;
  theglyphs[defchar] = theglyphs[256];
  thewidths[defchar] = thewidths[256];
  numglyphs = defchar - lowchar + 1;

  A = (unsigned short *) malloc(numglyphs * sizeof (unsigned short));
  B = (unsigned short *) malloc(numglyphs * sizeof (unsigned short));
  C = (unsigned short *) malloc(numglyphs * sizeof (unsigned short));
  offset = (unsigned short *) malloc(numglyphs * sizeof (unsigned short));

  if (!A || !B || !C || !offset) failf(outofmem);

  /* Figure out offsets and A, B, and C values: */
  /* For a character like this
   *
   * ...***...	i.e. A is the CharKern value,
   * ...***...	     B is the width in CharLoc,
   * ...***...	     B+C is CharSpace
   * ...***...
   * ...***...
   *  ^  ^  ^
   *  A  B  C
   *
   * If NULL pointer, 0 is assumed for CharKern.
   * If NULL pointer, tf_XSize is assumed for CharSpace.
   *
   * For fixed-width fonts it is usually more efficent to leave
   * out the space/kerning info than to optimise the A bits
   * of the glyphs.
   */

  for (pglyph = theglyphs + lowchar, pwidth = thewidths + lowchar, pA = A,
	 pB = B, pC = C, poffset = offset, pixmapwidth = 0,
	 lastglyph = theglyphs + defchar;
       pglyph <= lastglyph;
       ++pglyph, ++pwidth, ++pA, ++pB, ++pC, ++poffset) {
    if (*pglyph) {
      if (!*pwidth) *pA = *pB = *pC = 0;
      else {
	*pA = *pC = w = *pwidth;
	for (prow = *pglyph, lastrow = prow + ys * w;
	     prow < lastrow;
	     prow += w)
	  for (ppix = prow, lastpix = prow + w - 1;
	       ppix <= lastpix;
	       ++ppix)
	    if (*ppix) {
	      if (ppix - prow < *pA) *pA = ppix - prow;
	      if (lastpix - ppix < *pC) *pC = lastpix - ppix;
	    }
	if (*pC == w) *pA = 0;
	*pB = w - *pC - *pA;
	if (!needkern) {
	    /* put the A bits back with the B bits */
	    *pB += *pA;
	    *pA = 0;
	    if (fixedwidth > 1) {
		/* and also the C bits - we hope this renders faster */
		*pB += *pC;
		*pC = 0;
	    }
	}
      }
      /* Check for re-used glyphs: generate only once */
      if (pglyph[0][-1]) {
	  *poffset = offset[pglyph[0][-2]];
      } else {
	  pglyph[0][-1] = 1;
	  pglyph[0][-2] = poffset - offset;

	  *poffset = pixmapwidth;
	  pixmapwidth += *pB;
      }
    }
  }
  if (!needkern) {
    printf("Omitted kerning info %s.\n",
    fixedwidth>1? "and generated full-width characters" :
		  "but optimised character width"
    );
  }

  /* Replicate default glyph onto undefined glyphs: */

  defoffset = poffset[-1];
  defA = pA[-1];
  defB = pB[-1];
  defC = pC[-1];

  for (pglyph = theglyphs + lowchar, poffset = offset, pA = A, pB = B, pC = C,
	 lastglyph = theglyphs + highchar;
       pglyph <= lastglyph;
       ++pglyph, ++poffset, ++pA, ++pB, ++pC)
    if (!*pglyph) {
      *poffset = defoffset;
      *pA = defA;
      *pB = defB;
      *pC = defC;
    }

  modulo = ((pixmapwidth + 15) / 16) * 2;
  roundedpmw = modulo * 8;

  pixmap = (unsigned char *) malloc(ys * roundedpmw * sizeof (unsigned char));
  if (!pixmap) failf(outofmem);

  /* Construct pixmap: */

  for (pglyph = theglyphs + lowchar, pwidth = thewidths + lowchar, pA = A,
	 pB = B, poffset = offset, lastglyph = theglyphs + defchar;
       pglyph <= lastglyph;
       ++pglyph, ++pwidth, ++pA, ++pB, ++poffset)
    if (*pglyph) {
      w = *pwidth;
      for (prow = *pglyph, pmrow = pixmap + *poffset, lastrow = prow + ys * w;
	   prow < lastrow;
	   prow += w, pmrow += roundedpmw)
	for (ppix = prow + *pA, pmpix = pmrow, lastpix = ppix + *pB;
	     ppix < lastpix;
	     ++ppix, ++pmpix)
	  *pmpix = *ppix;
    }

  for (pmrow = pixmap + pixmapwidth, lastrow = pmrow + (ys - 1) * roundedpmw;
       pmrow <= lastrow;
       pmrow += roundedpmw)
    for (pmpix = pmrow, lastpix = pmrow + (roundedpmw - pixmapwidth);
	 pmpix < lastpix;
	 ++pmpix)
      *pmpix = 0;

  fontname = 26;			/* 4+dfh_Name */
  fontdata = cf ? 154 : 110;		/* 4+dfh_TF+(ctf_SIZEOF:tf_SIZEOF) */
  fontloc = fontdata + d * ys * modulo;
  fontend = fontloc + numglyphs * 4;
  if (needkern) {
      fontspace = fontend;
      fontend = fontend + numglyphs * 2;
      fontkern = fontend;
      fontend = fontend + numglyphs * 2;
  }
  if (cf) {
    fontcolors = fontend;
    colortable = fontcolors + 8;
    fontend = colortable + thefont->numcolors * 2;
  }
  if (thefont->usedxydpi) {
    tags = fontend;
    fontend = tags + 4 * 4;
  }
  codeend = ((fontend + 3) / 4) * 4;

  /* Write the load file. */

  writefile = loadfile;

  /* hunk_header: 0x00003F3 0x00000001 0x00000000 */

  writeubytes(20, "\0\0\x03\xF3\0\0\0\0\0\0\0\1\0\0\0\0\0\0\0\0");
  writeulong((fontend + 3) / 4);

  /* hunk_code: */

  writeulong(0x3E9);
  writeulong((fontend + 3) / 4);

  /* dfh_ReturnCode: */

  hunkoffset = 0;
  writeubyte(0x70);
  writeubyte(theparams[returncode]);
  writeuword(0x4E75);

  /* dfh_DF: */

  writeubytes(10, "\0\0\0\0\0\0\0\0\x0C\0");
  writeptr(fontname);

  writeuword(0x0F80);               /* dfh_FileID                 */
  writeuword(theparams[revision]);  /* dfh_Revision               */
  if (thefont->usedxydpi) {
    writeptr(tags);                 /* dfh_Segment or dfh_Taglist */
  } else {
    writeulong(0);                  /* dfh_Segment or dfh_Taglist */
  }
  writeubytes(32, thefont->name);   /* dfh_Name                   */

  /* dfh_TF.tf_Message.mn_Node: (just like dfh_DF) */

  writeubytes(10, "\0\0\0\0\0\0\0\0\x0C\0");
  writeptr(fontname);

  writeulong(0);   /* dfh_TF.tf_Message.mn_Replyport */
		   /*	or dfh_TF.tf_Extension	     */
  writeuword(0);   /* dfh_TF.tf_Message.mn_Length    */
  writeuword(ys);  /* dfh_TF.tf_YSize                */

  /* dfh_TF.tf_Style: */

  writeubyte(theparams[underlined] +
	     2 * theparams[bold] +
	     4 * theparams[italic] +
	     8 * theparams[extended] +
	     64 * theparams[colorfont] +
	     128 * thefont->usedxydpi);

  /* dfh_TF.tf_Flags: */

  writeubyte(66 + 4 * theparams[revpath] +
	     8 * theparams[talldot] +
	     16 * theparams[widedot] +
	     32 * theparams[proportional] );

  writeuword(theparams[xsize]);      /* dfh_TF.tf_XSize     */
  writeuword(theparams[baseline]);   /* dfh_TF.tf_Baseline  */
  writeuword(theparams[boldsmear]);  /* dfh_TF.tf_Boldsmear */
  writeuword(0);                     /* dfh_TF.tf_Accessors */
  writeubyte(lowchar);               /* dfh_TF.tf_LowChar   */
  writeubyte(highchar);              /* dfh_TF.tf_HighChar  */
  writeptr(fontdata);                /* dfh_TF.tf_CharData  */
  writeword(modulo);                 /* dfh_TF.tf_Modulo    */
  writeptr(fontloc);                 /* dfh_TF.tf_CharLoc   */
  if (needkern) {
      writeptr(fontspace);           /* dfh_TF.tf_CharSpace */
      writeptr(fontkern);            /* dfh_TF.tf_CharKern  */
  } else {
      writeulong(0);                 /* dfh_TF.tf_CharSpace */
      writeulong(0);                 /* dfh_TF.tf_CharKern  */
  }

  if (cf) {
    unsigned long cfdata, planesize = ys * modulo;
    int plane;

    /* dfh_TF.ctf_Flags: */

    writeuword(thefont->usedcolors +
	       2 * theparams[greyfont] +
	       4 * theparams[antialias] );

    writeubyte(d);                      /* dfh_TF.ctf_Depth           */
    writeubyte(theparams[fgcolor]);     /* dfh_TF.ctf_FgColor         */
    writeubyte(theparams[low]);         /* dfh_TF.ctf_Low             */
    writeubyte(theparams[high]);        /* dfh_TF.ctf_High            */
    writeubyte(theparams[planepick]);   /* dfh_TF.ctf_PlanePick       */
    writeubyte(theparams[planeonoff]);  /* dfh_TF.ctf_PlaneOnOff      */
    writeptr(fontcolors);               /* dfh_TF.ctf_ColorFontColors */

    /* dfh_TF.ctf_CharData: */

    for (cfdata = fontdata; cfdata < fontloc; cfdata += planesize)
      writeptr(cfdata);
    for (plane = d; plane < 8; ++plane)
      writeptr(0);
  }

  /* *dfh_TF.tf_CharData: */

  for (plane = 0, bitmask = 1; plane < d; ++plane, bitmask <<= 1)
    for (pmrow = pixmap, lastrow = pixmap + ys * roundedpmw;
	 pmrow < lastrow;
	 pmrow += roundedpmw)
      for (pmpix = pmrow, lastpix = pmrow + roundedpmw;
	   pmpix < lastpix;
	   pmpix += 8)
	writeubyte(  ((pmpix[0] & bitmask) >> plane) << 7
		   | ((pmpix[1] & bitmask) >> plane) << 6
		   | ((pmpix[2] & bitmask) >> plane) << 5
		   | ((pmpix[3] & bitmask) >> plane) << 4
		   | ((pmpix[4] & bitmask) >> plane) << 3
		   | ((pmpix[5] & bitmask) >> plane) << 2
		   | ((pmpix[6] & bitmask) >> plane) << 1
		   | ((pmpix[7] & bitmask) >> plane) << 0
		  );

  /* *dfh_TF.tf_CharLoc: */

  for (poffset = offset, pB = B, lastoffset = offset + numglyphs;
       poffset < lastoffset;
       ++poffset, ++pB) {
    writeuword(*poffset);
    writeuword(*pB);
  }

  if (needkern) {
      /* *dfh_TF.tf_CharSpace: */

      for (pA = A, pB = B, pC = C, lastA = A + numglyphs;
	   pA < lastA;
	   ++pA, ++pB, ++pC)
	writeuword(rp ? -*pA : *pB + *pC);

      /* *dfh_TF.tf_CharKern: */

      for (pA = A, pB = B, pC = C, lastA = A + numglyphs;
	   pA < lastA;
	   ++pA, ++pB, ++pC)
	writeuword(rp ? -*pB - *pC : *pA);
  }

  if (cf) {
    unsigned short *pcolor, *lastcolor;

    /* fields of *dfh_TF.ctf_ColorFontColors: */

    writeuword(0);                   /* cfc_Reserved   */
    writeuword(thefont->numcolors);  /* cfc_Count      */
    writeptr(colortable);            /* cfc_ColorTable */

    /* *dfh_TF.ctf_ColorFontColors->cfc_ColorTable: */

    for (pcolor = thefont->colorvals, lastcolor = pcolor + thefont->numcolors;
	 pcolor < lastcolor;
	 ++pcolor)
      writeuword(*pcolor);
  }

  if (thefont->usedxydpi) {
      writeulong(0x80000001);        /* TA_DeviceDPI   */
      writeulong(thefont->xdpi << 16 | thefont->ydpi);
      writeulong(0);                 /* TAG_DONE       */
      writeulong(0);
  }

  /* pad hunk_code: */

  for (p = fontend; p < codeend; ++p) writeubyte(0);

  /* hunk_reloc32: */

  writeulong(0x3EC);
  writerelocs();

  writeulong(0);

  /* hunk_end: */

  writeulong(0x3F2);
}


void usage(char **argv)  /* Prints usage message and exits. */
{
  warnf("usage:\n%s [-o <loadfile>] <srcfile>\n", *argv ? *argv : "bmfc");
  exit(EXIT_FAILURE);
}


main(int argc, char **argv)
{
  const char *srcfilename = NULL, *loadfilename = NULL, **arg = argv;
  char lfnspace[6];
  FILE *srcfile = NULL, *loadfile = NULL;
  struct font thefontspace, *thefont = &thefontspace;

  if (!*arg) usage(argv);

  for (;;) {
    if (!*++arg) usage(argv);
    if (**arg != '-') break;
    if (arg[0][1] == 'f') {
      fixedwidth = arg[0][2] ? atoi(&arg[0][2]) : 1;
      continue;
    }
    if (arg[0][1] != 'o' || arg[0][2] != '\0' || !*++arg) usage(argv);
    loadfilename = *arg;
  }

  srcfilename = *arg;

  if (*++arg) usage(argv);

  srcfile = fopen(srcfilename, "rb");
  if (!srcfile) failf(cantopenread,srcfilename);

  build(srcfile,thefont);

  if (fclose(srcfile)) warnf(cantclose,srcfilename);
  srcfile = NULL;

  if (!loadfilename) {
    sprintf(lfnspace, "%hu", thefont->ysize);
    loadfilename = lfnspace;
  }

  loadfile = fopen(loadfilename, "wb");
  if (!loadfile) failf(cantopenwrite,loadfilename);

  writeloadfile(loadfile,thefont);

  if (fclose(loadfile)) warnf(cantclose,loadfilename);
  loadfile = NULL;

  warnf(success);
  warnf(outputto,loadfilename);
  exit(EXIT_SUCCESS);
}
