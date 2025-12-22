/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     images
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 7, 1996: Created.
***/

#ifndef IMAGES
#define IMAGES

XPutImage_nochunky(
     Display *display,
     Drawable d,
     GC gc,
     XImage *image,
     int src_x, int src_y,
     int dest_x, int dest_y,
     unsigned int width, unsigned int height
);

XImage *XGetImage_nochunky(
     Display *display,
     Drawable drawable,
     int x, int y,
     unsigned int width, unsigned int height,
     unsigned long plane_mask,
     int format);

void X11Setup_Tile( GC gc, int tile );

#ifdef DEBUGXEMUL_ENTRY
extern int bIgnoreImages; /* ignore outputting information about images */
extern int bSkipImageWrite;
#endif

extern unsigned char X11InvertMap[];

void X11init_images(void);
void X11exit_images(void);

char*
make_8bit( XImage *image,
	   int src_x,
	   int src_y,
	   int width,
	   int height);

extern int show;

#endif /* IMAGES */
