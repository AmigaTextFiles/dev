/* Copyright (c) 1997 by A BIG Corporation.  All Rights Reserved */

/***
   NAME
     imagecache
   PURPOSE
     caching images used in filing
   NOTES
     
   HISTORY
     Terje Pedersen - Apr 13, 1997: Created.
***/

#include "amiga.h"

#include <dos/dos.h>

#include <stdio.h>
#include "defines.h"

#include "libX11.h"

#include "x11display.h"
#include "imagecache.h"

extern int free_bitmap( struct BitMap *bmp );
extern void X11RemoveTileStippled( int vBitmap );
extern boolean X11IsTileStippleActive( int vBitmap );

CacheEntry_t ImageCache[MAXENTRIES];

int vCurrentMemorySize = 0;
int vMaxCacheMemorySize = 200*1024;

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
ImageCache_Init( void )
{
  int i;

  for( i=0; i<MAXENTRIES; i++ ){
    ImageCache[i].vFillSource = -1;
    ImageCache[i].vSize = 0;
    ImageCache[i].vUseCount = 0;
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

void
ImageCache_Exit( void )
{
  int i;

  for( i=0; i<MAXENTRIES; i++ ){
    if( ImageCache[i].vFillSource!=-1 ){
      free_bitmap((struct BitMap *)ImageCache[i].pData);
    }
  }
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

CacheEntry_p
ImageCache_Find( int w, int h, int Source, int LastX, int LastY )
{
  int i;
  int nNewItemsX,nNewItemsY;

  for( i=0; i<MAXENTRIES; i++ ){
    if( ImageCache[i].vFillSource==Source ){
      ImageCache[i].vUseCount++;

      nNewItemsX = (int)((w+ImageCache[i].vFillWidth)/ImageCache[i].vFillWidth);
      nNewItemsY = (int)((h+ImageCache[i].vFillHeight)/ImageCache[i].vFillHeight);
    
      if( nNewItemsX*ImageCache[i].vFillWidth<=LastX
	  && nNewItemsX*ImageCache[i].vFillWidth<=w
	  && nNewItemsY*ImageCache[i].vFillHeight<=LastY
	  && nNewItemsY*ImageCache[i].vFillHeight<=h )
	return &ImageCache[i];

      /* ImageCache_Delete( Source ); */
      ImageCache[i].vFillSource = -1;
      free_bitmap((struct BitMap *)ImageCache[i].pData);
      vCurrentMemorySize -= ImageCache[i].vSize;
      ImageCache[i].vSize = 0;

      return NULL;
    }
  }

  return NULL;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

boolean
ImageCache_Insert( int Source,
		   int X,
		   int Y,
		   int Depth,
		   int Width,
		   int Height,
		   void* pData )
{
  int vPos;
  int i;
  int vSize = X*Y*Depth;

  if( Source==0 ){
    printf("Inserting 0!\n");
  }

  if( vSize>vMaxCacheMemorySize )
    return FALSE;

  for( i=0; i<MAXENTRIES; i++ ){
    if( ImageCache[i].vFillSource==-1 ){
      vCurrentMemorySize += vSize;
      while( vCurrentMemorySize>vMaxCacheMemorySize )
	ImageCache_RemoveSome( Source );

      ImageCache[i].vFillSource = Source;
      ImageCache[i].vFillX = X;
      ImageCache[i].vFillY = Y;
      ImageCache[i].vFillDepth = Depth;
      ImageCache[i].vFillWidth = Width;
      ImageCache[i].vFillHeight = Height;
      ImageCache[i].pData = pData;
      ImageCache[i].vSize = vSize;
      ImageCache[i].vUseCount = 1;

      return TRUE;
    }
  }
  vPos = ImageCache_RemoveSome( Source );

  vCurrentMemorySize += vSize;
  while( vCurrentMemorySize>vMaxCacheMemorySize )
    ImageCache_RemoveSome( Source );

  ImageCache[vPos].vFillSource = Source;
  ImageCache[vPos].vFillX = X;
  ImageCache[vPos].vFillY = Y;
  ImageCache[vPos].vFillDepth = Depth;
  ImageCache[vPos].vFillWidth = Width;
  ImageCache[vPos].vFillHeight = Height;
  ImageCache[vPos].vSize = vSize;
  ImageCache[vPos].pData = pData;
  ImageCache[vPos].vUseCount = 1;

  return TRUE;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
ImageCache_RemoveSome( int vSource )
{
  int vSize = 0;
  int vUse = -1;
  int i;
  int vNumActive = 0;

  for( i=0; i<MAXENTRIES; i++ ){
    if( ImageCache[i].vFillSource==-1 )
      continue;
    if( X11IsTileStippleActive(ImageCache[i].vFillSource) ){
      vNumActive++;
      continue;
    }

    if( ImageCache[i].vSize>vSize &&
        ImageCache[i].vFillSource!=vSource ){
      vSize = ImageCache[i].vSize;
      vUse = i;
    }
  }

#if (DEBUG!=0)
  if( vNumActive>DG.X11NumGC ){
    printf("How can it be?");
  }
  printf("*** Cache Remove %d %d keep %d\n",vUse,ImageCache[vUse].vFillSource,vSource);
#endif
  if( vUse == -1 ){/* bugger need bigger cache.. */
    vMaxCacheMemorySize = vCurrentMemorySize;

    return 0;
  }
  
  free_bitmap((struct BitMap *)ImageCache[vUse].pData);
  X11RemoveTileStippled( ImageCache[vUse].vFillSource );
  ImageCache[vUse].vFillSource = -1;
  ImageCache[vUse].vSize = 0;
  vCurrentMemorySize -= vSize;

  return vUse;
}

/********************************************************************************
Name     : 
Author   : Terje Pedersen
Input    : 
Output   : 
Function : 
********************************************************************************/

int
ImageCache_Delete( int vSource )
{
  int vUse = -1;
  int i;

  for( i=0; i<MAXENTRIES; i++ ){
    if( ImageCache[i].vFillSource==vSource ){
      vUse = i;
      break;
    }
  }
  if( vUse!=-1 ){
    X11RemoveTileStippled( ImageCache[vUse].vFillSource );
    ImageCache[vUse].vFillSource = -1;
    
    free_bitmap((struct BitMap *)ImageCache[vUse].pData);
    vCurrentMemorySize -= ImageCache[vUse].vSize;
    ImageCache[vUse].vSize = 0;
  }
}
