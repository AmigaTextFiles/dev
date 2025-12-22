;/*
sc Page.c LINK LIB lib:reaction.lib NOSTACKCHECK
quit
*/

/**
 **  This is a simple example testing some of the capabilities
 **  of the clicktab and page layout gadget class.
 **
 **  Best viewed with TabSize = 2, or = 4.
 **/

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>
#include <libraries/gadtools.h>
#include <intuition/intuition.h>
#include <intuition/gadgetclass.h>
#include <graphics/gfxbase.h>
#include <graphics/text.h>
#include <graphics/gfxmacros.h>
#include <utility/tagitem.h>
#include <workbench/startup.h>
#include <workbench/workbench.h>

#include <clib/alib_protos.h>
#include <clib/reaction_lib_protos.h>

#include <clib/intuition_protos.h>
#include <clib/graphics_protos.h>
#include <clib/exec_protos.h>
#include <clib/dos_protos.h>
#include <clib/utility_protos.h>
#include <clib/wb_protos.h>
#include <clib/icon_protos.h>
#include <clib/clicktab_protos.h>
#include <clib/label_protos.h>
#include <clib/layout_protos.h>
#include <clib/listbrowser_protos.h>
#include <clib/string_protos.h>
#include <clib/window_protos.h>

#include <reaction/reaction.h>
#include <reaction/reaction_macros.h>
#include <gadgets/clicktab.h>
#include <images/label.h>
#include <gadgets/layout.h>
#include <gadgets/listbrowser.h>
#include <classes/window.h>

#include <pragmas/clicktab_pragmas.h>
#include <pragmas/label_pragmas.h>
#include <pragmas/layout_pragmas.h>
#include <pragmas/listbrowser_pragmas.h>
#include <pragmas/string_pragmas.h>
#include <pragmas/window_pragmas.h>

IMPORT struct Library *ButtonBase,
                      *ClickTabBase,
                      *LabelBase,
                      *LayoutBase,
                      *ListBrowserBase,
                      *StringBase,
                      *WindowBase;

enum
{
	GID_MAIN=0,
	GID_CLICKTAB,
	GID_PAGE,

	GID_ALIGN1,
	GID_ALIGN2,
	GID_ALIGN3,

	GID_PAGELAY1,
	GID_PAGELAY2,

	GID_COMPANY,
	GID_LASTNAME,
	GID_FIRSTNAME,
	GID_ADD1,
	GID_ADD2,
	GID_CITY,
	GID_STATE,
	GID_ZIPCODE,
	GID_PHONE,
	GID_FAX,

	GID_CUSTOMERS,
	GID_ORDERS,
	GID_DETAILS,
	GID_NEWORD,
	GID_EDITORD,
	GID_DELORD,

	GID_QUIT,
	GID_LAST
};

enum
{
	WID_MAIN=0,
	WID_LAST
};

enum
{
	OID_MAIN=0,
	OID_LAST
};


int main(void)
{
	struct MsgPort *AppPort;

	struct Window *windows[WID_LAST];

	struct Gadget *gadgets[GID_LAST];

	Object *objects[OID_LAST];

	/* special case - reference buttonbase to make sure it autoinit!
	 */
	if ( !ButtonBase )
		return(30);
	else if ( AppPort = CreateMsgPort() )
	{
		struct List *tablabels = ClickTabs("_Contacts","_Orders", NULL);

		if (tablabels)
		{
			struct List CustomersList, OrdersList, DetailsList;

			NewList(&CustomersList);
			NewList(&OrdersList);
			NewList(&DetailsList);

			/* Create the window object.
			 */
			objects[OID_MAIN] = WindowObject,
				WA_ScreenTitle, "ReAction",
				WA_Title, "ReAction Page Example",
				WA_Activate, TRUE,
				WA_DepthGadget, TRUE,
				WA_DragBar, TRUE,
				WA_CloseGadget, TRUE,
				WA_SizeGadget, TRUE,
				WINDOW_IconifyGadget, TRUE,
				WINDOW_IconTitle, "Page",
				WINDOW_AppPort, AppPort,
				WINDOW_Position, WPOS_CENTERMOUSE,
				WINDOW_ParentGroup, gadgets[GID_MAIN] = VGroupObject,
					LAYOUT_DeferLayout, TRUE,
					LAYOUT_SpaceOuter, TRUE,
					LAYOUT_SpaceInner, TRUE,

					LAYOUT_AddChild,  gadgets[GID_CLICKTAB] = ClickTabObject,
						GA_ID, GID_CLICKTAB,
						GA_RelVerify, TRUE,
						CLICKTAB_Labels, tablabels,

						/* Embed the PageObject "inside" the Clicktab
						 * the clicktab's beveling will surround the page.
						 */
						CLICKTAB_PageGroup, gadgets[GID_PAGE] = PageObject,
							/* We will defer layout/render changing pages! */
							LAYOUT_DeferLayout, TRUE,

							PAGE_Add, gadgets[GID_PAGELAY1] = VGroupObject,
								LAYOUT_SpaceOuter, TRUE,
								LAYOUT_SpaceInner, TRUE,

								LAYOUT_AddChild, gadgets[GID_COMPANY] = StringObject,
									GA_ID, GID_COMPANY,
									GA_RelVerify, TRUE,
									GA_TabCycle, TRUE,
									STRINGA_MaxChars, 48,
									STRINGA_TextVal, "",
								StringEnd,
								CHILD_Label, LabelObject, LABEL_Text,"Company", LabelEnd,
								CHILD_MinWidth, 200,

								LAYOUT_AddChild, gadgets[GID_ALIGN1] = HGroupObject,
									LAYOUT_AddChild, gadgets[GID_LASTNAME] = StringObject,
										GA_ID, GID_LASTNAME,
										GA_RelVerify, TRUE,
										GA_TabCycle, TRUE,
										STRINGA_MaxChars, 48,
										STRINGA_TextVal, "",
									StringEnd,
									CHILD_Label, LabelObject, LABEL_Text,"Last", LabelEnd,

									LAYOUT_AddChild, gadgets[GID_FIRSTNAME] = StringObject,
										GA_ID, GID_FIRSTNAME,
										GA_RelVerify, TRUE,
										GA_TabCycle, TRUE,
										STRINGA_MaxChars, 48,
										STRINGA_TextVal, "",
									StringEnd,
									CHILD_Label, LabelObject, LABEL_Text,"First", LabelEnd,
								LayoutEnd,
								CHILD_WeightedHeight, 0,

								LAYOUT_AddChild, gadgets[GID_ADD1] = StringObject,
									GA_ID, GID_ADD1,
									GA_RelVerify, TRUE,
									GA_TabCycle, TRUE,
									STRINGA_MaxChars, 48,
									STRINGA_TextVal, "",
								StringEnd,
								CHILD_Label, LabelObject, LABEL_Text,"Address 1", LabelEnd,

								LAYOUT_AddChild, gadgets[GID_ADD2] = StringObject,
									GA_ID, GID_ADD2,
									GA_RelVerify, TRUE,
									GA_TabCycle, TRUE,
									STRINGA_MaxChars, 48,
									STRINGA_TextVal, "",
								StringEnd,
								CHILD_Label, LabelObject, LABEL_Text,"Address 2", LabelEnd,

								LAYOUT_AddChild, gadgets[GID_ALIGN2] = HGroupObject,
									LAYOUT_AddChild, gadgets[GID_CITY] = StringObject,
										GA_ID, GID_CITY,
										GA_RelVerify, TRUE,
										GA_TabCycle, TRUE,
										STRINGA_MaxChars, 48,
										STRINGA_TextVal, "",
									StringEnd,
									CHILD_Label, LabelObject, LABEL_Text,"City", LabelEnd,
									CHILD_WeightedWidth, 100,

									LAYOUT_AddChild, gadgets[GID_STATE] = StringObject,
										GA_ID, GID_STATE,
										GA_RelVerify, TRUE,
										GA_TabCycle, TRUE,
										STRINGA_MaxChars, 48,
										STRINGA_TextVal, "",
									StringEnd,
									CHILD_Label, LabelObject, LABEL_Text,"State", LabelEnd,
									CHILD_WeightedWidth, 75,

									LAYOUT_AddChild, gadgets[GID_ZIPCODE] = StringObject,
										GA_ID, GID_ZIPCODE,
										GA_RelVerify, TRUE,
										GA_TabCycle, TRUE,
										STRINGA_MaxChars, 24,
										STRINGA_TextVal, "",
									StringEnd,
									CHILD_Label, LabelObject, LABEL_Text,"ZipCode", LabelEnd,
									CHILD_WeightedWidth, 25,
								LayoutEnd,
								CHILD_WeightedHeight, 0,

								LAYOUT_AddChild, gadgets[GID_ALIGN3] = HGroupObject,
									LAYOUT_BevelStyle, BVS_SBAR_VERT,
									LAYOUT_TopSpacing, 2,

									LAYOUT_AddChild, gadgets[GID_PHONE] = StringObject,
										GA_ID, GID_PHONE,
										GA_RelVerify, TRUE,
										GA_TabCycle, TRUE,
										STRINGA_MaxChars, 48,
										STRINGA_TextVal, "",
									StringEnd,
									CHILD_Label, LabelObject, LABEL_Text,"Phone", LabelEnd,

									LAYOUT_AddChild, gadgets[GID_FAX] = StringObject,
										GA_ID, GID_FAX,
										GA_RelVerify, TRUE,
										GA_TabCycle, TRUE,
										STRINGA_MaxChars, 48,
										STRINGA_TextVal, "",
									StringEnd,
									CHILD_Label, LabelObject, LABEL_Text,"Fax", LabelEnd,
								LayoutEnd,
								CHILD_WeightedHeight, 0,
							LayoutEnd,

							PAGE_Add, gadgets[GID_PAGELAY2] = VGroupObject,
								LAYOUT_SpaceOuter, TRUE,
								LAYOUT_SpaceInner, TRUE,

								LAYOUT_AddChild, HGroupObject,
									LAYOUT_SpaceInner, TRUE,
									// customer
									LAYOUT_AddChild, gadgets[GID_CUSTOMERS] = ListBrowserObject,
										GA_ID, GID_CUSTOMERS,
										GA_RelVerify, TRUE,
										LISTBROWSER_Labels, &CustomersList,
										LISTBROWSER_ShowSelected, TRUE,
										LISTBROWSER_HorizontalProp, TRUE,
									ListBrowserEnd,
									CHILD_WeightedWidth, 30,

									LAYOUT_AddChild, VGroupObject,
										LAYOUT_SpaceInner, TRUE,
										// orders
										LAYOUT_AddChild, gadgets[GID_ORDERS] = ListBrowserObject,
											GA_ID, GID_ORDERS,
											GA_RelVerify, TRUE,
											LISTBROWSER_Labels, &OrdersList,
											LISTBROWSER_ShowSelected, TRUE,
											LISTBROWSER_HorizontalProp, TRUE,
										ListBrowserEnd,
										// details
										LAYOUT_AddChild, gadgets[GID_DETAILS] = ListBrowserObject,
											GA_ID, GID_DETAILS,
											GA_RelVerify, TRUE,
											LISTBROWSER_Labels, &DetailsList,
											LISTBROWSER_ShowSelected, TRUE,
											LISTBROWSER_HorizontalProp, TRUE,
										ListBrowserEnd,
									LayoutEnd,
									CHILD_WeightedWidth, 70,

								LayoutEnd,

								LAYOUT_AddChild, HGroupObject,
									LAYOUT_AddChild, gadgets[GID_NEWORD] = ButtonObject,
										GA_ID, GID_NEWORD,
										GA_RelVerify, TRUE,
										GA_Text, "_New Order",
									ButtonEnd,

									LAYOUT_AddChild, gadgets[GID_EDITORD] = ButtonObject,
										GA_ID, GID_EDITORD,
										GA_RelVerify, TRUE,
										GA_Text, "_Edit Order",
									ButtonEnd,

									LAYOUT_AddChild, gadgets[GID_DELORD] = ButtonObject,
										GA_ID, GID_DELORD,
										GA_RelVerify, TRUE,
										GA_Text, "_Delete Order",
									ButtonEnd,

								LayoutEnd,
								CHILD_WeightedHeight, 0,

							LayoutEnd,

						PageEnd,

					ClickTabEnd,

					LAYOUT_AddChild, ButtonObject,
						GA_ID, GID_QUIT,
						GA_RelVerify, TRUE,
						GA_Text,"_Quit",
					ButtonEnd,
					CHILD_WeightedHeight, 0,

				EndGroup,
			EndWindow;

	 	 	/*  Object creation sucessful?
	 	 	 */
			if (objects[OID_MAIN])
			{
				/* Set up inter-group label pagement.
				 */
				SetAttrs( gadgets[GID_PAGELAY1], LAYOUT_AlignLabels,  gadgets[GID_ALIGN1], TAG_DONE);
				SetAttrs( gadgets[GID_ALIGN1], LAYOUT_AlignLabels, gadgets[GID_ALIGN2], TAG_DONE);
				SetAttrs( gadgets[GID_ALIGN2], LAYOUT_AlignLabels, gadgets[GID_ALIGN3], TAG_DONE);

				/*  Open the window.
				 */
				if (windows[WID_MAIN] = (struct Window *) RA_OpenWindow(objects[OID_MAIN]))
				{
					ULONG wait, signal, app = (1L << AppPort->mp_SigBit);
					ULONG done = FALSE;
					ULONG result;
					UWORD code;

				 	/* Obtain the window wait signal mask.
					 */
					GetAttr(WINDOW_SigMask, objects[OID_MAIN], &signal);

					/* Activate the first string gadget!
					 */
//					ActivateLayoutGadget( gadgets[GID_MAIN], windows[WID_MAIN], NULL, gadgets[GID_COMPANY] );

					/* Input Event Loop
					 */
					while (!done)
					{
						wait = Wait( signal | SIGBREAKF_CTRL_C | app );

						if ( wait & SIGBREAKF_CTRL_C )
						{
							done = TRUE;
						}
						else
						{
							while ( (result = RA_HandleInput(objects[OID_MAIN], &code) ) != WMHI_LASTMSG )
							{
								switch (result & WMHI_CLASSMASK)
								{
									case WMHI_CLOSEWINDOW:
										windows[WID_MAIN] = NULL;
										done = TRUE;
										break;

									case WMHI_GADGETUP:
										switch (result & WMHI_GADGETMASK)
										{
											case GID_COMPANY:
											//	printf( "Company: %s\n", ((struct StringInfo *)(gadgets[GID_COMPANY]->SpecialInfo))->Buffer);
												break;

											case GID_QUIT:
												done = TRUE;
												break;
										}
										break;

									case WMHI_ICONIFY:
										RA_Iconify(objects[OID_MAIN]);
										windows[WID_MAIN] = NULL;
										break;

									case WMHI_UNICONIFY:
										windows[WID_MAIN] = (struct Window *) RA_OpenWindow(objects[OID_MAIN]);

										if (windows[WID_MAIN])
										{
											GetAttr(WINDOW_SigMask, objects[OID_MAIN], &signal);
										}
										else
										{
											done = TRUE;	// error re-opening window!
										}
									 	break;
								}
							}
						}
					}
				}

				/* Disposing of the window object will also close the window if it is
				 * already opened, and it will dispose of the layout object attached to it.
				 */
				DisposeObject(objects[OID_MAIN]);
			}

			/* Free the click tab label list.
			 */ 
			FreeClickTabs(tablabels);
		}

		/* close/free the application port.
		 */
		DeleteMsgPort(AppPort);
	}

	return(0);
}
