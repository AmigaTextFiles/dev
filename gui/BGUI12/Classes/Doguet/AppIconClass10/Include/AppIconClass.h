/*
**
** $VER: AppIconClass.lib 1.0 (17.9.95) Doguet Emmanuel
**
**
** C Header for the AppIcon Class.
**
** Allow to create/manage many AppIcons/AppMenus
**
** For use with Intuition, BGUI..
**
**
**
**          (C) Copyright 1995 Doguet Emmanuel
**          All  Rights Reserved.
**
**/

#ifndef APPICONCLASS_H
#define APPICONCLASS_H

#include <exec/types.h>
#include <exec/memory.h>

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef INTUITION_GADGETCLASS_H
#include <intuition/gadgetclass.h>
#endif

/*
**      Macros
**/
#define APP_CLICKED( AppMsg )       ( AppMsg->am_NumArgs ? FALSE:TRUE )
#define APP_NUMARGS( AppMsg )       ( AppMsg->am_NumArgs )

#define APP_IS_FILE( WBArg )        ( WBArg->wa_Lock && WBArg->wa_Name[0] )
#define APP_IS_DIR( WBArg )         ( WBArg->wa_Lock && !WBArg->wa_Name[0] )


/* Tags */
#define AIC_TB              (TAG_USER+0x30000)

#define AIC_AppName         (AIC_TB+1)              /* I---- */
#define AIC_ErrorCode       (AIC_TB+2)              /* I---- */
#define AIC_IconFileName    (AIC_TB+3)              /* I---- */
#define AIC_AppIconMask     (AIC_TB+4)              /* --G-- */
#define AIC_AppMenuItem     (AIC_TB+5)              /* I---- */
#define AIC_AppIconX        (AIC_TB+6)              /* I---- */
#define AIC_AppIconY        (AIC_TB+7)              /* I---- */

/*
**      Possible errors
**/
#define AICERR_CANT_CREATE_MSGPORT  (1L)
#define AICERR_CANT_GET_DISKOBJECT  (2L)
#define AICERR_OUT_OF_MEMORY        (3L)

/*
**  Class routine protos
**/
extern Class *InitAppIconClass( void );
extern BOOL FreeAppIconClass( Class *cl );

#endif

