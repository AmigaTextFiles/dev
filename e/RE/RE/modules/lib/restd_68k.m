OPT	LINK='68K/re_std.lib'
/*
D >ram:script re:lib/68K/Src/#?.ass DO phxass %>t:op NOEXE opt nrqbtlps %s
execute ram:script
join re:lib/68K/Src/#?.o to re:lib/68K/re_std.lib
*/
LIBRARY LINK REG
// String/EString functions ////////////

 StrAdd(a0,a1,d0=-1),
 StrCopy(a0,a1,d0=-1),
 StrLen(a0),
 /*StrLen(a0)='move.l\ta0,d0\n'+
            '\ttst.b\t(a0)+\n'+
            '\tbne.s\t*-4\n'+
            '\tsubq.l\t#1,a0\n'+
            '\tsuba.l\td0,a0\n'+
            '\tmove.l\ta0,d0',*/
 TrimStr(a0),
 UpperStr(a0),
 LowerStr(a0),
 InStr(a0,a1,d0=0),

-> String(d0),
 EStrAdd(a0,a1,d0=-1),
 EStrCopy(a0,a1,d0=-1),
 EStrLen(a0)='moveq\t#0,d0 \n\tmove.w\t-2(a0),d0',
 EStrMax(a0)='moveq\t#0,d0 \n\tmove.w\t-4(a0),d0',
 SetEStr(a0,d0)='cmp.w\t-4(a0),d0 \n\tbhi.s\t*+6 \n\tmove.w\td0,-2(a0) \n\tmove.b\t#0,0(a0,d0.w)\t* SetEStr',
->RightEStr(a0,a1,d0)
->MidEStr(a0,a1,d0,d1=-1)
->ReadEStr(fh,str)

 DupStr(a0),
 DupStrPooled(a0,a1),
 DupEStr(a0),
 DupEStrPooled(a0,a1),
 EStringF(a0,a1,a2=NIL:LIST OF LONG),
 VEStringF(a0,a1,a2=NIL:PTR TO LONG),

 StrCmp(a0,a1,d0=-1),
 StrCmpNC(a0,a1,d0=-1),
 OStrCmp(a0,a1,d0=-1),
 OStrCmpNC(a0,a1,d0=-1),
 HiChar(d0)='cmp.b\t#122,d0\n\tbgt.b\t*+6\n\tcmp.b\t#97,d0\n\tblt.b\t*+2\n\tsub.b\t#32,d0',
 LoChar(d0)='cmp.b\t#91,d0\n\tbgt.b\t*+6\n\tcmp.b\t#65,d0\n\tblt.b\t*+2\n\tadd.b\t#32,d0',
 IsAlpha(d0),
 IsBin(d0),
 IsHex(d0),
 IsNum(d0),
 NewEStr(d0),
 ReEStr(a0),
 RemEStr(a1),
 RemStr(a1),
 StringF(a3,a0,a1=NIL:LIST OF LONG),
 VStringF(a3,a0,a1=NIL:PTR TO LONG),

// List functions

// Math functions //////////////////////
 Not(d0)='not.l\td0',
 And(d0,d1)='and.l\td1,d0',
 Or(d0,d1)='or.l\td1,d0',
 Eor(d0,d1)='eor.l\td1,d0',
 Rol(d0,d1)='rol.l\td1,d0',
 Ror(d0,d1)='ror.l\td1,d0',
 Shl(d0,d1)='asl.l\td1,d0',
 Shr(d0,d1)='asr.l\td1,d0',

 HiBit(d0),
 LoBit(d0),
 BitCount(d0),
 BitSize(d0),

 Add(d0,d1)='add.l\td1,d0',
 Sub(d0,d1)='sub.l\td1,d0',
 Mul(d0,d1)='muls.l\td1,d0',
 Div(d0,d1)='divs.l\td1,d0',
 Mod(d0,d1)='divsl.l\td1,d1:d0\n\texg\td0,d1\t* Mod',
 Neg(d0)='neg.l\td0',
 Abs(d0)='tst.l\td0 \n\tbge.b\t*+2\n\tneg.l\td0\t* Abs',

 Sign(d0)='tst\td0\n\tblt.b\t*+6\n\tbgt.b\t*+6\n\tbra.b\t*+6\n\tmoveq\t#-1,d0\n\tbra.b\t*+2\n\tmoveq\t#1,d0',
 Even(d0)='andi.l\t#1,d0\n\tbeq\t*+2\n\tmoveq\t#-1,d0\n\tnot.l\td0',
 Odd(d0)='andi.l\t#1,d0\n\tbeq\t*+2\n\tmoveq\t#-1,d0',
 Max(d0,d1)='cmp.l\td1,d0\n\tbge.b\t*+2\n\tmove.l\td1,d0',
 Min(d0,d1)='cmp.l\td1,d0\n\tble.b\t*+2\n\tmove.l\td1,d0',
 Bounds(d0,d1,d2)='cmp.l\td2,d0\n\tbmi.b\t*+4\n\tmove.l\td2,d0\n\tbra.b\t*+6\n\tcmp.l\td1,d0\n\tbpl.b\t*+2\n\tmove.l\td1,d0\n',
 InBounds(d0,d1,d2)='cmp.l\td0,d1\n\tbgt.b\t*+8\n\tcmp.l\td2,d1\n\tblt.b\t*+4\n\tmoveq\t#-1,d0\n\tblt.b\t*+2\n\tmoveq\t#0,d0\n',
	
// FPU functions ///////////////////////
 FAdd(fp0,fp1)='fadd.s\tfp1,fp0',
 FMul(fp0,fp1)='fmul.s\tfp1,fp0',
 Fabs(fp0)='fabs.s\tfp0',
 Fneg(fp0)='fneg.s\tfp0',
 Fsin(fp0)='fsin.s\tfp0',
 Fcos(fp0)='fcos.s\tfp0',-> \n\tfmove.s\tfp0,d0',
 Ftan(fp0)='ftan.s\tfp0',
 Flog(fp0)='flogn.s\tfp0',
 Flog10(fp0)='flog10.s\tfp0',
 Fexp(fp0)='fetox.s\tfp0',
 Pow(fp0,fp1),
 Fsqrt(fp0)='fsqrt.s\tfp0',
 FInt(fp0)='fintrz.s\tfp0',

// Intuition support functions /////////
 Mouse(),
 MouseX(a0)='move.w\t14(a0),d0',
 MouseY(a0)='move.w\t12(a0),d0',

// Miscellaneous functions /////////////
/*
 Byte(a0:PTR TO BYTE)='move.b\t(a0),d0\n\textb.l\td0',
 Word(a0:PTR TO WORD)='move.w\t(a0),d0\n\text.l\td0',
 Long(a0:PTR TO LONG)='move.l\t(a0),d0',
 UByte(a0:PTR TO BYTE)='move.b\t(a0),d0\n\tandi.l\t#$ff,d0',
 UWord(a0:PTR TO WORD,d0=0)='move.w\t(a0,d0.l*2),d0\n\tandi.l\t#$ffff,d0',
 ULong(a0:PTR TO LONG)='move.l\t(a0),d0',

-> Float(a0:PTR TO FLOAT)='fmove.s\t(a0),fp0'
-> PutFloat(a0:PTR TO FLOAT,fp0:FLOAT)='fmove.s\tfp0,(a0)'

 PutByte(a0:PTR TO BYTE,d0)='move.b\td0,(a0)',
 PutWord(a0:PTR TO WORD,d0)='move.w\td0,(a0)',
 PutLong(a0:PTR TO LONG,d0)='move.l\td0,(a0)',
*/
 Byte(a6) ASM ' LDB d0 a6\n EXB d0\n', ->MUST add the newline
 Word(a6) ASM ' LDW d0 a6\n EXW d0\n', ->MUST add the newline
 Long(a6) ASM ' LDL d0 a6\n', ->MUST add the newline
 UByte(a6) ASM ' LDB d0 a6\n AND d0 $FF\n', ->MUST add the newline
 UWord(a6) ASM ' LDW d0 a6\n AND d0 $FFFF\n', ->MUST add the newline

 PutByte(a6,d0) ASM ' STB d0 a6\n', ->MUST add the newline
 PutWord(a6,d0) ASM ' STW d0 a6\n', ->MUST add the newline
 PutLong(a6,d0) ASM ' STL d0 a6\n', ->MUST add the newline

 ReByte(d0)='extb.l\td0',
 ReWord(d0)='ext.l\td0',
 ReUByte(d0)='andi.l\t#$ff,d0',
 ReUWord(d0)='andi.l\t#$ffff,d0',

 Rnd(d0),
 RndQ(d0)='add.l\td0,d0 \n\tbgt.s\t*+6 \n\teori.l\t#$1d872b41,d0',

 KickVersion(d0),

 Inp(d1),
 ->Out(d1,d2),

 SizePooled(a0)='move.l\t(-4,a0),d0',
 AllocVecPooled(a0,d0),
 FreeVecPooled(a0,a1),

 ReNewR(d0),
 ReDispose(a1),
 ReDisposeAll(),

 Raise(d0=NIL,d1=NIL),

// graphics functions //////////////////
 CloseW(a0),
 CloseS(a0),
 SetColour(a0,d0,d1,d2,d3),

 SetStdRast(d1)='move.l\t_stdrast,d0 \n\ttst.l\td1 \n\tbeq.s\t*+6 \n\tmove.l\td1,_stdrast',
 Colour(d0,d1=0),
 Line(d0,d1,d2,d3,d4=-1),
 Plot(d0,d1,d2=-1),
 Box(d0,d1,d2,d3,d4=-1),
 Ellipse(d0,d1,d2,d3,d4=-1),
 Circle(d0,d1,d2,d3=-1),

// Quoted Expression functions /////////
 Eval(a0)='jsr\t(a0)',
 MapList(a0:PTR TO LONG,a1:PTR TO LONG,a2:PTR TO LONG,d0,a3:PTR TO LONG),
 ForAll(a0:PTR TO LONG,a1:PTR TO LONG,d0,a2:PTR TO LONG),
 Exists(a0:PTR TO LONG,a1:PTR TO LONG,d0,a2:PTR TO LONG),
 SelectList(a0:PTR TO LONG,a1:PTR TO LONG,a2:PTR TO LONG,d0,a3:PTR TO LONG)



LIBRARY LINK
 ReadEStr(fh,estr),

 Val(s:PTR TO UBYTE,n=0),

 WriteF(a,b=NIL:LIST OF LONG),
 VWriteF(a,b=NIL:PTR TO LONG),

// graphics functions //////////////////
 TextF(x,y,fmt,args=NIL:LIST OF LONG),
 SetTopaz(size=8),

// Intuition support functions /////////
 WaitIMessage(win),
 MsgCode(),
 MsgQualifier(),
 MsgIaddr(),

 OpenS(w,h,d,t=0,n=NIL,tags=NIL:PTR TO LONG),
 OpenW(l,t,w,h,i,f,n=NIL,s=NIL,st=1,g=NIL,tags=NIL:PTR TO LONG),
 Gadget(buf,glist,id,flags,x,y,width,string),

// FPU functions ///////////////////////
 RealVal(s),
 RealF(s,x,n),

// misc functions //////////////////////
 FileLength(name:PTR TO CHAR)

#define RightStr(dstr,sstr,l) StrCopy(dstr,sstr+StrLen(sstr)-l)
#define MidStr(dstr,sstr,p,l) StrCopy(dstr,sstr+p,l)
->PROC EStrCopy(d,s,l=$7fff) ; StrCopy(d,s,Min(Min($7fff,l),EStrLen(d))) ; SetStr(d,StrLen(d)) ; ENDPRO

#define Char UByte
#define Int UWord

#define Fpow Pow

#define ReadStr(f,s) ReadEStr(f,s)
#define Out FPutC

#define CtrlC() (SetSignal(0,$1000) AND $1000)
#define CtrlD() (SetSignal(0,$2000) AND $2000)
#define CtrlE() (SetSignal(0,$4000) AND $4000)
#define CtrlF() (SetSignal(0,$8000) AND $8000)

#define Throw Raise
#define ReThrow() IF exception THEN Raise(exception)
#define CleanUp Raise

