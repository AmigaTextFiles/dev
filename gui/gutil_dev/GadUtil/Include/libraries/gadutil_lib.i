	IFND	GADUTIL_LIB_I
GADUTIL_LIB_I	SET	1
**------------------------------------------------------------------------**
*
*	$VER: gadutil_lib.i 37.10 (28.09.97)
*
*	Filename:	libraries/gadutil_lib.i
*	Version:	37.10
*	Date:		28-Sep-97
*
*	Gadutil definitions, a dynamic gadget layout system.
*
*	© Copyright 1994-1997 by P-O Yliniemi and Staffan Hämälä.
*
*	All Rights Reserved.
*
**------------------------------------------------------------------------**

	IFND	EXEC_TYPES_I
	include	"exec/types.i"
	ENDC

	IFND	EXEC_LIBRARIES_I
	include	"exec/libraries.i"
	ENDC

	LIBINIT
	LIBDEF	_LVOGU_LayoutGadgetsA		; Layouts gadgets.
	LIBDEF	_LVOGU_FreeLayoutGadgets	; Frees layouted gadgets.
	LIBDEF	_LVOGU_CreateGadgetA
	LIBDEF	_LVOGU_SetGadgetAttrsA		; Changes attributes.
	LIBDEF	_LVOGU_GetIMsg			; Get message, process keys
	LIBDEF	_LVOGU_CountNodes		; Count nodes in a list
	LIBDEF	_LVOGU_GadgetArrayIndex		; 
	LIBDEF	_LVOGU_BlockInput
	LIBDEF	_LVOGU_FreeInput

	LIBDEF	_LVOGU_FindTag			; "reserved" library routine
	LIBDEF	_LVOGU_GetGTTags		; "reserved" library routine
	LIBDEF	_LVOGU_CountEntries		; "reserved" library routine
	LIBDEF	_LVOGU_ToLower			; "reserved" library routine

	LIBDEF	_LVOGU_FreeGadgets		; Free allocated gadgets
	LIBDEF	_LVOGU_SetGUGadAttrsA		; Set attributes of GU gadget
	LIBDEF	_LVOGU_CoordsInGadBox		; Check if coords are within
						;  gadget border
	LIBDEF	_LVOGU_GetGadgetPtr		; Find the gadget structure
	LIBDEF	_LVOGU_TextWidth		; Get pixel length of text
	LIBDEF	_LVOGU_GetLocaleStr		; Get a string from a catalog
	LIBDEF	_LVOGU_CreateLocMenuA		; Create localized menus
	LIBDEF	_LVOGU_OpenCatalog		; Open a message catalog
	LIBDEF	_LVOGU_CloseCatalog		; Close a message catalog
	LIBDEF	_LVOGU_DisableGadget		; Disable / Enable a gadget
	LIBDEF	_LVOGU_SetToggle		; Change status of toggle-sel
	LIBDEF	_LVOGU_RefreshBoxes		; Redraw bevel boxes
	LIBDEF	_LVOGU_RefreshWindow		; Redraw window contents
	LIBDEF	_LVOGU_OpenFont			; Open a font

	LIBDEF	_LVOGU_NewList			; Initialize a new list
	LIBDEF	_LVOGU_ClearList		; Clear a listview and dealloc
	LIBDEF	_LVOGU_DetachList		; Remove list from listview
	LIBDEF	_LVOGU_AttachList		; Change/set listview's list
	LIBDEF	_LVOGU_AddTail			; Add a node at end of list
	LIBDEF	_LVOGU_ChangeStr		; Change a string gadget

	LIBDEF	_LVOGU_CreateContext		; GadTools replacement routine
	LIBDEF	_LVOGU_GetGadgetAttrsA		; GadTools replacement routine
	LIBDEF	_LVOGU_CreateMenusA		; GadTools replacement routine
	LIBDEF	_LVOGU_FreeMenus		; GadTools replacement routine
	LIBDEF	_LVOGU_LayoutMenuItemsA		; GadTools replacement routine
	LIBDEF	_LVOGU_LayoutMenusA		; GadTools replacement routine
	LIBDEF	_LVOGU_GetVisualInfoA		; GadTools replacement routine
	LIBDEF	_LVOGU_FreeVisualInfo		; GadTools replacement routine
	LIBDEF	_LVOGU_BeginRefresh		; GadTools replacement routine
	LIBDEF	_LVOGU_EndRefresh		; GadTools replacement routine
	LIBDEF	_LVOGU_FilterIMsg		; GadTools replacement routine
	LIBDEF	_LVOGU_PostFilterIMsg		; GadTools replacement routine
	LIBDEF	_LVOGU_ReplyIMsg		; GadTools replacement routine
	LIBDEF	_LVOGU_DrawBevelBoxA		; GadTools replacement routine

	LIBDEF	_LVOGU_FindNode			; Find the n:th node in a list
	LIBDEF	_LVOGU_NodeUp			; Move a node one step up
	LIBDEF	_LVOGU_NodeDown			; Move a node one step down

	LIBDEF	_LVOGU_UpdateProgress		; Redraw/update progress indicator
	LIBDEF	_LVOGU_SortList			; Sort nodes in one or two lists

	LIBDEF	_LVOGU_CheckVersion		; Check version.revision of lib/dev
	LIBDEF	_LVOGU_ClearWindow		; Fill a window with selected color
	LIBDEF	_LVOGU_SizeWindow		; Change size of a window, move if
						;  necessary
	LIBDEF	_LVOGU_CloseFont		; Close a system font

	ENDC	; GADUTIL_LIB_I
