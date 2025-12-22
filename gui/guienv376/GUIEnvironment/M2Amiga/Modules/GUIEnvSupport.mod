(****************************************************************************

$RCSfile: GUIEnvSupport.mod $

$Revision: 1.3 $
    $Date: 1994/09/14 17:40:55 $

    Some needful extra definitions and functions for GUIEnvironment

    M2Amiga Modula-2 Compiler V4.3

  Copyright © 1994, Carsten Ziegeler
                    Augustin-Wibbelt-Str.7, 33106 Paderborn, Germany

****************************************************************************)
IMPLEMENTATION MODULE GUIEnvSupport;

  (*$ StackParms:=FALSE Volatile:=FALSE EntryClear:=FALSE LongAlign:=TRUE *)
  (*$ NilChk:=FALSE StackChk:=FALSE ReturnChk:=FALSE RangeChk:=FALSE *)
  (*$ OverflowChk:=FALSE CaseChk:=FALSE *)

  FROM SYSTEM     IMPORT ADR, ADDRESS, CAST;
  FROM GraphicsD  IMPORT TextAttr, TextAttrPtr;
  FROM String     IMPORT Copy;
  FROM UtilityD   IMPORT HookPtr, TagItemPtr;
IMPORT R,
       D : GUIEnvD,
       L : GUIEnvL,
       Gt: GadToolsD,
       Id: IntuitionD;

TYPE STRPTR = POINTER TO ARRAY[0..255] OF CHAR;
     LINTPTR= POINTER TO LONGINT;


  PROCEDURE GADDESC(left, top, width, height : CARDINAL):LONGCARD;
  BEGIN
    RETURN LONGCARD(left)*256*256*256+LONGCARD(top)*256*256+LONGCARD(width)*256+LONGCARD(height);
  END GADDESC;

  PROCEDURE GADOBJS(left, top, width, height : CARDINAL):LONGCARD;
  BEGIN
    RETURN LONGCARD(left)*256*256*256+LONGCARD(top)*256*256+LONGCARD(width)*256+LONGCARD(height);
  END GADOBJS;

  PROCEDURE TopazAttr():TextAttrPtr;
  BEGIN
    RETURN ADR(TextAttr{name: ADR("topaz.font"), ySize: 8});
  END TopazAttr;

  PROCEDURE UpdateEntryGadget(gui : D.GUIInfoPtr;
                              gadget : Id.GadgetPtr) : LONGINT;
  VAR GINFO : D.GUIGadgetInfoPtr;
      VA    : ADDRESS;
  BEGIN
    GINFO := D.GUIGadgetInfoPtr(gadget^.userData);
    VA := CAST(ADDRESS, L.GetGUIGadget(gui, gadget^.gadgetID, D.gegVarAddress));
    IF VA # NIL THEN
      CASE GINFO^.kind OF
        Gt.integerKind : LINTPTR(VA)^ := Id.StringInfoPtr(gadget^.specialInfo)^.longInt;
                         RETURN 1;
      | Gt.stringKind  : Copy(STRPTR(VA)^, STRPTR(Id.StringInfoPtr(gadget^.specialInfo)^.buffer)^);
                         RETURN 1;
      ELSE
      END;
    END;
    RETURN 0;
  END UpdateEntryGadget;

  PROCEDURE GEUpdateEntryGadgetAHook(hook{R.A0} : HookPtr;
                                     gadget{R.A2} : Id.GadgetPtr;
                                     unused{R.A1} : ADDRESS) : LONGINT;
  BEGIN
    RETURN UpdateEntryGadget(hook^.data, gadget);
  END GEUpdateEntryGadgetAHook;

END GUIEnvSupport.
