****************************************************************************
**
** MUIExtend - Magic User Interface Extensions V0.1
**  ©1997 by Robin Cloutman
**
** Main Header File
**
****************************************************************************
** General Header File Information
****************************************************************************
**
** This header file is to be included at the BEGINNING of the source code!
** BUT you MUST include MUIClasses.i at the END!
**
** NOTE: The data included is variable length, see later for details.
**
** This header file has the correct information for MUI V3.8
*/

 IFND	LIBRARIES_MUIEXTEND_I
LIBRARIES_MUIEXTEND_I	SET	1

 IFND	LIBRARIES_MUI_I
	INCLUDE	"libraries/mui.i"
 ENDC	;LIBRARIES_MUI_I

 IFND	EXEC_TYPES_I
	INCLUDE	"exec/types.i"
 ENDC	;EXEC_TYPES_I

 IFND	UTILITY_TAGITEM_I
	INCLUDE	"utility/tagitem.i"
 ENDC	;UTILITY_TAGITEM_I

****************************************************************************
**
** Object Generation
** -----------------
**
** The RealObject structure is what saves so much memory for programs,
** instead of creating the objects using the stack (and using about three
** times as much memory as needed), you define all of your objects
** using the 'Object' MACRO call. You then pass the first object
** to MUIExtend/MUIObjects which will create the entire tree for you.
**
** There is however one limit: All Objects must be given a name
**
** MyApplication:	Object	MUIC_Application,NULL,MyWindow,TAG_END
**	MyWindow:		Object	MUIC_Window,NULL,MyGroup,TAG_END
** MyGroup:			Object	MUIC_Group,NULL,MyButton
** 					TagItem	Tag,TagValue
**						TagEnd
**	MyButton:		Object	MUIC_Text,MyButton2,NULL,Tag,TagValue
** 					TagMore	MyStandardTextTags
** MyButton2:		Object	MUIC_Text,NULL,NULL,Tag,TagValue
**						TagItem	Tag,TagValue,TAG_END
**
**	- This serves two purposes, it allows you to create the entire tree in
** more than one file, and it also allows you to access any of the objects
** as the actual pointer to the created object at the address of each label.
**
** NOTE: Although the class generation may use "Application" etc, you must
** use "MUIC_Application" etc.
** See include file "muimacros.i" for macros for specific classes, frames,
** objects.	(ie. ApplicationObject,ButtonFrame,etc...)
**
****************************************************************************

****************************************************************************
** RealObject
****************************************************************************

* This structure is shown here, but it is PRIVATE! *
 STRUCTURE RealObject,0
	APTR		RO_Object		;Pointer when created (Always here)
	APTR		RO_Next			;Pointer to next RealObject
	APTR		RO_Child			;Pointer to child RealObject
	APTR		RO_Type			;Pointer to RealType
	LABEL		RO_TagList		;TagList for creation

****************************************************************************
**
** Object Macro
**
** This macro is for generating your objects. You need to use a taglist
** directly after it to give the correct creation-time options.
**
** If you place tags on the end of this call then it will place a TagEnd
** on the end (this can save space in your source). If you are not wanting
** to specify *any* tags for the object then place `,TAG_END' at the end
** of the line.
**
****************************************************************************

Object	MACRO		;Type(Label),Next,Child
	dc.l	0,\2,\3,\1
\1_S	SET	1		;Need String
\1_T	SET	1		;Need Taglist
	IFNC	'\4',''
		TagItem	\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
	ENDC
	ENDM

****************************************************************************
**
** Tag Macros
**
** TagItem
** This macro may be used to place TagItems into dc.l statements.
** (It may be simpler to use dc.l statements, but this looks better and
** may do something more usefull in the future.)
**
** TagMore
** As we are dealing with true TagLists we can link them in series.
** This macro is a one-stop macro for this. Don't forget that you
** can save a lot of memory if you place common TagItems behind one
** label and link to that.
**
** TagEnd Macro
** I forget exactly what this does - never mind, it'll come to me.
**
****************************************************************************

TagItem	MACRO		;TAG,Value
	IFC	'\1','TAG_END'
		TagEnd
	ELSE
		IFNC	'\1',''
			dc.l	\1,\2
			TagItem	\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
		ENDC
	ENDC
 ENDM

TagMore	MACRO		;Label to next TagList
	dc.l	TAG_MORE,\1
 ENDM

TagEnd	MACRO
	dc.l	TAG_END
 ENDM

****************************************************************************
**
** Class Definition
** ----------------
**
** Each class consists of its label (for Object macros), its parent object
** (for placing children in the correct classes), its name (for object
** creation), and a list of possible children.
**
** 	MUIClass	LABEL/A,PARENT/A,NAME/A [,CHILD1,CHILDTAG1 [,CHILD2...]]
** ie:
** LABEL/A=Application (refer to it as MUIC_Application)
** PARENT/A=MUIC_Notify
** NAME/A="Application.mui" (remember the quotes)
** CHILD1=MUIC_Window
** CHILDTAG1=MUIA_Application_Window
** No more tags, NOTE: DO NOT specify TAG_END or anything... it's automatic.
**
** If you need to use *private* custom classes then you use:
** NAME=private
** This gives you a class - MUIC_CustomClassName (whatever), and an APTR
** that you store the result from MUI_CreateCustomClass() in.
**
** NOTE: You do NOT need to specify all children as it can check parent-
** objects children, so this can save duplication.
**
****************************************************************************

****************************************************************************
** RealType
****************************************************************************

* This structure shape is shown here, but it is private *
 STRUCTURE RealType,0
	APTR		RT_Class			;Pointer to RT_CustomClass/RT_Name
	APTR		RT_Parent		;Pointer to parent RealType
;REPT
	APTR		RT_Child			;Pointer to child RealType
	ULONG		RT_ChildTag		;Tag for child RealType
;ENDR
;	ULONG		RT_TagEnd
;	IF	CustomClass
;		APTR		RT_CustomClass	;Pointer to struct MUI_CustomClass
;	ELSE
;		CHAR		RT_Name		;Name of Class
;	END

****************************************************************************
**
** MUIClass Macro
**
****************************************************************************

MUIC_Any		EQU	-1	;Use "Any" if a class can have any objects as children.
MUIC_Any_T	SET	1	;For optimisations

MUIClass		MACRO		;Label,Parent,Class,ChildClass,ChildTag...
	IFD	MUIC_\1_T
MUIC_\1	dc.l	\@,\2
\2_T	SET	1			;Need parents Taglist
		IFNC	'\4',''
			ChildClass	\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
		ENDC
		TagEnd
\@
		IFD	MUIC_\1_S
			IFC	'\3','private'
				dc.l	0
\1				dc.l	0
			ELSE
				dc.b	\3,0
				EVEN
			ENDC
		ENDC
	ENDC
 ENDM

ChildClass	MACRO		;Class,Tag
	IFD	\1_T			;Only if that class (TagList) is used.
		dc.l	\1,\2
	ENDC
	IFNC	'\3',''
		ChildClass	\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
	ENDC
 ENDM

** Class definitions are in a seperate file - "muiclasses.i".
** remember to include it at the END of your source.

****************************************************************************
**
** Method Definition
** -----------------
**
** If you want to save even more memory, and have all of your DoMethods
** (for notification etc.) you can use this section.
**
****************************************************************************

****************************************************************************
** MMethod
****************************************************************************

* This is another structure you shouldn't touch, it's only here for info *
 STRUCTURE	MMethod,0
	APTR		MM_Next
	APTR		MM_Object
	ULONG		MM_MethodID
	UWORD		MM_NumTags
	LABEL		MM_TagList
;REPT
	ULONG		MM_Tag				;Tag
	ULONG		MM_TagValue			;TagValue
;ENDR
;	ULONG		MM_TagListFlags	;AFTER TagList, shows immediate/indirect.

****************************************************************************
**
** Method & LastMethod MACROs
**
** These are for the lazy programmer who wants to put his RealMethods next
** to his RealObjects, as they are both data, it is quite simple to
** interleave them.
** Note: Always remember to use LastMethod if you want to break up your
** methods into different lists.
**
** (Last)Method OBJECT/A,METHOD/A,TYPE,ATTRIBUTE [,TYPE,ATTRIBUTE[,...]]
** OBJECT/A=struct RealObject *
** METHOD/A=MUIM_...
** TYPE="Imm"-Immediate/"Ind"-Indirect/"Late"-Label for programmer
**	ATTRIBUTE=ULONG/APTR/Label
**
** NOTE: First Method has Label "Method_1"
**
****************************************************************************

	IFND	METHOD_NUM	;Have to have this somewhere
METHOD_NUM	SET	1
	ENDC

Method	MACRO
METHOD_NUM2	SET	METHOD_NUM
METHOD_NUM	SET	METHOD_NUM+1
Method_\<METHOD_NUM2>:	dc.l	Method_\<METHOD_NUM>,\1,\2
METHOD_TAGS		SET	1<<(((\#-2)/2)-1)
	dc.w	((\#-2)/2)
METHOD_FLAGS	SET	0
	MethodFlags	\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
	dc.l	METHOD_FLAGS
 ENDM

LastMethod	MACRO
METHOD_NUM2	SET	METHOD_NUM
METHOD_NUM	SET	METHOD_NUM+1
Method_\<METHOD_NUM2>:	dc.l	NULL,\1,\2
METHOD_TAGS		SET	1<<(((\#-2)/2)-1)
	dc.w	((\#-2)/2)
METHOD_FLAGS	SET	0
	MethodFlags	\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
	dc.l	METHOD_FLAGS
 ENDM

;-- private --
MethodFlags	MACRO
METHOD_FLAGS	SET	METHOD_FLAGS>>1
	IFC	'\1','Ind'		;The data is a pointer to the data
METHOD_FLAGS	SET	METHOD_FLAGS!METHOD_TAGS
	ENDC
	IFC	'\1','Late'		;The Data is to be filled in by the programmer...
\2		dc.l	0				;...so give him a label to use
	ELSEIF
		dc.l	\2
	ENDC
	IFNC	'\3',''
		MethodFlags	\3,\4,\5,\6,\7,\8,\9,\A,\B,\C,\D,\E,\F,\G,\H,\I,\J,\K,\L,\M,\N,\O,\P,\Q,\R,\S,\T,\U,\V,\W,\X,\Y,\Z
	ENDC
 ENDM

 ENDC	;LIBRARIES_MUIEXTEND_I
