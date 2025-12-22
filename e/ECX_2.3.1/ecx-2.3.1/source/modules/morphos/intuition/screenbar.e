OPT MODULE
OPT EXPORT
OPT PREPROCESS


/*
   intuition screenbar plugin definitions

   Copyright © 2007 The MorphOS Development Team, All Rights Reserved.
*/

MODULE 'utility/tagitem'
-># include <libraries/mui.h>


/* Creates a cfgid x from your tagbase. Set isstring to 1 if the config item is textual
** Otherwise it will be stored as ULONG (4 bytes) */
->#define MUI_CFGID(tagbase,isstring,x) ( (((tagbase) SHL 16) AND $7fffffff) OR $00008000 OR ((isstring) SHL 14) OR (x) )
#define MUI_CFGID(tagbase,isstring,x) ( (Shl(tagbase, 16) AND $7fffffff) OR $00008000 OR Shl(isstring, 14) OR (x) )

->#define MUI_CFGID(tagbase,isstring,x) mui_cfgid(tagbase,isstring,x)
->PROC mui_cfgid(tagbase,isstring,x) IS ( (Shl(tagbase, 16) AND $7fffffff) OR $00008000 OR Shl(isstring, 14) OR (x) )

/* Please obtain your own MUI serial number if you wish to develop screenbar classes! */
->#define MUISERIALNO_INTUITION 0xFECF
->#define TAGBASE_SCREENBAR ((TAG_USER | (MUISERIALNO_INTUITION << 16)) + 3000)
CONST TAGBASE_SCREENBAR = $FECF0BB8

/* In order to support user preferences in your screenbar plugin, implement all of the following methods: */
CONST MUIM_Screenbar_BuildSettingsPanel = TAGBASE_SCREENBAR + 20
CONST MUIM_Screenbar_KnowsConfigItem    = TAGBASE_SCREENBAR + 21
CONST MUIM_Screenbar_DefaultConfigItem  = TAGBASE_SCREENBAR + 22
CONST MUIM_Screenbar_UpdateConfigItem   = TAGBASE_SCREENBAR + 23
/* call the 2 methods below on parent object if you want to ensure that
** the titlebar doesn't disappear while you perform your work*/
CONST MUIM_Screenbar_Lock               = TAGBASE_SCREENBAR + 24
CONST MUIM_Screenbar_Unlock             = TAGBASE_SCREENBAR + 25

OBJECT muip_screenbar_buildsettingspanel
  id:LONG
ENDOBJECT

OBJECT muip_screenbar_knowsconfigitem
  id:LONG
  cfgid:LONG
ENDOBJECT

OBJECT muip_screenbar_defaultconfigitem
  id:LONG
  cfgid:LONG
ENDOBJECT

OBJECT muip_screenbar_updateconfigitem
  id:LONG
  cfgid:LONG
ENDOBJECT

OBJECT muip_screenbar_lock
  id:LONG
ENDOBJECT

OBJECT muip_screenbar_unlock
  id:LONG
ENDOBJECT


/* ScreenbarControl tags */
CONST SBCT_Dummy = TAG_USER + $60500
CONST SBCT_InstallPlugin = SBCT_Dummy + 1
/* struct MUI_CustomClass *,mcc_Class->cl_ID must contain a valid name
** with ascii letters only */
CONST SBCT_UninstallPlugin = SBCT_Dummy + 2
/* struct MUI_CustomClass * */
