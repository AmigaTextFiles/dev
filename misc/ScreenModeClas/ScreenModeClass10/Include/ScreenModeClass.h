/*
**
** $VER: ScreenModeClass.lib  1.0 (17.9.95) Doguet Emmanuel
**
**
** C Header for the ScreenMode Class.
**
** Allow to manage/set the Asl-Screenmode requester
** for Intuition, BGUI..
**
**
**          (C) Copyright 1995 Doguet Emmanuel
**          All  Rights Reserved.
**
**/

#ifndef SCREENMODECLASS_H
#define SCREENMODECLASS_H

#include <exec/types.h>
#include <exec/memory.h>

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif

#ifndef LIBRARIES_ASL_H
#include <libraries/asl.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <libraries/utility.h>
#endif

/*
**      Methods
**/
#define SMC_MB                      (0x3000)

#define SMC_DOREQUEST               (SMC_MB+1)



/*
**      Tags
**/
#define SMC_TB                      (TAG_USER+0x30000)


#define SMC_InitialInfoPos          (SMC_TB+1)                  /* I---- */
    /* SMC_INFOPOS_TopLeft, SMC_INFOPOS_TopRight */

#define SMC_InfoPosArround          (SMC_TB+2)                  /* I---- */

#define SMC_DisplayID               (SMC_TB+3)                  /* --G-- */
#define SMC_DisplayWidth            (SMC_TB+4)                  /* --G-- */
#define SMC_DisplayHeight           (SMC_TB+5)                  /* --G-- */
#define SMC_DisplayDepth            (SMC_TB+6)                  /* --G-- */
#define SMC_OverscanType            (SMC_TB+7)                  /* --G-- */
#define SMC_AutoScroll              (SMC_TB+8)                  /* --G-- */

#define SMC_ReqLeftEdge             (SMC_TB+9)                  /* --G-- */
#define SMC_ReqTopEdge              (SMC_TB+10)                  /* --G-- */
#define SMC_ReqWidth                (SMC_TB+11)                 /* --G-- */
#define SMC_ReqHeight               (SMC_TB+12)                 /* --G-- */

#define SMC_InfoLeftEdge            (SMC_TB+13)                 /* --G-- */
#define SMC_InfoTopEdge             (SMC_TB+14)                 /* --G-- */
#define SMC_InfoWidth               (SMC_TB+15)                 /* --G-- */
#define SMC_InfoHeight              (SMC_TB+16)                 /* --G-- */

#define SMC_GUI_MODES               (SMC_TB+17)                 /* IS--- */
#define SMC_ControlMinSize          (SMC_TB+18)                 /* IS--- */


/* Value for SCRM_InitialInfoPos tag */
/* Position relative from ScreenMode Requester */
#define SMC_INFOPOS_TopLeft             (1)
#define SMC_INFOPOS_TopRight            (2)


/*
**      Possible errors
**/
#define SMCERR_OUT_OF_MEMORY            (1L)


/*
**      Macros
**/
#define ScreenModeReq( Obj )      DoMethod( Obj, SMC_DOREQUEST )


/*
**      Class routine protos
**/
extern Class *InitScreenModeClass( void );
extern BOOL FreeScreenModeClass( Class *cl );

#endif

