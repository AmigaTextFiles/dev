/* Re "compiler" and optimizer to MC68020 by Marco Antoniazzi 10-12-2005 */
/* 17-09-2008 finished translation to E */
/*PROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Marco Antoniazzi 2008
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;
;; The zlib/libpng License
;;
;; Copyright (C) 2008 Marco Antoniazzi
;;
;; This software is provided 'as-is', without any express or implied warranty.
;; In no event will the authors be held liable for any damages arising from
;; the use of this software.
;;
;; Permission is granted to anyone to use this software for any purpose,
;; including commercial applications, and to alter it and redistribute it
;; freely, subject to the following restrictions:
;;
;;
;; 1. The origin of this software must not be misrepresented; you must not
;;    claim that you wrote the original software. If you use this software
;;    in a product, an acknowledgment in the product documentation would be
;;    appreciated but is not required.
;;
;; 2. Altered source versions must be plainly marked as such, and must not be
;;    misrepresented as being the original software.
;;
;; 3. This notice may not be removed or altered from any source distribution.
;;
ENDPROC;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
*/
OPT OPTIMIZE

MODULE
        'dos',
        'dos/dos',
        'exec/lists',
        'exec/nodes',
        'exec/memory'

DEF fh,fhm=0,destmod[255]:STRING,pool
DEF end,pos:PTR TO CHAR,float=FALSE

  DEF mnem1:PTR TO LONG,mnem2:PTR TO LONG,mnem3:PTR TO LONG
  DEF mnem4:PTR TO LONG,mnem5:PTR TO LONG,mnem6:PTR TO LONG
  DEF c1:PTR TO LONG,c2:PTR TO LONG
  DEF preline:PTR TO CHAR
  DEF reg11:PTR TO CHAR,reg12:PTR TO CHAR
  DEF reg21:PTR TO CHAR,reg22:PTR TO CHAR
  DEF reg31:PTR TO CHAR,reg32:PTR TO CHAR
  DEF reg41:PTR TO CHAR,reg42:PTR TO CHAR
  DEF reg51:PTR TO CHAR,reg52:PTR TO CHAR
  DEF reg61:PTR TO CHAR,reg62:PTR TO CHAR
  DEF regt1:PTR TO CHAR,regt2:PTR TO CHAR
  DEF len,null=0,optim
  DEF pre,post1,post2,post3,post4

#define CLRMEM            MEMF_PUBLIC + MEMF_CLEAR
#define new(size)         AllocVecPooled(pool,size)
#define free(mem)         IF mem THEN FreeVecPooled(pool,mem)

->#define outcon

->#define DEBUG
#ifdef DEBUG
#define DBPrintF FPrintF
#else
#define DBPrintF() NOP
#endif

OBJECT dNode
  Succ:PTR TO Node,
  Pred:PTR TO Node,
  Type:BYTE,
  Pri :BYTE,
  Name:PTR TO CHAR,
  Name2:PTR TO CHAR
ENDOBJECT


PROC main() HANDLE
  DEF filelen,destname[255]:STRING,start,prog,rc=0
  DEF cliargs:PTR TO LONG,rdargs,template='SOURCE/A,DEST'

  cliargs:=[0,0]
  IFN rdargs:=ReadArgs(template,cliargs,NIL) THEN Raise('BAD Args')
  arg:=cliargs[]
  IFN pool:=CreatePool(CLRMEM,4096*2,4096) THEN Raise('Out of RAM')

  IF prog,filelen:=loadfile(arg)

    destname[]:=0
    IF cliargs[1] THEN StrAdd(destname,cliargs[1])

    end:=-1 ; WHILE (start:=InStr(arg+end+1,'.'))>-1 DO end +=start+1 ->find last dot
    StrAdd(destname,arg,end) ->copy till extension
    StrAdd(destname,'.ass') ->add new extension
    StrCopy(destmod,arg,end) ->copy till extension
    StrAdd(destmod,'.m') ->add new extension
#ifdef outcon
    fh:=stdout
#else
    IF fh:=Open(destname,NEWFILE)
#endif
      IF (IOErr()=205) THEN SetIoErr(0) ->since we are creating a new file it obviously doesn't exist yet!
      pos := start := prog
      end := start+filelen+1
      StrCopy(destname,arg,InStr(arg,'.')) ->copy till extension
      FPrintF(fh,';rE\n\tmachine mc68020\n\tfpu\t1\n\n')
      translate()
#ifndef outcon
      Close(fh)
    ELSE
      Raise('Unable to open new file:',destname)
    ENDIF
#endif
  ENDIF

EXCEPT DO
  freefile(prog)
  IF IOErr() THEN PrintFault(IOErr(),'OptiRe')
  IF fhm
    /* remove the last comma */
    Seek(fhm,-2,OFFSET_END)
    Write(fhm,'\n',1)
    Close(fhm)
  ENDIF
  IF pool THEN DeletePool(pool)
  FreeArgs(rdargs)
  IF exception THEN PrintF('\s \s\n',exception,exceptioninfo)
  IF exception THEN rc:=5
ENDPROC rc



PROC loadfile(filename)(LONG,LONG)
  DEF file=0,filelen=0,mem=0:PTR TO LONG

  IF file:=Open(filename,OLDFILE)
    filelen:=FileLength(filename)
    IF mem := AllocVec(filelen+1,MEMF_PUBLIC + MEMF_CLEAR)
      IF Read(file,mem,filelen)<>filelen
        FreeVec(mem)
        mem:=0
        SetIoErr(310) ->random number!
      ENDIF
    ELSE
      SetIoErr(ERROR_NO_FREE_STORE)
    ENDIF
    Close(file)
  ENDIF
ENDPROC mem,filelen

PROC freefile(mem:PTR TO LONG)
  IF mem THEN FreeVec(mem)
ENDPROC

PROC addNode(list,str,str2=0)
  DEF node:PTR TO dNode
  node:=new(SIZEOF dNode)
  node.Name:=new(StrLen(str))
  StrCopy(node.Name,str)
  IF str2
    node.Name2:=new(StrLen(str2))
    StrCopy(node.Name2,str2)
  ENDIF
  AddHead(list,node)
ENDPROC

PROC newList()(LONG)
  DEF list=0:PTR TO MinList

  IFN list:=new(SIZEOF MinList) THEN RETURN 0
  list.Head:=list+4
  list.Tail:=0
  list.TailPred:=list
ENDPROC list



PROC translate()
  DEF n,ver,rev,tracestr=FALSE,tracelst,data=FALSE,
      argn=0,stk=0,local=0,pregs='0',regsparams=FALSE,
      ulist=0:PTR TO MinList,urf:PTR TO LONG,lib=FALSE,src:PTR TO CHAR

  reg11 := new(100) ;  reg12 := new(100)
  reg21 := new(100) ;  reg22 := new(100)
  reg31 := new(100) ;  reg32 := new(100)
  reg41 := new(100) ;  reg42 := new(100)
  reg51 := new(100) ;  reg52 := new(100)
  reg61 := new(100) ;  reg62 := new(100)
  regt1 := new(100) ;  regt2 := new(100)
  preline := new(100)

  src := new(255)
  ->collect unreferenced procedures
  IF (n := InStr(pos,' URF'))>0
    urf := pos+n
    ulist := newList()
    WHILE n>=0
      setregs(urf,reg11,reg12)
      addNode(ulist,reg11)
      n := InStr(urf+1,' URF')
      urf += n+1
    ENDWHILE
  ENDIF

  mnem1:=pos              ; setregs(mnem1,reg11,reg12)
  mnem2:=nextmnem(mnem1)  ; setregs(mnem2,reg21,reg22)
  mnem3:=nextmnem(mnem2)  ; setregs(mnem3,reg31,reg32)
  mnem4:=nextmnem(mnem3)  ; setregs(mnem4,reg41,reg42)
  mnem5:=nextmnem(mnem4)  ; setregs(mnem5,reg51,reg52)
  mnem6:=nextmnem(mnem5)  ; setregs(mnem6,reg61,reg62)
  ->mnem6:=pos
  ->advancelines(6)
  WHILE (pos<end)
    IF pos[]=" "
      IF float
        pre:='f'
        post1:='.s'
        post2:='.s'
        post3:='.x'
        post4:='.x'
      ELSE
        pre:=[0,0]:CHAR ->use list since strings are not aligned
        post1:='.l'
        post2:='s.l'
        post3:='.l'
        post4:='s.l'
      ENDIF
      optim:=FALSE

      SELECT mnem1[]
        ->put number in register
        CASE " MVI" ->; FPrintF(fh,'\tmove.l\t#\s,\s\n',reg12,reg11)
          trans_MVI()
        -> put address of var in address register
        CASE " LEA" ->; FPrintF(fh,'\tlea.l\t\s\s,\s\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg11)
          trans_LEA()
        ->"fake" mnem not present in REC output
        CASE " MVL"
          trans_MVL()
        -> move contents of one register inside the other
        CASE " MVR" ->; FPrintF(fh,'\tmove.l\t\s,\s\n',reg12,reg11)
          trans_MVR()
        -> load 4bytes contained at address in register in the other register (load indirect)
        CASE " LDL" ->; FPrintF(fh,'\tmove.l\t(\s),\s\n',reg12,reg11)
          trans_LDL()
        -> load 2bytes contained at address in register in the other register (load indirect)
        CASE " LDW" ; FPrintF(fh,'\tmove.w\t(\s),\s\n',reg12,reg11)
        -> load 1byte contained at address in register in the other register (load indirect)
        CASE " LDB" ; FPrintF(fh,'\tmove.b\t(\s),\s\n',reg12,reg11)
        -> store contents of register (4bytes) into the memory at address in the other register
        CASE " STL"
          IF (mnem2[]=" ADA") AND (mnem3[]<>" ADA") AND (UWord(reg12)=UWord(reg21)) AND (reg22[]="4")
    DBPrintF(fh,';optiSTL-ADA 4\n')->optimize PrintF(a,func(),b)
            FPrintF(fh,'\t\smove\s\t\s,(\s)+\n',pre,post1,reg11,reg12)
            advancelines(1)
          ELSE
            FPrintF(fh,'\t\smove\s\t\s,(\s)\n',pre,post1,reg11,reg12)
            IF (mnem2[]=" LDL") AND (UWord(reg11)=UWord(reg21)) AND (UWord(reg12)=UWord(reg22))
    DBPrintF(fh,';optiSTL-LDL\n')
              advancelines(1)
            ENDIF
          ENDIF

        -> store contents of register (2bytes or 1byte) into the memory at address in the other register
        CASE " STW", " STB"
          IF (mnem2[]=" ADA") AND (mnem3[]<>" ADA") AND (UWord(reg12)=UWord(reg21))
            IF ((mnem1[]=" STW") AND (reg22[]="2")) OR ((mnem1[]=" STB") AND (reg22[]="1"))
    DBPrintF(fh,';optiSTW/STB-ADA 2/1\n')
              FPrintF(fh,'\tmove.\c\t\s,(\s)+\n',"a"-"A"+UByte(mnem1+3),reg11,reg12)
              advancelines(1)
            ENDIF
          ELSE
            FPrintF(fh,'\tmove.\c\t\s,(\s)\n',"a"-"A"+UByte(mnem1+3),reg11,reg12)
          ENDIF
        ->add value or register contents to address register
        CASE " ADA"
        /*  IF reg12[]="d"
            FPrintF(fh,'\tadda.l\t\s,\s\n',reg12,reg11)
          ELSE
            FPrintF(fh,'\tadda.l\t#\s,\s\n',reg12,reg11)
          ENDIF
        */
          trans_ADA()
        -> subtract immadiate value from address of address register
        CASE " SBA" ; FPrintF(fh,'\tsuba.l\t#\s,\s\n',reg12,reg11)

        -> stack is decreased and  value is stored in stack
        CASE " PSH"
          IF (mnem2[]=" POP")
  DBPrintF(fh,';optiPSH-POP;\c\c\c\c-\n',UByte(mnem2),UByte(mnem2+1),UByte(mnem2+2),UByte(mnem2+3))
            IF UWord(reg11)<>UWord(reg21) THEN FPrintF(fh,'\tmove.l\t\s,\s\n',reg11,reg21)

            advancelines(1)
          ELSEIF (mnem2[]=" F2I")
  DBPrintF(fh,';optiPSH-F2I\n')
            FPrintF(fh,'\t\smove\s\t\s,-(a7)\n',pre,post1,reg11)
            IF mnem3[]=" I2F"
              advancelines(2)
            ELSE
              float := FALSE
              advancelines(1)
            ENDIF
          ELSE
  DBPrintF(fh,';optiPSH\n')
            FPrintF(fh,'\t\smove\s\t\s,-(a7)\n',pre,post1,reg11)

          ENDIF
        -> contents of stack is put in register and stack is incremented
        CASE " POP"
          IF (mnem2[]=" PSH")
            IF StrCmp(reg11,reg21)
  DBPrintF(fh,';optiPOP-PSH\n')
              advancelines(2)
              optim:=TRUE
            ENDIF
          ENDIF
          IFN optim THEN FPrintF(fh,'\t\smove\s\t(a7)+,\s\n',pre,post1,reg11)
        ->output the current source line number and byte position
        CASE " LIN" ; FPrintF(fh,'\tdebug\t\s\n',reg11)
  DBPrintF(fh,';LIN:\s:\s:\d:\d\n',reg11,reg12,reg12[],Val(reg12))
          IF (reg12[]<>$20) AND (Val(reg12)>0)
            FPrintF(fh,'\tmove.l\td0,-(a7)\t;debug\n'+
                       '\tmove.l\t#\s,-(a7)\t;debug\n'+
                       '\tlea\t_str_00\d,a6\t;debug\n'+  ->FIXME: pea.l\t_str\d
                       '\tmove.l\ta6,-(a7)\t;debug\n'+
                       '\tlea\t_list_00\d,a6\t;debug\n'+
                       '\tmove.l\ta6,-(a7)\t;debug\n'+
                       '\tlea\t__source,a6\t;debug\n'+
                       '\tmove.l\ta6,-(a7)\t;debug\n'+
                       '\tmove.l\t#0,-(a7)\t;debug\n'+
                       '\tjsr\t_TraceLine\t;debug\n'+
                       '\tadda.l\t#4*5,a7\t\t;debug\n'+
                       '\tmove.l\t(a7)+,d0\t;debug\n',reg12,tracestr,tracelst)
          ENDIF
        ->unconditionally branch to label
        CASE " BRA" ; FPrintF(fh,'\tbra\t\s\n',reg11)
        ->conditionally branch to label
        CASE " BLT" ; FPrintF(fh,'\tblt\t\s\n',reg11)
        CASE " BLE" ; FPrintF(fh,'\tble\t\s\n',reg11)
        CASE " BGT" ; FPrintF(fh,'\tbgt\t\s\n',reg11)
        CASE " BGE" ; FPrintF(fh,'\tbge\t\s\n',reg11)
        CASE " BEQ" ; FPrintF(fh,'\tbeq\t\s\n',reg11)
        CASE " BNE" ; FPrintF(fh,'\tbne\t\s\n',reg11)
        ->jump to sub-routine whose address is in register
        CASE " JSI" ; FPrintF(fh,'\tjsr\t(\s)\n',reg11)
        ->set current cpu
        CASE " CPU"
        ->jump to sub-routine addressed by label
        CASE " JSR"
          FPrintF(fh,'\tjsr\t\s\n',reg11)
          IF mnem2[]=" I2F"
            FPrintF(fh,'\tfmove.l\td0,fp0\n')
            advancelines(1)
            float := TRUE
          ENDIF
        ->call a shared library function given the library base address and the offset of the function
        CASE " LBC" ; FPrintF(fh,'\tmovea.l\t\s,a6\n\tjsr\t\s(a6)\n',reg12,reg11)
        ->compare the registers setting the CPU condition register
        CASE " CMP" ; FPrintF(fh,'\t\scmp\s\t\s,\s\n',pre,post1,reg12,reg11)
        ->compare the register with 0 setting the CPU condition register
        CASE " TST"
          IF float
            FPrintF(fh,'\ttst.l\td\c\n',reg11[2])
          ELSE
            FPrintF(fh,'\ttst.l\t\s\n',reg11)
          ENDIF
          float:=FALSE
        ->conditionally put -1 or 0 in register
        ->FIXME: SLT-NOT -> SGE ecc.
        CASE " SLT"," SLE"," SGT"," SGE"," SEQ"," SNE"
          IF float
            FPrintF(fh,'\t\ss\c\c\td\c\n\textb.l\td\c\n',pre,"a"-"A"+UByte(mnem1+2),"a"-"A"+UByte(mnem1+3),reg11[2],reg11[2])
          ELSE
            FPrintF(fh,'\t\ss\c\c\t\s\n\textb.l\t\s\n',pre,"a"-"A"+UByte(mnem1+2),"a"-"A"+UByte(mnem1+3),reg11,reg11)
          ENDIF
          IF (float=TRUE) AND (mnem2[]=" F2I")
            float:=FALSE
            advancelines(1)
          ENDIF
        ->execute operation taking value from registers
        CASE " ADD", " SUB", " MUL", " DIV", " NEG", " SHR", " SHL", " AND", " ORL", " XOR", " NOT" ->optimize
  DBPrintF(fh,';optimath-\c\c\c\c-\n',UByte(mnem1),UByte(mnem1+1),UByte(mnem1+2),UByte(mnem1+3))
          SELECT mnem1[]
            CASE " ADD" ; FPrintF(fh,'\t\sadd\s\t\s,\s\n',pre,post1,reg12,reg11)
            CASE " SUB" ; FPrintF(fh,'\t\ssub\s\t\s,\s\n',pre,post1,reg12,reg11)
            CASE " MUL" ; FPrintF(fh,'\t\smul\s\t\s,\s\n',pre,post2,reg12,reg11)
            CASE " DIV" ; FPrintF(fh,'\t\sdiv\s\t\s,\s\n',pre,post2,reg12,reg11)
            CASE " NEG" ; FPrintF(fh,'\t\sneg\s\t\s\n',pre,post1,reg11)
            CASE " SHL" ; FPrintF(fh,'\tlsl.l\t\s,\s\n',reg12,reg11)
            CASE " SHR" ; FPrintF(fh,'\tlsr.l\t\s,\s\n',reg12,reg11)
            CASE " AND"
              IF float
                FPrintF(fh,'\tand.l\td\c,d\c\n',reg11[2],reg11[2]-1)
              ELSE
                FPrintF(fh,'\tand.l\t\s\s,\s\n',IF reg12[]="d" THEN null ELSE '#',reg12,reg11)
              ENDIF
              IF (mnem2[]=" TST") THEN advancelines(1)
            CASE " ORL" ; FPrintF(fh,'\tor.l\t\s,\s\n',reg12,reg11)
            CASE " XOR" ; FPrintF(fh,'\teor.l\t\s,\s\n',reg12,reg11)
            CASE " NOT" ; FPrintF(fh,'\tnot.l\td\c\n',IF reg11[]="f" THEN reg11[2] ELSE reg11[1])
          ENDSELECT

        ->add number to register
        CASE " ADI"
          optim := FALSE
          SELECT mnem2[]
            CASE " MVI"
              optim := TRUE
    DBPrintF(fh,';optiADI-MVI-\c\c\c\c-\n',UByte(mnem3),UByte(mnem3+1),UByte(mnem3+2),UByte(mnem3+3))
             ->make a "fake" line to possibly optimize further
              SELECT mnem3[]
                CASE " ADD"
                  c1 := Val(reg12)+Val(reg22)
                  StringF(preline,' ADI \s \d\n',reg11,c1)
                  advancelines(1)
                  copyprec()
                CASE " SUB"
                  c1 := Val(reg12)-Val(reg22)
                  StringF(preline,' ADI \s \d\n',reg11,c1)
                  advancelines(1)
                  copyprec()
                CASE " MUL"
                  c1 := Val(reg12)*Val(reg22)
                  StringF(preline,' MLI \s \d\n',reg11,c1)
                  advancelines(1)
                  copyprec()
                CASE " DIV"
                  c1 := Val(reg12)/Val(reg22)
                  StringF(preline,' ADI \s \d\n',reg11,c1)
                  advancelines(1)
                  copyprec()
                DEFAULT ; optim := FALSE
              ENDSELECT
            CASE " ADI"
  DBPrintF(fh,';optiADI-ADI\n')
              c1 := Val(reg12)+Val(reg22)
              FPrintF(fh,'\tmove.l\t#\d,\s\n',c1,reg21)
              advancelines(1)
              optim := TRUE
            CASE " SBI"
  DBPrintF(fh,';optiADI-SBI\n')
              c1 := Val(reg12)-Val(reg22)
              FPrintF(fh,'\tmove.l\t#\d,\s\n',c1,reg21)
              advancelines(1)
              optim := TRUE
          ENDSELECT
          IF optim=FALSE THEN IF reg12[]="0" THEN DBPrintF(fh,';opti ADI 0\n') ELSE FPrintF(fh,'\taddi.l\t#\s,\s\n',reg12,reg11)
          
        ->sub number from register
        CASE " SBI"
          optim := FALSE
          IF (mnem2[]=" MVI")
            optim := TRUE
  DBPrintF(fh,';optiSBI-MVI-\c\c\c\c-\n',UByte(mnem3),UByte(mnem3+1),UByte(mnem3+2),UByte(mnem3+3))
           ->make a "fake" line and go back to possibly optimize further
            SELECT mnem3[]
              CASE " ADD"
                c1 := Val(reg22)-Val(reg12)
                StringF(preline,' ADI \s \d\n',reg11,c1)
                advancelines(1)
                copyprec()
              CASE " SUB"
                c1 := Val(reg22)-Val(reg12)
                StringF(preline,' ADI \s \d\n',reg11,c1)
                advancelines(1)
                copyprec()
              CASE " MUL"
                c1 := Val(reg22)*Val(reg12)
                StringF(preline,' MLI \s \d\n',reg11,c1)
                advancelines(1)
                copyprec()
              CASE " DIV"
                c1 := Val(reg22)/Val(reg12)
                StringF(preline,' ADI \s \d\n',reg11,c1)
                advancelines(1)
                copyprec()
              DEFAULT ; optim := FALSE
            ENDSELECT
          ELSEIF (mnem2[]=" ADI")
  DBPrintF(fh,';optiSBI-ADI\n')
            setregs(mnem2,reg21,reg22)
            c1 := Val(reg12)+Val(reg22)
            FPrintF(fh,'\tmove.l\t#\d,\s\n',c1,reg21)
            advancelines(1)
            optim := TRUE
          ELSEIF (mnem2[]=" SBI")
  DBPrintF(fh,';optiSBI-SBI\n')
            setregs(mnem2,reg21,reg22)
            c1 := Val(reg12)-Val(reg22)
            FPrintF(fh,'\tmove.l\t#\d,\s\n',c1,reg21)
            advancelines(1)
            optim := TRUE
          ENDIF
          IF optim=FALSE THEN IF reg12[]="0" THEN DBPrintF(fh,';opti SBI 0\n') ELSE FPrintF(fh,'\tsubi.l\t#\s,\s\n',reg12,reg11)

        ->multiply number and register
        CASE " MLI"
  DBPrintF(fh,';optiMLI:\h,\d\n',UWord(reg12),reg12[1])
          IF (mnem2[]=" MLI")
  DBPrintF(fh,';optiMLI-MLI\n')
            c1 := Val(reg12)*Val(reg22)
            FPrintF(fh,'\tmuls.l\t#\d,\s\n',c1,reg21)
            advancelines(1)
          ELSEIF UWord(reg12)=$3100
            ->FPrintF(fh,';opti MLI 1\n')
          ELSEIF UWord(reg12)=$3200
            FPrintF(fh,'\tasl.l\t#1,\s\n',reg11)
          ELSEIF UWord(reg12)=$3400
            FPrintF(fh,'\tasl.l\t#2,\s\n',reg11)
          ELSE
            FPrintF(fh,'\tmuls.l\t#\s,\s\n',reg12,reg11)
          ENDIF
        ->add number to value addressed by label
        CASE " INC" ; FPrintF(fh,'\tadd.l\t#\s,\s\s\n',reg11,reg12,IF reg12[]="_" THEN &null ELSE '(a5)')
        ->subtract number from value addressed by label
        CASE " DEC" ; FPrintF(fh,'\tsub.l\t#\s,\s\s\n',reg11,reg12,IF reg12[]="_" THEN &null ELSE '(a5)')
        ->increment address of stack by given value (multiplied by 4)
        CASE " ADS"
          IF Val(reg11)>0 THEN FPrintF(fh,'\tadda.l\t#\s*4,a7\n',reg11)
        -> extend from 8 to 32 bit
        CASE " EXB" ; FPrintF(fh,'\textb.l\t\s\n',reg11)
        -> extend from 16 to 32 bit
        CASE " EXW" ; FPrintF(fh,'\text.l\t\s\n',reg11)->FIXME:IF mnem2[]=" TST" THEN advancelines(1)
        ->put value in counter register
        CASE " CTR" ; FPrintF(fh,'\tmove.l\t\s,d7\n',reg11)
        ->decrement counter register by given value and branch if <>0
        CASE " DBF" ; FPrintF(fh,'\tdbf\td7,\s\n',reg11)
        ->reserve 4bytes,2bytes,1byte multiplied by given value in program (static) memory
        CASE " DCL" ; FPrintF(fh,'\tdc.l\t\s\n',reg11)
        CASE " DCW" ; FPrintF(fh,'\tdc.w\t\s\n',reg11)
        CASE " DCB" ; FPrintF(fh,'\tdc.b\t\s\n',reg11)
        ->put given string in program (static) memory
        CASE " DSB" ; FPrintF(fh,'\tds.b\t\s\n\tcnop\t0,2\n',reg11)
        ->put given float number in program (static) memory
        CASE " DCF" ; FPrintF(fh,'\tdc.s\t\s\n',reg11)
        ->align to CPU's bitness
        CASE " ALN" ; FPrintF(fh,'\tcnop\t0,2\n')
        ->declare given symbol as external
        CASE " XRF" ; FPrintF(fh,'\txref\t\s\n',reg11)
        ->let given symbol be exported
        CASE " XDF"
          FPrintF(fh,'\txdef\t\s\n',reg11)
          IF (data=0) AND (ulist<>0) AND (lib=FALSE)
            IF FindName(ulist,reg11)
              pos +=InStr(pos,' RTS _')
              pos := nextmnem(pos)-1
              mnem6:=pos
              advancelines(6)
            ENDIF
          ENDIF

        ->switch from integer to float registers and computations
        CASE " I2F"
            IF (float=FALSE)
    DBPrintF(fh,';optiI2F:\s\n',reg11)
              FPrintF(fh,'\tfmove.l\t\s,fp\c\n',reg11,reg11[1])
            ENDIF
            float := TRUE

        ->switch from float to integer registers an computations
        CASE " F2I"
  DBPrintF(fh,';optiF2I:\s \s \s \s\n',reg11,reg12,reg21,reg22)
          IF mnem2[]=" I2F"
            float := TRUE
            IF mnem3[]=" F2I"
  DBPrintF(fh,';optiF2I-I2F-F2I\n')
              float:=FALSE
              advancelines(2)
            ELSE
              
  DBPrintF(fh,';optiF2I2-I2F:\s \s \s \s\n',reg11,reg12,reg21,reg22)
              IF (reg22[]<>0) ->F2I d d
                FPrintF(fh,'\tfmove.s\t\s,fp\c\n',reg22,reg21[1])
                advancelines(1)
              ENDIF
            ENDIF
          ELSE
            
            IF (float=TRUE)
              IF (UWord(reg12)="fp") AND (UWord(reg11)="fp")
                FPrintF(fh,'\tfmove.s\t\s,d\c\n',reg12,reg11[2])
              ELSEIF  (UWord(reg11)="fp")
                FPrintF(fh,'\tfmove.l\t\s,d\c\n',reg11,reg11[2])
              ENDIF
            ENDIF
            float := FALSE

          ENDIF
        ->given symbol is an argument of current sub-routine
        CASE " ARG"
          IFN regsparams
            IF mnem2[]=" PSH"
              argn -=4
              regsparams := argn-4
            ENDIF
          ENDIF
          FPrintF(fh,'\s\tequ\t\d\n',reg11,argn -=4)
        -> local variable size and name
        CASE " LCL" ; FPrintF(fh,'\s\tequ\t-\d\n',reg12,local) ; c1 := Val(reg11) ; c1 := (c1 +3) AND ~3 ; local -= c1
        -> number of arguments
        CASE " ARN" ; argn := Val(reg11) ; argn := argn*4+8 ; float := FALSE
        ->create local stack frame
        CASE " LNK" ; 
                      stk := Val(pos+InStr(pos,'\n ULK') + 6) +regsparams ; local := stk
                      FPrintF(fh,'\tlink\ta5,#-\d\n',stk)
        ->free stack frame created by LNK
        CASE " ULK" ; FPrintF(fh,'\tunlk\ta5\n')
          IF regsparams THEN FPrintF(fh,'\tadda.l\t#\d,a7\n',regsparams)
          regsparams := 0
        ->multiple push registers on stack
        CASE " MPS" ; IF (argn := Val(pos+InStr(pos,' MPP') + 5))>0 THEN PutByte(pregs,"0"+argn)
                      FPrintF(fh,'\tmovem.l\ta0\s\s,-(a7)\n',IF argn=0 THEN null ELSE '-a',IF argn=0 THEN null ELSE pregs)
        ->multiple pop registers from stack
        CASE " MPP"
          IF float THEN FPrintF(fh,'\tfmove.s\tfp0,d0\n') ->FIXME:Kind of a hack!
          FPrintF(fh,'\tmovem.l\t(a7)+,a0\s\s\n',IF argn=0 THEN null ELSE '-a',IF argn=0 THEN null ELSE pregs)
        ->return from subroutin (to address found on stack)
        CASE " RTS" ; FPrintF(fh,'\trts\n')
        ->activates tracing-debug output
        CASE " TRN"
          tracestr := Val(reg11)
          tracelst := Val(reg12)
        ->deactivates tracing-debug output
        CASE " TRF"
        -> start of data section
        CASE " DAT" ; FPrintF(fh,'\n\tsection\t".tocd",data\n') ; data := TRUE
                      IF tracestr THEN FPrintF(fh,'__source:\tdc.b\t\s,0\n\tcnop\t0,2\n',src)
        ->place given file in this position
        CASE " INB" ; FPrintF(fh,'\tincbin\t\s\n',reg11)
        ->assign given value to given symbol
        CASE " EQU" ; FPrintF(fh,'\s\tequ\t\s\n',reg11,reg12)
        ->declare current source complete path name
        CASE " SRC" ; FPrintF(fh,'\tdsource\t\s\n',reg11) ; StrCopy(src,reg11)
        -> library name
        CASE " LBN" ; lib := TRUE
                      FPrintF(fh, '\n'+
                              '_LibNull:\n'+
                              '\tmove.l\t#0,d0\n'+
                              '\trts\n'+
                              '_LibName:\n')
        -> library version
        CASE " LBV" ; ver:=Val(reg11)
                      FPrintF(fh,'\n'+
                              'RomTag:\n'+
                              '\tdc.w\t$4afc\n'+
                              '\tdc.l\tRomTag\n'+
                              '\tdc.l\tEndRom\n'+
                              '\tdc.b\t$80\n'+
                              '\tdc.b\t\d\n'+
                              '\tdc.b\t9\n'+
                              '\tdc.b\t0\n'+
                              '\tdc.l\t_LibName\n'+
                              '\tdc.l\t_LibIDString\n'+
                              '\tdc.l\t_LibInitTable\n'+
                              'EndRom:\n'+
                              '\tdc.w\t0\n',
                              ver)
        -> library revision
        CASE " LBR" ; rev:=Val(reg11)
                      FPrintF(fh,'\n'+
                              '_LibData:\n'+
                              '\tdc.b\t$a0,8,9,0,$80,10\n'+
                              '\tdc.l\t_LibName\n'+
                              '\tdc.b\t$a0,14,6,0,$90,2\n'+
                              '\tdc.w\t\d\n'+
                              '\tdc.b\t$90,22\n'+
                              '\tdc.w\t\d\n'+
                              '\tdc.b\t$80,24\n'+
                              '\tdc.l\t_LibIDString\n'+
                              '\tdc.l\t0\n',
                              ver,rev)
        -> library ID string
        CASE " LBI" ; FPrintF(fh, '_LibIDString:\n')
        -> library data size
        CASE " LBS" ; fhm := Open(destmod,NEWFILE)
                      FPrintF(fh,'\n'+
                              '_LibInitTable:\n'+
                              '\tdc.l\t\s\n'+
                              '\tdc.l\t_LibVectors\n'+
                              '\tdc.l\t_LibData\n'+
                              '\txref\t_LibInit\n'+
                              '\tdc.l\t_LibInit\n'+
                              '_LibVectors:\n'+
                              '\txref\t_LibOpen\n'+
                              '\tdc.l\t_LibOpen\n'+
                              '\txref\t_LibClose\n'+
                              '\tdc.l\t_LibClose\n'+
                              '\txref\t_LibExpunge\n'+
                              '\tdc.l\t_LibExpunge\n'+
                              '\tdc.l\t_LibNull\n',
                              reg11)
                      IF fhm THEN FPrintF(fhm,'LIBRARY \s\n',reg12)
        -> library function
        CASE " LBF" ; FPrintF(fh, '\tdc.l\t_\s\n',reg11)
        -> library list of functions end
        CASE " LBE" ; FPrintF(fh, '\tdc.l\t-1\n')
        -> library function "prototype" to be output to .m file
        CASE " LBM" ; StrCopy(reg12,reg11+1,StrLen(reg11)-2); IF fhm THEN FPrintF(fhm,'\t\s\n',reg12)
        ->end of main()
        CASE " ENM" ;
          FPrintF(fh,'\tmove.l\td0,-(a7)\t;debug\n'+
                     '\tmove.l\t#0,-(a7)\t;debug\n'+
                     '\tmove.l\t#0,-(a7)\t;debug\n'+
                     '\tmove.l\t#0,-(a7)\t;debug\n'+
                     '\tmove.l\t#0,-(a7)\t;debug\n'+
                     '\tmove.l\t#1,-(a7)\t;debug\n'+
                     '\tjsr\t_TraceLine\t;debug\n'+
                     '\tadda.l\t#4*5,a7\t\t;debug\n'+
                     '\tmove.l\t(a7)+,d0\t;debug\n')

        ->mark start of assembler output block
        CASE " ASM"
          pos:=mnem2
          REPEAT
            FPutC(fh,pos[]++)
          UNTIL Long(pos)=" ENA"
          mnem6:=pos-1
          advancelines(6)
        ->mark end of assembler output block (absorbed by previous CASE)
        ->CASE " ENA"
        ->unrecognized mnemonic
        DEFAULT
          FPrintF(fh,';\c\c\c\c \s\n',UByte(mnem1),UByte(mnem1+1),UByte(mnem1+2),UByte(mnem1+3),reg11)
          
      ENDSELECT
    ->write label
    ELSEIF pos[]=":"
      FPrintF(fh,'\s:\n',reg11)
    ->write comment
    ELSEIF pos[]=";"
      WHILE (pos[]<>"\n") AND (pos<end) DO FPutC(fh,pos[]++)
      FPutC(fh,"\n")
    ENDIF
    ->goto next line
    advancelines(1)
  ENDWHILE
/*
  freeing mem is done at exit by DeletePool()
*/
ENDPROC

PROC trans_MVI()
 DEF res=0:PTR TO LONG

          SELECT mnem2[]
            CASE " MVI" ->optimize
              res := Val(reg12)
              optim:=TRUE
              SELECT mnem3[]
                CASE " ADD" ; res += Val(reg22)
                CASE " SUB" ; res -= Val(reg22)
                CASE " MUL" ; res *= Val(reg22)
                CASE " DIV" ; res /= Val(reg22)
                ->CASE " NEG" ; res := 0-res
                CASE " SHR" ; res := res >> Val(reg22)
                CASE " SHL" ; res := res << Val(reg22)
                CASE " AND" ; res := res & Val(reg22)
                CASE " ORL" ; res := res | Val(reg22)
                ->FIXME:CASE " XOR" ; res := Eor(res , Val(reg22))
                ->CASE " NOT" ; res := Not(res)
                DEFAULT ; optim := FALSE
              ENDSELECT
              IF optim
  DBPrintF(fh,';optiMVI-MVI::\d\n',res)
/*
 MVI dx n
 MVI dy m
 math dx dy => MVI dx n(math)m
*/
  DBPrintF(fh,';optiMVI-MVI-\c\c\c\c\n',UByte(mnem3),UByte(mnem3+1),UByte(mnem3+2),UByte(mnem3+3))
                ->make a "fake" line to possibly optimize further
                StringF(preline,' MVI \s \d\n',reg11,res)
                advancelines(1)
                copyprec()

              ENDIF
/*
 MVI
 math => mathi
*/
            CASE " ADD", " SUB", " MUL", " MLI", " DIV", " NEG", " SHR", " SHL", " AND", " ORL", " NOT" ->optimize
  DBPrintF(fh,';optiMVI-\c\c\c\c-\d\n',UByte(mnem2),UByte(mnem2+1),UByte(mnem2+2),UByte(mnem2+3),Val(reg12))
              IF float=FALSE
                optim:=TRUE
                SELECT mnem2[]
                  CASE " ADD"
                      ->make a "fake" line to possibly optimize further
                      StringF(preline,' ADI \s \s\n',reg21,reg12)
                      copyprec()
                  CASE " SUB"
                      ->make a "fake" line to possibly optimize further
                      StringF(preline,' SBI \s \s\n',reg21,reg12)
                      copyprec()
                  CASE " MUL"
                      ->make a "fake" line to possibly optimize further
                      StringF(preline,' MLI \s \s\n',reg21,reg12)
                      copyprec()
                  CASE " DIV"
                    IF Val(reg12)<>1 THEN FPrintF(fh,'\tdivs.l\t#\s,\s\n',reg12,reg21)
                    advancelines(1)
                  CASE " SHR"
                    IF Val(reg12)<=8
                      FPrintF(fh,'\tlsr.l\t#\s,\s\n',reg12,reg21)
                      advancelines(1)
                    ELSE
                      optim:=FALSE
                    ENDIF
                  CASE " SHL"
                    IF Val(reg12)<=8
                      FPrintF(fh,'\tlsl.l\t#\s,\s\n',reg12,reg21)
                      advancelines(1)
                    ELSE
                      optim:=FALSE
                    ENDIF
                  CASE " AND"
                    IF Val(reg12)<>-1 THEN FPrintF(fh,'\tandi.l\t#\s,\s\n',reg12,reg21)
                    advancelines(1)
                  CASE " ORL"
                    IF Val(reg12)<>0  THEN FPrintF(fh,'\tori.l\t#\s,\s\n',reg12,reg21)
                    advancelines(1)
                  CASE " NEG" ->;                       FPrintF(fh,'\tmove.l\t#-\s,\s\n',reg12,reg21)
                    ->make a "fake" line to possibly optimize further
                    StringF(preline,' MVI \s \d\n',reg21,(0-Val(reg12)))
      DBPrintF(fh,';optiMVI-NEG-\s:\s\n',reg12,preline)
                    copyprec()
                  CASE " NOT" 
                    ->make a "fake" line to possibly optimize further
                    StringF(preline,' MVI \s \d\n',reg21,Not(Val(reg12)))
                    copyprec()
                  CASE " MLI"
                    c1:=Val(reg12)
                    c1 *=Val(reg22)
                    IF (mnem3[]=" ADA") AND (reg32[]="d")->e.g. a:=b[1]

      DBPrintF(fh,';optiMVI-MLI-ADA-\s \d\n',reg31,c1)
                      ->make a "fake" line to possibly optimize further
                      StringF(preline,' ADA \s \d\n',reg31,c1)
                      copyprec()
                    ELSE
    DBPrintF(fh,';optiMVI-MLI\n')
                      FPrintF(fh,'\tmove.l\t#\d,\s\n',c1,reg21)
                    ENDIF
                ENDSELECT
              ENDIF ->IF float

            CASE " LEA"
              IF (mnem3[]=" STL")->e.g. a:=1
                SELECT mnem4[]
                  CASE " CMP"," TST"," PSH"," LEA"," MVI"->with these I can not "absorb" d0
                  DEFAULT
  DBPrintF(fh,';optiMVI-LEA-STL\n')
                    FPrintF(fh,'\tmove.l\t#\s,\s\s\n',reg12,reg22,IF reg22[]="_" THEN &null ELSE '(a5)')
                    ->FIXME:IF mnem4[]=" TST" THEN advancelines(3)
                    advancelines(2)
                    optim := TRUE
                ENDSELECT
              ENDIF
            CASE " CMP" ->optimize IF a<1 THEN
              IF UWord(mnem3)=" B"
  DBPrintF(fh,';optiMVI-CMP-Bcc\n')
                FPrintF(fh,'\tcmpi.l\t#\s,\s\n',reg12,reg21)
                advancelines(1)
                optim := TRUE
              ELSEIF UWord(mnem3)=" S"
  DBPrintF(fh,';optiMVI-CMP-Scc\n')

                FPrintF(fh,'\tcmpi.l\t#\s,\s\n',reg12,reg21)
                IF (mnem4[]=" NOT") AND (mnem5[]=" TST") ->nextmnem
                  c1:="a"-"A"+UByte(mnem3+2) ; c2:="a"-"A"+UByte(mnem3+3)
                  advancelines(2)
                ELSE
                  SELECT mnem3[]
                    CASE " SLT" ; c1:="g" ; c2:="e"
                    CASE " SLE" ; c1:="g" ; c2:="t"
                    CASE " SGT" ; c1:="l" ; c2:="e"
                    CASE " SGE" ; c1:="l" ; c2:="t"
                    CASE " SEQ" ; c1:="n" ; c2:="e"
                    CASE " SNE" ; c1:="e" ; c2:="q"
                    ->DEFAULT
                  ENDSELECT
                  advancelines(1)
                ENDIF
                optim := TRUE
                IF mnem3[]=" TST"
  DBPrintF(fh,';optiMVI-CMP-SET-TST\n')
                  FPrintF(fh,'\tb\c\c\t\s\n',c1,c2,reg41)
                  advancelines(3)
                ENDIF
              ENDIF
            CASE " PSH" ->e.g. func(1)
              IF reg11[1]=reg21[1]
                IF (mnem3[]=" POP")
                  IF reg11[1]=reg21[1]
    DBPrintF(fh,';optiMVI-PSH-POP2\n')
                    FPrintF(fh,'\tmove.l\t#\s,\s\n',reg12,reg31)
                    advancelines(2)
                    optim := TRUE
                  ENDIF
                ELSE
    DBPrintF(fh,';optiMVI-PSH\n')
                  FPrintF(fh,'\tmove.l\t#\s,-(a7)\n',reg12)
                  advancelines(1)
                  optim := TRUE
                ENDIF
              ENDIF
            CASE " MVR" ->optimize PrintF('Hello')
              IF (UWord(reg11)=UWord(reg22))
    DBPrintF(fh,';optiMVI-MVR:\s\n',reg21)
                IF (reg21[]="f")
                  float :=TRUE
                  FPrintF(fh,'\tmove.l\t#\s,d\c\n',reg12,reg21[2])
                  FPrintF(fh,'\tfmove.s\td\c,fp\c\n',reg21[2],reg22[1])
                  pos := nextmnem(mnem2)-1
                  advancelines(1)
                ELSE
                  ->make a "fake" line to possibly optimize further
                  StringF(preline,' MVI \s \s\n',reg21,reg12)
                  copyprec()
                ENDIF

                optim := TRUE
              ENDIF
          ENDSELECT
          IF optim=FALSE
            IF reg11[]="f"
              FPrintF(fh,'\tmove.l\t#\s,d\c\n',reg12,reg11[2])
              FPrintF(fh,'\tfmove.s\td\c,fp\c\n',reg11[2],reg11[2])
            ELSE
              FPrintF(fh,'\tmove.l\t#\s,\s\n',reg12,reg11)
              IF float THEN FPrintF(fh,'\tfmove.s\t\s,fp\c\n',reg11,reg11[1])
            ENDIF
          ENDIF
ENDPROC

PROC trans_LEA()
          SELECT mnem2[]
            CASE " LDL"
              IF (reg21[]="d") OR (reg21[]="f")
DBPrintF(fh,';optiLEA-LDL;\c\c\c\c-\n',UByte(mnem2),UByte(mnem2+1),UByte(mnem2+2),UByte(mnem2+3))
                IF (mnem4[]<>" STL") OR ((mnem4[]=" STL") AND /*(mnem3[]<>" LDL") AND ((UWord(11)<>UWord(reg42)) OR (UWord(21)<>UWord(reg41))))->*/(mnem3[]=" LEA"))
                  IFN float
    DBPrintF(fh,';optiLEA-LDL-LEA/MVI/STL/PSH/I2F/TST/MVR=MVL \s \s\n',reg21,reg12)
                    ->make a "fake" line to possibly optimize further
                    StringF(preline,' MVL \s \s\n',reg21,reg12)
                    copyprec()
                    optim := TRUE
                  ELSEIF reg12[]<>"_"
    DBPrintF(fh,';optiLEA-LDL:float\n')
                    FPrintF(fh,'\tfmove.s\t\s(a5),fp\c\n',reg12,reg21[1])
                    float:=TRUE
                    advancelines(1)
                    optim := TRUE
                  ENDIF
                ENDIF
              ELSEIF reg21[]="a"
  DBPrintF(fh,';optiLEA-LDL\n')
                ->FIXME: oppure diventa MVL
                FPrintF(fh,'\tmovea.l\t\s\s,\s\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg21)
                advancelines(1)
                optim := TRUE
              ENDIF
            CASE " STL" ->optimize a:=b+c
              IF mnem3[]<>" PSH"
  DBPrintF(fh,';optiLEA-STL:\d \s \s\n',float,reg21,reg12)
                IF float
                  FPrintF(fh,'\t\smove\s\tfp\c,\s\s\n',pre,post1,reg21[1],reg12,IF reg12[]="_" THEN &null ELSE '(a5)')
                ELSE
                  FPrintF(fh,'\t\smove\s\t\s,\s\s\n',pre,post1,reg21,reg12,IF reg12[]="_" THEN &null ELSE '(a5)')
                ENDIF
                float:=FALSE
                advancelines(1)
                optim := TRUE
              ENDIF
            CASE " INC" ->optimize a++
              IF StrCmp(reg12,reg22)
  DBPrintF(fh,';optiLEA-INC\n')
                optim := TRUE
              ENDIF

            ->DEFAULT
          ENDSELECT

          IF optim=FALSE
    DBPrintF(fh,';optiLEA-def\n')
            FPrintF(fh,'\tlea\t\s\s,\s\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg11)
          ENDIF

ENDPROC

PROC trans_MVL()
          SELECT mnem2[]
            CASE " LEA" ->optimize a:=b
              IF mnem3[]=" STL"
                IF (reg21[1]=reg11[1]) AND (mnem4[]<>" LEA") AND (mnem5[]<>" STL") AND (mnem5[]<>" CMP") AND (mnem5[]<>" MPP")
    DBPrintF(fh,';optiMVL-LEA-STL\n')
                  FPrintF(fh,'\tmove.l\t\s\s,\s\s\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg22,IF reg22[]="_" THEN &null ELSE '(a5)')
                  advancelines(2)
                  optim := TRUE
                ENDIF
              ENDIF

            CASE " STL" ->optimize [a,b]
              IF reg21[1]=reg11[1]
                IF (mnem4[]<>" CMP") AND (mnem5[]<>" CMP")
                  IF (mnem3[]=" ADA") AND (mnem4[]<>" ADA") AND (UWord(reg22)=UWord(reg31)) AND (reg32[]="4")
    DBPrintF(fh,';optiMVL-STL-ADA\n')
                    FPrintF(fh,'\tmove.l\t\s\s,(\s)+\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg22)
                    advancelines(2)
                  ELSE
    DBPrintF(fh,';optiMVL-STL\n')
                    FPrintF(fh,'\tmove.l\t\s\s,(\s)\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg22)
                    advancelines(1)
                  ENDIF
                  optim := TRUE
                ENDIF
              ENDIF

            CASE " ADD", " SUB", " MUL", " DIV" ->optimize a:=b+c
              IF reg21[1]<reg22[1]
      DBPrintF(fh,';optiMVL-\c\c\c\c-\n',UByte(mnem2),UByte(mnem2+1),UByte(mnem2+2),UByte(mnem2+3))
                SELECT mnem2[]
                  CASE " ADD" ; FPrintF(fh,'\tadd.l\t\s\s,\s\n' ,reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg21)
                  CASE " SUB" ; FPrintF(fh,'\tsub.l\t\s\s,\s\n' ,reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg21)
                  CASE " MUL" ; FPrintF(fh,'\tmuls.l\t\s\s,\s\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg21)
                  CASE " DIV" ; FPrintF(fh,'\tdivs.l\t\s\s,\s\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg21)
                ENDSELECT

                advancelines(1)
                optim := TRUE
              ENDIF

            CASE " PSH" ->optimize func(a)
  DBPrintF(fh,';optiMVL-PSH:\s,\s,\d\n',reg11,reg21,float)
              IF (UWord(reg11)=UWord(reg21)) AND (mnem3[]<>" TST") AND (mnem3[]<>" F2I") AND (mnem3[]<>" PSH") AND (float=FALSE)
  DBPrintF(fh,';optiMVL-PSH\n')
                ->FIXME:IF mnem3[]=" F2I" THEN FPrintF(move.l -(a7))
                ->make a "fake" line to possibly optimize further
                StringF(preline,' PSH \s\s\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)')
                copyprec()
                optim := TRUE
              ENDIF
 
            CASE " MVR" ->optimize StrCopy(a,b,StrLen(b))
              IF (float=FALSE) AND (UWord(reg21)<>"fp")
  DBPrintF(fh,';optiMVL-MVR\n')
                  FPrintF(fh,'\tmove.l\t\s\s,\s\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg21)
                  advancelines(1)
                  optim := TRUE
              ENDIF

            CASE " TST" ->optimize IF a
  DBPrintF(fh,';optiMVL-TST\n')
              IF float=FALSE
                FPrintF(fh,'\t\smove\s\t\s\s,\s\n',pre,post1,reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg11)
                advancelines(1)
                optim := TRUE
              ENDIF
              
            CASE " CMP" ->optimize IF a>b or FOR a:=0 TO
              IF float=FALSE
  DBPrintF(fh,';optiMVL-CMP\n')
                FPrintF(fh,'\tcmp.l\t\s\s,\s\n',reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg21)
                optim := TRUE
                IF (UWord(mnem3)=" S") AND
                   ((mnem4[]=" TST") OR (mnem5[]=" TST")) AND
                   (mnem4[]<>" AND") AND (mnem4[]<>" ORL") AND (mnem4[]<>" XOR") AND (mnem4[]<>" NOT")

                  IF (mnem4[]=" NOT") AND (mnem5[]=" TST")
                    c1:="a"-"A"+UByte(mnem3+2) ; c2:="a"-"A"+UByte(mnem3+3)
                    advancelines(2)
                  ELSE
                    SELECT mnem3[]
                      CASE " SLT" ; c1:="g" ; c2:="e"
                      CASE " SLE" ; c1:="g" ; c2:="t"
                      CASE " SGT" ; c1:="l" ; c2:="e"
                      CASE " SGE" ; c1:="l" ; c2:="t"
                      CASE " SEQ" ; c1:="n" ; c2:="e"
                      CASE " SNE" ; c1:="e" ; c2:="q"
                      ->DEFAULT
                    ENDSELECT
                    advancelines(1)
                  ENDIF
                  IF mnem3[]=" TST"
    DBPrintF(fh,';optiMVL-CMP-SET-TST\n')
                    FPrintF(fh,'\tb\c\c\t\s\n',c1,c2,reg41)
                    advancelines(2)
                  ENDIF
                ENDIF
                advancelines(1)
                    
              ENDIF
            DEFAULT ; optim := FALSE
          ENDSELECT

          IF optim=FALSE THEN FPrintF(fh,'\t\smove\s\t\s\s,\s\n',pre,post1,reg12,IF reg12[]="_" THEN &null ELSE '(a5)',reg11)
ENDPROC

PROC trans_MVR()
          SELECT mnem2[]

            CASE " PSH" ->optimize PrintF('Hello')
              IF (UWord(reg11)=UWord(reg21)) AND (mnem3[]<>" F2I") AND (mnem3[]<>" PSH") ->PSH d0 is used also when calling methods
    DBPrintF(fh,';optiMVR-PSH;\c\c\c\c-\n',UByte(mnem2),UByte(mnem2+1),UByte(mnem2+2),UByte(mnem2+3))
                IF (float=TRUE) AND (reg11[]="f")
                  StringF(reg11,'d\c',reg11[2])
                  float := FALSE
                ENDIF
                ->make a "fake" line to possibly optimize further
                StringF(preline,' PSH \s\n',reg12)
                copyprec()
                optim := TRUE
              ENDIF

            CASE " LEA" ->optimize a:=&b
              IF mnem3[]=" STL"
                IF (mnem5[]<>" CMP") AND (mnem6[]<>" CMP") AND ((mnem4[]<>" TST") OR ((mnem4[]=" TST") AND (StrCmp(reg11,reg41)=0) ))
    DBPrintF(fh,';optiMVR-LEA-STL\n')
                  FPrintF(fh,'\t\smove\s\t\s,\s\s\n',pre,post1,reg12,reg22,IF reg22[]="_" THEN &null ELSE '(a5)')
                  advancelines(2)
                  optim := TRUE
                ENDIF
              ENDIF

            CASE " MVR" ->optimize PrintF(a,b)
              IF (UWord(reg11)=UWord(reg21)) AND (UWord(reg12)=UWord(reg22))
    DBPrintF(fh,';optiMVR-MVR:11=22,12=22\n')
                advancelines(1)
                optim := TRUE
              ELSEIF (UWord(reg11)=UWord(reg22)) AND (UWord(reg12)=UWord(reg21))
    DBPrintF(fh,';optiMVR-MVR:11=22,12=21\n')
                advancelines(1)
                optim := TRUE
              ELSEIF (UWord(reg11)=UWord(reg22))
    DBPrintF(fh,';optiMVR-MVR:11=22\n')
                ->make a "fake" line to possibly optimize further
                StringF(preline,' MVR \s \s\n',reg21,reg12)
                copyprec()
                optim := TRUE
              ENDIF

            DEFAULT ; optim := FALSE
          ENDSELECT
          IF optim=FALSE
      DBPrintF(fh,';optiMVR-def:\s:\s\n',reg11,reg12)
            IF UWord(reg11)="fp" THEN float:=TRUE
            IF (UWord(reg11)=UWord(reg12)) AND (float=FALSE)
      DBPrintF(fh,';optiMVR-def-=:\s:\s\n',reg11,reg12)
            ELSEIF float
              IF StrCmp(reg11,reg12)
      DBPrintF(fh,';optiMVR-def-float:\s:\s\n',reg11,reg12)
              ELSE
                FPrintF(fh,'\tfmove.s\t\s,\s\n',reg12,reg11)
              ENDIF
            ELSE
              FPrintF(fh,'\t\smove\s\t\s,\s\n',pre,post1,reg12,reg11)
            ENDIF
          ENDIF
ENDPROC

PROC trans_LDL()
          optim := FALSE
          IF float
     DBPrintF(fh,';optiLDL-float:\d,\s,\s\n',float,reg11,reg22)
            IF mnem2[]=" MVR" ->e.g. f:=!Ftan(.8)
              IF reg11[2]=reg22[1]
      DBPrintF(fh,';optiLDL-MVR-float \s \s \s \s\n',reg11,reg12,reg21,reg22)
                FPrintF(fh,'\tfmove.s\t(\s),\s\n',reg12,reg21)
                advancelines(1)
                optim := TRUE
              ENDIF
            ELSE
              FPrintF(fh,'\tfmove.s\t(\s),\s\n',reg12,reg11)
            ENDIF
          ELSE
            
            SELECT mnem2[]

              CASE " LEA" ->optimize a:=b[]
                IF mnem3[]=" STL"
                  IF (mnem5[]<>" CMP") AND (mnem6[]<>" CMP") AND (mnem5[]<>" STL")
      DBPrintF(fh,';optiLDL-LEA-STL\n')
                    FPrintF(fh,'\tmove.l\t(\s),\s\s\n',reg12,reg22,IF reg22[]="_" THEN &null ELSE '(a5)')
                    advancelines(2)
                    optim := TRUE
                  ENDIF
                ENDIF
              CASE " STL" ->a:=:b
                IF UWord(reg11)=UWord(reg21)
      DBPrintF(fh,';optiLDL-STL\n')
                  FPrintF(fh,'\tmove.l\t(\s),(\s)\n',reg12,reg22)
                  advancelines(1)
                  optim := TRUE
                ENDIF
              CASE " ADD", " SUB", " MUL", " DIV"-> optimize a:=b+c[]
                IF (UWord(reg11)=UWord(reg22)) AND (float=FALSE)
      DBPrintF(fh,';optiLDL-MTH\n')
                  SELECT mnem2[]
                    CASE " ADD" ; FPrintF(fh,'\tadd.l\t(\s),\s\n' ,reg12,reg21)
                    CASE " SUB" ; FPrintF(fh,'\tsub.l\t(\s),\s\n' ,reg12,reg21)
                    CASE " MUL" ; FPrintF(fh,'\tmuls.l\t(\s),\s\n',reg12,reg21)
                    CASE " DIV" ; FPrintF(fh,'\tdivs.l\t(\s),\s\n',reg12,reg21)
                  ENDSELECT
                  advancelines(1)
                  optim := TRUE
                ENDIF
              CASE " PSH" ->optimize func(a[])
                IF (UWord(reg11)=UWord(reg21)) AND (mnem3[]<>" TST") AND (mnem3[]<>" F2I") AND (mnem3[]<>" PSH") AND (float=FALSE)
    DBPrintF(fh,';optiLDL-PSH\n')
                  ->FIXME:IF mnem3[]=" F2I" THEN FPrintF(move.l -(a7))
                  ->make a "fake" line to possibly optimize further
                  StringF(preline,' PSH (\s)\n',reg12)
                  copyprec()
                  optim := TRUE
                ENDIF
              ->DEFAULT ; FPrintF(fh,'\tmove.l\t(\s),\s\n',reg12,reg11)
            ENDSELECT
            IF optim=FALSE THEN FPrintF(fh,'\tmove.l\t(\s),\s\n',reg12,reg11)

          ENDIF
ENDPROC

PROC trans_ADA()
  DEF mnem7:PTR TO LONG

  DBPrintF(fh,';optiADA\n')
          optim := FALSE
          IF reg12[]="d"
            SELECT mnem2[]
              CASE " STL"," STW"," STB" ->optimize a[b]:=0
  DBPrintF(fh,';optiADA-ST\n')
                FPrintF(fh,'\tmove.\c\t\s,(\s,\s)\n',"a"-"A"+UByte(mnem2+3),reg21,reg11,reg12)
                advancelines(1)
              CASE " LDL"," LDW"," LDB" ->optimize IF a[b]
  DBPrintF(fh,';optiADA-LD\n')
                IF (mnem2[]=" LDL") AND (mnem3[]=" LEA") AND (mnem4[]=" STL") ->optimize a:=b[c]
                  mnem7 := nextmnem(mnem6)
                  IF (mnem6[]<>" CMP") AND (mnem7[]<>" CMP")
    DBPrintF(fh,';optiADA-LDL-LEA-STL\n')
                    FPrintF(fh,'\tmove.l\t(\s,\s),\s\s\n',reg11,reg12,reg32,IF reg32[]="_" THEN &null ELSE '(a5)')
                    IF mnem5[]=" TST" THEN advancelines(1)
                    advancelines(3)
                    optim := TRUE
                  ENDIF
                ELSE
                  SELECT mnem4[]
                    CASE " ADD", " SUB", " MUL", " MLI", " DIV", " NEG", " SHR", " SHL", " AND", " ORL", " NOT" ->DO NOT optimize
                      FPrintF(fh,'\tadda.l\t\s,\s\n',reg12,reg11)
                      optim := FALSE
                    DEFAULT
                      FPrintF(fh,'\tmove.\c\t(\s,\s),\s\n',"a"-"A"+UByte(mnem2+3),reg11,reg12,reg21)
                      IF mnem3[]=" TST" THEN advancelines(1)
                      optim := TRUE
                  ENDSELECT
                ENDIF
                IF optim THEN advancelines(1)
              DEFAULT ; FPrintF(fh,'\tadda.l\t\s,\s\n',reg12,reg11)
            ENDSELECT
          ELSE
     DBPrintF(fh,';ADA-#\n') ->ex. x.a
            SELECT mnem2[]
              CASE " LDL"
                SELECT mnem3[]

                  CASE " STL" ->optimize PrintF(a,b[1])
                    IF (mnem5[]<>" CMP") AND (mnem6[]<>" CMP") AND (UWord(reg21)=UWord(reg31))
      DBPrintF(fh,';optiADA-LDL-STL,\d,\s\n',reg12[],reg12)
                      IF (mnem4[]=" ADA") AND (mnem5[]<>" ADA") AND (UWord(reg32)=UWord(reg41)) AND (reg42[]="4")
                        FPrintF(fh,'\tmove.l\t\s(\s),(\s)+\n',IF reg12[]="0" THEN null ELSE reg12,reg11,reg32)
                        advancelines(1)
                      ELSE
                        FPrintF(fh,'\tmove.l\t\s(\s),(\s)\n',IF reg12[]="0" THEN null ELSE reg12,reg11,reg32)
                      ENDIF
                      advancelines(2)
                      optim := TRUE
                    ENDIF

                  CASE " LEA" ->optimize a:=b[1]
                    IF mnem4[]=" STL"
                      mnem7 := nextmnem(mnem6)
                      IF (mnem6[]<>" CMP") AND (mnem7[]<>" CMP")
        DBPrintF(fh,';optiADA-LDL-LEA-STL\n')
                        FPrintF(fh,'\tmove.l\t\s(\s),\s\s\n',IF reg12[]="0" THEN null ELSE reg12,reg11,reg32,IF reg32[]="_" THEN &null ELSE '(a5)')
                        IF mnem5[]=" TST" THEN advancelines(1)->pos:=mnem2-1
                        advancelines(3)
                        optim := TRUE
                      ENDIF
                    ENDIF

                  CASE " ADD"," SUB"," MUL"," DIV" ->optimize x.a +=1 or x[1] +=1
                    IF float=FALSE
                      IF (mnem4[]=" STL") AND ((UByte(mnem5)=";") OR (UByte(mnem5)=":") OR (mnem5[]=" F2I"))
                DBPrintF(fh,';optiADA-LDL-MTH-STL\n')
                        optim:=TRUE
                        SELECT mnem3[]
                          CASE " ADD" ; FPrintF(fh,'\tadd.l\t\s,\s(\s)\n' ,reg32,IF reg12[]="0" THEN null ELSE reg12,reg42)
                          CASE " SUB" ; FPrintF(fh,'\tsub.l\t\s,\s(\s)\n' ,reg32,IF reg12[]="0" THEN null ELSE reg12,reg42)
                          ->CASE " MUL" ; ->unsupported by 68000
                          ->CASE " DIV" ; ->unsupported by 68000
                          DEFAULT ; optim:=FALSE
                        ENDSELECT
                        IF optim
                          advancelines(3)
                        ELSE
                          IF reg12[]<>"0" THEN FPrintF(fh,'\tadda.l\t#\s,\s\n',reg12,reg11)
                          RETURN
                        ENDIF
                        
                      ELSEIF (UWord(reg21)=UWord(reg32)) AND (float=FALSE)-> optimize a:=b+c[1]
            DBPrintF(fh,';optiADA-LDL-MTH\n')
                        SELECT mnem3[]
                          CASE " ADD" ; FPrintF(fh,'\tadd.l\t\s(\s),\s\n' ,IF reg12[]="0" THEN null ELSE reg12,reg22,reg31)
                          CASE " SUB" ; FPrintF(fh,'\tsub.l\t\s(\s),\s\n' ,IF reg12[]="0" THEN null ELSE reg12,reg22,reg31)
                          CASE " MUL" ; FPrintF(fh,'\tmuls.l\t\s(\s),\s\n',IF reg12[]="0" THEN null ELSE reg12,reg22,reg31)
                          CASE " DIV" ; FPrintF(fh,'\tdivs.l\t\s(\s),\s\n',IF reg12[]="0" THEN null ELSE reg12,reg22,reg31)
                        ENDSELECT
                        advancelines(2)
                        optim := TRUE
                      ENDIF
                    ENDIF
                  CASE " TST" ->optimize ex. IF x.a
                    IF reg31[1]=reg11[1]
          DBPrintF(fh,';optiADA-LDL-TST\n') ->
                      FPrintF(fh,'\ttst.l\t\s(\s)\n',IF reg12[]="0" THEN null ELSE reg12,reg11)
                      advancelines(2)
                      optim:=TRUE
                    ENDIF
                  CASE " PSH" ->optimize func(a[1])
                    IF (UWord(reg21)=UWord(reg31)) AND (mnem4[]<>" TST") AND (mnem4[]<>" F2I") AND (mnem4[]<>" PSH") AND (float=FALSE)
        DBPrintF(fh,';optiADA-LDL-PSH\n')
                      ->FIXME:IF mnem3[]=" F2I" THEN FPrintF(move.l -(a7))
                      ->make a "fake" line to possibly optimize further
                      StringF(preline,' PSH \s(\s)\n',reg12,reg22)
                      advancelines(1)
                      copyprec()
                      optim := TRUE
                    ENDIF
                  ->DEFAULT
                ENDSELECT
                IF (optim=FALSE) AND (mnem3[]<>" LDL") AND (mnem3[]<>" LDW") AND (mnem3[]<>" LDB")
      DBPrintF(fh,';optiADA-LDL\n')
                  FPrintF(fh,'\tmove.l\t\s(\s),\s\n',IF reg12[]="0" THEN null ELSE reg12,reg11,reg21)
                  advancelines(1)
                  optim := TRUE
                ENDIF
              CASE " LDW"," LDB"
      DBPrintF(fh,';ADA-LDW/LDB,\d\n',optim) ->ex. x.a:=b or a:=b[1]
                SELECT mnem4[]
                  ->CASE " STL" ->cannot optimize because of EXW/AND

                  CASE " ADD"," SUB" ->optimize x.a +=1 or a[1] += 1
                    IF ((mnem5[]=" STW") OR (mnem5[]=" STB")) AND ((UByte(mnem6)=";") OR (UByte(mnem6)=":") OR (mnem6[]=" F2I"))
              DBPrintF(fh,';optiADA-LDW/LDB-ADD/SUB-STW/STB\n')
                      IF mnem4[]=" ADD"
                        FPrintF(fh,'\tadd.\c\t\s,\s(\s)\n',IF mnem2[]=" LDW" THEN "w" ELSE "b",reg42,IF reg12[]="0" THEN null ELSE reg12,reg52)
                      ELSEIF mnem4[]=" SUB"
                        FPrintF(fh,'\tsub.\c\t\s,\s(\s)\n',IF mnem2[]=" LDW" THEN "w" ELSE "b",reg42,IF reg12[]="0" THEN null ELSE reg12,reg52)
                      ENDIF
                      advancelines(4)
                      optim:=TRUE
                    ENDIF
                  CASE " TST" ->optimize ex. IF x.a
                    IF reg31[1]=reg11[1]
          DBPrintF(fh,';optiADA-LDW/LDB-TST\n') ->
                      FPrintF(fh,'\ttst.\c\t\s(\s)\n',"a"-"A"+UByte(mnem3+3),IF reg12[]="0" THEN null ELSE reg12,reg11)
                      advancelines(3)
                      optim:=TRUE
                    ENDIF

                  DEFAULT
                    SELECT mnem4[]
                      CASE " ADD", " SUB", " MUL", " MLI", " DIV", " NEG", " SHR", " SHL", " AND", " ORL", " NOT" ->DO NOT optimize
                        optim := FALSE
                      DEFAULT
          DBPrintF(fh,';ADA-LDW/LDB\n')
                        IF mnem2[]=" LDB"
                          IF ((mnem4[]<>" STB") AND (mnem5[]<>" STB")) OR ((mnem4[]=" STB") AND (UWord(reg22)<>UWord(reg42)))
                            FPrintF(fh,'\tmove.b\t\s(\s),\s\n',IF reg12[]="0" THEN null ELSE reg12,reg11,reg21)
                            advancelines(1)
                            optim:=TRUE
                          ENDIF
                        ELSEIF mnem2[]=" LDW"
                          IF ((mnem4[]<>" STW") AND (mnem5[]<>" STW")) OR ((mnem4[]=" STW") AND (UWord(reg22)<>UWord(reg42)))
                            FPrintF(fh,'\tmove.w\t\s(\s),\s\n',IF reg12[]="0" THEN null ELSE reg12,reg11,reg21)
                            advancelines(1)
                            optim:=TRUE
                          ENDIF
                        ENDIF
                      
                  ENDSELECT
                ENDSELECT

              CASE " ADA"
                ->make a "fake" line to possibly optimize further
                c1 := Val(reg12)+Val(reg22)
    DBPrintF(fh,';optiADA-ADA:\d\n',c1)
                StringF(preline,' ADA \s \d\n',reg11,c1)
                copyprec()
                optim := TRUE

              CASE " SBA"
                IF Val(reg12)=Val(reg22)
    DBPrintF(fh,';optiADA-SBA:\s=\s:\n',reg12,reg22)
                  advancelines(1)
                  optim := TRUE
                ELSEIF UWord(reg11)=UWord(reg21)
    DBPrintF(fh,';optiADA-SBA:\s<>\s:\n',reg12,reg22)
                  c1 := Val(reg12)-Val(reg22)
                  FPrintF(fh,'\tadda.l\t#\d,\s\n',c1,reg11)
                  advancelines(1)
                  optim := TRUE
                ENDIF

              CASE " STL"," STB"," STW" ->optimize a[1]:=0
                IF (mnem4[]<>" CMP") AND (mnem5[]<>" CMP")
    DBPrintF(fh,';optiADA-STL/STW/STB\n')
                  c2 := "a"-"A"+UByte(mnem2+3)
                  FPrintF(fh,'\tmove.\c\t\s,\s(\s)\n',c2,reg21,IF reg12[]="0" THEN null ELSE reg12,reg22)
                  advancelines(1)
                  optim := TRUE
                ENDIF

            ENDSELECT
            IF optim=FALSE THEN IF reg12[]<>"0" THEN FPrintF(fh,'\tadda.l\t\s\s,\s\n',IF reg12[]="d" THEN null ELSE '#',reg12,reg11)
          ENDIF
ENDPROC

PROC copyprec()
  len := StrLen(preline)
  mnem2 := mnem3-len
  CopyMem(preline,mnem2,len)
  setregs(mnem2,reg21,reg22)
ENDPROC

PROC advancelines(lines)
  DEF mnemt
  WHILE lines
    mnemt:=nextmnem(mnem6)
    setregs(mnemt,regt1,regt2)
    mnem1:=mnem2 ; reg11:=reg21 ;  reg12:=reg22
    IF (float=TRUE)
      IF (reg11[]="d") AND (reg11[2]=0)
        reg11[2]:=reg11[1] ; reg11[3]:=0 ; reg11[]:="f" ; reg11[1] := "p"
      ENDIF
      IF (reg12[]="d") AND (reg12[2]=0)
        reg12[2]:=reg12[1] ; reg12[3]:=0 ; reg12[]:="f" ; reg12[1] := "p"
      ENDIF
    ENDIF
    mnem2:=mnem3 ; reg21:=reg31 ;  reg22:=reg32
    mnem3:=mnem4 ; reg31:=reg41 ;  reg32:=reg42
    mnem4:=mnem5 ; reg41:=reg51 ;  reg42:=reg52
    mnem5:=mnem6 ; reg51:=reg61 ;  reg52:=reg62
    mnem6:=mnemt ; reg61:=regt1 ;  reg62:=regt2
    regt1:=reg11 ; regt2:=reg12
    pos:=mnem1
    lines--
  ENDWHILE
ENDPROC

PROC setregs(spos:PTR TO CHAR,sreg11:PTR TO CHAR,sreg12:PTR TO CHAR)(LONG)
  IF spos<end
    IF (spos[]=":") OR (spos[]=";")
      spos++
      spos:=copyuntilspace(spos,sreg11)
      sreg12[]:=0->erase
      RETURN spos
    ENDIF
    IF spos[]=" " THEN spos +=4
    IF (spos[]=" ")
      spos++
      spos:=copyuntilspace(spos,sreg11)
    ELSE
      sreg11[]:=0->erase
    ENDIF
    IF spos[]=" "
      spos++
      spos:=copyuntilspace(spos,sreg12)
    ELSE
      sreg12[]:=0->erase
    ENDIF
  ENDIF
ENDPROC spos

PROC copyuntilspace(spos:PTR TO CHAR,dst:PTR TO CHAR)(LONG)
  DEF n=0

  IF spos[]="\q" ->a quoted string
    WHILE (spos[]<>"\n") AND (spos<end) AND (n<100)
      dst[n] := spos[]++
      n++
    ENDWHILE
  ELSE
    WHILE (spos[]<>"\n") AND (spos<end) AND (n<100) AND (spos[]<>" ")
      dst[n] := spos[]++
      n++
    ENDWHILE
  ENDIF
  dst[n] := 0 ->trailing 0 byte
ENDPROC spos

PROC nextmnem(spos:PTR TO CHAR)(LONG)
    WHILE (spos[]<>"\n") AND (spos<end) DO spos++
    spos++
ENDPROC spos
