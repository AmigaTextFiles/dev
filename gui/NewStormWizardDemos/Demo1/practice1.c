/*
/	Programm: Wizard-Demo Eins
/	Datei:	practice1.c
/	Version: 1.0
/	Compiler: StormC3/StormGCC4/SAS C, GNU gcc
/	Oberfläche erstellt mit StormWizard v2.3
/	(überarbeitete Version von Bernd Roesch)
/
/	Aufgaben:	Demo zur Verwendung der wizard.library unter StormC3, (nicht StormGCC4!!),
/					SAS C v6.58, vbcc und Geek Gadgets gcc v2.95
/
/	Autor: Michael Bergmann, mbergmann-sh@gmx.de
/
/	Hinweise: GNU gcc ohne Overload - noixemul (-noixemul), libnix (-lnix), math (-lm)
/	Aufruf GNU gcc v2.95: gcc -pedantic -Wall -O2 -m<680x0> <quelldatei.c> -o <programmname_gcc> -noixemul -lnix -lm
/	Aufruf GNU gcc v3.4.0: gcc -Wall -O2 -m<680x0> <quelldatei.c> -o <programmname_gcc>
/	(gcc v3.4.0 ist eigenwillig in Bexug auf libnix. Das Program compiliert nur mit ixemul!)
/	Aufruf SAS C v6.58: sc ERRORREXX CPU=68x00 <quelldatei.c> link to <programmname_sas>
/	Aufruf VBCC: vc -O3 -cpu=<680x0> practice1.c -o demo_vbcc -c99
/
/	Danksagung: Das Code-Gerüst beruht auf dem gcc-Beispiel für wizard.library von Bernd Roesch
/
/	Bekannte Fehler in v1.0.0:
/	1) Source compiliert nicht unter StormGCC
/	2) unbekanntes Speicherleck zerschießt unter AfA mit wizard.library 45.1 Textteile in langen EasyRequestern!
/	   Verdacht: sprintf() in Funktion infofenster()
/
*/

#include	<stdio.h>
#include <string.h>

#ifdef __STORMC__
#include	<clib/alib_protos.h>

#include	<pragma/exec_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/utility_lib.h>
#include	<pragma/wizard_lib.h>

#else       // wird für StormGCC gebraucht
            // Beispiel für die am häufigsten benutzten Libraries...
            //...in eigenen Programmen um die Includes zusätzlich verwendeter Libraries erweitern!
#ifndef __GNUC__
#include	<proto/exec.h>
#include	<proto/intuition.h>
#include	<proto/utility.h>
#include	<proto/graphics.h>
#include	<proto/dos.h>
#include	<proto/asl.h>
#endif

#ifdef __STORMGCC__
#include	<proto/exec.h>
#include	<proto/intuition.h>
#include	<proto/utility.h>
#include	<proto/graphics.h>
#include	<proto/dos.h>
#include	<proto/asl.h>
#endif

#include	<proto/wizard.h>

#endif

#include	<clib/alib_protos.h>

#include	<pragma/exec_lib.h>
#include	<pragma/intuition_lib.h>
#include	<pragma/utility_lib.h>
#include	<pragma/wizard_lib.h>

#include	<libraries/wizard.h>
#include	<intuition/gadgetclass.h>
#include	<intuition/intuition.h>

#include	"practice1.h"

/* Hilfsvariablen zur Ausgabe von Präprozessoroptionen */
const char date_and_time[] = __DATE__" um "__TIME__;
#ifdef __SASC
const int sasversion = __VERSION__;
const int sasrev = __REVISION__;
#endif

/* Prototypen für eigene Funktionen */
void infotext(void);		// Compiler: Infotexte an die Shell
void infofenster(void);	// Compiler: Infotexte im Programmfenster

/* StormC3 öffnet und schließt Systembibliotheken selbstständig */
/* Für andere Compiler gilt: Bibliotheken "von Hand" öffnen und schließen! */
#ifndef __STORMC__
int init_libraries( void);
void exit_libraries( void);
#endif

/* hier Basiszeiger für verwendete Bibliotheken eintragen */
struct IntuitionBase *IntuitionBase;
#ifdef __SASC
struct Library *UtilitiyBase;
#else
struct UtilityBase *UtilityBase;
#endif

struct Library *WizardBase;

APTR	surface;
struct Screen	*screen;
struct NewWindow *newwin;
struct Window	*window;							// Bezeichner gemäß Angaben in StormWizard für eigene Programme anpassen!
struct WizardWindowHandle *winhandle;
struct Gadget *gads[WINDOW_MAIN_GADGETS];	// Index gemäß Angaben in StormWizard für eigene Programme anpassen!
struct IntuiMessage *msg;

char *ver = "\0$VER: Wizard-Demo Eins v1.0.3 (26.08.2012) © Michael Bergmann";

int main( void)
{
	BOOL Flag;
	int ende_count = 0;		// für Zählschleifen des Ende-Buttons
	long result;				// Rückgabewert des EasyRequesters
	long cycl_value;			// Rückgabewert des Cycle-Gadgets
	long toggle_value;		// Rückgabewert des Toggle-Gadgets
	char *wert = "Fasel";	// Variable für den Inhalt von Stringgadgets

	/* Systembibliotheken Öffnen (nicht für die alte Version 3 von StormC!) */
	#ifndef __STORMC__
	if(! init_libraries( )) 		// benötigt, falls nicht mit StormC compiliert
		return 0; 						// Fehler werfen!
	#endif


	// Erstmal die Oberflächenbeschreibung bereitstellen!
	if ((surface=WZ_OpenSurface("practice1.wizard",0L,TAG_DONE)))
	{
		printf ("Wizard GUI geladen\n");

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
						printf("Fenster wurde geöffnet\n");

						/* Compiler-Infos in die String-Gadgets schreiben */
						infofenster();

						Flag=TRUE;	// Flag zum Beenden der nachfolgenden Schleife
										// TRUE: Schleife läuft weiter
										// FALSE: Schleife wird beendet

						do	// durchlaufe die Schleife solange, bis Abbruchbedingung (Flag = FALSE) erfüllt ist
						{
							// Da wir keine Rechenzeit verschwenden wollen, werden wir
							// das Program "schlafen" legen, bis eine Nachricht
							// eintifft. Für Profis gilt, das auch Wait() verwendet
							// werden kann.
							WaitPort(window->UserPort);

							if ((msg=(struct IntuiMessage *)GetMsg(window->UserPort)))	// Message abholen
							{
								switch(msg->Class)			// IDCMP-Flags unterscheiden:
								{
									case IDCMP_CLOSEWINDOW:	// CloseWindow gedrückt ?
										{
											ULONG Simselbimsel;
											setstring(gads[STI_STRINGINPUT], window, "CloseGadget angeklickt. Das Programm soll beendet werden.");
											WZ_LockWindow(winhandle);
											result = WZ_EasyRequestArgs(surface, window, REQ_ENDE, &Simselbimsel);
											WZ_UnlockWindow(winhandle);
											printf("Ende EasyRequest result = %ld\n", result);
											switch(result)
											{
												case 0:
													setstring(gads[STI_STRINGINPUT], window, "Ende-Dialog: Button ´Abbruch´ gewählt. Das Programm wird fortgesetzt.");
													ende_count = 0;
												break;

												case 1:
													setstring(gads[STI_STRINGINPUT], window, "Ende-Dialog: Button ´Ok!´ gewählt.");
													Flag = FALSE;
													printf("\nCloseWindow gedrückt\nDas Programm wird nun beendet!\n");;
												break;
											}
										}
										break;

									/* Kam die Message von einem Gadget? 						                         */
									/* (Symbolische Konstanten der Gadgets gemäß Angaben in StormWizard anpassen!) */
									case IDCMP_IDCMPUPDATE:
									{
										switch(GetTagData(GA_ID,0,(struct TagItem *)msg->IAddress))	// Aufrufer unterscheiden
											{
												case TXT_TEXTBUTTON:
												{
													setstring(gads[STI_STRINGINPUT], window, "Textbutton gedrückt");
													printf("Textbutton gedrückt\n");
												}
												break;
												case TGL_TOGGLEBUTTON:
												{
													gettoggle(gads[TGL_TOGGLEBUTTON], &toggle_value);
													switch(toggle_value)
													{
														case 0:
															setstring(gads[STI_STRINGINPUT], window, "Toggle-Button Zustand: normal.");
														break;

														case 1:
															setstring(gads[STI_STRINGINPUT], window, "Toggle-Button Zustand: gedrückt.");
														break;
													}
													printf("Togglebutton gedrückt. Wert: %ld\n0 = normal, 1 = gedrückt\n", toggle_value);
												}
												break;
												case CYC_CYCLE:
												{
													printf("Cycle-Gadget verändert\n");
													getcycle(gads[CYC_CYCLE], &cycl_value);			// Index des ausgewählten Eintrags abholen...
													printf("Cycle hat den Wert: %ld\n", cycl_value);
													/* STRINGINPUT in Abhängigkeit zum Wert beschreiben */
													switch(cycl_value)
													{
														case 0:
														{
															strcpy(wert, "Cyclegadget: Wert 0");
															printf("Cyclegadget: Wert 0\n");
															setstring(gads[STI_STRINGINPUT], window, wert);
														}
														break;
														case 1:
														{
															strcpy(wert, "Cyclegadget: Wert 1");
															printf("Cyclegadget: Wert 1\n");
															setstring(gads[STI_STRINGINPUT], window, wert);
														}
														break;
														case 2:
														{
															strcpy(wert, "Cyclegadget: Wert 2");
															printf("Cyclegadget: Wert 2\n");
															setstring(gads[STI_STRINGINPUT], window, wert);
														}
														break;
													}
													break;
													case TXT_BTN_ENDE:
													{
														if(ende_count < 1)
														{
															setstring(gads[STI_STRINGINPUT], window, "Beenden-Button gedrückt. Zum Beenden nochmal anklicken");
															printf("\nBeenden-Button gedrückt\nZum Beenden nochmal anklicken!\n");
															++ende_count;
														}
														else
														{
															Flag = FALSE;
															printf("\nBeenden-Button gedrückt\nDas Programm wurde beendet!\n");
														}
													}
													break;

												}
												break;
												case STI_TEXTEINGABE:
												{
													setstring(gads[STI_STRINGINPUT], window, "Sie haben einen Text eingegeben...");
													printf("String-Input Text verändert\n");
													getstring(gads[STI_TEXTEINGABE], &wert);
													printf("Inhalt: %s\n", wert);
												}
												break;
												case STI_STRINGINPUT:
												{
													printf("String-Input Status verändert\n");
													getstring(gads[STI_STRINGINPUT], &wert);
													printf("Inhalt: %s\n", wert);
												}
												break;
											}
									}
									break;

									/* Kam die Message von einem Menü?  	 				                          */
									/* (Symbolische Konstanten der Menüs gemäß Angaben in StormWizard anpassen!) */
									case IDCMP_MENUPICK:
									switch(msg->Code)		// Welcher Eintrag wurde gewählt?
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

										case MEN_ABOUT:
										{
											/* Wizard-generierten Easy-Requester initieren und aufrufen: */
											ULONG Dummy;

											setstring(gads[STI_STRINGINPUT], window, "About-Menü gewählt");
											WZ_LockWindow(winhandle);
											result = WZ_EasyRequestArgs(surface, window, REQ_ABOUT, &Dummy);
											WZ_UnlockWindow(winhandle);
											printf("EasyRequest result = %ld\n", result);
											switch(result)
											{
												case 1:
													setstring(gads[STI_STRINGINPUT], window, "About-Dialog: Button ´OK´ gewählt");
												break;

												case 0:
													setstring(gads[STI_STRINGINPUT], window, "About-Dialog: Button ´So ein Senf!´ gewählt");
												break;
											}
										}
										break;

										case MEN_ENDE:
										{
											if(ende_count < 1)
											{
												setstring(gads[STI_STRINGINPUT], window, "Beenden-Menü gewählt. Zum Beenden nochmal anklicken");
												printf("\nBeenden-Menü gewählt\nZum Beenden nochmal anklicken!\n");
												++ende_count;
											}
											else
											{
												ULONG Blafasel;
												setstring(gads[STI_STRINGINPUT], window, "Ende-Menü gewählt");
												WZ_LockWindow(winhandle);
												result = WZ_EasyRequestArgs(surface, window, REQ_ENDE, &Blafasel);
												WZ_UnlockWindow(winhandle);
												printf("Ende EasyRequest result = %ld\n", result);
												switch(result)
												{
													case 0:
														setstring(gads[STI_STRINGINPUT], window, "Ende-Dialog: Button ´Abbruch´ gewählt. Das Programm wird fortgesetzt.");
														ende_count = 0;
													break;

													case 1:
														setstring(gads[STI_STRINGINPUT], window, "Ende-Dialog: Button ´Ok!´ gewählt.");
														Flag = FALSE;
														printf("\nBeenden-Button gedrückt\nDas Programm wurde beendet!\n");
													break;
												}
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
						while (Flag);	// ...solange Flag == TRUE: Schleife fortsetzen!

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

		/* Infotexte in der Shell ausgeben */
		infotext();

}	// main() ENDE

/*
 * Funktion: init_libraries()
 * Öffnen von Systembibliotheken
 */
#ifndef __STORMC__
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
#endif

/*
 * Funktion: exit_libraries()
 * Schließen von Systembibliotheken
 */
#ifndef __STORMC__
void exit_libraries( void)
{
CloseLibrary((struct Library *) WizardBase);
/* not need when link with -lauto */
CloseLibrary((struct Library *) UtilityBase);
CloseLibrary((struct Library *) IntuitionBase);
/*
CloseLibrary((struct Library *) UtilityBase);
CloseLibrary((struct Library *) DOSBase);
CloseLibrary((struct Library *) GfxBase);
CloseLibrary((struct Library *) AslBase);
*/
}
#endif

/*
 * Funktion: infotext()
 * Ausgabe von Compilerinformationen an die Shell
 */
void infotext(void)
{
	/* Infos zum verwendeten Compiler ausgeben */

	printf("\nDatei: %s - compiliert  %s Uhr\n",__FILE__, date_and_time);

	/* SAS C */
	#ifdef __SASC
	    printf("Compiler: SAS C, Version %d.%d\n", sasversion, sasrev);
	#endif
	/* StormC 4 */
	#ifdef __STORM__
		printf("Compiler: StormC 3 Revision %ld\n", __STORM__);
	#endif
	#ifdef __STORMGCC__
		printf("Compiler:GNU gcc, Flavour: StormGCC, Version %d.%d\n",__GNUC__, __GNUC_MINOR__);
	#endif
	/* GNU C */
	#ifndef __STORMGCC__
		#ifdef __GNUC__
			#ifdef __GNUC_PATCHLEVEL__
				printf("Compiler: GNU gcc, Version %d.%d Patchlevel %d\n", __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
			#else
				printf("Compiler: GNU gcc, Version %d.%d\n", __GNUC__, __GNUC_MINOR__);
			#endif
		#endif
	#endif

	printf("\n");
}

/*
 * Funktion: infofenster()
 * Ausgabe von Compilerinformationen im Fenster
 */

void infofenster(void)
{
	char puffer[80];
	char *datei = "Datei: unbekannt";
	char *datum = "unbekannt";
	char *compiler = "Compiler: unbekannt";

	// Infos zum verwendeten Compiler ausgeben
	// Strings für Ausgabe zusammenbauen:
	strcpy(datei, __FILE__);
	strcpy(datum, date_and_time);
	strcat(datum, " Uhr");
	// Strings in Gadgets schreiben:
	setstring(gads[FTXT_DATEI], window, datei);
	setstring(gads[FTXT_DATUM], window, datum);
	// Unbekannter Compiler
	setstring(gads[FTXT_COMPILER], window, compiler);
	// SAS C
	#ifdef __SASC
		strcpy(compiler, "SAS/C, Version ");
		sprintf(puffer, "%d", sasversion);	// Integer in String umwandeln für Weiterverarbeitung!
		strcat(compiler,puffer);
		strcat(compiler, ".");
		sprintf(puffer, "%d", sasrev);	// Integer in String umwandeln für Weiterverarbeitung!
		strcat(compiler, puffer);
		setstring(gads[FTXT_COMPILER], window, compiler);
	#endif
	// StormC 3
	#ifdef __STORM__
		strcpy(compiler, "StormC 3, Revision ");
		sprintf(puffer, "%ld", __STORM__);
		strcat(compiler, puffer);
		setstring(gads[FTXT_COMPILER], window, compiler);
	#endif
	// StormGCC (StormC 4)
	#ifdef __STORMGCC__
		strcpy(compiler,"Compiler:GNU gcc, Flavour: StormGCC, Version ");
		sprintf(puffer, "%d", __GNUC__);	// Integer in String umwandeln für Weiterverarbeitung!
		strcat(compiler, puffer);
		strcat(compiler, ".");
		sprintf(puffer, "%d", __GNUC_MINOR__);	// Integer in String umwandeln für Weiterverarbeitung!
		strcat(compiler, puffer);
		setstring(gads[FTXT_COMPILER], window, compiler);
	#endif
	// GNU C
	#ifndef __STORMGCC__
		#ifdef __GNUC__
			strcpy(compiler, "Compiler: GNU gcc, Version ");
			sprintf(puffer, "%d", __GNUC__);	// Integer in String umwandeln für Weiterverarbeitung!
			strcat(compiler, puffer);
			strcat(compiler, ".");
			sprintf(puffer, "%d", __GNUC_MINOR__);	// Integer in String umwandeln für Weiterverarbeitung!
			strcat(compiler, puffer);
			setstring(gads[FTXT_COMPILER], window, compiler);
		#endif
	#endif
	// VBCC
	#ifdef __VBCC__
		strcpy(compiler, "Volker Bartel's Cross Compiler (VBCC) ");
		setstring(gads[FTXT_COMPILER], window, compiler);
	#endif

}

