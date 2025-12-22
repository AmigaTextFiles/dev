/*
/       Programm: ASCIIwiz (Wizard-Demo Zwei)
/       Datei:  ASCIIwiz.c
/       Version: 1.0
/       Compiler: StormC3/StormGCC4/SAS C, GNU gcc
/       Oberfläche erstellt mit StormWizard v2.3
/       (überarbeitete Version von Bernd Roesch)
/
/       Aufgaben:       Demo zur Verwendung der wizard.library unter StormC3, StormGCC4,
/                                       SAS C v6.58 und Geek Gadgets gcc v2.95
/       Trivia:         Das Programm ist die Umsetzung von "ASCIImui" mit Hilfe der wizard.library
/
/       Autor: Michael Bergmann, mbergmann-sh@gmx.de
/
/       Hinweise: GNU gcc ohne Overload - noixemul (-noixemul), libnix (-lnix), math (-lm)
/       Aufruf GNU gcc v2.95: gcc -pedantic -Wall -noixemul -lnix -lm -O2 <quelldatei.c> -o <programmname_gcc>
/       Aufruf SAS C v6.58: sc ERRORREXX CPU=68x00 <quelldatei.c> link to <programmname_sas>
/
/       Danksagung: Das Code-Gerüst beruht auf dem gcc-Beispiel für wizard.library von Bernd Roesch
/
/       Bekannte Fehler in v1.0.0:
/       1) Unter AfA/wizard.library v45.1 wird unter StormC/StormGCC ein Teil des Speichers nach Programmende nicht freigegeben
/          winuaeenforcer wirft Hits gegen die StormShell. Das Problem tritt mit wizard.library v 42.100 unter WB 3.9 nicht auf.
/
*/

/* zu ladendes GUI */
char *GUI = "ASCIIwiz.wizard";

/* Versionsstring: */
char *ver = "\0$VER: ASCIIwiz v1.0.0 (28. August 2012) © Michael Bergmann";

/* Einbinden der benötigten System-Headerdateien        */
/* kleine Hilfsfunktionen zur Bestimmung des Compilers, */
/* der compilierten Datei und des Datums der Erstellung */
#include "mbFunctions.h"

/* Macrodefinitionen zur Schnittstelle (StormWizard-generiert) */
#include        "ASCIIwiz.h"

/* Prototypen für eigene Funktionen aus mbFunctions.h */
//void infotext(void);          // Compiler: Infotexte an die Shell
void do_convert(void);

/* StormC3 und SAS/C öffnen und schließen bestimmte Systembibliotheken selbstständig */
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
struct Library *WizardBase;

APTR    surface;
struct Screen   *screen;
struct NewWindow *newwin;
struct Window   *window;                                                        // Bezeichner gemäß Angaben in StormWizard für eigene Programme anpassen!
struct WizardWindowHandle *winhandle;
struct Gadget *gads[WINDOW_MAIN_GADGETS];       // Index gemäß Angaben in StormWizard für eigene Programme anpassen!
struct IntuiMessage *msg;


/*
 * Funktion: do_convert()
 */
void do_convert(void)
{
	char *zeichen;
	getstring(gads[STI_ZEICHEN], &zeichen);

	/*      Zeichen in Zahl umwandeln in ANSI-C */
	/* ascii_code = (int)*zeichen;        */

	setinteger(gads[STI_ASCII], window, (int)*zeichen);
}

int main( void)
{
	BOOL Flag;
//      int ende_count = 0;             // für Zählschleifen des Ende-Buttons/-Menüs
	long result;                            // Rückgabewert des EasyRequesters
	//char *wert = "Fasel"; // Variable für den Inhalt von Stringgadgets

	/* Systembibliotheken Öffnen (nicht für die alte Version 3 von StormC!) */

	if(! init_libraries( ))                 // benötigt, falls nicht mit StormC compiliert
		return 0;                                               // Fehler werfen!



	// Erstmal die Oberflächenbeschreibung bereitstellen!
	if ((surface=WZ_OpenSurface(GUI, 0L,TAG_DONE)))
	{
		// Natürlich brauchen wir auch einen Screen oder?
		if ((screen=LockPubScreen(0L)))
		{

			// Jetzt holen wir uns ein WindowHandle, mit dem unsere Objekte
			// durch die wizard.library verwaltet werden.
			if ((winhandle=WZ_AllocWindowHandle(screen,0L,surface,TAG_DONE)))
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
						Flag=TRUE;      // Flag zum Beenden der nachfolgenden Schleife
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
											ULONG Simselbimsel;
											WZ_LockWindow(winhandle);
											result = WZ_EasyRequestArgs(surface, window, REQ_ENDE, &Simselbimsel);
											WZ_UnlockWindow(winhandle);

											switch(result)
											{
												case 0:
												break;
												/* Beenden */
												case 1:
													Flag = FALSE;
												break;
											}
										}
										break;

									/* Kam die Message von einem Gadget?                                                                     */
									/* (Symbolische Konstanten der Gadgets gemäß Angaben in StormWizard anpassen!) */
									case IDCMP_IDCMPUPDATE:
									{
										switch(GetTagData(GA_ID,0,(struct TagItem *)msg->IAddress))     // Aufrufer unterscheiden
											{
												/* GADGETS */
												case TB_CLEAR:
												{
													/* Hier: Routine zum Löschen der String Inputs*/
													setstring(gads[STI_ZEICHEN], window, "A");
													setinteger(gads[STI_ASCII], window, 65L);
												}
												break;
												case TB_CONVERT:
												{
													/* Hier: Routine zum Umwandeln des Zeichens in seinen ASCII Code */
													do_convert();
												}
												break;
												case STI_ZEICHEN:
												{
													do_convert();
												}
												break;
											}
									}
									break;

									/* Kam die Message von einem Menü?                                                                */
									/* (Symbolische Konstanten der Menüs gemäß Angaben in StormWizard anpassen!) */
									case IDCMP_MENUPICK:
									switch(msg->Code)               // Welcher Eintrag wurde gewählt?
									{
										/* Geht auch so: Menüstruktur über Indizes ansprechen!*/
										/*
										case FULLMENUNUM(0,0,-1):
										{
											ULONG Dummy;
											WZ_LockWindow(winhandle);
											WZ_EasyRequestArgs(surface,window, REQ_ABOUT,&Dummy);
											WZ_UnlockWindow(winhandle);
										}
										break;
										*/

										case SMN_DATEI_ABOUT:
										{
											/* Wizard-generierten Easy-Requester initieren und aufrufen: */
											ULONG Dummy;

											WZ_LockWindow(winhandle);
											result = WZ_EasyRequestArgs(surface, window, REQ_ABOUT, &Dummy);
											WZ_UnlockWindow(winhandle);

											switch(result)
											{
												case 1:
												case 0:
												break;
											}
										}
										break;

										case SMN_DATEI_ENDE:
										{
											ULONG Blafasel;
											WZ_LockWindow(winhandle);
											result = WZ_EasyRequestArgs(surface, window, REQ_ENDE, &Blafasel);
											WZ_UnlockWindow(winhandle);
											switch(result)
											{
												case 0:
												break;
												/* Beenden */
												case 1:
													Flag = FALSE;
												break;
											}
											// Schleife verlassen = Programmende!
										}
										break;
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
		/* Fensterposition für nächsten Programmstart merken! */
		WZ_SnapShot(surface,TAG_DONE);

		// Da wir keine Objekte von dieser Surface mehr besitzen und wir diese
		// auch nicht mehr anlegen geben wir sie frei. Übrigens noch
		// nicht freigegebene WindowHandles werden hierbei von der
		// wizard.libarry entfernt (Fenster auch geschlossen).
		WZ_CloseSurface(surface);
	}

		/* Systembibliotheken schließen (nicht unter StormC!) */
		#ifndef __STORMC__
			exit_libraries(); // aufrufen, falls nicht unter StormC compiliert!
		#endif

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

	if(! (WizardBase = (struct Library *)OpenLibrary("wizard.library",37L)))
	{
		printf("wizard.library konnte nicht geöffnet werden!\n");
		return 0;
	}

/*
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
	if ( WizardBase )
		CloseLibrary((struct Library *) WizardBase);

/*
CloseLibrary((struct Library *) UtilityBase);
CloseLibrary((struct Library *) DOSBase);
CloseLibrary((struct Library *) GfxBase);
CloseLibrary((struct Library *) AslBase);
*/
}


