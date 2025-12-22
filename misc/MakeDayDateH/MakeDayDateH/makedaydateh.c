/*
 * MakeDayDateH.c
 *
 * Small utility to make C header file containing current day/date
 * in system boot. 
 * This way you have always correct date/day in your projects.
 *
 * Redirect the output e.g. "MakeDayDateH >env:release_date.h"
 *
 * All done by MKsa  (internet: k114636@ee.tut.fi)
 *
 *                                   'Be Careful Out There, Fellaz'
 */

#include <exec/libraries.h>
#include <libraries/dos.h>
#include <dos/datetime.h>
#include <proto/exec.h>
#include <proto/dos.h>
#include <clib/alib_protos.h>
#include <clib/alib_stdio_protos.h>
#include <strings.h>

#include "makedaydateh.h"

#define NOTESTR "/* Current day and date */\n\n"
#define DEFDAY  "#define CURRENT_DAY  \""
#define DEFDATE "#define CURRENT_DATE \""
#define DEFEND  "\"\n"

UBYTE *VersionString = "$VER: MakeDayDateH 1.0 by MKsa (1-Feb-93)";
/* note: SPACEs are <ALT SPACE>s, because c:version screws up the date */

void main(int argc, char **argv)
{
struct Library *DOSLibrary;
struct DateTime dt;
char   date[LEN_DATSTRING], day[LEN_DATSTRING],*datept;
BPTR   fh;

if (!(DOSLibrary = OpenLibrary("dos.library", 0))) return;

DateStamp(&dt.dat_Stamp);
dt.dat_Format = FORMAT_DOS; /* Format:   dd-mmm-yy */
dt.dat_Flags = 0;
dt.dat_StrDay = day;
dt.dat_StrDate = date;
dt.dat_StrTime = NULL;
DateToStr(&dt);
datept = date;
if (*datept=='0') datept++; /* e.g. make "08-Dec-92" to "8-Dec-92" */

fh = Output();
Write(fh,NOTESTR,strlen(NOTESTR));

Write(fh,DEFDAY,strlen(DEFDAY));
Write(fh,day,strlen(day));
Write(fh,DEFEND,strlen(DEFEND));

Write(fh,DEFDATE,strlen(DEFDATE));
Write(fh,datept,strlen(datept));
Write(fh,DEFEND,strlen(DEFEND));

CloseLibrary(DOSLibrary);
}
