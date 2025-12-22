#ifndef door_io_pragmas
#define door_io_pragmas
#include "door_io_pragmas.h"
#endif

#include <exec/types.h>

//----------------------------- BOX_start --------------------------------------
// initialisierung des interfaces 
// vor der init. darf keine der anderen 
// funktionen aufgerufen werden
// die hookfunktionen MÜSSEN mit __saveds (__geta4 ) deklariert sein
// clhook     -> Hookfunktion, bei Carrier Loss
// exthandler -> Hookfunktion, bei auftreten eines signals in der extmask
// extmask    -> selbige sigmask :)
// metaon     -> TRUE : "#" auswerten FALSE :  "#" nicht auswerten

void BOX_start(	void (*clhook)(void),		
						void (*exthandler)(void),	
						int extmask,				
						int metaon);					

//---------------------------- BOX_stop ---------------------------------------
// abschalten des interfaces
// danach keine anderen funktionen aufrufen !
void BOX_stop(void);


//---------------------------- BOX_print --------------------------------------
// String ausgeben 
// - wenn bei BOX_start "metaon" auf TRUE gesetzt wurde, dann werden
//   folgende metazeichen expandiert:
//   #0 -> color black
//   #1 -> color red
//   #2 -> color green
//   #3 -> color blue
//   #4 -> color yellow
//   #5 -> color magenta
//   #6 -> color cyan
//   #7 -> color white
//   #n -> CR/LF
//   #s -> standard colors
// 
// - Der interne Stringbuffer ist 1KB groß, deshalb darf der expandierte
//   String nicht größer sein
void BOX_print(char *text);


//--------------------------- BOX_getstr -------------------------------------
// String einlesen 
// - wenn die angegebene Signalmaske zutrifft,
//   wird die mit BOX_start eingestellte Hookfunktion aufgerufen
// - falls carrierloss stattfindet, wird ebenfalls die zugehörige Hookfunktion
//   aufgerufen.
// - Bei einem carrier-loss muß BOX_stop aufgerufen werden, um alle resourcen
//   freizugeben.
// - CR/LF werden entfernt
// - es werden maximal 255 zeichen eingelesen
void BOX_getstr(char *text);

//--------------------------- BOX_setmask -----------------------------------
//verändern der signalmaske des Wait() in BOX_getstr() und BOX_getchrs()
void BOX_setmask(int extmask);


//--------------------------- BOX_getchrs -----------------------------------
// zeicheneingabe mit laengenangabe
// wie BOX_getstr, nur daß man die zu lesende Länge angeben kann. 
void BOX_getchrs(char *text, int len);


//--------------------------- BOX_wgetchar ----------------------------------
// ein zeichen lesen mit angabe einer signalmaske, die 
// auch zum abbruch des Reads führt
// - returncode = 2 -> ein signalbit wurde gesetzt
//   (es wird keine Hookfunktion aufgerufen !)
// - returncode = 0 -> carrier loss
//   (es wird keine Hookfunktion aufgerufen !)
// alles andere -> taste wurde gedrückt
char BOX_wgetchar(int mask);
