/*
**  $VER: space.h 44.1 (19.10.1999)
**  Includes Release 44.1
**
**  Definitions for the space.gadget BOOPSI class
**
**  (C) Copyright 1987-1999 Amiga, Inc.
**      All Rights Reserved
*/
/*****************************************************************************/
//MODULE 'reaction/reaction','intuition/gadgetclass'
/*****************************************************************************/
/* Additional attributes defined by the space.gadget class
 */
#define SPACE_Dummy       (REACTION_Dummy + $9000)
#define SPACE_MinHeight     (SPACE_Dummy+1)
/* (WORD) Height of space gadget
     * (OM_NEW,OM_SET,OM_UPDATE,OM_GET) */
#define SPACE_MinWidth    (SPACE_Dummy+2)
/* (WORD) Width of space gadget
     * (OM_NEW,OM_SET,OM_UPDATE,OM_GET) */
#define SPACE_MouseX    (SPACE_Dummy+3)
/* (WORD) X Position of Mouse within space gadget
     * (OM_NOTIFY) */
#define SPACE_MouseY    (SPACE_Dummy+4)
/* (WORD) Y Position of Mouse within space gadget
     * (OM_NOTIFY) */
#define SPACE_Transparent   (SPACE_Dummy+5)
/* (BOOL) Will not EraseRect() background before redraw if true.
     * (OM_NEW,OM_SET,OM_UPDATE) */
#define SPACE_AreaBox     (SPACE_Dummy+6)
/* (struct IBox *) Inner area IBox application rendering bounds
     * (OM_GET) */
#define SPACE_RenderHook  (SPACE_Dummy+7)
/* (struct Hook *) render hook is called when the gadget refreshes.
     * (OM_NEW,OM_SET,OM_UPDATE) */
#define SPACE_BevelStyle  (SPACE_Dummy+8)
/* (WORD) Defaults to BVS_NONE (no bevel - see images/bevel.h)
     * (OM_NEW,OM_SET,OM_UPDATE) */
/*****************************************************************************/
