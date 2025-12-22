/*
 * muitest.c was generated with MUIBuilder, except for the part
 * that makes the Textfield gadget, which I just modified from
 * from a list object.
 *
 * V1.1 modifications - a scroll bar has been added that interacts
 * with the textfield object.
 *
 * When using the Textfield gadget in MUI, I suggest you use the
 * frames and labels that it provides instead of the features
 * builtin to the Textfield gadget.  This way, MUI has a better
 * idea how to correctly layout the graphics elements.
 */

#include <libraries/mui.h>
#include <proto/muimaster.h>
#include <clib/exec_protos.h>
#include <exec/memory.h>
#include <intuition/icclass.h>
#include <gadgets/textfield.h>

#include <proto/textfield.h>
#include <proto/iffparse.h>

#ifndef MAKE_ID
#define MAKE_ID(a,b,c,d) ((ULONG) (a)<<24 | (ULONG) (b)<<16 | (ULONG) (c)<<8 | (ULONG) (d))
#endif

#ifdef _DCC
#define __inline
#endif

#define MUIA_Boopsi_Smart 0x8042b8d7 /* V9 i.. BOOL */

static struct ClipboardHandle *clip_handle, *undo_handle;

/*	ExTended KeyButton ( or Eric Totel KeyButton :-) )	*/
/*	to use with localization features 			*/

static APTR __inline ETKeyButton(char *text)
{
        return (KeyButton(&text[3], text[1]));
}

#include "muitest.h"

struct ObjApp * CreateApp( void )
{
	struct ObjApp * Object;

	if (!(Object = AllocVec( sizeof( struct ObjApp ), MEMF_PUBLIC|MEMF_CLEAR )))
		return( NULL );

	clip_handle = OpenClipboard(0);
	undo_handle = OpenClipboard(42);

	Object->App = ApplicationObject,
		MUIA_Application_Author, "Mark Thomas",
		MUIA_Application_Base, "MUITEST",
		MUIA_Application_Title, "MUITest",
		MUIA_Application_Version, "$VER: MUI 1.1 (4.12.94)",
		MUIA_Application_Copyright, "FREE",
		MUIA_Application_Description, "Test textfield.gadget with MUI",
		SubWindow, Object->window = WindowObject,
			MUIA_Window_Title, "Test MUI - BOOPSI",
			MUIA_Window_ID, MAKE_ID( '0','W','I','N' ),
			WindowContents, GroupObject,
				MUIA_Group_Horiz, TRUE,
				Child, Object->text = BoopsiObject,  /* MUI and Boopsi tags mixed */
					InputListFrame,
					MUIA_Boopsi_Class,		TextFieldClass,
					MUIA_Boopsi_Smart,		TRUE,
					MUIA_Boopsi_MinWidth,	40, /* boopsi objects don't know */
					MUIA_Boopsi_MinHeight,	40, /* their sizes, so we help   */
					ICA_TARGET,				ICTARGET_IDCMP, /* needed for notification */
					TEXTFIELD_Text,			(ULONG)"Hello?",
					TEXTFIELD_ClipStream,	clip_handle,
					TEXTFIELD_UndoStream,	undo_handle,
				End,
				Child, Object->sbar = ScrollbarObject, End,
			End,
		End,
	End;

	if (!(Object->App))
	{
		if (undo_handle)
		{
			CloseClipboard(undo_handle);
			undo_handle = NULL;
		}
		if (clip_handle)
		{
			CloseClipboard(clip_handle);
			clip_handle = NULL;
		}
		FreeVec(Object);
		Object = NULL;
	}

	return( Object );
}

void DisposeApp( struct ObjApp * Object )
{
	MUI_DisposeObject(Object->App);
	if (undo_handle)
	{
		CloseClipboard(undo_handle);
		undo_handle = NULL;
	}
	if (clip_handle)
	{
		CloseClipboard(clip_handle);
		clip_handle = NULL;
	}
	FreeVec( Object );
}
