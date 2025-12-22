/*
** gttest1.e adapted to E By  Aris Basic
**
** Original source its from gtlayout.doc by Olaf 'Olsen' Barthel
**
** This is test program for use of gtlayout.library (by Olaf 'Olsen' Barthel [ I think so ])
** with AmigaE by Wouter van Oortmerssen
**
** USE THIS THAT`S PD
**
*/

MODULE 'gtlayout','gadtools','libraries/gtlayout','libraries/gadtools'
MODULE 'utility/tagitem','intuition/intuition'

/* define some program variables.handle must not be defined like PTR TO layouthandle
   because we don`t use anything from these structure(object) */

DEF handle:PTR TO layouthandle,win:PTR TO window,gad

PROC main()

DEF msg:PTR TO intuimessage,msgqualifier,msgclass,msgcode,msggadget:PTR TO gadget,done=FALSE

IF (gadtoolsbase:=OpenLibrary('gadtools.library',0))
   IF (gtlayoutbase:=OpenLibrary('gtlayout.library',0))
/* create new object handle */
      IF (handle:=Lt_CreateHandleTagList(NIL,[LH_AUTOACTIVATE,FALSE,TAG_DONE]))
/* add Group to handle ( Handle Must have min. one group ).Group is like one VERTICAL group definied */
         Lt_NewA(handle,[LA_TYPE,VERTICAL_KIND,LA_LABELTEXT,'Main Group',TAG_DONE])
/* add Button gadget to the group  */
            Lt_NewA(handle,[LA_TYPE,BUTTON_KIND,LA_LABELTEXT,'A Button',LA_ID,11,TAG_DONE])
/* add Separator line to the group */
            Lt_NewA(handle,[LA_TYPE,XBAR_KIND,TAG_DONE])
/* add second Button gadget to the group */
            Lt_NewA(handle,[LA_TYPE,BUTTON_KIND,LA_LABELTEXT,'Another Button',LA_ID,22,TAG_DONE])
/* end of group (That was also posibile to do with Lt_EndGroup(handle)) */
            Lt_NewA(handle,[LA_TYPE,END_KIND])
/* build a Window with this gadgets.This funktion is to use in a way of OpenWindowTagList
   WARNING !!! Read gtlayout.doc from Term-43-source.lha Some Tags From ^ can`t be used. */
         IF (win:=Lt_BuildA(handle,[LAWN_TITLE,'Window Title',LAWN_IDCMP,IDCMP_CLOSEWINDOW,WA_CLOSEGADGET,TRUE,WA_FLAGS,WFLG_DRAGBAR,TAG_DONE]))
/* standard wait for IMessage programm structure */
            WHILE done=FALSE
                  WaitPort(win.userport)
                  WHILE (msg:=Gt_GetIMsg(win.userport))
                        msgclass:=msg.class
                        msgcode:=msg.code
                        msgqualifier:=msg.qualifier
                        msggadget:=msg.iaddress
                        Gt_ReplyIMsg(msg)
/* This funktion must be done . These makes that messages are clean from not usable things and
   and does some things alone (like REFRESH) */
                        Lt_HandleInput(handle,msgqualifier,{msgclass},{msgcode},{msggadget})
                        SELECT msgclass
                               CASE IDCMP_CLOSEWINDOW
                                    done:=TRUE
                               CASE IDCMP_GADGETUP
                                    IF msgclass=IDCMP_GADGETUP
                                       gad:=msggadget.gadgetid
                                       SELECT gad
                                              CASE 11
                                                   WriteF('First Gadget\n')
                                              CASE 22
                                                   WriteF('Second Gadget\n')
                                       ENDSELECT
                                    ENDIF
                        ENDSELECT
                  ENDWHILE
            ENDWHILE
/* This Funktion Close the Window and dispose handle */
            Lt_DeleteHandle(handle)
         ENDIF
      ENDIF
   CloseLibrary(gtlayoutbase)
   ENDIF
CloseLibrary(gadtoolsbase)
ENDIF
ENDPROC
