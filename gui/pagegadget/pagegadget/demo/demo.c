
/******************************************************************
 *
 * demo-programm of the BOOPSI class "page.gadget"
 *
 * this custom-class is copyright (C) 1996 by Jens Tröger
 *
 */

#include <intuition/classes.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <gadgets/page.h>
#include <libraries/gadtools.h>
#include <exec/memory.h>

#include <clib/exec_protos.h>
#include <clib/intuition_protos.h>
#include <clib/page_protos.h>
#include <clib/graphics_protos.h>
#include <clib/gadtools_protos.h>
#include <clib/diskfont_protos.h>

#include <stdio.h>
#include <string.h>

#include "images.c"

/********************************************************************
 *
 * global vars
 *
 */

struct PageBase *PageBase;							/* the base of the page.gadget */

struct Library *IntuitionBase;					/* this should be clear */
struct Library *GadtoolsBase;
struct Library *GfxBase;
struct Library *DiskfontBase;
struct Window *myWindow;
struct Gadget *myPageGadget;
struct IntuiMessage *myIMsg;

IClass *myPageClass = NULL;							/* this will hold the pointer
																					 to the private class */

struct TextAttr tattr = { "topaz.font", 8, 0, 0 };
struct TextFont *tfont;

/******************************************************************
 *
 * prototypes
 *
 */

struct Gadget *createPageGadget(void);
struct Gadget *createGadgets(void);
void myHookFunction(struct Hook *, struct Gadget *, struct PageHookObject *);

/********************************************************************
 *
 * the page-definitions themselves
 *
 * every page can have it`s own gadgets, itexts, images and bevel-
 * boxes (note: bevel-boxes are defined with a custom structure
 * called BevelBox...   refer to the include gadgets/page.h)
 *
 * the tag-data of the tag-item PAGE_Pages will hold the pointer to the
 * first node of a linked list of Page-Structures (see gadgets/page.h)
 * every node holds pointer to the pages gadget list, itexts, images and
 * bevel-boxes. the layout will do the page.gadget automatically, your
 * programm only receives an IDCMP_GADGETUP message if the user switched
 * to another page. now you can "ask" the page.gadget using intuitions
 * GetAttrsA() and the PAGE_Active tag which is the new page.
 *
 * important note: the Page-structure list and all the linked list
 * (gadgets, itext etc) should not be modified while the page.gadget is
 * in your window (because every switch will cause a redraw with the
 * actual data of the list so its possible that a page can have
 * several layouts... if you as a programmer want so))
 *
 * the clearRect defines a area in you window, which should be filled
 * with the BACKGROUND pen if the page.gadget switches to another
 * page (try what happens if you set no clear area !!)
 *
 * VERY IMPORTANT NOTE:
 * THE PAGE GADGET _MUST_ BE THE LAST GADGET OF A GADGET LIST. IT
 * ADDS THE "CHILD"-GADGETS OF A PAGE AUTOMATICALLY, BUT AGAIN:
 * PAGE MUST BE THE LAST (NOT THE LEAST ;)
 *
 ******************************************************************/

/******************************************************************
 *
 * the rect to be cleared with every page-switch (since the gadget
 * adapts to windows width the data will be set later)
 *
 */

struct Rectangle clearRect = { 0, 0, 0, 0 };

/******************************************************************
 *
 * data of first page...  only itexts
 *
 */

struct IntuiText itext1_3 = { 2, 0, JAM1, 40, 90, NULL, "Incredible: thats NOT all !", NULL };
struct IntuiText itext1_2 = { 2, 0, JAM1, 40, 80, NULL, "As you can see has every page its own itexts.", &itext1_3 };
struct IntuiText itext1_1 = { 1, 0, JAM1, 40, 60, NULL, "WELCOME TO THE GENIOUS BOOPSI CLASS 'page.gadget'", &itext1_2 };

/******************************************************************
 *
 * data of second page...  itexts AND bevel-boxes
 *
 */

struct IntuiText itext2_2 = { 1, 0, JAM1, 40, 70, NULL, "(where a BB has several Frames/Backgrounds)", NULL };
struct IntuiText itext2_1 = { 1, 0, JAM1, 40, 60, NULL, "You can link a Page with Itexts, BevelBoxes", &itext2_2 };

struct BevelBox bbox2_7 = { NULL,
														400, 90, 50, 50,
														BBFLG_FRAMERIDGE|BBFLG_BACKFILL|BBFLG_PATTERNFILL,
														7, 6, 2, 1 };

struct BevelBox bbox2_6 = { &bbox2_7,
														340, 90, 50, 50,
														BBFLG_FRAMENONE|BBFLG_BACKFILL|BBFLG_PATTERNFILL,
														6, 3, 0, 0 };

struct BevelBox bbox2_5 = { &bbox2_6,
														280, 90, 50, 50,
														BBFLG_FRAMENONE|BBFLG_BACKFILL|BBFLG_PATTERNFILL,
														5, 0, 0, 0 };

struct BevelBox bbox2_4 = { &bbox2_5,
														220, 90, 50, 50,
														BBFLG_FRAMERIDGE|BBFLG_BACKFILL,
														4, 0, 2, 1 };

struct BevelBox bbox2_3 = { &bbox2_4,
														160, 90, 50, 50,
														BBFLG_FRAMEBUTTON|BBFLG_BACKFILL,
														3, 0, 2, 1 };

struct BevelBox bbox2_2 = { &bbox2_3,
														100, 90, 50, 50,
														BBFLG_FRAMERIDGE,
														0, 0, 2, 1 };

struct BevelBox bbox2_1 = { &bbox2_2,
													  40, 90, 50, 50,
														BBFLG_FRAMEBUTTON,
													  0, 0, 2, 1 };

/******************************************************************
 *
 * data of third page...   itext AND a gadget list (createt and
 * linked to this page later)
 *
 */

struct IntuiText itext3_1 = { 1, 0, JAM1, 40, 60, NULL, "...how about to add some gadgets ??", NULL };

/******************************************************************
 *
 * data of fourth page...   itext AND some images
 *
 */

struct IntuiText itext4_1 = { 2, 0, JAM1, 40, 60, NULL, "Great: usage of image-structures :)", NULL };

struct Image image4_2 = { 70, 80, 39, 39, 3, &image_data2[0], 0x1f,0x00, NULL };
struct Image image4_1 = { 110, 100, 95, 39, 3, &image_data1[0], 0x1f, 0x00, &image4_2 };

/******************************************************************
 *
 * data of fivth page...    itexts AND bevel-boxes AND images
 * AND gadgets
 *
 */

struct IntuiText itext5_2 = { 2, 0, JAM1, 30, 55, NULL, "Gadgets, BBoxes, Images, ITexts...", NULL };
struct IntuiText itext5_1 = { 1, 0, JAM1, 30, 45, NULL, "Simply genious: ALL IN ONE", &itext5_2 };

struct BevelBox bbox5_1 = { NULL,
														15, 73, 320, 70,
														BBFLG_FRAMERIDGE|BBFLG_BACKFILL,
														5, 0, 2, 1 };

struct Image image5_1 = { 350, 80, 39, 39, 3, &image_data2[0], 0x1f,0x00, NULL };

/******************************************************************
 *
 * data of the sixth page which demonstrates the hook (the hook
 * structure will be initialized later)
 *
 */

struct IntuiText itext6_3 = { 1, 0, JAM1, 30, 70, NULL, "flashes all screens one time.", NULL };
struct IntuiText itext6_2 = { 1, 0, JAM1, 30, 60, NULL, "Switch to this page calls a hook function which", &itext6_3 };
struct IntuiText itext6_1 = { 2, 0, JAM1, 30, 45, NULL, "This shows how to use a page-private Hook", &itext6_2 };

struct Hook hook6 = { NULL, NULL, NULL, NULL, NULL };

/******************************************************************
 *
 * the pages
 *
 * these five linked structures hold pointers to page-private
 * gadgets, itexts, bevel-boxes, images etc as defined above
 *
 */

struct Page sixthPage = { NULL, "_Hook", FS_NORMAL, NULL, &itext6_1, NULL, NULL, &hook6 };
struct Page fivthPage = { &sixthPage, "_All in one", FSF_BOLD, NULL, &itext5_1, &bbox5_1, &image5_1, NULL };
struct Page fourthPage = { &fivthPage, "_More gfx", FS_NORMAL, NULL, &itext4_1, NULL, &image4_1, NULL };
struct Page thirdPage = { &fourthPage, "_Enhanced usage", FS_NORMAL, NULL, &itext3_1, NULL, NULL, NULL };
struct Page secondPage = { &thirdPage, "_Simple gfx", FS_NORMAL, NULL, &itext2_1, &bbox2_1, NULL, NULL };
struct Page firstPage = { &secondPage, "_Intro", FS_NORMAL, NULL, &itext1_1, NULL, NULL, NULL };

/********************************************************************
 *
 * this is the hook function itself.
 *
 * if page.gadget switches to an other page and finds a hook defined
 * there it will build a hook message an then call the hook.
 * see the include file for the message struct. the hook will be
 * called BEFORE any other rendering is done.
 *
 */

void myHookFunction(struct Hook *hook, struct Gadget *pageGad, struct PageHookObject *pho)
	{
		DisplayBeep(NULL);
	}

/********************************************************************
 *
 * the main programm
 *
 * this opens the page.gadget and gets the class. you dont have to
 * care about the result of PAGE_GetClass if the page.gadget was opened
 * sucessfully (the library initialisator will get the class if you
 * call OpenLibrary, so its shure that you can get the class if the
 * gadget is open)
 *
 * after this the window will be opened and a page gadget will be
 * created using NewObject()
 *
 */

void main(void)
	{

		/* first of all open the page.gadget same way as a shared library
		   (actual version: 1.0) */
		PageBase = (struct PageBase *) OpenLibrary("gadgets/page.gadget", 1L);

		/* test the result */
		if (PageBase)
			{
				/* set these bases... if the page.gadget is open then these
				   values are valid !!! */
				IntuitionBase = PageBase -> page_IntuitionBase;
				GadtoolsBase = PageBase -> page_GadtoolsBase;
				GfxBase = PageBase -> page_GfxBase;
				DiskfontBase = PageBase -> page_DiskfontBase;

				/* open the topaz font for this window (since i am a lazy
				   demo programmer i dont care for your window font :) */
				if (tfont = OpenDiskFont(&tattr))
					{
						/* get the pointer to the class (is always valid if the gadget
						   is successfully open */
						myPageClass = PAGE_GetClass();

						/* open window (sorry not font sensitive for this demo) */
						if (myWindow = OpenWindowTags(NULL,
																					WA_Flags, WFLG_DEPTHGADGET|WFLG_DRAGBAR|
																										WFLG_CLOSEGADGET|WFLG_SIZEGADGET|
																										WFLG_SIZEBBOTTOM,
																					WA_IDCMP, IDCMP_CLOSEWINDOW|IDCMP_GADGETUP|
																										IDCMP_NEWSIZE|IDCMP_VANILLAKEY,
																					WA_InnerWidth, 	470,
																					WA_InnerHeight,	150,
																					WA_Title, "PageGadget DEMO   © 1996 by Jens Tröger",
																					WA_Activate, TRUE,
																					WA_MaxWidth, ~0,
																					TAG_DONE))
							{
								/* set topaz */
								SetFont(myWindow -> RPort, tfont);

								/* now create the page gadget via intuiton.NewObject()
								   ... see below */
								if (myPageGadget = createPageGadget())
									{
										/* create some gadtools-gadgets and link them to the
										   page gadget structure */
										if (thirdPage.FirstGadget = createGadgets())
											{
												fivthPage.FirstGadget = thirdPage.FirstGadget;

												/* add and refresh the page gadget */
												AddGList(myWindow, myPageGadget, -1, -1, NULL);
												RefreshGList(myPageGadget, myWindow, NULL, -1);

												/* really difficult :) */
												printf("\n%s\n\n", PAGE_GetCopyright());

												/* wait for user input */
												while (TRUE)
													{
														/* wait for a message and get it */
														WaitPort((struct MsgPort *) myWindow -> UserPort);
														myIMsg = (struct IntuiMessage *) GetMsg((struct MsgPort *) myWindow -> UserPort);

														/* close the window ??? */
														if (myIMsg -> Class == IDCMP_CLOSEWINDOW)
															{
																ReplyMsg((struct Message *) myIMsg);
																break;
															}

														/* a gadget was clicked... (maybe my page.gadget ???) */
														else if (myIMsg -> Class == IDCMP_GADGETUP)
															{
																/* ... which gadget ??? */
																switch (((struct Gadget *) (myIMsg -> IAddress)) -> GadgetID)
																	{
																		/* page.gadget sends us a IDCMP_GADGETUP which
																		   means it switched to a new page (and already
																		   painted it) */
																		case 1:
																			{
																				ULONG pageNr;

																				/* find out what the new page is */
																				GetAttr(PAGE_Active, myPageGadget, &pageNr);
																				printf("Page: %ld\n", pageNr);

																				/* since these pages use gadtools gadget
																				   we have to care for the gadtools
																				   refresh */
																				if ((pageNr == 2)||(pageNr == 5))
																					{
																						GT_RefreshWindow(myWindow, NULL);
																					}

																				break;
																			}

																		/* any other gadget */
																		case 2:
																		default:
																			{
																				printf("Button Nr: %ld\n", ((struct Gadget *) (myIMsg -> IAddress)) -> GadgetID);
																			}
																	}

																/* you know this */
																ReplyMsg((struct Message *) myIMsg);
															}

														/* the user sized the window so set the size
														   of the page.gadget */
														else if (myIMsg -> Class == IDCMP_NEWSIZE)
															{
																ReplyMsg((struct Message *) myIMsg);

																SetGadgetAttrs(myPageGadget, myWindow, NULL,
																							 GA_Width, myWindow -> Width - (2*(myWindow -> BorderLeft)) - 10L, TAG_DONE);
															}

														/* a key was pressed so look what it was */
														else if (myIMsg -> Class == IDCMP_VANILLAKEY)
															{
																ULONG newSet;

																ReplyMsg((struct Message *) myIMsg);

																switch (myIMsg -> Code)
																	{
																		case 105:
																			{
																				SetGadgetAttrs(myPageGadget, myWindow, NULL,
																											 PAGE_Active, 0L, TAG_DONE);
																				break;
																			}
																		case 115:
																			{
																				SetGadgetAttrs(myPageGadget, myWindow, NULL,
																											 PAGE_Active, 1L, TAG_DONE);
																				break;
																			}
																		case 101:
																			{
																				SetGadgetAttrs(myPageGadget, myWindow, NULL,
																											 PAGE_Active, 2L, TAG_DONE);
																				break;
																			}
																		case 109:
																			{
																				SetGadgetAttrs(myPageGadget, myWindow, NULL,
																											 PAGE_Active, 3L, TAG_DONE);
																				break;
																			}
																		case 97:
																			{
																				SetGadgetAttrs(myPageGadget, myWindow, NULL,
																											 PAGE_Active, 4L, TAG_DONE);
																				break;
																			}
																		case 104:
																			{
																				SetGadgetAttrs(myPageGadget, myWindow, NULL,
																											 PAGE_Active, 5L, TAG_DONE);
																				break;
																			}
																	}
																GetAttr(PAGE_Active, myPageGadget, &newSet);
																printf("Page: %ld\n", newSet);
															}
													}

												/* ok... lez quit */
												FreeGadgets(thirdPage.FirstGadget);
												RemoveGList(myWindow, myPageGadget, -1);
												DisposeObject(myPageGadget);
											}
									}
								CloseWindow(myWindow);
							}
						CloseFont(tfont);
					}
				CloseLibrary((struct Library *) PageBase);
			}
	}

/******************************************************************
 *
 * this creates the page gadget
 *
 */

struct Gadget *createPageGadget(void)
	{
		extern ULONG HookEntry();

		/* set the rect to be cleared with every switch */
		clearRect.MinX = myWindow -> BorderLeft + 10;
		clearRect.MinY = myWindow -> BorderTop + 5 + 19;
		clearRect.MaxX = myWindow -> Width - myWindow -> BorderLeft - myWindow -> BorderRight - 20;
		clearRect.MaxY = 120;

		/* init the hook */
		hook6.h_Entry = HookEntry;
		hook6.h_SubEntry = (APTR) myHookFunction;
		hook6.h_Data = NULL;

		/* create the gadget */
		return (NewObject(myPageClass, NULL,
																	 GA_ID, 1L,
																	 GA_Left, myWindow -> BorderLeft + 5L,
											 						 GA_Top, myWindow -> BorderTop + 5L,
																	 GA_Width, myWindow -> Width - (2*(myWindow -> BorderLeft)) - 10L,
																	 GA_Height, 17L,
																	 GA_RelVerify, TRUE,

																	 PAGE_Pages, &firstPage,
																	 PAGE_Layout, PGLYT_MUISTYLE,
																	 PAGE_ActiveStyle, PGAST_SHADOW,
																	 PAGE_ClearRect, &clearRect,
																	 PAGE_Active, 0L,
																	 PAGE_TextAttr, &tattr,
																	 PAGE_Underscore, 95L,

																	 TAG_END));
	}

/******************************************************************
 *
 * and here we create some gadtools gadgets (buttons only)
 *
 */

struct Gadget *createGadgets(void)
	{
		APTR vi = GetVisualInfo(myWindow -> WScreen, NULL);
		struct Gadget *gadget = NULL, *context = NULL;
		struct NewGadget newGad = { 0, 0, 60, 17,
																"Button", &tattr, 0, PLACETEXT_IN,
																vi, NULL };
		WORD x, y, id = 2;

		if (vi)
			{
				gadget = CreateContext(&gadget);
				context = gadget;

				newGad.ng_TopEdge = myWindow -> BorderTop + 70;
				for (y = 1; y < 4; y++)
					{
						newGad.ng_LeftEdge = myWindow -> BorderLeft + 20;
						for (x = 1; x < 6; x++)
							{
								newGad.ng_GadgetID = id ++;
								gadget = CreateGadgetA(BUTTON_KIND, gadget, &newGad, NULL);
								newGad.ng_LeftEdge += 60;
							}

						newGad.ng_TopEdge += 20;
					}

				if (gadget == NULL)
					{
						FreeGadgets(context);
						context = NULL;
					}

				FreeVisualInfo(vi);
			}

		return (context);
	}

