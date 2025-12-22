/*
IGRequest.h

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


#include <exec/types.h>
#include <Intuition/Intuition.h>
#include <dos/dos.h>

#ifndef IGREQUEST_H

#define IGREQUEST_H



/* returns TRUE is character c is in string s, other wise returns false */

int cismember (char c,char *set);




/* deletes n chars starting at position p from string s */

void delchars (char *s,USHORT p,USHORT n);




/* if k==FALSE deletes every occurance of any character in string elim in
*		string s
*  if k==TRUE  deletes every occurance of any character not in string elim in
*		string s
*  returns true if any characters were deleted */

BOOL strelim (char *s,char *elim,BOOL k);




/* Takes RAWKEY code and qualifier (from an IntuiMessage) and returns
*  ASCII equivalent
*/

UBYTE RawKeyToAscii (USHORT code,USHORT qual);




/* For removing a Gadget from the IGRequest's Gadget list that was
*  added by an IGObject.  This will normally be called by that
*  object's cleanup routine.  IT CANNOT BE CALLED WHILE THE REQUESTER
*  IS ACTIVE (ON SCREEN).
*
*  The Following IGRemove functions perform similar functions, just
*  on a different structure category.
*/

void IGRemoveGadget (struct IGRequest *req,struct Gadget *rm);
void IGRemoveImage (struct IGRequest *req,struct Image *rm);
void IGRemoveBorder (struct IGRequest *req,struct Border *rm);
void IGRemoveIText (struct IGRequest *req,struct IntuiText *rm);
void IGRemoveSBox (struct IGRequest *req,struct SelectBox *rm);
void IGRemoveIGObject (struct IGRequest *req,struct IGObject *rm);




/* zeros values in Requester req, sets LeftEdge, TopEdge, Width, Height
*  values so that they are offsets from the edges of the window win */

void IGInitRequester (struct Window *win,    /* Window values relative to */
		      struct Requester *req, /* Intuition Requester */
		      SHORT rl, SHORT rr,    /* Left, right offsets from
					      * Window edge */
		      SHORT rt,SHORT rb);    /* Top, Bottom offsets from
					      * Window edge */
/*  NOTE: This routine calls Intuition's InitRequest, clearing any
*   data values previously in requester */




/* Refreshes values in IGInfo, PropInfo structures for IG Prop Gadget */

void ModifyIGProp (struct IGRequest *req, /* IGRequest containing prop gadget */
		   struct Gadget *prop, /* Prop Gadget */
		   USHORT mx,my,dx,dy, /* MaxX, MaxY, DisplayedX, DisplayedY, */
		   USHORT top,left); /* Top position, Left Position */




/* Allocates and Frees CallLoop bit for IGRequest CallLoops */

BYTE AllocCLBit (struct IGRequest *req);
void FreeCLBit (struct IGRequest *req,UBYTE bit);




/* Sends an IntuiMessage to an IGRequest over an internal port (not the
*   window port).  IGRequest treats messages coming to this port as if they
*   had came directly to the window port.
*   NOTE:  These messages should be freed using the macro FreeIntuiMsg().
*	    They are not intended to be replied to.
*/

BOOL SendIntuiMsg (struct IGRequest *req,ULONG Class,ULONG Code,
		    USHORT Qualifier,APTR IAddress);




/* Frees an IntuiMessage allocated by SendIntuiMsg.  Use this instead of
*  ReplyMsg.
*/

#define FreeIntuiMsg(x) FreeMem(x,sizeof(struct IntuiMessage))




/* Causes a Gadget to look like it was clicked by the user
*	 Activates string gadgets
*	 Selects or deselects toggle gadgets
*	 Causes select and then deselect for Bool Gadgets
*  DOES NOT SEND ANY MESSAGES OR EFFECT BEHAVIOR OF PROGRAM - SIMPLY
*  CHANGES GADGET APPEARANCE
*/

void StimulateGadget (struct IGRequest *req,struct Gadget *gadg);




/* Causes the program to behave as if they user clicked on a
*  Gadget.  Sends appropriate messages to IGRequest, causes gadget
*  to be stimulated.
*/

BOOL GadgetClick(struct IGRequest *req,struct Gadget *gadg);




/* Sends a RAWKEY message to an IGRequest.  keyinfo points to a string
*  that can contain any of the following letters in any order:
*	 s - shift
*	 c - control
*	 a - alt
*	 A - command (Amiga)
*  Letters besides these will be ignored.  Case is significant.
*  key contains the ASCII code of the key to send.  It is converted
*  to Rawkey using the current default keymap.
*/

BOOL KeyClick (struct IGRequest *req,UBYTE *keyinfo,UBYTE key);




/* This routine finds a Gadget with a RexxName of name in a gadget list
*  pointed to by gadg. Used internally by IGRequest, but can also be used
*  by you.  Returns null on failure.
*/

struct Gadget *FindRexxGadget (struct Gadget *gadg,UBYTE *name);




/* This routine finds a menu or submenu item with the RexxName of
   name in the requester described by the req IGRequest structure.
   It then returns a pointer to the IGMenu structure concerning it.
   This is used by the ARexx processing routines.
*/

struct IGMenu *FindRexxMenu (struct IGRequest *req,UBYTE *name);




/* This function will cause the program to behave as if the user
   had selected the given menu item manually.
*/

BOOL MenuPick (struct IGRequest *req,struct IGMenu *igm);




/* Copies string to a string Gadget buffer, refreshes string gadget,
*  and sends GADGETUP and GADGETDOWN messages to IGRequest.
*/

void SetStringGad (struct IGRequest *req,struct Gadget *gadg,UBYTE *string);




/* Convenient routine to pull words off of a string.  Multiple words in
*  quotes as single words.  Keeps track of nested Quotes ('"Nested quotes"').
*  slist is the string to pull words off of.  word is the buffer to copy
*  the word to.  index is the index to start at in slist.  delim is a string
*  that contains characters that should be ignored, but counted as delimiters.
*  retdelim contains characters that should be used as delimiters and returned
*  as words by themselves.  len is the length of word.
*/

#define RxPullWord(rxcom,combuf,ndx,len) \
    PullWordIndex(rxcom,combuf,ndx," ,","",len)

LONG PullWordIndex (UBYTE *slist,UBYTE *word,USHORT index,
		      UBYTE *delim,UBYTE *retdelim,USHORT len);




/* Processes a RexxMsg for IGRequest req.  Called internally by IGRequest
*  to implement the following Rexx commands:
*
*	GadgetClick <RexxGadgetName>
*	SetStringGad <RexxGadgetName> <String>
*	KeyClick <qualifiers> <key>
*	MenuPick <RexxMenuName>
*
*  Qualifers for KeyClick is a string like that sent to KeyClick above and
*  key should be the unqualified (non-shifted,controled,etc.) letter that
*  appears when the desired key is typed.
*
*  If IGProcessRexxMsg doesn't understand the command, or can't find
*  the specified Gadget in this IGRequest, it returns 1.  Otherwise it
*  returns 0.
*
*  If this routine returns 1 when called from IGRequest, IGRequest will call
*  your ArexxFunction.	If you don't have an ArexxFunction, it will set
*  the Result1 field to 10 before replying to the message.
*/

BOOL IGProcessRexxMsg (struct IGRequest *req,struct RexxMsg *rm);




/*
    BlockIGInput Function opens an blank intuition requester on top
    of an IGRequest, thereby blocking its input
*/
void BlockIGInput(struct IGRequest *req);




/*
    UnBlockIGInput closes blank requester opened by BlockIGInput, thereby
    permitting messages to come through again
*/
void UnBlockIGInput(struct IGRequest *req);




/*
*  ClearWindow Function, clears inside of window to background (0)
*/

void ClearWindow (struct Window *w);




/* Handles all necessary procedures to display and handle IGRequest req
   returns pointer to endlist item that caused request to terminate,
   if termination was caused by Terminate field in req being set to TRUE,
   returns pointer to allocated (on req->ReqKey) endlist struct with class
   of IG_REQTERMINATE, returns NULL on error */

#ifdef IGFAR /* define this in your source for far IGRequest */
	     /* Be careful if you use precompiled headers!!! */
__far
#endif /* IGFAR */

struct IGEndList *IGRequest (struct IGRequest *req);




/* Opens an Intuition requester over IGRequest req, with message string, and
   2 Gadgets, labeled by strings g1 and g2.  returns 0 if g1 is selected,
   1 if g2 is selected
*/

BOOL BoolRequest (struct IGRequest *req,UBYTE *string,UBYTE *g1,UBYTE *g2);

#endif /* IGREQUEST_H */

