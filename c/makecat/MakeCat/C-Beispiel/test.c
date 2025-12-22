#include <exec/types.h>
#include <exec/libraries.h>
#include <libraries/locale.h>
#include <utility/tagitem.h>

#include <clib/exec_protos.h>
#include <clib/dos_protos.h>

#include <pragmas/exec_pragmas.h>
#include <pragmas/dos_pragmas.h>

/*
 * Die foglende DEFINE-Anweisung darf in einem Projekt nur
 * einmal erscheinen.
 */
#define LOCALE_TEXT

/*
 * Das Include 'test.h' mit MakeCat (Eingabe 'C-Source') übersetzen
 */
#include "test.h"

extern struct Library   *DOSBase;
extern struct Library   *SysBase;

struct Library *LocaleBase=NULL;
struct Catalog *mycatalog=NULL;

char *CatalogName="test.catalog";

/*
 * protos
 */
struct Locale *OpenLocale(STRPTR);
struct Catalog *OpenCatalogA(struct Locale *, STRPTR, APTR);
STRPTR GetLocaleStr( struct Locale *, ULONG );
STRPTR GetCatalogStr(struct Catalog *, LONG, STRPTR );
BOOL   CloseLocale( struct Locale * );
BOOL   CloseCatalog( struct Catalog *);

/*
 * Diese Funktion holt den gewünschten String aus dem Katalog und
 * gibt den Pointer auf diesen zurück. Rufen Sie diese Funktion
 * mit dem Pointer auf die LocText-Struktur auf.
 */
char *GetMyLocaleString(struct Catalog *mycat, struct LocText *loctext ) {
  if( mycat ) {
    GetCatalogStr(mycat,loctext->id,NULL);
  } else return loctext->text;
}


VOID main(ULONG argc, char **argv) {

  if( argc ) {
    /*
     * Nur vom CLI zu starten
     */
    LocaleBase=OpenLibrary("locale.library",38);

    if( LocaleBase )
      mycatalog=OpenCatalogA(NULL,CatalogName,NULL);

    printf("String 1=%s\nString 2=%s\nString 3=%s\n",
            GetMyLocaleString(mycatalog, &FirstText ),
            GetMyLocaleString(mycatalog, &SecondText ),
            GetMyLocaleString(mycatalog, &Bye ));

    if( mycatalog )
      CloseCatalog( mycatalog );

    if( LocaleBase )
      CloseLibrary(LocaleBase);
  }
}
