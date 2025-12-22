
-> Copyright © 1995, Guichard Damien.

-> Note the use of inheritance hierarchy:
-> Is MC680x0 a specialization of the AME machine or the other way around?
-> As both are universal the question is irrelevant.
-> Don't matter wether the machines are virtual or real.

OPT MODULE

MODULE '*ame','*code'

EXPORT CONST IRTD = $4E74

DEF l_opcode,l_mode,l_source,l_dest
DEF current

EXPORT OBJECT ame_code OF code
ENDOBJECT

-> Generation of all AME instructions.
PROC ame(opcode,mode,source,dest) OF ame_code
  IF l_opcode=I_CALL
    l_opcode:=0
    IF mode=M_REGISTER
      self.generate(opcode,l_mode,l_source,dest)
      RETURN
    ELSE
      self.generate(I_CALL,l_mode,l_source,l_dest)
    ENDIF
  ENDIF
  IF opcode=I_CALL
    IF dest<>R_NONE
      l_opcode:=opcode
      l_mode:=mode
      l_source:=source
      l_dest:=dest
      RETURN
    ENDIF
  ENDIF
  self.generate(opcode,mode,source,dest)
ENDPROC

-> Generate AME code.
PROC generate(opcode,mode,source,dest) OF ame_code
  DEF idata,imode,ireg:PTR TO INT
  -> dump(opcode,mode,source,dest)
  SELECT M_NONE OF mode
  CASE M_TRUE
    idata:=TRUE
    imode:=MODE7
    ireg:=IMM
  CASE M_FALSE
    idata:=FALSE
    imode:=MODE7
    ireg:=IMM
  CASE M_VOID
    idata:=NIL
    imode:=MODE7
    ireg:=IMM
  CASE M_CURRENT
    idata:=0
    imode:=ARDIR
    ireg:=0
  CASE M_IMMEDIATE
    idata:=source
    imode:=MODE7
    ireg:=IMM
  CASE M_STRING
    idata:=source
  CASE M_REGISTER
    idata:=0
    imode:=DREG
    ireg:=source
  CASE M_ATTRIBUT
    idata:=source*4
    imode:=ARDISP
    ireg:=current
  CASE M_ARG
    idata:=source*4+12
    imode:=ARDISP
    ireg:=5
  CASE M_LOCAL
    idata:=-source*4-4
    imode:=ARDISP
    ireg:=5
  CASE M_ROUTINE
    idata:=source-1*4
    imode:=ARDISP
  CASE M_LABEL
    idata:=source
  ENDSELECT
  SELECT I_NONE OF opcode
  CASE I_ADD
    self.putF5(IADD,L,idata,imode,ireg,dest)
  CASE I_AND
    self.putF5(IAND,L,idata,imode,ireg,dest)
  CASE I_ASSIGN
    self.putF4(L,0,DREG,dest,idata,imode,ireg)
  CASE I_CALL
    IF mode=M_ROUTINE
      self.putF4(L,0,ARIND,1,0,ARDIR,2)            ->  move.l  (a1),a2
      self.putF3(IJSR,idata,imode,2)               ->  jsr     d8(a2)
    ELSEIF mode=M_STRING
      self.putF4(L,0,DREG,0,0,ARDIR,2)             ->  move.l  d0,a2
      self.putF7(IADDQ,L,4,0,ARDIR,2)              ->  addq.l  #4,a2
      self.putF2(ILEA,StrLen(idata),MODE7,ABSW,6)  ->  lea     StrLen.w,a6
      self.putF4(L,0,ARDIR,6,0,ARPOST,2)           ->  move.l  a6,(a2)+
      self.putF4(L,0,ARDIR,6,0,ARPOST,2)           ->  move.l  a6,(a2)+
      self.putF2(ILEA,6,MODE7,PCDISP,6)            ->  lea     text(pc),a6
      self.putF4(L,0,ARDIR,6,0,ARPOST,2)           ->  move.l  a6,(a2)+
      self.putword(StrLen(idata)+1 AND $FE OR IBRA)
      self.putbinary(idata,StrLen(idata)+1 AND $FE+idata)
    ELSE
      self.putF4(L,idata,imode,ireg,0,DREG,dest)
    ENDIF
  CASE I_CLASSFIELDS
    self.putlong(idata)
  CASE I_CREATE
    self.global_ref(idata)
    self.putF2(ILEA,0,MODE7,PCDISP,2)         ->  lea     class(pc),a2
    self.putF4(L,$20,ARDISP,4,0,ARDIR,6)      ->  move.l  $20(a4),a6
    self.putF3(IJSR,0,ARIND,6)                ->  jsr     (a6)
  CASE I_CURRENT
    IF mode=M_NONE
      current:=0
    ELSE
      self.putF4(L,idata,imode,ireg,0,ARDIR,1)
      current:=1
    ENDIF
  CASE I_DIV
    self.putF2(IDIVS,idata,imode,ireg,dest)
  CASE I_ENDROUTINE
    self.putword(IUNLK OR 5)
    self.putF4(L,0,ARPOST,7,0,ARDIR,0)
    self.putword(IF idata THEN IRTS ELSE IRTD)
    IF idata THEN self.putword(idata*SIZEOF LONG)
    self.resolve_locals()
  CASE I_EQUAL
    self.putF5(ICMP,L,idata,imode,ireg,dest)
    self.putF3(ISEQ,0,DREG,dest)
  CASE I_GREATERTHAN
    self.putF5(ICMP,L,idata,imode,ireg,dest)
    self.putF3(ISGT,0,DREG,dest)
  CASE I_JALWAYS
    self.local_ref(idata)
    self.putword(IBRA)
    self.putword(0)
  CASE I_JFALSE
    self.local_ref(idata)
    self.putword(IBEQ)
    self.putword(0)
  CASE I_JTRUE
    self.local_ref(idata)
    self.putword(IBNE)
    self.putword(0)
  CASE I_LABEL
    self.define_local(idata)
  CASE I_LESSTHAN
    self.putF5(ICMP,L,idata,imode,ireg,dest)
    self.putF3(ISLT,0,DREG,dest)
  CASE I_LINK
    self.global_ref(idata)
    self.putword(IBRA)
    self.putword(0)
  CASE I_LOCALS
    self.putword(IMOVEQ)
    FOR ireg:=1 TO idata
      self.putF4(L,0,DREG,0,0,ARPRE,SP)
    ENDFOR
  CASE I_MOD
    self.putF2(IDIVS,idata,imode,ireg,dest)
    self.putword(ISWAP OR dest)
    self.putword(IEXTL OR dest)
  CASE I_MUL
    self.putF2(IMULS,idata,imode,ireg,dest)
  CASE I_NEG
    self.putF1(INEG,L,0,DREG,dest)
  CASE I_NOT
    self.putF1(INOT,L,0,DREG,dest)
  CASE I_NOTEQUAL
    self.putF5(ICMP,L,idata,imode,ireg,dest)
    self.putF3(ISNE,0,DREG,dest)
  CASE I_NOTGREATER
    self.putF5(ICMP,L,idata,imode,ireg,dest)
    self.putF3(ISLE,0,DREG,dest)
  CASE I_NOTLESS
    self.putF5(ICMP,L,idata,imode,ireg,dest)
    self.putF3(ISGE,0,DREG,dest)
  CASE I_OR
    self.putF5(IOR,L,idata,imode,ireg,dest)
  CASE I_POPREGS
    IF idata=1
      self.putF4(L,0,ARPOST,7,0,DREG,1)
    ELSE
      self.putword($4CDF)
      ireg:=[$0002,$0006,$000E,$001E,$003E,$007E,$00FE]:INT
      self.putword(ireg[idata-1])
    ENDIF
  CASE I_PUSH
    self.putF4(L,idata,imode,ireg,0,ARPRE,SP)
  CASE I_PUSHREGS
    IF idata=1
      self.putF4(L,0,DREG,1,0,ARPRE,7)
    ELSE
      self.putword($48E7)
      ireg:=[$4000,$6000,$7000,$7800,$7C00,$7E00,$7F00]:INT
      self.putword(ireg[idata-1])
    ENDIF
  CASE I_ROUTINE
    self.define_global(idata)
    self.putF4(L,0,ARDIR,0,0,ARPRE,7)
    self.putF4(L,0,ARDIR,1,0,ARDIR,0)
    self.putword(ILINK OR 5)
    self.putword(0)
  CASE I_SUB
    self.putF5(ISUB,L,idata,imode,ireg,dest)
  CASE I_TABLE
    self.define_global(idata)
  CASE I_XOR
    self.putF4(L,idata,imode,ireg,0,DREG,0)
    self.putF5(IEOR,L,0,DREG,dest,0)
  ENDSELECT
ENDPROC

-> Dump AME code.
PROC dump(opcode,mode,source,dest)
  DEF mnemo:PTR TO LONG,modes:PTR TO LONG
  mnemo:=['ADD\t\t','AND\t\t','ASSIGN\t\t','CALL\t\t','CLASSFIELDS\t',
          'CREATE\t\t','CURRENT\t\t','DIV\t\t','ENDROUTINE\t','EQUAL\t\t',
          'GREATERTHAN\t','JALWAYS\t\t.','JFALSE\t\t.','JTRUE\t\t.',
          'LABEL\t\t.','LESSTHAN\t','LINK\t\t','LOCALS\t\t','MOD\t\t',
          'MUL\t\t','NEG\t\t','NOT\t\t','NOTEQUAL\t','NOTGREATER\t',
          'NOTLESS\t\t','OR\t\t','POPREGS\t\t','PUSH\t\t','PUSHREGS\t',
          'ROUTINE\t\t','SUB\t\t','TABLE\t\t','XOR\t\t']
  modes:=['true','false','Void','','Current','',
          'R','Attribut ','Arg ','Local ','Routine ','L','']
  VfPrintf(stdout,'\s\s',[mnemo[opcode],modes[mode]])
  IF mode=M_STRING THEN VfPrintf(stdout,'"\s"',[source])
  IF mode>M_CURRENT THEN VfPrintf(stdout,'\d',[source])
  IF dest<>R_NONE THEN
    VfPrintf(stdout,'\sR\d',
      [IF mode=M_NONE THEN '' ELSE ', ', dest])
  FputC(stdout,10)
ENDPROC

