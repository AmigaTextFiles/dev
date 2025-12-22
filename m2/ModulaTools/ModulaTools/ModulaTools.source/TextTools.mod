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
(*    The source code to TextTools is in the public domain. You may do with   *)
(* it as you please.                                                          *)
(*                                                                            *)
(******************************************************************************)

IMPLEMENTATION MODULE TextTools;


FROM GraphicsLibrary IMPORT DrawingModes, DrawingModeSet;
FROM Intuition       IMPORT IntuitionText, IntuitionTextPtr;
FROM Storage         IMPORT ALLOCATE, DEALLOCATE;
FROM Strings         IMPORT InitStringModule, String;
FROM SYSTEM          IMPORT ADDRESS, BYTE, NULL;

TYPE
   StringPtr = POINTER TO String;


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
(*    This procedure creates an IntuitionText structure from a supplied    *)
(* character string. The location (or offset, if for Menus & gadgets) must *)
(* must also be supplied. The user has access to each of the fields of the *)
(* IntuitionText structure via the corresponding variables listed in the   *)
(* definition module. Or, she/he may ignore the variables, since they all  *)
(* have default values).                                                   *)
(*                                                                         *)
(*    The following parameters are required as inputs:                     *)
(*                                                                         *)
(*    TextItem - (String) the character string containing the desired text *)
(*    TextLeft - (INTEGER) the leftmost pixel-location of the text         *)
(*    TextTop  - (INTEGER) the topmost  pixel-location of the text         *)
(*                                                                         *)
(*    Upon return to the calling routine, the variable IntuiText will      *)
(* point to the need IntuitionText structure.                              *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE GetIntuiText  (TextItem          : String;
                            TextLeft, TextTop : INTEGER;
                            VAR IntuiText     : IntuitionTextPtr);
   
   VAR
      TextString : StringPtr;
      
   BEGIN
      NEW(IntuiText);
      NEW(TextString);
      TextString^ := TextItem;
      WITH IntuiText^ DO 
         FrontPen  := BYTE(FrontTextPen);         (* pens chosen from the  *)
         BackPen   := BYTE(BackTextPen);          (* Screen's color table; *)
         DrawMode  := BYTE(TextDrawMode);
         LeftEdge  := TextLeft;
         TopEdge   := TextTop;
         ITextFont := ADDRESS(CurrentFont);
         IText     := TextString;
         NextText  := NULL;                  
      END; (* WITH IntuiText *)
      
      IF (LastText <> NULL) THEN
         LastText^.NextText := IntuiText;
         LastText := NULL;
      END; (* IF LastText *)
      
   END GetIntuiText;


(***************************************************************************)
(*                                                                         *)
(*    This procedure DISPOSEs of an IntuitionText structure without leav-  *)
(* ing dangling pointers. All of the pointers are DISPOSEd of, followed by *)
(* the IntuitionText itself.                                               *)
(*    The only parameter required is the variable IntuiText, which points  *)
(* to the IntuitionText structure to be DISPOSEd.                          *)
(*                                                                         *)
(***************************************************************************)

   PROCEDURE DestroyIntuiText (VAR IntuiText  : IntuitionTextPtr;
                               DestroyAllText : BOOLEAN);
 
   VAR
      NextIntuiText : IntuitionTextPtr;
      dummystring   : StringPtr;


      PROCEDURE DisposeOfIntuiText;

      BEGIN
         WITH IntuiText^ DO
            NextIntuiText := NextText;
            IF (IText <> NULL) THEN          (* ok to DISPOSE of NIL pointer; *)
               dummystring := StringPtr(IText);
               DISPOSE (dummystring);
            END;
         END; (* WITH IntuiText^ *)

         DISPOSE (IntuiText);
         IntuiText := NextIntuiText;

         IF (IntuiText = NIL) THEN IntuiText := NULL; END;

      END DisposeOfIntuiText;

      
   BEGIN
 
      IF (IntuiText = NIL)  THEN IntuiText := NULL; END;
      IF (IntuiText = NULL) THEN RETURN END;

      IF (DestroyAllText) THEN
         REPEAT                            (* destroy given text and any text *)
            DisposeOfIntuiText;            (* which may be linked to it;      *)
         UNTIL (IntuiText = NULL);
      ELSE
         DisposeOfIntuiText;               (* destroy only given text & return*)
      END; (* IF DestroyAllText *)         (* next text in linked list;       *)
   END DestroyIntuiText;   


BEGIN

   InitStringModule;                          (* initialize Strings module *)

                  (* initialize variables used in IntuitionText procedures *)
   FrontTextPen := 0;
   BackTextPen  := 1;
   CurrentFont  := NULL;
   TextDrawMode := DrawingModeSet{Jam2};
   LastText     := NULL;
                                 
END TextTools.
