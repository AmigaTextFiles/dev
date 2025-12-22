#include <exec/types.h>
#include <exec/libraries.h>
#include <intuition/screens.h>
#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>
#include <intuition/cghooks.h>
#include <intuition/icclass.h>
#include <graphics/gfx.h>
#include <libraries/gadtools.h>
#include <utility/tagitem.h>
#include <utility/hooks.h>
#include <clib/macros.h>
#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/utility.h>
#include <proto/dos.h>
#include <string.h>
#include <dos.h>
#include <dos/dos.h>

#include <graphics/gfxmacros.h>

#include <stdio.h>
#include <string.h>

#include <classes/itemclass.h>
#include <classes/textitemclass.h>
#include <classes/itemlistclass.h>

struct Library *TextLabelBase, *ItemListBase;

struct ItDim {
	WORD Width;
	WORD Height;
};

struct ItOff {
	WORD X;
	WORD Y;
};

struct TagItem il2int1[] = {
	{ILGA_Top, STRINGA_LongVal},
	{TAG_DONE,}
};

struct TagItem il2int2[] = {
	{ILGA_Selected, STRINGA_LongVal},
	{TAG_DONE,}
};

struct TagItem il2prop[] = {
	{ILGA_Top, PGA_Top},
	{ILGA_Total, PGA_Total},
	{ILGA_Visible, PGA_Visible},
	{TAG_DONE,}
};

struct TagItem ic12prop[] = {
	{ILGA_Selected, PGA_Top},
	{ILGA_Total, PGA_Total},
	{TAG_DONE,}
};

struct TagItem ic22prop2[] = {
	{ILGA_Top, PGA_Top},
	{ILGA_Visible, PGA_Visible},
	{ILGA_Total, PGA_Total},
	{TAG_DONE,}
};

struct TagItem prop2il[] = {
	{PGA_Top, ILGA_Selected},
	{TAG_DONE,}
};

struct TagItem prop22il[] = {
	{PGA_Top, ILGA_Top},
	{TAG_DONE,}
};

struct TagItem ic12il[] = {
	{PGA_Top, ILGA_Selected},
	{TAG_DONE,}
};

struct TagItem ic22il[] = {
	{PGA_Top, ILGA_Top},
	{TAG_DONE,}
};

VOID
main(VOID)
{
    Object *im, *im2, *im3, *im4, *im5, *mod, *ic1, *ic2;
    struct Gadget *gad, *integer, *integer2, *prop, *prop2;
    struct Window  *win;
    struct RastPort *rp;
    struct Screen *screen;
    struct DrawInfo *dri;
    UWORD           top, left, height;
    ULONG getwidth;

    /* Make sure we're at least using Version 2.0 */
    if (IntuitionBase = OpenLibrary("intuition.library", 36))
    {
        GfxBase = OpenLibrary("graphics.library", 36);
        UtilityBase = OpenLibrary("utility.library", 36);
        if( TextLabelBase = OpenLibrary( "textitem.class", 0 ) )
        {
        	if( ItemListBase = OpenLibrary( "itemlist.class", 0 ) )
        	{
					printf( "hello2\n" );
        /* Open a window, without system gadgets or IDCMP events */
        screen = LockPubScreen( 0 );
        dri = GetScreenDrawInfo( screen );
        if (win = OpenWindowTags(NULL,
                                 WA_Left, 10,
                                 WA_Top, 10,
                                 WA_Width, 400,
                                 WA_Height, 400,
                                 TAG_DONE))
        {
            /* Cache the pointer to the RastPort */
            rp = win->RPort;

            /* Cache the upper-left coordinates of the window */
            top = win->BorderTop + INTERHEIGHT;
            left = win->BorderRight + INTERWIDTH;

            /* Cache the height of the font */
            height = rp->TxHeight + INTERHEIGHT;


            /* Initialize the custom image class. */
             /* Create a new image structure, using the given string. */
                if (im = NewObject( NULL, "textitemclass",
                                   IA_Name, "Hello How Are You",
                                   IA_DrawInfo, dri,
                                   TAG_DONE))
                {

                		printf( "im\n" );
                		im2 = NewObject( NULL, "textitemclass",
                                   IA_Name, "Fine Thanks",
                                   IA_DrawInfo, dri,
                                   TAG_DONE );
										im3 = NewObject( NULL, "textitemclass",
                                   IA_Name, "Ok",
                                   IA_DrawInfo, dri,
                                   TAG_DONE );
										im4 = NewObject( NULL, "textitemclass",
                                   IA_Name, "See",
                                   IA_DrawInfo, dri,
                                   TAG_DONE );
										im5 = NewObject( NULL, "textitemclass",
                                   IA_Name, "Not",
                                   IA_DrawInfo, dri,
                                   TAG_DONE );
										printf( "im2\n" );
										prop = NewObject( NULL, "propgclass",
																		GA_Top, 10,
																		GA_Left, 110,
																		GA_Width, 10,
																		GA_Height, 45,
																		GA_ID, 1,
																		PGA_NewLook, TRUE,
																		PGA_Visible, 4,
																		TAG_DONE );
										printf( "prop\n" );
										if( gad = NewObject( NULL, "itemlistgadget",
																		GA_Top, 10,
																		GA_Left, 10,
																		GA_Height, 300,
																		GA_Width, 100,
																		GA_ID, 2L,
																		GA_Previous, prop,
																		ICA_TARGET, prop,
																		ICA_MAP, il2prop,
																		ILGA_Selected, 3,
																		ILGA_NumSelectable, NS_ONE,
																		ILGA_Top, 0,
																		ILGA_NoCareShift, TRUE,
																		TAG_DONE ) )
										{
											SetGadgetAttrs( prop, win, 0, ICA_TARGET, gad, ICA_MAP, prop22il, TAG_DONE );
											printf( "gad\n" );
											DoMethod( (Object *)gad, OM_ADDMEMBER, im );
											printf( "add1\n" );
											DoMethod( (Object *)gad, OM_ADDMEMBER, im2 );
											printf( "add2\n" );
											DoMethod( (Object *)gad, OM_ADDMEMBER, im3 );
											DoMethod( (Object *)gad, OM_ADDMEMBER, im4 );
											DoMethod( (Object *)gad, OM_ADDMEMBER, im5 );
											DoMethod( (Object *)gad, OM_ADDMEMBER, NewObject( NULL, "textitemclass",
															                                   IA_Name, "Exactly",
															                                   IA_DrawInfo, dri,
															                                   TAG_DONE ) );
											DoMethod( (Object *)gad, OM_ADDMEMBER, NewObject( NULL, "textitemclass",
															                                   IA_Name, "the greatest",
															                                   IA_DrawInfo, dri,
															                                   TAG_DONE ) );
											DoMethod( (Object *)gad, OM_ADDMEMBER, NewObject( NULL, "textitemclass",
															                                   IA_Name, "demo",
															                                   IA_DrawInfo, dri,
															                                   TAG_DONE ) );
											DoMethod( (Object *)gad, OM_ADDMEMBER, NewObject( NULL, "textitemclass",
															                                   IA_Name, "ever, but",
															                                   IA_DrawInfo, dri,
															                                   TAG_DONE ) );
											DoMethod( (Object *)gad, OM_ADDMEMBER, NewObject( NULL, "textitemclass",
															                                   IA_Name, "its easy to play with to see how",
															                                   IA_DrawInfo, dri,
															                                   TAG_DONE ) );
											DoMethod( (Object *)gad, OM_ADDMEMBER, NewObject( NULL, "textitemclass",
															                                   IA_Name, "it all works",
															                                   IA_DrawInfo, dri,
															                                   TAG_DONE ) );
											DoMethod( (Object *)gad, OM_ADDMEMBER, NewObject( NULL, "textitemclass",
															                                   IA_Name, "btw, Amiga",
															                                   IA_DrawInfo, dri,
															                                   TAG_DONE ) );
											DoMethod( (Object *)gad, OM_ADDMEMBER, NewObject( NULL, "textitemclass",
															                                   IA_Name, "Forever",
															                                   IA_DrawInfo, dri,
															                                   TAG_DONE ) );
											DoMethod( (Object *)gad, OM_ADDMEMBER, NewObject( NULL, "textitemclass",
															                                   IA_Name, "Anybody got any Beer?",
															                                   IA_DrawInfo, dri,
															                                   TAG_DONE ) );
											SetGadgetAttrs( gad, win, 0, ILGA_ItemHeight, 15, TAG_DONE );
											SetGadgetAttrs( gad, win, 0, ILGA_Total, 1, TAG_DONE );
											AddGList( win, prop, -1, -1, NULL );
											printf( "addgad\n" );
											RefreshGList( prop, win, 0, -1 );
											printf( "refresh\n" );
                 					}
                }
            Wait( SIGBREAKF_CTRL_C );
            /*SetGadgetAttrs( gad, win, 0, ILGA_Lock, TRUE, TAG_DONE );
            Wait( SIGBREAKF_CTRL_C );*/
            RemoveGList( win, prop, -1 );
            DisposeObject(gad);
            DisposeObject(prop);
            CloseWindow(win);
        }
        FreeScreenDrawInfo( screen, dri );
        UnlockPubScreen( 0, screen );
        }
        }
        else
        	printf( "fucker\n" );
        CloseLibrary(ItemListBase);
				CloseLibrary(TextLabelBase);
        CloseLibrary(UtilityBase);
        CloseLibrary(GfxBase);
        CloseLibrary(IntuitionBase);
    }
}
