   IFND    EGS_EGSBLIT_I
EGS_EGSBLIT_I           SET     1
*\
*
*  $
*  $ FILE     : egsblit.i
*  $ VERSION  : 1
*  $ REVISION : 2
*  $ DATE     : 31-Jan-93 21:40
*  $
*  $ Author   : mvk
*  $
*
*
* (c) Copyright 1990/93 VIONA Development
*     All Rights Reserved
*
*\
    IFND    EXEC_TYPES_I
    INCLUDE "exec/types.i"
    ENDC
    IFND    EXEC_PORTS_I
    INCLUDE "exec/ports.i"
    ENDC
    IFND    EGS_EGS_I
    INCLUDE "egs.i"
    ENDC

*
*  This library offers basic drawing functions.  These are especially func-
*  tions that might later be implemented by a blitter in some future version
*  of a graphics card.
*
*  Therefore these functions should be used whenever possible.
*
*  Moreover, the library forms the base for other libraries such as EGSLayers,
*  EGSGfx and EGSIntui.  If the library is implemented for any other graphics
*  card, the other libraries will run without change.
*
*  Programs that abide by this convention face a safe future.
*
*  In favour of speed, the library neglects heavier management.  Most func-
*  tions are contained in one version with and one version without clipping.
*  That clipping is rather rudimentary since it supports only one rectangle.
*

*
*  ClipRect, ClipRectPtr
*
*  Definition of a clipping rectangle.  The values are inclusive, i.e. they
*  are located inside the rectangle.
*  The "Next" field is ignored by EGSBlit but used by EGSLayers.
*
 STRUCTURE  EBClipRect,0
    APTR    ebcr_Next
    WORD    ebcr_Left
    WORD    ebcr_Top
    WORD    ebcr_Right
    WORD    ebcr_Bottom
    LABEL   ebcr_SIZEOF

*
*  ColorTable, Image
*
*  Many times you use predefined images for icons.  As video organization is
*  different in different video modes, images are stored in a general, bit-
*  plane oriented way and can be inflated on need to different bit depths.
*
*  To achieve this an array must be specified containing the colour values
*  that are wanted for the image.
*

* Note: differing from the Cluster .def file, ColorTable is defined as the
*   type contained in the color table instead of the array itself.  Thus
*   ColorTablePtr is declared differently, either.
*
 STRUCTURE  EBImage,0
    WORD    ebim_Width
    WORD    ebim_Height
    WORD    ebim_Depth
    WORD    ebim_Pad_1
    STRUCT  ebim_Planes,4*8        * APTR Planes[8]
    LABEL   ebim_SIZEOF

*
*  ColorDes, ColorDesPtr
*
*  Descriptor for text output.
*
*  ColorDes
*   .Front       : Front pen colour.
*   .Back        : Back pen colour if transparent = FALSE.
*   .Transparent : if TRUE the background shines through "holes".
*
 STRUCTURE  EBColorDes,0
    ULONG   ebcd_Front
    ULONG   ebcd_Back
    UBYTE   ebcd_Transparent
    UBYTE   ebcd_Pad_1
    UBYTE   ebcd_Pad_2
    UBYTE   ebcd_Pad_3
    LABEL   ebcd_SIZEOF

*
*  ImageDesPtr, ImageDes
*
*  Object description for "FillMask".
*
*  ImageDes
*    .Colors   : Filling colours.
*    .Left,
*    .Top,
*    .Width,
*    .Height   : Borders of the object.
*
     STRUCTURE  EBImageDes,0
    STRUCT  ebid_Colors,ebcd_SIZEOF
    WORD    ebid_Left
    WORD    ebid_Top
    WORD    ebid_Width
    WORD    ebid_Height
    LABEL   ebid_SIZEOF

*
*  Polygon, PolygonPtr
*
*  Description of a polygon for PolygonFill.  The array size is not limited.
*
 STRUCTURE  EBPolygon,0
    WORD    ebpo_X
    WORD    ebpo_Y
    LABEL   ebpo_SIZEOF

    ENDC  ; EGS_EGSBLIT_I

