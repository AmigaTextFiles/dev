/* Auslesen des Konfigurationsstrings.

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

#include	"config.h"

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


	// Erstmal die Oberflächenbeschreibung bereitstellen !
	if ((surface=WZ_OpenSurface("config.wizard",0L,TAG_DONE)))
	{

		// Natürlich brauchen wir auch einen Screen oder ?
		if ((screen=LockPubScreen(0L)))
		{

			// Jetzt holen wir uns ein WindowHandle, mit dem unsere Objekt
			// durch die wizard.library verwaltet werden.
			if ((winhandle=WZ_AllocWindowHandle(screen,0L,surface,TAG_DONE)))
			{

				// Da ein WindowHandle nur Sinn macht, wenn auch die Objekte
				// darin vorkommen, legen wir diese Objecte jetzt an.
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
							// Da wir keine Rechenzeit verschwenden wollen, werden wir
							// das Program schlafen legen, bis eine Nachricht
							// eintifft. Für Profis gilt, das auch Wait() verwendet
							// werden kann.
							WaitPort(window->UserPort);

							if ((msg=(struct IntuiMessage *)GetMsg(window->UserPort)))
							{
								// Ha, da ist doch tatsächlich eine Nachricht ange-
								// kommen. Na dann gucken wir mal ob Sie auch vom
								// richtigen Type ist.

								switch(msg->Class)
								{
									case IDCMP_CLOSEWINDOW:
										{
											Flag=FALSE;
										}
										break;

									case IDCMP_IDCMPUPDATE:
										{
											switch(GetTagData(GA_ID,0,(struct TagItem *)msg->IAddress))
											{
												case MAIN_BUTTON_FIRST:
													{
														SetGadgetAttrs(gads[MAIN_ARGS_CONFIGDISPLAY],window,0,
																							WARGSA_Arg0,WZ_GadgetConfig(winhandle,gads[MAIN_BUTTON_FIRST]),
																							TAG_DONE);
													}
													break;
												case MAIN_BUTTON_SECOND:
													{
														SetGadgetAttrs(gads[MAIN_ARGS_CONFIGDISPLAY],window,0,
																							WARGSA_Arg0,WZ_GadgetConfig(winhandle,gads[MAIN_BUTTON_SECOND]),
																							TAG_DONE);
													}
													break;
											}
										}
										break;
								}

								// Da wir keine Speicherleichen dulden und
								// das Nachrichtensystem nicht durcheinanden bringen
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
		// auch nicht mehr anlegen. Geben Sie wir damit frei. Übrigens noch
		// nicht freigegebene WindowHandles werden hierbei von der
		// wizard.libarry entfernt (Fenster auch geschlossen).
		WZ_CloseSurface(surface);
	}
}