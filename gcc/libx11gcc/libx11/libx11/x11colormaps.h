/* Copyright (c) 1996 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     x11colormaps
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Nov 10, 1996: Created.
***/

#ifndef X11COLORMAPS
#define X11COLORMAPS

#define SCALE8TO32(x) ((x)|((x)<<8)|((x)<<16)|((x)<<24))

typedef struct {
  unsigned char red;
  unsigned char green;
  unsigned char blue;
  unsigned char pixel;
} X11color_t;

typedef struct {
  int nMaxColors;
  X11color_t aColorDef[256];
  unsigned char aAllocMap[256];
  short nAllocNext;
  short nAllocateMax;
  int vWindow; /* window using this colormap */

} X11ColorMap_t;


extern struct ColorMap **X11Cmaps;
extern int X11NumCmaps;
extern int X11AvailCmaps;

XID X11NewCmap( struct ColorMap *cmap );
extern void swapwbcm(int,ULONG *);
extern void savewbcm(void);

#endif /* X11COLORMAPS */
