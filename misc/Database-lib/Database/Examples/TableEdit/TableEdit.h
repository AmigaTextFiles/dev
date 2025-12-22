#ifndef _TABLEEDIT_H_
#define _TABLEEDIT_H_ 1
/* TableEdit.h
 *
 * This is a shell-tool for general access to DataTables.
 *	The DataTable has to be created and opened at the application entry, and
 * this module is linked against that application and allows to do several
 * manipulations to that DataTable:
 *
 * The Table may be browsed (define BROWSER_PAGE_LENGTH with the number of
 * lines that should be displayed at a time, before the user is requested
 * to hit RETURN to continue browsing, default is 40).
 *
 * Any record may be displayed, by jumping direct to it.
 *
 * The current order may be changed.
 *
 * New records could be added, existing records could be removed or changed.
 */
#ifndef _DEFINES_H_
#include <joinOS/exec/defines.h>
#endif

#ifndef _AMIGADOS_H_
#include <joinOS/dos/AmigaDOS.h>
#endif

#ifndef _DATABASE_DATASERVER_H_
#include <joinOS/database/DataServer.h>
#endif

#ifndef _DATABASE_INDEX_H_
#include <joinOS/database/Index.h>
#endif

/***************************************************************************/
/*																									*/
/*									Public functions											*/
/*																									*/
/***************************************************************************/

void PrintDBError (struct DataServer *server);

BOOL __saveds __asm ReIndexNotify ( register __a0 struct IDXHeader *ihd,
												register __d0 ULONG recCount,
												register __a1 STRPTR indexName);

BOOL AddOpenTable (APTR tableEd, struct DataServer *server);
struct DataServer *RemoveOpenTable (APTR tableEd, STRPTR name);

APTR InitTableEdit (ULONG pageLength);
void DisposeTableEdit (APTR tableEd);
void TableEdit (APTR tableEd);

#endif 		/*_TABLEEDIT_H_ */
