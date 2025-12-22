// MPGui - requester library
// Copyright (C) © 1995 Mark John Paddock

// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; either version 2 of the License, or
// any later version.

// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.

// mark@topic.demon.co.uk
// mpaddock@cix.compulink.co.uk

/****** MPGui.library/--background-- ****************************************
*
* MPGui provides an easy way to display simple single colum requesters with
* File/String/Number/Slider/Cycle/Check/ScreenMode/List gadgets.
*
* It uses a text input file to specify the format of the Gui.
*
* Menus can be provided.
*
* Bottom gadgets can be "Ok/Cancel" for normal gadgets or "Save/Use/Cancel"
* for preferences requesters.
* From Version 5.2 the short cuts for these buttons will automatically be
* disabled if required. The library is also localised.
*
* From Version 5.4 opens locale.library(38) to work on OS3.0.
*
* Normal Help and continuous Help is supported.
*
* Keyboard shortcuts are supported.
*
* The format of the file is:
*
* * comment
*                  Comment line
*
* Any #n# (n>=0) will be replaced by parameters if supplied
* ## is changed to # if parameters are supplied
* 
* Some standard C conversions are done with \ values
*  \\ -> \
*  \" -> "
*  \t -> tab
*  \n -> newline
*
* "command "HelpMessage
*        etc.      Command (etc. is ignored)
*  "Comment"       Comment for heading of requester
*  "HelpNode"      Global Help Node for requester
*  GADGET "Title":"prefix"!HelpNode!HelpMessage!
*                         A Gadget
*                         GAGDET is type of gadget (see below).
*                         "Title" is gadget title
*                         "prefix" appears before the value in the result
*                                  if prefix includes %s then result
*                                  replaces %s instead
*                         !HelpNode! is optional help string to
*                                    use in call back
*                         !HelpMessage is displayed in text gadget at top
*
*  LFILE "Title":"prefix":"def"!Help!
*                  Input file string and request gadget
*                  Key activates
*                  Right shift and key shows requester
*  SFILE "Title":"prefix":"def"!Help!
*                  Output file string and gadget
*                  Key activates
*                  Right shift and key shows requester
*  FILE "T":"P":"def"!Help!
*                  File string and request (input file)
*                  Key activates
*                  Right shift and key shows requester
*  OFILE "T":"P":"def":Y/N!Help!
*                  Optional file (has checkbox)
*                  Key toggles and activates if becomes selectable
*                  Left shift and key activates if selectable
*                  Right shift and key shows requester if selectable
*  ONUMBER "T":"P":"def":Y/N!Help!
*                  Optional number (has checkbox)
*                  Key toggles and activates if becomes selectable
*                  Left shift and key activates if selectable
*  NUMBER "T":"P":"def"!Help!
*                  Number
*                  Key activates
*  CYCLE "Title"!Help!
*                  Cycle gadget, each entry can be followed by other gadgets
*                  Key cycles
*                  Shift and key cycles back
*        "value1":"Prefix1"
*        "value2":"Prefix2"
*     gadgets      
*                  Only active when item is 2
*        "value3":"Prefix3"
*  ENDCYCLE:"number or valuen" 
*                  Finished by default value (numeric or string)
*  STRING "Title":"prefix":"def"!Help!
*                  String - use for floating point as well
*                  Key activates
*  OSTRING "Title":"prefix":"def":Y/N!Hlp!
*                  String with checkbox
*                  Key toggles and activates if becomes selectable
*                  Left shift and key activates if selectable
*  CHECK "T":"P":"NPrefix":Y/N!Help
*                  Check box gadget
*                  NPrefix (optional) used if Check not selected
*                  Key toggles
*  SLIDER "T":"P":"min":"max":"def"!Hlp!
*                  Slider gadget
*                  Key increases
*                  Shift and key decreases
*  MODEn "T":"P":"def"!Help!
*                  Screen Mode requester
*                  Key shows requester
*                  n == 1 -> Workbench modes
*                       2 -> Workbench modes + NONE
*                       3 -> All modes
*                       4 -> All modes + NONE (3 and 4 do not work too well)
*  OMODEn "T":"P":"def":Y/N!Help!
*                  Optional Screen Mode requester
*                  Key toggles
*                  Right shift and key shows requester if selectable
*  FONTn "T":"P":"def"!Help!
*                  Font requester
*                  Key shows requester
*                  n == 1 -> All Fonts
*                       2 -> Fixed width only
*  OFONTn "T":"P":"def":Y/N!Help!
*                  Optional Font requester
*                  Key toggles
*                  Right shift and key shows requester if selectable
*  LIST "Title":!Help!
*                  List view
*                  Key cycles
*                  Shift and key cycles back
*       "value1":"prefix1"
*       "value2":"prefix2"
*  ENDLIST:"number or valuen":"lines"
*                  finished by default value and lines (optional) default 4
*  MLIST "Title":!Help!
*                  List view
*                  Key cycles
*                  Left shift and key cycles back
*                  Right shift and key toggles selected
*       "value1":"prefix1":"NPrefix1" (Negative Prefix optional)
*       "value2":"prefix2"
*  ENDMLIST:"values":"lines"
*                  finished by default selected values (space seperated)
*                  and lines (optional) default 4
*  BUTTON "Title"  List of button gadgets - horizontal
*                  If Title zero length then full width is used
*       "Button text1":"n"!Help!HelpMessage!  n is number of button
*       "Button text2":"m"!Help!HelpMessage!
*  ENDBUTTON
*  TEXT "Title":"def"Y/N!Help!HelpMessage!    (added in 5.1)
*                  Text - If title 0 length then full width
*                  Y to Center Text
*  MTEXT "def"Y/N!Help!HelpMessage!    (added in 5.1)
*                  Text without border
*                  Y to Center Text
*
*****************************************************************************
*
*/

#include <dos.h>

#define USE_BUILTIN_MATH
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include <stddef.h>
#include <stdarg.h>
#include <ctype.h>

#define INTUI_V36_NAMES_ONLY
#define INTUITION_IOBSOLETE_H
#define ASL_V38_NAMES_ONLY
#include <graphics/gfxbase.h>
#include <proto/exec.h>
#include <proto/gadtools.h>
#include <proto/intuition.h>
#include <proto/graphics.h>
#include <proto/asl.h>
#include <proto/dos.h>
#include <proto/utility.h>
#include <proto/locale.h>

#include <intuition/gadgetclass.h>
#include <dos/dostags.h>
#include <exec/memory.h>

extern long __oslibversion=39;

extern struct Catalog *Catalog=NULL;

#define CATCOMP_BLOCK
#define CATCOMP_NUMBERS
#include "messages.h"

#include "MPGui.h"
#include "libraries/MPGui.h"

const char Version[]="$VER: MPGui.library 5.5 (4.3.97)";

struct MPGuiHandle * __asm __saveds AllocMPGuiHandleA(register __a0 struct TagItem * TagList);
void __asm __saveds FreeMPGuiHandle(register __a0 struct MPGuiHandle * );
char * __asm __saveds MPGuiError(register __a0 struct MPGuiHandle * );
char * __asm __saveds SyncMPGuiRequest(register __a0 char * , register __a1 struct MPGuiHandle * );
__saveds __asm ULONG MPGuiResponse(register __a0 struct MPGuiHandle *gh);
__saveds __asm BOOL SetMPGuiGadgetValue(register __a0 struct MPGuiHandle *gh,
							register __a1 char *Title, register __a2 char *Value);
__saveds __asm char *MPGuiCurrentAttrs(register __a0 struct MPGuiHandle *gh);
void __saveds __asm RefreshMPGui(register __a0 struct MPGuiHandle *gh);
struct Window * __saveds __asm MPGuiWindow(register __a0 struct MPGuiHandle *gh);

/* Internal prototypes */
int sprintf(unsigned char * ,const unsigned char * , ...);
unsigned char * mystrdup(struct MPGuiHandle * , unsigned char * );
void Command(struct MPGuiHandle * );
void pError(struct MPGuiHandle * , unsigned char const * , unsigned char * );
unsigned char * myfgets(struct MPGuiHandle * );
void ProcessGadget(struct MPGuiHandle * );
void ProcessButton(struct MPGuiHandle * );
void ProcessCycle(struct MPGuiHandle * );
void ProcessList(struct MPGuiHandle * );
void ProcessMList(struct MPGuiHandle * );
void GetTitle(BOOL SetLeft,struct MPGuiHandle * );
void GetParameter(struct MPGuiHandle * );
void GetNParameter(struct MPGuiHandle * );
void GetStringDefault(struct MPGuiHandle * );
void GetNumberDefault(struct MPGuiHandle * );
void GetCheckDefault(struct MPGuiHandle * );
void GetDefCycle(struct MPGuiHandle * );
void GetDefList(struct MPGuiHandle * );
void GetDefMList(struct MPGuiHandle * );
void GetDefLines(struct MPGuiHandle * );
void GetCycleTitle(struct MPGuiHandle * );
void GetCycleParameter(struct MPGuiHandle * );
void GetListTitle(struct MPGuiHandle * );
void GetListParameter(struct MPGuiHandle * );
void GetListNParameter(struct MPGuiHandle * );
unsigned char * SkipSpace(unsigned char * );
void RequesterStuff(struct MPGuiHandle *);
BOOL CreateGadgets(struct MPGuiHandle *);
static void checkleft(struct MPGuiHandle *gh, int addheight, short *curgh, int *tleft);
BOOL GetAFile(struct MPGuiHandle * , UBYTE const * , unsigned char const * , ULONG ,char *);
BOOL GetAMode(struct MPGuiHandle *, struct MyGadget * , UBYTE const * , unsigned char const *);
BOOL GetAFont(struct MPGuiHandle *, struct MyGadget * , UBYTE const * , unsigned char const *);
void GetHelp(struct MPGuiHandle * );
void DisableWindow(struct MPGuiHandle *gh);
void EnableWindow(struct MPGuiHandle *gh);
ULONG MyCallHookPkt(struct MPGuiHandle *gh,struct Hook *,APTR,APTR);
ULONG __asm MyRefresh(register __a0 struct Hook *hook,
								  register __a2 struct FileRequester *fr,
								  register __a1 struct IntuiMessage *msg);


/****** MPGui.library/AllocMPGuiHandleA *************************************
*
*   NAME   
*  AllocMPGuiHandleA -- Allocates an MPGuiHandle. (V3)
*  AllocMPGuiHandle -- Varargs version of AllocMPGuiHandleA (V3)
*
*   SYNOPSIS
*  gh = AllocMPGuiHandleA(taglist)
*  D0                     A0
*
*  struct MPGuiHandle * AllocMPGuiHandleA(struct TagItem *);
*
*  gh = AllocMPGuiHandle(Tag1, ...)
*
*  struct MPGuiHandle * AllocMPGuiHandle(ULONG,...);
*
*   FUNCTION
*  Allocates an MPGuiHandle.
*
*   INPUTS
*  taglist - pointer to TagItem array.
*
*  Tags are:
*
*  MPG_PUBSCREENNAME - Data is char * name of public screen to use.
*                      Default is default public screen.
*  MPG_RELMOUSE      - Data is BOOL. TURE to open requester near pointer.
*                      Default is FALSE.
*  MPG_HELP          - Data is struct Hook *, called with object=char * to
*                      help node to be displayed.
*  MPG_CHELP         - Call help when gadget changes
*  MPG_PARAMS        - Data is char ** array of parameters
*  MPG_NEWLINE       - Data is BOOL. TRUE means new line rather than space
*                      in output, no "s round files or screen modes.
*                      Default is FALSE.
*  MPG_PREFS         - Data is BOOL. Default FALSE. TRUE provides
*                      _Save/_Use/_Cancel gadgets, Use MPGuiResponse() to
*                      get response (1=Save 2=Use), Esc key will not exit.
*  MPG_MENUS         - Data is struct NewMenu *.
*  MPG_MENUHOOK      - Data is struct Hook *, called with
*                      object=struct IntuiMsg *, message = struct Menu *
*                      If MPG_HELP is set then called for MENUHELP as well.
*                      Return 0 to quit, non 0 to continue.
*  MPG_SIGNALS       - Data is ULONG signals to wait for then call hook
*                      provided in MPG_SIGNALHOOK.
*  MPG_SIGNALHOOK    - Data is struct Hook *, called with
*                      object = ULONG signals received,
*                      message = ULONG notused
*                      Return 0 to quit, non 0 to continue.
*  MPG_CHECKMARK     - Data is struct Image * for menu checkmark
*  MPG_AMIGAKEY      - Data is struct Image * for menu AmigaKey
*  MPG_BUTTONHOOK		- Data is struct Hook *,
*                      called with object=struct MPGuiHandle *,
*                      message = number of button
*                      Return 0 to quit, non 0 to continue.
*  MPG_NOBUTTONS     - If set then no buttons are shown, overrides MPG_PREFS.
*
*   RESULT
*  gh - Allocated MPGuiHandle.
*       NULL on error (no memory).
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*  The allocated handle has a max size of about 3K for the response.
*  The maximum parameter replaced line length is about 2K.
*  FONT? gadgets ignore the size at the moment.
*  If there are more than 3 BUTTON gadgets in a row then they are left
*  justified - should be fully justified.
*  Button layout may not yet be correct.
*
*   SEE ALSO
*  FreeMPGuiHandle(),MPGuiResponse().
*
*****************************************************************************
*
*/
// Allocate a handle
struct MPGuiHandle *__saveds __asm
AllocMPGuiHandleA(register __a0 struct TagItem *TagList) {
	struct MPGuiHandle *gh;

	if (gh = (struct MPGuiHandle *)AllocMem(sizeof(struct MPGuiHandle),MEMF_ANY | MEMF_CLEAR)) {
		gh->TagList = CloneTagItems(TagList);
		if (gh->MemPool = CreatePool(MEMF_CLEAR | MEMF_ANY,2048,1024)) {
			if (gh->filereq = AllocFileRequest()) {
				gh->RefreshHook.h_Entry = (HOOKFUNC)MyRefresh;
				gh->RefreshHook.h_Data = gh;
				return gh;
			}
			DeletePool(gh->MemPool);
		}
		FreeMem(gh,sizeof(struct MPGuiHandle));
	}
	return NULL;
}

/****** MPGui.library/FreeMPGuiHandle ****************************************
*
*   NAME   
*  FreeMPGuiHandle -- Frees a Handle allocated by AllocMPGuiHandleA(). (V3)
*
*   SYNOPSIS
*  FreeMPGuiHandle( gh)
*                   A0
*
*  void FreeMPGuiHandle( struct MPGuiHandle *);
*
*
*   FUNCTION
*  Frees a Handle allocated by AllocMPGuiHandleA().
*
*   INPUTS
*  gh - Handle allocated by AllocMPGuiHandleA.
*
*   RESULT
*  None.
*
*   EXAMPLE
*
*   NOTES
*
*   BUGS
*
*   SEE ALSO
*  AllocMPGuiHandleA().
*
*****************************************************************************
*
*/
// Free a handle
__saveds __asm void
FreeMPGuiHandle(register __a0 struct MPGuiHandle *gh) {
	if (gh) {
		if (gh->TagList) {
			FreeTagItems(gh->TagList);
		}
		if (gh->filereq) {
			FreeAslRequest(gh->filereq);
		}
		if (gh->MemPool) {
			DeletePool(gh->MemPool);
		}
		FreeMem(gh,sizeof(struct MPGuiHandle));
	}
}
	
/****** MPGui.library/MPGuiError *********************************************
*
*   NAME   
*  MPGuiError -- Returns the error message for an MPGuiHandle. (V3)
*
*   SYNOPSIS
*  Message = MPGuiError(gh )
*  D0                   A0
*
*  char * MPGuiError( struct MPGuiHandle *);
*
*   FUNCTION
*  Returns the error message for an MPGuiHandle.
*
*   INPUTS
*  gh - MPGuiHandle allocated by AllocMPGuiHandleA().
*
*   RESULT
*  Message - The text of an error message. May be multi line.
*
*   EXAMPLE
*
*   NOTES
*  Use after SyncMPGuiRequest() returns -1.
*
*   BUGS
*
*   SEE ALSO
*  SyncMPGuiRequest().
*
******************************************************************************
*
*/
__saveds __asm char *
MPGuiError(register __a0 struct MPGuiHandle *gh) {
	return gh->error;
}

/****** MPGui.library/MPGuiResponse ******************************************
*
*   NAME   
*  MPGuiResponse -- returns the response from a Prefs MPGui. (V3)
*
*   SYNOPSIS
*  resp = MPGuiResponse( gh)
*  D0                   A0
*
*  ULONG MPGuiResponse( struct MPGuiHandle *);
*
*   FUNCTION
*  Returns the response after calling SyncMPGuiRequest() with MPG_PREFS.
*
*   INPUTS
*  gh - An MPGuiHandle.
*
*   RESULT
*  resp - MPG_SAVE Save gadget was pressed.
*         MPG_USE  Use gadget was pressed.
*
*   EXAMPLE
*
*   NOTES
*  Only use if SyncMPGui() returns not (0 or -1).
*
*   BUGS
*
*   SEE ALSO
*  AllocMPGuiHandleA(),SyncMPGuiRequest().
*
*****************************************************************************
*
*/
__saveds __asm ULONG
MPGuiResponse(register __a0 struct MPGuiHandle *gh) {
	return gh->Response;
}

/****** MPGui.library/MPGuiCurrentAttrs *************************************
*
*   NAME   
*  MPGuiCurrentAttrs -- Returns the Current MPGui attributes. (V3)
*
*   SYNOPSIS
*  Attrs = MPGuiCurrentAttrs( gh)
*  D0                          A0
*
*  char * MPGuiCurrentAttrs( struct MPGuiHandle *);
*
*   FUNCTION
*  Returns the same as would be returned by SyncMPGuiRequest if the OK gadget
*  is pressed now.
*
*   INPUTS
*  gh - An MPGuiHandle currently being used by SyncMPGuiRequest().
*
*   RESULT
*  Attrs - String that would be returned SyncMPGuiRequest.
*
*   EXAMPLE
*
*   NOTES
*  This should be called from a MPG_MENUHOOK supplied to AllocMPGuiHandle().
*  e.g. If a Save As... menu item is called.
*
*   BUGS
*
*   SEE ALSO
*  SyncMPGuiRequest().
*
*****************************************************************************
*
*/
__saveds __asm char *
MPGuiCurrentAttrs(register __a0 struct MPGuiHandle *gh) {
	struct MyGadget *LoopGadget;
	int count;
	struct MyValue *MyValue;
	char *p = NULL;
	ULONG l = 0;
	char buffer[32];

	sprintf(gh->result,"%s",gh->Command);
	if (gh->NewLine) {
		strcat(gh->result,"\n");
	}
	for (LoopGadget = (struct MyGadget *)(gh->GList.lh_Head);
			LoopGadget->GNode.ln_Succ;
			LoopGadget = (struct MyGadget *)(LoopGadget->GNode.ln_Succ)) {
		if (!LoopGadget->OwnCycle || (LoopGadget->OwnCycle->Currenty == LoopGadget->Activey)) {
			switch (LoopGadget->Type) {
			case GAD_FILE:
			case GAD_LFILE:
			case GAD_SFILE:
				GT_GetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
									GTST_String,&p,
									TAG_END);
				if (strstr(LoopGadget->Prefix,"%s")) {
					sprintf(gh->tBuffer,LoopGadget->Prefix,p);
				}
				else {
					if (gh->NewLine) {
						sprintf(gh->tBuffer,"%s%s",LoopGadget->Prefix,p);
					}
					else {
						sprintf(gh->tBuffer,"%s\"%s\"",LoopGadget->Prefix,p);
					}
				}
				strcat(gh->result,gh->tBuffer);
				break;
			case GAD_MODE:
			case GAD_FONT:
				GT_GetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
									GTTX_Text,&p,
									TAG_END);
				if (strstr(LoopGadget->Prefix,"%s")) {
					sprintf(gh->tBuffer,LoopGadget->Prefix,p);
				}
				else {
					if (gh->NewLine) {
						sprintf(gh->tBuffer,"%s%s",LoopGadget->Prefix,p);
					}
					else {
						sprintf(gh->tBuffer,"%s\"%s\"",LoopGadget->Prefix,p);
					}
				}
				strcat(gh->result,gh->tBuffer);
				break;
			case GAD_OMODE:
			case GAD_OFONT:
				if (LoopGadget->Currentc) {
					GT_GetGadgetAttrs(LoopGadget->Gadget2,gh->Window,NULL,
										GTTX_Text,&p,
										TAG_END);
					if (strstr(LoopGadget->Prefix,"%s")) {
						sprintf(gh->tBuffer,LoopGadget->Prefix,p);
					}
					else {
						if (gh->NewLine) {
							sprintf(gh->tBuffer,"%s%s",LoopGadget->Prefix,p);
						}
						else {
							sprintf(gh->tBuffer,"%s\"%s\"",LoopGadget->Prefix,p);
						}
					}
					strcat(gh->result,gh->tBuffer);
				}
				break;
			case GAD_OFILE:
				if (LoopGadget->Currentc) {
					GT_GetGadgetAttrs(LoopGadget->Gadget2,gh->Window,NULL,
										GTST_String,&p,
										TAG_END);
					if (strstr(LoopGadget->Prefix,"%s")) {
						sprintf(gh->tBuffer,LoopGadget->Prefix,p);
					}
					else {
						if (gh->NewLine) {
							sprintf(gh->tBuffer,"%s%s",LoopGadget->Prefix,p);
						}
						else {
							sprintf(gh->tBuffer,"%s\"%s\"",LoopGadget->Prefix,p);
						}
					}
					strcat(gh->result,gh->tBuffer);
				}
				break;
			case GAD_ONUMBER:
				if (LoopGadget->Currentc) {
					GT_GetGadgetAttrs(LoopGadget->Gadget2,gh->Window,NULL,
									GTIN_Number,&l,
									TAG_END);
					if (strstr(LoopGadget->Prefix,"%s")) {
						sprintf(buffer,"%ld",l);
						sprintf(gh->tBuffer,LoopGadget->Prefix,buffer);
					}
					else {
						sprintf(gh->tBuffer,"%s%ld",LoopGadget->Prefix,l);
					}
					strcat(gh->result,gh->tBuffer);
				}
				break;
			case GAD_NUMBER:
				GT_GetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
								GTIN_Number,&l,
								TAG_END);
				if (strstr(LoopGadget->Prefix,"%s")) {
					sprintf(buffer,"%ld",l);
					sprintf(gh->tBuffer,LoopGadget->Prefix,buffer);
				}
				else {
					sprintf(gh->tBuffer,"%s%ld",LoopGadget->Prefix,l);
				}
				strcat(gh->result,gh->tBuffer);
				break;
			case GAD_CYCLE:
			case GAD_LIST:
				count = 0;
				for (MyValue = (struct MyValue *)(LoopGadget->VList.lh_Head);
						MyValue->VNode.ln_Succ;
						MyValue = (struct MyValue *)(MyValue->VNode.ln_Succ)){
					if (count == LoopGadget->Currenty) {
						strcat(gh->result,MyValue->Prefix);
					}
					++count;
				}
				break;
			case GAD_MLIST:
				for (MyValue = (struct MyValue *)(LoopGadget->VList.lh_Head);
						MyValue->VNode.ln_Succ;
						MyValue = (struct MyValue *)(MyValue->VNode.ln_Succ)){
					if (MyValue->Selected) {
						strcat(gh->result,MyValue->Prefix);
						if (gh->NewLine) {
							strcat(gh->result,"\n");
						}
						else {
							strcat(gh->result," ");
						}
					}
					else {
						if (MyValue->NPrefix) {
							strcat(gh->result,MyValue->NPrefix);
							if (gh->NewLine) {
								strcat(gh->result,"\n");
							}
							else {
								strcat(gh->result," ");
							}
						}
					}
				}
				break;
			case GAD_STRING:
				GT_GetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
									GTST_String,&p,
									TAG_END);
				if (strstr(LoopGadget->Prefix,"%s")) {
					sprintf(gh->tBuffer,LoopGadget->Prefix,p);
				}
				else {
					sprintf(gh->tBuffer,"%s%s",LoopGadget->Prefix,p);
				}
				strcat(gh->result,gh->tBuffer);
				break;
			case GAD_OSTRING:
				if (LoopGadget->Currentc) {
					GT_GetGadgetAttrs(LoopGadget->Gadget2,gh->Window,NULL,
										GTST_String,&p,
										TAG_END);
					if (strstr(LoopGadget->Prefix,"%s")) {
						sprintf(gh->tBuffer,LoopGadget->Prefix,p);
					}
					else {
						sprintf(gh->tBuffer,"%s%s",LoopGadget->Prefix,p);
					}
					strcat(gh->result,gh->tBuffer);
				}
				break;
			case GAD_CHECK:
				if (LoopGadget->Currentc) {
					strcat(gh->result,LoopGadget->Prefix);
				}
				else {
					if (LoopGadget->NPrefix) {
						strcat(gh->result,LoopGadget->NPrefix);
					}
				}
				break;
			case GAD_SLIDER:
				if (strstr(LoopGadget->Prefix,"%s")) {
					sprintf(buffer,"%ld",LoopGadget->Currentn);
					sprintf(gh->tBuffer,LoopGadget->Prefix,buffer);
				}
				else {
					sprintf(gh->tBuffer,"%s%ld",LoopGadget->Prefix,LoopGadget->Currentn);
				}
				strcat(gh->result,gh->tBuffer);
				break;
			case GAD_BUTTON:
				break;
			case GAD_BUTTONTEXT:
				break;
			}
			if (gh->NewLine) {
				strcat(gh->result,"\n");
			}
			else {
				strcat(gh->result," ");
			}
		}
	}
	// convert " back
	p = gh->result;
	while (*p) {
		if ('\001' == *p) {
			*p = '"';
		}
		++p;
	}
	return gh->result;
}

/****** MPGui.library/SetMPGuiGadgetValue ***********************************
*
*   NAME   
*  SetMPGuiGadgetValue -- Sets the value of an MPGui gadget. (V3)
*
*   SYNOPSIS
*  succ = SetMPGuiGadgetValue( gh, Title, Value)
*  D0                          A0  A1     A2
*
*  BOOL SetMPGuiGadgetValue( struct MPGuiHandle *, char *, char *);
*
*   FUNCTION
*  Sets the value of a gadget currently being displayed by
*  SyncMPGuiRequest().
*
*   INPUTS
*  gh    - MPGuiHandle being displayed by SyncMPGuiRequest().
*  Title - Title of the gadget as in the input file.
*  Value - Value of the gadget.
*          Y/N for a CHECKs.
*          A String for Strings/Files/Modes.
*          A String (which is converted using strtol) for Numbers/Sliders.
*          A value or number in the list/cycle for lists/cycles.
*          Values strung together sperated by space for an MLIST gadget
*
*   RESULT
*  error - 1 for success, 0 for failure.
*          Error means gadget not found or Value not found.
*
*   EXAMPLE
*
*   NOTES
*  Title must be exact including "_" as required.
*
*  This should be called from a MPG_MENUHOOK supplied to AllocMPGuiHandle().
*  e.g. If a Reset To Defaults... menu item is called.
*
*  BUTTON gadgets can not have there attributes set.
*
*   BUGS
*  For an MLIST gadget if a value is a substring of another gadget then the
*  value can be incorrectly set.
*
*  MTEXT/TEXT gadgets can not be updated.
*
*   SEE ALSO
*  SyncMPGuiRequest().
*
*****************************************************************************
*
*/
__saveds __asm BOOL
SetMPGuiGadgetValue(register __a0 struct MPGuiHandle *gh,
							register __a1 char *Title, register __a2 char *Value) {
	struct MyGadget *LoopGadget,*Loop1Gadget;
	BOOL Ok = FALSE;
	int i;
	int number;
	struct MyValue *MyValue;
	char *s;

	for (LoopGadget = (struct MyGadget *)(gh->GList.lh_Head);
										LoopGadget->GNode.ln_Succ;
										LoopGadget = (struct MyGadget *)(LoopGadget->GNode.ln_Succ)) {
		if (!strcmp(LoopGadget->Title,Title)) {
			switch (LoopGadget->Type) {
			case GAD_LFILE:
			case GAD_SFILE:
			case GAD_FILE:
			case GAD_STRING:
				Ok = TRUE;
				GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
									GTST_String,Value,
									TAG_END);
				break;
			case GAD_MODE:
			case GAD_FONT:
				Ok = TRUE;
				GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
									GTTX_Text,Value,
									TAG_END);
				break;
			case GAD_OMODE:
			case GAD_OFONT:
				Ok = TRUE;
				GT_SetGadgetAttrs(LoopGadget->Gadget2,gh->Window,NULL,
									GTTX_Text,Value,
									TAG_END);
				break;
			case GAD_NUMBER:
				Ok = TRUE;
				GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
									GTIN_Number,strtol(Value,NULL,10),
									TAG_END);
				break;
			case GAD_ONUMBER:
				Ok = TRUE;
				GT_SetGadgetAttrs(LoopGadget->Gadget2,gh->Window,NULL,
									GTIN_Number,strtol(Value,NULL,10),
									TAG_END);
				break;
			case GAD_CYCLE:
				i = 0;
				number = -1;
				for (MyValue = (struct MyValue *)(LoopGadget->VList.lh_Head);
						MyValue->VNode.ln_Succ;
						MyValue = (struct MyValue *)(MyValue->VNode.ln_Succ)){
					if (!strcmp(Value,MyValue->VNode.ln_Name)) {
						number = i;
					}
					++i;
				}
				if (number == -1) {
					number = strtol(Value,NULL,10);
				}
				if (number != -1) {
					Ok = TRUE;
					LoopGadget->Currenty = number;
					GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
								GTCY_Active, LoopGadget->Currenty,
								TAG_END);
					for (Loop1Gadget = (struct MyGadget *)(gh->GList.lh_Head);
							Loop1Gadget->GNode.ln_Succ;
							Loop1Gadget = (struct MyGadget *)(Loop1Gadget->GNode.ln_Succ)){
						if (LoopGadget == Loop1Gadget->OwnCycle) {
							GT_SetGadgetAttrs(Loop1Gadget->Gadget1,gh->Window,NULL,
													GA_Disabled,LoopGadget->Currenty != Loop1Gadget->Activey,
													TAG_END);
							if (Loop1Gadget->Gadget2) {
								GT_SetGadgetAttrs(Loop1Gadget->Gadget2,gh->Window,NULL,
										GA_Disabled,(LoopGadget->Currenty != Loop1Gadget->Activey) ||
														(((Loop1Gadget->Type == GAD_ONUMBER) ||
														  (Loop1Gadget->Type == GAD_OSTRING) ||
														  (Loop1Gadget->Type == GAD_OFILE)) && (!Loop1Gadget->Currentc)),
										TAG_END);
							}
							if (Loop1Gadget->Gadget3) {
								GT_SetGadgetAttrs(Loop1Gadget->Gadget3,gh->Window,NULL,
										GA_Disabled,(LoopGadget->Currenty != Loop1Gadget->Activey) ||
														  (((Loop1Gadget->Type == GAD_OFILE) ||
														    (Loop1Gadget->Type == GAD_OMODE) ||
														    (Loop1Gadget->Type == GAD_OFONT))
														    && (!Loop1Gadget->Currentc)),
										TAG_END);
							}
						}
					}
				}
				break;
			case GAD_LIST:
				i = 0;
				number = -1;
				for (MyValue = (struct MyValue *)(LoopGadget->VList.lh_Head);
						MyValue->VNode.ln_Succ;
						MyValue = (struct MyValue *)(MyValue->VNode.ln_Succ)){
					if (!strcmp(Value,MyValue->VNode.ln_Name)) {
						number = i;
					}
					++i;
				}
				if (number == -1) {
					number = strtol(Value,NULL,10);
				}
				if (number != -1) {
					Ok = TRUE;
					LoopGadget->Currenty = number;
					GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
								GTLV_Selected, LoopGadget->Currenty,
								GTLV_MakeVisible, LoopGadget->Currenty,
								TAG_END);
				}
				break;
			case GAD_MLIST:
				GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
									GTLV_Labels, -1,
									TAG_END);
				for (MyValue = (struct MyValue *)(LoopGadget->VList.lh_Head);
						MyValue->VNode.ln_Succ;
						MyValue = (struct MyValue *)(MyValue->VNode.ln_Succ)) {
					if (s = strstr(Value,MyValue->VNode.ln_Name)) {
						MyValue->Selected = TRUE;
					}
					else {
						MyValue->Selected = FALSE;
					}
				}
				GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
									GTLV_Labels, &(LoopGadget->VList),
									TAG_END);
				break;
			case GAD_OFILE:
			case GAD_OSTRING:
				Ok = TRUE;
				GT_SetGadgetAttrs(LoopGadget->Gadget2,gh->Window,NULL,
									GTST_String,Value,
									TAG_END);
				break;
			case GAD_CHECK:
				Ok = TRUE;
				GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
									GTCB_Checked, LoopGadget->Currentc = (toupper(*Value) == 'Y'),
									TAG_END);
				break;
			case GAD_SLIDER:
				Ok = TRUE;
				LoopGadget->Currentn = strtol(Value,NULL,10);
				GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
								GTSL_Level, LoopGadget->Currentn,
								TAG_END);
				break;
			case GAD_BUTTON:
				break;
			case GAD_BUTTONTEXT:
				break;
			default:
				break;
			}
		}
	}
	return Ok;
}

/****** MPGui.library/SyncMPGuiRequest **************************************
*
*   NAME   
*  SyncMPGuiRequest -- Displays and processes an MPGui. (V3)
*
*   SYNOPSIS
*  result = SyncMPGuiRequest( fname, gh)
*  D0                         A0     A1
*
*  char * SyncMPGuiRequest( char *, struct MPGuiHandle *);
*
*   FUNCTION
*  Displays an MPGuiHandle allocated by AllocMPGuiHandle() and processes all
*  messages.
*
*   INPUTS
*  fname - name of file describing gui.
*  gh    - MPGuiHandle allocated by AllocMPGuiHandle().
*
*   RESULT
*  Attributes of the MPGui if Save/Use/Ok was used.
*  0 if Cancel was used/window closed/Esc pressed.
*  -1 for error. Use MPGuiError() to get error.
*
*   EXAMPLE
*
*   NOTES
*  If MPG_PREFS was supplied to AllocMPGuiHandle() then use MPGuiResponse()
*  to determine if Save or Use was pressed.
*
*  If the requester will not fit in one column with the default screen font
*  then it falls back in the following order until it fits:
*
*    Compressed vertical seperation;
*    Default fixed font;
*    Default fixed font with compressed vertical seperation;
*    Topaz 80;
*    Topaz 80 with compressed vertical seperation;
*    Two columns topaz 80 with compressed vertical seperation;
*    3 or more columns topaz 80 with compressed vertical seperation.
*
*   BUGS
*  When trying to cope with very small screens/very large requesters it can
*  result in gadgets with negative width which can crash the system. This
*  should only happen if more than 2 columns are required.
*
*  Fixed in version 5.1 Buttons with no Title going to a new column
*
*   SEE ALSO
*  AllocMPGuiHandleA(),MPGuiError(),MPGuiResponse().
*
*****************************************************************************
*
*/
char * __saveds __asm
SyncMPGuiRequest(register __a0 char *fname,register __a1 struct MPGuiHandle *gh) {
	UBYTE *temp = 0;
	struct TagItem *ti;
	if (!fname || !gh) {
		pError(gh,GetMessage(MSG_ERR_NOPS),NULL);
		return (char *) -1;
	}
	if (ti = FindTagItem(MPG_AMIGAKEY,gh->TagList)) {
		gh->Amiga = (struct Image *)ti->ti_Data;
	}
	if (ti = FindTagItem(MPG_CHECKMARK,gh->TagList)) {
		gh->Check = (struct Image *)ti->ti_Data;
	}
	if (ti = FindTagItem(MPG_PUBSCREENNAME,gh->TagList)) {
		temp = (UBYTE *)(ti->ti_Data);
	}
	if (!(gh->MyScreen = LockPubScreen(temp))) {
		gh->MyScreen = LockPubScreen(NULL);
	}
	if (ti = FindTagItem(MPG_HELP,gh->TagList)) {
		gh->HelpFunc = (struct Hook *)(ti->ti_Data);
	}
	if (ti = FindTagItem(MPG_CHELP,gh->TagList)) {
		gh->CHelp = ti->ti_Data;
	}
	if (ti = FindTagItem(MPG_PARAMS,gh->TagList)) {
		gh->Params = (char **)ti->ti_Data;
	}
	if (ti = FindTagItem(MPG_NEWLINE,gh->TagList)) {
		gh->NewLine = ti->ti_Data;
	}
	if (ti = FindTagItem(MPG_PREFS,gh->TagList)) {
		gh->Prefs = ti->ti_Data;
	}
	if (ti = FindTagItem(MPG_NOBUTTONS,gh->TagList)) {
		gh->NoButtons = ti->ti_Data;
		if (gh->NoButtons) {
			gh->Prefs = FALSE;
		}
	}
	if (ti = FindTagItem(MPG_BUTTONHOOK,gh->TagList)) {
		gh->ButtonFunc = (struct Hook *)ti->ti_Data;
	}
	if (ti = FindTagItem(MPG_MENUS,gh->TagList)) {
		gh->NewMenu = (struct NewMenu *)ti->ti_Data;
	}
	if (ti = FindTagItem(MPG_MENUHOOK,gh->TagList)) {
		gh->MenuFunc = (struct Hook *)ti->ti_Data;
	}
	else {
		gh->Menu = FALSE;
	}
	if (ti = FindTagItem(MPG_SIGNALHOOK,gh->TagList)) {
		if (ti->ti_Data) {
			gh->SignalFunc = (struct Hook *)ti->ti_Data;
			if (ti = FindTagItem(MPG_SIGNALS,gh->TagList)) {
				gh->Signals = ti->ti_Data;
			}
		}
	}
	gh->MyTextAttr = gh->MyScreen->Font;
	if (gh->MyScreen) {
		if (gh->fp = Open(fname,MODE_OLDFILE)) {
			if (myfgets(gh)) {
				if (gh->buffer[0] == '"') {
					Command(gh);
				}
				else {
					pError(gh,GetMessage(MSG_ERR_NOSQ),gh->buffer);
				}
			}
			else {
				pError(gh,GetMessage(MSG_ERR_NOCOM),NULL);
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_OPENF),fname);
		}
	}
	else {
		pError(gh,GetMessage(MSG_ERR_LOCKS),NULL);
	}
	if (!gh->FoundError) {
		ULONG temp,temp1;
		if (gh->allsize > (gh->leftsize + gh->rightsize)) {
			gh->rightsize = gh->allsize - gh->leftsize;
		}
		if (gh->tallsize > (gh->tleftsize + gh->trightsize)) {
			gh->trightsize = gh->tallsize - gh->tleftsize;
		}
		temp = gh->MyScreen->WBorTop + gh->MyScreen->Font->ta_YSize + 1 + gh->MyScreen->WBorBottom -
			 (INTERHEIGHT + 1) * gh->extralist;
		temp1 = gh->numlines+(gh->NoButtons?0:1)+(gh->HelpMessageB?1:0)+1;
		if (temp + (gh->MyScreen->Font->ta_YSize + 2 + INTERHEIGHT)*temp1 >
										gh->MyScreen->Height) {
			if (temp + (gh->MyScreen->Font->ta_YSize + 2 + (INTERHEIGHT/2))*temp1 >
											gh->MyScreen->Height) {
				if (temp + (GfxBase->DefaultFont->tf_YSize + 2 + INTERHEIGHT)*temp1 >
												gh->MyScreen->Height) {
					if (temp + (GfxBase->DefaultFont->tf_YSize + 2 + INTERHEIGHT/2)*temp1 >
													gh->MyScreen->Height) {
						if (temp + (8 + 2 + INTERHEIGHT)*temp1 >
														gh->MyScreen->Height) {
							gh->interwidth = INTERWIDTH;
							gh->interheight = (INTERHEIGHT/2);
							gh->Attr.ta_Name = (STRPTR)"topaz.font";
							gh->Attr.ta_YSize = 8;
							gh->MyTextAttr = &(gh->Attr);
							gh->leftsize = gh->tleftsize;
							gh->rightsize = gh->trightsize;
							gh->UseTopaz = TRUE;
							gh->XSize = 8;
							if (temp + (8 + 2 + INTERHEIGHT/2)*temp1 >
																gh->MyScreen->Height) {
								if ((gh->leftsize*2 + gh->rightsize*2 + (gh->interwidth * 2) +
									  gh->MyScreen->WBorLeft + gh->MyScreen->WBorRight) > gh->MyScreen->Width) {
									gh->rightsize = (gh->MyScreen->Width - 2 * gh->leftsize - (gh->interwidth * 2) -
														  gh->MyScreen->WBorLeft - gh->MyScreen->WBorRight) / 2;
								}
							}
						}
						else {
							gh->interwidth = INTERWIDTH;
							gh->interheight = INTERHEIGHT;
							gh->Attr.ta_Name = (STRPTR)"topaz.font";
							gh->Attr.ta_YSize = 8;
							gh->MyTextAttr = &(gh->Attr);
							gh->leftsize = gh->tleftsize;
							gh->rightsize = gh->trightsize;
							gh->UseTopaz = TRUE;
							gh->XSize = 8;
						}
					}
					else {
						gh->interwidth = INTERWIDTH;
						gh->interheight = (INTERHEIGHT/2);
						gh->Attr.ta_Name = (STRPTR)GfxBase->DefaultFont->tf_Message.mn_Node.ln_Name;
						gh->Attr.ta_YSize = GfxBase->DefaultFont->tf_YSize;
						gh->MyTextAttr = &(gh->Attr);
						gh->leftsize = (gh->tleftsize * GfxBase->DefaultFont->tf_XSize)/8;
						gh->rightsize = (gh->trightsize * GfxBase->DefaultFont->tf_XSize)/8;
						gh->UseTopaz = TRUE;
						gh->XSize = GfxBase->DefaultFont->tf_XSize;
					}
				}
				else {
					gh->interwidth = INTERWIDTH;
					gh->interheight = INTERHEIGHT;
					gh->Attr.ta_Name = (STRPTR)GfxBase->DefaultFont->tf_Message.mn_Node.ln_Name;
					gh->Attr.ta_YSize = GfxBase->DefaultFont->tf_YSize;
					gh->MyTextAttr = &(gh->Attr);
					gh->leftsize = (gh->tleftsize * GfxBase->DefaultFont->tf_XSize)/8;
					gh->rightsize = (gh->trightsize * GfxBase->DefaultFont->tf_XSize)/8;
					gh->UseTopaz = TRUE;
					gh->XSize = GfxBase->DefaultFont->tf_XSize;
				}
			}
			else {
				gh->interwidth = INTERWIDTH;
				gh->interheight = INTERHEIGHT/2;
			}
		}
		else {
			gh->interwidth = INTERWIDTH;
			gh->interheight = INTERHEIGHT;
		}
		RequesterStuff(gh);
	}
	if (gh->MyScreen) {
		UnlockPubScreen(NULL,gh->MyScreen);
	}
	if (gh->fp) {
		Close(gh->fp);
	}
	if (gh->FoundError) {
		return (char *)-1;
	}
	else {
		if (gh->result[0]) {
			return gh->result;
		}
		else {
			return NULL;
		}
	}
}

/****** MPGui.library/ReadMPGui *********************************************
*
*   NAME   
*  ReadMPGui -- Reads information for an MPGui. (V4)
*
*   SYNOPSIS
*  result = ReadMPGui( fname, gh)
*  D0                         A0     A1
*
*  BOOL ReadMPGui( char *, struct MPGuiHandle *);
*
*   FUNCTION
*  Reads all the information in the file for an MPGuiHandle allocated by
*  AllocMPGuiHandle().
*
*   INPUTS
*  fname - name of file describing gui.
*  gh    - MPGuiHandle allocated by AllocMPGuiHandle().
*
*   RESULT
*  TRUE if file read OK
*  FALSE for error. Use MPGuiError() to get error.
*
*   EXAMPLE
*
*   NOTES
*  Ignores any tags supplied to AllocMPGuiHandleA().
*
*  This currently serves no purpose, but may be later used for a gui based
*  gui designer.
*
*   BUGS
*
* Currently does nothing!
* Does not handle TEXT/MTEXT
*
*   SEE ALSO
*  AllocMPGuiHandleA(),MPGuiError(),WriteMPGui().
*
*****************************************************************************
*
*/
BOOL __saveds __asm
ReadMPGui(register __a0 char *fname,register __a1 struct MPGuiHandle *gh) {
#if 0
	if (!fname || !gh) {
		pError(gh,GetMessage(MSG_ERR_NOPR),NULL);
		return FALSE;
	}
	if (gh->fp = Open(fname,MODE_OLDFILE)) {
		if (myfgets(gh)) {
			if (gh->buffer[0] == '"') {
				Command(gh);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_NOSQ),gh->buffer);
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_NOCOM),NULL);
		}
		Close(gh->fp);
	}
	else {
		pError(gh,GetMessage(MSG_ERR_OPENF),fname);
	}
	if (gh->FoundError) {
		return FALSE;
	}
	else {
		return TRUE;
	}
#else
	return TRUE;
#endif
}

#if 0
void
PrintHelp(struct MPGuiHandle *gh,struct MyGadget *gad) {
	if (gad->HelpNode) {
		if (gad->HelpMessage) {
			FPrintf(gh->fp,"!%s!%s!",gad->HelpNode,gad->HelpMessage);
		}
		else {
			FPrintf(gh->fp,"!%s!!",gad->HelpNode);
		}
	}
	else {
		if (gad->HelpMessage) {
			FPrintf(gh->fp,"!!%s!",gad->HelpMessage);
		}
		else {
			FPrintf(gh->fp,"!!!");
		}
	}
}

BOOL
PrintGadget(struct MPGuiHandle *gh,struct MyGadget *gad) {
	struct MyGadget *gad1;
	struct MyValue *val;
	int i,j;
	char *type;
	if (gad->OwnCycle) {
		FPuts(gh->fp,"\t\t");
	}
	else {
		FPutC(gh->fp,'\t');
	}
	switch (gad->Type) {
	case GAD_LFILE:
		type = "LFILE";
		break;
	case GAD_SFILE:
		type = "SFILE";
		break;
	case GAD_FILE:
		type = "FILE";
		break;
	case GAD_OFILE:
		type = "OFILE";
		break;
	case GAD_ONUMBER:
		type = "ONUMBER";
		break;
	case GAD_NUMBER:
		type = "NUMBER";
		break;
	case GAD_CYCLE:
		type = "CYCLE";
		break;
	case GAD_STRING:
		type = "STRING";
		break;
	case GAD_OSTRING:
		type = "OSTRING";
		break;
	case GAD_CHECK:
		type = "CHECK";
		break;
	case GAD_SLIDER:
		type = "SLIDER";
		break;
	case GAD_MODE:
		type = "MODE";
		break;
	case GAD_OMODE:
		type = "OMODE";
		break;
	case GAD_FONT:
		type = "FONT";
		break;
	case GAD_OFONT:
		type = "OFONT";
		break;
	case GAD_LIST:
		type = "LIST";
		break;
	case GAD_MLIST:
		type = "MLIST";
		break;
	case GAD_BUTTONTEXT:
		type = "BUTTON";
		break;
	case GAD_BUTTON:
		break;
	default:
		break;
	}
	switch (gad->Type) {
	case GAD_LFILE:
	case GAD_SFILE:
	case GAD_FILE:
	case GAD_STRING:
		FPrintf(gh->fp,"%s \"%s\":\"%s\":\"%s\"",type,gad->Title,gad->Prefix,gad->Defaults);
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		break;
	case GAD_OFILE:
	case GAD_OSTRING:
		FPrintf(gh->fp,"%s \"%s\":\"%s\":\"%s\":%s",type,gad->Title,gad->Prefix,gad->Defaults,
																	gad->Defaultc?"Y":"N");
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		break;
	case GAD_ONUMBER:
		FPrintf(gh->fp,"%s \"%s\":\"%s\":\"%ld\":%s",type,gad->Title,gad->Prefix,gad->Defaultn,
																	gad->Defaultc?"Y":"N");
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		break;
	case GAD_NUMBER:
		FPrintf(gh->fp,"%s \"%s\":\"%s\":\"%ld\"",type,gad->Title,gad->Prefix,gad->Defaultn);
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		break;
	case GAD_CYCLE:
		FPrintf(gh->fp,"%s \"%s\"",type,gad->Title);
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		i = 0;
		for (gad1 = (struct MyGadget *)(gh->GList.lh_Head);
			  gad1->GNode.ln_Succ;
			  gad1 = (struct MyGadget *)(gad1->GNode.ln_Succ)){
			if (gad == gad1->OwnCycle) {
				for (; !(i > gad1->Activey); i++) {
					val = (struct MyValue *)gad->VList.lh_Head;
					for (j = 0; (j < i); j++) {
						val = (struct MyValue *)val->VNode.ln_Succ;
					}
					FPrintf(gh->fp,"\t\"%s\":\"%s\"\n",val->VNode.ln_Name,val->Prefix);
				}
				PrintGadget(gh,gad1);
			}
		}
		for (; (i < gad->Numbery); i++) {
			val = (struct MyValue *)gad->VList.lh_Head;
			for (j = 0; (j < i); j++) {
				val = (struct MyValue *)val->VNode.ln_Succ;
			}
			FPrintf(gh->fp,"\t\"%s\":\"%s\"\n",val->VNode.ln_Name,val->Prefix);
		}
		FPrintf(gh->fp,"\t%s:\"%ld\"\n","ENDCYCLE",gad->Defaulty);
		break;
	case GAD_CHECK:
		if (gad->NPrefix) {
			FPrintf(gh->fp,"%s \"%s\":\"%s\":\"%s\":%s",type,gad->Title,gad->Prefix,
																	gad->NPrefix,gad->Defaultc?"Y":"N");
		}
		else {
			FPrintf(gh->fp,"%s \"%s\":\"%s\":%s",type,gad->Title,gad->Prefix,
																	gad->Defaultc?"Y":"N");
		}
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		break;
	case GAD_SLIDER:
		FPrintf(gh->fp,"%s \"%s\":\"%s\":\"%ld\":\"%ld\":\"%ld\"",type,gad->Title,gad->Prefix,
																			gad->Minn,gad->Maxn,gad->Defaultn);
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		break;
	case GAD_MODE:
	case GAD_FONT:
		FPrintf(gh->fp,"%s%ld \"%s\":\"%s\":\"%s\"",type,gad->ModeType,gad->Title,gad->Prefix,
																			gad->Defaults);
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		break;
	case GAD_OMODE:
	case GAD_OFONT:
		FPrintf(gh->fp,"%s%ld \"%s\":\"%s\":\"%s\":%s",type,gad->ModeType,gad->Title,gad->Prefix,
																			gad->Defaults,gad->Defaultc?"Y":"N");
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		break;
	case GAD_LIST:
		FPrintf(gh->fp,"%s \"%s\"",type,gad->Title);
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		val = (struct MyValue *)gad->VList.lh_Head;
		for (i=0; (i < gad->Numbery); i++) {
			if (gad->OwnCycle) {
				FPutC(gh->fp,'\t');
			}
			FPrintf(gh->fp,"\t\t\"%s\":\"%s\"\n",val->VNode.ln_Name,val->Prefix);
			val = (struct MyValue *)val->VNode.ln_Succ;
		}
		if (gad->OwnCycle) {
			FPutC(gh->fp,'\t');
		}
		FPrintf(gh->fp,"\t%s:\"%ld\":\"%ld\"\n","ENDLIST",gad->Defaulty,gad->Lines);
		break;
	case GAD_MLIST:
		FPrintf(gh->fp,"%s \"%s\"",type,gad->Title);
		PrintHelp(gh,gad);
		FPutC(gh->fp,'\n');
		val = (struct MyValue *)gad->VList.lh_Head;
		for (i=0; (i < gad->Numbery); i++) {
			if (gad->OwnCycle) {
				FPutC(gh->fp,'\t');
			}
			if (val->NPrefix) {
				FPrintf(gh->fp,"\t\t\"%s\":\"%s\":\"%s\"\n",val->VNode.ln_Name,val->Prefix,val->NPrefix);
			}
			else {
				FPrintf(gh->fp,"\t\t\"%s\":\"%s\"\n",val->VNode.ln_Name,val->Prefix);
			}
			val = (struct MyValue *)val->VNode.ln_Succ;
		}
		if (gad->OwnCycle) {
			FPutC(gh->fp,'\t');
		}
		FPrintf(gh->fp,"\t%s:\"%s\":\"%ld\"\n","ENDMLIST",gad->Defaults,gad->Lines);
		break;
	case GAD_BUTTONTEXT:
		{
			struct MyGadget* gad1;
			FPrintf(gh->fp,"\t%s:\"%s\"\n",type,gad->Title);
			for (gad1 = (struct MyGadget *)gad->GNode.ln_Succ;
				  gad1->GNode.ln_Succ && (GAD_BUTTON == gad1->Type);
				  gad1 = (struct MyGadget *)gad1->GNode.ln_Succ) {
				if (gad->OwnCycle) {
					FPutC(gh->fp,'\t');
				}
				FPrintf(gh->fp,"\t\t\"%s\":\"%ld\"",gad1->Title,gad1->ButtonNo);
				PrintHelp(gh,gad1);
				FPutC(gh->fp,'\n');
			}
			if (gad->OwnCycle) {
				FPutC(gh->fp,'\t');
			}
			FPrintf(gh->fp,"\tENDBUTTON\n");
		}
		break;
	case GAD_BUTTON:
		break;
	default:
		FPuts(gh->fp,"??\n");
		break;
	}
	return TRUE;
}

/****** MPGui.library/WriteMPGui ********************************************
*
*   NAME   
*  WriteMPGui -- Writes information for an MPGui. (V4)
*
*   SYNOPSIS
*  result = WriteMPGui( fname, gh)
*  D0                         A0     A1
*
*  BOOL WriteMPGui( char *, struct MPGuiHandle *);
*
*   FUNCTION
*  Writes all the information in the file for an MPGuiHandle allocated by
*  AllocMPGuiHandle().
*
*   INPUTS
*  fname - name of file to describe the gui.
*  gh    - MPGuiHandle allocated by AllocMPGuiHandle().
*
*   RESULT
*  TRUE if file written OK
*  FALSE for error. Use MPGuiError() to get error.
*
*   EXAMPLE
*
*   NOTES
*  Ignores any tags supplied to AllocMPGuiHandleA().
*
*  This currently serves no purpose, but may be later used for a gui based
*  gui designer.
*
*   BUGS
*
* Currently does nothing!
* Does not handle TEXT/MTEXT
*
*   SEE ALSO
*  AllocMPGuiHandleA(),MPGuiError(),ReadMPGui().
*
*****************************************************************************
*
*/
#endif
BOOL __saveds __asm
WriteMPGui(register __a0 char *fname,register __a1 struct MPGuiHandle *gh) {
#if 0
	int i;
	struct MyGadget *gad;
	if (!fname || !gh) {
		pError(gh,GetMessage(MSG_ERR_NOPW),NULL);
		return FALSE;
	}
	if (gh->fp = Open(fname,MODE_NEWFILE)) {
		for (i=0; i<6; i++) {
			if (gh->comment[i]) {
				FPrintf(gh->fp,"%s\n",gh->comment[i]);
			}
		}
		FPutC(gh->fp,'\n');
		FPrintf(gh->fp,"\"%s\"%s",gh->Command,gh->HelpMessage);
		FPrintf(gh->fp,"\t\"%s\"\n",gh->Comment);
		FPrintf(gh->fp,"\t\"%s\"\n",gh->HelpNode);
		for (gad = (struct MyGadget *)gh->GList.lh_Head;
			  gad->GNode.ln_Succ;
			  gad = (struct MyGadget *)gad->GNode.ln_Succ) {
			if (!gad->OwnCycle) {
				PrintGadget(gh,gad);
			}
		}
		Close(gh->fp);
	}
	else {
		pError(gh,GetMessage(MSG_ERR_OPENF),fname);
	}
	if (gh->FoundError) {
		return FALSE;
	}
	else {
		return TRUE;
	}
#else
	return TRUE;
#endif
}

/****** MPGui.library/RefreshMPGui ******************************************
*
*   NAME   
*  RefreshMPGui -- Refreshes an MPGui Window. (V5)
*
*   SYNOPSIS
*  RefreshMPGui(gh)
*               A0
*
*  void RefreshMPGui(struct MPGuiHandle *);
*
*   FUNCTION
*  Refreshes an MPGui Window.
*
*   INPUTS
*  gh    - MPGuiHandle allocated by AllocMPGuiHandle().
*
*   RESULT
*  None
*
*   EXAMPLE
*
*   NOTES
*  Use in a call back hook - e.g. if a menu item opens a file requester.
*
*   BUGS
*
*   SEE ALSO
*  AllocMPGuiHandleA(), SyncMPGuiRequest().
*
*****************************************************************************
*
*/
void __saveds __asm
RefreshMPGui(register __a0 struct MPGuiHandle *gh) {
	if (gh) {
		if (gh->Window) {
			GT_BeginRefresh(gh->Window);
			GT_EndRefresh(gh->Window,TRUE);
		}
	}
}

/****** MPGui.library/MPGuiWindow *******************************************
*
*   NAME   
*  MPGuiWindow -- Returns the Window for an MPGui. (V5)
*
*   SYNOPSIS
*  Window = MPGuiWindow(gh)
*  D0                   A0
*
*  struct Window *MPGuiWindow(struct MPGuiHandle *);
*
*   FUNCTION
*  Returns the Window for an MPGui.
*
*   INPUTS
*  gh    - MPGuiHandle allocated by AllocMPGuiHandle().
*
*   RESULT
*  The Window for the GUI - if open.
*
*   EXAMPLE
*
*   NOTES
*  Use in a call back hook - e.g. if a menu item opens a file requester.
*
*   BUGS
*
*   SEE ALSO
*  AllocMPGuiHandleA(), SyncMPGuiRequest().
*
*****************************************************************************
*
*/
struct Window * __saveds __asm
MPGuiWindow(register __a0 struct MPGuiHandle *gh) {
	if (gh) {
		return gh->Window;
	}
	return NULL;
}

int
sprintf(char *buffer,const char *ctl, ...) {
   va_list args;

   va_start(args, ctl);

   /*********************************************************/
   /* NOTE: The string below is actually CODE that copies a */
   /*       value from d0 to A3 and increments A3:          */
   /*                                                       */
   /*          move.b d0,(a3)+                              */
   /*          rts                                          */
   /*                                                       */
   /*       It is essentially the callback routine needed   */
   /*       by RawDoFmt.                                    */
   /*********************************************************/

   RawDoFmt((char *)ctl, args, (void (*))"\x16\xc0\x4e\x75", buffer);

   va_end(args);

   return 0;
}

/* clone of strdup using pooled memory */
char
*mystrdup(struct MPGuiHandle *gh,char *old) {
	char *ptr;
	if (!old) {
		return NULL;
	}
	if (ptr = AllocPooled(gh->MemPool,strlen(old)+1)) {
		strcpy(ptr,old);
	}
	return ptr;
}

/* Does all the input file processing for a command */
void
Command(struct MPGuiHandle *gh) {
	char *s,*s1;
	NewList(&(gh->GList));
	s = strchr(&(gh->buffer[1]),'"');
	if (s) {
		*s = 0;
		gh->Command = mystrdup(gh,&(gh->buffer[1]));
		gh->HelpMessage = mystrdup(gh,++s);
		while ((s = myfgets(gh)) && !strchr(gh->buffer,'"')) {
		}
		if (s) {
			s = strchr(gh->buffer,'"');
			s1 = strchr(s+1,'"');
			if (s1) {
				*s1=0;
				gh->Comment = mystrdup(gh,s+1);
				if (!gh->HelpMessage) {
					gh->HelpMessage = gh->Comment;
				}
				gh->TitleLength = TextLength(&(gh->MyScreen->RastPort),gh->Comment,strlen(gh->Comment));
				if (myfgets(gh)) {
					s = strchr(gh->buffer,'"');
					if (s) {
						s1 = strchr(s+1,'"');
						if (s1) {
							*s1=0;
							gh->HelpNode = mystrdup(gh,s+1);
							while (myfgets(gh)) {
								ProcessGadget(gh);
							}
 						}
						else {
							pError(gh,GetMessage(MSG_ERR_TEEQ),NULL);
							while (myfgets(gh) && (gh->buffer[0] != '\n')) {
							}
						}
					}
					else {
						pError(gh,GetMessage(MSG_ERR_TSSQ),NULL);
						while (myfgets(gh) && (gh->buffer[0] != '\n')) {
						}
					}
				}
				else {
					pError(gh,GetMessage(MSG_ERR_TEOF),NULL);
				}
			}
			else {
				pError(gh,GetMessage(MSG_ERR_COMMTQ),NULL);
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_COMEOF),NULL);
		}
	}
	else {
		pError(gh,GetMessage(MSG_ERR_COMTQ),NULL);
	}
}

void
pError(struct MPGuiHandle *gh,const char *a,char *b) {
	if (!gh->OutOfMemory) {
		sprintf(gh->TempFileName,GetMessage(MSG_ERR_LINE),gh->linenumber);
		strncat(gh->error,gh->TempFileName,1024);
		sprintf(gh->TempFileName,a,b);
		strncat(gh->error,gh->TempFileName,1024);
		strncat(gh->error,"\n",1024);
	}
	++gh->FoundError;
}

static char wbuffer[2048];

char
*myfgets(struct MPGuiHandle *gh) {
	char *s;
	int i;
	if ((gh->FoundError > 10) || (gh->OutOfMemory)) {
		return NULL;
	}
	++gh->linenumber;
	while ((s = FGets(gh->fp,gh->buffer,256)) && ((gh->buffer[0] == '*') || (gh->buffer[0] == '\n'))) {
		if (gh->buffer[0] == '*') {
			if (!gh->comment[6]) {
				for (i=0; i<6; i++) {
					if (!gh->comment[i]) {
						s[strlen(s)-1] = 0;
						gh->comment[i] = mystrdup(gh,s);
						i=6;
					}
				}
			}
		}
		++gh->linenumber;
	}
	if (!s) {
		return NULL;
	}
	s[strlen(s)-1] = 0;
	// Convert \ formats, \" is converted to 1 and converted back later
	if (strstr(s,"\\")) {
		char *s1,*s2;
		s1 = s;
		s2 = wbuffer;
		while (*s1) {
			if ('\\' == *s1) {
				++s1;
				switch (*s1) {
				case '\\':
					*s2++ = '\\';
					++s1;
					break;
				case '"':
					*s2++ = '\001';
					++s1;
					break;
				case 't':
					*s2++ = '\t';
					++s1;
					break;
				case 'n':
					*s2++ = '\n';
					++s1;
					break;
				default:
					*s2++ = *s1++;
					break;
				}
			}
			else {
				*s2++ = *s1++;
			}
		}
		*s2 = 0;
		strcpy(gh->buffer,wbuffer);
		s = gh->buffer;
	}
	if (!gh->Params || !s) {
		return s;
	}
	else {
		char *s1,*s2,*s3;
		BOOL found = FALSE;
		BOOL flag;
		int i,j;

		s1 = s;
		s2 = wbuffer;
		while (*s1) {
			if (*s1 != '#') {
				*s2++ = *s1++;
			}
			else {
				found = TRUE;
				s1++;
				if (*s1 == '#') {
					*s2++ = *s1++;
				}
				else {
					if (isdigit(*s1)) {
						i = atoi(s1);
						flag = TRUE;
						for (j = 0; j<(i+1); ++j) {
							if (!gh->Params[j]) {
								flag = FALSE;
								j = i+1;
							}
						}
						if (flag) {
							s3 = gh->Params[i];
						}
						else {
							s3 = "";
						}
						while (*s3) {
							*s2++ = *s3++;
						}
						while (*s1 && (*s1 != '#')) {
							s1++;
						}
						if (*s1) {
							s1++;
						}
					}
				}
			}
		}
		if (!found) {
			return s;
		}
		else {
			*s2 = 0;
			strcpy(gh->buffer,wbuffer);
			return gh->buffer;
		}
	}
}

#define ALPHA (char *)"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
#define NUMBER (char *)"0123456789"

void
ProcessGadget(struct MPGuiHandle *gh) {
	char *s;
	int temp=0,temp1=0;

	if (gh->CurrentGadget = (struct MyGadget *)AllocPooled(gh->MemPool,sizeof(struct MyGadget))) {
		NewList(&(gh->CurrentGadget->VList));
		AddTail(&(gh->GList),&(gh->CurrentGadget->GNode));
		if (gh->CurrentCycle) {
			gh->CurrentGadget->Activey = gh->CurrentCycleVal;
			gh->CurrentGadget->OwnCycle = gh->CurrentCycle;
		}
	}
	else {
		pError(gh,GetMessage(MSG_ERR_NOMEM),NULL);
		gh->OutOfMemory = 1;
		return;
	}
	s = SkipSpace(gh->buffer);
	if (s) {
		if (!strncmp(s,"FILE",strlen("FILE"))) {
			gh->CurrentGadget->Type = GAD_FILE;
		}
		else if (!strncmp(s,"LFILE",strlen("LFILE"))) {
			gh->CurrentGadget->Type = GAD_LFILE;
		}
		else if (!strncmp(s,"SFILE",strlen("SFILE"))) {
			gh->CurrentGadget->Type = GAD_SFILE;
		}
		else if (!strncmp(s,"OFILE",strlen("OFILE"))) {
			gh->CurrentGadget->Type = GAD_OFILE;
		}
		else if (!strncmp(s,"ONUMBER",strlen("ONUMBER"))) {
			gh->CurrentGadget->Type = GAD_ONUMBER;
		}
		else if (!strncmp(s,"NUMBER",strlen("NUMBER"))) {
			gh->CurrentGadget->Type = GAD_NUMBER;
		}
		else if (!strncmp(s,"CYCLE",strlen("CYCLE"))) {
			gh->CurrentGadget->Type = GAD_CYCLE;
		}
		else if (!strncmp(s,"STRING",strlen("STRING"))) {
			gh->CurrentGadget->Type = GAD_STRING;
		}
		else if (!strncmp(s,"TEXT",strlen("TEXT"))) {
			gh->CurrentGadget->Type = GAD_TEXT;
		}
		else if (!strncmp(s,"MTEXT",strlen("MTEXT"))) {
			gh->CurrentGadget->Type = GAD_MTEXT;
		}
		else if (!strncmp(s,"OSTRING",strlen("OSTRING"))) {
			gh->CurrentGadget->Type = GAD_OSTRING;
		}
		else if (!strncmp(s,"CHECK",strlen("CHECK"))) {
			gh->CurrentGadget->Type = GAD_CHECK;
		}
		else if (!strncmp(s,"SLIDER",strlen("SLIDER"))) {
			gh->CurrentGadget->Type = GAD_SLIDER;
		}
		else if (!strncmp(s,"MODE",strlen("MODE"))) {
			gh->CurrentGadget->Type = GAD_MODE;
		}
		else if (!strncmp(s,"OMODE",strlen("OMODE"))) {
			gh->CurrentGadget->Type = GAD_OMODE;
		}
		else if (!strncmp(s,"FONT",strlen("FONT"))) {
			gh->CurrentGadget->Type = GAD_FONT;
		}
		else if (!strncmp(s,"OFONT",strlen("OFONT"))) {
			gh->CurrentGadget->Type = GAD_OFONT;
		}
		else if (!strncmp(s,"LIST",strlen("LIST"))) {
			gh->CurrentGadget->Type = GAD_LIST;
		}
		else if (!strncmp(s,"MLIST",strlen("MLIST"))) {
			gh->CurrentGadget->Type = GAD_MLIST;
		}
		else if (!strncmp(s,"BUTTON",strlen("BUTTON"))) {
			gh->CurrentGadget->Type = GAD_BUTTONTEXT;
		}
		else {
			pError(gh,GetMessage(MSG_ERR_UNG),s);
			while(myfgets(gh)) {
				/* */
			}
			gh->CurrentGadget->Type = 0;
		}
		switch (gh->CurrentGadget->Type) {
		case GAD_FILE:
		case GAD_SFILE:
		case GAD_LFILE:
			GetTitle(TRUE,gh);
			GetParameter(gh);
			GetStringDefault(gh);
			GetHelp(gh);
			temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/3 + (GADGETWIDTH + INTERWIDTH);
			temp1 = (52*8/3) + (GADGETWIDTH + INTERWIDTH);
			break;
		case GAD_OFILE:
			GetTitle(TRUE,gh);
			GetParameter(gh);
			GetStringDefault(gh);
			GetCheckDefault(gh);
			GetHelp(gh);
			temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/3 + (GADGETWIDTH * 2 + INTERWIDTH * 2);
			temp1 = (52*8/3) + (GADGETWIDTH * 2 + INTERWIDTH * 2);
			break;
		case GAD_ONUMBER:
			GetTitle(TRUE,gh);
			GetParameter(gh);
			GetNumberDefault(gh);
			GetCheckDefault(gh);
			GetHelp(gh);
			temp = TextLength(&(gh->MyScreen->RastPort),NUMBER,strlen(NUMBER))*2/3 + (GADGETWIDTH + INTERWIDTH);
			temp1 = (10*8/3) + (GADGETWIDTH + INTERWIDTH);
			break;
		case GAD_NUMBER:
			GetTitle(TRUE,gh);
			GetParameter(gh);
			GetNumberDefault(gh);
			GetHelp(gh);
			temp = TextLength(&(gh->MyScreen->RastPort),NUMBER,strlen(NUMBER))*2/3;
			temp1 = (10*8/3);
			break;
		case GAD_CYCLE:
			if (gh->CurrentCycle) {
				pError(gh,GetMessage(MSG_ERR_CYCLECYCLE),NULL);
			}
			else {
				GetTitle(TRUE,gh);
				GetHelp(gh);
				ProcessCycle(gh);
			}
			temp = gh->rightsize;
			temp1 = gh->trightsize;
			break;
		case GAD_STRING:
			GetTitle(TRUE,gh);
			GetParameter(gh);
			GetStringDefault(gh);
			GetHelp(gh);
			temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/3;
			temp1 = (52*8/3);
			break;
		case GAD_TEXT:
			GetTitle(TRUE,gh);
			GetStringDefault(gh);
			GetCheckDefault(gh);
			GetHelp(gh);
			temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/3;
			temp1 = (52*8/3);
			break;
		case GAD_MTEXT:
			gh->CurrentPos = gh->buffer;
			GetStringDefault(gh);
			GetCheckDefault(gh);
			GetHelp(gh);
			temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/3;
			temp1 = (52*8/3);
			break;
		case GAD_OSTRING:
			GetTitle(TRUE,gh);
			GetParameter(gh);
			GetStringDefault(gh);
			GetCheckDefault(gh);
			GetHelp(gh);
			temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/3 + (GADGETWIDTH + INTERWIDTH);
			temp1 = (52*8/3) + (GADGETWIDTH + INTERWIDTH);
			break;
		case GAD_CHECK:
			GetTitle(TRUE,gh);
			GetParameter(gh);
			GetNParameter(gh);
			GetCheckDefault(gh);
			GetHelp(gh);
			temp = GADGETWIDTH;
			temp1 = GADGETWIDTH;
			break;
		case GAD_SLIDER:
			GetTitle(TRUE,gh);
			GetParameter(gh);
			GetNumberDefault(gh);
			gh->CurrentGadget->Minn = gh->CurrentGadget->Defaultn;
			GetNumberDefault(gh);
			gh->CurrentGadget->Maxn = gh->CurrentGadget->Defaultn;
			GetNumberDefault(gh);
			GetHelp(gh);
			if (gh->CurrentGadget->Defaultn < gh->CurrentGadget->Minn) {
				gh->CurrentGadget->Defaultn = gh->CurrentGadget->Minn;
			}
			if (gh->CurrentGadget->Defaultn > gh->CurrentGadget->Maxn) {
				gh->CurrentGadget->Defaultn = gh->CurrentGadget->Maxn;
			}
			gh->CurrentGadget->Currentn = gh->CurrentGadget->Defaultn;
			gh->CurrentGadget->logMaxn = 1;
			if (gh->CurrentGadget->Maxn > 9) {
				gh->CurrentGadget->logMaxn = 2;
				if (gh->CurrentGadget->Maxn > 99) {
					gh->CurrentGadget->logMaxn = 3;
					if (gh->CurrentGadget->Maxn > 999) {
						gh->CurrentGadget->logMaxn = 4;
						if (gh->CurrentGadget->Maxn > 9999) {
							gh->CurrentGadget->logMaxn = 5;
							if (gh->CurrentGadget->Maxn > 99999) {
								gh->CurrentGadget->logMaxn = 6;
							}
						}
					}
				}
			}
			temp = (GADGETWIDTH * 2 + INTERWIDTH) + TextLength(&(gh->MyScreen->RastPort),NUMBER,strlen(NUMBER))* gh->CurrentGadget->logMaxn/10;
			temp1 = (GADGETWIDTH*2 + INTERWIDTH)+gh->CurrentGadget->logMaxn*8;
			break;
		case GAD_MODE:
			s += 4;
			if ((*s > '0') && (*s < '5')) {
				gh->CurrentGadget->ModeType = *s - '0';
				GetTitle(TRUE,gh);
				GetParameter(gh);
				GetStringDefault(gh);
				GetHelp(gh);
				temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/2 + (GADGETWIDTH + INTERWIDTH);
				temp1 = (52*8/2) + (GADGETWIDTH + INTERWIDTH);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_MODEN),NULL);
				temp = gh->rightsize;
				temp1 = gh->trightsize;
			}
			break;
		case GAD_OMODE:
			s += 5;
			if ((*s > '0') && (*s < '5')) {
				gh->CurrentGadget->ModeType = *s - '0';
				GetTitle(TRUE,gh);
				GetParameter(gh);
				GetStringDefault(gh);
				GetCheckDefault(gh);
				GetHelp(gh);
				temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/2 + (GADGETWIDTH * 2 + INTERWIDTH * 2);
				temp1 = (52*8/2) + (GADGETWIDTH * 2 + INTERWIDTH * 2);
			}
			else {
				temp = gh->rightsize;
				temp1 = gh->trightsize;
				pError(gh,GetMessage(MSG_ERR_OMODEN),NULL);
			}
			break;
		case GAD_FONT:
			s += 4;
			if ((*s > '0') && (*s < '3')) {
				gh->CurrentGadget->ModeType = *s - '0';
				GetTitle(TRUE,gh);
				GetParameter(gh);
				GetStringDefault(gh);
				GetHelp(gh);
				temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/2 + (GADGETWIDTH + INTERWIDTH);
				temp1 = (52*8/2) + (GADGETWIDTH + INTERWIDTH);
			}
			else {
				temp = gh->rightsize;
				temp1 = gh->trightsize;
				pError(gh,GetMessage(MSG_ERR_FONTN),NULL);
			}
			break;
		case GAD_OFONT:
			s += 5;
			if ((*s > '0') && (*s < '3')) {
				gh->CurrentGadget->ModeType = *s - '0';
				GetTitle(TRUE,gh);
				GetParameter(gh);
				GetStringDefault(gh);
				GetCheckDefault(gh);
				GetHelp(gh);
				temp = TextLength(&(gh->MyScreen->RastPort),ALPHA,strlen(ALPHA))/2 + (GADGETWIDTH * 2 + INTERWIDTH * 2);
				temp1 = (52*8/2) + (GADGETWIDTH * 2 + INTERWIDTH * 2);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_OFONTN),NULL);
				temp = gh->rightsize;
				temp1 = gh->trightsize;
			}
			break;
		case GAD_LIST:
			GetTitle(TRUE,gh);
			GetHelp(gh);
			ProcessList(gh);
			gh->numlines += gh->CurrentGadget->Lines-1;
			gh->extralist += gh->CurrentGadget->Lines-1;
			temp = gh->rightsize;
			temp1 = gh->trightsize;
			break;
		case GAD_MLIST:
			GetTitle(TRUE,gh);
			GetHelp(gh);
			ProcessMList(gh);
			gh->numlines += gh->CurrentGadget->Lines-1;
			gh->extralist += gh->CurrentGadget->Lines-1;
			temp = gh->rightsize;
			temp1 = gh->trightsize;
			break;
		case GAD_BUTTONTEXT:
			GetTitle(FALSE,gh);
			{
				int temp2;
				temp2 = TextLength(&(gh->MyScreen->RastPort),gh->CurrentGadget->Title,strlen(gh->CurrentGadget->Title)) + INTERWIDTH;
				if (temp2 > gh->leftsize) {
					gh->leftsize = temp2;
				}
				temp2 = strlen(gh->CurrentGadget->Title) * 8 + INTERWIDTH;
				if (temp2 > gh->tleftsize) {
					gh->tleftsize = temp2;
				}
			}
			ProcessButton(gh);
			temp = gh->rightsize;
			temp1 = gh->trightsize;
			break;
		default:
			break;
		}
		if (temp > gh->rightsize) {
			gh->rightsize = temp;
		}
		if (temp1 > gh->trightsize) {
			gh->trightsize = temp1;
		}
		++gh->numlines;
	}
	else {
		pError(gh,GetMessage(MSG_ERR_UNSPC),NULL);
	}
	gh->CurrentGadget = NULL;
}

void
ProcessButton(struct MPGuiHandle *gh) {
	short endfound = 0;
	short first = 1;
	BOOL Left;
	char *s;
	int width = 0;
	int twidth = 0;
	struct MyGadget *Button;

	Button = gh->CurrentGadget;
	if (*gh->CurrentGadget->Title) {
		Left = TRUE;
	}
	else {
		Left = FALSE;
	}
	while (!endfound && myfgets(gh)) {
		s = SkipSpace(gh->buffer);
		if (s) {
			if ('"' == *s) {
				first = 0;
				if (gh->CurrentGadget = (struct MyGadget *)AllocPooled(gh->MemPool,sizeof(struct MyGadget))) {
					NewList(&(gh->CurrentGadget->VList));
					AddTail(&(gh->GList),&(gh->CurrentGadget->GNode));
					if (gh->CurrentCycle) {
						gh->CurrentGadget->Activey = gh->CurrentCycleVal;
						gh->CurrentGadget->OwnCycle = gh->CurrentCycle;
					}
					gh->CurrentGadget->Type = GAD_BUTTON;
					gh->CurrentGadget->OwnButton = Button;
					++Button->ButtonCount;
					GetTitle(FALSE,gh);
					GetNumberDefault(gh);
					gh->CurrentGadget->ButtonNo = gh->CurrentGadget->Defaultn;
					GetHelp(gh);
					width += TextLength(&(gh->MyScreen->RastPort),gh->CurrentGadget->Title,strlen(gh->CurrentGadget->Title)) + INTERWIDTH;
					twidth += 8*(strlen(gh->CurrentGadget->Title) + INTERWIDTH);
				}
				else {
					pError(gh,GetMessage(MSG_ERR_NOMEM),NULL);
					gh->OutOfMemory = 1;
					return;
				}
			}
			else {
				if (!first) {
					if (!strncmp(s,"ENDBUTTON",strlen("ENDBUTTON"))) {
						width += INTERWIDTH * (Button->ButtonCount - 1);
						twidth += INTERWIDTH * (Button->ButtonCount - 1);
						if (Left) {
							if (width > gh->rightsize) {
								gh->rightsize = width;
							}
							if (twidth > gh->trightsize) {
								gh->trightsize = twidth;
							}
						}
						else {
							if (width > gh->allsize) {
								gh->allsize = width;
							}
							if (twidth > gh->tallsize) {
								gh->tallsize = twidth;
							}
						}
						endfound = 1;
					}
					else {
						pError(gh,GetMessage(MSG_ERR_UNBUT),NULL);
						return;
					}
				}
				else {
					pError(gh,GetMessage(MSG_ERR_FIRSTBUT),NULL);
					while (myfgets(gh)) {
						/* */
					}
				}
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_ENDBSPC),NULL);
			return;
		}
	}
	if (!endfound) {
		pError(gh,GetMessage(MSG_ERR_ENDBEOF),NULL);
	}
}

void
ProcessCycle(struct MPGuiHandle *gh) {
	char *s;
	short endfound = 0;
	short first = 1;
	short StringCount = 0;
	struct MyValue *MyValue;

	gh->CurrentCycle = gh->CurrentGadget;
	gh->CurrentCycleVal = -1;
	while (!endfound && myfgets(gh)) {
		s = SkipSpace(gh->buffer);
		if (s) {
			if (*s == '"') {
				first = 0;
				if (gh->CurrentValue = (struct MyValue *)AllocPooled(gh->MemPool,sizeof(struct MyValue))) {
					AddTail(&gh->CurrentCycle->VList,&gh->CurrentValue->VNode);
					GetCycleTitle(gh);
					GetCycleParameter(gh);
					gh->CurrentValue = NULL;
					++StringCount;
					++gh->CurrentCycleVal;
				}
				else {
					pError(gh,GetMessage(MSG_ERR_NOMEM),NULL);
					gh->OutOfMemory = 1;
					return;
				}
			}
			else {
				if (!first) {
					if (!strncmp(s,"ENDCYCLE",strlen("ENDCYCLE"))) {
						GetDefCycle(gh);
						endfound = 1;
					}
					else {
						ProcessGadget(gh);
					}
				}
				else {
					pError(gh,GetMessage(MSG_ERR_FIRSTCYC),NULL);
					while (myfgets(gh)) {
						/* */
					}
				}
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_ENDCSPC),NULL);
			return;
		}
	}
	if (!endfound) {
		pError(gh,GetMessage(MSG_ERR_ENDCEOF),NULL);
	}
	if (gh->ptr = gh->CurrentCycle->VStrings = (STRPTR *)AllocPooled(gh->MemPool,sizeof(STRPTR)*(StringCount+1))) {
		for (MyValue = (struct MyValue *)gh->CurrentCycle->VList.lh_Head;
				MyValue->VNode.ln_Succ;
				MyValue = (struct MyValue *)MyValue->VNode.ln_Succ) {
			*(gh->ptr) = MyValue->VNode.ln_Name;
			(gh->ptr)++;
		}
		gh->CurrentCycle->Numbery = StringCount;
	}
	else {
		pError(gh,GetMessage(MSG_ERR_NOMEM),NULL);
		gh->OutOfMemory = 1;
		return;
	}
	gh->CurrentCycle = NULL;
}

void
ProcessList(struct MPGuiHandle *gh) {
	char *s;
	short endfound = 0;
	short first = 1;
	short StringCount = 0;

	while (!endfound && myfgets(gh)) {
		s = SkipSpace(gh->buffer);
		if (s) {
			if (*s == '"') {
				first = 0;
				if (gh->CurrentValue = (struct MyValue *)AllocPooled(gh->MemPool,sizeof(struct MyValue))) {
					AddTail(&gh->CurrentGadget->VList,&gh->CurrentValue->VNode);
					GetListTitle(gh);
					GetListParameter(gh);
					gh->CurrentValue = NULL;
					++StringCount;
				}
				else {
					pError(gh,GetMessage(MSG_ERR_NOMEM),NULL);
					gh->OutOfMemory = 1;
					return;
				}
			}
			else {
				if (!first) {
					if (!strncmp(s,"ENDLIST",strlen("ENDLIST"))) {
						GetDefList(gh);
						GetDefLines(gh);
						endfound = 1;
					}
				}
				else {
					pError(gh,GetMessage(MSG_ERR_FIRSTLIST),NULL);
					while (myfgets(gh)) {
						/* */
					}
				}
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_ENDLSPC),NULL);
			return;
		}
	}
	if (!endfound) {
		pError(gh,GetMessage(MSG_ERR_ENDLEOF),NULL);
	}
	gh->CurrentGadget->Numbery = StringCount;
}

void
ProcessMList(struct MPGuiHandle *gh) {
	char *s;
	short endfound = 0;
	short first = 1;
	short StringCount = 0;

	while (!endfound && myfgets(gh)) {
		s = SkipSpace(gh->buffer);
		if (s) {
			if (*s == '"') {
				first = 0;
				if (gh->CurrentValue = (struct MyValue *)AllocPooled(gh->MemPool,sizeof(struct MyValue))) {
					AddTail(&gh->CurrentGadget->VList,&gh->CurrentValue->VNode);
					GetListTitle(gh);
					GetListParameter(gh);
					GetListNParameter(gh);
					gh->CurrentValue = NULL;
					++StringCount;
				}
				else {
					pError(gh,GetMessage(MSG_ERR_NOMEM),NULL);
					gh->OutOfMemory = 1;
					return;
				}
			}
			else {
				if (!first) {
					if (!strncmp(s,"ENDMLIST",strlen("ENDMLIST"))) {
						GetDefMList(gh);
						GetDefLines(gh);
						endfound = 1;
					}
				}
				else {
					pError(gh,GetMessage(MSG_ERR_FIRSTLIST),NULL);
					while (myfgets(gh)) {
						/* */
					}
				}
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_ENDLSPC),NULL);
			return;
		}
	}
	if (!endfound) {
		pError(gh,GetMessage(MSG_ERR_ENDLEOF),NULL);
	}
	gh->CurrentGadget->Numbery = StringCount;
}

void
GetTitle(BOOL SetLeft,struct MPGuiHandle *gh) {
	char *s;
	int temp;

	gh->CurrentPos = strchr(gh->buffer,'"');
	if (gh->CurrentPos) {
		s = gh->CurrentPos + 1;
		gh->CurrentPos = strchr(s,'"');
		if (gh->CurrentPos) {
			*gh->CurrentPos = 0;
			gh->CurrentGadget->Title = mystrdup(gh,s);
			if (SetLeft) {
				temp = TextLength(&(gh->MyScreen->RastPort),s,strlen(s));
				if (temp > gh->leftsize) {
					gh->leftsize = temp;
				}
				temp = strlen(s) * 8;
				if (temp > gh->tleftsize) {
					gh->tleftsize = temp;
				}
			}
			s = strchr(gh->CurrentGadget->Title,'_');
			if (s) {
				char c;
				++s;
				c = gh->CurrentGadget->Char = toupper(*s);
				if (c == OKCHAR) {
					gh->NoOk = TRUE;
				}
				if (c == USECHAR) {
					gh->NoUse = TRUE;
				}
				if (c == SAVECHAR) {
					gh->NoSave = TRUE;
				}
				if (c == CANCELCHAR) {
					gh->NoCancel = TRUE;
				}
			}
			++(gh->CurrentPos);
		}
		else {
			pError(gh,GetMessage(MSG_ERR_TEQ),NULL);
		}
	}
	else {
		pError(gh,GetMessage(MSG_ERR_TSQ),NULL);
	}
}

void
GetParameter(struct MPGuiHandle *gh) {
	char *s;
	if (gh->CurrentPos) {
		gh->CurrentPos = strchr(gh->CurrentPos,'"');
		if (gh->CurrentPos) {
			s = gh->CurrentPos + 1;
			gh->CurrentPos = strchr(s,'"');
			if (gh->CurrentPos) {
				*(gh->CurrentPos) = 0;
				gh->CurrentGadget->Prefix = mystrdup(gh,s);
				++(gh->CurrentPos);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_PEQ),NULL);
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_PSQ),NULL);
		}
	}
}

void
GetNParameter(struct MPGuiHandle *gh) {
	char *s;
	if (gh->CurrentPos) {
		s = strchr(gh->CurrentPos,'"');
		if (s) {
			gh->CurrentPos = s;
			s = gh->CurrentPos + 1;
			gh->CurrentPos = strchr(s,'"');
			if (gh->CurrentPos) {
				*(gh->CurrentPos) = 0;
				gh->CurrentGadget->NPrefix = mystrdup(gh,s);
				++(gh->CurrentPos);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_NPEQ),NULL);
			}
		}
	}
}

void
GetStringDefault(struct MPGuiHandle *gh) {
	char *s;
	if (gh->CurrentPos) {
		gh->CurrentPos = strchr(gh->CurrentPos,'"');
		if (gh->CurrentPos) {
			s = gh->CurrentPos + 1;
			gh->CurrentPos = strchr(s,'"');
			if (gh->CurrentPos) {
				*(gh->CurrentPos) = 0;
				gh->CurrentGadget->Defaults = mystrdup(gh,s);
				++(gh->CurrentPos);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_DEFEQ),NULL);
			}
		}
		else {
			gh->CurrentGadget->Defaults = (char *)"";
		}
	}
	else {
		gh->CurrentGadget->Defaults = (char *)"";
	}
}

void
GetNumberDefault(struct MPGuiHandle *gh) {
	char *s;
	long number;
	if (gh->CurrentPos) {
		gh->CurrentPos = strchr(gh->CurrentPos,'"');
		if (gh->CurrentPos) {
			s = gh->CurrentPos + 1;
			gh->CurrentPos = strchr(s,'"');
			if (gh->CurrentPos) {
				*(gh->CurrentPos) = 0;
				number = strtol(s,&(gh->CurrentPos),10);
				gh->CurrentGadget->Defaultn = number;
				++(gh->CurrentPos);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_DEFEQ),NULL);
			}
		}
		else {
			number = 0;
			gh->CurrentGadget->Defaultn = number;
		}
	}
	else {
		number = 0;
		gh->CurrentGadget->Defaultn = number;
	}
}

void
GetCheckDefault(struct MPGuiHandle *gh) {
	char *s;
	short Check;
	if (gh->CurrentPos) {
		s = strpbrk(gh->CurrentPos,"YN");
		if (s && *s) {
			if (*s == 'Y') {
				Check = 1;
				gh->CurrentGadget->Defaultc = Check;
			}
			else {
				Check = 0;
				gh->CurrentGadget->Defaultc = Check;
			}
		}
		else {
			Check = 0;
			gh->CurrentGadget->Defaultc = Check;
		}
	}
	else {
		Check = 0;
		gh->CurrentGadget->Defaultc = Check;
	}
	gh->CurrentGadget->Currentc = gh->CurrentGadget->Defaultc;
}

void
GetDefCycle(struct MPGuiHandle *gh) {
	char *s;
	long number=0;
	long i;
	struct MyValue *MyValue;

	gh->CurrentPos = strchr(gh->buffer,'"');
	if (gh->CurrentPos) {
		s = gh->CurrentPos + 1;
		gh->CurrentPos = strchr(s,'"');
		if (gh->CurrentPos) {
			*(gh->CurrentPos) = 0;
			if (isdigit(*s)) {
				number = strtol(s,&(gh->CurrentPos),10);
			}
			else {
				i = 0;
				for (MyValue = (struct MyValue *)(gh->CurrentCycle->VList.lh_Head);
						MyValue->VNode.ln_Succ;
						MyValue = (struct MyValue *)(MyValue->VNode.ln_Succ)){
					if (!strcmp(s,MyValue->VNode.ln_Name)) {
						number = i;
					}
					++i;
				}
			}
			gh->CurrentCycle->Defaulty = number;
			++(gh->CurrentPos);
		}
		else {
			pError(gh,GetMessage(MSG_ERR_DEFEQ),NULL);
		}
	}
	else {
		number = 0;
		gh->CurrentCycle->Defaulty = number;
	}
	gh->CurrentCycle->Currenty = gh->CurrentCycle->Defaulty;
}

void
GetDefList(struct MPGuiHandle *gh) {
	char *s;
	long number=0;
	long i;
	struct MyValue *MyValue;

	gh->CurrentPos = strchr(gh->buffer,'"');
	if (gh->CurrentPos) {
		s = gh->CurrentPos + 1;
		gh->CurrentPos = strchr(s,'"');
		if (gh->CurrentPos) {
			*(gh->CurrentPos) = 0;
			if (isdigit(*s)) {
				number = strtol(s,&(gh->CurrentPos),10);
			}
			else {
				i = 0;
				for (MyValue = (struct MyValue *)(gh->CurrentGadget->VList.lh_Head);
						MyValue->VNode.ln_Succ;
						MyValue = (struct MyValue *)(MyValue->VNode.ln_Succ)){
					if (!strcmp(s,MyValue->VNode.ln_Name)) {
						number = i;
					}
					++i;
				}
			}
			gh->CurrentGadget->Defaulty = number;
			++(gh->CurrentPos);
		}
		else {
			pError(gh,GetMessage(MSG_ERR_DEFEQ),NULL);
		}
	}
	else {
		number = 0;
		gh->CurrentGadget->Defaulty = number;
	}
	gh->CurrentGadget->Currenty = gh->CurrentGadget->Defaulty;
}

void
GetDefMList(struct MPGuiHandle *gh) {
	char *s;
	struct MyValue *MyValue;

	gh->CurrentPos = strchr(gh->buffer,'"');
	if (gh->CurrentPos) {
		s = gh->CurrentPos + 1;
		gh->CurrentPos = strchr(s,'"');
		if (gh->CurrentPos) {
			*(gh->CurrentPos) = 0;
			gh->CurrentGadget->Defaults = mystrdup(gh,s);
			for (MyValue = (struct MyValue *)(gh->CurrentGadget->VList.lh_Head);
					MyValue->VNode.ln_Succ;
					MyValue = (struct MyValue *)(MyValue->VNode.ln_Succ)){
				if (strstr(s,MyValue->VNode.ln_Name)) {
					MyValue->Selected = TRUE;
				}
			}
			++(gh->CurrentPos);
		}
		else {
			pError(gh,GetMessage(MSG_ERR_DEFEQ),NULL);
		}
	}
	else {
		gh->CurrentGadget->Defaults = "";
	}
}

void
GetDefLines(struct MPGuiHandle *gh) {
	char *s;

	if (gh->CurrentPos) {
		gh->CurrentPos = strchr(gh->CurrentPos,'"');
		if (gh->CurrentPos) {
			s = gh->CurrentPos + 1;
			gh->CurrentPos = strchr(s,'"');
			if (gh->CurrentPos) {
				*(gh->CurrentPos) = 0;
				if (isdigit(*s)) {
					gh->CurrentGadget->Lines = strtol(s,&(gh->CurrentPos),10);
				}
				else {
					pError(gh,GetMessage(MSG_ERR_INVLL),NULL);
				}
				++(gh->CurrentPos);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_LEQ),NULL);
			}
		}
		else {
			gh->CurrentGadget->Lines = 4;
		}
	}
	else {
		gh->CurrentGadget->Lines = 4;
	}
}

void
GetCycleTitle(struct MPGuiHandle *gh) {
	char *s;
	int temp;
	gh->CurrentPos = strchr(gh->buffer,'"');
	if (gh->CurrentPos) {
		s = gh->CurrentPos + 1;
		gh->CurrentPos = strchr(s,'"');
		if (gh->CurrentPos) {
			*(gh->CurrentPos) = 0;
			gh->CurrentValue->VNode.ln_Name = mystrdup(gh,s);
			temp = TextLength(&(gh->MyScreen->RastPort),s,strlen(s))+(GADGETWIDTH+INTERWIDTH);
			if (temp > gh->rightsize) {
				gh->rightsize = temp;
			}
			temp = 8*strlen(s) + (GADGETWIDTH + INTERWIDTH);
			if (temp > gh->trightsize) {
				gh->trightsize = temp;
			}
			++(gh->CurrentPos);
		}
		else {
			pError(gh,GetMessage(MSG_ERR_CYCLEVEQ),NULL);
		}
	}
	else {
		pError(gh,GetMessage(MSG_ERR_CYCLEVSQ),NULL);
	}
}

void
GetCycleParameter(struct MPGuiHandle *gh) {
	char *s;
	if (gh->CurrentPos) {
		gh->CurrentPos = strchr(gh->CurrentPos,'"');
		if (gh->CurrentPos) {
			s = gh->CurrentPos + 1;
			gh->CurrentPos = strchr(s,'"');
			if (gh->CurrentPos) {
				*(gh->CurrentPos) = 0;
				gh->CurrentValue->Prefix = mystrdup(gh,s);
				++(gh->CurrentPos);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_CYCLEPEQ),NULL);
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_CYCLEPSQ),NULL);
		}
	}
}

void
GetListTitle(struct MPGuiHandle *gh) {
	char *s;
	int temp;
	gh->CurrentPos = strchr(gh->buffer,'"');
	if (gh->CurrentPos) {
		s = gh->CurrentPos + 1;
		gh->CurrentPos = strchr(s,'"');
		if (gh->CurrentPos) {
			*(gh->CurrentPos) = 0;
			gh->CurrentValue->VNode.ln_Name = mystrdup(gh,s);
			temp = TextLength(&(gh->MyScreen->RastPort),s,strlen(s))+(GADGETWIDTH+INTERWIDTH);
			if (temp > gh->rightsize) {
				gh->rightsize = temp;
			}
			temp = 8*strlen(s) + (GADGETWIDTH + INTERWIDTH);
			if (temp > gh->trightsize) {
				gh->trightsize = temp;
			}
			++(gh->CurrentPos);
		}
		else {
			pError(gh,GetMessage(MSG_ERR_LISTVEQ),NULL);
		}
	}
	else {
		pError(gh,GetMessage(MSG_ERR_LISTVSQ),NULL);
	}
}

void
GetListParameter(struct MPGuiHandle *gh) {
	char *s;
	if (gh->CurrentPos) {
		gh->CurrentPos = strchr(gh->CurrentPos,'"');
		if (gh->CurrentPos) {
			s = gh->CurrentPos + 1;
			gh->CurrentPos = strchr(s,'"');
			if (gh->CurrentPos) {
				*(gh->CurrentPos) = 0;
				gh->CurrentValue->Prefix = mystrdup(gh,s);
				++(gh->CurrentPos);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_MLISTVPE),NULL);
			}
		}
		else {
			pError(gh,GetMessage(MSG_ERR_MLISTVPS),NULL);
		}
	}
}

void
GetListNParameter(struct MPGuiHandle *gh) {
	char *s;
	if (gh->CurrentPos) {
		s = strchr(gh->CurrentPos,'"');
		if (s) {
			gh->CurrentPos = s;
			s = gh->CurrentPos + 1;
			gh->CurrentPos = strchr(s,'"');
			if (gh->CurrentPos) {
				*(gh->CurrentPos) = 0;
				gh->CurrentValue->NPrefix = mystrdup(gh,s);
				++(gh->CurrentPos);
			}
			else {
				pError(gh,GetMessage(MSG_ERR_MLISTENQ),NULL);
			}
		}
	}
}

void
GetHelp(struct MPGuiHandle *gh) {
	char *s;
	if (gh->CurrentPos) {
		gh->CurrentPos = strchr(gh->CurrentPos,'!');
		if (gh->CurrentPos) {
			s = gh->CurrentPos + 1;
			gh->CurrentPos = strchr(s,'!');
			if (gh->CurrentPos) {
				*(gh->CurrentPos) = 0;
				gh->CurrentGadget->HelpNode = mystrdup(gh,s);
				++(gh->CurrentPos);
				if (*gh->CurrentPos) {
					s = gh->CurrentPos;
					gh->CurrentPos = strchr(s,'!');
					if (gh->CurrentPos) {
						*(gh->CurrentPos) = 0;
						gh->CurrentGadget->HelpMessage = mystrdup(gh,s);
						gh->HelpMessageB = TRUE;
						++(gh->CurrentPos);
					}
					else {
						pError(gh,GetMessage(MSG_ERR_ENDMP),NULL);
					}
				}
			}
			else {
				pError(gh,GetMessage(MSG_ERR_ENDNP),NULL);
			}
		}
	}
}

char
*SkipSpace(char *s) {
	while (s && *s && ((*s == ' ') || (*s == '\t'))) {
		++s;
	}
	return s;
}

#define USEROK			((struct MyGadgetPtr *)(-1))
#define USERSAVE		USEROK
#define USERCANCEL	((struct MyGadgetPtr *)(-2))
#define USERHELP		((struct MyGadgetPtr *)(-3))
#define USERUSE		((struct MyGadgetPtr *)(-4))
#define USERMESSAGE	((struct MyGadgetPtr *)(-5))

void
RequesterStuff(struct MPGuiHandle *gh) {
	struct MyGadgetPtr *Ptr=0;
	struct MyGadget *MyGadget=0,*LoopGadget;
	struct MyValue *val;
	short notdone = 1;
	LONG left=0;
	LONG top=0;
	BOOL relmouse=FALSE;
	BOOL doit;
	struct TagItem *tag;
	struct MyGadget *HelpGadget=NULL,*oldHelpGadget=(struct MyGadget *)-1;
	ULONG Signals;
	char *p;
	char *HelpMessage;
	int i;

	if (gh->VisInfo = GetVisualInfo(gh->MyScreen,NULL)) {
		if (CreateContext(&(gh->Context))) {
			if (CreateGadgets(gh)) {
				if (tag = FindTagItem(MPG_RELMOUSE,gh->TagList)) {
					if (tag->ti_Data) {
						relmouse = TRUE;
						left = gh->MyScreen->MouseX - gh->width/2;
						if (left < 0) {
							left = 0;
						}
						top = gh->MyScreen->MouseY - gh->height/2;
						if (top < 0) {
							top = 0;
						}
					}
				}
				gh->Zoom[0] = (USHORT)~0;
				gh->Zoom[1] = (USHORT)~0;
				gh->Zoom[2] = gh->TitleLength + (GADGETWIDTH * 3 + INTERWIDTH);
				gh->Zoom[3] = gh->MyScreen->WBorTop + gh->MyScreen->Font->ta_YSize + 1;
				if (gh->Window = OpenWindowTags(NULL,
				  	 WA_Flags,  	WFLG_DRAGBAR|
		  		               	WFLG_DEPTHGADGET|
     				          		WFLG_CLOSEGADGET|
        			 	     	  		WFLG_SMART_REFRESH|
           		    		  		WFLG_ACTIVATE,
			   	 WA_IDCMP,   	BUTTONIDCMP|
			   	 					CHECKBOXIDCMP|
			   	 					INTEGERIDCMP|
			   	 					CYCLEIDCMP|
			   	 					SLIDERIDCMP|
			   	 					STRINGIDCMP|
			   	 					LISTVIEWIDCMP|
					             	IDCMP_CLOSEWINDOW|
  	   	   	 	         	IDCMP_VANILLAKEY|
  	   	   	 	         	IDCMP_RAWKEY|
  	   	   	 	         	IDCMP_REFRESHWINDOW|
  	   	   	 	         	IDCMP_GADGETHELP|
  	   	   	 	         	(gh->MenuFunc?IDCMP_MENUPICK:0)|
  	   	   	 	         	((gh->MenuFunc&&gh->HelpFunc)?IDCMP_MENUHELP:0),
		  			 WA_Width,   	gh->width,
		      	 WA_Height,  	gh->height,
					 WA_Title,		gh->Comment,
					 WA_AutoAdjust,TRUE,
					 WA_PubScreen,	gh->MyScreen,
					 WA_Gadgets,	gh->Context,
					 WA_Zoom, 		gh->Zoom,
					 relmouse?WA_Left:TAG_IGNORE,	left,
					 relmouse?WA_Top:TAG_IGNORE,	top,
					 WA_MenuHelp,	gh->HelpFunc?TRUE:FALSE,
					 WA_NewLookMenus,TRUE,
					 gh->Check ? WA_Checkmark: TAG_IGNORE,	gh->Check,
					 gh->Amiga ? WA_AmigaKey : TAG_IGNORE,	gh->Amiga,
					 TAG_END)) {
					// Enable gadget Help
					HelpControl(gh->Window,HC_GADGETHELP);
					if (gh->NewMenu) {
						if (gh->Menu = CreateMenus( gh->NewMenu, TAG_DONE )) {
							LayoutMenus( gh->Menu, gh->VisInfo, 
											GTMN_NewLookMenus,TRUE,
											gh->Check ? GTMN_Checkmark : TAG_IGNORE, gh->Check,
											gh->Amiga ? GTMN_AmigaKey : TAG_IGNORE, gh->Amiga,
											TAG_DONE );
							SetMenuStrip( gh->Window, gh->Menu);
						}
					}
					GT_RefreshWindow(gh->Window,NULL);
					if (gh->CHelp && gh->HelpFunc) {
						if (gh->HelpNode) {
							MyCallHookPkt(gh,gh->HelpFunc,gh->HelpNode,NULL);
						}
					}
					while (notdone) {
					 Signals = Wait((1L << gh->Window->UserPort->mp_SigBit) |
					 					 (gh->Signals));
					 if (Signals & gh->Signals) {
						if (gh->SignalFunc) {
							notdone = MyCallHookPkt(gh,gh->SignalFunc,(APTR)Signals,NULL);
							if (!notdone) {
								gh->result[0] = 0;
							}
						}
					 }
					 else {
						while (gh->IntuiMsg = GT_GetIMsg(gh->Window->UserPort)) {
							switch (gh->IntuiMsg->Class) {
							case IDCMP_MENUPICK:
								if (gh->MenuFunc) {
									notdone = MyCallHookPkt(gh,gh->MenuFunc,gh->IntuiMsg,gh->Menu);
								}
								break;
							case IDCMP_MENUHELP:
								if (gh->MenuFunc && gh->HelpFunc) {
									MyCallHookPkt(gh,gh->MenuFunc,gh->IntuiMsg,gh->Menu);
								}
								break;
							case IDCMP_RAWKEY:
								if (gh->IntuiMsg->Code == 0x5f) {
									if (gh->HelpFunc) {
										if (HelpGadget && HelpGadget->HelpNode) {
											MyCallHookPkt(gh,gh->HelpFunc,HelpGadget->HelpNode,NULL);
										}
										else {
											if (gh->HelpNode) {
												MyCallHookPkt(gh,gh->HelpFunc,gh->HelpNode,NULL);
											}
										}
									}
								}
								break;
							case IDCMP_GADGETHELP:
		 						if (gh->IntuiMsg->IAddress == NULL) {
 									HelpGadget = NULL;
 									HelpMessage = gh->HelpMessage;
 								}
		 						else {
 									if (gh->IntuiMsg->IAddress == gh->Window) {
 										HelpGadget = NULL;
	 									HelpMessage = gh->HelpMessage;
 									}
			 						else {
 										if (!(((struct Gadget *)gh->IntuiMsg->IAddress)->GadgetType & GTYP_SYSGADGET)) {	// Not a system gadget
											Ptr = (struct MyGadgetPtr *)((struct Gadget *)gh->IntuiMsg->IAddress)->UserData;
											if (Ptr == USERSAVE && gh->Prefs) {
												HelpGadget = NULL;
												HelpMessage = GetMessage(MSG_HELPSAVE);
											}
											else if (Ptr == USEROK && !gh->Prefs) {
												HelpGadget = NULL;
												HelpMessage = GetMessage(MSG_HELPOK);
											}
											else if (Ptr == USERUSE) {
												HelpGadget = NULL;
												HelpMessage = GetMessage(MSG_HELPUSE);
											}
											else if (Ptr == USERCANCEL && gh->Prefs) {
												HelpGadget = NULL;
												HelpMessage = GetMessage(MSG_HELPCANCELP);
											}
											else if (Ptr == USERCANCEL && !gh->Prefs) {
												HelpGadget = NULL;
												HelpMessage = GetMessage(MSG_HELPCANCELR);
											}
											else if (Ptr == USERHELP) {
												HelpGadget = NULL;
												HelpMessage = GetMessage(MSG_HELPHELPB);
											}
											else if (Ptr == USERMESSAGE) {
												HelpGadget = NULL;
												HelpMessage = GetMessage(MSG_HELPHELPG);
											}
											else if (Ptr) {
												HelpGadget = Ptr->MyGadget;
												HelpMessage = HelpGadget->HelpMessage;
											}
											else {
												HelpGadget = NULL;
			 									HelpMessage = gh->HelpMessage;
											}
 										}
 										else {
					 						switch (((struct Gadget *)gh->IntuiMsg->IAddress)->GadgetType & GTYP_SYSTYPEMASK) {
			 								case GTYP_WDRAGGING:
			 									HelpMessage = GetMessage(MSG_HELPDRAG);
		 										break;
			 								case GTYP_WUPFRONT:
			 									HelpMessage = GetMessage(MSG_HELPFRONT);
 												break;
					 						case GTYP_WDOWNBACK:
			 									HelpMessage = GetMessage(MSG_HELPZOOM);
 												break;
			 								case GTYP_CLOSE:
			 									if (gh->Prefs) {
				 									HelpMessage = GetMessage(MSG_HELPCANCELP);
				 								}
				 								else {
													HelpMessage = GetMessage(MSG_HELPCANCELR);
				 								}
			 									break;
			 								default:
			 									HelpMessage = gh->HelpMessage;
 												break;
			 								}
 											HelpGadget = NULL;
 										}
 									}
 								}
 								if (!HelpMessage) {
 									HelpMessage = gh->HelpMessage;
								}
								if (gh->HelpMessageB) {
									GT_SetGadgetAttrs(gh->HelpGadget,gh->Window,NULL,
															GTTX_Text,HelpMessage,
															TAG_END);
								}
 								if (gh->CHelp && gh->HelpFunc) {
 									if (oldHelpGadget != HelpGadget) {
										if (HelpGadget && HelpGadget->HelpNode) {
											MyCallHookPkt(gh,gh->HelpFunc,HelpGadget->HelpNode,NULL);
										}
										else {
											if (gh->HelpNode) {
												MyCallHookPkt(gh,gh->HelpFunc,gh->HelpNode,NULL);
											}
										}
										oldHelpGadget = HelpGadget;
									}
								}
								break;
							case IDCMP_REFRESHWINDOW:
								GT_BeginRefresh(gh->Window);
								GT_EndRefresh(gh->Window,TRUE);
								break;
							case IDCMP_CLOSEWINDOW:
								notdone = 0;
								break;
							case IDCMP_VANILLAKEY:
							case IDCMP_GADGETUP:
								if ((gh->IntuiMsg->Class == IDCMP_GADGETUP) &&
									 (gh->IntuiMsg->Code == 0x5F)) {	// Help key in string
									Ptr = (struct MyGadgetPtr *)((struct Gadget *)gh->IntuiMsg->IAddress)->UserData;
									// Cant be Ok, Help, Cancel, Save, Use
									HelpGadget = Ptr->MyGadget;
									if (gh->HelpFunc) {
										if (HelpGadget && HelpGadget->HelpNode) {
											MyCallHookPkt(gh,gh->HelpFunc,HelpGadget->HelpNode,NULL);
										}
										else {
											if (gh->HelpNode) {
												MyCallHookPkt(gh,gh->HelpFunc,gh->HelpNode,NULL);
											}
										}
									}
									ActivateGadget((struct Gadget *)gh->IntuiMsg->IAddress,gh->Window,NULL);
									doit = FALSE;
								}
								else {
									if (gh->IntuiMsg->Class == IDCMP_VANILLAKEY) {
										doit = FALSE;
										if ((gh->IntuiMsg->Code == 0x1B) && !gh->Prefs) {
											Ptr = USERCANCEL;
											notdone = 0;
										}
										if (!gh->NoButtons) {
											if (!gh->NoOk && (toupper(gh->IntuiMsg->Code) == OKCHAR) && !gh->Prefs) {
												doit = TRUE;
												Ptr = USEROK;
											}
											else if (!gh->NoSave && (toupper(gh->IntuiMsg->Code) == SAVECHAR) && gh->Prefs) {
												doit = TRUE;
												Ptr = USERSAVE;
												gh->Response = MPG_SAVE;
											}
											else if (!gh->NoUse && (toupper(gh->IntuiMsg->Code) == USECHAR) && gh->Prefs) {
												doit = TRUE;
												Ptr = USERUSE;
												gh->Response = MPG_USE;
											}
											else if (!gh->NoCancel && toupper(gh->IntuiMsg->Code) == CANCELCHAR) {
												notdone = 0;
											}
										}
										if (notdone && !doit) {
											for (LoopGadget = (struct MyGadget *)(gh->GList.lh_Head);
													LoopGadget->GNode.ln_Succ;
													LoopGadget = (struct MyGadget *)(LoopGadget->GNode.ln_Succ)) {
												if (toupper(gh->IntuiMsg->Code) == LoopGadget->Char) {
													doit = TRUE;
													Ptr = &(LoopGadget->Ptr1);
												}
											}
										}
									}
									else {
										Ptr = (struct MyGadgetPtr *)((struct Gadget *)gh->IntuiMsg->IAddress)->UserData;
										doit = TRUE;
										if (Ptr == USERSAVE) {
											gh->Response = MPG_SAVE;
										}
										else {
											if (Ptr == USERUSE) {
												gh->Response = MPG_USE;
											}
										}
									}
									if (Ptr == USERCANCEL) {	// Cancel gadget
										notdone = 0;
										doit = FALSE;
									}
									else {
										if (Ptr == USERHELP) {	// Help gadget
											if (gh->HelpFunc && gh->HelpNode) {
												MyCallHookPkt(gh,gh->HelpFunc,gh->HelpNode,NULL);
											}
											doit = FALSE;
										}
									}
								}
								if (((Ptr == USERSAVE) || (Ptr == USERUSE)) && doit) {
									MPGuiCurrentAttrs(gh);
									notdone = 0;
								}
								else {
									if (doit) {
										MyGadget = Ptr->MyGadget;
										if (MyGadget->OwnCycle) {
											if (MyGadget->OwnCycle->Currenty != MyGadget->Activey) {
												doit = FALSE;
											}
										}
									}
									if (doit) {
										switch (MyGadget->Type) {
										case GAD_FILE:
										case GAD_LFILE:
										case GAD_SFILE:
											if ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
												 (!(gh->IntuiMsg->Qualifier & IEQUALIFIER_RSHIFT))) {
												ActivateGadget(MyGadget->Gadget1,gh->Window,NULL);
											}
											else {
												if ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) ||
													 (Ptr->Number == 2)) {
													GT_GetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
															GTST_String,&p,
															TAG_END);
													if (GetAFile(gh,p,
														 (MyGadget->Type == GAD_LFILE)?GetMessage(MSG_SELECTINPUT):
														 (MyGadget->Type == GAD_SFILE)?GetMessage(MSG_SELECTOUTPUT):
														 GetMessage(MSG_SELECTFILE),
														 (MyGadget->Type == GAD_SFILE)?FRF_DOSAVEMODE:0,
														 (MyGadget->Type == GAD_LFILE)?GetMessage(MSG_INPUT):
														 (MyGadget->Type == GAD_SFILE)?GetMessage(MSG_OUTPUT):
														 GetMessage(MSG_SELECT))) {
														GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
															GTST_String,gh->TempFileName,
															TAG_END);
													}
												}
											}
											break;
										case GAD_OFILE:
											if (((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
												  (!(gh->IntuiMsg->Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT)))) ||
												 ((gh->IntuiMsg->Class == IDCMP_GADGETUP) &&
												  (Ptr->Number == 1))) {
												MyGadget->Currentc = !MyGadget->Currentc;
												GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
														GTCB_Checked, MyGadget->Currentc,
														TAG_END);
												GT_SetGadgetAttrs(MyGadget->Gadget2,gh->Window,NULL,
														GA_Disabled,!MyGadget->Currentc,
														TAG_END);
												GT_SetGadgetAttrs(MyGadget->Gadget3,gh->Window,NULL,
														GA_Disabled,!MyGadget->Currentc,
														TAG_END);
												if (MyGadget->Currentc) {
													ActivateGadget(MyGadget->Gadget2,gh->Window,NULL);
												}
											}
											else {
												if ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
													 (gh->IntuiMsg->Qualifier & IEQUALIFIER_LSHIFT)) {
													if (MyGadget->Currentc) {
														ActivateGadget(MyGadget->Gadget2,gh->Window,NULL);
													}
												}
												else {
													if (((gh->IntuiMsg->Class == IDCMP_GADGETUP) &&
													     (Ptr->Number == 3)) ||
													    ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
														  (gh->IntuiMsg->Qualifier & IEQUALIFIER_RSHIFT) &&
														  (MyGadget->Currentc))) {
														GT_GetGadgetAttrs(MyGadget->Gadget2,gh->Window,NULL,
																GTST_String,&p,
																TAG_END);
														if (GetAFile(gh,p,
															 GetMessage(MSG_SELECTFILE),0,GetMessage(MSG_SELECT))) {
															GT_SetGadgetAttrs(MyGadget->Gadget2,gh->Window,NULL,
																GTST_String,gh->TempFileName,
																TAG_END);
														}
													}
												}
											}
											break;
										case GAD_MODE:
											if ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) ||
												  (Ptr->Number == 2)) {
												GT_GetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
														GTTX_Text,&p,
														TAG_END);
												if (GetAMode(gh,MyGadget,p,
														GetMessage(MSG_SELECTMODE))) {
													GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
														GTTX_Text,gh->TempFileName,
														TAG_END);
												}
											}
											break;
										case GAD_OMODE:
										case GAD_OFONT:
											if (((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
												  (!(gh->IntuiMsg->Qualifier & IEQUALIFIER_RSHIFT))) ||
												 ((gh->IntuiMsg->Class == IDCMP_GADGETUP) &&
												  (Ptr->Number == 1))) {
												MyGadget->Currentc = !MyGadget->Currentc;
												GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
														GTCB_Checked, MyGadget->Currentc,
														TAG_END);
												GT_SetGadgetAttrs(MyGadget->Gadget2,gh->Window,NULL,
														GA_Disabled,!MyGadget->Currentc,
														TAG_END);
												GT_SetGadgetAttrs(MyGadget->Gadget3,gh->Window,NULL,
														GA_Disabled,!MyGadget->Currentc,
														TAG_END);
											}
											else {
												if (((gh->IntuiMsg->Class == IDCMP_GADGETUP) &&
												     (Ptr->Number == 3)) ||
												    ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
													  (gh->IntuiMsg->Qualifier & IEQUALIFIER_RSHIFT) &&
													  (MyGadget->Currentc))) {
													GT_GetGadgetAttrs(MyGadget->Gadget2,gh->Window,NULL,
															GTTX_Text,&p,
															TAG_END);
													switch (MyGadget->Type) {
													case GAD_OMODE:
														if (GetAMode(gh,MyGadget,p,
																GetMessage(MSG_SELECTMODE))) {
															GT_SetGadgetAttrs(MyGadget->Gadget2,gh->Window,NULL,
																GTTX_Text,gh->TempFileName,
																TAG_END);
														}
														break;
													case GAD_OFONT:
														if (GetAFont(gh,MyGadget,p,
																GetMessage(MSG_SELECTFONT))) {
															GT_SetGadgetAttrs(MyGadget->Gadget2,gh->Window,NULL,
																GTTX_Text,gh->TempFileName,
																TAG_END);
														}
														break;
													}
												}
											}
											break;
										case GAD_FONT:
											if ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) ||
												  (Ptr->Number == 2)) {
												GT_GetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
														GTTX_Text,&p,
														TAG_END);
												if (GetAFont(gh,MyGadget,p,
														GetMessage(MSG_SELECTFONT))) {
													GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
														GTTX_Text,gh->TempFileName,
														TAG_END);
												}
											}
											break;
										case GAD_ONUMBER:
										case GAD_OSTRING:
											if (((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
												  (!(gh->IntuiMsg->Qualifier & IEQUALIFIER_LSHIFT))) ||
												 ((gh->IntuiMsg->Class == IDCMP_GADGETUP) &&
												  (Ptr->Number == 1))) {
												MyGadget->Currentc = !MyGadget->Currentc;
												GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
														GTCB_Checked, MyGadget->Currentc,
														TAG_END);
												GT_SetGadgetAttrs(MyGadget->Gadget2,gh->Window,NULL,
														GA_Disabled,!MyGadget->Currentc,
														TAG_END);
												if (MyGadget->Currentc) {
													ActivateGadget(MyGadget->Gadget2,gh->Window,NULL);
												}
											}
											else {
												if (gh->IntuiMsg->Class == IDCMP_VANILLAKEY) {
													if (MyGadget->Currentc) {
														ActivateGadget(MyGadget->Gadget2,gh->Window,NULL);
													}
												}
											}
											break;
										case GAD_NUMBER:
										case GAD_STRING:
											if (gh->IntuiMsg->Class == IDCMP_VANILLAKEY) {
												ActivateGadget(MyGadget->Gadget1,gh->Window,NULL);
											}
											break;
										case GAD_LIST:
											if ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
												 (gh->IntuiMsg->Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))) {
												if (!MyGadget->Currenty) {
													MyGadget->Currenty = MyGadget->Numbery - 1;
												}
												else {
													MyGadget->Currenty -= 1;
												}
											}
											else {
												if (gh->IntuiMsg->Class == IDCMP_VANILLAKEY) {
													++MyGadget->Currenty;
													if (MyGadget->Currenty == MyGadget->Numbery) {
														MyGadget->Currenty = 0;
													}
												}
												else {
													MyGadget->Currenty = gh->IntuiMsg->Code;
												}
											}
											GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
															GTLV_Selected, MyGadget->Currenty,
															GTLV_MakeVisible, MyGadget->Currenty,
															TAG_END);
											break;
										case GAD_MLIST:
											if ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
												 !(gh->IntuiMsg->Qualifier & IEQUALIFIER_RSHIFT)) {
												if (gh->IntuiMsg->Qualifier & IEQUALIFIER_LSHIFT) {
													if (!MyGadget->Currenty) {
														MyGadget->Currenty = MyGadget->Numbery - 1;
													}
													else {
														MyGadget->Currenty -= 1;
													}
												}
												else {
													++MyGadget->Currenty;
													if (MyGadget->Currenty == MyGadget->Numbery) {
														MyGadget->Currenty = 0;
													}
												}
												GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
															GTLV_Selected, MyGadget->Currenty,
															GTLV_MakeVisible, MyGadget->Currenty,
															TAG_END);
											}
											else {
												GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
																GTLV_Labels, -1,
																TAG_END);
												if (gh->IntuiMsg->Class != IDCMP_VANILLAKEY) {
													MyGadget->Currenty = gh->IntuiMsg->Code;
												}
												val = (struct MyValue *)MyGadget->VList.lh_Head;
												for (i=0; (i < MyGadget->Currenty); i++) {
													val = (struct MyValue *)val->VNode.ln_Succ;
												}
												if (val->Selected) {
													val->Selected = FALSE;
												}
												else {
													val->Selected = TRUE;
												}
												GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
																GTLV_Labels,	&(MyGadget->VList),
																GTLV_Selected, MyGadget->Currenty,
																TAG_END);
											}
											break;
										case GAD_CYCLE:
											if ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
												 (gh->IntuiMsg->Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))) {
												if (!MyGadget->Currenty) {
													MyGadget->Currenty = MyGadget->Numbery - 1;
												}
												else {
													MyGadget->Currenty -= 1;
												}
											}
											else {
												if (gh->IntuiMsg->Class == IDCMP_VANILLAKEY) {
													++MyGadget->Currenty;
													if (MyGadget->Currenty == MyGadget->Numbery) {
														MyGadget->Currenty = 0;
													}
												}
												else {
													MyGadget->Currenty = gh->IntuiMsg->Code;
												}
											}
											GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
														GTCY_Active, MyGadget->Currenty,
														TAG_END);
											for (LoopGadget = (struct MyGadget *)(gh->GList.lh_Head);
													LoopGadget->GNode.ln_Succ;
													LoopGadget = (struct MyGadget *)(LoopGadget->GNode.ln_Succ)){
												if (MyGadget == LoopGadget->OwnCycle) {
													GT_SetGadgetAttrs(LoopGadget->Gadget1,gh->Window,NULL,
															GA_Disabled,MyGadget->Currenty != LoopGadget->Activey,
															TAG_END);
													if (LoopGadget->Gadget2) {
														GT_SetGadgetAttrs(LoopGadget->Gadget2,gh->Window,NULL,
																GA_Disabled,(MyGadget->Currenty != LoopGadget->Activey) ||
																				(((LoopGadget->Type == GAD_ONUMBER) ||
																				  (LoopGadget->Type == GAD_OSTRING) ||
																				  (LoopGadget->Type == GAD_OFILE)) && (!LoopGadget->Currentc)),
																TAG_END);
													}
													if (LoopGadget->Gadget3) {
														GT_SetGadgetAttrs(LoopGadget->Gadget3,gh->Window,NULL,
																GA_Disabled,(MyGadget->Currenty != LoopGadget->Activey) ||
																				  (((LoopGadget->Type == GAD_OFILE) ||
																				    (LoopGadget->Type == GAD_OFONT) ||
																				    (LoopGadget->Type == GAD_OMODE)) && (!LoopGadget->Currentc)),
																TAG_END);
													}
												}
											}
											break;
										case GAD_CHECK:
											MyGadget->Currentc = !MyGadget->Currentc;
											GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
													GTCB_Checked, MyGadget->Currentc,
													TAG_END);
											break;
										case GAD_SLIDER:
											if ((gh->IntuiMsg->Class == IDCMP_VANILLAKEY) &&
												 (gh->IntuiMsg->Qualifier & (IEQUALIFIER_LSHIFT | IEQUALIFIER_RSHIFT))) {
												if (MyGadget->Currentn > MyGadget->Minn) {
													MyGadget->Currentn -= 1;
												}
											}
											else {
												if (gh->IntuiMsg->Class == IDCMP_VANILLAKEY) {
													if (MyGadget->Currentn < MyGadget->Maxn) {
														MyGadget->Currentn += 1;
													}
												}
												else {
													MyGadget->Currentn = gh->IntuiMsg->Code;
												}
											}
											GT_SetGadgetAttrs(MyGadget->Gadget1,gh->Window,NULL,
														GTSL_Level, MyGadget->Currentn,
														TAG_END);
											break;
										case GAD_BUTTON:
											if (gh->ButtonFunc) {
												notdone = MyCallHookPkt(gh,gh->ButtonFunc,gh,(APTR)MyGadget->ButtonNo);
											}
											break;
										}
									}
								}
								break;
							default:
								break;
							}
							GT_ReplyIMsg(gh->IntuiMsg);
						}
					 }
					}
					if (gh->Menu) {
						ClearMenuStrip(gh->Window);
						FreeMenus(gh->Menu);
					}
					CloseWindow(gh->Window);
				}
			}
			FreeGadgets(gh->Context);
		}
		FreeVisualInfo(gh->VisInfo);
	}
}

/* Creates all the gadgets for a requester
 * Returns:		TRUE if everything worked
 */
BOOL
CreateGadgets(struct MPGuiHandle *gh) {
	struct MyGadget *MyGadget;
	struct Gadget *Gadget;
	struct NewGadget NewGadget = {
		0,0,
		0,0,
		NULL,
		NULL,
		PLACETEXT_IN,
		NULL,
		NULL
	};
	int CancelSize;
	int temp;
	int tleft = 0;
	BOOL InButton = FALSE;
	int ButtonNo = 0;	// Number of this gadget in ButtonText
	long ButtonWidth = 0;	// Set to get fixed width buttons

	if (gh->UseTopaz) {
		CancelSize = gh->XSize*strlen(GetMessage(MSG__CANCEL));
	}
	else {
		CancelSize = TextLength(&(gh->MyScreen->RastPort),GetMessage(MSG__CANCEL),strlen(GetMessage(MSG__CANCEL)));
	}
	if ((CancelSize + (gh->interwidth)) > gh->rightsize) {
		gh->rightsize = CancelSize+gh->interwidth;
	}
	if ((CancelSize) > gh->leftsize) {
		gh->leftsize = CancelSize;
	}
	if ((gh->HelpFunc && gh->HelpNode) || (gh->Prefs)) {
		if (((CancelSize + (gh->interwidth))*2) > gh->rightsize) {
			gh->rightsize = (CancelSize+gh->interwidth)*2;
		}
	}
	gh->width = gh->leftsize + gh->rightsize + (gh->interwidth * 2) +
			  gh->MyScreen->WBorLeft + gh->MyScreen->WBorRight;
	if ((gh->TitleLength + (GADGETWIDTH * 3 + gh->interwidth)) > gh->width) {
		gh->width = gh->TitleLength + (GADGETWIDTH * 3 + gh->interwidth);
		temp = gh->width - gh->leftsize - gh->rightsize - (gh->interwidth * 2) -
				 gh->MyScreen->WBorLeft - gh->MyScreen->WBorRight;
		gh->leftsize += temp/2;
		gh->rightsize += temp/2;
	}
	Gadget = gh->Context;
	gh->height = gh->MyScreen->WBorTop + gh->MyScreen->Font->ta_YSize + 1;
	NewGadget.ng_Height = gh->MyTextAttr->ta_YSize + 4;
	NewGadget.ng_VisualInfo = gh->VisInfo;
	NewGadget.ng_TextAttr = gh->MyTextAttr;
	NewGadget.ng_Flags = PLACETEXT_LEFT;
	if (gh->HelpMessageB) {
		gh->height += gh->interheight;
		NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth;
		NewGadget.ng_Width = gh->rightsize + gh->leftsize;
		NewGadget.ng_TopEdge = gh->height;
		NewGadget.ng_UserData = (APTR)USERMESSAGE;
		gh->HelpGadget = Gadget = CreateGadget(TEXT_KIND,Gadget,&NewGadget,
										GTTX_Text, gh->HelpMessage,
										GTTX_Border, TRUE,
										TAG_END);
		gh->height += gh->MyTextAttr->ta_YSize + 2;
	}
	for (MyGadget = (struct MyGadget *)gh->GList.lh_Head;
			MyGadget->GNode.ln_Succ && Gadget;
			MyGadget = (struct MyGadget *)MyGadget->GNode.ln_Succ) {
		if (InButton &&
			 (MyGadget->Type != GAD_BUTTON)) {
			gh->height += gh->MyTextAttr->ta_YSize + 2;
			InButton = FALSE;
		}
		if (!InButton) {
			gh->height += gh->interheight;
		}
		NewGadget.ng_TopEdge = gh->height;
		switch (MyGadget->Type) {
		case GAD_FILE:
		case GAD_LFILE:
		case GAD_SFILE:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = gh->rightsize - (gh->interwidth/2 + GADGETWIDTH);
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(STRING_KIND,Gadget,&NewGadget,
										GTST_String, MyGadget->Defaults,
										GTST_MaxChars, 256,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										STRINGA_ExitHelp, TRUE,
										TAG_END);
			NewGadget.ng_LeftEdge += NewGadget.ng_Width + gh->interwidth/2;
			MyGadget->Ptr2.MyGadget = MyGadget;
			MyGadget->Ptr2.Number = 2;
			NewGadget.ng_UserData = &(MyGadget->Ptr2);
			NewGadget.ng_Width = GADGETWIDTH;
			NewGadget.ng_Flags = PLACETEXT_IN;
			NewGadget.ng_GadgetText = (char *)"«";
			MyGadget->Gadget2 = Gadget = CreateGadget(BUTTON_KIND,Gadget,&NewGadget,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										TAG_END);
			NewGadget.ng_Flags = PLACETEXT_LEFT;
			break;
		case GAD_MODE:
		case GAD_FONT:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = gh->rightsize - (gh->interwidth/2 + GADGETWIDTH);
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(TEXT_KIND,Gadget,&NewGadget,
										GTTX_Text, MyGadget->Defaults,
										GTTX_Border, TRUE,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										TAG_END);
			NewGadget.ng_LeftEdge += NewGadget.ng_Width + gh->interwidth/2;
			MyGadget->Ptr2.MyGadget = MyGadget;
			MyGadget->Ptr2.Number = 2;
			NewGadget.ng_UserData = &(MyGadget->Ptr2);
			NewGadget.ng_Width = GADGETWIDTH;
			NewGadget.ng_Flags = PLACETEXT_IN;
			NewGadget.ng_GadgetText = (char *)"«";
			MyGadget->Gadget2 = Gadget = CreateGadget(BUTTON_KIND,Gadget,&NewGadget,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										TAG_END);
			NewGadget.ng_Flags = PLACETEXT_LEFT;
			break;
		case GAD_OMODE:
		case GAD_OFONT:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = GADGETWIDTH;
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(CHECKBOX_KIND,Gadget,&NewGadget,
										GTCB_Checked, MyGadget->Currentc,
										GTCB_Scaled, TRUE,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										TAG_END);
			MyGadget->Ptr2.MyGadget = MyGadget;
			MyGadget->Ptr2.Number = 2;
			NewGadget.ng_UserData = &(MyGadget->Ptr2);
			NewGadget.ng_LeftEdge += gh->interwidth/2 + GADGETWIDTH;
			NewGadget.ng_Width = gh->rightsize - ((gh->interwidth/2 + GADGETWIDTH) * 2);
			NewGadget.ng_GadgetText = NULL;
			MyGadget->Gadget2 = Gadget = CreateGadget(TEXT_KIND,Gadget,&NewGadget,
										GTTX_Text, MyGadget->Defaults,
										GTTX_Border, TRUE,
										GA_Disabled,MyGadget->Currentc ? (MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE) : TRUE,
										GT_Underscore, '_',
										TAG_END);
			NewGadget.ng_LeftEdge += NewGadget.ng_Width + gh->interwidth/2;
			MyGadget->Ptr3.MyGadget = MyGadget;
			MyGadget->Ptr3.Number = 3;
			NewGadget.ng_UserData = &(MyGadget->Ptr3);
			NewGadget.ng_Width = GADGETWIDTH;
			NewGadget.ng_Flags = PLACETEXT_IN;
			NewGadget.ng_GadgetText = (char *)"«";
			MyGadget->Gadget3 = Gadget = CreateGadget(BUTTON_KIND,Gadget,&NewGadget,
										GA_Disabled,MyGadget->Currentc ? (MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE) : TRUE,
										TAG_END);
			NewGadget.ng_Flags = PLACETEXT_LEFT;
			break;
		case GAD_OFILE:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = GADGETWIDTH;
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(CHECKBOX_KIND,Gadget,&NewGadget,
										GTCB_Checked, MyGadget->Currentc,
										GTCB_Scaled, TRUE,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										TAG_END);
			MyGadget->Ptr2.MyGadget = MyGadget;
			MyGadget->Ptr2.Number = 2;
			NewGadget.ng_UserData = &(MyGadget->Ptr2);
			NewGadget.ng_LeftEdge += gh->interwidth/2 + GADGETWIDTH;
			NewGadget.ng_Width = gh->rightsize - ((gh->interwidth/2 + GADGETWIDTH) * 2);
			NewGadget.ng_GadgetText = NULL;
			MyGadget->Gadget2 = Gadget = CreateGadget(STRING_KIND,Gadget,&NewGadget,
										GTST_String, MyGadget->Defaults,
										GTST_MaxChars, 256,
										GA_Disabled,MyGadget->Currentc ? (MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE) : TRUE,
										STRINGA_ExitHelp, TRUE,
										TAG_END);
			NewGadget.ng_LeftEdge += NewGadget.ng_Width + gh->interwidth/2;
			MyGadget->Ptr3.MyGadget = MyGadget;
			MyGadget->Ptr3.Number = 3;
			NewGadget.ng_UserData = &(MyGadget->Ptr3);
			NewGadget.ng_Width = GADGETWIDTH;
			NewGadget.ng_Flags = PLACETEXT_IN;
			NewGadget.ng_GadgetText = (char *)"«";
			MyGadget->Gadget3 = Gadget = CreateGadget(BUTTON_KIND,Gadget,&NewGadget,
										GA_Disabled,MyGadget->Currentc ? (MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE) : TRUE,
										TAG_END);
			NewGadget.ng_Flags = PLACETEXT_LEFT;
			break;
		case GAD_ONUMBER:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = GADGETWIDTH;
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(CHECKBOX_KIND,Gadget,&NewGadget,
										GTCB_Checked, MyGadget->Currentc,
										GTCB_Scaled, TRUE,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										TAG_END);
			MyGadget->Ptr2.MyGadget = MyGadget;
			MyGadget->Ptr2.Number = 2;
			NewGadget.ng_UserData = &(MyGadget->Ptr2);
			NewGadget.ng_LeftEdge += gh->interwidth/2 + GADGETWIDTH;
			NewGadget.ng_Width = gh->rightsize - (GADGETWIDTH + gh->interwidth/2);
			NewGadget.ng_GadgetText = NULL;
			MyGadget->Gadget2 = Gadget = CreateGadget(INTEGER_KIND,Gadget,&NewGadget,
										GTIN_Number, MyGadget->Defaultn,
										GA_Disabled,MyGadget->Currentc ? (MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE) : TRUE,
										STRINGA_ExitHelp, TRUE,
										TAG_END);
			break;
		case GAD_NUMBER:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = gh->rightsize;
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(INTEGER_KIND,Gadget,&NewGadget,
										GTIN_Number, MyGadget->Defaultn,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										STRINGA_ExitHelp, TRUE,
										TAG_END);
			break;
		case GAD_CYCLE:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = gh->rightsize;
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(CYCLE_KIND,Gadget,&NewGadget,
										GTCY_Labels, MyGadget->VStrings,
										GTCY_Active, MyGadget->Currenty,
										GT_Underscore, '_',
										TAG_END);
			break;
		case GAD_STRING:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = gh->rightsize;
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(STRING_KIND,Gadget,&NewGadget,
										GTST_String, MyGadget->Defaults,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										STRINGA_ExitHelp, TRUE,
										TAG_END);
			break;
		case GAD_TEXT:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			if (*MyGadget->Title) {
				NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
				NewGadget.ng_Width = gh->rightsize;
			}
			else {
				NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + tleft;
				NewGadget.ng_Width = gh->rightsize + gh->leftsize;
			}
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(TEXT_KIND,Gadget,&NewGadget,
										GTTX_Text, MyGadget->Defaults,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										GTTX_Border, TRUE,
										GTTX_Justification, MyGadget->Currentc?GTJ_CENTER:GTJ_LEFT,
										TAG_END);
			break;
		case GAD_MTEXT:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + tleft;
			NewGadget.ng_Width = gh->rightsize + gh->leftsize;
			NewGadget.ng_GadgetText = "";
			MyGadget->Gadget1 = Gadget = CreateGadget(TEXT_KIND,Gadget,&NewGadget,
										GTTX_Text, MyGadget->Defaults,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										GTTX_Border, FALSE,
										GTTX_Justification, MyGadget->Currentc?GTJ_CENTER:GTJ_LEFT,
										TAG_END);
			break;
		case GAD_OSTRING:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = GADGETWIDTH;
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(CHECKBOX_KIND,Gadget,&NewGadget,
										GTCB_Checked, MyGadget->Currentc,
										GTCB_Scaled, TRUE,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										TAG_END);
			MyGadget->Ptr2.MyGadget = MyGadget;
			MyGadget->Ptr2.Number = 2;
			NewGadget.ng_UserData = &(MyGadget->Ptr2);
			NewGadget.ng_LeftEdge += gh->interwidth/2 + GADGETWIDTH;
			NewGadget.ng_Width = gh->rightsize - (GADGETWIDTH + gh->interwidth/2);
			NewGadget.ng_GadgetText = NULL;
			MyGadget->Gadget2 = Gadget = CreateGadget(STRING_KIND,Gadget,&NewGadget,
										GTST_String, MyGadget->Defaults,
										GA_Disabled,MyGadget->Currentc ? (MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE) : TRUE,
										STRINGA_ExitHelp, TRUE,
										TAG_END);
			break;
		case GAD_CHECK:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = GADGETWIDTH;
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(CHECKBOX_KIND,Gadget,&NewGadget,
										GTCB_Checked, MyGadget->Currentc,
										GTCB_Scaled, TRUE,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										TAG_END);
			break;
		case GAD_SLIDER:
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = gh->rightsize - 
										(gh->UseTopaz ? (gh->XSize * MyGadget->logMaxn) : (TextLength(&(gh->MyScreen->RastPort),NUMBER,strlen(NUMBER))* MyGadget->logMaxn/10))
										- gh->interwidth;
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Gadget1 = Gadget = CreateGadget(SLIDER_KIND,Gadget,&NewGadget,
										GTSL_Min, MyGadget->Minn,
										GTSL_Max, MyGadget->Maxn,
										GTSL_Level, MyGadget->Defaultn,
										GTSL_MaxLevelLen, MyGadget->logMaxn,
										GTSL_MaxPixelLen, gh->UseTopaz ? (gh->XSize*MyGadget->logMaxn+2) : (TextLength(&(gh->MyScreen->RastPort),"8",1)* MyGadget->logMaxn + 2),
										GTSL_LevelFormat, "%ld",
										GTSL_LevelPlace, PLACETEXT_RIGHT,
										GA_RelVerify, TRUE,
										PGA_Freedom, LORIENT_HORIZ,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										TAG_END);
			break;
		case GAD_LIST:
		case GAD_MLIST:
			temp = NewGadget.ng_Height;
			NewGadget.ng_GadgetText = MyGadget->Title;
			NewGadget.ng_Height = (MyGadget->Lines * gh->MyTextAttr->ta_YSize) + 4;
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			NewGadget.ng_Width = gh->rightsize;
			MyGadget->Gadget1 = Gadget = CreateGadget(LISTVIEW_KIND,Gadget,&NewGadget,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GTLV_MakeVisible, MyGadget->Currenty,
										GTLV_Labels, &(MyGadget->VList),
										GTLV_ShowSelected, NULL,
										GTLV_Selected, MyGadget->Currenty,
										GT_Underscore, '_',
										(GAD_MLIST==MyGadget->Type)?GTLV_CallBack:TAG_IGNORE, (ULONG)&HookList,
										TAG_END);
			gh->height += NewGadget.ng_Height - 2;
			NewGadget.ng_Height = temp;
			break;
		case GAD_BUTTONTEXT:
			InButton = TRUE;
			ButtonNo = 0;
			checkleft(gh,NewGadget.ng_Height,&(NewGadget.ng_TopEdge),&tleft);
			if (*MyGadget->Title) {	
				NewGadget.ng_GadgetText = "";
				MyGadget->Ptr1.MyGadget = MyGadget;
				MyGadget->Ptr1.Number = 1;
				NewGadget.ng_UserData = &(MyGadget->Ptr1);
				NewGadget.ng_LeftEdge = max(gh->MyScreen->WBorLeft + gh->interwidth + tleft - INTERWIDTH,0);
				NewGadget.ng_Width = gh->leftsize;
				MyGadget->Gadget1 = Gadget = Gadget = CreateGadget(TEXT_KIND,Gadget,&NewGadget,
										GTTX_Text, MyGadget->Title,
										GTTX_Border, FALSE,
										GTTX_Justification, GTJ_RIGHT,
										GTTX_Clipped, TRUE,
										TAG_END);
				NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft;
			}
			else {
				NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + tleft;
			}
			if (MyGadget->ButtonCount > 1) {
				struct MyGadget *gad1;
				int MaxWidth = 0;
				int t;
				for (gad1 = (struct MyGadget *)MyGadget->GNode.ln_Succ;
					  gad1->GNode.ln_Succ && (GAD_BUTTON == gad1->Type);
					  gad1 = (struct MyGadget *)gad1->GNode.ln_Succ) {
					if (gh->UseTopaz) {
						t = gh->XSize*strlen(gad1->Title) + INTERWIDTH;
					}
					else {
						t = TextLength(&(gh->MyScreen->RastPort),gad1->Title,strlen(gad1->Title)) + INTERWIDTH;
					}
					if (t > MaxWidth) {
						MaxWidth = t;
					}
				}
				t = (MaxWidth + gh->interwidth) * MyGadget->ButtonCount - gh->interwidth;
				if (*MyGadget->Title) {
					if (t <= gh->rightsize) {
						ButtonWidth = MaxWidth;
					}
					else {
						ButtonWidth = 0;
					}
				}
				else {
					if (t <= (gh->rightsize+gh->leftsize)) {
						ButtonWidth = MaxWidth;
					}
					else {
						ButtonWidth = 0;
					}
				}
			}
			break;
		case GAD_BUTTON:
			NewGadget.ng_GadgetText = MyGadget->Title;
			MyGadget->Ptr1.MyGadget = MyGadget;
			MyGadget->Ptr1.Number = 1;
			NewGadget.ng_UserData = &(MyGadget->Ptr1);
			if (MyGadget->OwnButton->ButtonCount > 1) {
				if (ButtonWidth) {
					NewGadget.ng_Width = ButtonWidth;
				}
				else {
					if (gh->UseTopaz) {
						NewGadget.ng_Width = gh->XSize*strlen(MyGadget->Title) + INTERWIDTH;
					}
					else {
						NewGadget.ng_Width = TextLength(&(gh->MyScreen->RastPort),MyGadget->Title,strlen(MyGadget->Title)) + INTERWIDTH;
					}
				}
			}
			else {
				if (*MyGadget->OwnButton->Title) {
					NewGadget.ng_Width = gh->rightsize;
				}
				else {
					NewGadget.ng_Width = gh->rightsize + gh->leftsize;
				}
			}
			if (ButtonNo) {
				if (MyGadget->OwnButton->ButtonCount == 2) {
					NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize +
													gh->rightsize + tleft - NewGadget.ng_Width;
				}
				else if (MyGadget->OwnButton->ButtonCount == 3) {
					if (1 == ButtonNo) {
						if (*MyGadget->OwnButton->Title) {
							NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize + tleft +
															(gh->rightsize - NewGadget.ng_Width)/2;
						}
						else {
							NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + tleft +
															(gh->leftsize + gh->rightsize - NewGadget.ng_Width)/2;
						}
					}
					else if (2 == ButtonNo) {
						NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth + gh->leftsize +
														gh->rightsize + tleft - NewGadget.ng_Width;
					}
				}
			}
			NewGadget.ng_GadgetText = MyGadget->Title;
			NewGadget.ng_Flags = PLACETEXT_IN;
			MyGadget->Gadget1 = Gadget = CreateGadget(BUTTON_KIND,Gadget,&NewGadget,
										GA_Disabled, MyGadget->OwnCycle ?((MyGadget->OwnCycle->Currenty == MyGadget->Activey) ? FALSE : TRUE ) : FALSE,
										GT_Underscore, '_',
										TAG_END);
			NewGadget.ng_Flags = PLACETEXT_LEFT;
			NewGadget.ng_LeftEdge += NewGadget.ng_Width + gh->interwidth;
			++ButtonNo;
			break;
		}
		if (!InButton) {
			if ((MyGadget->Type != GAD_LIST) &&
				 (MyGadget->Type != GAD_MLIST)) {
				gh->height += gh->MyTextAttr->ta_YSize + 2;
			}
		}
	}
	if (InButton) {
		gh->height += gh->MyTextAttr->ta_YSize + 2;
	}
	if (gh->Bottom) {
		gh->height = gh->Bottom;
	}
	gh->height += gh->interheight*2;
	NewGadget.ng_Flags = PLACETEXT_IN;
	if (!gh->NoButtons && Gadget) {
		NewGadget.ng_TopEdge = gh->height;
		NewGadget.ng_UserData = (APTR)USERSAVE;
		NewGadget.ng_LeftEdge = gh->MyScreen->WBorLeft + gh->interwidth;
		NewGadget.ng_Width = CancelSize;
		if (gh->Prefs) {
			NewGadget.ng_GadgetText = (gh->NoSave?GetMessage(MSG_SAVE):GetMessage(MSG__SAVE));
		}
		else {
			NewGadget.ng_GadgetText = (gh->NoOk?GetMessage(MSG_OK):GetMessage(MSG__OK));
		}
		Gadget = CreateGadget(BUTTON_KIND,Gadget,&NewGadget,
								GT_Underscore, '_',
								TAG_END);
		if (Gadget) {
			if (gh->Prefs) {
				NewGadget.ng_UserData = (APTR)USERUSE;
				NewGadget.ng_LeftEdge = (gh->width - CancelSize)/2;
				NewGadget.ng_GadgetText = (gh->NoUse?GetMessage(MSG_USE):GetMessage(MSG__USE));
				Gadget = CreateGadget(BUTTON_KIND,Gadget,&NewGadget,
										GT_Underscore, '_',
										TAG_END);
			}
			else {
				if (gh->HelpFunc && gh->HelpNode) {
					NewGadget.ng_UserData = (APTR)USERHELP;
					NewGadget.ng_LeftEdge = (gh->width - CancelSize)/2;
					NewGadget.ng_GadgetText = GetMessage(MSG_HELP);
					Gadget = CreateGadget(BUTTON_KIND,Gadget,&NewGadget,
											TAG_END);
				}
			}
			if (Gadget) {
				NewGadget.ng_UserData = (APTR)USERCANCEL;
				NewGadget.ng_LeftEdge = gh->width - gh->interwidth - gh->MyScreen->WBorRight - CancelSize;
				NewGadget.ng_GadgetText = (gh->NoCancel?GetMessage(MSG_CANCEL):GetMessage(MSG__CANCEL));
				Gadget = CreateGadget(BUTTON_KIND,Gadget,&NewGadget,
										GT_Underscore, '_',
										TAG_END);
			}
		}
		gh->height += gh->MyTextAttr->ta_YSize + 2 + gh->MyScreen->WBorBottom + gh->interheight;
	}
	else {
		gh->height += gh->MyScreen->WBorBottom;
	}
	return (BOOL)Gadget;
}

static void
checkleft(struct MPGuiHandle *gh, int addheight, short *curgh, int *tleft) {
	if ((gh->height + gh->MyScreen->WBorBottom + gh->interheight + addheight +
		  (gh->NoButtons?0:(gh->MyTextAttr->ta_YSize + 2 + gh->interheight))) > gh->MyScreen->Height) {
		if ((gh->height + addheight) > gh->Bottom) {
			gh->Bottom = gh->height;
		}
		gh->height = gh->MyScreen->WBorTop + gh->MyScreen->Font->ta_YSize + 1 + gh->interheight;
		*curgh = gh->height;
		*tleft += gh->leftsize + gh->rightsize + gh->interwidth;
		gh->width += gh->leftsize + gh->rightsize + gh->interwidth;
		if (gh->width > gh->MyScreen->Width) {
			gh->width -= gh->interwidth;
			*tleft -= gh->interwidth;
		}
		if (gh->width > gh->MyScreen->Width) {
			gh->rightsize -= (gh->width - gh->MyScreen->Width);
			gh->width = gh->MyScreen->Width;
		}
	}
	return;
}

/* Shows ASL file requester for a file
 * name	: current file name
 * Prompt: Title
 * flags	: e.g. for save flag
 * Returns: TRUE if file selected, name is TempFileName
 */
BOOL
GetAFile(struct MPGuiHandle *gh,const UBYTE *name,const char *Prompt,ULONG flags,char *positive) {
	char TempName[257];
	char TempDir[257];

	if (name && *name) {
		strncpy(TempDir,name,(size_t)(PathPart((char *)name) - name));
		TempDir[PathPart((char *)name)-name]=0;
		strcpy(TempName,FilePart((char *)name));
	}
	else {
		TempDir[0]=0;
		TempName[0]=0;
	}
	// Show requesters
	DisableWindow(gh);
	if (AslRequestTags((APTR) gh->filereq,
							ASLFR_TitleText,(Tag) Prompt,
							ASLFR_Flags1,flags,
							ASLFR_InitialDrawer, (Tag) TempDir,
							ASLFR_InitialFile,(Tag) TempName,
							ASLFR_Window, gh->Window,
							ASLFR_RejectIcons, TRUE,
							ASLFR_PositiveText, positive,
							ASLFR_IntuiMsgFunc, &(gh->RefreshHook),
							TAG_DONE)) {
		// rejoin name
		strncpy(gh->TempFileName,gh->filereq->fr_Drawer,256);
		AddPart(gh->TempFileName,gh->filereq->fr_File,256);
		EnableWindow(gh);
		return TRUE;
	}
	else {
	EnableWindow(gh);
	return FALSE;
	}
}

/* Shows ASL file requester for a font
 * name	: current font name
 * Prompt: Title
 * Returns: TRUE if font selected, constructed name is gh->TempFileName
 */
BOOL
GetAFont(struct MPGuiHandle *gh,struct MyGadget *mg,const UBYTE *name,const char *Prompt) {
	char TempName[257];
	struct FontRequester *req;

	if (name && *name) {
		strcpy(TempName,name);
	}
	else {
		TempName[0]=0;
	}
	// Show requesters
	DisableWindow(gh);
	if (req = AllocAslRequest(ASL_FontRequest,NULL)) {
		if (AslRequestTags(req,
							ASLFO_Window, gh->Window,
							ASLFO_TitleText, Prompt,
							ASLFO_InitialName, TempName,
							ASLFO_InitialSize, 8,	//??
							ASLFO_FixedWidthOnly, (mg->ModeType > 1),
							ASLFO_PositiveText,GetMessage(MSG_SELECT),
							ASLFO_IntuiMsgFunc, &(gh->RefreshHook),
							TAG_END)) {
			strcpy(gh->TempFileName,req->fo_Attr.ta_Name);
			if (strlen(gh->TempFileName) > 5) {
				if (!stricmp(&(gh->TempFileName[strlen(gh->TempFileName)-5]),".font")) {
					gh->TempFileName[strlen(gh->TempFileName)-5] = 0;
				}
			}
			FreeAslRequest(req);
			EnableWindow(gh);
			return TRUE;
		}
		else {
			FreeAslRequest(req);
			EnableWindow(gh);
			return FALSE;
		}
	}
	else {
		return FALSE;
	}
}

/* Shows ASL file requester for a font
 * name	: current font name
 * Prompt: Title
 * Returns: TRUE if file selected, name is TempFileName
 */
BOOL
GetAMode(struct MPGuiHandle *gh,struct MyGadget *mg,const UBYTE *name,const char *Prompt) {
	char TempName[257];

	if (name && *name) {
		strcpy(TempName,name);
	}
	else {
		TempName[0]=0;
	}
	// Show requesters
	DisableWindow(gh);
	{
		ULONG id = (ULONG)INVALID_ID;
		ULONG myid = (ULONG)INVALID_ID;
		struct NameInfo buff;
		struct List List = {0};
		struct DisplayMode DisplayMode = {0};
		struct ScreenModeRequester *req;

		NewList(&List);
		DisplayMode.dm_Node.ln_Name = GetMessage(MSG_NONE);
      DisplayMode.dm_PropertyFlags                 	= DIPF_IS_WB;
		DisplayMode.dm_DimensionInfo.Header.StructID		= DTAG_DIMS;
		DisplayMode.dm_DimensionInfo.Header.DisplayID	= (ULONG)INVALID_ID;
		DisplayMode.dm_DimensionInfo.Header.SkipID 		= TAG_SKIP;
      DisplayMode.dm_DimensionInfo.Header.Length		= sizeof(struct DimensionInfo);
      DisplayMode.dm_DimensionInfo.MaxDepth         = 24;
      DisplayMode.dm_DimensionInfo.MinRasterWidth   = 16;
      DisplayMode.dm_DimensionInfo.MinRasterHeight  = 16;
      DisplayMode.dm_DimensionInfo.MaxRasterWidth   = 2048;
      DisplayMode.dm_DimensionInfo.MaxRasterHeight  = 2048;
      DisplayMode.dm_DimensionInfo.Nominal.MinX     = 0;
      DisplayMode.dm_DimensionInfo.Nominal.MinY     = 0;
      DisplayMode.dm_DimensionInfo.Nominal.MaxX     = 640;
      DisplayMode.dm_DimensionInfo.Nominal.MaxY     = 200;
      DisplayMode.dm_DimensionInfo.TxtOScan         = DisplayMode.dm_DimensionInfo.Nominal;
      DisplayMode.dm_DimensionInfo.MaxOScan         = DisplayMode.dm_DimensionInfo.Nominal;
      DisplayMode.dm_DimensionInfo.VideoOScan       = DisplayMode.dm_DimensionInfo.Nominal;
      DisplayMode.dm_DimensionInfo.StdOScan         = DisplayMode.dm_DimensionInfo.Nominal;
		AddHead(&List,&(DisplayMode.dm_Node));

		id = NextDisplayInfo(id);
		while ((id != INVALID_ID) && (myid == INVALID_ID)) {
			if (GetDisplayInfoData(NULL,(UBYTE *)&buff,sizeof(struct NameInfo),DTAG_NAME,id)) {
				if (!Stricmp(TempName,buff.Name)) {
					myid = id;
				}
			}
			id = NextDisplayInfo(id);
		}
		if (req = AllocAslRequest(ASL_ScreenModeRequest,NULL)) {
			if (AslRequestTags(req,
								ASLSM_Window, gh->Window,
								ASLSM_TitleText, Prompt,
								ASLSM_InitialDisplayID, myid,
								((mg->ModeType == 2) || (mg->ModeType == 4)) ? ASLSM_CustomSMList : TAG_IGNORE,
									(ULONG)&List,
								(mg->ModeType > 2) ? ASLSM_PropertyFlags : TAG_IGNORE , NULL,
								(mg->ModeType > 2) ? ASLSM_PropertyMask : TAG_IGNORE, NULL,
								ASLSM_PositiveText,GetMessage(MSG_SELECT),
								ASLSM_IntuiMsgFunc, &(gh->RefreshHook),
								TAG_END)) {
				if (GetDisplayInfoData(NULL,(UBYTE *)&buff,sizeof(struct NameInfo),DTAG_NAME,
						req->sm_DisplayID)) {
					strcpy(gh->TempFileName, buff.Name);
				}
				else {
					strcpy(gh->TempFileName,"");
				}
				FreeAslRequest(req);
				EnableWindow(gh);
				return TRUE;
			}
			else {
				FreeAslRequest(req);
				EnableWindow(gh);
				return FALSE;
			}
		}
		else {
			return FALSE;
		}
	}
}

void
DisableWindow(struct MPGuiHandle *gh) {
	InitRequester(&gh->Requestx);
	SetWindowPointer(gh->Window, WA_BusyPointer, TRUE, TAG_DONE);
	if (!gh->Disabled) {
		if (Request(&gh->Requestx,gh->Window)) {
			gh->Disabled = 1;
		}
	}
	else {
		++gh->Disabled;
	}
}	

void
EnableWindow(struct MPGuiHandle *gh) {
	if (gh->Disabled) {
		--gh->Disabled;
	}
	if (!gh->Disabled) {
		SetWindowPointer(gh->Window,WA_Pointer, NULL, TAG_DONE);
		EndRequest(&gh->Requestx,gh->Window);
	}
}

ULONG
MyCallHookPkt(struct MPGuiHandle *gh,struct Hook *h,APTR a,APTR b) {
	ULONG ret;
	DisableWindow(gh);
	ret = CallHookPkt(h,a,b);
	EnableWindow(gh);
	return ret;
}

char
*GetMessage(UWORD message) {
	LONG   *l;
	UWORD  *w;
	STRPTR  builtIn;

   l = (LONG *)CatCompBlock;

	while (*l != message)  {
		w = (UWORD *)((ULONG)l + 4);
		l = (LONG *)((ULONG)l + (ULONG)*w + 6);
	}
	builtIn = (STRPTR)((ULONG)l + 6);
	return(GetCatalogStr(Catalog,message,builtIn));
}
