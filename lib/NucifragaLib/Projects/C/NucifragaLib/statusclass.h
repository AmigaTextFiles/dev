/* $Id: statusclass.h 1.3 1995/12/06 19:25:33 JöG Exp JöG $ */

Class * statusclasscreate(void);
void statusclassdestroy(Class *);

#define STATUS_Text		(TAG_USER+1)	/* is--- */
#define STATUS_RText	(TAG_USER+2)	/* is--- */
#define STATUS_BSpace	(TAG_USER+3)	/* is--- */
#define STATUS_WinMult	(TAG_USER+4)	/* is--- */
#define STATUS_BorCol	(TAG_USER+5)	/* is--- */
