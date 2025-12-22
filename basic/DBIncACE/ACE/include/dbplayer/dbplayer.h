#ifndef DBPLAYER_H
#define DBPLAYER_H

/*
** dbplayer.h for ACE Basic
**
** Note: Translated to ACE by ConvertC2ACE
**       Cleaned up by Oliver Gantert
**
** Date: 21-07-99
**
*/

#define DBPLAYER_VERSION 2

/* return values for DBM_StartModule() */

#define DBM_OK                	0L
#define DBM_ALREADY_PLAYING   	1L
#define DBM_NOT_ENOUGH_MEMORY 	2L
#define DBM_MODULE_TRUNCATED  	3L
#define DBM_NOT_DBM_MODULE    	4L
#define DBM_AHI_ASL_ERROR     	5L
#define DBM_AHI_ERROR         	6L

/* Flags definition for DBM_StartModule() */

#define DBB_AUTOBOOST 	0
#define DBF_AUTOBOOST 	(1)

/* DBM tag base */

#define DBM_TB    	(TAG_USER+&HDB2000)

/* Tags definitions for DBM_GetModuleAttr() */

#define DBMATTR_InstNum    	(DBM_TB+&H0100)  /* number of instruments in module */
#define DBMATTR_PattNum    	(DBM_TB+&H0200)  /* number of Patterns in module */
#define DBMATTR_ChanNum    	(DBM_TB+&H0300)  /* number of channels in module */
#define DBMATTR_ModName    	(DBM_TB+&H0400)  /* Module Name */
#define DBMATTR_InstNames  	(DBM_TB+&H0500)  /* Names of instruments */
#define DBMATTR_PlayTime   	(DBM_TB+&H0600)  /* module duration */

#endif
