/*
**  $VER: pictureclassext.h 43.2 (9.3.97)
**
**  Extended V43 interface definitions for DataType picture objects.
**
**  Written by Ralph Schmidt, Frank Mariak and Roland Mainz
**
*/

#define PDTA_SourceMode 		(DTA_Dummy + 250)	/* Used to set the sub datatype interface */
#define PDTA_DestMode 		(DTA_Dummy + 251)	/* Used to set the app datatype interface */
#define PDTA_PixelFormat 	(DTA_Dummy + 252)	/* private..DON'T touch */
#define PDTA_TransRemapPen 	(DTA_Dummy + 253)	/* Optional transparent remap pen */
#define PDTA_NumPixMapDir 	(DTA_Dummy + 254)	/* Count of the Object's PixMapDirs..default=1 */
#define PDTA_UseFriendBitMap 	(DTA_Dummy + 255)	/* Converts the result bitmap into a friendbitmap */
/* This will speed up rendering a lot */
#define PDTA_AlphaChannel 	(DTA_Dummy + 256)	/* Alphachannel input */
#define PDTA_MultiRemap 		(DTA_Dummy + 257)	/* Tells the picture.datatype NOT to keep control */
/* over DestBitmap and Pens...these are now*/
/* controlled by the appliction. TM mode*/
#define PDTA_MaskPlane 		(DTA_Dummy + 258)	/* NULL or MaskPlane for BltMaskBitMapRastPort() */
/* This mask is generated when the transparent flag is set*/
/* or an Alphachannel exists */
/* PDTA_SourceMode, PDTA_DestMode */
#define PMODE_V42         (0)
#define PMODE_V43         (1)
/* Extended V43 pictureclass methods */
#define PDTM_Dummy            (DTM_Dummy + $60) L*	/* see datatypes/datatypesclass.h */
#define PDTM_WRITEPIXELARRAY  (PDTM_Dummy + 0)
/* Used to transfer pixel data to the picture.datatype object in the specified format */
#define PDTM_READPIXELARRAY   (PDTM_Dummy + 1)
/* Used to transfer pixel data from the picture.datatype object in the specified format */
#define PDTM_CREATEPIXMAPDIR  (PDTM_Dummy + 2)
/* Used to create a new pixmap directory for multi-volume bitmap data */
#define PDTM_FIRSTPIXMAPDIR   (PDTM_Dummy + 3)
/* Used to set the current pixmap to the first one in the list  */
#define PDTM_NEXTPIXMAPDIR    (PDTM_Dummy + 4)
/* Used to set the current pixmap to the next one in the list  */
#define PDTM_PREVPIXMAPDIR    (PDTM_Dummy + 5)
/* Used to set the current pixmap to the previous one in the list  */
#define PDTM_BESTPIXMAPDIR    (PDTM_Dummy + 6)
/* Sets the pixmap directory to the best one fitted for the screen */
/* PDTM_WRITEPIXELARRAY, PDTM_READPIXELARRAY */

OBJECT pdtBlitPixelArray
	MethodID:ULONG,                  /* PDTM_BLITPIXELARRAY or PDTM_READPIXELARRAY id             */
	PixelArray:PTR TO UBYTE,    /* Source PixelArray                                         */
	PixelArrayMode:ULONG,       /* Format Mode of the Source PixelArray; see cybergraphics.h */
	PixelArrayMod:ULONG,        /* Bytes to add to the next line in the Source PixelArray    */
	LeftEdge:ULONG,             /* XStart of the Dest                                        */
	TopEdge:ULONG,              /* YStart of the Dest                                        */
	Width:ULONG,                /* Width of the Source PixelArray                            */
	Height:ULONG                /* Height of the Source PixelArray                           */

/* Obsolete pictureclassext.h definitions, here for source code compatibility only.
 * Please do NOT use in new code.
 *
 * #define PICTURECLASS_NEWNAMES_ONLY to remove these older names
 */
#define DTM_WRITEPIXELARRAY  PDTM_WRITEPIXELARRAY
#define DTM_READPIXELARRAY   PDTM_READPIXELARRAY
#define DTM_CREATEPIXMAPDIR  PDTM_CREATEPIXMAPDIR
#define DTM_FIRSTPIXMAPDIR   PDTM_FIRSTPIXMAPDIR
#define DTM_NEXTPIXMAPDIR    PDTM_NEXTPIXMAPDIR
#define DTM_PREVPIXMAPDIR    PDTM_PREVPIXMAPDIR
#define DTM_BESTPIXMAPDIR    PDTM_BESTPIXMAPDIR

/* Obsolete DTM_BLITPIXELARRAY msg, use struct pdtBlipPixelArray instead */

OBJECT gpBlitPixelArray
	MethodID:ULONG,             /* DTM_BLITPIXELARRAY id */
	PixelArray:PTR TO UBYTE,    /* Source PixelArray */
	PixelArrayMode:ULONG,       /* Format Mode of the Source PixelArray..see cybergraphics.h */
	PixelArrayMod:ULONG,        /* Bytes to add to the next line in the Source PixelArray */
	LeftEdge:ULONG,             /* XStart of the Dest */
	TopEdge:ULONG,              /* YStart of the Dest */
	Width:ULONG,                /* Width of the Source PixelArray */
	Height:ULONG                /* Height of the Source PixelArray */

/* PDTA_SourceMode,PDTA_DestMode */
#define MODE_V42  PMODE_V42
#define MODE_V43  PMODE_V43
