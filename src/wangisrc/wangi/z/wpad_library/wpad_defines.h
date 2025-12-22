#ifndef WPAD_DEFINES_H
#define WPAD_DEFINES_H 1

/***************************************************************************
 * wpad_defines.h
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * 
 */

/***************************************************************************
 * Structure defining a pad
 */

struct Pad 
{
	/* 
	 * This is the private definition
	 * Initial fields must match those in wpad.h
	 *
	 * Public fields... 
	 */
	LONG             pad_ID;
	/*
	 * Private fields...
	 */
	struct Process   *pad_Process;  // Process descriptor
	struct MsgPort   *pad_MsgPort;  // Message port to send requests to ?
	struct MsgPort   *pad_CxMsgPort;// Port for Cx hotkey messages
	struct List      *pad_Items;    // Items in the listview
	struct Hook      *pad_Hook;     // Hook to call on double click
	STRPTR            pad_PSName;   // Name of screen to open on
	STRPTR            pad_Title;    // Title of the pad window
	STRPTR            pad_ScrTitle; // Title of the pad screen
	struct TextAttr  *pad_TAFont;
	struct TextFont  *pad_TFont;    // Default font for the items
	LONG              pad_Iconify;  // iconify method see WPOP_ICONIFY_#? defines
	CxObj            *pad_Broker;   // Cx Broker to add hotkeys onto
	STRPTR            pad_HotKey;   // Input description of the activate-hide hotkey
	CxObj            *pad_HotKeyH;  // Hotkey Cx Object
	STRPTR            pad_IconName; // Filename of icon to use for icon
	LONG              pad_State;    // Are we iconified? see WPOP_STATE_#? defines
	struct Window    *pad_Window;   // The pad window
	LONG              pad_OrgLeft;  // Original left edge position
	LONG              pad_OrgTop;   // Original top edge position
	LONG              pad_OrgWidth; // Original width
	LONG              pad_OrgHeight;// Original Height
	ULONG             pad_Flags;    // Flags - see WPOP_STYLE_#? defines
	struct Menu      *pad_Menu;     // Menu on pad window
	struct AppWindow *pad_AppWindow;// Handle of the AppWindow
	APTR              pad_AppHide;  // Handle of App#? when hidden
	LONG              pad_ScrollW;  // Width of scroller
	struct TagItem   *pad_OWTTags;  // Tags to pass to OpenWindowTags()
	struct TagItem   *pad_CGTags;   // Tags to pass to CreateGadgetA()
	struct TagItem   *pad_LMTags;   // Tags to pass to LayoutMenuA()
};

/***************************************************************************
 * Default tag values 
 */

#define DEF_WPOP_ProcName "wpad.library_Pad"
#define DEF_WPOP_StackSize 4096
#define DEF_WPOP_Priority 0
#define DEF_WPOP_CurrentDir 0
#define DEF_WPOP_LeftEdge 0
#define DEF_WPOP_TopEdge 0
#define DEF_WPOP_Width 60
#define DEF_WPOP_Height 120
/* No DEF_WPOP_Items */
#define DEF_WPOP_Hook NULL
#define DEF_WPOP_Menu NULL
#define DEF_WPOP_PubScreenName NULL
#define DEF_WPOP_ScrollerWidth 16
#define DEF_WPOP_Flags WPOP_STYLE_SIZEGADGET | WPOP_STYLE_DRAGBAR | \
                       WPOP_STYLE_DEPTHGADGET | WPOP_STYLE_CLOSEGADGET
#define DEF_WPOP_Title NULL
#define DEF_WPOP_ScreenTitle NULL
/* No DEF_WPOP_Font */
#define DEF_WPOP_Iconify WPOP_ICONIFY_HOTKEY
#define DEF_WPOP_Broker NULL
#define DEF_WPOP_HotKey NULL
#define DEF_WPOP_IconifyIcon "ENV/Sys/def_Pad"
#define DEF_WPOP_State WPOP_STATE_SHOWN
#define DEF_WPOP_CNPTags NULL
#define DEF_WPOP_OWTTags NULL
#define DEF_WPOP_CGTags NULL
#define DEF_WPOP_LMTags NULL

/***************************************************************************
 *
 */

#define EVENT_MAINHOTKEY -1

/***************************************************************************
 * WPMsg structure - used for communication between library and threads
 */

struct WPMsg
{
	struct Message  wpm_Msg;    // Basic Message
	LONG            wpm_Action; // Do what? see WPM_ACTION_#? defines
	struct TagItem *wpm_Data;   // Data for some of the WPM_ACTION types
};

#define wpm_Node wpm_Msg.mn_Node
#define wpm_ReplyPort wpm_Msg.mn_ReplyPort
#define wpm_Length wpm_Msg.mn_Length

#define WPM_ACTION_DIE 1
        /* This thread is terminated */
#define WPM_ACTION_GETATTRS 2
        /* Process WP_GetAttrsA() */
#define WPM_ACTION_SETATTRS 3
        /* Process WP_SetAttrsA() */

/***************************************************************************
 * PIHandles structure
 */

struct PIHandles
{
	CxObj  *pih_HotKey;   /* Private! */
	Object *pih_DataType; /* Private! */
	APTR    pih_App;      /* Private! */
};

#define PIH_SIZE_HOTKEY   (sizeof(struct CxObj *))
#define PIH_SIZE_DATATYPE (sizeof(struct CxObj *) + sizeof(struct Object *))
#define PIH_SIZE_APP      (sizeof(struct PIHandles))

/***************************************************************************
 * Useful macros
 */

/* 
 * Find a tag and set a variable to its data value or a default if not present
 * f - Tag to search for (LONG)
 * d - Variable to write result into
 * e - Default value if tag is not found
 * t - Type of d
 * l - Taglist (struct TagItem *)
 * g - temp. variable (struct TagItem *)
 */
#define GETTAG(f,d,e,t,l,g) if( g = FindTagItem(f, l) ) \
                              d = t g->ti_Data; \
                            else \
                              d = e

#endif
