/* Auslesen und anzeigen eines Hilfe-Strings

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

#include	"gadgethelp.h"

APTR	surface;
struct Screen	*screen;
struct NewWindow *newwin;
struct Window	*window;
struct WizardWindowHandle *winhandle;
struct Gadget *gads[WINDOW_MAIN_GADGETS];

main()
{
	BOOL Flag;

	struct IntuiMessage *msg;

	APTR	helpiaddress;
	struct WizardWindowHandle *helpwinhandle;

	// Erstmal die Oberfl‰chenbeschreibung bereitstellen !
	if ((surface=WZ_OpenSurface("gadgethelp.wizard",0L,TAG_DONE)))
	{

		// Nat¸rlich brauchen wir auch einen Screen oder ?
		if ((screen=LockPubScreen(0L)))
		{

			// Jetzt holen wir uns ein WindowHandle, mit dem unsere Objekte
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
					// Fenster zu ˆffnen. Dabei werden alle Objekte installiert.
					if ((window=WZ_OpenWindow(winhandle,newwin,WA_AutoAdjust,TRUE,
																			TAG_DONE)))
					{
						// Jetzt nur noch dem Betriebssystem mitteilen, das wir
						// den User unterst¸tzen wollen (in Form des Hilfe !!!).
						HelpControl(window,HC_GADGETHELP);

						Flag=TRUE;	// Flag zum Beenden der nachfolgenden Schleife

						do
						{
							// Da wir keine Rechenzeit verschwenden wollen, werden wir
							// das Program "schlafen" legen, bis eine Nachricht
							// eintifft. F¸r Profis gilt, das auch Wait() verwendet
							// werden kann.
							WaitPort(window->UserPort);

							if ((msg=(struct IntuiMessage *)GetMsg(window->UserPort)))
							{
								// Ha, da ist doch tats‰chlich eine Nachricht ange-
								// kommen. Na dann gucken wir mal ob Sie auch vom
								// richtigen Type ist.

								switch(msg->Class)
								{
									case IDCMP_CLOSEWINDOW:
										{
											Flag=FALSE;
										}
										break;

									case IDCMP_GADGETHELP:
										{
											if (msg->IAddress)
											{
												SetWindowTitles(window,WZ_GadgetHelp(winhandle,msg->IAddress),(STRPTR)-1L);
											}
											else
												SetWindowTitles(window,"Auﬂerhalb",(STRPTR)-1L);
										}
										break;
									case IDCMP_MOUSEMOVE:
										{
											// Leider gibts IDCMP_GADGETHELP`s nur
											// ab OS 3.0. Deshalb kann vor OS 3.0
											// diese emuliert werden.

											if (WZ_GadgetHelpMsg(winhandle,&helpwinhandle,&helpiaddress,
																		msg->MouseX,msg->MouseY,NULL))
											{
												// So, es liegt also ein neue Msg vor.

												if (msg->IAddress)
												{
													SetWindowTitles(window,WZ_GadgetHelp(helpwinhandle,helpiaddress),(STRPTR)-1L);
												}
												else
													SetWindowTitles(window,"Auﬂerhalb",(STRPTR)-1L);

											}
										}
										break;
								}

								// Da wir keine Speicherleichen dulden  und
								// das Nachrichtensystem nicht durcheinanden bringen
								// wollen, teilen wir den Betriebssystem mit, das
								// die Nachricht von uns nicht mehr benˆtigt wird.
								ReplyMsg((struct Message *)msg);
							}
						}
						while (Flag);

						// Fenster schlieﬂen
						WZ_CloseWindow(winhandle);
					}
				}

				// In jedem Fall muﬂ ein mit WZ_AllocWindowHandle() angelegter
				// WindowHandle auch wieder freigegeben werden. ‹brigens
				// kann das Fenster hierbei noch offen sein. Probieren Sie es!
				WZ_FreeWindowHandle(winhandle);
			}

			// PublicScreen-Benutzerz‰hler wieder um eins verringern
			UnlockPubScreen(0L,screen);
		}

		// Da wir keine Objekte von dieser Oberfl‰che mehr besitzen und wir diese
		// auch nicht mehr anlegen, geben wir sie frei. ‹brigens noch
		// nicht freigegebene WindowHandles werden hierbei von der
		// wizard.libarry entfernt (Fenster auch geschlossen).
		WZ_CloseSurface(surface);
	}
}