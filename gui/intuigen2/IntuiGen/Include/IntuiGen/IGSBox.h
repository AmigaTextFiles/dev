/*
IGSBox.h

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


#ifndef IGSBOX_H

#define IGSBOX_H


/* Scroll Function in SBox's Prop's IGInfo should point to here */
void UpdateSBox (struct IGRequest *req, struct Gadget *gadg,
		 LONG x,LONG y);



/* Call this after you have added entries */
void RefreshSBox (struct IGRequest *req,struct SelectBox *sb);



/*  Renumbers ID's in entries so that they are correct
NOTE:  A SELECT BOX WILL NOT WORK IF ITS IDS ARE NOT CONSECUTIVE
       STARTING AT 0 */
void FixIDs (struct SelectBoxEntry *first);


/* Allocates two border structures and SHORT values on the key, and creates
   Box, returns pointer to first Border structure */
struct Border *MakeBox (USHORT w,  USHORT h,
			UBYTE c1, UBYTE c2,
			struct Remember **key);


/* Calls MakeBox to make border for a selectbox, returns 1 on error, 0 for no error */
BOOL MakeSBBorder (struct SelectBox *sb);


/* using array of strings items, with num strings, it allocates SelectBoxEntry
	structures for each item and creates a entries list that can be
	used with a selectbox.	Just set the SBox's Entries field to this
	functions return value.  All allocations are make on the key */
struct SelectBoxEntry *MakeSBEntryList (struct Remember **key,
					char *items[],int num,
					void (*func) ());


/* Goes through a list of SelectBoxEntries linked only by the Next field,
   and make the list doubly linked (both Next and Prev fields valid */
void FixLinks (struct SelectBoxEntry *first);


/* Adds a SelectBoxEntry toadd to the list currently being used by SelectBox
    sb.  toadd is added at position pos, if pos==-1, it is added at the end */
void AddSBEntry (struct SelectBox *sb,struct SelectBoxEntry *toadd,int pos);


/* allocates a SelectBoxEntry on key, and sets its Text field to point to
	string entry, and its ItemSelected field to point to func, then adds
	the new entry to SelectBox sb at position pos */
BOOL AddEntry (struct SelectBox *sb,
	       char *entry, void (*func) (),
	       int pos);


/*  Same as above, but inserts the entry into entry list in alphabetical
    order */
BOOL AddEntryAlpha (struct SelectBox *sb,
		    char *entry, void (*func) () );

/* Removes entry from SelectBoxes SelectBoxEntry List.	Does not
 * free entry (which is necessary with entries added via AddEntry
 * and AddEntryAlpha). */
void RemoveSBEntry (struct SelectBox *sb,struct SelectBoxEntry *e);

/* Frees SelectBoxEntry allocated with AllocMem, AddEntry, or
 * AddEntryAlpha */
void FreeSBEntry (struct SelectBoxEntry *e);

void ClearSBox (struct SelectBox *sb,BOOL freeEntries);

void SBoxSelectAll (struct SelectBox *sb);
void SBoxDSelectAll (struct SelectBox *sb);

#endif /* IGSBOX_H */

