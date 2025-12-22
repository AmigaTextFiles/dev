#ifndef EXTRAS_GTOBJECT_H
#define EXTRAS_GTOBJECT_H

#ifndef EXEC_TYPES_H
#include "exec/types.h"
#endif /* EXEC_TYPES_H */

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif /* UTILITY_TAGITEM_H */

#ifndef	GRAPHICS_GFX_H
#include <graphics/gfx.h>
#endif /* GRAPHICS_GFX_H */

#define GTA_Dummy    (TAG_USER)

#define GTA_DebugMode      (GTA_Dummy + 0) /* Debug Mode */
#define GTA_CreateGadget   (GTA_Dummy + 1) /* (struct Gadget **) or NULL  */
#define GTA_NewGadget      (GTA_Dummy + 2) /* (struct NewGadget *) */

/* 
  Note: High Word of dimensions are used for relational flags.
  See GTA_REL_ macros.
*/   

#define GTA_LeftEdge       (GTA_Dummy + 3)
#define GTA_XPos           GTA_LeftEdge    /* Just an alias */
#define GTA_TopEdge        (GTA_Dummy + 4)
#define GTA_YPos           GTA_TopEdge
#define GTA_Width          (GTA_Dummy + 5)
#define GTA_Height         (GTA_Dummy + 6)

#define GTA_GadgetText     (GTA_Dummy + 7)
#define GTA_TextAttr       (GTA_Dummy + 8)
#define GTA_GadgetID       (GTA_Dummy + 9)
#define GTA_Flags          (GTA_Dummy + 10)
#define GTA_VisualInfo     (GTA_Dummy + 11)
#define GTA_UserData       (GTA_Dummy + 12)
#define GTA_GadgetKind     (GTA_Dummy + 13)
#define GTA_GadgetTags     (GTA_Dummy + 14)   /* The next ti_Data tags are GTXX_ tags */
#define GTA_GadgetTagList  (GTA_Dummy + 15)
#define GTA_OffsetX        (GTA_Dummy + 16)   /* global offset from left of window - note that this will be added to GTA_UseScreenOffsets & GTA_UseWindowOffsets*/
#define GTA_OffsetY        (GTA_Dummy + 17)   /* global offset from top of window */
#define GTA_LabelFlags     (GTA_Dummy + 18)   /* see LGLF_ */
#define GTA_ScaleX         (GTA_Dummy + 19)
#define GTA_ScaleY         (GTA_Dummy + 20)   /* scale * 65535 */
#define GTA_Justification  (GTA_Dummy + 21)   /* see GTA_JUST_? */
#define GTA_UseScreenOffsets (GTA_Dummy + 22) /* (struct Screen *) or NULL - sets global offsets based on Window border dimensions specified in the Screen structure */
#define GTA_UseWindowOffsets (GTA_Dummy + 23) /* (struct Window *) or NULL - sets global offsets based on Window border dimensions */
#define GTA_EraseRemoved     (GTA_Dummy + 24) /* (BOOL) erase gadges when they're removed using GTA_RemoveGadgets (defualt TRUE ) */

#define GTA_KeyClass         (GTA_Dummy + 25) /* Not used */
#define GTA_KeyString        (GTA_Dummy + 26) /* A string of characters that "activate" that gadget, if not specified, GTA_CreateGadget() will scan the gadget label for the appropriate string */
#define GTA_ErrorCode        (GTA_Dummy + 27) /* Not used */
/* Bounding area for gadgets */

#define GTA_Bounds           (GTA_Dummy + 28) /* (struct IBox *) set offsets of area for gadgets */
/* individual tags for GTA_Bounds */
#define GTA_BoundsLeft        (GTA_OffsetX)   // Aliases
#define GTA_BoundsTop         (GTA_OffsetY)
#define GTA_BoundsWidth       (GTA_Dummy + 29)
#define GTA_BoundsHeight      (GTA_Dummy + 30)

#define GTA_RelHorizGap       (GTA_Dummy + 31)  /* Gap between certain relative operations */
#define GTA_RelVertGap        (GTA_Dummy + 32)

#define GTA_HorizCells        (GTA_Dummy + 33)  /* 0 - 65535 */
#define GTA_VertCells         (GTA_Dummy + 34)  /* 0 - 65535 */

#define GTA_SkipGadgets       (GTA_Dummy + 35)  /* Skip the next ti_Data GTA_CreateGadgets and all Tags in between.  */

/* Not implemented */
#define GTA_SuperBounds       (GTA_Dummy + 36) /* ??? (struct IBox *) to use relative dimensions on Bounds ??? */

#define GTA_GroupGadgets
#define GTA_GroupName
#define GTA_GroupFlags

/* GTA_LabelFlags */
#define LGLF_FITLABEL  (1<<0)

/* GTA_Justufication flags */
#define GTA_JUST_HORIZ_MASK  0xf
#define GTA_JUST_LEFT        0x0
#define GTA_JUST_HCENTER     0x1
#define GTA_JUST_RIGHT       0x2 

#define GTA_JUST_VERT_MASK   0xf0
#define GTA_JUST_TOP         0x00
#define GTA_JUST_VCENTER     0x10
#define GTA_JUST_BOTTOM      0x20

#define GTA_JUST_WITHLABEL   0x100

/* Internal use */
struct GTA_Rel_Data
{
  UBYTE RelGrp,Code;
  union
  {
    WORD WData;
    struct 
    {
      BYTE Byte1,
           Byte2;
    };
  };
};

/* Relational Macros! */
#define GTA_REL_W(RelType,Code,WordData)         (ULONG)( (RelType & 0xff)<<24 | (Code & 0xff)<<16 | (WordData & 0xffff) )
#define GTA_REL_BB(RelType,Code,Byte1,Byte2)     (ULONG)( (RelType & 0xff)<<24 | (Code & 0xff)<<16 | (Byte1 & 0xff )<<8 | (Byte2 & 0xff) )

/* Relative to current GTA_Bounds */
#define GTA_REL_RIGHT(x)       GTA_REL_W( 1, 0, x) // GTA_LeftEdge
#define GTA_REL_WIDTH(x)       GTA_REL_W( 1, 1, x) // GTA_Width
#define GTA_REL_BOTTOM(y)      GTA_REL_W( 1, 2, y) // GTA_TopEdge
#define GTA_REL_HEIGHT(y)      GTA_REL_W( 1, 3, y) // GTA_Height

/* cell spacing/dimensions.
   These work in conjunction with the GTA_Columns & GTA_Rows tagitems, 
   relative to current bounds.  GTA_RelGapX & Y are considered.
*/
#define GTA_REL_CELL_LEFTEDGE(column)    GTA_REL_W( 1, 4, column)  // GTA_LeftEdge Horizontal spacing
#define GTA_REL_CELL_TOPEDGE(row)        GTA_REL_W( 1, 5, row)     // GTA_TopEdge  Vertical spacing    
#define GTA_REL_CELL_WIDTH(x)            GTA_REL_W( 1, 6, x)       // GTA_Width    the width of x columns    
#define GTA_REL_CELL_HEIGHT(y)           GTA_REL_W( 1, 7, y)       // GTA_Height   the height of x rows 

/* relative to another gadget, (also considers label)
   restrictions:
      The gadget, GADGETID, must appear above the gadget using these 
        GTA_REL_ flags in the taglist.
      GAP < -128 - 127 > 
*/
      
#define GTA_REL_LEFTOF(GADGETID, GAP)    GTA_REL( 2, GAP  , GADGETID) // GTA_LeftEdge GTA_Width
#define GTA_REL_TOPOF(GADGETID, GAP)     GTA_REL( 3, GAP  , GADGETID) // GTA_TopEdge  GTA_Height
#define GTA_REL_WIDTHOF(GADGETID, GAP)   GTA_REL( 4, GAP  , GADGETID) // GTA_Width
#define GTA_REL_HEIGHTOF(GADGETID, GAP)  GTA_REL( 5, GAP  , GADGETID) // GTA_Height
#define GTA_REL_RIGHTOF(GADGETID, GAP)   GTA_REL( 6, GAP  , GADGETID) // GTA_LeftEdge GTA_Width
#define GTA_REL_BOTTOMOF(GADGETID, GAP)  GTA_REL( 7, GAP  , GADGETID) // GTA_TopEdge  GTA_Height


struct GTA_GadgetIndex
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
 
struct GTA_Control
{
  struct Gadget *lgc_GadgetList;
  ULONG  lgc_GadgetCount;
  struct GTA_GadgetIndex *lgc_GadgetIndex;
  ULONG  lgc_IndexCount;
  struct Window *lgc_Window;
  ULONG  lgc_Flags;
  WORD   lgc_Left,lgc_Top,
         lgc_Right,lgc_Bottom;
  struct GTA_Control *lgc_Next;
};

struct GTA_DimInfo
{
  WORD CellsHoriz , CellsVert,
       GapHoriz   , GapVert;
};

#define LGCF_ERASEREMOVED (1<<0)


#define GTA_PagedGroupBegin
#define GTA_Page
#define GTA_PagedGroupEnd


#define GTM_CREATEGADGET
#define GTM_GETSIZE 

struct gtpCreateGadget
{
  ULONG MethodID;
  struct NewGadget *gtpcg_NewGadget;
  
};


struct gtpSize
{
  ULONG MethodID;
  struct IBox gtps_Gadget[3];
  struct IBox gtps_Label;
  ULONG  gtps_LabelFlags;
};

struct gtpGetSize
{
  ULONG MethodID;
  struct IBox gtpgs_Gadget[3];
  ULONG  gtpgs_Flags;
};

#define GSF_NOLABEL


#endif /* EXTRAS_GTOBJECT_H */
