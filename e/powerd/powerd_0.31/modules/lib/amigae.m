OPT	LINK='amigae.lib'

// String/EString functions ////////////
RPROC DupEStr(a0:PTR TO CHAR)(PTR TO CHAR)
RPROC DupEStrPooled(a0:PTR,a1:PTR TO CHAR)(PTR TO CHAR)
RPROC DupStr(a0:PTR TO CHAR)(PTR TO CHAR)
RPROC DupStrPooled(a0:PTR,a1:PTR TO CHAR)(PTR TO CHAR)
RPROC EStrAdd(a0:PTR TO CHAR,a1:PTR TO CHAR,d0=-1)(PTR TO CHAR)
RPROC EStrCopy(a0:PTR TO CHAR,a1:PTR TO CHAR,d0=-1)(PTR TO CHAR)
RPROC EStringF(a0:PTR TO CHAR,a1:PTR TO CHAR,a2=NIL:LIST OF LONG)(PTR TO CHAR)
RPROC VEStringF(a0:PTR TO CHAR,a1:PTR TO CHAR,a2=NIL:PTR TO LONG)(PTR TO CHAR)
RPROC EStrLen(a0:PTR TO CHAR)(LONG)
RPROC EStrMax(a0:PTR TO CHAR)(LONG)
RPROC InStr(a0:PTR TO CHAR,a1:PTR TO CHAR,d0=0:LONG)(LONG)
RPROC MidEStr(a0:PTR TO CHAR,a1:PTR TO CHAR,d1,d0)(PTR TO CHAR)
//LPROC MidStr(string:PTR TO CHAR,str:PTR TO CHAR,start,length)(PTR TO CHAR)
RPROC HiChar(d0:LONG)(LONG)
RPROC IsAlpha(d0:LONG)(BOOL)
RPROC IsBin(d0:LONG)(BOOL)
RPROC IsHex(d0:LONG)(BOOL)
RPROC IsNum(d0:LONG)(BOOL)
RPROC LoChar(d0:LONG)(LONG)
RPROC LowerStr(a0:PTR TO CHAR)(PTR TO CHAR)
RPROC NewEStr(d0:UWORD)(PTR TO CHAR)
RPROC OStrCmp(a0:PTR TO CHAR,a1:PTR TO CHAR,d0=-1)(LONG)
LPROC ReadEStr(fh:BPTR,estr:PTR TO CHAR)(LONG)
//LPROC ReadStr(fh:BPTR,str:PTR TO CHAR)(LONG)
RPROC ReEStr(a0:PTR TO CHAR)
RPROC RemEStr(a1:PTR TO CHAR)
RPROC RemStr(a1:PTR TO CHAR)
LPROC RightEStr(dstr:PTR TO CHAR,sstr:PTR TO CHAR,length)(PTR TO CHAR)
//LPROC RightStr(dstr:PTR TO CHAR,sstr:PTR TO CHAR,length)(PTR TO CHAR)
RPROC SetEStr(a0:PTR TO CHAR,d0:LONG)
RPROC StrAdd(a0:PTR TO CHAR,a1:PTR TO CHAR,d0=-1)(PTR TO CHAR)
RPROC StrCmp(a0:PTR TO CHAR,a1:PTR TO CHAR,d0=-1)(BOOL)
RPROC StrCopy(a0:PTR TO CHAR,a1:PTR TO CHAR,d0=-1)(PTR TO CHAR)
LPROC StringF(dstr:PTR TO CHAR,fstr:PTR TO CHAR,list=NIL:LIST OF LONG)(PTR TO CHAR)
LPROC VStringF(dstr:PTR TO CHAR,fstr:PTR TO CHAR,list=NIL:PTR TO LONG)(PTR TO CHAR)
RPROC StrLen(a0:PTR TO CHAR)(LONG)
RPROC TrimStr(a0:PTR TO CHAR)(PTR TO CHAR)
RPROC UpperStr(a0:PTR TO CHAR)(PTR TO CHAR)

RPROC WriteF(a0:PTR TO CHAR,a1=NIL:LIST OF LONG)
RPROC VWriteF(a0:PTR TO CHAR,a1=NIL:PTR TO LONG)

// List functions

// Math functions //////////////////////
RPROC Abs(d0:LONG)(LONG)
RPROC And(d0:LONG,d1:LONG)(LONG)='and.l\td1,d0'
RPROC BitCount(d0:LONG)(LONG)
RPROC BitSize(d0:LONG)(LONG)
RPROC EOr(d0:LONG,d1:LONG)(LONG)='eor.l\td1,d0'
RPROC HiBit(d0:LONG)(LONG)
RPROC LoBit(d0:LONG)(LONG)
RPROC Or(d0:LONG,d1:LONG)(LONG)='or.l\td1,d0'
RPROC Neg(d0:LONG)(LONG)='neg.l\td0'
RPROC Not(d0:LONG)(LONG)='not.l\td0'
RPROC Rol(d0:LONG,d1:LONG)(LONG)='rol.l\td1,d0'
RPROC Ror(d0:LONG,d1:LONG)(LONG)='ror.l\td1,d0'
RPROC Shl(d0:LONG,d1:LONG)(LONG)='asl.l\td1,d0'
RPROC Shr(d0:LONG,d1:LONG)(LONG)='asr.l\td1,d0'
RPROC Sign(d0:LONG)(LONG)

// FPU functions ///////////////////////
RPROC Pow(fp0:DOUBLE,fp1:DOUBLE)(DOUBLE)
RPROC Cos(fp0:DOUBLE)(DOUBLE)='fcos.x\tfp0'
RPROC Sin(fp0:DOUBLE)(DOUBLE)='fsin.x\tfp0'
RPROC Tan(fp0:DOUBLE)(DOUBLE)='ftan.x\tfp0'
RPROC Cosh(fp0:DOUBLE)(DOUBLE)='fcosh.x\tfp0'
RPROC Sinh(fp0:DOUBLE)(DOUBLE)='fsinh.x\tfp0'
RPROC Tanh(fp0:DOUBLE)(DOUBLE)='ftanh.x\tfp0'
RPROC ACos(fp0:DOUBLE)(DOUBLE)='facos.x\tfp0'
RPROC ASin(fp0:DOUBLE)(DOUBLE)='fasin.x\tfp0'
RPROC ATan(fp0:DOUBLE)(DOUBLE)='fatan.x\tfp0'
RPROC FAbs(fp0:DOUBLE)(DOUBLE)='fabs.x\tfp0'
RPROC Sqrt(fp0:DOUBLE)(DOUBLE)='fsqrt.x\tfp0'
RPROC ATanh(fp0:DOUBLE)(DOUBLE)='fatanh.x\tfp0'
RPROC Log(fp0:DOUBLE)(DOUBLE)='flog10.x\tfp0'
RPROC Ln(fp0:DOUBLE)(DOUBLE)='flogn.x\tfp0'
RPROC Log2(fp0:DOUBLE)(DOUBLE)='flog2.x\tfp0'
RPROC Int(fp0:DOUBLE)(DOUBLE)='fintrz.x\tfp0'
RPROC Rem(fp0:DOUBLE)(DOUBLE)='frem.x\tfp0'
RPROC EToX(fp0:DOUBLE)(DOUBLE)='fetox.x\tfp0'
RPROC FNeg(fp0:DOUBLE)(DOUBLE)='fneg.x\tfp0'

// Intuition support functions /////////
RPROC Mouse()(LONG)
RPROC MouseX(a0:PTR TO Window)(LONG)
RPROC MouseXY(a0:PTR TO Window)(LONG,LONG)
RPROC MouseY(a0:PTR TO Window)(LONG)
RPROC WaitIMessage(a0:PTR TO Window)(LONG,LONG,LONG,LONG)

// Miscellaneous functions /////////////
RPROC CtrlC()(BOOL)
RPROC CtrlD()(BOOL)
RPROC CtrlE()(BOOL)
RPROC CtrlF()(BOOL)

RPROC Byte(a0:PTR TO BYTE)(LONG)='move.b\t(a0),d0\n\textb.l\td0'
RPROC Word(a0:PTR TO WORD)(LONG)='move.w\t(a0),d0\n\text.l\td0'
RPROC Long(a0:PTR TO LONG)(LONG)='move.l\t(a0),d0'
RPROC UByte(a0:PTR TO BYTE)(LONG)='move.b\t(a0),d0\n\tandi.l\t#$ff,d0'
RPROC UWord(a0:PTR TO WORD)(LONG)='move.b\t(a0),d0\n\tandi.l\t#$ffff,d0'
RPROC ULong(a0:PTR TO LONG)(LONG)='move.l\t(a0),d0'
RPROC Float(a0:PTR TO FLOAT)(FLOAT)='fmove.s\t(a0),fp0'
RPROC Double(a0:PTR TO DOUBLE)(DOUBLE)='fmove.d\t(a0),fp0'

RPROC PutByte(a0:PTR TO BYTE,d0:LONG)='move.b\td0,(a0)'
RPROC PutWord(a0:PTR TO WORD,d0:LONG)='move.w\td0,(a0)'
RPROC PutLong(a0:PTR TO LONG,d0:LONG)='move.l\td0,(a0)'
RPROC PutFloat(a0:PTR TO FLOAT,fp0:FLOAT)='fmove.s\tfp0,(a0)'
RPROC PutDouble(a0:PTR TO DOUBLE,fp0:DOUBLE)='fmove.d\tfp0,(a0)'

RPROC ReByte(d0:BYTE)(LONG)='extb.l\td0'
RPROC ReWord(d0:WORD)(LONG)='ext.l\td0'
RPROC ReUByte(d0:UBYTE)(LONG)='andi.l\t#$ff,d0'
RPROC ReUWord(d0:UWORD)(LONG)='andi.l\t#$ffff,d0'

RPROC Bounds(d0:LONG,d1:LONG,d2:LONG)(LONG)
RPROC InBounds(d0:LONG,d1:LONG,d2:LONG)(BOOL)
RPROC Even(d0:LONG)(BOOL)
RPROC Odd(d0:LONG)(BOOL)
RPROC Max(d0:LONG,d1:LONG)(LONG)
RPROC Min(d0:LONG,d1:LONG)(LONG)

RPROC Rnd(d0:LONG)(LONG)
RPROC RndQ(d0:LONG)(LONG)

EPROC FileLength(name:PTR TO CHAR)(LONG)
RPROC KickVersion(d0:LONG)(BOOL)

RPROC Inp(d1:BPTR)(LONG)
RPROC Out(d1:BPTR,d2:LONG)

EPROC RealStr(str:PTR TO UBYTE,f:DOUBLE,n=1)(PTR TO UBYTE)
EPROC RealEStr(estr:PTR TO UBYTE,f:DOUBLE,n=1)(PTR TO UBYTE)
EPROC RealVal(str:PTR TO UBYTE,pos=0)(DOUBLE,LONG)
EPROC Val(s:PTR TO UBYTE,n=0)(LONG,LONG)

RPROC AllocVecPooled(a0:APTR,d0:LONG)(PTR)
RPROC FreeVecPooled(a0:APTR,a1:PTR)

RPROC New(d0:LONG)(PTR)
RPROC Free(a1:PTR)

RPROC Raise(d0=NIL:LONG,d1=NIL:LONG)
EDEF	exception,exceptioninfo

EPROC OpenW(l,t,w,h,i,f,n=NIL,s=NIL,st=1,g=NIL,tags=NIL:PTR TO TagItem)(PTR TO Window)
EDEF	stdrast
EPROC OpenS(w,h,d,t=0,n=NIL,tags=NIL:PTR TO TagItem)(PTR TO Screen)
RPROC CloseW(a0:PTR TO Window)
RPROC CloseS(a0:PTR TO Screen)
RPROC SetColour(a0:PTR TO RastPort,d0,d1,d2,d3)

RPROC SetStdRast(d1:PTR TO RastPort)(PTR TO RastPort)
RPROC Colour(d0,d1=0)
RPROC Line(d0,d1,d2,d3,d4=-1)
RPROC Plot(d0,d1,d2=-1)
RPROC Box(d0,d1,d2,d3,d4=-1)
RPROC Ellipse(d0,d1,d2,d3,d4=-1)
RPROC Circle(d0,d1,d2,d3=-1)
/*
RPROC IBox(x,y,w,h,c=-1)
RPROC TextF(x,y,fmt,args)
*/

// Quoted Expression functions /////////
RPROC Eval(a0:PTR)(LONG)
//RPROC MapList(a2:PTR TO LONG,a1:PTR TO LONG,d0:LONG,a3:PTR TO LONG,a0:PTR TO LONG)
