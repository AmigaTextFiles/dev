/*
 *	File:					RecallModules.h
 *	Description:	
 *
 *	(C) 1995, Ketil Hunn
 *
 */

#ifndef RECALLMODULES_H
#define RECALLMODULES_H

/*** DEFINES *************************************************************************/
#define	RECALL_PORT	"RecallIOPort"

/*** Module types *********/
#define	LOADER_TYPE				1L
#define	SAVER_TYPE				2L
#define	OPERATOR_TYPE			3L
#define	DISPLAYER_TYPE		4L

/*** Parse flags **********/
#define	PARSEDIRS					1L

/*** Event types **********/
#define REQUESTER_TYPE		0
#define	YELLOWALERT_TYPE	1
#define REDALERT_TYPE			2
#define CLI_TYPE					3
#define WB_TYPE						4
#define	AREXX_TYPE				5
#define	HOTKEY_TYPE				6

/*** Event attributes *****/
#define	CENTRE						1
#define	GROUP							2
#define	FLASH							4
#define	CONFIRM						8
#define	POSTPONE					16
#define	MULTITASK					32
#define	CATCHUP						64

/*** Event node types *****/
#define	REC_EVENT					0
#define	REC_DIR						1
#define	REC_DIREND				2	// not in use
#define	REC_DATE					3
#define	REC_TEXT					4
#define	REC_QUICK					5

/*** Display types ********/
#define ALWAYS						0
#define DAILY							1
#define STARTUP						2
#define NEVER							3

/*** Date stamps **********/
#define	EXACT							0
#define	BEFORE						1
#define	AFTER							2

/*** No time **************/
#define NONE							-1

/*** Weekdays *************/
#define	SUNDAY						0
#define	MONDAY						1
#define	TUESDAY						2
#define	WEDNESDAY					3
#define	THURSDAY					4
#define	FRIDAY						5
#define	SATURDAY					6

/*** Weekdays masks *******/
#define	FSUNDAY						1
#define	FMONDAY						2
#define	FTUESDAY					4
#define	FWEDNESDAY				8
#define	FTHURSDAY					16
#define	FFRIDAY						32
#define	FSATURDAY					64

/*** GLOBALS *************************************************************************/
struct RecallMsg
{
	struct Message	msg;
	ULONG						version,
									revision,
									moduleType,
									flags,
									error;
	APTR						node;
	struct List			*list;
	UBYTE						*name;

	struct TagItem	*taglist;
};

struct EventNode
{
	struct Node nn_Node;
	UBYTE				type,
							show,
							*screen,
							*dir;
	BYTE				priority;
	ULONG				stack,
							timeout,
							flags;
							
	struct List	*datelist,
							*textlist,
							*children;

	LONG				datestamp;
	BYTE				display;
};

struct DateNode
{
	struct Node nn_Node;

	BYTE	whendate,		// må være BYTE og ikke UBYTE pga NONE=-1
				day,
				month,
				whentime,
				hour,
				minutes,
				weekdays,
				week;
	short	year,
				dateperiod,
				daterepeat,
				timeperiod,
				timerepeat;
};

/*** PROTOTYPES **********************************************************************/
struct RecallMsg *AllocMessage(struct MsgPort *port, ULONG type);
struct RecallMsg *SendMessageA(	struct MsgPort		*port,
																struct RecallMsg	*msg,
																struct TagItem		*taglist);
struct RecallMsg *SendMessage(struct MsgPort		*port,
															struct RecallMsg	*msg,
															Tag								tag1, ...);

/*** TAGS ***************************************************************************/
#define REC_TagBase						(TAG_USER+777)

#define REC_InitMessage			(REC_TagBase+1)		/* Initializes the message					*/
#define REC_GetEventList		(REC_TagBase+2)		/* pointer to the eventlist					*/
#define REC_GetTextList			(REC_TagBase+3)		/* pointer to the textlist					*/
#define REC_GetDateList			(REC_TagBase+4)		/* pointer to the datelist					*/
#define REC_GetEvent				(REC_TagBase+5)		/* pointer to current event					*/
#define REC_GetScreen				(REC_TagBase+6)		/* pointer to Recall's screen				*/
#define REC_GetText					(REC_TagBase+7)		/* pointer to current textline			*/
#define REC_GetDate					(REC_TagBase+8)		/* pointer to current date					*/

#define REC_AddEvent				(REC_TagBase+9)		/* add event to current list				*/
#define REC_AddText					(REC_TagBase+10)	/* add text to current event				*/
#define REC_AddDate					(REC_TagBase+11)	/* add date to current event				*/

#define REC_ClearList				(REC_TagBase+12)	/* clear list												*/
#define REC_PutEventList		(REC_TagBase+13)	/* pointer to new eventlist					*/
#define REC_PutTextList			(REC_TagBase+14)	/* pointer to new textlist					*/
#define REC_PutDateList			(REC_TagBase+15)	/* pointer to new datelist					*/
#define REC_PutRootList			(REC_TagBase+16)	/* pointer to new datelist					*/
#define REC_JumpToEvent			(REC_TagBase+17)	/* jump to and mark new event				*/
#define	REC_SleepWindows		(REC_TagBase+18)	/* puts all Recall windows to sleep	*/

#define REC_UpdateData			(REC_TagBase+19)	/* update windows to show new data	*/
#define REC_GetRootList			(REC_TagBase+20)	/* pointer to the rootlist					*/
#define REC_SetWhenString		(REC_TagBase+21)	/* pointer to the rootlist					*/

#define REC_KeyOK						(REC_TagBase+22)	/* TRUE if the user has registered	*/

#endif
