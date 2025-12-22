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

/*
 * pmalloc/pfree
 */

struct palpic *pmalloc(register short int width, register short int height, register struct rgb *palette, register char *picName)
{
  struct palpic *Picture = 0;

  if ((Picture = (struct palpic *)tmalloc((width * height) + sizeof(struct palpic)))) {
    Picture->width = width;
    Picture->height = height;
    if (!palette)
      palette = GetPalette();
    Picture->palette = palette;
    if (!picName)
      picName = "nameLess";
    Picture->name = smalloc(picName);
  }
  else
    eprintf(failed_memory, (width * height) + sizeof(struct palpic), "palpicture");

  return Picture;
}

bool pfree(register struct palpic * Picture)
{
  if (Picture) {
    if (Picture->palette)
      tfree(Picture->palette);
    if (Picture->name)
      tfree(Picture->name);
    tfree(Picture);
    return TRUE;
  }
  else
    return FALSE;
}

/*
 * palette
 */

HANDLE palFile = 0, colrFile = 0, transFile = 0;
short int darkness = 0, transparency = -1;
struct rgb *cachedPalette = 0;
unsigned char *cachedColormap = 0;
unsigned char *cachedTransparency = 0;

unsigned char *GetTransparency(int transVal)
{
  char transTemplate[NAMELEN_PATH + 1] = "TArray.%2d";
  char transName[NAMELEN_PATH + 1] = "TArray.??";
  unsigned char *NewTransparency;

  if ((NewTransparency = (unsigned char *)tmalloc(256 * 256 * sizeof(unsigned char)))) {
    if (!cachedTransparency || (transVal != transparency)) {
      sprintf(transName, transTemplate, transVal);
      if ((transFile = __open(transName, H_READ_BINARY)) < 0) {
	char *transBase;

	if ((transBase = getenv("QUAKE_TRANSPARENCY"))) {
	  __strncpy(transName, transBase, NAMELEN_PATH);
	  __strncat(transName, transTemplate, NAMELEN_PATH);
	  __strcpy(transTemplate, transName);
	  sprintf(transName, transTemplate, transVal);
	  transFile = __open(transName, H_READ_BINARY);
	}
      }

      if (transFile < 0) {
	int i, j;
	struct rgb *actPel;

	mprintf("build transparency for density %2d\n", transVal);

	for (i = 0; i < 256; i++) {
	  actPel = &cachedPalette[i];
	  for (j = 0; j < 256; j++) {
	    int R, G, B;
	    struct rgb matchPel;

	    R = ((((int)(cachedPalette[j].r - actPel->r) * transVal) / 100) + (int)actPel->r);
	    G = ((((int)(cachedPalette[j].g - actPel->g) * transVal) / 100) + (int)actPel->g);
	    B = ((((int)(cachedPalette[j].b - actPel->b) * transVal) / 100) + (int)actPel->b);

	    matchPel.r = (unsigned char)R;
	    matchPel.g = (unsigned char)G;
	    matchPel.b = (unsigned char)B;
	    NewTransparency[(i << 8) + j] = Match(&matchPel, cachedPalette);
	  }
	  mprogress(256, i + 1);
	}

	if ((transFile = __open(transName, H_WRITE_BINARY)) > 0)
	  __write(transFile, NewTransparency, 256 * 256 * sizeof(unsigned char));
      }
      else
	__read(transFile, NewTransparency, 256 * 256 * sizeof(unsigned char));

      if (transFile) {
	__close(transFile);
	transFile = 0;
      }
      if (cachedTransparency)					/* release wrong cached transval */
	tfree(cachedTransparency);

      transparency = transVal;
      cachedTransparency = NewTransparency;
      NewTransparency = GetTransparency(transVal);
    }
    else
      __memcpy(NewTransparency, cachedTransparency, 256 * 256 * sizeof(unsigned char));
  }
  return NewTransparency;
}

struct rgb *GetDarkness(struct rgb *Palette)
{
  struct rgb *NewPalette;

  if ((NewPalette = (struct rgb *)tmalloc(256 * 3))) {
    short int i;

    if (!cachedColormap) {
      bool closecolr = FALSE;
      unsigned char *DarkLevel;

      if ((DarkLevel = (unsigned char *)tmalloc(256 * 64))) {

	if (!colrFile) {
	  if ((colrFile = __open("colormap.lmp", H_READ_BINARY)) < 0) {
	    char *colrName;

	    if ((colrName = getenv("QUAKE_COLORMAP"))) {
	      if ((colrFile = __open(colrName, H_READ_BINARY)) < 0)
		eprintf("no colormap available, build new from scratch\n");
	      else
		closecolr = TRUE;
	    }
	    else
	      eprintf("no colormap available, build new from scratch\n");
	  }
	  else
	    closecolr = TRUE;
	}

	if (colrFile) {
	  __read(colrFile, DarkLevel, 256 * 64);
	  if (closecolr)
	    __close(colrFile);
	  else
	    __lseek(colrFile, 0, SEEK_SET);
	}
	else {
	  /* TODO: how to build colormap */
	}

	cachedColormap = DarkLevel;
      }
      else {
	eprintf(failed_memory, 256 * 64, "colormap");
	return Palette;
      }
    }

    for (i = 256; i < 256; i++)
      NewPalette[i] = Palette[cachedColormap[i]];

    tfree(Palette);
  }

  if (NewPalette)
    return NewPalette;
  else
    return Palette;
}

struct rgb *GetPalette(void)
{
  struct rgb *Palette;

  if ((Palette = (struct rgb *)tmalloc(256 * 3))) {
    if (!cachedPalette) {
      bool closepal = FALSE;

      if (!palFile) {
	if ((palFile = __open("palette.lmp", H_READ_BINARY)) < 0) {
	  char *palName;

	  if ((palName = getenv("QUAKE_PALETTE"))) {
	    if ((palFile = __open(palName, H_READ_BINARY)) < 0) {
	      eprintf("no palette available\n");
	      tfree(Palette);
	      return 0;
	    }
	    else
	      closepal = TRUE;
	  }
	  else {
	    eprintf("no palette available\n");
	    tfree(Palette);
	    return 0;
	  }
	}
	else
	  closepal = TRUE;
      }

      __read(palFile, Palette, 256 * 3);

      if (closepal)
	__close(palFile);
      else
	__lseek(palFile, 0, SEEK_SET);

      /*
       * small trick
       */
      cachedPalette = Palette;
      Palette = GetPalette();
    }
    else
      __memcpy(Palette, cachedPalette, 256 * 3);
  }

  if (darkness)
    Palette = GetDarkness(Palette);

  return Palette;
}

/*
 * Lumps
 */
struct palpic *GetLMP(register HANDLE file, register char *lmpName)
{
  struct lump Lump;
  struct palpic *Picture;

  __read(file, &Lump, sizeof(struct lump));

  if ((Picture = pmalloc(LittleLong(Lump.width), LittleLong(Lump.height), 0, lmpName)))
    __read(file, Picture->rawdata, Picture->width * Picture->height);

  return Picture;
}

struct palpic *ParseLMP(register struct lump *Lump, register char *lmpName)
{
  struct palpic *Picture;

  if ((Picture = pmalloc(LittleLong(Lump->width), LittleLong(Lump->height), 0, lmpName)))
    __memcpy(Picture->rawdata, Lump->rawdata, Picture->width * Picture->height);

  return Picture;
}

bool PutLMP(register HANDLE file, register struct palpic * Picture)
{
  struct lump Lump;
  int size = sizeof(struct lump) + (Picture->width * Picture->height);

  Lump.width = LittleLong(Picture->width);
  Lump.height = LittleLong(Picture->height);
  __write(file, &Lump, 2 * sizeof(int));

  if (__write(file, Picture->rawdata, size) != size)
    return FALSE;
  else
    return TRUE;
}

bool PasteLMP(register struct lump * Lump, register struct palpic * Picture)
{
  Lump->width = LittleLong(Picture->width);
  Lump->height = LittleLong(Picture->height);
  __memcpy(((char *)Lump) + sizeof(struct lump), Picture->rawdata, (Picture->width * Picture->height));

  return TRUE;
}

#if defined(HAVE_LIBPNG) && defined(HAVE_PNG_H)
# include <png.h>
#endif
#if defined(HAVE_LIBJPEG) && defined(HAVE_JPEGLIB_H)
# include <jpeglib.h>
#endif

bool dither = FALSE;
short int dithervalue = 16;
bool smoothing = FALSE;
short int smoothingvalue = 2;
short int smoothingshift = 1;

/*#define FS_SCALE 16 */
#define FS_SCALE dithervalue
/*#define S_SCALE 2 */
#define S_SCALE smoothingvalue
/*#define S_SHIFT 2 */
#define S_SHIFT smoothingshift

typedef float PRECISION;
typedef float PRECISION_EXT;

struct drgb {
  PRECISION r, g, b;
};

staticfnc inline unsigned char MatchD(register struct drgb *rawpix, register struct rgb *Palette)
{
  struct rgb newpix;

  newpix.r = (unsigned char)rawpix->r;
  newpix.g = (unsigned char)rawpix->g;
  newpix.b = (unsigned char)rawpix->b;
  return Match(&newpix, Palette);
}

/* picture-tools */
bool RemapPalettes(unsigned char *dataBody, int dataSize, struct rgb * oldPalette, struct rgb * newPalette)
{
  unsigned char *conversionArray;

  if ((conversionArray = (unsigned char *)tmalloc(256))) {
    int i;

    for (i = 0; i < 256; i++)
      conversionArray[i] = Match(&oldPalette[i], &newPalette[i]);
    for (i = 0; i < dataSize; i++)
      dataBody[i] = conversionArray[dataBody[i]];

    tfree(conversionArray);
    return TRUE;
  }
  else
    return FALSE;
}

#ifdef HAVE_LIBPNG
#ifdef REPLACE_STDIO
void png_default_read_data(png_structp png_ptr, png_bytep data, png_size_t length)
{
  if (__fread(data, (png_size_t) 1, length, (FILE *) png_ptr->io_ptr) != length)
    png_error(png_ptr, "Read Error");
}

void png_default_write_data(png_structp png_ptr, png_bytep data, png_size_t length)
{
  if (__fwrite(data, 1, length, (FILE *) (png_ptr->io_ptr)) != length)
    png_error(png_ptr, "Write Error");
}
#endif

bool SavePNG(register FILE * imgFile, register struct palpic *Picture)
{
  png_struct *png_ptr;
  png_info *info_ptr;
  bool retval = FALSE;

  if ((png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, 0, 0, 0))) {
    if ((info_ptr = png_create_info_struct(png_ptr))) {
      if (!setjmp(png_ptr->jmpbuf)) {
	short int y;
	png_byte *row_pointers = (png_byte *) Picture->rawdata;

	png_init_io(png_ptr, imgFile);
	png_set_IHDR(png_ptr, info_ptr, Picture->width, Picture->height, 8, PNG_COLOR_TYPE_PALETTE,
	 PNG_INTERLACE_NONE, PNG_COMPRESSION_TYPE_BASE, PNG_FILTER_TYPE_BASE);
	png_set_PLTE(png_ptr, info_ptr, (png_color *) Picture->palette, 256);
	png_set_compression_level(png_ptr, 9);
	png_write_info(png_ptr, info_ptr);
	png_set_packing(png_ptr);
	for (y = 0; y < Picture->height; y++) {
	  png_write_rows(png_ptr, &row_pointers, 1);
	  row_pointers += Picture->width;
	}
	png_write_end(png_ptr, info_ptr);
	retval = TRUE;
      }
      else
	eprintf("cannot set png-jump\n");
    }
    else
      eprintf("cannot create info-struct\n");

    png_destroy_write_struct(&png_ptr, 0);
  }
  else
    eprintf("cannot create png-struct\n");

  return retval;
}
#endif
#ifdef HAVE_LIBJPEG
bool SaveJPEG(register FILE * imgFile, register unsigned char *rawBody, register short int width, register short int height)
{
  struct jpeg_compress_struct cinfo;
  struct jpeg_error_mgr jerr;
  unsigned char *row_pointers = rawBody;

  cinfo.err = jpeg_std_error(&jerr);
  jpeg_create_compress(&cinfo);
  jpeg_stdio_dest(&cinfo, imgFile);

  cinfo.image_width = width;					/* image width and height, in pixels */
  cinfo.image_height = height;
  cinfo.input_components = 3;					/* # of color components per pixel */
  cinfo.in_color_space = JCS_RGB;				/* colorspace of input image */

  jpeg_set_defaults(&cinfo);

  cinfo.dct_method = JDCT_FLOAT;
  cinfo.optimize_coding = TRUE;

  jpeg_set_quality(&cinfo, 100, TRUE);
  jpeg_start_compress(&cinfo, TRUE);
  while (cinfo.next_scanline < cinfo.image_height) {
    jpeg_write_scanlines(&cinfo, &row_pointers, 1);
    row_pointers += (width * 3);
  }

  jpeg_finish_compress(&cinfo);
  jpeg_destroy_compress(&cinfo);

  return TRUE;
}
#endif

bool PutImage(FILE * file, struct palpic * Picture, filetype picType)
{
  bool retval = FALSE;

  switch (picType) {
    case TYPE_PPM:
#ifdef HAVE_LIBJPEG
    case TYPE_JPEG:
#endif
      {
	short int x = Picture->width, y = Picture->height;
	struct rgb *PPMPic = (struct rgb *)tmalloc(x * y * 3);

	if (PPMPic) {
	  unsigned char *bodySrc = Picture->rawdata;
	  struct rgb *bodyPal = Picture->palette;
	  struct rgb *bodyDst = PPMPic;

	  /* convert body */
	  for (y = 0; y < Picture->width; y++) {
	    for (x = 0; x < Picture->height; x++) {
	      *bodyDst++ = bodyPal[(short int)(*bodySrc++)];
	    }
	  }

	  if (picType == TYPE_PPM) {
	    /* put header */
	    fprintf(file, "P6\n%d %d\n255\n", Picture->width, Picture->height);
	    fflush(file);
	    /* put body */
	    __write(fileno(file), PPMPic, (Picture->width * Picture->height * 3));
	    retval = TRUE;
	  }
#ifdef HAVE_LIBJPEG
	  else
	    retval = SaveJPEG(file, (unsigned char *)PPMPic, Picture->width, Picture->height);
#endif
	  tfree(PPMPic);
	}
	else
	  eprintf(failed_memory, x * y * 3, "ppm-body");
      }
      break;
#ifdef HAVE_LIBPNG
    case TYPE_PNG:
      retval = SavePNG(file, Picture);
      break;
#endif
    case TYPE_RAW:
      __write(fileno(file), Picture->rawdata, Picture->width * Picture->height);
      break;
    default:
      eprintf("unknown picture-type\n");
      break;
  }

  return retval;
}

#define CHECK_SIZE	12

filetype CheckImage(register FILE * imgFile)
{
  union blabla {
    char minChars[CHECK_SIZE];
    int minInts[CHECK_SIZE / 4];
  } minHeader;

  __fseek(imgFile, 0, SEEK_SET);
  __fread(&minHeader, 1, CHECK_SIZE, imgFile);
  __fseek(imgFile, 0, SEEK_SET);
#ifdef HAVE_LIBPNG
  if ((minHeader.minInts[0] == 0x89504E47) && (minHeader.minInts[1] == 0x0D0A1A0A))
    return TYPE_PNG;
#endif
#ifdef HAVE_LIBJPEG
  if ((minHeader.minInts[0] == 0xFFD8FFE0) && (minHeader.minInts[1] == 0x00104A46))
    return TYPE_JPEG;
#endif
#ifdef ILBM
  if (minHeader.minInts[0] == 0x464F524D)
    &&(minHeader.minInts[2] == 0x494C424D))
      return TYPE_ILBM;
#endif
  if ((minHeader.minChars[0] == 'P') && (minHeader.minChars[1] == '6') && (minHeader.minChars[2] == '\n'))
    return TYPE_PPM;
  if ((minHeader.minChars[0] == 'P') && (minHeader.minChars[1] == '5') && (minHeader.minChars[2] == '\n'))
    return TYPE_PGM;

  return TYPE_NONE;
}

#ifdef HAVE_LIBPNG
filetype LoadPNG(register FILE * imgFile, register struct rgb ** bodySrc, register short int *width, register short int *height) {
  png_struct *png_ptr;
  png_info *info_ptr;
  short int color_type = 0;

  if ((png_ptr = png_create_read_struct(PNG_LIBPNG_VER_STRING, 0, 0, 0))) {
    if ((info_ptr = png_create_info_struct(png_ptr))) {
      if (!setjmp(png_ptr->jmpbuf)) {
	short int number_passes, pass, y;

	png_init_io(png_ptr, imgFile);
	png_read_info(png_ptr, info_ptr);

	*width = info_ptr->width;
	*height = info_ptr->height;
	color_type = info_ptr->color_type;

	if ((*bodySrc = (struct rgb *)tmalloc((*width) * (*height) * 3))) {
	  png_byte *row_pointers = (png_byte *) (*bodySrc);

	  if ((color_type == PNG_COLOR_TYPE_PALETTE) || ((color_type == PNG_COLOR_TYPE_GRAY) && (info_ptr->bit_depth < 8)))
	    png_set_expand(png_ptr);

	  number_passes = png_set_interlace_handling(png_ptr);
	  png_read_update_info(png_ptr, info_ptr);
	  for (pass = 0; pass < number_passes; pass++) {
	    for (y = 0; y < (*height); y++) {
	      png_read_rows(png_ptr, &row_pointers, 0, 1);
	      if (color_type == PNG_COLOR_TYPE_GRAY)
		row_pointers += ((*width));
	      else
		row_pointers += ((*width) * 3);
	    }
	  }
	}
	else
	  eprintf(failed_memory, (*width) * (*height) * 3, "picture");

	png_read_end(png_ptr, info_ptr);
      }
      else
	eprintf("cannot set png-jump\n");

      png_destroy_read_struct(&png_ptr, &info_ptr, 0);
    }
    else {
      png_destroy_read_struct(&png_ptr, 0, 0);
      eprintf("cannot create info-struct\n");
    }
  }
  else
    eprintf("cannot create png-struct\n");

  if (color_type == PNG_COLOR_TYPE_GRAY)
    return TYPE_PGM;
  else if (color_type)
    return TYPE_PPM;
  else
    return TYPE_NONE;
}
#endif

#ifdef HAVE_LIBJPEG
filetype LoadJPEG(register FILE * imgFile, register struct rgb ** bodySrc, register short int *width, register short int *height) {
  struct jpeg_decompress_struct cinfo;
  struct jpeg_error_mgr jerr;

  cinfo.err = jpeg_std_error(&jerr);
  jpeg_create_decompress(&cinfo);
  jpeg_stdio_src(&cinfo, imgFile);
  jpeg_read_header(&cinfo, TRUE);

  cinfo.dct_method = JDCT_FLOAT;
  cinfo.out_color_space = JCS_RGB;

  jpeg_start_decompress(&cinfo);

  *width = (short int)cinfo.image_width;
  *height = (short int)cinfo.image_height;

  if ((*bodySrc = (struct rgb *)tmalloc(cinfo.image_width * cinfo.image_height * 3))) {
    unsigned char *row_pointers = (unsigned char *)(*bodySrc);

    while (cinfo.output_scanline < cinfo.output_height) {
      jpeg_read_scanlines(&cinfo, &row_pointers, 1);
      row_pointers += (cinfo.image_width * 3);
    }
  }
  else
    eprintf(failed_memory, cinfo.image_width * cinfo.image_height * 3, "picture");

  jpeg_finish_decompress(&cinfo);
  jpeg_destroy_decompress(&cinfo);

  return TYPE_PPM;
}
#endif

struct rgb *LoadImage(register FILE * imgFile, register filetype * picType, register short int *width, register short int *height) {
  struct rgb *bodySrc = 0;
  int x, y, reead;

  switch (*picType) {
#ifdef HAVE_LIBPNG
    case TYPE_PNG:
      *picType = LoadPNG(imgFile, (struct rgb **)&bodySrc, width, height);
      break;
#endif
#ifdef HAVE_LIBJPEG
    case TYPE_JPEG:
      *picType = LoadJPEG(imgFile, (struct rgb **)&bodySrc, width, height);
      break;
#endif
#ifdef ILBM
    case TYPE_ILBM:
      break;
#endif
    case TYPE_PPM:
      fscanf(imgFile, "%nP6\n%d %d\n255\n", &reead, &x, &y);
      *width = (short int)x;
      *height = (short int)y;
      if ((bodySrc = (struct rgb *)tmalloc(x * y * 3))) {
        __lseek(fileno(imgFile), reead, SEEK_SET);
	__read(fileno(imgFile), bodySrc, x * y * 3);
      }
      else
	eprintf(failed_memory, x * y * 3, "picture");
      break;
    case TYPE_PGM:
      fscanf(imgFile, "%nP5\n%d %d\n255\n", &reead, &x, &y);
      *width = (short int)x;
      *height = (short int)y;
      if ((bodySrc = (struct rgb *)tmalloc(x * y))) {
        __lseek(fileno(imgFile), reead, SEEK_SET);
	__read(fileno(imgFile), bodySrc, x * y);
      }
      else
	eprintf(failed_memory, x * y, "picture");
      break;
    case TYPE_RAW:
      eprintf("raw files can't be read as pictures as they do not contain any informations about size\n");
      break;
    default:
      eprintf("unknown picture-type\n");
      break;
  }

  return bodySrc;
}

struct palpic *GetImage(FILE * file, char *picName, short int alignX, short int alignY) {
  struct palpic *Picture = 0;
  struct rgb *bodySrc;
  struct drgb *bodyTmp;
  short int width, height;
  filetype picType = TYPE_NONE;

  if (smoothing)
    switch (S_SCALE) {
      case  1: S_SHIFT =  0; break;
      case  2: S_SHIFT =  1; break;
      case  4: S_SHIFT =  2; break;
      case  8: S_SHIFT =  3; break;
      case 16: S_SHIFT =  4; break;
      default: S_SHIFT = -1; break;
    }

  if ((picType = CheckImage(file)) != TYPE_NONE) {
    if ((bodySrc = LoadImage(file, &picType, &width, &height))) {
      short int newwidth = width, newheight = height;

#ifdef	DEBUG
      FILE *dumpFile = __fopen("dump", F_WRITE_BINARY);
      fprintf(dumpFile, "P6\n%d %d\n255\n", width, height);
      fflush(dumpFile);
      __write(fileno(dumpFile), bodySrc, (width * height * 3));
      fclose(dumpFile);
#endif

      /* calculate a new size that is multiple of align or an absolute value */
      if (alignX > 0) {
	if ((width % alignX))
	  newwidth = width - (width % alignX) + alignX;
      }
      else
	newwidth = -alignX;
      if (alignY > 0) {
	if ((height % alignY))
	  newheight = height - (height % alignY) + alignY;
      }
      else
	newheight = -alignY;

      if ((!dither) || ((dither) && (bodyTmp = (struct drgb *)tmalloc(newwidth * newheight * 3 * sizeof(PRECISION))))) {
	if ((Picture = pmalloc(newwidth, newheight, 0, picName))) {
	  double dx = (double)width / newwidth;
	  double dy = (double)height / newheight;
	  double x, y;
	  short int nx, ny;
	  struct rgb *Palette = Picture->palette;
	  unsigned char *flowDst = Picture->rawdata;
	  struct drgb *flowTmp = bodyTmp;

#ifdef DEBUG
	  mprintf("size; %dx%d, newsize: %dx%d, diffs: %fx%f, type: %d\n", width, height, newwidth, newheight, dx, dy, picType);
#endif
	  /* scale body in advance of dithering */
	  for (ny = 0, y = 0; ny < newheight; ny++, y += dy) {
	    for (nx = 0, x = 0; nx < newwidth; nx++, x += dx) {
	      struct rgb rawpix;

#define	floatPos(yy, xx)	(((int)(yy) * width) + (int)xx)

	      /* get unscaled value */
	      if (picType == TYPE_PPM) {
		/* colored ppm */
		rawpix = bodySrc[floatPos(y, x)];

		if (smoothing) {
		  short int sR = 0, sG = 0, sB = 0, sS = 0;

#define AddRGB(pospos) {					\
  struct rgb *addpix = &bodySrc[pospos];			\
  sR += (short int)addpix->r;					\
  sG += (short int)addpix->g;					\
  sB += (short int)addpix->b;					\
  sS++; }

		  /*
		   * smoothing means
		   * 123
		   * 4a5 a += ((a-((1+2+3+4+5+6+7+8)/8))/smoothing)
		   * 678
		   */
		  if ((y - 1) > 0) {
		    if ((x - 1) > 0)
		      AddRGB(floatPos(y - 1, x - 1));		/*2 */
		    AddRGB(floatPos(y - 1, x));			/*1 */
		    if ((x + 1) < width)
		      AddRGB(floatPos(y - 1, x + 1));		/*3 */
		  }
		  if ((x - 1) > 0)
		    AddRGB(floatPos(y, x - 1));			/*4 */
		  AddRGB(floatPos(y, x));			/*a */
		  if ((x + 1) < width)
		    AddRGB(floatPos(y, x + 1));			/*5 */
		  if ((y + 1) < height) {
		    if ((x - 1) > 0)
		      AddRGB(floatPos(y + 1, x - 1));		/*7 */
		    AddRGB(floatPos(y + 1, x));			/*6 */
		    if ((x + 1) < width)
		      AddRGB(floatPos(y + 1, x + 1));		/*8 */
		  }

		  sR /= sS;
		  sG /= sS;
		  sB /= sS;

#define SetRGB(src, dst) {					\
  src -= (short int)rawpix.dst;					\
  src = S_SHIFT >= 0 ? (src >> S_SHIFT) : (src / S_SCALE);	\
  if(src) {							\
    src += (short int)rawpix.dst;				\
    if(src > 255)						\
      src = 255;						\
    else if(src < 0)						\
      src = 0;							\
    rawpix.dst = (unsigned char)src; } }

		  SetRGB(sR, r);
		  SetRGB(sG, g);
		  SetRGB(sB, b);
		}
	      }
	      else if (picType == TYPE_PGM) {
		/* gray    pgm */
		rawpix.r = ((unsigned char *)bodySrc)[floatPos(y, x)];

		if (smoothing) {
		  short int sG = 0, sS = 0;

#define AddGrey(pospos) {					\
  sG += (short int)(((unsigned char *)bodySrc)[pospos]);	\
  sS++; }

		  /*
		   * smoothing means
		   * 123
		   * 4a5 a += ((a-((1+2+3+4+5+6+7+8)/8))/smoothing)
		   * 678
		   */
		  if ((y - 1) > 0) {
		    if ((x - 1) > 0)
		      AddGrey(floatPos(y - 1, x - 1));		/*2 */
		    AddGrey(floatPos(y - 1, x));		/*1 */
		    if ((x + 1) < width)
		      AddGrey(floatPos(y - 1, x + 1));		/*3 */
		  }
		  if ((x - 1) > 0)
		    AddGrey(floatPos(y, x - 1));		/*4 */
		  AddGrey(floatPos(y, x));			/*a */
		  if ((x + 1) < width)
		    AddGrey(floatPos(y, x + 1));		/*5 */
		  if ((y + 1) < height) {
		    if ((x - 1) > 0)
		      AddGrey(floatPos(y + 1, x - 1));		/*7 */
		    AddGrey(floatPos(y + 1, x));		/*6 */
		    if ((x + 1) < width)
		      AddGrey(floatPos(y + 1, x + 1));		/*8 */
		  }

		  sG /= sS;

#define SetGrey(src, dst) {					\
  src -= (short int)rawpix.dst;					\
  src = S_SHIFT >= 0 ? (src >> S_SHIFT) : (src / S_SCALE);	\
  if(src) {							\
    src += (short int)rawpix.dst;				\
    if(src > 255)						\
      src = 255;						\
    else if(src < 0)						\
      src = 0;							\
    rawpix.dst = (unsigned char)src; }}

		  SetGrey(sG, r);
		}

		rawpix.b = rawpix.g = rawpix.r;
	      }

	      if (dither) {
		/* put scaled value */
		*((PRECISION *) flowTmp)++ = (PRECISION) rawpix.r;
		*((PRECISION *) flowTmp)++ = (PRECISION) rawpix.g;
		*((PRECISION *) flowTmp)++ = (PRECISION) rawpix.b;
	      }
	      else {
		/* put scaled value */
		*flowDst++ = Match(&rawpix, Palette);
#ifdef DEBUG
		mprintf("pixel %dx%d: %02x%02x%02x matches %02x (%02x%02x%02x) with match %d\n", ny, nx, rawpix.r, rawpix.g, rawpix.b, palpix, Palette[palpix].r, Palette[palpix].g, Palette[palpix].b, match);
#endif
	      }
	    }
	    mprogress((int)newheight, (int)ny + 1);
	  }

	  if (dither) {
	    flowTmp = bodyTmp;
	    for (ny = 0; ny < newheight; ny++) {
	      for (nx = 0; nx < newwidth; nx++) {
		unsigned char palpix = *flowDst++ = MatchD(flowTmp, Palette);
		PRECISION_EXT fR, fG, fB;

#define MakeError(offset, errorR, errorG, errorB) {		\
  PRECISION_EXT new;						\
  new = (PRECISION_EXT)(flowTmp[offset].r) + (errorR);		\
  if(new > 255)							\
    new = 255;							\
  else if(new < 0)						\
    new = 0;							\
  flowTmp[offset].r = (PRECISION)new; 				\
  new = (PRECISION_EXT)(flowTmp[offset].g) + (errorG);		\
  if(new > 255)							\
    new = 255;							\
  else if(new < 0)						\
    new = 0;							\
  flowTmp[offset].g = (PRECISION)new;				\
  new = (PRECISION_EXT)(flowTmp[offset].b) + (errorB);		\
  if(new > 255)							\
    new = 255;							\
  else if(new < 0)						\
    new = 0;							\
  flowTmp[offset].b = (PRECISION)new; }

		/*
		 * calculate error *
		 *      erro,7/16
		 * 3/16,5/16,1/16
		 */
		fR = ((PRECISION_EXT) (Palette[(short int)palpix].r) - (PRECISION_EXT) (flowTmp->r)) / FS_SCALE;
		fG = ((PRECISION_EXT) (Palette[(short int)palpix].g) - (PRECISION_EXT) (flowTmp->g)) / FS_SCALE;
		fB = ((PRECISION_EXT) (Palette[(short int)palpix].b) - (PRECISION_EXT) (flowTmp->b)) / FS_SCALE;
		if ((fR + fG + fB) != 0) {
		  if ((ny + 1) < newheight) {
		    if ((nx - 1) > 0) {
		      MakeError((newwidth - 1), (fR * 3), (fG * 3), (fB * 3));
		    }
		    MakeError((newwidth), (fR * 5), (fG * 5), (fB * 5));
		    if ((nx + 1) < newwidth) {
		      MakeError((newwidth + 1), (fR), (fG), (fB));
		    }
		  }
		  if ((nx + 1) < newwidth) {
		    MakeError((1), (fR * 7), (fG * 7), (fB * 7));
		  }
		}

		flowTmp++;
	      }
	      mprogress((int)newheight, (int)ny + 1);
	    }
	  }
	}

	if (dither)
	  tfree(bodyTmp);
      }
      else
	eprintf(failed_memory, picType == TYPE_PPM ? newwidth * newheight * 3 : newwidth * newheight, "picture");

      tfree(bodySrc);
    }
    else
      eprintf(failed_memory, picType == TYPE_PPM ? width * height * 3 : width * height, "picture");
  }
  else
    eprintf("unknown picture-type\n");

  return Picture;
}
