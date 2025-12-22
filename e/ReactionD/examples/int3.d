// Simple example of integer buttons V0.11 © by DMX 2001
OPT OPTIMIZE=3,LINK='amiga.lib'

MODULE 'exec','exec/memory','dos/dos','dos/dosextens','exec/lists',
       'exec/nodes','intuition','graphics','intuition/intuition',
       'intuition/gadgetclass','intuition/imageclass',
       'intuition/intuitionbase','intuition/classusr',
       'intuition/gadgetclass','intuition/cghooks','intuition/icclass',
       'intuition/classes','intuition/sghooks','graphics/gfxbase',
       'graphics/text','graphics/gfxmacros','utility/tagitem','utility/hooks'

MODULE 'window','classes/window','layout','integer','label','button','bevel',
       'gadgets/layout', 'reaction/reaction', 'reaction/reaction_macros','reaction/reaction_class'

DEF LayoutBase:PTR TO ClassLibrary
DEF WindowBase:PTR TO ClassLibrary
DEF IntegerBase:PTR TO ClassLibrary
DEF ButtonBase:PTR TO ClassLibrary
DEF LabelBase:PTR TO ClassLibrary
DEF BevelBase:PTR TO ClassLibrary

ENUM GID_MAIN=0, GID_LAYER1, GID_INTEGER1, GID_INTEGER2, GID_DOWN, GID_UP, GID_QUIT, GID_LAST
ENUM WID_MAIN=0, WID_LAST
ENUM OID_MAIN=0, OID_LAST
//ULONG DoMethod( Object *obj, ULONG methodID, ... ); // c style
LPROC DoMethod(obj:PTR TO _Object,methodid:LONG,message=NIL:LIST OF LONG)(ULONG)

PROC main()(INT)
  DEF AppPort:PTR TO MsgPort
  DEF windows[WID_LAST]:PTR TO Window
  DEF gadgets[GID_LAST]:PTR TO Gadget
  DEF objects[OID_LAST]:PTR TO Object
  OpenAll()
  IF (AppPort := CreateMsgPort())
//    PrintF('AppPort = 0x\z\h[8]\n', AppPort) // Debug
    objects[OID_MAIN]:=WindowObject,
      WA_ScreenTitle, 'Reaction Example V0.11 by DMX © 2001',
      WA_Title, 'Reaction Integer Example',
      WA_Activate, TRUE,
      WA_DepthGadget, TRUE,
      WA_DragBar, TRUE,
      WA_CloseGadget, TRUE,
      WA_SizeGadget, TRUE,
      WA_RMBTrap, TRUE,
      WA_AutoAdjust, TRUE,
      WA_IDCMP, IDCMP_GADGETDOWN | IDCMP_GADGETUP | IDCMP_GADGETHELP | IDCMP_MENUPICK | IDCMP_MENUHELP | IDCMP_CLOSEWINDOW | IDCMP_ACTIVEWINDOW | IDCMP_INACTIVEWINDOW | IDCMP_RAWKEY | IDCMP_VANILLAKEY | IDCMP_MOUSEBUTTONS | IDCMP_MOUSEMOVE | IDCMP_NEWSIZE | IDCMP_CHANGEWINDOW | IDCMP_SIZEVERIFY | IDCMP_REFRESHWINDOW | IDCMP_INTUITICKS,
      WINDOW_GadgetHelp, TRUE,
      WINDOW_IconifyGadget, TRUE,
      WINDOW_IconTitle, 'Integer',
      WINDOW_AppPort, AppPort,
      WINDOW_Position, WPOS_CENTERSCREEN,
      WINDOW_ParentGroup, gadgets[GID_MAIN] := VGroupObject,
        LAYOUT_SpaceOuter, TRUE,
        LAYOUT_DeferLayout, TRUE,

        LAYOUT_AddChild, gadgets[GID_LAYER1] := LayoutObject,
        GA_ID, GID_LAYER1,
        GA_RelVerify, TRUE,
        GA_GadgetHelp, TRUE,
        LAYOUT_Label, 'IntegerX',
        LAYOUT_Orientation, 1,
        LAYOUT_LeftSpacing, 1,
        LAYOUT_TopSpacing, 1,
        LAYOUT_BottomSpacing, 1,
        LAYOUT_RightSpacing, 1,
        LAYOUT_HorizAlignment, LALIGN_LEFT,
        LAYOUT_VertAlignment, LALIGN_TOP,
        LAYOUT_LabelPlace, BVJ_TOP_CENTER,
        LAYOUT_BevelState, IDS_NORMAL,
        LAYOUT_BevelStyle, 2,
        LAYOUT_ShrinkWrap, TRUE,

          LAYOUT_AddChild, gadgets[GID_INTEGER1] := IntegerObject,
            GA_ID, GID_INTEGER1,
            GA_RelVerify, TRUE,
            GA_GadgetHelp, TRUE,
            GA_TabCycle, TRUE,
            INTEGER_Number, 0,
            INTEGER_MaxChars, 10,
            INTEGER_Minimum, -32,
            INTEGER_Maximum, 32,
            INTEGER_Arrows, TRUE,
          IntegerEnd,
          CHILD_NominalSize, TRUE,
          CHILD_Label, LabelObject, LABEL_Text, 'Integer _1', LabelEnd,

          LAYOUT_AddChild, gadgets[GID_INTEGER2] := IntegerObject,
            GA_ID, GID_INTEGER2,
            GA_RelVerify, TRUE,
            GA_GadgetHelp, TRUE,
            GA_TabCycle, TRUE,
            INTEGER_Number, 0,
            INTEGER_MaxChars, 10,
            INTEGER_Minimum, -100,
            INTEGER_Maximum, 100,
            INTEGER_Arrows, FALSE,
          IntegerEnd,
          CHILD_Label, LabelObject, LABEL_Text, 'Integer _2', LabelEnd,

          LAYOUT_AddChild, ButtonObject,
            GA_ID, GID_QUIT,
            GA_RelVerify, TRUE,
            GA_Text,'_Quit',
          ButtonEnd,
          CHILD_WeightedHeight, 0,
        LayoutEnd,
      EndGroup,
    EndWindow
    IF (objects[OID_MAIN])
      IF (windows[WID_MAIN]:=RA_OpenWindow(objects[OID_MAIN]))
        DEFUL wait,signal,app=(1 << AppPort.SigBit),done=0,result
        DEFUW code
        GetAttr(WINDOW_SigMask, objects[OID_MAIN], &signal)
        ActivateLayoutGadget( gadgets[GID_MAIN], windows[WID_MAIN], NIL, gadgets[GID_INTEGER1])
        WHILEN done
          wait := Wait(signal | SIGBREAKF_CTRL_C | app)
          IF (wait & SIGBREAKF_CTRL_C)
            done := TRUE
          ELSE
            WHILEN (result := RA_HandleInput(objects[OID_MAIN], &code)) = WMHI_LASTMSG
              SELECT (result & WMHI_CLASSMASK)
                CASE WMHI_CLOSEWINDOW
                  windows[WID_MAIN] := NIL
                  done := TRUE
                CASE WMHI_GADGETUP
                  SELECT (result & WMHI_GADGETMASK)
                    CASE GID_QUIT
                      done := TRUE
                  ENDSELECT
                CASE WMHI_ICONIFY
                  RA_Iconify(objects[OID_MAIN])
                  windows[WID_MAIN] := NIL
                CASE WMHI_UNICONIFY
                  windows[WID_MAIN] := RA_OpenWindow(objects[OID_MAIN])
                  IF (windows[WID_MAIN])
                    GetAttr(WINDOW_SigMask, objects[OID_MAIN], &signal)
                  ELSE
                    done := TRUE
                  ENDIF
              ENDSELECT
            ENDWHILE
          ENDIF
        ENDWHILE
      ELSE
        PrintF('Can''t RA_OpenWindow()\n') // Debug
      ENDIF
      DisposeObject(objects[OID_MAIN])
    ELSE
      PrintF('Can''t find objects[]\n') // Debug
//      PrintF('Objects[] = 0x\z\h[8]\n', objects) // Debug
    ENDIF
    DeleteMsgPort(AppPort)
  ELSE
    PrintF('Can''t create MsgPort\n') // Debug
  ENDIF
  CloseAll(0)
ENDPROC

PROC OpenAll()
  IFN (WindowBase := OpenLibrary('window.class', 44)); PrintF('Can''t open window.class\n'); CloseAll(10); ENDIF
  IFN (BevelBase := OpenLibrary('images/bevel.image', 44)); PrintF('Can''t open bevel.image\n'); CloseAll(11); ENDIF
  IFN (LayoutBase := OpenLibrary('layout.gadget', 44)); PrintF('Can''t open layout.gadget\n'); CloseAll(12); ENDIF
  IFN (IntegerBase := OpenLibrary('gadgets/integer.gadget', 44)); PrintF('Can''t open integer.gadget\n'); CloseAll(13); ENDIF
  IFN (ButtonBase := OpenLibrary('gadgets/button.gadget', 44)); PrintF('Can''t open button.gadget\n'); CloseAll(15); ENDIF
  IFN (LabelBase := OpenLibrary('images/label.image', 44)); PrintF('Can''t open label.image\n'); CloseAll(16); ENDIF
ENDPROC

PROC CloseAll(number:INT)
  IF WindowBase; CloseLibrary(WindowBase); ENDIF
  IF BevelBase; CloseLibrary(BevelBase); ENDIF
  IF LayoutBase; CloseLibrary(LayoutBase); ENDIF
  IF IntegerBase; CloseLibrary(IntegerBase); ENDIF
  IF ButtonBase; CloseLibrary(ButtonBase); ENDIF
  IF LabelBase; CloseLibrary(LabelBase); ENDIF
  Exit(number)
ENDPROC
