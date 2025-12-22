MODULE OberObjects;

(*  Matt's first serious Oberon-A programming attempt!
	Oberon Objects attempts to make programming a GUI on the amiga easy
	this is currently very difficult (without practise that is) and
	this program takes the pain out of it. Currently it is restricted
	to GadTools gadgets, but I think it is system friendly enough to
	add other types (eg Boopsi) of gadgets. *)

(* $Id: OberObjects.mod 1.14 1996/12/23 08:59:22 MattS Exp MattS $ *)

<*$NilChk-*>
<*$CaseChk-*>
<*$OvflChk-*>
<*$TypeChk-*>
<*$LongVars+*>


IMPORT e := Exec, i := Intuition, gt := GadTools, U := Utility, Dos,
		Errors, SYS := SYSTEM, Events, iutil:=IntuiUtil,
		gfx := Graphics, Kernel, Sets,
		esup := ExecSupport, Strings, InputEvent, KeyMapLib;

TYPE
	ObjTags *               = POINTER TO ARRAY OF U.TagItem;
	LabelType *             = POINTER TO ARRAY OF e.STRPTR;

	OberPort                = POINTER TO OberPortDesc;
	OberRawKeyDecoder *     = POINTER TO OberRKDDesc;

	OberObject *            = POINTER TO OberObjectDesc;
	OberScreen *            = POINTER TO OberScreenDesc;
	VirtWindow              = POINTER TO VirtWindowDesc;
	OberWindow *            = POINTER TO OberWindowDesc;
	OberMenuItem *          = POINTER TO OberMenuItemDesc;
	OberGroupBox *          = POINTER TO OberGroupBoxDesc;

	OberCanvas *            = POINTER TO OberCanvasDesc;
	OberGraphic *           = POINTER TO OberGraphicDesc;

	(* Gadgets *)
	OberGadget *            = POINTER TO OberGadgetDesc;

	OberPushButton *        = POINTER TO OberPushButtonDesc;
	OberCheckBox *          = POINTER TO OberCheckBoxDesc;
	OberRadioButton*        = POINTER TO OberRadioButtonDesc;
	OberCycleGadget*        = POINTER TO OberCycleGadgetDesc;
	OberListView *          = POINTER TO OberListViewDesc;
	OberIntegerGad *        = POINTER TO OberIntegerGadDesc;
	OberStringGad *         = POINTER TO OberStringGadDesc;
	OberStaticText *        = POINTER TO OberStaticTextDesc;
	OberStaticNumber *      = POINTER TO OberStaticNumberDesc;
	OberPaletteGad *        = POINTER TO OberPaletteGadDesc;
	OberScrollerGad *       = POINTER TO OberScrollerGadDesc;
	OberSliderGad *         = POINTER TO OberSliderGadDesc;


	cbProcType *            = PROCEDURE (ob : OberObject; SpecialCode : e.UWORD);
	
	WinKey                  = RECORD
								gadget      : OberGadget;
								key         : CHAR;
							  END;
	OberWinKeys             = POINTER TO ARRAY OF WinKey;

	OberObjectDesc *        = RECORD
								Parent -            : OberObject; (* Read Only Parent object *)
								Name -              : POINTER TO ARRAY OF CHAR;
								Visible             : BOOLEAN;
								initialized -       : BOOLEAN;
								tagList -           : ObjTags;
							  END;

	OberCanvasDesc *        = RECORD (OberObjectDesc)
								iObject -           : gfx.RastPortPtr;
							  END;

	OberGadgetDesc *        = RECORD (OberObjectDesc)
								enabled             -   : BOOLEAN;
								iObject             -   : i.ExtGadgetPtr;
								defCbProc               : cbProcType;
								gadDownCbProc           : cbProcType;
								gadDblClkCbProc         : cbProcType;
								gadHelpCbProc           : cbProcType;
								gadText             -   : POINTER TO ARRAY OF CHAR;
							  END;

	OberPushButtonDesc *    = RECORD (OberGadgetDesc)
							  END;

	OberCheckBoxDesc *      = RECORD (OberGadgetDesc)
							  END;

	OberRadioButtonDesc *   = RECORD (OberGadgetDesc)
								Labels -    : LabelType;
								NumLabels - : INTEGER;
							  END;

	OberCycleGadgetDesc *   = RECORD (OberGadgetDesc)
								Labels -    : LabelType;
								NumLabels - : INTEGER;
							  END;

	OberListViewDesc *      = RECORD (OberGadgetDesc)
								NumLabels - : INTEGER;
								List        : e.List;
							  END;

	OberIntegerGadDesc *    = RECORD (OberGadgetDesc)
							  END;

	OberStringGadDesc *     = RECORD (OberGadgetDesc)
							  END;

	OberStaticTextDesc *    = RECORD (OberGadgetDesc)
							  END;

	OberStaticNumberDesc *  = RECORD (OberGadgetDesc)
							  END;

	OberPaletteGadDesc *    = RECORD (OberGadgetDesc)
							  END;

	OberScrollerGadDesc *   = RECORD (OberGadgetDesc)
							  END;

	OberSliderGadDesc *     = RECORD (OberGadgetDesc)
							  END;


	VirtWindowDesc          = RECORD (OberObjectDesc)
								Title -         : POINTER TO ARRAY OF CHAR;
								parentWin -     : OberWindow;
							  END;

	OberWindowDesc *        = RECORD (VirtWindowDesc)
								iObject -       : i.WindowPtr;
								WinsPort -      : OberPort;
								gtContext -     : i.GadgetPtr;
								LastGadget -    : i.GadgetPtr;
								vi -            : e.APTR;
								NumMenuItems -  : INTEGER;
								menuStrip -     : i.MenuPtr;
								oldRegion       : gfx.RegionPtr;
								keyShorts       : OberWinKeys;
								windowGad       : OberGadget;
								gadHelpCbProc   : cbProcType;
							  END;


	OberGroupBoxDesc *      = RECORD (VirtWindowDesc)
							  END;


	OberPortDesc            = RECORD (Events.GadToolsPortRec)
								PortsWin : OberWindow;
							  END;

	OberScreenDesc *        = RECORD (OberObjectDesc)
								iObject -       : i.ScreenPtr;
								Title -         : POINTER TO ARRAY OF CHAR;
							  END;

	OberMenuItemDesc *      = RECORD (OberObjectDesc)
								enabled     : BOOLEAN;
								CbProc      : cbProcType;
								Text        : POINTER TO ARRAY OF CHAR;
								Type        : SHORTINT;
								commandKey  : CHAR;
								MX          : Sets.SET32;
								IsAttribute : BOOLEAN;
								IsChecked   : BOOLEAN;
							  END;


	ObjectNode *            = POINTER TO ObjectNodeDesc;
	ObjectNodeDesc *        = RECORD
								Object -    : OberObject;
								Children -  : ObjectNode;
								Sibling -   : ObjectNode;
							  END;


	OberRKDDesc *           = RECORD
								qualifier -     : Sets.SET16;
								key -           : CHAR;
								mesg            : i.IntuiMessagePtr;
							  END;

	OberGraphicDesc *       = RECORD (OberObjectDesc)

							  END;

CONST
	Continue *      = Events.Continue;
	Pass *           = Events.Pass;
	Stop *           = Events.Stop;
	StopAll *        = Events.StopAll;

CONST
	(* Object Tags *)
	(***************)
	obBase *          = U.user + 600000H;

	obText *          = obBase + 20;
	(* These tags apply to all objects EXCEPT screens (obviously you can't
	control the positioning of a screen!).
	NOTE: These tags override anything set by waWidth, waTop etc. *)
	obLeft *          = obBase + 1;
	obTop *         = obBase + 2;
	obRight *        = obBase + 3;
	obBottom *      = obBase + 4;
	obWidth *        = obBase + 5;
	obHeight *      = obBase + 6;

	(* The following form a basis for OberObjects resizability. *)
	(* NOT YET IMPLEMENTED *)
	obLeftFromLeftofParent *          = obLeft;
	obTopFromTopofParent *           = obTop;
	obRightFromLeftofParent *        = obRight;
	obBottomFromTopofParent *        = obBottom;

	obLeftFromRightofParent *        = obBase + 7;
	obRightFromRightofParent *      = obBase + 8;
	obTopFromBottomofParent *        = obBase + 9;
	obBottomFromBottomofParent *     = obBase + 10;

	obLeftFromLeftofPred *           = obBase + 11;
	obRightFromLeftofPred *         = obBase + 12;
	obTopFromTopofPred *                = obBase + 13;
	obBottomFromTopofPred *         = obBase + 14;

	obLeftFromRightofPred *         = obBase + 15;
	obRightFromRightofPred *          = obBase + 16;
	obTopFromBottomofPred *         = obBase + 17;
	obBottomFromBottomofPred *      = obBase + 18;


	oberBarLabel * = "----";

	normalPointer * = obBase + 1000;
	busyPointer *   = obBase + 1001;

	gtGadget *      = obBase + 2000;
	gtGadKind *     = obBase + 2001;
	gtExtraFlags *  = obBase + 2002;

	gadHelp *       = obBase + 2010;

	(* ModifyIDCMP flags *)
	Add *           = 1;
	Remove *        = 2;
	Change *        = 3;

	(* Use for comparing GetTagValue results *)
	LTRUE *         = SYS.VAL(LONGINT, TRUE);
	LFALSE *        = SYS.VAL(LONGINT, FALSE);

	(* Canvas flags *)
	fgColor *       = obBase + 2100;
	bgColor *       = obBase + 2101;
	drawMode *      = obBase + 2102;

VAR (* System variables *)
	MainEventLoop           : Events.EventLoop;
	ignoreSig               : Events.Signal;
	OberonObjectList        : ObjectNode;
	rider                   : INTEGER; (* Multi-use array rider *)

	prevDblClkGadget        : OberGadget; (* Used for DblClick tests *)
	prevDblClkSecs          : LONGINT;
	prevDblClkMicros        : LONGINT;


(* Show and hide - Virtual Functions *****************************

	Must be implemented in all child objects.
	Used to visually display or remove the object.
	Note: If the parent object is not visible, this should
		set a tag such that if the parent is made visible
		then this object is either hidden or shown.

******************************************************************)

PROCEDURE (ob : OberObject) Hide * ;
BEGIN END Hide;

PROCEDURE (ob : OberObject) Show * ;
BEGIN END Show;


(********************************************************************
 ===================================================================
		Miscellaneous Utility Functions
 ===================================================================
*********************************************************************)


PROCEDURE Do *;
BEGIN
	(* This procedure simply starts the main event loop, call this
	   after initializing all your windows and everything else you
	   want to do, otherwise nothing will happen! *)
	MainEventLoop.Do;
END Do;


(* clean *********************************************************

	Cleanup procedure called at program exit (or if there is a fault)
	removes all objects from screen and frees memory.

******************************************************************)

PROCEDURE Clean * (VAR rc : LONGINT); (* Given to Kernel.mod in SetCleanup() *)
VAR theNode : ObjectNode;
BEGIN
	Dos.PrintF("Cleaning Up\n", NIL);
	Dos.PrintF("Source Module : %s\n", SYS.ADR(Kernel.errModule));
	Dos.PrintF("Line Num : %ld\nCol Num : %ld\n", Kernel.errLine, Kernel.errCol);
	theNode := OberonObjectList.Children;
	IF theNode.Object # NIL THEN
		theNode.Object.Hide; (* Everything should be a child of this
										top level object *)
	END;
END Clean;


(********************************************************************
 ===================================================================
		OberRawKeyDecoder Functions
 ===================================================================
*********************************************************************)


(* OberRawKeyDecoder.Init *******************************************

	This function decodes the raw key held in the IntuiMessage given
	and stores the result in the member variables qualifier and key.
	Note the special handling of shifted cursor keys to remap them
	back to the unshifted cursor keys.

*********************************************************************)

<*$CaseChk+ *>

PROCEDURE (ob : OberRawKeyDecoder) Init * (msg : i.IntuiMessagePtr);
VAR
	iBuffer : ARRAY 20 OF CHAR;
	iEvent : InputEvent.InputEvent;
	result : INTEGER;
BEGIN
	iEvent.class := InputEvent.rawkey;
	iEvent.code := msg.code;
	iEvent.qualifier := msg.qualifier;
	result := KeyMapLib.MapRawKey(SYS.ADR(iEvent), iBuffer, 19, NIL);
	IF result # -1 THEN
		ob.qualifier := iEvent.qualifier;
		IF iBuffer[0] = CHR(InputEvent.repeat) THEN
			ob.key := iBuffer[1];
			IF ob.key = ' ' THEN
				ob.key := iBuffer[2];
				CASE ob.key OF
					'T' : ob.key := 'A';
				|   'S' : ob.key := 'B';
				|   '@' : ob.key := 'C';
				|   'A' : ob.key := 'D';
				END
			END
		ELSE
			ob.key := iBuffer[0];
		END
	END
END Init;

<*$CaseChk- *>

(* ObjectNode.Find **************************************************

	Find the node, beginning from this node with the name equal to that
	given. Returns NIL if not found.

*********************************************************************)

PROCEDURE (node : ObjectNode) Find * (Name : ARRAY OF CHAR) : ObjectNode;
VAR
	Found : ObjectNode;
BEGIN
	REPEAT
		IF node.Object # NIL THEN
			IF node.Object.Name^ = Name THEN
				RETURN node
			END;
		END;
		IF node.Children # NIL THEN
			Found := node.Children.Find(Name);
			IF Found # NIL THEN
				RETURN Found
			END;
		END;
		node := node.Sibling;
	UNTIL node = NIL;
	RETURN NIL;
END Find;


(* ObjectNode.FindObject ********************************************

	Find the node, beginning from this node containing the object
	given. Returns NIL if not found.

*********************************************************************)

PROCEDURE (node : ObjectNode) FindObject * (ob : OberObject) : ObjectNode;
VAR
	Found : ObjectNode;
BEGIN
	REPEAT
		IF node.Object = ob THEN
			RETURN node
		END;
		IF node.Children # NIL THEN
			Found := node.Children.FindObject(ob);
			IF Found # NIL THEN
				RETURN Found
			END;
		END;
		node := node.Sibling;
	UNTIL node = NIL;
	RETURN NIL;
END FindObject;


(* GetObject (And associated functions) ****************

	Gets the object from the object list with the given name.

****************************************************************)

PROCEDURE GetObject * (Name : ARRAY OF CHAR) : OberObject;
VAR
	node : ObjectNode;
BEGIN
	node := OberonObjectList.Find(Name);
	Errors.Assert(node # NIL, "Node not in list!");
	RETURN node.Object;
END GetObject;


(********************************************************************
 ===================================================================
		OberObject Functions
 ===================================================================
*********************************************************************)


(* OberObject.IsVisible *****************************************

	This looks up the objects tree to see if this object, and all
	its parents are visible.

*****************************************************************)

PROCEDURE (ob : OberObject) IsVisible * () : BOOLEAN;
BEGIN
	IF ~ob.Visible THEN
		RETURN FALSE
	END;
	IF ob.Parent # NIL THEN
		RETURN ob.Parent.IsVisible();
	ELSE
		RETURN TRUE;
	END;
END IsVisible;


PROCEDURE (ob : OberObject) GetText * (VAR text : ARRAY OF CHAR);
(* By Default return the name of the object *)
BEGIN
	COPY(ob.Name^, text);
END GetText;


(* OberObject.AddToList ********************************************

	This function adds the object to the object list (called
	OberonObjectList). This means that objects can be called from
	the list by name.

*****************************************************************)

PROCEDURE (ob : OberObject) AddToList *;
VAR
	node : ObjectNode;
	findNode : ObjectNode;
	theChild : ObjectNode;
BEGIN
	findNode := OberonObjectList.Find(ob.Name^);
	IF ob.Name^ # "" THEN (* Allow for null named objects *)
		Errors.Assert(findNode = NIL, "Object with this name exists already!");
	END;
	NEW(node);
	node.Object := ob;
	IF ob.Parent = NIL THEN
		OberonObjectList.Children := node
	ELSE
		findNode := OberonObjectList.FindObject(ob.Parent);
		theChild := findNode.Children;
		IF theChild = NIL THEN
			findNode.Children := node;
		ELSE
			WHILE theChild.Sibling # NIL DO
				theChild := theChild.Sibling;
			END;
			theChild.Sibling := node;
		END;
	END;
END AddToList;


(* OberObject.RemoveFromList ***************************************

	This function removes this object from the object list
	(OberonObjectList) and all of this objects children.
	This must be called when you want to "delete" the object.

*****************************************************************)

PROCEDURE (ob : OberObject) RemoveFromList *;
VAR
	node, parentNode, previous : ObjectNode;
BEGIN
	node := OberonObjectList.FindObject(ob);
	parentNode := OberonObjectList.FindObject(ob.Parent);
	Errors.Assert(node # NIL, "Node not in list!");
	IF ob IS OberMenuItem THEN
		DEC(ob.Parent(OberWindow).NumMenuItems);
	END;
	IF parentNode = NIL THEN
		OberonObjectList.Children := node.Sibling
	ELSE
		IF parentNode.Children = node THEN
			parentNode.Children := node.Sibling;
		ELSE
			previous := parentNode.Children;
			WHILE previous.Sibling # node DO
				previous := previous.Sibling;
			END;
			previous.Sibling := node.Sibling;
		END
	END
END RemoveFromList;


PROCEDURE RemoveNamedFromList * (Name : ARRAY OF CHAR);
VAR
	remObject : OberObject;
BEGIN
	remObject := GetObject(Name);
	remObject.RemoveFromList;
END RemoveNamedFromList;


(* OberObject.FindTag *********************************************

	Finds the given tag from the object's tagList and returns
	a pointer to the tag item. Works for U.done as well.

*******************************************************************)

PROCEDURE (ob : OberObject) FindTag * (thetag : U.TagID) : U.TagItemPtr;
VAR
	found : BOOLEAN;
BEGIN
	IF thetag # U.done THEN
		RETURN U.FindTagItemA(thetag, ob.tagList^);
	ELSE
		rider := 0; found := FALSE;
		LOOP
			IF rider = LEN(ob.tagList^) THEN EXIT END;
			IF ob.tagList[rider].tag = U.done THEN
				found := TRUE;
				EXIT
			END;
			INC(rider);
		END;
		IF found THEN
			RETURN SYS.VAL(U.TagItemPtr, SYS.ADR(ob.tagList[rider]));
		ELSE
			RETURN NIL
		END
	END
END FindTag;


(* OberObject.SetTag *********************************************

	Looks in ob.tagList for the tag, if it finds it then checks
	the value of setIfFound, setting the tag if TRUE, leaving it
	alone if false. If it is not found then it adds it to the
	end of the tagList (appending U.done after it).

******************************************************************)

PROCEDURE (ob : OberObject) SetTag * (thetag : U.TagID;
									thevalue : U.Tag;
									setIfFound : BOOLEAN);
VAR
	changeTag : U.TagItemPtr;
	newTags : ObjTags;
BEGIN
	changeTag := ob.FindTag(thetag);
	IF changeTag = NIL THEN
		NEW(newTags, (LEN(ob.tagList^) + 1) );
		rider := 0;
		LOOP
			changeTag := U.NextTagItem(SYS.VAL(U.TagItemPtr, ob.tagList));
			IF changeTag = NIL THEN EXIT END;
			newTags^[rider].tag := changeTag.tag;
			newTags^[rider].data := changeTag.data;
			INC(rider);
		END;
		newTags^[rider].tag := thetag;
		newTags^[rider].data := thevalue;
		newTags^[rider+1].tag := U.done;
		ob.tagList := NIL;
		ob.tagList := newTags;
	ELSIF setIfFound THEN
		changeTag.data := thevalue;
	END;
END SetTag;


(* OberObject.GetTagValue ****************************************

	Gets the value from the tag list with the associated tag. Returns
	the default if the tag was not found or if there was an error.

******************************************************************)

PROCEDURE (ob : OberObject) GetTagValue * (thetag : U.TagID;
										   default : U.Tag ) : LONGINT;
BEGIN
	RETURN U.GetTagDataA( thetag, default, ob.tagList^ );
END GetTagValue;


(* OberObject.CopyTag ********************************************

	Copys the value associated with the sourceTag into the value
	associated with the destTag. It allocates the new tag if
	destTag doesn't exist. Leaves the same value if the source
	tag didn't exist, or creates the new destTag and puts 0 in it
	if the destTag didn't previously exist - Sounds complicated
	but it is the safest way.

******************************************************************)

PROCEDURE (ob : OberObject) CopyTag * (sourceTag, destTag : U.TagID);
BEGIN
	ob.SetTag(destTag, ob.GetTagValue(sourceTag,
					   ob.GetTagValue(destTag, 0)), TRUE);
END CopyTag;


(* OberObject.RemoveTag *******************************************

	Removes the first instance of the tag from the object's tagList

*****************************************************************)

PROCEDURE (ob : OberObject) RemoveTag * (thetag : U.TagID);
VAR
	newTags : ObjTags;
	removeTag : U.TagItemPtr;
BEGIN
	IF ob.FindTag(thetag) # NIL THEN
		NEW(newTags, (LEN(ob.tagList^) - 1));
		rider := 0;
		LOOP
			removeTag := U.NextTagItem(SYS.VAL(U.TagItemPtr, ob.tagList));
			IF removeTag = NIL THEN EXIT END;
			IF removeTag.tag # thetag THEN
				newTags^[rider].tag := removeTag.tag;
				newTags^[rider].data := removeTag.data;
				INC(rider);
			END
		END;
		newTags^[rider].tag := U.done;
		ob.tagList := NIL;
		ob.tagList := newTags;
	END
END RemoveTag;


(* OberObject.ShowVisibleChildren *********************************

	This function looks at the ObjectList for any children of
	this object and calls the Show function on those objects.
	NB: It is up to the child's Show function to call ShowVisibleChildren
	again for that object.

*****************************************************************)

PROCEDURE (ob : OberObject) ShowVisibleChildren;
VAR
	theNode : ObjectNode;
	pos : e.UWORD;
BEGIN
(*  Dos.PrintF("ShowVisibleChildren : %s\n", ob.Name); *)
	theNode := OberonObjectList.FindObject(ob);
	IF ob IS OberWindow THEN
		Errors.Assert(ob(OberWindow).gtContext # NIL, "ShowVisibleChildren : Context Gadget = NIL");
		pos := i.AddGadget(ob(OberWindow).iObject, ob(OberWindow).gtContext^, -1);
	END;
	theNode := theNode.Children;
	WHILE theNode # NIL DO
		IF theNode.Object.Visible THEN
			theNode.Object.Visible := FALSE;
			theNode.Object.Show;
		END;
		theNode := theNode.Sibling;
	END;
END ShowVisibleChildren;


(* OberObject.HideVisibleChildren **********************************

	This function hides all the visible children of an object. It
	also resets the IsVisible() parameter back to true after the hide
	because this is a visual hide, not a total hide.

*****************************************************************)

PROCEDURE (ob : OberObject) HideVisibleChildren;
VAR
	theNode : ObjectNode;
BEGIN
	theNode := OberonObjectList.FindObject(ob);
	theNode := theNode.Children;
	WHILE theNode # NIL DO
		IF theNode.Object.Visible THEN
			theNode.Object.Hide;
			theNode.Object.Visible := TRUE;
		END;
		theNode := theNode.Sibling;
	END;
END HideVisibleChildren;


(* OberObject.Init (and associated functions) *********************

	The Init function MUST be called on all objects before
	you realize them (with Show()). It adds the object to the
	object list, and initializes any default tags, and sets
	up the parent object.

****************************************************************)

PROCEDURE (ob : OberObject) Init * (Name : ARRAY OF CHAR;
								  tags : ObjTags;
								  parent : OberObject);
BEGIN
	Errors.Assert(~ob.initialized, "Cannot initialize twice");
	IF tags = NIL THEN
		NEW(ob.tagList, 1);
	ELSE
		ob.tagList := tags;
	END;
	NEW(ob.Name, LEN(Name));
	COPY(Name, ob.Name^);
	ob.Parent := parent;
	IF ob.FindTag(U.done) = NIL THEN
		ob.tagList^[0].tag := U.done;
	END;
	ob.Visible := FALSE; (* all objects start off not seen *)
	ob.AddToList;
END Init;


(********************************************************************
 ===================================================================
		OberScreen Functions
 ===================================================================
*********************************************************************)


PROCEDURE (ob : OberScreen) Init * (Name : ARRAY OF CHAR;
									tags : ObjTags;
									parent : OberObject);
BEGIN
	Errors.Assert( (parent = NIL) OR (parent IS OberScreen),
			"OberScreen.Init: parent is of wrong type");
	ob.Init^ (Name, tags, parent);
	(* Set up defaults *)
	(* ob.SetTag( *)
END Init;


(********************************************************************
 ===================================================================
		OberGraphic Functions
 ===================================================================
*********************************************************************)





(********************************************************************
 ===================================================================
		VirtWindow Functions
 ===================================================================
*********************************************************************)


(* VirtWindow.GetLeftBorder *****************************************

	Gets the x coordinate of the VirtWindow's left edge relative to
	the window's rast port taking borders into account. Used to place
	gadgets (use gadget.leftEdge + gadget.Parent.GetLeftBorder() to
	position the gadget relative to the parent's left edge.

*********************************************************************)

PROCEDURE (ob : VirtWindow) GetLeftBorder() : LONGINT;
BEGIN
	IF ob IS OberWindow THEN
		RETURN ob(OberWindow).iObject.borderLeft;
	ELSE
		RETURN ob.GetTagValue(obLeft, 0) + ob.Parent(VirtWindow).GetLeftBorder();
	END;
END GetLeftBorder;


(* VirtWindow.GetTopBorder ******************************************

	Same as above but for top borders.

*********************************************************************)

PROCEDURE (ob : VirtWindow) GetTopBorder() : LONGINT;
BEGIN
	IF ob IS OberWindow THEN
		RETURN ob(OberWindow).iObject.borderTop;
	ELSE
		RETURN ob.Parent(VirtWindow).GetTopBorder() + ob.GetTagValue(obTop, 0);
	END;
END GetTopBorder;


(* VirtWindow.ReDrawGroupBoxes **************************************

	Goes along this window's children checking if any of the children
	are group boxes. If they are, redraw the groupbox image. Used
	whenever the window needs refreshing.

*********************************************************************)

PROCEDURE (ob : VirtWindow) ReDrawGroupBoxes;
VAR
	nextNode : ObjectNode;
	left, top, width, height : LONGINT;
	tags : ObjTags;
	rp : gfx.RastPortPtr;
	outputText : e.STRPTR;
BEGIN
	nextNode := OberonObjectList.Find(ob.Name^);
	IF nextNode.Children # NIL THEN
		nextNode := nextNode.Children;
		REPEAT
			IF (nextNode.Object IS OberGroupBox) & (nextNode.Object.IsVisible()) THEN
				left := nextNode.Object(OberGroupBox).GetLeftBorder();
				left := left - LONG(nextNode.Object(OberGroupBox).parentWin.iObject.borderLeft);
				top := nextNode.Object(OberGroupBox).GetTopBorder();
				top := top - LONG(nextNode.Object(OberGroupBox).parentWin.iObject.borderTop);
				width := nextNode.Object.GetTagValue(obWidth, 0);
				height := nextNode.Object.GetTagValue(obHeight, 0);
				tags := nextNode.Object.tagList;
				rp := nextNode.Object(OberGroupBox).parentWin.iObject.rPort;
				(* Errors.Assert(rp # NIL, "ReDrawGroupBoxes : Rasport is NIL"); *)
				gt.DrawBevelBoxA( rp,
								  left,
								  top,
								  width, height,
								  tags^);
				gfx.Move( rp, SHORT(left + 10), SHORT(top + SYS.LSH(rp.txBaseline,-1)) );
				outputText := SYS.VAL(e.STRPTR, nextNode.Object(OberGroupBox).Title);
				gfx.Text( rp, outputText^, Strings.Length(outputText^));
				nextNode.Object(VirtWindow).ReDrawGroupBoxes;
			END;
			nextNode := nextNode.Sibling;
		UNTIL nextNode = NIL;
	END;
END ReDrawGroupBoxes;


(* VirtWindow.ReDrawGraphics ****************************************

	Redraws all graphics that are children of this VirtWindow

*********************************************************************)

PROCEDURE (ob : VirtWindow) ReDrawGraphics;
BEGIN
END ReDrawGraphics;


(* VirtWindow.RefreshWindow *****************************************

	Completely refreshes the window by blanking it out and redrawing
	all group boxes, graphic objects, gadgets and finally calls
	gadtools.RefreshWindow().

*********************************************************************)

PROCEDURE (ob : VirtWindow) RefreshWindow*;
VAR
	left, top, width, height : INTEGER;
BEGIN
	IF ob.IsVisible() THEN
		Errors.Assert(ob.parentWin.iObject.rPort # NIL, "RefreshWindow : Rasport = NIL");
		gfx.EraseRect(ob.parentWin.iObject.rPort,
						ob.parentWin.iObject.borderLeft,
						ob.parentWin.iObject.borderTop,
						ob.parentWin.iObject.width - ob.parentWin.iObject.borderLeft - ob.parentWin.iObject.borderRight,
						ob.parentWin.iObject.height - ob.parentWin.iObject.borderTop - ob.parentWin.iObject.borderBottom );
		ob.ReDrawGraphics;
		ob.ReDrawGroupBoxes;
		Errors.Assert(ob.parentWin.gtContext # NIL, "RefreshWindow : Context Gadget = NIL");
		Errors.Assert(ob.parentWin.iObject # NIL, "RefreshWindow : Parent Window = NIL");
		i.RefreshGadgets(ob.parentWin.gtContext, ob.parentWin.iObject, NIL);
		gt.RefreshWindow(ob.parentWin.iObject, NIL);
	END;
END RefreshWindow;


(********************************************************************
 ===================================================================
		OberWindow Functions
 ===================================================================
*********************************************************************)


(* OberWindow.OnCreate **********************************************

	Function designed to be overridden in the user's application. Use
	this function to create the windows gadgets and other visual
	things. You don't need to call OnCreate, it will be called for
	you.

*********************************************************************)

PROCEDURE (ob : OberWindow) OnCreate *;
BEGIN
	(*  Create all gadgets here.  This is just a convention. *)
END OnCreate;


(**********************************************************************

	Name        : SwitchHelp
	Description : Switch gadget/menu help on/off
	Parameters  : on - if TRUE switch gad/menu help on
					   if FALSE switch gad/menu help off

***********************************************************************)

PROCEDURE (ob : OberWindow) SwitchHelp * ( on : BOOLEAN );
BEGIN
	IF on THEN
		ob.SetTag(gadHelp, TRUE, TRUE);
		IF ob.IsVisible() THEN
			Errors.Assert(ob.iObject # NIL, "SwitchHelp : Window is NIL!");
			i.HelpControl( ob.iObject, {i.hcGadgetHelp} );
		END
	ELSE
		ob.SetTag(gadHelp, FALSE, TRUE);
		IF ob.IsVisible() THEN
			Errors.Assert(ob.iObject # NIL, "SwitchHelp : Window is NIL!");
			i.HelpControl( ob.iObject, {} );
		END
	END
END SwitchHelp;



PROCEDURE (ob : OberWindow) Init * (Name : ARRAY OF CHAR;
									tags : ObjTags;
									parent : OberObject);
BEGIN
	Errors.Assert( (parent = NIL) OR (parent IS OberScreen),
			"Init : Invalid parent object type");
	ob.Init^ (Name, tags, parent); (* set these things up first *)
	NEW(ob.WinsPort);
	(* Set up defaults *)
	ob.SetTag(i.waSizeGadget, TRUE, FALSE);
	ob.SetTag(i.waDragBar, TRUE, FALSE);
	ob.SetTag(i.waDepthGadget, TRUE, FALSE);
	ob.SetTag(i.waCloseGadget, TRUE, FALSE);
	ob.SetTag(i.waActivate, TRUE, FALSE);
	ob.SetTag(i.waAutoAdjust, TRUE, FALSE);
	ob.SetTag(i.waNewLookMenus, TRUE, FALSE);
	ob.SetTag(i.waPubScreenFallBack, TRUE, FALSE);
	ob.SetTag(i.waIDCMP, {i.newSize, i.closeWindow}, FALSE);
	IF ob.Parent = NIL THEN
		ob.SetTag(i.waPubScreen, i.LockPubScreen(e.NILSTR), FALSE);
	ELSIF ob.Parent IS OberScreen THEN
		ob.SetTag(i.waPubScreen, ob.Parent(OberScreen).iObject, FALSE);
	ELSIF ob.Parent IS OberWindow THEN
		ob.SetTag(i.waPubScreen, ob.Parent(OberWindow).iObject.wScreen, FALSE);
	END;
	IF ob.FindTag(i.waSimpleRefresh) = NIL THEN
		ob.SetTag(i.waSmartRefresh, TRUE, FALSE);
	END;
	ob.parentWin := ob;
	ob.LastGadget := gt.CreateContext(ob.gtContext);
	IF ob.gtContext # NIL THEN
		(* Create a generic gadget so that window resizing works *)
		NEW(ob.windowGad);
		ob.windowGad.Init("WindowGad", NIL, ob);
		ob.windowGad.SetTag(gtGadget, TRUE, TRUE);
		ob.windowGad.SetTag(gtGadKind, gt.genericKind, TRUE);
		ob.windowGad.Show;
		(* Use OnCreate to create user gadgets *)
		ob.OnCreate;
	END;
	ob.initialized := TRUE;
END Init;


(********************************************************************

	Name        : ModifyIDCMP
	Description : Change the IDCMP of the window. This affects the
				  message types that ar returned to the window.
	Inputs      : Method = Add - Add the IDCMP's, Remove - remove them,
						   Change - change the whole set of IDCMP's
				  IDCMP = The Message types in a set
	Returns     : FALSE if it was unable to open the message port.

*********************************************************************)

PROCEDURE (ob : OberWindow) ModifyIDCMP * ( Method : SHORTINT;
											IDCMP  : Sets.SET32 ) : BOOLEAN;
VAR OldIDCMP : Sets.SET32;
BEGIN
	CASE Method OF
		Add     : OldIDCMP := SYS.VAL(Sets.SET32, ob.GetTagValue( i.waIDCMP, 0 ));
				  IF OldIDCMP * IDCMP # IDCMP THEN
					  IDCMP := IDCMP + OldIDCMP;
					  ob.SetTag( i.waIDCMP, IDCMP, TRUE );
					  IF ob.IsVisible() THEN
						Errors.Assert(ob.iObject # NIL, "ModifyIDCMP : Window is NIL!");
						RETURN i.ModifyIDCMP( ob.iObject, IDCMP )
					  END
				  END

	  | Remove  : OldIDCMP := SYS.VAL(Sets.SET32, ob.GetTagValue( i.waIDCMP, 0 ));
				  IF OldIDCMP * IDCMP # {} THEN
					  IDCMP := OldIDCMP - IDCMP;
					  ob.SetTag( i.waIDCMP, IDCMP, TRUE );
					  IF ob.IsVisible() THEN
						Errors.Assert(ob.iObject # NIL, "ModifyIDCMP : Window is NIL!");
						RETURN i.ModifyIDCMP( ob.iObject, IDCMP )
					  END
				  END

	  | Change  : ob.SetTag( i.waIDCMP, IDCMP, TRUE );
				  IF ob.IsVisible() THEN
					Errors.Assert(ob.iObject # NIL, "ModifyIDCMP : Window is NIL!");
					RETURN i.ModifyIDCMP( ob.iObject, IDCMP )
				  END
	END;
	RETURN TRUE;
END ModifyIDCMP;


(* OberWindow.UpdatePositionTags **************************************

	copies OberObject tags into intuition window tags so that
	OpenWindowTags() works properly.

***********************************************************************)

PROCEDURE (ob : OberWindow) UpdatePositionTags;
BEGIN
	ob.CopyTag(obTop, i.waTop); ob.CopyTag(obLeft, i.waLeft);
	ob.CopyTag(obWidth, i.waWidth); ob.CopyTag(obHeight, i.waHeight);
END UpdatePositionTags;


(* OberWindow.SetTitle ************************************************

	Sets the window title.

***********************************************************************)

PROCEDURE (ob : OberWindow) SetTitle * (Title : ARRAY OF CHAR);
BEGIN
	ob.Title := NIL;
	NEW(ob.Title, LEN(Title));
	COPY(Title, ob.Title^);
	ob.SetTag(i.waTitle, ob.Title, TRUE);
	IF ob.IsVisible() THEN
		Errors.Assert(ob.iObject # NIL, "SetTitle : Window is NIL!");
		i.SetWindowTitles(ob.iObject, SYS.VAL(e.LSTRPTR, ob.Title), NIL);
	END;
END SetTitle;


(* OberWindow.SetDimensions ******************************************

	Sets the window's position and size

**********************************************************************)

PROCEDURE (ob : OberWindow) SetDimensions * (x,y,w,h : INTEGER);
BEGIN
	ob.SetTag(obLeft, x, TRUE); ob.SetTag(obTop, y, TRUE);
	ob.SetTag(obWidth, w, TRUE); ob.SetTag(obHeight, h, TRUE);
	ob.UpdatePositionTags;
	IF ob.IsVisible() THEN
		Errors.Assert(ob.iObject # NIL, "SetDimensions : Window is NIL!");
		i.ChangeWindowBox(ob.iObject, x,y,w,h);
	END;
END SetDimensions;


(* OberWindow.SetMinSize ********************************************

	Sets the minimum size the window can be.

*********************************************************************)

PROCEDURE (ob : OberWindow) SetMinSize * (w,h : INTEGER);
BEGIN
	ob.SetTag(i.waMinWidth, w, TRUE); ob.SetTag(i.waMinHeight, h, TRUE);
	IF ob.IsVisible() THEN
		Errors.Assert(ob.iObject # NIL, "SetMinSize : Window is NIL");
		IF ~i.WindowLimits(ob.iObject, w, h, 0, 0) THEN
			(* Failed ! *)
		END;
	END;
END SetMinSize;


(* OberWindow.SetMaxSize *******************************************

	Sets the maximum size the window can be.

********************************************************************)

PROCEDURE (ob : OberWindow) SetMaxSize * (w,h : INTEGER);
BEGIN
	ob.SetTag(i.waMaxWidth, w, TRUE); ob.SetTag(i.waMaxHeight, h, TRUE);
	IF ob.IsVisible() THEN
		Errors.Assert(ob.iObject # NIL, "SetMaxSize : Window is NIL");
		IF ~i.WindowLimits(ob.iObject, 0,0,w,h) THEN
			(* Failed ! *)
		END;
	END;
END SetMaxSize;


(* OberWindow.MakeMenus ********************************************

	Convert all the OberMenuItem's that are children of this window
	into a NewMenu structure, keeping all tags.

********************************************************************)

PROCEDURE (ob : OberWindow) MakeMenus() : gt.NewMenuPtr;
VAR
	MenuArray   : POINTER TO ARRAY OF gt.NewMenu;
	theNode   : ObjectNode;
BEGIN
	NEW(MenuArray, ob.NumMenuItems);
	Errors.Assert(MenuArray # NIL, "Out of Memory : Menu Creation Failed");
	rider := 0;
	theNode := OberonObjectList.FindObject(ob);
	theNode := theNode.Children;
	WHILE theNode # NIL DO
		IF (theNode.Object IS OberMenuItem) & theNode.Object.Visible THEN
			MenuArray[rider].type := theNode.Object(OberMenuItem).Type;
			IF theNode.Object(OberMenuItem).Text^ = oberBarLabel THEN
				MenuArray[rider].label := gt.barLabel;
			ELSE
				MenuArray[rider].label := SYS.VAL(e.LSTRPTR, theNode.Object(OberMenuItem).Text);
			END;
			IF theNode.Object(OberMenuItem).commandKey # '' THEN
				MenuArray[rider].commKey := SYS.VAL(e.LSTRPTR, SYS.ADR(theNode.Object(OberMenuItem).commandKey));
			END;
			MenuArray[rider].mutualExclude := theNode.Object(OberMenuItem).MX;
			IF theNode.Object(OberMenuItem).IsAttribute THEN
				MenuArray[rider].flags := {i.checkIt};
				IF theNode.Object(OberMenuItem).MX = {} THEN
					MenuArray[rider].flags := {i.checkIt} + {i.menuToggle};
				END;
				IF theNode.Object(OberMenuItem).IsChecked THEN
					MenuArray[rider].flags := MenuArray[rider].flags + {i.checked};
				END;
			END;
			IF ~theNode.Object(OberMenuItem).enabled THEN
				IF theNode.Object(OberMenuItem).Type = gt.title THEN
					MenuArray[rider].flags := MenuArray[rider].flags + {gt.menuDisabled};
				ELSE
					MenuArray[rider].flags := MenuArray[rider].flags + {gt.itemDisabled};
				END;
			END;
			MenuArray[rider].userData := SYS.VAL(e.APTR, SYS.ADR(theNode.Object.Name));
			INC(rider);
		END;
		theNode := theNode.Sibling;
	END;
	RETURN SYS.VAL(gt.NewMenuPtr, SYS.ADR(MenuArray[0]));
END MakeMenus;


(* OberWindow.ReDisplayMenus ********************************************

	update the menus of the window.

*************************************************************************)

PROCEDURE (ob : OberWindow) ReDisplayMenus;
VAR
	NewMenus : gt.NewMenuPtr;
BEGIN
	IF ob.menuStrip # NIL THEN
		i.ClearMenuStrip(ob.iObject);
		gt.FreeMenus(ob.menuStrip);
		ob.menuStrip := NIL;
	END;
	NewMenus := ob.MakeMenus();
	ob.menuStrip := gt.CreateMenusB(NewMenus, U.done);
	IF ob.menuStrip # NIL THEN
		IF gt.LayoutMenus(ob.menuStrip, gt.GetVisualInfo(ob.iObject.wScreen, NIL), U.done)
		THEN
			IF ~i.SetMenuStrip(ob.iObject, ob.menuStrip^) THEN
				(* Can't do much about it ! *)
			END;
		END;
	END;
END ReDisplayMenus;


PROCEDURE (ob : OberWindow) Show *;
VAR
	newWin : i.NewWindowPtr;
	pos : e.UWORD;
	font : gfx.TextFontPtr;
BEGIN
	IF ~ob.IsVisible() THEN
		Errors.Assert(ob.initialized, "Cannot Show : not initialized");
		NEW(newWin);
		Errors.Assert(newWin # NIL, "Out of Memory, cannot create window.");
		ob.iObject := i.OpenWindowTagListA(newWin, ob.tagList^);
		Errors.Assert(ob.iObject # NIL, "Out of Memory");
		ob.Visible := TRUE;
		ob.WinsPort.AttachPort(ob.iObject.userPort);
		ob.WinsPort.PortsWin := ob;
		ignoreSig := MainEventLoop.AddSignal(ob.WinsPort);
		IF ob.NumMenuItems>0 THEN
			ob.ReDisplayMenus;
		END;
		ob.vi := gt.GetVisualInfo(ob.iObject.wScreen, NIL);
		font := gfx.OpenFont(ob.iObject.wScreen.font^);
		IF font # NIL THEN
			gfx.SetFont(ob.iObject.rPort, font);
		END;
		gfx.SetAPen(ob.iObject.rPort, SYS.VAL(SHORTINT, ob.GetTagValue(fgColor,1)));
		ob.ShowVisibleChildren;
		ob.RefreshWindow;
		ob.SwitchHelp(ob.GetTagValue(gadHelp, FALSE) = LTRUE);
	END;
	ob.Visible := TRUE;
END Show;


PROCEDURE (ob : OberWindow) Hide *;
BEGIN
	IF ob.IsVisible() THEN
		Errors.Assert(ob.initialized, "Cannot hide : not initialized");
		ob.HideVisibleChildren;
		ob.SetTag(obLeft, ob.iObject.leftEdge, TRUE);
		ob.SetTag(obTop, ob.iObject.topEdge, TRUE);
		ob.UpdatePositionTags;
		MainEventLoop.RemoveSignal(ob.WinsPort);
		ob.WinsPort.DetachPort;
		IF ob.NumMenuItems>0 THEN
			i.ClearMenuStrip(ob.iObject);
			gt.FreeMenus(ob.menuStrip);
			ob.menuStrip := NIL;
		END;
		IF ob.oldRegion # NIL THEN
			iutil.UnclipWindow( ob.iObject, ob.oldRegion );
		END;
		iutil.CloseWindowSafely(ob.iObject);
		gt.FreeVisualInfo(ob.vi);
		ob.vi := NIL;
	END;
	ob.Visible := FALSE;
END Hide;


(* OberWindow.FindGadget *********************************************

	This function finds the gadget with this object in the gadgets roots
	and whose GadgetID is given by GadId.

**********************************************************************)

PROCEDURE (ob : VirtWindow) FindGadget * (GadId : e.UWORD) : OberGadget;
VAR
	theNode : ObjectNode;
	Found : OberGadget;
BEGIN
	theNode := OberonObjectList.Find(ob.Name^);
	theNode := theNode.Children;
	WHILE theNode # NIL DO
		IF theNode.Object IS OberGadget THEN
			IF theNode.Object.IsVisible() THEN
				IF theNode.Object(OberGadget).iObject.gadgetID = GadId THEN
					RETURN theNode(ObjectNode).Object(OberGadget);
				END;
			END;
		END;
		IF theNode.Object IS VirtWindow THEN
			Found := theNode.Object(VirtWindow).FindGadget(GadId);
			IF Found # NIL THEN
				RETURN Found
			END
		END;
		theNode := theNode.Sibling;
	END;
	RETURN NIL;
END FindGadget;


(* OberWindow.FindMenu *********************************************

	Same as above but for menus by name.

********************************************************************)

PROCEDURE (ob : OberWindow) FindMenu * (Name : ARRAY OF CHAR) : OberMenuItem;
VAR
	theNode : ObjectNode;
BEGIN
	theNode := OberonObjectList.Find(Name);
	IF (theNode.Object IS OberMenuItem) &
		(theNode.Object.Parent = ob) THEN
			RETURN theNode.Object(OberMenuItem);
	ELSE
			RETURN NIL;
	END;
END FindMenu;


(* OberWindow.AddMenuBit **********************************************

	This is the general add menu one. Used by AddMenuTitle, etc.

***********************************************************************)

PROCEDURE (ob : OberWindow) AddMenuBit( menuName : ARRAY OF CHAR;
										menuType : SHORTINT;
										menuText : ARRAY OF CHAR;
										menuKey  : CHAR;
										MX       : Sets.SET32;
										IsAttr  : BOOLEAN;
										CbProc  : cbProcType );
VAR theMenuItem : OberMenuItem;
BEGIN
	NEW(theMenuItem);
	IF theMenuItem # NIL THEN
		IF ob.ModifyIDCMP( Add, {i.menuPick} ) THEN
			INC(ob.NumMenuItems);
			theMenuItem.Parent := ob;
			NEW(theMenuItem.Text, LEN(menuText));
			IF theMenuItem.Text # NIL THEN
				COPY(menuText, theMenuItem.Text^);
				NEW(theMenuItem.Name, LEN(menuName));
				IF theMenuItem.Name # NIL THEN
					COPY(menuName, theMenuItem.Name^);
					theMenuItem.enabled := TRUE;
					theMenuItem.Type := menuType; theMenuItem.commandKey := menuKey;
					theMenuItem.MX := MX; theMenuItem.IsAttribute := IsAttr;
					theMenuItem.CbProc := CbProc;
					theMenuItem.Visible := TRUE; (* Menus start off visible *)
					theMenuItem.AddToList;
				END;
			END;
		END;
	END;
	IF ob.IsVisible() THEN ob.ReDisplayMenus; END;
END AddMenuBit;


(* AddMenu Functions ***************************************************

	These functions add bits to the menu of the window, it does not
	do any error checking on the structure as yet. The bits of the menu
	are added in turn, so you add a title followed by all items in
	that title, and any sub items immediately after the item who is
	the parent. There is no safe way to delete a menu item yet (i.e. one
	which, if you delete a title, all items under that title go too)
	but you can primitively use RemoveNamedFromList() so long as you
	are careful. Note that these menus are primitive and slow so a
	speed up (with no CallBack functions) would be to use your own
	gadtools menus with the iObject.

************************************************************************)

PROCEDURE (ob : OberWindow) AddMenuTitle * ( menuName : ARRAY OF CHAR;
											 menuText : ARRAY OF CHAR );
BEGIN
	ob.AddMenuBit(menuName, gt.title, menuText, '', {}, FALSE, NIL);
END AddMenuTitle;


PROCEDURE (ob : OberWindow) AddMenuItem * ( menuName : ARRAY OF CHAR;
											menuText : ARRAY OF CHAR;
											CbProc  : cbProcType;
											menuKey : CHAR;
											MutualExclude : Sets.SET32;
											IsAttr : BOOLEAN );
BEGIN
	ob.AddMenuBit(menuName, gt.item, menuText, menuKey, MutualExclude, IsAttr, CbProc);
END AddMenuItem;


PROCEDURE (ob : OberWindow) AddMenuSubItem * (  menuName : ARRAY OF CHAR;
												menuText : ARRAY OF CHAR;
												CbProc  : cbProcType;
												menuKey  : CHAR;
												MutualExclude : Sets.SET32;
												IsAttr : BOOLEAN );
BEGIN
	ob.AddMenuBit(menuName, gt.sub, menuText, menuKey, MutualExclude, IsAttr, CbProc);
END AddMenuSubItem;

PROCEDURE (ob : OberWindow) AddMenuBar *;
BEGIN
	ob.AddMenuBit("", gt.item, oberBarLabel, '', {}, FALSE, NIL);
END AddMenuBar;

PROCEDURE (ob : OberWindow) AddMenuBarSub *;
BEGIN
	ob.AddMenuBit("", gt.sub, oberBarLabel, '', {}, FALSE, NIL);
END AddMenuBarSub;


(* OberWindow.CheckMenu (and UnCheckMenu) ***************************

	These two functions check or uncheck an attribute menu item.

*********************************************************************)

PROCEDURE (ob : OberWindow) CheckMenu * (Name : ARRAY OF CHAR);
VAR
	theMenu : OberMenuItem;
BEGIN
	theMenu := ob.FindMenu(Name);
	IF theMenu # NIL THEN
		theMenu.IsChecked := TRUE;
		IF ob.IsVisible() THEN
			ob.ReDisplayMenus;
		END;
	END;
END CheckMenu;

PROCEDURE (ob : OberMenuItem) SetState * (checked : BOOLEAN);
BEGIN
	ob.IsChecked := checked;
	IF ob.Parent.IsVisible() THEN
		ob.Parent(OberWindow).ReDisplayMenus;
	END;
END SetState;

PROCEDURE (ob : OberWindow) UnCheckMenu * (Name : ARRAY OF CHAR);
VAR
	theMenu : OberMenuItem;
BEGIN
	theMenu := ob.FindMenu(Name);
	IF theMenu # NIL THEN
		theMenu.IsChecked := FALSE;
		IF ob.IsVisible() THEN
			ob.ReDisplayMenus;
		END;
	END;
END UnCheckMenu;


(* OberWindow.EnableMenu *********************************************

	Enable the menu with the given name.

**********************************************************************)

PROCEDURE (ob : OberWindow) EnableMenu * (Name : ARRAY OF CHAR);
VAR
	theMenu : OberMenuItem;
BEGIN
	theMenu := ob.FindMenu(Name);
	IF theMenu # NIL THEN
		theMenu.enabled := TRUE;
		IF ob.IsVisible() THEN
			ob.ReDisplayMenus;
		END;
	END;
END EnableMenu;

PROCEDURE (ob : OberMenuItem) Enable *;
BEGIN
	ob.enabled := TRUE;
	IF ob.Parent.IsVisible() THEN
		ob.Parent(OberWindow).ReDisplayMenus;
	END;
END Enable;


(* OberWindow.DisableMenu *******************************************

	Disable the menu with the given name. Makes the menu option, and
	all children of it, greyed out.

*********************************************************************)

PROCEDURE (ob : OberWindow) DisableMenu * (Name : ARRAY OF CHAR);
VAR
	theMenu : OberMenuItem;
BEGIN
	theMenu := ob.FindMenu(Name);
	IF theMenu # NIL THEN
		theMenu.enabled := FALSE;
		IF ob.IsVisible() THEN
			ob.ReDisplayMenus;
		END;
	END;
END DisableMenu;

PROCEDURE (ob : OberMenuItem) Disable *;
BEGIN
	ob.enabled := FALSE;
	IF ob.Parent.IsVisible() THEN
		ob.Parent(OberWindow).ReDisplayMenus;
	END;
END Disable;


(* OberMenuItem.Hide ***********************************************

	Hide this menu item (and all its children)

********************************************************************)

PROCEDURE (ob : OberMenuItem) Hide *;
BEGIN
	ob.Visible := FALSE;
	IF ob.Parent.IsVisible() THEN
		ob.Parent(OberWindow).ReDisplayMenus;
	END;
END Hide;


(* OberMenuItem.Show ***********************************************

	Show this menu item (and all its VISIBLE children)

********************************************************************)

PROCEDURE (ob : OberMenuItem) Show *;
BEGIN
	ob.Visible := TRUE;
	IF ob.Parent.IsVisible() THEN
		ob.Parent(OberWindow).ReDisplayMenus;
	END;
END Show;


(**********************************************************************
 =====================================================================
	Misc Windows functions
 =====================================================================
***********************************************************************)

(**********************************************************************

	Name        : Activate
	Description : Activate this window.

***********************************************************************)

PROCEDURE (ob : OberWindow) Activate *;
BEGIN
	IF ob.IsVisible() THEN
		i.ActivateWindow( ob.iObject );
	END;
END Activate;


(**********************************************************************

	Name        : SetPointer
	Description : Change the window's pointer
	Parameters  : pointerType - either busyPointer or normalPointer

***********************************************************************)

PROCEDURE (ob : OberWindow) SetPointer * ( pointerType : LONGINT );
BEGIN
	CASE pointerType OF
		busyPointer     : IF ob.IsVisible() THEN
							i.SetWindowPointer( ob.iObject,
								i.waBusyPointer, TRUE,
								i.waPointerDelay, TRUE, U.done );
						  END;
						  ob.SetTag(i.waBusyPointer, TRUE, TRUE);
	  | normalPointer   : IF ob.IsVisible() THEN
							i.SetWindowPointer( ob.iObject,
								i.waBusyPointer, FALSE,
								i.waPointerDelay, TRUE, U.done );
						  END;
						  ob.SetTag(i.waBusyPointer, FALSE, TRUE);
	END;
END SetPointer;


(**********************************************************************

	Name        : SetHelpGroup
	Description : Set up the help group for the window
	Parameters  : win - The window to share the help group with
					or NIL to create a new help group.
	Returns     : TRUE if successful, FALSE for Failure

***********************************************************************)

PROCEDURE (ob : OberWindow) SetHelpGroup * ( win : OberWindow );
BEGIN
	IF ob.ModifyIDCMP( Add, {i.gadgetHelp, i.menuHelp} ) THEN
		IF win = NIL THEN
			ob.SetTag(i.waHelpGroup, U.GetUniqueID(), TRUE);
		ELSE
			Errors.Assert(win.IsVisible(), "SetHelpGroup : Must be called when window to share with is visible");
			ob.SetTag(i.waHelpGroupWindow, win.iObject, TRUE);
		END;
		ob.SetTag(gadHelp, TRUE, TRUE);
		IF ob.IsVisible() THEN
			ob.Hide; ob.Show;
		END;
	END;
END SetHelpGroup;

(**********************************************************************

	Name        : SetGadHelpCallback
	Description : Set the callback procedure for gadgetHelp for the
				  whole window.
	Parameters  : cbp - the callback procedure

***********************************************************************)

PROCEDURE (ob : OberWindow) SetGadHelpCallback * (cbp : cbProcType);
BEGIN
	ob.gadHelpCbProc := cbp;
END SetGadHelpCallback;


(**********************************************************************
 =====================================================================
	Key Shortcut Control Functions
 =====================================================================
***********************************************************************)


(* OberWindow.AddUnderscore *******************************************

	Adds a gadgets underscore character to the window's list of
	underscores to be later examined when the window recieves
	a key event with a rCommand key. This function examines
	the text to see if it contains an underscore and then takes
	the next character as the shortcut key.

***********************************************************************)

PROCEDURE (ob : OberWindow) AddUnderscore( text : ARRAY OF CHAR;
										   gadget : OberGadget );
VAR
	oldKeys : OberWinKeys;
	arrLen : LONGINT;
	addChar : CHAR;
BEGIN
	rider := Strings.Pos("_", text, 0);
	IF rider # -1 THEN
		IF ob.ModifyIDCMP( Add, {i.rawKey} ) THEN
			INC(rider);
			addChar := CAP(text[rider]);
			oldKeys := ob.keyShorts;
			IF oldKeys # NIL THEN
				arrLen := LEN(oldKeys^);
			END;
			NEW(ob.keyShorts, arrLen + 1);
			Errors.Assert(ob.keyShorts # NIL, "AddUnderscore : Out of Memory");
			rider := 0;
			WHILE rider < arrLen DO
				Errors.Assert(addChar # ob.keyShorts[rider].key, "AddUnderscore : Key previously specified");
				ob.keyShorts[rider].gadget := oldKeys[rider].gadget;
				ob.keyShorts[rider].key := oldKeys[rider].key;
				INC(rider)
			END;
			ob.keyShorts[rider].gadget := gadget;
			ob.keyShorts[rider].key := addChar;
		END
	END
END AddUnderscore;


(* OberWindow.RemoveUnderscore ****************************************

	Removes any entries in the underscore list that have the underscore
	character (as defined in AddUnderscore) contained in text.

***********************************************************************)

PROCEDURE (ob : OberWindow) RemoveUnderscore (text : ARRAY OF CHAR);
VAR
	oldKeys : OberWinKeys;
	remChar : CHAR;
BEGIN
	rider := Strings.Pos("_", text, 0);
	IF rider # -1 THEN
		INC(rider);
		remChar := CAP(text[rider]);
		oldKeys := ob.keyShorts;
		NEW(ob.keyShorts, LEN(oldKeys^) -1);
		Errors.Assert(ob.keyShorts # NIL, "RemoveUnderscore : Out of Memory");
		rider := 0;
		WHILE rider < LEN(oldKeys^) DO
			ob.keyShorts[rider].gadget := oldKeys[rider].gadget;
			ob.keyShorts[rider].key := oldKeys[rider].key;
			IF oldKeys[rider].key # remChar THEN
				INC(rider)
			END
		END
	END
END RemoveUnderscore;


(* OberWindow.DoKeyShortcut ********************************************

	Performs a shortcut function associated with the passed key. This
	currently performs the gadget's default callback procedure.

************************************************************************)

PROCEDURE (ob : OberWindow) DoKeyShortcut ( theKey : CHAR;
											code : e.UWORD);
VAR
	pushGad : i.GadgetPtr;
BEGIN
	theKey := CAP(theKey);
	rider := 0;
	IF ob.keyShorts # NIL THEN
		WHILE rider < LEN(ob.keyShorts^) DO
			IF ob.keyShorts[rider].key = theKey THEN
				IF ob.keyShorts[rider].gadget.IsVisible() THEN
					IF ob.keyShorts[rider].gadget.defCbProc # NIL THEN
						pushGad := ob.keyShorts[rider].gadget.iObject;
						gfx.RectFill(ob.iObject.rPort,
							pushGad.leftEdge + 1, pushGad.topEdge + 1,
							(pushGad.width + pushGad.leftEdge) - 1,
							(pushGad.height + pushGad.topEdge) - 1);
						i.RefreshGadgets(pushGad, ob.iObject, NIL);
						gt.RefreshWindow(ob.iObject, NIL);
						ob.keyShorts[rider].gadget.defCbProc(ob.keyShorts[rider].gadget, code)
					END
				END
			END;
			INC(rider)
		END
	END;
END DoKeyShortcut;


(********************************************************************
 ===================================================================
		OberWindow Callback Functions
 ===================================================================
*********************************************************************)


(* ReplyMsg *********************************************************

	Reply's to the message passed, performing any special functions
	needed. (Currently this is to call gt.ReplyMsg). This is
	documented here because it goes hand in hand with the callback
	functions.

*********************************************************************)

PROCEDURE ReplyMsg* (msg : i.IntuiMessagePtr);
BEGIN
	gt.ReplyIMsg(msg);
END ReplyMsg;


(*********************************************************************
 ====================================================================
	The callback procedures. On{IDCMP}(msg)
 ====================================================================
**********************************************************************)

PROCEDURE (ob : OberWindow) OnSizeVerify * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnSizeVerify;

PROCEDURE (ob : OberWindow) OnNewSize * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN
	ReplyMsg(msg);
	ob.SetTag(obWidth, ob.iObject.width, TRUE);
	ob.SetTag(obHeight, ob.iObject.height, TRUE);
	ob.HideVisibleChildren;
	ob.ShowVisibleChildren;
	ob.RefreshWindow;
	RETURN Continue;
END OnNewSize;

PROCEDURE (ob : OberWindow) OnRefreshWindow * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN (* Override this function at your peril!!! *)
	ReplyMsg(msg);
	Dos.PrintF("Refreshing Window!\n", NIL);
	gt.BeginRefresh( ob.iObject );
	ob.ReDrawGroupBoxes;
	gt.EndRefresh( ob.iObject, e.LTRUE);
	RETURN Continue;
END OnRefreshWindow;

PROCEDURE (ob : OberWindow) OnMouseButtons * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnMouseButtons;

PROCEDURE (ob : OberWindow) OnMouseMove * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnMouseMove;

PROCEDURE (ob : OberWindow) OnGadgetDown * (msg : i.IntuiMessagePtr) : INTEGER;
VAR
	gad   : i.GadgetPtr;
	ooGad   : OberGadget;
	code : e.UWORD;
BEGIN
	gad := SYS.VAL(i.GadgetPtr, msg.iAddress);
	code := msg.code;
	ReplyMsg(msg);
	ooGad := ob.FindGadget(gad.gadgetID);
	IF ooGad.gadDownCbProc # NIL THEN
		ooGad.gadDownCbProc(ooGad, code);
	END;
	RETURN Continue;
END OnGadgetDown;

PROCEDURE (ob : OberWindow) OnGadgetUp * (msg : i.IntuiMessagePtr) : INTEGER;
VAR
	gad   : i.GadgetPtr;
	ooGad   : OberGadget;
	code : e.UWORD;
BEGIN
	gad := SYS.VAL(i.GadgetPtr, msg.iAddress);
	code := msg.code;
	ReplyMsg(msg);
	ooGad := ob.FindGadget(gad.gadgetID);
	IF ooGad = prevDblClkGadget THEN
		IF i.DoubleClick( prevDblClkSecs, prevDblClkMicros,
						  msg.time.secs, msg.time.micro ) THEN
			IF ooGad.gadDblClkCbProc # NIL THEN
				ooGad.gadDblClkCbProc(ooGad, code);
			END;
		END;
	END;
	prevDblClkGadget := ooGad;
	prevDblClkSecs := msg.time.secs;
	prevDblClkMicros := msg.time.micro;
	IF ooGad.defCbProc # NIL THEN
		ooGad.defCbProc(ooGad, code); 
	END;
	RETURN Continue;
END OnGadgetUp;

PROCEDURE (ob : OberWindow) OnReqSet * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnReqSet;


PROCEDURE (ob : OberWindow) GetNextMenu ( theNode : ObjectNode;
										  Type : SHORTINT ) : ObjectNode;
BEGIN
	WHILE theNode # NIL DO
		IF theNode.Object IS OberMenuItem THEN
			IF theNode.Object(OberMenuItem).Type = Type THEN
				RETURN theNode;
			END;
		END;
		theNode := theNode.Sibling;
	END;
	RETURN NIL; (* This should never occur *)
END GetNextMenu;

PROCEDURE (ob : OberWindow) GetMenuBit( VAR theNode : ObjectNode;
											mNum : INTEGER;
											mNo : INTEGER;
											mType : SHORTINT );
BEGIN
	IF mNum # mNo THEN
		theNode := ob.GetNextMenu(theNode, mType);
		WHILE mNum > 0 DO
			theNode := ob.GetNextMenu(theNode, mType);
			DEC(mNum);
		END;
	END;
END GetMenuBit;

PROCEDURE (ob : OberWindow) OnMenuPick * (msg : i.IntuiMessagePtr) : INTEGER;
VAR
	theNode : ObjectNode;
	theMenuItem : i.MenuItemPtr;
	menuCode : e.UWORD;
BEGIN
	menuCode := msg.code;
	ReplyMsg(msg);
	WHILE menuCode # i.menuNull DO
		theNode := OberonObjectList.Find(ob.Name^);
		theNode := theNode.Children;
		ob.GetMenuBit(theNode, i.MenuNum(menuCode), i.noMenu, gt.title);
		ob.GetMenuBit(theNode, i.ItemNum(menuCode), i.noItem, gt.item);
		ob.GetMenuBit(theNode, i.SubNum(menuCode), i.noSub, gt.sub);
		IF theNode.Object(OberMenuItem).CbProc # NIL THEN
			theNode.Object(OberMenuItem).CbProc(theNode.Object(OberMenuItem), menuCode);
		END;
		theMenuItem := i.ItemAddress(ob.iObject.menuStrip^, menuCode);
		menuCode := theMenuItem.nextSelect;
	END;
	RETURN Continue;
END OnMenuPick;

PROCEDURE (ob : OberWindow) OnCloseWindow * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnCloseWindow;

PROCEDURE (ob : OberWindow) OnRawKey * (msg : i.IntuiMessagePtr) : INTEGER;
VAR
	code : e.UWORD;
	RKD : OberRawKeyDecoder;
BEGIN
	NEW(RKD);
	IF RKD # NIL THEN
		code := msg.code;
		RKD.Init(msg);
		ReplyMsg(msg);
		IF InputEvent.rCommand IN RKD.qualifier THEN
			ob.DoKeyShortcut(RKD.key, code)
		END;
		RETURN Continue
	ELSE
		RETURN Pass
	END
END OnRawKey;

PROCEDURE (ob : OberWindow) OnReqVerify * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnReqVerify;

PROCEDURE (ob : OberWindow) OnReqClear * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnReqClear;

PROCEDURE (ob : OberWindow) OnMenuVerify * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnMenuVerify;

PROCEDURE (ob : OberWindow) OnNewPrefs * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnNewPrefs;

PROCEDURE (ob : OberWindow) OnDiskInserted * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnDiskInserted;

PROCEDURE (ob : OberWindow) OnDiskRemoved * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnDiskRemoved;

PROCEDURE (ob : OberWindow) OnActiveWindow * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnActiveWindow;

PROCEDURE (ob : OberWindow) OnInactiveWindow * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnInactiveWindow;

PROCEDURE (ob : OberWindow) OnDeltaMove * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnDeltaMove;

PROCEDURE (ob : OberWindow) OnVanillaKey * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnVanillaKey;

PROCEDURE (ob : OberWindow) OnIntuiTicks * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnIntuiTicks;

PROCEDURE (ob : OberWindow) OnIdcmpUpdate * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnIdcmpUpdate;

PROCEDURE (ob : OberWindow) OnMenuHelp * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnMenuHelp;

PROCEDURE (ob : OberWindow) OnChangeWindow * (msg : i.IntuiMessagePtr) : INTEGER;
BEGIN RETURN Pass; END OnChangeWindow;

PROCEDURE (ob : OberWindow) OnGadgetHelp * (msg : i.IntuiMessagePtr) : INTEGER;
VAR
	gad   : i.GadgetPtr;
	ooGad   : OberGadget;
	code : e.UWORD;
BEGIN
	gad := SYS.VAL(i.GadgetPtr, msg.iAddress);
	code := msg.code;
	ReplyMsg(msg);
	IF gad # NIL THEN (* gad is NIL if moving off the window *)
		ooGad := ob.FindGadget(gad.gadgetID);
		IF ooGad # NIL THEN
			IF ooGad.gadHelpCbProc # NIL THEN
				ooGad.gadHelpCbProc(ooGad, code);
			END;
		ELSE
			IF ob.gadHelpCbProc # NIL THEN
				ob.gadHelpCbProc(ob, code);
			END;
		END;
	END;
	RETURN Continue;
END OnGadgetHelp;

(*=================================================================
			OberPort Message Functions - provide Callback methods
			Do not touch these, they only push the callback back
			to the OberWindow, nothing more.
 =================================================================*)
PROCEDURE (oport : OberPort) HandleSizeVerify ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnSizeVerify( msg ); END HandleSizeVerify;
PROCEDURE (oport : OberPort) HandleNewSize ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnNewSize( msg ); END HandleNewSize;
PROCEDURE (oport : OberPort) HandleRefreshWindow ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnRefreshWindow( msg ); END HandleRefreshWindow;
PROCEDURE (oport : OberPort) HandleMouseButtons ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnMouseButtons( msg ); END HandleMouseButtons;
PROCEDURE (oport : OberPort) HandleMouseMove ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnMouseMove( msg ); END HandleMouseMove;
PROCEDURE (oport : OberPort) HandleGadgetDown ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnGadgetDown( msg ); END HandleGadgetDown;
PROCEDURE (oport : OberPort) HandleGadgetUp ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnGadgetUp( msg ); END HandleGadgetUp;
PROCEDURE (oport : OberPort) HandleReqSet ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnReqSet( msg ); END HandleReqSet;
PROCEDURE (oport : OberPort) HandleMenuPick ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnMenuPick( msg ); END HandleMenuPick;
PROCEDURE (oport : OberPort) HandleCloseWindow ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnCloseWindow( msg ); END HandleCloseWindow;
PROCEDURE (oport : OberPort) HandleRawKey ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnRawKey( msg ); END HandleRawKey;
PROCEDURE (oport : OberPort) HandleReqVerify ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnReqVerify( msg ); END HandleReqVerify;
PROCEDURE (oport : OberPort) HandleReqClear ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnReqClear( msg ); END HandleReqClear;
PROCEDURE (oport : OberPort) HandleMenuVerify ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnMenuVerify( msg ); END HandleMenuVerify;
PROCEDURE (oport : OberPort) HandleNewPrefs ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnNewPrefs( msg ); END HandleNewPrefs;
PROCEDURE (oport : OberPort) HandleDiskInserted ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnDiskInserted( msg ); END HandleDiskInserted;
PROCEDURE (oport : OberPort) HandleDiskRemoved ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnDiskRemoved( msg ); END HandleDiskRemoved;
PROCEDURE (oport : OberPort) HandleActiveWindow ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnActiveWindow( msg ); END HandleActiveWindow;
PROCEDURE (oport : OberPort) HandleInactiveWindow ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnInactiveWindow( msg ); END HandleInactiveWindow;
PROCEDURE (oport : OberPort) HandleDeltaMove ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnDeltaMove( msg ); END HandleDeltaMove;
PROCEDURE (oport : OberPort) HandleVanillaKey ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnVanillaKey( msg ); END HandleVanillaKey;
PROCEDURE (oport : OberPort) HandleIntuiTicks ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnIntuiTicks( msg ); END HandleIntuiTicks;
PROCEDURE (oport : OberPort) HandleIdcmpUpdate ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnIdcmpUpdate( msg ); END HandleIdcmpUpdate;
PROCEDURE (oport : OberPort) HandleMenuHelp ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnMenuHelp( msg ); END HandleMenuHelp;
PROCEDURE (oport : OberPort) HandleChangeWindow ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnChangeWindow( msg ); END HandleChangeWindow;
PROCEDURE (oport : OberPort) HandleGadgetHelp ( msg : i.IntuiMessagePtr ) : INTEGER;
BEGIN RETURN oport.PortsWin.OnGadgetHelp( msg ); END HandleGadgetHelp;


(***********************************************************************
 ======================================================================
	OberCanvas Procedures
 ======================================================================
************************************************************************)

PROCEDURE (ob : OberCanvas) Init * ( Name : ARRAY OF CHAR;
									 tags : ObjTags;
									 parent : OberObject);
BEGIN
	Errors.Assert(parent IS OberWindow, "Init : Invalid parent object type");
	ob.Init^ (Name, tags, parent);
	(* Now setup defaults *)
	ob.SetTag(fgColor, 1, FALSE);
	ob.SetTag(bgColor, 0, FALSE);
	ob.SetTag(drawMode, gfx.jam1, FALSE);
	ob.initialized := TRUE;
END Init;

PROCEDURE (ob : OberCanvas) ReDisplay *;
BEGIN
		ob.Hide;
		ob.Show;
		ob.Parent(OberWindow).RefreshWindow;
END ReDisplay;

PROCEDURE (ob : OberCanvas) SetDimensions * ( x, y, w, h : INTEGER );
(* x, y relative to window top left. w, h in pixels *)
BEGIN
	ob.SetTag(obLeft, x, TRUE);
	ob.SetTag(obTop, y, TRUE);
	ob.SetTag(obWidth, w, TRUE);
	ob.SetTag(obHeight, h, TRUE);
	ob.ReDisplay;
END SetDimensions;

PROCEDURE (ob : OberCanvas) MoveTo * ( x, y : INTEGER );
BEGIN
	IF ob.IsVisible() THEN
		Errors.Assert(ob.iObject # NIL, "MoveTo : rasport = NIL");
(**)    Dos.PrintF("moveTo\n", NIL);
		gfx.Move(ob.iObject,
			x + ob.Parent(OberWindow).iObject.borderLeft,
			y + ob.Parent(OberWindow).iObject.borderTop);
	END
END MoveTo;

PROCEDURE (ob : OberCanvas) Show * ;
BEGIN
	IF ob.Parent.IsVisible() & ~ob.Visible THEN
		ob.Visible := TRUE;
		ob.iObject := ob.Parent(OberWindow).iObject.rPort;
		Errors.Assert(ob.iObject # NIL, "Show : Rastport = NIL");
		gfx.SetAPen( ob.iObject, SYS.VAL(e.UBYTE, (ob.GetTagValue(fgColor, 0) ) ) );
		gfx.SetBPen( ob.iObject, SYS.VAL(e.UBYTE, (ob.GetTagValue(bgColor, 2) ) ) );
		gfx.SetDrMd( ob.iObject, SYS.VAL(Sets.SET8, ob.GetTagValue(drawMode, gfx.jam1 )) );
		ob.ShowVisibleChildren;
	END;
	ob.Visible := TRUE;
END Show;

PROCEDURE (ob : OberCanvas) Hide * ;
BEGIN
	IF ob.IsVisible() THEN
		ob.HideVisibleChildren;
		ob.iObject := NIL;
		ob.Visible := FALSE;
	END;
	ob.Visible := FALSE;
END Hide;

PROCEDURE (ob : OberCanvas) Scroll * ( x, y : INTEGER );
VAR minx, miny, maxx, maxy : INTEGER;
BEGIN
	IF ob.IsVisible() THEN
(**)    Dos.PrintF("Scroll\n", NIL);
		minx := ob.Parent(OberWindow).iObject.borderLeft;
		miny := ob.Parent(OberWindow).iObject.borderTop;
		maxx := (ob.Parent(OberWindow).iObject.width - 1) -
				ob.Parent(OberWindow).iObject.borderRight;
		maxy := (ob.Parent(OberWindow).iObject.height - 1) -
				ob.Parent(OberWindow).iObject.borderBottom;

		Errors.Assert(ob.iObject # NIL, "Scroll : rasport = NIL");
		i.ScrollWindowRaster(ob.Parent(OberWindow).iObject, x, y,
							minx, miny, maxx, maxy);
	END
END Scroll;

PROCEDURE (ob : OberCanvas) SetFgColor * ( color : e.UBYTE );
BEGIN
	IF ob.IsVisible() THEN
		Errors.Assert(ob.iObject # NIL, "SetFgColor : Rastport = NIL");
		gfx.SetAPen( ob.iObject, color );
	END;
	ob.SetTag(fgColor, color, TRUE);
END SetFgColor;

PROCEDURE (ob : OberCanvas) SetBgColor * ( color : e.UBYTE );
BEGIN
	IF ob.IsVisible() THEN
		Errors.Assert(ob.iObject # NIL, "SetBgColor : Rastport = NIL");
		gfx.SetBPen( ob.iObject, color );
	END;
	ob.SetTag(bgColor, color, TRUE);
END SetBgColor;

PROCEDURE (ob : OberCanvas) SetDrawMode * ( drMode : Sets.SET8 );
BEGIN
	IF ob.IsVisible() THEN
		Errors.Assert(ob.iObject # NIL, "SetDrawMode : Rastport = NIL");
		gfx.SetDrMd( ob.iObject, drMode );
	END;
	ob.SetTag(drawMode, drMode, TRUE);
END SetDrawMode;

PROCEDURE (ob : OberCanvas) WriteText * ( text : ARRAY OF CHAR );
BEGIN
	IF ob.IsVisible() THEN
		Errors.Assert(ob.iObject # NIL, "WriteText : Rastport = NIL");
		gfx.Text( ob.iObject, text, Strings.Length(text) );
	END
END WriteText;


(***********************************************************************
 ======================================================================
	OberGadget Procedures
 ======================================================================
************************************************************************)

PROCEDURE (ob : OberGadget) Init * ( Name : ARRAY OF CHAR;
									 tags : ObjTags;
									 parent : OberObject);
BEGIN                                
	Errors.Assert(parent IS VirtWindow, "Init : Invalid parent object type");
	ob.Init^ (Name, tags, parent);
	(* setup defaults *)
	ob.SetTag(gt.underscore, '_', FALSE);
	IF ob IS OberListView THEN
		esup.NewList(ob(OberListView).List);
	END;
	ob.enabled := TRUE;
	ob.initialized := TRUE;
END Init;


PROCEDURE (ob : OberGadget) SaveValues;
BEGIN
	(* Virtual Function to store all the gadget values that MAY HAVE
	   CHANGED since being first displayed. This must include all
	   gadget parameters that can be changed by clicking on it, typing
	   in it, etc.
	*)
END SaveValues;


PROCEDURE (ob : OberGadget) ReDisplay *;
BEGIN
		ob.Hide;
		ob.Show;
		ob.Parent(VirtWindow).parentWin.RefreshWindow;
END ReDisplay;


(* OberGadget.SetAttr ***********************************************

	This deals with distributing attributes between being able to
	set them at run time (using GT_SetAttributes) or only when the
	gadget is created (in which case use ob.ReDisplay).

*********************************************************************)

PROCEDURE (ob : OberGadget) SetAttr * ( thetag : U.Tag;
										thevalue : U.TagID );
BEGIN
	CASE SYS.VAL(LONGINT, thetag) OF
		(* Buttons *)
		i.gaDisabled,

		(* Check Boxes *)
		gt.cbChecked,

		(* Cycle Gadgets *)
		gt.cyActive, gt.cyLabels,

		(* Integer Gadgets *)
		gt.inNumber,

		(* ListViews *)
		gt.lvTop, gt.lvMakeVisible, gt.lvLabels, gt.lvSelected,

		(* Radio Buttons *)
		gt.mxActive,

		(* Number Displays *)
		gt.nmNumber, gt.nmFrontPen, gt.nmBackPen, gt.nmJustification, gt.nmFormat,

		(* Palettes *)
		gt.paColor, gt.paColorOffset, gt.paColorTable,

		(* Scrollers *)
		gt.scTop, gt.scVisible, gt.scTotal,

		(* Sliders *)
		gt.slMin, gt.slMax, gt.slLevel, gt.slLevelFormat, gt.slDispFunc, gt.slJustification,

		(* String Gadgets *)
		gt.stString,

		(* Text Display *)
		gt.txText (* gt.txFrontPen, gt.txBackPen, gt.txJustification *)

				: ob.SetTag(thetag, thevalue, TRUE);
				  IF ob.IsVisible() THEN
						gt.SetGadgetAttrs(ob.iObject^,
							ob.Parent(VirtWindow).parentWin.iObject, NIL,
							thetag, thevalue, U.done )
				  END;
	ELSE
		ob.SetTag(thetag, thevalue, TRUE);
		ob.ReDisplay
	END
	(*
	+++++ THE BELOW ARE HERE AS A REMINDER ONLY +++++

		(* Buttons, Integer, String, Scrollers and Sliders *)
		i.gaImmediate,

		(* Check Box *)
		gt.cbScaled,

		(* Integer and String gadgets *)
		i.gaTabCycle, i.stringaExitHelp, i.stringaJustification, i.stringaReplaceMode

		(* Integer Gadgets *)
		gt.inMaxChars, gt.inEditHook,

		(* ListViews and Radio Buttons *)
		i.layoutaSpacing,

		(* ListViews *)
		gt.lvReadOnly, gt.lvScrollWidth, gt.lvShowSelected,
			gt.lvItemHeight, gt.lvCallBack, gt.lvMaxPen,
		
		(* Radio Buttons *)
		gt.mxLabels, gt.mxSpacing, gt.mxScaled, gt.mxTitlePlace,

		(* Number Displays *)
		gt.nmBorder, gt.nmMaxNumberLen, gt.nmClipped,

		(* Palettes *)
		gt.paDepth, gt.paIndicatorWidth, gt.paIndicatorHeight, gt.paNumColors,

		(* Scroller and Slider gads *)
		i.gaRelVerify, i.pgaFreedom,

		(* Scrollers *)
		gt.scArrows,

		(* Sliders *)
		gt.slMaxLevelLen, gt.slLevelPlace, gt.slDispFunc, gt.slMaxPixelLen,
			gt.slJustification,
		
		(* String Gadgets *)
		gt.stMaxChars, gt.stEditHook,

		(* Text Display *)
		gt.txCopyText, gt.txBorder, gt.txClipped

				: ob.SetTag(thetag, thevalue, TRUE);
				  ob.ReDisplay;
	ELSE
		ob.SetTag(thetag, thevalue, TRUE);
	END
	*)
END SetAttr;


(* OberGadget.GetAttr ***********************************************

	This is the same as the above in reverse.

*********************************************************************)

PROCEDURE (ob : OberGadget) GetAttr * ( thetag : U.Tag ) : LONGINT;
VAR
	numDone, val : LONGINT;
BEGIN
	CASE SYS.VAL(LONGINT, thetag) OF

		(* Most Gadgets *)
		i.gaDisabled,

		(* Check Boxes *)
		gt.cbChecked,

		(* Cycle Gadgets *)
		gt.cyActive, gt.cyLabels,

		(* Integer Gadgets *)
		gt.inNumber,

		(* Listviews *)
		gt.lvTop, gt.lvLabels, gt.lvSelected,

		(* Radio Buttons *)
		gt.mxActive,

		(* Number Displays *)
		gt.nmNumber,

		(* Palettes *)
		gt.paColor, gt.paColorOffset, gt.paColorTable,

		(* Scrollers *)
		gt.scTop, gt.scTotal, gt.scVisible,

		(* Sliders *)
		gt.slMin, gt.slMax, gt.slLevel,

		(* String Gadgets *)
		gt.stString,

		(* Text Displays *)
		gt.txText

					: IF ob.IsVisible() THEN
							numDone := gt.GetGadgetAttrs(ob.iObject,
								ob.Parent(VirtWindow).parentWin.iObject, NIL,
								thetag, SYS.ADR(val), U.done );
							Errors.Assert(numDone = 1, "GTGetAttr : Failed. Aborting");
							RETURN val
					ELSE
							RETURN ob.GetTagValue(thetag, 0)
					END;
	ELSE
		RETURN ob.GetTagValue(thetag, 0)
	END
END GetAttr;


(* OberGadget.SetText ***********************************************

	Set the text in the gadget. This also calls AddUnderscore to add
	callbacks to the window's list.

*********************************************************************)

PROCEDURE (ob : OberGadget) SetText * (txt : ARRAY OF CHAR );
BEGIN
	Errors.Assert(ob.initialized, "Gadget not initialized");
	IF ob.gadText # NIL THEN
		ob.Parent(VirtWindow).parentWin.RemoveUnderscore( ob.gadText^ )
	END;
	NEW(ob.gadText, LEN(txt));
	Errors.Assert(ob.gadText # NIL, "SetText : Out of Memory");
	COPY(txt, ob.gadText^);
	ob.Parent(VirtWindow).parentWin.AddUnderscore(txt, ob);
	ob.SetTag(obText, ob.gadText, TRUE);
	ob.ReDisplay;
END SetText;
	

(* OberGadget.GetText ***********************************************

	Gets the current text in the gadget.

*********************************************************************)

PROCEDURE (ob : OberGadget) GetText * (VAR gadText : ARRAY OF CHAR);
VAR
	strp : e.STRPTR;
BEGIN
	Errors.Assert(ob.initialized, "GetText : Gadget not initialized");
	strp := SYS.VAL(e.STRPTR, ob.GetTagValue(obText, SYS.ADR("")));
	COPY(strp^, gadText);
END GetText;


(* OberGadget.SetDimensions *****************************************

	Sets the dimensions of the gadget. Not all dimensions are relevant
	for example radio buttons are sized by the number of labels.

*********************************************************************)

PROCEDURE (ob : OberGadget) SetDimensions * (x,y,w,h : INTEGER);
BEGIN
	ob.SetTag(obLeft, x, TRUE);
	ob.SetTag(obTop, y, TRUE);
	ob.SetTag(obWidth, w, TRUE);
	ob.SetTag(obHeight, h, TRUE);
	ob.ReDisplay;
END SetDimensions;


(* OberGadget.SetCallback *******************************************

	This sets the default callback procedure for this gadget. This
	will be called when a certain event happens to the gadget, for
	example a button gets clicked, return is pressed in a string
	gadget etc. This is also called when the shortCut key is pressed.

*********************************************************************)

PROCEDURE (ob : OberGadget) SetCallback * (cbp : cbProcType);
BEGIN
	ob.defCbProc := cbp;
END SetCallback;

PROCEDURE (ob : OberGadget) SetGadDownCallback * (cbp : cbProcType);
BEGIN
	ob.gadDownCbProc := cbp;
END SetGadDownCallback;

PROCEDURE (ob : OberGadget) SetDblClkCallback * (cbp : cbProcType);
BEGIN
	ob.gadDblClkCbProc := cbp;
END SetDblClkCallback;

PROCEDURE (ob : OberGadget) SetGadHelpCallback * (cbp : cbProcType);
BEGIN
	ob.gadHelpCbProc := cbp;
END SetGadHelpCallback;

(* OberGadget.Show **************************************************

	Come on, you must know this one by now...

*********************************************************************)

PROCEDURE (ob : OberGadget) Show *;
VAR
	newGad : gt.NewGadget;
	pos : e.UWORD;
	gadKind : e.ULONG;
BEGIN
	IF ob.Parent.IsVisible() & ~ob.Visible THEN
		Errors.Assert(ob.initialized, "Show : Cannot show gadget - not initialized");
		IF ob.GetTagValue(gtGadget, FALSE) = LTRUE THEN
			IF ob.Parent(VirtWindow).parentWin.vi # NIL THEN
				newGad.textAttr :=      ob.Parent(VirtWindow).parentWin.iObject.wScreen.font;
				newGad.visualInfo :=    ob.Parent(VirtWindow).parentWin.vi;
				newGad.leftEdge :=      SHORT(ob.GetTagValue(obLeft, 0) + ob.Parent(VirtWindow).GetLeftBorder());
				newGad.topEdge :=       SHORT(ob.GetTagValue(obTop, 0) + ob.Parent(VirtWindow).GetTopBorder());
				newGad.width :=         SHORT(ob.GetTagValue(obWidth, 0));
				newGad.height :=        SHORT(ob.GetTagValue(obHeight, 0));
				newGad.gadgetText :=    SYS.VAL(e.LSTRPTR, ob.GetTagValue(obText, SYS.ADR("")));
				newGad.gadgetID :=      SYS.VAL(e.UWORD, U.GetUniqueID());
				gadKind := ob.GetTagValue(gtGadKind, gt.genericKind);
				ob.iObject := SYS.VAL(i.ExtGadgetPtr, gt.CreateGadgetA( gadKind,
												ob.Parent(VirtWindow).parentWin.LastGadget,
												newGad,
												ob.tagList^));
				IF ob.iObject # NIL THEN
					IF ob.GetTagValue(gadHelp, FALSE) = LTRUE THEN
						ob.iObject.flags := ob.iObject.flags + {i.gExtended};
						ob.iObject.moreFlags := ob.iObject.moreFlags + {i.gmoreGadgetHelp};
					END;
					pos := i.AddGList(ob.Parent(VirtWindow).parentWin.iObject, ob.Parent(VirtWindow).parentWin.LastGadget.nextGadget, -1, -1, NIL);
					ob.Parent(VirtWindow).parentWin.LastGadget := ob.iObject;
					ob.Parent(VirtWindow).parentWin.LastGadget.nextGadget := NIL;
				END;
				ob.Visible := TRUE;
				ob.ShowVisibleChildren;
			END;
		END;
	END;
	ob.Visible := TRUE;
END Show;


(* OberGadget.Hide ***************************************************

	See above ;)

**********************************************************************)

PROCEDURE (ob : OberGadget) Hide *;
VAR
	pos : e.UWORD;
	minx, miny, maxx, maxy : INTEGER;
	oldContext : i.GadgetPtr;
	prevGad, thisGad : i.GadgetPtr;
BEGIN
	IF ob.IsVisible() THEN
		ob.HideVisibleChildren;
		ob.SaveValues;
		ob.Visible := FALSE;
		pos := i.RemoveGList(ob.Parent(VirtWindow).parentWin.iObject, ob.Parent(VirtWindow).parentWin.gtContext, -1);
		oldContext := ob.Parent(VirtWindow).parentWin.gtContext;
		ob.Parent(VirtWindow).parentWin.LastGadget := gt.CreateContext(ob.Parent(VirtWindow).parentWin.gtContext);
		ob.Parent(VirtWindow).parentWin.ShowVisibleChildren;
		gt.FreeGadgets(oldContext);
	END;
	ob.Visible := FALSE;
END Hide;


(* OberGadget.Enable **************************************************

	Enable the gadget.

***********************************************************************)

PROCEDURE (ob : OberGadget) Enable *;
BEGIN
	ob.SetAttr(i.gaDisabled, SYS.VAL(U.TagID, TRUE) );
END Enable;


(* OberGadget.Disable *************************************************

	Disable the gadget, greying it out.

***********************************************************************)

PROCEDURE (ob : OberGadget) Disable *;
BEGIN
	ob.SetAttr(i.gaDisabled, SYS.VAL(U.TagID, FALSE) );
END Disable;


(**********************************************************************
 =====================================================================
	OberPushButton
 =====================================================================
***********************************************************************)

PROCEDURE (ob : OberPushButton) Init * ( Name : ARRAY OF CHAR;
										 tags : ObjTags;
										 parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	IF ob.Parent(VirtWindow).parentWin.ModifyIDCMP( Add, {i.gadgetUp} ) THEN
		ob.SetTag( gtGadget, TRUE, TRUE );
		ob.SetTag( gtGadKind, gt.buttonKind, TRUE );
	END;
END Init;


(* Utility Function : AddLabelPred ************************************

	Adds a String to the end of an open array of strings (of type
	LabelType) allocating memory to the open array as it goes.

***********************************************************************)

PROCEDURE AddLabelPred ( Label : ARRAY OF CHAR;
						 VAR GadLabels : LabelType;
						 VAR NumLabels : INTEGER );
VAR
	NewLabels : LabelType;
BEGIN
	rider := 0;
	NEW(NewLabels, NumLabels + 2);
	IF NewLabels # NIL THEN
		WHILE rider < NumLabels DO
			NewLabels[rider] := GadLabels[rider];
			INC(rider)
		END;
		SYS.NEW(NewLabels[NumLabels], LEN(Label));
		IF NewLabels[NumLabels] # NIL THEN
			COPY(Label, NewLabels[NumLabels]^);
			INC(NumLabels);
			GadLabels := NewLabels
		END
	END
END AddLabelPred;


(***********************************************************************
 ======================================================================
	OberCheckBox Functions
 ======================================================================
************************************************************************)

PROCEDURE (ob : OberCheckBox) Init * (   Name : ARRAY OF CHAR;
										 tags : ObjTags;
										 parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	IF ob.Parent(VirtWindow).parentWin.ModifyIDCMP( Add, {i.gadgetUp} ) THEN
		ob.SetTag( gtGadget, TRUE, TRUE );
		ob.SetTag( gtGadKind, gt.checkBoxKind, TRUE );
	END;
END Init;


(* OberCheckBox.SetState ***********************************************

	Set the checked state of the checkbox.

************************************************************************)

PROCEDURE (ob : OberCheckBox) SetState * (checked : BOOLEAN);
(* Set the state (checked/unchecked) of the checkbox *)
BEGIN
	ob.SetAttr(gt.cbChecked, SYS.VAL(e.ULONG, checked));
END SetState;


(* OberCheckBox.GetState ***********************************************

	Get the current checked state of the checkbox

************************************************************************)

PROCEDURE (ob : OberCheckBox) GetState * () : BOOLEAN;
(* Return the current state of the checkbox *)
BEGIN
	RETURN SYS.VAL(BOOLEAN, ob.GetAttr(gt.cbChecked) );
END GetState;


PROCEDURE (ob : OberCheckBox) SaveValues;
VAR
	numDone, state : LONGINT;
BEGIN
	numDone := gt.GetGadgetAttrs(ob.iObject, ob.Parent(VirtWindow).parentWin.iObject, NIL,
									gt.cbChecked, SYS.ADR(state), U.done);
	Errors.Assert(numDone = 1, "Failed CheckBox.SaveValues");
	ob.SetTag(gt.cbChecked, state, TRUE);
END SaveValues;


(**********************************************************************
 =====================================================================
	OberRadioButton Functions
 =====================================================================
***********************************************************************)


PROCEDURE (ob : OberRadioButton) Init * ( Name : ARRAY OF CHAR;
										 tags : ObjTags;
										 parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	IF ob.Parent(VirtWindow).parentWin.ModifyIDCMP( Add, {i.gadgetDown} ) THEN
		ob.SetTag( gtGadget, TRUE, TRUE );
		ob.SetTag( gtGadKind, gt.mxKind, TRUE );
	END;
END Init;


PROCEDURE (ob : OberRadioButton) SaveValues;
VAR
	numDone, Active : LONGINT;
BEGIN
	numDone := gt.GetGadgetAttrs(ob.iObject, ob.Parent(VirtWindow).parentWin.iObject, NIL,
								gt.mxActive, SYS.ADR(Active), U.done);
	Errors.Assert(numDone = 1, "Failed RadioButton.SaveValues");
	ob.SetTag(gt.mxActive, Active, TRUE);
END SaveValues;
	

PROCEDURE (ob : OberRadioButton) AddLabel * (Label : ARRAY OF CHAR);
(* Add a label to the end of the label array (and display results) *)
BEGIN
	AddLabelPred ( Label, ob.Labels, ob.NumLabels );
	ob.SetAttr(gt.mxLabels, SYS.VAL(U.TagID, ob.Labels) );
END AddLabel;


PROCEDURE (ob : OberRadioButton) SetCallback * (cbp : cbProcType);
BEGIN
	ob.gadDownCbProc := cbp;
END SetCallback;


PROCEDURE (ob : OberRadioButton) SetActive * (active : INTEGER);
(* Sets the current (Active) button starting from 0 *)
BEGIN
	ob.SetAttr(gt.mxActive, active);
END SetActive;


PROCEDURE (ob : OberRadioButton) SetText * (Name : ARRAY OF CHAR);
(* As above but use the button text *)
BEGIN
	rider := 0;
	LOOP
		IF ob.Labels[rider]^ = Name THEN
			ob.SetActive(rider);
			EXIT;
		END;
		INC(rider);
	END;
END SetText;


PROCEDURE (ob : OberRadioButton) GetActive * () : INTEGER;
(* Gets the current active radio button *)
BEGIN
	RETURN SHORT(ob.GetAttr(gt.mxActive));
END GetActive;


PROCEDURE (ob : OberRadioButton) GetText * (VAR Name : ARRAY OF CHAR);
(* Gets the current active buttons text *)
VAR
	Active : INTEGER;
BEGIN
	Active := ob.GetActive();
	IF ob.Labels[Active] # NIL THEN
		COPY(ob.Labels[Active]^, Name);
	END;
END GetText;


(**********************************************************************
 =====================================================================
	OberCycleGadget Functions
 =====================================================================
***********************************************************************)

PROCEDURE (ob : OberCycleGadget) Init * ( Name : ARRAY OF CHAR;
										  tags : ObjTags;
										  parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	IF ob.Parent(VirtWindow).parentWin.ModifyIDCMP( Add, {i.gadgetUp} ) THEN
		ob.SetTag( gtGadget, TRUE, TRUE );
		ob.SetTag( gtGadKind, gt.cycleKind, TRUE );
	END;
END Init;


PROCEDURE (ob : OberCycleGadget) SaveValues;
VAR
	numDone, Active : LONGINT;
BEGIN
	numDone := gt.GetGadgetAttrs(ob.iObject, ob.Parent(VirtWindow).parentWin.iObject, NIL,
							gt.cyActive, SYS.ADR(Active), U.done);
	Errors.Assert(numDone = 1, "Failed CycleGadget.SaveValues");
	ob.SetTag(gt.cyActive, Active, TRUE);
END SaveValues;


PROCEDURE (ob : OberCycleGadget) AddLabel * (Label : ARRAY OF CHAR);
(* Adds a label to the end of the list *)
BEGIN
	AddLabelPred ( Label, ob.Labels, ob.NumLabels );
	ob.SetAttr(gt.cyLabels, SYS.VAL(e.ULONG, ob.Labels));
END AddLabel;


PROCEDURE (ob : OberCycleGadget) SetActive * (active : INTEGER);
(* Sets the current active label *)
BEGIN
	ob.SetAttr(gt.cyActive, active);
END SetActive;


PROCEDURE (ob : OberCycleGadget) SetText * (Name : ARRAY OF CHAR);
(* As above using the string to define the label *)
BEGIN
	rider := 0;
	LOOP
		IF ob.Labels[rider]^ = Name THEN
			ob.SetActive(rider);
			EXIT;
		END;
		INC(rider);
		IF rider = LEN(ob.Labels^) THEN
			Errors.Assert(FALSE, "SetText : Label not found in list")
		END
	END
END SetText;


PROCEDURE (ob : OberCycleGadget) GetActive * () : INTEGER;
(* Get the currently active label number *)
BEGIN
	RETURN SHORT( ob.GetAttr(gt.cyActive) );
END GetActive;


PROCEDURE (ob : OberCycleGadget) GetText * (VAR Name : ARRAY OF CHAR);
(* Get the currently active label text *)
VAR
	Active : INTEGER;
BEGIN
	Active := ob.GetActive();
	IF ob.Labels[Active] # NIL THEN
		COPY(ob.Labels[Active]^, Name)
	END
END GetText;


(**********************************************************************
 =====================================================================
	OberListView Functions
 =====================================================================
***********************************************************************)

PROCEDURE (ob : OberListView) Init * ( Name : ARRAY OF CHAR;
										 tags : ObjTags;
										 parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	IF ob.Parent(VirtWindow).parentWin.ModifyIDCMP( Add,
				{i.gadgetUp, i.gadgetDown, i.intuiTicks} ) THEN
		ob.SetTag( gtGadget, TRUE, TRUE );
		ob.SetTag( gtGadKind, gt.listViewKind, TRUE );
	END;
END Init;


PROCEDURE (ob : OberListView) SaveValues;
VAR numDone, TopItem, Selected : LONGINT;
BEGIN
	numDone := gt.GetGadgetAttrs(ob.iObject, ob.Parent(VirtWindow).parentWin.iObject, NIL,
				gt.lvTop, SYS.ADR(TopItem), gt.lvSelected, SYS.ADR(Selected),
				U.done );
	Errors.Assert(numDone = 2, "Failed in ListView.SaveValues");
	ob.SetTag(gt.lvTop, TopItem, TRUE);
	ob.SetTag(gt.lvSelected, Selected, TRUE);
END SaveValues;


PROCEDURE (ob : OberListView) AddLabel * (Label : ARRAY OF CHAR);
(* Add this label to the end of the list *)
VAR
	node : e.NodePtr;
BEGIN
	ob.SetAttr(gt.lvLabels, -1);
	NEW(node);
	IF node # NIL THEN
		SYS.NEW(node.name, LEN(Label));
		IF node.name # NIL THEN
			COPY(Label, node.name^);
			e.AddTail(ob.List, node);
			ob.SetTag(gt.lvLabels, SYS.ADR(ob.List), TRUE)
		END
	END;
	ob.SetAttr(gt.lvLabels, SYS.ADR(ob.List))
END AddLabel;
	

PROCEDURE (ob : OberListView) SetActive * (active : INTEGER);
(* Sets the currently active label *)
BEGIN
	ob.SetAttr(gt.lvSelected, active);
END SetActive;


<*$OvflChk+ *>

PROCEDURE (ob : OberListView) SetText * (text : ARRAY OF CHAR);
(* Sets the currently active label using the contents *)
VAR i : INTEGER;
	node : e.NodePtr;
BEGIN
	i := 0;
	node := ob.List.head;
	LOOP
		IF node = NIL THEN EXIT END;
		IF node.name^ = text THEN
			ob.SetActive(i);
			EXIT; (* WHILE *)
		END;
		node := node.succ;
		i := i + 1;
	END
END SetText;

<*$OvflChk- *>

<*$NilChk- *>
<*$TypeChk- *>

PROCEDURE (ob : OberListView) GetActive * () : LONGINT;
(* Gets the currently active selection *)
VAR numDone, Selected : LONGINT;
BEGIN
	numDone := gt.GetGadgetAttrs(ob.iObject, ob.Parent(VirtWindow).parentWin.iObject, NIL,
					gt.lvSelected, SYS.ADR(Selected), U.done);
	IF numDone = 1 THEN
		RETURN Selected;
	ELSE
		RETURN -1;
	END;
END GetActive;

<*$TypeChk+ *>
<*$NilChk+ *>


PROCEDURE (ob : OberListView) GetText * (VAR text : ARRAY OF CHAR);
(* Gets the text of the currently active item *)
VAR Active, i : LONGINT;
	node : e.NodePtr;
BEGIN
	Active := ob.GetActive();
	IF Active # -1 THEN
		node := ob.List.head;
		FOR i := 0 TO Active - 1 DO
			node := node.succ;
		END;
		COPY(node.name^, text);
	END
END GetText;



PROCEDURE (ob : OberListView) SetReadOnly * (IsRO : BOOLEAN);
(* Sets the listview to read only *)
BEGIN
	ob.SetAttr(gt.lvReadOnly, SYS.VAL(U.TagID, IsRO) );
END SetReadOnly;
	

(************************************************************************)
(*  OberIntegerGad Functions                                            *)
(*  ========================                                            *)
(************************************************************************)

PROCEDURE (ob : OberIntegerGad) Init * ( Name : ARRAY OF CHAR;
										 tags : ObjTags;
										 parent : OberObject);
BEGIN
	ob.Init^(Name, tags, parent);
	IF ob.Parent(VirtWindow).parentWin.ModifyIDCMP( Add, {i.gadgetUp} ) THEN
		ob.SetTag( gtGadget, TRUE, TRUE );
		ob.SetTag( gtGadKind, gt.integerKind, TRUE );
	END;
END Init;


(************************************************************************)
(*  OberStringGad Functions                                             *)
(*  =======================                                             *)
(************************************************************************)

PROCEDURE (ob : OberStringGad) Init * ( Name : ARRAY OF CHAR;
										tags : ObjTags;
										parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	ob.SetTag( gtGadget, TRUE, TRUE );
	ob.SetTag( gtGadKind, gt.stringKind, TRUE );
END Init;


(************************************************************************)
(*  OberStaticText Functions                                            *)
(*  ========================                                            *)
(************************************************************************)

PROCEDURE (ob : OberStaticText) Init * ( Name : ARRAY OF CHAR;
										 tags : ObjTags;
										 parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	ob.SetTag( gtGadget, TRUE, TRUE );
	ob.SetTag( gtGadKind, gt.textKind, TRUE );
END Init;


(************************************************************************)
(*  OberStaticNumber Functions                                          *)
(*  ==========================                                          *)
(************************************************************************)

PROCEDURE (ob : OberStaticNumber) Init * ( Name : ARRAY OF CHAR;
										   tags : ObjTags;
										   parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	ob.SetTag( gtGadget, TRUE, TRUE );
	ob.SetTag( gtGadKind, gt.numberKind, TRUE );
END Init;


(************************************************************************)
(*  OberPaletteGad Functions                                            *)
(*  ========================                                            *)
(************************************************************************)

PROCEDURE (ob : OberPaletteGad) Init * ( Name : ARRAY OF CHAR;
										 tags : ObjTags;
										 parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	ob.SetTag( gtGadget, TRUE, TRUE );
	ob.SetTag( gtGadKind, gt.paletteKind, TRUE );
END Init;


(************************************************************************)
(*  OberScrollerGad Functions                                           *)
(*  =========================                                           *)
(************************************************************************)

PROCEDURE (ob : OberScrollerGad) Init * ( Name : ARRAY OF CHAR;
										  tags : ObjTags;
										  parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	ob.SetTag( gtGadget, TRUE, TRUE );
	ob.SetTag( gtGadKind, gt.scrollerKind, TRUE );
END Init;


(************************************************************************)
(*  OberSliderGad Functions                                             *)
(*  =======================                                             *)
(************************************************************************)

PROCEDURE (ob : OberSliderGad) Init * ( Name : ARRAY OF CHAR;
										tags : ObjTags;
										parent : OberObject );
BEGIN
	ob.Init^(Name, tags, parent);
	ob.SetTag( gtGadget, TRUE, TRUE );
	ob.SetTag( gtGadKind, gt.sliderKind, TRUE );
END Init;


(************************************************************************)
(*  OberGroupBox Functions                                              *)
(*  ======================                                              *)
(************************************************************************)

PROCEDURE (ob : OberGroupBox) Init * ( Name : ARRAY OF CHAR;
									   tags : ObjTags;
									   parent : OberObject);
BEGIN
	Errors.Assert(parent IS VirtWindow, "Init : Invalid parent object type");
	ob.Init^(Name, tags, parent);
	(* defaults *)
	ob.SetTag( gt.bbRecessed, TRUE, FALSE );
	ob.SetTag( gt.bbFrameType, gt.bbftRidge, FALSE );
	WHILE ~(parent IS OberWindow) DO
		parent := parent.Parent;
	END;
	ob.parentWin := parent(OberWindow);
	ob.initialized := TRUE;
END Init;

PROCEDURE (ob : OberGroupBox) Show * ;
BEGIN
	IF ob.Parent.IsVisible() & ~ob.Visible THEN
		ob.SetTag(gt.visualInfo, ob.parentWin.vi, TRUE);
		ob.Visible := TRUE;
		ob.ShowVisibleChildren;
	END;
	ob.Visible := TRUE;
END Show;


PROCEDURE (ob : OberGroupBox) Hide * ;
BEGIN
	IF ob.IsVisible() THEN
		ob.HideVisibleChildren;
		ob.RefreshWindow;
	END;
	ob.Visible := FALSE;
END Hide;


PROCEDURE (ob : OberGroupBox) SetDimensions * (x,y,w,h : INTEGER);
BEGIN
	ob.SetTag(obLeft, x, TRUE);
	ob.SetTag(obTop, y, TRUE);
	ob.SetTag(obWidth, w, TRUE);
	ob.SetTag(obHeight, h, TRUE);
	IF ob.IsVisible() THEN
		ob.Hide;
		ob.Show;
		ob.RefreshWindow;
	END;
END SetDimensions;


PROCEDURE (ob : OberGroupBox) SetText * (txt : ARRAY OF CHAR);
BEGIN
	NEW(ob.Title, LEN(txt) + 2);
	IF ob.Title # NIL THEN
		ob.Title[0] := ' ';
		rider := 1;
		WHILE rider < LEN(txt) DO
			ob.Title[rider] := txt[rider - 1];
			INC(rider);
		END;
		ob.Title[rider] := ' ';
		INC(rider);
		ob.Title[rider] := '\0';
		IF ob.IsVisible() THEN
			ob.RefreshWindow;
		END;
	END
END SetText;



(************************************************************************
 =======================================================================
  +++++ Main Program bit (Not much doing here!) +++++++++++++++++++++++
 =======================================================================
*************************************************************************)

BEGIN
	Errors.Init;
	NEW(MainEventLoop);
	NEW(OberonObjectList);
	Events.InitEventLoop(MainEventLoop);
	MainEventLoop.Collect(5); (* Number of signals per GC *)
	Kernel.SetCleanup(Clean);
END OberObjects.


(*  $Log: OberObjects.mod $
 * Revision 1.14  1996/12/23  08:59:22  MattS
 * Finished basic canvas - add children next.
 * Bug fixed window with no gadgets (simply added a generic gadget)
 *
 * Revision 1.13  1996/12/14  21:19:50  MattS
 * Added initial trial at a Canvas type object.
 *
 * Revision 1.12  1996/12/10  22:12:53  MattS
 * Fixed Enforcer Hit! A real step forward...
 *
 * Revision 1.11  1996/12/08  22:40:39  MattS
 * Added more listview functionality
 * added all gadget types
 * changed way gadget types are recognised
 * extended to allow simple implementation of non-gt gadgets
 * Enforcer Hit ! Not yet found why.
 *
 * Revision 1.10  1996/12/02  22:35:24  MattS
 * Added DblClick callback.
 * Added GadgetHelp callback and functionality
 * Changed to allow for other than gt gadgets
 * Added SetPointer
 * Added Window.Activate
 *
 * Revision 1.8  1996/06/04  22:42:54  MattS
 * Bug Fixes
 * Added Gadget.GTSetAttrs()
 * Some Formatting ;)
 *
 * Revision 1.7  1996/06/01  23:41:19  MattS
 * Added title to GroupBoxes
 * Made slightly more efficient in places
 *
 * Revision 1.6  1996/05/31  20:53:59  MattS
 * BIG CHANGES
 * Pushed window refreshing to a separate function
 * Added Group boxes
 * rewrote find functions
 * lots of bug fixes
 *
 * Revision 1.5  1996/05/28  22:14:30  MattS
 * IsVisible to function.
 *
 * Revision 1.4  1996/05/28  21:13:07  MattS
 * Changed ObjectList methods to use bespoke list
 *
 * Revision 1.3  1996/05/28  16:28:08  MattS
 * Updated mx and cy labels to use open arrays
 * Split OberWindow into VirtWindow and OberWindow to enable GroupBoxes
 *
 * Revision 1.2  1996/05/28  10:48:48  MattS
 * Updated tags to use open array.
 * Some bug fixes.
 *
 * Revision 1.1  1996/05/25  18:59:10  MattS
 * Initial revision
 *
*)


