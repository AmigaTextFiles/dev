/*
IntuiGen.h

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
#include <intuition/intuition.h>
#include <dos/dos.h>

#ifndef INTUIGEN_H

#define INTUIGEN_H

#define FLAGOFF(x,flag) ((x)&=0xffffffff^(flag))
#define FLAGON(x,flag) ((x)|=(flag))

#define ISFLAGON(x,flag) ((x) & (flag))
#define ISFLAGOFF(x,flag) (!(ISFLAGON(x,flag)))

#define IGREQUEST_IDCMP (IDCMP_GADGETUP | IDCMP_GADGETDOWN | IDCMP_MOUSEBUTTONS | IDCMP_RAWKEY)

#define WUD_FIXEDSIZE (1<<31) /* WARNING:

		IGRequest uses 31st bit of the window->UserData, making
		it dangerous for the user to also try to store data in it
*/

#define STRING_FLOAT 1
#define STRING_SHORT 2
#define STRING_LONG 4
#define GADG_ARROW 8
#define GADG_PROP 16
#define GADG_BOOL 32
#define GADG_STRING 64
#define STRING_ALLOC 128 /* internal use only */
#define STRING_FILL 256
#define BOOL_FILL 256
#define STRING_HIGHLIMIT 512
#define STRING_LOWLIMIT 1024
#define STRING_INITONCE 2048
#define STRING_INITALWAYS 4096
#define GADG_INITONCE 2048
#define GADG_INITALWAYS 4096
#define GADG_SBOX 2048
#define GADG_ONESELECTED 8192
#define IG_REQTERMINATE 0xFFFFFFFF

#define IG_SHIFT 1
#define IG_CONTROL 8
#define IG_ALT	  16
#define IG_AMIGA  32

#define SB_RELVERIFY 0
#define SB_NOTSELECTED 0
#define SB_TOGGLEALL 1
#define SB_TOGGLEONE 2
#define SB_SELECTED 4
#define SB_ADDEDGADGETS 8 /* internal use only */

#define IGFR_READING 1		/* internal use */
#define IGFR_INIT 8		/* internal use */
#define IGFR_FILENAMEPRESENT 2	/* internal use */
#define IGFR_FREEDIRKEY 32	/* internal use */

#define IGFR_VARSSAVED 256
#define IGFR_OKCANCEL 4
#define IGFR_CURRENTDIR 16
#define IGFR_NOINFO	64
#define IGFR_MULTISELECT 128
#define IGFR_INCLUDEASSIGNS 512
#define IGFR_NOFILESELECT 1024

#define IG_ADDGADGETS 1
#define IG_INITREQUESTERTOOPEN 2
#define IG_INITDATASTRUCT 4
#define IG_RECORDWINDOWPOS 8
#define IG_INPUTBLOCKED 16 /* internal use only */

/*
    All functions are passed the address of the IGRequest structure, and the
    address of a copy of the IntuiMessage structure.  Do not reply to this
    message, it will already have been replied to.  It is the pointer
    to the same message used by IGRequest to make decisions.  You may
    change it to affect the decisions that it makes,

NOTE:  NO FUNCTIONS ARE EVER PASSED A STRUCTURE, THEY ARE ALWAYS PASSED THE
       ADDRESS OF THE STRUCTURE
*/

struct SelectBox {
    struct SelectBox *Next;
    USHORT LeftEdge;
    USHORT TopEdge;
    USHORT Width;
    USHORT Displayed;	       /* Number entries displayed at one time
				  used to calculate height=10*Displayed+6 */
    USHORT NumberEntries;      /* Total number of entries in list,
				  may be changed while selectbox running */
    USHORT Flags;
	/* SB_TOGGLEALL  All entries are TOGGLESELECT, may have any combination
			 turned on or off
	   SB_TOGGLEONE  All entries are TOGGLESELECT, only one may be selected
			 at a time, others are turned off
	   SB_RELVERIFY  each entry is a simple RELVERIFY Gadget, no toggling
			 supported */
    UBYTE  BColor1,BColor2;
	/*  BColor1	Color of Left and Top Borders
	    BColor2	Color of Right and Bottom Borders */
    struct Border *SBoxBorder;
	/*  Pointer to Border structure to use.  Can be initialized,
	    but if not, border is automatically allocated using BColor1, BColor2 */
    struct Gadget *Prop;
	/*  Pointer to Prop Gadget associated with this SelectBox.  Can
	    be left unitialized  */
    struct Gadget *GList;	/* leave NULL */
    struct SelectBoxEntry *Entries; /* Can be initialized, or can be indirectly
				       updated through AddEntry, AddEntryAlpha, etc */
    struct SelectBoxEntry *Selected; /* leave NULL */
    struct Remember *SBKey; /* key upon which all necessary structures are allocated */
			    /* is freed upon exit from IGRequest */

    void (*ItemSelected) (struct IGRequest *,struct SelectBox *,
			  struct SelectBoxEntry *,struct IntuiMessage *);
			  /* Function to call when an item is selected */

    void (*ItemDSelected) (struct IGRequest *,struct SelectBox *,
			   struct SelectBoxEntry *,struct IntuiMessage *);
			  /* Function to call when an item is deselected */

    struct IGObject *IGObject; /* Object which this SelectBox is part of */
    APTR UserData;
};



struct SelectBoxEntry {
    UBYTE *Text; /* Pointer to text string to be used */
    UBYTE Color; /* Color of text printed in Select Box */
    USHORT Flags;
	/* SB_SELECTED	    Item is selected, should be highlighted
	   SB_NOTSELECTED   Item is not selected, not highlighted */
    USHORT ID; /*  ID, SBox Entries must be numbered sequentially,
		   from 0 to X,  Use FixIDs () to accomplish this */
    struct Gadget *Gadget; /* Gadget this entry is currently linked to
			      will change as user scrolls through select box */

    void (*ItemSelected) (struct IGRequest *,struct SelectBox *,
			  struct SelectBoxEntry *,struct IntuiMessage *);
			 /* Function to call when this item is selected,
				called after Global ItemSelected () from
				SelectBox structure is called. */

    void (*ItemDSelected) (struct IGRequest *,struct SelectBox *,
			   struct SelectBoxEntry *,struct IntuiMessage *);
			  /* Function call when this item is deselected,
				  Everything same as ItemSelected above */

    struct SelectBoxEntry *Next,*Prev; /* Used to link together SBox Entries
					  Only the next link needs to be filled in,
					  IGRequest will call FixLinks () to
					  fill in Prev links */
    struct IGObject *IGObject; /* Object which this SBEntry is part of */
    APTR UserData;
};



/* SBox Gadgets and GadgetInfos will be allocated for each SelectBox by
   IGRequest, provided here for informational purposes only */

struct IGSBoxGadgetInfo {
    USHORT Type;
    struct SelectBox *SBox;
    struct SelectBoxEntry *Entry;
    struct IGObject *IGObject; /* Object which this SBoxGadget is part of */
    APTR UserData;
};



struct IGPropArrowInfo {
    USHORT Type; /* must be GADG_ARROW */
    struct Gadget *Prop; /* Pointer to prop Gadget with which this
			    arrow is associated.  Need not be initialized,
			    PropInfo will point to arrow Gadget which will
			    Point here, so that the prop field can be initialized
			    automatically by IGRequest */
    void (*GUpFunction) (struct IGRequest *,struct IntuiMessage *);
      /* function to call on GadgetUp */

    void (*GDownFunction) (struct IGRequest *,struct IntuiMessage *);
      /* Function to call on GadgetDown */

    struct IGObject *IGObject; /* Object which this PropArrow is part of */
    APTR UserData;
};



struct IGBoolInfo {
    USHORT Type; /* must be GADG_BOOL. Can also contain:
			GADG_INITONCE	   Initialize the on/off state of
					   Gadget first time requester is
					   opened.  Leave as user leaves it
					   thereafter.
			GADG_INITALWAYS    Initialize the on/off state of
					   Gadget every time the requester is
					   opened.
			GADG_ONESELECTED   If this is part of a series of
					   mutual exclude toggleselect gadgets,
					   one must always be selected.
			BOOL_FILL	   Copy Values to and from
					   Datastruct given in IGRequest
					   using the BitToSet in the longword
					   at offset DataStructOffset
					   as the source/destination
					   See below.
		 */
    USHORT InitialValue; /* For ToggleSelect Gadgets. Can be set to
			     NULL	      Gadget is off
			     GFLG_SELECTED    Gadget is on
			 */
    USHORT DataStructOffSet; /* OffSet of integral field to set to true or
				false on exit from IGRequest (toggleselect
				gadgets only) */
    UBYTE  BitToSet;	     /* Bit in data field to set to true or false */

    void (*GUpFunction) (struct IGRequest *,struct IntuiMessage *);
    void (*GDownFunction) (struct IGRequest *,struct IntuiMessage *);
    void (*DClickFunction) (struct IGRequest *,struct IntuiMessage *);

    struct IGObject *IGObject; /* Object which this Bool Gadget is part of */
    UBYTE *RexxName; /* Name that Arexx commands can refer to this gadget by */
    APTR UserData;

/* FOR MUTUAL EXCLUDE TOGGLESELECT GADGETS:
    Under IGRequest the MutualExclude long word in the Gadget structure has
    been implemented.  Each group of mutual exclude Gadgets should be assigned
    a bit, and this bit set in each Gadget's structure in the MutualExclude
    field.  Gadget's that have the same bit set will not be able to be
    activated simultaneously (turning one on will turn the other off).
    NOTE:  Using the MutualExclude field to contain other information in
	    ToggleSelect Gadgets will have undesirable results
*/
};



struct IGStringInfo {
    USHORT Type; /* must be GADG_STRING */
	/* Can also contain
		STRING_FLOAT  This gadget contains a floating point numeral
			      Structure field to be filled is of type IGFloat
			      (typedefed as float)
		STRING_LONG   This gadget contains a long integer,
			      structure field to be filled is of type LONG
		STRING_SHORT  This gadget contains a short integer
			      structure field to be filled is of type SHORT
		STRING_LOWLIMIT
			      StringLow is to be imposed on this string gadget
		STRING_HIGHLIMIT
			      StringHigh is to be imposed on this string gadget
		STRING_FILL   fill structure field at offset in DataStructOffSet
			      when ending of type FILLSTRUCT is chosen
		STRING_INITONCE
			      Setting this flag will cause whatever is in
			      the IGInfo->InitialValue field to be copied
			      into the buffer.	This flag is then cleared.
		STRING_INITALWAYS
			      Setting this flag will cause whatever is in
			      the IGInfo->InitialValue field to be copied
			      into the buffer every time the requester is
			      opened.

	NOTE:  If IGRequest allocates a buffer for a string, it will always
	       copy IGInfo->InitialValue to the buffer, which would otherwise
	       be completely blank.  It will only do this when it actually
	       allocates the buffers, which would be the first time through,
	       or the first time through after you Free them.
    */

    UBYTE *InitialValue;    /* pointer to string to copy into buffer when
				requester begins */
    UBYTE *DisAllowedChars; /* pointer to string, characters in which are
			       not to be allowed in this string gadget */
    USHORT DataStructOffSet; /* offset from structure of field that contents
				of this string gadget should be copied to */

    /* These set limits on contents of numerical string gadgets */
    LONG   StringHigh;
    LONG   StringLow;

    struct Gadget * NextStringGadget; /* pointer to string Gadget
					 to activate when a GadgetUp msg
					 is recieved from this one */

    void (*GUpFunction) (struct IGRequest *,struct IntuiMessage *);
    void (*GDownFunction) (struct IGRequest *,struct IntuiMessage *);
    void (*DSelectFunction) (struct IGRequest *,struct IntuiMessage *);
			       /* Same as GUpFunction but will always be called,
				   either on GadgetUp, or when another gadget
				   is activated, thereby deactivating this one */

    struct IGObject *IGObject; /* Object which this String Gadget is part of */
    UBYTE *RexxName; /* Name that Arexx commands can refer to this gadget by */
    APTR UserData;
};



struct IGPropInfo {
    USHORT Type; /* must be GADG_PROP */
    void (*ScrollFunc) (struct IGRequest *,struct Gadget *,LONG,LONG);
	 /* called when arrows clicked, held down, or
			      prop played with */
	 /*Args: ScrollFunc(IGRequest,gadget,XPos,YPos)*/

    struct SelectBox *SBox; /* Pointer to SelectBox with which this Prop
			       Gadget associated */
    struct Gadget *LUArrow; /* Pointer to the Left or Up arrow Gadget */
    struct Gadget *RDArrow; /* Pointer to the Right or Down arrow Gadget */
    USHORT MaxX; /* Number of Items to be displayed horizontally */
    USHORT MaxY; /* Number of Items to be displayed vertically */
    USHORT DisplayedX; /* Number displayed at one time */
    USHORT DisplayedY;
    USHORT Top; /* Topmost item currently being displayed */
    USHORT Left; /* Leftmost item currently being displayed */
    struct IGObject *IGObject; /* Object which this Scroll Bar is part of */
    APTR UserData;
};



/* struct IGObject */
/* This is somewhat esoteric, but works as follows:
    An Object could be anything the user thinks up, such as a FileRequester,
    which should be part of a requester.  The InitFunction is called first.
    It should allocate and initialize the constituent Gadgets, Borders, Images,
    IntuiTexts, SelectBoxes, or other IGObjects (which must be placed at the
    end of the list in order to be recognized), accompanying IGInfo structures,
    and add them to the appropriate linked lists.  It should also tie in any
    additional functions to be called upon certain events.  For General
    message functions - the ones pointed to in the IGRequest structure
    itself (for instance RAWKEY, InitFunction, or DISKREMOVED), a passthru
    feature should be provided as follows:

	The address in the IGRequest structure should be saved in the
	    structure pointed to by IGObject.Address
	The address of the new function should be put in
	When the new function is called, it should service the last object
	    of the appropriate type whose service flag is not set.  It should
	    immediately set the serviced flag in that object.
	    It should then perform whatever processing is necessary for
	    that object.  Last, it should that objects passthru function.

    The address should be saved in the structure pointed to by
    IGObject address and not in a static variable so that the
    function is fully reenterant and can be multitasked, and nested calls
    (from nested IGRequests) can be made to it.  The serviced flag is to
    allow multiple objects of complex types to exist in the same requester.

    Later, in the CleanUp Routine, each object should replace the original
    value of each of these general functions that it used into the IGRequest
    struct.  Since these objects are handled in reverse order, that will
    restore the IGRequest structure to its previous state PROVIDING
    that the only time the values of the General functions are changed
    are in the InitFunctions and the cleanup.  NO OTHER ROUTINES MAY CHANGE
    THESE FUNCTIONS DURING THE EXECUTION OF IGREQUEST IF IGOBJECTS ARE TO
    BE USED.

    REMEMBER:  If an Object adds anything to one of the linked lists, and
    then frees it upon exit from the requester, it also must remove its
    reference from the linked list.  Failure to do so will cause a Guru.

*/

struct IGObject {
    BOOL (*InitFunction) (struct IGRequest *,struct IGObject *);
			     /* The InitFunction should return 1 on error */

/*  The following two can be the same, but should be provided if the
    InitFunction Allocates anything, providing a means to free it.
    Any thing allocated on the IGRequest structure's key will be taken care
    of, DO NOT FREE IT IN THESE FUNCTIONS!

    Arguments for both (so they are interchangeable, if desired):
	Function (IGRequest,IGObject,EndListItem);

    ALL FUNCTIONS ARE PASSED POINTERS ONLY
*/
    void (*AbortFunction) (struct IGRequest *,struct IGObject *,struct IGEndList *);
    void (*RequestEndedFunction) (struct IGRequest *,struct IGObject *,struct IGEndList *);

/* The Rexx Function is sent rexx messages for this object.  It is up to
   it to process them.	The Arexx command line would look like this:
	RexxName Command Arg1 Arg2...Argn
    Where RexxName is this objects name as defined below, and the command
	and arguments are specific to this object.

    This function should return True if it processed the Rexx Message,
    and False if the Rexx Message needs further processing.
*/

    BOOL (*RexxFunction) (struct IGRequest *,struct IGObject *,struct RexxMsg *);

    UBYTE *Class; /* Label for this Object Class */
    APTR Address; /* Pointer to data structure for this Object */
    BOOL Serviced;
    USHORT GadgetYOffSet; /* Number of pixels to add to TopEdge of Gadgets to
			      compensate for larger system fonts used in title bars.
			      If this is zero, the default system font is equivalent
			      in vertical size to Topaz 8 (first usable row in Windows
			      has Y coord of 11
			  */
    struct IGObject *IGObject; /* Object which this Object is part of */
    struct IGObject *Next;
    struct IGObject *Prev; /* Need not be initialized, IGRequest will fix */
    UBYTE *RexxName; /* Name for this Object to be addressed by via Rexx Programs */
    APTR UserData;
};



/* This is an IGObject.  Code for this object is in the file IGFR.c in
   the source directory.  An example is in the examples directory
   under FileRequest.c.  To use this, first fill out an IGFileRequest
   stucture.  Next Fill out an IGObject structure.  The InitFunction
   should be MakeIGFileRequest.  The Address field should point to the
   IGFileRequest structure.  All can be left blank.
*/
struct IGFileRequest {
    USHORT LeftEdge,TopEdge; /* LeftEdge, TopEdge of FileRequester */
    UBYTE  FileName[200]; /* Current directory is taken from this */
			  /* Upon exit, chosen file and path name is
			  /* stored here */
    UBYTE  Extension[10]; /* File extension, only files with this extension
			   * will be placed in Requester */
    UBYTE  BColor1,BColor2; /* Border Colors for SBox border and FileRequest
			     * Border */
    USHORT  Flags;    /* IGFR_OKCANCEL	   Put Ok and Cancel Gadgets
					   in requester
			IGFR_CURRENTDIR   Initialize requester to
					   current directory
			IGFR_NOINFO	  Do not display info files
			IGFR_MULTISELECT  Have ToggleSelect FileRequester
					   Selected Entries can be read
					   by cycling through IGDirEntry
					   list pointed to by First.
					   In MultiSelect requesters, this
					   list is not freed upon termination
					   of the request (so that it can be
					   examined later).  To free it,
					   FreeRemember the DirKey.
					   When this option is on, a single
					   click selects a directory, a
					   double click opens it.
			IGFR_VARSSAVED	   This causes the Selectbox
						   to be completely cleared
						   and the display rebuilt
						   from DirEntries present
						   upon initialization.
						   This can be used when
						   Manually saving variables,
						   including the DirEntry list,
						   Closing the request, and
						   then reopening it with a
						   a directory already read.
			IGFR_NOFILESELECT  Causes File names to be ghosted,
					    not selectable
		     */

    /* These should all be initialized to zero */

    BYTE   CLBit;	    /* req->CallLoop bit allocated */
    BPTR   Lock;	    /* For reading directory */
    struct FileInfoBlock *FInfo; /* For reading directory */
    struct SelectBox *SBox;	 /* SelectBox (allocated) */
    struct Gadget *Gadgets;	 /* Gadgets (allocated */
    struct Border *Borders;	 /* Borders (allocated */
    struct Remember *Key;	 /* Key upon which above is allocated
				    automatically freed on exit */
    struct Remember *DirKey;	 /* Key upon which current directory entries
				    are allocated, automatically freed */
    struct IGDirEntry *First;	   /* Pointer to first DirEntry in linked list */
    USHORT Number;		 /* Number of entries in DirEntry list */
    void (*LoopFunction) ();     /* Variable in which IGRequest's LoopFunction
				  * is saved */
    void (*DRemoved) ();         /* Variable DiskRemoved saved to */
    void (*DInserted) ();        /* Variable DiskInserted saved to */
    struct IGDirEntry *DCEntry;  /* Last Entry Selected (for double click */
    ULONG DCSecs,DCMics;	 /* Double click time, seconds */

    /* These can be used by you or other objects */

    struct IGObject *Object;	 /* Pointer to IGObject of which this is part
				  * DOES NOT POINT BACK TO THIS REQUESTER'S
				  * IGOBJECT STRUCTURE.  This permits
				  * a file requester to be part of another
				  * IGObject */
    APTR UserData;		 /* UserData */
};



/* These are the structure and flag definitions for the linked list pointed
   to by the First field in the IGFileRequest structure.  The current
   directory is stored thus.
*/
#define IGDE_DIR 1	   /* This entry is directory */
#define IGDE_DISPLAYED 2   /* This entry matches current file matching specs */
#define IGDE_SELECTED 4    /* This entry is selected (in MULTISELECT
			      FileRequester's only */

#define IGDE_FILESONLY 8       /* These are for use with the DupDirList function */
#define IGDE_NOTDISPLAYED 16   /* only.  They are not written into the */
#define IGDE_NOTSELECTED 32    /* IGDirEntry structure.  See IGFR.h for more */
#define IGDE_ALL 0	       /* info. */
#define IGDE_DIRSONLY 1

struct IGDirEntry {
    UBYTE *FileName;
    UBYTE Flags;
    struct SelectBoxEntry *SBE;
    struct IGDirEntry *Next,*Prev;
};



struct IGEndList {
    ULONG Class; /* IDCMP class of message to end requester */
    USHORT Code; /* IDCMP code of message to end requester */
    USHORT Qualifier; /* IDCMP qualifier of message to end requester */
    struct Gadget *Gadget; /* if Gadget msg, address of gadget to end requester */

    BOOL (*OKToEnd) (struct IGRequest *,struct IntuiMessage *);
     /* 1=end request, 0=don't end request */
    void (*Function) (struct IGRequest *,struct IntuiMessage *);
     /* Function to call if this ending is taken */

    BOOL FillStruct; /* Fill DataStructure if this ending is taken? */
};



struct IGKeyCommand {
    USHORT Command; /* RAWKEY code*/
    USHORT ASCIICommand; /* ASCII code for unqualified key.  Fill in either
	this or Command.  If this is filled in, the equivalent Rawkey is
	looked up from the current keymap and placed in Command by IGRequest.
	If both ASCIICommand and Command are 0, RawKey code of 0 is assumed.
    */
    USHORT Qualifier; /* Qualifier */
    struct Gadget *Gadget; /*pointer to gadget that code/qualifier
			     will activate */
};



struct IGMenu {
    USHORT Code; /* Number that will be recieved in Code field of
		    IntuiMessage when this MenuItem Chosen */
    void (*Function) (struct IGRequest *,struct IntuiMessage *);
    /* Function to call when MenuItem Chosen */
    UBYTE *RexxName;
};



/*  Use this to set up handling routines for classes of messages or
    sequences of messages not supported by IGRequest.  (Shift Click,
    Triple Click, etc.)
*/
struct MessageHandler {
    UBYTE *Name; /* Name of this class.  Can be whatever you want */
    BOOL (*IsType) (struct IGRequest *,struct IntuiMessage *);
	/* Called on every message.  Should return 1 if the message
	    constitutes the correct type, 0 otherwise */
    void (*HandlerFunction) (struct IGRequest *,struct IntuiMessage *);
	/* If IsType () returns 1, this is called */
    struct MessageHandler *Next;
};



struct IGRequest {
    struct NewWindow *NewWindow; /* pointer to NewWindow to open */
				 /* pointer to opend window will be
				    placed in IGRequest->Window field */
    struct Window *Window; /* pointer to already opened window
			      IGRequest will not close window unless it
			      opened it */
    UBYTE *ScreenName;	/* ScreenName to use with this window */
    struct Requester *RequesterToOpen; /* pointer to Intuition Requester
					  to open */
    struct Requester *Requester; /* Pointer to already open Intuition Requester */
    struct IGMenu *Menus; /* pointer to null terminated array of IGMenu structures
			     for handling of menus */
    struct IGEndList *EndList; /* pointer to null terminated array of IGEndList
				  structures */
    struct IGKeyCommand *KeyCommands; /* pointer to null terminated array of
					 IGKeyCommand structures */
    struct Gadget *Gadgets; /* pointer to first gadget in requester to use */
    USHORT Flags; /* Possible Values:
		IG_INITREQUESTERTOOPEN	 Causes RequesterToOpen to be
					 Initialized before opening
		IG_ADDGADGETS		 Causes Gadgets to be Added to Window
					 or requester
		IG_INITDATASTRUCT	 Causes Data Struct to be Initialized
					 to default values for string and
					 Toggleselect flag fields,
					 useful with newly allocated
					 Data Structures
    */
    struct Gadget *StringToActivate; /* Pointer to string Gadget to activate when
					requester first opened */
    struct Menu *MenuStrip;	     /* pointer to menu list to add to window
					when opened */
    struct Border *Borders;  /* pointer to Border list to draw into window */
    struct Image *Images;    /* pointer to Image list to draw into window */
    struct IntuiText *ITexts; /* pointer to IntuiText list to write into window */
    struct SelectBox *SBoxes;  /* pointer to first SelectBox to put into this window */
    struct IGObject *IGObjects; /* pointer to first IGObject structure */
    APTR DataStruct;	     /* pointer to structure to fill */
    struct Remember *ReqKey; /* Strings without buffers allocated on this */

    void (*InitFunction) (struct IGRequest *); /* function to call when requester first opened */

    BYTE Terminate; /* Can be set by outside routines to */
		 /* force request to end, >0==FillStruct, <0==!FillStruct */

    struct MsgPort *IComPort; /* Internal use only.  Initialize to 0 */
    APTR  InternalData;  /* Internal use only.	Initialize to 0 */

    void (*DSelectFunction) (struct IGRequest *,struct IntuiMessage *);
     /* To be called any time String Gadget is
      * De-Selected */

    void (*EndFunction) (struct IGRequest *,struct IntuiMessage *);
     /* To be called when requester ends.
      * This is called after any EndList EndFunction */

    void (*LoopFunction) (struct IGRequest *);
			     /* This function is called repeatedly
			      * while there is not a message at the
			      * Window port and while CallLoop!=0
			     */

    /* When using IGObjects, LoopFunction should be passed through.
       If any of the Functions or Objects in the list need to be
       called, the whole list must be called.  Each function then, should
       perform the obligatory task of finding its corresponding object (the
       last one of its type in the IGObject list that does not have its
       serviced flag set) and set the serviced flag so that the function
       that does need to be called can find its object.  After setting
       the serviced flag, each function can then check some internal
       variable, or CallLoop to see if it needs to do anything further.
       It then must call whatever function it replaced from the IGRequest
       structure.  To insure that one function does not clear CallLoop
       when another function needs it set, each function should call
       AllocCLBit to be assigned a bit in the CallLoop variable.  This
       function should only change this bit.  LoopBitsUsed records
       what bits are free and which ones have been allocated */

    ULONG CallLoop;
    ULONG LoopBitsUsed;

    struct MsgPort *ArexxPort;
    void (*ArexxFunction) (struct IGRequest *,struct RexxMsg *);
	/*  Port to which Arexx messages are coming in.  IGRequest will
	    process and reply to the following commands:
		KEYCLICK qualifiers key
		GADGETCLICK gadgetname
		SETSTRINGGAD stringgad string

	    If IGRequest can't find the specified gadget, or encounters an
	    unrecognized commands, the RexxMsg will be passed to your
	    ArexxFunction to process.  If an ArexxFunction
	    is not specified, an error will be set. IGRequest replies to all
	    RexxMsgs.
	*/

    ULONG AdditionalSignals; /* Additional signals to Wait on */
    BOOL  (*SignalFunction) (struct IGRequest *,ULONG);

	/* Called before IGRequest goes into wait state.  Use this to test
	    Ports that you are waiting on through AdditionalSignals for messages.
	    Process one message at a time.  Return 0 if IGRequest can go
	    into a wait state, 1 if you require further processing time,
	    in which case your function will be called again (after checking
	    the window port, calling the loopfunction, etc.)


	     SignalFunction (IGRequest,Signals);
	*/


    /* The Following correspond with IDCMP messages, and are called when that
     *	message is recieved
    */

    void (*GUpFunction)         (struct IGRequest *,struct IntuiMessage *);
    void (*GDownFunction)       (struct IGRequest *,struct IntuiMessage *);
    void (*MouseButtons)        (struct IGRequest *,struct IntuiMessage *);
    void (*MouseMove)           (struct IGRequest *,struct IntuiMessage *);
    void (*DeltaMove)           (struct IGRequest *,struct IntuiMessage *);
    void (*RawKey)              (struct IGRequest *,struct IntuiMessage *);
    void (*IntuiTicks)          (struct IGRequest *,struct IntuiMessage *);
    void (*DiskInserted)        (struct IGRequest *,struct IntuiMessage *);
    void (*DiskRemoved)         (struct IGRequest *,struct IntuiMessage *);
    void (*MenuVerify)          (struct IGRequest *,struct IntuiMessage *);
    void (*MenuPick)            (struct IGRequest *,struct IntuiMessage *);
    void (*SizeVerify)          (struct IGRequest *,struct IntuiMessage *);
    void (*NewSize)             (struct IGRequest *,struct IntuiMessage *);
    void (*ReqVerify)           (struct IGRequest *,struct IntuiMessage *);
    void (*ReqSet)              (struct IGRequest *,struct IntuiMessage *);
    void (*ReqClear)            (struct IGRequest *,struct IntuiMessage *);
    void (*ActiveWindow)        (struct IGRequest *,struct IntuiMessage *);
    void (*InActiveWindow)      (struct IGRequest *,struct IntuiMessage *);
    void (*RefreshWindow)       (struct IGRequest *,struct IntuiMessage *);
    void (*NewPrefs)            (struct IGRequest *,struct IntuiMessage *);
    void (*CloseWindow)         (struct IGRequest *,struct IntuiMessage *);
    void (*DoubleClick)         (struct IGRequest *,struct IntuiMessage *);

    struct MessageHandler *OtherMessages;
    APTR UserData;
};

#endif INTUIGEN_H


