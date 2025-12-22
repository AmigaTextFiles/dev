/*==========================================================================*/

-> PROGRAM       BFW
-> VERSION       3.1b
-> AUTHOR        Martin 'Bay-Tek' Zawadowicz
-> GUI DESIGN BY Bay-Tek
-> MAKE          ECDEMO v3.1

/*==========================================================================*/
/* NOTE: SOURCE IS FREEWARE!!!                                              */
/*==========================================================================*/

OPT PREPROCESS

MODULE 'intuition/intuition','gadtools','libraries/gadtools','intuition/gadgetclass',
       'intuition/screens','graphics/text','utility/tagitem','graphics/rastport',
       'dos/dos','dos/dosextens','dos/exall','dos/filehandler','dos/dostags',
       'exec/nodes','exec/lists','asl','libraries/asl'


ENUM ERR_NONE,ERR_KICK,ERR_CONTEXT,ERR_GADGET,ERR_LOCKSCREEN,ERR_VISUAL,
     ERR_GTOPEN,ERR_WINDOW,ERR_SCREEN,ERR_MENUS,ERR_DEVLIST,ERR_FORMAT,
     ERR_BFNAME,ERR_DISKNAME

CONST WNDIDCMP = IDCMP_MOUSEMOVE OR IDCMP_REFRESHWINDOW OR IDCMP_RAWKEY OR
                 IDCMP_GADGETUP OR IDCMP_CLOSEWINDOW OR LISTVIEWIDCMP OR
                 SCROLLERIDCMP

CONST WNDFLAGS = WFLG_DRAGBAR OR WFLG_DEPTHGADGET OR WFLG_CLOSEGADGET OR
                 WFLG_SMART_REFRESH OR WFLG_ACTIVATE OR WFLG_RMBTRAP

DEF	screen:PTR TO screen,
	quit_bfw=FALSE,
	bfw_wnd:PTR TO window,
	visual=NIL,
	tattr:PTR TO textattr,
	offx,offy,
	bfw_glist,
	bfw_Zoom[4]:ARRAY OF INT,
	getfileimagedata_g:PTR TO image,getfileimagedata

DEF	g_dname=NIL:PTR TO gadget,
	g_drives=NIL:PTR TO gadget,
	g_system=NIL:PTR TO gadget,
	g_speed=NIL:PTR TO gadget,
	g_quiet=NIL:PTR TO gadget,
	g_getfile=NIL:PTR TO gadget,
	g_bfname=NIL:PTR TO gadget,
	g_format=NIL:PTR TO gadget,
	g_about=NIL:PTR TO gadget

DEF     drivesList=NIL:PTR TO mlh,
        fileReq=NIL:PTR TO filerequester

DEF     nameValue,
        pathValue,
        quiet_info[5]:STRING,
        drive_info[50]:STRING,
        system_info[5]:STRING,
        speed_info[5]:STRING,
        pubScrName[$50]:STRING,
        pathBuff[256]:STRING

/*==========================================================================*/


PROC p_OpenLibraries()
    IF (gadtoolsbase:=OpenLibrary('gadtools.library',37))=NIL THEN Raise(ERR_GTOPEN)
ENDPROC

PROC p_CloseLibraries()
    IF gadtoolsbase THEN CloseLibrary(gadtoolsbase)
ENDPROC

PROC p_SetUpScreen()
    IF (screen:=LockPubScreen(pubScrName))=NIL THEN Raise(ERR_LOCKSCREEN)
        ScreenToFront(screen)
    IF (visual:=GetVisualInfoA(screen,NIL))=NIL THEN Raise(ERR_VISUAL)
    offy:=screen.wbortop+Int(screen.rastport+58)-10
ENDPROC

PROC p_SetDownScreen()
    IF getfileimagedata THEN Dispose(getfileimagedata)
    IF visual THEN FreeVisualInfo(visual)
    IF screen THEN UnlockPubScreen(NIL,screen)
ENDPROC

PROC p_bfwGui()
DEF g=NIL:PTR TO gadget
DEF stringInfo_dn:PTR TO stringinfo,stringInfo_p:PTR TO stringinfo

   drivesList:=New(SIZEOF mlh)
     p_InitList(drivesList)

 IF ( g:=CreateContext({bfw_glist}))=NIL THEN Raise (ERR_CONTEXT)
  IF (g_dname:=g:=CreateGadgetA(STRING_KIND,g,
    [offx+94,offy+17,169,14,'Disk Name',tattr,0,1,visual,0]:newgadget,
    [$80032013,1,
     GTST_STRING,'Empty',
     GTST_MAXCHARS,256,
     NIL]))=NIL THEN Raise (ERR_GADGET)
     stringInfo_dn:=g_dname.specialinfo
     nameValue:=stringInfo_dn.buffer

  IF (g_drives:=g:=CreateGadgetA(LISTVIEW_KIND,g,
    [offx+14,offy+55,91,56,'Drives:',tattr,1,4,visual,0]:newgadget,
    [GTLV_LABELS,NIL,
     GTLV_SHOWSELECTED,NIL,
     NIL]))=NIL THEN Raise (ERR_GADGET)
  IF (g_system:=g:=CreateGadgetA(CYCLE_KIND,g,
    [offx+174,offy+55,89,13,'System:',tattr,2,1,visual,0]:newgadget,
    [GTCY_LABELS,['FFS','OFS',0],
     NIL]))=NIL THEN Raise (ERR_GADGET)
  IF (g_speed:=g:=CreateGadgetA(CYCLE_KIND,g,
    [offx+174,offy+75,89,13,'Speed:',tattr,3,1,visual,0]:newgadget,
    [GTCY_LABELS,['FAST','QUICK','SLOW',0],
     NIL]))=NIL THEN Raise (ERR_GADGET)
  IF (g_quiet:=g:=CreateGadgetA(CHECKBOX_KIND,g,
    [offx+237,offy+96,26,11,'Quiet:',tattr,4,1,visual,0]:newgadget,
     NIL))=NIL THEN Raise (ERR_GADGET)
  IF (g_getfile:=g:=CreateGadgetA(GENERIC_KIND,g,
    [offx+243,offy+119,20,14,'',tattr,5,0,visual,0]:newgadget,
    [NIL]))=NIL THEN Raise (ERR_GADGET)
        g_getfile.flags:=GFLG_GADGIMAGE
        g_getfile.activation:=GACT_RELVERIFY
        g_getfile.gadgetrender:=getfileimagedata_g
  IF (g_bfname:=g:=CreateGadgetA(STRING_KIND,g,
    [offx+14,offy+119,227,14,'',tattr,6,0,visual,0]:newgadget,
    [$80032013,1,
     GTST_STRING,pathBuff,
     GTST_MAXCHARS,256,
     NIL]))=NIL THEN Raise (ERR_GADGET)
     stringInfo_p:=g_bfname.specialinfo
     pathValue:=stringInfo_p.buffer

  IF (g_format:=g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+14,offy+145,124,15,'_FORMAT',tattr,7,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN Raise (ERR_GADGET)
  IF (g_about:=g:=CreateGadgetA(BUTTON_KIND,g,
    [offx+139,offy+145,124,15,'_ABOUT',tattr,8,16,visual,0]:newgadget,
    [GT_UNDERSCORE,"_",
     NIL]))=NIL THEN Raise (ERR_GADGET)
ENDPROC

PROC  p_OpenbfwWindow()
 bfw_Zoom[0]:=NIL
 bfw_Zoom[1]:=NIL
 bfw_Zoom[2]:=TextLength(screen.rastport,'BFW v3.1b',8)+85
 bfw_Zoom[3]:=screen.wbortop+screen.rastport.txheight+1

 IF (bfw_wnd:=OpenWindowTagList(NIL,
		 [WA_LEFT,(screen.width-277)/2,
     		  WA_TOP,(screen.height-offy-168)/2,
     		  WA_WIDTH,277,
     		  WA_HEIGHT,offy+168,
     		  WA_FLAGS,WNDFLAGS,
     		  WA_IDCMP,WNDIDCMP,
     		  WA_TITLE,'BFW v3.1b',
     		  WA_SCREENTITLE,'BFW by Bay-Tek/MAWI^SCUM^TSI',
     		  WA_GADGETS,bfw_glist,
     		  WA_ZOOM,bfw_Zoom,
     		  WA_AUTOADJUST,TRUE,
                  WA_CUSTOMSCREEN,screen,
     		  WA_NEWLOOKMENUS,TRUE,
     		  TAG_DONE]))=NIL THEN Raise (ERR_WINDOW)

   p_bfwRender()
ENDPROC

PROC p_ClosebfwWindow()
  IF bfw_wnd THEN CloseWindow(bfw_wnd)
  IF bfw_glist THEN FreeGadgets(bfw_glist)
ENDPROC

PROC p_bfwRender()
  DrawBevelBoxA(bfw_wnd.rport,12+offx,144+offy,253,17,
    [GT_VISUALINFO,visual,GTBB_RECESSED,TRUE,NIL])
  DrawBevelBoxA(bfw_wnd.rport,4+offx,11+offy,269,26,
    [GT_VISUALINFO,visual,NIL])
  DrawBevelBoxA(bfw_wnd.rport,4+offx,113+offy,269,26,
    [GT_VISUALINFO,visual,NIL])
  DrawBevelBoxA(bfw_wnd.rport,4+offx,139+offy,269,27,
    [GT_VISUALINFO,visual,NIL])
  DrawBevelBoxA(bfw_wnd.rport,4+offx,37+offy,269,76,
    [GT_VISUALINFO,visual,NIL])
  Gt_RefreshWindow(bfw_wnd,NIL)
ENDPROC

/*==========================================================================*/

PROC p_LookbfwMessage()
DEF mes:PTR TO intuimessage,g:PTR TO gadget,
    type=0,infos=NIL,listItemPosition=1

  REPEAT
   IF mes:=Gt_GetIMsg(bfw_wnd.userport)
       type:=mes.class
        infos:=mes.code
       SELECT type
          CASE IDCMP_CLOSEWINDOW
             quit_bfw:=TRUE
          CASE IDCMP_REFRESHWINDOW
             Gt_BeginRefresh(bfw_wnd)
             Gt_EndRefresh(bfw_wnd,TRUE)
              p_bfwRender()
             type:=0
           CASE IDCMP_RAWKEY
                IF infos=69
                   quit_bfw:=TRUE
                ELSEIF infos=35
                   p_Format()
                ELSEIF infos=32
                   JUMP about
                ENDIF
           CASE IDCMP_GADGETUP
              g:=mes.iaddress
              SELECT g
                 CASE  g_drives
                   listItemPosition:=infos
                   p_DriveName(listItemPosition)
                 CASE  g_system
                   IF infos=1
                      StrCopy(system_info,'NOFFS')
                   ELSEIF infos=0
                      StrCopy(system_info,'FFS')
                   ENDIF

                 CASE  g_speed
                   IF infos=1
                      StrCopy(speed_info,'QUICK')
                   ELSEIF infos=2
                      StrCopy(speed_info,'SLOW')
                   ELSEIF infos=0
                      StrCopy(speed_info,'FAST')
                   ENDIF

                 CASE  g_quiet
                   IF infos THEN quiet_info:='QuIeT' ELSE quiet_info:=FALSE

                 CASE  g_getfile
                   p_FileReqester()
                 CASE  g_format
                   p_Format()
                 CASE  g_about
about:             reqest({about_txt},'OK')

              ENDSELECT
       ENDSELECT
       Gt_ReplyIMsg(mes)
     ELSE
      WaitPort(bfw_wnd.userport)
   ENDIF
  UNTIL type
ENDPROC

PROC main() HANDLE
DEF errlist:PTR TO LONG,args:PTR TO LONG,rdarg

 args:=['SYS:C/BFormat','Workbench']

   tattr:=['topaz.font',8,0,0]:textattr
    IF KickVersion(37)=FALSE THEN Raise (ERR_KICK)
     rdarg:=ReadArgs('BFNAME/K/A,PUBSCR/K/A',args,NIL)
      StrCopy(pathBuff,args[0],ALL)
        StrCopy(pubScrName,args[1],ALL)
    p_OpenLibraries()
    p_SetUpScreen()
    p_AllocGetFileImage()
    p_bfwGui()
    p_OpenbfwWindow()
    p_HuntDrives()
    p_DriveName(0)
      IF rdarg THEN FreeArgs(rdarg)
       StrCopy(system_info,'FFS')
        StrCopy(speed_info,'FAST')

    REPEAT
        p_LookbfwMessage()
    UNTIL quit_bfw=TRUE

    Raise(ERR_NONE)
 EXCEPT
    p_ClosebfwWindow()
    p_SetDownScreen()
    p_CloseLibraries()

  IF exception="MEM"
      WriteF('Sorry, out of memory!!!\n') ; JUMP exit
  ENDIF

  IF exception=ERR_KICK THEN WriteF('Sorry, you need KickStart v37+!!!\n')
  IF exception>1
     errlist:=['get context','create gadget','lock screen','get visual infos',
               'open "gadtools.library" v37+','open window','open screen','create menus']
     EasyRequestArgs(0,[20,0,'Error!!!','Could not \s!','OK'],0,[errlist[exception-2]])
  ENDIF
exit:
ENDPROC

/*=======================================================================*/

PROC p_InitList(l:PTR TO mlh)
  l.head:=l+4
  l.tail:=NIL
  l.tailpred:=l
ENDPROC


PROC p_AddToList(string)
DEF newNode=NIL:PTR TO ln, node:PTR TO ln,done=FALSE,itemPosition=0
  newNode:=New(SIZEOF ln)
  newNode.name:=String(StrLen(string))
  StrCopy(newNode.name,string,ALL)
  Gt_SetGadgetAttrsA (g_drives,bfw_wnd , NIL, [GTLV_LABELS, -1, TAG_DONE])
  node:=drivesList.head
  IF drivesList.tailpred=drivesList
    AddHead(drivesList, newNode)
  ELSEIF Char(node.name)>string[]
    AddHead(drivesList, newNode)
  ELSEIF node=drivesList.tailpred
    AddTail(drivesList,newNode)
  ELSE
    WHILE done=FALSE
      node:=node.succ
      INC itemPosition
      IF Char(node.name)>string[]
        done:=TRUE
      ELSEIF node.succ=NIL
        done:=TRUE
      ENDIF
    ENDWHILE
    Insert(drivesList, newNode, node.pred)
  ENDIF
  Gt_SetGadgetAttrsA (g_drives,bfw_wnd, NIL,
                      [GTLV_LABELS, drivesList,
                       GTLV_TOP,    0,
                       GTLV_SELECTED,0,
                       TAG_DONE])
ENDPROC


PROC p_DriveName(itemPosition)
DEF node:PTR TO ln, i=0
    node:=drivesList.head
    WHILE i<>itemPosition
         node:=node.succ
         INC i
    ENDWHILE
    StrCopy(drive_info,node.name)
ENDPROC

/*==========================================================================*/

PROC reqest(body,gad)
ENDPROC  EasyRequestArgs(bfw_wnd,[20,0,'BFW requester',body,gad],0,0)

/*==========================================================================*/

PROC p_HuntDrives()
DEF dl=NIL:PTR TO doslist,dlist=NIL,srtBuff[50]:STRING,
    fss:PTR TO filesysstartupmsg,dosenv:PTR TO dosenvec

   dl:=(dlist:=LockDosList(LDF_DEVICES OR LDF_READ))
    IF dlist=NIL THEN Raise (ERR_DEVLIST)
     WHILE dl:=NextDosEntry(dl,LDF_DEVICES)
      IF (dl.task<>0) AND (dl.startup>0)
        fss:=BADDR(dl.startup) ; dosenv:=BADDR(fss.environ)
       IF ((dosenv.dostype=$444F5300)  OR (dosenv.dostype=$444F5301)) AND ((dosenv.blockspertrack=11) OR (dosenv.blockspertrack=63) OR (dosenv.blockspertrack=51))
         StringF(srtBuff,'\s:',BADDR(dl.name)+1)
         p_AddToList(srtBuff)
       ENDIF
     ENDIF
   ENDWHILE
 UnLockDosList(LDF_DEVICES OR LDF_READ)
ENDPROC

PROC p_FileReqester()
 IF (aslbase:=OpenLibrary('asl.library',37))=NIL
     reqest('Could not open "asl.library" v37+','OK')
     RETURN
 ELSE

  IF (fileReq:=AllocAslRequest(ASL_FILEREQUEST,[ASLFR_TITLETEXT,'BFormatWin',ASLFR_WINDOW,bfw_wnd,ASLFR_SLEEPWINDOW,TAG_DONE]))=NIL
      reqest('Could not alloc requester','OK')
      JUMP closeLib
  ENDIF

 ENDIF

  IF (AslRequest(fileReq,0))=NIL THEN JUMP nofile

                        MOVE.L	fileReq,A0
			MOVE.L	8(A0),A0
			MOVE.L	pathValue,A1
		cp0:	MOVE.B	(A0)+,(A1)+
			BNE.S	cp0

			AddPart(pathValue,fileReq.file,256)


       Gt_SetGadgetAttrsA(g_bfname,bfw_wnd,NIL,[GTST_STRING,pathValue,NIL])
nofile:
       FreeAslRequest(fileReq)
closeLib:
       CloseLibrary(aslbase)
ENDPROC

/*==========================================================================*/

PROC p_Format() HANDLE
DEF bformat_exe[256]:STRING,fh=NIL,err,con[256]:STRING
 IF pathValue[]=NIL THEN Raise(ERR_BFNAME)
  IF nameValue[]=NIL THEN Raise(ERR_DISKNAME)

 IF  (reqest('You are sure ?!?','Yes|No!'))=FALSE THEN RETURN
    StringF(bformat_exe,'"\s" DRIVE \s NAME "\s" \s \s \s',pathValue,drive_info,nameValue,system_info,speed_info,quiet_info)
    StringF(con,'CON:////BFW output window/CLOSE/SCREEN\s',pubScrName)
       IF (fh:=Open(con,NEWFILE))=NIL THEN Raise ("OPEN")
       IF (err:=SystemTagList(bformat_exe,[SYS_INPUT,fh,
                                           SYS_OUTPUT,fh,
                                           SYS_ASYNCH,FALSE,NIL]))<>NIL THEN Raise (ERR_FORMAT)

 EXCEPT DO
   IF fh ; Delay(50) ; Close(fh) ; ENDIF
 IF exception
   SELECT exception
    CASE ERR_DISKNAME ;  reqest('Disk name is bad!!!','OK')
    CASE ERR_BFNAME   ;  reqest('BadFormat name is bad!!!','OK')
    CASE ERR_FORMAT   ;  reqest('Format error!!!','OK')
    CASE "OPEN"       ;  reqest('Could not open output window!!!','OK')
  ENDSELECT
 ENDIF
ENDPROC

/*==========================================================================*/

PROC p_AllocGetFileImage()
IF  (CopyMem([$0000,$1000,$0000,$3000,$003C,$3000,$0042,$3000,
              $0F81,$3000,$0FC1,$3000,$0C3F,$3000,$0C01,$3000,
              $0C01,$3000,$0C01,$3000,$0FFF,$3000,$0000,$3000,
              $0000,$3000,$7FFF,$F000,
              $FFFF,$E000,$C000,$0000,$C000,$0000,$C000,$0000,
              $C000,$0000,$C000,$0000,$C000,$0000,$C000,$0000,
              $C000,$0000,$C000,$0000,$C000,$0000,$C000,$0000,
              $C000,$0000,$8000,$0000]:INT,getfileimagedata:=NewM(112,2),112))=NIL THEN Raise("MEM")

              getfileimagedata_g:=[ 0,0,20,14,2,getfileimagedata,$3,0,NIL]:image
ENDPROC

/*==========================================================================*/
about_txt:
           CHAR   '»This program is FREEWARE«\n\n',
                  'If you have any sugestions\n',
                  'write to:\n\n',
                  '    Martin Zawadowicz\n',
                  '       Lipowa 4/19\n',
                  '      76-200 Slupsk\n',
                  '         POLAND',NIL
/*==========================================================================*/

