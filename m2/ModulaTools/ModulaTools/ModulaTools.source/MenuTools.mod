(******************************************************************************)
(*                                                                            *)
(*  Version 1.00a.002 (Beta) :   March 2, 1988                                *)
(*                                                                            *)
(*    These procedures were originally written under version 1.20 of the TDI  *)
(* Modula-2 compiler. I have rewritten this module to operate under the v2.00 *)
(* compiler. However, should you find any problem or inconsistency with the   *)
(* functionality of this code, please contact me at the following address:    *)
(*                                                                            *)
(*                               Jerry Mack                                   *)
(*                               23 Prospect Hill Ave.                        *)
(*                               Waltham, MA   02154                          *)
(*                                                                            *)
(*    Check the module MenuUtils for TDI's (considerably less powerful) ver-  *)
(* sions of my Menu and IntuitionText procedures. The modules GadgetUtils and *)
(* EasyGadgets should also be of great help.                                  *)
(*                                                                            *)
(******************************************************************************)
(*                                                                            *)
(*    The source code to MenuTools is in the public domain. You may do with   *)
(* it as you please.                                                          *)
(*                                                                            *)
(******************************************************************************)

IMPLEMENTATION MODULE MenuTools;


FROM Intuition       IMPORT IntuitionText, IntuitionTextPtr, WindowPtr,
                            IDCMPFlags,IDCMPFlagSet,
                            Menu, MenuPtr, MenuFlags, MenuFlagSet,
                            MenuItem, MenuItemPtr, ItemFlags, ItemFlagSet,
                            CheckWidth, LowCheckWidth, CommWidth, LowCommWidth;
FROM IntuiUtils      IMPORT MenuNum, ItemNum, SubNum;
FROM Menus           IMPORT ClearMenuStrip, HighFlags;
FROM Storage         IMPORT ALLOCATE, DEALLOCATE;
FROM Strings         IMPORT InitStringModule, String, Compare, Equal, Length;
FROM SYSTEM          IMPORT BYTE, NULL;
FROM TextTools       IMPORT GetIntuiText, DestroyIntuiText, TextDrawMode,
                            FrontTextPen, BackTextPen, LastText, CurrentFont;

CONST
   OutOfBounds = 10000;              (* flag: default Menu & Item placement? *)
   TextFlag    = ItemFlagSet{ItemText};   (* all Menu Items must be textual; *)
   NoText      = 0C;
 
TYPE
   StringPtr = POINTER TO String;       (* storage space for Menu text;      *)

VAR                                     (*       default positions:          *)
   MenuLeft         : INTEGER;          (* left position of current Menu;    *)
   ItemLeft         : INTEGER;          (* left position of current Item;    *)
   ItemTop          : INTEGER;          (* top  position of current Item;    *)
   ItemWide         : INTEGER;          (* width         of current Item;    *)
   ItemColumnTop    : MenuItemPtr;      (* first Item    in current column;  *)
   SubItemLeft      : INTEGER;          (* left position of current SubItem; *)
   SubItemTop       : INTEGER;          (* top  position of current SubItem; *)
   SubItemWide      : INTEGER;          (* width         of current SubItem; *)
   SubItemColumnTop : MenuItemPtr;      (* first SubItem in current column;  *)
   MenuText         : StringPtr;        (* permanent storage of Menu text;   *)
   Itemintuitext    : IntuitionTextPtr; (* Menu-text structure Amiga uses;   *)
 
 
   PROCEDURE Min (int1, int2 : INTEGER ) : INTEGER;
   
   BEGIN
      IF (int1 < int2) THEN              (* utility routine to find the    *)
         RETURN int1;                    (* minimum of a pair of integers; *)
      ELSE
         RETURN int2;
      END; (* IF int1 *)
   END Min; 
   
   
   PROCEDURE Max (int1, int2 : INTEGER ) : INTEGER;
   
   BEGIN
      IF (int1 > int2) THEN              (* utility routine to find the    *)
         RETURN int1;                    (* maximum of a pair of integers; *)
      ELSE
         RETURN int2;
      END; (* IF int1 *)
   END Max; 
   

(***************************************************************************)
(*                                                                         *)
(*    This procedure initializes the variables used in the Menu procedures *)
(* below. If you wish to build several Menu structures, save the value of  *)
(* FirstMenu before the second and subsequent calls: this is the MenuPtr   *)
(* used in the procedure SetMenuStrip to attach the Menu tree to a window. *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE InitializeMenuStrip;
   
   BEGIN
      CurrentMenu   := NULL;                (* no Menus currently defined; *)
      FirstMenu     := NULL;
      SelectText    := NoText;
      MenuLeft      := 0;     (* place next Menu at left edge of Menu bar; *)
      VerPixPerChar := 8;            (* max. # of vertical and horizontal  *)
      HorPixPerChar := 8;           (* pixels per character for this font; *)
      HiResScreen   := FALSE;  (* low-resolution screen (320 hor. pixels); *)
      Left          := OutOfBounds;
      Top           := OutOfBounds;  (* flags: calculate reasonable values *)
      Wide          := OutOfBounds;  (* for positions of Menus and Items;  *)
      High          := OutOfBounds;
      MenuSetting   := MenuFlagSet{MenuEnabled};          (* enable Menus; *)
      AutoIndent    := FALSE;        (* don't shift (Sub)Items to right;   *)
      RightJustify  := TRUE;         (* align right edges of (Sub)Items;   *)
      NewItemColumn := FALSE;        (* don't start new (Sub)Item column   *)
      ItemPen       := -1;
      ItemSelectPen := -1;
   END InitializeMenuStrip;          (* unless required to for checkmark;  *)


(***************************************************************************)
(*                                                                         *)
(*    This procedure adds a new Menu to the current Menu-tree. All Menu    *)
(* structures and pointers are properly allocated and linked. The only     *)
(* required parameter is the string MenuBarText, which contains the text   *)
(* for the new Menu. Upon the execution of this procedure, the global      *)
(* pointer CurrentMenu will point to this new Menu.                        *)
(*                                                                         *)
(*    The placement of the Menus is determined by the global variables     *)
(* Left, Top, Wide and High. If you assign a value to any of these prior   *)
(* to calling this procedure, then that value will be used in constructing *)
(* the Menu structure. Otherwise, the procedure will calculate reasonable  *)
(* values for the size and placement of the Menu. The variable MenuSetting *)
(* can also be modified by the user, although it merely enables & disables *)
(* the Menu in this version of Intuition.                                  *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE AddMenu (MenuBarText : String);

   VAR
      OldMenu : MenuPtr;
         
   BEGIN
   
      IF (CurrentMenu <> NULL) THEN
         OldMenu := CurrentMenu;              (* link new Menu to old Menu *)
         NEW(CurrentMenu);
         OldMenu^.NextMenu := CurrentMenu;
      ELSE
         NEW (CurrentMenu);                   (* first Menu in Menu tree   *)
         FirstMenu := CurrentMenu;
      END; (* IF CurrentMenu *)

      SelectText := NoText;                    (* calculate Menu positions *)
      CalcLeftTopWideHigh (MenuLeft, 0, MenuBarText, SelectText);

      NEW(MenuText);
      MenuText^ := MenuBarText;   
      WITH CurrentMenu^ DO
         LeftEdge  := Left;
         TopEdge   := Top;              (* location and dimensions of Menu *)
         Height    := High;
         Width     := Wide;
         Flags     := MenuSetting;        (* To enable or not to enable... *)
         MenuName  := MenuText;
         NextMenu  := NULL;
         FirstItem := NULL;
      END; (* WITH NewMenu^ *)
      CurrentItem := NULL;
                                                (* left position of next Menu *)
      INC(MenuLeft, Wide+INTEGER(HorPixPerChar));

      ItemLeft    := 0;             (* location of first Item under this Menu *)
      ItemTop     := 0;
      IF (RightJustify) THEN
         ItemWide := Wide;     (* width of Item's select box >= width of Menu *)
      ELSE
         ItemWide := HorPixPerChar;
      END; (* IF RightJustify *)

      ResetGlobals;

   END AddMenu;


(***************************************************************************)
(*                                                                         *)
(*    This procedure adds a new Item under the CurrentMenu. All the Item   *)
(* structures and pointers are properly allocated and linked. The required *)
(* parameters are as follows:                                              *)
(*                                                                         *)
(*    ItemText    - (String) the text to appear in this Item.              *)
(*    CommandKey  - (CHAR) the command-key equivalent for this Item; if    *)
(*                  this is set to the global constant NoKey, then no key  *)
(*                  equivalent will be assigned; otherwise, pressing this  *)
(*                  key and the right Amiga-key will select this Item.     *)
(*    ItemSetting - (ItemFlagSet) the options desired for this Item;       *)
(*                  several commonly-used values for this parameter are    *)
(*                  declared in the definition module.                     *)
(*    Exclusion   - (LONGINT) the other Items in this Menu (CurrentMenu)   *)
(*                  which cannot be selected at the same time as this one; *)
(*                  setting a bit in Exclusion excludes the corresponding  *)
(*                  Item while this Item is chosen.                        *)
(*                                                                         *)
(*    The placement of the Items is determined by the global variables     *)
(* Left, Top, Wide and High. If you assign a value to any of these prior   *)
(* to calling this procedure, then that value will be used in constructing *)
(* the Item structure. Otherwise, the procedure will calculate reasonable  *)
(* values for the size and placement of the Item. Wide and Left are auto-  *)
(* matically adjusted if checkmarks and/or command keys are desired, based *)
(* upon the value of the global flag HiResScreen. Setting the global flag  *)
(* AutoIndent adds the space required for a checkmark to all subsequent    *)
(* Items under the CurrentMenu, regardless of whether or not the Item may  *)
(* be checked. (This is useful for lining up the left edges of the Items   *)
(* when not all of them may be checked.) If AutoIndent is not set, then    *)
(* the space will be added only to Items which may be checked.             *)
(*                                                                         *)
(*    Since the IntuiText procedures in this module are used to create the *)
(* IntuitionText structures for this Item, you may change the global vari- *)
(* ables recognized by those procedures to obtain special effects for your *)
(* Items (e.g., different fonts, styles, colors, etc.).                    *)
(*                                                                         *)
(*    Upon returning from this procedure, the global variable CurrentItem  *)
(* will point to this new Item.                                            *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE AddItem (ItemText    : String;
                      Commandkey  : CHAR;
                      ItemSetting : ItemFlagSet;
                      Exclusion   : LONGINT);

   VAR
      Selectintuitext     : IntuitionTextPtr;
      TextLeft            : INTEGER;
      ChangePreviousItems : BOOLEAN;

   BEGIN

      ItemSetting := ItemSetting + TextFlag;      (* Item must be a string *)
      ChangePreviousItems := FALSE;      (* no reverse-traverse needed yet *)

      LinkItemsOrSubItems (CurrentItem, CurrentMenu^.FirstItem, ItemColumnTop);

      IF (NewItemColumn) THEN 
         MakeNewColumn (ItemLeft, ItemTop, ItemWide);
         ItemColumnTop := CurrentItem;
      END; (* IF NewItemColumn *)

      CalcLeftTopWideHigh (ItemLeft, ItemTop, ItemText, SelectText); 

      AddCheckmarkAndCommandKey (ItemSetting, Commandkey, TextLeft);

      CalcFinalLeftAndWide (ItemLeft, ItemWide, ChangePreviousItems);

      IF (ChangePreviousItems) THEN
         ReverseTraverse (ItemColumnTop, ItemLeft, ItemWide);
      END; (* IF ChangePreviousSubItems *)

      IntuitionizeTexts (ItemText, SelectText, TextLeft, ItemSetting,
                                      Itemintuitext, Selectintuitext);

       WITH CurrentItem^ DO
         LeftEdge      := ItemLeft;    (* LeftEdge & Width must be same as *)
         TopEdge       := Top;         (* values for other items under     *)
         Height        := High;        (* this menu; TopEdge & Height may  *)
         Width         := ItemWide;    (* vary as user wishes;             *)
         Flags         := ItemSetting;             (* Item characteristics *)
         MutualExclude := Exclusion;          (* exclude these other Items *)
         ItemFill      := Itemintuitext;   (* text seen when Item selected *)
         SelectFill    := Selectintuitext;           (* text normally seen *)
         Command       := BYTE(Commandkey);              (* key equivalent *)
         SubItem       := NULL;
      END; (* WITH CurrentItem *)

      INC(ItemTop, High);                   (* top position of next Item   *)

      CurrentSubItem := NULL;
      SubItemTop     := 0;             (* subitem select-box must overlap *)
      SubItemLeft    := Wide-1;        (* item select-box somewhere;      *)
      SubItemWide    := HorPixPerChar; (* ...safety precaution...         *)

      ResetGlobals;

   END AddItem;
      
      
(***************************************************************************)
(*                                                                         *)
(*    This procedure adds a new SubItem under the CurrentItem. All Item    *)
(* structures and pointers are properly allocated and initialized. The     *)
(* procedure is virtually identical to the above routine AddItem, except   *)
(* that the parameters and variables mentioned affect the SubItems under   *)
(* the CurrentItem, rather than the Items under the CurrentMenu.           *)
(*                                                                         *)
(*    Upon returning from this procedure, the global variable CurrentSub-  *)
(* Item will point to this new SubItem.                                    *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE AddSubItem (SubItemText           : String;
                         Commandkey            : CHAR;
                         ItemSetting           : ItemFlagSet;
                         Exclusion             : LONGINT);

   VAR
      Selectintuitext        : IntuitionTextPtr;
      TextLeft               : INTEGER;
      ChangePreviousSubItems : BOOLEAN;

   BEGIN
   
      ItemSetting := ItemSetting + TextFlag;   (* subitem must be a string *)
      ChangePreviousSubItems := FALSE;   (* no reverse-traverse needed yet *)

      LinkItemsOrSubItems (CurrentSubItem, CurrentItem^.SubItem, 
                                           SubItemColumnTop);

      IF (NewItemColumn) THEN
         MakeNewColumn (SubItemLeft, SubItemTop, SubItemWide);
         SubItemColumnTop := CurrentSubItem;
      END; (* IF NewItemColumn *)

      CalcLeftTopWideHigh (SubItemLeft, SubItemTop, SubItemText, SelectText);

      AddCheckmarkAndCommandKey (ItemSetting, Commandkey, TextLeft);

      CalcFinalLeftAndWide (SubItemLeft, SubItemWide, ChangePreviousSubItems);

      IF (ChangePreviousSubItems) THEN
         ReverseTraverse (SubItemColumnTop, SubItemLeft, SubItemWide);
      END; (* IF ChangePreviousSubItems *)

      IntuitionizeTexts (SubItemText, SelectText, TextLeft, ItemSetting,
                                         Itemintuitext, Selectintuitext);
     
      WITH CurrentSubItem^ DO
         LeftEdge      := SubItemLeft;     (* LeftEdge & Width must be the *)
         TopEdge       := Top;             (* same for all subitems under  *)
         Height        := High;            (* this item; TopEdge & Height  *)
         Width         := SubItemWide;     (* may vary as the user desires *)
         Flags         := ItemSetting;          (* SubItem characteristics *)  
         MutualExclude := Exclusion;       (* exclude these other SubItems *)
         ItemFill      := Itemintuitext;(* text seen when SubItem selected *)
         SelectFill    := Selectintuitext;           (* text normally seen *)
         Command       := BYTE(Commandkey);              (* key equivalent *)
         SubItem       := NULL;
      END; (* WITH CurrentSubItem *)

      INC (SubItemTop, High);              (* top position of next SubItem *)

      ResetGlobals;

   END AddSubItem;
      
      
(***************************************************************************)
(*                                                                         *)
(*    This procedure removes a Menu tree from a Window, DISPOSEs of all    *)
(* Menu and Item structures and pointers and then calls InitializeMenuStrip*)
(* to reset the variables used to create the next Menu tree. The only para-*)
(* meter required is WindowPointer, a pointer to the Window from which you *)
(* wish the Menu tree to be removed. If WindowPointer = NULL, then any Menu*)
(* pointed to by the global variable LoneMenuStrip is DISPOSEd of as above;*)
(* This feature is useful if you have several MenuStrips for a Window and  *)
(* you wish to DISPOSE of one that isn't currently attached.               *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE DestroyMenuStrip (WindowPointer : WindowPtr);

   VAR
      thisMenu     : MenuPtr;       (* pointers for traversing the Menus,  *)
      nextMenu     : MenuPtr;       (* Items and SubItems in the MenuStrip *)
      thisItem     : MenuItemPtr;
      nextItem     : MenuItemPtr;
      thisSubItem  : MenuItemPtr;
      nextSubItem  : MenuItemPtr;
         
   BEGIN

      IF (WindowPointer <> NULL) AND (WindowPointer <> NIL) THEN
         ClearMenuStrip (WindowPointer);
         thisMenu := WindowPointer^.MenuStrip;
      ELSE
         IF (LoneMenuStrip <> NULL) AND (LoneMenuStrip <> NIL) THEN
            thisMenu := LoneMenuStrip;
         ELSE
            RETURN;                         (* nothing of which to DISPOSE *)
         END; (* IF LoneMenuStrip *)
      END; (* IF WindowPointer *)

      
      WHILE thisMenu <> NULL DO
         thisItem := thisMenu^.FirstItem;

          WHILE thisItem <> NULL DO
            thisSubItem := thisItem^.SubItem;

            WHILE thisSubItem <> NULL DO
               WITH thisSubItem^ DO
                  nextSubItem   := NextItem;
                  Itemintuitext := IntuitionTextPtr(ItemFill);
                  DestroyIntuiText (Itemintuitext, FALSE);
                  IF (SelectFill <> NULL) THEN
                     Itemintuitext := IntuitionTextPtr(SelectFill);
                     DestroyIntuiText (Itemintuitext, FALSE);
                  END; (* IF SelectFill *)
               END; (* WITH thisSubItem *)
               DISPOSE (thisSubItem);
              thisSubItem := nextSubItem;
            END; (* WHILE thisSubItem^ *)

            WITH thisItem^ DO
               nextItem      := NextItem;
               Itemintuitext := IntuitionTextPtr(ItemFill);
               DestroyIntuiText (Itemintuitext, FALSE);
               IF (SelectFill <> NULL) THEN
                  Itemintuitext := IntuitionTextPtr(SelectFill);
                  DestroyIntuiText (Itemintuitext, FALSE);
               END; (* IF SelectFill *)
            END; (* WITH thisItem^ *)
            DISPOSE (thisItem);
            thisItem := nextItem;
         END; (* WHILE thisItem *)

         nextMenu := thisMenu^.NextMenu;
         MenuText := StringPtr(thisMenu^.MenuName);
         DISPOSE (MenuText);
         DISPOSE (thisMenu);
         thisMenu := nextMenu;
      END; (* WHILE thisMenu *)
      InitializeMenuStrip;
   END DestroyMenuStrip;
 
 
   PROCEDURE LinkItemsOrSubItems (VAR NewLink, FirstLink : MenuItemPtr;
                                  VAR ColumnTop          : MenuItemPtr);

   VAR
      OldLink : MenuItemPtr;

   BEGIN
      IF (NewLink <> NULL) THEN
         OldLink := NewLink;      (* link new (Sub)Item to last (Sub)Item *)
         NEW(NewLink);
         OldLink^.NextItem := NewLink;
      ELSE
         NEW(NewLink);                     (* first (Sub)Item; link it to *)
         FirstLink := NewLink;             (* CurrentMenu or CurrentItem; *)
         ColumnTop := FirstLink;           (* first (Sub)Item in column;  *)
      END; (* IF NewLink *)
      NewLink^.NextItem := NULL;
   END LinkItemsOrSubItems;


   PROCEDURE MakeNewColumn (VAR ItemLeft, ItemTop, ItemWide : INTEGER);

   BEGIN
      ItemTop  := 0;
      ItemLeft := ItemLeft + ItemWide;
      ItemWide := HorPixPerChar;
   END MakeNewColumn;
 
 
   PROCEDURE CalcLeftTopWideHigh (DefaultLeft  : INTEGER;
                                  DefaultTop   : INTEGER;
                                  DefaultText  : String;
                                  SelectText   : String);

   BEGIN
      IF (Left = OutOfBounds) THEN Left := DefaultLeft;     END;
      IF (Top  = OutOfBounds) THEN Top  := DefaultTop;      END;
      IF (High = OutOfBounds) THEN High := VerPixPerChar+2; END;
      IF (Wide = OutOfBounds) THEN 
         Wide := ( Length( DefaultText ) + 1 ) * HorPixPerChar; 
         IF (Compare (SelectText, NoText) <> Equal) THEN
            Wide := Max (Wide, ( Length( SelectText ) + 1 ) * HorPixPerChar );
         END; (* IF Compare *)
      END; (* IF Wide *)
   END CalcLeftTopWideHigh;
 

   PROCEDURE  AddCheckmarkAndCommandKey (VAR ItemSetting : ItemFlagSet;
                                             Commandkey  : CHAR;
                                         VAR TextLeft    : INTEGER);

   BEGIN

      IF (CheckIt IN ItemSetting) OR (AutoIndent) THEN
         IF HiResScreen THEN
            TextLeft := CheckWidth;        (* left edge of IntuitionText   *)
            INC(Wide, CheckWidth);         (* must be placed to right of   *)
         ELSE                              (* checkmark; also, the width   *)
            TextLeft := LowCheckWidth;     (* of the (Sub)Item must be in- *)
            INC(Wide, LowCheckWidth);      (* creased to prevent the Intu- *)
         END; (* IF HiResScreen *)         (* itionText from being clipped;*)
      ELSE
         TextLeft := 0;                      (* left edge of IntuitionText *)
      END; (* IF CheckIt *)                  (* = left edge of (Sub)Item;  *)

      IF (Commandkey <> NoKey) THEN
         INCL (ItemSetting, CommSeq);                (* add space to width *)
         IF HiResScreen THEN                         (* of Item to allow   *)
            INC(Wide, CommWidth + HorPixPerChar);    (* for command key;   *)
         ELSE                                       
            INC(Wide, LowCommWidth + HorPixPerChar);
         END; (* IF HiResScreen *)
      ELSE
         EXCL (ItemSetting, CommSeq);        (* don't want key-equivalent; *)
      END; (* IF CheckIt *)

   END AddCheckmarkAndCommandKey;
 
 
    (* compute left position and width required by (Sub)Item; if either  *)
    (* of these exceeds the corresponding values for previous (Sub)Items *)
    (* under this Menu(Item), then must reverse traverse the MenuStrip;  *)
 
   PROCEDURE CalcFinalLeftAndWide (VAR CurrentLeft     : INTEGER;
                                   VAR CurrentWide     : INTEGER;
                                   VAR ReverseTraverse : BOOLEAN);

   BEGIN
 
      IF (Left < CurrentLeft) THEN
         IF (RightJustify) THEN
            Wide         := Max( Wide, CurrentWide + CurrentLeft - Left );
            CurrentWide  := Wide;
         END; (* IF RightJustify *)
         CurrentLeft     := Left;
         ReverseTraverse := TRUE;
      ELSE
         Left := CurrentLeft;
      END; (* IF Left *)

      IF (Wide > CurrentWide) THEN
         CurrentWide     := Wide;
         ReverseTraverse := TRUE;
      ELSE
         Wide := CurrentWide;
      END; (* IF Wide *)

   END CalcFinalLeftAndWide;


   PROCEDURE ReverseTraverse (StartItem   : MenuItemPtr;
                              NewLeftEdge : INTEGER;
                              NewWidth    : INTEGER);

   VAR
      thisItem : MenuItemPtr;

   BEGIN 
      thisItem := StartItem;
      WHILE (thisItem <> NULL) DO
         WITH thisItem^ DO
            LeftEdge := NewLeftEdge;      (* NewLeftEdge always <= LeftEdge *)
            Width    := NewWidth;         (* NewWidth    always >= Width    *)
            thisItem := NextItem;
         END; (* WITH thisSubItem *)
      END; (* WHILE thisItem *)
   END ReverseTraverse;
 
 
   PROCEDURE IntuitionizeTexts (ItemText, SelectText : String;
                                TextLeft             : INTEGER;
                                VAR ItemSetting      : ItemFlagSet;
                                VAR Itemintuitext    : IntuitionTextPtr;
                                VAR Selectintuitext  : IntuitionTextPtr);
   VAR
      SavedPen : INTEGER;
 
   BEGIN

      SavedPen := FrontTextPen;
 
      FrontTextPen := ItemPen; 
      GetIntuiText (ItemText, TextLeft, 0, Itemintuitext);
  
      IF (Compare (SelectText, NoText) = Equal) THEN
         Selectintuitext := NULL;
      ELSE
         ItemSetting  := ItemSetting - HighFlags;
         FrontTextPen := ItemSelectPen;
         GetIntuiText(SelectText, TextLeft, 0, Selectintuitext);
      END; (* IF Compare *)

      FrontTextPen := SavedPen;
 
   END IntuitionizeTexts; 
 
 
   PROCEDURE ResetGlobals;

   BEGIN

      Left := OutOfBounds;
      Top  := OutOfBounds;           (* flags: calculate reasonable positions *)
      Wide := OutOfBounds;
      High := OutOfBounds;

      SelectText := NoText;       (* default: no alternate text for (Sub)Item *)

      NewItemColumn := FALSE;        (* default: no new column for (Sub)Items *)

   END ResetGlobals; 

 
BEGIN

   InitStringModule;                          (* initialize Strings module *)

   LoneMenuStrip := NULL;

END MenuTools.
