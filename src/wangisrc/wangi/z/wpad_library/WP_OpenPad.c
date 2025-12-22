/***************************************************************************
 * WP_OpenPad.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * WP_OpenPad()
 */

#include "wpad_global.h"
	
/****** wpad.library/WP_OpenPadA ******************************************
*
*   NAME 
*       WP_OpenPadA - Allocate and open a pad.
*
*   SYNOPSIS
*       pad = WP_OpenPadA ( tags );
*       d0                  a0
*
*       struct Pad *WP_OpenPadA ( struct TagItem * );
*
*       pad = WP_OpenPad ( Tag tag1, ... );
*       d0                 a0
*
*       struct Pad *WP_OpenPad( tag1, ... )
*
*   FUNCTION
*
*   INPUTS
*       tags - 
*
*   RESULT
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*       dos.library/CreateNewProc(), intuition.library/OpenWindowTagList(),
*       gadtools.library/CreateGadgetA()
*
*****************************************************************************
*
*/

struct Pad LIBENT *WP_OpenPadA( REG(a0) struct TagItem *tags )
{
	struct Pad *res;
	BOOL success;
	//struct EasyStruct ez = {
	//	sizeof(struct EasyStruct),
	//	0,
	//	"wpad.library",
	//	"0x%06lx = OpenPad( 0x%06lx )",
	//	"Ok"
	//};
	
	res = NULL;
	success = FALSE;
	
	/* Check tags and Allocate a pad */
	if( (FindTagItem(WPOP_Items, tags)) &&
	    (FindTagItem(WPOP_Font, tags)) &&
	    (res = AllocVec(sizeof(struct Pad), MEMF_CLEAR)) )
	{
		struct TagItem *tag;
		
		/* Search and parse process tags */
		
		GETTAG(WPOP_Items, res->pad_Items, NULL, (struct List *), tags, tag);
		
		if( tag = FindTagItem(WPOP_Font, tags) )
		{
			res->pad_TAFont = (struct TextAttr *)tag->ti_Data;
			res->pad_TFont = OpenDiskFont(res->pad_TAFont);
		}
		
		/* We must have the above tags... */
		if( res->pad_Items &&
		    res->pad_TAFont &&
		    res->pad_TFont )
		{
			LONG WPOP_StackSize_D, WPOP_Priority_D;
			STRPTR WPOP_ProcName_D;
			BPTR WPOP_CurrentDir_D;
			struct TagItem *WPOP_CNPTags_D;
			
			GETTAG(WPOP_ProcName, WPOP_ProcName_D, DEF_WPOP_ProcName, (STRPTR), tags, tag);
			GETTAG(WPOP_StackSize, WPOP_StackSize_D, DEF_WPOP_StackSize, (LONG), tags, tag);
			GETTAG(WPOP_Priority, WPOP_Priority_D, DEF_WPOP_Priority, (LONG), tags, tag);
			GETTAG(WPOP_CurrentDir, WPOP_CurrentDir_D, DEF_WPOP_CurrentDir, (BPTR), tags, tag);
			GETTAG(WPOP_LeftEdge, res->pad_OrgLeft, DEF_WPOP_LeftEdge, (LONG), tags, tag);
			GETTAG(WPOP_TopEdge, res->pad_OrgTop, DEF_WPOP_TopEdge, (LONG), tags, tag);
			GETTAG(WPOP_Width, res->pad_OrgWidth, DEF_WPOP_Width, (LONG), tags, tag);
			GETTAG(WPOP_Height, res->pad_OrgHeight, DEF_WPOP_Height, (LONG), tags, tag);
			GETTAG(WPOP_Hook, res->pad_Hook, DEF_WPOP_Hook, (struct Hook *), tags, tag);
			GETTAG(WPOP_Menu, res->pad_Menu, DEF_WPOP_Menu, (struct Menu *), tags, tag);
			GETTAG(WPOP_PubScreenName, res->pad_PSName, DEF_WPOP_PubScreenName, (STRPTR), tags, tag);
			GETTAG(WPOP_ScrollerWidth, res->pad_ScrollW, DEF_WPOP_ScrollerWidth, (LONG), tags, tag);
			GETTAG(WPOP_Flags, res->pad_Flags, DEF_WPOP_Flags, (ULONG), tags, tag);
			GETTAG(WPOP_Title, res->pad_Title, DEF_WPOP_Title, (STRPTR), tags, tag);
			GETTAG(WPOP_ScreenTitle, res->pad_ScrTitle, DEF_WPOP_ScreenTitle, (STRPTR), tags, tag);
			GETTAG(WPOP_Iconify, res->pad_Iconify, DEF_WPOP_Iconify, (LONG), tags, tag);
			GETTAG(WPOP_Broker, res->pad_Broker, DEF_WPOP_Broker, (CxObj *), tags, tag);
			GETTAG(WPOP_HotKey, res->pad_HotKey, DEF_WPOP_HotKey, (STRPTR), tags, tag);
			GETTAG(WPOP_IconifyIcon, res->pad_IconName, DEF_WPOP_IconifyIcon, (STRPTR), tags, tag);
			GETTAG(WPOP_State, res->pad_State, DEF_WPOP_State, (LONG), tags, tag);
			GETTAG(WPOP_CNPTags, WPOP_CNPTags_D, DEF_WPOP_CNPTags, (struct TagItem *), tags, tag);
			GETTAG(WPOP_OWTTags, res->pad_OWTTags, DEF_WPOP_OWTTags, (struct TagItem *), tags, tag);
			GETTAG(WPOP_CGTags, res->pad_CGTags, DEF_WPOP_CGTags, (struct TagItem *), tags, tag);
			GETTAG(WPOP_LMTags, res->pad_LMTags, DEF_WPOP_LMTags, (struct TagItem *), tags, tag);
		
			//GETTAG(WPOP_, res->pad_, DEF_WPOP_, (), tags, tag);
			
			/* Create the pad process/thread */
			if( res->pad_Process = CreateNewProcTags(
			     NP_Entry, WPP_Entry,
			     NP_StackSize, WPOP_StackSize_D,
			     NP_Name, WPOP_ProcName_D,
			     NP_Priority, WPOP_Priority_D,
			     NP_Output, Open("CON:557/11/100/250/wpad Output/AUTO/WAIT", MODE_READWRITE),
			     NP_ExitData, res, /* Hide the pad structure :) */
			     WPOP_CNPTags ? TAG_MORE : TAG_END, WPOP_CNPTags_D) )
			{
				success = TRUE;
			}
		}
	}
	
	if( !success )
	{
		if( res )
		{
			FreeVec(res);
			res = NULL;
		}
	}
	
	//EasyRequest(NULL, &ez, NULL, res, tags);

	return( res );
}
