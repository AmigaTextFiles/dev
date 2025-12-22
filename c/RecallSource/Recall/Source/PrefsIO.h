/*
 *	File:					PrefsIO.h
 *	Description:	
 *
 *	(C) 1995, Ketil Hunn
 *
 */

#ifndef PREFSIO_H
#define PREFSIO_H

/*** FUNCTIONS ***********************************************************************/
LONG ReadProject(struct List *list, UBYTE *file, BYTE force);
LONG OpenProject(struct List *list, UBYTE *file, BYTE force);
LONG AppendProject(struct List *list, UBYTE *file);
LONG SaveProject(struct List *list, UBYTE *file);
LONG SaveProjectAs(struct List *list, UBYTE *file);
LONG LastSaved(struct List *list, UBYTE *file, BYTE force);
BYTE OverwriteFile(UBYTE *file);
#endif
