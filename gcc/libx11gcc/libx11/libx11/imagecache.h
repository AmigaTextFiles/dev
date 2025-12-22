/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     imagecache
   PURPOSE
     
   NOTES
     
   HISTORY
     Terje Pedersen - Apr 13, 1997: Created.
***/

#ifndef IMAGECACHE
#define IMAGECACHE

typedef struct {
  int vFillSource;
  int vFillX;
  int vFillY;
  int vFillDepth;
  int vFillWidth;
  int vFillHeight;
  int vSize;
  void* pData;
  int vUseCount;
} CacheEntry_t;

typedef CacheEntry_t* CacheEntry_p;

#define MAXENTRIES 64

void ImageCache_Init( void );
void ImageCache_Exit( void );
CacheEntry_p
ImageCache_Find( int w, int h, int Source, int LastX, int LastY );

boolean
ImageCache_Insert( int Source,
		   int X,
		   int Y,
		   int Depth,
		   int Width,
		   int Height,
		   void* pData );

int ImageCache_RemoveSome( int vSource );
int ImageCache_Delete( int vSource );

extern CacheEntry_t ImageCache[MAXENTRIES];

#endif /* IMAGECACHE */
