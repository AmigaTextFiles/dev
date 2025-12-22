/*

PPI - Programming Project Interface

Meant to satisfy all the 'would-have-been' users of ESEE.

Written by Vincent Platt - (c) 1994 - All Rights Reserved
Modifying & distributing this source is prohibited.
Source may be modified for own personal use.

This program and its source are freeware and no charge may be
made for this program, its source, or its documentation.

SrcGen used to create original code skeleton.

A modified version of Eformat was used to make things uniform.
(My version makes indents a single space, rather than a tab char.)


*/

OPT OSVERSION=37

MODULE 'gadtools','libraries/gadtools','intuition/intuition',
'intuition/screens', 'intuition/gadgetclass', 'graphics/text',
'Asl', 'libraries/Asl', 'dos/dos'

ENUM NONE, NOCONTEXT, NOGADGET, NOWB, NOVISUAL, OPENGT, NOWINDOW, NOMENUS
ENUM EDIT_BUTTON, COMPILE_BUTTON, ACTION1_BUTTON, ACTION2_BUTTON,
PICK_BUTTON, SAVESETTINGS_BUTTON, EDITOR_STRING, COMPILER_STRING,
ACTION1_STRING, ACTION2_STRING, KILL_CBOX
ENUM EDIT, COMPILE, ACTION1, ACTION2

DEF ppiwnd:PTR TO window, ppiglist, scr:PTR TO screen, visual=NIL,
offx,offy,tattr

/* strings for launch's and files */

DEF pickfile[256]:STRING, compile[256]:STRING, edit[256]:STRING,
action1[256]:STRING, action2[256]:STRING

/* for the checkbox */
DEF checked=TRUE

PROC setupscreen()
 IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN RETURN OPENGT
 IF (scr:=LockPubScreen('Workbench'))=NIL THEN RETURN NOWB
 IF (visual:=GetVisualInfoA(scr,NIL))=NIL THEN RETURN NOVISUAL
 offy:=scr.wbortop+Int(scr.rastport+58)-10
 tattr:=['topaz.font',8,0,0]:textattr
ENDPROC

PROC closedownscreen()
 IF visual THEN FreeVisualInfo(visual)
 IF scr THEN UnlockPubScreen(NIL,scr)
 IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC

PROC openppiwindow()
 DEF g:PTR TO gadget
 IF (g:=CreateContext({ppiglist}))=NIL THEN RETURN NOCONTEXT

 IF (g:=CreateGadgetA(BUTTON_KIND,g,
  [offx+410,offy+22,120,19,'_Edit',tattr,EDIT_BUTTON,16,visual,0]:newgadget,
  [GT_UNDERSCORE,"_",
  NIL]))=NIL THEN RETURN NOGADGET
  IF (g:=CreateGadgetA(BUTTON_KIND,g,
   [offx+410,offy+40,120,19,'_Compile',tattr,COMPILE_BUTTON,16,visual,0]:newgadget,
   [GT_UNDERSCORE,"_",
   NIL]))=NIL THEN RETURN NOGADGET
   IF (g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+410,offy+58,120,19,'Action _1',tattr,ACTION1_BUTTON,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
    NIL]))=NIL THEN RETURN NOGADGET
    IF (g:=CreateGadgetA(BUTTON_KIND,g,
     [offx+410,offy+76,120,19,'Action _2',tattr,ACTION2_BUTTON,16,visual,0]:newgadget,
     [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN RETURN NOGADGET
     IF (g:=CreateGadgetA(BUTTON_KIND,g,
      [offx+410,offy+94,120,19,'_Pick',tattr,PICK_BUTTON,16,visual,0]:newgadget,
      [GT_UNDERSCORE,"_",
      NIL]))=NIL THEN RETURN NOGADGET
      IF (g:=CreateGadgetA(BUTTON_KIND,g,
       [offx+410,offy+112,120,19,'_Save Settings',tattr,SAVESETTINGS_BUTTON,16,visual,0]:newgadget,
       [GT_UNDERSCORE,"_",
       NIL]))=NIL THEN RETURN NOGADGET

       IF (g:=CreateGadgetA(STRING_KIND,g,
        [offx+96,offy+23,224,12,'Editor:',tattr,EDITOR_STRING,1,visual,0]:newgadget,
        [GTST_MAXCHARS,256,GTST_STRING,edit,
        NIL]))=NIL THEN RETURN NOGADGET
        IF (g:=CreateGadgetA(STRING_KIND,g,
         [offx+97,offy+42,224,12,'Compiler:',tattr,COMPILER_STRING,1,visual,0]:newgadget,
         [GTST_MAXCHARS,256,GTST_STRING,compile,
         NIL]))=NIL THEN RETURN NOGADGET
         IF (g:=CreateGadgetA(STRING_KIND,g,
          [offx+97,offy+61,224,12,'Action 1:',tattr,ACTION1_STRING,1,visual,0]:newgadget,
          [GTST_MAXCHARS,256,GTST_STRING,action1,
          NIL]))=NIL THEN RETURN NOGADGET
          IF (g:=CreateGadgetA(STRING_KIND,g,
           [offx+96,offy+80,224,12,'Action 2:',tattr,ACTION2_STRING,1,visual,0]:newgadget,
           [GTST_MAXCHARS,256,GTST_STRING,action2,
           NIL]))=NIL THEN RETURN NOGADGET

           IF (g:=CreateGadgetA(CHECKBOX_KIND,g,
            [offx+170,offy+115,26,11,'Kill Extension For Compiling',tattr,KILL_CBOX,4,visual,0]:newgadget,
            [GTCB_CHECKED,checked,
            NIL]))=NIL THEN RETURN NOGADGET

            IF (ppiwnd:=OpenWindowTagList(NIL,
             [WA_LEFT,0,
             WA_TOP,17,
             WA_WIDTH,offx+579,
             WA_HEIGHT,offy+149,
             WA_IDCMP,IDCMP_GADGETUP+IDCMP_CLOSEWINDOW+IDCMP_VANILLAKEY,
             WA_FLAGS,WFLG_DEPTHGADGET+WFLG_SMART_REFRESH+WFLG_DRAGBAR+WFLG_CLOSEGADGET+WFLG_RMBTRAP,
             WA_TITLE,'Programming Project Interface (PPI) -- (c) 1994 Vincent Platt',
             WA_CUSTOMSCREEN,scr,
             WA_MINWIDTH,67,
             WA_MINHEIGHT,21,
             WA_MAXWIDTH,$23A,
             WA_MAXHEIGHT,145,
             WA_AUTOADJUST,1,
             WA_AUTOADJUST,1,
             WA_GADGETS,ppiglist,
             NIL]))=NIL THEN RETURN NOWINDOW
             Gt_RefreshWindow(ppiwnd,NIL)

ENDPROC

PROC closeppiwindow()
 IF ppiwnd THEN CloseWindow(ppiwnd)
 IF ppiglist THEN FreeGadgets(ppiglist)
ENDPROC

PROC reporterr(er)
 DEF erlist:PTR TO LONG
 IF er
  erlist:=['get context','create gadget','lock wb','get visual infos',
  'open "gadtools.library" v37+','open window','create menus']
  EasyRequestArgs(0,[20,0,0,'Could not \s!','ok'],0,[erlist[er-1]])
 ENDIF
ENDPROC er

PROC request_file()

 DEF req:PTR TO filerequester
 DEF a[2]:STRING

 IF aslbase:=OpenLibrary('asl.library',37)
  IF req:=AllocFileRequest()
   RequestFile(req)

   /* first see if the user bothered to pick a file, if not then get out */
   IF StrCmp(req.file,'',ALL) THEN JUMP getout

   /* copy path name to our full file name string */
   StrCopy(pickfile,req.drawer,ALL)

   /* tack a '/' on to the end of pickfile if req.dir is not empty and
   the last char of req.dir is not ':' */
   IF (StrCmp(req.drawer,'',ALL)=FALSE)
    MidStr(a,req.drawer,StrLen(req.drawer)-1,ALL)
    IF (StrCmp(a,':',ALL)=FALSE)
     StrAdd(pickfile,'/',ALL)
    ENDIF
   ENDIF

   /* then tack the filename on to the end of pickfile */
   StrAdd(pickfile,req.file,ALL)

   getout:
   FreeFileRequest(req)
  ELSE
   WriteF('Could not open filerequester!\n')
  ENDIF
  CloseLibrary(aslbase)
 ELSE
  WriteF('Could not open asl.library!\n')
 ENDIF
ENDPROC


PROC launch(whichone)
 DEF orgstr[256]:STRING
 DEF str[256]:STRING
 DEF x, test[1]:STRING
 DEF oldpickfile[256]:STRING
 StrCopy(str,'',ALL)

 /* this is done so the compile section can mess with the pickfile
 pickfile is restored when everything is done */
 StrCopy(oldpickfile,pickfile,ALL)

 SELECT whichone

  CASE EDIT
   StrCopy(orgstr,edit,ALL)

  CASE COMPILE
   IF checked
    FOR x:= StrLen(pickfile)-1 TO 0 STEP -1
     MidStr(test,pickfile,x,1)
     IF StrCmp(test,'.',ALL)
      StrCopy(pickfile,pickfile,x)
     ENDIF
    ENDFOR
   ENDIF
   StrCopy(orgstr,compile,ALL)

  CASE ACTION1
   StrCopy(orgstr,action1,ALL)

  CASE ACTION2
   StrCopy(orgstr,action2,ALL)

 ENDSELECT

 FOR x:= 0 TO StrLen(orgstr)-1
  MidStr(test,orgstr,x,1)
  IF StrCmp(test,'%',ALL)
   MidStr(test,orgstr,x+1,1)
   IF StrCmp(test,'s',ALL)
    StrAdd(str,pickfile,ALL)
    INC x /* inc to skip the s as well as the % */
    JUMP z /* don't add % and s chars now that they have been handled */
   ELSE
    StrAdd(str,'%',ALL)
   ENDIF
  ENDIF
  StrAdd(str,test,ALL)
  z:
 ENDFOR

 Execute(str,0,0)
 StrCopy(pickfile,oldpickfile,ALL)

ENDPROC


PROC pick()
 request_file()
 TextF(18,140,'Workfile =                                                         ')
 TextF(18,140,'Workfile = \s',pickfile)
ENDPROC

PROC savesettings()
 DEF file

 IF file:= Open('s:PPI.prefs', NEWFILE)
  Fputs(file,'PPI Prefs\n')

  Fputs(file,pickfile)
  Fputs(file,'\n')

  Fputs(file,edit)
  Fputs(file,'\n')

  Fputs(file,compile)
  Fputs(file,'\n')

  Fputs(file,action1)
  Fputs(file,'\n')

  Fputs(file,action2)
  Fputs(file,'\n')

  IF checked
   Fputs(file,'T\n')
  ELSE
   Fputs(file,'F\n')
  ENDIF

  Close(file)
 ENDIF
ENDPROC

PROC loadsettings()
 DEF file
 DEF buf[260]:STRING

 IF file:= Open('s:PPI.prefs', OLDFILE)
  Fgets(file,buf,260)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(pickfile,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(edit,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(compile,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(action1,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(action2,buf,StrLen(buf)-1)

  StrCopy(buf,'',ALL)
  Fgets(file,buf,260)
  StrCopy(buf,buf,StrLen(buf)-1)

  IF StrCmp(buf,'F',ALL)
   checked:=FALSE
  ELSE
   checked:=TRUE
  ENDIF
  Close(file)

 ELSE
  Close(file)
 ENDIF
ENDPROC

PROC main()

 DEF class, code, iaddress, dummy: PTR TO stringinfo, dummy2
 DEF mes: PTR TO intuimessage
 DEF clicked: PTR TO gadget, gadgetid

 loadsettings()

 IF reporterr(setupscreen())=0
  reporterr(openppiwindow())

  stdrast:=ppiwnd.rport
  Colour(1,0)
  TextF(18,140,'Workfile = \s',pickfile)

  LOOP
   class:=FALSE
   REPEAT
    IF mes:=Gt_GetIMsg(ppiwnd.userport)
     class:=mes.class
     code:=mes.code
     iaddress:=mes.iaddress
     Gt_ReplyIMsg(mes)
     IF class=IDCMP_REFRESHWINDOW
      Gt_BeginRefresh(ppiwnd)
      Gt_EndRefresh(ppiwnd,TRUE)
      TextF(18,140,'Workfile =                                                         ')
      TextF(18,140,'Workfile = \s',pickfile)
      class:=FALSE
     ELSEIF ((class<>IDCMP_CLOSEWINDOW) AND (class<>IDCMP_GADGETUP) AND (class<>IDCMP_VANILLAKEY))
      class:=FALSE
     ENDIF
    ELSE
     WaitPort(ppiwnd.userport)
    ENDIF
   UNTIL class

   SELECT class

    CASE IDCMP_CLOSEWINDOW
     BRA x

    CASE IDCMP_VANILLAKEY
     /* here we must check to see if one of our hotkeys were pressed and
     then react appropriately for each case */

     SELECT code

      /* "e" or "E" = Edit Button */
      CASE "e"
       launch(EDIT)
      CASE "E"
       launch(EDIT)

       /* "c" or "C" = Compile Button */
      CASE "c"
       launch(COMPILE)
      CASE "C"
       launch(COMPILE)

       /* "1" = Action1 Button */
      CASE "1"
       launch(ACTION1)

       /* "2" = Action2 Button */
      CASE "2"
       launch(ACTION2)

       /* "p" or "P" = Pick Button */
      CASE "p"
       pick()
      CASE "P"
       pick()

       /* "s" or "S" = SaveSettings Button */
      CASE "s"
       savesettings()
      CASE "S"
       savesettings()

     ENDSELECT


    CASE IDCMP_GADGETUP
     clicked:=iaddress
     gadgetid:=clicked.gadgetid

     SELECT gadgetid
      CASE EDIT_BUTTON
       launch(EDIT)

      CASE COMPILE_BUTTON
       launch(COMPILE)

      CASE ACTION1_BUTTON
       launch(ACTION1)

      CASE ACTION2_BUTTON
       launch(ACTION2)

      CASE PICK_BUTTON
       pick()

      CASE SAVESETTINGS_BUTTON
       savesettings()

      CASE EDITOR_STRING
       dummy := clicked.specialinfo
       dummy2 := dummy.buffer
       StrCopy(edit, dummy2, ALL)

      CASE COMPILER_STRING
       dummy := clicked.specialinfo
       dummy2 := dummy.buffer
       StrCopy(compile, dummy2, ALL)

      CASE ACTION1_STRING
       dummy := clicked.specialinfo
       dummy2 := dummy.buffer
       StrCopy(action1, dummy2, ALL)

      CASE ACTION2_STRING
       dummy := clicked.specialinfo
       dummy2 := dummy.buffer
       StrCopy(action2, dummy2, ALL)

      CASE KILL_CBOX
       IF checked
        checked:=FALSE
       ELSE
        checked:=TRUE
       ENDIF

     ENDSELECT
   ENDSELECT

  ENDLOOP

 ENDIF
 x: closedownscreen()
 closeppiwindow()
 CleanUp(0)
ENDPROC
