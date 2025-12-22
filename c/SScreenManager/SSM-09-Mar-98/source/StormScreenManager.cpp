/*

StormScreenManager (SSM) Version 2.0

*/

#include "ScreenManager.h"
#include <dos/dos.h>
#include <exec/memory.h>
#include <intuition/gadgetclass.h>
#include <intuition/imageclass.h>
#include <libraries/asl.h>
#include <libraries/commodities.h>
#include <libraries/wizard.h>
#include <rexx/errors.h>
#include <workbench/workbench.h>

#include <clib/alib_protos.h>
#include <clib/asl_protos.h>
#include <clib/commodities_protos.h>
#include <clib/dos_protos.h>
#include <clib/exec_protos.h>
#include <clib/graphics_protos.h>
#include <clib/icon_protos.h>
#include <clib/intuition_protos.h>
#include <clib/locale_protos.h>
#include <clib/rexxsyslib_protos.h>
#include <clib/utility_protos.h>
#include <clib/wb_protos.h>
#include <clib/wizard_protos.h>

#include <string.h>
#include <stdio.h>
#include <ctype.h>

#define WBSTART_LIKE_SAS
#include <wbstartup.h>

#define CATCOMP_NUMBERS
#define CATCOMP_STRINGS
#include "ScreenManagerAll.h"

#define EVT_HOTKEY 1

struct Screen *GlbScreenP;     // Open SSM User Interface on this screen
struct Catalog *GlbCatalogP;   // SSM User Interface catalog
APTR GlbSurfaceP;              // Wizard Interface Descriptor
struct MsgPort *GlbIDCMPortP;  // Shared IDCM Port for all windows
LONG GlbScreenSignal;          // All public screens use the same signal
BPTR GlbCurrentDir;            // Backup of current directory
STRPTR GlbProgramNameP;        // Name of Program
BOOL GlbExitSoonF;             // Exit as soon as every screen is closed

extern UBYTE WizardSurface[];  // Wizard resource is linked to executable

// main window variables
struct WizardWindowHandle *GlbManagerWindowHandleP;
struct NewWindow *GlbManagerNewWindowP;
struct Window *GlbManagerWindowP;
struct Gadget *GlbManagerGadgets[MANAGERWIN_ID_GADGETS];

// property window variables
struct WizardWindowHandle *GlbPropertiesWindowHandleP;
struct NewWindow *GlbPropertiesNewWindowP;
struct Window *GlbPropertiesWindowP;
struct Gadget *GlbPropertiesGadgets[PROPERTIESWIN_ID_GADGETS];
BOOL GlbOpenPropertiesF;

// asl font requester
struct // loaded parameters
{
	BOOL Set;
	ULONG Left, Top;
	ULONG Width, Height;
} GlbFontGeometry;
struct FontRequester *GlbFontRequesterP;

// asl screen mode requester
struct // loaded parameters
{
	BOOL Set;
	ULONG Left, Top;
	ULONG Width, Height;
	BOOL InfoSet;
	BOOL InfoOpened;              // InfoOpened, InfoWidth, InfoHeight are not
	ULONG InfoLeft, InfoTop;      // supported to be set by AllocAslRequest()
	ULONG InfoWidth, InfoHeight;  // so it is "future expansion"
} GlbScreenModeGeometry;
struct ScreenModeRequester *GlbScreenModeRequesterP;

// some global screen flags
BOOL GlbShanghaiF;
BOOL GlbAutoPopupF;

// commodity variables
CxObj *GlbBrokerP;
struct MsgPort *GlbBrokerPortP;
BOOL GlbStartPopupF;
LONG GlbCXPriority;
BOOL GlbCXPopkeyF;
UBYTE GlbCXPopkey[256];  // hot key description string
BOOL GlbDisableF;

// rexx interface variables
struct MsgPort *GlbRexxPortP;

// *************************************************************
// ***
// *** NAME      getlocalestr
// *** FUNCTION  Simplify GetCatalogStr from locale.library
// ***
// *************************************************************

extern struct Library *LocaleBase;

STRPTR getlocalestr(ULONG id, STRPTR dflt)
{
	if (!LocaleBase)
		return dflt;
	return GetCatalogStr(GlbCatalogP,id,dflt);
}

// *************************************************************
// ***
// *** NAME      ScreenNode
// *** FUNCTION  Structure to store the screen parameters
// ***
// *************************************************************

struct ScreenNode
{
	struct WizardNode Node; // this is a node for wizard listviews
	struct WizardNodeEntry Entries[6]; // 6 columns in my list
	// work data
	BOOL StormScreenF; // TRUE : Screen is managed by StormScreenManager
	BOOL OpenF;        // TRUE : Screen is currently open
	BOOL CloseSoonF;   // TRUE : Close screen ASAP
	BOOL OpenSoonF;    // TRUE: Open screen ASAP
	struct Screen *Screen;      // pointer to screen, valid if OpenF == TRUE
	struct Window *CloseGadget; // pointer to window showing the close gadget
	STRPTR DefaultTitle;        // the old default title
	// screen description
	UBYTE Name[MAXPUBSCREENNAME]; // screen name
	ULONG ModeID;          // display mode id
	ULONG Depth;
	ULONG Height;
	ULONG Width;
	UWORD Overscan;        // OSCAN_#?
	BOOL AutoScrollF;
	struct TextAttr Font;
	BOOL OpenBehindF;
	// more properties
	BOOL CloseGadgetF;     // make a close gadget for this screen
	BOOL QuietF;
	UBYTE Title[256]; // if (strlen(Title) == 0) use pubscreen name
	ULONG SysFont;    // 0 = custom font, 1 = system font, 2 = workbench font
	UWORD Pens[15];   // currently not configurable, Pens[0] == ~0
	BOOL LikeWorkbenchF;
	BOOL DraggableF;
	BOOL ExclusiveF;
	struct            // colors are currently not configurable
	{
		struct loadrgb;
		ULONG colors[3*256];
	} colors32;
	// buffers for listview texts
	UBYTE ModeName[DISPLAYNAMELEN];
	UBYTE FontText[64];
	// more buffers
	UBYTE FontName[64];     // Font.ta_Name points to this array
	UBYTE ScreenTitle[280]; // the actual screen title is stored here
};

struct MinList ScreenList;
struct ScreenNode HeaderNode;    // the header node for the listview
struct ScreenNode *ActiveNodeP;  // actual selected node
struct ScreenNode *DefaultScreenNodeP; // this screen is the default screen

// *************************************************************
// ***
// *** NAME      AllocScreenNode
// *** FUNCTION  Allocates a new ScreenNode entry and initializes it
// ***
// *************************************************************
struct ScreenNode *AllocScreenNode(STRPTR Name)
{
	struct ScreenNode *node = (struct ScreenNode *) AllocVec(sizeof(struct ScreenNode),MEMF_CLEAR);
	if (node)
	{
		strcpy(node->Name,Name);
		node->CloseGadgetF = TRUE;
		node->Pens[0] = ~0;
		WZ_InitNode(&node->Node,6,       // 6 columns
			TAG_END);
		WZ_InitNodeEntry(&node->Node,0,  // Initialize each column
			WENTRYA_Type,WNE_TEXT,
			WENTRYA_TextPen,WZRD_TEXTPEN,
			WENTRYA_TextSPen,WZRD_TEXTPEN,
			WENTRYA_TextString,"",
			TAG_END);
		WZ_InitNodeEntry(&node->Node,1,
			WENTRYA_Type,WNE_TEXT,
			WENTRYA_TextPen,WZRD_TEXTPEN,
			WENTRYA_TextSPen,WZRD_TEXTPEN,
			WENTRYA_TextString,&node->Name,
			TAG_END);
		WZ_InitNodeEntry(&node->Node,2,
			WENTRYA_Type,WNE_VIMAGE,
			WENTRYA_VImageType,10,
			TAG_END);
		WZ_InitNodeEntry(&node->Node,3,
			WENTRYA_Type,WNE_TEXT,
			WENTRYA_TextPen,WZRD_TEXTPEN,
			WENTRYA_TextSPen,WZRD_TEXTPEN,
			WENTRYA_TextString,"",
			TAG_END);
		WZ_InitNodeEntry(&node->Node,4,
			WENTRYA_Type,WNE_VIMAGE,
			WENTRYA_VImageType,10,
			TAG_END);
		WZ_InitNodeEntry(&node->Node,5,
			WENTRYA_Type,WNE_TEXT,
			WENTRYA_TextPen,WZRD_TEXTPEN,
			WENTRYA_TextSPen,WZRD_TEXTPEN,
			WENTRYA_TextString,"",
			TAG_END);
	}
	return node;
}

// *************************************************************
// ***
// *** NAME      FreeScreenNode
// *** FUNCTION  frees a screen node and release allocated resources
// ***           (currently none)
// ***
// *************************************************************
void FreeScreenNode(struct ScreenNode *node)
{
	FreeVec(node);
}

// *************************************************************
// ***
// *** NAME      FreeScreenList
// *** FUNCTION  remove and free all ScreenNodes from the global list
// ***
// *************************************************************
void FreeScreenList()
{
	struct ScreenNode *node;
	while (node = (struct ScreenNode *) RemHead((struct List *) &ScreenList))
		FreeScreenNode(node);
}

// *************************************************************
// ***
// *** NAME      InitHeaderNode
// *** FUNCTION  Initialize the header node used for the listview
// ***
// *************************************************************
void InitHeaderNode()
{
	struct ScreenNode *node = &HeaderNode;
	WZ_InitNode(&node->Node,6,      // 6 columns
		TAG_END);
	WZ_InitNodeEntry(&node->Node,0, // initialize each column
		WENTRYA_Type,WNE_TEXT,
		WENTRYA_TextPen,WZRD_TEXTPEN,
		WENTRYA_TextSPen,WZRD_TEXTPEN,
		WENTRYA_TextStyle,FSF_BOLD,
		WENTRYA_TextString,"·",
		TAG_END);
	WZ_InitNodeEntry(&node->Node,1,
		WENTRYA_Type,WNE_TEXT,
		WENTRYA_TextPen,WZRD_TEXTPEN,
		WENTRYA_TextSPen,WZRD_TEXTPEN,
		WENTRYA_TextStyle,FSF_BOLD,
		WENTRYA_TextString,getlocalestr(MSG_NAME_ID,MSG_NAME_ID_STR),
		TAG_END);
	WZ_InitNodeEntry(&node->Node,2, // this feature is new for the latest
		WENTRYA_Type,WNE_VIMAGE,     // wizard.library. If you have not the
		WENTRYA_VImageType,10,       // newest version you will not see the
		TAG_END);                    // vertical bars
	WZ_InitNodeEntry(&node->Node,3,
		WENTRYA_Type,WNE_TEXT,
		WENTRYA_TextPen,WZRD_TEXTPEN,
		WENTRYA_TextSPen,WZRD_TEXTPEN,
		WENTRYA_TextStyle,FSF_BOLD,
		WENTRYA_TextString,getlocalestr(MSG_DISPLAYMODE_ID,MSG_DISPLAYMODE_ID_STR),
		TAG_END);
	WZ_InitNodeEntry(&node->Node,4,
		WENTRYA_Type,WNE_VIMAGE,
		WENTRYA_VImageType,10,
		TAG_END);
	WZ_InitNodeEntry(&node->Node,5,
		WENTRYA_Type,WNE_TEXT,
		WENTRYA_TextPen,WZRD_TEXTPEN,
		WENTRYA_TextSPen,WZRD_TEXTPEN,
		WENTRYA_TextStyle,FSF_BOLD,
		WENTRYA_TextString,getlocalestr(MSG_FONT_ID,MSG_FONT_ID_STR),
		TAG_END);
}

// *************************************************************
// ***
// *** NAME      SetScreenName
// *** FUNCTION  Set the screen name for the given node
// ***
// *************************************************************
void SetScreenName(struct ScreenNode *node, STRPTR Name)
{
	strcpy(node->Name,Name);
	WZ_InitNodeEntry(&node->Node,1,
		WENTRYA_TextString,&node->Name,
		TAG_END);
}

// *************************************************************
// ***
// *** NAME      SetScreenMode
// *** FUNCTION  Set display mode and some values from the asl requester
// ***
// *************************************************************
void SetScreenMode(struct ScreenNode *node, ULONG modeid,
	ULONG depth, ULONG height, ULONG width, UWORD overscan, BOOL autoscroll)
{
	struct NameInfo nameinfo;
	if (GetDisplayInfoData(NULL,(UBYTE *) &nameinfo,sizeof(struct NameInfo),DTAG_NAME,modeid))
	{
		strcpy(node->ModeName,nameinfo.Name);
		WZ_InitNodeEntry(&node->Node,3,
			WENTRYA_TextString,&node->ModeName,
			TAG_END);
	}
	else
	{
		WZ_InitNodeEntry(&node->Node,3,
			WENTRYA_TextString,getlocalestr(MSG_UNKNOWN_ID,MSG_UNKNOWN_ID_STR),
			TAG_END);
	}
	node->ModeID = modeid;
	node->Depth = depth;
	node->Height = height;
	node->Width = width;
	node->Overscan = overscan;
	node->AutoScrollF = autoscroll;
}

// *************************************************************
// ***
// *** NAME      SetScreenFont
// *** FUNCTION  Set the screen font from the asl requester
// ***
// *************************************************************
void SetScreenFont(struct ScreenNode *node, struct TextAttr *tattr)
{
	sprintf(node->FontText,getlocalestr(MSG_FONTTEXT_ID,MSG_FONTTEXT_ID_STR),
		tattr->ta_Name,tattr->ta_YSize);
	WZ_InitNodeEntry(&node->Node,5,
		WENTRYA_TextString,&node->FontText,
		TAG_END);
	strcpy(node->FontName,tattr->ta_Name);
	node->Font = *tattr;
	node->Font.ta_Name = node->FontName;
	node->Font.ta_Style &= ~FSF_TAGGED; // for safety
}

// *************************************************************
// ***
// *** NAME      AddScreenNode
// *** FUNCTION  Add node to list, alphanumerical sorted
// ***
// *************************************************************
void AddScreenNode(struct ScreenNode *node)
{
	struct ScreenNode *n;
	for (n = (struct ScreenNode *) ScreenList.mlh_Head;
		n->Node.Node.mln_Succ;
		n = (struct ScreenNode *) n->Node.Node.mln_Succ)
	{
		if (Stricmp(n->Name,node->Name) > 0)
		{
			Insert((struct List *) &ScreenList, (struct Node *) &node->Node.Node,
				(struct Node *) n->Node.Node.mln_Pred);
			return;
		}
	}
	AddTail((struct List *) &ScreenList, (struct Node *) &node->Node.Node);
}

// *************************************************************
// ***
// *** NAME      RemScreenNode
// *** FUNCTION  Remove a screen node from its list
// ***
// *************************************************************
void RemScreenNode(struct ScreenNode *node)
{
	Remove((struct Node *) &node->Node.Node);
}

// *************************************************************
// ***
// *** NAME      FindScreenNode
// *** FUNCTION  Find a screen node with the given name
// ***
// *************************************************************
struct ScreenNode *FindScreenNode(STRPTR Name)
{
	struct ScreenNode *node;
	for (node = (struct ScreenNode *) ScreenList.mlh_Head;
		node->Node.Node.mln_Succ;
		node = (struct ScreenNode *) node->Node.Node.mln_Succ)
	{
		if (Stricmp(node->Name,Name) == 0)
			return node;
	}
	return NULL;
}

// *************************************************************
// ***
// *** NAME      GetScreenNode
// *** FUNCTION  Find a screen node with the given index
// ***
// *************************************************************
struct ScreenNode *GetScreenNode(ULONG index)
{
	ULONG i = 0;
	struct ScreenNode *node;
	for (node = (struct ScreenNode *) ScreenList.mlh_Head;
		node->Node.Node.mln_Succ;
		node = (struct ScreenNode *) node->Node.Node.mln_Succ)
	{
		if (index == i)
			return node;
		i++;
	}
	return NULL;
}

// *************************************************************
// ***
// *** NAME      GetScreenNodeIndex
// *** FUNCTION  COunt the index for a given screen node
// ***
// *************************************************************
ULONG GetScreenNodeIndex(struct ScreenNode *n)
{
	ULONG i = 0;
	struct ScreenNode *node;
	for (node = (struct ScreenNode *) ScreenList.mlh_Head;
		node->Node.Node.mln_Succ;
		node = (struct ScreenNode *) node->Node.Node.mln_Succ)
	{
		if (node == n)
			return i;
		i++;
	}
	return ~0;
}

// *************************************************************
// ***
// *** NAME      LengthOfScreenList
// *** FUNCTION  Calculate the number of ScreenNodes in the list
// ***
// *************************************************************
ULONG LengthOfScreenList()
{
	ULONG i = 0;
	struct ScreenNode *node;
	for (node = (struct ScreenNode *) ScreenList.mlh_Head;
		node->Node.Node.mln_Succ;
		node = (struct ScreenNode *) node->Node.Node.mln_Succ)
	{
		i++;
	}
	return i;
}

// *************************************************************
// ***
// *** NAME      ScanOpenPubScreens
// *** FUNCTION  Scan the list of public screens and add to list
// ***
// *************************************************************
void ScanOpenPubScreens()
{
	struct ScreenNode *node, *succ;
	for (node = (struct ScreenNode *) ScreenList.mlh_Head;
		succ = (struct ScreenNode *) node->Node.Node.mln_Succ;
		node = succ)
	{
		if (!node->StormScreenF)
		{
			RemScreenNode(node);
			FreeScreenNode(node);
		}
	}
	struct List *pubscreens = LockPubScreenList();
	struct PubScreenNode *snode;
	for (snode = (struct PubScreenNode *) pubscreens->lh_Head;
		snode->psn_Node.ln_Succ;
		snode = (struct PubScreenNode *) snode->psn_Node.ln_Succ)
	{
		if ((snode->psn_Flags & PSNF_PRIVATE) == 0)
		{
			if (!FindScreenNode(snode->psn_Node.ln_Name))
			{
				struct ScreenNode *n = AllocScreenNode(snode->psn_Node.ln_Name);
				if (n)
				{
					AddScreenNode(n);
					n->OpenF = TRUE;
				}
			}
		}
	}
	UnlockPubScreenList()
}

// *************************************************************
// ***
// *** NAME      SetDefaultScreenNode
// *** FUNCTION  Make the given screen node the default public screen
// ***
// *************************************************************
void SetDefaultScreenNode(struct ScreenNode *node)
{
	if (node->OpenF)
	{
		if (DefaultScreenNodeP)
		{
			WZ_InitNodeEntry(&DefaultScreenNodeP->Node,0,
				WENTRYA_TextString,"",
				TAG_END);
			DefaultScreenNodeP = NULL;
		}
		DefaultScreenNodeP = node;
		SetDefaultPubScreen(node->Name);
		WZ_InitNodeEntry(&DefaultScreenNodeP->Node,0,
			WENTRYA_TextString,"·",
			TAG_END);
	}
}

// *************************************************************
// ***
// *** NAME      GetDefaultScreenNode
// *** FUNCTION  Get the default public screen and reset it in the list
// ***
// *************************************************************
struct ScreenNode *GetDefaultScreenNode()
{
	UBYTE Name[MAXPUBSCREENNAME];
	GetDefaultPubScreen(Name);
	struct ScreenNode *node = FindScreenNode(Name);
	if (node)
		SetDefaultScreenNode(node);
	return node;
}

// *************************************************************
// ***
// *** NAME      IsAnyScreenOpen
// *** FUNCTION  Returns TRUE if any screen is opened by SSM
// ***
// *************************************************************
BOOL IsAnyScreenOpen()
{
	struct ScreenNode *node;
	for (node = (struct ScreenNode *) ScreenList.mlh_Head;
		node->Node.Node.mln_Succ;
		node = (struct ScreenNode *) node->Node.Node.mln_Succ)
	{
		if (node->StormScreenF && node->OpenF)
			return TRUE;
	}
	return FALSE;
}

// *************************************************************
// ***
// *** NAME      Save
// *** FUNCTION  Save the screen list and interface parameters to
// ***           a workbench icon
// ***
// *************************************************************
STRPTR Save(STRPTR Name)
{
	struct DiskObject *diskobj;
	STRPTR ToolTypes[64];
	UBYTE *Buffer;
	if (!(Buffer = (UBYTE *) AllocVec(16384,MEMF_CLEAR)))
		return getlocalestr(MSG_OUT_OF_MEMORY_ID,MSG_OUT_OF_MEMORY_ID_STR);
	if (diskobj = GetDiskObject(Name))
	{
	}
	else if (diskobj = GetDefDiskObject(WBTOOL))
	{
		diskobj->do_CurrentX = NO_ICON_POSITION;
		diskobj->do_CurrentY = NO_ICON_POSITION;
	}
	else
	{
		FreeVec(Buffer);
		return getlocalestr(MSG_UNABLE_TO_READ_ICON_ID,MSG_UNABLE_TO_READ_ICON_ID_STR);
	}
	// copy some tooltypes that are not configurable by SSM
	STRPTR cxpriority = FindToolType((UBYTE **) diskobj->do_ToolTypes,"CX_PRIORITY");
	STRPTR cxpopup = FindToolType((UBYTE **) diskobj->do_ToolTypes,"CX_POPUP");
	if (!cxpopup)
		cxpopup = "NO";
	STRPTR cxpopkey = FindToolType((UBYTE **) diskobj->do_ToolTypes,"CX_POPKEY");
	if (!cxpopkey)
		cxpopkey = "control alt p";

	// set the standard tooltypes
	ULONG i = 0;
	STRPTR Buf = Buffer;
	Buf += sprintf(ToolTypes[i++] = Buf,"DONOTWAIT") + 1;
	if (cxpriority)
		Buf += sprintf(ToolTypes[i++] = Buf,"CX_PRIORITY=%s",cxpriority) + 1;
	Buf += sprintf(ToolTypes[i++] = Buf,"CX_POPUP=%s",cxpopup) + 1;
	Buf += sprintf(ToolTypes[i++] = Buf,"CX_POPKEY=%s",cxpopkey) + 1;

	// save the global parameters
	Buf += sprintf(ToolTypes[i++] = Buf,"SHANGHAI=%s",GlbShanghaiF ? "ON" : "OFF") + 1;
	Buf += sprintf(ToolTypes[i++] = Buf,"AUTOPOPUP=%s",GlbAutoPopupF ? "ON" : "OFF") + 1;
	if (DefaultScreenNodeP)
		Buf += sprintf(ToolTypes[i++] = Buf,"DEFAULTSCREEN=%s",DefaultScreenNodeP->Name) + 1;

	// save the screen list
	struct ScreenNode *node;
	for (node = (struct ScreenNode *) ScreenList.mlh_Head;
		node->Node.Node.mln_Succ;
		node = (struct ScreenNode *) node->Node.Node.mln_Succ)
	{
		if (node->StormScreenF)
		{
			Buf += sprintf(ToolTypes[i++] = Buf,
				"SCREEN=%s/%ld/%ld/%ld/0x%lx/%s/%ld/%s/%ld/%ld/%ld/%ld/%ld/%s/%ld/%ld/%ld/%ld",
				node->Name,
				node->Width,
				node->Height,
				node->Depth,
				node->ModeID,
				node->Font.ta_Name,
				node->Font.ta_YSize,
				node->OpenF ? "on" : "off",
				node->OpenBehindF,
				node->CloseGadgetF,
				node->AutoScrollF,
				node->Overscan,
				node->QuietF,
				node->Title,
				node->SysFont,
				node->LikeWorkbenchF,
				node->DraggableF,
				node->ExclusiveF
				) + 1;
		}
	}

	// save the interface parameters like window geometry etc
	if (GlbManagerWindowP)
	{
		Buf += sprintf(ToolTypes[i++] = Buf,"WINDOW=%ld/%ld/%ld/%ld",
			GlbManagerWindowP->LeftEdge,
			GlbManagerWindowP->TopEdge,
			GlbManagerWindowP->Width,
			GlbManagerWindowP->Height) + 1;
	}
	else
	{
		Buf += sprintf(ToolTypes[i++] = Buf,"WINDOW=%ld/%ld/%ld/%ld",
			GlbManagerNewWindowP->LeftEdge,
			GlbManagerNewWindowP->TopEdge,
			GlbManagerNewWindowP->Width,
			GlbManagerNewWindowP->Height) + 1;
	}
	if (GlbPropertiesWindowP)
	{
		Buf += sprintf(ToolTypes[i++] = Buf,"PROPERTIES=%ld/%ld/%ld/%ld/on",
			GlbPropertiesWindowP->LeftEdge,
			GlbPropertiesWindowP->TopEdge,
			GlbPropertiesWindowP->Width,
			GlbPropertiesWindowP->Height) + 1;
	}
	else
	{
		Buf += sprintf(ToolTypes[i++] = Buf,"PROPERTIES=%ld/%ld/%ld/%ld/off",
			GlbPropertiesNewWindowP->LeftEdge,
			GlbPropertiesNewWindowP->TopEdge,
			GlbPropertiesNewWindowP->Width,
			GlbPropertiesNewWindowP->Height) + 1;
	}
	Buf += sprintf(ToolTypes[i++] = Buf,"SCREENMODEREQ=%ld/%ld/%ld/%ld",
		GlbScreenModeRequesterP->sm_LeftEdge,
		GlbScreenModeRequesterP->sm_TopEdge,
		GlbScreenModeRequesterP->sm_Width,
		GlbScreenModeRequesterP->sm_Height) + 1;
	Buf += sprintf(ToolTypes[i++] = Buf,"SCREENMODEINFO=%ld/%ld/%ld/%ld/%ld",
		GlbScreenModeRequesterP->sm_InfoLeftEdge,
		GlbScreenModeRequesterP->sm_InfoTopEdge,
		GlbScreenModeRequesterP->sm_InfoWidth,
		GlbScreenModeRequesterP->sm_InfoHeight,
		GlbScreenModeRequesterP->sm_InfoOpened) + 1;
	Buf += sprintf(ToolTypes[i++] = Buf,"FONTREQ=%ld/%ld/%ld/%ld",
		GlbFontRequesterP->fo_LeftEdge,
		GlbFontRequesterP->fo_TopEdge,
		GlbFontRequesterP->fo_Width,
		GlbFontRequesterP->fo_Height) + 1;
	ToolTypes[i] = NULL;

	// write icon to file
	STRPTR *tooltypes = diskobj->do_ToolTypes;
	diskobj->do_ToolTypes = ToolTypes;
	if (!PutDiskObject(Name,diskobj))
	{
		diskobj->do_ToolTypes = tooltypes;
		FreeDiskObject(diskobj);
		FreeVec(Buffer);
		return getlocalestr(MSG_UNABLE_TO_WRITE_ICON_ID,MSG_UNABLE_TO_WRITE_ICON_ID_STR);
	}
	diskobj->do_ToolTypes = tooltypes;
	FreeDiskObject(diskobj);
	FreeVec(Buffer);
	return NULL; // no error string
}

// *************************************************************
// ***
// *** NAME      Load
// *** FUNCTION  Load a screen list and many parameters from a wb icon
// ***
// *************************************************************
STRPTR Load(STRPTR Name)
{
	struct DiskObject *diskobj;
	if (!(diskobj = GetDiskObject(Name)))
		return NULL;
	STRPTR v;

	// load some standard parameters
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"CX_PRIORITY");
	if (v)
	{
		sscanf(v,"%ld",&GlbCXPriority);
		if (GlbCXPriority > 127)
			GlbCXPriority = 127;
		else if (GlbCXPriority < -128)
			GlbCXPriority = -128;
	}
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"CX_POPUP");
	if (v && (MatchToolValue(v,"ON") || MatchToolValue(v,"TRUE") || strlen(v) == 0))
		GlbStartPopupF = TRUE;
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"CX_POPKEY");
	if (v)
	{
		GlbCXPopkeyF = TRUE;
		strcpy(GlbCXPopkey,v);
	}

	// load some global variables
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"SHANGHAI");
	if (v && (MatchToolValue(v,"ON") || MatchToolValue(v,"TRUE") || strlen(v) == 0))
		GlbShanghaiF = TRUE;
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"AUTOPOPUP");
	if (v && (MatchToolValue(v,"ON") || MatchToolValue(v,"TRUE") || strlen(v) == 0))
		GlbAutoPopupF = TRUE;

	// build the screen list
	STRPTR *ToolTypes = diskobj->do_ToolTypes;
	while (*ToolTypes)
	{
		STRPTR ToolType = *ToolTypes;
		UBYTE Name[MAXPUBSCREENNAME];
		ULONG Width, Height, Depth, ModeID;
		struct TextAttr Font;
		UBYTE FontName[64];
		UBYTE OpenF[6];
		ULONG OpenBehindF = FALSE, CloseGadgetF = FALSE, AutoScrollF = FALSE;
		ULONG Overscan = OSCAN_TEXT, QuietF = FALSE;
		UBYTE Title[256] = { };
		ULONG SysFont = 0, LikeWorkbenchF = FALSE, DraggableF = FALSE;
		ULONG ExclusiveF = FALSE;
		LONG parameters;
		if (parameters = sscanf(ToolType,
			"SCREEN=%[^/]/%ld/%ld/%ld/%lx/%[^/]/%hd/%[^/]/%ld/%ld/%ld/%ld/%ld/%[^/]/%ld/%ld/%ld/%ld",
			Name,
			&Width,
			&Height,
			&Depth,
			&ModeID,
			FontName,
			&Font.ta_YSize,
			OpenF,
			&OpenBehindF,
			&CloseGadgetF,
			&AutoScrollF,
			&Overscan,
			&QuietF,
			Title,
			&SysFont,
			&LikeWorkbenchF,
			&DraggableF,
			&ExclusiveF
			) >= 8)
		{
			struct ScreenNode *node;
			if (node = AllocScreenNode(Name))
			{
				node->StormScreenF = TRUE;
				SetScreenMode(node,ModeID,Depth,Height,Width,OSCAN_TEXT,TRUE);
				Font.ta_Name = FontName;
				SetScreenFont(node,&Font);
				node->OpenSoonF = (Stricmp(OpenF,"on") == 0); // screens will be opened later
				node->OpenBehindF = OpenBehindF;
				node->CloseGadgetF = CloseGadgetF;
				node->AutoScrollF = AutoScrollF;
				node->Overscan = Overscan;
				node->QuietF = QuietF;
				strcpy(node->Title,Title);
				node->SysFont = SysFont;
				node->LikeWorkbenchF = LikeWorkbenchF;
				node->DraggableF = DraggableF;
				node->ExclusiveF = ExclusiveF;
				AddScreenNode(node);
			}
			else
			{
				FreeDiskObject(diskobj);
				return getlocalestr(MSG_OUT_OF_MEMORY_ID,MSG_OUT_OF_MEMORY_ID_STR);
			}
		}
		ToolTypes++
	}
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"DEFAULTSCREEN");
	if (v)
	{
		DefaultScreenNodeP = FindScreenNode(v);
	}

	// load interface parameters
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"WINDOW");
	sscanf(v,"%hd/%hd/%hd/%hd",
		&GlbManagerNewWindowP->LeftEdge,
		&GlbManagerNewWindowP->TopEdge,
		&GlbManagerNewWindowP->Width,
		&GlbManagerNewWindowP->Height);
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"PROPERTIES");
	UBYTE onoff[10];
	sscanf(v,"%hd/%hd/%hd/%hd/%[^/]",
		&GlbPropertiesNewWindowP->LeftEdge,
		&GlbPropertiesNewWindowP->TopEdge,
		&GlbPropertiesNewWindowP->Width,
		&GlbPropertiesNewWindowP->Height,
		&onoff);
	GlbOpenPropertiesF = (Stricmp(onoff,"on") == 0);
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"SCREENMODEREQ");
	GlbScreenModeGeometry.Set = (sscanf(v,"%ld/%ld/%ld/%ld",
		&GlbScreenModeGeometry.Left,
		&GlbScreenModeGeometry.Top,
		&GlbScreenModeGeometry.Width,
		&GlbScreenModeGeometry.Height) == 4);
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"SCREENMODEINFO");
	GlbScreenModeGeometry.InfoSet = (sscanf(v,"%ld/%ld/%ld/%ld/%hd",
		&GlbScreenModeGeometry.InfoLeft,
		&GlbScreenModeGeometry.InfoTop,
		&GlbScreenModeGeometry.InfoWidth,
		&GlbScreenModeGeometry.InfoHeight,
		&GlbScreenModeGeometry.InfoOpened) == 5);
	v = FindToolType((UBYTE **) diskobj->do_ToolTypes,"FONTREQ");
	GlbFontGeometry.Set = (sscanf(v,"%ld/%ld/%ld/%ld",
		&GlbFontGeometry.Left,
		&GlbFontGeometry.Top,
		&GlbFontGeometry.Width,
		&GlbFontGeometry.Height) == 4);
	FreeDiskObject(diskobj);
	return NULL;
}

// *************************************************************
// ***
// *** NAME      StripIDCMPMessages
// *** FUNCTION  Reply messages before closing a window (should be in amiga.lib)
// ***
// *************************************************************
void StripIDCMPMessages(struct Window *WinP)
{
	Forbid();
	struct IntuiMessage *msg;
	struct Node *succ;
	msg = (struct IntuiMessage *) WinP->UserPort->mp_MsgList.lh_Head;
	while (succ = msg->ExecMessage.mn_Node.ln_Succ)
	{
		if (msg->IDCMPWindow == WinP)
		{
			Remove(&msg->ExecMessage.mn_Node);
			ReplyMsg(&msg->ExecMessage);
		}
		msg = (struct IntuiMessage *) succ;
	}
	WinP->UserPort = NULL;
	ModifyIDCMP(WinP,0);
	Permit();
}

// *************************************************************
// ***
// *** NAME      error
// *** FUNCTION  show error message, cleanup and exit
// ***
// *************************************************************
void error(char *s)
{
	if (s)
	{
		if (GlbSurfaceP)
		{
			WZ_LockWindows(GlbSurfaceP);
			WZ_EasyRequestArgs(GlbSurfaceP,GlbManagerWindowP,REQ_ERROR_ID,&s);
			WZ_UnlockWindows(GlbSurfaceP);
		}
	}
	if (GlbPropertiesWindowP)
	{
		StripIDCMPMessages(GlbPropertiesWindowP);
		WZ_CloseWindow(GlbPropertiesWindowHandleP);
	}
	if (GlbManagerWindowP)
	{
		StripIDCMPMessages(GlbManagerWindowP);
		WZ_CloseWindow(GlbManagerWindowHandleP);
	}
	if (GlbIDCMPortP)
		DeleteMsgPort(GlbIDCMPortP);
	if (GlbRexxPortP)
	{
		RemPort(GlbRexxPortP);
		struct RexxMsg *msg;
		while (msg = (struct RexxMsg *) GetMsg(GlbRexxPortP))
		{
			msg->rm_Result1 = RC_FATAL;
			ReplyMsg(&msg->rm_Node);
		}
		DeleteMsgPort(GlbRexxPortP);
	}
	if (GlbScreenSignal != ~0)
		FreeSignal(GlbScreenSignal);
	if (GlbPropertiesWindowHandleP)
		WZ_FreeWindowHandle(GlbPropertiesWindowHandleP);
	if (GlbManagerWindowHandleP)
		WZ_FreeWindowHandle(GlbManagerWindowHandleP);
	if (GlbSurfaceP)
		WZ_CloseSurface(GlbSurfaceP);
	if (GlbScreenP)
		UnlockPubScreen(NULL,GlbScreenP);
	if (GlbFontRequesterP)
		FreeAslRequest(GlbFontRequesterP);
	if (GlbScreenModeRequesterP)
		FreeAslRequest(GlbScreenModeRequesterP);
	FreeScreenList();
	if (GlbBrokerP)
	{
		DeleteCxObjAll(GlbBrokerP);
	}
	if (GlbBrokerPortP)
	{
		CxMsg *msg;
		while (msg = (CxMsg *) GetMsg(GlbBrokerPortP))
			ReplyMsg((struct Message *) msg);
		DeletePort(GlbBrokerPortP);
	}
	if (GlbCatalogP)
		CloseCatalog(GlbCatalogP);
	if (GlbCurrentDir)
		UnLock(CurrentDir(GlbCurrentDir));
	exit(s ? 20 : 0)
}

// *************************************************************
// ***
// *** NAME      setselected
// *** FUNCTION  Set all gadgets that reflect a screen node
// ***
// *************************************************************
void setselected()
{
	ULONG selected;
	GetAttr(WLISTVIEWA_Selected,GlbManagerGadgets[GAD_MAN_LIST_ID],&selected);
	ActiveNodeP = GetScreenNode(selected);
	if (ActiveNodeP)
	{
		BOOL v = (!ActiveNodeP->StormScreenF) || ActiveNodeP->OpenF;
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_NAME_ID],GlbManagerWindowP,NULL,
			GA_Disabled,v,
			WSTRINGA_String,ActiveNodeP->Name,
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_DELETE_ID],GlbManagerWindowP,NULL,
			GA_Disabled,v,
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_MODE_ID],GlbManagerWindowP,NULL,
			GA_Disabled,v,
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_FONT_ID],GlbManagerWindowP,NULL,
			GA_Disabled,v,
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_OPEN_ID],GlbManagerWindowP,NULL,
			GA_Disabled,!ActiveNodeP->StormScreenF,
			WTOGGLEA_Checked,ActiveNodeP->OpenF,
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_OPENBEHIND_ID],GlbManagerWindowP,NULL,
			GA_Disabled,!ActiveNodeP->StormScreenF,
			WCHECKBOXA_Checked,ActiveNodeP->OpenBehindF,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_COLORNUM_ID],GlbPropertiesWindowP,NULL,
			WARGSA_Format,ActiveNodeP->StormScreenF ? "%ld" : "",
			WARGSA_Arg0,1L << ActiveNodeP->Depth,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_WIDTH_ID],GlbPropertiesWindowP,NULL,
			WARGSA_Format,ActiveNodeP->StormScreenF ? "%ld" : "",
			WARGSA_Arg0,ActiveNodeP->Width,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_HEIGHT_ID],GlbPropertiesWindowP,NULL,
			WARGSA_Format,ActiveNodeP->StormScreenF ? "%ld" : "",
			WARGSA_Arg0,ActiveNodeP->Height,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_FONT_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,v,
			WCYCLEA_Active,ActiveNodeP->SysFont,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_TITLE_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,v,
			WSTRINGA_String,ActiveNodeP->Title,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_LIKEWB_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,v,
			WCHECKBOXA_Checked,ActiveNodeP->LikeWorkbenchF,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_CLOSEGADGET_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,v,
			WCHECKBOXA_Checked,ActiveNodeP->CloseGadgetF,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_DRAGGABLE_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,v,
			WCHECKBOXA_Checked,ActiveNodeP->DraggableF,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_QUIET_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,v,
			WCHECKBOXA_Checked,ActiveNodeP->QuietF,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_EXCLUSIVE_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,v,
			WCHECKBOXA_Checked,ActiveNodeP->ExclusiveF,
			TAG_END);
	}
	else
	{
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_NAME_ID],GlbManagerWindowP,NULL,
			GA_Disabled,TRUE,
			WSTRINGA_String,"",
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_DELETE_ID],GlbManagerWindowP,NULL,
			GA_Disabled,TRUE,
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_MODE_ID],GlbManagerWindowP,NULL,
			GA_Disabled,TRUE,
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_FONT_ID],GlbManagerWindowP,NULL,
			GA_Disabled,TRUE,
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_OPEN_ID],GlbManagerWindowP,NULL,
			GA_Disabled,TRUE,
			WCHECKBOXA_Checked,FALSE,
			TAG_END);
		SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_OPENBEHIND_ID],GlbManagerWindowP,NULL,
			GA_Disabled,TRUE,
			WCHECKBOXA_Checked,FALSE,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_COLORNUM_ID],GlbPropertiesWindowP,NULL,
			WARGSA_Format,"",
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_WIDTH_ID],GlbPropertiesWindowP,NULL,
			WARGSA_Format,"",
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_HEIGHT_ID],GlbPropertiesWindowP,NULL,
			WARGSA_Format,"",
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_FONT_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,TRUE,
			WCYCLEA_Active,0,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_TITLE_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,TRUE,
			WSTRINGA_String,"",
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_LIKEWB_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,TRUE,
			WCHECKBOXA_Checked,FALSE,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_CLOSEGADGET_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,TRUE,
			WCHECKBOXA_Checked,FALSE,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_DRAGGABLE_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,TRUE,
			WCHECKBOXA_Checked,FALSE,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_QUIET_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,TRUE,
			WCHECKBOXA_Checked,FALSE,
			TAG_END);
		SetGadgetAttrs(GlbPropertiesGadgets[GAD_PRP_EXCLUSIVE_ID],GlbPropertiesWindowP,NULL,
			GA_Disabled,TRUE,
			WCHECKBOXA_Checked,FALSE,
			TAG_END);
	}
}

// *************************************************************
// ***
// *** NAME      openscreen
// *** FUNCTION  open a public screen, close gadget etc
// ***
// *************************************************************
void openscreen(struct ScreenNode *node)
{
	strcpy(node->ScreenTitle,strlen(node->Title) ? node->Title : node->Name);
	if (node->Screen = OpenScreenTags(NULL,
		SA_Type,PUBLICSCREEN,
		SA_PubName,node->Name,
		SA_PubSig,GlbScreenSignal,
		SA_PubTask,NULL,

		SA_LikeWorkbench, node->LikeWorkbenchF,
		node->LikeWorkbenchF ? TAG_SKIP : TAG_IGNORE, 10,
		SA_DisplayID,node->ModeID,
		SA_Depth,node->Depth,
		SA_Overscan,node->Overscan,
		SA_Width,node->Width,
		SA_Height,node->Height,
		SA_FullPalette,TRUE,
		SA_Interleaved,TRUE,
		SA_Pens,node->Pens,
		node->SysFont == 0 ? SA_Font : TAG_IGNORE, &node->Font,
		node->SysFont != 0 ? SA_SysFont : TAG_IGNORE, node->SysFont-1,

		SA_Title,node->CloseGadgetF ? "" : node->ScreenTitle,
		SA_AutoScroll,node->AutoScrollF,
		SA_Behind,node->OpenBehindF,
		SA_ShowTitle,FALSE,
		SA_Quiet,node->QuietF,
		SA_Exclusive,node->ExclusiveF,
		SA_Draggable,node->DraggableF,
		TAG_END))
	{
		node->OpenF = TRUE;
		if (node->CloseGadgetF)
		{
			struct DrawInfo *drawinfo = GetScreenDrawInfo(node->Screen);
			if (drawinfo)
			{
				struct Image *closeimage = (struct Image *) NewObject(NULL,SYSICLASS,
					SYSIA_DrawInfo,drawinfo,
					SYSIA_Size,SYSISIZE_HIRES,
					SYSIA_Which,CLOSEIMAGE,
					TAG_END);
				if (closeimage)
				{
					// calculate Screentitle
					#define SPACES "                            "
					struct TextExtent textextent;
					ULONG count = TextFit(&node->Screen->RastPort,
						SPACES,strlen(SPACES),
						&textextent,NULL,1,
						closeimage->Width + 4, 1000);
					sprintf(node->ScreenTitle,"%s%s",
						SPACES+strlen(SPACES)-count,strlen(node->Title) == 0 ? node->Name : node->Title);
					node->DefaultTitle = node->Screen->DefaultTitle;
					node->Screen->DefaultTitle = node->ScreenTitle;
					#undef SPACES
					struct Window *win = OpenWindowTags(NULL,
						WA_Activate,TRUE,
						WA_Left,0,
						WA_Top,0,
						WA_Width,1,
						WA_Height,1,
						WA_Borderless,TRUE,
						WA_PubScreen,node->Screen,
						WA_ScreenTitle,node->ScreenTitle,
						TAG_END);
					if (win)
						CloseWindow(win);
					if (node->CloseGadget = OpenWindowTags(NULL,
						WA_Activate,FALSE,
						WA_Backdrop,TRUE,
						WA_Borderless,TRUE,
						WA_CloseGadget,TRUE,
						WA_DepthGadget,FALSE,
						WA_DragBar,FALSE,
						WA_Left,0,
						WA_Top,0,
						WA_Width,closeimage->Width,
						WA_Height,closeimage->Height,
						WA_IDCMP,0,
						WA_NoCareRefresh,TRUE,
						WA_RMBTrap,TRUE,
						WA_SimpleRefresh,TRUE,
						WA_SizeGadget,FALSE,
						WA_Title,NULL,
						WA_ScreenTitle,node->ScreenTitle,
						WA_PubScreen,node->Screen,
						TAG_END))
					{
						node->CloseGadget->UserPort = GlbIDCMPortP;
						ModifyIDCMP(node->CloseGadget,IDCMP_CLOSEWINDOW);
					}
					DisposeObject(closeimage);
				}
				FreeScreenDrawInfo(node->Screen,drawinfo);
			}
		}
		PubScreenStatus(node->Screen,0);
	}
	else
	{
		STRPTR err = node->Name;
		WZ_LockWindows(GlbSurfaceP);
		WZ_EasyRequestArgs(GlbSurfaceP,GlbManagerWindowP,REQ_SCREENOPENERR_ID,&err);
		WZ_UnlockWindows(GlbSurfaceP);
	}
}

// *************************************************************
// ***
// *** NAME      closescreen
// *** FUNCTION  close a public screen
// ***
// *************************************************************
void closescreen(struct ScreenNode *node)
{
	if (node->CloseGadget)
	{
		StripIDCMPMessages(node->CloseGadget);
		CloseWindow(node->CloseGadget);
		node->CloseGadget = NULL;
	}
	if (node->Screen)
	{
		node->Screen->DefaultTitle = node->DefaultTitle;
		if (CloseScreen(node->Screen))
		{
			node->OpenF = FALSE;
			node->CloseSoonF = FALSE;
		}
		else
		{
			node->CloseSoonF = TRUE;
		}
	}
}

// *************************************************************
// ***
// *** NAME      closeproperties
// *** FUNCTION  close properties window
// ***
// *************************************************************
void closeproperties()
{
	if (GlbPropertiesWindowP)
	{
		StripIDCMPMessages(GlbPropertiesWindowP);
		WZ_CloseWindow(GlbPropertiesWindowHandleP);
		GlbPropertiesWindowP = NULL;
	}
}

// *************************************************************
// ***
// *** NAME      openproperties
// *** FUNCTION  open properties window
// ***
// *************************************************************
void openproperties(BOOL activate)
{
	if (!GlbPropertiesWindowP)
	{
		struct NewWindow *nw = GlbPropertiesNewWindowP;
		if (nw->Width < nw->MinWidth)
			nw->Width = nw->MinWidth;
		nw->Height = nw->MaxHeight = nw->MinHeight;
		if (!(GlbPropertiesWindowP = WZ_OpenWindow(GlbPropertiesWindowHandleP,GlbPropertiesNewWindowP,
			WA_IDCMP,0,
			WA_AutoAdjust,TRUE,
			WA_Activate,activate,
			TAG_END)))
		{
			error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
		}
		GlbPropertiesWindowP->UserPort = GlbIDCMPortP;
		ModifyIDCMP(GlbPropertiesWindowP,GlbPropertiesNewWindowP->IDCMPFlags);
	}
	else
	{
		WindowToFront(GlbPropertiesWindowP);
		if (activate)
			ActivateWindow(GlbPropertiesWindowP);
	}
}

// *************************************************************
// ***
// *** NAME      hide
// *** FUNCTION  hide user interface, remember state of properties window
// ***
// *************************************************************
void hide()
{
	if (GlbPropertiesWindowP)
		GlbOpenPropertiesF = TRUE;
	closeproperties();
	if (GlbManagerWindowP)
	{
		StripIDCMPMessages(GlbManagerWindowP);
		WZ_CloseWindow(GlbManagerWindowHandleP);
		GlbManagerWindowP = NULL;
	}
}

// *************************************************************
// ***
// *** NAME      show
// *** FUNCTION  show user interface, open properties window?
// ***
// *************************************************************
void show()
{
	if (!GlbManagerWindowP)
	{
		struct NewWindow *nw = GlbPropertiesNewWindowP;
		if (nw->Width < nw->MinWidth)
			nw->Width = nw->MinWidth;
		if (nw->Height < nw->MinHeight)
			nw->Height = nw->MinHeight;
		if (!(GlbManagerWindowP = WZ_OpenWindow(GlbManagerWindowHandleP,GlbManagerNewWindowP,
			WA_IDCMP,0,
			WA_AutoAdjust,TRUE,
			TAG_END)))
		{
			error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
		}
		GlbManagerWindowP->UserPort = GlbIDCMPortP;
		ModifyIDCMP(GlbManagerWindowP,GlbManagerNewWindowP->IDCMPFlags);
	}
	else
	{
		WindowToFront(GlbManagerWindowP);
		ActivateWindow(GlbManagerWindowP);
	}
	if (GlbOpenPropertiesF)
		openproperties(FALSE);
}

// *************************************************************
// ***
// *** NAME      handlemanagerwindow
// *** FUNCTION  handle all IDCMP messages for the main window
// ***
// *************************************************************
BOOL handlemanagerwindow(struct IntuiMessage *msg)
{
	BOOL retval = FALSE;
	switch (msg->Class)
	{
		case IDCMP_IDCMPUPDATE:
			switch (GetTagData(GA_ID,-1,(struct TagItem *) msg->IAddress))
			{
				case GAD_MAN_LIST_ID:
					if (GetTagData(WLISTVIEWA_DoubleClick,FALSE,(struct TagItem *) msg->IAddress))
					{
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],NULL,NULL,
							WLISTVIEWA_List,NULL,
							TAG_END);
						SetDefaultScreenNode(ActiveNodeP);
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
							WLISTVIEWA_List,&ScreenList,
							TAG_END);
					}
					else
						setselected();
					break;
				case GAD_MAN_NAME_ID:
				{
					STRPTR name;
					GetAttr(WSTRINGA_String,GlbManagerGadgets[GAD_MAN_NAME_ID],(ULONG *) &name);
					if (ActiveNodeP)
					{
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],NULL,NULL,
							WLISTVIEWA_List,NULL,
							TAG_END);
						SetScreenName(ActiveNodeP,name);
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
							WLISTVIEWA_List,&ScreenList,
							TAG_END);
					}
					break;
				}
				case GAD_MAN_NEW_ID:
				{
					struct ScreenNode *node;
					UBYTE Name[MAXPUBSCREENNAME];
					ULONG i = 1;
					strcpy(Name,"StormScreen");
					while (FindScreenNode(Name))
					{
						sprintf(Name,"StormScreen.%ld",i);
						i++;
					}
					if (node = AllocScreenNode(Name))
					{
						node->StormScreenF = TRUE;
						struct Screen *screen = LockPubScreen(NULL);
						SetScreenMode(node,GetVPModeID(&screen->ViewPort),
							screen->RastPort.BitMap->Depth,
							screen->Height,
							screen->Width,
							OSCAN_TEXT,
							TRUE);
						SetScreenFont(node,screen->Font);
						UnlockPubScreen(NULL,screen);
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],NULL,NULL,
							WLISTVIEWA_List,NULL,
							TAG_END);
						AddScreenNode(node);
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
							WLISTVIEWA_List,&ScreenList,
							WLISTVIEWA_Selected,GetScreenNodeIndex(node),
							TAG_END);
						setselected();
					}
					break;
				}
				case GAD_MAN_DELETE_ID:
					if (ActiveNodeP)
					{
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],NULL,NULL,
							WLISTVIEWA_List,NULL,
							TAG_END);
						RemScreenNode(ActiveNodeP);
						FreeScreenNode(ActiveNodeP);
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
							WLISTVIEWA_List,&ScreenList,
							WLISTVIEWA_Selected,-1,
							TAG_END);
						setselected();
					}
					break;
				case GAD_MAN_MODE_ID:
					if (ActiveNodeP)
					{
						WZ_LockWindows(GlbSurfaceP);
						if (AslRequestTags(GlbScreenModeRequesterP,
							ASLSM_InitialDisplayDepth,ActiveNodeP->Depth,
							ASLSM_InitialDisplayHeight,ActiveNodeP->Height,
							ASLSM_InitialDisplayWidth,ActiveNodeP->Width,
							ASLSM_InitialDisplayID,ActiveNodeP->ModeID,
							ASLSM_InitialOverscanType,ActiveNodeP->Overscan,
							ASLSM_DoAutoScroll,TRUE,
							ASLSM_DoDepth,TRUE,
							ASLSM_DoHeight,TRUE,
							ASLSM_DoWidth,TRUE,
							ASLSM_DoOverscanType,TRUE,
							TAG_END))
						{
							SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],NULL,NULL,
								WLISTVIEWA_List,NULL,
								TAG_END);
							SetScreenMode(ActiveNodeP,
								GlbScreenModeRequesterP->sm_DisplayID,
								GlbScreenModeRequesterP->sm_DisplayDepth,
								GlbScreenModeRequesterP->sm_DisplayHeight,
								GlbScreenModeRequesterP->sm_DisplayWidth,
								GlbScreenModeRequesterP->sm_OverscanType,
								GlbScreenModeRequesterP->sm_AutoScroll);
							SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
								WLISTVIEWA_List,&ScreenList,
								TAG_END);
						}
						WZ_UnlockWindows(GlbSurfaceP);
					}
					break;
				case GAD_MAN_FONT_ID:
					if (ActiveNodeP)
					{
						WZ_LockWindows(GlbSurfaceP);
						if (AslRequestTags(GlbFontRequesterP,
							ASLFO_InitialName,ActiveNodeP->Font.ta_Name,
							ASLFO_InitialSize,ActiveNodeP->Font.ta_YSize,
							TAG_END))
						{
							SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],NULL,NULL,
								WLISTVIEWA_List,NULL,
								TAG_END);
							SetScreenFont(ActiveNodeP,&GlbFontRequesterP->fo_Attr);
							SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
								WLISTVIEWA_List,&ScreenList,
								TAG_END);
						}
						WZ_UnlockWindows(GlbSurfaceP);
					}
					break;
				case GAD_MAN_OPEN_ID:
					if (ActiveNodeP)
					{
						ULONG openf;
						GetAttr(WTOGGLEA_Checked,GlbManagerGadgets[GAD_MAN_OPEN_ID],&openf);
						if (openf && !ActiveNodeP->OpenF)
						{
							openscreen(ActiveNodeP);
							GlbExitSoonF = FALSE;
						}
						else if (!openf && ActiveNodeP->OpenF)
						{
							closescreen(ActiveNodeP);
						}
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],NULL,NULL,
							WLISTVIEWA_List,NULL,
							TAG_END);
						GetDefaultScreenNode();
						SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
							WLISTVIEWA_List,&ScreenList,
							TAG_END);
						setselected();
					}
					break;
				case GAD_MAN_OPENBEHIND_ID:
					if (ActiveNodeP)
					{
						ULONG checked;
						GetAttr(WCHECKBOXA_Checked,GlbManagerGadgets[GAD_MAN_OPENBEHIND_ID],&checked);
						ActiveNodeP->OpenBehindF = checked;
					}
					break;
				case GAD_MAN_PROPERTIES_ID:
					openproperties(TRUE);
					break;
				case GAD_MAN_SHANGHAI_ID:
				{
					ULONG checked;
					GetAttr(WCHECKBOXA_Checked,GlbManagerGadgets[GAD_MAN_SHANGHAI_ID],&checked);
					GlbShanghaiF = checked;
					ULONG mode = SetPubScreenModes(0);
					if (checked)
						SetPubScreenModes(mode | SHANGHAI);
					else
						SetPubScreenModes(mode & ~SHANGHAI);
					break;
				}
				case GAD_MAN_AUTOPOPUP_ID:
				{
					ULONG checked;
					GetAttr(WCHECKBOXA_Checked,GlbManagerGadgets[GAD_MAN_AUTOPOPUP_ID],&checked);
					GlbAutoPopupF = checked;
					ULONG mode = SetPubScreenModes(0);
					if (checked)
						SetPubScreenModes(mode | POPPUBSCREEN);
					else
						SetPubScreenModes(mode & ~POPPUBSCREEN);
					break;
				}
			}
			break;
		case IDCMP_VANILLAKEY:
			if (!WZ_GadgetKeyA(GlbManagerWindowHandleP,msg->Code,msg->Qualifier,NULL))
			{
				switch (msg->Code)
				{
					case 0x1b: // ESC
						hide();
						msg = NULL;
						break;
				}
			}
			break;
		case IDCMP_RAWKEY:
			switch (msg->Code)
			{
				case 0x4c: // cursor up
				{
					ULONG selected;
					GetAttr(WLISTVIEWA_Selected,GlbManagerGadgets[GAD_MAN_LIST_ID],&selected);
					ULONG l = LengthOfScreenList();
					if (l > 0)
					{
						if (selected == ~0)
							selected = 0;
						else if (selected > 0)
							selected--;
						else
							selected = LengthOfScreenList() - 1;
					}
					SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
						WLISTVIEWA_Selected,selected,
						TAG_END);
					setselected();
					break;
				}
				case 0x4d: // cursor down
				{
					ULONG selected;
					GetAttr(WLISTVIEWA_Selected,GlbManagerGadgets[GAD_MAN_LIST_ID],&selected);
					ULONG l = LengthOfScreenList();
					if (l > 0)
					{
						if (selected == ~0)
							selected = 0;
						else if (selected < l - 1)
							selected++;
						else
							selected = 0;
					}
					SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
						WLISTVIEWA_Selected,selected,
						TAG_END);
					setselected();
					break;
				}
				case 0x44: // return == double click
					SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],NULL,NULL,
						WLISTVIEWA_List,NULL,
						TAG_END);
					SetDefaultScreenNode(ActiveNodeP);
					SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],GlbManagerWindowP,NULL,
						WLISTVIEWA_List,&ScreenList,
						TAG_END);
					break;
			}
			break;
		case IDCMP_CLOSEWINDOW:
			hide();
			msg = NULL;
			break;
		case IDCMP_MENUPICK:
		{
			UWORD code = msg->Code;
			while (code != MENUNULL)
			{
				switch (code)
				{
					case PROJECT_SAVE_ID:
					{
						STRPTR err = Save(GlbProgramNameP);
						if (err)
							error(err);
						break;
					}
					case PROJECT_ABOUT_ID:
						WZ_LockWindows(GlbSurfaceP);
						WZ_EasyRequestArgs(GlbSurfaceP,GlbManagerWindowP,REQ_ABOUT_ID,NULL);
						WZ_UnlockWindows(GlbSurfaceP);
						break;
					case PROJECT_HIDE_ID:
						hide();
						msg = NULL;
						break;
					case PROJECT_QUIT_ID:
						retval = TRUE;
						break;
				}
				if (!msg)
					break;
				code = ItemAddress(GlbManagerWindowP->MenuStrip,code)->NextSelect;
			}
			break;
		}
	}
	if (msg)
		ReplyMsg(&msg->ExecMessage);
	return retval;
}

// *************************************************************
// ***
// *** NAME      handlepropertieswindow
// *** FUNCTION  handle all IDCMP messages for the properties window
// ***
// *************************************************************
BOOL handlepropertieswindow(struct IntuiMessage *msg)
{
	BOOL retval = FALSE;
	switch (msg->Class)
	{
		case IDCMP_IDCMPUPDATE:
			switch (GetTagData(GA_ID,-1,(struct TagItem *) msg->IAddress))
			{
				case GAD_PRP_FONT_ID:
					if (ActiveNodeP)
					{
						ULONG selected;
						GetAttr(WCYCLEA_Active,GlbPropertiesGadgets[GAD_PRP_FONT_ID],&selected);
						ActiveNodeP->SysFont = selected;
					}
					break;
				case GAD_PRP_TITLE_ID:
					if (ActiveNodeP)
					{
						STRPTR str;
						GetAttr(WSTRINGA_String,GlbPropertiesGadgets[GAD_PRP_TITLE_ID],(ULONG *) &str);
						strcpy(ActiveNodeP->Title,str);
					}
					break;
				case GAD_PRP_LIKEWB_ID:
					if (ActiveNodeP)
					{
						ULONG checked;
						GetAttr(WCHECKBOXA_Checked,GlbPropertiesGadgets[GAD_PRP_LIKEWB_ID],&checked);
						ActiveNodeP->LikeWorkbenchF = checked;
					}
					break;
				case GAD_PRP_CLOSEGADGET_ID:
					if (ActiveNodeP)
					{
						ULONG checked;
						GetAttr(WCHECKBOXA_Checked,GlbPropertiesGadgets[GAD_PRP_CLOSEGADGET_ID],&checked);
						ActiveNodeP->CloseGadgetF = checked;
					}
					break;
				case GAD_PRP_DRAGGABLE_ID:
					if (ActiveNodeP)
					{
						ULONG checked;
						GetAttr(WCHECKBOXA_Checked,GlbPropertiesGadgets[GAD_PRP_DRAGGABLE_ID],&checked);
						ActiveNodeP->DraggableF = checked;
					}
					break;
				case GAD_PRP_QUIET_ID:
					if (ActiveNodeP)
					{
						ULONG checked;
						GetAttr(WCHECKBOXA_Checked,GlbPropertiesGadgets[GAD_PRP_QUIET_ID],&checked);
						ActiveNodeP->QuietF = checked;
					}
					break;
				case GAD_PRP_EXCLUSIVE_ID:
					if (ActiveNodeP)
					{
						ULONG checked;
						GetAttr(WCHECKBOXA_Checked,GlbPropertiesGadgets[GAD_PRP_EXCLUSIVE_ID],&checked);
						ActiveNodeP->ExclusiveF = checked;
					}
					break;
			}
			break;
		case IDCMP_VANILLAKEY:
			if (!WZ_GadgetKeyA(GlbPropertiesWindowHandleP,msg->Code,msg->Qualifier,NULL))
			{
				switch (msg->Code)
				{
					case 0x1b: // ESC
						closeproperties();
						GlbOpenPropertiesF = FALSE;
						msg = NULL;
						break;
				}
			}
			break;
		case IDCMP_CLOSEWINDOW:
			closeproperties();
			GlbOpenPropertiesF = FALSE;
			msg = NULL;
			break;
	}
	if (msg)
		ReplyMsg(&msg->ExecMessage);
	return retval;
}

// *************************************************************
// ***
// *** NAME      handleintuimsg
// *** FUNCTION  handle all IDCMP messages
// ***
// *************************************************************
BOOL handleintuimsg(struct IntuiMessage *msg)
{
	BOOL retval = FALSE;
	if (msg->IDCMPWindow == GlbManagerWindowP)
		retval = handlemanagerwindow(msg);
	else if (msg->IDCMPWindow == GlbPropertiesWindowP)
		retval = handlepropertieswindow(msg);
	else // close gadget pressed?
	{
		struct ScreenNode *node;
		for (node = (struct ScreenNode *) ScreenList.mlh_Head;
			node->Node.Node.mln_Succ;
			node = (struct ScreenNode *) node->Node.Node.mln_Succ)
		{
			if (msg->IDCMPWindow == node->CloseGadget)
			{
				switch (msg->Class)
				{
					case IDCMP_CLOSEWINDOW:
						closescreen(node);
						msg = NULL;
						break;
				}
				if (msg)
					ReplyMsg(&msg->ExecMessage);
			}
		}
	}
	return retval;
}

// *************************************************************
// ***
// *** NAME      readtok
// *** FUNCTION  read next token from a REXX command string
// ***
// *************************************************************
STRPTR readtok(STRPTR *cmdbuf)
{
	STRPTR cmd = *cmdbuf;
	while (isspace(*cmd))
		cmd++;
	if (!*cmd)
	{
		*cmdbuf = cmd;
		return NULL;
	}
	STRPTR command = cmd;
	UBYTE delim = '\0';
	UBYTE ch = *cmd;
	if (*cmd == '\"' || *cmd == '\'')
	{
		delim = ch;
		cmd++;
		for (;;)
		{
			while (*cmd && *cmd != delim)
				cmd++;
			if (!*cmd)
			{
				*cmdbuf = cmd;
				return command; // last token must not stop with delim
			}
			if (*(cmd+1) != delim)
				break;
			cmd += 2;
		}
	}
	else
	{
		while (*cmd && !isspace(*cmd))
			cmd++;
		if (!*cmd)
		{
			*cmdbuf = cmd;
			return command;
		}
	}
	*cmd++ = '\0';
	*cmdbuf = cmd;
	return command;
}

// *************************************************************
// ***
// *** NAME      handlerexxmsg
// *** FUNCTION  handle REXX messages
// ***
// *************************************************************
BOOL handlerexxmsg(struct RexxMsg *msg)
{
	BOOL retval = FALSE;
	if ((msg->rm_Action & RXCODEMASK) == RXCOMM)
	{
		UBYTE cmdbuf[256];
		strncpy(cmdbuf,msg->rm_Args[0],255);
		cmdbuf[255] = '\0';
		STRPTR cmd = cmdbuf;
		STRPTR command = readtok(&cmd);
		if (Stricmp(command,"OPEN") == 0) // OPEN <screenname>
		{
			STRPTR name = readtok(&cmd);
			if (name)
			{
				if (!readtok(&cmd))
				{
					struct ScreenNode *node = FindScreenNode(name);
					if (node)
					{
						if (node->StormScreenF && !node->OpenF)
							openscreen(node);
						else
							msg->rm_Result1 = RC_WARN;
					}
					else
						msg->rm_Result1 = RC_ERROR;
				}
				else
					msg->rm_Result1 = RC_ERROR;
			}
			else
				msg->rm_Result1 = RC_ERROR;
		}
		else if (Stricmp(command,"CLOSE") == 0) // CLOSE <screenname>
		{
			STRPTR name = readtok(&cmd);
			if (name)
			{
				if (!readtok(&cmd))
				{
					struct ScreenNode *node = FindScreenNode(name);
					if (node)
					{
						if (node->StormScreenF && node->OpenF)
							closescreen(node);
						else
							msg->rm_Result1 = RC_WARN;
					}
					else
						msg->rm_Result1 = RC_ERROR;
				}
				else
					msg->rm_Result1 = RC_ERROR;
			}
			else
				msg->rm_Result1 = RC_ERROR;
		}
		else if (Stricmp(command,"SCREENTOFRONT") == 0) // SCREENTOFRONT <screenname>
		{
			STRPTR name = readtok(&cmd);
			if (name)
			{
				if (!readtok(&cmd))
				{
					struct ScreenNode *node = FindScreenNode(name);
					if (node)
					{
						if (node->StormScreenF && node->OpenF)
							ScreenToFront(node->Screen);
						else
							msg->rm_Result1 = RC_WARN;
					}
					else
						msg->rm_Result1 = RC_ERROR;
				}
				else
					msg->rm_Result1 = RC_ERROR;
			}
			else
				msg->rm_Result1 = RC_ERROR;
		}
		else if (Stricmp(command,"SCREENTOBACK") == 0) // SCREENTOBACK <screenname>
		{
			STRPTR name = readtok(&cmd);
			if (name)
			{
				if (!readtok(&cmd))
				{
					struct ScreenNode *node = FindScreenNode(name);
					if (node)
					{
						if (node->StormScreenF && node->OpenF)
							ScreenToBack(node->Screen);
						else
							msg->rm_Result1 = RC_WARN;
					}
					else
						msg->rm_Result1 = RC_ERROR;
				}
				else
					msg->rm_Result1 = RC_ERROR;
			}
			else
				msg->rm_Result1 = RC_ERROR;
		}
		else if (Stricmp(command,"HIDE") == 0) // HIDE
		{
			if (!readtok(&cmd))
				hide();
			else
				msg->rm_Result1 = RC_ERROR;
		}
		else if (Stricmp(command,"SHOW") == 0) // SHOW
		{
			if (!readtok(&cmd))
				show();
			else
				msg->rm_Result1 = RC_ERROR;
		}
		else if (Stricmp(command,"QUIT") == 0) // QUIT
		{
			if (!readtok(&cmd))
				retval = TRUE;
			else
				msg->rm_Result1 = RC_ERROR;
		}
		else
		{
			msg->rm_Result1 = RC_FATAL; // unknown command
		}
		ReplyMsg(&msg->rm_Node)
	}
	return retval;
}

// *************************************************************
// ***
// *** NAME      main
// *** FUNCTION
// ***
// *************************************************************
void main(int argc, char *argv[])
{
	NewList((struct List *) &ScreenList);

	// set the current directory
	if (argc == 0) // started from WB
	{
		GlbCurrentDir = CurrentDir(DupLock(((struct WBStartup *) argv)->sm_ArgList[0].wa_Lock));
		GlbProgramNameP = ((struct WBStartup *) argv)->sm_ArgList[0].wa_Name;
	}
	else
	{
		GlbCurrentDir = CurrentDir(Lock("PROGDIR:",SHARED_LOCK));
		GlbProgramNameP = argv[0];
	}

	// open locale catalog
	if (LocaleBase)
	{
		GlbCatalogP = OpenCatalog(NULL,"StormScreenManager.catalog",
			OC_Version,0,
			TAG_END);
	}

	// open user interface
	if (!(GlbScreenP = LockPubScreen(NULL)))
		error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	if (!(GlbSurfaceP = WZ_OpenSurface(NULL,WizardSurface,
		SFH_Catalog,GlbCatalogP,
		TAG_END)))
	{
		error(getlocalestr(MSG_UNABLE_TO_OPEN_WIZARD_FILE_ID,MSG_UNABLE_TO_OPEN_WIZARD_FILE_ID_STR));
	}
	if (!(GlbManagerWindowHandleP = WZ_AllocWindowHandle(GlbScreenP,0,GlbSurfaceP,
		TAG_END)))
	{
		error(getlocalestr(MSG_OUT_OF_MEMORY_ID,MSG_OUT_OF_MEMORY_ID_STR));
	}
	if (!(GlbManagerNewWindowP = WZ_CreateWindowObj(GlbManagerWindowHandleP,MANAGERWIN_ID,
		WWH_GadgetArray,GlbManagerGadgets,
		TAG_END)))
	{
		error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	}
	if (!(GlbPropertiesWindowHandleP = WZ_AllocWindowHandle(GlbScreenP,0,GlbSurfaceP,
		TAG_END)))
	{
		error(getlocalestr(MSG_OUT_OF_MEMORY_ID,MSG_OUT_OF_MEMORY_ID_STR));
	}
	if (!(GlbPropertiesNewWindowP = WZ_CreateWindowObj(GlbPropertiesWindowHandleP,PROPERTIESWIN_ID,
		WWH_GadgetArray,GlbPropertiesGadgets,
		TAG_END)))
	{
		error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	}
	if (!(GlbIDCMPortP = CreateMsgPort()))
	{
		error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	}

	// allocate signal for public screens
	if ((GlbScreenSignal = AllocSignal(~0)) == ~0)
	{
		error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	}

	// create REXX msg port
	if (!(GlbRexxPortP = CreateMsgPort()))
	{
		error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	}
	Forbid();
	if (FindPort("StormScreenManager"))
	{
		Permit();
		DeleteMsgPort(GlbRexxPortP);
		GlbRexxPortP = NULL;
		error(getlocalestr(MSG_REXXPORT_IN_USE_ID,MSG_REXXPORT_IN_USE_ID_STR));
	}
	GlbRexxPortP->mp_Node.ln_Name = "StormScreenManager";
	AddPort(GlbRexxPortP);
	Permit();

	STRPTR err = Load(GlbProgramNameP);
	if (err)
		error(err);

	// initialize asl requesters using the loaded geometries
	struct TagItem ScreenModeInfoTags[] =
	{
		{ ASLSM_InitialInfoLeftEdge, GlbScreenModeGeometry.InfoLeft },
		{ ASLSM_InitialInfoTopEdge, GlbScreenModeGeometry.InfoTop },
//		{ ASLSM_InitialInfoWidth, GlbScreenModeGeometry.InfoWidth },
//		{ ASLSM_InitialInfoHeight, GlbScreenModeGeometry.InfoHeight },
		{ TAG_END }
	};
	struct TagItem ScreenModeTags[] =
	{
		{ ASLSM_InitialLeftEdge, GlbScreenModeGeometry.Left },
		{ ASLSM_InitialTopEdge, GlbScreenModeGeometry.Top },
		{ ASLSM_InitialWidth, GlbScreenModeGeometry.Width },
		{ ASLSM_InitialHeight, GlbScreenModeGeometry.Height },
		{ GlbScreenModeGeometry.InfoSet ? TAG_MORE : TAG_END, (ULONG) ScreenModeInfoTags }
	};
	if (!(GlbScreenModeRequesterP = (struct ScreenModeRequester *) AllocAslRequestTags(ASL_ScreenModeRequest,
		ASLSM_PrivateIDCMP,TRUE,
		ASLSM_Screen,GlbScreenP,
		ASLSM_TitleText,getlocalestr(MSG_SELECT_SCREEN_MODE_ID,MSG_SELECT_SCREEN_MODE_ID_STR),
		GlbScreenModeGeometry.Set ? TAG_MORE : TAG_END, ScreenModeTags)))
	{
		error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	}
	struct TagItem FontReqTags[] =
	{
		{ ASLFO_InitialLeftEdge, GlbFontGeometry.Left },
		{ ASLFO_InitialTopEdge, GlbFontGeometry.Top },
		{ ASLFO_InitialWidth, GlbFontGeometry.Width },
		{ ASLFO_InitialHeight, GlbFontGeometry.Height },
		{ TAG_END }
	};
	if (!(GlbFontRequesterP = (struct FontRequester *) AllocAslRequestTags(ASL_FontRequest,
		ASLFO_PrivateIDCMP,TRUE,
		ASLFO_Screen,GlbScreenP,
		ASLFO_TitleText,getlocalestr(MSG_SELECT_FONT_ID,MSG_SELECT_FONT_ID_STR),
		GlbFontGeometry.Set ? TAG_MORE : TAG_END, FontReqTags)))
	{
		error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	}

	// initialize commodity
	if (!(GlbBrokerPortP = CreateMsgPort()))
		error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	struct NewBroker newbroker =
	{
		NB_VERSION,
		"StormScreenManager",
		getlocalestr(MSG_BROKER_TITLE_ID,MSG_BROKER_TITLE_ID_STR),
		getlocalestr(MSG_BROKER_DESCRIP_ID,MSG_BROKER_DESCRIP_ID_STR),
		NBU_UNIQUE|NBU_NOTIFY,
		COF_SHOW_HIDE,
		GlbCXPriority,
		GlbBrokerPortP
	};
	LONG brokererr;
	if (!(GlbBrokerP = CxBroker(&newbroker,&brokererr)))
	{
		error(brokererr != CBERR_DUP ? getlocalestr(MSG_UNABLE_TO_INSTALL_COMMODITY_ID,MSG_UNABLE_TO_INSTALL_COMMODITY_ID_STR) : NULL);
	}
	if (GlbCXPopkeyF)
	{
		CxObj *filter, *sender, *translate;
		filter = CxFilter(GlbCXPopkey);
		sender = CxSender(GlbBrokerPortP,EVT_HOTKEY);
		translate = CxTranslate(NULL);
		AttachCxObj(GlbBrokerP,filter);
		AttachCxObj(filter,sender);
		AttachCxObj(filter,translate);
		if (CxObjError(GlbBrokerP) || CxObjError(filter))
			error(getlocalestr(MSG_FATAL_ID,MSG_FATAL_ID_STR));
	}
	ActivateCxObj(GlbBrokerP,1);

	// final stage: init header, open screens, init listview
	InitHeaderNode();
	ScanOpenPubScreens();
	struct ScreenNode *node;
	for (node = (struct ScreenNode *) ScreenList.mlh_Head;
		node->Node.Node.mln_Succ;
		node = (struct ScreenNode *) node->Node.Node.mln_Succ)
	{
		if (node->StormScreenF && node->OpenSoonF)
		{
			openscreen(node);
		}
	}
	if (DefaultScreenNodeP)
		SetDefaultScreenNode(DefaultScreenNodeP);
	GetDefaultScreenNode();
	SetGadgetAttrs(GlbManagerGadgets[GAD_MAN_LIST_ID],NULL,NULL,
		WLISTVIEWA_HeaderNode,&HeaderNode,
		WLISTVIEWA_List,&ScreenList,
		WLISTVIEWA_Columns,6,
		TAG_END);
	setselected();

	// popup user interface?
	if (GlbStartPopupF)
		show();

	// the main loop
	ULONG mask = (1L << GlbIDCMPortP->mp_SigBit)
		| (1L << GlbScreenSignal)
		| (1L << GlbBrokerPortP->mp_SigBit)
		| (1L << GlbRexxPortP->mp_SigBit)
		| SIGBREAKF_CTRL_C;
	BOOL exitloop = FALSE;
	GlbExitSoonF = FALSE;
	while (!exitloop)
	{
		ULONG signals = Wait(mask);

		// Ctrl-C
		if (signals & SIGBREAKF_CTRL_C)
			GlbExitSoonF = TRUE;

		// IDCMP messages
		struct IntuiMessage *msg;
		while (msg = (struct IntuiMessage *) GetMsg(GlbIDCMPortP))
		{
			if (handleintuimsg(msg))
			{
				GlbExitSoonF = TRUE;
				break;
			}
		}

		// screen signals are sent if the last window is closed
		if (signals & (1L << GlbScreenSignal))
		{
			struct ScreenNode *node;
			for (node = (struct ScreenNode *) ScreenList.mlh_Head;
				node->Node.Node.mln_Succ;
				node = (struct ScreenNode *) node->Node.Node.mln_Succ)
			{
				if (node->CloseSoonF && node->OpenF)
				{
					if (CloseScreen(node->Screen))
					{
						node->CloseSoonF = FALSE;
						node->OpenF = FALSE;
						node->Screen = NULL;
					}
				}
			}
			setselected();
		}

		// commodity messages
		CxMsg *cxmsg;
		while (cxmsg = (CxMsg *) GetMsg(GlbBrokerPortP))
		{
			ULONG msgid = CxMsgID(cxmsg);
			ULONG msgtype = CxMsgType(cxmsg);
			ReplyMsg((struct Message *) cxmsg);
			switch (msgtype)
			{
				case CXM_IEVENT:
					switch (msgid)
					{
						case EVT_HOTKEY: // hotkey pressed
							show();
							break;
					}
					break;
				case CXM_COMMAND:
					switch (msgid)
					{
						case CXCMD_DISABLE:
							GlbDisableF = TRUE;
							ActivateCxObj(GlbBrokerP,0);
							break;
						case CXCMD_ENABLE:
							GlbDisableF = FALSE;
							ActivateCxObj(GlbBrokerP,1);
							break;
						case CXCMD_APPEAR:
						case CXCMD_UNIQUE: // SSM is started second time
							show();
							break;
						case CXCMD_DISAPPEAR:
							hide();
							break;
						case CXCMD_KILL:
							GlbExitSoonF = TRUE; // exit as soon as possible
							break;
					}
					break;
			}
		}

		// handle REXX messages
		struct RexxMsg *rxmsg;
		while (rxmsg = (struct RexxMsg *) GetMsg(GlbRexxPortP))
		{
			if (handlerexxmsg(rxmsg))
			{
				GlbExitSoonF = TRUE;
				break;
			}
		}

		// try to exit
		if (GlbExitSoonF)
		{
			exitloop = TRUE;
			struct ScreenNode *node;
			for (node = (struct ScreenNode *) ScreenList.mlh_Head;
				node->Node.Node.mln_Succ;
				node = (struct ScreenNode *) node->Node.Node.mln_Succ)
			{
				if (node->StormScreenF && node->OpenF)
				{
					// try to close the screen
					closescreen(node);
					if (node->OpenF) // couldn't close the screen
						exitloop = FALSE; // -> cannot exit
				}
			}
			setselected(); // some screens may be closed
		}
	}
	error(NULL); // exit gracefully
}
