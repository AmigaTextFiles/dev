

OPT OSVERSION=37



MODULE 'exec/ports','exec/memory'
MODULE 'dos/dos'
MODULE 'gadtools','libraries/gadtools'
MODULE 'intuition/intuition','intuition/screens'
MODULE 'graphics/display','graphics/text','graphics/rastport'
MODULE 'utility/tagitem'
MODULE 'grio/uncomment'



ENUM OK,ER_CFG,ER_OPEN,ER_VIS,ER_GLIST,ER_RD,ER_MEM


CONST LEFTMOUSE=1,ERROR_EXIT=20,
      OPTIONSID=50,CHOICESID=0,
      START_POS=0,END_POS=1




RAISE ER_VIS   IF GetVisualInfoA()=NIL
RAISE ER_GLIST IF CreateContext()=NIL
RAISE ER_GLIST IF CreateGadgetA()=NIL
RAISE ER_RD    IF ReadArgs()=NIL

ENUM CONFIG,GUI,TIMEOUT,MOUSE,TEST,ARGS_SIZE



DEF checks[45]:ARRAY OF LONG,choices[45]:ARRAY OF LONG,vi
DEF gad:PTR TO gadget,window:PTR TO window,cfg,clen,slen
DEF checkcmds[30]:ARRAY OF LONG,tags,time=90,tick,min,cmds
DEF scriptfh,checkday,checkmin,checktick,text:PTR TO textattr


PROC main() HANDLE

   DEF glist,screen:PTR TO screen,gadid,quit,prefs,script
   DEF imsg:PTR TO intuimessage,number,gtname,scriptrun
   DEF args[ARGS_SIZE]:ARRAY OF LONG,rdargs



   FOR number:=0 TO ARGS_SIZE-1 DO args[number]:=NIL

   prefs:=glist:=screen:=quit:=NIL


   rdargs:=ReadArgs('CONFIG/K,GUI/S,TIMEOUT/K/N,MOUSEMOVE/S,TEST/S',args,NIL)


   IF (cfg:=args[CONFIG])=NIL THEN cfg:='S:BootGrio.prefs'


   IF (cfg:=prefs:=openCfg(cfg))=NIL THEN Raise(ER_MEM)


   cmds:=getCmds('###')


   IF parseCfg()=NIL THEN Raise(ER_CFG)


   scriptrun:='Execute RAM:BootGrioScript'
   script:=scriptrun+8


   IF (scriptfh:=Open(script,NEWFILE))
      writeCmds(cmds)
   ELSE
      Throw(ER_OPEN,'temp file')
   ENDIF


   cmds:=choices[]

   IF args[GUI]=NIL
      IF LEFTMOUSE <> Mouse()
         IF choices[2] THEN writeWithDefOptions() ELSE writeCmds(cmds)
         Raise(OK)
      ENDIF
   ENDIF


   gtname:='gadtools.library'


   IF (gadtoolsbase:=OpenLibrary(gtname,37))=NIL THEN Throw(ER_OPEN,gtname)


   tags:=[SA_DISPLAYID,MODE_640,
          SA_QUIET,TRUE,
          SA_DEPTH,2,SA_PENS,[-1]:INT,
          TAG_DONE]


   IF (screen:=OpenScreenTagList(NIL,tags))=NIL THEN Throw(ER_OPEN,'screen')



   vi:=GetVisualInfoA(screen,NIL)

   gad:=CreateContext({glist})


   text:=['topaz.font',8,FS_NORMAL,NIL]:textattr

   createGads()

   number:=IF args[MOUSE] THEN WFLG_REPORTMOUSE ELSE NIL


   tags:=[WA_WIDTH,640,WA_HEIGHT,256,
          WA_CUSTOMSCREEN,screen,
          WA_GADGETS,glist,
          WA_FLAGS,number OR (WFLG_BORDERLESS OR
          WFLG_RMBTRAP OR WFLG_ACTIVATE OR
          WFLG_SIMPLE_REFRESH),
          WA_IDCMP,IDCMP_MOUSEMOVE OR
          IDCMP_INTUITICKS OR
          IDCMP_REFRESHWINDOW OR
          IDCMP_GADGETUP,TAG_DONE]


   IF (window:=OpenWindowTagList(NIL,tags))=NIL THEN Throw(ER_OPEN,'window')


   Gt_RefreshWindow(window,NIL)

   drawBoxes()

   IF (number:=args[TIMEOUT])
       IF (number:=^number) > 0 THEN time:=number
   ENDIF


   setCheckTime()



   REPEAT
      IF (imsg:=Gt_GetIMsg(window.userport))
         number:=imsg.class
         gad:=imsg.iaddress
         Gt_ReplyIMsg(imsg)
         SELECT number
              CASE IDCMP_MOUSEMOVE
                   setTimeOut()
              CASE IDCMP_GADGETUP
                   gadid:=gad.gadgetid
                   IF OPTIONSID > gadid
                      cmds:=gad.userdata
                      quit:=TRUE
                   ENDIF
              CASE IDCMP_INTUITICKS
                   IF (quit:=checkTimeOut()) THEN gadid:=0
              CASE IDCMP_REFRESHWINDOW
                   Gt_BeginRefresh(window)
                   drawBoxes()
                   Gt_EndRefresh(window,TRUE)
         ENDSELECT
      ELSE
         WaitPort(window.userport)
      ENDIF

   UNTIL quit


   IF choices[gadid] THEN writeWithOptions() ELSE writeCmds(cmds)


EXCEPT DO

   IF exception
      SELECT exception
         CASE ER_CFG
            PutStr('no choices in prefs\n')
         CASE ER_OPEN
            Vprintf('unable to open \s\n',[exceptioninfo])
         CASE ER_VIS
            PutStr('could not get visual info\n')
         CASE ER_GLIST
            PutStr('create gadget error\n')
         CASE ER_RD
            PutStr('bad args (try : BootGrio ?)\n')
         CASE ER_MEM
            PutStr('no enough memory\n')
      ENDSELECT
      quit:=ERROR_EXIT
   ELSE
      quit:=NIL
   ENDIF

   IF window  THEN  CloseWindow(window)
   IF glist   THEN  FreeGadgets(glist)
   IF vi      THEN  FreeVisualInfo(vi)
   IF screen  THEN  CloseScreen(screen)
   IF gadtoolsbase  THEN CloseLibrary(gadtoolsbase)
   IF prefs   THEN  FreeVec(prefs)
   IF rdargs  THEN  FreeArgs(rdargs)

   IF scriptfh
      Close(scriptfh)
      IF args[TEST]=FALSE
         SystemTagList(scriptrun,NIL)
         DeleteFile(script)
      ENDIF
   ENDIF


ENDPROC quit



CHAR  '$VER: BootGrio 1.3e (07.09.97) by Grio',0




PROC openCfg(name)

   DEF buf=NIL:REG,fh:REG,fib:fileinfoblock,len:REG

   IF (fh:=Open(name,OLDFILE))=NIL THEN Throw(ER_OPEN,name)
   ExamineFH(fh,fib)
   len:=fib.size
   IF (buf:=AllocVec(len+1,MEMF_REVERSE))
      IF Read(fh,buf,len) = len
         buf[len]:=NIL
         unComment(buf,UNCM_REMLF OR UNCM_REMSPACE)
      ELSE
         FreeVec(buf)
         buf:=NIL
      ENDIF
   ENDIF
   Close(fh)


ENDPROC buf



CONST  ENDGADS=-1


PROC parseCfg()

   DEF name:REG,type:REG,check,sp:REG PTR TO LONG
   DEF cp:REG PTR TO LONG,sc:REG PTR TO LONG

   sp:=checks   ;   cp:=choices   ;   sc:=checkcmds

   REPEAT
       type,check,name:=gadFromCfg()
       SELECT type
           CASE BUTTON_KIND
                IF (15 > clen)
                   INC clen
                   cp[]++:=getCmds('###')
                   cp[]++:=name
                   cp[]++:=check
                ELSE
                   IF (15 = slen) THEN type:=ENDGADS
                ENDIF
           CASE CHECKBOX_KIND
                IF (15 > slen)
                   INC slen
                   sp[]++:=sc
                   sp[]++:=name
                   sp[]++:=check
                   sc[]++:=getCmds('BEFORE')
                   sc[]++:=getCmds('AFTER')
                ELSE
                   IF (15 = clen) THEN type:=ENDGADS
                ENDIF
       ENDSELECT
   UNTIL ENDGADS=type


ENDPROC clen





PROC gadFromCfg()

   MOVEM.L D3-D5,-(A7)
   MOVEA.L cfg,A0
   MOVEQ   #NIL,D1
   TST.B   (A0)
   BEQ.W   empty
   MOVEQ   #"#",D3
   CMP.B   (A0)+,D3
   BNE.W   empty
   MOVE.L  A0,D2
   LEA     choice(PC),A1
bloop:
   MOVE.B  (A1)+,D0
   BEQ.S   okchoice
   CMP.B   (A0)+,D0
   BEQ.S   bloop
   BRA.S   nochoice
okchoice:
   MOVEQ   #BUTTON_KIND,D0
   BRA.S   getname
nochoice:
   MOVEA.L D2,A0
   LEA     option(PC),A1
cloop:
   MOVE.B  (A1)+,D0
   BEQ.S   okcheck
   CMP.B   (A0)+,D0
   BEQ.S   cloop
   BRA.S   empty
okcheck:
   MOVEQ   #CHECKBOX_KIND,D0
getname:
   CMP.B   (A0),D3
   BNE.S   ready
   MOVE.L  #GTCB_CHECKED,D1
   ADDQ.W  #1,A0
ready:
   MOVEQ   #32,D4
   MOVEQ   #9,D5
copyloop:
   MOVE.B  (A0)+,D3
   CMP.B   D4,D3
   BEQ.S   copyloop
   CMP.B   D5,D3
   BEQ.S   copyloop
   SUBQ.W  #1,A0
   MOVE.L  A0,D2
   MOVEQ   #15,D3
   MOVEQ   #10,D5
findtext:
   MOVE.B  (A0)+,D4
   BEQ.S   zerocfg
   CMP.B   D5,D4
   BEQ.S   cleartext
   DBRA    D3,findtext
   CLR.B   (A0)+
looplf:
   MOVE.B  (A0)+,D3
   BNE.S   nozerocfg
zerocfg:
   SUBQ.W  #1,A0
   BRA.S   savetocfg
nozerocfg:
   CMP.B   D5,D3
   BNE.S   looplf
cleartext:
   CLR.B  -1(A0)
savetocfg:
   MOVE.L  A0,cfg
   BRA.S   end
empty:
   MOVEQ   #ENDGADS,D0
end:
   MOVEM.L (A7)+,D3-D5

ENDPROC D0

option:
   CHAR 'OPTION',0
choice:
   CHAR 'CHOICE',0




PROC writeWithOptions()

  DEF x:REG,p:REG PTR TO LONG,position:REG

  position:=START_POS
  BSR.S     writeLoop
  writeCmds(cmds)
  position:=END_POS
  BSR.S     writeLoop
  RETURN    D0
  
writeLoop:

  FOR x:=0 TO slen-1
      gad:=checks[x]
      IF (GFLG_SELECTED AND gad.flags)
         p:=gad.userdata
         writeCmds(p[position])
      ENDIF
  ENDFOR
  RTS

ENDPROC D0




PROC writeWithDefOptions()

   DEF x:REG,y:REG,p:REG PTR TO LONG,position:REG

   position:=START_POS
   BSR.S     writeDefLoop
   writeCmds(cmds)
   position:=END_POS
   BSR.S     writeDefLoop
   RETURN    D0
   
writeDefLoop:

   FOR x:=0 TO slen-1
       y:=x*3
       IF checks[y+2]
          p:=checks[y]
          writeCmds(p[position])
       ENDIF
   ENDFOR
   RTS

ENDPROC D0




PROC createGads()

   DEF ng:REG PTR TO newgadget,p1:REG PTR TO LONG,p2:REG PTR TO LONG
   DEF len:REG,addtop:REG,topstart,subproc,leftcheck,topcmp,x,type_gad


   ng:=[0,0,160,16,0,text,0,0,vi,0]:newgadget

   type_gad:=BUTTON_KIND
   p1:=choices
   len:=clen
   addtop:=20
   topstart:=10
   ng.gadgetid:=CHOICESID
   ng.flags:=PLACETEXT_IN
   subproc:={createChoice}
   topcmp:=110
   tags:=NIL
   BSR.S  makeGad

   type_gad:=CHECKBOX_KIND
   p1:=checks
   len:=slen
   addtop:=15
   topstart:=145
   ng.gadgetid:=OPTIONSID
   ng.flags:=PLACETEXT_RIGHT
   subproc:={createOption}
   topcmp:=210
   BSR.S   makeGad
   RETURN D0


makeGad:

   p2:=p1       ;       ng.topedge:=topstart

   IF 5 >= len
      ng.leftedge:=leftcheck:=240
   ELSE
      IF 10 >= len
         ng.leftedge:=157
         leftcheck:=323
      ELSE
         ng.leftedge:=76
         leftcheck:=574
      ENDIF
   ENDIF

   DEC len

   FOR x:=0 TO len
       IF ng.topedge < topcmp
          ng.topedge:=ng.topedge+addtop
       ELSE
          IF ng.leftedge=leftcheck
             RTS
          ELSE
             ng.leftedge:=ng.leftedge+166
             ng.topedge:=addtop+topstart
          ENDIF
       ENDIF
       ng.userdata:=p1[]++          ->   cmd
       ng.gadgettext:=p1[]++        ->   name
       MOVEA.L  subproc,A0
       JSR      (A0)
       ng.gadgetid:=ng.gadgetid+1
   ENDFOR
   RTS


createChoice:
   p2[]++:=p1[]++               ->   check
createGad:
   gad:=CreateGadgetA(type_gad,gad,ng,tags)
   RTS


createOption:
   tags:=[p1[]++,TRUE,TAG_DONE]
   BSR.S  createGad
   p2[]++:=gad
   RTS


ENDPROC D0






PROC drawBoxes()

  DEF left:REG,top:REG,width:REG,height:REG,name,length:REG

  length:=clen
  top:=19
  height:=IF 5 <= length THEN 113 ELSE (clen*20)+13
  name:=' CHOICES '
  BSR.S   drawBox
  
  length:=slen
  top:=150
  height:=IF 5 <= length THEN 87 ELSE (slen*15)+12
  name:=' OPTIONS '
  BSR.S drawBox
  RETURN D0

drawBox:

  IF 5 >= length
     left:=228
     width:=184
  ELSE
     IF 10 >= length
        left:=145
        width:=350
     ELSE
        left:=64
        width:=516
     ENDIF
  ENDIF

  DrawBevelBoxA (window.rport,left,top,width,height,
                [GTBB_FRAMETYPE,BBFT_RIDGE,GT_VISUALINFO,vi,
                 GTBB_RECESSED,TRUE,TAG_DONE])
  PrintIText(window.rport,
         [1,0,RP_JAM2,0,0,text,name,0]:intuitext,284,top-2)

  RTS


ENDPROC D0




PROC getCmds(pos_name)

   MOVEQ   #0,D0
   MOVEA.L cfg,A1
   CMP.B   #"#",(A1)+
   BNE.S   endskip
   MOVEA.L pos_name,A0
cmpget:
   MOVE.B  (A0)+,D1
   BEQ.S   okcmpget
   CMP.B   (A1)+,D1
   BEQ.S   cmpget
   BRA.S   endskip
okcmpget:
   CMPI.B  #10,(A1)+
   BNE.S   endskip
   MOVEA.L A1,A0
loopskip:
   TST.B   (A0)+
   BEQ.S   endskip
   CMPI.L  #"#END",(A0)
   BNE.S   loopskip
   MOVEQ   #0,D1
   MOVE.B  4(A0),D1
   BEQ.S   clearcmd
   CMP.B   #10,D1
   BNE.S   loopskip
   MOVEQ   #5,D1
clearcmd:
   CLR.B   (A0)
   PEA     0(A0,D1.L)
   MOVE.L  (A7)+,cfg
   TST.B   (A1)
   BEQ.S   endskip
   MOVE.L  A1,D0
   SUB.L   D0,A0
   MOVE.L  A0,-4(A1)
endskip:

ENDPROC D0




PROC writeCmds(cm)

   MOVE.L   cm,D2
   BEQ.S    quit
   MOVE.L   D3,-(A7)
   MOVEA.L  D2,A0
   MOVE.L   -4(A0),D3
   MOVE.L   scriptfh,D1
   MOVEA.L  dosbase,A6
   JSR      Write(A6)
   MOVE.L   (A7)+,D3
quit:

ENDPROC D0





PROC setCheckTime()

 MOVE.L  #1800,D0
 MOVE.L  time,D1
 CMP.L   D0,D1
 BLE.S   makeset
 MOVE.L  D0,D1
makeset:
 DIVU.W  #60,D1
 MOVE.L  D1,D0
 EXT.L   D1
 SWAP     D0
 MULU.W  #TICKS_PER_SECOND,D0
 MOVE.L  D1,min
 MOVE.L  D0,tick
 BSR.S   setTimeOut

ENDPROC D0





PROC setTimeOut()

  DEF ds:datestamp,m:REG,t:REG,x:REG

   DateStamp(ds)

   checkday:=ds.days

   t:=tick+ds.tick
   m:=min+ds.minute

   IF (x:=3000) < t
      INC m
      t:=t-x
   ENDIF

   IF (x:=1440) < m
      INC checkday
      m:=m-x
   ENDIF

   checkmin:=m
   checktick:=t

ENDPROC D0




PROC checkTimeOut()

  DEF ds:datestamp

  DateStamp(ds)

  IF ds.days >= checkday
     IF ds.minute >= checkmin
        IF ds.tick >= checktick THEN RETURN TRUE
     ENDIF
  ENDIF

ENDPROC FALSE





