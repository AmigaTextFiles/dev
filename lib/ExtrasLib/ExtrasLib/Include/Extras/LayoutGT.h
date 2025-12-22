#ifndef EXTRAS_LAYOUTGT_H
#define EXTRAS_LAYOUTGT_H

#ifndef EXEC_TYPES_H
#include "exec/types.h"
#endif /* EXEC_TYPES_H */

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif /* UTILITY_TAGITEM_H */

#ifndef	GRAPHICS_GFX_H
#include <graphics/gfx.h>
#endif /* GRAPHICS_GFX_H */

#define LG_Dummy    (TAG_USER)

#define LG_DebugMode      (LG_Dummy + 0) /* Debug Mode */
#define LG_CreateGadget   (LG_Dummy + 1) /* (struct Gadget **) or NULL  */
#define LG_NewGadget      (LG_Dummy + 2) /* (struct NewGadget *) */

/* 
  Note: High Word of dimensions are used for relational flags.
  See LG_REL_ macros.
*/   

#define LG_LeftEdge       (LG_Dummy + 3)
#define LG_XPos           LG_LeftEdge    /* Just an alias */
#define LG_TopEdge        (LG_Dummy + 4)
#define LG_YPos           LG_TopEdge
#define LG_Width          (LG_Dummy + 5)
#define LG_Height         (LG_Dummy + 6)

#define LG_GadgetText     (LG_Dummy + 7)
#define LG_TextAttr       (LG_Dummy + 8)
#define LG_GadgetID       (LG_Dummy + 9)
#define LG_Flags          (LG_Dummy + 10)
#define LG_VisualInfo     (LG_Dummy + 11)
#define LG_UserData       (LG_Dummy + 12)
#define LG_GadgetKind     (LG_Dummy + 13)
#define LG_GadgetTags     (LG_Dummy + 14)   /* The next ti_Data tags are GTXX_ tags */
#define LG_GadgetTagList  (LG_Dummy + 15)
#define LG_OffsetX        (LG_Dummy + 16)   /* global offset from left of window - note that this will be added to LG_UseScreenOffsets & LG_UseWindowOffsets*/
#define LG_OffsetY        (LG_Dummy + 17)   /* global offset from top of window */
#define LG_LabelFlags     (LG_Dummy + 18)   /* see LGLF_ */
#define LG_ScaleX         (LG_Dummy + 19)
#define LG_ScaleY         (LG_Dummy + 20)   /* scale * 65535 */
#define LG_Justification  (LG_Dummy + 21)   /* see LG_JUST_? */
#define LG_UseScreenOffsets (LG_Dummy + 22) /* (struct Screen *) or NULL - sets global offsets based on Window border dimensions specified in the Screen structure */
#define LG_UseWindowOffsets (LG_Dummy + 23) /* (struct Window *) or NULL - sets global offsets based on Window border dimensions */
#define LG_EraseRemoved     (LG_Dummy + 24) /* (BOOL) erase gadges when they're removed using LG_RemoveGadgets (defualt TRUE ) */

#define LG_KeyClass         (LG_Dummy + 25) /* Not used */
#define LG_KeyString        (LG_Dummy + 26) /* A string of characters that "activate" that gadget, if not specified, LG_CreateGadget() will scan the gadget label for the appropriate string */
#define LG_ErrorCode        (LG_Dummy + 27) /* Not used */
/* Bounding area for gadgets */

#define LG_Bounds           (LG_Dummy + 28) /* (struct IBox *) set offsets of area for gadgets */
/* individual tags for LG_Bounds */
#define LG_BoundsLeft        (LG_OffsetX)   // Aliases
#define LG_BoundsTop         (LG_OffsetY)
#define LG_BoundsWidth       (LG_Dummy + 29)
#define LG_BoundsHeight      (LG_Dummy + 30)

#define LG_RelHorizGap       (LG_Dummy + 31)  /* Gap between certain relative operations */
#define LG_RelVertGap        (LG_Dummy + 32)

#define LG_HorizCells        (LG_Dummy + 33)  /* 0 - 65535 */
#define LG_VertCells         (LG_Dummy + 34)  /* 0 - 65535 */

#define LG_SkipGadgets       (LG_Dummy + 35)  /* Skip the next ti_Data LG_CreateGadgets and all Tags in between.  */

/* Not implemented */
#define LG_SuperBounds       (LG_Dummy + 36) /* ??? (struct IBox *) to use relative dimensions on Bounds ??? */

#define LG_GetMinHeight      (LG_Dummy + 37) /* (LONG *) Minimum gadget size, should be initialized to 0's */
#define LG_GetMinWidth       (LG_Dummy + 38) /* */
#define LG_AddMinHeight      (LG_Dummy + 39) /* (LONG *) Add Minimum gadget size */
#define LG_AddMinWidth       (LG_Dummy + 40) /* */

#define LG_GroupGadgets
#define LG_GroupName
#define LG_GroupFlags

/* LG_LabelFlags */
#define LGLF_FITLABEL  (1<<0)

/* LG_Justufication flags */
#define LG_JUST_HORIZ_MASK  0xf
#define LG_JUST_LEFT        0x0
#define LG_JUST_HCENTER     0x1
#define LG_JUST_RIGHT       0x2 

#define LG_JUST_VERT_MASK   0xf0
#define LG_JUST_TOP         0x00
#define LG_JUST_VCENTER     0x10
#define LG_JUST_BOTTOM      0x20

#define LG_JUST_WITHLABEL   0x100

/* Internal use */
struct LG_Rel_Data
{
  UBYTE RelGrp,Code;
  union
  {
    WORD WData;
    struct 
    {
      BYTE Byte1,
           Byte2;
    } _TwoBytes;
  } _OneWord;
};

/* Relational Macros! */
#define LG_REL_W(RelType,Code,WordData)         (ULONG)( (RelType & 0xff)<<24 | (Code & 0xff)<<16 | (WordData & 0xffff) )
#define LG_REL_BB(RelType,Code,Byte1,Byte2)     (ULONG)( (RelType & 0xff)<<24 | (Code & 0xff)<<16 | (Byte1 & 0xff )<<8 | (Byte2 & 0xff) )

/* Relative to current LG_Bounds */
#define LG_REL_RIGHT(x)       LG_REL_W( 1, 0, x) // LG_LeftEdge
#define LG_REL_WIDTH(x)       LG_REL_W( 1, 1, x) // LG_Width
#define LG_REL_BOTTOM(y)      LG_REL_W( 1, 2, y) // LG_TopEdge
#define LG_REL_HEIGHT(y)      LG_REL_W( 1, 3, y) // LG_Height

/* cell spacing/dimensions.
   These work in conjunction with the LG_Columns & LG_Rows tagitems, 
   relative to current bounds.  LG_RelGapX & Y are considered.
*/
#define LG_REL_CELL_LEFTEDGE(column)    LG_REL_W( 1, 4, column)  // LG_LeftEdge Horizontal spacing
#define LG_REL_CELL_TOPEDGE(row)        LG_REL_W( 1, 5, row)     // LG_TopEdge  Vertical spacing    
#define LG_REL_CELL_WIDTH(x)            LG_REL_W( 1, 6, x)       // LG_Width    the width of x columns    
#define LG_REL_CELL_HEIGHT(y)           LG_REL_W( 1, 7, y)       // LG_Height   the height of x rows 

/* relative to another gadget, (also considers label)
   restrictions:
      The gadget, GADGETID, must appear above the gadget using these 
        LG_REL_ flags in the taglist.
      GAP < -128 - 127 > 
*/
      
#define LG_REL_LEFTOF(GADGETID, GAP)    LG_REL( 2, GAP  , GADGETID) // LG_LeftEdge LG_Width
#define LG_REL_TOPOF(GADGETID, GAP)     LG_REL( 3, GAP  , GADGETID) // LG_TopEdge  LG_Height
#define LG_REL_WIDTHOF(GADGETID, GAP)   LG_REL( 4, GAP  , GADGETID) // LG_Width
#define LG_REL_HEIGHTOF(GADGETID, GAP)  LG_REL( 5, GAP  , GADGETID) // LG_Height
#define LG_REL_RIGHTOF(GADGETID, GAP)   LG_REL( 6, GAP  , GADGETID) // LG_LeftEdge LG_Width
#define LG_REL_BOTTOMOF(GADGETID, GAP)  LG_REL( 7, GAP  , GADGETID) // LG_TopEdge  LG_Height


struct LG_GadgetIndex
{
  ULONG  gi_ID;
  struct Gadget *gi_Gadget;
  struct Rectangle gi_Rect; /* refresh area */
  ULONG  gi_Disabled,
         gi_GadKind,
         gi_KeyTagID,   
         gi_KeyTagValue,
         gi_KeyClass;
  STRPTR gi_KeyString;
};
 
struct LG_Control
{
  struct Gadget *lgc_GadgetList;
  ULONG  lgc_GadgetCount;
  struct LG_GadgetIndex *lgc_GadgetIndex;
  ULONG  lgc_IndexCount;
  struct Window *lgc_Window;
  ULONG  lgc_Flags;
  WORD   lgc_Left,lgc_Top,
         lgc_Right,lgc_Bottom;
  struct LG_Control *lgc_Next;
};

struct lg_DimInfo
{
  WORD CellsHoriz , CellsVert,
       GapHoriz   , GapVert;
};

#define LGCF_ERASEREMOVED (1<<0)


#define LG_PagedGroupBegin
#define LG_Page
#define LG_PagedGroupEnd


#endif

