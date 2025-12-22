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

#include <exec/types.h>
#include <exec/lists.h>
#include <utility/tagitem.h>

// Different types of gadgets
#define GAD_LFILE		1
#define GAD_SFILE		2
#define GAD_FILE		3
#define GAD_OFILE		4
#define GAD_ONUMBER	5
#define GAD_NUMBER	6
#define GAD_CYCLE		7
#define GAD_STRING	8
#define GAD_OSTRING	9
#define GAD_CHECK		10
#define GAD_SLIDER	11
#define GAD_MODE		12
#define GAD_LIST		13
#define GAD_OMODE		14
#define GAD_FONT		15
#define GAD_OFONT		16
#define GAD_MLIST		17
#define GAD_BUTTON	18
#define GAD_TEXT		19
#define GAD_MTEXT		20
#define GAD_BUTTONTEXT	99	// Heading of Button gadgets

extern char OKCHAR;
extern char CANCELCHAR;
extern char SAVECHAR;
extern char USECHAR;
#define GADGETWIDTH 26

struct MyGadgetPtr {
	struct MyGadget *MyGadget;
	short				Number;
};

struct MyGadget {		// A gadget
	struct Node		GNode;		//	Used for list of gadgets on command
	short				Type;			// Gadget type
	struct List		VList;		// Used for values on cycle/list gadget
	STRPTR			*VStrings;	//	Used for strings on cycle gadget
	struct MyGadget *OwnCycle;	// Owning cycle gadget
	struct Gadget	*Gadget1;	// 1st gadget
	struct Gadget	*Gadget2;	// 2nd gadget
	struct Gadget	*Gadget3;	//	3rd gadget
	long				Activey;		// Cycle value these are activated on
	char				*Title;		// Title of gadget
	char				*Prefix;		// Prefix for command
	char				*NPrefix;	// Negative Value for Check Box
	char				*Defaults;	//	Default string/MLIST;
	long				Defaultn;	// Default number (includes slider)
	long				Minn;			// For slider;
	long				Maxn;			// For slider;
	short				logMaxn;		// length of maxval
	short				Defaultc;	// Default check;
	long				Defaulty;	//	Default cycle/list;
	long				Currentc;	// Current check;
	long				Currenty;	//	Current cycle/list;
	long				Currentn;	// Current slider
	long				Numbery;		// Number of cycle gadgets
	struct MyGadgetPtr Ptr1;		// UserData points to one of these
	struct MyGadgetPtr Ptr2;
	struct MyGadgetPtr Ptr3;
	char				Char;			// Keyboard shortcut
	char				*HelpNode;	// Help Node for gadget
	int Lines;						// Number of lines for listview
	UBYTE ModeType;				// Type of screen/font mode requester
	char				*HelpMessage;	// Help Message to display
	long				ButtonNo;	// Number of button
	struct MyGadget *OwnButton;// Owning Button Text gadget
	short				ButtonCount;// Number of Buttons this buttontext owns
};

struct MyValue {
	struct Node		VNode;		// Used for list of cycle values;
	char				*Prefix;		//	Prefix for command
	char				*NPrefix;	// Negative Prefix (for MLIST)
	BOOL				Selected;	// Is this selected? (for MLIST)
};

#define MPGUIHANDLE
struct MPGuiHandle {	// Note strings come at the start to reduce memory corruption problems
	char error[81];							// resulting error message
	char result[1025];						// resulting message
	char buffer[257];							// Buffer to read input file
	char tBuffer[256];
	char TempFileName[257];					// Stored file name
	char *comment[6];							// first 6 Comments in file
	UWORD Zoom[4];								// Used for zoom size of window
	long linenumber;							// Current line number for error messages
	struct MyGadget *CurrentGadget;		//	The current gadget
	struct MyGadget *CurrentCycle;		// The current owning cycle gadget
	struct MyValue *CurrentValue;			// Current cycle list
	long	CurrentCycleVal;
	struct Screen *MyScreen;				// Screen to use
	struct TextAttr *MyTextAttr;			// Text attributes of screen
	struct FileRequester *filereq;		// File requester
	BPTR fp;										// Config file
	short FoundError;							// Have we found an error yet
	short OutOfMemory;						// Run out of memory?
	APTR MemPool;								// Global memory pool
	int leftsize;								// left hand size of requester
	int rightsize;								// right hand size
	int tleftsize;								// left hand size of requester using topaz 8
	int trightsize;							// right hand size using topaz 8
	int allsize;								// whole size of requester
	int tallsize;								// whole size of requester using topaz 8
	char *CurrentPos;
	STRPTR *ptr;
	APTR VisInfo;
	struct Gadget *Context;
	struct Window *Window;					// Requester Window
	struct IntuiMessage	*IntuiMsg;
	long height;
	int TitleLength;							// Length of window title
	int width;									// Window Width
	struct TagItem *TagList;				// Copy of user tags
	struct Hook *HelpFunc;					// HelpFunction
	BOOL CHelp;									// Continuous Help?
	char **Params;								// Parameters to replace %n%
	ULONG Response;							//	For prefs mode - 1 = save 2 = use
	struct NewMenu *NewMenu;				// NewMenu for window
	struct Menu *Menu;						// Menu for window
	struct Hook *MenuFunc;					// Called for Menu (and menu help) message
	BOOL Prefs;									// Is this a Prefs type handle
	BOOL NewLine;								// Should we output a new line rather than space
	int Bottom;									// Bottom of requester
	ULONG Signals;								// Signals to wait on
	struct Hook *SignalFunc;				// Called for Signals
	struct TextAttr Attr;					// Used if we use topaz 80
	ULONG numlines;							// Number of horizontal text lines in requester
	ULONG extralist;							// Extra lines (included above) in list views
	ULONG interwidth;							// INTERWIDTH or 0
	ULONG interheight;						// INTERHEIGHT or 0
	BOOL UseTopaz;								// Use topaz 80/Default font
	UWORD XSize;								// Width of fixed font
	struct Image* Check;						// Checkmark for menu
	struct Image* Amiga;						// AmigaKey for menu
	BOOL HelpMessageB;						// Any Help Messages?
	struct Gadget* HelpGadget;				// Help Message
	struct List		GList;					// List of gadgets
	char				*Command;				//	Command to run
	char				*Comment;				//	Helpful comment - title of requester
	char				*HelpNode;				// Help node for requester
	char				*HelpMessage;			// HelpMessage
	UWORD				FontSize;				// Font size
	BOOL				NoButtons;				// If set then no buttons
	struct			Hook *ButtonFunc;		// Callled for Button presses
	struct Requester Requestx;				// Used to disable window
	int Disabled;								// Number of times disabled
	struct Hook 	RefreshHook;			// Refresh Hook for Requesters
	BOOL NoUse;									// Disable short cuts for buttons
	BOOL NoSave;
	BOOL NoOk;
	BOOL NoCancel;
};

extern far const struct Hook				  HookList;

extern char *GetMessage(UWORD message);

extern struct Catalog *Catalog;
