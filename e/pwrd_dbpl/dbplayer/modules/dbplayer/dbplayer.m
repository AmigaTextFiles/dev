MODULE	'utility/tagitem'

CONST	DBPLAYER_VERSION=2

/* return values for DBM_StartModule() */
CONST	DBM_OK=0,
		DBM_ALREADY_PLAYING=1,
		DBM_NOT_ENOUGH_MEMORY=2,
		DBM_MODULE_TRUNCATED=3,
		DBM_NOT_DBM_MODULE=4,
		DBM_AHI_ASL_ERROR=5,
		DBM_AHI_ERROR=6
FLAG	DB_AUTOBOOST=0

/* DBM tag base */
CONST	DBM_TB=TAG_USER+$DB2000

/*
 Tags definitions for DBM_GetModuleAttr();
*/
CONST	DBMATTR_InstNum     =DBM_TB+$0100, 	/* number of instruments in module */
		DBMATTR_PattNum     =DBM_TB+$0200, 	/* number of Patterns in module */
		DBMATTR_ChanNum     =DBM_TB+$0300, 	/* number of channels in module */
		DBMATTR_ModName     =DBM_TB+$0400, 	/* Module Name */
		DBMATTR_InstNames   =DBM_TB+$0500, 	/* Names of instruments */
		DBMATTR_PlayTime    =DBM_TB+$0600 	/* module duration */
