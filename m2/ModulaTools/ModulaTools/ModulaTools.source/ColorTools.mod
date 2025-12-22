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
(*    The source code to ColorTools is in the public domain. You may do with  *)
(* it as you please.                                                          *)
(*                                                                            *)
(******************************************************************************)
 
 
IMPLEMENTATION MODULE ColorTools;
 
FROM Colors    IMPORT LoadRGB4;
FROM Intuition IMPORT ScreenPtr;
FROM SYSTEM    IMPORT ADR, NULL; 
 
 
(***************************************************************************)
(*                                                                         *)
(*    This procedure allows you to easily change the colors in a Screen.   *)
(* The only parameter required is CurrentScreen, a pointer to the Screen   *)
(* you wish to change. The global array ScreenColors contains the colors   *)
(* which will be loaded into the Screen's ViewPort. Thus, you may change   *)
(* any of the values in ScreenColors prior to calling this procedure to    *)
(* obtain a custom colortable for your Screen.                             *)
(*    In case it isn't obvious, you must first open both the Intuition and *)
(* the Graphics libraries before calling SetScreenColors. Alternatively, a *)
(* call to OpenGraphics (in WindowTools) will enable you to successfully   *)
(* call SetScreenColors.                                                   *)
(*                                                                         *)
(***************************************************************************)
 
   PROCEDURE SetScreenColors (CurrentScreen : ScreenPtr);
               
   BEGIN
      IF (CurrentScreen <> NULL) AND (CurrentScreen <> NIL) THEN
         LoadRGB4(ADR(CurrentScreen^.VPort), ADR(ScreenColors), MaxColors);
      END; (* IF CurrentScreen *)
   END SetScreenColors;
 
 
BEGIN
   ScreenColors[ 0] := Black;
   ScreenColors[ 1] := LimeGreen;
   ScreenColors[ 2] := White;
   ScreenColors[ 3] := Red;
   ScreenColors[ 4] := Violet;
   ScreenColors[ 5] := LemonYellow;
   ScreenColors[ 6] := ForestGreen;
   ScreenColors[ 7] := BrightBlue;
   ScreenColors[ 8] := DarkGreen;
   ScreenColors[ 9] := Brown;
   ScreenColors[10] := Purple;
   ScreenColors[11] := Orange;
   ScreenColors[12] := MediumGrey;
   ScreenColors[13] := Aqua;
   ScreenColors[14] := Tan;
   ScreenColors[15] := Magenta;
   ScreenColors[16] := Pink;
   ScreenColors[17] := LightAqua;
   ScreenColors[18] := CadmiumYellow;
   ScreenColors[19] := Green;
   ScreenColors[20] := DarkBrown;
   ScreenColors[21] := LightGrey;
   ScreenColors[22] := GoldenOrange;
   ScreenColors[23] := DarkBlue;
   ScreenColors[24] := LightGreen;
   ScreenColors[25] := BrickRed;
   ScreenColors[26] := SkyBlue;
   ScreenColors[27] := BlueGreen;
   ScreenColors[28] := LightBlue;
   ScreenColors[29] := RedOrange;
   ScreenColors[30] := Blue;
   ScreenColors[31] := Black;
END ColorTools.
