#ifndef POPBUTTONCLASS_H
#define POPBUTTONCLASS_H
/*
**	$VER: popbuttonclass.h 1.1 (18.8.95)
**	C Header for the BOOPSI popup-menu button class.
**
**	(C) Copyright 1995 Jaba Development.
**	(C) Copyright 1995 Jan van den Baard.
**	    All Rights Reserved.
**/

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef INTUITION_CLASSES_H
#include <intuition/classes.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

/*
**	An array of these structures define
**	the menu labels.
**/
struct PopMenu {
	UBYTE		       *pm_Label;		/* Menu text, NULL terminates array. */
	UWORD			pm_Flags;		/* See below. */
	ULONG			pm_MutualExclude;	/* Mutual-exclusion. */
};

/* Flags */
#define PMF_CHECKIT		(1<<0)			/* Checkable (toggle) item. */
#define PMF_CHECKED		(1<<1)			/* The item is checked. */

/*
**	Special menu entry.
**/
#define PMB_BARLABEL		( UBYTE * )~0

/* Tags */
/*
**	All labelclass attributes are usable at create time (I).
**	The vectorclass attributes are usable at create time and
**	with OM_SET (IS).
**/
#define PMB_Image		TAG_USER+0x70021	/* IS--- */
#define PMB_MenuEntries         TAG_USER+0x70022	/* IS--- */
#define PMB_MenuNumber		TAG_USER+0x70023	/* --GN- */
#define PMB_PopPosition         TAG_USER+0x70024	/* I---- */

/* TAG_USER+0x70025 through TAG_USER+0x70040 reserved. */

/* Methods */
#define PMBM_CHECK_STATUS	0x70000
#define PMBM_CHECK_MENU         0x70001
#define PMBM_UNCHECK_MENU	0x70002

struct pmbmCommand {
	ULONG			MethodID;
	ULONG			pmbm_MenuNumber;	/* Menu to do it on. */
};

/* Prototypes */
Class *InitPMBClass( void );
BOOL FreePMBClass( Class * );

#endif
