OPT	LINK='powerd_ppc.lib',LINK='ppcmath.lib',CPU=603

// String/EString functions ////////////
//RPROC DupEStr(a0:PTR TO CHAR)(PTR TO CHAR)
//RPROC DupEStrPooled(a0:PTR,a1:PTR TO CHAR)(PTR TO CHAR)
//RPROC DupStr(a0:PTR TO CHAR)(PTR TO CHAR)
//RPROC DupStrPooled(a0:PTR,a1:PTR TO CHAR)(PTR TO CHAR)
RPROC EStrAdd(r3:PTR TO CHAR,r4:PTR TO CHAR,r5=-1)(PTR TO CHAR)
RPROC EStrCopy(r3:PTR TO CHAR,r4:PTR TO CHAR,r5=-1)(PTR TO CHAR)
RPROC EStringF(r3:PTR TO CHAR,r4:PTR TO CHAR,r5=NIL:LIST OF LONG)(PTR TO CHAR)
RPROC EStrLen(r3:PTR TO CHAR)(LONG)='lhz\tr3,-2(r3)'
RPROC EStrMax(r3:PTR TO CHAR)(LONG)='lhz\tr3,-4(r3)'
RPROC HiChar(r3:LONG)(LONG)
//RPROC InStr(a0:PTR TO CHAR,a1:PTR TO CHAR,d0=0:LONG)(LONG)
//RPROC MidEStr(a0:PTR TO CHAR,a1:PTR TO CHAR,d1,d0)(PTR TO CHAR)
//RPROC MidStr(string:PTR TO CHAR,str:PTR TO CHAR,start,length)(PTR TO CHAR)
RPROC IsAlpha(r3:LONG)(BOOL)
RPROC IsBin(r3:LONG)(BOOL)
RPROC IsHex(r3:LONG)(BOOL)
RPROC IsNum(r3:LONG)(BOOL)
RPROC LoChar(r3:LONG)(LONG)
RPROC LowerStr(r3:PTR TO CHAR)(PTR TO CHAR)
//RPROC NewEStr(d0:UWORD)(PTR TO CHAR)
RPROC OStrCmp(a:PTR TO CHAR,b:PTR TO CHAR,length=-1)(LONG)
RPROC OStrCmpNC(a:PTR TO CHAR,b:PTR TO CHAR,length=-1)(LONG)
RPROC ReadEStr(fh:BPTR,estr:PTR TO CHAR)(LONG)
//RPROC ReadStr(fh:BPTR,str:PTR TO CHAR)(LONG)
RPROC ReEStr(estr:PTR TO CHAR)
//RPROC RemEStr(a1:PTR TO CHAR)
//RPROC RemStr(a1:PTR TO CHAR)
//RPROC RightEStr(dstr:PTR TO CHAR,sstr:PTR TO CHAR,length)(PTR TO CHAR)
//RPROC RightStr(dstr:PTR TO CHAR,sstr:PTR TO CHAR,length)(PTR TO CHAR)
RPROC SetEStr(estr:PTR TO CHAR,len:LONG)
RPROC StrAdd(r3:PTR TO CHAR,r4:PTR TO CHAR,r5=-1)(BOOL)
RPROC StrCmp(r3:PTR TO CHAR,r4:PTR TO CHAR,r5=-1)(BOOL)
RPROC StrCmpNC(r3:PTR TO CHAR,r4:PTR TO CHAR,r5=-1)(BOOL)
RPROC StrCopy(r3:PTR TO CHAR,r4:PTR TO CHAR,r5=-1)(BOOL)
RPROC StringF(r3:PTR TO CHAR,r4:PTR TO CHAR,r5=NIL:LIST OF LONG)(PTR TO CHAR)
RPROC StrLen(r3:PTR TO CHAR)(LONG)
RPROC TrimStr(r3:PTR TO CHAR)(PTR TO CHAR)
RPROC UpperStr(r3:PTR TO CHAR)(PTR TO CHAR)

// added in v0.19alpha7:
RPROC CStrCmp(stra:PTR TO CHAR,strb:PTR TO CHAR)(L)

RPROC WriteF(fmt:PTR TO CHAR,list=NIL:LIST OF LONG)
RPROC VWriteF(fmt:PTR TO CHAR,list=NIL:PTR TO LONG)

// List functions

// Math functions //////////////////////
RPROC Abs(r3:L)(L)
RPROC And(r3:L,r4:L)(L)='and\tr3,r4,r3'
RPROC NAnd(r3:L,r4:L)(L)='nand\tr3,r4,r3'
RPROC BitCount(r3:L)(L)
RPROC BitSize(r3:L)(L)
RPROC EOr(r3:L,r4:L)(L)='xor\tr3,r4,r3'
RPROC XOr(r3:L,r4:L)(L)='xor\tr3,r4,r3'
RPROC HiBit(r3:L)(L)
RPROC LoBit(r3:L)(L)
RPROC Or(r3:L,r4:L)(L)='or\tr3,r4,r3'
RPROC Max(r3:L,r4:L)(L)
RPROC Min(r3:L,r4:L)(L)
RPROC NOr(r3:L,r4:L)(L)='or\tr3,r4,r3'
RPROC Neg(r3:L)(L)='neg\tr3,r3'
RPROC Not(r3:L)(L)='not\tr3,r3'
RPROC Rol(r3:L,r4:L)(L)='rotlw\tr3,r3,r4,0,31'
RPROC Ror(r3:L,r4:L)(L)='neg\tr4,r4\n\trotlw\tr3,r3,r4,0,31'
RPROC Shl(r3:L,r4:L)(L)='slw\tr3,r3,r4'
RPROC Shr(r3:L,r4:L)(L)='srw\tr3,r3,r4'
RPROC Sign(r3:L)(L)
RPROC Mod(r3:L,r4:L)(L)='divw\tr0,r3,r4\n\tmullw\tr0,r0,r4\n\tsubf\tr3,r0,r3'
RPROC Div(r3:L,r4:L)(L)='divw\tr3,r3,r4'
RPROC Mul(r3:L,r4:L)(L)='mulllw\tr3,r3,r4'
RPROC Add(r3:L,r4:L)(L)='add\tr3,r3,r4'
RPROC Sub(r3:L,r4:L)(L)='sub\tr3,r3,r4'

// FPU functions ///////////////////////
RPROC Pow(f1:D,f2:D)(D)='bl\t_pow\n\t.extern\t_pow'
RPROC Cos(f1:D)(D)='bl\t_cos\n\t.extern\t_cos'
RPROC Sin(f1:D)(D)='bl\t_sin\n\t.extern\t_sin'
RPROC Tan(f1:D)(D)
RPROC Cosh(f1:D)(D)='bl\t_cosh\n\t.extern\t_cosh'
RPROC Sinh(f1:D)(D)='bl\t_sinh\n\t.extern\t_sinh'
RPROC Tanh(f1:D)(D)='bl\t_tanh\n\t.extern\t_tanh'
RPROC ACos(f1:D)(D)//='bl\t_acos\n\t.extern\t_acos'
RPROC ASin(f1:D)(D)='bl\t_asin\n\t.extern\t_asin'
RPROC ATan(f1:D)(D)='bl\t_atan\n\t.extern\t_atan'
RPROC FAbs(f1:D)(D)='fabs\tf1,f1'
RPROC Sqrt(f1:D)(D)='bl\t_sqrt\n\t.extern\t_sqrt'
//RPROC ATanh(f1:D)(D)='bl\t_atanh\n\t.extern\t_atanh'
RPROC Log(f1:D)(D)='bl\t_log10\n\t.extern\t_log10'
RPROC Ln(f1:D)(D)='bl\t_log\n\t.extern\t_log'
//RPROC Log2(f1:D)(D)='bl\t_log2\n\t.extern\t_log2'
//RPROC Int(f1:D)(D)='bl\t_\n\t.extern\t_'
//RPROC Rem(f1:D)(D)='bl\t_\n\t.extern\t_'
RPROC Exp(f1:D)(D)='bl\t_exp\n\t.extern\t_exp'
RPROC FNeg(f1:D)(D)='fneg\tf1,f1'
RPROC FMax(f1:D,f2:D)(D)='fsub\tf0,f1,f2\n\tfsel\tf1,f0,f1,f2'
RPROC FMin(f1:D,f2:D)(D)='fsub\tf0,f1,f2\n\tfsel\tf1,f0,f2,f1'
RPROC F2I(f1:D)(L)='fctiw\tf1,f1\n\tstfd\tf1,-8(r1)\n\tlwz\tr3,-4(r1)'

// Intuition support functions /////////
RPROC Mouse()(L)
RPROC MouseX(r3:PTR TO Window)(L)='lha\tr3,14(r3)'
RPROC MouseXY(r3:PTR TO Window)(L,L)='lha\tr4,12(r3)\n\tlha\tr3,14(r3)'
RPROC MouseY(r3:PTR TO Window)(L)='lha\tr3,12(r3)'
RPROC WaitIMessage(r3:PTR TO Window)(L,L,L,L)

// Miscellaneous functions /////////////
RPROC CtrlC()(BOOL)
RPROC CtrlD()(BOOL)
RPROC CtrlE()(BOOL)
RPROC CtrlF()(BOOL)

RPROC Byte(r3:PTR TO BYTE)(L)='lbz\tr3,0(r3)\n\textsb\tr3,r3'
RPROC Word(r3:PTR TO WORD)(L)='lha\tr3,0(r3)'
RPROC Long(r3:PTR TO LONG)(L)='lwz\tr3,0(r3)'
RPROC UByte(r3:PTR TO BYTE)(L)='lbz\tr3,0(r3)'
RPROC UWord(r3:PTR TO WORD)(L)='lhz\tr3,0(r3)'
RPROC ULong(r3:PTR TO LONG)(L)='lwz\tr3,0(r3)'
RPROC Float(r3:PTR TO FLOAT)(DOUBLE)='lfs\tf1,0(r3)'
RPROC Double(r3:PTR TO DOUBLE)(DOUBLE)='lfd\tf1,0(r3)'

RPROC PutByte(r3:PTR TO BYTE,r4:L)='stb\tr4,0(r3)'
RPROC PutWord(r3:PTR TO WORD,r4:L)='sth\tr4,0(r3)'
RPROC PutLong(r3:PTR TO LONG,r4:LONG)='stw\tr4,0(r3)'
RPROC PutFloat(r3:PTR TO LONG,f1:DOUBLE)='stfs\tf1,0(r3)'
RPROC PutDouble(r3:PTR TO LONG,f1:DOUBLE)='stfd\tf1,0(r3)'

RPROC ReByte(r3:BYTE)(LONG)='extsb\tr3,r3'
RPROC ReWord(r3:WORD)(LONG)='extsh\tr3,r3'
RPROC ReUByte(r3:UBYTE)(LONG)='andi.\tr3,r3,0xff'
RPROC ReUWord(r3:UWORD)(LONG)='andi.\tr3,r3,0xffff'

RPROC Bounds(r3:LONG,r4:LONG,r5:LONG)(LONG)
RPROC Even(r3:LONG)(BOOL)
RPROC Odd(r3:LONG)(BOOL)

RPROC Rnd(r3:LONG)(LONG)
RPROC RndQ(r3:LONG)(LONG)

EPROC FileLength(name:PTR TO CHAR)(LONG)
EPROC KickVersion(minimal:LONG)(BOOL)

RPROC Inp(d1:BPTR)(LONG)
RPROC Out(d1:BPTR,d2:LONG)

RPROC RealStr(r3:PTR TO UBYTE,f1:DOUBLE,r4=1)(PTR TO UBYTE)
RPROC RealEStr(r3:PTR TO UBYTE,f1:DOUBLE,r4=1)(PTR TO UBYTE)
RPROC RealVal(r3:PTR TO UBYTE,r4=0)(DOUBLE,LONG)
EPROC Val(s:PTR TO UBYTE,n=0)(LONG,LONG)

RPROC AllocVecPooled(a0:APTR,d0:LONG)(PTR)
RPROC FreeVecPooled(a0:APTR,a1:PTR)
RPROC SizePooled(r3:PTR)(LONG)='lwz\tr3,0(r3)'
RPROC AllocVecPooledPPC(a0:APTR,d0:LONG)(PTR)
RPROC FreeVecPooledPPC(a0:APTR,a1:PTR)
RPROC SizePooledPPC(r3:PTR)(LONG)='lwz\tr3,0(r3)'

EPROC New(length)(PTR)
EPROC NewR(length)(PTR)
EPROC NewM(length,flags)(PTR)
EPROC Dispose(memptr)

RPROC Raise(d0=NIL:LONG,d1=NIL:LONG)
EDEF	exception,exceptioninfo

EPROC OpenW(l,t,w,h,i,f,n=NIL,s=NIL,st=1,g=NIL,tags=NIL:PTR TO TagItem)(PTR TO Window)
EDEF	stdrast,stdrast_coloura
EPROC OpenS(w,h,d,t=0,n=NIL,tags=NIL:PTR TO TagItem)(PTR TO Screen)
EPROC CloseW(w:PTR TO Window)
EPROC CloseS(s:PTR TO Screen)

RPROC SetStdRast(d1:PTR TO RastPort)(PTR TO RastPort)
RPROC Colour(d0,d1=0)
RPROC Line(d0,d1,d2,d3,d4=-1)
RPROC Plot(d0,d1,d2=-1)
RPROC Box(d0,d1,d2,d3,d4=-1)
RPROC Ellipse(d0,d1,d2,d3,d4=-1)
RPROC Circle(d0,d1,d2,d3=-1)
//RPROC IBox(x,y,w,h,c=-1)
//RPROC TextF(x,y,fmt,args)

// Quoted Expression functions /////////
EPROC Eval(r3:PTR)(L)
RPROC MapList(r3:PTR TO LONG,r4:PTR TO LONG,r5:PTR TO LONG,r6:LONG,r7:PTR TO LONG)
RPROC ForAll(r3:PTR TO LONG,r4:PTR TO LONG,r5:LONG,r6:PTR TO LONG)(L)
RPROC Exists(r3:PTR TO LONG,r4:PTR TO LONG,r5:LONG,r6:PTR TO LONG)(L)
RPROC SelectList(r3:PTR TO LONG,r4:PTR TO LONG,r5:PTR TO LONG,r6:LONG,r7:PTR TO LONG)(L)
