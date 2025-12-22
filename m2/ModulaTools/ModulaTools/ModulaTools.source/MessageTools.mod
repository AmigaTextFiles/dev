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
(*    The source code to MessageTools is in the public domain. You may do     *)
(* with it as you please.                                                     *)
(*                                                                            *)
(******************************************************************************)

IMPLEMENTATION MODULE MessageTools;


FROM Intuition       IMPORT IntuiMessagePtr, WindowPtr, Window, 
                            MenuPtr, MenuItemPtr;
FROM IntuiUtils      IMPORT MenuNum, ItemNum, SubNum;
FROM Menus           IMPORT ItemAddress;
FROM Ports           IMPORT MessagePtr, GetMsg, ReplyMsg;
FROM Storage         IMPORT ALLOCATE, DEALLOCATE;
FROM SYSTEM          IMPORT ADDRESS, NULL;

  
(***************************************************************************)
(*                                                                         *)
(*    This procedure is used to obtain the next IntuiMessage from a Window *)
(* in a quick and efficient manner. The procedure requires one parameter,  *)
(* CurrentWindow, a pointer to the Window which you wish checked. The pro- *)
(* cedure returns IMessage, a pointer to the next IntuiMessage (if any) in *)
(* CurrentWindow's message queue. If a message is found, the procedure re- *)
(* turns a TRUE value; otherwise, it returns a FALSE value and IMessage    *)
(* points to NULL. Additionally, if no message is found, then any message  *)
(* pointed to by IMessage upon input is DISPOSEd of, thus preserving the   *)
(* memory required to monitor IntuiMessages.                               *)
(*                                                                         *)
(*    The IntuiMessage returned by the Intuition procedure GetMsg is quick-*)
(* ly copied and returned to Intuition (via ReplyMsg), thus minimizing the *)
(* number of IntuiMessages which Intuition must allocate. This is of con-  *)
(* siderable importance, since Intuition doesn't deallocate IntuiMessages  *)
(* once allocated (unless Intuition is reinitialized).                     *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE GotMessage (VAR IMessage  : IntuiMessagePtr;
                         CurrentWindow : WindowPtr)     : BOOLEAN;

   VAR
      IMsg : IntuiMessagePtr;
      
   BEGIN

      IF (IMessage = NIL) THEN IMessage := NULL; END;

      IMsg := GetMsg (CurrentWindow^.UserPort);             (* get message *)

      IF (IMsg <> NULL) THEN
         IF (IMessage = NULL) THEN NEW(IMessage); END;
         IMessage^ := IMsg^;                            (* copy message &  *)
         ReplyMsg (MessagePtr(IMsg));                   (* return original *)
         RETURN TRUE;
      ELSE
         IF (IMessage <> NULL) THEN
            DISPOSE(IMessage);                         (* DISPOSE of old   *)
            IMessage := NULL;                          (* messages, if any *)
         END; (* IF IMessage *)
         RETURN FALSE;
      END; (* IF IMsg *)
   END GotMessage;


(***************************************************************************)
(*                                                                         *)
(*    This procedure identifies the MenuItem which a user chooses and      *)
(* returns a pointer to that Item. The parameters required for input are   *)
(* as follows:                                                             *)
(*                                                                         *)
(*    MenuSelection - (CARDINAL) either the Code field of an IntuiMessage  *)
(*                    (if Class = MenuPick) or the NextSelect field of a   *)
(*                    MenuItem (if several MenuItems are drag selected);   *)
(*    FirstMenu     - (MenuPtr) a pointer to the FIRST Menu in the Menu    *)
(*                    tree from which the selection is made.               *)
(*                                                                         *)
(*    The procedure returns the ChoiceType-structure MenuChoice with the   *)
(* following fields set:                                                   *)
(*                                                                         *)
(*    MenuChosen    - (CARDINAL) the Menu containing the (Sub)Item chosen; *)
(*    ItemChosen    - (CARDINAL) the Item chosen or containing the chosen  *)
(*                    SubItem;                                             *)
(*    SubItemChosen - (CARDINAL) the chosen SubItem, if any;               *)
(*    ChoicePointer - (MenuItemPtr) a pointer to the chosen (Sub)Item.     *)
(*                                                                         *)
(*    If no SubItem is chosen, then SubItemChosen will equal NoSub; if no  *)
(* Item is chosen, then ItemChosen will equal NoSub and MenuChosen will    *)
(* equal NoMenu. NoSub, NoItem and NoMenu can be found in the Intuition    *)
(* definition module. ChoicePointer will equal NULL if no choice is made.  *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE GetMenuChoice  (MenuSelection  : CARDINAL;
                             FirstMenu      : MenuPtr;
                             VAR MenuChoice : ChoiceType);

   VAR
      ChoiceAddress : ADDRESS;
      
   BEGIN
      WITH MenuChoice DO
         MenuChosen    := MenuNum (MenuSelection);
         ItemChosen    := ItemNum (MenuSelection);
         SubItemChosen := SubNum  (MenuSelection);
         ChoiceAddress := ItemAddress (FirstMenu^, MenuSelection);
         ChoicePointer := MenuItemPtr (ChoiceAddress);
      END; (* WITH MenuChoice *)
   END GetMenuChoice;
   
   
BEGIN
END MessageTools.
