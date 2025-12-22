/* $Id: bitmapshare.h,v 1.15 2005/11/10 15:39:40 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
MODULE 'target/utility/tagitem'
{#include <intuition/bitmapshare.h>}
NATIVE {INTUITION_BITMAPSHARE_H} CONST

/* Tags for ObtainBitMapSourceA() */

NATIVE {BMS_Dummy}     CONST BMS_DUMMY     = (TAG_USER + $01547300)
NATIVE {BMS_NoDiskIO}  CONST BMS_NODISKIO  = (BMS_DUMMY + 1)      /* Only open if already in memory */
NATIVE {BMS_DoMask}    CONST BMS_DOMASK    = (BMS_DUMMY + 2)      /* Generate a mask, if possible   */
NATIVE {BMS_DoOutline} CONST BMS_DOOUTLINE = (BMS_DUMMY + 3)      /* Load outline mask, if present  */
NATIVE {BMS_DoShade}   CONST BMS_DOSHADE   = (BMS_DUMMY + 4)      /* Load shading maps, if present  */

/* Tags for ObtainBitMapInstanceA() */

NATIVE {BMI_Dummy}         CONST BMI_DUMMY         = (TAG_USER + $01547400)
NATIVE {BMI_Exclusive}     CONST BMI_EXCLUSIVE     = (BMI_DUMMY +  1)  /* Is this bitmap exclusive? */
NATIVE {BMI_DoLevels}      CONST BMI_DOLEVELS      = (BMI_DUMMY +  2)  /* Generate brighter/darker
                                               variants? */
NATIVE {BMI_Offsets}       CONST BMI_OFFSETS       = (BMI_DUMMY +  3)  /* Packed backfill offsets */
NATIVE {BMI_LayerInfo}     CONST BMI_LAYERINFO     = (BMI_DUMMY +  4)  /* Is this a LayerInfo backfill? */
NATIVE {BMI_ReferencePen}  CONST BMI_REFERENCEPEN  = (BMI_DUMMY +  5)  /* Base pen this bitmap is
                                               associated to */
NATIVE {BMI_GradientSpec}  CONST BMI_GRADIENTSPEC  = (BMI_DUMMY +  6)  /* Gradient specification for
                                               backfill */
NATIVE {BMI_CacheGradient} CONST BMI_CACHEGRADIENT = (BMI_DUMMY +  7)  /* Packed W:H to rasterize
                                               gradient */
NATIVE {BMI_GradientAxis}  CONST BMI_GRADIENTAXIS  = (BMI_DUMMY +  8)  /* Tile rasterized gradient on
                                               this axis */
NATIVE {BMI_IgnoreDomain}  CONST BMI_IGNOREDOMAIN  = (BMI_DUMMY +  9)  /* Always use whole RastPort as
                                               domain */
NATIVE {BMI_TileLeft}      CONST BMI_TILELEFT      = (BMI_DUMMY + 10)  /* Left offset for backfill tile
                                               (V51) */
NATIVE {BMI_TileTop}       CONST BMI_TILETOP       = (BMI_DUMMY + 11)  /* Top offset for backfill tile
                                               (V51) */
NATIVE {BMI_TileWidth}     CONST BMI_TILEWIDTH     = (BMI_DUMMY + 12)  /* Width of backfill tile (V51) */
NATIVE {BMI_TileHeight}    CONST BMI_TILEHEIGHT    = (BMI_DUMMY + 13)  /* Height of backfill tile (V51) */

/* Tags for BitMapInstanceControlA() */

NATIVE {BMICTRL_Dummy} CONST BMICTRL_DUMMY = (TAG_USER + $01547600)

NATIVE {BMICTRL_GetBitMap}           CONST BMICTRL_GETBITMAP           = (BMICTRL_DUMMY + 1)
   /* (struct BitMap **) Get actual BitMap address. */

NATIVE {BMICTRL_GetHook}             CONST BMICTRL_GETHOOK             = (BMICTRL_DUMMY + 2)
   /* (struct Hook **) Get backfill hook address. */

NATIVE {BMICTRL_GetOffsets}          CONST BMICTRL_GETOFFSETS          = (BMICTRL_DUMMY + 3)
   /* (ULONG *) Get backfill offsets, packed in a single longword. */

NATIVE {BMICTRL_SetOffsets}          CONST BMICTRL_SETOFFSETS          = (BMICTRL_DUMMY + 4)
   /* (ULONG) Set backfill offsets, packed in a single longword; */
   /* this ONLY applies to instances allocated in exclusive mode. */

NATIVE {BMICTRL_GetWidth}            CONST BMICTRL_GETWIDTH            = (BMICTRL_DUMMY + 5)
   /* (ULONG *) Get width of BitMap. */

NATIVE {BMICTRL_GetHeight}           CONST BMICTRL_GETHEIGHT           = (BMICTRL_DUMMY + 6)
   /* (ULONG *) Get height of BitMap. */

NATIVE {BMICTRL_GetBrightBitMap}     CONST BMICTRL_GETBRIGHTBITMAP     = (BMICTRL_DUMMY + 7)
   /* (struct BitMap **) Get address of bright-level BitMap (if any). */

NATIVE {BMICTRL_GetHalfBrightBitMap} CONST BMICTRL_GETHALFBRIGHTBITMAP = (BMICTRL_DUMMY + 8)
   /* (struct BitMap **) Get address of half-bright-level BitMap (if any). */

NATIVE {BMICTRL_GetHalfDarkBitMap}   CONST BMICTRL_GETHALFDARKBITMAP   = (BMICTRL_DUMMY + 9)
   /* (struct BitMap **) Get address of half-dark-level BitMap (if any). */

NATIVE {BMICTRL_GetDarkBitMap}       CONST BMICTRL_GETDARKBITMAP       = (BMICTRL_DUMMY + 10)
   /* (struct BitMap **) Get address of dark-level BitMap (if any). */

NATIVE {BMICTRL_GetMaskBitMap}       CONST BMICTRL_GETMASKBITMAP       = (BMICTRL_DUMMY + 11)
   /* (struct BitMap **) Get address of single-plane mask bitmap (if any). */

NATIVE {BMICTRL_GetOutlineBitMap}    CONST BMICTRL_GETOUTLINEBITMAP    = (BMICTRL_DUMMY + 12)
   /* (struct BitMap **) Get address of single-plane outline bitmap (if any) */

NATIVE {BMICTRL_GetShineMap}         CONST BMICTRL_GETSHINEMAP         = (BMICTRL_DUMMY + 13)
   /* (UBYTE **) Get address of bright shading alpha map array (if any). */

NATIVE {BMICTRL_GetShadowMap}        CONST BMICTRL_GETSHADOWMAP        = (BMICTRL_DUMMY + 14)
   /* (UBYTE **) Get address of dark shading alpha map array (if any). */

NATIVE {BMICTRL_GetAlphaMap}         CONST BMICTRL_GETALPHAMAP         = (BMICTRL_DUMMY + 15)
   /* (UBYTE **) Get address of alpha blending map array (if any). */

NATIVE {BMICTRL_GetShadeMaskBitMap}  CONST BMICTRL_GETSHADEMASKBITMAP  = (BMICTRL_DUMMY + 16)
   /* (struct BitMap **) Get address of single-plane shade mask bitmap
      (if any). */

NATIVE {BMICTRL_GetScreen}           CONST BMICTRL_GETSCREEN           = (BMICTRL_DUMMY + 17)
   /* (struct Screen **) Get address of the reference screen (may be NULL). */

NATIVE {BMICTRL_GetBitMapSource}     CONST BMICTRL_GETBITMAPSOURCE     = (BMICTRL_DUMMY + 18)
   /* (APTR *) Get address of the BitMapSource this instance was obtained
      from. */

NATIVE {BMICTRL_GetGradientSpec}     CONST BMICTRL_GETGRADIENTSPEC     = (BMICTRL_DUMMY + 19)
   /* (GRADSPEC **) Get address of gradient specification (if any). */

NATIVE {BMICTRL_SetGradientSpec}     CONST BMICTRL_SETGRADIENTSPEC     = (BMICTRL_DUMMY + 20)
   /* (GRADSPEC *) Set gradient specification; this ONLY applies to */
   /* instances allocated in exclusive mode. */

NATIVE {BMICTRL_GetReferencePen}     CONST BMICTRL_GETREFERENCEPEN     = (BMICTRL_DUMMY + 21)
   /* (ULONG *) Get reference pen index. */

NATIVE {BMICTRL_GetOutlineMap}       CONST BMICTRL_GETOUTLINEMAP       = (BMICTRL_DUMMY + 22)
   /* (UBYTE **) Get address of outline alpha map array (if any). */

NATIVE {BMICTRL_GetTileLeft}         CONST BMICTRL_GETTILELEFT         = (BMICTRL_DUMMY + 23)
   /* (ULONG *) Get left offset of backfill tile. (V51) */

NATIVE {BMICTRL_GetTileTop}          CONST BMICTRL_GETTILETOP          = (BMICTRL_DUMMY + 24)
   /* (ULONG *) Get top offset of backfill tile. (V51) */

NATIVE {BMICTRL_GetTileWidth}        CONST BMICTRL_GETTILEWIDTH        = (BMICTRL_DUMMY + 25)
   /* (ULONG *) Get width of backfill tile. (V51) */

NATIVE {BMICTRL_GetTileHeight}       CONST BMICTRL_GETTILEHEIGHT       = (BMICTRL_DUMMY + 26)
   /* (ULONG *) Get height of backfill tile. (V51) */

NATIVE {BMICTRL_GetTileBox}          CONST BMICTRL_GETTILEBOX          = (BMICTRL_DUMMY + 27)
   /* (struct IBox *) Get backfill tile box in one go. (V51) */

NATIVE {BMICTRL_SetTileLeft}         CONST BMICTRL_SETTILELEFT         = (BMICTRL_DUMMY + 28)
   /* (UWORD) Set left offset of backfill tile; this ONLY applies to */
   /* instances allocated in exclusive mode. (V51) */

NATIVE {BMICTRL_SetTileTop}          CONST BMICTRL_SETTILETOP          = (BMICTRL_DUMMY + 29)
   /* (UWORD) Set top offset of backfill tile; this ONLY applies to */
   /* instances allocated in exclusive mode. (V51) */

NATIVE {BMICTRL_SetTileWidth}        CONST BMICTRL_SETTILEWIDTH        = (BMICTRL_DUMMY + 30)
   /* (UWORD) Set width of backfill tile; this ONLY applies to */
   /* instances allocated in exclusive mode. (V51) */

NATIVE {BMICTRL_SetTileHeight}       CONST BMICTRL_SETTILEHEIGHT       = (BMICTRL_DUMMY + 31)
   /* (UWORD) Set height of backfill tile; this ONLY applies to */
   /* instances allocated in exclusive mode. (V51) */

NATIVE {BMICTRL_SetReferencePen}     CONST BMICTRL_SETREFERENCEPEN     = (BMICTRL_DUMMY + 32)
   /* (ULONG) Set reference pen index; this ONLY applies to */
   /* instances allocated in exclusive mode. (V51) */

/* Useful type definitions */
NATIVE {BitMapSource} OBJECT
NATIVE {BitMapInstance} OBJECT
