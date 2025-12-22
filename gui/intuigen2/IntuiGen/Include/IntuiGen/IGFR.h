/*
IGFR.h

(C) Copyright 1993 Justin Miller
	This file is part of the IntuiGen package.
	Use of this code is pursuant to the license outlined in
	COPYRIGHT.txt, included with the IntuiGen package.

    As per COPYRIGHT.txt:

	1)  This file may be freely distributed providing that
	    it is unmodified, and included in a complete IntuiGen
	    2.0 package (it may not be distributed alone).

	2)  Programs using this code may not be distributed unless
	    their author has paid the Shareware fee for IntuiGen 2.0.
*/


#ifndef IGFR_H

#define IGFR_H

/* Set the InitFunction field of the IGObject structure to point
   to this function.  The Address field must contain a pointer to
   an initialized IGFileRequest structure */

MakeIGFileRequest (struct IGRequest *req,struct IGObject *obj);




/* If you change the name in FileName, call this routine to show
   the directory */

void ShowDir (struct IGRequest *,struct IGFileRequest *);




/* This routine updates the FileName Gadget */

void FixFile (struct IGRequest *req,struct IGFileRequest *fr);




/* This routine will change the string FileName so that it contains one
   less directory level, or contains the directory short the filename*/

void ChopLevel (UBYTE *FileName);




/* This routine insures that a directory name ends either with ':' or '/',
   and if necessary appends a '/' so that you can strcat filenames onto a
   directory name easily */

void FixDirNameEnding (UBYTE *dirname);




/* This routine will copy the last part (after the last '/' or ':') of
   pathfile to file */

void GetFileName (UBYTE *pathfile,UBYTE *file);




/* This routine will take a path and file name, and copy it file minus
   a filename if one is present.  Pathfile is assumed to have just come
   from fr (which has a flag bit set if a filename was present */

void GetFRDirName (UBYTE *pathfile,UBYTE *file, struct IGFileRequest *fr);




/* This routine erases the last level from a file requester's
   filename and then calls FixFile */

void UpDirectory (struct IGRequest *req,struct IGFileRequest *fr);




/* Sets given file requester to given directory */

void SetDirectory (struct IGRequest *,struct IGFileRequest *,UBYTE *dir);




/* Selects file in file requester, taking into account single select
   or multiselect modes.  If necessary, waits until directory has been
   read.
*/

BOOL SelectFile (struct IGRequest *,struct IGFileRequest *,UBYTE *file);




/* Selectively calls one or both of SetDirectory and SelectFile, depending
   on whether path is directory name of directory and file name or just
   file name.
*/

BOOL SetPathFile (struct IGRequest *,struct IGFileRequest *,UBYTE *path);




/*  This function will duplicate a Directory Entry list, matching the
    criteria given in flags.  If there is any chance of an IGFR routine
    running while you are looking through the DirEntry list, duplicate it
    first to avoid problems (like IGFR freeing the list).  The following
    are flags you can use, in any combinations.

	IGDE_DISPLAYED	 Entries must match current file matching specs
			      to be copied
	IGDE_SELECTED	 Entries must be selected (in MULTISELECT
			      FileRequester's only
	IGDE_FILESONLY	 Entries must be files
	IGDE_DIRSONLY	 Entries must be directories
	IGDE_NOTDISPLAYED   Entries must not match current file matching
			      specs
	IGDE_NOTSELECTED    Entries must not be selected (in MULTISELECT
			      FileRequester's only
	IGDE_ALL	    Both files and directories will be copied

    Note:  Do not write to the FileName field of duplicated IGDirEntry
	     structures, or add entries to the linked list that were not
	     created by the DupDirList function, as they will not be properly
	     freed (read "The Computer will Guru")
*/

struct IGDirEntry *DupDirList(struct IGFileRequest *fr,ULONG flags);




/*   Use this function to free a linked list created by DupDirList */

void FreeDirList(struct IGDirEntry *de);




/* Selects all files in multiselect file requester */

void IGFRSelectAll (struct IGRequest *req, struct IGFileRequest *fr);




/* Deselects all files in multiselect file requester,
   Deselects selected file, if any, in single select file requester
*/

void IGFRDeSelectAll (struct IGRequest *req, struct IGFileRequest *fr);


#endif /* IGFR_H */
