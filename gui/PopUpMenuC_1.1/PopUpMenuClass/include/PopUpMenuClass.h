#ifndef PUMG_CLASS_H
#define PUMG_CLASS_H 1
/** ** *** MakeRev Header *** **
**
**  ** PopupMenuClass - BOOPSI Popup menu. **
**
**  Copyright © 1993,1994 Markus Aalto
**
**  Creation date: 09-Dec-93
**
**  ------------------------------------------------------------------
**  $Filename: PopUpMenuClass.h $
**  $Revision: 1.1 $
**  $Date: 29-Dec-93 $
**
**  $Author: Markus_Aalto $
**  $Comment: Freely Distributable. $
**
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/lists.h>
#include <exec/libraries.h>

#include <graphics/gfxmacros.h>
#include <graphics/regions.h>

#include <intuition/intuition.h>
#include <intuition/classusr.h>
#include <intuition/gadgetclass.h>
#include <intuition/icclass.h>
#include <intuition/imageclass.h>

#include <utility/tagitem.h>

#include <stdlib.h>

#include <proto/all.h>

extern  Class *CreatePopUpMenuClass( void );
extern  BOOL DisposePopUpMenuClass( Class *cl );

#define PUMG_TAGBASE            (TAG_USER + 700)

/*  Text in Exec List. (ISG--) */
#define PUMG_Labels             (PUMG_TAGBASE)

/*  Active item in Labels list. (ISGNU) */
#define PUMG_Active             (PUMG_TAGBASE+1)

/*  TextFont we use for Texts. (ISG--) */
#define PUMG_TextFont           (PUMG_TAGBASE+2)

/*  V39 users can use this to use NewLook menu colors. (I-G--) */
#define PUMG_NewLook            (PUMG_TAGBASE+3)


/* Predefined Minimum dimensions for safe operation. */
#define PUMG_MinWidth           28
#define PUMG_MinHeight          8

/*****************************************************/
/* Private data, do NOT USE this outside class code. */
/*****************************************************/
#ifdef POPUPMENUCLASS_PRIVATE

#define PUMG_SetTagArg(tag, id, data)   {tag.ti_Tag = (ULONG)(id);\
                                        tag.ti_Data = (ULONG)(data);}

typedef ULONG (*HookFunction)(void);

typedef struct {
    struct  List *Labels;
    UWORD   Active;
    UWORD   Count;
    BOOL    NewLook;

    /* For rendering. */
    struct  Image *FrameImage;
    struct  TextFont *Font;

    /* Temporary data for PopupMenu. */
    UWORD   ItemHeight;
    UWORD   FitsItems;
    BOOL    ActiveFromMouse;
    UWORD   Temp_Active;
    struct  Window *popup_window;
    struct  Rectangle rect;
} PUMGData;

#endif      /* POPUPMENUCLASS_PRIVATE */

#endif      /* PUMG_CLASS_H */
