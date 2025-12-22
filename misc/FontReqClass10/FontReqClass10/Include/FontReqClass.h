/*
** $VER: FontReq.lib 1.0 (17.9.95) Doguet Emmanuel
**
**
** C Header for the Font requester Class.
**
** Allow to manage/set the Asl-Font requester
** for Intuition, BGUI..
**
**
**
**          (C) Copyright 1995 Doguet Emmanuel
**          All  Rights Reserved.
**
**/


#ifndef FONTREQCLASS_H
#define FONTREQCLASS_H

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
#define FC_MB                       (0x4000)

#define FC_DOREQUEST                (FC_MB+1)

/*
**      Tags
**/
#define FC_TB                       (TAG_USER+0x40000)

#define FC_TextAttr                 (FC_TB+1)               /* I-G-- */
#define FC_FrontPen                 (FC_TB+2)               /* --G-- */
#define FC_BackPen                  (FC_TB+3)               /* --G-- */
#define FC_DrawMode                 (FC_TB+4)               /* --G-- */
#define FC_TTextAttr                (FC_TB+5)               /* --G-- */

#define FC_ReqLeftEdge              (FC_TB+6)               /* --G-- */
#define FC_ReqTopEdge               (FC_TB+7)               /* --G-- */
#define FC_ReqWidth                 (FC_TB+8)               /* --G-- */
#define FC_ReqHeight                (FC_TB+9)               /* --G-- */


/*
**      Possible errors ( ! NOT IMPLEMENTED YET ! )
**/
#define FCERR_OUT_OF_MEMORY             (1L)


/*
**      Macros
**/
#define FontRequester( Obj )      DoMethod( Obj, FC_DOREQUEST )


/*
**      Class routine protos
**/
extern Class *InitFontReqClass( void );
extern BOOL FreeFontReqClass( Class *cl );

#endif

