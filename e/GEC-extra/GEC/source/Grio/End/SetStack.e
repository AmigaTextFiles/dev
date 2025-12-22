OPT OSVERSION=36
OPT REG=5
OPT PREPROCESS


MODULE 'dos/dostags','utility/tagitem'
MODULE 'dos/dos','utility'


#define GEC 1

#ifndef GEC
  MODULE 'grio/fakestack'
#endif



CONST CREATEPROC=-138,CREATENEWPROC=-498,
      RUNCOMMAND=-504,SYSTEMTAGLIST=-606


CONST CREATENEWTAGS=0,CREATENEWSIZE=4,CREATENEWOLD=12
CONST SYSTEMTAGS=0,SYSTEMSIZE=4,SYSTEMMORE=8,SYSTEMOLD=12



ENUM MINSTACK,ADDSTACK

DEF oldcp,oldcnp,oldrc,oldstl,min,add


PROC main()
DEF args[2]:ARRAY OF LONG,rdargs,old,stop=0
DEF cp,cnp,rc,stl
#ifndef GEC
DEF stc
  stc:=fakestack()
#endif
  LEA     a4Store(PC),A0
  MOVE.L  A4,(A0)
  args[MINSTACK]:=0 ; args[ADDSTACK]:=0
  IF (utilitybase:=OpenLibrary('utility.library',36))
     IF (rdargs:=ReadArgs('MINSTACK=MIN/N/K,ADDSTACK=ADD/N/K',args,NIL))
        IF (min:=Long(args[MINSTACK]))=0 THEN min:=4096
        add:=Long(args[ADDSTACK])
        FreeArgs(rdargs)
        Forbid()
        oldcp:=patchDos(CREATEPROC,cp:={createProc})
        oldcnp:=patchDos(CREATENEWPROC,cnp:={createNewProc})
        oldrc:=patchDos(RUNCOMMAND,rc:={runCommand})
        oldstl:=patchDos(SYSTEMTAGLIST,stl:={systemTag})
        CacheClearU()
        Permit()
        WHILE stop<>4
           Wait(SIGBREAKF_CTRL_C)
           Forbid()
           IF oldcp
              IF (old:=patchDos(CREATEPROC,oldcp))<>cp
                 patchDos(CREATEPROC,old)
              ELSE
                 INC stop
                 oldcp:=0
              ENDIF
           ENDIF
           IF oldcnp
              IF (old:=patchDos(CREATENEWPROC,oldcnp))<>cnp
                 patchDos(CREATENEWPROC,old)
              ELSE
                 INC stop
                 oldcnp:=0
              ENDIF
           ENDIF
           IF oldrc
              IF (old:=patchDos(RUNCOMMAND,oldrc))<>rc
                 patchDos(RUNCOMMAND,old)
              ELSE
                 INC stop
                 oldrc:=0
              ENDIF
           ENDIF
           IF oldstl
              IF (old:=patchDos(SYSTEMTAGLIST,oldstl))<>stl
                 patchDos(SYSTEMTAGLIST,old)
              ELSE
                 INC stop
                 oldstl:=0
              ENDIF
           ENDIF
           CacheClearU()
           Permit()
           IF stop<4 THEN PrintF('can\at remove patch\n')
        ENDWHILE
     ELSE
        PrintF('bad args\n')
     ENDIF
     CloseLibrary(utilitybase)
  ELSE
     PrintF('can\at open utility.library\n')
  ENDIF
#ifndef GEC
  fakestack(stc)
#endif
ENDPROC

a4Store:
    LONG    0


CHAR '$VER : SetStack 1.1 (02.03.2004) by Grio',0


createProc:
  MOVE.L   A4,-(A7)
  MOVEA.L  a4Store(PC),A4
  CMP.L    min,D4
  BPL.S    bigger1
  MOVE.L   min,D4
bigger1:
  ADD.L    add,D4
  MOVEA.L  oldcp,A0
  MOVEA.L  (A7)+,A4
  JMP      (A0)

createNewProc:
  TST.L    D1
  BNE.S    start2
  MOVEQ    #NIL,D0
  RTS
start2:
  LEA      -20(A7),A7
  MOVEM.L  A3-A6,-(A7)
  LEA      16(A7),A5
  MOVEA.L  a4Store(PC),A4
  MOVEA.L  D1,A3
  MOVE.L   D1,A0
  MOVE.L   #NP_STACKSIZE,D0
  MOVEA.L  utilitybase,A6
  JSR      FindTagItem(A6)
  TST.L    D0
  BEQ.S    nfound2
  MOVE.L   D0,A1
  ADDQ.L   #4,A1
  BRA.S    patch2
nfound2:
  LEA      createNewTags(PC),A0
  MOVEA.L  A5,A1
  MOVE.L   (A0)+,(A1)+
  MOVE.L   (A0)+,(A1)+
  MOVE.L   (A0)+,(A1)+
  MOVE.L   (A0)+,(A1)+
  MOVE.L   (A0),(A1)
  LEA      CREATENEWOLD(A5),A0
  MOVE.L   A3,(A0)
  LEA      CREATENEWTAGS(A5),A0
  MOVE.L   A0,A3
  LEA      CREATENEWSIZE(A5),A1
patch2:
  MOVE.L   (A1),D0
  CMP.L    min,D0
  BPL.S    bigger2
  MOVE.L   min,D0
bigger2:
  ADD.L    add,D0
  MOVE.L   D0,(A1)
  MOVEA.L  oldcnp,A0
  MOVE.L   A3,D1
  MOVEM.L  (A7)+,A3-A6
  JSR      (A0)
  LEA      20(A7),A7
  RTS


createNewTags:
  LONG NP_STACKSIZE
->createNewSize:
  LONG 0,TAG_MORE
->createNewOld:
  LONG 0,TAG_DONE


runCommand:
  MOVE.L   A4,-(A7)
  MOVEA.L  a4Store(PC),A4
  CMP.L    min,D2
  BPL.S    bigger3
  MOVE.L   min,D2
bigger3:
  ADD.L    add,D2
  MOVEA.L  oldrc,A0
  MOVEA.L  (A7)+,A4
  JMP      (A0)


systemTag:
  MOVEM.L  D2/A4/A5,-(A7)
  LEA      -20(A7),A7
  MOVEA.L  A7,A5
  MOVEA.L  a4Store(PC),A4
  TST.L    D2
  BNE.S    nfound4
  MOVEM.L  D1/A6,-(A7)
  MOVEA.L  D2,A0
  MOVE.L   #NP_STACKSIZE,D0
  MOVEA.L  utilitybase,A6
  JSR      FindTagItem(A6)
  MOVEM.L  (A7)+,D1/A6
  TST.L    D0
  BEQ.S    nfound4
  MOVE.L   D0,A1
  ADDQ.L   #4,A1
  BRA.S    patch4
nfound4:
  LEA      systemTags(PC),A0
  MOVEA.L  A5,A1
  MOVE.L   (A0)+,(A1)+
  MOVE.L   (A0)+,(A1)+
  MOVE.L   (A0)+,(A1)+
  MOVE.L   (A0)+,(A1)+
  MOVE.L   (A0),(A1)
  LEA      SYSTEMOLD(A5),A0
  MOVE.L   D2,(A0)
  BNE.S    ptr4
  CLR.L    SYSTEMMORE(A5)
ptr4:
  LEA      SYSTEMTAGS(A5),A0
  MOVE.L   A0,D2
  LEA      SYSTEMSIZE(A5),A1
patch4:
  MOVE.L   (A1),D0
  CMP.L    min,D0
  BPL.S    bigger4
  MOVE.L   min,D0
bigger4:
  ADD.L    add,D0
  MOVE.L   D0,(A1)
  MOVEA.L  oldstl,A0
  JSR      (A0)
  LEA      20(A7),A7
  MOVEM.L  (A7)+,D2/A4/A5
  RTS


systemTags:
  LONG NP_STACKSIZE
->systemSize:
  LONG 0,TAG_MORE
->systemOld:
  LONG 0,TAG_DONE



PROC patchDos(offset,function)
  MOVEA.L   execbase,A6
  MOVEA.L   dosbase,A1
  MOVE.L    offset,A0
  MOVE.L    function,D0
  JSR       SetFunction(A6)
ENDPROC D0



