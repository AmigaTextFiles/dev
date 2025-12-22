MODULE 'utility/tagitem',
       'intuition/intuition'
MODULE 'gtlayout',
       'gadtools',
       'libraries/gtlayout',
       'libraries/gadtools'

DEF	handle:PTR TO LayoutHandle,
		win:PTR TO Window,
		gad,
		GadToolsBase,
		GTLayoutBase

PROC main()
  DEF msg:PTR TO IntuiMessage,
      msgqualifier,
      msgclass,
      msgcode,
      msggadget:PTR TO Gadget,
      done=FALSE

  IF (GadToolsBase:=OpenLibrary('gadtools.library',0))
    IF (GTLayoutBase:=OpenLibrary('gtlayout.library',0))

      IF (handle:=LT_CreateHandleTags(NIL,LH_AutoActivate,FALSE,TAG_DONE))

        LT_New(handle,
          LA_Type,VERTICAL_KIND,
          LA_LabelText,'Main Group',TAG_DONE)

          LT_New(handle,
            LA_Type,BUTTON_KIND,
            LA_LabelText,'A Button',
            LA_ID,11,TAG_DONE)

          LT_New(handle,LA_Type,XBAR_KIND,TAG_DONE)

          LT_New(handle,
            LA_Type,BUTTON_KIND,
            LA_LabelText,'Another Button',
            LA_ID,22,TAG_DONE)

        LT_New(handle,LA_Type,END_KIND)

        IF (win:=LT_Build(handle,
            LAWN_Title,'Window Title',
            LAWN_IDCMP,IDCMP_CLOSEWINDOW,
            WA_CloseGadget,TRUE,
            WA_Flags,WFLG_DRAGBAR,TAG_DONE))

          WHILE done=FALSE
            WaitPort(win.UserPort)
            WHILE (msg:=GT_GetIMsg(win.UserPort))
              msgclass:=msg.Class
              msgcode:=msg.Code
              msgqualifier:=msg.Qualifier
              msggadget:=msg.IAddress
              GT_ReplyIMsg(msg)

              LT_HandleInput(handle,msgqualifier,&msgclass,&msgcode,&msggadget)
              SELECT msgclass
              CASE IDCMP_CLOSEWINDOW
                done:=TRUE
              CASE IDCMP_GADGETUP
                IF msgclass=IDCMP_GADGETUP
                  gad:=msggadget.GadgetID
                  SELECT gad
                  CASE 11
                    PrintF('First Gadget\n')
                  CASE 22
                    PrintF('Second Gadget\n')
                  ENDSELECT
                ENDIF
              ENDSELECT
            ENDWHILE
          ENDWHILE
        ENDIF
        LT_DeleteHandle(handle)
      ENDIF
      CloseLibrary(GTLayoutBase)
    ENDIF
    CloseLibrary(GadToolsBase)
  ENDIF
ENDPROC
