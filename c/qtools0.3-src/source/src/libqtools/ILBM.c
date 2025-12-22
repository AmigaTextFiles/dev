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

#define	LIBQTOOLS_CORE
#include "../include/libqtools.h"

/* ilbmtoppm.c - read an IFF ILBM file and produce a portable pixmap
 *
 * Copyright (C) 1989 by Jef Poskanzer.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted, provided
 * that the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation.  This software is provided "as is" without express or
 * implied warranty.
 *
 * Modified by Mark Thompson on 10/4/90 to accomodate 24 bit IFF files
 * as used by ASDG, NewTek, etc.
 *
 * Modified by Ingo Wilken (Ingo.Wilken@informatik.uni-oldenburg.de)
 *  20/Jun/93:
 *  - row-by-row operation
 *  - better de-interleave algorithm
 *  - colormap files
 *  - direct color
 *  04/Oct/93:
 *  - multipalette support (PCHG chunk)
 *  - options -ignore, -isham, -isehb and -adjustcolors
 */

/* prototypes */
staticfnc void getfourchars ARGS((FILE * f, char fourchars[4]));
staticfnc unsigned char get_byte ARGS((FILE * f));
staticfnc long get_big_long ARGS((FILE * f));
staticfnc short get_big_short ARGS((FILE * f));
staticfnc void readerr ARGS((FILE * f));

staticfnc void skip_chunk ARGS((FILE * f, long chunksize));
staticfnc void display_chunk ARGS((FILE * ifp, char *iffid, long chunksize));
staticfnc pixel *read_colormap ARGS((FILE * f, long colors));
staticfnc BitMapHeader *read_bmhd ARGS((FILE * f));
staticfnc PCHGInfo *read_pchg ARGS((FILE * ifp, unsigned long chunksize));

staticfnc void ham_to_ppm ARGS((FILE * ifp, BitMapHeader * bmhd, pixel * colormap, int colors, PCHGInfo * pchginfo));
staticfnc void deep_to_ppm ARGS((FILE * ifp, BitMapHeader * bmhd));
staticfnc void cmap_to_ppm ARGS((pixel * colormap, int colors));
staticfnc void std_to_ppm ARGS((FILE * ifp, BitMapHeader * bmhd, pixel * colormap, int colors, PCHGInfo * pchginfo, long viewportmodes));
staticfnc void direct_to_ppm ARGS((FILE * ifp, BitMapHeader * bmhd, DirectColor * dcol));

staticfnc void init_pchg ARGS((PCHGInfo * pchginfo, pixel * colormap, int colors, pixval newmaxval));
staticfnc void adjust_colormap ARGS((PCHGInfo * pchginfo, int row));
staticfnc void scale_colormap ARGS((pixel * colormap, int colors, pixval oldmaxval, pixval newmaxval));
staticfnc pixel *ehb_to_cmap ARGS((pixel * colormap, int *colors));
staticfnc void read_ilbm_plane ARGS((FILE * ifp, int cols, int compression));
staticfnc void decode_row ARGS((FILE * ifp, rawtype * chunkyrow, int planes, BitMapHeader * bmhd));

staticfnc rawtype *alloc_rawrow ARGS((int cols));
staticfnc void *xmalloc ARGS((int bytes));

#define MALLOC(n, type)     (type *)tmalloc((n) * sizeof(type))

static short verbose = 0;
static short adjustcolors = 0;
static unsigned char *ilbmrow;
static pixel *pixelrow;

struct rawpic *LoadILBM(HANDLE ilbmFile, int flags, int ignore)
{
  FILE *ifp;
  pixel *colormap = 0;
  int argn, colors;
  char iffid[5];
  short body = 0;
  long formsize, bytesread, chunksize, viewportmodes = 0, fakeviewport = 0;
  char *usage = "[-verbose] [-ignore <chunkID>] [-isham|-isehb] [-adjustcolors] [ilbmfile]";
  BitMapHeader *bmhd = NULL;
  DirectColor *dcol = NULL;
  PCHGInfo *pchginfo = NULL;

#define MAX_IGNORE  16
  char *ignorelist[MAX_IGNORE];
  int ignorecount = 0;

  ppm_init(&argc, argv);

  argn = 1;
  while (argn < argc && argv[argn][0] == '-' && argv[argn][1] != '\0') {
    if (pm_keymatch(argv[argn], "-verbose", 2))
      verbose = 1;
    else if (pm_keymatch(argv[argn], "-noverbose", 4))
      verbose = 0;
    else if (pm_keymatch(argv[argn], "-isham", 4))
      fakeviewport |= vmHAM;
    else if (pm_keymatch(argv[argn], "-isehb", 4))
      fakeviewport |= vmEXTRA_HALFBRITE;
    else if (pm_keymatch(argv[argn], "-adjustcolors", 2))
      adjustcolors = 1;
    else if (pm_keymatch(argv[argn], "-noadjustcolors", 4))
      adjustcolors = 0;
    else if (pm_keymatch(argv[argn], "-ignore", 2)) {
      if (++argn >= argc)
	pm_usage(usage);
      if (strlen(argv[argn]) != 4)
	pm_error("\"-ignore\" option needs a 4 byte chunk ID string as argument");
      if (ignorecount >= MAX_IGNORE)
	pm_error("max %d chunk IDs to ignore", MAX_IGNORE);
      ignorelist[ignorecount++] = argv[argn];
    }
    else
      pm_usage(usage);
    ++argn;
  }

  if (argn < argc) {
    ifp = pm_openr(argv[argn]);
    argn++;
  }
  else
    ifp = stdin;

  if (argn != argc)
    pm_usage(usage);

  /* Read in the ILBM file. */
  iffid[4] = '\0';
  getfourchars(ifp, iffid);
  if (strcmp(iffid, "FORM") != 0)
    pm_error("input is not a FORM type IFF file");
  formsize = get_big_long(ifp);
  getfourchars(ifp, iffid);
  if (strcmp(iffid, "ILBM") != 0)
    pm_error("input is not an ILBM type FORM IFF file");
  bytesread = 4;						/* FORM and formsize do not count */

  /* Main loop, parsing the IFF FORM. */
  while (bytesread < formsize) {
    short i, ignore = 0;

    getfourchars(ifp, iffid);
    chunksize = get_big_long(ifp);
    bytesread += 8;

    for (i = 0; i < ignorecount && !ignore; i++) {
      if (strcmp(ignorelist[i], iffid) == 0)
	ignore = 1;
    }

    if (ignore) {
      ignore = 0;
      pm_message("ignoring \"%s\" chunk", iffid);
      skip_chunk(ifp, chunksize);
    }
    else if (body != 0) {
      pm_message("\"%s\" chunk found after BODY chunk - skipping", iffid);
      skip_chunk(ifp, chunksize);
    }
    else if (strcmp(iffid, "BMHD") == 0) {
      if (chunksize != BitMapHeaderSize)
	pm_error("BMHD chunk size mismatch");
      bmhd = read_bmhd(ifp);
    }
    else if (strcmp(iffid, "CMAP") == 0) {
      colors = chunksize / 3;
      if (colors == 0) {
	pm_error("warning - empty colormap");
	skip_chunk(ifp, chunksize);
      }
      else {
	long r = 3 * colors;

	colormap = read_colormap(ifp, colors);
	while (r++ < chunksize)
	  (void)get_byte(ifp);
      }
    }
    else if (strcmp(iffid, "CAMG") == 0) {
      if (chunksize != CAMGChunkSize)
	pm_error("CAMG chunk size mismatch");
      viewportmodes = get_big_long(ifp);
    }
    else if (strcmp(iffid, "DCOL") == 0) {
      if (chunksize != DirectColorSize)
	pm_error("DCOL chunk size mismatch");
      dcol = MALLOC(1, DirectColor);
      dcol->r = get_byte(ifp);
      dcol->g = get_byte(ifp);
      dcol->b = get_byte(ifp);
      (void)get_byte(ifp);
    }
    else if (strcmp(iffid, "PCHG") == 0) {
      pchginfo = read_pchg(ifp, chunksize);
    }
    else if (strcmp(iffid, "BODY") == 0) {
      if (bmhd == NULL)
	pm_error("\"BODY\" chunk without \"BMHD\" chunk");

      ilbmrow = MALLOC(RowBytes(bmhd->w), unsigned char);

      pixelrow = ppm_allocrow(bmhd->w);

      viewportmodes |= fakeviewport;

      if (viewportmodes & vmHAM)
	ham_to_ppm(ifp, bmhd, colormap, colors, pchginfo);
      else if (dcol != NULL)
	direct_to_ppm(ifp, bmhd, dcol);
      else if (bmhd->nPlanes == 24)
	deep_to_ppm(ifp, bmhd);
      else
	std_to_ppm(ifp, bmhd, colormap, colors, pchginfo, viewportmodes);
      body = 1;
    }
    else if (strcmp(iffid, "GRAB") == 0 || strcmp(iffid, "DEST") == 0 ||
	     strcmp(iffid, "SPRT") == 0 || strcmp(iffid, "CRNG") == 0 ||
	     strcmp(iffid, "CCRT") == 0 || strcmp(iffid, "CLUT") == 0 ||
	     strcmp(iffid, "DPPV") == 0 || strcmp(iffid, "DRNG") == 0 ||
	     strcmp(iffid, "EPSF") == 0) {
      skip_chunk(ifp, chunksize);
    }
    else if (strcmp(iffid, "(c) ") == 0 || strcmp(iffid, "AUTH") == 0 ||
	     strcmp(iffid, "NAME") == 0 || strcmp(iffid, "ANNO") == 0 ||
	     strcmp(iffid, "TEXT") == 0) {
      if (verbose)
	display_chunk(ifp, iffid, chunksize);
      else
	skip_chunk(ifp, chunksize);
    }
    else if (strcmp(iffid, "DPI ") == 0) {
      int x, y;

      x = get_big_short(ifp);
      y = get_big_short(ifp);
      if (verbose)
	pm_message("\"DPI \" chunk:  dpi_x = %d    dpi_y = %d", x, y);
    }
    else {
      pm_message("unknown chunk type \"%s\" - skipping", iffid);
      skip_chunk(ifp, chunksize);
    }

    bytesread += chunksize;
    if (odd(chunksize)) {
      (void)get_byte(ifp);
      ++bytesread;
    }
  }
  pm_close(ifp);

  if (body == 0) {
    if (colormap)
      cmap_to_ppm(colormap, colors);
    else
      pm_error("no \"BODY\" or \"CMAP\" chunk found");
  }

  if (bytesread != formsize) {
    pm_message("warning - file length (%ld bytes) does not match FORM size field (%ld bytes) +8",
	       bytesread, formsize);
  }

  exit(0);
}

staticfnc void readerr(f)
    FILE *f;
{
  if (ferror(f))
    pm_error("read error");
  else
    pm_error("premature EOF");
}

staticfnc unsigned char get_byte(ifp)
    FILE *ifp;
{
  int i;

  i = getc(ifp);
  if (i == EOF)
    readerr(ifp);

  return (unsigned char)i;
}

staticfnc void getfourchars(ifp, fourchars)
    FILE *ifp;
    char fourchars[4];
{
  fourchars[0] = get_byte(ifp);
  fourchars[1] = get_byte(ifp);
  fourchars[2] = get_byte(ifp);
  fourchars[3] = get_byte(ifp);
}

staticfnc long get_big_long(ifp)
    FILE *ifp;
{
  long l;

  if (pm_readbiglong(ifp, &l) == -1)
    readerr(ifp);

  return l;
}

staticfnc short get_big_short(ifp)
    FILE *ifp;
{
  short s;

  if (pm_readbigshort(ifp, &s) == -1)
    readerr(ifp);

  return s;
}

staticfnc void skip_chunk(ifp, chunksize)
    FILE *ifp;
    long chunksize;
{
  int i;

  for (i = 0; i < chunksize; i++)
    (void)get_byte(ifp);
}

staticfnc pixel *
  read_colormap(ifp, colors)
    FILE *ifp;
    long colors;
{
  pixel *colormap;
  int i, r, g, b;
  pixval colmaxval = 0;

  colormap = ppm_allocrow(colors);
  for (i = 0; i < colors; i++) {
    r = get_byte(ifp);
    if (r > colmaxval)
      colmaxval = r;
    g = get_byte(ifp);
    if (g > colmaxval)
      colmaxval = g;
    b = get_byte(ifp);
    if (b > colmaxval)
      colmaxval = b;
    PPM_ASSIGN(colormap[i], r, g, b);
  }
#ifdef DEBUG
  pm_message("colormap maxval is %d", colmaxval);
#endif
  if (colmaxval == 0)
    pm_message("warning - black colormap");
  else if (colmaxval <= 15) {
    if (!adjustcolors) {
      pm_message("warning - probably 4 bit colormap");
      pm_message("use \"-adjustcolors\" to scale colormap to 8 bits");
    }
    else {
      pm_message("scaling colormap to 8 bits");
      scale_colormap(colormap, colors, 15, MAXCOLVAL);
    }
  }
  return colormap;
}

staticfnc BitMapHeader *
  read_bmhd(ifp)
    FILE *ifp;
{
  BitMapHeader *bmhd;

  bmhd = MALLOC(1, BitMapHeader);

  bmhd->w = get_big_short(ifp);					/* cols */
  bmhd->h = get_big_short(ifp);					/* rows */
  bmhd->x = get_big_short(ifp);
  bmhd->y = get_big_short(ifp);
  bmhd->nPlanes = get_byte(ifp);
  bmhd->masking = get_byte(ifp);
  bmhd->compression = get_byte(ifp);
  bmhd->pad1 = get_byte(ifp);					/* (ignored) */
  bmhd->transparentColor = get_big_short(ifp);
  bmhd->xAspect = get_byte(ifp);
  bmhd->yAspect = get_byte(ifp);
  bmhd->pageWidth = get_big_short(ifp);
  bmhd->pageHeight = get_big_short(ifp);

  if (verbose) {
    pm_message("dimensions: %dx%d", bmhd->w, bmhd->h);
    pm_message("BODY compression: %s", bmhd->compression <= cmpMAXKNOWN ?
	       cmpNAME[bmhd->compression] : "unknown");
  }

  /* fix aspect ratio */
  if (bmhd->xAspect == 0) {
    if (bmhd->yAspect == 0) {
      pm_message("warning - xAspect:yAspect = 0:0, using 1:1");
      bmhd->xAspect = bmhd->yAspect = 1;
    }
    else {
      pm_message("warning - xAspect = 0, setting to yAspect");
      bmhd->xAspect = bmhd->yAspect;
    }
  }
  else {
    if (bmhd->yAspect == 0) {
      pm_message("warning - yAspect = 0, setting to xAspect");
      bmhd->yAspect = bmhd->xAspect;
    }
  }
  if (bmhd->xAspect != bmhd->yAspect) {
    pm_message("warning - non-square pixels; to fix do a 'pnmscale -%cscale " VEC_CONV1D "'",
	       bmhd->xAspect > bmhd->yAspect ? 'x' : 'y',
	       bmhd->xAspect > bmhd->yAspect ? (vec1D)(bmhd->xAspect) / bmhd->yAspect : (vec1D)(bmhd->yAspect) / bmhd->xAspect);
  }

  return bmhd;
}

staticfnc void ham_to_ppm(ifp, bmhd, colormap, colors, pchginfo)
    FILE *ifp;
    BitMapHeader *bmhd;
    pixel *colormap;
    int colors;
    PCHGInfo *pchginfo;
{
  int cols, rows, hambits, hammask, col, row;
  pixval maxval;
  rawtype *rawrow;
  int pchgflag = (pchginfo && colormap);

  cols = bmhd->w;
  rows = bmhd->h;
  hambits = bmhd->nPlanes - 2;
  hammask = (1 << hambits) - 1;

  pm_message("input is a %sHAM%d file", pchgflag ? "multipalette " : "", bmhd->nPlanes);

  if (hambits > MAXPLANES)
    pm_error("too many planes (max %d)", MAXPLANES);
  if (hambits < 0) {
    pm_message("HAM requires 2 or more planes");
    pm_error("try \"-ignore CAMG\" to treat this file as a normal ILBM");
  }

  maxval = pm_bitstomaxval(hambits);
  if (maxval > PPM_MAXMAXVAL)
    pm_error("nPlanes is too large - try reconfiguring with PGM_BIGGRAYS\n    or without PPM_PACKCOLORS");

  /* scale colormap to new maxval */
  if (colormap && maxval != MAXCOLVAL)
    scale_colormap(colormap, colors, MAXCOLVAL, maxval);

  if (pchgflag)
    init_pchg(pchginfo, colormap, colors, maxval);

  rawrow = alloc_rawrow(cols);

  ppm_writeppminit(stdout, cols, rows, maxval, 0);
  for (row = 0; row < rows; row++) {
    pixval r, g, b;

    if (pchgflag)
      adjust_colormap(pchginfo, row);

    decode_row(ifp, rawrow, bmhd->nPlanes, bmhd);

    r = g = b = 0;
    for (col = 0; col < cols; col++) {
      switch ((rawrow[col] >> hambits) & 0x03) {
	case HAMCODE_CMAP:
	  if (colormap && colors >= maxval)
	    pixelrow[col] = colormap[rawrow[col] & hammask];
	  else
	    PPM_ASSIGN(pixelrow[col], rawrow[col] & hammask,
		       rawrow[col] & hammask, rawrow[col] & hammask);
	  r = PPM_GETR(pixelrow[col]);
	  g = PPM_GETG(pixelrow[col]);
	  b = PPM_GETB(pixelrow[col]);
	  break;
	case HAMCODE_BLUE:
	  b = rawrow[col] & hammask;
	  PPM_ASSIGN(pixelrow[col], r, g, b);
	  break;
	case HAMCODE_RED:
	  r = rawrow[col] & hammask;
	  PPM_ASSIGN(pixelrow[col], r, g, b);
	  break;
	case HAMCODE_GREEN:
	  g = rawrow[col] & hammask;
	  PPM_ASSIGN(pixelrow[col], r, g, b);
	  break;
	default:
	  pm_error("impossible HAM code");
      }
    }
    ppm_writeppmrow(stdout, pixelrow, cols, (pixval) maxval, 0);
  }
}

staticfnc void deep_to_ppm(ifp, bmhd)
    FILE *ifp;
    BitMapHeader *bmhd;
{
  int cols, rows, col, row;
  rawtype *Rrow, *Grow, *Brow;

  cols = bmhd->w;
  rows = bmhd->h;

  pm_message("input is a deep (24bit) ILBM");

  Rrow = alloc_rawrow(cols);
  Grow = alloc_rawrow(cols);
  Brow = alloc_rawrow(cols);

  ppm_writeppminit(stdout, cols, rows, MAXCOLVAL, 0);
  for (row = 0; row < rows; row++) {
    decode_row(ifp, Rrow, 8, bmhd);
    decode_row(ifp, Grow, 8, bmhd);
    decode_row(ifp, Brow, 8, bmhd);
    for (col = 0; col < cols; col++)
      PPM_ASSIGN(pixelrow[col], Rrow[col], Grow[col], Brow[col]);
    ppm_writeppmrow(stdout, pixelrow, cols, MAXCOLVAL, 0);
  }
  pm_close(stdout);
}

staticfnc void direct_to_ppm(ifp, bmhd, dcol)
    FILE *ifp;
    BitMapHeader *bmhd;
    DirectColor *dcol;
{
  int cols, rows, col, row, redplanes, greenplanes, blueplanes;
  rawtype *Rrow, *Grow, *Brow;
  pixval maxval, redmaxval, greenmaxval, bluemaxval;
  int scale;

  cols = bmhd->w;
  rows = bmhd->h;

  redplanes = dcol->r;
  greenplanes = dcol->g;
  blueplanes = dcol->b;

  pm_message("input is a %d:%d:%d direct color ILBM",
	     redplanes, greenplanes, blueplanes);

  if (redplanes > MAXPLANES || blueplanes > MAXPLANES || greenplanes > MAXPLANES)
    pm_error("too many planes (max %d per color)", MAXPLANES);

  if (bmhd->nPlanes != (redplanes + greenplanes + blueplanes))
    pm_error("BMHD/DCOL plane number mismatch");

  if (redplanes == blueplanes && redplanes == greenplanes) {
    scale = 0;
    maxval = pm_bitstomaxval(redplanes);
  }
  else {
    scale = 1;
    redmaxval = pm_bitstomaxval(redplanes);
    greenmaxval = pm_bitstomaxval(greenplanes);
    bluemaxval = pm_bitstomaxval(blueplanes);

    maxval = max(redmaxval, max(greenmaxval, bluemaxval));
    pm_message("rescaling colors to %d bits", pm_maxvaltobits(maxval));
  }

  if (maxval > PPM_MAXMAXVAL)
    pm_error("too many planes - try reconfiguring with PGM_BIGGRAYS\n    or without PPM_PACKCOLORS");

  Rrow = alloc_rawrow(cols);
  Grow = alloc_rawrow(cols);
  Brow = alloc_rawrow(cols);

  ppm_writeppminit(stdout, cols, rows, maxval, 0);
  for (row = 0; row < rows; row++) {
    decode_row(ifp, Rrow, dcol->r, bmhd);
    decode_row(ifp, Grow, dcol->g, bmhd);
    decode_row(ifp, Brow, dcol->b, bmhd);

    if (scale) {
      for (col = 0; col < cols; col++) {
	PPM_ASSIGN(pixelrow[col],
		   Rrow[col] * maxval / redmaxval,
		   Grow[col] * maxval / greenmaxval,
		   Brow[col] * maxval / bluemaxval);
      }
    }
    else {
      for (col = 0; col < cols; col++)
	PPM_ASSIGN(pixelrow[col], Rrow[col], Grow[col], Brow[col]);
    }
    ppm_writeppmrow(stdout, pixelrow, cols, maxval, 0);
  }
  pm_close(stdout);
}

staticfnc void cmap_to_ppm(colormap, colors)
    pixel *colormap;
    int colors;
{
  pm_message("input is a colormap file");

  ppm_writeppminit(stdout, colors, 1, MAXCOLVAL, 0);
  ppm_writeppmrow(stdout, colormap, colors, MAXCOLVAL, 0);
  pm_close(stdout);
}

staticfnc void std_to_ppm(ifp, bmhd, colormap, colors, pchginfo, viewportmodes)
    FILE *ifp;
    BitMapHeader *bmhd;
    pixel *colormap;
    int colors;
    PCHGInfo *pchginfo;
    long viewportmodes;
{
  rawtype *rawrow;
  pixval maxval;
  int row, rows, col, cols;
  int pchgflag = (pchginfo && colormap);

  cols = bmhd->w;
  rows = bmhd->h;

  pm_message("input is a %d-plane %s%sILBM", bmhd->nPlanes,
	     pchgflag ? "multipalette " : "",
	     viewportmodes & vmEXTRA_HALFBRITE ? "EHB " : ""
    );

  if (bmhd->nPlanes > MAXPLANES)
    pm_error("too many planes (max %d)", MAXPLANES);

  if (colormap)
    maxval = MAXCOLVAL;
  else {
    maxval = pm_bitstomaxval(bmhd->nPlanes);
    pm_message("no colormap - interpreting values as grayscale");
  }
  if (maxval > PPM_MAXMAXVAL)
    pm_error("nPlanes is too large - try reconfiguring with PGM_BIGGRAYS\n    or without PPM_PACKCOLORS");

  if (pchgflag)
    init_pchg(pchginfo, colormap, colors, maxval);

  rawrow = alloc_rawrow(cols);

  if (viewportmodes & vmEXTRA_HALFBRITE)
    colormap = ehb_to_cmap(colormap, &colors);

  ppm_writeppminit(stdout, cols, rows, (pixval) maxval, 0);
  for (row = 0; row < rows; row++) {

    if (pchgflag)
      adjust_colormap(pchginfo, row);

    decode_row(ifp, rawrow, bmhd->nPlanes, bmhd);
    for (col = 0; col < cols; col++) {
      if (colormap)
	pixelrow[col] = colormap[rawrow[col]];
      else
	PPM_ASSIGN(pixelrow[col], rawrow[col], rawrow[col], rawrow[col]);
    }
    ppm_writeppmrow(stdout, pixelrow, cols, maxval, 0);
  }
}

staticfnc pixel *
  ehb_to_cmap(colormap, colors)
    pixel *colormap;
    int *colors;
{
  pixel *tempcolormap = NULL;
  int i, col;

  if (colormap) {
    col = *colors;
    tempcolormap = ppm_allocrow(col * 2);
    for (i = 0; i < col; i++) {
      tempcolormap[i] = colormap[i];
      PPM_ASSIGN(tempcolormap[col + i], PPM_GETR(colormap[i]) / 2,
		 PPM_GETG(colormap[i]) / 2, PPM_GETB(colormap[i]) / 2);
    }
    ppm_freerow(colormap);
    *colors *= 2;
  }
  return tempcolormap;
}

staticfnc void read_ilbm_plane(ifp, cols, compression)
    FILE *ifp;
    int cols, compression;
{
  unsigned char *ubp;
  int bytes, j, byte;

  bytes = RowBytes(cols);

  switch (compression) {
    case cmpNone:
      j = fread(ilbmrow, 1, bytes, ifp);
      if (j != bytes)
	readerr(ifp);
      break;
    case cmpByteRun1:
      ubp = ilbmrow;
      do {
	byte = (int)get_byte(ifp);
	if (byte <= 127) {
	  j = byte;
	  bytes -= (j + 1);
	  if (bytes < 0)
	    pm_error("error doing ByteRun1 decompression");
	  for (; j >= 0; j--)
	    *ubp++ = get_byte(ifp);
	}
	else if (byte != 128) {
	  j = 256 - byte;
	  bytes -= (j + 1);
	  if (bytes < 0)
	    pm_error("error doing ByteRun1 decompression");
	  byte = (int)get_byte(ifp);
	  for (; j >= 0; j--)
	    *ubp++ = (unsigned char)byte;
	}
	/* 128 is a NOP */
      }
      while (bytes > 0);
      break;
    default:
      pm_error("unknown compression type");
  }
}

const unsigned char bit_mask[] =
{1, 2, 4, 8, 16, 32, 64, 128};

staticfnc void decode_row(ifp, chunkyrow, nPlanes, bmhd)
    FILE *ifp;
    rawtype *chunkyrow;
    int nPlanes;
    BitMapHeader *bmhd;
{
  int plane, col, cols;
  unsigned char *ilp;
  rawtype *chp;

  cols = bmhd->w;
  for (plane = 0; plane < nPlanes; plane++) {
    int mask, cbit;

    mask = 1 << plane;
    read_ilbm_plane(ifp, cols, bmhd->compression);

    ilp = ilbmrow;
    chp = chunkyrow;

    cbit = 7;
    for (col = 0; col < cols; col++, cbit--, chp++) {
      if (cbit < 0) {
	cbit = 7;
	ilp++;
      }
      if (*ilp & bit_mask[cbit])
	*chp |= mask;
      else
	*chp &= ~mask;
    }
  }
  /* skip mask plane */
  if (bmhd->masking == mskHasMask)
    read_ilbm_plane(ifp, cols, bmhd->compression);
}

staticfnc rawtype *
  alloc_rawrow(cols)
    int cols;
{
  rawtype *r;
  int i;

  r = MALLOC(cols, rawtype);

  for (i = 0; i < cols; i++)
    r[i] = 0;

  return r;
}

staticfnc void *
  xmalloc(bytes)
    int bytes;
{
  void *mem;

  if (bytes == 0)
    return NULL;

  mem = malloc(bytes);
  if (mem == NULL)
    pm_error("out of memory allocating %d bytes", bytes);
  return mem;
}

staticfnc void display_chunk(ifp, iffid, chunksize)
    FILE *ifp;
    char *iffid;
    long chunksize;
{
  int byte;

  pm_message("contents of \"%s\" chunk:", iffid);

  while (chunksize--) {
    byte = get_byte(ifp);
    if (fputc(byte, stderr) == EOF)
      pm_error("write error");
  }
  if (fputc('\n', stderr) == EOF)
    pm_error("write error");
}

/*
 * PCHG stuff
 */

staticfnc void PCHG_Decompress ARGS((PCHGHeader * PCHG, PCHGCompHeader * CompHdr, unsigned char *compdata, unsigned long compsize, unsigned char *comptree, unsigned char *data));
staticfnc unsigned char *PCHG_MakeMask ARGS((PCHGHeader * PCHG, unsigned char *data, unsigned long datasize, unsigned char **newdata));
staticfnc void PCHG_ConvertSmall ARGS((PCHGInfo * Info, unsigned char *data, unsigned long datasize));
staticfnc void PCHG_ConvertBig ARGS((PCHGInfo * Info, unsigned char *data, unsigned long datasize));
staticfnc void PCHG_DecompHuff ARGS((unsigned char *src, unsigned char *dest, short *tree, unsigned long origsize));
staticfnc void pchgerr ARGS((char *when));

/* Turn big-endian 4-byte long and 2-byte short stored at x (unsigned char *)
 * into the native format of the CPU
 */
#define BIG_LONG(x) (   ((unsigned long)((x)[0]) << 24) + \
                        ((unsigned long)((x)[1]) << 16) + \
                        ((unsigned long)((x)[2]) <<  8) + \
                        ((unsigned long)((x)[3]) <<  0) )
#define BIG_WORD(x) (   ((unsigned short)((x)[0]) << 8) + \
                        ((unsigned short)((x)[1]) << 0) )

staticfnc PCHGInfo *
  read_pchg(ifp, bytesleft)
    FILE *ifp;
    unsigned long bytesleft;
{
  static PCHGInfo Info;
  PCHGCompHeader CompHdr;
  PCHGHeader *PCHG;
  unsigned char *data, *chdata;
  unsigned long datasize;

#ifdef DEBUG
  pm_message("PCHG chunk found");
#endif

  if (bytesleft < PCHGHeaderSize)
    pchgerr("while reading PCHGHeader");

  Info.PCHG = PCHG = MALLOC(1, PCHGHeader);
  PCHG->Compression = get_big_short(ifp);
  PCHG->Flags = get_big_short(ifp);
  PCHG->StartLine = get_big_short(ifp);
  PCHG->LineCount = get_big_short(ifp);
  PCHG->ChangedLines = get_big_short(ifp);
  PCHG->MinReg = get_big_short(ifp);
  PCHG->MaxReg = get_big_short(ifp);
  PCHG->MaxChanges = get_big_short(ifp);
  PCHG->TotalChanges = get_big_long(ifp);
  bytesleft -= PCHGHeaderSize;

#ifdef DEBUG
  pm_message("PCHG StartLine   : %d", PCHG->StartLine);
  pm_message("PCHG LineCount   : %d", PCHG->LineCount);
  pm_message("PCHG ChangedLines: %d", PCHG->ChangedLines);
  pm_message("PCHG TotalChanges: %d", PCHG->TotalChanges);
#endif

  if (PCHG->Compression != PCHG_COMP_NONE) {
    unsigned char *compdata, *comptree;
    unsigned long treesize;

    if (bytesleft < PCHGCompHeaderSize)
      pchgerr("while reading PCHGCompHeader");

    CompHdr.CompInfoSize = get_big_long(ifp);
    CompHdr.OriginalDataSize = get_big_long(ifp);
    bytesleft -= PCHGCompHeaderSize;
    treesize = CompHdr.CompInfoSize;
    datasize = CompHdr.OriginalDataSize;

    if (bytesleft < treesize)
      pchgerr("while reading compression info data");

    comptree = MALLOC(treesize, unsigned char);

    if (fread(comptree, 1, treesize, ifp) != treesize)
      readerr(ifp);

    bytesleft -= treesize;
    if (bytesleft == 0)
      pchgerr("while reading compressed change structure data");

    compdata = MALLOC(bytesleft, unsigned char);
    data = MALLOC(datasize, unsigned char);

    if (fread(compdata, 1, bytesleft, ifp) != bytesleft)
      readerr(ifp);

    PCHG_Decompress(PCHG, &CompHdr, compdata, bytesleft, comptree, data);
    free(comptree);
    free(compdata);
    bytesleft = 0;
  }
  else {
#ifdef DEBUG
    pm_message("uncompressed PCHG");
#endif
    if (bytesleft == 0)
      pchgerr("while reading uncompressed change structure data");

    datasize = bytesleft;
    data = MALLOC(datasize, unsigned char);

    if (fread(data, 1, datasize, ifp) != datasize)
      readerr(ifp);
    bytesleft = 0;
  }

  Info.LineMask = PCHG_MakeMask(PCHG, data, datasize, &chdata);
  datasize -= (chdata - data);

  Info.Palette = MALLOC(PCHG->TotalChanges, PaletteChange);
  Info.Change = MALLOC(PCHG->ChangedLines, LineChanges);

  if (PCHG->Flags & PCHGF_USE_ALPHA)
    pm_message("warning - PCHG alpha channel not supported");

  if (PCHG->Flags & PCHGF_12BIT) {
#ifdef DEBUG
    pm_message("SmallLineChanges");
#endif
    PCHG_ConvertSmall(&Info, chdata, datasize);
  }
  else if (PCHG->Flags & PCHGF_32BIT) {
#ifdef DEBUG
    pm_message("BigLineChanges");
#endif
    PCHG_ConvertBig(&Info, chdata, datasize);
  }
  else
    pm_error("unknown palette changes structure format in PCHG chunk");

  free(data);
  return &Info;
}

staticfnc void PCHG_Decompress(PCHG, CompHdr, compdata, compsize, comptree, data)
    PCHGHeader *PCHG;
    PCHGCompHeader *CompHdr;
    unsigned char *compdata;
    unsigned long compsize;
    unsigned char *comptree;
    unsigned char *data;
{
  short *hufftree;
  unsigned long huffsize, i;
  unsigned long treesize = CompHdr->CompInfoSize;

  switch (PCHG->Compression) {
    case PCHG_COMP_HUFFMAN:

#ifdef DEBUG
      pm_message("PCHG Huffman compression");
#endif
      /* turn big-endian 2-byte shorts into native format */
      huffsize = treesize / 2;
      hufftree = MALLOC(huffsize, short);

      for (i = 0; i < huffsize; i++) {
	hufftree[i] = (short)BIG_WORD(comptree);
	comptree += 2;
      }

      /* decompress the change structure data */
      PCHG_DecompHuff(compdata, data, &hufftree[huffsize - 1], CompHdr->OriginalDataSize);

      free(hufftree);
      break;
    default:
      pm_error("unknown PCHG compression type");
  }
}

staticfnc unsigned char *
  PCHG_MakeMask(PCHG, data, datasize, newdata)
    PCHGHeader *PCHG;
    unsigned char *data;
    unsigned long datasize;
    unsigned char **newdata;
{
  unsigned long bytes;
  unsigned char *mask;

  /* the mask at 'data' is in 4-byte big-endian longword format,
   * thus we can simply treat it at unsigned char and don't have
   * to convert it, just copy it to a new mem block so we can
   * free the original data
   */
  bytes = MaskLongWords(PCHG->LineCount) * 4;
  if (datasize < bytes)
    pchgerr("for line mask");
  mask = MALLOC(bytes, unsigned char);

#ifdef DEBUG
  pm_message("%ld bytes for line mask", bytes);
#endif
  bcopy(data, mask, bytes);

  *newdata = (data + bytes);
  return mask;
}

staticfnc void PCHG_ConvertSmall(Info, data, datasize)
    PCHGInfo *Info;
    unsigned char *data;
    unsigned long datasize;
{
  PCHGHeader *PCHG = Info->PCHG;
  LineChanges *Change = Info->Change;
  PaletteChange *Palette = Info->Palette;
  unsigned long i, palettecount = 0;
  unsigned char ChangeCount16, ChangeCount32;
  unsigned short SmallChange;

  Info->maxval = 15;						/* 4 bit values */

  for (i = 0; i < PCHG->ChangedLines; i++) {
    int n;

    if (datasize < 2)
      goto fail;
    ChangeCount16 = *data++;
    ChangeCount32 = *data++;
    datasize -= 2;

    Change[i].Count = ChangeCount16 + ChangeCount32;
    Change[i].Palette = &Palette[palettecount];

    for (n = 0; n < Change[i].Count; n++) {
      if (palettecount >= PCHG->TotalChanges)
	goto fail;
      if (datasize < 2)
	goto fail;
      SmallChange = BIG_WORD(data);
      data += 2;
      datasize -= 2;

      Palette[palettecount].Register = (SmallChange >> 12) & 0x0f;
      if (n >= ChangeCount16)
	Palette[palettecount].Register += 16;
      Palette[palettecount].Alpha = 0;
      Palette[palettecount].Red = (SmallChange >> 8) & 0x0f;
      Palette[palettecount].Green = (SmallChange >> 4) & 0x0f;
      Palette[palettecount].Blue = SmallChange & 0x0f;
      palettecount++;
    }
  }
#ifdef DEBUG
  pm_message("%ld palette change structures", palettecount);
#endif
  return;
fail:
  pchgerr("while building SmallLineChanges array");
}

staticfnc void PCHG_ConvertBig(Info, data, datasize)
    PCHGInfo *Info;
    unsigned char *data;
    unsigned long datasize;
{
  PCHGHeader *PCHG = Info->PCHG;
  LineChanges *Change = Info->Change;
  PaletteChange *Palette = Info->Palette;
  unsigned long i, palettecount = 0;

  Info->maxval = MAXCOLVAL;

  for (i = 0; i < PCHG->ChangedLines; i++) {
    int n;

    if (datasize < 2)
      goto fail;
    Change[i].Count = BIG_WORD(data);
    data += 2;
    datasize -= 2;

    Change[i].Palette = &Palette[palettecount];

    for (n = 0; n < Change[i].Count; n++) {
      if (palettecount >= PCHG->TotalChanges)
	goto fail;
      if (datasize < 6)
	goto fail;
      Palette[palettecount].Register = BIG_WORD(data);
      data += 2;
      Palette[palettecount].Alpha = *data++;
      Palette[palettecount].Red = *data++;
      Palette[palettecount].Blue = *data++;			/* yes, RBG */
      Palette[palettecount].Green = *data++;
      palettecount++;
      datasize -= 6;
    }
  }
#ifdef DEBUG
  pm_message("%ld palette change structures", palettecount);
#endif
  return;
fail:
  pchgerr("while building BigLineChanges array");
}

staticfnc void pchgerr(when)
    char *when;
{
  pm_message("insufficient data in PCHG chunk %s", when);
  pm_error("try the \"-ignore\" option to skip this chunk");
}

staticfnc void PCHG_DecompHuff(src, dest, tree, origsize)
    unsigned char *src, *dest;
    short *tree;
    unsigned long origsize;
{
  unsigned long i = 0, bits = 0;
  unsigned char thisbyte;
  short *p;

  p = tree;
  while (i < origsize) {
    if (bits == 0) {
      thisbyte = *src++;
      bits = 8;
    }
    if (thisbyte & (1 << 7)) {
      if (*p >= 0) {
	*dest++ = (unsigned char)*p;
	i++;
	p = tree;
      }
      else
	p += (*p / 2);
    }
    else {
      p--;
      if (*p > 0 && (*p & 0x100)) {
	*dest++ = (unsigned char)*p;
	i++;
	p = tree;
      }
    }
    thisbyte <<= 1;
    bits--;
  }
}

staticfnc void init_pchg(pchginfo, colormap, colors, newmaxval)
    PCHGInfo *pchginfo;
    pixel *colormap;
    int colors;
    pixval newmaxval;
{
  PCHGHeader *PCHG = pchginfo->PCHG;
  pixval oldmaxval = pchginfo->maxval;
  int row;

  pchginfo->colormap = colormap;
  pchginfo->colors = colors;

  if (oldmaxval != newmaxval) {
    PaletteChange *Palette = pchginfo->Palette;
    unsigned long i;

#ifdef DEBUG
    pm_message("scaling PCHG palette from %d to %d", oldmaxval, newmaxval);
#endif

    for (i = 0; i < PCHG->TotalChanges; i++) {
      Palette[i].Red = Palette[i].Red * newmaxval / oldmaxval;
      Palette[i].Green = Palette[i].Green * newmaxval / oldmaxval;
      Palette[i].Blue = Palette[i].Blue * newmaxval / oldmaxval;
    }
    pchginfo->maxval = newmaxval;
  }

  for (row = PCHG->StartLine; row < 0; row++)
    adjust_colormap(pchginfo, row);
}

staticfnc void adjust_colormap(pchginfo, row)
    PCHGInfo *pchginfo;
    int row;
{
  static unsigned long maskcount, changecount;
  static unsigned char thismask;
  static int bits;

  PCHGHeader *PCHG = pchginfo->PCHG;

  if (row < PCHG->StartLine || changecount >= PCHG->ChangedLines)
    return;

  if (bits == 0) {
    thismask = pchginfo->LineMask[maskcount++];
    bits = 8;
  }

  if (thismask & (1 << 7)) {
    int i;

    for (i = 0; i < pchginfo->Change[changecount].Count; i++) {
      PaletteChange *pal = &(pchginfo->Change[changecount].Palette[i]);
      int reg = pal->Register;

      if (reg >= pchginfo->colors) {
	pm_message("warning - PCHG palette change register value out of range");
	pm_message("    row %d  change structure %ld  palette %d", row, changecount, i);
	pm_message("    ignoring it... colors might get messed up from here");
      }
      else
	PPM_ASSIGN(pchginfo->colormap[reg], pal->Red, pal->Green, pal->Blue);
    }
    changecount++;
  }
  thismask <<= 1;
  bits--;
}

staticfnc void scale_colormap(colormap, colors, oldmaxval, newmaxval)
    pixel *colormap;
    int colors;
    pixval oldmaxval, newmaxval;
{
  int i, r, g, b;

  for (i = 0; i < colors; i++) {
    r = PPM_GETR(colormap[i]) * newmaxval / oldmaxval;
    g = PPM_GETG(colormap[i]) * newmaxval / oldmaxval;
    b = PPM_GETB(colormap[i]) * newmaxval / oldmaxval;
    PPM_ASSIGN(colormap[i], r, g, b);
  }
}

/* ppmtoilbm.c - read a portable pixmap and produce an IFF ILBM file
 *
 * Copyright (C) 1989 by Jef Poskanzer.
 * Modified by Ingo Wilken (Ingo.Wilken@informatik.uni-oldenburg.de)
 *  20/Jun/93:
 *  - 24bit support (new options -24if, -24force)
 *  - HAM8 support (well, anything from HAM3 to HAM(MAXPLANES))
 *  - now writes up to 8 (16) planes (new options -maxplanes, -fixplanes)
 *  - colormap file (new option -map)
 *  - write colormap only (new option -cmaponly)
 *  - only writes CAMG chunk if it is a HAM-picture
 *  29/Aug/93:
 *  - operates row-by-row whenever possible
 *  - faster colorscaling with lookup-table (~20% faster on HAM pictures)
 *  - options -ham8 and -ham6 now imply -hamforce
 *  27/Nov/93:
 *  - byterun1 compression (this is now default) with new options:
 *    -compress, -nocompress, -cmethod, -savemem
 *  - floyd-steinberg error diffusion (for std+mapfile and HAM)
 *  - new options: -lace and -hires --> write CAMG chunk
 *  - LUT for luminance calculation (used by ppm_to_ham)
 *
 *
 *           std   HAM  24bit cmap  direct
 *  -------+-----+-----+-----+-----+-----
 *  BMHD     yes   yes   yes   yes   yes
 *  CMAP     yes   (1)   no    yes   no
 *  BODY     yes   yes   yes   no    yes
 *  CAMG     (2)   yes   (2)   no    (2)
 *  other    -     -     -     -     DCOL
 *  nPlanes  1-8   3-8   24    0     3-24   if configured without ILBM_BIGRAW
 *  nPlanes  1-16  3-16  24    0     3-48   if configured with ILBM_BIGRAW
 *
 *  (1): grayscale colormap
 *  (2): only if "-lace" or "-hires" option used
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted, provided
 * that the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation.  This software is provided "as is" without express or
 * implied warranty.
 */

#define MODE_DIRECT     4					/* direct color ILBM */
#define MODE_CMAP       3					/* write normal file, but colormap only */
#define MODE_24         2					/* write a 24bit (deep) ILBM */
#define MODE_HAM        1					/* write a HAM */
#define MODE_NONE       0					/* write a normal picture */

#define DEF_MAXPLANES   8
#define DEF_HAMPLANES   8
#define DEF_DCOLPLANES  5
#define DEF_COMPRESSION cmpByteRun1

typedef struct {
  int len;
  unsigned char *row;
} bodyrow;

typedef struct {
  long *thisrederr, *thisgreenerr, *thisblueerr;
  long *nextrederr, *nextgreenerr, *nextblueerr;
  int lefttoright;						/* 1 for left-to-right scan, 0 for right-to-left */
  int cols;
  pixel *pixrow;
  pixval maxval;
  int col, col_end;
  int alternate;
  pixval red, green, blue;					/* values of current pixel */
} floydinfo;

staticfnc int colorstobpp ARGS((int colors));

#define put_fourchars(str)  (void)(fputs(str, stdout))
staticfnc void put_big_short ARGS((short s));
staticfnc void put_big_long ARGS((long l));

#define put_byte(b)     (void)(putc((unsigned char)(b), stdout))
staticfnc void ppm_to_ham ARGS((FILE * fp, int cols, int rows, int maxval, int hambits, int nocolor));
staticfnc void ppm_to_24 ARGS((FILE * fp, int cols, int rows, int maxval));
staticfnc void ppm_to_direct ARGS((FILE * fp, int cols, int rows, int maxval, DirectColor * direct));
staticfnc void ppm_to_std ARGS((FILE * fp, int cols, int rows, int maxval, colorhist_vector chv, int colors, int nPlanes));
staticfnc void ppm_to_cmap ARGS((int maxval, colorhist_vector chv, int colors));
staticfnc void write_form_ilbm ARGS((int size));
staticfnc void write_bmhd ARGS((int cols, int rows, int nPlanes));
staticfnc void write_std_cmap ARGS((colorhist_vector chv, int colors, int maxval));
staticfnc int encode_row ARGS((FILE * outfile, rawtype * rawrow, int cols, int nPlanes));
staticfnc int compress_row ARGS((int bytes));
staticfnc int runbyte1 ARGS((int bytes));
staticfnc pixel *next_pixrow ARGS((FILE * fp, int row));
staticfnc pixval *make_val_table ARGS((pixval oldmaxval, pixval newmaxval));
staticfnc void *xmalloc ARGS((int bytes));

#define MALLOC(n, type)     (type *)tmalloc((n) * sizeof(type))
staticfnc void init_read ARGS((FILE * fp, int *colsP, int *rowsP, pixval * maxvalP, int *formatP, int readall));
staticfnc void write_body ARGS((void));
staticfnc void write_camg ARGS((void));
staticfnc void alloc_body_array ARGS((int rows, int nPlanes));
staticfnc void free_body_array ARGS((void));

#define PAD(n)      odd(n)					/* pad to a word */
staticfnc int closest_color ARGS((colorhist_vector chv, int colors, pixval cmaxval, pixel * pP));
staticfnc floydinfo *init_floyd ARGS((int cols, pixval maxval, int alternate));
staticfnc void free_floyd ARGS((floydinfo * fi));
staticfnc void begin_floyd_row ARGS((floydinfo * fi, pixel * prow));
staticfnc pixel *next_floyd_pixel ARGS((floydinfo * fi));
staticfnc void update_floyd_pixel ARGS((floydinfo * fi, int r, int g, int b));
staticfnc void end_floyd_row ARGS((floydinfo * fi));

/* global data */
static unsigned char *coded_rowbuf;				/* buffer for uncompressed scanline */
static unsigned char *compr_rowbuf;				/* buffer for compressed scanline */
static pixel **pixels;						/* PPM image (NULL for row-by-row operation) */
static pixel *pixrow;						/* current row in PPM image (pointer into pixels array, or buffer for row-by-row operation) */
static bodyrow *ilbm_body = NULL;				/* compressed ILBM BODY */

static long viewportmodes = 0;
static int compr_type = DEF_COMPRESSION;

/* flags */
static short savemem = 0;					/* slow operation, but uses less memory */
static short compr_force = 0;					/* force compressed output, even if the image got larger  - NOT USED */
static short floyd = 0;						/* apply floyd-steinberg error diffusion */

#define WORSTCOMPR(bytes)       ((bytes) + (bytes)/128 + 1)
#define DO_COMPRESS             (compr_type != cmpNone)
#define CAMGSIZE                (viewportmodes == 0 ? 0 : (4 + 4 + CAMGChunkSize))

/* Lookup tables for fast RGB -> luminance calculation. */
/* taken from ppmtopgm.c   -IUW */

static int times77[256] =
{
  0, 77, 154, 231, 308, 385, 462, 539,
  616, 693, 770, 847, 924, 1001, 1078, 1155,
  1232, 1309, 1386, 1463, 1540, 1617, 1694, 1771,
  1848, 1925, 2002, 2079, 2156, 2233, 2310, 2387,
  2464, 2541, 2618, 2695, 2772, 2849, 2926, 3003,
  3080, 3157, 3234, 3311, 3388, 3465, 3542, 3619,
  3696, 3773, 3850, 3927, 4004, 4081, 4158, 4235,
  4312, 4389, 4466, 4543, 4620, 4697, 4774, 4851,
  4928, 5005, 5082, 5159, 5236, 5313, 5390, 5467,
  5544, 5621, 5698, 5775, 5852, 5929, 6006, 6083,
  6160, 6237, 6314, 6391, 6468, 6545, 6622, 6699,
  6776, 6853, 6930, 7007, 7084, 7161, 7238, 7315,
  7392, 7469, 7546, 7623, 7700, 7777, 7854, 7931,
  8008, 8085, 8162, 8239, 8316, 8393, 8470, 8547,
  8624, 8701, 8778, 8855, 8932, 9009, 9086, 9163,
  9240, 9317, 9394, 9471, 9548, 9625, 9702, 9779,
  9856, 9933, 10010, 10087, 10164, 10241, 10318, 10395,
  10472, 10549, 10626, 10703, 10780, 10857, 10934, 11011,
  11088, 11165, 11242, 11319, 11396, 11473, 11550, 11627,
  11704, 11781, 11858, 11935, 12012, 12089, 12166, 12243,
  12320, 12397, 12474, 12551, 12628, 12705, 12782, 12859,
  12936, 13013, 13090, 13167, 13244, 13321, 13398, 13475,
  13552, 13629, 13706, 13783, 13860, 13937, 14014, 14091,
  14168, 14245, 14322, 14399, 14476, 14553, 14630, 14707,
  14784, 14861, 14938, 15015, 15092, 15169, 15246, 15323,
  15400, 15477, 15554, 15631, 15708, 15785, 15862, 15939,
  16016, 16093, 16170, 16247, 16324, 16401, 16478, 16555,
  16632, 16709, 16786, 16863, 16940, 17017, 17094, 17171,
  17248, 17325, 17402, 17479, 17556, 17633, 17710, 17787,
  17864, 17941, 18018, 18095, 18172, 18249, 18326, 18403,
  18480, 18557, 18634, 18711, 18788, 18865, 18942, 19019,
  19096, 19173, 19250, 19327, 19404, 19481, 19558, 19635};
static int times150[256] =
{
  0, 150, 300, 450, 600, 750, 900, 1050,
  1200, 1350, 1500, 1650, 1800, 1950, 2100, 2250,
  2400, 2550, 2700, 2850, 3000, 3150, 3300, 3450,
  3600, 3750, 3900, 4050, 4200, 4350, 4500, 4650,
  4800, 4950, 5100, 5250, 5400, 5550, 5700, 5850,
  6000, 6150, 6300, 6450, 6600, 6750, 6900, 7050,
  7200, 7350, 7500, 7650, 7800, 7950, 8100, 8250,
  8400, 8550, 8700, 8850, 9000, 9150, 9300, 9450,
  9600, 9750, 9900, 10050, 10200, 10350, 10500, 10650,
  10800, 10950, 11100, 11250, 11400, 11550, 11700, 11850,
  12000, 12150, 12300, 12450, 12600, 12750, 12900, 13050,
  13200, 13350, 13500, 13650, 13800, 13950, 14100, 14250,
  14400, 14550, 14700, 14850, 15000, 15150, 15300, 15450,
  15600, 15750, 15900, 16050, 16200, 16350, 16500, 16650,
  16800, 16950, 17100, 17250, 17400, 17550, 17700, 17850,
  18000, 18150, 18300, 18450, 18600, 18750, 18900, 19050,
  19200, 19350, 19500, 19650, 19800, 19950, 20100, 20250,
  20400, 20550, 20700, 20850, 21000, 21150, 21300, 21450,
  21600, 21750, 21900, 22050, 22200, 22350, 22500, 22650,
  22800, 22950, 23100, 23250, 23400, 23550, 23700, 23850,
  24000, 24150, 24300, 24450, 24600, 24750, 24900, 25050,
  25200, 25350, 25500, 25650, 25800, 25950, 26100, 26250,
  26400, 26550, 26700, 26850, 27000, 27150, 27300, 27450,
  27600, 27750, 27900, 28050, 28200, 28350, 28500, 28650,
  28800, 28950, 29100, 29250, 29400, 29550, 29700, 29850,
  30000, 30150, 30300, 30450, 30600, 30750, 30900, 31050,
  31200, 31350, 31500, 31650, 31800, 31950, 32100, 32250,
  32400, 32550, 32700, 32850, 33000, 33150, 33300, 33450,
  33600, 33750, 33900, 34050, 34200, 34350, 34500, 34650,
  34800, 34950, 35100, 35250, 35400, 35550, 35700, 35850,
  36000, 36150, 36300, 36450, 36600, 36750, 36900, 37050,
  37200, 37350, 37500, 37650, 37800, 37950, 38100, 38250};
static int times29[256] =
{
  0, 29, 58, 87, 116, 145, 174, 203,
  232, 261, 290, 319, 348, 377, 406, 435,
  464, 493, 522, 551, 580, 609, 638, 667,
  696, 725, 754, 783, 812, 841, 870, 899,
  928, 957, 986, 1015, 1044, 1073, 1102, 1131,
  1160, 1189, 1218, 1247, 1276, 1305, 1334, 1363,
  1392, 1421, 1450, 1479, 1508, 1537, 1566, 1595,
  1624, 1653, 1682, 1711, 1740, 1769, 1798, 1827,
  1856, 1885, 1914, 1943, 1972, 2001, 2030, 2059,
  2088, 2117, 2146, 2175, 2204, 2233, 2262, 2291,
  2320, 2349, 2378, 2407, 2436, 2465, 2494, 2523,
  2552, 2581, 2610, 2639, 2668, 2697, 2726, 2755,
  2784, 2813, 2842, 2871, 2900, 2929, 2958, 2987,
  3016, 3045, 3074, 3103, 3132, 3161, 3190, 3219,
  3248, 3277, 3306, 3335, 3364, 3393, 3422, 3451,
  3480, 3509, 3538, 3567, 3596, 3625, 3654, 3683,
  3712, 3741, 3770, 3799, 3828, 3857, 3886, 3915,
  3944, 3973, 4002, 4031, 4060, 4089, 4118, 4147,
  4176, 4205, 4234, 4263, 4292, 4321, 4350, 4379,
  4408, 4437, 4466, 4495, 4524, 4553, 4582, 4611,
  4640, 4669, 4698, 4727, 4756, 4785, 4814, 4843,
  4872, 4901, 4930, 4959, 4988, 5017, 5046, 5075,
  5104, 5133, 5162, 5191, 5220, 5249, 5278, 5307,
  5336, 5365, 5394, 5423, 5452, 5481, 5510, 5539,
  5568, 5597, 5626, 5655, 5684, 5713, 5742, 5771,
  5800, 5829, 5858, 5887, 5916, 5945, 5974, 6003,
  6032, 6061, 6090, 6119, 6148, 6177, 6206, 6235,
  6264, 6293, 6322, 6351, 6380, 6409, 6438, 6467,
  6496, 6525, 6554, 6583, 6612, 6641, 6670, 6699,
  6728, 6757, 6786, 6815, 6844, 6873, 6902, 6931,
  6960, 6989, 7018, 7047, 7076, 7105, 7134, 7163,
  7192, 7221, 7250, 7279, 7308, 7337, 7366, 7395};

/************ parse options and figure out what kind of ILBM to write ************/

staticfnc int get_int_val ARGS((char *string, char *option, int bot, int top));
staticfnc int get_compr_type ARGS((char *string));

#define NEWDEPTH(pix, table)    PPM_ASSIGN((pix), (table)[PPM_GETR(pix)], (table)[PPM_GETG(pix)], (table)[PPM_GETB(pix)])

int main(argc, argv)
    int argc;
    char *argv[];
{
  FILE *ifp;
  int argn, rows, cols, format, colors, nPlanes;
  int ifmode, forcemode, maxplanes, fixplanes, hambits, mode;

#define MAXCOLORS       (1<<maxplanes)
  pixval maxval;
  colorhist_vector chv;
  DirectColor dcol;
  char *mapfile;
  char *usage =
  "[-ecs|-aga] [-ham6|-ham8] [-maxplanes|-mp n] [-fixplanes|-fp n]\
 [-normal|-hamif|-hamforce|-24if|-24force|-dcif|-dcforce|-cmaponly]\
 [-hambits|-hamplanes n] [-dcbits|-dcplanes r g b] [-hires] [-lace]\
 [-floyd|-fs] [-compress|-nocompress] [-cmethod none|byterun1]\
 [-map ppmfile] [-savemem] [ppmfile]";

  ppm_init(&argc, argv);

  ifmode = MODE_NONE;
  forcemode = MODE_NONE;
  maxplanes = DEF_MAXPLANES;
  fixplanes = 0;
  hambits = DEF_HAMPLANES;
  mapfile = NULL;
  dcol.r = dcol.g = dcol.b = DEF_DCOLPLANES;

  argn = 1;
  while (argn < argc && argv[argn][0] == '-' && argv[argn][1] != '\0') {
    if (pm_keymatch(argv[argn], "-maxplanes", 4) || pm_keymatch(argv[argn], "-mp", 3)) {
      if (++argn >= argc)
	pm_usage(usage);
      maxplanes = get_int_val(argv[argn], argv[argn - 1], 1, MAXPLANES);
      fixplanes = 0;
    }
    else if (pm_keymatch(argv[argn], "-fixplanes", 4) || pm_keymatch(argv[argn], "-fp", 3)) {
      if (++argn >= argc)
	pm_usage(usage);
      fixplanes = get_int_val(argv[argn], argv[argn - 1], 1, MAXPLANES);
      maxplanes = fixplanes;
    }
    else if (pm_keymatch(argv[argn], "-map", 4)) {
      if (++argn >= argc)
	pm_usage(usage);
      mapfile = argv[argn];
    }
    else if (pm_keymatch(argv[argn], "-cmaponly", 3)) {
      forcemode = MODE_CMAP;
    }
    else if (pm_keymatch(argv[argn], "-hambits", 5) || pm_keymatch(argv[argn], "-hamplanes", 5)) {
      if (++argn > argc)
	pm_usage(usage);
      hambits = get_int_val(argv[argn], argv[argn - 1], 3, MAXPLANES);
    }
    else if (pm_keymatch(argv[argn], "-ham6", 5)) {
      hambits = ECS_HAMPLANES;
      forcemode = MODE_HAM;
    }
    else if (pm_keymatch(argv[argn], "-ham8", 5)) {
      hambits = AGA_HAMPLANES;
      forcemode = MODE_HAM;
    }
    else if (pm_keymatch(argv[argn], "-lace", 2)) {
#ifdef ILBM_PCHG
      slicesize = 2;
#endif
      viewportmodes |= vmLACE;
    }
    else if (pm_keymatch(argv[argn], "-nolace", 4)) {
#ifdef ILBM_PCHG
      slicesize = 1;
#endif
      viewportmodes &= ~vmLACE;
    }
    else if (pm_keymatch(argv[argn], "-hires", 3))
      viewportmodes |= vmHIRES;
    else if (pm_keymatch(argv[argn], "-nohires", 5))
      viewportmodes &= ~vmHIRES;
    else if (pm_keymatch(argv[argn], "-ecs", 2)) {
      maxplanes = ECS_MAXPLANES;
      hambits = ECS_HAMPLANES;
    }
    else if (pm_keymatch(argv[argn], "-aga", 2)) {
      maxplanes = AGA_MAXPLANES;
      hambits = AGA_HAMPLANES;
    }
    else if (pm_keymatch(argv[argn], "-hamif", 5))
      ifmode = MODE_HAM;
    else if (pm_keymatch(argv[argn], "-nohamif", 7)) {
      if (ifmode == MODE_HAM)
	ifmode = MODE_NONE;
    }
    else if (pm_keymatch(argv[argn], "-hamforce", 5))
      forcemode = MODE_HAM;
    else if (pm_keymatch(argv[argn], "-nohamforce", 7)) {
      if (forcemode == MODE_HAM)
	forcemode = MODE_NONE;
    }
    else if (pm_keymatch(argv[argn], "-24if", 4))
      ifmode = MODE_24;
    else if (pm_keymatch(argv[argn], "-no24if", 6)) {
      if (ifmode == MODE_24)
	ifmode = MODE_NONE;
    }
    else if (pm_keymatch(argv[argn], "-24force", 4))
      forcemode = MODE_24;
    else if (pm_keymatch(argv[argn], "-no24force", 6)) {
      if (forcemode == MODE_24)
	forcemode = MODE_NONE;
    }
    else if (pm_keymatch(argv[argn], "-dcif", 4)) {
      ifmode = MODE_DIRECT;
    }
    else if (pm_keymatch(argv[argn], "-nodcif", 6)) {
      if (ifmode == MODE_DIRECT)
	ifmode = MODE_NONE;
    }
    else if (pm_keymatch(argv[argn], "-dcforce", 4)) {
      forcemode = MODE_DIRECT;
    }
    else if (pm_keymatch(argv[argn], "-nodcforce", 6)) {
      if (forcemode == MODE_DIRECT)
	forcemode = MODE_NONE;
    }
    else if (pm_keymatch(argv[argn], "-dcbits", 4) || pm_keymatch(argv[argn], "-dcplanes", 4)) {
      char *option = argv[argn];

      if (++argn >= argc)
	pm_usage(usage);
      dcol.r = (unsigned char)get_int_val(argv[argn], option, 1, MAXPLANES);
      if (++argn >= argc)
	pm_usage(usage);
      dcol.g = (unsigned char)get_int_val(argv[argn], option, 1, MAXPLANES);
      if (++argn >= argc)
	pm_usage(usage);
      dcol.b = (unsigned char)get_int_val(argv[argn], option, 1, MAXPLANES);
    }
    else if (pm_keymatch(argv[argn], "-normal", 4)) {
      ifmode = forcemode = MODE_NONE;
      compr_type = DEF_COMPRESSION;
    }
    else if (pm_keymatch(argv[argn], "-compress", 3)) {
      compr_force = 1;
      if (compr_type == cmpNone)
	if (DEF_COMPRESSION == cmpNone)
	  compr_type = cmpByteRun1;
	else
	  compr_type = DEF_COMPRESSION;
    }
    else if (pm_keymatch(argv[argn], "-nocompress", 4)) {
      compr_force = 0;
      compr_type = cmpNone;
    }
    else if (pm_keymatch(argv[argn], "-cmethod", 4)) {
      if (++argn >= argc)
	pm_usage(usage);
      compr_type = get_compr_type(argv[argn]);
    }
    else if (pm_keymatch(argv[argn], "-savemem", 2))
      savemem = 1;
    else if (pm_keymatch(argv[argn], "-fs1", 4))		/* EXPERIMENTAL */
      floyd = 2;
    else if (pm_keymatch(argv[argn], "-floyd", 3) || pm_keymatch(argv[argn], "-fs", 3))
      floyd = 1;
    else if (pm_keymatch(argv[argn], "-nofloyd", 5) || pm_keymatch(argv[argn], "-nofs", 5))
      floyd = 0;
    else
      pm_usage(usage);
    ++argn;
  }

  if (argn < argc) {
    ifp = pm_openr(argv[argn]);
    ++argn;
  }
  else
    ifp = stdin;

  if (argn != argc)
    pm_usage(usage);

  if (forcemode != MODE_NONE && mapfile != NULL)
    pm_message("warning - mapfile only used for normal ILBMs");

  mode = forcemode;
  switch (forcemode) {
    case MODE_HAM:
      /* grayscale colormap for now - we don't need to read the whole
       * file into memory and can use row-by-row operation */
      init_read(ifp, &cols, &rows, &maxval, &format, 0);
      pm_message("hamforce option used - proceeding to write a HAM%d file", hambits);
      break;
    case MODE_24:
      init_read(ifp, &cols, &rows, &maxval, &format, 0);
      pm_message("24force option used - proceeding to write a 24bit file");
      break;
    case MODE_DIRECT:
      init_read(ifp, &cols, &rows, &maxval, &format, 0);
      pm_message("dcforce option used - proceeding to write a %d:%d:%d direct color file",
		 dcol.r, dcol.g, dcol.b);
      break;
    case MODE_CMAP:
      /* must read the whole file into memory */
      init_read(ifp, &cols, &rows, &maxval, &format, 1);

      /* Figure out the colormap. */
      pm_message("computing colormap...");
      chv = ppm_computecolorhist(pixels, cols, rows, MAXCMAPCOLORS, &colors);
      if (chv == (colorhist_vector) NULL)
	pm_error("too many colors - try doing a 'ppmquant %d'", MAXCMAPCOLORS);
      pm_message("%d colors found", colors);
      break;
    default:
      /* must read the whole file into memory */
      init_read(ifp, &cols, &rows, &maxval, &format, 1);

      /* Figure out the colormap. */
      if (mapfile) {
	int mapcols, maprows, row, col;
	pixel **mappixels, *pP;
	pixval mapmaxval;
	FILE *mapfp;

	pm_message("reading colormap file...");
	mapfp = pm_openr(mapfile);
	mappixels = ppm_readppm(mapfp, &mapcols, &maprows, &mapmaxval);
	pm_close(mapfp);
	if (mapcols == 0 || maprows == 0)
	  pm_error("null colormap??");

	/* if the maxvals of the ppmfile and the mapfile are the same,
	 * then the scaling to MAXCOLVAL (if necessary) will be done by
	 * the write_std_cmap() function.
	 * Otherwise scale them both to MAXCOLVAL.
	 */
	if (maxval != mapmaxval) {
	  if (mapmaxval != MAXCOLVAL) {
	    pixval *table;

	    pm_message("colormap maxval is not %d - rescaling colormap...", MAXCOLVAL);
	    table = make_val_table(mapmaxval, MAXCOLVAL);
	    for (row = 0; row < maprows; ++row)
	      for (col = 0, pP = mappixels[row]; col < mapcols; ++col, ++pP)
		NEWDEPTH(*pP, table);				/* was PPM_DEPTH( *pP, *pP, mapmaxval, MAXCOLVAL ); */
	    mapmaxval = MAXCOLVAL;
	    free(table);
	  }

	  if (maxval != mapmaxval) {
	    pixval *table;

	    pm_message("rescaling colors of picture...");
	    table = make_val_table(maxval, mapmaxval);
	    for (row = 0; row < rows; ++row)
	      for (col = 0, pP = pixels[row]; col < cols; ++col, ++pP)
		NEWDEPTH(*pP, table);				/* was PPM_DEPTH( *pP, *pP, maxval, mapmaxval ); */
	    maxval = mapmaxval;
	    free(table);
	  }
	}

	pm_message("computing colormap...");
	chv = ppm_computecolorhist(mappixels, mapcols, maprows, MAXCMAPCOLORS, &colors);
	ppm_freearray(mappixels, maprows);
	if (chv == (colorhist_vector) 0)
	  pm_error("too many colors in colormap!");
	pm_message("%d colors found in colormap", colors);

	nPlanes = fixplanes = maxplanes = colorstobpp(colors);
      }
      else {							/* no mapfile */
	pm_message("computing colormap...");
	chv = ppm_computecolorhist(pixels, cols, rows, MAXCOLORS, &colors);
	if (chv == (colorhist_vector) 0) {
	  /* too many colors */
	  mode = ifmode;
	  switch (ifmode) {
	    case MODE_HAM:
	      pm_message("too many colors - proceeding to write a HAM%d file", hambits);
	      pm_message("if you want a non-HAM file, try doing a 'ppmquant %d'", MAXCOLORS);
	      break;
	    case MODE_24:
	      pm_message("too many colors - proceeding to write a 24bit file");
	      pm_message("if you want a non-24bit file, try doing a 'ppmquant %d'", MAXCOLORS);
	      break;
	    case MODE_DIRECT:
	      pm_message("too many colors - proceeding to write a %d:%d:%d direct color file",
			 dcol.r, dcol.g, dcol.b);
	      pm_message("if you want a non-direct-color file, try doing a 'ppmquant %d'", MAXCOLORS);
	      break;
	    default:
	      pm_message("too many colors for %d planes", maxplanes);
	      pm_message("either use -hamif/-hamforce/-24if/-24force/-dcif/-dcforce/-maxplanes,");
	      pm_error("or try doing a 'ppmquant %d'", MAXCOLORS);
	      break;
	  }
	}
	else {
	  pm_message("%d colors found", colors);
	  nPlanes = colorstobpp(colors);
	  if (fixplanes > nPlanes)
	    nPlanes = fixplanes;
	}
      }
      break;
  }

  if (mode != MODE_CMAP) {
    register int i;
    coded_rowbuf = MALLOC(RowBytes(cols), unsigned char);

    for (i = 0; i < RowBytes(cols); i++)
      coded_rowbuf[i] = 0;
    if (DO_COMPRESS)
      compr_rowbuf = MALLOC(WORSTCOMPR(RowBytes(cols)), unsigned char);
  }

  switch (mode) {
    case MODE_HAM:{
	int nocolor;

	nocolor = !(PPM_FORMAT_TYPE(format) == PPM_TYPE);
	if (nocolor)
	  floyd = 0;

	viewportmodes |= vmHAM;
	ppm_to_ham(ifp, cols, rows, maxval, hambits, nocolor);
      }
      break;
    case MODE_24:
      ppm_to_24(ifp, cols, rows, maxval);
      break;
    case MODE_DIRECT:
      ppm_to_direct(ifp, cols, rows, maxval, &dcol);
      break;
    case MODE_CMAP:
      ppm_to_cmap(maxval, chv, colors);
      break;
    default:
      if (mapfile == NULL)
	floyd = 0;						/* would only slow down conversion */
      ppm_to_std(ifp, cols, rows, maxval, chv, colors, nPlanes);
      break;
  }
  pm_close(ifp);
  exit(0);
  /*NOTREACHED */
}

staticfnc int get_int_val(string, option, bot, top)
    char *string, *option;
    int bot, top;
{
  int val;

  if (sscanf(string, "%d", &val) != 1)
    pm_error("option \"%s\" needs integer argument", option);

  if (val < bot || val > top)
    pm_error("option \"%s\" argument value out of range (%d..%d)", option, bot, top);

  return val;
}

staticfnc int get_compr_type(string)
    char *string;
{
  int i;

  for (i = 0; i <= cmpMAXKNOWN; i++) {
    if (strcmp(string, cmpNAME[i]) == 0)
      return i;
  }
  pm_message("unknown compression method: %s", string);
  pm_message("using default compression (%s)", cmpNAME[DEF_COMPRESSION]);
  return DEF_COMPRESSION;
}

/************ colormap file ************/

staticfnc void ppm_to_cmap(maxval, chv, colors)
    int maxval;
    colorhist_vector chv;
    int colors;
{
  int formsize, cmapsize;

  cmapsize = colors * 3;

  formsize =
    4 +								/* ILBM */
    4 + 4 + BitMapHeaderSize +					/* BMHD size header */
    4 + 4 + cmapsize + PAD(cmapsize);				/* CMAP size colormap */

  write_form_ilbm(formsize);
  write_bmhd(0, 0, 0);
  write_std_cmap(chv, colors, maxval);
}

/************ HAM ************/

staticfnc long do_ham_body ARGS((FILE * ifp, FILE * ofp, int cols, int rows, pixval maxval, pixval hammaxval, int nPlanes, int colbits, int no));

staticfnc void ppm_to_ham(fp, cols, rows, maxval, hambits, nocolor)
    FILE *fp;
    int cols, rows, maxval, hambits, nocolor;
{
  int colors, colbits, nPlanes, i, hammaxval;
  long oldsize, bodysize, formsize, cmapsize;
  pixval *table = NULL;

  colbits = hambits - 2;
  colors = 1 << colbits;
  hammaxval = pm_bitstomaxval(colbits);
  nPlanes = hambits;
  cmapsize = colors * 3;

  bodysize = oldsize = rows * nPlanes * RowBytes(cols);
  if (DO_COMPRESS) {
    alloc_body_array(rows, nPlanes);
    bodysize = do_ham_body(fp, NULL, cols, rows, maxval, hammaxval, nPlanes, colbits, nocolor);
    if (bodysize > oldsize)
      pm_message("warning - %s compression increases BODY size by %d%%", cmpNAME[compr_type], 100 * (bodysize - oldsize) / oldsize);
    else
      pm_message("BODY compression (%s): %d%%", cmpNAME[compr_type], 100 * (oldsize - bodysize) / oldsize);
  }

  formsize =
    4 +								/* ILBM */
    4 + 4 + BitMapHeaderSize +					/* BMHD size header */
    CAMGSIZE +							/* 0 or CAMG size val */
    4 + 4 + cmapsize + PAD(cmapsize) +				/* CMAP size colormap */
    4 + 4 + bodysize + PAD(bodysize);				/* BODY size data */

  write_form_ilbm(formsize);
  write_bmhd(cols, rows, nPlanes);
  write_camg();

  /* write grayscale colormap */
  put_fourchars("CMAP");
  put_big_long(cmapsize);
  table = make_val_table(hammaxval, MAXCOLVAL);
  for (i = 0; i < colors; i++) {
    put_byte(table[i]);						/* red */
    put_byte(table[i]);						/* green */
    put_byte(table[i]);						/* blue */
  }
  free(table);
  if (odd(cmapsize))
    put_byte(0);

  /* write body */
  put_fourchars("BODY");
  put_big_long(bodysize);
  if (DO_COMPRESS)
    write_body();
  else
    do_ham_body(fp, stdout, cols, rows, maxval, hammaxval, nPlanes, colbits, nocolor);
  if (odd(bodysize))
    put_byte(0);
}

staticfnc long do_ham_body(ifp, ofp, cols, rows, maxval, hammaxval, nPlanes, colbits, nocolor)
    FILE *ifp, *ofp;
    int cols, rows;
    pixval maxval, hammaxval;
    int nPlanes, colbits, nocolor;
{
  register int col, row;
  pixel *pP;
  pixval *table = NULL;
  rawtype *raw_rowbuf;
  floydinfo *fi;
  long bodysize = 0;

  raw_rowbuf = MALLOC(cols, rawtype);

  if (hammaxval != maxval)
    table = make_val_table(maxval, hammaxval);

  if (floyd) {
    fi = init_floyd(cols, maxval, 0);
  }

  for (row = 0; row < rows; row++) {
    register int noprev, pr, pg, pb, r, g, b, l;
    int fpr, fpg, fpb;						/* unscaled previous color values, for floyd */

    pP = next_pixrow(ifp, row);
    if (floyd)
      begin_floyd_row(fi, pP);

    noprev = 1;
    for (col = 0; col < cols; col++, pP++) {
      int fr, fg, fb, fl;					/* unscaled color values, for floyd */

      if (floyd)
	pP = next_floyd_pixel(fi);

      r = fr = PPM_GETR(*pP);
      g = fg = PPM_GETG(*pP);
      b = fb = PPM_GETB(*pP);
      if (maxval <= 255)					/* Use fast approximation to 0.299 r + 0.587 g + 0.114 b. */
	l = fl = (int)((times77[r] + times150[g] + times29[b] + 128) >> 8);
      else							/* Can't use fast approximation, so fall back on floats. */
	l = fl = (int)(PPM_LUMIN(*pP) + 0.5);			/* -IUW added '+ 0.5' */

      if (table) {
	r = table[r];
	g = table[g];
	b = table[b];
	l = table[l];
      }

      if (noprev || nocolor) {
	/* No previous pixels, gotta use the gray option. */
	raw_rowbuf[col] = l /* + (HAMCODE_CMAP << colbits) */ ;
	pr = pg = pb = l;
	fpr = fpg = fpb = fl;
	noprev = 0;
      }
      else {
	register int dred, dgreen, dblue, dgray;

	/* Compute distances for the four options. */
	dred = abs(g - pg) + abs(b - pb);
	dgreen = abs(r - pr) + abs(b - pb);
	dblue = abs(r - pr) + abs(g - pg);
	dgray = abs(r - l) + abs(g - l) + abs(b - l);

	/* simply doing  raw_rowbuf[col] = ...
	 * is ok here because there is no fs-alternation performed
	 * for HAM.  Otherwise we would have to do
	 *     if( floyd )  raw_rowbuf[fi->col] = ...
	 *     else         raw_rowbuf[col] = ...
	 */
	if (dgray <= dred && dgray <= dgreen && dgray <= dblue) {	/* -IUW  '<=' was '<'  */
	  raw_rowbuf[col] = l /* + (HAMCODE_CMAP << colbits) */ ;
	  pr = pg = pb = l;
	  fpr = fpg = fpb = fl;
	}
	else if (dblue <= dred && dblue <= dgreen) {
	  raw_rowbuf[col] = b + (HAMCODE_BLUE << colbits);
	  pb = b;
	  fpb = fb;
	}
	else if (dred <= dgreen) {
	  raw_rowbuf[col] = r + (HAMCODE_RED << colbits);
	  pr = r;
	  fpr = fr;
	}
	else {
	  raw_rowbuf[col] = g + (HAMCODE_GREEN << colbits);
	  pg = g;
	  fpg = fg;
	}
      }
      if (floyd)
	update_floyd_pixel(fi, fpr, fpg, fpb);
    }
    bodysize += encode_row(ofp, raw_rowbuf, cols, nPlanes);
    if (floyd)
      end_floyd_row(fi);
  }
  /* clean up */
  if (table)
    free(table);
  free(raw_rowbuf);
  if (floyd)
    free_floyd(fi);

  return bodysize;
}

/************ 24bit ************/

staticfnc long do_24_body ARGS((FILE * ifp, FILE * ofp, int cols, int rows, pixval maxval));

staticfnc void ppm_to_24(fp, cols, rows, maxval)
    FILE *fp;
    int cols, rows, maxval;
{
  int nPlanes;
  long bodysize, oldsize, formsize;

  nPlanes = 24;

  bodysize = oldsize = rows * nPlanes * RowBytes(cols);
  if (DO_COMPRESS) {
    alloc_body_array(rows, nPlanes);
    bodysize = do_24_body(fp, NULL, cols, rows, maxval);
    if (bodysize > oldsize)
      pm_message("warning - %s compression increases BODY size by %d%%", cmpNAME[compr_type], 100 * (bodysize - oldsize) / oldsize);
    else
      pm_message("BODY compression (%s): %d%%", cmpNAME[compr_type], 100 * (oldsize - bodysize) / oldsize);
  }

  formsize =
    4 +								/* ILBM */
    4 + 4 + BitMapHeaderSize +					/* BMHD size header */
    CAMGSIZE +							/* 0 or CAMG size val */
    4 + 4 + bodysize + PAD(bodysize);				/* BODY size data */

  write_form_ilbm(formsize);
  write_bmhd(cols, rows, nPlanes);
  write_camg();

  /* write body */
  put_fourchars("BODY");
  put_big_long(bodysize);
  if (DO_COMPRESS)
    write_body();
  else
    do_24_body(fp, stdout, cols, rows, maxval);
  if (odd(bodysize))
    put_byte(0);
}

staticfnc long do_24_body(ifp, ofp, cols, rows, maxval)
    FILE *ifp, *ofp;
    int cols, rows;
    pixval maxval;
{
  register int row, col;
  pixel *pP;
  pixval *table = NULL;
  long bodysize = 0;
  rawtype *redbuf, *greenbuf, *bluebuf;

  redbuf = MALLOC(cols, rawtype);
  greenbuf = MALLOC(cols, rawtype);
  bluebuf = MALLOC(cols, rawtype);

  if (maxval != MAXCOLVAL) {
    pm_message("maxval is not %d - automatically rescaling colors", MAXCOLVAL);
    table = make_val_table(maxval, MAXCOLVAL);
  }

  for (row = 0; row < rows; row++) {
    pP = next_pixrow(ifp, row);
    if (table) {
      for (col = 0; col < cols; col++, pP++) {
	redbuf[col] = table[PPM_GETR(*pP)];
	greenbuf[col] = table[PPM_GETG(*pP)];
	bluebuf[col] = table[PPM_GETB(*pP)];
      }
    }
    else {
      for (col = 0; col < cols; col++, pP++) {
	redbuf[col] = PPM_GETR(*pP);
	greenbuf[col] = PPM_GETG(*pP);
	bluebuf[col] = PPM_GETB(*pP);
      }
    }
    bodysize += encode_row(ofp, redbuf, cols, 8);
    bodysize += encode_row(ofp, greenbuf, cols, 8);
    bodysize += encode_row(ofp, bluebuf, cols, 8);
  }
  /* clean up */
  if (table)
    free(table);
  free(redbuf);
  free(greenbuf);
  free(bluebuf);

  return bodysize;
}

/************ direct color ************/

staticfnc long do_direct_body ARGS((FILE * ifp, FILE * ofp, int cols, int rows, pixval maxval, DirectColor * dcol));

staticfnc void ppm_to_direct(fp, cols, rows, maxval, dcol)
    FILE *fp;
    int cols, rows, maxval;
    DirectColor *dcol;
{
  int nPlanes;
  long formsize, bodysize, oldsize;

  nPlanes = dcol->r + dcol->g + dcol->b;

  bodysize = oldsize = rows * nPlanes * RowBytes(cols);
  if (DO_COMPRESS) {
    alloc_body_array(rows, nPlanes);
    bodysize = do_direct_body(fp, NULL, cols, rows, maxval, dcol);
    if (bodysize > oldsize)
      pm_message("warning - %s compression increases BODY size by %d%%", cmpNAME[compr_type], 100 * (bodysize - oldsize) / oldsize);
    else
      pm_message("BODY compression (%s): %d%%", cmpNAME[compr_type], 100 * (oldsize - bodysize) / oldsize);
  }

  formsize =
    4 +								/* ILBM */
    4 + 4 + BitMapHeaderSize +					/* BMHD size header */
    CAMGSIZE +							/* 0 or CAMG size val */
    4 + 4 + DirectColorSize +					/* DCOL size description */
    4 + 4 + bodysize + PAD(bodysize);				/* BODY size data */

  write_form_ilbm(formsize);
  write_bmhd(cols, rows, nPlanes);
  write_camg();

  /* write DCOL */
  put_fourchars("DCOL");
  put_big_long(DirectColorSize);
  put_byte(dcol->r);
  put_byte(dcol->g);
  put_byte(dcol->b);
  put_byte(0);							/* pad */

  /* write body */
  put_fourchars("BODY");
  put_big_long(bodysize);
  if (DO_COMPRESS)
    write_body();
  else
    do_direct_body(fp, stdout, cols, rows, maxval, dcol);
  if (odd(bodysize))
    put_byte(0);
}

staticfnc long do_direct_body(ifp, ofp, cols, rows, maxval, dcol)
    FILE *ifp, *ofp;
    int cols, rows;
    pixval maxval;
    DirectColor *dcol;
{
  register int row, col;
  pixel *pP;
  pixval *redtable = NULL, *greentable = NULL, *bluetable = NULL;
  pixval redmaxval, greenmaxval, bluemaxval;
  rawtype *redbuf, *greenbuf, *bluebuf;
  long bodysize = 0;

  redbuf = MALLOC(cols, rawtype);
  greenbuf = MALLOC(cols, rawtype);
  bluebuf = MALLOC(cols, rawtype);

  redmaxval = pm_bitstomaxval(dcol->r);
  if (redmaxval != maxval) {
    pm_message("rescaling reds to %d bits", dcol->r);
    redtable = make_val_table(maxval, redmaxval);
  }
  greenmaxval = pm_bitstomaxval(dcol->g);
  if (greenmaxval != maxval) {
    pm_message("rescaling greens to %d bits", dcol->g);
    greentable = make_val_table(maxval, greenmaxval);
  }
  bluemaxval = pm_bitstomaxval(dcol->b);
  if (bluemaxval != maxval) {
    pm_message("rescaling blues to %d bits", dcol->b);
    bluetable = make_val_table(maxval, bluemaxval);
  }

  for (row = 0; row < rows; row++) {
    pP = next_pixrow(ifp, row);
    for (col = 0; col < cols; col++, pP++) {
      register pixval r, g, b;

      r = PPM_GETR(*pP);
      if (redtable)
	r = redtable[r];
      g = PPM_GETG(*pP);
      if (greentable)
	g = greentable[g];
      b = PPM_GETB(*pP);
      if (bluetable)
	b = bluetable[b];

      redbuf[col] = r;
      greenbuf[col] = g;
      bluebuf[col] = b;
    }
    bodysize += encode_row(ofp, redbuf, cols, dcol->r);
    bodysize += encode_row(ofp, greenbuf, cols, dcol->g);
    bodysize += encode_row(ofp, bluebuf, cols, dcol->b);
  }
  /* clean up */
  if (redtable)
    free(redtable);
  if (greentable)
    free(greentable);
  if (bluetable)
    free(bluetable);
  free(redbuf);
  free(greenbuf);
  free(bluebuf);

  return bodysize;
}

/************ normal colormapped ************/

staticfnc long do_std_body ARGS((FILE * ifp, FILE * ofp, int cols, int rows, pixval maxval, colorhist_vector chv, int colors, int nPlanes));

staticfnc void ppm_to_std(fp, cols, rows, maxval, chv, colors, nPlanes)
    FILE *fp;
    int cols, rows, maxval;
    colorhist_vector chv;
    int colors, nPlanes;
{
  long formsize, cmapsize, bodysize, oldsize;

  bodysize = oldsize = rows * nPlanes * RowBytes(cols);
  if (DO_COMPRESS) {
    alloc_body_array(rows, nPlanes);
    bodysize = do_std_body(fp, NULL, cols, rows, maxval, chv, colors, nPlanes);
    if (bodysize > oldsize)
      pm_message("warning - %s compression increases BODY size by %d%%", cmpNAME[compr_type], 100 * (bodysize - oldsize) / oldsize);
    else
      pm_message("BODY compression (%s): %d%%", cmpNAME[compr_type], 100 * (oldsize - bodysize) / oldsize);
  }

  cmapsize = colors * 3;

  formsize =
    4 +								/* ILBM */
    4 + 4 + BitMapHeaderSize +					/* BMHD size header */
    CAMGSIZE +							/* 0 or CAMG size val */
    4 + 4 + cmapsize + PAD(cmapsize) +				/* CMAP size colormap */
    4 + 4 + bodysize + PAD(bodysize);				/* BODY size data */

  write_form_ilbm(formsize);
  write_bmhd(cols, rows, nPlanes);
  write_camg();
  write_std_cmap(chv, colors, maxval);

  /* write body */
  put_fourchars("BODY");
  put_big_long(bodysize);
  if (DO_COMPRESS)
    write_body();
  else
    do_std_body(fp, stdout, cols, rows, maxval, chv, colors, nPlanes);
  if (odd(bodysize))
    put_byte(0);
}

staticfnc long do_std_body(ifp, ofp, cols, rows, maxval, chv, colors, nPlanes)
    FILE *ifp, *ofp;
    int cols, rows;
    pixval maxval;
    colorhist_vector chv;
    int colors, nPlanes;
{
  colorhash_table cht;
  register int row, col;
  pixel *pP;
  rawtype *raw_rowbuf;
  floydinfo *fi;
  long bodysize = 0;
  short usehash = !savemem;

  raw_rowbuf = MALLOC(cols, rawtype);

  /* Make a hash table for fast color lookup. */
  cht = ppm_colorhisttocolorhash(chv, colors);

  if (floyd)
    fi = init_floyd(cols, maxval, 1);

  for (row = 0; row < rows; row++) {
    pP = next_pixrow(ifp, row);
    if (floyd)
      begin_floyd_row(fi, pP);

    for (col = 0; col < cols; col++, pP++) {
      int ind;

      if (floyd)
	pP = next_floyd_pixel(fi);

      /* Check hash table to see if we have already matched this color. */
      ind = ppm_lookupcolor(cht, pP);
      if (ind == -1) {
	ind = closest_color(chv, colors, maxval, pP);		/* No; search colormap for closest match. */
	if (usehash) {
	  if (ppm_addtocolorhash(cht, pP, ind) < 0) {
	    pm_message("out of memory adding to hash table, proceeding without it");
	    usehash = 0;
	  }
	}
      }
      if (floyd) {
	raw_rowbuf[fi->col] = ind;
	update_floyd_pixel(fi, (int)PPM_GETR(chv[ind].color), (int)PPM_GETG(chv[ind].color), (int)PPM_GETB(chv[ind].color));
      }
      else
	raw_rowbuf[col] = ind;
    }
    if (floyd)
      end_floyd_row(fi);
    bodysize += encode_row(ofp, raw_rowbuf, cols, nPlanes);
  }
  /* clean up */
  free(raw_rowbuf);
  ppm_freecolorhash(cht);
  if (floyd)
    free_floyd(fi);

  return bodysize;
}

/************ multipalette ************/

#ifdef ILBM_PCHG
static pixel *ppmslice[2];					/* need 2 for laced ILBMs, else 1 */

void ppm_to_pchg()
{
/*
 * read first slice
 * build a colormap from this slice
 * select upto <maxcolors> colors
 * build colormap from selected colors
 * map slice to colormap
 * write slice
 * while( !finished ) {
 * read next slice
 * compute distances for each pixel and select upto
 * <maxchangesperslice> unused colors in this slice
 * modify selected colors to the ones with maximum(?) distance
 * map slice to colormap
 * write slice
 * }
 * 
 * 
 * for HAM use a different mapping:
 * compute distance to closest color in colormap
 * if( there is no matching color in colormap ) {
 * compute distances for the three "modify" cases
 * use the shortest distance from the four cases
 * }
 */
}

#endif

/************ ILBM functions ************/

staticfnc void write_std_cmap(chv, colors, maxval)
    colorhist_vector chv;
    int colors, maxval;
{
  int cmapsize, i;

  cmapsize = 3 * colors;

  /* write colormap */
  put_fourchars("CMAP");
  put_big_long(cmapsize);
  if (maxval != MAXCOLVAL) {
    pixval *table;

    pm_message("maxval is not %d - automatically rescaling colors", MAXCOLVAL);
    table = make_val_table(maxval, MAXCOLVAL);
    for (i = 0; i < colors; i++) {
      put_byte(table[PPM_GETR(chv[i].color)]);
      put_byte(table[PPM_GETG(chv[i].color)]);
      put_byte(table[PPM_GETB(chv[i].color)]);
    }
    free(table);
  }
  else {
    for (i = 0; i < colors; i++) {
      put_byte(PPM_GETR(chv[i].color));
      put_byte(PPM_GETG(chv[i].color));
      put_byte(PPM_GETB(chv[i].color));
    }
  }
  if (odd(cmapsize))
    put_byte(0);
}

staticfnc void write_form_ilbm(size)
    int size;
{
  put_fourchars("FORM");
  put_big_long(size);
  put_fourchars("ILBM");
}

staticfnc void write_bmhd(cols, rows, nPlanes)
    int cols, rows, nPlanes;
{
  unsigned int xasp = 10, yasp = 10;

  if (viewportmodes & vmLACE)
    xasp *= 2;
  if (viewportmodes & vmHIRES)
    yasp *= 2;

  put_fourchars("BMHD");
  put_big_long(BitMapHeaderSize);

  put_big_short(cols);
  put_big_short(rows);
  put_big_short(0);						/* x-offset */
  put_big_short(0);						/* y-offset */
  put_byte(nPlanes);						/* no of planes */
  put_byte(mskNone);						/* masking type */
  put_byte((unsigned char)compr_type);				/* compression type */
  put_byte(0);							/* pad1 */
  put_big_short(0);						/* tranparentColor */
  put_byte(xasp);						/* x-aspect */
  put_byte(yasp);						/* y-aspect */
  put_big_short(cols);						/* pageWidth */
  put_big_short(rows);						/* pageHeight */
}

/* encode algorithm by Johan Widen (jw@jwdata.se) */
const unsigned char ppmtoilbm_bitmask[] =
{1, 2, 4, 8, 16, 32, 64, 128};

staticfnc int encode_row(outfile, rawrow, cols, nPlanes)
    FILE *outfile;						/* if non-NULL, write uncompressed row to this file */
    rawtype *rawrow;
    int cols, nPlanes;
{
  int plane, bytes;
  long retbytes = 0;

  bytes = RowBytes(cols);

  /* Encode and write raw bytes in plane-interleaved form. */
  for (plane = 0; plane < nPlanes; plane++) {
    register int col, cbit;
    register rawtype *rp;
    register unsigned char *cp;
    int mask;

    mask = 1 << plane;
    cbit = -1;
    cp = coded_rowbuf - 1;
    rp = rawrow;
    for (col = 0; col < cols; col++, cbit--, rp++) {
      if (cbit < 0) {
	cbit = 7;
	*++cp = 0;
      }
      if (*rp & mask)
	*cp |= ppmtoilbm_bitmask[cbit];
    }
    if (outfile) {
      retbytes += bytes;
      if (fwrite(coded_rowbuf, 1, bytes, stdout) != bytes)
	pm_error("write error");
    }
    else
      retbytes += compress_row(bytes);
  }
  return retbytes;
}

staticfnc int compress_row(bytes)
    int bytes;
{
  static int count;
  int newbytes;

  /* if new compression methods are defined, do a switch here */
  newbytes = runbyte1(bytes);

  if (savemem) {
    ilbm_body[count].row = MALLOC(newbytes, unsigned char);

    bcopy(compr_rowbuf, ilbm_body[count].row, newbytes);
  }
  else {
    ilbm_body[count].row = compr_rowbuf;
    compr_rowbuf = MALLOC(WORSTCOMPR(bytes), unsigned char);
  }
  ilbm_body[count].len = newbytes;
  ++count;

  return newbytes;
}

staticfnc void
write_body ARGS((void))
{
  bodyrow *p;

  for (p = ilbm_body; p->row != NULL; p++) {
    if (fwrite(p->row, 1, p->len, stdout) != p->len)
      pm_error("write error");
  }
  /* pad byte (if neccessary) is written by do_xxx_body() function */
}

staticfnc void
write_camg ARGS((void))
{
  if (viewportmodes) {
    put_fourchars("CAMG");
    put_big_long(CAMGChunkSize);
    put_big_long(viewportmodes);
  }
}

/************ compression ************/

/* runbyte1 algorithm by Robert A. Knop (rknop@mop.caltech.edu) */
staticfnc int runbyte1(size)
    int size;
{
  int in, out, count, hold;
  register unsigned char *inbuf = coded_rowbuf;
  register unsigned char *outbuf = compr_rowbuf;

  in = out = 0;
  while (in < size) {
    if ((in < size - 1) && (inbuf[in] == inbuf[in + 1])) {	/*Begin replicate run */
      for (count = 0, hold = in; in < size && inbuf[in] == inbuf[hold] && count < 128; in++, count++);
      outbuf[out++] = (unsigned char)(char)(-count + 1);
      outbuf[out++] = inbuf[hold];
    }
    else {							/*Do a literal run */
      hold = out;
      out++;
      count = 0;
      while (((in >= size - 2) && (in < size)) || ((in < size - 2) && ((inbuf[in] != inbuf[in + 1]) || (inbuf[in] != inbuf[in + 2])))) {
	outbuf[out++] = inbuf[in++];
	if (++count >= 128)
	  break;
      }
      outbuf[hold] = count - 1;
    }
  }
  return (out);
}

/************ PPM functions ************/

staticfnc int closest_color(chv, colors, cmaxval, pP)
    colorhist_vector chv;
    int colors;
    pixval cmaxval;
    pixel *pP;
{
  /* Search colormap for closest match.       */
  /* algorithm taken from ppmquant.c   -IUW   */
  register int i, r1, g1, b1;
  int ind;
  long dist;

  r1 = PPM_GETR(*pP);
  g1 = PPM_GETG(*pP);
  b1 = PPM_GETB(*pP);
  dist = 2000000000;
  for (i = 0; i < colors; i++) {
    register int r2, g2, b2;
    long newdist;

    r2 = PPM_GETR(chv[i].color);
    g2 = PPM_GETG(chv[i].color);
    b2 = PPM_GETB(chv[i].color);
    newdist = (r1 - r2) * (r1 - r2) +
      (g1 - g2) * (g1 - g2) +
      (b1 - b2) * (b1 - b2);

    if (newdist < dist) {
      ind = i;
      dist = newdist;
    }
  }
  return ind;
}

/************ floyd-steinberg error diffusion ************/

staticfnc floydinfo *
  init_floyd(cols, maxval, alternate)
    int cols;
    pixval maxval;
    int alternate;
{
  register int i;
  floydinfo *fi;

  fi = MALLOC(1, floydinfo);

  fi->thisrederr = MALLOC(cols + 2, long);
  fi->thisgreenerr = MALLOC(cols + 2, long);
  fi->thisblueerr = MALLOC(cols + 2, long);
  fi->nextrederr = MALLOC(cols + 2, long);
  fi->nextgreenerr = MALLOC(cols + 2, long);
  fi->nextblueerr = MALLOC(cols + 2, long);

  fi->lefttoright = 1;
  fi->cols = cols;
  fi->maxval = maxval;
  fi->alternate = alternate;

  for (i = 0; i < cols + 2; i++)
    fi->thisrederr[i] = fi->thisgreenerr[i] = fi->thisblueerr[i] = 0;

  return fi;
}

staticfnc void free_floyd(fi)
    floydinfo *fi;
{
  free(fi->thisrederr);
  free(fi->thisgreenerr);
  free(fi->thisblueerr);
  free(fi->nextrederr);
  free(fi->nextgreenerr);
  free(fi->nextblueerr);
  free(fi);
}

staticfnc void begin_floyd_row(fi, prow)
    floydinfo *fi;
    pixel *prow;
{
  register int i;

  fi->pixrow = prow;

  for (i = 0; i < fi->cols + 2; i++)
    fi->nextrederr[i] = fi->nextgreenerr[i] = fi->nextblueerr[i] = 0;

  if (fi->lefttoright) {
    fi->col = 0;
    fi->col_end = fi->cols;
  }
  else {
    fi->col = fi->cols - 1;
    fi->col_end = -1;
  }
}

#define FS_GREEN_WEIGHT     1
#define FS_RED_WEIGHT       2					/* luminance of component relative to green */
#define FS_BLUE_WEIGHT      5

staticfnc pixel *
  next_floyd_pixel(fi)
    floydinfo *fi;
{
  register long r, g, b;
  register pixel *pP;
  int errcol = fi->col + 1;
  pixval maxval = fi->maxval;

#ifdef DEBUG
  if (fi->col == fi->col_end)
    pm_error("fs - access out of array bounds");		/* should never happen */
#endif

  pP = &(fi->pixrow[fi->col]);

  /* Use Floyd-Steinberg errors to adjust actual color. */
  r = fi->thisrederr[errcol];
  if (r < 0)
    r -= 8;
  else
    r += 8;
  r /= 16;
  g = fi->thisgreenerr[errcol];
  if (g < 0)
    g -= 8;
  else
    g += 8;
  g /= 16;
  b = fi->thisblueerr[errcol];
  if (b < 0)
    b -= 8;
  else
    b += 8;
  b /= 16;

  if (floyd == 2) {						/* EXPERIMENTAL */
    r /= FS_RED_WEIGHT;
    b /= FS_BLUE_WEIGHT;
  }

  r += PPM_GETR(*pP);
  if (r < 0)
    r = 0;
  else if (r > maxval)
    r = maxval;
  g += PPM_GETG(*pP);
  if (g < 0)
    g = 0;
  else if (g > maxval)
    g = maxval;
  b += PPM_GETB(*pP);
  if (b < 0)
    b = 0;
  else if (b > maxval)
    b = maxval;

  PPM_ASSIGN(*pP, r, g, b);

  fi->red = r;
  fi->green = g;
  fi->blue = b;

  return pP;
}

staticfnc void update_floyd_pixel(fi, r, g, b)
    floydinfo *fi;
    int r, g, b;
{
  register long rerr, gerr, berr, err;
  int col = fi->col;
  int errcol = col + 1;
  long two_err;

  rerr = (long)(fi->red) - r;
  gerr = (long)(fi->green) - g;
  berr = (long)(fi->blue) - b;

  if (fi->lefttoright) {
    two_err = 2 * rerr;
    err = rerr;
    fi->nextrederr[errcol + 1] += err;				/* 1/16 */
    err += two_err;
    fi->nextrederr[errcol - 1] += err;				/* 3/16 */
    err += two_err;
    fi->nextrederr[errcol] += err;				/* 5/16 */
    err += two_err;
    fi->thisrederr[errcol + 1] += err;				/* 7/16 */

    two_err = 2 * gerr;
    err = gerr;
    fi->nextgreenerr[errcol + 1] += err;			/* 1/16 */
    err += two_err;
    fi->nextgreenerr[errcol - 1] += err;			/* 3/16 */
    err += two_err;
    fi->nextgreenerr[errcol] += err;				/* 5/16 */
    err += two_err;
    fi->thisgreenerr[errcol + 1] += err;			/* 7/16 */

    two_err = 2 * berr;
    err = berr;
    fi->nextblueerr[errcol + 1] += err;				/* 1/16 */
    err += two_err;
    fi->nextblueerr[errcol - 1] += err;				/* 3/16 */
    err += two_err;
    fi->nextblueerr[errcol] += err;				/* 5/16 */
    err += two_err;
    fi->thisblueerr[errcol + 1] += err;				/* 7/16 */

    fi->col++;
  }
  else {
    two_err = 2 * rerr;
    err = rerr;
    fi->nextrederr[errcol - 1] += err;				/* 1/16 */
    err += two_err;
    fi->nextrederr[errcol + 1] += err;				/* 3/16 */
    err += two_err;
    fi->nextrederr[errcol] += err;				/* 5/16 */
    err += two_err;
    fi->thisrederr[errcol - 1] += err;				/* 7/16 */

    two_err = 2 * gerr;
    err = gerr;
    fi->nextgreenerr[errcol - 1] += err;			/* 1/16 */
    err += two_err;
    fi->nextgreenerr[errcol + 1] += err;			/* 3/16 */
    err += two_err;
    fi->nextgreenerr[errcol] += err;				/* 5/16 */
    err += two_err;
    fi->thisgreenerr[errcol - 1] += err;			/* 7/16 */

    two_err = 2 * berr;
    err = berr;
    fi->nextblueerr[errcol - 1] += err;				/* 1/16 */
    err += two_err;
    fi->nextblueerr[errcol + 1] += err;				/* 3/16 */
    err += two_err;
    fi->nextblueerr[errcol] += err;				/* 5/16 */
    err += two_err;
    fi->thisblueerr[errcol - 1] += err;				/* 7/16 */

    fi->col--;
  }
}

staticfnc void end_floyd_row(fi)
    floydinfo *fi;
{
  long *tmp;

  tmp = fi->thisrederr;
  fi->thisrederr = fi->nextrederr;
  fi->nextrederr = tmp;
  tmp = fi->thisgreenerr;
  fi->thisgreenerr = fi->nextgreenerr;
  fi->nextgreenerr = tmp;
  tmp = fi->thisblueerr;
  fi->thisblueerr = fi->nextblueerr;
  fi->nextblueerr = tmp;
  if (fi->alternate)
    fi->lefttoright = !(fi->lefttoright);
}

/************ other utility functions ************/

staticfnc void alloc_body_array(rows, nPlanes)
    int rows, nPlanes;
{
  ilbm_body = MALLOC(rows * nPlanes + 1, bodyrow);
  ilbm_body[rows * nPlanes].row = NULL;
}

staticfnc int colorstobpp(colors)
    int colors;
{
  int i;

  for (i = 1; i <= MAXPLANES; i++) {
    if (colors <= (1 << i))
      return i;
  }
  pm_error("too many planes (max %d)", MAXPLANES);
  /*NOTREACHED */
}

staticfnc void put_big_short(s)
    short s;
{
  if (pm_writebigshort(stdout, s) == -1)
    pm_error("write error");
}

staticfnc void put_big_long(l)
    long l;
{
  if (pm_writebiglong(stdout, l) == -1)
    pm_error("write error");
}

staticfnc pixval *
  make_val_table(oldmaxval, newmaxval)
    pixval oldmaxval, newmaxval;
{
  int i;
  pixval *table;

  table = MALLOC(oldmaxval + 1, pixval);
  for (i = 0; i <= oldmaxval; i++)
    table[i] = (i * newmaxval + oldmaxval / 2) / oldmaxval;

  return table;
}

staticfnc void *
  xmalloc(bytes)
    int bytes;
{
  void *mem;

  mem = malloc(bytes);
  if (mem == NULL)
    pm_error("out of memory allocating %d bytes", bytes);
  return mem;
}

static int gFormat;
static int gCols;
static int gMaxval;

staticfnc void init_read(fp, colsP, rowsP, maxvalP, formatP, readall)
    FILE *fp;
    int *colsP, *rowsP;
    pixval *maxvalP;
    int *formatP;
    int readall;
{
  ppm_readppminit(fp, colsP, rowsP, maxvalP, formatP);
  if (readall) {
    int row;

    pixels = ppm_allocarray(*colsP, *rowsP);
    for (row = 0; row < *rowsP; row++)
      ppm_readppmrow(fp, pixels[row], *colsP, *maxvalP, *formatP);
    /* pixels = ppm_readppm(fp, colsP, rowsP, maxvalP); */
  }
  else {
    pixrow = ppm_allocrow(*colsP);
  }
  gCols = *colsP;
  gMaxval = *maxvalP;
  gFormat = *formatP;
}

staticfnc pixel *
  next_pixrow(fp, row)
    FILE *fp;
    int row;
{
  if (pixels)
    pixrow = pixels[row];
  else {
#ifdef DEBUG
    static int rowcnt;

    if (row != rowcnt)
      pm_error("big mistake");
    rowcnt++;
#endif
    ppm_readppmrow(fp, pixrow, gCols, gMaxval, gFormat);
  }
  return pixrow;
}
