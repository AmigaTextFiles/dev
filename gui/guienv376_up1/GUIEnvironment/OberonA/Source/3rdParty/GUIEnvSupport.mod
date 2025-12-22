(****************************************************************************

$RCSfile: GUIEnvSupport.mod $

$Revision: 1.4 $
    $Date: 1994/09/29 17:50:19 $

    Some needful extra definitions and functions for GUIEnvironment

    Oberon-A Oberon-2 Compiler V5.18 (Release 1.5)

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)

<* STANDARD- *> <* MAIN- *> <*$ LongVars+ *>

MODULE GUIEnvSupport;

IMPORT SYS := SYSTEM,
       E := Exec,
       GT:= GadTools,
       G := Graphics,
       I := Intuition,
       S := Strings,
       U := Utility,

       GUI := GUIEnv;

VAR topazfont : G.TextAttr;

CONST

(* -------------- screen support: displayIDs ----------------------------- *)

  gesHiresPalID  * = G.hiresKey + G.palMonitorID;
  gesHiresID     * = G.hiresKey + G.defaultMonitorID;
  gesLoresPalID  * = G.loresKey + G.palMonitorID;
  gesLoresID     * = G.loresKey + G.defaultMonitorID;


(* -------------------------- tag data support --------------------------- *)

  gegShiftLeft   * = 256*256*256;
  gegShiftTop    * = 256*256;
  gegShiftWidth  * = 256;
  gegShiftHeight * = 1;

  PROCEDURE GADDESC * (left, top, width, height : INTEGER) : LONGINT;
  BEGIN
    RETURN gegShiftLeft * left + gegShiftTop * top + gegShiftWidth * width + gegShiftHeight * height;
  END GADDESC;

  PROCEDURE GADOBJS * (left, top, width, height : INTEGER) : LONGINT;
  BEGIN
    RETURN gegShiftLeft * left + gegShiftTop * top + gegShiftWidth * width + gegShiftHeight * height;
  END GADOBJS;

(* ------------------------------- Font support ------------------------- *)

  PROCEDURE TopazAttr * ():G.TextAttrPtr;
  BEGIN
    topazfont.name := SYS.ADR("topaz.font");
    topazfont.ySize:= 8;
    RETURN SYS.ADR(topazfont);
  END TopazAttr;

(* ---------------------------- Hook functions -------------------------- *)

  PROCEDURE GEUpdateEntryGadgetAHook * (hook   : U.HookPtr;
                                        gadget : I.GadgetPtr;
                                        unused : E.APTR) : LONGINT;
  TYPE LINTPTR = POINTER TO ARRAY 2 OF LONGINT;
  VAR GINFO : GUI.GUIGadgetInfoPtr;
      val   : LINTPTR;
      vas   : E.LSTRPTR;
      info  : I.StringInfoPtr;
  BEGIN
    GINFO := SYS.VAL(GUI.GUIGadgetInfoPtr, gadget^.userData);
    vas := SYS.VAL(E.LSTRPTR, GUI.GetGUIGadget(hook^.data, gadget^.gadgetID, GUI.gegVarAddress));
    IF vas # NIL THEN
      info := SYS.VAL(I.StringInfoPtr, gadget^.specialInfo);
      CASE GINFO^.kind OF
        GT.integerKind : val     := SYS.VAL(LINTPTR, vas);
                         val^[0] := info^.longInt;
                         RETURN 1;
      | GT.stringKind  : vas^[0] := 0X;
                         S.Insert(info^.buffer^, 0, vas^);
                         RETURN 1;
      ELSE
      END;
    END;
    RETURN 0;
  END GEUpdateEntryGadgetAHook;

END GUIEnvSupport.
