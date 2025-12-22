
-> Copyright © 1995, Guichard Damien.

-> New style of MC680x0 code generation
-> This version is stricly limited to 68000 code
-> Generators for abstract machines are derived from this by inheritance
-> Two label range levels are provided: local range and global range

OPT MODULE
OPT EXPORT

MODULE 'dos/doshunks'

->  Condition codes
ENUM   T, F, HI, LS, CC, CS, NE, EQ, VC, VS, PL, MI, GE, LT, GT, LE

-> Instruction mnemonics

CONST  XBCC   = $6000,  XDBCC  = $50C8,  XSCC   = $50C0

CONST  IADD   = $D000,  IADDI  = $0600,  IADDQ  = $5000,  IAND   = $C000,
       IANDI  = $0200,  IASL   = $E100,  IASR   = $E000,  IBCC   = $6400,
       IBCLR  = $0080,  IBCS   = $6500,  IBEQ   = $6700,  IBGE   = $6C00,
       IBGT   = $6E00,  IBHI   = $6200,  IBLE   = $6F00,  IBLS   = $6300,
       IBLT   = $6D00,  IBMI   = $6B00,  IBNE   = $6600,  IBPL   = $6A00,
       IBRA   = $6000,  IBSET  = $00C0,  IBSR   = $6100,  IBTST  = $0000,
       IBVC   = $6800,  IBVS   = $6900,  ICHK   = $4180,  ICLR   = $4200,
       ICMP   = $B000,  ICMPI  = $0C00,  IDBCC  = $54C8,  IDBCS  = $55C8,
       IDBEQ  = $57C8,  IDBF   = $51C8,  IDBGE  = $5CC8,  IDBGT  = $5EC8,
       IDBHI  = $52C8,  IDBLE  = $5FC8,  IDBLS  = $53C8,  IDBLT  = $5DC8,
       IDBMI  = $5BC8,  IDBNE  = $56C8,  IDBPL  = $5AC8,  IDBRA  = $50C8,
       IDBT   = $50C8,  IDBVC  = $58C8,  IDBVS  = $59C8,  IDIVS  = $81C0,
       IEOR   = $B100,  IEORI  = $0A00,  IEXG   = $C140,  IEXTW  = $4880,
       IEXTL  = $48C0,  IJMP   = $4EC0,  IJSR   = $4E80,  ILEA   = $41C0,
       ILINK  = $4E50,  ILSL   = $E108,  ILSR   = $E008,  IMOVEQ = $7000,
       IMULS  = $C1C0,  INEG   = $4400,  INOP   = $4E71,  INOT   = $4600,
       IOR    = $8000,  IORI   = $0000,  IPEA   = $4840,  IROL   = $E118,
       IROR   = $E018,  IRTE   = $4E73,  IRTS   = $4E75,  ISCS   = $55C0,
       ISEQ   = $57C0,  ISF    = $51C0,  ISGE   = $5CC0,  ISGT   = $5EC0,
       ISHI   = $52C0,  ISLE   = $5FC0,  ISLS   = $53C0,  ISLT   = $5DC0,
       ISMI   = $5BC0,  ISNE   = $56C0,  ISPL   = $5AC0,  ISRA   = $50C0,
       IST    = $50C0,  ISVC   = $58C0,  ISVS   = $59C0,  ISUB   = $9000,
       ISUBI  = $0400,  ISUBQ  = $5100,  ISWAP  = $4840,  ITRAP  = $4E40,
       ITRAPV = $4E76,  ITST   = $4A00,  IUNLK  = $4E58

-> CPU Registers

ENUM   D_0, D_1, D_2, D_3, D_4, D_5, D_6, D_7
ENUM   A_0, A_1, A_2, A_3, A_4, A_5, A_6, A_7
CONST  SP = A_7

-> Addressing mode flag values

CONST  DREG   = 0, -> Data Register
       ARDIR  = 1, -> Address Register Direct
       ARIND  = 2, -> Address Register Indirect
       ARPOST = 3, -> Address Register with Post-Increment
       ARPRE  = 4, -> Address Register with Pre-Decrement
       ARDISP = 5, -> Address Register with Displacement
       ARDISX = 6, -> Address Register with Disp. & Index
       MODE7  = 7, -> All other addressing modes
       ABSW   = 0, -> Absolute Short (16-bit Address)
       ABSL   = 1, -> Absolute Long (32-bit Address)
       PCDISP = 2, -> Program Counter Relative, with Displacement
       PCDISX = 3, -> Program Counter Relative, with Disp. & Index
       IMM    = 4  -> Immediate

-> Size types

ENUM B, W, L


-> hunk_code class
OBJECT code
  hunk:PTR TO INT
  pc:PTR TO INT
  globals:PTR TO LONG
  global_refs:PTR TO LONG
  g_ref:PTR TO LONG
  locals:PTR TO LONG
  local_refs:PTR TO LONG
  l_ref:PTR TO LONG
ENDOBJECT

-> Allocate code hunk
PROC buffer(codesize) OF code
  self.hunk:=NewR(codesize)
  self.pc:=self.hunk
ENDPROC

-> Flush code hunk into a file
PROC flush(handle) OF code
  DEF len
  len:=self.pc-self.hunk+3 AND $FFFFFFFC
  Write(handle,[HUNK_HEADER,0,1,0,0,Shr(len,2),HUNK_CODE,Shr(len,2)],32)
  Write(handle,self.hunk,self.pc-self.hunk)
  Write(handle,[0,0,0,0]:CHAR,len-self.pc+self.hunk)
  Write(handle,[HUNK_END],4)
ENDPROC

-> Allow global labels
PROC global_labels(labels,refs) OF code
  self.globals:=NewR(labels*SIZEOF LONG)
  self.global_refs:=NewR(refs*2*SIZEOF LONG)
  self.g_ref:=self.global_refs
ENDPROC

-> Define a global label
PROC define_global(label) OF code
  self.globals[label]:=self.pc
ENDPROC

-> Reference a global label
PROC global_ref(label) OF code
  self.g_ref[]:=self.pc
  self.g_ref:=self.g_ref+SIZEOF LONG
  self.g_ref[]:=label
  self.g_ref:=self.g_ref+SIZEOF LONG
ENDPROC

-> Resolve global references
PROC resolve_globals() OF code
  DEF lab:PTR TO LONG,adr
  lab:=self.global_refs
  WHILE lab<self.g_ref
    PutInt((adr:=lab[]++)+2,self.globals[lab[]++]-adr-2)
  ENDWHILE
  self.g_ref:=self.global_refs
ENDPROC

-> Allow local labels
PROC local_labels(labels,refs) OF code
  self.locals:=NewR(labels*SIZEOF LONG)
  self.local_refs:=NewR(refs*2*SIZEOF LONG)
  self.l_ref:=self.local_refs
ENDPROC

-> Define a local label
PROC define_local(label) OF code
  self.locals[label]:=self.pc
ENDPROC

-> Reference a local label
PROC local_ref(label) OF code
  self.l_ref[]:=self.pc
  self.l_ref:=self.l_ref+SIZEOF LONG
  self.l_ref[]:=label
  self.l_ref:=self.l_ref+SIZEOF LONG
ENDPROC

-> Resolve local references
PROC resolve_locals() OF code
  DEF lab:PTR TO LONG,adr
  lab:=self.local_refs
  WHILE lab<self.l_ref
    PutInt((adr:=lab[]++)+2,self.locals[lab[]++]-adr-2)
  ENDWHILE
  self.l_ref:=self.local_refs
ENDPROC

-> Put word into code
-> Instructions: Bcc, DBcc, BRA, BSR, LINK, UNLK, RTS, RTE, RTR, SWAP, EXT
-> Instructions: ILLEGAL, TRAP, TRAPV, NOP
PROC putword(word) OF code
  self.pc[]:=word
  self.pc:=self.pc+SIZEOF INT
ENDPROC

-> Put long into code
PROC putlong(long) OF code
  PutLong(self.pc,long)
  self.pc:=self.pc+SIZEOF LONG
ENDPROC

-> Put binary into code
PROC putbinary(start,end) OF code
  CopyMem(start,self.pc,end-start)
  self.pc:=self.pc+end-start
ENDPROC

-> Instruction format #1: xxxxxxxxsseeeeee
-> Instructions: CLR, NEG, NOT, TST
PROC putF1(op,size,data,mode,reg) OF code
  self.pc[]:=op OR Shl(size,6) OR Shl(mode,3) OR reg
  self.pc:=self.pc+SIZEOF INT
  self.argument(size,data,mode,reg)
ENDPROC

-> Instruction format #2: xxxxrrrxxxeeeeee
-> Instructions: LEA, DIVS, DIVU, MULS, MULU, CHK
PROC putF2(op,xdata,xmode,xreg,yreg) OF code
  self.pc[]:=op OR Shl(yreg,9) OR Shl(xmode,3) OR xreg
  self.pc:=self.pc+SIZEOF INT
  self.argument(W,xdata,xmode,xreg)
ENDPROC

-> Instruction format #3: xxxxxxxxxxeeeeee
-> Instructions: PEA, JSR, JMP, Scc
PROC putF3(op,data,mode,reg) OF code
  self.pc[]:=op OR Shl(mode,3) OR reg
  self.pc:=self.pc+SIZEOF INT
  self.argument(W,data,mode,reg)
ENDPROC

-> Instruction format #4: 00sseeeeeeeeeeee
-> Instructions: MOVE, MOVEA
PROC putF4(size,xdata,xmode,xreg,ydata,ymode,yreg) OF code
  self.pc[]:= Shl(IF size=B THEN %1 ELSE size OR %10,12) OR
              Shl(yreg,9) OR Shl(ymode,6) OR Shl(xmode,3) OR xreg
  self.pc:=self.pc+SIZEOF INT
  self.argument(size,xdata,xmode,xreg)
  self.argument(size,ydata,ymode,yreg)
ENDPROC

-> Instruction format #5: xxxxrrrmmmeeeeee
-> Instructions: OR, SUB, SUBA, CMP, CMPA, EOR, AND, ADD, ADDA
PROC putF5(op,size,xdata,xmode,xreg,yreg) OF code
  self.pc[]:=op OR Shl(yreg,9) OR Shl(size,6) OR Shl(xmode,3) OR xreg
  self.pc:=self.pc+SIZEOF INT
  self.argument(size,xdata,xmode,xreg)
ENDPROC

-> Instruction format #6: xxxxxxxxsseeeeee
-> Instructions: ORI, SUBI, CMPI, EORI, ANDI, ADDI
PROC putF6(op,size,xdata,ydata,ymode,yreg) OF code
  self.pc[]:=op OR Shl(size,6) OR Shl(ymode,3) OR yreg
  self.argument(size,xdata,MODE7,IMM)
  self.argument(size,ydata,ymode,yreg)
ENDPROC

-> Instruction format #7: xxxxdddxsseeeeee
-> Instructions: ADDQ, SUBQ
PROC putF7(op,size,xdata,ydata,ymode,yreg) OF code
  self.pc[]:=op OR Shl(xdata,9) OR Shl(size,6) OR Shl(ymode,3) OR yreg
  self.pc:=self.pc+SIZEOF INT
  self.argument(size,ydata,ymode,yreg)
ENDPROC


-> PRIVATE part

-> Instruction arguments
PROC argument(size,data,mode,reg) OF code
  IF (mode = ARDISP) OR (mode = ARDISX)
    self.pc[]:=data
    self.pc:=self.pc+SIZEOF INT
  ELSEIF mode = MODE7
    SELECT reg
    CASE ABSW
      self.pc[]:=data
      self.pc:=self.pc+SIZEOF INT
    CASE ABSL
      PutLong(self.pc,data)
      self.pc:=self.pc+SIZEOF LONG
    CASE PCDISP
      self.pc[]:=data
      self.pc:=self.pc+SIZEOF INT
    CASE PCDISX
      self.pc[]:=data
      self.pc:=self.pc+SIZEOF INT
    CASE IMM
      SELECT size
      CASE B
        self.pc[]:=data
        self.pc:=self.pc+SIZEOF INT
      CASE W
        self.pc[]:=data
        self.pc:=self.pc+SIZEOF INT
      CASE L
        PutLong(self.pc,data)
        self.pc:=self.pc+SIZEOF LONG
      ENDSELECT
    ENDSELECT
  ENDIF
ENDPROC

