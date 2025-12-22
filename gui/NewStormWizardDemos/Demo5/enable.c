/*
/       Programm: ASLrequest (Wizard-Demo 5)
/       Datei:  enable.c
/       Version: 1.0
/       Compiler: StormC3/StormGCC4/SAS C, GNU gcc
/       Oberfläche erstellt mit StormWizard v2.3
/       (überarbeitete Version von Bernd Roesch)
/
/       Aufgaben:       Demo zur Verwendung der wizard.library unter StormC3, StormGCC4,
/                                       SAS C v6.58 und Geek Gadgets gcc v2.95
/       Trivia:         Das Programm illustriert die Manipulation von Gadgets zur Laufzeit
/
/       Autor: Michael Bergmann, mbergmann-sh@gmx.de
/
/       Hinweise: GNU gcc ohne Overload - noixemul (-noixemul), libnix (-lnix), math (-lm)
/       Aufruf GNU gcc v2.95: gcc -pedantic -Wall -noixemul -lnix -lm -O2 <quelldatei.c> -o <programmname_gcc>
/       Aufruf SAS C v6.58: sc ERRORREXX CPU=68x00 <quelldatei.c> link to <programmname_sas>
*/

/* zu ladendes GUI */
char *GUI = "enable.wizard";

/* Versionsstring: */
char *ver = "\0$VER: enable  v1.0.0 (28. September 2012) © Michael Bergmann";

/* Einbinden der benötigten System-Headerdateien        */
#include "mbHeaders.h"

/* Macrodefinitionen zur Schnittstelle (StormWizard-generiert) */
#include "enable.h"

/* Makros, die das Leben leichter machen... */
#define setDisableGadget(gad, win) SetGadgetAttrs((gad),(win),NULL,GA_Disabled,TRUE, TAG_DONE)
#define setEnableGadget(gad, win) SetGadgetAttrs((gad),(win),NULL,GA_Disabled,FALSE, TAG_DONE)

/* Prototypen für eigene Funktionen: */


/* StormC3 und SAS/C öffnen und schließen bestimmte Systembibliotheken b. B. selbstständig */
/* Für andere Compiler gilt: Bibliotheken "von Hand" öffnen und schließen! */
int init_libraries( void);
void exit_libraries( void);


/* hier Basiszeiger für verwendete Bibliotheken eintragen */
struct IntuitionBase *IntuitionBase;
#ifdef __SASC
struct Library *UtilitiyBase;
#else
struct UtilityBase *UtilityBase;
#endif
struct Library *AslBase;
struct Library *WizardBase;

APTR   surface;
struct Screen   *screen;
struct NewWindow *newwin;
struct Window   *window;                        // Bezeichner gemäß Angaben in StormWizard für eigene Programme anpassen!
struct WizardWindowHandle *winhandle;
struct Gadget *gads[WINDOW_MAIN_GADGETS];       // Index gemäß Angaben in StormWizard für eigene Programme anpassen!
struct IntuiMessage *msg;


/* Struktur für EasyReQuest */
#define NO 0
#define YES 1
/* Easy Requester Frage */
   struct EasyStruct myreq = {
     sizeof(struct EasyStruct),
     0,
     "Button disabled/enabled",
     "Der Zustand des Gadgets wurde verändert.",
     "Ach, wie schön!|Mir doch egal..."
   };

/*
 *	main()
 */
int main( void)
{
	BOOL Flag;
	long result;                            // Rückgabewert des EasyRequesters
	long wert;										 // Rückgaewert des Toggle-Gadgets

	/* Systembibliotheken Öffnen (nicht für die alte Version 3 von StormC!) */
	if(! init_libraries( ))                 // benötigt, falls nicht mit StormC compiliert
		return 0;                            // Fehler werfen!

	// Erstmal die Oberflächenbeschreibung bereitstellen!
	if ((surface=WZ_OpenSurface(GUI, 0L, TAG_DONE)))
	{
		// Natürlich brauchen wir auch einen Screen oder?
		if ((screen=LockPubScreen(0L)))
		{

			// Jetzt holen wir uns ein WindowHandle, mit dem unsere Objekte
			// durch die wizard.library verwaltet werden.
			if ((winhandle=WZ_AllocWindowHandle(screen,0L, surface,TAG_DONE)))
			{

				// Da ein WindowHandle nur Sinn macht, wenn auch die Objekte
				// darin vorkommen, legen wir diese Objekte jetzt an.
				if ((newwin=WZ_CreateWindowObj(winhandle,WINDOW_MAIN,WWH_GadgetArray,(int)gads,
																							WWH_GadgetArraySize,(int)sizeof(gads),
																							TAG_DONE)))
				{

					// Nachdem das glatt ging, versuchen wir unser
					// Fenster zu öffnen. Dabei werden alle Objekte installiert.
					if ((window=WZ_OpenWindow(winhandle,newwin,WA_AutoAdjust,TRUE,
																			TAG_DONE)))
					{
						Flag=TRUE;   // Flag zum Beenden der nachfolgenden Schleife
										// TRUE: Schleife läuft weiter
									  // FALSE: Schleife wird beendet

						do      // durchlaufe die Schleife solange, bis Abbruchbedingung (Flag = FALSE) erfüllt ist
						{
							// Da wir keine Rechenzeit verschwenden wollen, werden wir
							// das Program "schlafen" legen, bis eine Nachricht
							// eintifft. Für Profis gilt, das auch Wait() verwendet
							// werden kann.
							WaitPort(window->UserPort);

							if ((msg=(struct IntuiMessage *)GetMsg(window->UserPort)))      // Message abholen
							{
								switch(msg->Class)                      // IDCMP-Flags unterscheiden:
								{
									case IDCMP_CLOSEWINDOW: // CloseWindow gedrückt ?
										{
											Flag = FALSE;
										}
										break;

									/* Kam die Message von einem Gadget?                                           */
									/* (Symbolische Konstanten der Gadgets gemäß Angaben in StormWizard anpassen!) */
									case IDCMP_IDCMPUPDATE:
									{
										switch(GetTagData(GA_ID,0,(struct TagItem *)msg->IAddress))     // Aufrufer unterscheiden
											{
												/* GADGETS */
												case BT_EINS:
												{
													SetGadgetAttrs(gads[BT_ZWEI], window, NULL,GA_Disabled, FALSE, TAG_END);
													SetGadgetAttrs(gads[BT_EINS], window, NULL,GA_Disabled, TRUE, TAG_END);
													WZ_LockWindow(winhandle);
													result = EasyRequest(window, &myreq, NULL, NULL);
													WZ_UnlockWindow(winhandle);
												}
												break;
												case BT_ZWEI:
												{
													/*
													* SetGadgetAttrs(gads[BT_EINS], window, NULL,GA_Disabled, FALSE, TAG_END);
													* SetGadgetAttrs(gads[BT_ZWEI], window, NULL,GA_Disabled, TRUE, TAG_END);
													*
													*	Klappt auch sehr schön mit Macros:
													*/
													setEnableGadget(gads[BT_EINS], window);
													setDisableGadget(gads[BT_ZWEI], window);
													WZ_LockWindow(winhandle);
													result = EasyRequest(window, &myreq, NULL, NULL);
													WZ_UnlockWindow(winhandle);
												}
												break;
												case TG_SLIDE:
												{
													gettoggle(gads[TG_SLIDE], &wert);
													switch(wert)
													{
														case 0:
															setDisableGadget(gads[HSL_ZAHL], window);
															setDisableGadget(gads[IG_ZAHL], window);
														break;
														case 1:
															setEnableGadget(gads[HSL_ZAHL], window);
															setEnableGadget(gads[IG_ZAHL], window);
															// SetGadgetAttrs(gads[TG_SLIDE], window, NULL,WGA_Label, "Disable", TAG_END);
														break;
													}
												}
												break;

											}
									}
									break;

									/* Kam die Message von einem Menü?                                           */
									/* (Symbolische Konstanten der Menüs gemäß Angaben in StormWizard anpassen!) */
									case IDCMP_MENUPICK:
									switch(msg->Code)               // Welcher Eintrag wurde gewählt?
									{
										;
									}

								}

								// Da wir keine Speicherleichen dulden und
								// das Nachrichtensystem nicht durcheinanden bringen
								// wollen, teilen wir den Betriebssystem mit, das
								// die Nachricht von uns nicht mehr benötigt wird.
								ReplyMsg((struct Message *)msg);
							}
						}
						while (Flag);   // ...solange Flag == TRUE: Schleife fortsetzen!

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
		/* Fensterposition für nächsten Start merken*/
		WZ_SnapShot(surface,TAG_DONE);

		// Da wir keine Objekte von dieser Surface mehr besitzen und wir diese
		// auch nicht mehr anlegen geben wir sie frei. Übrigens noch
		// nicht freigegebene WindowHandles werden hierbei von der
		// wizard.libarry entfernt (Fenster auch geschlossen).
		WZ_CloseSurface(surface);
	}

		/* Systembibliotheken schließen (nicht unter StormC!) */
			exit_libraries();

}       // main() ENDE


/*
 * Funktion: init_libraries()
 * Öffnen von Systembibliotheken
 */
int init_libraries( void)
{
	/*  nicht zwingend benötigt, wenn gcc mit -lauto aufgerufen wird */
	if(! (IntuitionBase = (struct IntuitionBase *)OpenLibrary("intuition.library",37L)))
	{
		printf("intuition.library konnte nicht geöffnet werden!\n");
		return 0;
	}
	#ifdef __SASC
	if(! (UtilityBase = (struct Library *)OpenLibrary("utility.library",37L)))
	#else
	if(! (UtilityBase = (struct UtilityBase *)OpenLibrary("utility.library",37L)))
	#endif
	{
		printf("utility.library konnte nicht geöffnet werden!\n");
		return 0;
	}
	if(! (AslBase = (struct Library *)OpenLibrary("asl.library",37L)))
	{
		printf("asl.library konnte nicht geöffnet werden!\n");
		return 0;
	}

	if(! (WizardBase = (struct Library *)OpenLibrary("wizard.library",37L)))
	{
		printf("wizard.library konnte nicht geöffnet werden!\n");
		return 0;
	}
	return 1;
}


/*
 * Funktion: exit_libraries()
 * Schließen von Systembibliotheken
 */

void exit_libraries( void)
{
	if ( IntuitionBase )
		CloseLibrary((struct Library *) IntuitionBase);
	if ( UtilityBase )
		CloseLibrary((struct Library *) UtilityBase);
	if ( AslBase )
		CloseLibrary((struct Library *) AslBase);
	if ( WizardBase )
		CloseLibrary((struct Library *) WizardBase);
}


