/* Standard Rumpfprogramm.

   Dieser Quellcode ist der Anfang aller mit StormWizard-Oberflächen
   versehenen Programmen in C oder C++!

   (geschrieben unter StormC V1.1)

   $VER:              1.0 (12.06.96)

   Autor:             Thomas Mittelsdorf

   © 1996 HAAGE & PARTNER Computer GmbH,  All Rights Reserved

*/

#include	<stdio.h>

#include	<clib/alib_protos.h>

#include	<pragma/exec_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/utility_lib.h>
#include	<pragma/wizard_lib.h>

#include	<libraries/wizard.h>
#include	<intuition/gadgetclass.h>
#include	<intuition/intuition.h>

#include	"basis.h"

APTR	surface;
struct Screen	*screen;
struct NewWindow *newwin;
struct Window	*window;
struct WizardWindowHandle *winhandle;
struct Gadget *gads[WINDOW_MAIN_GADGETS];

/* Falls Sie mit einem anderen Entiwcklungssystem als StormC
   arbeiten, müssen zuerst alle Bibliotheken geöffnet und
   am Ende wieder geschlossen werden!
*/
#ifndef __STORM__
struct Library *IntuitionBase;
struct Library *WizardBase;

int init_libraries( void);
void exit_libraries( void);
#endif
/*

*/

void main( void)
{
	BOOL Flag;
	struct IntuiMessage *msg;

	#ifndef __STORM__
	if(! init_libraries( )) // Nur aufrufen, wenn nicht mit StormC kompiliert wird!
		return; 							// Fehler beim Öffnen
	#endif


	// Oberflächenbeschreibung laden!
	if ((surface=WZ_OpenSurface("basis.wizard",0L,TAG_DONE)))
	{

		// Natürlich brauchen wir auch einen Screen.
		if ((screen=LockPubScreen( 0L)))
		{

			// Jetzt reservieren wor ein WindowHandle, mit dem unsere Objekte
			// durch die wizard.library verwaltet werden.
			if ((winhandle=WZ_AllocWindowHandle(screen,0L,surface,TAG_DONE)))
			{

				// Da ein WindowHandle nur Sinn macht, wenn auch die Objekte
				// darin vorkommen, legen wir diese Objekte jetzt an.
				if ((newwin=WZ_CreateWindowObj(winhandle,WINDOW_MAIN,WWH_GadgetArray,gads,
																			WWH_GadgetArraySize,sizeof(gads),
																			TAG_DONE)))
				{

					// Nachdem das glatt ging, versuchen wir unser
					// Fenster zu öffnen. Dabei werden alle Objekte installiert.
					if ((window=WZ_OpenWindow(winhandle,newwin,WA_AutoAdjust,TRUE,
																			TAG_DONE)))
					{
						Flag=TRUE;	// Flag zum Beenden der nachfolgenden Schleife

						do
						{
							// Da wir keine Rechenzeit verschwenden wollen, wird
							// das Program solange "schlafen" legen bis eine Nachricht
							// eintifft. Selbstverständlich kann auch Wait() verwendet
							// werden kann.
							WaitPort(window->UserPort);

							if ((msg=(struct IntuiMessage *)GetMsg(window->UserPort)))
							{
								// Ha, da ist doch tatsächlich eine Message ange-
								// kommen. Na dann gucken wir mal ob Sie auch vom
								// richtigen Type ist.

								switch(msg->Class)
								{
									case IDCMP_CLOSEWINDOW:
										{
											Flag=FALSE;
										}
										break;
								}

								// Da wir keine Speicherleichen dulden und
								// das Nachrichtensystem nicht durcheinander bringen
								// wollen, teilen wir den Betriebssystem mit, das
								// die Nachricht von uns nicht mehr benötigt wird.
								ReplyMsg((struct Message *)msg);
							}
						}
						while (Flag);

						// Fenster schließen
						WZ_CloseWindow(winhandle);
					}
				}

				// In jedem Fall muß ein mit WZ_AllocWindowHandle() angelegter
				// WindowHandle auch wieder freigegeben werden. Übrigens
				// kann das Fenster hierbei noch offen sein. Probieren Sie es!
				WZ_FreeWindowHandle(winhandle);
			}

			// PublicScreen-Benutzerzähler wieder um eins verringern
			UnlockPubScreen(0L,screen);
		}

		// Da wir keine Objekte von dieser Oberfläche mehr besitzen und wir diese
		// auch nicht mehr anlegen, geben wir sie einfach frei. Übrigens noch
		// nicht freigegebene WindowHandles werden hierbei von der
		// wizard.library entfernt. Noch geöffnete Fenster werden dabei auch
		// geschlossen.
		WZ_CloseSurface(surface);
	}
	#ifndef __STORM__
	exit_libraries(); // Nur aufrufen, wenn nicht mit StormC kompiliert wird!
	#endif
}

#ifndef __STORM__
int init_libraries( void)
{

if(! (IntuitionBase = (struct Library *)OpenLibrary("intuition.library",37L)))
	return 0;

if(! (WizardBase = (struct Library *)OpenLibrary("wizard.library",37L)))
	return 0;

return 1;
}

void exit_libraries( void)
{

CloseLibrary((struct Library *) WizardBase);
CloseLibrary((struct Library *) IntuitionBase);
}
#endif
