#ifndef LIBBASE_H
#define LIBBASE_H

#include <exec/libraries.h>

/*
   Dies ist die Basisstruktur für die neue Bibliothek.
   
   Das erste Element ist immer ein struct Library, dann folgen die öffentlich
   zugänglichen Elemente. Private Elemente der Bibliothek sollte man in
   normalen Variablen deklarieren, nicht in dieser Struktur.
*/

struct LibBase {
	struct Library base;
	int last_result;
	
};

#endif
