/**
 **    $VER:  page.h 1.0 (09.09.96)
 **
 **    main include file for BOOPSI page.gadget
 **
 **    (C) Copyright 1996 by Jens Tröger
 **    All rights reserved.
 **
 **/

#ifndef PAGE_PAGE_H
#define PAGE_PAGE_H

#ifndef UTILITY_HOOKS_H
#include <utility/hooks.h>
#endif

#ifndef EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

/* this defines the PageBase-structure
   NOTE:  only call OpenLibrary("gadgets/page.gadgets",0L) to get
          pointers to all the other library-bases defined in this
          structure
          (guess this will save a lot of boring stuff) */

struct PageBase
	{
		struct Library		page_LibNode;
		UBYTE							page_Flags;
		UBYTE							page_PadByte;
		APTR							page_SegList;
		struct Library		*page_SysBase;
		struct Library		*page_DOSBase;
		struct Library		*page_IntuitionBase;
		struct Library		*page_GfxBase;
		struct Library		*page_GadtoolsBase;
		struct Library		*page_UtilityBase;
		struct Library		*page_DiskfontBase;

		/* PRIVATE... lots of data will follow: hands off */

	};


/* the tags you may pass to NewObject() or SetGadgetAttrsA() or
   GetAttrsA() */

#define PAGE_Pages				(TAG_USER + 0)		/* ti_Data holds pointer to the first Page-structure */
#define PAGE_Layout				(TAG_USER + 1)		/* defines the look of the pages (see PGLYT_* flags) */
#define PAGE_Underscore 	(TAG_USER + 2)		/* same as the GT_Underscore */
#define PAGE_Active				(TAG_USER + 3)		/* the active page (starts with 0 !!) */
#define PAGE_TextFont			(TAG_USER + 4)		/* ptr to TextFont of the page-gadget */
#define PAGE_TextAttr			(TAG_USER + 5)		/* ptr to TextAttr of the page-gadget */
#define	PAGE_ActiveStyle	(TAG_USER + 6)		/* defines the look of the selected page (see PGAST_* flags) */
#define PAGE_ClearRect		(TAG_USER + 7)		/* ptr to Rectange... defines the to-be-cleared-rect */

/* this structure defines a node called BevelBox; use a linked
   list of such nodes to auto-draw all bevel-boxes of one page */

struct BevelBox
	{
		struct BevelBox *NextBBox;				/* pointer to next node or NULL */
		UWORD Left;												/* left, top, width, height of bevel-box */
		UWORD Top;
		UWORD Width;
		UWORD Height;
		ULONG Flags;											/* see BBFLG_* below */
		UWORD	PtrnAPen;
		UWORD	PtrnBPen;
		UWORD BoxShine;										/* shine/shadow pen for bevel-box */
		UWORD BoxShadow;
	};

/* flags of one BevelBox (used by BevelBox.Flags) */

#define BBFLG_BACKFILL		(1L<<0)			/* fill bevel-box with BackPen color */
#define BBFLG_PATTERNFILL	(1L<<1)			/* if BBFLG_BACKFILL then draw pattern */
#define BBFLG_RECESSED		(1L<<2)			/* recessed-look of bevel-box */
#define BBFLG_FRAMENONE		(1L<<3)			/* bevel-box without any borders */
#define BBFLG_FRAMEBUTTON	(1L<<4)			/* simple button-look */
#define BBFLG_FRAMERIDGE	(1L<<5)			/* looks like a string-gadget */

/* the most important structure: build a linked list of these will
   define the complete page-gadget */

struct Page
	{
		struct Page *NextPage;						/* pointer to next or NULL */
		UBYTE *Name;											/* pointer to the name of this page */
		ULONG NameStyle;									/* the style of the name (bold etc..) */
		struct Gadget *FirstGadget;				/* optionally pointer to first gadget of this page or NULL */
		struct IntuiText *FirstIText;			/* optionally pointer to first intui-text of this page or NULL */
		struct BevelBox *FirstBBox;				/* optionally pointer to first bevel-box of this page or NULL */
		struct Image *FirstImage;
		struct Hook *ThisPageHook;
	};

/* the flags */

#define PGLYT_SIMPLE			0			/* PAGE_Layout */
#define PGLYT_MUISTYLE		1
#define PGLYT_GADTOOLS		2

#define PGAST_NORMAL			0			/* PAGE_ActiveStyle */
#define PGAST_HILIGHT			1
#define PGAST_SHADOW			2

/* the hook-object strcuture
   your hook-function gets a pointer to this structure */
   
struct PageHookObject
	{
		struct GadgetInfo *pho_GInfo;
		struct Page *pho_ActivePage;
	};

#endif /* PAGE_PAGE_H */

