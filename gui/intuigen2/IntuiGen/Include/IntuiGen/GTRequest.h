/*
GTRequest.h

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
#include <utility/tagitem.h>

/*
	This file is Copyright 1993 Justin Miller

	It may be freely distributed as follows:
	    1) In compiled form by owners of IntuiGen
	    2) As part of an IntuiGen demo disk
	Modified versions of this file may be distributed only in
	compiled form by owners of IntuiGen.  All rights not
	expressly granted herewith are reserved.
*/

#ifndef GTREQUEST_H

#define GTREQUEST_H

/**************************************************************************/
/* Define these however you want depending on the floating point options  */
/*				You are using.				  */
/**************************************************************************/

typedef ULONG GTFLOAT;

#define FloatToString(string,flt) sprintf(string,"%d",flt)
#define StringToFloat(s) atol(s)


/**************************************************************************/
/*	  Useful macros for bitfield flags				  */
/**************************************************************************/

#define FLAGOFF(x,flag) ((x)&=0xffffffff^(flag))
#define FLAGON(x,flag) ((x)|=(flag))

#define SETFLAG(x,flag,onoff) (onoff ? ((x)|=(flag)) : ((x)&=0xffffffff^(flag)) )

#define ISFLAGON(x,flag) ((x) & (flag))
#define ISFLAGOFF(x,flag) (!((x) & (flag)))
#define GETFLAG(x,flag) ((x) & flag)


/**************************************************************************/
/*		   GTRequest/Control Tags				  */
/**************************************************************************/

#define TAG_GTR_BASE (TAG_USER | (1<<16))

/**************************************************************************/
/*			Prefixes for Tags				  */
/**************************************************************************/
/* GTRT is a Request Tag						  */
/*	It should be placed in list pointed to by Request->RequestTags	  */
/*									  */
/* GTCT is a Control Tag						  */
/*	It should be placed in list pointed to by Control->ControlTags	  */
/*									  */
/* GTPK is a Gadget Tag for pseudo kind 				  */
/*	It should be placed in list pointed to by Control->GadgetTags	  */
/*									  */
/* GTGT is a Gadget Tag for GadTools kind which is intercepted by GTRequest */
/*	It should be placed in list pointed to by Control->GadgetTags	  */
/**************************************************************************/


/**************************************************************************/
/*	These tags are for String_Kind controls 			  */
/*	  They are used to set minimum, maximum limits, and illegal chars */
/**************************************************************************/

#define GTCT_INT_MIN (TAG_GTR_BASE + 1)
#define GTCT_INT_MAX (TAG_GTR_BASE + 2)
#define GTCT_STRING_INVALIDCHARS (TAG_GTR_BASE + 3)

/**************************************************************************/
/*		Don't use these next two                                  */
/**************************************************************************/

#define GTCT_TOGGLED (TAG_GTR_BASE + 4)  /* These 2 really aren't control tags */
#define GTCT_NEXTDATATOGADGETADDRESS (TAG_GTR_BASE +4) /* use synonyms def'd
							    below */

/**************************************************************************/
/* If the ti_Data for a tag should be the Gadget Address of a created	  */
/*  GadTools Gadget (i.e. To get an editable ListView ShowSelected        */
/*  String_Kind, you have to pass it the address of an already created	  */
/*  String_Kind), use GTGT_NEXTDATATOGADGETADDRESS.  The data value of	  */
/*  the next tag is assumed to be a pointer to a GTControl.  This	  */
/*  GTControl is created first, and the address of the resulting gadget   */
/*  returned by GadTools is placed in place of the GTControl pointer.	  */
/*  The GTGT_NEXTDATATOGADGETADDRESS tag is turned into a TAG_IGNORE.	  */
/*  These changes are actually performed on a duplicate of the TagList,   */
/*  so the original taglist is unmodified for future calls to GTRequest.  */
/**************************************************************************/

#define GTGT_NEXTDATATOGADGETADDRESS GTCT_NEXTDATATOGADGETADDRESS

/**************************************************************************/
/*  For ImageButton PseudoKind						  */
/**************************************************************************/

#define GTPK_Image (TAG_GTR_BASE + 5)         /* Arg = struct Image * */
#define GTPK_Toggleselect (TAG_GTR_BASE + 6)  /* Arg = T/F */
#define GTPK_SelectedImage (TAG_GTR_BASE + 7) /* Arg = struct Image * */
					      /* If not specified, GADGHCOMP
						    used */
#define GTPK_Toggled GTCT_TOGGLED	      /* Arg = T/F */


/************************************************************************/
/****			   Info for EditList PseudoKind 	     ****/
/************************************************************************/

#define GTPK_Remember (TAG_GTR_BASE + 5) /* Arg = struct Remember ** */
#define GTPK_List     GTLV_Labels	 /* Arg = struct List * */
#define GTPK_Alpha    (TAG_GTR_BASE + 7) /* Arg = T/F */
#define GTPK_NodeSize (TAG_GTR_BASE + 8) /* Arg = ULONG */
#define GTPK_SetList  (TAG_GTR_BASE * 9) /* Arg =
						void (*SetList)
						    (GTRequest *,
						     GTControl *,
						     List *);

					    This should Attach/disattach
					    list to all controls associated
					    with list, so changes will show
					    up in all ListView gadgets.
					  */

/* Messages An EditList will send out to MessageHandlers */
/*

ChangedEntry
    msg->IAddress = ENTRY

AddedEntry
    msg->IAddress = NEWENTRY

ChangedList
    msg->IAddress = LIST

DeletedEntry
    msg->IAddress = DELETEDENTRY

GadgetUp (New Selection)
    msg->Code = Entry's ord. #
    msg->IAddress = ENTRY

*/

/**************************************************************************/
/*		Internal Use by GTRequest				  */
/**************************************************************************/

#define GTC_GOTRAWKEY 1
#define GT_INPUTBLOCKED 8
#define GT_GADGETSADDED 16

/**************************************************************************/
/*	    These are flags for Control->Flags				  */
/**************************************************************************/

#define GTC_ATTROVERRIDESSTRING 8
    /* This indicates that control->Attribute should be used
	instead of converting the contents of a string gadgets
	buffer to the appropriate type and using this value.
    */
#define GTC_PSEUDOKIND 16
    /* Specify this, and the control is assumed to be of a user type.
       GTControl->Kind should point to a string which gives the class
       of this control.  The local custom control class list, and then
       the global list are searched to find the function to create this
       type.  See struct GTPKind for more info.
    */


#define GTC_INTERNALCONTROL 32	     /* If Pseudo controls need to add
					      other controls to the requester
					      They should call AllocControl
					      to do so and then set one of these
					      2 flags.	The first marks
					      this as a pseudo control which
					      will be removed from the control
					      list when the request is ended
					      and freed.
					      The second indicates the same
					      thing, but in addition tells
					      GTRequest not to take any action
					      to initialize this control.
					      (It's Gadget will not be
					       created; it is assumed to have
					       already been created)
					    */
#define GTC_INTERNALCONTROLIGNORE 64


#define GTC_INITFROMDATA 2
#define GTC_STOREDATA 4

/**************************************************************************/
/*		These flags are for use in Request->Flags		  */
/**************************************************************************/

#define GT_INITFROMDATA 2
#define GT_STOREDATA	4


/**************************************************************************/
/*		Synonyms for above flags, can be used in either 	  */
/*		    Control->Flags or Request->Flags			  */
/**************************************************************************/

#define INITFROMDATA GT_INITFROMDATA
#define STOREDATA GT_STOREDATA


/**************************************************************************/
/* These are the data types that can be copied between struct fields and  */
/*	    Controls.							  */
/**************************************************************************/

#define FLD_NONE  0  /* No data is copied to or from structure */
#define FLD_SHORT 1
#define FLD_LONG 2
#define FLD_FLOAT 3  /* This uses GTFLOAT typedef, must be 4 bytes in length */
		     /* It is assumed you are using a STRING_KIND control for
			adjusting floats.  If you are not, you will need to
			override default setting/reading code in the particular
			control
		     */
#define FLD_BYTE   4
#define FLD_POINTER 5

/* The Bit field storage types require that the field given be of type
    ULONG!!
*/
#define FLD_BOOLBIT 6 /* SETFLAG(field,1<<control->Bit,control->Attribute) */
#define FLD_ATTRBIT 7 /* field=1<<control->Attribute */
		      /* The above (ATTRBIT) is especially useful for
			 LISTVIEWS, MX_KINDS, etc, where you are given
			 an ordinal position and you wish to encode it
			 a ULONG
		      */

/*  These next 2 can be written into the data structure,
    but they can't be written into the gadgets without special code
    specified for the appropriate control.  You probably won't use them.   */

#define FLD_ORATTR  8 /* field|=control->Attribute */
#define FLD_ORATTRBIT 9 /* field|=1<<control->Attribute */


#define FLD_STRINGINSTRUCT 10 /* if your structure looks like this:
				    struct mystruct {
					type1 field1;
					type2 field2;
					...
					UBYTE TheField[X];
					type3 field4;
					type4 field5;
					...
				    };
				  Then use this flag to store data in
				  TheField
			       */

#define FLD_STRINGPOINTEDTOINSTRUCT 11 /* if your structure looks like this:
					      struct mystruct {
						  type1 field1;
						  ...
						  UBYTE *TheField;
						  typeX FieldX;
						  ...
					      };
					   Then use this flag to copy the
					   string to the buffer pointed to
					   by TheField
				       */

#define FLD_STRINGPTR 12  /* if your structure looks like the one above
			     (for STRINGPOINTEDTOINSTRUCT) and you
			     want to set TheField=control->Attribute
			     (without performing a strcpy)
			     use this.
			  */


/**************************************************************************/
/*		    MessageClass structure				  */
/**************************************************************************/
/*  Use this to set up handling routines for classes of messages or	  */
/*  sequences of messages not supported by IGRequest.  (Shift Click,      */
/*  Triple Click, etc.) 						  */
/**************************************************************************/

struct MessageClass {
    UBYTE *Name; /* Name of this message class, case significant */
    BOOL  (*IsType) (struct GTRequest *,struct IntuiMessage *,struct GTControl *,struct MessageHandler *mh);
	/* Called on every message.  Should return 1 if the message
	    constitutes the correct type, 0 otherwise */
};

/**************************************************************************/
/*		    MessageHandler structure				  */
/**************************************************************************/

struct MessageHandler {
    struct MessageHandler *Next;
    UBYTE *Name; /* Name of class to which this handler belongs. */

    BOOL (*IsType) (struct GTRequest *,struct IntuiMessage *,
		    struct GTControl *,struct MessageHandler *);

	/* if this is a member of a class (Name!=NULL) and GTRequest can find
	    the MessageClass struct for this class, (either in its global list,
	    or its GTRequest list) this will be initialized; hence it can be
	    left NULL.	If this Handler is unique, and doesn't belong to
	    a class, or you would like to override the class default IsType
	    function, enter a function pointer here.
	*/

    void (*HandlerFunction) (struct GTRequest *,struct IntuiMessage *,
			      struct GTControl *,struct MessageHandler *);
	/* If IsType () returns 1, this is called */

	/* The address of this structure is passed to the HandlerFunction.
	   Hence, you can make custom structures embedding this one
	   to pass additional data to this function if you like
	*/
};

/**************************************************************************/
/*		    GTControl structure 				  */
/**************************************************************************/

struct GTControl {
    struct GTControl *Next;
    ULONG  Kind;
    ULONG  Flags;
    struct TagList *GadgetTags;
    struct TagList *ControlTags;
    struct NewGadget *NewGadget;
    struct Gadget    *Gadget;
    struct MessageHandler *MsgHandlerList;

    USHORT  ASCIICommand;   /* do not use qualified characters here */
			    /* use Qualifier below  */

    USHORT  RawKeyCommand;  /* Will automatically be filled in (using current
				keymap) if ASCIICommand is filled in */
    USHORT  Qualifier;
    UBYTE   Pad1;
    UBYTE   Pad2;

    BOOL (*HandleKeyCommand) (struct GTRequest *,struct GTControl *,struct IntuiMessage *);
	/*  If this is non-zero, it is called everytime a RAWKEY message is
	    received to check if the RAWKEY message is a keyboard command
	    for this control, and if so to take whatever action is necessary.
	    If it is not present, default processing is done based on the
	    above vaules.
	    Return True if this was a valid Keyboard command for your control,
	    False otherwise.
	*/

    USHORT  FieldOffset;
    USHORT  FieldType;
    USHORT  FieldSize;
    UBYTE   FieldBit;
    UBYTE   Pad3;
    ULONG   Attribute; /* Except for Kinds STRING_KIND and INTEGER_KIND
			   message processing functions
			   Should Cause this to contain the value
			   of the GTGadget to be stored to the data structure */

    ULONG   AttributeTag; /* Used in setting Gadget Attribute from data struct info */

    void (*SetGadgetFromData) (struct GTRequest *,struct GTControl *,APTR);
	/*  If this is non-NULL, it is called to initialize the control from
	    information given in GTRequest->DataStruct.  APTR points to the
	    field within DataStruct which this control is associated with.
	    If not specified (NULL), default processing is used (assuming
	    INITFROMDATA flag is set) */

    void (*SetDataFromGadget) (struct GTRequest *,struct GTControl *,APTR);
	/* If this is non-NULL, it is called to copy the data represented
	   by the control into the data structure.  The arguments are the
	   same as above.  Again, if not specified, default processing is
	   used (assuming STOREDATA flag is set)
	*/

    void (*GUpUpdateControl) (struct GTRequest *,struct GTControl *,struct IntuiMessage *);
    void (*GDownUpdateControl) (struct GTRequest *,struct GTControl *,struct IntuiMessage *);
	   /* If either of these is non-null, they will be called every time
	      this control recieves either a GadgetUp or GadgetDown message.
	      They should update the GTControl->Attribute field as required
	      by the contents of the passed message.  If these values are null,
	      defaults are supplied for:
		    CHECKBOX_KIND, MX_KIND, CYCLE_KIND, SCROLLER_KIND,
		    SLIDER_KIND, LISTVIEW_KIND, PALETTE_KIND,
		    STRING_KIND, and INTEGER_KIND
	      If these values are 0xffffffff (-1L) no function is called
	      at all for this control.
	    */

    void (*SetAttrs) (struct GTRequest *,struct GTControl *,struct TagItem *);
	/* If this is Non-Null this is called instead of GT_SetGadgetAttrs
	   to set an attribute.  It will (and should) usually pass its
	   data on to GT_SetGadgetAttrs. Particularly useful for pseudo-
	   controls.
	*/
    APTR   UserData;
};

/**************************************************************************/
/*		    GTPKind structure					  */
/*			Used for setting up additional pseudokinds	  */
/**************************************************************************/

struct GTPKind {
    UBYTE *Name;
    struct Gadget * (*Create) (struct GTPKind *,struct Gadget *,struct GTControl *,struct GTRequest *,struct VisualInfo *);
    void (*Destroy) (struct GTPKind *,struct GTControl *,struct GTRequest *);
};


/**************************************************************************/
/*		  GTMenuInfo structure					  */
/*		   Used for linking menu events to functions to be called */
/**************************************************************************/

struct GTMenuInfo {
    USHORT Code;
    void (*Function) (struct GTRequest *,struct IntuiMessage *);
};

/**************************************************************************/
/*			GTReqSet structure				  */
/*			  Used for opening many requesters simultaneously */
/**************************************************************************/

struct GTReqSet {
    struct List List;
    struct MsgPort *MsgPort;
};


/**************************************************************************/
/*		    GTRequest structure 				  */
/* This is the top level structure which contains pointers to all the	  */
/*  others' lists.  A pointer to one of these structures is passed to     */
/*  GTRequest.								  */
/**************************************************************************/

struct GTRequest {
    struct TagList *NewWindowTags; /* pointer to NewWindow to open */
				 /* pointer to opened window will be
				    placed in IGRequest->Window field */
    struct Window *Window; /* Pointer to already opened window
			       If you would like GTRequest to use a window
				you open, place a pointer to it here,
				and leave NewWindowTags NULL
			   */
    struct NewMenu *Menus;
    struct GTMenuInfo *MenuInfo;
    struct GTControl *Controls; /* pointer to first control in requester to use */
    ULONG Flags;
    struct TagItem *RequestTags;
    struct Border *Borders;  /* pointer to Border list to draw into window */
    struct Image *Images;    /* pointer to Image list to draw into window */
    struct IntuiText *ITexts; /* pointer to IntuiText list to write into window */
    void   (*InitFunction) (struct IGRequest *); /* function to call when requester first opened */

    LONG Terminate; /* Can be set by outside routines to */
		 /* force request to end, >0==FillStruct, <0==!FillStruct */

    struct MsgPort *IComPort; /* Internal use only.  Initialize to 0 */

    APTR DataStruct;
    void (*EndFunction) (struct IGRequest *,struct IntuiMessage *);
     /* To be called when requester ends.
      * This is called after any EndList EndFunction */

    void (*LoopFunction) (struct IGRequest *);
			     /* This function is called repeatedly
			      * while there is not a message at the
			      * Window port and while CallLoop!=0
			     */

    ULONG CallLoop;
    ULONG LoopBitsUsed;

    ULONG AdditionalSignals; /* Additional signals to Wait on */
    BOOL  (*SignalFunction) (struct GTRequest *,ULONG);

	/* Called before IGRequest goes into wait state.  Use this to test
	    Ports that you are waiting on through AdditionalSignals for messages.
	    Process one message at a time.  Return 0 if IGRequest can go
	    into a wait state, 1 if you require further processing time,
	    in which case your function will be called again (after checking
	    the window port, calling the loopfunction, etc.)


	     SignalFunction (IGRequest,Signals);
	*/


    struct MessageClass *LocalMsgClassList; /* Must be NULL terminated array */
    struct GTPKind *LocalPKindClassList; /* Must be NULL terminated array */

    struct MessageHandler *MsgHandlerList;

    ULONG  AppIDCMP; /* Internal use only! */
    struct IntuiMessage *LastGadgetEvent;  /* For use by GTRequest, Message Handlers */
    struct IntuiMessage *BeforeLastGadgetEvent;
    struct Remember *GTKey; /* Internal use. Do not free (will be freed
				    on exit from GTRequest) */
    struct GTControl *ActiveControl;
    APTR InternalData; /* Internal use only, init to zero */
    struct GTControl *EndControl; /* Pointer to control that caused requester
					to terminate */
    struct MessageHandler *EndMsgHandler; /* Pointer to MsgHandler that
						caused requester to
						terminate
					  */
    APTR UserData;
};



/**************************************************************************/
/*			       Function Prototypes			  */
/**************************************************************************/


/**************************************************************************/
/* Functions to control requester behavior while it is running		  */
/**************************************************************************/

/*  Call this to end requester */

__far void EndGTRequest(struct GTRequest *req,LONG terminate,
		   struct MessageHandler *mh,struct GTControl *gtc);
		     /**************************************/


/*
   This function sends a simulated IntuiMessage to a GTRequest.
    GTRequest will normally take care of freeing the message.
*/

__far BOOL GTSendIntuiMsg (struct GTRequest *req,ULONG Class,ULONG Code,
		    USHORT Qualifier,APTR IAddress);

#define FreeIntuiMsg(x) FreeMem(x,sizeof(struct IntuiMessage))
		     /**************************************/

/*
   This function simulates a user keypress to the requester
*/

__far BOOL GTKeyClick (struct GTRequest *req,UBYTE *keyinfo,UBYTE key);
		     /**************************************/

/*
   This function will set an Integer_Kind control to the given number,
    and will simulate appropriate messages, making it appear to the program
    as if the user entered the new number
*/

__far void SetIntControl (struct GTRequest *req,struct GTControl *gtc,LONG number);
		     /**************************************/

/*
   This function will set a String_Kind control to the given string,
    and will simulate appropriate messages, making it appear to the program
    as if the user entered the new string
*/

__far void SetStringControl (struct GTRequest *req,struct GTControl *gtc,UBYTE *string);
		     /**************************************/

/*
   This function will simulate a user mouse press over the given gadget
    The corresponding macro simulates a user mouse press over a control
*/

__far BOOL GTGadgetClick(struct GTRequest *req,struct Gadget *gadg);

#define GTControlClick(r,g) GTGadgetClick(r,(g)->Gadget)
		     /**************************************/

/*
    GTBlockInput Function opens an blank intuition requester on top
    of an IGRequest, thereby blocking it from receiving input
*/
__far void GTBlockInput(struct GTRequest *req);
		     /**************************************/

/*
    UnBlockIGInput closes blank requester opened by BlockIGInput, thereby
    permitting messages to come through again
    Calls to GTBlock/UnBlockIGInput can be nested; a nesting depth count
							is kept
*/
__far void GTUnBlockInput(struct GTRequest *req);

#define GTBlockIGInput GTBlockInput
#define GTUnBlockIGInput GTUnBlockInput

		     /**************************************/

/* You must use this instead of ModifyIDCMP!! */

__far void GTReqModifyIDCMP(struct GTRequest *req,ULONG IDCMP);
		     /**************************************/

/* You must use these instead of GT_SetGadgetAttrs & GT_SetGadgetAttrsA */

__far void SetControlAttrsA (struct GTRequest *req,struct GTControl *gtc,struct TagItem *ti);
__far void SetControlAttrs(struct GTRequest *req,struct GTControl *gtc,Tag tag1,...);
		     /**************************************/

/*
    This function searches through a GTControl's MessageHandler list
	for a MessageHandler of the given class, and then calls that
	MessageHandler's HandlerFunction.  IsType isn't called;
	the message is by definition of the given type.
	This allows you to set up additional classes of messages
	for controls and Pseudocontrols, as a class can be named
	anything you would like.  The EditList pseudokind uses
	this stategy.
*/

__far void SendMessageToControl(struct GTRequest *req,struct GTControl *gtc,struct IntuiMessage *msg,
				UBYTE *class);
		     /**************************************/

/*
    This function adds an internal Control to a GTRequest's control list.
    An internal control is one that is created by a pseudokind and is removed
    from the list when the requester is terminated.  EditList kind uses this
    function.
*/

__far void AddInternalControl(struct GTRequest *req,struct GTControl *parent,struct GTControl *gtc,ULONG type);
		     /**************************************/

/*
    This function allocates a NewGadget structure on the Request's ReqKey,
	which is automatically freed.  Used for creating internal controls.
	Used by EditList PKind.
*/

__far struct NewGadget *AllocNewGadget(struct GTRequest *req,struct NewGadget *sg,
					    LONG x,LONG y,LONG w,LONG h);
		     /**************************************/

/**************************************************************************/
/*	These macros extract information about the requester's mode of    */
/*	    termination from the request structure			  */
/**************************************************************************/

#define GetTerminate(req) ((req)->Terminate)
#define GetEndControl(req) ((req)->EndControl)
#define GetEndMsgHandler(req) ((req)->EndMsgHandler)


/**************************************************************************/
/*	Utility functions						  */
/**************************************************************************/


/*
    Takes pointer to linked list of controls, and finds and returns
    the one that is related to the given gadget
*/
__far struct GTControl *FindGadgetControl(struct GTControl *gtc,struct Gadget *g);
		     /**************************************/


/*
  Takes RAWKEY code and qualifier (from an IntuiMessage) and returns
   ASCII equivalent
*/
__far UBYTE RawKeyToAscii (USHORT code,USHORT qual);
		     /**************************************/


/* Takes ASCII char and returns Rawkey code.  ASCII code must correspond to
   letter painted on keyboard keycap (the unqualified value).  Qualifier
   must be determined as follows (Under IGRequest which does not
   differentiate between right and left):

	SHIFT =  1
	ALT   = 16
	CTRL  =  8
	AMIGA = 64

   Returns -1 error.
*/

__far SHORT ASCIIToRawKey (char c);
		     /**************************************/
/*
    ClearWindow Function, clears inside of window to background (0)
    Used by GTRequest on exit if it doesn't close the window.
*/
__far void ClearWindow (struct Window *w);
		     /**************************************/

/*
    This function returns a pointer to the first item in an exec list,
	or NULL if the list is empty
*/

struct Node *FirstItem(struct List *l);
		     /**************************************/

/*
    This function returns a pointer to the next node in an exec list,
	or NULL if the given node is the last valid node
*/
struct Node *NextItem(struct Node *n);
		     /**************************************/

/*
    This macro determines whether a node is valid (contains data or is
	part of the ListHead structure)
*/
#define NodeValid(n) ((n)->ln_Succ->ln_Succ)
		     /**************************************/

/*
    This function returns the ordinal position +1 of c in set.
     If c isn't in set, it returns 0.  set is a string (NULL delimited).
*/
__far int cismember (char c,char *set);
		     /**************************************/

/* deletes n chars starting at position p from string s */

__far void delchars (char *s,USHORT p,USHORT n);
		     /**************************************/

/*
   when k is true, only chars in elim allowed, otherwise,
    only chars not in elim allowed
*/
__far BOOL strelim (char *s,char *elim,BOOL k);
		     /**************************************/

/*
  Generates the necessary structures and SHORT values for a two pixel thick,
   two color box.  Returns pointer to first of two Border structures.  All
   information is allocated on the Remember key
*/

__far struct Border *MakeBox (USHORT w,USHORT h,UBYTE c1,UBYTE c2,struct Remember **key);
		     /**************************************/

/*
    This function will detach the UserPort from a window so that
	the window may be closed without closing the UserPort,
	important if several windows are sharing a UserPort.
*/

void DetachUserPort(struct Window *win);
		     /**************************************/


/***********************************************************/
/* These are the routines that the user will call to	   */
/* GTRequest behavior as it is running. 		   */
/***********************************************************/


/* Allocates a CallLoop Bit for a GTRequester */
BYTE GTAllocCLBit (struct GTRequest *req);

/* Frees a CallLoop Bit for a GTRequester */
void GTFreeCLBit (struct GTRequest *req,UBYTE bit);


/**************************************************************************/
/*  The actual GTRequest Function.  This is the top level function and is */
/*  what you actually need to call to open and execute your requester.	  */
/**************************************************************************/

__far LONG GTRequest (struct GTRequest *req);
		     /**************************************/

/**************************************************************************/
/*  These functions are used when dealing with a set of simultaneously	  */
/*   Open, active requesters						  */
/**************************************************************************/

/*
    This function initializes a ReqSet structure.  It must be called
	before any requests are added to the ReqSet.
*/

void InitReqSet(struct GTReqSet *rs);
		     /**************************************/

/*
    This function calls EndGTRequest for each requester in a ReqSet,
	Causing them all to end as soon as ProcessReqSet is called/returned to
*/

void EndAllRequests(struct GTReqSet *rs,LONG terminate,struct MessageHandler *mh,
			struct GTControl *gtc);
		     /**************************************/

/*
    This function opens a requester, allocates the gadgets, displays imagery,
	etc, and adds the requester to the ReqSet
*/

LONG AddGTRequest(struct GTReqSet *rs,struct GTRequest *gtr);
		     /**************************************/

/*
    Call This function to process messages sent to all requesters in
	the given ReqSet.  Each requester will work just as if it
	had been opened by GTRequest and was running by itself.
	More requesters can be added to the set while ProcessReqSet is
	running.  ProcessReqSet returns only when all requesters in the
	ReqSet have terminated.
*/
__far void ProcessReqSet (struct GTReqSet *set);
		     /**************************************/

/*
    You cannot call AddGTRequest and add the same requester to a ReqSet
	twice.	You must duplicate the Requester and add the duplicate
	to the ReqSet.	The below function does this.  When the request
	is finished, free the key to recover memory.
*/

struct Request *DuplicateRequest (struct Remember **key,struct GTRequest *req);
		     /**************************************/

#endif GTREQUEST_H

