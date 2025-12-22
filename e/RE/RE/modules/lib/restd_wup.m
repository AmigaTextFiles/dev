OPT	LINK='WUP/re_std.lib',LINK='WUP/vppcmath.lib'
/*
D >ram:script re:lib/WUP/Src/#?.ass DO pasm %>t:op -F 2 -mo -O -1 -I re:lib/ %s
execute ram:script
join re:lib/WUP/Src/#?.o to re:lib/WUP/re_std.lib
FIXME: attention to registers passed to funcs (dn<->rn)
*/
LIBRARY LINK REG
// String/EString functions ////////////

 EStrAdd(a0,a1,d0=-1),
 EStrCopy(a0,a1,d0=-1),
 EStrLen(d0)='lhz\td0,-2(d0)',
 EStrMax(d0)='lhz\td0,-4(d0)',
 SetEStr(a0,d0),
 RightEStr(a0,a1,d0),
//MidEStr(a0,a1,d0,d1=-1) ->implemented as a macro (see below)

 StrAdd(a0,a1,d0=-1),
 StrCopy(a0,a1,d0=-1),
 StrLen(d0),

 TrimStr(d0)=''+
  '\tsubi\tr3,d0,1\n'+
  '\tlbzu\tr0,1(r3)\n'+
  '\tcmpwi\tr0,32\n'+
  '\tbgt\t$+8\n'+
  '\tb\t$-12\n',

 StrCmp(a0,a1,d0=-1),->='mtctr\td2 \n\tsubi\td0,d0,1 \n\tsubi\td1,d1,1 \n\tlbzu\tr0,1(d0) \n\tlbzu\td2,1(d1) \n\tcmpw\td2,r0 \n\tbne\t$16 \n\tmr.\tr0,r0 \n\tbeq\t$16 \n\tbdnz\t$-24 \n\tli\td0,0 \n\tb\t$8 \n\tli\td0,-1 \n',
 StrCmpNC(a0,a1,d0=-1),
 OStrCmp(a0,a1,d0=-1),
 OStrCmpNC(a0,a1,d0=-1),

 InStr(a0,a1,d0=0),
 UpperStr(d0),
 LowerStr(d0),

 HiChar(d0)='cmplwi\td0,122 \n\tbgt\t$+16 \n\tcmplwi\td0,97 \n\tblt\t$+8 \n\tsubi\td0,d0,32',
 LoChar(d0)='cmplwi\td0,91 \n\tbgt\t$+16 \n\tcmplwi\td0,65 \n\tblt\t$+8 \n\taddi\td0,d0,32',
 IsAlpha(d0),
 IsBin(d0),
 IsHex(d0),
 IsNum(d0),

// DupStr(a0),
// DupStrPooled(a0,a1),
// DupEStr(a0),
// DupEStrPooled(a0,a1),
// EStringF(d0,d1,d2=NIL:LIST OF LONG),
// VEStringF(d0,d1,d2=NIL:PTR TO LONG),
// NewEStr(d0),
// ReEStr(a1),
// RemEStr(a1),
// RemStr(a1),

// List functions //////////////////////

// Math functions //////////////////////
 Not(d0)='not\td0,d0\t#Not',
 And(d0,d1)='and\td0,d1,d0',
 Or(d0,d1)='or\td0,d1,d0',
 Eor(d0,d1)='xor\td0,d1,d0',
 Rol(d0,d1)='rotlw\td0,d0,d1,0,31',
 Ror(d0,d1)='neg\td1,d1\n\trotlw\td0,d0,d1,0,31',
 Shl(d0,d1)='slw\td0,d0,d1',
 Shr(d0,d1)='srw\td0,d0,d1',

 HiBit(d0)='cntlzw\td0,d0 \n\tsubi\td0,d0,31 \n\tneg\td0,d0',
 LoBit(d0),
 BitCount(d0),
 BitSize(d0),

 Add(d0,d1)='add\td0,d0,d1',
 Sub(d0,d1)='sub\td0,d0,d1',
 Mul(d0,d1)='mullw\td0,d0,d1',
 Div(d0,d1)='divw\td0,d0,d1',
 Mod(d0,d1)='divw\tr0,d0,d1\n\tmullw\tr0,r0,d1\n\tsubf\td0,r0,d0\t#Mod',
 Neg(d0)='neg\td0,d0',
 Abs(d0)='mr.\td0,d0\n\tbge\t$+8\n\tneg\td0,d0\t#Abs',

 Sign(d0)='mr.\td0,d0 \n\tbeq\t$+12 \n\tsrawi\td0,d0,30 \n\tori\td0,d0,1\t#Sign',
 Even(d0)='rlwinm\td0,d0,1,0,31 \n\tsrawi\td0,d0,31 \n\tnot\td0,d0\t#Even',
 Odd(d0)='rlwinm\td0,d0,1,0,31 \n\tsrawi\td0,d0,31\t#Odd',
 Max(d0,d1)='cmpw\td1,d0 \n\tble\t$+8 \n\tmr\td0,d1\t#Max',
 Min(d0,d1)='cmpw\td1,d0 \n\tbge\t$+8 \n\tmr\td0,d1\t#Min',
 Bounds(d0,d1,d2)='cmpw\td0,d2 \n\tble\t$+12 \n\tmr\td0,d2 \n\tb\t$+16 \n\tcmpw\td0,d1 \n\tbge\t$+8 \n\tmr\td0,d1\t#Bounds',
// InBounds(d0,d1,d2),->='cmp.l\td0,d1\n\tbgt.b\t*+8\n\tcmp.l\td2,d1\n\tblt.b\t*+4\n\tmoveq\t#-1,d0\n\tblt.b\t*+2\n\tmoveq\t#0,d0',
->#define Bounds(n,l,r) Max(l,Min(n,r))


// FPU functions ///////////////////////
 FMul(fp0,fp1)='fmuls\tfp0,fp0,fp1',
 FAdd(fp0,fp1)='fadds\tfp0,fp0,fp1',

 Fabs(fp0)='fabs\tfp0,fp0',
 Fneg(fp0)='fneg\tfp0,fp0',

 Ffloor(fp0)='bl\t_floor\n\t.extern\t_floor \n\tfrsp\tfp0,fp0',
 Fceil(fp0)='bl\t_ceil\n\t.extern\t_ceil \n\tfrsp\tfp0,fp0',

 Fsin(fp0)='bl\t_sin\n\t.extern\t_sin \n\tfrsp\tfp0,fp0',
 Fcos(fp0)='bl\t_cos\n\t.extern\t_cos \n\tfrsp\tfp0,fp0',
 Ftan(fp0)='fmr\tfp1,fp0 \n\t.extern\t_sin \n\t.extern\t_cos \n\tbl\t_sin\n\tfmr\tfp2,fp0 \n\tfmr\tfp0,fp1 \n\tbl\t_cos \n\tfdiv\tfp0,fp2,fp0\n\tfrsp\tfp0,fp0',
 Fsinh(fp0)='bl\t_sinh\n\t.extern\t_sinh \n\tfrsp\tfp0,fp0',
 Fcosh(fp0)='bl\t_cosh\n\t.extern\t_cosh \n\tfrsp\tfp0,fp0',
 Ftanh(fp0)='bl\t_tanh\n\t.extern\t_tanh \n\tfrsp\tfp0,fp0',
 Fasin(fp0)='bl\t_asin\n\t.extern\t_asin \n\tfrsp\tfp0,fp0',
 Facos(fp0)='bl\t_acos\n\t.extern\t_acos \n\tfrsp\tfp0,fp0',
 Fatan(fp0)='bl\t_atan\n\t.extern\t_atan \n\tfrsp\tfp0,fp0',
 Flog(fp0)='bl\t_log\n\t.extern\t_log \n\tfrsp\tfp0,fp0',
 Flog10(fp0)='bl\t_log10\n\t.extern\t_log10 \n\tfrsp\tfp0,fp0',
 Fexp(fp0)='bl\t_exp\n\t.extern\t_exp \n\tfrsp\tfp0,fp0',
 Fpow(fp0,f2)='bl\t_pow\n\t.extern\t_pow \n\tfrsp\tfp0,fp0',

 Fsqrt(fp0)='fsqrts\tfp0,fp0',

// Miscellaneous functions /////////////
 Byte(a0)='lbz\td0,0(a0)\n\textsb\td0,d0',
 Word(a0)='lha\td0,0(a0)',
 Long(a0)='lwz\td0,0(a0)',
 UByte(a0)='lbz\td0,0(a0)',
 UWord(a0)='lhz\td0,0(a0)',
 ULong(a0)='lwz\td0,0(a0)',
/*
 Float(d0)='lfs\tf1,0(d0)',
 Double(d0)='lfd\tf1,0(d0)',
 PutFloat(d0,f1)='stfs\tf1,0(d0)',
 PutDouble(d0,f1)='stfd\tf1,0(d0)',
*/
 PutByte(a0,d1)='stb\td1,0(a0)',
 PutWord(a0,d1)='sth\td1,0(a0)',
 PutLong(a0,d1)='stw\td1,0(a0)',

 ReByte(d0)='extsb\td0,d0',
 ReWord(d0)='extsh\td0,d0',
 ReUByte(d0)='andi.\td0,d0,0xff',
 ReUWord(d0)='andi.\td0,d0,0xffff',

 Rnd(d0),
 RndQ(d0)='add.\td0,d0,d0 \n\tbgt\t$+12 \n\txori\td0,d0,0x2b41 \n\txoris\td0,d0,0x1d87\t#RndQ',

 ->Inp(d1), ->macro
 ->Out(d1,d2),->macro (buffered)

 ->SizePooled(a0)='lwz\td0,-4(a0)',
 AllocVecPooled(a0,d0),
 FreeVecPooled(a0,a1),

 ReNewR(d0),
 ReDispose(a1),
 ReDisposeAll(),

 Raise(d0=NIL,d1=NIL),

// Quoted Expression functions /////////
-> Eval(a0)='mflr\tr0 \n\tpush\tr0\n\tmtctr\ta0 \n\tbctrl \n\tpop\tr0 \n\tmtlr\tr0',
-> Eval(a0)='mflr\tr0 \n\tpush\tr0\n\tmtlr\ta0 \n\tblrl \n\tpop\tr0 \n\tmtlr\tr0',
 Eval(a0)='mtlr\ta0 \n\tblrl',
// Exists(a0:PTR TO LONG,a1:PTR TO LONG,d0,a2:PTR TO LONG),
// ForAll(a0:PTR TO LONG,a1:PTR TO LONG,d0,a2:PTR TO LONG),
// MapList(a0:PTR TO LONG,a1:PTR TO LONG,a2:PTR TO LONG,d0,a3:PTR TO LONG),
// SelectList(a0:PTR TO LONG,a1:PTR TO LONG,a2:PTR TO LONG,d0,a3:PTR TO LONG)


// graphics functions //////////////////
 SetStdRast(d1)='law\ta6,_stdrast \n\tlwz\td0,0(a6) \n\tmr.\td1,d1 \n\tbeq\t$+8 \n\tstw\td1,0(a6)',

// Intuition support functions /////////
 Mouse(),
 MouseX(a0)='lhz\td0,14(a0)',
 MouseY(a0)='lhz\td0,12(a0)'



LIBRARY LINK
// String/EString functions ////////////
 String(maxlen),

 ReadEStr(fh,estr),
// ReEStr(estr),
// RightEStr(dstr,sstr,length),
// RightStr(dstr,sstr,length),

 StringF(s,f,l=NIL:LIST OF LONG),
 VStringF(s,f,l=NIL:PTR TO LONG),
->#define VStringF(str,fmt,list) RawDoFmtPPC(fmt,list,0,str)
 WriteF(a,b=NIL:LIST OF LONG),
-> VWriteF(a,b=NIL:PTR TO LONG),

 Val(s:PTR TO UBYTE,n=0),

// Dos support functions /////////
 FileLength(name),


// graphics functions //////////////////
 SetColour(scr,n,r,g,b),
 SetTopaz(size),
 Colour(reg,n=0),
 Plot(x,y,c=-1),
 Line(x1,y1,x2,y2,c=-1),
 Box(x0,y0,x1,y1,c=-1),
 Ellipse(x,y,w,h,c=-1),
 Circle(x,y,r,c=-1),
 TextF(x,y,fmt,args=0:LIST OF LONG),


// Intuition support functions /////////
 WaitIMessage(win),
 MsgCode(),
 MsgQualifier(),
 MsgIaddr(),

 OpenW(l,t,w,h,i,f,n=NIL,s=NIL,st=1,g=NIL,tags=NIL:PTR TO LONG),
 CloseW(win),
 OpenS(w,h,d,t=0,n=NIL,tags=NIL:PTR TO LONG),
 Gadget(buf,glist,id,flags,x,y,width,string),

// FPU functions ///////////////////////
 RealVal(s),
 RealF(s,x,n),
// misc functions //////////////////////
 KickVersion(ver)


#define MidEStr(estr,str,pos,len) EStrCopy(estr,(str)+(pos),len)

#define ReadStr ReadEStr
->#define ReadStr(fh,str) FGets(fh,str,EStrLen(str)) ; str[StrLen(str)-1].CHAR:=0 ->null terminate
->#define ReadStr(fh,str) str[StrLen(str)-1].CHAR:=0

#define Char UByte
#define Int UWord

#define In  FGetC
#define Out FPutC

#define CloseS CloseScreen

#define CtrlC() (SetSignal(0,$1000) AND $1000)
#define CtrlD() (SetSignal(0,$2000) AND $2000)
#define CtrlE() (SetSignal(0,$4000) AND $4000)
#define CtrlF() (SetSignal(0,$8000) AND $8000)

#define Throw Raise
#define ReThrow() IF exception THEN Raise(exception)
#define CleanUp Raise

/* put value in register
PROC setA4(a REG a4)=''
PROC setA5(a REG a5)=''
*/