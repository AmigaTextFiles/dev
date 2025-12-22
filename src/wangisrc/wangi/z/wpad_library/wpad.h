#ifndef LIBRARIES_WPAD_H
#define LIBRARIES_WPAD_H

/***************************************************************************
 * wpad.h
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * 
 */

#ifndef EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef EXEC_NODES_H
#include <exec/nodes.h>
#endif
#ifndef UTILITY_TAGITEM_H
#include <utility/tagitem.h>
#endif
#ifndef LIBRARIES_COMMODITIES_H
#include <libraries/commodities.h>
#endif
#ifndef INTUITION_CLASSUSR_H
#include <intuition/classusr.h>
#endif

/***************************************************************************
 * Library name and version
 */

#define WPADNAME "wpad.library"
#define WPADVERSION 1

/***************************************************************************
 * Pad structure - The major handle in wpad.library
 */

#ifndef WPAD_C
struct Pad 
{
	LONG pad_ID;
	/* Private fields follow... */
};
#endif

/**************************************************************************
 * Tags for WP_OpenPad(), WP_SetPadAttrs(), WP_GetPadAttrs()
 *
 * I - Can use with WP_OpenPadA()
 * S - Can use with WP_SetPadAttrsA()
 * G - Can use with WP_GetPadAttrsA()
 *
 * Default is for WP_OpenPad if tag is not specified
 */

#define WP_TAGBASE (TAG_USER + 0x2000)

#define WPOP_ProcName      (WP_TAGBASE +  1)
        /* (I-G) (STRPTR)
         * Name of the created process/thread
         * Default - "wpad.library_Pad"
         */
#define WPOP_StackSize     (WP_TAGBASE +  2)
        /* (I-G) (LONG)
         * Stack size of the created thread
         * Default - 4096 
         */
#define WPOP_Priority      (WP_TAGBASE +  3)
        /* (ISG) (LONG)
         * Priority of the created thread
         * Default - 0
         */
#define WPOP_CurrentDir    (WP_TAGBASE +  4)
        /* (---) 
         * Not implemented 
         */
#define WPOP_LeftEdge      (WP_TAGBASE +  5)
        /* (ISG) (LONG)
         * Left edge of pad 
         * See WPOP_LEFTEDGE_#? defines for other options
         * Default - 0
         */
#define WPOP_TopEdge       (WP_TAGBASE +  6)
        /* (ISG) (LONG)
         * Top edge of pad
         * See WPOP_TOPEDGE_#? defines for other options
         * Default - 0 
         */     
#define WPOP_Width         (WP_TAGBASE +  7)
        /* (ISG) (LONG)
         * Width of pad
         * Default - 60
         */
#define WPOP_Height        (WP_TAGBASE +  8)
        /* (ISG) (LONG)
         * Height of Pad
         * Default - 120 
         */
#define WPOP_Items         (WP_TAGBASE +  9)
        /* (ISG) (struct List *)
         * List of items for the pad
         * Tag must be given to WP_OpenPadA() 
         */
#define WPOP_Hook          (WP_TAGBASE + 10)
        /* (ISG) (struct Hook *) Hook(A0 Hook *, A2 WPOPHookMsg *, A1 PadItem*)
         * This hook will be called everytime an item is double clicked.
         */
// RESERVED (WP_TABBASE + 11)
#define WPOP_Menu          (WP_TAGBASE + 12)
        /* (IS-) (struct Menu *)
         * Menu for pad
         */
#define WPOP_PubScreenName (WP_TAGBASE + 13)
        /* (ISG) (STRPTR)
         * Name of public screen to open on
         * Default - default public screen
         */
#define WPOP_ScrollerWidth (WP_TAGBASE + 14)
        /* (ISG) (LONG)
         * Width of the scroller on the pad listview
         * Default - 16
         */
#define WPOP_Flags         (WP_TAGBASE + 15)
        /* (ISG) (ULONG)
         * Determines the style of the pad. See WPOP_STYLE_#? defines.
         * Default - WPOP_STYLE_SIZEGADGET | WPOP_STYLE_DRAGBAR | 
         *           WPOP_STYLE_DEPTHGADGET | WPOP_STYLE_CLOSEGADGET
         */
#define WPOP_Title         (WP_TAGBASE + 16)
        /* (ISG) (STRPTR)
         * Title of the pad window (c.f. WA_Title)
         * Default - ""
         */
#define WPOP_ScreenTitle   (WP_TAGBASE + 17)
        /* (ISG) (STRPTR)
         * Title of the pad screen (c.f. WA_ScreenTitle)
         * Default - ""
         */
#define WPOP_Font          (WP_TAGBASE + 18)
        /* (ISG) (struct TextAttr *)
         * Default font for this pad. Each item can override this!
         * Tag must be given to WP_OpenPadA()
         */
#define WPOP_Iconify       (WP_TAGBASE + 19)
        /* (ISG) (LONG)
         * Iconify method - See WPOP_ICONIFY_#? defines
         * Default - WPOP_ICONIFY_HOTKEY
         */
#define WPOP_Broker        (WP_TAGBASE + 20)
        /* (ISG) (CxObj *)
         * Commodities broker to add hotkey onto
         */
#define WPOP_HotKey        (WP_TAGBASE + 21)
        /* (ISG) (STRPTR)
         * Input description of the event which will activate-hide-show
         * the pad
         */
#define WPOP_IconifyIcon   (WP_TAGBASE + 22)
        /* (ISG) (STRPTR)
         * If WPOP_Iconify is WPOP_ICONIFY_APPICON then this is the filename
         * of the icon to use (sans .info)
         * Default - "ENV/Sys/def_Pad"
         */
#define WPOP_State         (WP_TAGBASE + 23)
        /* (ISG) (LONG)
         * State that the pad will open in... ie hidden/iconified or shown
         * See WPOP_OPENSTATE_#? defines
         * Default - WPOP_STATE_SHOWN
         */
#define WPOP_CNPTags       (WP_TAGBASE + 24)
        /* (I--) (struct TagItem *)
         * Optional Tags to pass straight to CreateNewProc() 
         */
#define WPOP_OWTTags       (WP_TAGBASE + 25)
        /* (ISG) (struct TagItem *)
         * Optional Tags to pass straight to OpenWindowTags() 
         */
#define WPOP_CGTags        (WP_TAGBASE + 26)
        /* (ISG) (struct TagItem *)
         * Optional Tags to pass straight to CreateGadget() for the listview
         */
#define WPOP_LMTags        (WP_TAGBASE + 27)
        /* (ISG) (struct TagItem *)
         * Optional tags to pass straight to LayoutMenuA()
         */

/**************************************************************************
 * Defines for WPOP_LeftEdge and WPOP_TopEdge
 */

#define WPOP_LEFTEDGE_MOUSE -1 
        /* Center on mouse pointer */
#define WPOP_TOPEDGE_MOUSE -1
        /* Center on mouse pointer */
#define WPOP_TOPEDGE_TBORDER -2
        /* Just under the menubar */

/**************************************************************************
 * Defines for WPOP_Flags
 */

#define WPOP_STYLE_SIZEGADGET  (1<<0)
        /* include sizing system-gadget? */
#define WPOP_STYLE_DRAGBAR     (1<<1)
        /* include dragging system-gadget? */
#define WPOP_STYLE_DEPTHGADGET (1<<2)
        /* include depth arrangement gadget? */
#define WPOP_STYLE_CLOSEGADGET (1<<3)
        /* include close-box system-gadget? */
#define WPOP_STYLE_BACKDROP    (1<<4)
        /* this is a backdrop pad */
#define WPOP_STYLE_BORDERLESS  (1<<5)
        /* to get a pad sans border */
#define WPOP_STYLE_ACTIVATE    (1<<6)
        /* when pad opens, it's Active */
#define WPOP_STYLE_STICKY      (1<<7)
        /* When hidden it will reopen at last position */

/**************************************************************************
 * Defines for WPOP_Iconify
 */

#define WPOP_ICONIFY_HOTKEY  0 
        /* Hotkey to iconify-deiconify */
#define WPOP_ICONIFY_APPMENU 1 
        /* Hotkey plus item in WB Tools menu */
#define WPOP_ICONIFY_APPICON 2
        /* Hotkey plus appicon on WB */

/**************************************************************************
 * Defines for WPOP_State
 */

#define WPOP_STATE_SHOWN  0
        /* Pad will be shown */
#define WPOP_STATE_HIDDEN 1
        /* The pad will be iconified */

/***************************************************************************
 * WPOPHookMsg structure
 */

struct WPOPHookMsg
{
	ULONG hm_MethodID; /* ID see WPOP_HOOK_#? defines */
};

/***************************************************************************
 * defines for WPOPHookMsg.hm_MethodID
 */

#define WPOP_HOOK_EXEC 1

/***************************************************************************
 * Return codes from WPOP_Hook
 */

#define WPOP_HOOKRETURN_OK 0
#define WPOP_HOOKRETURN_FAIL 1

/***************************************************************************
 * PIHandles structure
 */

#ifndef WPAD_C
struct PIHandles
{
	APTR pih_PRIVATE; /* All elements are private */
};
#endif

/***************************************************************************
 * PadItem structure - One of these for each item in a pad
 */
 
struct PadItem
{
	struct Node       pi_Node;           /* Backbone structure */
	struct TextFont  *pi_Font;           /* Font to use for this item */
	STRPTR            pi_HotKey;         /* Hotkey description */
	STRPTR            pi_AppIconName;    /* Name of AppIcon (if to be used) */
	STRPTR            pi_DataTypeName;   /* Name of gfx (if to be used) */
	struct PIHandles *pi_Handles;        /* Private! */
	/* You will probably extend this structure */
};

#define pi_Name pi_Node.ln_Name  /* Name of item, text to display */
#define pi_Flags pi_Node.ln_Type /* Flags, see PI_FLAGS_#? defines */
#define pi_Colour pi_Node.ln_Pri /* Colour of text */

/***************************************************************************
 * Flags for pi_Flags
 */

#define PI_FLAGS_WBMENU        (1<<0)
        /* Will have an entry on the Workbench Tools menu */
#define PI_FLAGS_APPICON       (1<<1)
        /* Will have an AppIcon on Workbench */
#define PI_FLAGS_DATATYPE      (1<<2)
        /* Will have a graphical item, using pi_DataTypeName */
#define PI_FLAGS_DTTEXT        (1<<3)
        /* As above plus overlayed text */
#define PI_FLAGS_DEFTEXTCOLOUR (1<<3)
        /* Ignore pi_Colour */

#endif	/* LIBRARIES_WPAD_H */
