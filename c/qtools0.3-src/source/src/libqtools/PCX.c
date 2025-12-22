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

/*
 * pcxtoppm.c - Converts from a PC Paintbrush PCX file to a PPM file.
 *
 * Copyright (c) 1990 by Michael Davidson
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted,
 * provided that the above copyright notice appear in all copies and that
 * both that copyright notice and this permission notice appear in
 * supporting documentation.
 *
 * This file is provided AS IS with no warranties of any kind.  The author
 * shall have no liability with respect to the infringement of copyrights,
 * trade secrets or any patents by this file or any part thereof.  In no
 * event will the author be liable for any lost revenue or profits or
 * other special, indirect and consequential damages.
 *
 */

#define	PCX_MAGIC	0x0a					/* PCX magic number               */
#define	PCX_HDR_SIZE	128					/* size of PCX header             */
#define	PCX_256_COLORS	0x0c					/* magic number for 256 colors    */

#define	MAXCOLORS   	256
#define	MAXPLANES	4
#define	PCX_MAXVAL	255

staticfnc void read_pcx_image ARGS((FILE * fp, unsigned char *buf, int BytesPerLine, int Planes, int Height));
staticfnc void pcx_planes_to_pixels ARGS((unsigned char *pixels, unsigned char *bitplanes, int bytesperline, int planes, int bitsperpixel));
staticfnc void pcx_unpack_pixels ARGS((unsigned char *pixels, unsigned char *bitplanes, int bytesperline, int planes, int bitsperpixel));
staticfnc int GetByte ARGS((FILE * fp));
staticfnc int GetWord ARGS((FILE * fp));

int main(argc, argv)
    int argc;
    char *argv[];
{
  register int i;
  FILE *ifp;
  char *ifname;
  int Version;
  int Xmin, Ymin, Xmax, Ymax;
  int Width, Height;
  register int x, y;
  int Planes;
  int BitsPerPixel;
  int BytesPerLine;
  unsigned char Red[MAXCOLORS], Green[MAXCOLORS], Blue[MAXCOLORS];
  unsigned char *pcximage;
  unsigned char *pcxplanes;
  unsigned char *pcxpixels;
  pixel **pixels;

  ppm_init(&argc, argv);

  switch (argc) {
    case 1:
      ifname = "standard input";
      ifp = stdin;
      break;
    case 2:
      ifname = argv[1];
      ifp = pm_openr(ifname);
      break;
    default:
      pm_usage("[pcxfile]");
      break;
  }

  /*
   * read the PCX header
   */
  if (GetByte(ifp) != PCX_MAGIC)
    pm_error("%s is not a PCX file", ifname);

  Version = GetByte(ifp);					/* get version #                       */

  if (GetByte(ifp) != 1)					/* check for PCX run length encoding      */
    pm_error("%s has unknown encoding scheme", ifname);

  BitsPerPixel = GetByte(ifp);
  Xmin = GetWord(ifp);
  Ymin = GetWord(ifp);
  Xmax = GetWord(ifp);
  Ymax = GetWord(ifp);

  Width = (Xmax - Xmin) + 1;
  Height = (Ymax - Ymin) + 1;

  (void)GetWord(ifp);						/* ignore horizontal resolution */
  (void)GetWord(ifp);						/* ignore vertical resolution   */

  /*
   * get the 16-color color map
   */
  for (i = 0; i < 16; i++) {
    Red[i] = GetByte(ifp);
    Green[i] = GetByte(ifp);
    Blue[i] = GetByte(ifp);
  }

  (void)GetByte(ifp);						/* skip reserved byte    */
  Planes = GetByte(ifp);					/* # of color planes     */
  BytesPerLine = GetWord(ifp);					/* # of bytes per line   */
  (void)GetWord(ifp);						/* ignore palette info   */

  /*
   * check that we can handle this image format
   */
  switch (BitsPerPixel) {
    case 1:
      if (Planes > 4)
	pm_error("can't handle image with more than 4 planes");
      break;

    case 2:
    case 4:
    case 8:
      if (Planes == 1)
	break;
    default:
      pm_error("can't handle %d bits per pixel image with %d planes",
	       BitsPerPixel, Planes);
  }

  /*
   * read the pcx format image
   */
  fseek(ifp, (long)PCX_HDR_SIZE, 0);
  pcximage = (unsigned char *)pm_allocrow(BytesPerLine * Planes, Height);
  read_pcx_image(ifp, pcximage, BytesPerLine, Planes, Height);

  /*
   * 256 color images have their color map at the end of the file
   * preceeded by a magic byte
   */
  if (BitsPerPixel == 8) {
    if (GetByte(ifp) != PCX_256_COLORS)
      pm_error("bad color map signature");

    for (i = 0; i < MAXCOLORS; i++) {
      Red[i] = GetByte(ifp);
      Green[i] = GetByte(ifp);
      Blue[i] = GetByte(ifp);
    }
  }

  pixels = ppm_allocarray(Width, Height);
  pcxpixels = (unsigned char *)pm_allocrow(Width + 7, 1);

  /*
   * convert the image
   */
  for (y = 0; y < Height; y++) {
    pcxplanes = pcximage + (y * BytesPerLine * Planes);

    if (Planes == 1) {
      pcx_unpack_pixels(pcxpixels, pcxplanes,
			BytesPerLine, Planes, BitsPerPixel);
    }
    else {
      pcx_planes_to_pixels(pcxpixels, pcxplanes,
			   BytesPerLine, Planes, BitsPerPixel);
    }

    for (x = 0; x < Width; x++) {
      i = pcxpixels[x];
      PPM_ASSIGN(pixels[y][x], Red[i], Green[i], Blue[i]);
    }
  }

  pm_close(ifp);

  ppm_writeppm(stdout, pixels, Width, Height, (pixval) 255, 0);

  pm_close(stdout);

  exit(0);
}

staticfnc void read_pcx_image(fp, buf, BytesPerLine, Planes, Height)
    FILE *fp;
    unsigned char *buf;
    int BytesPerLine;
    int Planes;
    int Height;
{
  int c;
  int nbytes;
  int count;

  nbytes = BytesPerLine * Planes * Height;

  while (nbytes > 0) {
    c = GetByte(fp);
    if ((c & 0xc0) != 0xc0) {
      *buf++ = c;
      --nbytes;
      continue;
    }

    count = c & 0x3f;
    c = GetByte(fp);
    if (count > nbytes)
      pm_error("repeat count spans end of image, count = %d, nbytes = %d", count, nbytes);

    nbytes -= count;
    while (--count >= 0)
      *buf++ = c;
  }
}

/*
 * convert multi-plane format into 1 pixel per byte
 */
staticfnc void pcx_planes_to_pixels(pixels, bitplanes, bytesperline, planes, bitsperpixel)
    unsigned char *pixels;
    unsigned char *bitplanes;
    int bytesperline;
    int planes;
    int bitsperpixel;
{
  int i, j;
  int npixels;
  unsigned char *p;

  if (planes > 4)
    pm_error("can't handle more than 4 planes");
  if (bitsperpixel != 1)
    pm_error("can't handle more than 1 bit per pixel");

  /*
   * clear the pixel buffer
   */
  npixels = (bytesperline * 8) / bitsperpixel;
  p = pixels;
  while (--npixels >= 0)
    *p++ = 0;

  /*
   * do the format conversion
   */
  for (i = 0; i < planes; i++) {
    int pixbit, bits, mask;

    p = pixels;
    pixbit = (1 << i);
    for (j = 0; j < bytesperline; j++) {
      bits = *bitplanes++;
      for (mask = 0x80; mask != 0; mask >>= 1, p++)
	if (bits & mask)
	  *p |= pixbit;
    }
  }
}

/*
 * convert packed pixel format into 1 pixel per byte
 */
staticfnc void pcx_unpack_pixels(pixels, bitplanes, bytesperline, planes, bitsperpixel)
    unsigned char *pixels;
    unsigned char *bitplanes;
    int bytesperline;
    int planes;
    int bitsperpixel;
{
  register int bits;

  if (planes != 1)
    pm_error("can't handle packed pixels with more than 1 plane");
  if (bitsperpixel == 8) {
    while (--bytesperline >= 0)
      *pixels++ = *bitplanes++;
  }
  else if (bitsperpixel == 4) {
    while (--bytesperline >= 0) {
      bits = *bitplanes++;
      *pixels++ = (bits >> 4) & 0x0f;
      *pixels++ = (bits) & 0x0f;
    }
  }
  else if (bitsperpixel == 2) {
    while (--bytesperline >= 0) {
      bits = *bitplanes++;
      *pixels++ = (bits >> 6) & 0x03;
      *pixels++ = (bits >> 4) & 0x03;
      *pixels++ = (bits >> 2) & 0x03;
      *pixels++ = (bits) & 0x03;
    }
  }
  else if (bitsperpixel == 1) {
    while (--bytesperline >= 0) {
      bits = *bitplanes++;
      *pixels++ = ((bits & 0x80) != 0);
      *pixels++ = ((bits & 0x40) != 0);
      *pixels++ = ((bits & 0x20) != 0);
      *pixels++ = ((bits & 0x10) != 0);
      *pixels++ = ((bits & 0x08) != 0);
      *pixels++ = ((bits & 0x04) != 0);
      *pixels++ = ((bits & 0x02) != 0);
      *pixels++ = ((bits & 0x01) != 0);
    }
  }
}

staticfnc int GetByte(fp)
    FILE *fp;
{
  int c;

  if ((c = getc(fp)) == EOF)
    pm_error("unexpected end of file");

  return c;
}

staticfnc int GetWord(fp)
    FILE *fp;
{
  int c;

  c = GetByte(fp);
  c |= (GetByte(fp) << 8);
  return c;
}

/* ppmtopcx.c - read a portable pixmap and produce a PCX file
 *
 * Copyright (C) 1990 by Michael Davidson.
 *
 * Permission to use, copy, modify, and distribute this software and its
 * documentation for any purpose and without fee is hereby granted, provided
 * that the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation.  This software is provided "as is" without express or
 * implied warranty.
 */

#define MAXCOLORS	256
#define	MAXPLANES	4

/*
 * Pointer to function returning an int
 */
typedef void (*vfunptr) ARGS((int, int, unsigned char *, int, int));

staticfnc void PCXEncode ARGS((FILE * fp, int GWidth, int GHeight, int Colors, int Red[], int Green[], int Blue[], vfunptr GetPlanes));
staticfnc void PutPlane ARGS((FILE * fp, unsigned char *buf, int Size));
staticfnc void ReadPlanes ARGS((int y, int width, unsigned char *buf, int planes, int bits));
staticfnc void Putword ARGS((int w, FILE * fp));
staticfnc void Putbyte ARGS((int b, FILE * fp));

staticvar pixel **pixels;
staticvar colorhash_table cht;

int main(argc, argv)
    int argc;
    char *argv[];
{
  FILE *ifp;
  int argn, rows, cols, colors, i;
  pixval maxval;
  pixel black_pixel;
  colorhist_vector chv;
  int Red[MAXCOLORS], Green[MAXCOLORS], Blue[MAXCOLORS];
  char *usage = "[ppmfile]";

  ppm_init(&argc, argv);

  argn = 1;

  if (argn < argc) {
    ifp = pm_openr(argv[argn]);
    ++argn;
  }
  else
    ifp = stdin;

  if (argn != argc)
    pm_usage(usage);

  pixels = ppm_readppm(ifp, &cols, &rows, &maxval);

  pm_close(ifp);

  /* Figure out the colormap. */
  pm_message("computing colormap...");
  chv = ppm_computecolorhist(pixels, cols, rows, MAXCOLORS, &colors);
  if (chv == (colorhist_vector) 0)
    pm_error(
	      "too many colors - try doing a 'ppmquant %d'", MAXCOLORS);
  pm_message("%d colors found", colors);

  /* Force black to slot 0 if possible. */
  PPM_ASSIGN(black_pixel, 0, 0, 0);
  ppm_addtocolorhist(chv, &colors, MAXCOLORS, &black_pixel, 0, 0);

  /* Now turn the ppm colormap into the appropriate PCX colormap. */
  if (maxval > 255)
    pm_message(
		"maxval is not 255 - automatically rescaling colors");
  for (i = 0; i < colors; ++i) {
    if (maxval == 255) {
      Red[i] = PPM_GETR(chv[i].color);
      Green[i] = PPM_GETG(chv[i].color);
      Blue[i] = PPM_GETB(chv[i].color);
    }
    else {
      Red[i] = (int)PPM_GETR(chv[i].color) * 255 / maxval;
      Green[i] = (int)PPM_GETG(chv[i].color) * 255 / maxval;
      Blue[i] = (int)PPM_GETB(chv[i].color) * 255 / maxval;
    }
  }

  /* And make a hash table for fast lookup. */
  cht = ppm_colorhisttocolorhash(chv, colors);
  ppm_freecolorhist(chv);

  /* All set, let's do it. */
  PCXEncode(stdout, cols, rows, colors, Red, Green, Blue, ReadPlanes);

  exit(0);
}

/*****************************************************************************
 *
 * PCXENCODE.C    - PCX Image compression interface
 *
 * PCXEncode( FName, GHeight, GWidth, Colors, Red, Green, Blue, GetPlanes )
 *
 *****************************************************************************/

/* public */

staticfnc void PCXEncode(fp, GWidth, GHeight, Colors, Red, Green, Blue, GetPlanes)
    FILE *fp;
    int GWidth, GHeight;
    int Colors;
    int Red[], Green[], Blue[];
    vfunptr GetPlanes;
{
  int BytesPerLine;
  int Planes;
  int BitsPerPixel;
  unsigned char *buf;
  int i;
  int n;
  int y;

  /*
   * select number of planes and number of bits
   * per pixel according to number of colors
   */
  /*
   * 16 colors or less are handled as 1 bit per pixel
   * with 1, 2, 3 or 4 color planes.
   * more than 16 colors are handled as 8 bits per pixel
   * with 1 plane
   */
  if (Colors > 16) {
    BitsPerPixel = 8;
    Planes = 1;
  }
  else {
    BitsPerPixel = 1;
    if (Colors > 8)
      Planes = 4;
    else if (Colors > 4)
      Planes = 3;
    else if (Colors > 2)
      Planes = 2;
    else
      Planes = 1;
  }

  /*
   * Write the PCX header
   */
  Putbyte(0x0a, fp);						/* .PCX magic number            */
  Putbyte(0x05, fp);						/* PC Paintbrush version        */
  Putbyte(0x01, fp);						/* .PCX run length encoding     */
  Putbyte(BitsPerPixel, fp);					/* bits per pixel               */

  Putword(0, fp);						/* x1   - image left            */
  Putword(0, fp);						/* y1   - image top             */
  Putword(GWidth - 1, fp);					/* x2   - image right           */
  Putword(GHeight - 1, fp);					/* y2   - image bottom          */

  Putword(GWidth, fp);						/* horizontal resolution        */
  Putword(GHeight, fp);						/* vertical resolution          */

  /*
   * Write out the Color Map for images with 16 colors or less
   */
  n = (Colors <= 16) ? Colors : 16;
  for (i = 0; i < n; ++i) {
    Putbyte(Red[i], fp);
    Putbyte(Green[i], fp);
    Putbyte(Blue[i], fp);
  }
  for (; i < 16; ++i) {
    Putbyte(255, fp);
    Putbyte(255, fp);
    Putbyte(255, fp);
  }

  Putbyte(0, fp);						/* reserved byte                */

  Putbyte(Planes, fp);						/* number of color planes       */

  BytesPerLine = ((GWidth * BitsPerPixel) + 7) / 8;
  Putword(BytesPerLine, fp);					/* number of bytes per scanline */

  Putword(1, fp);						/* pallette info                */

  for (i = 0; i < 58; ++i)					/* fill to end of header  */
    Putbyte(0, fp);

  buf = (unsigned char *)malloc(MAXPLANES * BytesPerLine);

  for (y = 0; y < GHeight; ++y) {
    (*GetPlanes) (y, GWidth, buf, Planes, BitsPerPixel);

    for (i = 0; i < Planes; ++i)
      PutPlane(fp, buf + (i * BytesPerLine), BytesPerLine);
  }

  /*
   * color map for > 16 colors is at end of file
   */
  if (Colors > 16) {
    Putbyte(0x0c, fp);						/* magic for 256 colors */
    for (i = 0; i < Colors; ++i) {
      Putbyte(Red[i], fp);
      Putbyte(Green[i], fp);
      Putbyte(Blue[i], fp);
    }
    for (; i < MAXCOLORS; ++i) {
      Putbyte(255, fp);
      Putbyte(255, fp);
      Putbyte(255, fp);
    }
  }

  fclose(fp);
}

staticfnc void PutPlane(fp, buf, Size)
    FILE *fp;
    unsigned char *buf;
    int Size;
{
  unsigned char *end;
  int c;
  int previous;
  int count;

  end = buf + Size;

  previous = *buf++;
  count = 1;

  while (buf < end) {
    c = *buf++;
    if (c == previous && count < 63) {
      ++count;
      continue;
    }

    if (count > 1 || (previous & 0xc0) == 0xc0) {
      count |= 0xc0;
      Putbyte(count, fp);
    }
    Putbyte(previous, fp);
    previous = c;
    count = 1;
  }

  if (count > 1 || (previous & 0xc0) == 0xc0) {
    count |= 0xc0;
    Putbyte(count, fp);
  }
  Putbyte(previous, fp);
}

staticvar unsigned long PixMap[8][16] =
{
  0x00000000L, 0x00000080L, 0x00008000L, 0x00008080L,
  0x00800000L, 0x00800080L, 0x00808000L, 0x00808080L,
  0x80000000L, 0x80000080L, 0x80008000L, 0x80008080L,
  0x80800000L, 0x80800080L, 0x80808000L, 0x80808080L,
};

staticfnc void ReadPlanes(y, width, buf, planes, bits)
    int y;
    int width;
    unsigned char *buf;
    int planes;
    int bits;
{
  static int first_time = 1;
  unsigned char *plane0, *plane1, *plane2, *plane3;
  int i, j, x;

  /*
   * 256 color, 1 plane, 8 bits per pixel
   */
  if (planes == 1 && bits == 8) {
    for (x = 0; x < width; ++x)
      buf[x] = ppm_lookupcolor(cht, &pixels[y][x]);
    return;
  }

  /*
   * must be 16 colors or less, 4 planes or less, 1 bit per pixel
   */
  if (first_time) {
    for (i = 1; i < 8; ++i)
      for (j = 0; j < 16; ++j)
	PixMap[i][j] = PixMap[0][j] >> i;
    first_time = 0;
  }

  i = (width + 7) / 8;

  plane0 = buf;
  plane1 = plane0 + i;
  plane2 = plane1 + i;
  plane3 = plane2 + i;

  i = 0;
  x = 0;

  while (x < width) {
    register unsigned long t;

    t = PixMap[0][ppm_lookupcolor(cht, &pixels[y][x++])];
    t |= PixMap[1][ppm_lookupcolor(cht, &pixels[y][x++])];
    t |= PixMap[2][ppm_lookupcolor(cht, &pixels[y][x++])];
    t |= PixMap[3][ppm_lookupcolor(cht, &pixels[y][x++])];
    t |= PixMap[4][ppm_lookupcolor(cht, &pixels[y][x++])];
    t |= PixMap[5][ppm_lookupcolor(cht, &pixels[y][x++])];
    t |= PixMap[6][ppm_lookupcolor(cht, &pixels[y][x++])];
    t |= PixMap[7][ppm_lookupcolor(cht, &pixels[y][x++])];

    plane0[i] = t;
    plane1[i] = t >> 8;
    plane2[i] = t >> 16;
    plane3[i++] = t >> 24;
  }
}

/*
 * Write out a word to the PCX file
 */
staticfnc void Putword(w, fp)
    int w;
    FILE *fp;
{
  fputc(w & 0xff, fp);
  fputc((w / 256) & 0xff, fp);
}

/*
 * Write out a byte to the PCX file
 */
staticfnc void Putbyte(b, fp)
    int b;
    FILE *fp;
{
  fputc(b & 0xff, fp);
}

/* The End */
