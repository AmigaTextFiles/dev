	IFND GRAPHICS_PICTURES_I
GRAPHICS_PICTURES_I  SET  1

**
**  $VER: pictures.i
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
**

	IFND    DPKERNEL_I
	include 'dpkernel/dpkernel.i'
	ENDC

****************************************************************************
* Picture object.

VER_PICTURE  = 2
TAGS_PICTURE = ((ID_SPCTAGS<<16)|ID_PICTURE)

   STRUCTURE	PIC,HEAD_SIZEOF ;Standard header.
	APTR	PIC_Bitmap      ;Bitmap details.
	LONG	PIC_Options     ;Special flags.
	APTR	PIC_Source      ;Where this picture comes from.
	WORD	PIC_ScrMode     ;Intended screen mode for picture.
	WORD	PIC_ScrHeight   ;Screen Height (pixels)
	WORD	PIC_ScrWidth    ;Screen Width (pixels)

PCA_BitmapTags = (TSTEPIN|PIC_Bitmap)
PCA_Options    = (TLONG|PIC_Options)
PCA_Source     = (TAPTR|PIC_Source)
PCA_ScrMode    = (TWORD|PIC_ScrMode)
PCA_ScrHeight  = (TWORD|PIC_ScrHeight)
PCA_ScrWidth   = (TWORD|PIC_ScrWidth)

****************************************************************************
* Picture, Anim, CardSet etc special options.

IMG_RESIZEX   = $00000001     ;Allow resize on X axis.
IMG_NOCOMPARE = $00000002     ;Do not compare the palettes.
IMG_REMAP     = $00000004     ;Allow remapping.
IMG_RESIZEY   = $00000008     ;Allow resize on Y axis.
IMG_RESIZE    = IMG_RESIZEX|IMG_RESIZEY  ;Allow resize on both axis?

	ENDC	;GRAPHICS_PICTURES_I
