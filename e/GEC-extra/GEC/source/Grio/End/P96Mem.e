OPT PREPROCESS
OPT 020,OSVERSION=39
OPT REG=5

#define STRDOT

#define GEC


#ifdef  GEC
OPT STRMERGE
#define mul(a,b) (a*b)
#define div(a,b) (a/b)
#endif
#ifndef GEC
#define mul Mul
#define div Div
#endif



MODULE 'Picasso96API','libraries/Picasso96'
MODULE 'utility/tagitem','exec/tasks'
MODULE 'dos/var','exec/nodes','exec/ports'
MODULE 'icon','workbench/workbench'
MODULE 'dos/dos'



ENUM BOARDNAME,LARGEMEM,KBYTES,DELAY,FRAGMENT,DOTS,
     VARNAME,FORMAT,INFO,QUIET,DONTWAIT,NUM_ARGS

OBJECT mymn
  mn:mn
  task:LONG
ENDOBJECT


DEF args[NUM_ARGS]:ARRAY OF LONG,task:PTR TO tc
DEF dob=NIL:PTR TO diskobject,mes:PTR TO mymn,rdargs


PROC makePort()
DEF port:PTR TO mp
IF (port:=CreateMsgPort())
    IF (mes:=New(SIZEOF mymn))
        port::ln.name:={mpname}
        port::ln.pri:=-20
        AddPort(port)
        mes.task:=task
        PutMsg(port,mes)
    ELSE
       DeleteMsgPort(port)
       port:=NIL
    ENDIF
ENDIF
ENDPROC port

PROC delPort(port)
  RemPort(port)
  DeleteMsgPort(port)
ENDPROC


CHAR '$VER: P96Mem 0.3 (13.02.2002) by Grio',0


PROC main()
DEF num,board,buf[50]:STRING,mem,dots[30]:STRING
DEF bytes,name=NIL,total,port=NIL,free,large,frag=1
#ifndef GEC
task:=FindTask(NIL)
#endif
#ifdef GEC
task:=thistask
#endif
IF getargs()
   IF args[INFO]=NIL
      Forbid()
      IF (port:=FindPort({mpname}))
         mes:=GetMsg(port)
         Signal(mes.task,SIGBREAKF_CTRL_C)
      ENDIF
      Permit()
      stdout:=NIL
   ELSE
      args[QUIET]:=NIL
   ENDIF
   IF port=NIL
      IF (p96base:=OpenLibrary(P96NAME,2))
         IF Pi96GetRTGDataTagList([P96RD_NumberOfBoards,{num},TAG_END])=1
            IF num=1
               IF args[BOARDNAME]=NIL
                  Pi96GetBoardDataTagList(board:=0,[P96BD_BoardName,{name},TAG_DONE])
                  bytes:=TRUE
               ENDIF
            ENDIF
            IF name=NIL
               bytes:=NIL
               IF args[BOARDNAME]
                  DEC num
                  FOR board:=0 TO num
                      Pi96GetBoardDataTagList(board,[P96BD_BoardName,{name},TAG_DONE])
                      EXIT (bytes:=StrCmp(name,args[BOARDNAME],ALL))
                  ENDFOR
               ELSE
                  putstr('There\as more boards installed,give me the BOARDNAME, please.\n')
               ENDIF
            ENDIF
            IF bytes
               IF args[INFO]
                  Pi96GetBoardDataTagList(board,[P96BD_TotalMemory,{total},
                                                 P96BD_LargestFreeMemory ,{large},
                                                 P96BD_FreeMemory,{free},
                                                 P96BD_MemoryClock,{num},TAG_DONE])
                  num:=div(num+50000,100000)
                  bytes:='Board \d:  \s\nTotalMem: \l\d[8]\nFreeMem:  \l\d[8]\n'+
                         'LargeMem: \l\d[8]\nMemClock: \d.\d[1]MHz'
                  IF wbmessage
                     EasyRequestArgs(0,[20,0,'P96Mem Info',bytes,'Ok'],0,
                         [board,name,total,free,large,num/10,Mod(num,10)])
                  ELSE
                     PrintF(bytes,board,name,total,free,large,num/10,Mod(num,10))
                     PrintF('\n')
                  ENDIF
               ELSE
                  bytes:=IF args[KBYTES] THEN 'KB' ELSE 'B'
                  IF (port:=makePort())
                      putstr('P96Mem installed\n')
                      WHILE CtrlC()=NIL
                          Pi96GetBoardDataTagList(board,[P96BD_LargestFreeMemory ,{large},
                                                         P96BD_FreeMemory,{free},TAG_DONE])
                          mem:=IF args[LARGEMEM] THEN large ELSE free
                          IF args[KBYTES] THEN mem:=div(mem,1024)
                          IF args[FRAGMENT]
                             IF large THEN frag:=div(free,large)
                          ENDIF
                          makeValStr(dots,mem)
                          IF args[FORMAT]
                             StringF(buf,args[FORMAT],dots,frag)
                          ELSE
                             StrAdd(dots,bytes,ALL)
                             IF args[FRAGMENT]
                                StringF(buf,'\s (\d%)',dots,frag)
                             ELSE
                                StrCopy(buf,dots,ALL)
                             ENDIF
                          ENDIF
                          FOR num:=0 TO 2
                              EXIT SetVar(args[VARNAME],buf,EstrLen(buf),GVF_GLOBAL_ONLY)
                              Delay(5)
                          ENDFOR
                          Delay(args[DELAY])
                      ENDWHILE
                      delPort(port)
                      putstr('P96Mem removed\n')
                  ELSE
                      putstr('Error in creating msgport\n')
                  ENDIF
               ENDIF
            ELSE
               putstr('You haven\at installed selected board\n')
            ENDIF
         ENDIF
         CloseLibrary(p96base)
      ELSE
          putstr('Fail open Picasso96API.library\n')
      ENDIF
   ENDIF
   freeargs()
ELSE
   putstr('Problems with arguments/icon\n')
ENDIF
ENDPROC


mpname:
   CHAR  'P96Mem',0



PROC putstr(str)
DEF x
IF args[QUIET]=NIL
   PrintF(str)
   IF conout
      IF args[DONTWAIT]
         Delay(150)
      ELSE
         Read(conout,{x},0)
      ENDIF
      Close(conout)
      stdout:=conout:=NIL
   ENDIF
ENDIF
ENDPROC D0


PROC getargs()
DEF ret=FALSE,name[116]:STRING,i
IF wbmessage
   IF (iconbase:=OpenLibrary('icon.library',39))
      StringF(name,'PROGDIR:\s',task::ln.name)
      IF (dob:=GetDiskObjectNew(name))
         tooltypes(['BOARDNAME','LARGEMEM','KBYTES','DELAY',
         'FRAGMENT','DOTS','VARNAME','FORMAT','INFO','QUIET',
         'DONTWAIT'])
         IF (i:=args[DELAY])
            StrToLong(i,DELAY*4+args)
         ENDIF
         ret:=TRUE
      ELSE
         freeargs()
      ENDIF
   ENDIF
ELSE
   FOR i:=0 TO NUM_ARGS-1 DO args[i]:=NIL
   IF (rdargs:=ReadArgs('BOARDNAME,LARGEMEM/S,KBYTES/S,DELAY/K/N,'+
             'FRAGMENT/S,DOTS/S,VARNAME/K,FORMAT/K,INFO/S,QUIET/S'+
             ',DONTWAIT/S',args,NIL))
      IF args[DELAY] THEN args[DELAY]:=Long(args[DELAY])
      ret:=TRUE
   ENDIF
ENDIF
IF args[DELAY]=NIL THEN args[DELAY]:=50
IF args[VARNAME]=NIL THEN args[VARNAME]:='P96MemVar'
ENDPROC ret

PROC tooltypes(names:PTR TO LONG)
DEF x
FOR x:=0 TO NUM_ARGS-1
  args[x]:=FindToolType(dob.tooltypes,names[x])
ENDFOR
ENDPROC D0


PROC freeargs()
IF wbmessage
   IF dob THEN FreeDiskObject(dob)
   CloseLibrary(iconbase)
ELSE
   IF rdargs THEN FreeArgs(rdargs)
ENDIF
ENDPROC D0




#ifdef STRDOT
PROC makeValStr(estr,num)
DEF str[20]:STRING,len,x
StringF(str,'\d',num)
IF args[DOTS]
   IF (len:=EstrLen(str))<=3
      StrCopy(estr,str,ALL)
   ELSEIF len<=6
      StrCopy(estr,str,x:=len-3)
      addDot(estr,str+x,ALL)
   ELSE
      StrCopy(estr,str,x:=len-6)
      addDot(estr,str+x,3)
      addDot(estr,str+x+3,ALL)
   ENDIF
ELSE
   StrCopy(estr,str,ALL)
ENDIF
ENDPROC D0

PROC addDot(bf,cp,s)
 StrAdd(bf,'.',1)
 StrAdd(bf,cp,s)
ENDPROC D0
#endif


#ifndef STRDOT
PROC makeValStr(estr,num)
DEF dot1,dot2,dot3
IF args[DOTS]
   IF args[KBYTES]
      dot1:=div(num,1000)
      dot2:=num-mul(dot1,1000)
   ELSE
      dot1:=div(num,1000000)
      dot3:=mul(dot1,1000000)
      dot2:=div(num-dot3,1000)
      dot3:=num-dot3-mul(dot2,1000)
   ENDIF
   StringF(estr,IF args[KBYTES] THEN '\r\d.\z\d[3]' ELSE
               '\r\d.\z\d[3].\z\d[3]',dot1,dot2,dot3)
ELSE
   StringF(estr,'\d',num)
ENDIF
ENDPROC D0
#endif





