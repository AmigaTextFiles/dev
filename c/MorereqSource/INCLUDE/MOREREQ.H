/*
 *	File:					MoreReq.h
 *	Description:	More Requesters
 *
 *	(C) 1994,1995 Ketil Hunn
 *
 */

#ifndef LIBRARIES_MOREREQ_H
#define LIBRARIES_MOREREQ_H

#define	MOREREQNAME		 "morereq.library"
#define	MOREREQVERSION 1L

#ifndef	EXEC_TYPES_H
#include <exec/types.h>
#endif

#ifndef	EXEC_LISTS_H
#include <exec/lists.h>
#endif

#ifndef	GRAPHICS_RASTPORT_H
#include <graphics/rastport.h>
#endif

#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif	/* UTILITY_TAGITEM_H */

/* Types of requesters known to MoreReq, used as arguments to mrAllocRequest() */
#define	MR_ListviewRequest	0

/* ********************************************************************************** */

struct MR_VarCHARArray
{
	UBYTE *text[0];
};

struct MR_VarGADGETArray
{
	struct Gadget *gad[0];
};

typedef struct MR_VarCHARArray		varCHAR;
typedef struct MR_VarGADGETArray	varGADGET;

struct ListviewRequester
{
	unsigned long		type,
									numgads;
	UBYTE						*titletext;
	struct Window		*window,
									*pwindow;
	struct Screen		*screen;
	struct TextAttr	*textattr;
	struct TextFont	*font;
	struct Gadget		*glist;
	WORD						LeftEdge,
									TopEdge,
									Width,
									Height,
									percenth,
									percentv;
	short						status;
	BOOL						closegadget,
									sizegadget,
									simplerefresh,
									samegadgetwidth,
									sleepwindow,
									privateidcmp,
									centreh,
									centrev;
	struct MsgPort			*port;
	APTR								mr_UserData;
	void								*visualinfo,
											*func;
	struct Requester		*sleepreq;
	varCHAR							*gadgettexts;
	varGADGET						*gadgets;
	struct RastPort			rp;
	struct BitMap				bm;

/* rest is private for listviewreq */

	BOOL						readonly,
									dropdown;
	struct Gadget		*listview;
	struct List			*list;
	UWORD						count, top, scrollrows;
	struct Node			*selectednode;						/* the only element you should read !!!! */
	LONG						selectednum,
									lastselected,
									seconds,
									micros;
};


#define MR_TagBase							(TAG_USER+1000)

/* GENERAL TAGS */
#define MR_Window								MR_TagBase+1		/* Parent window										*/
#define MR_Screen								MR_TagBase+2		/* Screen to open on if no window		*/
#define MR_PrivateIDCMP					MR_TagBase+3		/* Allocate private IDCMP?					*/
#define MR_UserData							MR_TagBase+4		/* What to put in sm_UserData				*/
#define MR_TextAttr							MR_TagBase+5		/* Text font to use for gadget text	*/
#define MR_TitleText						MR_TagBase+6		/* Title of requester								*/
#define MR_InitialLeftEdge			MR_TagBase+7		/* Initial requester coordinates		*/
#define MR_InitialTopEdge				MR_TagBase+8
#define MR_InitialWidth					MR_TagBase+9
#define MR_InitialHeight				MR_TagBase+10
#define	MR_InitialCentreH				MR_TagBase+11		/* Centre requester horizontally		*/
#define	MR_InitialCentreV				MR_TagBase+12		/* Centre requester vertically			*/
#define	MR_InitialPercentH			MR_TagBase+13		/* Width in percent of screen				*/
#define	MR_InitialPercentV			MR_TagBase+14		/* Height in percent of screen				*/
#define	MR_Gadgets							MR_TagBase+15		/* EZ-way of passing args "%s|%s|.."*/
#define	MR_SameGadgetWidth			MR_TagBase+16		/* All buttons will have same width	*/
#define MR_SizeGadget						MR_TagBase+17		/* Requester will be sizeable				*/
#define MR_CloseGadget					MR_TagBase+18		/* Requester will be have a closega */
#define	MR_SimpleRefresh				MR_TagBase+19		/* All buttons will have same width	*/
#define MR_SleepWindow					MR_TagBase+20		/* Block input in MR_Window?				*/
#define MR_IntuiMsgFunc					MR_TagBase+21		/* Function to handle IntuiMessages	*/


/* LISTVIEWREQUESTER TAGS */
#define	MRLV_Labels							MR_TagBase+200	/* List to display in listview			*/
#define	MRLV_Selected						MR_TagBase+201	/* Item to highlighted							*/
#define	MRLV_ReadOnly						MR_TagBase+202	/* List to display in listview			*/
#define	MRLV_DropDown						MR_TagBase+203	/* Requester as dropdown menu				*/


#endif
