
OPT MODULE
OPT PREPROCESS
OPT EXPORT

MODULE 'utility/tagitem'

CONST DBPLAYER_VERSION= 2

/* return values for DBM_StartModule() */
CONST DBM_OK               = 0
CONST DBM_ALREADY_PLAYING  = 1
CONST DBM_NOT_ENOUGH_MEMORY= 2
CONST DBM_MODULE_TRUNCATED = 3
CONST DBM_NOT_DBM_MODULE   = 4
CONST DBM_AHI_ASL_ERROR    = 5
CONST DBM_AHI_ERROR 	   = 6


/*
Flags definition for DBM_StartModule() 
Only one exist right now...
*/

CONST DBB_AUTOBOOST= 0
#define DBF_AUTOBOOST  (Shl(1,DBB_AUTOBOOST))

/* DBM tag base */

CONST DBM_TB=TAG_USER+$DB2000

/*
 Tags definitions for DBM_GetModuleAttr();
*/

CONST DBMATTR_InstNum   = DBM_TB+$0100 /* number of instruments in module */
CONST DBMATTR_PattNum   = DBM_TB+$0200 /* number of Patterns in module */
CONST DBMATTR_ChanNum   = DBM_TB+$0300 /* number of channels in module */
CONST DBMATTR_ModName   = DBM_TB+$0400 /* Module Name */
CONST DBMATTR_InstNames = DBM_TB+$0500 /* Names of instruments */
CONST DBMATTR_PlayTime  = DBM_TB+$0600 /* module duration */
