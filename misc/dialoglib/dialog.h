#ifndef DIALOG_H
#define DIALOG_H

#include <exec/types.h>
#include <utility/hooks.h>
#include <utility/tagitem.h>
#include <limits.h>

/*** implementation specific constants ***/
#define MAX_SPACE SHRT_MAX

/*************** data types **************/

struct __DialogElement
{
	struct Hook hook;
	struct TagItem *taglist;
	APTR object;		/* zero this after disposing the object! (DIALOGM_CLEAR) */
	ULONG structure;	/* dispatchers may utilize this field in any way they see fit! */
	ULONG idcmp_mask;
	LONG minWidth, minHeight, minLeftExtent, minRightExtent, minTopExtent, minBottomExtent;
	LONG maxWidth, maxHeight, maxLeftExtent, maxRightExtent, maxTopExtent, maxBottomExtent;
	struct __DialogElement *root;
};
typedef struct __DialogElement DialogElement;

struct __DialogMessage
{
	ULONG dm_MethodID;
#define DIALOGM_SETUP			1
#define DIALOGM_LAYOUT			2
#define DIALOGM_CLEAR			3
#define DIALOGM_MATCH			4
#define DIALOGM_SETATTRS		5
#define DIALOGM_GETSTRUCT		100
#define DIALOGM_GETSPACE		101
};
typedef struct __DialogMessage DialogMessage;

struct __LayoutMessage
{
	ULONG lm_MethodID;
	LONG lm_X, lm_Y, lm_Width, lm_Height, lm_Left, lm_Right, lm_Top, lm_Bottom;
	APTR *lm_PreviousPtr;
};
typedef struct __LayoutMessage LayoutMessage;

/*** dialog element structure flags (as reported by DIALOGM_GETSTRUCT) ***/
#define DESB_HBaseline	0
#define DESF_HBaseline	(1<<DESB_HBaseline)
#define DESB_VBaseline	1
#define DESF_VBaseline	(1<<DESB_VBaseline)

struct __MatchMessage
{
	ULONG mm_MethodID;
	struct IntuiMessage *mm_IntuiMsg;
};
typedef struct __MatchMessage MatchMessage;

struct __SetAttrsMessage
{
	ULONG sam_MethodID;
	struct Window *sam_Window;
	struct Requester *sam_Requester;
};
typedef struct __SetAttrsMessage SetAttrsMessage;

typedef ULONG (*DialogCallback)( struct Hook *, DialogElement *, DialogMessage * );

/************** tags **************/

/*
 *	The tag base may be redefined externally if this one happens
 *	to conflict with another one.
 *	Of course you will have to re-compile the library then.
 */
#ifndef DA_TagBase
	#define DA_TagBase		(TAG_USER + 0x2000)
#endif
#define NGDA_TextAttr			(DA_TagBase + 0x00)
#define NGDA_VisualInfo			(DA_TagBase + 0x01)
#define NGDA_GadgetText			(DA_TagBase + 0x02)
#define NGDA_Flags				(DA_TagBase + 0x03)
#define NGDA_Width				(DA_TagBase + 0x04)
#define NGDA_Height				(DA_TagBase + 0x05)
#define DA_Screen				(DA_TagBase + 0x10)
#define DA_Title				(DA_TagBase + 0x11)
#define DA_Member				(DA_TagBase + 0x12)
#define DA_XSpacing				(DA_TagBase + 0x13)
#define DA_YSpacing				(DA_TagBase + 0x14)
#define DA_Alignment			(DA_TagBase + 0x15)
#define DA_Storage				(DA_TagBase + 0x16)
#define DA_Termination			(DA_TagBase + 0x17)
#define DA_EquivalentKey		(DA_TagBase + 0x18)
#define DA_MatchEventClasses	(DA_TagBase + 0x19)
#define DA_MatchEventCode		(DA_TagBase + 0x1a)
#define DA_MatchEventQualifier	(DA_TagBase + 0x1b)
#define DA_CAR					(DA_TagBase + 0x1c)
#define DA_CDR					(DA_TagBase + 0x1d)
#define DA_HelpHook				(DA_TagBase + 0x1e)

/************** error codes *************/
#define DIALOGERR_NO_ERROR	0
#define DIALOGERR_OK		DIALOGERR_NO_ERROR
#define DIALOGERR_NO_MEMORY	1	/* some object could no be allocated */
#define DIALOGERR_BAD_ARGS	2	/* bad arguments supplied */

/************** prototypes **************/

/*** for dialog element implementors ***/
VOID setMinWidth( DialogElement *, LONG );
VOID setMinHeight( DialogElement *, LONG );
VOID setMinLeftExtent( DialogElement *, LONG );
VOID setMinRightExtent( DialogElement *, LONG );
VOID setMinTopExtent( DialogElement *, LONG );
VOID setMinBottomExtent( DialogElement *, LONG );
VOID setMaxWidth( DialogElement *, LONG );
VOID setMaxHeight( DialogElement *, LONG );
VOID setMaxLeftExtent( DialogElement *, LONG );
VOID setMaxRightExtent( DialogElement *, LONG );
VOID setMaxTopExtent( DialogElement *, LONG );
VOID setMaxBottomExtent( DialogElement *, LONG );
LONG getMinWidth( DialogElement * );
LONG getMinHeight( DialogElement * );
LONG getMinLeftExtent( DialogElement * );
LONG getMinRightExtent( DialogElement * );
LONG getMinTopExtent( DialogElement * );
LONG getMinBottomExtent( DialogElement * );
LONG getMaxWidth( DialogElement * );
LONG getMaxHeight( DialogElement * );
LONG getMaxLeftExtent( DialogElement * );
LONG getMaxRightExtent( DialogElement * );
LONG getMaxTopExtent( DialogElement * );
LONG getMaxBottomExtent( DialogElement * );
VOID prepareLayoutX( LayoutMessage *, LONG );
VOID prepareLayoutY( LayoutMessage *, LONG );
VOID prepareLayoutNoVBaseline( LayoutMessage *, LONG );
VOID prepareLayoutVBaseline( LayoutMessage *, LONG, LONG );
VOID prepareLayoutNoHBaseline( LayoutMessage *, LONG );
VOID prepareLayoutHBaseline( LayoutMessage *, LONG, LONG );
ULONG prepareMemberLayoutH( LayoutMessage *,
	DialogElement *, DialogElement *, LayoutMessage * );
ULONG prepareMemberLayoutV( LayoutMessage *,
	DialogElement *, DialogElement *, LayoutMessage * );

/*** support functions for gadtools-based elements ***/
VOID setGTAttrs( DialogElement *, SetAttrsMessage * );
ULONG getTextPlacement( ULONG, ULONG );
VOID setupGT( DialogElement *, ULONG );
VOID layoutGTSingleLined( struct NewGadget *, LayoutMessage *, ULONG );

/*** for clients (and implementors) ***/
VOID initDialogElement( DialogElement *, DialogElement *, DialogCallback, ULONG *,
	ULONG , ... );
VOID initDialogElementA( DialogElement *, DialogElement *, DialogCallback, ULONG *,
	struct TagItem * );
VOID cleanupDialogElement( DialogElement * );
VOID setupDialogElement( DialogElement * );
ULONG getDialogElementStructure( DialogElement * );
ULONG layoutDialogElement( DialogElement *, LayoutMessage *, APTR );
DialogElement *mapDialogEvent( DialogElement *, struct IntuiMessage * );
ULONG setDialogElementAttrsA( DialogElement *,
	struct Window *, struct Requester *, struct TagItem * );
ULONG setDialogElementAttrs( DialogElement *,
	struct Window *, struct Requester *, ULONG, ... );
VOID clearDialogElement( DialogElement * );

ULONG dispatchRoot( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchHStack( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchVStack( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchHCons( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchVCons( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchHBumper( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchVBumper( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchHSpring( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchVSpring( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchButton( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchCheckBox( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchString( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchInteger( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchListView( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchMX( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchCycle( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchText( struct Hook *, DialogElement *, DialogMessage * );
ULONG dispatchNumber( struct Hook *, DialogElement *, DialogMessage * );

ULONG openDialogWindow( DialogElement *, ULONG, ... );
ULONG openDialogWindowA( DialogElement *, struct TagItem * );
VOID closeDialogWindow( DialogElement * );
struct Window *getDialogWindow( DialogElement * );
DialogElement *runSimpleDialog( DialogElement *, ULONG, ... );
DialogElement *runSimpleDialogA( DialogElement *, struct TagItem * );

#endif
