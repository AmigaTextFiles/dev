
-> Example on how to use Textfield.gadget in Amiga E
-> by Daniel Adolfsson <m-29431@mailbox.swipnet.se>
-> based on TestClass.c from the TextField v3.1 archive

OPT PREPROCESS

MODULE  'exec/ports',
        'exec/memory',
        'dos/dos',
        'intuition/intuition',
        'intuition/screens',
        'intuition/classes',
        'intuition/classusr',
        'intuition/imageclass',
        'intuition/gadgetclass',
        'graphics/rastport',
        'graphics/text',
        'utility/tagitem',

        'textfield',
        'gadgets/textfield'

PROC main()
  DEF textfieldclass
  DEF win:PTR TO window,win_sig
  DEF drawinfo:PTR TO drawinfo
  DEF pens:PTR TO LONG,yfsize
  DEF tf_itext:intuitext
  DEF tf_obj
  DEF going=TRUE,rec_sigs,msg:PTR TO intuimessage,class

  DEF textlen,my_buff:PTR TO CHAR,text_buff

  IF textfieldbase:=OpenLibrary(TEXTFIELD_NAME,TEXTFIELD_VER)
    textfieldclass:=Textfield_GetClass()
    IF win:=OpenWindowTagList(0,[WA_FLAGS,WFLG_DEPTHGADGET OR
                                          WFLG_DRAGBAR OR
                                          WFLG_CLOSEGADGET OR
                                          WFLG_SIZEGADGET OR
                                          WFLG_SIZEBBOTTOM OR
                                          WFLG_SIZEBRIGHT,
                                 WA_ACTIVATE,TRUE,
                                 WA_IDCMP,IDCMP_CLOSEWINDOW,
                                 WA_TOP,50,
                                 WA_LEFT,100,
                                 WA_WIDTH,400,
                                 WA_HEIGHT,100,
                                 WA_NOCAREREFRESH,TRUE,
                                 WA_NEWLOOKMENUS,TRUE,
                                 WA_TITLE,'Testing textfield.gadget',
                                 TAG_END])
      win_sig:=Shl(1,win.userport.sigbit)
      IF drawinfo:=GetScreenDrawInfo(win.wscreen)

        pens:=drawinfo.pens             -> store ptr to array of pens
        yfsize:=win.rport.font.ysize    -> store height of font

        WindowLimits(win,160,win.bordertop+win.borderbottom+yfsize+46,-1,-1)

        tf_itext.frontpen:=pens[SHADOWPEN]     -> fill out the intuitext struct
        tf_itext.backpen:=pens[BACKGROUNDPEN]
        tf_itext.drawmode:=RP_JAM1
        tf_itext.topedge:=-yfsize
        tf_itext.leftedge:=0
        tf_itext.itext:='Gadget label:'
        tf_itext.itextfont:=0
        tf_itext.nexttext:=0

        tf_obj:=NewObjectA(textfieldclass,0,    -> create the (gadget) object
                           [GA_ID,1,
                            GA_TOP,       win.bordertop+yfsize,
                            GA_LEFT,      win.borderleft,
                            GA_RELWIDTH,  -(win.borderleft+win.borderright),
                            GA_RELHEIGHT, -(win.bordertop+win.borderbottom+yfsize),
                            GA_INTUITEXT, tf_itext,
                            TEXTFIELD_TEXT,           'Blah blah-blah\nBlah-blah-blah Blah-blah Blah\nBlah\n',
                            TEXTFIELD_BLINKRATE,      500000,
                            TEXTFIELD_BLOCKCURSOR,    TRUE,
->                          TEXTFIELD_MAXSIZE,        1000,
                            TEXTFIELD_BORDER,         TEXTFIELD_BORDER_DOUBLEBEVEL,
                            TEXTFIELD_TABSPACES,      4,
                            TEXTFIELD_NONPRINTCHARS,  FALSE,
                            TAG_END])

        IF tf_obj<>0    -> object created ok?

          AddGList(win,tf_obj,-1,-1,0)          -> attach to gadgetlist
          RefreshGList(tf_obj,win,0,-1)         -> refresh list

          ActivateGadget(tf_obj,win,0)          -> activate textfield gadget

          WHILE going=TRUE                                -> main loop...
            rec_sigs:=Wait(win_sig OR SIGBREAKF_CTRL_C)
            IF (rec_sigs AND win_sig)
              WHILE msg:=GetMsg(win.userport)
                class:=msg.class
                ReplyMsg(msg)
                SELECT class
                  CASE IDCMP_CLOSEWINDOW;going:=FALSE
                ENDSELECT
              ENDWHILE
            ENDIF
            IF (rec_sigs AND SIGBREAKF_CTRL_C)
              going:=FALSE
            ENDIF
          ENDWHILE

          -> gadget must be READONLY if we gonna get attributes from it
          SetGadgetAttrsA(tf_obj,win,0,[TEXTFIELD_READONLY,TRUE,TAG_END])

          IF GetAttr(TEXTFIELD_SIZE,tf_obj,{textlen})
            IF my_buff:=AllocMem(textlen+1,MEMF_ANY)
              my_buff[textlen]:=0
              IF GetAttr(TEXTFIELD_TEXT,tf_obj,{text_buff})
                CopyMem(text_buff,my_buff,textlen)
                WriteF('\s\n',my_buff)
              ENDIF
              FreeMem(my_buff,textlen+1)
            ENDIF
          ENDIF

          -> restore...
          SetGadgetAttrsA(tf_obj,win,0,[TEXTFIELD_READONLY,FALSE,TAG_END])

          RemoveGList(win,tf_obj,-1)          -> remove from gadgetlist

        ELSE
          WriteF('One or more NewObjectA() failed\n')
        ENDIF

        DisposeObject(tf_obj)       -> get rid of (gadget) object
                                    -> (tf_obj=0 is ok for DisposeObject()!)

        FreeScreenDrawInfo(win.wscreen,drawinfo)
      ELSE
        WriteF('Could not get drawinfo\n')
      ENDIF
      CloseWindow(win)
    ELSE
      WriteF('Could not open window\n')
    ENDIF
  ELSE
    WriteF('Could not open '+TEXTFIELD_NAME+'\n')
  ENDIF
ENDPROC
