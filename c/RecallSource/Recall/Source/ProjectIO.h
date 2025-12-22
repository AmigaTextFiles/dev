/*
 *	File:					ProjectIO.h
 *	Description:	Defines the structure of the configuration and events.
 *								Reads and writes the project as an IFF-FORM.
 *
 *	(C) 1993,1994,1995 Ketil Hunn
 *
 */

#ifndef PROJECTIO_H
#define	PROJECTIO_H

/*** PROTOTYPES **********************************************************************/
LONG ReadIFF(struct List *list, char *file);
LONG WriteIFF(struct List *list, char *file);
#endif
