/*
** PCX Hollywood plugin
** Copyright (C) 2015-2020 Andreas Falkenhahn <andreas@airsoftsoftwair.de>
** Copyright (C) 2001-2005 by TEK neoscientists and the respective authors:
**
**	- Timm S. Müller
**	- Daniel Adler
**	- Frank Pagels
**	- Daniel Trompetter
**	- Tobias Schwinger
**	- Franciska Schulze
**
** Permission is hereby granted, free of charge, to any person obtaining a copy
** of this software and associated documentation files (the "Software"), to deal
** in the Software without restriction, including without limitation the rights
** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
** copies of the Software, and to permit persons to whom the Software is
** furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included in
** all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
** EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
** MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
** IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
** CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
** TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
** SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include <ctype.h>
#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#include <hollywood/plugin.h>

#include "pcx.h"
#include "version.h"

// container structure for our image	
struct pcximage
{
	APTR fh;
	APTR data;
	ULONG palette[256];
	int width;
	int height;
	int depth;
	int version;
	int compression;
	int bitsperpixel;
	int bytesperline;
	int bytesperrow;
	int planes;
	int format;
	int palinfo;
	int longpalette;
	int shortpalette;
	int loadpalette;
	int grey;
	int length;
	int filelen;
};

// pointer to the Hollywood plugin API
static hwPluginAPI *hwcl = NULL;

// information about our plugin for InitPlugin()
// (NB: we store the version string after the plugin's name; this is not required by Hollywood;
// it is just a trick to prevent the linker from optimizing our version string away)
static const char plugin_name[] = PLUGIN_NAME "\0$VER: " PLUGIN_MODULENAME ".hwp " PLUGIN_VER_STR " (" PLUGIN_DATE ") [" PLUGIN_PLAT "]";
static const char plugin_modulename[] = PLUGIN_MODULENAME;
static const char plugin_author[] = PLUGIN_AUTHOR;
static const char plugin_description[] = PLUGIN_DESCRIPTION;
static const char plugin_copyright[] = PLUGIN_COPYRIGHT;
static const char plugin_url[] = PLUGIN_URL;
static const char plugin_date[] = PLUGIN_DATE;

// different types of PCX pixel data
enum {PCXFMT_PLANAR, PCXFMT_CLUT, PCXFMT_BGR};

/*
** WARNING: InitPlugin() will be called by *any* Hollywood version >= 5.0. Thus, you must
** check the Hollywood version that called your InitPlugin() implementation before calling
** functions from the hwPluginAPI pointer or accessing certain structure members. Your
** InitPlugin() implementation must be compatible with *any* Hollywood version >= 5.0. If
** you call Hollywood 6.0 functions here without checking first that Hollywood 6.0 or higher
** has called your InitPlugin() implementation, *all* programs compiled with Hollywood
** versions < 6.0 *will* crash when they try to open your plugin! 
*/
HW_EXPORT int InitPlugin(hwPluginBase *self, hwPluginAPI *cl, STRPTR path)
{
	// open Amiga libraries needed by this plugin
#ifdef HW_AMIGA
	if(!initamigastuff()) return FALSE;
#endif

	// identify as an image plugin to Hollywood
	self->CapsMask = HWPLUG_CAPS_IMAGE;
	self->Version = PLUGIN_VER;
	self->Revision = PLUGIN_REV;
	
	// we want to be compatible with Hollywood 5.0
	// **WARNING**: when compiling with newer SDK versions you have to be very
	// careful which functions you call and which structure members you access
	// because not all of them are present in earlier versions. Thus, if you
	// target versions older than your SDK version you have to check the hollywood.h
	// header file very carefully to check whether the older version you want to
	// target has the respective feature or not
	self->hwVersion = 5;
	self->hwRevision = 0;
	
	// set plugin information; note that these string pointers need to stay
	// valid until Hollywood calls ClosePlugin()
	self->Name = (STRPTR) plugin_name;
	self->ModuleName = (STRPTR) plugin_modulename;	
	self->Author = (STRPTR) plugin_author;
	self->Description = (STRPTR) plugin_description;
	self->Copyright = (STRPTR) plugin_copyright;
	self->URL = (STRPTR) plugin_url;
	self->Date = (STRPTR) plugin_date;
	self->Settings = NULL;
	self->HelpFile = NULL;

	// NB: "cl" can be NULL in case Hollywood or Designer just wants to obtain information
	// about our plugin
	if(cl) {
		
		hwcl = cl;
		
		// it is important to check that we have at least Hollywood 5.3 before calling
		// hw_RegisterFileType() because it isn't available in earlier versions
		if(hwcl->hwVersion > 5 || (hwcl->hwVersion == 5 && hwcl->hwRevision >= 3)) {			
			hwcl->SysBase->hw_RegisterFileType(self, HWFILETYPE_IMAGE, "PCX", NULL, "pcx", 0, 0);	
		}		
	}
		
	return TRUE;
}

/*
** WARNING: ClosePlugin() will be called by *any* Hollywood version >= 5.0.
** --> see the note above in InitPlugin() for information on how to implement this function
*/
HW_EXPORT void ClosePlugin(void)
{
#ifdef HW_AMIGA
	freeamigastuff();
#endif
}

/* read a little-endian 16-bit word in an endian-neutral way */
static short FReadW_LE(APTR fh)
{
	int one, two;

	one = hw_FGetC(fh);
	two = hw_FGetC(fh);

	return (short) ((two << 8) | one);   // return signed short
}

/*
** version of hw_FOpen() that supports Hollywood's "Adapter" tag (introduced in 6.0)
** but is also compatible with Hollywood 5
*/
static APTR hw_FOpen(STRPTR name, int mode, STRPTR adapter)
{
	if(hwcl->hwVersion >= 6 && adapter) {
		
		struct hwTagList tags[16];
		
		tags[0].Tag = HWFOPENTAG_ADAPTER;
		tags[0].Data.pData = adapter;
		tags[1].Tag = 0;
		
		return hwcl->DOSBase->hw_FOpenExt(name, mode, tags);

	} else {		

		return hwcl->DOSBase->hw_FOpen(name, mode);
	}	
} 

/* open a PCX image */
static struct pcximage *openpcx(STRPTR filename, struct LoadImageCtrl *ctrl)
{
	struct pcximage *img;
	STRPTR adapter = NULL;	
	APTR fh;
	UBYTE sig[2];		
	int startx, starty, endx, endy;
			
	// we must check for Hollywood 6.0 before trying to access the "Adapter" structure
	// member because it isn't there in earlier versions
	if(hwcl->hwVersion >= 6) adapter = ctrl->Adapter;
			
      	// open file                               	
	if(!(fh = hw_FOpen(filename, HWFOPENMODE_READ_LEGACY, adapter))) return NULL;

	// read first 2 bytes
	if(hw_FRead(fh, sig, 2) != 2) {
		hw_FClose(fh);
		return NULL;
	}
	
	// do we have a PCX image?
	if(!(sig[0] == 10 && (sig[1] == 0 || (sig[1] >= 2 && sig[1] <= 5)))) {
		hw_FClose(fh);
		return NULL;
	}
				
	if(!(img = my_calloc(sizeof(struct pcximage), 1))) {
		hw_FClose(fh);
		return NULL;
	}	

	img->fh = fh;
	img->version = sig[1];
		
	// read PCX header
	img->compression = hw_FGetC(fh);
	img->bitsperpixel = hw_FGetC(fh);
	startx = FReadW_LE(fh);
	starty = FReadW_LE(fh);
	endx = FReadW_LE(fh);
	endy = FReadW_LE(fh);
	
	hw_FSeek(fh, 65, HWFSEEKMODE_BEGINNING);
	img->planes = hw_FGetC(fh);
	img->bytesperline = FReadW_LE(fh);
	img->palinfo = FReadW_LE(fh);

	img->width = (endx - startx) + 1;
	img->height = (endy - starty) + 1;
	img->loadpalette = !!(ctrl->Flags & HWIMGFLAGS_LOADPALETTE);
	
	return img;
}

/* check if a file is a PCX image */
HW_EXPORT int IsImage(STRPTR filename, struct LoadImageCtrl *ctrl)
{
	struct pcximage *img = openpcx(filename, ctrl);
	
	if(img) {
		ctrl->Width = img->width;
		ctrl->Height = img->height;
		ctrl->AlphaChannel = FALSE;
	
		hw_FClose(img->fh);
		my_free(img);	
	}
		
	return !!img;	
}

/* read palette data from PCX file */
static int read_pcx_palette(struct pcximage *img, ULONG *palette)
{
	int i;
	UBYTE r, g, b;
	
	if(img->longpalette) {
		
		hw_FSeek(img->fh, img->filelen - 768, HWFSEEKMODE_BEGINNING);

		for(i = 0; i < 256; i++) {
			hw_FRead(img->fh, &r, 1);
			hw_FRead(img->fh, &g, 1);
			hw_FRead(img->fh, &b, 1);
			palette[i] = MakeRGB(r, g, b);
		}
		
	} else if(img->shortpalette) {
		
		hw_FSeek(img->fh, 16, HWFSEEKMODE_BEGINNING);
		
		if(img->depth == 4) {
			
			for(i = 0; i < 16; i++) {
				hw_FRead(img->fh, &r, 1);
				hw_FRead(img->fh, &g, 1);
				hw_FRead(img->fh, &b, 1);
				palette[i] = MakeRGB(r, g, b);
			}
			
		} else if(img->depth == 1) {
			
			for(i = 0; i < 2; i++) {
				hw_FRead(img->fh, &r, 1);
				hw_FRead(img->fh, &g, 1);
				hw_FRead(img->fh, &b, 1);
				palette[i] = MakeRGB(r, g, b);
			}
		}
		
	} else if(img->grey) {
		
		if(img->depth == 1) {
			
			palette[0] = 0;
			palette[1] = 0xffffff;
			
		} else if(img->depth == 4) {
			
			for(i = 0; i < 16; i++) palette[i] = MakeRGB(i << 4, i << 4, i << 4);
			
		} else if(img->depth == 8) {
			
			for(i = 0; i < 256; i++) palette[i] = MakeRGB(i, i, i);
		}
	}
	
	return TRUE;
}

/* unpack RLE compressed pixels */
static int read_pcx_data_normal(struct pcximage *img, UBYTE *data)
{
	int i, j, k, m, lb;
	int X = 0, N;
	int remcount = 0;
	
	lb = img->bytesperline;

	hw_FSeek(img->fh, 128, HWFSEEKMODE_BEGINNING);
	i = 0;
	
	for(i = 0; i < img->height; i++) {
		
		for(j = img->planes - 1; j >= 0; j--) {
				
			for(k = 0; k < remcount; k++) data[(i*lb+k)*img->planes+j] = X;
			remcount = 0;
								
			while(k < lb) {
				
				if(-1 == (X = (hw_FGetC(img->fh)))) return TRUE;

				if((X & 0xc0) == 0xc0) {
					N = X & 0x3f;
					if(-1 == (X = (hw_FGetC(img->fh)))) return TRUE;
				} else {
					N = 1;
				}
				
				if(k + N > lb) {
					remcount = (k + N) - lb;
					N = lb - k;
				}	
				
				for(m = 0; m < N; m++) data[(i*lb+k+m)*img->planes+j] = X;
				k += N;	
			}		
		}
	}
	
	return TRUE;
}

/* read uncompressed pixels */
static int read_pcx_data_normal_unpacked(struct pcximage *img, UBYTE *data)
{
	int i, j, k, lb;
	int X;

	lb = img->bytesperline;

	hw_FSeek(img->fh, 128, HWFSEEKMODE_BEGINNING);
	i = 0;

	for(i = 0; i < img->height; i++) {
		
		for(j = img->planes - 1; j >= 0; j--) {
			
			k = 0;
			while(k < lb) {
				
				if(-1 == (X = (hw_FGetC(img->fh)))) return TRUE;

				data[(i*lb+k)*img->planes+j] = X;

				k++;
			}
		}
	}
	
	return TRUE;
}

/* decode RLE data */ 
static int read_pcx_encget(struct pcximage *img, UBYTE *pbyt, UBYTE *pcnt)
{
	int i;

	*pcnt = 1;
	if(-1 == (i = (hw_FGetC(img->fh)))) return -1;

	if(0xC0 == (0xC0 & i)) {
		*pcnt = 0x3F & i;
		if(-1 == (i = (hw_FGetC(img->fh)))) return -1;
	}
	
	*pbyt = i;
	return 0;
}

/* read RLE compressed 4-bit PCX files */
static int read_pcx_data_4bit(struct pcximage *img, UBYTE *tmpbuf)
{
	int i, l, lsize;
	UBYTE chr, cnt;
	UBYTE *wptr;

	lsize = img->bytesperline * img->planes * img->width * 2;
	wptr = tmpbuf;

	hw_FSeek(img->fh, 128, HWFSEEKMODE_BEGINNING);

	for(l = 0; l < lsize; ) {
		
		if(-1 == read_pcx_encget(img, &chr, &cnt)) return TRUE;

		for(i = 0; i < cnt; i++) *wptr++ = chr;

		l += cnt;
	}
	
	return TRUE;
}

/* read uncompressed 4-bit PCX files */
static int read_pcx_data_4bit_unpacked(struct pcximage *img, UBYTE *tmpbuf)
{
	int l, lsize;
	int chr;
	UBYTE *wptr;

	lsize = img->bytesperline * img->planes * img->width * 2;
	wptr = tmpbuf;

	hw_FSeek(img->fh, 128, HWFSEEKMODE_BEGINNING);

	for(l = 0; l < lsize; l++) {		
		if(-1 == (chr = hw_FGetC(img->fh))) return TRUE;
		*wptr++ = chr;
	}
	
	return TRUE;
}

/* decode 4-bit pixels to 8-bit chunky */
static void read_pcx_decode4bit(struct pcximage *img, UBYTE *tmpbuf, UBYTE *data)
{
	int i, j, rowoffset, lcount, lineoffset;
	UBYTE v1, v2, v3, v4, val;
	UBYTE *wptr = data;

	for(i = 0; i < img->height; i++) {
		
		lineoffset = i * img->bytesperline * 4;
		rowoffset = 0;
		
		for(j = 0; j < img->width; j += 8) {

			v1 = tmpbuf[lineoffset+rowoffset];
			v2 = tmpbuf[lineoffset+img->bytesperline+rowoffset];
			v3 = tmpbuf[lineoffset+img->bytesperline+img->bytesperline+rowoffset];
			v4 = tmpbuf[lineoffset+img->bytesperline+img->bytesperline+img->bytesperline+rowoffset];
			rowoffset++;
			
			if(j < img->width-8) {
				lcount = 7;
			} else {
				lcount = img->width - j - 1;
			}
			
			do
			{
				val=((((v4 << (7-lcount)) & 0x80)>>4) |
					 (((v3 << (7-lcount)) & 0x80)>>5) |
					 (((v2 << (7-lcount)) & 0x80)>>6) |
					 (((v1 << (7-lcount)) & 0x80)>>7));

				*wptr++ = val;
				
			} while(lcount--);
		}
	}
}
 
/* load PCX image */ 
HW_EXPORT APTR LoadImage(STRPTR filename, struct LoadImageCtrl *ctrl)
{
      	struct pcximage *img;
      	int success, x, y, bpp;
      	UBYTE *data = NULL, *src, *dst;

	// is the file in PCX format?
	if(!(img = openpcx(filename, ctrl))) return NULL;
	
	// note that there are more PCX formats than we support here
	// we support only the most common ones			
	if(img->bitsperpixel == 1 && img->planes == 1) {
		img->depth = 1;
		img->bytesperrow = (img->width + 7) / 8;
		img->format = PCXFMT_PLANAR;
	} else if(img->bitsperpixel == 1 && img->planes == 4) {
		img->depth = 4;
		img->bytesperrow = img->width;
		img->format = PCXFMT_CLUT;
		img->shortpalette = TRUE;
	} else if(img->bitsperpixel == 8 && img->planes == 1) {
		img->depth = 8;
		img->bytesperrow = img->bytesperline;
		img->format = PCXFMT_CLUT;
	} else if(img->bitsperpixel == 8 && img->planes == 3) {
		img->depth = 24;
		img->bytesperrow = img->bytesperline * 3;
		img->format = PCXFMT_BGR;
	} else {
		goto error_loadimage;
	}
	
	hw_FSeek(img->fh, 0, HWFSEEKMODE_END);
	img->length = hw_FSeek(img->fh, 0, HWFSEEKMODE_CURRENT) - 128;
	img->filelen = img->length + 128;
	
	// determine palette type (if any)
	if(img->palinfo == 2) {
		
		img->grey = TRUE;
		img->shortpalette = FALSE;
		
	} else if(img->version == 2 || img->version == 5) {
		
		if(img->depth == 8) {
			
			if(hw_FSeek(img->fh, img->filelen - 769, HWFSEEKMODE_BEGINNING)) {

				UBYTE loaddata[1];
				
				if(hw_FRead(img->fh, loaddata, 1) != 1) goto error_loadimage;
					
				if(loaddata[0] == 0x0c) {
					
					img->length -= 769;
					img->longpalette = TRUE;
					
				} else {
					
					img->grey = TRUE;
				}
				
			} else {
				
				img->grey = TRUE;
			}
		
		} else {
		
			img->shortpalette = TRUE;
		}	
	}		
	
	// allocate temporary buffer
	if(!(data = my_malloc(img->bytesperrow * img->height))) goto error_loadimage;
				
	if(img->depth == 4) {
			
		int lsize = img->bytesperline * img->planes * img->width * 2;
		UBYTE *tmpbuf = my_calloc(lsize, 1);

		if(!tmpbuf) goto error_loadimage;
		
		// read PCX data	
		if(img->compression) {
			if((success = read_pcx_data_4bit(img, tmpbuf)) == TRUE) read_pcx_decode4bit(img, tmpbuf, data);
		} else {
			if((success = read_pcx_data_4bit_unpacked(img, tmpbuf)) == TRUE) read_pcx_decode4bit(img, tmpbuf, data);				
		}
		
		my_free(tmpbuf);
			
	} else {
		
		// read PCX data
		if(img->compression) {
			success = read_pcx_data_normal(img, data);
		} else {
			success = read_pcx_data_normal_unpacked(img, data);
		}
	}		

	if(!success) goto error_loadimage;
		
	bpp = (img->loadpalette) ? 1 : 4;
		
	// allocate ARGB pixel buffer for GetImage()
	if(!(img->data = my_malloc(img->width * img->height * bpp))) goto error_loadimage;
	src = data;
	dst = img->data;
	
	// convert pixel data to ARGB
	switch(img->format) {
	case PCXFMT_PLANAR:
		if(img->loadpalette) img->palette[1] = 0xffffff;
			
		for(y = 0; y < img->height; y++) {
			
			int bitmask = 0x80;
			
			for(x = 0; x < img->width; x++) {
				
				UBYTE pset = !!(src[x>>3] & bitmask);
				
				switch(bpp) {
				case 1:
					*dst = pset;
					break;
				case 4:
					*((ULONG *) dst) = (pset) ? 0xffffff : 0;
					break;
				}
				
				dst += bpp;
					
				if(!(bitmask >>= 1)) bitmask = 0x80;
			}
			
			src += img->bytesperrow;
		}			
		break;
		
	case PCXFMT_CLUT:
		read_pcx_palette(img, img->palette);
		
		for(y = 0; y < img->height; y++) {
						
			for(x = 0; x < img->width; x++) {
				
				UBYTE pen = *src++;
				
				switch(bpp) {
				case 1:
					*dst = pen;
					break;
				case 4:	
					*((ULONG *) dst) = img->palette[pen];
					break;
				}
				
				dst += bpp;
			}
			
			if(img->depth == 8) {
				src += img->bytesperline - img->width;
			} else {
				src += img->bytesperrow - img->width;
			}		
		}									
		break;
		
	case PCXFMT_BGR:
		if(img->loadpalette) goto error_loadimage;
			
		for(y = 0; y < img->height; y++) {
			
			for(x = 0; x < img->width; x++) {
				
				UBYTE b = *src++;
				UBYTE g = *src++;
				UBYTE r = *src++;
				
				*((ULONG *) dst) = MakeRGB(r, g, b);
				dst += bpp;
			}
			
			src += (img->bytesperline - img->width) * 3;			
		}		
		break;
	}
			
	my_free(data);
	data = NULL;
	
	hw_FClose(img->fh);
	img->fh = NULL;	
	
	// return information about the image just read
	ctrl->Width = img->width;
	ctrl->Height = img->height;
	ctrl->LineWidth = img->width;
	ctrl->Type = HWIMAGETYPE_RASTER;
	ctrl->ForceAlphaChannel = 0;
	ctrl->AlphaChannel = FALSE;
	
	if(hwcl->hwVersion >= 9) ctrl->Depth = img->depth;	
	
	return img;
	
error_loadimage:
	if(data) my_free(data);

	if(img->fh) hw_FClose(img->fh);		
	if(img->data) my_free(img->data);
	my_free(img);
					
	return NULL;		
}

/* return image data to Hollywood */
HW_EXPORT ULONG *GetImage(APTR handle, struct LoadImageCtrl *ctrl)
{
	struct pcximage *img = (struct pcximage *) handle;

	ctrl->Width = img->width;
	ctrl->Height = img->height;
	ctrl->LineWidth = img->width;
	ctrl->AlphaChannel = FALSE;

	if(hwcl->hwVersion >= 9) {
		ctrl->Depth = img->depth;	
		if(img->loadpalette) ctrl->Palette = img->palette;
	}
	
	return img->data;	
}

/* free image handle allocated by LoadImage() */
HW_EXPORT void FreeImage(APTR handle)
{
	struct pcximage *img = (struct pcximage *) handle;

	my_free(img->data);
	my_free(img);
}

/* dummy function because this is never called for raster images */
HW_EXPORT int TransformImage(APTR handle, struct hwMatrix2D *m, int width, int height)
{
	return FALSE;
}

