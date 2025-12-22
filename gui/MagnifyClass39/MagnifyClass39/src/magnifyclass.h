#ifndef MAGNIFYCLASS_H
#define MAGNIFYCLASS_H
/*
**	$VER: magnifyclass.h 1.1 (20.3.96)
**	C Header for the BOOPSI magnify gadget class.
**
**	(C) 1995/96 by Reinhard Katzmann
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

/* Prototypes */
Class *InitMagnifyClass( void );
BOOL FreeMagnifyClass( Class * );

/* Tags */

#define MAGNIFY_MagFactor			TAG_USER+0x70010	/* ISGNU */
#define MAGNIFY_Edit					TAG_USER+0x70011	/* I-G-- */
#define MAGNIFY_SpecialFrame		TAG_USER+0x70012	/* I-G-- */
#define MAGNIFY_GraphWidth			TAG_USER+0x70013	/* --G-- */
#define MAGNIFY_GraphHeight		TAG_USER+0x70014	/* --G-- */
#define MAGNIFY_FrameCoordsX  	TAG_USER+0x70015	/* ISGNU */
#define MAGNIFY_FrameCoordsY  	TAG_USER+0x70016	/* ISGNU */
#define MAGNIFY_PicArea				TAG_USER+0x70017	/* ISGNU */
#define MAGNIFY_CurrentPen  		TAG_USER+0x70018	/* ISG-U */
#define MAGNIFY_Grid					TAG_USER+0x70019	/* ISGNU */
#define MAGNIFY_GridPen				TAG_USER+0x70020	/* ISGNU */
#define MAGNIFY_SelectRegionX		TAG_USER+0x70021	/* ISGNU */
#define MAGNIFY_SelectRegionY		TAG_USER+0x70022	/* ISGNU */
#define MAGNIFY_BoxWidth			TAG_USER+0x70023	/* ---N- */
#define MAGNIFY_BoxHeight		   TAG_USER+0x70024	/* ---N- */
#define MAGNIFY_ScaleWidth			TAG_USER+0x70025	/* I---- */
#define MAGNIFY_ScaleHeight		TAG_USER+0x70026	/* I---- */

/* Methods */

#define MAGM_Undo				0x70000
#define MAGM_AllocBitMap	0x70001 /* Do only use this methods if you know */
#define MAGM_FreeBitMap    0x70002 /* what you are doing.                  */

struct magmBitMap {
	ULONG		MethodID;   /* MAGM_AllocBitMap, MAGM_FreeBitMap */
	struct BitMap **mbm;
	struct BitMap *sbm;  /* Only needed for MAGM_AllocBitMap */
};

#define MAGERR_Ok          0x0
#define MAGERR_AllocFail   0x5
#define MAGERR_NoBitMap    0x7
#define MAGERR_Fatal       0x10


/* TAG_USER+0x70000 through TAG_USER+0x700030 reserved. */

#endif
