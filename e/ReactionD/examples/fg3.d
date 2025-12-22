// Simple example of a fuelgauge button V0.31 © by DMX 2001
OPT OPTIMIZE=3,LINK='amiga.lib'

MODULE 'exec','exec/memory','dos/dos','dos/dosextens','exec/lists',
       'exec/nodes','intuition','graphics','intuition/intuition',
       'intuition/gadgetclass','intuition/imageclass',
       'intuition/intuitionbase','intuition/classusr',
       'intuition/gadgetclass','intuition/cghooks','intuition/icclass',
       'intuition/classes','intuition/sghooks','graphics/gfxbase',
       'graphics/text','graphics/gfxmacros','utility/tagitem','utility/hooks'

MODULE 'window','classes/window','layout','fuelgauge','label','button',
       'gadgets/layout', 'reaction/reaction', 'reaction/reaction_macros','reaction/reaction_class'

DEF LayoutBase:PTR TO ClassLibrary
DEF WindowBase:PTR TO ClassLibrary
DEF FuelGaugeBase:PTR TO ClassLibrary
DEF ButtonBase:PTR TO ClassLibrary
DEF LabelBase:PTR TO ClassLibrary

#define FMIN 0
#define FMAX 100

ENUM GID_GAUGE=0, GID_DOWN, GID_UP, GID_QUIT, GID_LAST
ENUM WID_MAIN=0, WID_LAST
ENUM OID_MAIN=0, OID_LAST
//ULONG DoMethod( Object *obj, ULONG methodID, ... ); // c style
LPROC DoMethod(obj:PTR TO _Object,methodid:LONG,message=NIL:LIST OF LONG)(ULONG)

PROC main()(INT)

  DEF AppPort:PTR TO MsgPort
  DEF windows[WID_LAST]:PTR TO Window
  DEF gadgets[GID_LAST]:PTR TO Gadget
  DEF objects[OID_LAST]:PTR TO Object
  DEF i:INT

  OpenAll()
  IF (AppPort := CreateMsgPort())
//    PrintF('AppPort = 0x\z\h[8]\n', AppPort) // Debug
    objects[OID_MAIN]:=WindowObject,
      WA_ScreenTitle, 'Reaction Example V0.31 by DMX © 2001',
      WA_Title, 'Reaction FuelGauge Example',
      WA_Activate, TRUE,
      WA_DepthGadget, TRUE,
      WA_DragBar, TRUE,
      WA_CloseGadget, TRUE,
      WA_SizeGadget, TRUE,
      WINDOW_IconifyGadget, TRUE,
      WINDOW_IconTitle, 'FuelGauge',
      WINDOW_AppPort, AppPort,
      WINDOW_Position, WPOS_CENTERSCREEN,
      WINDOW_ParentGroup, VGroupObject,
        LAYOUT_SpaceOuter, TRUE,
        LAYOUT_DeferLayout, TRUE,

        LAYOUT_AddChild, gadgets[GID_GAUGE] := FuelGaugeObject,
          GA_ID, GID_GAUGE,
          FUELGAUGE_Orientation, FGORIENT_HORIZ,
          FUELGAUGE_Min, FMIN,
          FUELGAUGE_Max, FMAX,
          FUELGAUGE_Level, 0,
          FUELGAUGE_Percent, TRUE,
          FUELGAUGE_TickSize, 5,
          FUELGAUGE_Ticks, 10,
          FUELGAUGE_ShortTicks, TRUE,
        FuelGaugeEnd,

        LAYOUT_AddChild, VGroupObject, 
          LAYOUT_BackFill, NIL,
          LAYOUT_SpaceOuter, TRUE,
          LAYOUT_VertAlignment, LALIGN_CENTER,
          LAYOUT_HorizAlignment, LALIGN_CENTER,
          LAYOUT_BevelStyle, BVS_FIELD,

          LAYOUT_AddImage, LabelObject,
            LABEL_Text, 'The fuelgauge supports optional tickmarks as\n',
            LABEL_Text, 'well as vertical and horizontal orientation.\n',
            LABEL_Text, ' \n',
            LABEL_Text, 'You can set the min/max range, as well as\n',
            LABEL_Text, 'options such as varargs ascii display,\n',
            LABEL_Text, 'percentage display, and custom pen selection.\n',
          LabelEnd,
        LayoutEnd,

        LAYOUT_AddChild, HGroupObject,
          LAYOUT_SpaceOuter, FALSE,
          LAYOUT_EvenSize, TRUE,

          LAYOUT_AddChild, ButtonObject,
            GA_ID, GID_DOWN,
            GA_RelVerify, TRUE,
            GA_Text,'_Down',
          ButtonEnd,

          LAYOUT_AddChild, ButtonObject,
            GA_ID, GID_UP,
            GA_RelVerify, TRUE,
            GA_Text,'_Up',
          ButtonEnd,

          LAYOUT_AddChild, ButtonObject,
            GA_ID, GID_QUIT,
            GA_RelVerify, TRUE,
            GA_Text,'_Quit',
          ButtonEnd,
      LayoutEnd,
      CHILD_WeightedHeight, 0,
      EndGroup,
    EndWindow

    IF (objects[OID_MAIN])
      IF (windows[WID_MAIN]:=RA_OpenWindow(objects[OID_MAIN]))
        DEFUL wait,signal,app=(1 << AppPort.SigBit),done=0,result
        DEFUW code

        GetAttr(WINDOW_SigMask, objects[OID_MAIN], &signal)
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
                    CASE GID_DOWN
                      SetAttrs(objects[OID_MAIN], WA_BusyPointer, TRUE, TAG_END)
                      FOR i := FMAX DTO FMIN STEP -5
                        SetGadgetAttrs(gadgets[GID_GAUGE], windows[WID_MAIN], NIL, FUELGAUGE_Level, i, TAG_DONE)
                        Delay(3)
                      ENDFOR
                      SetAttrs(objects[OID_MAIN], WA_BusyPointer, FALSE, TAG_END)
                    CASE GID_UP
                      SetAttrs(objects[OID_MAIN], WA_BusyPointer, TRUE, TAG_END)
                      FOR i := FMIN TO FMAX STEP 5
                        SetGadgetAttrs(gadgets[GID_GAUGE], windows[WID_MAIN], NIL, FUELGAUGE_Level, i, TAG_DONE)
                        Delay(3)
                      ENDFOR
                      SetAttrs(objects[OID_MAIN], WA_BusyPointer, FALSE, TAG_END)
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
  IFN (WindowBase := OpenLibrary('window.class', 44))
    PrintF('Can''t open window.class\n')
    CloseAll(10)
  ENDIF
  IFN (LayoutBase := OpenLibrary('layout.gadget', 44))
    PrintF('Can''t open layout.gadget\n')
    CloseAll(11)
  ENDIF
  IFN (FuelGaugeBase := OpenLibrary('gadgets/fuelgauge.gadget', 44))
    PrintF('Can''t open fuelgauge.gadget\n')
    CloseAll(12)
  ENDIF
  IFN (ButtonBase := OpenLibrary('gadgets/button.gadget', 44))
    PrintF('Can''t open button.gadget\n')
    CloseAll(13)
  ENDIF
  IFN (LabelBase := OpenLibrary('images/label.image', 44))
    PrintF('Can''t open label.image\n')
    CloseAll(14)
  ENDIF
ENDPROC

PROC CloseAll(number:INT)
  IF WindowBase
    CloseLibrary(WindowBase)
  ENDIF
  IF LayoutBase
    CloseLibrary(LayoutBase)
  ENDIF
  IF FuelGaugeBase
    CloseLibrary(FuelGaugeBase)
  ENDIF
  IF ButtonBase
    CloseLibrary(ButtonBase)
  ENDIF
  IF LabelBase
    CloseLibrary(LabelBase)
  ENDIF
  Exit(number)
ENDPROC
