
/***************************************************************************
*==========================================================================*
*=																		  =*
*=					Profyler v1.00 © 2022 by Mike Steed					  =*
*=																		  =*
*==========================================================================*
*==========================================================================*
*=																		  =*
*=	Profyler User Interface Module				Last modified 08-Jan-22	  =*
*=																		  =*
*==========================================================================*
***************************************************************************/

/***************************************************************************
============================================================================

 The User Interface (GUI) module encapsulates the user interface functional-
 ity of Profyler. It creates and operates the program's window and the MUI
 gadgets it contains (one tab and list viewer per target), as well as the
 associated menus and requesters. It is also responsible for other user-
 facing tasks such as printing the database contents and saving them to text
 and CSV files.

============================================================================
***************************************************************************/

/***************************************************************************
============================================================================

 This program is free software; you can redistribute it and/or modify it
 under the terms of the GNU General Public License as published by the Free
 Software Foundation; either version 2 of the License, or (at your option)
 any later version.
 
 This program is distributed in the hope that it will be useful, but WITHOUT
 ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 more details.
 
 You should have received a copy of the GNU General Public License along
 with this program; if not, write to the Free Software Foundation, Inc.,
 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

============================================================================
***************************************************************************/

/***************************************************************************
*																		   *
* Setup																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Includes ===

#define __NOLIBBASE__
#define __NOGLOBALIFACE__

#include <exec/types.h>
#include <exec/exectags.h>
#include <exec/lists.h>
#include <utility/hooks.h>
#include <libraries/gadtools.h>
#include <libraries/asl.h>
#include <libraries/mui.h>
#include <mui/Aboutbox_mcc.h>

#include "Profyler.h"
#include "ProfGUI.h"
#include "ProfIPC.h"
#include "ProfDB.h"

#include <string.h>

#include <proto/exec.h>
#include <proto/intuition.h>
#include <proto/dos.h>
#include <proto/muimaster.h>

// -------------------------------------------------------------------------
// === Prototypes ===

static uint32 Title_Close(Class *Cls, Object *Obj, struct MUIP_Title_Close *Mesg);
static uint32 Title_Dispatcher(Class *Cls, Object *Obj, Msg Mesg);
static uint32 AddTab(uint32 Target, Object *TabTitle, Object *TabContent);
static Object *GetActiveTab(void);
static uint32 DisplayRow(UNUSED struct Hook *Hk, STRPTR *Strings, APTR Entry);
static int32 SortRows(UNUSED struct Hook *Hk, APTR SecondEntry, APTR FirstEntry);
static void FunctionInfo(APTR Entry);
static void GetColumnOrder(Object *Tab, int8 *Columns);
static STRPTR PlaceString(STRPTR Buff, STRPTR String, int32 *Len);
static STRPTR PlaceStringLeft(STRPTR Buff, STRPTR String, int32 Wid, int32 *Len);
static STRPTR PlaceStringRight(STRPTR Buff, STRPTR String, int32 Wid, int32 *Len);
static BOOL WriteTextHeader(BPTR File, STRPTR Name, int8 *Columns);
static BOOL WriteTextRecord(BPTR File, APTR Entry, int8 *Columns);
static BOOL WriteCSVHeader(BPTR File, STRPTR Name);
static BOOL WriteCSVRecord(BPTR File, APTR Entry);
static BOOL SaveProfileData(STRPTR Name, BOOL CSV);
static void CloseWind(void);
static void DoubleClick(UNUSED struct Hook *Hk, Object *Viewer);
static void MenuQuit(void);
static void MenuScan(void);
static void MenuUpdate(void);
static void MenuSaveText(void);
static void MenuSaveCSV(void);

// -------------------------------------------------------------------------
// === Macros ===


/***************************************************************************
*																		   *
* Data																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Defines ===

// We want a tab for each possible target (1 - MAX_TARGETS), plus one (0) for
// the default tab, which is displayed only if no targets are present. This
// also conveniently lets us index the TargetTitle and TargetView arrays by
// the target number, rather than the target number - 1.
#define NUM_TABS	(MAX_TARGETS + 1)

// The maximum length of the path + name of an output file (either text or
// CSV), *not* including the trailing NUL. Any buffer used to hold the file-
// name must be at least one byte larger than this.
#define MAX_FILENAME_LEN	255

// The buffer size required to hold one worst-case line of a CSV file, in-
// cluding the <LF>,<NUL> at the end. Includes some extra room, for safety.
#define CSV_BUF_LEN			200

// The buffer size required to hold one worst-case line of a text file, in-
// cluding the <LF>,<NUL> at the end. Includes some extra room, for safety.
#define TEXT_BUF_LEN		160

// -------------------------------------------------------------------------
// === Locals ===

// We depend on some of these variables being NULL on startup; the startup
// code ensures this (BSS is zeroed).

// The Database module's local data. It's fairly small, so we put it in BSS
// to avoid the need to allocate it.
static struct
{
	// The MUI Application object.
	Object *App;

	// Our custom subclass of the Title class.
	struct MUI_CustomClass *Title_Class;

	// The MUI objects that make up the GUI window.
	Object *TargetView[NUM_TABS];	// contents of the target tabs
	Object *TargetTitle[NUM_TABS];	// titles of target tabs
	Object *TargetTabs;				// tabbed title object
	Object *TargetGroup;			// group to contain target tabs
	Object *MainGroup;				// group to hold window contents

	Object *MenuProfyler;			// Profyler menu
	Object *MenuAbout;				// Profyler/About menu item
	Object *MenuAboutMUI;			// Profyler/About MUI menu item
	Object *MenuMUISettings;		// Profyler/MUI Settings menu item
	Object *MenuBar1;				// divider bar
	Object *MenuQuit;				// Profyler/Quit menu item
	Object *MenuContact;			// Contact menu
	Object *MenuScan;				// Contact/Scan For Targets menu item
	Object *MenuTarget;				// Target menu
	Object *MenuUpdate;				// Target/Update menu item
	Object *MenuBar2;				// divider bar
	Object *MenuSaveText;			// Target/Save As Text menu item
	Object *MenuSaveCSV;			// Target/Save As CSV menu item
	Object *MenuStrip;				// window's menu strip

	// The window itself.
	Object *Wind;

	// The 'About' window.
	Object *AboutWind;

	// Notification hooks called by MUI.
	struct Hook *CloseHook;			// window's close box was hit
	struct Hook *DoubleClickHook;	// a double-click in the list viewer
	struct Hook *MenuQuitHook;		// Quit menu item has been selected
	struct Hook *MenuScanHook;		// Scan menu item has been selected
	struct Hook *MenuUpdateHook;	// Update menu item has been selected
	struct Hook *MenuSaveTextHook;	// Save As Text menu item selected
	struct Hook *MenuSaveCSVHook;	// Save As CSV manu item selected

	// Hooks called by the list viewer.
	struct Hook *DisplayHook;		// return column content strings
	struct Hook *SortHook;			// determine sort order of two entries

} Envmt;

// The column format string for the list viewer. It's broken into per-column
// chunks, but it's all a single string.
static CONST_STRPTR ListFormat =
	"SORTABLE BAR,"
	"SORTABLE BAR HIDDEN,"
	"SORTABLE BAR PREPARSE=\033r,"
	"SORTABLE BAR PREPARSE=\033r,"
	"SORTABLE BAR PREPARSE=\033r,"
	"SORTABLE BAR PREPARSE=\033r,"
	"SORTABLE BAR PREPARSE=\033r,"
	"SORTABLE BAR PREPARSE=\033r,"
	"SORTABLE BAR PREPARSE=\033r"
;

// The column widths used when printing and saving as text. The contents are
// justified to fit within these widths.
static int32 ColumnWidth[NUM_GUI_COLUMNS] =
{
	FUNC_NAME_LEN, FUNC_LOCN_LEN, CALL_CNT_LEN,
	EXEC_TIME_LEN, PERCT_LEN, EXEC_TIME_LEN,
	EXEC_TIME_LEN, PERCT_LEN, EXEC_TIME_LEN
};

// A line feed as a string, for use in outputting the profile data.
static TEXT LF[] = "\n";

// Likewise, a single space.
static TEXT Space[] = " ";

// -------------------------------------------------------------------------
// === Globals ===

// We depend on some of these variables being NULL on startup; the startup
// code ensures this (BSS is zeroed).


/***************************************************************************
*																		   *
* Code																	   *
*																		   *
***************************************************************************/

// -------------------------------------------------------------------------
// === Custom MUI Title class ===

/***************************************************************************

 Title_Close(Class, Object, Message)

 An overload of the MUI Title class' Title_Close method, which is invoked
 when the close button in one of the title's pages (tabs) is clicked.

 If the tab being closed is the default tab, quit the program. Otherwise,
 allow the superclass (the standard MUI Title class) to remove and dispose
 of the tab and its contents, then update the Environment to note that the
 two objects have been removed. Delete the database associated with the tab.

 If there are no target tabs left after this one is disposed of, create and
 add the default tab, to serve as a placeholder.
 
 In -----------------------------------------------------------------------

 Class = A pointer to the IClass struct for the custom Title class.

 Object = A pointer to the custom Title object being manipulated.

 Message = A pointer to a MUIP_Title_Close struct, which contains a pointer
	to the title associated with the tab to be closed (i.e. the name of the
	tab).

 Out ----------------------------------------------------------------------

 Result = Always zero.

***************************************************************************/

static uint32 Title_Close(Class *Cls, Object *Obj, struct MUIP_Title_Close *Mesg)
{
	uint32 Target, i;
	Object *Title, *Content;

	// Get the target number from the tab's title.
	Target = muiUserData(Mesg->tito);

	// The default tab gets special handling.
	if(Target == 0)
	{
		// Closing the default tab quits the program. No need to delete the
		// tab here; it'll be deleted during shutdown.
		MenuQuit();
	}
	else
	{
		// Otherwise let our superclass dispose of the tab and its contents.
		// There's no way of knowing if this fails, so we'll assume it
		// doesn't.
		IIntuition->IDoSuperMethodA(Cls, Obj, (Msg)Mesg);

		// Mark the tab and view objects as having been deleted.
		Envmt.TargetTitle[Target] = NULL;
		Envmt.TargetView[Target] = NULL;

		// Delete the associated database.
		DB_Delete(Target);

		// Check to see if any other tabs are still open.
		for(i = 1; i <= MAX_TARGETS; i++) if(Envmt.TargetTitle[i]) break;

		// If there are no other tabs open, create and add a new default tab.
		if(i == MAX_TARGETS + 1)
		{
			// Create a title for the tab.
			Title = IMUIMaster->TextObject,
				MUIA_Text_Contents, MSG_GUI_NoTargets,
			End;

			// Create a message as the tab's content.
			Content = IMUIMaster->TextObject,
				MUIA_Text_Contents, MSG_GUI_NoTargetsHelp,
				MUIA_Text_PreParse, "\033c",
			End;

			// Use these elements to create a new default tab. This will fail
			// if either of the elements could not be created (which will
			// leave us with no tabs).
			if(!AddTab(0, Title, Content))
			{
				// Something went wrong- delete the two objects. No harm if
				// either or both could not be created.
				IMUIMaster->MUI_DisposeObject(Title);
				IMUIMaster->MUI_DisposeObject(Content);
			}
		}
	}

	// Always return zero.
	return(0);
}

/***************************************************************************

 Result = Title_Dispatcher(Class, Object, Message)

 The method dispatcher for the custom Title class. It invokes the methods
 that are overloaded by the custom class, and passes the others on up to the
 superclass (the standard MUI Title class).

 In -----------------------------------------------------------------------

 Class = A pointer to the IClass struct for the custom Title class.

 Object = A pointer to the object the methods are being invoked on.

 Message = A pointer to a data structure specific to the method being invok-
	ed. All structures contain the method ID.

 Out ----------------------------------------------------------------------

 Result = Whatever the invoked method returns.

***************************************************************************/

static uint32 Title_Dispatcher(Class *Cls, Object *Obj, Msg Mesg)
{
	// Determine which method is being invoked.
	switch(Mesg->MethodID)
	{
		// Our close button has been clicked.
		case MUIM_Title_Close: return(Title_Close(Cls, Obj, (APTR)Mesg));

		// All other methods are passed on to our superclass.
		default: return(IIntuition->IDoSuperMethodA(Cls, Obj, Mesg));
	}
}

// -------------------------------------------------------------------------
// === Private code ===

/***************************************************************************

 Success = AddTab(Target, TabTitle, TabContent)

 Add a new target tab to the GUI window, in the rightmost position. The tab
 will have the given title and will contain the given contents. It will be
 assigned to the specified target number (1 - MAX_TARGETS, or 0 for the de-
 fault tab that is displayed when there are no targets). If adding a non-zero
 target the default tab is removed and disposed of, if present. The GUI is
 refreshed to display the new tab, and the Target menu is disabled if only
 the default tab is present, and enabled otherwise.

 The objects' attributes are modified as required to serve as tabs, so this
 does not need to be done by the caller. Specifically, the UserData field is
 set to reflect the target number, and the title object is made draggable and
 dropable to allow the tabs to be manually reordered.

 Fail and return an error code if any of the parameters is invalid, if there
 is already a tab for the specified target, or if MUI is unable to accommo-
 date the new objects.

 In -----------------------------------------------------------------------

 Target = The target number, between 0 (the default target) and MAX_TARGETS.
	Invalid numbers cause failure.

 TabTitle = A pointer to a MUI object (normally a text object) that serves as
	the tab's title. This object will automatically	be deleted when the tab
	is closed, or when the GUI window is closed. NULL will cause failure.

 TabContent = A pointer to a MUI object or group (normally a listview for
	most tabs and a text object for the default tab, though this isn't enfor-
	ced) that comprises the contents of the tab. This object will automatic-
	ally be	deleted	when the tab is closed, or when the GUI window is closed.
	NULL will cause failure. 

 Out ----------------------------------------------------------------------

 Success = TRUE if the tab was successfully added, or FALSE if not.

***************************************************************************/

static uint32 AddTab(uint32 Target, Object *TabTitle, Object *TabContent)
{
	// Fail if the target number is out of range.
	if(Target > MAX_TARGETS) return(FALSE);

	// Fail if either of the objects is NULL.
	if(!TabTitle || !TabContent) return(FALSE);

	// Fail if the specified target seems to already have a tab.
	if(Envmt.TargetTitle[Target]) return(FALSE);
	if(Envmt.TargetView[Target]) return(FALSE);

	// Modify the object attributes as necessary to allow them to serve as
	// tabs.
	Set(TabTitle, MUIA_UserData, Target);	// user data = target #
	Set(TabContent, MUIA_UserData, Target);
	Set(TabTitle, MUIA_Draggable, TRUE);	// allow drag'n'drop of titles
	Set(TabTitle, MUIA_Dropable, TRUE);

	// Enable on-the-fly modification of the tabs.
	IIntuition->IDoMethod(Envmt.TargetTabs, MUIM_Group_InitChange); 
	IIntuition->IDoMethod(Envmt.TargetGroup, MUIM_Group_InitChange); 
	IIntuition->IDoMethod(Envmt.MainGroup, MUIM_Group_InitChange); 

	// Add the new title to the title object, and remember that we did so.
	if(IIntuition->IDoMethod(Envmt.TargetTabs, OM_ADDMEMBER, TabTitle))
	{
		Envmt.TargetTitle[Target] = TabTitle;
	}

	// Add the new contents to the tab group, and remember that we did so.
	if(IIntuition->IDoMethod(Envmt.TargetGroup, OM_ADDMEMBER, TabContent))
	{
		Envmt.TargetView[Target] = TabContent;
	}

	// Technically, we should deal with a possible failure to add either or
	// both of the objects above. But since we're just adding items to a
	// list, which seems very unlikely to fail, we'll punt and just assume
	// success.

	// If we're adding a real target tab, we need to dispose of the default
	// tab, if present.
	if(Target)
	{
		// Is the default tab present?
		if(Envmt.TargetTitle[0])
		{
			// Yes- remove its title.
			if(IIntuition->IDoMethod(Envmt.TargetTabs, OM_REMMEMBER,
				Envmt.TargetTitle[0]))
			{
				// Dispose of the tab's title object, and note that we've
				// done so.
				IMUIMaster->MUI_DisposeObject(Envmt.TargetTitle[0]);
				Envmt.TargetTitle[0] = NULL;
			}
		}

		// Is the default tab present?
		if(Envmt.TargetView[0])
		{
			// Yes- remove its contents.
			if(IIntuition->IDoMethod(Envmt.TargetGroup, OM_REMMEMBER,
				Envmt.TargetView[0]))
			{
				// Dispose of the tab's contents, and note that we've
				// done so.
				IMUIMaster->MUI_DisposeObject(Envmt.TargetView[0]);
				Envmt.TargetView[0] = NULL;
			}
		}
		else
		{
			// If we're adding a new tab, rather than replacing the default
			// one, make the new tab the active one.
			Set(Envmt.TargetGroup, MUIA_Group_ActivePage,
				MUIV_Group_ActivePage_Last);
		}

		// Note that things get ugly if only one of the two objects that make
		// up the tab can be removed and disposed of. We'll assume that's
		// very unlikely to happen, and so do not try to deal with it specif-
		// ically.
	}

	// Update the tabs to reflect the modification.
	IIntuition->IDoMethod(Envmt.MainGroup, MUIM_Group_ExitChange); 
	IIntuition->IDoMethod(Envmt.TargetGroup, MUIM_Group_ExitChange); 
	IIntuition->IDoMethod(Envmt.TargetTabs, MUIM_Group_ExitChange); 

	// The Target menu is enabled if a target tab is present, and disabled if
	// the default tab is present.
	if(Target) Set(Envmt.MenuTarget, MUIA_Menu_Enabled, TRUE);
	else Set(Envmt.MenuTarget, MUIA_Menu_Enabled, FALSE);

	// Return success.
	return(TRUE);
}

/***************************************************************************

 Tab = GetActiveTab()

 Determine which GUI tab is currently active. The corresponding target number
 can then be derived by reading the user data field of the returned object.
 The default tab (displayed when there are no targets) has a target number of
 zero.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Tab = A pointer to the active tab (specifically, the list viewer that com-
	prises the tab's contents). NULL if the current tab couldn't be determin-
	ed.

***************************************************************************/

static Object *GetActiveTab(void)
{
	struct List *Children;
	Object *Tab, *Iterate;
	uint32 Active, i;

	// Ask the tab group which of its children is currently displayed (this
	// is an index, alas, and not a pointer). Because the tabs may have been
	// rearranged by the user, this does not necessarily correspond to the
	// tab's apparent position.
	Get(Envmt.TargetGroup, MUIA_Group_ActivePage, &Active);

	// The first child is the title object and isn't counted, so we need to
	// bump the index by one to compensate.
	Active++;

	// Ask the tab group for a list of its children, and get a pointer to the
	// first child.
	Get(Envmt.TargetGroup, MUIA_Group_ChildList, &Children);
	Iterate = (Object *)Children->lh_Head;

	// Loop through the children until we get to the active one.
	for(i = 0; i <= Active; i++)
	{
		Tab = IIntuition->NextObject(&Iterate);

		// Abort (and return NULL) if we run out of children.
		if(!Tab) break;
	}

	// Return a pointer to the active tab.
	return(Tab);
}

/***************************************************************************

 DisplayRow(Hook, Strings, Entry)

 This function is called by the list viewer's display hook when the list
 viewer wants to display one of the list entries (list viewer rows), or the
 column titles. The column title strings are provided by this function, while
 the entry is passed along to the database module to provide the database
 strings.

 In -----------------------------------------------------------------------

 Hook = A pointer to the Hook through which this function was called. This is
	ignored by the function.

 String = A pointer to an array of string pointers, one per list viewer col-
	umn. This function fills in these pointers to point to the text to be
	displayed in each of the entry's columns.

 Entry = A pointer to the database record for the entry (row) to be display-
	ed, or NULL to display the column titles.

 Out ----------------------------------------------------------------------

 Always returns zero.

***************************************************************************/

static uint32 DisplayRow(UNUSED struct Hook *Hk, STRPTR *Strings, APTR Entry)
{
	// Was a database entry provided?
	if(Entry)
	{
		// Yes- provide the strings for the specified entry.
		DB_GetStrings(Entry, Strings);
	}
	else
	{
		// No- provide the strings for the column titles.
		Strings[0] = MSG_GUI_Col1Title;
		Strings[1] = MSG_GUI_Col2Title;
		Strings[2] = MSG_GUI_Col3Title;
		Strings[3] = MSG_GUI_Col4Title;
		Strings[4] = MSG_GUI_Col5Title;
		Strings[5] = MSG_GUI_Col6Title;
		Strings[6] = MSG_GUI_Col7Title;
		Strings[7] = MSG_GUI_Col8Title;
		Strings[8] = MSG_GUI_Col9Title;
	}

	// Always return zero.
	return(0);
}

/***************************************************************************

 Result = SortRows(Hook, SecondEntry, FirstEntry)

 This function is called by the list viewer's sort hook when the list viewer
 wants to determine which of two list entries (list viewer rows) comes before
 the other. The column number is extracted from the list viewer and is passed
 along with the two entries to the database module, which perforns the actual
 comparison.

 The order of the two entry parameters is backwards due to the way hook func-
 tions were historically invoked on 68K systems.

 In -----------------------------------------------------------------------

 Hook = A pointer to the Hook through which this function was called. This is
	ignored by the function.

 SecondEntry = A pointer to the database record for the second entry (row) to
	be compared.

 FirstEntry = A pointer to the database record for the first entry (row) to
	be compared.

 Out ----------------------------------------------------------------------

 Result = A positive number if the first entry comes after the second, a
	negative number if the first entry comes before the second, or zero if
	the two entries are equal.

***************************************************************************/

static int32 SortRows(UNUSED struct Hook *Hk, APTR SecondEntry, APTR FirstEntry)
{
	Object *Tab;
	uint32 Column;

	// Determine which GUI tab is being displayed; that's the one that is
	// being sorted.
	Tab = GetActiveTab();

	// If we couldn't determine the active tab just pretend the two entries
	// are equal (shouldn't happen, as we won't be called unless a tab is
	// active).
	if(!Tab) return(0);

	// Get the column that's being sorted.
	Get(Tab, MUIA_List_SortColumn, &Column);

	// Let the database module work out the order, and return the result.
	return(DB_Compare(FirstEntry, SecondEntry, Column));
}

/***************************************************************************

 FunctionInfo(Entry)

 Open a synchronous (modal) requester to display the data from the specified
 database entry; that information is fetched from the database module. The
 GUI window is put to sleep while the requester is open. The function will
 return after the requester is cosed.

 In -----------------------------------------------------------------------

 Entry = A pointer to the database record to be displayed. A NULL value is
	safely ignored.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void FunctionInfo(APTR Entry)
{
	STRPTR Strings[NUM_GUI_COLUMNS];

	// Do nothing if the entry is NULL.
	if(Entry)
	{
		// Fetch the database text strings for the specified entry.
		DB_GetStrings(Entry, Strings);

		// Use the strings to build and put up the Function Info requester.
		// Put the GUI window to sleep while the requester is up.
		Set(Envmt.Wind, MUIA_Window_Sleep, TRUE);
		IMUIMaster->MUI_RequestA(Envmt.App, Envmt.Wind,
			MUIV_Requester_Image_Info, MSG_GUI_FuncInfoTitle, MSG_GUI_Okay,
			MSG_GUI_FunctionInfo, Strings);
		Set(Envmt.Wind, MUIA_Window_Sleep, FALSE);
	}
}

/***************************************************************************

 GetColumnOrder(Tab, Columns)

 Return the display order and visibility of the columns of the given GUI
 tab's list viewer. This is based on the data returned by reading the MUIA_
 List_ColumnOrder attribute of the list viewer, but with one difference:
 columns that are hidden have their column number negated (e.g., if column
 seven is hidden, the value is -7).

 Since zero negated is still zero, the function name (field zero in the data-
 base records) will always show as visible, even if that column is hidden in
 the list viewer. There's no point to the data if you don't know which func-
 tion it corresponds to...

 In -----------------------------------------------------------------------

 Tab = A pointer to a GUI tab, which is really a MUI List object.

 Columns = A pointer to an array of bytes, one per column in the list viewer,
	which will be filled in with the display order and visibility of the
	columns.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void GetColumnOrder(Object *Tab, int8 *Columns)
{
	STRPTR Format;
	uint32 Entry;
	BOOL Delim;
	TEXT Char;

	// Get the column order from the list viewer.
	Get(Tab, MUIA_List_ColumnOrder, Columns);

	// Get the column format from the list viewer.
	Get(Tab, MUIA_List_Format, &Format);

	// Scan the comma-delimited entries, one per column, in the format
	// string. Exit at the end of the string.
	Entry = 0; Delim = TRUE;	// start of string is a parameter delimiter
	while(Char = *Format++)
	{
		switch(Char)
		{
			// A comma moves us from one entry to the next. It also counts
			// as a parameter delimiter, so fall into the next case.
			case ',':
				Entry++;

			// Spaces act as parameter delimiters within each entry.
			case ' ':
				Delim = TRUE;
				break;

			// If the first character of the parameter is an 'H' then this
			// entry's column is hidden, so negate the entry's column number.
			// The  'H' is not a delimiter, so fall into the next case.
			case 'H':
			case 'h':
				if(Delim) Columns[Entry] = -Columns[Entry];

			// Ignore all other characters.
			default:
				Delim = FALSE;
		}
	}
}

/***************************************************************************

 NewBuff = PlaceString(Buffer, String, Length)

 Copy the specified string into the provided buffer. Keep track of how many
 bytes remain in the buffer, and stop copying if the buffer becomes full.
 Return the modified buffer pointer and the new number of remaining bytes,
 so that additional strings may be placed if desired. The buffer is always
 NUL terminated.

 In -----------------------------------------------------------------------

 Buffer = A pointer to a buffer where the string is to be placed.

 String = A pointer to the ASCIIZ string to be copied to the buffer.

 Length = A pointer to a variable containing the number of bytes remaining
	in the buffer. This variable is decremented as each byte is copied.
	Copying stops when Length reaches zero. If Length is already zero, no-
	thing is copied.

 Out ----------------------------------------------------------------------

 NewBuff = The address of the trailing NUL at the end of the buffer following
	the copy. Additional strings may be placed starting at this address. A
	NUL is always written to this address, even if nothing is copied.

***************************************************************************/

static STRPTR PlaceString(STRPTR Buff, STRPTR String, int32 *Len)
{
	// Copy bytes from string until trailing NUL is reached, as long as room
	// remains in the buffer.
	while(*String && *Len)
	{
		*Buff = *String++;

		// Don't increment the buffer pointer if we're out of room, so the
		// trailing NUL will overwrite the last byte copied.
		if(--*Len) Buff++;
	}

	// Make sure the buffer is NUL terminated.
	*Buff = '\0';

	// Return the new buffer address.
	return(Buff);
}

/***************************************************************************

 NewBuff = PlaceStringLeft(Buffer, String, Width, Length)

 Copy the specified string into the provided buffer, then add spaces as re-
 quired to reach the given width. The effect is to left-justify the string in
 a field of the given width. If the string length is greater than the width
 the string is truncated.

 Keep track of how many bytes remain in the buffer, and stop copying/filling
 if the buffer becomes full. Return the modified buffer pointer and the new
 number of remaining bytes, so that additional strings may be placed if de-
 sired. The buffer is always NUL terminated.

 In -----------------------------------------------------------------------

 Buffer = A pointer to a buffer where the string is to be placed.

 String = A pointer to the ASCIIZ string to be copied to the buffer.

 Width = The number of characters to be placed into the buffer (not counting
	the trailing NUL). If the string is shorter than this, spaces are added
	to make up the difference. If the string is longer than this, it is trun-
	cated. If zero then nothing is copied.

 Length = A pointer to a variable containing the number of bytes remaining
	in the buffer. This variable is decremented as each byte is copied/fill-
	ed.	Copying/filling stops when Length reaches zero. If Length is already
	zero, nothing is copied.

 Out ----------------------------------------------------------------------

 NewBuff = The address of the trailing NUL at the end of the buffer following
	the copy/fill. Additional strings may be placed starting at this address.
	A NUL is always written to this address, even if nothing is copied.

***************************************************************************/

static STRPTR PlaceStringLeft(STRPTR Buff, STRPTR String, int32 Wid, int32 *Len)
{
	// Place bytes into buffer as long as room remains in the buffer and we
	// haven't reached the specified width.
	while(Wid-- && *Len)
	{
		// Bytes are copied from the string until we reach its end; after
		// that we fill with spaces.
		if(*String) *Buff = *String++;
		else *Buff = ' ';

		// Don't increment the buffer pointer if we're out of room, so the
		// trailing NUL will overwrite the last byte copied.
		if(--*Len) Buff++;
	}

	// Make sure the buffer is NUL terminated.
	*Buff = '\0';

	// Return the new buffer address.
	return(Buff);
}

/***************************************************************************

 NewBuff = PlaceStringRight(Buffer, String, Width, Length)

 Copy the specified string into the provided buffer, preceeded by as many
 spaces as required to reach the given width. The effect is to right-justify
 the string in a field of the given width. If the string length is greater
 than the width the string is truncated (currently the string is truncated on
 the right; truncating on the left might be better).

 Keep track of how many bytes remain in the buffer, and stop copying/filling
 if the buffer becomes full. Return the modified buffer pointer and the new
 number of remaining bytes, so that additional strings may be placed if de-
 sired. The buffer is always NUL terminated.

 In -----------------------------------------------------------------------

 Buffer = A pointer to a buffer where the string is to be placed.

 String = A pointer to the ASCIIZ string to be copied to the buffer.

 Width = The number of characters to be placed into the buffer (not counting
	the trailing NUL). If the string is shorter than this, spaces are added
	to make up the difference. If the string is longer than this, it is trun-
	cated. If zero then nothing is copied.

 Length = A pointer to a variable containing the number of bytes remaining
	in the buffer. This variable is decremented as each byte is copied/fill-
	ed.	Copying/filling stops when Length reaches zero. If Length is already
	zero, nothing is copied.

 Out ----------------------------------------------------------------------

 NewBuff = The address of the trailing NUL at the end of the buffer following
	the copy/fill. Additional strings may be placed starting at this address.
	A NUL is always written to this address, even if nothing is copied.

***************************************************************************/

static STRPTR PlaceStringRight(STRPTR Buff, STRPTR String, int32 Wid, int32 *Len)
{
	int32 Fill;

	// Determine the number of spaces that need to be added ahead of the
	// string.
	Fill = Wid - strlen(String);
	if(Fill < 0) Fill = 0;

	// Place bytes into buffer as long as room remains in the buffer and we
	// haven't reached the specified width.
	while(Wid-- && *Len)
	{
		// Fill with the appropriate number of spaces, then copy bytes from
		// the string. We know we won't exceed the end of the string.
		if(Fill) {*Buff = ' '; Fill--;}
		else *Buff = *String++;

		// Don't increment the buffer pointer if we're out of room, so the
		// trailing NUL will overwrite the last byte copied.
		if(--*Len) Buff++;
	}

	// Make sure the buffer is NUL terminated.
	*Buff = '\0';

	// Return the new buffer address.
	return(Buff);
}

/***************************************************************************

 Success = WriteTextHeader(File, Name, Columns)

 Write a header to the specified text file, for the target program with the
 given name, matching the column titles to the order and visibility of the
 GUI tab columns. The header identifies the target being profiled, and pro-
 vides column titles for the following records.

 Note that the function name column is always present, even if it's hidden
 in the list viewer.

 In -----------------------------------------------------------------------

 File = A handle to an open disk file to which the header is to be written.

 Name = A pointer to an ASCIIZ string with the name of the target tab. The
	first two characters of the name are "n:", where 'n' is the target num-
	ber; following that is the name of the target program itself.

 Columns = A pointer to an array of bytes, one per column in the list viewer,
	which contain the display order and visibility of the columns.

 Out ----------------------------------------------------------------------

 Success = FALSE if an error occurred (IoErr() will return the error code),
	or TRUE if the operation was successful.

***************************************************************************/

static BOOL WriteTextHeader(BPTR File, STRPTR Name, int8 *Columns)
{
	TEXT Buffer[TEXT_BUF_LEN];
	TEXT Dashes[32];
	STRPTR Buff;
	int32 Room, Field;
	uint32 i;

	// Skip over the first two characters (the target number and the sep-
	// arator), so the name is that of the program being profiled.
	if(Name) Name += 2;

	// If there's no name supplied, use a blank name instead.
	else Name = "";

	// Place the target ID message into the buffer, followed by the name of
	// the target program, followed by a newline to terminate the line.
	Buff = Buffer; Room = TEXT_BUF_LEN;
	Buff = PlaceString(Buff, MSG_GUI_FileHeader, &Room);
	Buff = PlaceString(Buff, Name, &Room);
	Buff = PlaceString(Buff, LF, &Room);

	// Write the buffer (minus the trailing NUL) to the file. Abort if
	// there's an error.
	if(IDOS->FPuts(File, Buffer)) return(FALSE); 

	// Build the column titles in the buffer, matching the column order and
	// visibility of the columns in the GUI's list viewer.
	Buff = Buffer; Room = TEXT_BUF_LEN;
	for(i = 0; i < NUM_GUI_COLUMNS; i++)
	{
		// Cache the database field associated with this column.
		Field = (int32)Columns[i];

		// Skip columns that are hidden.
		if(Field < 0) continue;

		// Place the appropriate title for columns that are visible.
		switch(Field)
		{
			// The function name and source location titles are left justi-
			// fied.
			case 0:
			case 1:
				Buff = PlaceStringLeft(Buff, Msgs[MSN_GUI_TextHeader+Field],
					ColumnWidth[Field] - 1, &Room);
				break;

			// All other titles are right justified.
			default:
				Buff = PlaceStringRight(Buff, Msgs[MSN_GUI_TextHeader+Field],
					ColumnWidth[Field] - 1, &Room);
		}

		// Add a single space to separate the columns.
		if(i < NUM_GUI_COLUMNS - 1) Buff = PlaceString(Buff, Space, &Room);
	}

	// Terminate the titles with a newline.
	Buff = PlaceString(Buff, LF, &Room);

	// Write the buffer (minus the trailing NUL) to the file. Abort if
	// there's an error.
	if(IDOS->FPuts(File, Buffer)) return(FALSE); 

	// We need a string of dashes for use below.
	memset(Dashes, '-', 31);
	Dashes[31] = '\0';

	// Build a line of dashes in the buffer to go under the column titles,
	// matching the column order and visibility of the columns in the GUI's
	// list viewer.
	Buff = Buffer; Room = TEXT_BUF_LEN;
	for(i = 0; i < NUM_GUI_COLUMNS; i++)
	{
		// Cache the database field associated with this column.
		Field = (int32)Columns[i];

		// Skip columns that are hidden.
		if(Field < 0) continue;

		// For columns that are visible, add dashes equal to one less than
		// the column width.
		Buff = PlaceStringLeft(Buff, Dashes, ColumnWidth[Field] - 1,
			&Room);

		// Followed by a single space to separate the columns.
		if(i < NUM_GUI_COLUMNS - 1) Buff = PlaceString(Buff, Space, &Room);
	}

	// Terminate the dashes with a newline.
	Buff = PlaceString(Buff, LF, &Room);

	// Write the buffer (minus the trailing NUL) to the file. Abort if
	// there's an error.
	if(IDOS->FPuts(File, Buffer)) return(FALSE); 

	// If we're here, then all is well.
	return(TRUE);
}

/***************************************************************************

 Success = WriteTextRecord(File, Entry, Columns)

 Write a record for the given database entry to the specified text file,
 matching the written columns to the order and visibility of the GUI tab.

 Note that the function name column is always present, even if it's hidden
 in the list viewer.

 In -----------------------------------------------------------------------

 File = A handle to an open disk file to which the record is to be written.

 Entry = A pointer to the database record for the entry (row) to be written.

 Columns = A pointer to an array of bytes, one per column in the list viewer,
	which contain the display order and visibility of the columns.

 Out ----------------------------------------------------------------------

 Success = FALSE if an error occurred (IoErr() will return the error code),
	or TRUE if the operation was successful.

***************************************************************************/

static BOOL WriteTextRecord(BPTR File, APTR Entry, int8 *Columns)
{
	STRPTR Buff, Strings[NUM_GUI_COLUMNS];
	TEXT Buffer[TEXT_BUF_LEN];
	int32 Room, Field;
	uint32 i;

	// Get the content strings for each of the record's fields.
	DB_GetStrings(Entry, Strings);

	// Build the record in the buffer, matching the column order and visibil-
	// ity of the columns in the GUI's list viewer.
	Buff = Buffer; Room = TEXT_BUF_LEN;
	for(i = 0; i < NUM_GUI_COLUMNS; i++)
	{
		// Cache the database field associated with this column.
		Field = (int32)Columns[i];

		// Skip columns that are hidden.
		if(Field < 0) continue;

		// Place the appropriate content string for columns that are visible.
		switch(Field)
		{
			// The function name and source location columns are left justi-
			// fied.
			case 0:
			case 1:
				Buff = PlaceStringLeft(Buff, Strings[Field],
					ColumnWidth[Field] - 1, &Room);
				break;

			// All other columns are right justified.
			default:
				Buff = PlaceStringRight(Buff, Strings[Field],
					ColumnWidth[Field] - 1, &Room);
		}

		// Add a space between the columns.
		if(i < NUM_GUI_COLUMNS - 1) Buff = PlaceString(Buff, Space, &Room);
	}

	// Terminate the record with a newline.
	Buff = PlaceString(Buff, LF, &Room);

	// Write the buffer (minus the trailing NUL) to the file. Abort if
	// there's an error.
	if(IDOS->FPuts(File, Buffer)) return(FALSE); 

	// If we're here, then all is well.
	return(TRUE);
}

/***************************************************************************

 Success = WriteCSVHeader(File, Name)

 Write a header to the specified CSV file, for the target program with the
 given name. The header identifies the target being profiled, and enumerates
 the fields and units of the following records.

 In -----------------------------------------------------------------------

 File = A handle to an open disk file to which the header is to be written.

 Name = A pointer to an ASCIIZ string with the name of the target tab. The
	first two characters of the name are "n:", where 'n' is the target num-
	ber; following that is the name of the target program itself.

 Out ----------------------------------------------------------------------

 Success = FALSE if an error occurred (IoErr() will return the error code),
	or TRUE if the operation was successful.

***************************************************************************/

static BOOL WriteCSVHeader(BPTR File, STRPTR Name)
{
	TEXT Buffer[CSV_BUF_LEN];
	STRPTR Buff;
	int32 Room;

	// Skip over the first two characters (the target number and the sep-
	// arator), so the name is that of the program being profiled.
	if(Name) Name += 2;

	// If there's no name supplied, use a blank name instead.
	else Name = "";

	// Place the target ID message into the buffer, followed by the name of
	// the target program, followed by a newline to terminate the line.
	Buff = Buffer; Room = CSV_BUF_LEN;
	Buff = PlaceString(Buff, MSG_GUI_FileHeader, &Room);
	Buff = PlaceString(Buff, Name, &Room);
	Buff = PlaceString(Buff, LF, &Room);

	// Write the buffer (minus the trailing NUL) to the file. Abort if
	// there's an error.
	if(IDOS->FPuts(File, Buffer)) return(FALSE); 

	// Place the header into the buffer, followed by a newline to terminate
	// the line.
	Buff = Buffer; Room = CSV_BUF_LEN;
	Buff = PlaceString(Buff, MSG_GUI_CSVHeader, &Room);

	// Write the buffer (minus the trailing NUL) to the file. Abort if
	// there's an error.
	if(IDOS->FPuts(File, Buffer)) return(FALSE); 

	// If we're here, then all is well.
	return(TRUE);
}

/***************************************************************************

 Success = WriteCSVRecord(File, Entry)

 Write a record for the given database entry to the specified CSV file. Raw
 unformatted data is used so the units will always be the same, making it
 easier to use the CSV data in other applications. Similarly, the order of
 the fields is fixed, and all fields are always present.

 In -----------------------------------------------------------------------

 File = A handle to an open disk file to which the record is to be written.

 Entry = A pointer to the database record for the entry (row) to be written.

 Out ----------------------------------------------------------------------

 Success = FALSE if an error occurred (IoErr() will return the error code),
	or TRUE if the operation was successful.

***************************************************************************/

static BOOL WriteCSVRecord(BPTR File, APTR Entry)
{
	APTR Data[NUM_GUI_COLUMNS];
	TEXT Buffer[CSV_BUF_LEN];

	// Get pointers to the raw data in the database record.
	DB_GetData(Entry, Data);

	// Convert the raw data to text and put it into the buffer, delimited
	// with commas and terminated with a newline.
	snprintf(Buffer, CSV_BUF_LEN, "%s,%s,%lu,%llu,%u,%llu,%llu,%u,%llu\n",
		(STRPTR)Data[0], (STRPTR)Data[1], *(uint32 *)Data[2],
		*(uint64 *)Data[3], *(uint16 *)Data[4], *(uint64 *)Data[5],
		*(uint64 *)Data[6], *(uint16 *)Data[7], *(uint64 *)Data[8]);

	// Write the buffer (minus the trailing NUL) to the file. Abort if
	// there's an error.
	if(IDOS->FPuts(File, Buffer)) return(FALSE); 

	// If we're here, then all is well.
	return(TRUE);
}

/***************************************************************************

 Success = SaveProfileData(Name, CSV)

 Save the profile data corresponding to the active GUI tab to a disk file
 with the given name (with optional path). The file may be formatted as
 either a regular text file or as a CSV file, as specified by the caller.
 If saving as a text file the order of the saved entries is the same as cur-
 rently displayed in the GUI tab, and only those columns currently displayed
 are saved; for a CSV file the sort order is fixed, and all columns are
 saved.

 The name is checked to see if there is already a file by that name, and if
 so the user is given the option to overwrite the file or to abort the save.
 If errors occur during the save, a requester is used to let the user know
 what went wrong.

 The caller is assumed to have put the parent window to sleep before calling
 this function, and to have told DOS to put its requesters up on the GUI
 window's screen, rather than the default screen.

 In -----------------------------------------------------------------------

 Name = The name of the file to be written, with optional path.

 CSV = TRUE if the profile is to be saved as a CSV file, or FALSE if the pro-
	file is to be saved as regular text.

 Out ----------------------------------------------------------------------

 Success = TRUE if the profile data has successfully been saved, or FALSE if
	not. FALSE may be returned due to an error (IoErr() will have more de-
	tail), or because the user chose not to overwrite an existing file.

***************************************************************************/

static BOOL SaveProfileData(STRPTR Name, BOOL CSV)
{
	Object *Tab;
	BPTR FileLock, File;
	APTR Entry;
	STRPTR Mesg, TargetName;
	uint32 i, Target, Err;
	int8 Columns[NUM_GUI_COLUMNS];

	// Clear any existing DOS errors.
	IDOS->SetIoErr(0);

	// Determine which GUI tab is active; that's the one whose profile data
	// we'll save. Abort if we can't determine the active tab. That should
	// never happen, so we won't bother with an error message.
	Tab = GetActiveTab();
	if(!Tab) return(FALSE);

	// Make sure the tab is a target tab and not the default tab. The 'Save'
	// menus are disabled for the default tab so it shouldn't happen, but if
	// it does just do nothing. Again, we won't bother with an error message.
	Target = muiUserData(Tab);
	if(!Target) return(FALSE);

	// Get the name of the target tab, which contains the name of the target
	// program.
	TargetName = DB_Title(Target);

	// Get the column sort order of the list viewer.
	GetColumnOrder(Tab, Columns);

	// Assume no errors until we find out otherwise.
	Mesg = NULL;

	// See if a file with the given name already exists by attempting to get
	// a lock on it. This will fail to detect the case where the file exists
	// but has an exclusive lock on it, but we can't open the file in that
	// case anyway, so no harm done.
	FileLock = IDOS->Lock(Name, SHARED_LOCK);
	if(FileLock)
	{
		// We got the lock, so a file with this name must already exist.
		// Remove the lock, which is no longer needed.
		IDOS->UnLock(FileLock);

		// Use a requester to inform the user, and let them decide whether
		// to continue or not.
		Err = IMUIMaster->MUI_Request(Envmt.App, Envmt.Wind,
			MUIV_Requester_Image_Warning, NULL,
			MSG_GUI_OverwriteOrCancel, MSG_GUI_FileExists);

		// Abort if the user has chosen not to continue.
		if(!Err) return(FALSE);
	}

	// Open the file to be written. The file will be created if it doesn't
	// exist, and will be deleted and recreated if it does. This will fail if
	// the file exists but has an exclusive lock on it.
	File = IDOS->FOpen(Name, MODE_NEWFILE, 0);
	if(!File)
	{
		// Notify the user and bail out if we can't open the file.
		Mesg = MSG_GUI_CantAccess;
		goto Done;
	}

	// The file is open. Write the appropriate header to it.
	if(!(CSV ? WriteCSVHeader(File, TargetName) :
		WriteTextHeader(File, TargetName, Columns)))
	{
		// Notify the user and bail out if we can't write to the file.
		Mesg = MSG_GUI_WriteError;
		goto Done;
	}

	// Get the first entry in the tab's list viewer. May be NULL if the list
	// is empty; in that case the file will contain only the header.
	i = 0;
	IIntuition->IDoMethod(Tab, MUIM_List_GetEntry, i++, &Entry);

	// Iterate through the entries in the list viewer.
	while(Entry)
	{
		// Write a line to the file with this entry's data.
		if(!(CSV ? WriteCSVRecord(File, Entry) :
			WriteTextRecord(File, Entry, Columns)))
		{
			// Notify the user and bail out if we can't write to the file.
			Mesg = MSG_GUI_WriteError;
			goto Done;
		}

		// Get the next entry, or NULL if none.
		IIntuition->IDoMethod(Tab, MUIM_List_GetEntry, i++, &Entry);
	}

	// Come here when we're done writing to the file. This may be because
	// we've written all the data, or it may be because we're bailing out
	// early due to an error. Close the file, errors or not.
Done:
	IDOS->FClose(File);

	// See if there's anything we need to tell the user.
	if(Mesg)
	{
		// An error occurred during the save. Let the user know what went
		// wrong.
		IMUIMaster->MUI_Request(Envmt.App, Envmt.Wind,
			MUIV_Requester_Image_Error, NULL, MSG_GUI_Okay,
			(CSV ? MSG_GUI_SaveCSVError : MSG_GUI_SaveTextError), Mesg);
	}

	// Let the caller know how it went.
	return(BOOL)(Mesg ? FALSE : TRUE);
}

/***************************************************************************

 CloseWind()

 The user clicked on the GUI window's close box. Since this is the program's
 only window, this is the same as selecting the Quit menu item.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void CloseWind(void)
{
	MenuQuit();
}

/***************************************************************************

 DoubleClick(Hook, Viewer)

 The user has double-clicked (or pressed Return) on a line in one of the
 GUI's list viewers. Display the function information requester for the func-
 tion that inhabits that line. Return when the requester is closed.

 In -----------------------------------------------------------------------

 Hook = A pointer to the Hook through which this function was called. This is
	ignored by the function.

 Viewer = A pointer to the list viewer that was double-clicked.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void DoubleClick(UNUSED struct Hook *Hk, Object *Viewer)
{
	APTR Entry;

	// Get a pointer to the active list entry.
	IIntuition->IDoMethod(Viewer, MUIM_List_GetEntry, 
		MUIV_List_GetEntry_Active, &Entry);

	// Put up the Function Info requester for that entry.
	FunctionInfo(Entry);
}

/***************************************************************************

 MenuQuit()

 The user has selected the Quit option from the Profyler menu. Close the GUI
 window and any accessories it opened, then signal the MUI application to
 quit.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void MenuQuit(void)
{
	// Close the GUI window and the 'About' window (if open). This isn't
	// strictly necessary, since closing the app will close these too, but
	// it seems cleaner this way.
	Set(Envmt.AboutWind, MUIA_Window_Open, FALSE);
	Set(Envmt.Wind, MUIA_Window_Open, FALSE);

	// Tell the MUI application to exit the main loop and quit.
	IIntuition->IDoMethod(Envmt.App, MUIM_Application_ReturnID, 
		MUIV_Application_ReturnID_Quit);
}

/***************************************************************************

 MenuScan()

 The user has selected the Scan for Target option from the Contact menu. Ask
 the IPC module to scan for any new target programs that may be running, but
 that we're not currently tracking.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void MenuScan(void)
{
	IPC_Scan();
}

/***************************************************************************

 MenuUpdate()

 The user has selected the Update option from the Target menu. Determine
 which target tab is active, then ask the IPC module to fetch the latest pro-
 file data from that target and update the GUI display.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void MenuUpdate(void)
{
	Object *Tab;
	uint32 Target;

	// Determine which GUI tab is being displayed; that's the one that is
	// being updated. Abort if we can't determine the active tab.
	Tab = GetActiveTab();
	if(!Tab) return;

	// Get the tab's associated target (zero if it's the default tab).
	Target = muiUserData(Tab);
	
	// Update the database and GUI with the latest profile data from the
	// target. Safely do nothing if the default tab is active.
	IPC_Update(Target);
}

/***************************************************************************

 MenuSaveText()

 The user has selected the Save As Text option from the Target menu. Use a
 file requester to get the name of the file to save to, then call SavePro-
 fileData() to perform the actual save.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void MenuSaveText(void)
{
	struct Window *Wind;
	struct FileRequester *FileReq;
	TEXT Filename[MAX_FILENAME_LEN + 1];

	// Tell DOS to open its requesters on the screen containing our window,
	// instead of on the default public screen.
	APP_SetDOSErrWind((APTR)Envmt.Wind);

	// Put the window to sleep during the export.
	Set(Envmt.Wind, MUIA_Window_Sleep, TRUE);

	// Use a file requester to get a name and optional location for the text
	// file from the user. Do nothing if the user cancels the requester or
	// fails to enter a filename.
	FileReq = APP_GetFileReq();
	Get(Envmt.Wind, MUIA_Window_Window, &Wind);
	if(IMUIMaster->MUI_AslRequestTags(FileReq, ASLFR_DoSaveMode, TRUE,
		ASLFR_TitleText, MSG_GUI_SaveTextTitle,
		ASLFR_PositiveText, MSG_GUI_SaveOkay,
		ASLFR_NegativeText, MSG_GUI_SaveCancel,
		ASLFR_Window, Wind, TAG_END)

		// Make sure the user entered a filename.
		&& FileReq->fr_File[0])
	{
		// We got a filename and optional location. Concatenate them to
		// create a combined drawer and file name.
		STRCPYN(Filename, FileReq->fr_Drawer, MAX_FILENAME_LEN);
		if(IDOS->AddPart(Filename, FileReq->fr_File, MAX_FILENAME_LEN))
		{
			// Save the database to the named file as a text file, and notify
			// the user of any errors. Ignore the return code, as we do the
			// same thing whether or not the save was successful.
			SaveProfileData(Filename, FALSE);
		}
	}

	// Re-awaken the window.
	Set(Envmt.Wind, MUIA_Window_Sleep, FALSE);

	// Restore DOS to opening its requesters on the default public screen.
	APP_SetDOSErrWind(NULL);
}

/***************************************************************************

 MenuSaveCSV()

 The user has selected the Save As CSV option from the Target menu. Use a
 file requester to get the name of the file to save to, then call SavePro-
 fileData() to perform the actual save.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

static void MenuSaveCSV(void)
{
	struct Window *Wind;
	struct FileRequester *FileReq;
	TEXT Filename[MAX_FILENAME_LEN + 1];

	// Tell DOS to open its requesters on the screen containing our window,
	// instead of on the default public screen.
	APP_SetDOSErrWind((APTR)Envmt.Wind);

	// Put the window to sleep during the export.
	Set(Envmt.Wind, MUIA_Window_Sleep, TRUE);

	// Use a file requester to get a name and optional location for the CSV
	// file from the user. Do nothing if the user cancels the requester or
	// fails to enter a filename.
	FileReq = APP_GetFileReq();
	Get(Envmt.Wind, MUIA_Window_Window, &Wind);
	if(IMUIMaster->MUI_AslRequestTags(FileReq, ASLFR_DoSaveMode, TRUE,
		ASLFR_TitleText, MSG_GUI_SaveCSVTitle,
		ASLFR_PositiveText, MSG_GUI_SaveOkay,
		ASLFR_NegativeText, MSG_GUI_SaveCancel,
		ASLFR_Window, Wind, TAG_END)

		// Make sure the user entered a filename.
		&& FileReq->fr_File[0])
	{
		// We got a filename and optional location. Concatenate them to
		// create a combined drawer and file name.
		STRCPYN(Filename, FileReq->fr_Drawer, MAX_FILENAME_LEN);
		if(IDOS->AddPart(Filename, FileReq->fr_File, MAX_FILENAME_LEN))
		{
			// Save the database to the named file as a CSV file, and notify
			// the user of any errors. Ignore the return code, as we do the
			// same thing whether or not the save was successful.
			SaveProfileData(Filename, TRUE);
		}
	}

	// Re-awaken the window.
	Set(Envmt.Wind, MUIA_Window_Sleep, FALSE);

	// Restore DOS to opening its requesters on the default public screen.
	APP_SetDOSErrWind(NULL);
}

// -------------------------------------------------------------------------
// === Public code ===

/***************************************************************************

 Success = GUI_Start(App)

 Initialize the User Interface module when the program starts up. If success-
 ful, the module is ready for action. If not, the program must abort. If in-
 itialization fails then everything has been cleaned up, and there is no need
 to call GUI_Stop().

 In -----------------------------------------------------------------------

 App = A pointer to the MUI application object for the Profyler program. The
	pointer is cached within the GUI module for future use.

 Out ----------------------------------------------------------------------

 Success = TRUE if the initialization was successful, or FALSE if it failed.

***************************************************************************/

BOOL GUI_Start(Object *App)
{
	// Cache a pointer to the MUI application object for later use.
	Envmt.App = App;

	// Create our custom Title class, a subclass of MUI's standard Title
	// class. Clean up and abort if the custom class could not be created.
	Envmt.Title_Class = IMUIMaster->MUI_CreateCustomClass(NULL, MUIC_Title,
		NULL, 0, (APTR)Title_Dispatcher);
	if(!Envmt.Title_Class) goto Fail;

	// Create the default tab, displayed when no targets are available. The
	// other tabs are created dynamically, as needed. First, create a text
	// object to serve as the contents of the tab.
	Envmt.TargetView[0] = IMUIMaster->TextObject,
		MUIA_Text_Contents, MSG_GUI_NoTargetsHelp,
		MUIA_Text_PreParse, "\033c",
		MUIA_UserData, 0,
	End;

	// Create another text object with the tab's title.
	Envmt.TargetTitle[0] = IMUIMaster->TextObject,
		MUIA_Text_Contents, MSG_GUI_NoTargets,
		MUIA_UserData, 0,
		MUIA_Draggable, TRUE,
		MUIA_Dropable, TRUE,
	End;

	// Create a title object to organize the tabs, using our custom Title
	// class. For now it contains only the default tab.
	Envmt.TargetTabs = IIntuition->NewObject(Envmt.Title_Class->mcc_Class,
		NULL,
		MUIA_Title_Closable, TRUE,
		MUIA_Title_Sortable, TRUE,
		Child, Envmt.TargetTitle[0],
	End;

	// Create a group to hold the title and its tabs. For now it contains
	// only the default tab.
	Envmt.TargetGroup = IMUIMaster->VGroup,
		Child, Envmt.TargetTabs,
		Child, Envmt.TargetView[0],
	End;

	// Create the main group to hold the window contents. We shouldn't need
	// to do this, as the only object in the window is already a group. But
	// adding a new tab does not clear the background properly unless this
	// parent group is present.
	Envmt.MainGroup = IMUIMaster->VGroup,
		Child, Envmt.TargetGroup,
	End;

	// Create the Profyler menu.
	Envmt.MenuAbout = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, MSG_GUI_About,
		MUIA_Menuitem_Shortcut, MSG_GUI_AboutShortcut,
	End;

	Envmt.MenuAboutMUI = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, MSG_GUI_AboutMUI,
	End;

	Envmt.MenuMUISettings = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, MSG_GUI_MUISettings,
	End;

	Envmt.MenuBar1 = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, NM_BARLABEL,
	End;

	Envmt.MenuQuit = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, MSG_GUI_Quit,
	End;

	Envmt.MenuProfyler = IMUIMaster->MenuObject,
		MUIA_Menu_Title, MSG_GUI_ProfylerMenu,
		MUIA_Family_Child, Envmt.MenuAbout,
		MUIA_Family_Child, Envmt.MenuAboutMUI,
		MUIA_Family_Child, Envmt.MenuMUISettings,
		MUIA_Family_Child, Envmt.MenuBar1,
		MUIA_Family_Child, Envmt.MenuQuit,
	End;
	
	// Create the Contact menu.
	Envmt.MenuScan = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, MSG_GUI_Scan,
		MUIA_Menuitem_Shortcut, MSG_GUI_ScanShortcut,
	End;

	Envmt.MenuContact = IMUIMaster->MenuObject,
		MUIA_Menu_Title, MSG_GUI_ContactMenu,
		MUIA_Family_Child, Envmt.MenuScan,
	End;

	// Create the Target menu.
	Envmt.MenuUpdate = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, MSG_GUI_Update,
		MUIA_Menuitem_Shortcut, MSG_GUI_UpdateShortcut,
	End;

	Envmt.MenuBar2 = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, NM_BARLABEL,
	End;

	Envmt.MenuSaveText = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, MSG_GUI_SaveText,
		MUIA_Menuitem_Shortcut, MSG_GUI_TextShortcut,
	End;

	Envmt.MenuSaveCSV = IMUIMaster->MenuitemObject,
		MUIA_Menuitem_Title, MSG_GUI_SaveCSV,
		MUIA_Menuitem_Shortcut, MSG_GUI_CSVShortcut,
	End;

	Envmt.MenuTarget = IMUIMaster->MenuObject,
		MUIA_Menu_Title, MSG_GUI_TargetMenu,
		MUIA_Menu_Enabled, FALSE,
		MUIA_Family_Child, Envmt.MenuUpdate,
		MUIA_Family_Child, Envmt.MenuBar2,
		MUIA_Family_Child, Envmt.MenuSaveText,
		MUIA_Family_Child, Envmt.MenuSaveCSV,
	End;

	// Create the window's menu strip.
	Envmt.MenuStrip = IMUIMaster->MenustripObject,
		MUIA_Family_Child, Envmt.MenuProfyler,
		MUIA_Family_Child, Envmt.MenuContact,
		MUIA_Family_Child, Envmt.MenuTarget,
	End;

	// Build the window itself. This will fail (and MUI will clean up) if
	// any of the above objects could not be created.
	Envmt.Wind = IMUIMaster->WindowObject,
		MUIA_Window_ID, MAKE_ID('P', 'F', 'Y', 'L'),
		MUIA_Window_Title, PROG_NAME,
		MUIA_Window_ScreenTitle, PROG_NAME,
		MUIA_Window_Menustrip, Envmt.MenuStrip,
		WindowContents, Envmt.MainGroup,
	End;

	// If anything went wrong, bail out. Otherwise, add the window to the
	// application.
	if(!Envmt.Wind) goto Fail;
	IIntuition->IDoMethod(Envmt.App, OM_ADDMEMBER, Envmt.Wind);

	// Create the 'About' window.
	Envmt.AboutWind = IMUIMaster->AboutboxObject,
		MUIA_Aboutbox_Credits, MSG_GUI_LicenseNotice,
	End;

	// If anything went wrong, bail out. Otherwise, add the window to the
	// application.
	if(!Envmt.AboutWind) goto Fail;
	IIntuition->IDoMethod(Envmt.App, OM_ADDMEMBER, Envmt.AboutWind);

	// Create the notification hooks. Abort if any of the allocations fails.
	Envmt.CloseHook = IExec->AllocSysObjectTags(ASOT_HOOK,
		ASOHOOK_Entry, CloseWind, TAG_END);
	if(!Envmt.CloseHook) goto Fail;

	Envmt.DoubleClickHook = IExec->AllocSysObjectTags(ASOT_HOOK,
		ASOHOOK_Entry, DoubleClick, TAG_END);
	if(!Envmt.DoubleClickHook) goto Fail;

	Envmt.MenuQuitHook = IExec->AllocSysObjectTags(ASOT_HOOK,
		ASOHOOK_Entry, MenuQuit, TAG_END);
	if(!Envmt.MenuQuitHook) goto Fail;

	Envmt.MenuScanHook = IExec->AllocSysObjectTags(ASOT_HOOK,
		ASOHOOK_Entry, MenuScan, TAG_END);
	if(!Envmt.MenuScanHook) goto Fail;

	Envmt.MenuUpdateHook = IExec->AllocSysObjectTags(ASOT_HOOK,
		ASOHOOK_Entry, MenuUpdate, TAG_END);
	if(!Envmt.MenuUpdateHook) goto Fail;

	Envmt.MenuSaveTextHook = IExec->AllocSysObjectTags(ASOT_HOOK,
		ASOHOOK_Entry, MenuSaveText, TAG_END);
	if(!Envmt.MenuSaveTextHook) goto Fail;

	Envmt.MenuSaveCSVHook = IExec->AllocSysObjectTags(ASOT_HOOK,
		ASOHOOK_Entry, MenuSaveCSV, TAG_END);
	if(!Envmt.MenuSaveCSVHook) goto Fail;

	// Create the list viewer hooks. Abort if any of the allocations fails.
	Envmt.DisplayHook = IExec->AllocSysObjectTags(ASOT_HOOK,
		ASOHOOK_Entry, DisplayRow, TAG_END);
	if(!Envmt.DisplayHook) goto Fail;

	Envmt.SortHook = IExec->AllocSysObjectTags(ASOT_HOOK,
		ASOHOOK_Entry, SortRows, TAG_END);
	if(!Envmt.SortHook) goto Fail;

	// Set up the notifications. Presumably this can't fail.
	IIntuition->IDoMethod(Envmt.Wind, MUIM_Notify,
			 MUIA_Window_CloseRequest, TRUE,
			 MUIV_Notify_Self, 2, MUIM_CallHook, Envmt.CloseHook);

	IIntuition->IDoMethod(Envmt.MenuAbout, MUIM_Notify,
			 MUIA_Menuitem_Trigger, MUIV_EveryTime,
			 Envmt.AboutWind, 3, MUIM_Set, MUIA_Window_Open, TRUE);

	IIntuition->IDoMethod(Envmt.MenuAboutMUI, MUIM_Notify,
			 MUIA_Menuitem_Trigger, MUIV_EveryTime,
			 Envmt.App, 2, MUIM_Application_AboutMUI, Envmt.Wind);

	IIntuition->IDoMethod(Envmt.MenuMUISettings, MUIM_Notify,
			 MUIA_Menuitem_Trigger, MUIV_EveryTime,
			 Envmt.App, 3, MUIM_Application_OpenConfigWindow, 0, NULL);

	IIntuition->IDoMethod(Envmt.MenuQuit, MUIM_Notify,
			 MUIA_Menuitem_Trigger, MUIV_EveryTime,
			 MUIV_Notify_Self, 2, MUIM_CallHook, Envmt.MenuQuitHook);

	IIntuition->IDoMethod(Envmt.MenuScan, MUIM_Notify,
			 MUIA_Menuitem_Trigger, MUIV_EveryTime,
			 MUIV_Notify_Self, 2, MUIM_CallHook, Envmt.MenuScanHook);

	IIntuition->IDoMethod(Envmt.MenuUpdate, MUIM_Notify,
			 MUIA_Menuitem_Trigger, MUIV_EveryTime,
			 MUIV_Notify_Self, 2, MUIM_CallHook, Envmt.MenuUpdateHook);

	IIntuition->IDoMethod(Envmt.MenuSaveText, MUIM_Notify,
			 MUIA_Menuitem_Trigger, MUIV_EveryTime,
			 MUIV_Notify_Self, 2, MUIM_CallHook, Envmt.MenuSaveTextHook);

	IIntuition->IDoMethod(Envmt.MenuSaveCSV, MUIM_Notify,
			 MUIA_Menuitem_Trigger, MUIV_EveryTime,
			 MUIV_Notify_Self, 2, MUIM_CallHook, Envmt.MenuSaveCSVHook);

	// All is well- open the GUI window.
	Set(Envmt.Wind, MUIA_Window_Open, TRUE);

	// Return success.
	return(TRUE);

	// Come here if startup fails.
Fail:
	// Clean up anything that was successfully created.
	GUI_Stop();

	// Let the caller know we've failed.
	return(FALSE);
}

/***************************************************************************

 GUI_Stop()

 Shut down the User Interface module when the program is quit. No harm comes
 if the module has never been initialized, if the initialization failed, or
 if GUI_Stop() has already been called.

 In -----------------------------------------------------------------------

 Nothing.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void GUI_Stop(void)
{
	// Shut down the 'About' window, if present.
	if(Envmt.AboutWind)
	{
		// Close the window. No harm if it's already closed.
		Set(Envmt.AboutWind, MUIA_Window_Open, FALSE);

		// Remove the window from the application.
		IIntuition->IDoMethod(Envmt.App, OM_REMMEMBER, Envmt.AboutWind);

		// Dispose of the window.
		IMUIMaster->MUI_DisposeObject(Envmt.AboutWind);
	}

	// Shut down the GUI window, if present.
	if(Envmt.Wind)
	{
		// Close the window. No harm if it's already closed.
		Set(Envmt.Wind, MUIA_Window_Open, FALSE);

		// Remove the window from the application.
		IIntuition->IDoMethod(Envmt.App, OM_REMMEMBER, Envmt.Wind);

		// Dispose of the window and all of its objects, including any tabs
		// that are open.
		IMUIMaster->MUI_DisposeObject(Envmt.Wind);
	}

	// Free any hooks that were allocated.
	if(Envmt.CloseHook)
		IExec->FreeSysObject(ASOT_HOOK, Envmt.CloseHook);

	if(Envmt.DoubleClickHook)
		IExec->FreeSysObject(ASOT_HOOK, Envmt.DoubleClickHook);

	if(Envmt.MenuQuitHook)
		IExec->FreeSysObject(ASOT_HOOK, Envmt.MenuQuitHook);

	if(Envmt.MenuScanHook)
		IExec->FreeSysObject(ASOT_HOOK, Envmt.MenuScanHook);

	if(Envmt.MenuUpdateHook)
		IExec->FreeSysObject(ASOT_HOOK, Envmt.MenuUpdateHook);

	if(Envmt.MenuSaveTextHook)
		IExec->FreeSysObject(ASOT_HOOK, Envmt.MenuSaveTextHook);

	if(Envmt.MenuSaveCSVHook)
		IExec->FreeSysObject(ASOT_HOOK, Envmt.MenuSaveCSVHook);

	if(Envmt.DisplayHook)
		IExec->FreeSysObject(ASOT_HOOK, Envmt.DisplayHook);

	if(Envmt.SortHook)
		IExec->FreeSysObject(ASOT_HOOK, Envmt.SortHook);

	// Delete the custom Title class, if present.
	if(Envmt.Title_Class)
		IMUIMaster->MUI_DeleteCustomClass(Envmt.Title_Class);

	// Zero out the environment, so we know it's all disposed of in case
	// we're called again.
	memset(&Envmt, 0, sizeof(Envmt));
}

/***************************************************************************

 GUI_CheckTarget(Target)

 Check to see if the specified target (tab) is present in the GUI.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	cause failure.

 Out ----------------------------------------------------------------------

 TRUE if the specified target is present, or FALSE if it is not.

***************************************************************************/

BOOL GUI_CheckTarget(uint32 Target)
{
	// Validate the target number. Fail if it's invalid.
	if((Target == 0) || (Target > MAX_TARGETS)) return(FALSE);

	// Look to see if the tab for the target is present, and let the caller
	// know what we find.
	if(Envmt.TargetTitle[Target]) return(TRUE);
	else return(FALSE);
}

/***************************************************************************

 GUI_AddTarget(Target, Title)

 Add the specified target (tab) to the GUI.

 Fail if the specified target already has a tab in the GUI.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	cause failure.

 Title = A pointer to an ASCIIZ string containing the target's number and
	name, to be displayed as the tab's title. There is no enforced limit to
	the length of the title, but it is intended that it be limited to DBASE_
	NAME_LEN characters, including the trailing NUL.

 Out ----------------------------------------------------------------------

 TRUE if the specified target was added, or FALSE if it could not be.

***************************************************************************/

BOOL GUI_AddTarget(uint32 Target, STRPTR Title)
{
	Object *TabTitle = NULL;
	Object *TabContent = NULL;

	// Validate the target number. Fail if it's invalid.
	if((Target == 0) || (Target > MAX_TARGETS)) return(FALSE);

	// Fail if the target already has a tab.
	if(Envmt.TargetTitle[Target]) return(FALSE);

	// Create a text object as the title for the new tab. Fail if we can't.
	TabTitle = IMUIMaster->TextObject,
		MUIA_Text_Contents, Title,
	End;
	if(!TabTitle) goto Fail;

	// Create a list viewer object as the content of the tab. Fail if we
	// can't.
	TabContent = IMUIMaster->ListObject,
		ReadListFrame,
		MUIA_List_Input, TRUE,
		MUIA_List_Stripes, TRUE,
		MUIA_List_MaxColumns, NUM_GUI_COLUMNS,
		MUIA_List_Format, ListFormat,
		MUIA_List_Title, TRUE,
		MUIA_List_DisplayHook, Envmt.DisplayHook,		
		MUIA_List_CompareHook, Envmt.SortHook,
		MUIA_CycleChain, TRUE,
	End;
	if(!TabContent) goto Fail;

	// Create a new tab using the two objects. Fail if we can't.
	if(!AddTab(Target, TabTitle, TabContent)) goto Fail;

	// Set up for notification when double-clicking in the list viewer.
	IIntuition->IDoMethod(TabContent, MUIM_Notify,
			 MUIA_List_DoubleClick, MUIV_EveryTime,
			 MUIV_Notify_Self, 2, MUIM_CallHook, Envmt.DoubleClickHook);

	// Done- return success.
	return(TRUE);

	// Come here on failure.
Fail:
	// Clean up anything that was successfully created.
	if(TabTitle) IMUIMaster->MUI_DisposeObject(TabTitle);
	if(TabContent) IMUIMaster->MUI_DisposeObject(TabContent);

	// Let the caller know we've failed.
	return(FALSE);
}

/***************************************************************************

 Success = GUI_RemoveTarget(Target)

 Remove the specified target (tab) from the GUI, and close the corresponding
 database. If no targets remain, add the default tab as a placeholder. If
 there is no tab for the target, do nothing (this is not considered an err-
 or).

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	cause failure.

 Out ----------------------------------------------------------------------

 Success = TRUE if the specified target was removed, or FALSE if it could not
	be.

***************************************************************************/

BOOL GUI_RemoveTarget(uint32 Target)
{
	// Validate the target number. Fail if it's invalid.
	if((Target == 0) || (Target > MAX_TARGETS)) return(FALSE);

	// Make sure the target has a tab. Do nothing if it doesn't (this is not
	// considered an error).
	if(Envmt.TargetTitle[Target])
	{
		// Close the target's tab by emulating a click on its close box. The
		// corresponding database is deleted as well. There's no way to know,
		// so we assume this is successful.
		IIntuition->IDoMethod(Envmt.TargetTabs, MUIM_Title_Close,
			Envmt.TargetTitle[Target]);
	}

	// Done- return success.
	return(TRUE);
}

/***************************************************************************

 GUI_BeginUpdate(Target)

 Prepare the specified target's tab to have new entries (rows) added or exis-
 ting entries modified, by preventing the display from being updated.

 This prevents the display from being updated with each new entry added,
 which looks poor and reduces the rate at which entries can be added. It also
 allows existing entries to be modified without potentially incomplete data
 showing up in the tab if the display should be scrolled or otherwise modi-
 fied.

 The tab's display will be refreshed when GUI_EndUpdate() is called.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	be ignored, as will values that don't correspond to an existing GUI tab.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void GUI_BeginUpdate(uint32 Target)
{
	// Validate the target number. Do nothing if it's invalid or if there's
	// no tab for this target.
	if(Target && (Target <= MAX_TARGETS) && Envmt.TargetView[Target])
	{
		// The target has a tab. Enable quiet mode for the tab's list viewer.
		Set(Envmt.TargetView[Target], MUIA_List_Quiet, TRUE);
	}
}

/***************************************************************************

 GUI_EndUpdate(Target)

 Allow the target tab's display to be refreshed following the addition of new
 entries (rows) or the modification of existing entries. The display will be
 refreshed to reflect any changes made since GUI_BeginUpdate() was called.

 Once an entry has been added to the tab any changes to that entry's database
 record will automatically be picked up when the tab is refreshed. So to mod-
 ify existing entries just call GUI_BeginUpdate(), make the changes (new en-
 tries may also be added), then call GUI_EndUpdate().

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	be ignored, as will values that don't correspond to an existing GUI tab.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void GUI_EndUpdate(uint32 Target)
{
	// Validate the target number. Do nothing if it's invalid or if there's
	// no tab for this target.
	if(Target && (Target <= MAX_TARGETS) && Envmt.TargetView[Target])
	{
		// The target has a tab. Disable quiet mode for the tab's list
		// viewer.
		Set(Envmt.TargetView[Target], MUIA_List_Quiet, FALSE);
	}
}

/***************************************************************************

 Success = GUI_AddEntry(Target, Record)

 Add a new function entry (row) to the specified target tab, to display the
 specified database record. The given record pointer is associated with the
 new entry, allowing the corresponding database record to be accessed when
 the tab's display needs to be updated, sorted, or otherwise utilized (i.e,
 printed or saved to a file).

 The new entry is added to the end of the tab's display list, so GUI_Sort()
 will need to be called to sort the entries properly once all new entries
 have been added.

 Addition will fail and an error code will be returned if the input param-
 eters are invalid. It is currently not possible to know if the actual add-
 ition of the record to the display list fails, so it is assumed to always
 succeed.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	cause failure, as will values that don't correspond to an existing GUI
	tab.

 Record = A pointer to a record in the target's database. This is treated as
	an opaque handle by the GUI; it will pass it back to the database module
	when required, but will not access or parse the record itself. A NULL
	pointer will cause failure.

 Out ----------------------------------------------------------------------

 Success = TRUE if the record was added, or FALSE if it could not be.

***************************************************************************/

BOOL GUI_AddEntry(uint32 Target, APTR Record)
{
	// Fail if there is no record.
	if(!Record) return(FALSE);

	// Validate the target number. Fail if it's invalid.
	if((Target == 0) || (Target > MAX_TARGETS)) return(FALSE);

	// Fail if the target does not have a tab.
	if(!Envmt.TargetView[Target]) return(FALSE);

	// So far so good. Add the record to the end of the display list.
	IIntuition->IDoMethod(Envmt.TargetView[Target], MUIM_List_InsertSingle,
			Record, MUIV_List_Insert_Bottom);

	// MUI is not documented as returning a result when adding an entry to
	// a list object, so we'll always assume that the addition succeeded.
	return(TRUE);
}

/***************************************************************************

 GUI_Sort(Target)

 Sort the entries in the specified target's display list.

 In -----------------------------------------------------------------------

 Target = The target number, between 1 and MAX_TARGETS. Illegal values will
	be ignored, as will values that don't correspond to an existing GUI tab.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void GUI_Sort(uint32 Target)
{
	// Validate the target number. Do nothing if it's invalid or if there's
	// no tab for this target.
	if(Target && (Target <= MAX_TARGETS) && Envmt.TargetView[Target])
	{
		// The target has a tab. Tell the tab's list viewer to sort the
		// entries in its list..
		IIntuition->IDoMethod(Envmt.TargetView[Target], MUIM_List_Sort);
	}
}

/***************************************************************************

 GUI_Sleep(Sleep)

 Put the GUI's window to sleep (blocking all user input), or reawaken it.
 The GUI is normally open when this call is made, but no harm comes if it's
 not (such as when the application is iconified).

 In -----------------------------------------------------------------------

 Sleep = TRUE to put the GUI to sleep, and FALSE to reawaken it.

 Out ----------------------------------------------------------------------

 Nothing.

***************************************************************************/

void GUI_Sleep(BOOL Sleep)
{
	// Tell MUI to set the window state.
	Set(Envmt.Wind, MUIA_Window_Sleep, Sleep);
}
