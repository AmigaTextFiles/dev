/*
 * <one line to give the program's name and a brief idea of what it does.>
 * Copyright (C) 1998  Niels Froehling <Niels.Froehling@Informatik.Uni-Oldenburg.de>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

/*\
 * $Id: bmp.h,v 1.3 1992/11/24 19:39:56 dws Exp dws $
 * 
 * bmp.h - routines to calculate sizes of parts of BMP files
 *
 * Some fields in BMP files contain offsets to other parts
 * of the file.  These routines allow us to calculate these
 * offsets, so that we can read and write BMP files without
 * the need to fseek().
 * 
 * Copyright (C) 1992 by David W. Sanderson.
 * 
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted,
 * provided that the above copyright notice appear in all copies and
 * that both that copyright notice and this permission notice appear
 * in supporting documentation.  This software is provided "as is"
 * without express or implied warranty.
 * 
 * $Log: bmp.h,v $
 * Revision 1.3  1992/11/24  19:39:56  dws
 * Added copyright.
 *
 * Revision 1.2  1992/11/17  02:13:37  dws
 * Adjusted a string's name.
 *
 * Revision 1.1  1992/11/16  19:54:44  dws
 * Initial revision
 *
 \*/

/* prototypes */
staticfnc unsigned long BMPlenfileheader ARGS((int class));
staticfnc unsigned long BMPleninfoheader ARGS((int class));
staticfnc unsigned long BMPlenrgbtable ARGS((int class, unsigned long bitcount));
staticfnc unsigned long BMPlenline ARGS((int class, unsigned long bitcount, unsigned long x));
staticfnc unsigned long BMPlenbits ARGS((int class, unsigned long bitcount, unsigned long x, unsigned long y));
staticfnc unsigned long BMPlenfile ARGS((int class, unsigned long bitcount, unsigned long x, unsigned long y));
staticfnc unsigned long BMPoffbits ARGS((int class, unsigned long bitcount));

/*
 * Classes of BMP files
 */

#define C_WIN	1
#define C_OS2	2

static char er_internal[] = "%s: internal error!";

staticfnc unsigned long BMPlenfileheader(class)
    int class;
{
  switch (class) {
    case C_WIN:
      return 14;
    case C_OS2:
      return 14;
    default:
      pm_error(er_internal, "BMPlenfileheader");
      return 0;
  }
}

staticfnc unsigned long BMPleninfoheader(class)
    int class;
{
  switch (class) {
    case C_WIN:
      return 40;
    case C_OS2:
      return 12;
    default:
      pm_error(er_internal, "BMPleninfoheader");
      return 0;
  }
}

staticfnc unsigned long BMPlenrgbtable(class, bitcount)
    int class;
    unsigned long bitcount;
{
  unsigned long lenrgb;

  if (bitcount < 1) {
    pm_error(er_internal, "BMPlenrgbtable");
    return 0;
  }
  switch (class) {
    case C_WIN:
      lenrgb = 4;
      break;
    case C_OS2:
      lenrgb = 3;
      break;
    default:
      pm_error(er_internal, "BMPlenrgbtable");
      return 0;
  }

  return (1 << bitcount) * lenrgb;
}

/*
 * length, in bytes, of a line of the image
 * 
 * Evidently each row is padded on the right as needed to make it a
 * multiple of 4 bytes long.  This appears to be true of both
 * OS/2 and Windows BMP files.
 */
staticfnc unsigned long BMPlenline(class, bitcount, x)
    int class;
    unsigned long bitcount;
    unsigned long x;
{
  unsigned long bitsperline;

  switch (class) {
    case C_WIN:
      break;
    case C_OS2:
      break;
    default:
      pm_error(er_internal, "BMPlenline");
      return 0;
  }

  bitsperline = x * bitcount;

  /*
   * if bitsperline is not a multiple of 32, then round
   * bitsperline up to the next multiple of 32.
   */
  if ((bitsperline % 32) != 0) {
    bitsperline += (32 - (bitsperline % 32));
  }

  if ((bitsperline % 32) != 0) {
    pm_error(er_internal, "BMPlenline");
    return 0;
  }

  /* number of bytes per line == bitsperline/8 */
  return bitsperline >> 3;
}

/* return the number of bytes used to store the image bits */
staticfnc unsigned long BMPlenbits(class, bitcount, x, y)
    int class;
    unsigned long bitcount;
    unsigned long x;
    unsigned long y;
{
  return y * BMPlenline(class, bitcount, x);
}

/* return the offset to the BMP image bits */
staticfnc unsigned long BMPoffbits(class, bitcount)
    int class;
    unsigned long bitcount;
{
  return BMPlenfileheader(class)
    + BMPleninfoheader(class)
    + BMPlenrgbtable(class, bitcount);
}

/* return the size of the BMP file in bytes */
staticfnc unsigned long BMPlenfile(class, bitcount, x, y)
    int class;
    unsigned long bitcount;
    unsigned long x;
    unsigned long y;
{
  return BMPoffbits(class, bitcount)
    + BMPlenbits(class, bitcount, x, y);
}

/*\
 * $Id: bmptoppm.c,v 1.10 1992/11/24 19:38:17 dws Exp dws $
 * 
 * bmptoppm.c - Converts from a Microsoft Windows or OS/2 .BMP file to a
 * PPM file.
 * 
 * The current implementation is probably not complete, but it works for
 * all the BMP files I have.  I welcome feedback.
 * 
 * Copyright (C) 1992 by David W. Sanderson.
 * 
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted,
 * provided that the above copyright notice appear in all copies and
 * that both that copyright notice and this permission notice appear
 * in supporting documentation.  This software is provided "as is"
 * without express or implied warranty.
 * 
 * $Log: bmptoppm.c,v $
 * Revision 1.10  1992/11/24  19:38:17  dws
 * Added code to verify that reading occurred at the correct offsets.
 * Added copyright.
 *
 * Revision 1.9  1992/11/17  02:15:24  dws
 * Changed to include bmp.h.
 * Eliminated need for fseek(), and therefore the need for a
 * temporary file.
 *
 * Revision 1.8  1992/11/13  23:48:57  dws
 * Made definition of Seekable() static, to match its prototype.
 *
 * Revision 1.7  1992/11/11  00:17:50  dws
 * Generalized to use bitio routines.
 *
 * Revision 1.6  1992/11/10  23:51:44  dws
 * Enhanced command-line handling.
 *
 * Revision 1.5  1992/11/08  00:38:46  dws
 * Changed some names to help w/ addition of ppmtobmp.
 *
 * Revision 1.4  1992/10/27  06:28:28  dws
 * Corrected stupid typo.
 *
 * Revision 1.3  1992/10/27  06:17:10  dws
 * Removed a magic constant value.
 *
 * Revision 1.2  1992/10/27  06:09:58  dws
 * Made stdin seekable.
 *
 * Revision 1.1  1992/10/27  05:31:41  dws
 * Initial revision
 \*/

#define	MAXCOLORS   	256

static char *ifname;

/*
 * Utilities
 */

staticfnc int GetByte ARGS((FILE * fp));
staticfnc short GetShort ARGS((FILE * fp));
staticfnc long GetLong ARGS((FILE * fp));
staticfnc void readto ARGS((FILE * fp, unsigned long *ppos, unsigned long dst));
staticfnc void BMPreadfileheader ARGS((FILE * fp, unsigned long *ppos,
				    unsigned long *poffBits));
staticfnc void BMPreadinfoheader ARGS((FILE * fp, unsigned long *ppos,
	   unsigned long *pcx, unsigned long *pcy, unsigned short *pcBitCount,
				    int *pclass));
staticfnc int BMPreadrgbtable ARGS((FILE * fp, unsigned long *ppos,
    unsigned short cBitCount, int class, pixval * R, pixval * G, pixval * B));
staticfnc int BMPreadrow ARGS((FILE * fp, unsigned long *ppos, pixel * row,
			    unsigned long cx, unsigned short cBitCount, pixval * R, pixval * G, pixval * B));
staticfnc pixel **BMPreadbits ARGS((FILE * fp, unsigned long *ppos,
		    unsigned long offBits, unsigned long cx, unsigned long cy,
    unsigned short cBitCount, int class, pixval * R, pixval * G, pixval * B));

static char er_read[] = "%s: read error";
static char er_seek[] = "%s: seek error";

staticfnc int GetByte(fp)
    FILE *fp;
{
  int v;

  if ((v = getc(fp)) == EOF) {
    pm_error(er_read, ifname);
  }

  return v;
}

staticfnc short GetShort(fp)
    FILE *fp;
{
  short v;

  if (pm_readlittleshort(fp, &v) == -1) {
    pm_error(er_read, ifname);
  }

  return v;
}

staticfnc long GetLong(fp)
    FILE *fp;
{
  long v;

  if (pm_readlittlelong(fp, &v) == -1) {
    pm_error(er_read, ifname);
  }

  return v;
}

/*
 * readto - read as many bytes as necessary to position the
 * file at the desired offset.
 */

staticfnc void readto(fp, ppos, dst)
    FILE *fp;
    unsigned long *ppos;					/* pointer to number of bytes read from fp */
    unsigned long dst;
{
  unsigned long pos;

  if (!fp || !ppos)
    return;

  pos = *ppos;

  if (pos > dst)
    pm_error("%s: internal error in readto()", ifname);

  for (; pos < dst; pos++) {
    if (getc(fp) == EOF) {
      pm_error(er_read, ifname);
    }
  }

  *ppos = pos;
}

/*
 * BMP reading routines
 */

staticfnc void BMPreadfileheader(fp, ppos, poffBits)
    FILE *fp;
    unsigned long *ppos;					/* number of bytes read from fp */
    unsigned long *poffBits;
{
  unsigned long cbSize;
  unsigned short xHotSpot;
  unsigned short yHotSpot;
  unsigned long offBits;

  if (GetByte(fp) != 'B') {
    pm_error("%s is not a BMP file", ifname);
  }
  if (GetByte(fp) != 'M') {
    pm_error("%s is not a BMP file", ifname);
  }

  cbSize = GetLong(fp);
  xHotSpot = GetShort(fp);
  yHotSpot = GetShort(fp);
  offBits = GetLong(fp);

  *poffBits = offBits;

  *ppos += 14;
}

staticfnc void BMPreadinfoheader(fp, ppos, pcx, pcy, pcBitCount, pclass)
    FILE *fp;
    unsigned long *ppos;					/* number of bytes read from fp */
    unsigned long *pcx;
    unsigned long *pcy;
    unsigned short *pcBitCount;
    int *pclass;
{
  unsigned long cbFix;
  unsigned short cPlanes;

  unsigned long cx;
  unsigned long cy;
  unsigned short cBitCount;
  int class;

  cbFix = GetLong(fp);

  switch (cbFix) {
    case 12:
      class = C_OS2;

      cx = GetShort(fp);
      cy = GetShort(fp);
      cPlanes = GetShort(fp);
      cBitCount = GetShort(fp);

      break;
    case 40:
      class = C_WIN;

      cx = GetLong(fp);
      cy = GetLong(fp);
      cPlanes = GetShort(fp);
      cBitCount = GetShort(fp);

      /*
       * We've read 16 bytes so far, need to read 24 more
       * for the required total of 40.
       */

      GetLong(fp);
      GetLong(fp);
      GetLong(fp);
      GetLong(fp);
      GetLong(fp);
      GetLong(fp);

      break;
    default:
      pm_error("%s: unknown cbFix: %d", ifname, cbFix);
      break;
  }

  if (cPlanes != 1) {
    pm_error("%s: don't know how to handle cPlanes = %d"
	     ,ifname
	     ,cPlanes);
  }

  switch (class) {
    case C_WIN:
      pm_message("Windows BMP, %dx%dx%d"
		 ,cx
		 ,cy
		 ,cBitCount);
      break;
    case C_OS2:
      pm_message("OS/2 BMP, %dx%dx%d"
		 ,cx
		 ,cy
		 ,cBitCount);
      break;
  }

  *pcx = cx;
  *pcy = cy;
  *pcBitCount = cBitCount;
  *pclass = class;

  *ppos += cbFix;
}

/*
 * returns the number of bytes read, or -1 on error.
 */
staticfnc int BMPreadrgbtable(fp, ppos, cBitCount, class, R, G, B)
    FILE *fp;
    unsigned long *ppos;					/* number of bytes read from fp */
    unsigned short cBitCount;
    int class;
    pixval *R;
    pixval *G;
    pixval *B;
{
  int i;
  int nbyte = 0;

  long ncolors = (1 << cBitCount);

  for (i = 0; i < ncolors; i++) {
    B[i] = (pixval) GetByte(fp);
    G[i] = (pixval) GetByte(fp);
    R[i] = (pixval) GetByte(fp);
    nbyte += 3;

    if (class == C_WIN) {
      (void)GetByte(fp);
      nbyte++;
    }
  }

  *ppos += nbyte;
  return nbyte;
}

/*
 * returns the number of bytes read, or -1 on error.
 */
staticfnc int BMPreadrow(fp, ppos, row, cx, cBitCount, R, G, B)
    FILE *fp;
    unsigned long *ppos;					/* number of bytes read from fp */
    pixel *row;
    unsigned long cx;
    unsigned short cBitCount;
    pixval *R;
    pixval *G;
    pixval *B;
{
  BITSTREAM b;
  unsigned nbyte = 0;
  int rc;
  unsigned x;

  if ((b = pm_bitinit(fp, "r")) == (BITSTREAM) 0) {
    return -1;
  }

  for (x = 0; x < cx; x++, row++) {
    unsigned long v;

    if ((rc = pm_bitread(b, cBitCount, &v)) == -1) {
      return -1;
    }
    nbyte += rc;

    PPM_ASSIGN(*row, R[v], G[v], B[v]);
  }

  if ((rc = pm_bitfini(b)) != 0) {
    return -1;
  }

  /*
   * Make sure we read a multiple of 4 bytes.
   */
  while (nbyte % 4) {
    GetByte(fp);
    nbyte++;
  }

  *ppos += nbyte;
  return nbyte;
}

staticfnc pixel **
  BMPreadbits(fp, ppos, offBits, cx, cy, cBitCount, class, R, G, B)
    FILE *fp;
    unsigned long *ppos;					/* number of bytes read from fp */
    unsigned long offBits;
    unsigned long cx;
    unsigned long cy;
    unsigned short cBitCount;
    int class;
    pixval *R;
    pixval *G;
    pixval *B;
{
  pixel **pixels;						/* output */
  long y;

  readto(fp, ppos, offBits);

  pixels = ppm_allocarray(cx, cy);

  if (cBitCount > 24) {
    pm_error("%s: cannot handle cBitCount: %d"
	     ,ifname
	     ,cBitCount);
  }

  /*
   * The picture is stored bottom line first, top line last
   */

  for (y = cy - 1; y >= 0; y--) {
    int rc;

    rc = BMPreadrow(fp, ppos, pixels[y], cx, cBitCount, R, G, B);

    if (rc == -1) {
      pm_error("%s: couldn't read row %d"
	       ,ifname
	       ,y);
    }
    if (rc % 4) {
      pm_error("%s: row had bad number of bytes: %d"
	       ,ifname
	       ,rc);
    }
  }

  return pixels;
}

int main(argc, argv)
    int argc;
    char **argv;
{
  FILE *ifp = stdin;
  char *usage = "[bmpfile]";
  int argn;

  int rc;
  unsigned long pos = 0;

  unsigned long offBits;

  unsigned long cx;
  unsigned long cy;
  unsigned short cBitCount;
  int class;

  pixval R[MAXCOLORS];						/* reds */
  pixval G[MAXCOLORS];						/* greens */
  pixval B[MAXCOLORS];						/* blues */

  pixel **pixels;

  ppm_init(&argc, argv);

  /*
   * Since this command takes no flags, produce an error message
   * if the user tries to give any.
   * This is friendlier than if the command were to say
   * 'no such file: -help'.
   */

  argn = 1;
  while (argn < argc && argv[argn][0] == '-' && argv[argn][1] != '\0') {
    pm_usage(usage);
    ++argn;
  }

  if (argn < argc) {
    ifname = argv[argn];
    ifp = pm_openr(ifname);
    ++argn;
  }
  else {
    ifname = "standard input";
    ifp = stdin;
  }

  if (argn != argc) {
    pm_usage(usage);
  }

  BMPreadfileheader(ifp, &pos, &offBits);
  BMPreadinfoheader(ifp, &pos, &cx, &cy, &cBitCount, &class);

  if (offBits != BMPoffbits(class, cBitCount)) {
    pm_message("warning: offBits is %d, expected %d"
	       ,pos
	       ,BMPoffbits(class, cBitCount));
  }

  rc = BMPreadrgbtable(ifp, &pos, cBitCount, class, R, G, B);

  if (rc != BMPlenrgbtable(class, cBitCount)) {
    pm_message("warning: %d-byte RGB table, expected %d bytes"
	       ,rc
	       ,BMPlenrgbtable(class, cBitCount));
  }

  pixels = BMPreadbits(ifp, &pos, offBits, cx, cy
		       ,cBitCount, class, R, G, B);

  if (pos != BMPlenfile(class, cBitCount, cx, cy)) {
    pm_message("warning: read %d bytes, expected to read %d bytes"
	       ,pos
	       ,BMPlenfile(class, cBitCount, cx, cy));
  }

  pm_close(ifp);
  ppm_writeppm(stdout, pixels, cx, cy, (pixval) (MAXCOLORS - 1), 0);
  pm_close(stdout);

  exit(0);
}

/*\
 * $Id: ppmtobmp.c,v 1.9 1992/11/24 19:39:33 dws Exp dws $
 *
 * ppmtobmp.c - Converts from a PPM file to a Microsoft Windows or OS/2
 * .BMP file.
 *
 * The current implementation is probably not complete, but it works for
 * me.  I welcome feedback.
 *
 * Copyright (C) 1992 by David W. Sanderson.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted,
 * provided that the above copyright notice appear in all copies and
 * that both that copyright notice and this permission notice appear
 * in supporting documentation.  This software is provided "as is"
 * without express or implied warranty.
 *
 * $Log: ppmtobmp.c,v $
 * Revision 1.9  1992/11/24  19:39:33  dws
 * Added copyright.
 *
 * Revision 1.8  1992/11/17  02:16:52  dws
 * Moved length functions to bmp.h.
 *
 * Revision 1.7  1992/11/11  23:18:16  dws
 * Modified to adjust the bits per pixel to 1, 4, or 8.
 *
 * Revision 1.6  1992/11/11  22:43:39  dws
 * Commented out a superfluous message.
 *
 * Revision 1.5  1992/11/11  05:58:06  dws
 * First version that works.
 *
 * Revision 1.4  1992/11/11  03:40:32  dws
 * Moved calculation of bits per pixel to BMPEncode.
 *
 * Revision 1.3  1992/11/11  03:02:34  dws
 * Added BMPEncode function.
 *
 * Revision 1.2  1992/11/08  01:44:35  dws
 * Added option processing and reading of PPM file.
 *
 * Revision 1.1  1992/11/08  00:46:07  dws
 * Initial revision
 \*/

#define MAXCOLORS 256

/*
 * Utilities
 */

static char er_write[] = "stdout: write error";

/* prototypes */
staticfnc void PutByte ARGS((FILE * fp, char v));
staticfnc void PutShort ARGS((FILE * fp, short v));
staticfnc void PutLong ARGS((FILE * fp, long v));
staticfnc int BMPwritefileheader ARGS((FILE * fp, int class, unsigned long bitcount,
				    unsigned long x, unsigned long y));
staticfnc int BMPwriteinfoheader ARGS((FILE * fp, int class, unsigned long bitcount,
				    unsigned long x, unsigned long y));
staticfnc int BMPwritergb ARGS((FILE * fp, int class, pixval R, pixval G, pixval B));
staticfnc int BMPwritergbtable ARGS((FILE * fp, int class, int bpp, int colors,
				  pixval * R, pixval * G, pixval * B));
staticfnc int BMPwriterow ARGS((FILE * fp, pixel * row, unsigned long cx,
			     unsigned short bpp, colorhash_table cht));
staticfnc int BMPwritebits ARGS((FILE * fp, unsigned long cx, unsigned long cy,
	     unsigned short cBitCount, pixel ** pixels, colorhash_table cht));
staticfnc int colorstobpp ARGS((int colors));
staticfnc void BMPEncode ARGS((FILE * fp, int class, int x, int y, pixel ** pixels,
	int colors, colorhash_table cht, pixval * R, pixval * G, pixval * B));
staticfnc void PutByte(fp, v)
    FILE *fp;
    char v;
{
  if (putc(v, fp) == EOF) {
    pm_error(er_write);
  }
}

staticfnc void PutShort(fp, v)
    FILE *fp;
    short v;
{
  if (pm_writelittleshort(fp, v) == -1) {
    pm_error(er_write);
  }
}

staticfnc void PutLong(fp, v)
    FILE *fp;
    long v;
{
  if (pm_writelittlelong(fp, v) == -1) {
    pm_error(er_write);
  }
}

/*
 * BMP writing
 */

/*
 * returns the number of bytes written, or -1 on error.
 */
staticfnc int BMPwritefileheader(fp, class, bitcount, x, y)
    FILE *fp;
    int class;
    unsigned long bitcount;
    unsigned long x;
    unsigned long y;
{
  PutByte(fp, 'B');
  PutByte(fp, 'M');

  /* cbSize */
  PutLong(fp, BMPlenfile(class, bitcount, x, y));

  /* xHotSpot */
  PutShort(fp, 0);

  /* yHotSpot */
  PutShort(fp, 0);

  /* offBits */
  PutLong(fp, BMPoffbits(class, bitcount));

  return 14;
}

/*
 * returns the number of bytes written, or -1 on error.
 */
staticfnc int BMPwriteinfoheader(fp, class, bitcount, x, y)
    FILE *fp;
    int class;
    unsigned long bitcount;
    unsigned long x;
    unsigned long y;
{
  long cbFix;

  /* cbFix */
  switch (class) {
    case C_WIN:
      cbFix = 40;
      PutLong(fp, cbFix);

      /* cx */
      PutLong(fp, x);
      /* cy */
      PutLong(fp, y);
      /* cPlanes */
      PutShort(fp, 1);
      /* cBitCount */
      PutShort(fp, bitcount);

      /*
       * We've written 16 bytes so far, need to write 24 more
       * for the required total of 40.
       */

      PutLong(fp, 0);
      PutLong(fp, 0);
      PutLong(fp, 0);
      PutLong(fp, 0);
      PutLong(fp, 0);
      PutLong(fp, 0);

      break;
    case C_OS2:
      cbFix = 12;
      PutLong(fp, cbFix);

      /* cx */
      PutShort(fp, x);
      /* cy */
      PutShort(fp, y);
      /* cPlanes */
      PutShort(fp, 1);
      /* cBitCount */
      PutShort(fp, bitcount);

      break;
    default:
      pm_error(er_internal, "BMPwriteinfoheader");
  }

  return cbFix;
}

/*
 * returns the number of bytes written, or -1 on error.
 */
staticfnc int BMPwritergb(fp, class, R, G, B)
    FILE *fp;
    int class;
    pixval R;
    pixval G;
    pixval B;
{
  switch (class) {
    case C_WIN:
      PutByte(fp, B);
      PutByte(fp, G);
      PutByte(fp, R);
      PutByte(fp, 0);
      return 4;
    case C_OS2:
      PutByte(fp, B);
      PutByte(fp, G);
      PutByte(fp, R);
      return 3;
    default:
      pm_error(er_internal, "BMPwritergb");
  }
  return -1;
}

/*
 * returns the number of bytes written, or -1 on error.
 */
staticfnc int BMPwritergbtable(fp, class, bpp, colors, R, G, B)
    FILE *fp;
    int class;
    int bpp;
    int colors;
    pixval *R;
    pixval *G;
    pixval *B;
{
  int nbyte = 0;
  int i;
  long ncolors;

  for (i = 0; i < colors; i++) {
    nbyte += BMPwritergb(fp, class, R[i], G[i], B[i]);
  }

  ncolors = (1 << bpp);

  for (; i < ncolors; i++) {
    nbyte += BMPwritergb(fp, class, 0, 0, 0);
  }

  return nbyte;
}

/*
 * returns the number of bytes written, or -1 on error.
 */
staticfnc int BMPwriterow(fp, row, cx, bpp, cht)
    FILE *fp;
    pixel *row;
    unsigned long cx;
    unsigned short bpp;
    colorhash_table cht;
{
  BITSTREAM b;
  unsigned nbyte = 0;
  int rc;
  unsigned x;

  if ((b = pm_bitinit(fp, "w")) == (BITSTREAM) 0) {
    return -1;
  }

  for (x = 0; x < cx; x++, row++) {
    if ((rc = pm_bitwrite(b, bpp, ppm_lookupcolor(cht, row))) == -1) {
      return -1;
    }
    nbyte += rc;
  }

  if ((rc = pm_bitfini(b)) == -1) {
    return -1;
  }
  nbyte += rc;

  /*
   * Make sure we write a multiple of 4 bytes.
   */
  while (nbyte % 4) {
    PutByte(fp, 0);
    nbyte++;
  }

  return nbyte;
}

/*
 * returns the number of bytes written, or -1 on error.
 */
staticfnc int BMPwritebits(fp, cx, cy, cBitCount, pixels, cht)
    FILE *fp;
    unsigned long cx;
    unsigned long cy;
    unsigned short cBitCount;
    pixel **pixels;
    colorhash_table cht;
{
  int nbyte = 0;
  long y;

  if (cBitCount > 24) {
    pm_error("cannot handle cBitCount: %d"
	     ,cBitCount);
  }

  /*
   * The picture is stored bottom line first, top line last
   */

  for (y = cy - 1; y >= 0; y--) {
    int rc;

    rc = BMPwriterow(fp, pixels[y], cx, cBitCount, cht);

    if (rc == -1) {
      pm_error("couldn't write row %d"
	       ,y);
    }
    if (rc % 4) {
      pm_error("row had bad number of bytes: %d"
	       ,rc);
    }
    nbyte += rc;
  }

  return nbyte;
}

/*
 * Return the number of bits per pixel required to represent the
 * given number of colors.
 */

staticfnc int colorstobpp(colors)
    int colors;
{
  int bpp;

  if (colors < 1) {
    pm_error("can't have less than one color");
  }

  if ((bpp = pm_maxvaltobits(colors - 1)) > 8) {
    pm_error("can't happen");
  }

  return bpp;
}

/*
 * Write a BMP file of the given class.
 *
 * Note that we must have 'colors' in order to know exactly how many
 * colors are in the R, G, B, arrays.  Entries beyond those in the
 * arrays are undefined.
 */
staticfnc void BMPEncode(fp, class, x, y, pixels, colors, cht, R, G, B)
    FILE *fp;
    int class;
    int x;
    int y;
    pixel **pixels;
    int colors;							/* number of valid entries in R,G,B */
    colorhash_table cht;
    pixval *R;
    pixval *G;
    pixval *B;
{
  int bpp;							/* bits per pixel */
  unsigned long nbyte = 0;

  bpp = colorstobpp(colors);

  /*
   * I have found empirically at least one BMP-displaying program
   * that can't deal with (for instance) using 3 bits per pixel.
   * I have seen no programs that can deal with using 3 bits per
   * pixel.  I have seen programs which can deal with 1, 4, and
   * 8 bits per pixel.
   *
   * Based on this, I adjust actual the number of bits per pixel
   * as follows.  If anyone knows better, PLEASE tell me!
   */
  switch (bpp) {
    case 2:
    case 3:
      bpp = 4;
      break;
    case 5:
    case 6:
    case 7:
      bpp = 8;
      break;
  }

  pm_message("Using %d bits per pixel", bpp);

  nbyte += BMPwritefileheader(fp, class, bpp, x, y);
  nbyte += BMPwriteinfoheader(fp, class, bpp, x, y);
  nbyte += BMPwritergbtable(fp, class, bpp, colors, R, G, B);

  if (nbyte != (BMPlenfileheader(class)
		+ BMPleninfoheader(class)
		+ BMPlenrgbtable(class, bpp))) {
    pm_error(er_internal, "BMPEncode");
  }

  nbyte += BMPwritebits(fp, x, y, bpp, pixels, cht);
  if (nbyte != BMPlenfile(class, bpp, x, y)) {
    pm_error(er_internal, "BMPEncode");
  }
}

int main(argc, argv)
    int argc;
    char **argv;
{
  FILE *ifp = stdin;
  char *usage = "[-windows] [-os2] [ppmfile]";
  int class = C_OS2;

  int argn;
  int rows;
  int cols;
  int colors;
  int i;
  pixval maxval;
  colorhist_vector chv;
  pixval Red[MAXCOLORS];
  pixval Green[MAXCOLORS];
  pixval Blue[MAXCOLORS];

  pixel **pixels;
  colorhash_table cht;

  ppm_init(&argc, argv);

  argn = 1;

  while (argn < argc && argv[argn][0] == '-' && argv[argn][1] != '\0') {
    if (pm_keymatch(argv[argn], "-windows", 2))
      class = C_WIN;
    else if (pm_keymatch(argv[argn], "-os2", 2))
      class = C_OS2;
    else
      pm_usage(usage);
    ++argn;
  }

  if (argn < argc) {
    ifp = pm_openr(argv[argn]);
    ++argn;
  }

  if (argn != argc) {
    pm_usage(usage);
  }

  pixels = ppm_readppm(ifp, &cols, &rows, &maxval);

  pm_close(ifp);

  /* Figure out the colormap. */
  pm_message("computing colormap...");
  chv = ppm_computecolorhist(pixels, cols, rows, MAXCOLORS, &colors);
  if (chv == (colorhist_vector) 0)
    pm_error("too many colors - try doing a 'ppmquant %d'"
	     ,MAXCOLORS);
  pm_message("%d colors found", colors);

  /*
   * Now turn the ppm colormap into the appropriate GIF
   * colormap.
   */
  if (maxval > 255) {
    pm_message("maxval is not 255 - automatically rescaling colors");
  }
  for (i = 0; i < colors; ++i) {
    if (maxval == 255) {
      Red[i] = PPM_GETR(chv[i].color);
      Green[i] = PPM_GETG(chv[i].color);
      Blue[i] = PPM_GETB(chv[i].color);
    }
    else {
      Red[i] = (pixval) PPM_GETR(chv[i].color) * 255 / maxval;
      Green[i] = (pixval) PPM_GETG(chv[i].color) * 255 / maxval;
      Blue[i] = (pixval) PPM_GETB(chv[i].color) * 255 / maxval;
    }
  }

  /* And make a hash table for fast lookup. */
  cht = ppm_colorhisttocolorhash(chv, colors);
  ppm_freecolorhist(chv);

  /* All set, let's do it. */
  BMPEncode(stdout, class
	    ,cols, rows, pixels, colors, cht
	    ,Red, Green, Blue);

  pm_close(stdout);

  exit(0);
}
