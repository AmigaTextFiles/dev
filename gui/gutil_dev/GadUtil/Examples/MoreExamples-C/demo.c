/*------------------------------------------------------------------------**
**           project: gadutil.library example demo                        **
**            author: Lukasz Szelag                                       **
**            e-mail: luk@i17linuxa.ists.pwr.wroc.pl                      **
**               WWW: http://www.pwr.wroc.pl/amiga/amiuser/luk            **
**               IRC: #amigapl (Luk)                                      **
**                                                                        **
** Compile with SAS/C 6.x:                                                **
**        sc Demo.c                                                       **
**        slink lib:c.o Demo.o to Demo LIB lib:sc.lib lib:amiga.lib       **
**------------------------------------------------------------------------*/

/*------------------------------------------------------------------------**
Since every C program usually has header files included, so we here include
needed files to satisfy our compiler !
**------------------------------------------------------------------------*/

#include <proto/exec.h>
#include <proto/intuition.h>
#include <intuition/gadgetclass.h>
#include <proto/gadtools.h>
#include <proto/gadutil.h>					/* the name of the game !	  */

/*------------------------------------------------------------------------**
It's  very useful to define absolute gadget's position in the window. Note:
it's only for the first gadget - other gadgets may be positioned relatively
each  to other. Also these values are used to compute the right size of the
window  (see  tags WA_InnerWidth and WA_InnerHeight). It means that gadutil
will compute for you the final size of the window !
**------------------------------------------------------------------------*/

#define LEFT_OFFSET 10
#define TOP_OFFSET  10

/* standard gadtools underscore tags */
struct TagItem GT_tags[] =
{
  GT_Underscore, '_',
  TAG_DONE
};

/*------------------------------------------------------------------------**
The  following  variables  will  be  further  filled  by  gadutil  internal
routines. Aren't ya familar with these yet ? Just refer to gadutil autodocs
and it'll becomes clear at once !
**------------------------------------------------------------------------*/
LONG farright, farbottom, gad_IDCMP;

struct TagItem global_tags[] =
{
  GU_RightExtreme, (ULONG)&farright,
  GU_LowerExtreme, (ULONG)&farbottom,
  GU_MinimumIDCMP, (ULONG)&gad_IDCMP,
  TAG_DONE
};

/*------------------------------------------------------------------------**
Here  we've  some hot image data for the IMAGE_KIND gadget - unselected and
selected images !
**------------------------------------------------------------------------*/

static UWORD __chip image1_data[60] =
{
  0x007F, 0xF000, 0x03FF, 0xFE00, 0x0FFF, 0xFF80, 0x3C1F, 0xC1E0, 0x780F,
  0x80F0, 0x780F, 0x80F0, 0xF9CF, 0x9CF8, 0xFDDD, 0xDDF8, 0xFFF8, 0xFFF8,
  0x7FF8, 0xFFF0, 0x7FFF, 0xFFF0, 0x3FFF, 0xFFE0, 0x0FE0, 0x3F80, 0x03FF,
  0xFE00, 0x007F, 0xF000,
  0x007F, 0xF000, 0x03FF, 0xFE00, 0x0FFF, 0xFF80, 0x3FFF, 0xFFE0, 0x7FFF,
  0xFFF0, 0x7FFF, 0xFFF0, 0xFE3F, 0xE3F8, 0xFE3F, 0xE3F8, 0xFFFF, 0xFFF8,
  0x7FFF, 0xFFF0, 0x7FFF, 0xFFF0, 0x3FFF, 0xFFE0, 0x0FFF, 0xFF80, 0x03FF,
  0xFE00, 0x007F, 0xF000
};

static UWORD __chip image2_data[60] =
{
  0x007F, 0xF000, 0x03FF, 0xFE00, 0x0FFF, 0xFF80, 0x3C1F, 0xC1E0, 0x78EF,
  0x8EF0, 0x78EF, 0x8EF0, 0xF80F, 0x80F8, 0xFC1D, 0xC1F8, 0xFFF8, 0xFFF8,
  0x7FF8, 0xFFF0, 0x7FFF, 0xFFF0, 0x3F9F, 0xCFE0, 0x0FC0, 0x1F80, 0x03FF,
  0xFE00, 0x007F, 0xF000,
  0x007F, 0xF000, 0x03FF, 0xFE00, 0x0FFF, 0xFF80, 0x3FFF, 0xFFE0, 0x7F1F,
  0xF1F0, 0x7F1F, 0xF1F0, 0xFFFF, 0xFFF8, 0xFFFF, 0xFFF8, 0xFFFF, 0xFFF8,
  0x7FFF, 0xFFF0, 0x7FFF, 0xFFF0, 0x3FFF, 0xFFE0, 0x0FFF, 0xFF80, 0x03FF,
  0xFE00, 0x007F, 0xF000
};


struct Image image1 = {0, 0, 29, 15, 2, image1_data, 0x03, 0x00, NULL};
struct Image image2 = {0, 0, 29, 15, 2, image2_data, 0x03, 0x00, NULL};

/*------------------------------------------------------------------------**
Here we can define all gadgets ! It's very simple task - you don't need any
GUI  editor  since  gadget's  positions may be specified relatively each to
other !
**------------------------------------------------------------------------*/

/* gadget's names */
#define GDG_BOX1     0
#define GDG_BOX2     1
#define GDG_BOX3     2
#define GDG_BOX4     3
#define GDG_BOX5     4
#define GDG_BOX6     5
#define GDG_DRAWER   6
#define GDG_FILE     7
#define GDG_PROGRESS 8
#define GDG_IMAGE    9

struct TagItem box1[] =
{
  GU_GadgetKind,  BEVELBOX_KIND,
  GU_GadgetText,  (ULONG)"Recessed3D FrameType = BFT_RIDGE",
  GUBB_Recessed,  TRUE,
  GUBB_FrameType, BFT_RIDGE,
  GUBB_TextColor, 2,
  GUBB_Flags,     BB_TEXT_ABOVE_LEFT|BB_SUNAT_UL,
  GUBB_3DText,    TRUE,
  GU_Left,        LEFT_OFFSET,
  GU_Top,         TOP_OFFSET,
  GU_Width,       300,
  GU_Height,      30,
  TAG_DONE
};

struct TagItem box2[] =
{
  GU_GadgetKind,  BEVELBOX_KIND,
  GU_GadgetText,  (ULONG)"Recessed FrameType = BFT_RIDGE",
  GUBB_Recessed,  TRUE,
  GUBB_FrameType, BFT_RIDGE,
  GUBB_TextColor, 2,
  GUBB_Flags,     BB_TEXT_ABOVE_LEFT,
  GU_LeftRel,     GDG_BOX1,
  GU_AlignTop,    GDG_BOX1,
  GU_DupeWidth,   GDG_BOX1,
  GU_DupeHeight,  GDG_BOX1,
  TAG_DONE
};

struct TagItem box3[] =
{
  GU_GadgetKind,  BEVELBOX_KIND,
  GU_GadgetText,  (ULONG)"Recessed3D FrameType = BFT_BUTTON",
  GUBB_Recessed,  TRUE,
  GUBB_FrameType, BFT_BUTTON,
  GUBB_TextColor, 2,
  GUBB_Flags,     BB_TEXT_ABOVE_LEFT|BB_SUNAT_UL,
  GUBB_3DText,    TRUE,
  GU_AlignLeft,   GDG_BOX1,
  GU_TopRel,      GDG_BOX1,
  GU_AddTop,      10,
  GU_DupeWidth,   GDG_BOX1,
  GU_DupeHeight,  GDG_BOX1,
  TAG_DONE
};

struct TagItem box4[] =
{
  GU_GadgetKind,  BEVELBOX_KIND,
  GU_GadgetText,  (ULONG)"Recessed FrameType = BFT_BUTTON",
  GUBB_Recessed,  TRUE,
  GUBB_FrameType, BFT_BUTTON,
  GUBB_TextColor, 2,
  GUBB_Flags,     BB_TEXT_ABOVE_LEFT,
  GU_LeftRel,     GDG_BOX3,
  GU_AlignTop,    GDG_BOX3,
  GU_DupeWidth,   GDG_BOX1,
  GU_DupeHeight,  GDG_BOX1,
  TAG_DONE
};

struct TagItem box5[] =
{
  GU_GadgetKind,  BEVELBOX_KIND,
  GU_GadgetText,  (ULONG)"Recessed3D FrameType = BFT_DROPBOX",
  GUBB_Recessed,  TRUE,
  GUBB_FrameType, BFT_DROPBOX,
  GUBB_TextColor, 2,
  GUBB_Flags,     BB_TEXT_ABOVE_LEFT|BB_SUNAT_UL,
  GUBB_3DText,    TRUE,
  GU_AlignLeft,   GDG_BOX1,
  GU_TopRel,      GDG_BOX4,
  GU_AddTop,      10,
  GU_DupeWidth,   GDG_BOX1,
  GU_DupeHeight,  GDG_BOX1,
  TAG_DONE
};

struct TagItem box6[] =
{
  GU_GadgetKind,  BEVELBOX_KIND,
  GU_GadgetText,  (ULONG)"Recessed FrameType = BFT_DROPBOX",
  GUBB_Recessed,  TRUE,
  GUBB_FrameType, BFT_DROPBOX,
  GUBB_TextColor, 2,
  GUBB_Flags,     BB_TEXT_ABOVE_LEFT,
  GU_LeftRel,     GDG_BOX5,
  GU_AlignTop,    GDG_BOX5,
  GU_DupeWidth,   GDG_BOX1,
  GU_DupeHeight,  GDG_BOX1,
  TAG_DONE
};

struct TagItem drawer[] =
{
  GU_GadgetKind,  DRAWER_KIND,
  GU_GadgetText,  (ULONG)"_DRAWER KIND:",
  GU_Flags,       NG_HIGHLABEL,
  GU_LabelHotkey, TRUE,
  GU_AlignLeft,   GDG_BOX1,
  GU_AdjustLeft,  10,
  GU_TopRel,      GDG_BOX5,
  GU_AddTop,      5,
  GU_Width,       DRAWERKIND_WIDTH,
  GU_Height,      DRAWERKIND_HEIGHT,
  TAG_DONE
};

struct TagItem file[] =
{
  GU_GadgetKind,  FILE_KIND,
  GU_GadgetText,  (ULONG)"_FILE KIND:",
  GU_Flags,       NG_HIGHLABEL,
  GU_LabelHotkey, TRUE,
  GU_AlignLeft,   GDG_DRAWER,
  GU_TopRel,      GDG_DRAWER,
  GU_AddTop,      5,
  GU_Width,       FILEKIND_WIDTH,
  GU_Height,      FILEKIND_HEIGHT,
  TAG_DONE
};

struct TagItem progress[] =
{
  GU_GadgetKind,  PROGRESS_KIND,
  GU_GadgetText,  (ULONG)"PROGRESS KIND:",
  GUPR_Current,   30,
  GUPR_Total,     100,
  GU_Flags,       NG_HIGHLABEL,
  GU_LeftRel,     GDG_DRAWER,
  GU_AdjustLeft,  10,
  GU_AlignTop,    GDG_DRAWER,
  GU_Width,       100,
  GU_DupeHeight,  GDG_DRAWER,
  TAG_DONE
};

struct TagItem image[] =
{
  GU_GadgetKind,   IMAGE_KIND,
  GU_GadgetText,   (ULONG)"_IMAGE KIND:",
  GUIM_Image,      (ULONG)&image1,
  GUIM_SelectImg,  (ULONG)&image2,
  GU_Flags,        NG_HIGHLABEL,
  GU_LabelHotkey,  TRUE,
  GU_LeftRel,      GDG_PROGRESS,
  GU_AdjustLeft,   10,
  GU_AlignTop,     GDG_PROGRESS,
  GU_Width,        29+10,
  GU_Height,       15+5,
  TAG_DONE
};

struct LayoutGadget gadgets[] =
{
  GDG_BOX1,     box1,     NULL,    NULL,
  GDG_BOX2,     box2,     NULL,    NULL,
  GDG_BOX3,     box3,     NULL,    NULL,
  GDG_BOX4,     box4,     NULL,    NULL,
  GDG_BOX5,     box5,     NULL,    NULL,
  GDG_BOX6,     box6,     NULL,    NULL,
  GDG_DRAWER,   drawer,   GT_tags, NULL,
  GDG_FILE,     file,     GT_tags, NULL,
  GDG_PROGRESS, progress, NULL,    NULL,
  GDG_IMAGE,    image,    GT_tags, NULL,
  -1
};

/*------------------------------------------------------------------------*/
struct Library *GadUtilBase = NULL;			/* library base				  */
struct Screen *myscreen = NULL;				/* our screen				  */
struct Window *mywindow     = NULL;			/* and its visitor window	  */

APTR ginfo;									/* gadget's stuff			  */
struct Gadget *glist;
UWORD sel_gadID;							/* number of the selected gadget */

struct IntuiMessage *imsg;					/* IntuiMessage stuff		  */
ULONG class;
UWORD code;
APTR iaddress;

BOOL done = FALSE;							/* program termination flag	  */

/*------------------------------------------------------------------------*/
void main(void)
{
	/* let's open the famous library :-) */
	if (GadUtilBase = OpenLibrary(GADUTILNAME, 36))
	{
		/* let's get pointer to the default public screen */
		if (myscreen = LockPubScreen(NULL))
		{
			/* let's initialize our pretty gadgets */
			if (ginfo = GU_LayoutGadgetsA(&glist, gadgets, myscreen, global_tags))
			{
				/* I think it'd be great to have one small cute window ! */
				if (mywindow = OpenWindowTags(
					NULL,
					WA_Left,			5,
					WA_Top,				20,
					WA_InnerWidth,		farright+LEFT_OFFSET,
					WA_InnerHeight,		farbottom+TOP_OFFSET,
					WA_PubScreenName,	NULL,
					WA_IDCMP,			gad_IDCMP|
										IDCMP_CLOSEWINDOW|
										IDCMP_VANILLAKEY,
					WA_Flags,			WFLG_DRAGBAR|
										WFLG_DEPTHGADGET|
										WFLG_CLOSEGADGET|
										WFLG_SMART_REFRESH|
										WFLG_ACTIVATE|
										WFLG_RMBTRAP,
					WA_Gadgets,			glist,
					WA_Title,			(ULONG)"Yeah, it tastes well, doesn't ?!",
					TAG_DONE))
				{
					/* Hmm, our pretties need to be refreshed... */
					GU_RefreshWindow(mywindow, ginfo);

					DrawImage(mywindow->RPort, &image1, 50, 70);
					DrawImage(mywindow->RPort, &image2, 50, 110);

					/* As ya may see program will terminate if our boolean become TRUE ! */
					while (!done)
					{
						/* Waitin' for messages - is it heavy work ? */
						Wait(1L << mywindow->UserPort->mp_SigBit);

						/* let's process our messages */
						while (imsg = GU_GetIMsg(mywindow->UserPort))
						{
							/* Let's store every message and reply as fast as we can ! */
							class    = imsg->Class;
							code     = imsg->Code;
							iaddress = imsg->IAddress;
							GU_ReplyIMsg(imsg);

							/* Let's  take  a brave decission and branch out (standard IDCMP handling). */
							switch (class)
							{
								/* DRAWER_KIND, FILE_KIND or IMAGE_KIND */
								case IDCMP_GADGETUP:

								/* number of the selected gadget */
								sel_gadID = ((struct Gadget *)iaddress)->GadgetID;

								switch (sel_gadID)
								{
									case GDG_DRAWER:
									case GDG_FILE:
									case GDG_IMAGE:
									DisplayBeep(myscreen); break;
								}
								break;

								/* both close window and Esc key will cause quit */
								case IDCMP_CLOSEWINDOW: done = TRUE; break;
								case IDCMP_VANILLAKEY:  done = (code==27); break;
							}
						}
					}
					/* Bye, bye dear window ! */
					CloseWindow(mywindow);
				}
				/* Bye for now, pretty gadgets ! */
				GU_FreeLayoutGadgets(ginfo);
			}
			/* Accordin' to the RKM we may unlock our screen now ! */
			UnlockPubScreen(NULL, myscreen);
		}
		/* Sorry, accordin' to the RKM I... have to close ya :( */
		CloseLibrary(GadUtilBase);
	}
}
