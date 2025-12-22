#ifndef LIBRARIES_DOSPATH_H
#define LIBRARIES_DOSPATH_H

/*
 * libraries/dospath.h  V1.0
 *
 * shared library include file
 *
 * (c) 1996 Stefan Becker
 */

#ifndef DOS_DOS_H
#include <dos/dos.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif

#define DOSPATH_NAME    "dospath.library"
#define DOSPATH_VERSION 1

/* This AmigaDOS structure is nowhere defined in the official header files,  */
/* but in "The Amiga Guru Book" (Ralph Babel, Taunusstein, 1993) on page 571 */
/* it is stated that it is "nethertheless officially documented"...          */
struct PathListEntry {
 BPTR ple_Next; /* Next PathListEntry */
 BPTR ple_Lock; /* Directory lock     */
};

/* Tags for BuildPathListTagList() */
/* Build a path list from the NULL terminated */
/* string array pointed to by ti_Data         */
/* ti_Data type: (const char **)             */
#define DOSPath_BuildFromArray (TAG_USER + 0x1001)

/* Build a path list from the Exec list to by ti_Data */
/* ti_Data type: (struct List *)                      */
#define DOSPath_BuildFromList  (TAG_USER + 0x1002)

#endif /* LIBRARIES_DOSPATH_H */
