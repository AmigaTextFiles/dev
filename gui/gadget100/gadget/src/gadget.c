/*
**	Gadget.c:   Neue gadget.library
**
**	05.09.92 - 05.06.93
*/

#include "Chip.pro"
#include "CycleGadget.pro"
#include "Gadget.pro"
#include "Message.pro"
#include "Listview.pro"
#include "MX.pro"
#include "Palette.pro"
#include "PropGadget.pro"
#include "Scrollbar.pro"
#include "Simple.pro"
#include "StringGadget.pro"
#include "TextButton.pro"
#include "TextGadget.pro"
#include "Utility.pro"

#ifdef LIBRARY
#include "GadgetPrivateLibrary.h"
#include "Gadget_lib.h"
#asm
	include libstart.asm
#endasm
#endif

extern struct TextAttr TextAttr;

/*
**	Variablen:
*/

struct TagItem flagsTags[]=
{
	GA_Selected, GFLG_SELECTED,
   GA_Disabled, GFLG_DISABLED,
	GA_TabCycle, GFLG_TABCYCLE,
   TAG_DONE,
};
struct TagItem activationTags[]=
{
	GA_RelVerify, GACT_RELVERIFY,
	GA_Immediate, GACT_IMMEDIATE,
	GA_FollowMouse, GACT_FOLLOWMOUSE,
	GA_ToggleSelect, GACT_TOGGLESELECT,
	GA_RightBorder, GACT_RIGHTBORDER,
	GA_LeftBorder, GACT_LEFTBORDER,
	GA_TopBorder, GACT_TOPBORDER,
	GA_BottomBorder, GACT_BOTTOMBORDER,
	TAG_DONE,
};
struct TagItem typeTags[]=
{
	GA_GZZGadget, GTYP_GZZGADGET,
   TAG_DONE,
};

struct IntuitionBase *IntuitionBase = NULL;
struct GfxBase *GfxBase = NULL;
struct Library *UtilityBase = NULL;
struct GadgetBase *GadgetBase = NULL;
struct IOStdReq iostdreq;
struct Device *ConsoleDevice = NULL;
struct InputEvent inputevent=
{
   0,IECLASS_RAWKEY, 0, 0, 0,
};
struct TextFont *topaz8Font = NULL;

#ifdef LIBRARY

/* library initialization table, used for AUTOINIT libraries			*/
struct InitTable {
	unsigned long	it_DataSize;		  /* library data space size		*/
	void			**it_FuncTable;		  /* table of entry points			*/
	void 			*it_DataInit;		  /* table of data initializers		*/
	void			(*it_InitFunc)(void); /* initialization function to run	*/
};

void *libfunctab[] =
{								/* my function table */
	myOpen,					/* standard open	*/
	myClose,					/* standard close	*/
	myExpunge,				/* standard expunge	*/
	0,

	/* user UTILITIES */

	/* exported functions - internal functions (for backward compatibility) */

	gadAllocIntuiText,
	gadFreeIntuiText,
								gadAllocBevelBorderA,
								gadAllocBoolGadgetA,
								gadAllocTextButtonGadgetA,
								gadAllocCheckMarkGadgetA,
	gadAllocGadgetA,
								gadAllocArrowGadgetA,
								gadAllocPropGadgetA,
								gadAllocStringGadgetA,
								gadAllocIntGadgetA,
								gadAllocScrollbarGadgetA,
	gadSetGadgetAttrsA,
	gadGetGadgetAttr,
	gadFreeGadget,
	gadFreeGadgetList,
	gadFilterMessage,
								gadAllocTextGadgetA,
								gadAllocListviewGadgetA,
								gadAllocCycleGadgetA,
								gadAllocGetFileGadgetA,
								gadAllocPaletteGadgetA,

	(void *)-1				/* end of function vector table */
};

struct InitTable myInitTab =  {
	sizeof(struct GadgetBase),
	libfunctab,
	0,						/* will initialize my data in funkymain()	*/
	myInit
};

#define MYREVISION	9		/* would be nice to auto-increment this		*/

char myname[] = "gadget.library";
char myid[] = "gadget.library 38.9";

extern struct Resident	myRomTag;

long _main(struct GadgetBase *GadBase, unsigned long seglist)
{
	GadgetBase = GadBase;

	GadgetBase->gad_SegList = seglist;

	/* ----- init. library structure  -----		*/
	GadgetBase->gad_Lib.lib_Node.ln_Type = NT_LIBRARY;
	GadgetBase->gad_Lib.lib_Node.ln_Name = (char *) myname;
	GadgetBase->gad_Lib.lib_Flags = LIBF_SUMUSED | LIBF_CHANGED;
	GadgetBase->gad_Lib.lib_Version = myRomTag.rt_Version;
	GadgetBase->gad_Lib.lib_Revision = MYREVISION;
	GadgetBase->gad_Lib.lib_IdString = (APTR) myid;
};

#endif

BOOL gadOpenGadget(void)
{
	if(!IntuitionBase && !(IntuitionBase = (struct IntuitionBase *)
	OpenLibrary((UBYTE *)"intuition.library", 0L)))
		return(FALSE);

	if(!GfxBase && !(GfxBase = (struct GfxBase *)
	OpenLibrary((UBYTE *)"graphics.library", 0L)))
		return(FALSE);

   if(ISKICK20)
		if(!UtilityBase  && !(UtilityBase = (struct Library *)
		OpenLibrary((UBYTE *)"utility.library", 37L)))
			return(FALSE);

   if(!ConsoleDevice && OpenDevice((UBYTE *)"console.device",
	-1L, (struct IORequest *)&iostdreq, 0L) != 0)
		return(FALSE);
 	ConsoleDevice=iostdreq.io_Device;

	if(!topaz8Font && !(topaz8Font = OpenFont(&TextAttr)))
		return(FALSE);

	if(!gadAllocChip())
		return(FALSE);

	return(TRUE);
}

#ifdef LIBRARY

long myOpen(void)
{
	if(!gadOpenGadget())
		return(0L);

	GadgetBase->gad_Lib.lib_OpenCnt++;

	/* prevent delayed expunges (standard procedure) */

	GadgetBase->gad_Lib.lib_Flags &= ~LIBF_DELEXP;

	return((long)GadgetBase);
}

#endif

void gadCloseGadget(void)
{
	gadFreeChip();

	if(topaz8Font)
		CloseFont(topaz8Font);
	topaz8Font = NULL;

   if(ConsoleDevice)
      CloseDevice((struct IORequest *)&iostdreq);
   ConsoleDevice = NULL;

   if(UtilityBase)
		CloseLibrary(UtilityBase);
	UtilityBase = NULL;

	if(GfxBase)
		CloseLibrary((struct Library *)GfxBase);
	GfxBase = NULL;

	if(IntuitionBase)
		CloseLibrary((struct Library *)IntuitionBase);
	IntuitionBase = NULL;
}

#ifdef LIBRARY

long myClose(void)
{
	long retval = 0;

	if(--GadgetBase->gad_Lib.lib_OpenCnt == 0)
	{
		if((GadgetBase->gad_Lib.lib_Flags & LIBF_DELEXP))
		{
			/* no more people have me open,
			 * and I have a delayed expunge pending
			 */
			retval = myExpunge(); /* return segment list	*/
		}
	}
	return (retval);
}

long myExpunge(void)
{
	unsigned long seglist = 0;
	long libsize;
	extern struct Library *DOSBase;

	if (GadgetBase->gad_Lib.lib_OpenCnt == 0) {
		/* really expunge: remove libbase and freemem	*/

		seglist	= GadgetBase->gad_SegList;
		Remove(&GadgetBase->gad_Lib.lib_Node);
								/* i'm no longer an installed library	*/
		gadCloseGadget();

		libsize = GadgetBase->gad_Lib.lib_NegSize+GadgetBase->gad_Lib.lib_PosSize;
		FreeMem((char *)GadgetBase-GadgetBase->gad_Lib.lib_NegSize, libsize);
		CloseLibrary(DOSBase);		/* keep the counts even */
	}
	else
		GadgetBase->gad_Lib.lib_Flags |= LIBF_DELEXP;

	/* return NULL or real seglist				*/
	return ((long) seglist);
}

#endif


/*
**	Hilfsfunktionen:
**	09.09.92 - 09.09.92
*/

void getxywhf(SHORT *x, SHORT *y, SHORT *w, SHORT *h, USHORT *flags, struct TagItem *tagList)
{
	*x = GETTAGDATA(GA_Left, *x, tagList);
   *x = GETTAGDATA(GA_RelRight, *x, tagList);
	*y = GETTAGDATA(GA_Top, *y, tagList);
	*y = GETTAGDATA(GA_RelBottom, *y, tagList);
	*w = GETTAGDATA(GA_Width, *w, tagList);
	*w = GETTAGDATA(GA_RelWidth, *w, tagList);
	*h = GETTAGDATA(GA_Height, *h, tagList);
	*h = GETTAGDATA(GA_RelHeight, *h, tagList);
	*flags = PACKBOOLTAGS(*flags, tagList, flagsTags);
   if(FINDTAGITEM(GA_RelRight, tagList))
		*flags |= GFLG_RELRIGHT;
	if(FINDTAGITEM(GA_RelBottom, tagList))
		*flags |= GFLG_RELBOTTOM;
	if(FINDTAGITEM(GA_RelWidth, tagList))
		*flags |= GFLG_RELWIDTH;
	if(FINDTAGITEM(GA_RelHeight, tagList))
		*flags |= GFLG_RELHEIGHT;
}

/*
**	gadAllocGadgetA
**	25.12.92 - 25.12.92
*/

struct Gadget *gadAllocGadgetA(ULONG kind, struct TagItem *tagList)
{
	switch(kind)
	{
		case GAD_BEVELBOX_KIND:	return(gadAllocBevelBorderA(tagList));	break;
		case GAD_TEXT_KIND:		return(gadAllocTextGadgetA(tagList));	break;
		case GAD_NUMBER_KIND:	return(NULL);	break;
		case GAD_BOOL_KIND:		return(gadAllocBoolGadgetA(tagList));	break;
		case GAD_BUTTON_KIND:	return(gadAllocTextButtonGadgetA(tagList));	break;
		case GAD_ARROW_KIND:		return(gadAllocArrowGadgetA(tagList));	break;
		case GAD_GETFILE_KIND:	return(gadAllocGetFileGadgetA(tagList));	break;
		case GAD_CHECKBOX_KIND:	return(gadAllocCheckMarkGadgetA(tagList));	break;
		case GAD_RADIOBUTTON_KIND:	return(gadAllocRadioButtonGadgetA(tagList)); break;
		case GAD_MX_KIND:			return(gadAllocMXGadgetA(tagList));	break;
		case GAD_CYCLE_KIND:		return(gadAllocCycleGadgetA(tagList));	break;
		case GAD_STRING_KIND:	return(gadAllocStringGadgetA(tagList));	break;
		case GAD_INTEGER_KIND:	return(gadAllocIntGadgetA(tagList));	break;
		case GAD_SCROLLER_KIND:	return(gadAllocScrollbarGadgetA(tagList));	break;
		case GAD_SLIDER_KIND:	return(NULL);	break;
		case GAD_LISTVIEW_KIND:	return(gadAllocListviewGadgetA(tagList));	break;
		case GAD_PALETTE_KIND:	return(gadAllocPaletteGadgetA(tagList));	break;
		default:	return(NULL);
	}
}

/*
**	gadSetGadgetAttrs
**	10.09.92 - 25.09.92
*/

ULONG gadSetGadgetAttrsA(struct Gadget *gad, struct Window *w, struct Requester *req, struct TagItem *tagList)
{
	struct GadgetExtend *gx = (struct GadgetExtend *)gad;
	struct TagItem *tag, *workList = tagList;
	USHORT pos, i;
   BOOL  setxywhf = FALSE, setactivation = FALSE;
	ULONG refresh = FALSE;
	struct Gadget **subgad;

	if(gad)
	{
		if(w)
			pos = RemoveGadget(w, gad);

		while(tag = NEXTTAGITEM(&workList))
		{
			switch(tag->ti_Tag)
			{
				case GA_Left:
				case GA_RelRight:
				case GA_Top:
				case GA_RelBottom:
				case GA_Width:
				case GA_RelWidth:
				case GA_Height:
				case GA_RelHeight:   break; /* not supported */

				case GA_Disabled: if(tag->ti_Data)
											gad->Flags |= GFLG_DISABLED;
										else
											gad->Flags &= ~(GFLG_DISABLED);
										refresh = TRUE;
                              break;

				case GA_Selected: if(gad->GadgetType == BOOLGADGET)
										{
											if(tag->ti_Data)
												gad->Flags |= GFLG_SELECTED;
											else
												gad->Flags &= ~(GFLG_SELECTED);
											refresh = TRUE;
										}
                              break;

				case GA_Immediate:
				case GA_RelVerify:
				case GA_FollowMouse:
				case GA_RightBorder:
				case GA_LeftBorder:
				case GA_TopBorder:
				case GA_BottomBorder:
				case GA_ToggleSelect:	setactivation = TRUE;
                                    break;
			}
		}
/*		if(setactivation)
         gad->Activation |= PACKBOOLTAGS(gad->Activation, tagList, activationTags); */
		if(gx->setattrs)
			refresh |= gx->setattrs(gad, w, req, tagList);

		if(w && pos >= 0L)
		{
			AddGadget(w, gad, pos);
			if(refresh)
				RefreshGList(gad, w, req, 1L);
			refresh = FALSE;
		}
		if(GADGET_TYPE(gad) & COMPOSED_GADGET)
		{
			/* Set attributes on childgadgets, too */

         subgad = (struct Gadget **)((struct ComposedGadget *)gx+1);
			for(i=0; i<((struct ComposedGadget *)gx)->num; i++)
         	refresh |= gadSetGadgetAttrsA(subgad[i], w, req, tagList);
		}
	}
	return(refresh);
}

/*
**	gadGetGadgetAttr
**	14.09.92 - 29.12.92
*/

ULONG gadGetGadgetAttr(ULONG tag, struct Gadget *gad, ULONG *storage)
{
	struct GadgetExtend *gx = (struct GadgetExtend *)gad;
	ULONG ret = FALSE;
	struct Gadget **subgad;
	SHORT i;

   if(gad && storage)
	{
      switch(tag)
		{
			case GA_Selected:	*storage = (gad->Flags & SELECTED)? 1L : 0L;
									ret = TRUE;
									break;
		}

		if(!ret && gx->getattr)
			/* ask private getattr method */
			ret = gx->getattr(tag, gad, storage);

   	if(!ret && (GADGET_TYPE(gad) & COMPOSED_GADGET))
		{
			/* ask childgadgets */
   		subgad = (struct Gadget **)((struct ComposedGadget *)gx+1);
			for(i=0; i<((struct ComposedGadget *)gx)->num; i++)
     			if(ret = gadGetGadgetAttr(tag, subgad[i], storage))
					break;
		}
	}
	return(ret);
}

/*
**	gadFreeGadget(List)
**	09.09.92 - 25.09.92
*/

void gadFreeGadget(struct Gadget *gad)
{
	struct GadgetExtend *gx = (struct GadgetExtend *)gad;
	struct Gadget **subgad;
	SHORT i;

   if(gad)
	{
   	if(GADGET_TYPE(gad) & COMPOSED_GADGET)
		{
   		subgad = (struct Gadget **)((struct ComposedGadget *)gx+1);
			for(i=0; i<((struct ComposedGadget *)gx)->num; i++)
     			gadFreeGadget(subgad[i]);
		}
		if(gx->free)
			gx->free(gad);
	}
}

void gadFreeGadgetList(struct Gadget *first)
{
	struct Gadget *gad;

	while(gad = first)
	{
		first = first->NextGadget;
		if(!ISCHILD_GADGET(gad))
			gadFreeGadget(gad);
	}
}

