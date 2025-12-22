/* standard template for a GUI
   Dieser Quellcode ist der Anfang aller mit StormWizard-Oberflächen
   versehenen Programmen in C oder C++!

   (geschrieben unter StormC V1.1)

   $VER:              1.0 (12.06.96)

   Autor:             Thomas Mittelsdorf

   © 1996 HAAGE & PARTNER Computer GmbH,  All Rights Reserved

*/

#include	<stdio.h>

#ifdef __STORMC__
#include	<clib/alib_protos.h>

#include	<pragma/exec_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/utility_lib.h>
#include	<pragma/wizard_lib.h>

#else       // this need for GCC
            // This example open the most used libraries
#include	<proto/exec.h>
#include	<proto/intuition.h>
#include	<proto/utility.h>
#include	<proto/wizard.h>
#include	<proto/graphics.h>
#include	<proto/dos.h>
#include	<proto/asl.h>

#endif

#include	<libraries/wizard.h>
#include	<intuition/gadgetclass.h>
#include	<intuition/intuition.h>

#include	"basis.h"   // include the header stormwizard create

APTR	surface;
struct Screen	*screen;
struct NewWindow *newwin;
struct Window	*window1;
struct WizardWindowHandle *winhandle;
struct Gadget *window1_gads[WINDOW_MAIN_GADGETS]; // a array need for every window you want open

struct Library *WizardBase; //need in file that open the library


/*  when use other develop System as Stormc you need open or close libs by hand
  
 
*/
#ifndef __STORM__

int init_libraries( void);
void exit_libraries( void);
#endif
/*

*/

int main( void)
{
	BOOL Flag;
	struct IntuiMessage *msg;

	#ifndef __STORM__
	if(! init_libraries( )) // Nur aufrufen, wenn nicht mit StormC kompiliert wird!
		return; 							// Fehler beim Öffnen
	#endif

    // load the GUI data
	if ((surface=WZ_OpenSurface("basis.wizard",0L,TAG_DONE)))
	{
        //  we need a screen
	    
		if ((screen=LockPubScreen( 0L)))
		{
            // now alloc a window handle
			if ((winhandle=WZ_AllocWindowHandle(screen,0L,surface,TAG_DONE)))
			{
                // Now we need create a wndow Object WINDOW_MAIN is the ID
                // you give the window in Wizard Editor.make sure
                // your Gadget array is big enough for the window
                // you need this for all windows you want show.

                
			if ((newwin=WZ_CreateWindowObj(winhandle,WINDOW_MAIN,WWH_GadgetArray,gads,
																			WWH_GadgetArraySize,sizeof(gads),
																			TAG_DONE,0)))
				{
                    // now the window can open and show the GUI

					
				if ((window1=WZ_OpenWindow(winhandle,newwin,WA_AutoAdjust,TRUE,
																			TAG_DONE)))
					{
						Flag=TRUE;	// Flag for end the loop
                        // now we set the toggle button to show how set values
                        // WZ_Set is a shorter macro as SetGadAttrs
                        // see in manuals/class_methods.txt what can do
                        WZ_Set(window1_gads[TEST1],window1,WTOGGLEA_Checked,1,0);
						do
						{
							// Now wait for messages.Wait is also possible

							WaitPort(window1->UserPort);

							if ((msg=(struct IntuiMessage *)GetMsg(window1->UserPort)))
							{
								
                                //now a message is come.

								switch(msg->Class)
								{
									case IDCMP_CLOSEWINDOW:
										{
											Flag=FALSE;
										}
										break;
								}

								// now free the message
								ReplyMsg((struct Message *)msg);
							}
						}
						while (Flag);

						// close the window
						WZ_CloseWindow(winhandle);
					}
				}

				// A WZ_AllocWindowHandle() with winhandle must free.
                // its possible to have the window open
				
				WZ_FreeWindowHandle(winhandle);
			}

			// PublicScreen-Benutzerzähler wieder um eins verringern
			UnlockPubScreen(0L,screen);
		}

		// now close the surface
		WZ_CloseSurface(surface);
	}
	#ifndef __STORM__
	exit_libraries(); // Nur aufrufen, wenn nicht mit StormC kompiliert wird!
	#endif
}

#ifndef __STORM__
int init_libraries( void)
{

if(! (WizardBase = (struct Library *)OpenLibrary("wizard.library",37L)))
	return 0;

/*  not need when link with -lauto
if(! (IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",37L)))
	return 0;

if(! (UtilityBase = (struct Library *)OpenLibrary("utility.library",37L)))
	return 0;
if(! (DOSBase = (struct DOSBase *) OpenLibrary("dos.library",37L)))
	return 0;
if(! (GfxBase = OpenLibrary("graphics.library",37L)))
	return 0;
if(! (AslBase = OpenLibrary("asl.library",37L)))
	return 0;
*/
return 1;
}

void exit_libraries( void)
{
CloseLibrary((struct Library *) WizardBase);
/* not need when link with -lauto
CloseLibrary((struct Library *) IntuitionBase);
CloseLibrary((struct Library *) UtilityBase);
CloseLibrary((struct Library *) DOSBase);
CloseLibrary((struct Library *) GfxBase);
CloseLibrary((struct Library *) AslBase);
*/
}
#endif
