    IFND    EGS_EGSGFX_I
EGS_EGSGFX_I     SET     1
*\
*  $
*  $ FILE     : egsgfx.i
*  $ VERSION  : 1
*  $ REVISION : 3
*  $ DATE     : 02-Feb-93 22:17
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
    IFND    EXEC_LISTS_I
    INCLUDE "exec/lists.i"
    ENDC
    IFND    EXEC_SEMAPHORES_I
    INCLUDE "exec/semaphores.i"
    ENDC
    IFND    GRAPHICS_TEXT_I
    INCLUDE "graphics/text.i"
    ENDC
    IFND    EGS_EGS_I
    INCLUDE "egs.i"
    ENDC
    IFND    EGS_EGSBLIT_I
    INCLUDE "egsblit.i"
    ENDC
    IFND    EGS_EGSLAYERS_I
    INCLUDE "egslayers.i"
    ENDC

*
*  This library uses "egslayers.library" and "egsblit.library".  It
*  standardizes the access to layers and BitMaps and makes their usage easier.
*
*  The functions resemble in a great part those of the "graphics.library".
*  The basic structure is the RastPort which contains a layer, a BitMap
*  and/or a screen.  All conventions are abided by (MouseOn..MouseOff,
*  LockLayer..UnlockLayer).  You can clip with a layer and/or a region, just
*  as you like.
*

*
*  DrawModes
*
*  States that define the color distribution for drawing operations.
*
*    DRAW_APEN  : You draw with the APen on transparent background.
*    DRAW_ABPEN : You draw with the APen in front and the BPen for the
*                  background.
*    INVERT     : You draw in inverting mode.
*

* Enumeration type DrawMode has 8 bits !
EG_DRAW_APEN                EQU     0
EG_DRAW_ABPEN               EQU     1
EG_INVERT                   EQU     2

*
*  EFont, EFontPtr
*
*  Extension of the Amiga TextFont structure with additional information.
*  Created by "OpenFont" and destroyed by "CloseFont".
*
 STRUCTURE  EGEFont,0
    APTR    egfo_Font
    STRUCT  egfo_EMap,ebm_SIZEOF
    LABEL   egfo_SIZEOF

*
*  PolyEntry, Polygon, PolyPtr
*
*  Structures for polygons.
*
 STRUCTURE  EGPolyEntry,0
    WORD    egpe_X
    WORD    egpe_Y
    LABEL   egpe_SIZEOF

*
*  AreaInfo, AreaInfoPtr
*
*  Structure for Area commands, initialized by "InitArea".
*
 STRUCTURE  EGAreaInfo,0
    APTR    egai_VctrTbl
    APTR    egai_VctrPtr
    APTR    egai_VctrLast
    WORD    egai_Count
    WORD    egai_MaxCount
    LABEL   egai_SIZEOF

*
*  RastPort, RastPortPtr...
*
*  Basic EGSGfx drawing structure:
*
*   .BitMap  : BitMap drawn into.
*   .Layer   : Layer drawn into.
*   .Screen  : Screen drawn into.
*
*   .cp_x,
*      cp_y  : Current drawing cursor, can be changed by "Move" or direct
*              access.
*   .am_x,
*      .am_y : Current area cursor, must be changed by "AreaMove".
*
*   .APen    : APen i.e. front pen.
*   .BPen    : BPen i.e. pen for background.
*
*   .Mode    : Drawing mode (see above).
*   .Font    : Current text font, can be changed by "SetFont" or direct access.
*
*   .Region  : ClipRegion, must be changed by "InstallClipRegion" or
*              "RemoveClipRegion".
*   .FClip,
*   .BClip   : PRIVATE !
*
*   .CurvStep: Bezier curves are split up into small lines.  This value
*              specifies the maximum length of such line segments.
*
*   .TmpRas  : Pointer to a one-planed BitMap that is to be used for Area
*              commands.  If the BitMap is missing each Area operation
*              allocates its own BitMap and frees it after processing.
*   .AreaInfo: AreaInfo structure.
*
*  For reasons of compatibility no variables of the RastPort type may be
*  used or created.  RastPorts can only be created by "CreateRastPort" and
*  destroyed by "DeleteRastPort".
*
 STRUCTURE  EGRastPort,0
    APTR    egrp_BitMap
    APTR    egrp_Layer
    APTR    egrp_Screen
    WORD    egrp_Depth
    WORD    egrp_cp_x
    WORD    egrp_cp_y
    WORD    egrp_am_x
    WORD    egrp_am_y            ; Commodore
    UWORD   egrp_Pad_1
    ULONG   egrp_APen
    ULONG   egrp_BPen
    UBYTE   egrp_DrawMode
    UBYTE   egrp_Pad_2
    UBYTE   egrp_Pad_3
    UBYTE   egrp_Pad_4
    APTR    egrp_Font
    APTR    egrp_Region
    APTR    egrp_FClip
    APTR    egrp_BClip
    WORD    egrp_CurvStep
    UWORD   egrp_Pad_5
    APTR    egrp_TmpRas
    APTR    egrp_AreaInfo
    UBYTE   egrp_AlgoStyle       ; Font style set has 8 bits
    UBYTE   egrp_Pad_6
    UBYTE   egrp_Pad_7
    UBYTE   egrp_Pad_8
    ULONG   egrp_Mask
    LONG    egrp_ClipKey
    LONG    egrp_Flags           ; No flags defined yet
    LABEL   egrp_SIZEOF

   ENDC    ; EGS_EGSGFX_I

