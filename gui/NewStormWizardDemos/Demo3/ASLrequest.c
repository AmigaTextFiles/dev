/*
/       Programm: ASLrequest (Wizard-Demo Drei)
/       Datei:  ASLrequest.c
/       Version: 1.0
/       Compiler: StormC3/StormGCC4/SAS C, GNU gcc
/       Oberfläche erstellt mit StormWizard v2.3
/       (überarbeitete Version von Bernd Roesch)
/
/       Aufgaben:       Demo zur Verwendung der wizard.library unter StormC3, StormGCC4,
/                                       SAS C v6.58 und Geek Gadgets gcc v2.95
/       Trivia:         Das Programm illustriert den Umgang mit ASL-Requestern und Stringfelderny
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
char *GUI = "ASLrequest.wizard";

/* Versionsstring: */
char *ver = "\0$VER: ASLrequest v1.0.0 (28. August 2012) © Michael Bergmann";

/* Einbinden der benötigten System-Headerdateien        */
#include "mbHeaders.h"

/* Macrodefinitionen zur Schnittstelle (StormWizard-generiert) */
#include        "ASLrequest.h"

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
struct Window   *window;                                                        // Bezeichner gemäß Angaben in StormWizard für eigene Programme anpassen!
struct WizardWindowHandle *winhandle;
struct Gadget *gads[WINDOW_MAIN_GADGETS];       // Index gemäß Angaben in StormWizard für eigene Programme anpassen!
struct IntuiMessage *msg;

/* ASL-Requester: */
struct FileRequester *request;	// Instanz des ASL-File-/Dateirequesters
UBYTE fname[255];						// Variable für Pfad-/Dateiname

/* Struktur für EasyReQuest */
#define NO 0
#define YES 1
/* Easy Requester Frage */
   struct EasyStruct myreq = {
     sizeof(struct EasyStruct),
     0,
     "Easy Request ohne Wizard!",
     "Na, kommen Sie zurecht?",
     "Ja freilich!|Ach nööö..."
   };

/*
 *	main()
 */
int main( void)
{
	BOOL Flag;
	long result;                            // Rückgabewert des EasyRequesters

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

									/* Kam die Message von einem Gadget?                                           */
									/* (Symbolische Konstanten der Gadgets gemäß Angaben in StormWizard anpassen!) */
									case IDCMP_IDCMPUPDATE:
									{
										switch(GetTagData(GA_ID,0,(struct TagItem *)msg->IAddress))     // Aufrufer unterscheiden
											{
												/* GADGETS */
												case BT_EASYREQUEST:
												{
												  /* Display question and depending on answer give a response in another requester */
												  if(EasyRequest(window, &myreq, NULL, NULL)==YES)
												  {
														puts("EasyRequester Antwort: Ja\n");
													}
												  else
												  {
														puts("EasyRequester Antwort: Nein\n");
													}
												}
												break;
												case VB_VERZEICHNIS:
												{
													//setstring(gads[STI_VERZEICHNIS], window, "");
													/* Hier: Routine zum Öffnen eines ASL-Verezichnis-Requesters */
													/* TODO: Ausgabe in ein Stringfield. Wie geht das? */

													/* Variable für Pfad leeren, sonst werden bei mehrfacher Auswahl */
													/* alle Pfade aneinandergehängt!                                 */
													strcpy(fname, "");

													/* FileRequester Structure anlegen */
    												request = (struct FileRequester *)AllocAslRequestTags(ASL_FileRequest,
      											ASL_Hail, "Öffne Verzeichnis", (struct TagItem *)TAG_DONE);

    												/* ...jetzt Verzeichnis-Requester anzeigen */
    												if (AslRequestTags(request,
      											ASLFR_Window, window, 		// hier Zeiger auf das aufrufende Fenster eintragen!
      											ASLFR_SleepWindow,TRUE,		// aufrufendes Fenster sperren - modaler Modus, Mousepointer wird "busy"...
      											ASLFR_InitialLeftEdge, 20,	// initiale Koordinaten
      											ASLFR_InitialTopEdge, 20,
      											ASLFR_InitialWidth, 300,	// initiale Abmessungen
      											ASLFR_InitialHeight, 350,
      											ASLFR_DrawersOnly, TRUE,				// nur Verzeichnisse anzeigen
      											ASLFR_InitialDrawer, "Libs:",	// Startverzeichnis
      											ASLFR_PositiveText, "Öffnen",			// Beschriftung linker Button	(accept)
      											ASLFR_NegativeText, "Vergiss es!", 	// Beschriftung rechter Button (reject)

      											ASLFR_Activate, TRUE,	// erst ab WB 3.9

      											(struct TagItem *)TAG_DONE))
      											{
       												/* Pfadnamen zusammenbauen */
      												strcat( fname, request->rf_Dir);
      												if (fname[strlen(fname)-1] != (UBYTE)58) /* Check for : */
         												strcat(fname, "/");

      												strcat(fname, request->rf_File);

      												/* Pfad anzeigen */
      												setstring(gads[STI_VERZEICHNIS], window, fname);
   												}

   												/* Requester-Structure freigeben! */
   												if (request) FreeAslRequest(request);

												}
												break;
												case VB_DATEI:
												{
													//setstring(gads[STI_DATEI], window, "");
													/* Hier: Routine zum Öffnen eines ASL-Datei-Requesters */
													/* TODO: Ausgabe in ein Stringfield. Wie geht das? */

													/* Variable für Pfad leeren, sonst werden bei mehrfacher Auswahl */
													/* alle Pfade aneinandergehängt!                                 */
													strcpy(fname, "");

													/* FileRequester Structure anlegen */
    												request = (struct FileRequester *)AllocAslRequestTags(ASL_FileRequest,
      											ASL_Hail, "Öffne Datei", (struct TagItem *)TAG_DONE);

    												/* ...Datei-Requester anzeigen */
    												if (AslRequestTags(request,
      											ASLFR_Window, window,
      											ASLFR_SleepWindow,TRUE,
      											ASLFR_InitialLeftEdge, 20,
      											ASLFR_InitialTopEdge, 20,
      											ASLFR_InitialWidth, 300,
      											ASLFR_InitialHeight, 350,
      											ASLFR_RejectIcons, TRUE,				// Icons nicht anzeigen
      											ASLFR_InitialDrawer, "Libs:",
      											ASLFR_InitialFile, "wizard.library",
      											ASLFR_InitialPattern, (ULONG)"~rexx#?|math#?",
      											ASLFR_DoPatterns,TRUE,					// Dateifilter-Stringgadget anzeigen
      											ASLFR_RejectPattern, (ULONG)"~rexx#?|math#?",

      											ASLFR_PositiveText, "Öffnen",
      											ASLFR_NegativeText, "Vergiss es!",

      											(struct TagItem *)TAG_DONE))
      											{
       												/* Pfadnamen zusammenbauen */
      												strcat( fname, request->rf_Dir);
      												if (fname[strlen(fname)-1] != (UBYTE)58) /* Check for : */
         												strcat(fname, "/");

      												strcat(fname, request->rf_File);

      												/* Pfad anzeigen */
      												setstring(gads[STI_DATEI], window, fname);
   												}

   												/* Requester-Structure freigeben! */
   												if (request) FreeAslRequest(request);
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

										case MN_DATEI_SUB_ABOUT:
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

										case MN_DATEI_SUB_END:
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
	if ( AslBase )
		CloseLibrary((struct Library *) AslBase);
	if ( WizardBase )
		CloseLibrary((struct Library *) WizardBase);

/*
CloseLibrary((struct Library *) UtilityBase);
CloseLibrary((struct Library *) DOSBase);
CloseLibrary((struct Library *) GfxBase);
CloseLibrary((struct Library *) AslBase);
*/
}


