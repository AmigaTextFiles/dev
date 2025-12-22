; --------------------------------------------------------------------------------------
;
; This source file is part of PureBasic
; For the latest info, see http://www.purebasic.com/
; 
; Copyright (c) 1998-2006 Fantaisie Software
;
; This program is free software; you can redistribute it and/or modify it under
; the terms of the GNU Lesser General Public License as published by the Free Software
; Foundation; either version 2 of the License, or (at your option) any later
; version.
;
; This program is distributed in the hope that it will be useful, but WITHOUT
; ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
; FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
;
; You should have received a copy of the GNU Lesser General Public License along with
; this program; if not, write to the Free Software Foundation, Inc., 59 Temple
; Place - Suite 330, Boston, MA 02111-1307, USA, or go to
; http://www.gnu.org/copyleft/lesser.txt.
;
; Note: As PureBasic is a compiler, the programs created with PureBasic are not
; covered by the LGPL license, but are fully free, license free and royality free
; software.
;
; --------------------------------------------------------------------------------------
;
;	$VER: pm.h 10.05 (11.11.00)
;
;	Library base, tags and macro definitions
;	for popupmenu.library.
;
;	©1996-2000 Henrik Isaksson
;	All Rights Reserved.

TAG_USER   = 0 ;1 << 31

PM_Menu			=(TAG_USER+4)	; (struct PopupMenu *) Pointer to menulist initialized by MakeMenu()		
PM_Top			=(TAG_USER+12)	; (LONG) Top (Y) position							
PM_Left			=(TAG_USER+13)	; (LONG) Left (X) position							
PM_Code			=(TAG_USER+14)	; (UWORD) Obsolete.								
PM_Right		=(TAG_USER+15)	; (LONG) X position relative to right edge					
PM_Bottom		=(TAG_USER+16)	; (LONG) Y position relative to bottom edge					
PM_MinWidth		=(TAG_USER+17)	; (LONG) Minimum width								
PM_MinHeight		=(TAG_USER+18)	; (LONG) Minimum height							
PM_ForceFont		=(TAG_USER+19)	; (struct TextFont *tf) Use this font instead of user preferences.		
PM_PullDown		=(TAG_USER+90)	; (BOOL) Turn the menu into a pulldown menu.					
PM_MenuHandler		=(TAG_USER+91)	; (struct Hook *) Hook that is called for each selected item, after the	
						; menu has been closed. This tag turns on MultiSelect.				
PM_AutoPullDown		=(TAG_USER+92)	; (BOOL) Automatic pulldown menu. (PM_FilterIMsg only)				
PM_LocaleHook		=(TAG_USER+93)	; (struct Hook *) Locale "GetString()" hook. (Not yet implemented)		
PM_CenterScreen		=(TAG_USER+94)	; (BOOL) Center menu on the screen						
PM_UseLMB		=(TAG_USER+95)	; (BOOL) Left mouse button should be used to select an item			
						; (right button selects multiple items)					
PM_DRIPensOnly		=(TAG_USER+96)	; (BOOL) Only use the screen's DRI pens, revert to system images if necessary.	
						; Use with care as it overrides the user's prefs!				
PM_HintBox		=(TAG_USER+97)	; (BOOL) Close the menu when the mouse is moved.				

;
; Tags passed to MakeItem


PM_Title		=(TAG_USER+20)	; (STRPTR) Item title								
PM_UserData		=(TAG_USER+21)	; (void *) Anything, returned by OpenPopupMenu when this item is selected	
PM_ID			=(TAG_USER+22)	; (ULONG) ID number, if you want an easy way to access this item later		
PM_CommKey		=(TAG_USER+47)	; (char) Keyboard shortcut for this item.					
PM_TitleID		=(TAG_USER+49)	; (ULONG) Locale string ID 							
PM_Object		=(TAG_USER+43)	; (Object *) BOOPSI object with the abillity to render this item		

; Submenu & Layout tags 
; PM_Sub & PM_Members are mutally exclusive 
PM_Sub			=(TAG_USER+23)	; (PopupMenu *) Pointer to submenu list (from PM_MakeMenu)			
PM_Members		=(TAG_USER+65)	; (PopupMenu *) Members for this group (list created by PM_MakeMenu)		
PM_LayoutMode		=(TAG_USER+64)	; (ULONG) Layout method (PML_Horizontal / PML_Vertical)			

; Text attributes 
PM_FillPen		=(TAG_USER+26)	; (BOOL) Make the item appear in FILLPEN					
PM_Italic		=(TAG_USER+29)	; (BOOL) Italic text								
PM_Bold			=(TAG_USER+30)	; (BOOL) Bold text								
PM_Underlined		=(TAG_USER+31)	; (BOOL) Underlined text							
PM_ShadowPen		=(TAG_USER+34)	; (BOOL) Draw text in SHADOWPEN						
PM_ShinePen		=(TAG_USER+35)	; (BOOL) Draw text in SHINEPEN							
PM_Centre		=(TAG_USER+36)	; (BOOL) Center the text of this item						
PM_Center		=PM_Centre	; American version... 
PM_TextPen		=(TAG_USER+45)	; (ULONG) Pen number for text colour of this item				
PM_Shadowed		=(TAG_USER+48)	; (BOOL) Draw a shadow behind the text						

; Other item attributes 
PM_TitleBar		=(TAG_USER+32)	; (BOOL) Horizontal separator bar						
PM_WideTitleBar		=(TAG_USER+33)	; (BOOL) Same as above, but full width						
PM_NoSelect		=(TAG_USER+25)	; (BOOL) Make the item unselectable (without visual indication)		
PM_Disabled		=(TAG_USER+38)	; (BOOL) Disable an item							
PM_Hidden		=(TAG_USER+63)	; (BOOL) This item is not to be drawn (nor used in the layout process)		

; Images & Icons 
PM_ImageSelected	=(TAG_USER+39)	; (struct Image *) Image when selected, title will be rendered on top it	
PM_ImageUnselected	=(TAG_USER+40)	; (struct Image *) Image when unselected					
PM_IconSelected		=(TAG_USER+41)	; (struct Image *) Icon when selected						
PM_IconUnselected	=(TAG_USER+42)	; (struct Image *) Icon when unselected					

; Check/MX items 
PM_Checkit		=(TAG_USER+27)	; (BOOL) Leave space for a checkmark						
PM_Checked		=(TAG_USER+28)	; (BOOL) Make this item is checked						
PM_AutoStore		=(TAG_USER+44)	; (BOOL *) Pointer to BOOL reflecting the current state of the item		
PM_Exclude		=(TAG_USER+37)	; (PM_IDLst *) Items to unselect or select when this gets selected		
PM_ExcludeShared	=(TAG_USER+101)	; (BOOL) Used if the list is shared between two or more items			
PM_Toggle		=(TAG_USER+100)	; (BOOL) Enable/disable toggling of check/mx items. Default: TRUE		

; Dynamic construction/destruction 
PM_SubConstruct		=(TAG_USER+61)	; (struct Hook *) Constructor hook for submenus. Called before menu is opened.	
PM_SubDestruct		=(TAG_USER+62)	; (struct Hook *) Destructor hook for submenus. Called after menu has closed.	

; Special/misc. stuff 
PM_UserDataString	=(TAG_USER+46)	; (STRPTR) Allocates memory and copies the string to UserData.			
PM_Flags		=(TAG_USER+24)	; (UlONG) For internal use							
PM_ColourBox		=(TAG_USER+60)	; (UlONG) Filled rectangle (for palettes etc.)					
PM_ColorBox		=PM_ColourBox	; For Americans... 
;
; Tags passed to MakeMenu


PM_Item			=(TAG_USER+50)	; (PopupMenu *) Item pointer from MakeItem					
PM_Dummy		=(TAG_USER+51)	; (void) Ignored.								

;
; Tags passed to MakeIDList


PM_ExcludeID		=(TAG_USER+55)	; (ULONG) ID number of menu to deselect when this gets selected		
PM_IncludeID		=(TAG_USER+56)	; (ULONG) ID number of menu to select when this gets selected			
PM_ReflectID		=(TAG_USER+57)	; (ULONG) ID number of menu that should reflect the state of this one		
PM_InverseID		=(TAG_USER+58)	; (ULONG) ID number of menu to inverse reflect the state of this one		

;
; Tags for PM_InsertMenuItemA()


PM_Insert_Before	=(TAG_USER+200)	; (BOOL) Insert before the item pointed to by the following argument	(N/A)	
PM_Insert_BeforeID	=(TAG_USER+201)	; (ULONG) Insert before the first item with ID equal to the argument		
PM_Insert_After		=(TAG_USER+202)	; (PopupMenu *) Insert after the item pointed to by the following argument	
PM_Insert_AfterID	=(TAG_USER+203)	; (ULONG) Insert after the first item with ID equal to the argument		
PM_Insert_Last		=(TAG_USER+205)	; (BOOL) Insert after the last item						
PM_Insert_First		=(TAG_USER+209)	; (BOOL) Insert after the first item (which is usually invisible)		
PM_InsertSub_First	=(TAG_USER+206)	; (PopupMenu *) Insert before the first item in the submenu			 
PM_InsertSub_Last	=(TAG_USER+207)	; (PopupMenu *) Insert at the and of a submenu					
PM_InsertSub_Sorted	=(TAG_USER+208)	; (PopupMenu *) 							(N/A)	
PM_Insert_Item		=(TAG_USER+210)	; (PopupMenu *) Item to insert, may be repeated for several items		

;
; Layout methods


PML_None		=0		; Normal item		
PML_Horizontal		=1		; Horizontal group	
PML_Vertical		=2		; Vertical group	
PML_Table		=3		; Table group		
PML_Default		=255		; Don't use		



PMERR		=-5

POPUPMENU_VERSION	=10
POPUPMENU_NAME		="popupmenu.library"

; Public flags for the PopupMenu->Header.Flags field 

PM_CHECKIT            = $40000000
PM_CHECKED            = $80000000

;-- LVO's
_PM_MakeMenuA  =-30
_PM_MakeItemA =-36
_PM_FreePopupMenu=-42
_PM_OpenPopupMenuA=-48
_PM_MakeIDListA=-54
_PM_ItemChecked=-60
_PM_GetItemAttrsA=-66
_PM_SetItemAttrsA=-72
_PM_FindItem=-78
_PM_AlterState=-84
_PM_OBSOLETEFilterIMsgA=-90
_PM_ExLstA =-96
_PM_FilterIMsgA=-102
_PM_InsertMenuItemA=-108
_PM_RemoveMenuItem=-114
_PM_AbortHook=-120
_PM_GetVersion=-126
_PM_ReloadPrefs=-132
_PM_LayoutMenuA=-138
_PM_RexxHost=-144
_PM_FreeIDList=-150


