#ifndef GADGETS_DRAG_H
#define GADGETS_DRAG_H TRUE

/*
**  $VER: drag.h 0.12 (10.7.1997)
**
**  Definitions for BOOPSI drag gadget objects
**
**  (c) Copyright 1996/97 Joerg Kollmann
**  All Rights Reserved
**
*/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef INTUITION_INTUITION_H
#include <intuition/intuition.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#ifndef IFF_IFFPARSE_H
#include <libraries/iffparse.h>
#endif

/*********************************************************************/

struct DragInfo
{
  WORD            type;       /* DGT_xxx */
  Object          *object;    /* target object */
  struct {
    WORD          X;          /* rel. to RastPort of bob */
    WORD          Y;
  } mouse;
  struct {
    WORD          X;          /* mouse offset rel.to gadget */
    WORD          Y;
  } offset;
  UWORD           id;         /* gadget->GadgetID of dropped gadget */
  APTR            userdata;   /* gadget->UserData of dropped gadget */
  struct DragInfo *next;      /* DragInfo of next selected (dropped) gadget */
};

/* type of DragInfo object */
#define DGT_NoObject 0
#define DGT_Gadget   1
#define DGT_Window   2

struct DropMessage {
  struct Message dm_Message;
  UWORD dm_Type;
  ULONG dm_UserData;
  ULONG dm_ID;
  struct DragInfo *dm_DragInfo;
};

/* type of drop message */
#define DMTYPE_OWN          0
#define DMTYPE_DROPWINDOW   7

/*********************************************************************/

#define DGA_Dummy   (TAG_USER+0x05000000)

#define DGA_ExtSelect   (DGA_Dummy+1)  /* BOOL, default FALSE, Applicability: (I)
        * with this attribute set to TRUE, the gadget image stays selected
        * after dropping. To deselect it set (GA_Selected,FALSE) */

#define DGA_Context     (DGA_Dummy+2)  /* Context of object, Applicability: (I).
        * result of CreateDContext(screen). Replaces DGA_Screen. */
#define DGA_Screen      (DGA_Dummy+3)  /* Screen/Window of drag object, mutually */
#define DGA_Window      (DGA_Dummy+4)  /* exclusive. Applicability: (I)
        * DGA_Screen should be replaced by DGA_Context. It may only be
        * used with non-public screens. */

#define DGA_DragInfo    (DGA_Dummy+5)  /* (struct DragInfo*), Applicability: (G)
        * gadget->SpecialInfo also points to this struct. */

#define DGA_Frame       (DGA_Dummy+6)  /* Object (Image), Applicability: (I) */
                                       /* not implemented */
#define DGA_DragImage   (DGA_Dummy+7)  /* Image for Bob, Applicability: (IS) */

#define DGA_DragAnim    (DGA_Dummy+8)  /* NULL-terminated array of Image* ,
                                        * Applicability: (IS) */

#define DGA_AnimSpeed   (DGA_Dummy+12) /* Applicability: (IS) */

#define DGA_NodropImage (DGA_Dummy+9)  /* not implemented */

#define DGA_DragGroup   (DGA_Dummy+10) /* DragGroup, Applicability: (IS)
        * makes this gadget part of a group. NULL removes it from the group.
        * If the group gadgets are DGA_ExtSelect, they deselect each other,
        * or if selected with SHIFT pressed, can be dragged as a group. All
        * group members should be in the same window/domain. */

#define DGA_DropActHook (DGA_Dummy+11) /* (struct Hook*), Applicability: (I)
        * if a drag gadget is dropped on this gadget, the hook is called with
        * Object=this gadget and Message=DragInfo of the dropped gadget */

/*********************************************************************/

#define OM_DROPACTION   MAKE_ID('O','M','D','A')

struct opDropAction
{
  ULONG              MethodID;
  struct GadgetInfo *opda_GInfo;
  struct DragInfo   *opda_DragInfo;
};

#endif /* GADGETS_DRAG_H */
