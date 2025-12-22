(*

Sub-Pascal 32-bit real mode compiler for 80386+ processors v. 2.0 by Vasiliy Tereshkov, 2009

https://atariage.com/forums/topic/240919-mad-pascal/
https://habr.com/en/post/440372/?fbclid=IwAR3SdW_HAqt6psraDj41UtNxFEXIgynOUKvS2d2cwPsJiF0kO_kDTNfYZg4

Mad-Pascal cross compiler for 6502 (Atari XE/XL) by Tomasz Biela, 2015-2019

Contributors:

+ Bocianu Boczansky :
	- library BLIBS: B_CRT, B_DL, B_PMG, B_SYSTEM, B_UTILS, XBIOS
	- MADSTRAP
	- PASDOC

+ Bostjan Gorisek :
	- unit PMG, ZXLIB

+ David Schmenk :
	- IEEE-754 (32bit) single

+ DMSC :
	- conditional directives {$IFDEF}, {$ELSE}, {$DEFINE} ...
	- fast SIN/COS (IEEE754-32 precision)
	- unit GRAPHICS: TextOut
	- unit EFAST

+ Draco :
	- unit MISC: DetectCPU, DetectCPUSpeed, DetectMem, DetectHighMem

+ Eru / TQA :
	- unit FASTGRAPH: fLine

+ Seban / Slight :
	- unit MISC: DetectStereo

+ Steven Don :
	- unit IMAGE, VIMAGE

+ Ullrich von Bassewitz, Christian Krueger :
	- unit SYSTEM: MOVE, FILLCHAR


# rejestr X uzywany jest do przekazywania parametrow przez programowy stos :STACKORIGIN
# stos programowy sluzy tez do tymczasowego przechowywania wyrazen, wynikow operacji itp.

# typ REAL Fixed-Point Q16.16 przekracza 32 bity dla MUL i DIV, czêsty OVERFLOW

# uzywaj asm65('') zamiast #13#10, POS bedzie wlasciwie zwracalo indeks

# wystepuja tylko skoki w przod @+ (@- nie istnieje)

# edx+2, edx+3 nie wystepuje

# wartosc dla typu POINTER zwiekszana jest o CODEORIGIN

# BP  tylko przy adresowaniu bajtu
# BP2 przy adresowaniu wiecej niz 1 bajtu (WORD, CARDINAL itd.)

# indeks dla jednowymiarowej tablicy [0..x] = a * DataSize[AllocElementType]
# indeks dla dwuwymiarowej tablicy [0..x, 0..y] = a * ((y+1) * DataSize[AllocElementType]) + b * DataSize[AllocElementType]

# tablice typu RECORD, OBJECT sa tylko jendowymiarowe [0..x], OBJECT nie testowane

# dla typu OBJECT przekazywany jest poczatkowy adres alokacji danych pamieci (HI = regY, LO = regA), potem sa obliczane kolejne adresy w naglowku procedury/funkcji

# optymalizator usuwa odwolania do :STACKORIGIN+STACKWIDTH*2+9 gdy operacja ADC, SBC konczy sie na takim odwolaniu

*)


program MADPASCAL;

//{$DEFINE USEOPTFILE}

{$DEFINE OPTIMIZECODE}

{$INLINE ON}

{$I+}

uses
  SysUtils;

const

  title = '1.6.3';

  TAB = ^I;		// Char for a TAB
  CR  = ^M;		// Char for a CR
  LF  = ^J;		// Char for a LF

  AllowDirectorySeparators : set of char = ['/','\'];

  AllowWhiteSpaces	: set of char = [' ',TAB,CR,LF];
  AllowQuotes		: set of char = ['''','"'];
  AllowLabelFirstChars	: set of char = ['A'..'Z','_'];
  AllowLabelChars	: set of char = ['A'..'Z','0'..'9','_','.'];
  AllowDigitFirstChars	: set of char = ['0'..'9','%','$'];
  AllowDigitChars	: set of char = ['0'..'9','A'..'F'];


  // Token codes

  UNTYPETOK		= 0;

  CONSTTOK		= 1;     // !!! nie zmieniac
  TYPETOK		= 2;     // !!!
  VARTOK		= 3;     // !!!
  PROCEDURETOK		= 4;     // !!!
  FUNCTIONTOK		= 5;     // !!!
  LABELTOK		= 6;	 // !!!
  UNITTOK		= 7;	 // !!!
  //ENUMTOK		= 8;	 // !!!

  GETINTVECTOK		= 10;
  SETINTVECTOK		= 11;
  CASETOK		= 12;
  BEGINTOK		= 13;
  ENDTOK		= 14;
  IFTOK			= 15;
  THENTOK		= 16;
  ELSETOK		= 17;
  WHILETOK		= 18;
  DOTOK			= 19;
  REPEATTOK		= 20;
  UNTILTOK		= 21;
  FORTOK		= 22;
  TOTOK			= 23;
  DOWNTOTOK		= 24;
  ASSIGNTOK		= 25;
  WRITETOK		= 26;
  READLNTOK		= 27;
  HALTTOK		= 28;
  USESTOK		= 29;
  ARRAYTOK		= 30;
  OFTOK			= 31;
  STRINGTOK		= 32;
  INCTOK		= 33;
  DECTOK		= 34;
  ORDTOK		= 35;
  CHRTOK		= 36;
  ASMTOK		= 37;
  ABSOLUTETOK		= 38;
  BREAKTOK		= 39;
  CONTINUETOK		= 40;
  EXITTOK		= 41;
  RANGETOK		= 42;

  EQTOK			= 43;
  NETOK			= 44;
  LTTOK			= 45;
  LETOK			= 46;
  GTTOK			= 47;
  GETOK			= 48;
  LOTOK			= 49;
  HITOK			= 50;

  DOTTOK		= 51;
  COMMATOK		= 52;
  SEMICOLONTOK		= 53;
  OPARTOK		= 54;
  CPARTOK		= 55;
  DEREFERENCETOK	= 56;
  ADDRESSTOK		= 57;
  OBRACKETTOK		= 58;
  CBRACKETTOK		= 59;
  COLONTOK		= 60;

  PLUSTOK		= 61;
  MINUSTOK		= 62;
  MULTOK		= 63;
  DIVTOK		= 64;
  IDIVTOK		= 65;
  MODTOK		= 66;
  SHLTOK		= 67;
  SHRTOK		= 68;
  ORTOK			= 69;
  XORTOK		= 70;
  ANDTOK		= 71;
  NOTTOK		= 72;

  ASSIGNFILETOK		= 73;
  RESETTOK		= 74;
  REWRITETOK		= 75;
  APPENDTOK		= 76;
  BLOCKREADTOK		= 77;
  BLOCKWRITETOK		= 78;
  CLOSEFILETOK		= 79;

  WRITELNTOK		= 80;
  SIZEOFTOK		= 81;
  LENGTHTOK		= 82;
  HIGHTOK		= 83;
  LOWTOK		= 84;
  INTTOK		= 85;
  FRACTOK		= 86;
  TRUNCTOK		= 87;
  ROUNDTOK		= 88;
  ODDTOK		= 89;

  PROGRAMTOK		= 90;
  INTERFACETOK		= 91;
  IMPLEMENTATIONTOK     = 92;
  INITIALIZATIONTOK     = 93;
  OVERLOADTOK		= 94;
  ASSEMBLERTOK		= 95;
  FORWARDTOK		= 96;
  REGISTERTOK		= 97;
  INTERRUPTTOK		= 98;

  SUCCTOK		= 100;
  PREDTOK		= 101;
  PACKEDTOK		= 102;
  GOTOTOK		= 104;
  INTOK			= 105;

  SETTOK		= 127;	// Size = 32 SET OF

  BYTETOK		= 128;	// Size = 1 BYTE
  WORDTOK		= 129;	// Size = 2 WORD
  CARDINALTOK		= 130;	// Size = 4 CARDINAL
  SHORTINTTOK		= 131;	// Size = 1 SHORTINT
  SMALLINTTOK		= 132;	// Size = 2 SMALLINT
  INTEGERTOK		= 133;	// Size = 4 INTEGER
  CHARTOK		= 134;	// Size = 1 CHAR
  BOOLEANTOK		= 135;	// Size = 1 BOOLEAN
  POINTERTOK		= 136;	// Size = 2 POINTER
  STRINGPOINTERTOK	= 137;	// Size = 2 POINTER to STRING
  FILETOK		= 138;	// Size = 2/12 FILE
  RECORDTOK		= 139;	// Size = 2/???
  OBJECTTOK		= 140;	// Size = 2/???
  SHORTREALTOK		= 141;	// Size = 2 SHORTREAL			Fixed-Point Q8.8
  REALTOK		= 142;	// Size = 4 REAL			Fixed-Point Q24.8
  SINGLETOK		= 143;	// Size = 4 SINGLE/FLOAT		IEEE-754
  PCHARTOK		= 144;	// Size = 2 POINTER TO ARRAY OF CHAR
  ENUMTOK		= 145;	// Size = 1 BYTE

  FLOATTOK		= 146;	// zamieniamy na SINGLETOK

  DATAORIGINOFFSET	= 150;
  CODEORIGINOFFSET	= 151;

  IDENTTOK		= 180;
  INTNUMBERTOK		= 181;
  FRACNUMBERTOK		= 182;
  CHARLITERALTOK	= 183;
  STRINGLITERALTOK	= 184;
//  UNKNOWNIDENTTOK	= 185;

  INFOTOK		= 192;
  WARNINGTOK		= 193;
  ERRORTOK		= 194;
  UNITBEGINTOK		= 195;
  UNITENDTOK		= 196;
  IOCHECKON		= 197;
  IOCHECKOFF		= 198;
  EOFTOK		= 199;     // MAXTOKENNAMES = 200

  UnsignedOrdinalTypes	= [BYTETOK, WORDTOK, CARDINALTOK];
  SignedOrdinalTypes	= [SHORTINTTOK, SMALLINTTOK, INTEGERTOK];
  RealTypes		= [SHORTREALTOK, REALTOK, SINGLETOK];

  IntegerTypes		= UnsignedOrdinalTypes + SignedOrdinalTypes;
  OrdinalTypes		= IntegerTypes + [CHARTOK, BOOLEANTOK];

  Pointers		= [POINTERTOK, STRINGPOINTERTOK];

  AllTypes		= OrdinalTypes + RealTypes + Pointers;

  StringTypes		= [STRINGLITERALTOK, STRINGTOK, PCHARTOK];

  // Identifier kind codes

  CONSTANT		= CONSTTOK;
  USERTYPE		= TYPETOK;
  VARIABLE		= VARTOK;
  PROC			= PROCEDURETOK;
  FUNC			= FUNCTIONTOK;
  LABELTYPE		= LABELTOK;
  UNITTYPE		= UNITTOK;

  ENUMTYPE		= ENUMTOK;

  // Compiler parameters

  MAXNAMELENGTH		= 32;
  MAXTOKENNAMES		= 200;
  MAXSTRLENGTH		= 255;
  MAXFIELDS		= 256;
  MAXTYPES		= 1024;
//  MAXTOKENS		= 32768;
  MAXIDENTS		= 16384;
  MAXBLOCKS		= 16384;	// maksymalna liczba blokow
  MAXPARAMS		= 8;		// maksymalna liczba parametrow dla PROC, FUNC
  MAXVARS		= 256;		// maksymalna liczba parametrów dla VAR
  MAXUNITS		= 128;
  MAXDEFINES		= 256;		// maksymalna liczba $DEFINE
  MAXALLOWEDUNITS	= 16;

  CODEORIGIN		= $100;
  DATAORIGIN		= $8000;

  CALLDETERMPASS	= 1;
  CODEGENERATIONPASS	= 2;

  // Indirection levels

  ASVALUE		 = 0;
  ASPOINTER		 = 1;
  ASPOINTERTOPOINTER	 = 2;
  ASPOINTERTOARRAYORIGIN = 3;
  ASPOINTERTOARRAYORIGIN2= 4;
  ASPOINTERTORECORD	 = 5;
  ASPOINTERTOARRAYRECORD = 6;
  //ASPOINTERTOARRAYRECORDORIGIN = 7;

  ASCHAR		= 6;	// GenerateWriteString
  ASBOOLEAN		= 7;
  ASREAL		= 8;
  ASSHORTREAL		= 9;
  ASSINGLE		= 10;
  ASPCHAR		= 11;

  OBJECTVARIABLE	= 1;
  RECORDVARIABLE	= 2;

  // Fixed-point 32-bit real number storage

  FRACBITS		= 8;	// Float Fixed Point
  TWOPOWERFRACBITS	= 256;

  // Parameter passing

  VALPASSING		= 1;
  CONSTPASSING		= 2;
  VARPASSING		= 3;


  // Data sizes

  DataSize: array [BYTETOK..ENUMTOK] of Byte = (1,2,4,1,2,4,1,1,2,2,2,2,2,2,4,4,2,1);

  fBlockRead_ParamType : array [1..3] of byte = (POINTERTOK, WORDTOK, POINTERTOK);

type

  ModifierCode = (mOverload= $80, mInterrupt = $40, mRegister = $20, mAssembler = $10, mForward = $08);

  irCode = (iDLI, iVBL);

  ioCode = (ioOpenRead = 4, ioRead = 7, ioOpenWrite = 8, ioOpenAppend = 9, ioWrite = $0b, ioOpenReadWrite = $0c, ioFileMode = $f0, ioClose = $ff);

  ErrorCode =
  (
  UnknownIdentifier, OParExpected, IdentifierExpected, IncompatibleTypeOf, UserDefined,
  IdNumExpExpected, IncompatibleTypes, IncompatibleEnum, OrdinalExpectedFOR, CantAdrConstantExp,
  VariableExpected, WrongNumParameters, OrdinalExpExpected, RangeCheckError, RangeCheckError_,
  VariableNotInit, ShortStringLength, StringTruncated, TypeMismatch, CantReadWrite,
  SubrangeBounds, TooManyParameters, CantDetermine, UpperBoundOfRange, HighLimit,
  IllegalTypeConversion, IncompatibleTypesArray, IllegalExpression, AlwaysTrue, AlwaysFalse,
  UnreachableCode, IllegalQualifier, LoHi
  );

  code65 =
  (
  __je, __jne, __jg, __jge, __jl, __jle,
  __putCHAR, __putEOL,
  __addBX, __subBX, __movaBX_Value,
  __imulECX,
  __notaBX, __negaBX, __notBOOLEAN,
  __addAL_CL, __addAX_CX, __addEAX_ECX,
  __shlAL_CL, __shlAX_CL, __shlEAX_CL,
  __subAL_CL, __subAX_CX, __subEAX_ECX,
  __cmpAX_CX, __cmpEAX_ECX, __cmpINT, __cmpSHORTINT, __cmpSMALLINT,
  __cmpSTRING, __cmpSTRING2CHAR, __cmpCHAR2STRING,
  __shrAL_CL, __shrAX_CL, __shrEAX_CL,
  __andEAX_ECX, __andAX_CX, __andAL_CL,
  __orEAX_ECX, __orAX_CX, __orAL_CL,
  __xorEAX_ECX, __xorAX_CX, __xorAL_CL

  );

  TString = string [MAXSTRLENGTH];
  TName   = string [MAXNAMELENGTH];

  TParam = record
    Name: TString;
    DataType: Byte;
    NumAllocElements: Cardinal;
    AllocElementType: Byte;
    PassMethod: Byte;
    end;

  TFloat = array [0..1] of integer;

  TParamList = array [1..MAXPARAMS] of TParam;

  TVariableList = array [1..MAXVARS] of TParam;

  TField = record
    Name: TName;
    Value: Int64;
    DataType: Byte;
    NumAllocElements: Cardinal;
    AllocElementType: Byte;
    Kind: Byte;
  end;

  TType = record
    Block: Integer;
    NumFields: Integer;
    Field: array [0..MAXFIELDS] of TField;
  end;

  TToken = record
    UnitIndex: Integer;
    Line, Column: Integer;
    case Kind: Byte of
      IDENTTOK:
	(Name: ^TString);
      INTNUMBERTOK:
	(Value: Int64);
      FRACNUMBERTOK:
	(FracValue: Single);
      STRINGLITERALTOK:
	(StrAddress: Word;
	 StrLength: Word);
    end;

  TIdentifier = record
    Name: TString;
    Value: Int64;			// Value for a constant, address for a variable, procedure or function
    Block: Integer;			// Index of a block in which the identifier is defined
    UnitIndex : Integer;
    DataType: Byte;
    IdType: Byte;
    PassMethod: Byte;
    Pass: Byte;

    NestedFunctionNumAllocElements: cardinal;
    NestedFunctionAllocElementType: Byte;
    isNestedFunction: Boolean;

    LoopVariable,
    isAbsolute,
    isInit,
    isInitialized,
    Section: Boolean;

    case Kind: Byte of
      PROC, FUNC:
	(NumParams: Word;
	 Param: TParamList;
	 ProcAsBlock: Integer;
	 ObjectIndex: Integer;
	 IsUnresolvedForward: Boolean;
	 isOverload: Boolean;
	 isRegister: Boolean;
	 isInterrupt: Boolean;
	 isRecursion: Boolean;
	 isAsm: Boolean;
	 IsNotDead: Boolean;);

      VARIABLE, USERTYPE:
	(NumAllocElements, NumAllocElements_: Cardinal;
	 AllocElementType: Byte);
    end;


  TCallGraphNode =
    record
     ChildBlock: array [1..MAXBLOCKS] of Integer;
     NumChildren: Word;
    end;

  TUnit =
    record
     Name: TString;
     Path: String;
     Units: byte;
     Allow: array [1..MAXALLOWEDUNITS] of TString;
    end;

  TOptimizeBuf =
    record
     line, comment: string;
    end;

  TResource =
    record
     resName, resType, resFile: TString;
     resFullName: string;
     resPar: array [1..MAXPARAMS] of TString;
    end;

  TCaseLabel =
    record
     left, right: Int64;
     equality: Boolean;
    end;

  TPosStack =
    record
     ptr: word;
     brk, cnt: Boolean;
    end;

  TCaseLabelArray = array of TCaseLabel;

  TArrayString = array of string;

var

  PROGRAM_NAME: string = 'Program';

  AsmBlock: array [0..4095] of string;

  Data, DataSegment, StaticStringData: array [0..$FFFF] of Word;

  Types: array [1..MAXTYPES] of TType;
  Tok: array of TToken;
  Ident: array [1..MAXIDENTS] of TIdentifier;
  Spelling: array [1..MAXTOKENNAMES] of TString;
  UnitName: array [1..MAXUNITS + MAXUNITS] of TUnit;
  Defines: array [1..MAXDEFINES] of TName;
  IFTmpPosStack: array of integer;
  BreakPosStack: array [0..1023] of TPosStack;
  CodePosStack: array [0..1023] of Word;
  BlockStack: array [0..MAXBLOCKS - 1] of Integer;
  CallGraph: array [1..MAXBLOCKS] of TCallGraphNode;	// For dead code elimination

  OldConstValType: byte;

  NumTok: integer = 0;

  AddDefines: integer = 1;
  NumDefines: integer = 1;	// NumDefines = AddDefines

  i, NumIdent, NumTypes, NumPredefIdent, NumStaticStrChars, NumUnits, NumBlocks,
  BlockStackTop, CodeSize, CodePosStackTop, BreakPosStackTop, VarDataSize, Pass, iOut,
  NumStaticStrCharsTmp, AsmBlockIndex, IfCnt, CaseCnt, IfdefLevel: Integer;

  start_time: QWord;

  CODEORIGIN_Atari: integer = $2000;

   DATA_Atari: integer = -1;
  ZPAGE_Atari: integer = -1;
  STACK_Atari: integer = -1;

  UnitNameIndex: Integer = 1;

  FastMul: Integer = -1;

  CPUMode: Integer = 6502;

  OutFile: TextFile;

  asmLabels: array of integer;

  TemporaryBuf: array [0..31] of string;

  OptimizeBuf: array of TOptimizeBuf;

  resArray: array of TResource;

  MainPath, FilePath, optyA, optyY, optyBP2: string;
  optyFOR0, optyFOR1, optyFOR2, optyFOR3, outTmp: string;

  msgWarning, msgNote, msgUser, UnitPath: TArrayString;

  optimize : record
	      use, assign: Boolean;
	      unitIndex, line: integer;
	     end;


  PROGRAMTOK_USE, INTERFACETOK_USE: Boolean;
  OutputDisabled, isConst, isError, IOCheck: Boolean;

  DiagMode: Boolean = false;
  DataSegmentUse: Boolean = false;

  PublicSection : Boolean = true;


{$IFDEF USEOPTFILE}

  OptFile: TextFile;

{$ENDIF}



function StrToInt(const a: string): Int64;
(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)
var i: integer;
begin
 val(a,Result, i);
end;


function IntToStr(const a: Int64): string;
(*----------------------------------------------------------------------------*)
(*----------------------------------------------------------------------------*)
begin
 str(a, Result);
end;


function Min(a,b: integer): integer;
begin

 if a < b then
  Result := a
 else
  Result := b;

end;


procedure FreeTokens;
var i: Integer;
begin

 for i := 1 to NumTok do
  if (Tok[i].Kind = IDENTTOK) and (Tok[i].Name <> nil) then Dispose(Tok[i].Name);

 SetLength(Tok, 0);
 SetLength(IFTmpPosStack, 0);
 SetLength(UnitPath, 0);
end;


function GetSpelling(i: Integer): TString;
begin

if i > NumTok then
  Result := 'no token'
else if (Tok[i].Kind > 0) and (Tok[i].Kind < IDENTTOK) then
  Result := Spelling[Tok[i].Kind]
else if Tok[i].Kind = IDENTTOK then
  Result := 'identifier'
else if (Tok[i].Kind = INTNUMBERTOK) or (Tok[i].Kind = FRACNUMBERTOK) then
  Result := 'number'
else if (Tok[i].Kind = CHARLITERALTOK) or (Tok[i].Kind = STRINGLITERALTOK) then
  Result := 'literal'
else if (Tok[i].Kind = UNITENDTOK) then
  Result := 'END'
else if (Tok[i].Kind = EOFTOK) then
  Result := 'end of file'
else
  Result := 'unknown token';

end;


function ErrTokenFound(ErrTokenIndex: Integer): string;
begin

 Result:=' expected but ''' + GetSpelling(ErrTokenIndex) + ''' found';

end;


function InfoAboutToken(t: Byte): string;
begin

   case t of

	 EQTOK: Result := '=';
	 NETOK: Result := '<>';
	 LTTOK: Result := '<';
	 LETOK: Result := '<=';
	 GTTOK: Result := '>';
	 GETOK: Result := '>=';

	 INTOK: Result := 'IN';

	DOTTOK: Result := '.';
      COMMATOK: Result := ',';
  SEMICOLONTOK: Result := ';';
       OPARTOK: Result := '(';
       CPARTOK: Result := ')';
DEREFERENCETOK: Result := '^';
    ADDRESSTOK: Result := '@';
   OBRACKETTOK: Result := '[';
   CBRACKETTOK: Result := ']';
      COLONTOK: Result := ':';
       PLUSTOK: Result := '+';
      MINUSTOK: Result := '-';
	MULTOK: Result := '*';
	DIVTOK: Result := '/';

       IDIVTOK: Result := 'DIV';
	MODTOK: Result := 'MOD';
	SHLTOK: Result := 'SHL';
	SHRTOK: Result:= 'SHR';
	 ORTOK: Result := 'OR';
	XORTOK: Result := 'XOR';
	ANDTOK: Result := 'AND';
	NOTTOK: Result := 'NOT';

      CONSTTOK: Result := 'CONST';
       TYPETOK: Result := 'TYPE';
	VARTOK: Result := 'VARIABLE';
  PROCEDURETOK: Result := 'PROCEDURE';
   FUNCTIONTOK: Result := 'FUNCTION';
      LABELTOK: Result := 'LABEL';
       UNITTOK: Result := 'UNIT';
      ENUMTYPE: Result := 'ENUM';

     RECORDTOK: Result := 'RECORD';
     OBJECTTOK: Result := 'OBJECT';
       BYTETOK: Result := 'BYTE';
   SHORTINTTOK: Result := 'SHORTINT';
       CHARTOK: Result := 'CHAR';
    BOOLEANTOK: Result := 'BOOLEAN';
       WORDTOK: Result := 'WORD';
   SMALLINTTOK: Result := 'SMALLINT';
   CARDINALTOK: Result := 'CARDINAL';
    INTEGERTOK: Result := 'INTEGER';
    POINTERTOK,
    DATAORIGINOFFSET,
    CODEORIGINOFFSET: Result := 'POINTER';

 STRINGPOINTERTOK: Result := 'STRING';

  SHORTREALTOK: Result := 'SHORTREAL';
       REALTOK: Result := 'REAL';
     SINGLETOK: Result := 'SINGLE';
	SETTOK: Result := 'SET';
       FILETOK: Result := 'FILE';
      PCHARTOK: Result := 'PCHAR';
 else
  Result := 'UNTYPED'
 end;

end;


procedure WritelnMsg;
var i: integer;
begin

 for i := 0 to High(msgWarning) - 1 do writeln(msgWarning[i]);

 for i := 0 to High(msgNote) - 1 do writeln(msgNote[i]);

end;


function GetEnumName(IdentIndex: integer): TString;
var IdentTtemp: integer;


  function Search(Num: cardinal): integer;
  var IdentIndex, BlockStackIndex: Integer;
  begin

    Result := 0;

    for BlockStackIndex := BlockStackTop downto 0 do	// search all nesting levels from the current one to the most outer one
    for IdentIndex := 1 to NumIdent do
      if (Ident[IdentIndex].DataType = ENUMTYPE) and (Ident[IdentIndex].NumAllocElements = Num) and (BlockStack[BlockStackIndex] = Ident[IdentIndex].Block) then
	exit(IdentIndex);
  end;


begin

 Result := '';

 if Ident[IdentIndex].NumAllocElements > 0 then begin
  IdentTtemp := Search(Ident[IdentIndex].NumAllocElements);

  if IdentTtemp > 0 then
   Result := Ident[IdentTtemp].Name;
 end else
  if Ident[IdentIndex].DataType = ENUMTYPE then begin
   IdentTtemp := Search(Ident[IdentIndex].NumAllocElements);

   if IdentTtemp > 0 then
    Result := Ident[IdentTtemp].Name;
  end;

end;


function LowBound(i: integer; DataType: Byte): Int64; forward;
function HighBound(i: integer; DataType: Byte): Int64; forward;


function ErrorMessage(ErrTokenIndex: Integer; err: ErrorCode; IdentIndex: Integer = 0; SrcType: Int64 = 0; DstType: Int64 = 0): string;
begin

 Result := '';

 case err of

	UserDefined: Result := 'User defined: ' + msgUser[Tok[ErrTokenIndex].Value];

  UnknownIdentifier: Result := 'Identifier not found ''' + Tok[ErrTokenIndex].Name^ + '''';
 IncompatibleTypeOf: Result := 'Incompatible type of ' + Ident[IdentIndex].Name;
   IncompatibleEnum: if DstType < 0 then
   			Result := 'Incompatible types: got "'+GetEnumName(SrcType)+'" expected "'+InfoAboutToken(abs(DstType))+ '"'
		     else
   		     if SrcType < 0 then
   			Result := 'Incompatible types: got "'+InfoAboutToken(abs(SrcType))+'" expected "'+GetEnumName(DstType)+ '"'
		     else
   	   		Result := 'Incompatible types: got "'+GetEnumName(SrcType)+'" expected "'+GetEnumName(DstType)+ '"';

 WrongNumParameters: Result := 'Wrong number of parameters specified for call to ' + Ident[IdentIndex].Name;

 CantAdrConstantExp: Result := 'Can''t take the address of constant expressions';

       OParExpected: Result := '''(''' + ErrTokenFound(ErrTokenIndex);

  IllegalExpression: Result := 'Illegal expression';
   VariableExpected: Result := 'Variable identifier expected';
 OrdinalExpExpected: Result := 'Ordinal expression expected';
 OrdinalExpectedFOR: Result := 'Ordinal expression expected as ''FOR'' loop counter value';
  IncompatibleTypes: Result := 'Incompatible types: got "'+InfoAboutToken(SrcType)+'" expected "'+InfoAboutToken(DstType)+ '"';
 IdentifierExpected: Result := 'Identifier' + ErrTokenFound(ErrTokenIndex);
   IdNumExpExpected: Result := 'Identifier, number or expression' + ErrTokenFound(ErrTokenIndex);

	       LoHi: Result := 'lo/hi(dword/qword) returns the upper/lower word/dword';

     IllegalTypeConversion, IncompatibleTypesArray:
		     begin

		      if err = IllegalTypeConversion then
     		       Result := 'Illegal type conversion: "Array[0..'
		      else begin
		       Result := 'Incompatible types: got ';
		       if Ident[IdentIndex].NumAllocElements > 0 then Result := Result + '"Array[0..';
		      end;


     		      if Ident[IdentIndex].NumAllocElements_ > 0 then
		       Result := Result + IntToStr(Ident[IdentIndex].NumAllocElements-1)+'] Of Array[0..'+IntToStr(Ident[IdentIndex].NumAllocElements_-1)+'] Of '+InfoAboutToken(Ident[IdentIndex].AllocElementType)+'" '
       		      else
		       if Ident[IdentIndex].NumAllocElements = 0 then begin

			if Ident[IdentIndex].AllocElementType <> UNTYPETOK then
			 Result := Result + '"^'+InfoAboutToken(Ident[IdentIndex].AllocElementType)+'" '
			else
			 Result := Result + '"'+InfoAboutToken(POINTERTOK)+'" ';

		       end else
			Result := Result + IntToStr(Ident[IdentIndex].NumAllocElements-1)+'] Of '+InfoAboutToken(Ident[IdentIndex].AllocElementType)+'" ';

		      if err = IllegalTypeConversion then
		       Result := Result + 'to "'+InfoAboutToken(SrcType)+'"'
		      else
		       if SrcType < 0 then begin

       			Result := Result + 'expected "Array[0..';

			if Ident[abs(SrcType)].NumAllocElements_ > 0 then
			 Result := Result + IntToStr(Ident[abs(SrcType)].NumAllocElements-1)+'] Of Array[0..'+IntToStr(Ident[abs(SrcType)].NumAllocElements_-1)+'] Of '+InfoAboutToken(Ident[IdentIndex].AllocElementType)+'" '
       			else
			 Result := Result + IntToStr(Ident[abs(SrcType)].NumAllocElements-1)+'] Of '+InfoAboutToken(Ident[abs(SrcType)].AllocElementType)+'" ';

		       end else
			Result := Result + 'expected "'+InfoAboutToken(SrcType)+'"';

		     end;

	 AlwaysTrue: Result := 'Comparison might be always true due to range of constant and expression';

	AlwaysFalse: Result := 'Comparison might be always false due to range of constant and expression';

    RangeCheckError: begin
   		      Result := 'Range check error while evaluating constants ('+IntToStr(SrcType)+' must be between '+IntToStr(LowBound(ErrTokenIndex, DstType))+' and ';

		      if IdentIndex > 0 then
		       Result := Result + IntToStr(Ident[IdentIndex].NumAllocElements-1)+')'
		      else
		       Result := Result + IntToStr(HighBound(ErrTokenIndex, DstType))+')';

		     end;

   RangeCheckError_: begin
		      Result := 'Range check error while evaluating constants ('+IntToStr(SrcType)+' must be between '+IntToStr(LowBound(ErrTokenIndex, DstType))+' and ';

		      if IdentIndex > 0 then
		       Result := Result + IntToStr(Ident[IdentIndex].NumAllocElements_-1)+')'
		      else
		       Result := Result + IntToStr(HighBound(ErrTokenIndex, DstType))+')';

		     end;

    VariableNotInit: Result := 'Variable '''+Ident[IdentIndex].Name+''' does not seem to be initialized';
  ShortStringLength: Result := 'String literal has more characters than short string length';
    StringTruncated: Result := 'String constant truncated to fit STRING['+IntToStr(Ident[IdentIndex].NumAllocElements - 1)+']';
      CantReadWrite: Result := 'Can''t read or write variables of this type';
       TypeMismatch: Result := 'Type mismatch';
    UnreachableCode: Result := 'Unreachable code';
   IllegalQualifier: Result := 'Illegal qualifier';
     SubrangeBounds: Result := 'Constant expression violates subrange bounds';
  TooManyParameters: Result := 'Too many formal parameters in ' + Ident[IdentIndex].Name;
      CantDetermine: Result := 'Can''t determine which overloaded function '''+ Ident[IdentIndex].Name +''' to call';
  UpperBoundOfRange: Result := 'Upper bound of range is less than lower bound';
	  HighLimit: Result := 'High range limit > '+IntToStr(High(word));

 end;

end;


procedure iError(ErrTokenIndex: Integer; err: ErrorCode; IdentIndex: Integer = 0; SrcType: Int64 = 0; DstType: Int64 = 0);
var Msg: string;
begin

 if not isConst then begin

 //Tok[NumTok-1].Column := Tok[NumTok].Column + Tok[NumTok-1].Column;

 WritelnMsg;

 Msg:=ErrorMessage(ErrTokenIndex, err, IdentIndex, SrcType, DstType);

 if ErrTokenIndex > NumTok then ErrTokenIndex := NumTok;
 WriteLn(UnitName[Tok[ErrTokenIndex].UnitIndex].Path + ' (' + IntToStr(Tok[ErrTokenIndex].Line) + ',' + IntToStr(Succ(Tok[ErrTokenIndex - 1].Column)) + ')'  + ' Error: ' + Msg);

 FreeTokens;

 CloseFile(OutFile);
 Erase(OutFile);

 Halt(2);

 end;

 isError := true;

end;


procedure Error(ErrTokenIndex: Integer; Msg: string);
begin

 if not isConst then begin

 //Tok[NumTok-1].Column := Tok[NumTok].Column + Tok[NumTok-1].Column;

 WritelnMsg;

 if ErrTokenIndex > NumTok then ErrTokenIndex := NumTok;

 WriteLn(UnitName[Tok[ErrTokenIndex].UnitIndex].Path + ' (' + IntToStr(Tok[ErrTokenIndex].Line) + ',' + IntToStr(Succ(Tok[ErrTokenIndex - 1].Column)) + ')'  + ' Error: ' + Msg);

 FreeTokens;

 CloseFile(OutFile);
 Erase(OutFile);

 Halt(2);

 end;

 isError := true;

end;


procedure Warning(WarnTokenIndex: Integer; err: ErrorCode; IdentIndex: Integer = 0; SrcType: Int64 = 0; DstType: Int64 = 0);
var i: integer;
    Msg, a: string;
    Yes: Boolean;
begin

 if Pass = CODEGENERATIONPASS then begin

  Msg:=ErrorMessage(WarnTokenIndex, err, IdentIndex, SrcType, DstType);

  a := UnitName[Tok[WarnTokenIndex].UnitIndex].Path + ' (' + IntToStr(Tok[WarnTokenIndex].Line) + ')' + ' Warning: ' + Msg;

  Yes := false;

  for i := High(msgWarning)-1 downto 0 do
   if msgWarning[i] = a then begin Yes:=true; Break end;

  if not Yes then begin
   i := High(msgWarning);
   msgWarning[i] := a;
   SetLength(msgWarning, i+2);
  end;

 end;

end;


procedure newMsg(var msg: TArrayString; var a: string);
var i: integer;
begin

    i:=High(msg);
    msg[i] := a;

    SetLength(msg, i+2);

end;


procedure Note(NoteTokenIndex: Integer; IdentIndex: Integer); overload;
var a: string;
begin

 if Pass = CODEGENERATIONPASS then
  if pos('.', Ident[IdentIndex].Name)=0 then begin

   a := UnitName[Tok[NoteTokenIndex].UnitIndex].Path + ' (' + IntToStr(Tok[NoteTokenIndex].Line) + ')' + ' Note: Local ';

   if Ident[IdentIndex].Kind <> UNITTYPE then begin

    case Ident[IdentIndex].Kind of
      CONSTANT: a := a + 'const';
      USERTYPE: a := a + 'type';
     LABELTYPE: a := a + 'label';

      VARIABLE: if Ident[IdentIndex].isAbsolute then
		 a := a + 'absolutevar'
		else
		 a := a + 'variable';

	  PROC: a := a + 'proc';
	  FUNC: a := a + 'func';
    end;

    a := a +' ''' + Ident[IdentIndex].Name + '''' + ' not used';

    newMsg(msgNote, a);

   end;

  end;

end;


procedure Note(NoteTokenIndex: Integer; Msg: string); overload;
var a: string;
begin

 if Pass = CODEGENERATIONPASS then begin

   a := UnitName[Tok[NoteTokenIndex].UnitIndex].Path + ' (' + IntToStr(Tok[NoteTokenIndex].Line) + ')' + ' Note: ';

   a := a + Msg;

   newMsg(msgNote, a);

 end;

end;


function GetStandardToken(S: TString): Integer;
var
  i: Integer;
begin
Result := 0;

if (S = 'LONGWORD') or (S = 'DWORD') or (S = 'UINT32') then S := 'CARDINAL' else
 if S = 'LONGINT' then S := 'INTEGER';

for i := 1 to MAXTOKENNAMES do
  if S = Spelling[i] then
    begin
    Result := i;
    Break;
    end;
end;


function GetIdentResult(ProcAsBlock: integer): integer;
var IdentIndex, BlockStackIndex: Integer;
begin

Result := 0;

for BlockStackIndex := BlockStackTop downto 0 do       // search all nesting levels from the current one to the most outer one
  for IdentIndex := 1 to NumIdent do
    if (Ident[IdentIndex].Name = 'RESULT') and (Ident[IdentIndex].Block = ProcAsBlock) then begin

	Result := IdentIndex;
	exit;
      end;

end;


function GetLocalName(IdentIndex: integer; a: string =''): string;
begin

 if (Ident[IdentIndex].UnitIndex > 1) and (Ident[IdentIndex].UnitIndex <> UnitNameIndex) and Ident[IdentIndex].Section then
  Result := UnitName[Ident[IdentIndex].UnitIndex].Name + '.' + a + Ident[IdentIndex].Name
 else
  Result := a + Ident[IdentIndex].Name;

end;


procedure asm65(a: string = ''; comment : string =''); forward;


function GetIdent(S: TString): Integer;
var TempIndex: integer;

  function UnitAllowedAccess(IdentIndex, Index: integer): Boolean;
  var i: integer;
  begin

   Result := false;

   if Ident[IdentIndex].Section then
    for i := 1 to MAXALLOWEDUNITS do
      if UnitName[Index].Allow[i] = UnitName[Ident[IdentIndex].UnitIndex].Name then begin Result := true; Break end;

  end;


  function Search(X: TString; UnitIndex: integer): integer;
  var IdentIndex, BlockStackIndex: Integer;
  begin

    Result := 0;

    for BlockStackIndex := BlockStackTop downto 0 do       // search all nesting levels from the current one to the most outer one
    for IdentIndex := 1 to NumIdent do
      if (X = Ident[IdentIndex].Name) and (BlockStack[BlockStackIndex] = Ident[IdentIndex].Block) then
	if (Ident[IdentIndex].UnitIndex = UnitIndex) {or Ident[IdentIndex].Section} or (Ident[IdentIndex].UnitIndex = 1) or (UnitName[Ident[IdentIndex].UnitIndex].Name = 'SYSTEM') or UnitAllowedAccess(IdentIndex, UnitIndex) then begin
	  Result := IdentIndex;
	  Ident[IdentIndex].Pass := Pass;

	  if pos('.', X) > 0 then GetIdent(copy(X, 1, pos('.', X)-1));

	  if (Ident[IdentIndex].UnitIndex = UnitIndex) or (Ident[IdentIndex].UnitIndex = 1) or (UnitName[Ident[IdentIndex].UnitIndex].Name = 'SYSTEM') then exit;
	end

  end;


  function SearchCurrentUnit(X: TString; UnitIndex: integer): integer;
  var IdentIndex, BlockStackIndex: Integer;
  begin

    Result := 0;

    for BlockStackIndex := BlockStackTop downto 0 do       // search all nesting levels from the current one to the most outer one
    for IdentIndex := 1 to NumIdent do
      if (X = Ident[IdentIndex].Name) and (BlockStack[BlockStackIndex] = Ident[IdentIndex].Block) then
	if (Ident[IdentIndex].UnitIndex = UnitIndex) or UnitAllowedAccess(IdentIndex, UnitIndex) then begin
	  Result := IdentIndex;
	  Ident[IdentIndex].Pass := Pass;

	  if pos('.', X) > 0 then GetIdent(copy(X, 1, pos('.', X)-1));

	  if (Ident[IdentIndex].UnitIndex = UnitIndex) then exit;
	end

  end;



begin

  Result := Search(S, UnitNameIndex);

  if (Result = 0) and (pos('.', S) > 0) then begin   // potencjalnie odwolanie do unitu / obiektu

    TempIndex := Search(copy(S, 1, pos('.', S)-1), UnitNameIndex);

//    writeln(S,',',Ident[TempIndex].Kind,' - ', Ident[TempIndex].DataType, ' / ',Ident[TempIndex].AllocElementType);

    if TempIndex > 0 then
     if (Ident[TempIndex].Kind = UNITTYPE) or (Ident[TempIndex].DataType = ENUMTYPE) then
       Result := SearchCurrentUnit(copy(S, pos('.', S)+1, length(S)), Ident[TempIndex].UnitIndex)
     else
      if Ident[TempIndex].DataType = OBJECTTOK then
       Result := SearchCurrentUnit(Types[Ident[TempIndex].NumAllocElements].Field[0].Name + copy(S, pos('.', S), length(S)), Ident[TempIndex].UnitIndex)
      ;{else
       if ( (Ident[TempIndex].DataType in Pointers) and (Ident[TempIndex].AllocElementType = RECORDTOK) ) then
	Result := TempIndex;}

  end;

end;


{
function GetRecordField(i: integer; field: string): Byte;
var j: integer;
begin

 Result:=0;

 for j:=1 to Types[i].NumFields do
  if Types[i].Field[j].Name = field then begin Result:=Types[i].Field[j].DataType; Break end;

 if Result = 0 then
  Error(0, 'Record field not found');

end;
}


function GetIdentProc(S: TString; Param: TParamList; NumParams: integer): integer;
var IdentIndex, BlockStackIndex, i, k, b: Integer;
    cnt: byte;
    hits, m: word;
    best: array of record
		    IdentIndex, b: integer;
		    hit: word;
		   end;

const
    mask : array [0..15] of word = ($01,$02,$04,$08,$10,$20,$40,$80,$0100,$0200,$0400,$0800,$1000,$2000,$4000,$8000);

begin

Result := 0;

SetLength(best, 1);

for BlockStackIndex := BlockStackTop downto 0 do	// search all nesting levels from the current one to the most outer one
  begin
  for IdentIndex := 1 to NumIdent do
    if (Ident[IdentIndex].Kind in [PROCEDURETOK, FUNCTIONTOK]) and
       (S = Ident[IdentIndex].Name) and (BlockStack[BlockStackIndex] = Ident[IdentIndex].Block) and
       (Ident[IdentIndex].NumParams = NumParams) then
      begin

      hits := 0;
      cnt:= 0;

      for i := 1 to NumParams do
       if (
	  ( ((Ident[IdentIndex].Param[i].DataType in UnsignedOrdinalTypes) and (Param[i].DataType in UnsignedOrdinalTypes) ) and
	  (DataSize[Ident[IdentIndex].Param[i].DataType] >= DataSize[Param[i].DataType]) ) or

	  ( ((Ident[IdentIndex].Param[i].DataType in SignedOrdinalTypes) and (Param[i].DataType in SignedOrdinalTypes) ) and
	  (DataSize[Ident[IdentIndex].Param[i].DataType] >= DataSize[Param[i].DataType]) ) or

	  ( ((Ident[IdentIndex].Param[i].DataType in SignedOrdinalTypes) and (Param[i].DataType in UnsignedOrdinalTypes) ) and	// smallint > byte
	  (DataSize[Ident[IdentIndex].Param[i].DataType] >= DataSize[Param[i].DataType]) ) or

	  (Ident[IdentIndex].Param[i].DataType = Param[i].DataType) ) or

	  ( (Param[i].DataType in Pointers) and (Ident[IdentIndex].Param[i].DataType = Param[i].AllocElementType) ) or		// dla parametru VAR

	  ( (Ident[IdentIndex].Param[i].DataType = UNTYPETOK) and (Ident[IdentIndex].Param[i].PassMethod = VARPASSING) and (Param[i].DataType in IntegerTypes + [CHARTOK]) )

	 then begin

	   hits := hits or mask[cnt];		// z grubsza spelnia warunek
	   inc(cnt);

	   if (Ident[IdentIndex].Param[i].DataType = Param[i].DataType) then begin	// dodatkowe punkty jesli idealnie spelnia warunek
	     hits := hits or mask[cnt];
	     inc(cnt);
	   end;

	 end;
{
      if Ident[IdentIndex].Name = 'TEST' then
       for i := 1 to NumParams do begin
        writeln(High(best),':',Ident[IdentIndex].Param[i].Name,',',Ident[IdentIndex].Param[i].DataType,',',Ident[IdentIndex].Param[i].AllocElementType ,' / ', Param[i].Name,',', Param[i].DataType,',',Param[i].AllocElementType ,' | ', hits);
       end;
}
	k:=High(best);

	best[k].IdentIndex := IdentIndex;
	best[k].hit	   := hits;
	best[k].b	   := Ident[IdentIndex].Block;

	SetLength(best, k+2);
      end;

  end;// for

 m:=0;
 b:=0;

 if High(best) = 1 then
  Result := best[0].IdentIndex
 else
  for i := 0 to High(best) - 1 do
   if (best[i].hit > m) and (best[i].b >= b) then begin m := best[i].hit; b := best[i].b; Result := best[i].IdentIndex end;

 SetLength(best, 0);
end;


procedure TestIdentProc(x: integer; S: TString);
var IdentIndex, BlockStackIndex: Integer;
    k, m: integer;
    ok: Boolean;

    ov: array of record
		  i,j,u,b: integer;
	end;

    l: array of record
		  u,b: integer;
		  Param: TParamList;
		  NumParams: word;
       end;


procedure addOverlay(UnitIndex, Block: integer; ovr: Boolean);
var i: integer;
    yes: Boolean;
begin

 yes:=true;

 for i:=High(ov)-1 downto 0 do
  if (ov[i].u = UnitIndex) and (ov[i].b = Block) then begin
   inc(ov[i].i, ord(ovr));
   inc(ov[i].j);

   yes:=false;
   Break;
  end;

 if yes then begin
  i:=High(ov);

  ov[i].u := UnitIndex;
  ov[i].b := Block;
  ov[i].i := ord(ovr);
  ov[i].j := 1;

  SetLength(ov, i+2);
 end;

end;


begin

SetLength(ov, 1);
SetLength(l, 1);

for BlockStackIndex := BlockStackTop downto 0 do       // search all nesting levels from the current one to the most outer one
  begin
  for IdentIndex := 1 to NumIdent do
    if (Ident[IdentIndex].Kind in [PROCEDURETOK, FUNCTIONTOK]) and
       (S = Ident[IdentIndex].Name) and (BlockStack[BlockStackIndex] = Ident[IdentIndex].Block) then
    begin

     for k := 0 to High(l)-1 do
      if (Ident[IdentIndex].NumParams = l[k].NumParams) and (Ident[IdentIndex].UnitIndex = l[k].u) and (Ident[IdentIndex].Block = l[k].b)  then begin

       ok := true;

       for m := 1 to l[k].NumParams do
	if (Ident[IdentIndex].Param[m].DataType <> l[k].Param[m].DataType) then begin ok := false; Break end;

       if ok then
	Error(x, 'Overloaded functions ''' + Ident[IdentIndex].Name + ''' have the same parameter list');

      end;

     k:=High(l);

     l[k].NumParams := Ident[IdentIndex].NumParams;
     l[k].Param     := Ident[IdentIndex].Param;
     l[k].u	    := Ident[IdentIndex].UnitIndex;
     l[k].b	    := Ident[IdentIndex].Block;

     SetLength(l, k+2);

     addOverlay(Ident[IdentIndex].UnitIndex, Ident[IdentIndex].Block, Ident[IdentIndex].isOverload);
    end;

  end;// for

 for i:=0 to High(ov)-1 do
  if ov[i].j > 1 then
   if ov[i].i <> ov[i].j then
    Error(x, 'Not all declarations of '+Ident[NumIdent].Name+' are declared with OVERLOAD');

 SetLength(l, 0);
 SetLength(ov, 0);
end;


procedure omin_spacje (var i:integer; var a:string);
(*----------------------------------------------------------------------------*)
(*  omijamy tzw. "biale spacje" czyli spacje, tabulatory		      *)
(*----------------------------------------------------------------------------*)
begin

 if a<>'' then
  while (i<=length(a)) and (a[i] in AllowWhiteSpaces) do inc(i);

end;


function get_digit(var i:integer; var a:string): string;
(*----------------------------------------------------------------------------*)
(*  pobierz ciag zaczynajaca sie znakami '0'..'9','%','$'		      *)
(*----------------------------------------------------------------------------*)
begin
 Result:='';

 if a<>'' then begin

  omin_spacje(i,a);

  if UpCase(a[i]) in AllowDigitFirstChars then begin

   Result:=UpCase(a[i]);
   inc(i);

   while UpCase(a[i]) in AllowDigitChars do begin Result:=Result+UpCase(a[i]); inc(i) end;

  end;

 end;

end;


function get_label(var i:integer; var a:string; up: Boolean = true): string;
(*----------------------------------------------------------------------------*)
(*  pobierz etykiete zaczynajaca sie znakami 'A'..'Z','_'		      *)
(*----------------------------------------------------------------------------*)
begin
 Result:='';

 if a<>'' then begin

  omin_spacje(i,a);

  if UpCase(a[i]) in AllowLabelFirstChars then
   while UpCase(a[i]) in AllowLabelChars + AllowDirectorySeparators do begin

    if up then
     Result:=Result+UpCase(a[i])
    else
     Result:=Result + a[i];

    inc(i);
   end;

 end;

end;


function get_string(var i:integer; var a:string; up: Boolean = true): string;
(*----------------------------------------------------------------------------*)
(*  pobiera ciag znakow, ograniczony znakami '' lub ""			      *)
(*  podwojny '' oznacza literalne '					      *)
(*  podwojny "" oznacza literalne "					      *)
(*----------------------------------------------------------------------------*)
var len: integer;
    znak, gchr: char;
begin
 Result:='';

 omin_spacje(i,a);

 if a[i] = '%' then begin

   while UpCase(a[i]) in ['A'..'Z','%'] do begin Result:=Result + Upcase(a[i]); inc(i) end;

 end else
 if not(a[i] in AllowQuotes) then begin

  Result := get_label(i, a, up);

 end else begin

  gchr:=a[i]; len:=length(a);

  while i<=len do begin
   inc(i);	 // omijamy pierwszy znak ' lub "

   znak:=a[i];

   if znak=gchr then begin inc(i); Break end;
{    inc(i);
    if a[i]=gchr then znak:=gchr;
   end;}

   Result:=Result+znak;
  end;

 end;

end;


procedure AddResource(fnam: string);
var i, j: integer;
    t: textfile;
    res: TResource;
    s, tmp: string;
begin

 AssignFile(t, fnam); FileMode:=0; Reset(t);

  while not eof(t) do begin

    readln(t, s);

    i:=1;
    omin_spacje(i, s);

    if (length(s) > i-1) and (not (s[i] in ['#',';'])) then begin

     res.resName := get_label(i, s);
     res.resType := get_label(i, s);
     res.resFile := get_string(i, s, false);  // nie zmieniaj wielkosci liter

     for j := 1 to MAXPARAMS do begin

      if s[i] in ['''','"'] then
       tmp := get_string(i, s)
      else
       tmp := get_digit(i, s);

      if tmp = '' then tmp:='0';

      res.resPar[j]  := tmp;
     end;

//     writeln(res.resName,',',res.resType,',',res.resFile);

     for j := High(resArray)-1 downto 0 do
      if resArray[j].resName = res.resName then
       Error(NumTok, 'Duplicate resource: Type = '+res.resType+', Name = '+res.resName);

     j:=High(resArray);
     resArray[j] := res;

     SetLength(resArray, j+2);

    end;

  end;

 CloseFile(t);

end;


procedure AddToken(Kind: Byte; UnitIndex, Line, Column: Integer; Value: Int64);
begin

 Inc(NumTok);

 if NumTok > High(Tok) then
  SetLength(Tok, NumTok+1);

// if NumTok > MAXTOKENS then
//    Error(NumTok, 'Out of resources, TOK');

 Tok[NumTok].UnitIndex := UnitIndex;
 Tok[NumTok].Kind := Kind;
 Tok[NumTok].Value := Value;

 if NumTok = 1 then
  Column := 1
 else begin

  if Tok[NumTok - 1].Line <> Line then
//   Column := 1
  else
    Column := Column + Tok[NumTok - 1].Column;

 end;

// if Tok[NumTok- 1].Line <> Line then writeln;

 Tok[NumTok].Line := Line;
 Tok[NumTok].Column := Column;

 //if line=46 then  writeln(Kind,',',Column);

end;


function Elements(IdentIndex: integer): cardinal;
begin

 if Ident[IdentIndex].DataType = ENUMTYPE then
  Result := 0
 else

 if (Ident[IdentIndex].NumAllocElements_ = 0) or (Ident[IdentIndex].AllocElementType in [RECORDTOK,OBJECTTOK]) then
  Result := Ident[IdentIndex].NumAllocElements
 else
  Result := Ident[IdentIndex].NumAllocElements * Ident[IdentIndex].NumAllocElements_;

end;


procedure DefineIdent(ErrTokenIndex: Integer; Name: TString; Kind: Byte; DataType: Byte; NumAllocElements: Cardinal; AllocElementType: Byte; Data: Int64; IdType: Byte = IDENTTOK);
var
  i: Integer;
  NumAllocElements_ : Cardinal;
begin

i := GetIdent(Name);

if (i > 0) and (not (Ident[i].Kind in [PROCEDURETOK, FUNCTIONTOK])) and (Ident[i].Block = BlockStack[BlockStackTop]) and (Ident[i].isOverload = false) and (Ident[i].UnitIndex = UnitNameIndex) then
  Error(ErrTokenIndex, 'Identifier ' + Name + ' is already defined')
else
  begin

  Inc(NumIdent);

  if NumIdent > High(Ident) then
    Error(NumTok, 'Out of resources, IDENT');

  Ident[NumIdent].Name := Name;
  Ident[NumIdent].Kind := Kind;
  Ident[NumIdent].DataType := DataType;
  Ident[NumIdent].Block := BlockStack[BlockStackTop];
  Ident[NumIdent].NumParams := 0;
  Ident[NumIdent].isAbsolute := false;
  Ident[NumIdent].PassMethod := VALPASSING;
  Ident[NumIdent].IsUnresolvedForward := false;

  Ident[NumIdent].Section := PublicSection;

  Ident[NumIdent].UnitIndex := UnitNameIndex;

  Ident[NumIdent].IdType := IdType;

  if (Kind = VARIABLE) and (Data <> 0) then begin
   Ident[NumIdent].isAbsolute := true;
   Ident[NumIdent].isInit := true;
  end;

  NumAllocElements_ := NumAllocElements shr 16;		// , yy]
  NumAllocElements  := NumAllocElements and $FFFF;	// [xx,

  if (NumIdent > NumPredefIdent + 1) and (UnitNameIndex = 1) and (Pass = CODEGENERATIONPASS) then
    if not ( (Ident[NumIdent].Pass in [CALLDETERMPASS , CODEGENERATIONPASS]) or (Ident[NumIdent].IsNotDead) ) then
      Note(ErrTokenIndex, NumIdent);

  case Kind of

    PROC, FUNC, UNITTYPE:
      begin
      Ident[NumIdent].Value := CodeSize;			// Procedure entry point address
//      Ident[NumIdent].Section := true;
      end;

    VARIABLE:
      begin

      if Ident[NumIdent].isAbsolute then
       Ident[NumIdent].Value := Data - 1
      else
       Ident[NumIdent].Value := DATAORIGIN + VarDataSize;	// Variable address

      if not OutputDisabled then
	VarDataSize := VarDataSize + DataSize[DataType];

      Ident[NumIdent].NumAllocElements := NumAllocElements;	// Number of array elements (0 for single variable)
      Ident[NumIdent].NumAllocElements_ := NumAllocElements_;

      Ident[NumIdent].AllocElementType := AllocElementType;

      if not OutputDisabled then begin

       if DataType in [ENUMTYPE] then
        inc(VarDataSize)
       else
       if (DataType in [RECORDTOK, OBJECTTOK]) and (NumAllocElements > 0) then
	VarDataSize := VarDataSize + 0
       else
       if (DataType = FILETOK) and (NumAllocElements > 0) then
	VarDataSize := VarDataSize + 12
       else
	VarDataSize := VarDataSize + integer(Elements(NumIdent) * DataSize[AllocElementType]);

       if NumAllocElements > 0 then dec(VarDataSize, DataSize[DataType]);

      end;

      end;

    CONSTANT, ENUMTYPE:
      begin
      Ident[NumIdent].Value := Data;				// Constant value

      if DataType in Pointers then begin
       Ident[NumIdent].NumAllocElements := NumAllocElements;
       Ident[NumIdent].NumAllocElements_ := NumAllocElements_;

       Ident[NumIdent].AllocElementType := AllocElementType;
      end;

      Ident[NumIdent].isInit := true;
      end;

    USERTYPE:
      begin
       Ident[NumIdent].NumAllocElements := NumAllocElements;
       Ident[NumIdent].NumAllocElements_ := NumAllocElements_;

       Ident[NumIdent].AllocElementType := AllocElementType;
      end;

    LABELTYPE:
      begin
       Ident[NumIdent].isInit := false;
      end;

  end;// case
  end;// else
end;



procedure DefineStaticString(StrTokenIndex: Integer; StrValue: String);
var
  i, j, k, len: Integer;
  yes: Boolean;
begin

Fillchar(Data, sizeof(Data), 0);

len:=Length(StrValue);

if len > 255 then
 Data[0]:=255
else
 Data[0]:=len;

for i:=1 to len do Data[i] := ord(StrValue[i]);

i:=0;
j:=0;
yes:=false;

while (i < NumStaticStrChars) and (yes=false) do begin

 j:=0;
 k:=i;
 while (Data[j] = StaticStringData[k+j]) and (j < len+2) and (k+j < NumStaticStrChars) do inc(j);

 if j = len+2 then begin yes:=true; Break end;

 inc(i);
end;

Tok[StrTokenIndex].StrLength := len;

if yes then begin
 Tok[StrTokenIndex].StrAddress := CODEORIGIN + i;
 exit;
end;

Tok[StrTokenIndex].StrAddress := CODEORIGIN + NumStaticStrChars;

StaticStringData[NumStaticStrChars] := Data[0];//length(StrValue);
Inc(NumStaticStrChars);

for i := 1 to len do
  begin
  StaticStringData[NumStaticStrChars] := ord(StrValue[i]);
  Inc(NumStaticStrChars);
  end;

StaticStringData[NumStaticStrChars] := 0;
Inc(NumStaticStrChars);

end;


procedure CheckOperator(ErrTokenIndex: Integer; op: Byte; DataType: Byte; RightType: Byte = 0);
begin

//writeln(tok[ErrTokenIndex].Name^,',', op,',',DataType);

 if {(not (DataType in (OrdinalTypes + [REALTOK, POINTERTOK]))) or}
   ((DataType in RealTypes) and
       not (op in [MULTOK, DIVTOK, PLUSTOK, MINUSTOK, GTTOK, GETOK, EQTOK, NETOK, LETOK, LTTOK])) or
   ((DataType in IntegerTypes) and
       not (op in [MULTOK, IDIVTOK, MODTOK, SHLTOK, SHRTOK, ANDTOK, PLUSTOK, MINUSTOK, ORTOK, XORTOK, NOTTOK, GTTOK, GETOK, EQTOK, NETOK, LETOK, LTTOK, INTOK])) or
   ((DataType = CHARTOK) and
       not (op in [GTTOK, GETOK, EQTOK, NETOK, LETOK, LTTOK, INTOK])) or
   ((DataType = BOOLEANTOK) and
       not (op in [ANDTOK, ORTOK, XORTOK, NOTTOK, GTTOK, GETOK, EQTOK, NETOK, LETOK, LTTOK])) or
   ((DataType in Pointers) and
       not (op in [GTTOK, GETOK, EQTOK, NETOK, LETOK, LTTOK]))
then
  Error(ErrTokenIndex, 'Operator is not overloaded: ' + '"' + InfoAboutToken(DataType) + '" ' + InfoAboutToken(op) + ' "' + InfoAboutToken(RightType) + '"');

end;


function GetCommonConstType(ErrTokenIndex: Integer; DstType, SrcType: Byte; err: Boolean = true): Boolean;
begin

  Result := false;

  if (DataSize[DstType] < DataSize[SrcType]) or
     ( (DstType = REALTOK) and (SrcType <> REALTOK) ) or
     ( (DstType <> REALTOK) and (SrcType = REALTOK) ) or

     ( (DstType = SINGLETOK) and (SrcType <> SINGLETOK) ) or
     ( (DstType <> SINGLETOK) and (SrcType = SINGLETOK) ) or

     ( (DstType = SHORTREALTOK) and (SrcType <> SHORTREALTOK) ) or
     ( (DstType <> SHORTREALTOK) and (SrcType = SHORTREALTOK) ) or

     ( (DstType in IntegerTypes) and (SrcType in [CHARTOK, BOOLEANTOK, POINTERTOK, DATAORIGINOFFSET, CODEORIGINOFFSET, STRINGPOINTERTOK]) ) or
     ( (SrcType in IntegerTypes) and (DstType in [CHARTOK, BOOLEANTOK]) ) then

     if err then
      iError(ErrTokenIndex, IncompatibleTypes, 0, SrcType, DstType)
     else
      Result := true;

end;


function GetCommonType(ErrTokenIndex: Integer; LeftType, RightType: Byte): Byte;
begin

 Result := 0;

 if LeftType = RightType then		 // General rule

  Result := LeftType

 else
  if (LeftType in IntegerTypes) and (RightType in IntegerTypes) then
    Result := LeftType;

  if (LeftType in Pointers) and (RightType in Pointers) then
    Result := LeftType;

 if LeftType = UNTYPETOK then Result := RightType;

// if LeftType in Pointers then Result :in Pointers;

 if Result = 0 then
   iError(ErrTokenIndex, IncompatibleTypes, 0, RightType, LeftType);

end;


procedure AddCallGraphChild(ParentBlock, ChildBlock: Integer);
begin

 if ParentBlock <> ChildBlock then begin

  Inc(CallGraph[ParentBlock].NumChildren);
  CallGraph[ParentBlock].ChildBlock[CallGraph[ParentBlock].NumChildren] := ChildBlock;

 end;

end;


procedure SaveAsmBlock(a: char);
begin

 AsmBlock[AsmBlockIndex]:=AsmBlock[AsmBlockIndex] + a;

end;


function GetVAL(a: string): integer;
var err: integer;
begin

 Result := -1;

 if a<>'' then
  if a[1] = '#' then begin
   val(copy(a, 2, length(a)), Result, err);

   if err > 0 then Result := -1;

  end;

end;


procedure ResetOpty;
begin

 optyA := '';
 optyY := '';
 optyBP2 := '';

end;


procedure OptimizeTemporaryBuf;
var i: integer;


  function SKIP(i: integer): Boolean;
  begin

     if i<0 then
      Result:=False
     else
      Result :=	(TemporaryBuf[i] = #9'seq') or (TemporaryBuf[i] = #9'sne') or
		(TemporaryBuf[i] = #9'spl') or (TemporaryBuf[i] = #9'smi') or
		(TemporaryBuf[i] = #9'scc') or (TemporaryBuf[i] = #9'scs') or
		(pos('bne ', TemporaryBuf[i]) > 0) or (pos('beq ', TemporaryBuf[i]) > 0) or
		(pos('bcc ', TemporaryBuf[i]) > 0) or (pos('bcs ', TemporaryBuf[i]) > 0) or
		(pos('bmi ', TemporaryBuf[i]) > 0) or (pos('bpl ', TemporaryBuf[i]) > 0);
  end;


  function TestBranch(i: integer): Boolean;
  var j: integer;
  begin

   Result:=true;

   for j:=i downto 0 do begin

    if pos(' @+', TemporaryBuf[j]) > 0 then begin Result:=false; Break end;
    if pos('lda ', TemporaryBuf[j]) > 0 then Break;

   end;

  end;


begin

 for i:=0 to High(TemporaryBuf)-1 do
  if TemporaryBuf[i] <> '' then begin


   if (pos('l_', TemporaryBuf[i]) > 0) and						//l_xxxxt		; 0
      (pos('lda IFTMP_', TemporaryBuf[i+1]) > 0) and					// lda IFTMP_xxxx	; 1
      (pos('jne l_', TemporaryBuf[i+2]) > 0) then					// jne l_xxxx		; 2
    begin
     TemporaryBuf[i+1] := TemporaryBuf[i];
     TemporaryBuf[i]   := #9'jmp ' + copy(TemporaryBuf[i+2], 6, 256);

     TemporaryBuf[i+2] := TemporaryBuf[i+1];
     TemporaryBuf[i+1] := TemporaryBuf[i];
     TemporaryBuf[i]   := '';
    end;


   if (pos('jmp @exit', TemporaryBuf[i]) > 0) and					// jmp @exit		; 0
      (TemporaryBuf[i+1] = '@exit') then						//@exit			; 1
    begin
     TemporaryBuf[i] := '';
    end;


   if (TemporaryBuf[i] = #9'lda #$01') and						// lda #$01		; 0
      (pos('jeq l_', TemporaryBuf[i+1]) > 0) and					// jeq l_xxxx		; 1
      (pos('jmp l_', TemporaryBuf[i+2]) > 0) and					// jmp l_yyyy		; 2
      (pos(TemporaryBuf[i+3], TemporaryBuf[i+1]) > 0) then				//l_xxxx		; 3
    begin
     TemporaryBuf[i]   := '';
     TemporaryBuf[i+1] := '';
     TemporaryBuf[i+3] := '';
    end;


   if (pos('jmp l_', TemporaryBuf[i]) > 0) then						// jmp l_xxxx		; 0
    if TemporaryBuf[i+1] = copy(TemporaryBuf[i], 6, 256) then				//l_xxxx		; 1
    begin
     TemporaryBuf[i]   := '';
     TemporaryBuf[i+1] := '';
    end;


   if (SKIP(i) = false) and								// beq *+5		; 1
      (pos('beq *+5', TemporaryBuf[i+1]) > 0) and					// jmp l_xxxx		; 2
      (pos('jmp l_', TemporaryBuf[i+2]) > 0) then
    begin
     TemporaryBuf[i+1] := #9'jne ' + copy(TemporaryBuf[i+2], 6, 256);
     TemporaryBuf[i+2] := '';
    end;


    if (TemporaryBuf[i] = #9'bcc *+7') and						// bcc *+7		; 0
       (TemporaryBuf[i+1] = #9'beq *+5') and						// beq *+5		; 1
       (pos('jmp l_', TemporaryBuf[i+2]) > 0) then					// jmp l_		; 2
      begin
       TemporaryBuf[i]   := #9'scc';
       TemporaryBuf[i+1] := #9'jne ' + copy(TemporaryBuf[i+2], 6, 256);
       TemporaryBuf[i+2] := '';
      end;


    if (TemporaryBuf[i] = #9'.ENDL') and						// .ENDL		; 0
       (TemporaryBuf[i+1] = #9'bmi *+7') and						// bmi *+7		; 1
       (TemporaryBuf[i+2] = #9'beq *+5') and						// beq *+5		; 2
       (pos('jmp l_', TemporaryBuf[i+3]) > 0) then					// jmp l_		; 3
      begin
       TemporaryBuf[i+1] := #9'smi';
       TemporaryBuf[i+2] := #9'jne ' + copy(TemporaryBuf[i+3], 6, 256);
       TemporaryBuf[i+3] := '';
      end;


   if TestBranch(i) and	(SKIP(i) = false) and						// beq @+		; 1
      (pos('beq @+', TemporaryBuf[i+1]) > 0) and					// jmp l_xxxx		; 2
      (pos('jmp l_', TemporaryBuf[i+2]) > 0) and
      (TemporaryBuf[i+3] = '@') then
    begin
     TemporaryBuf[i+1] := #9'jne ' + copy(TemporaryBuf[i+2], 6, 256);
     TemporaryBuf[i+2] := '';
    end;


   if TestBranch(i) and	(SKIP(i) = false) and						// bcs @+		; 1
      (pos('bcs @+', TemporaryBuf[i+1]) > 0) and					// jmp l_xxxx		; 2
      (pos('jmp l_', TemporaryBuf[i+2]) > 0) and
      (TemporaryBuf[i+3] = '@') then
    begin
     TemporaryBuf[i+1] := #9'jcc ' + copy(TemporaryBuf[i+2], 6, 256);
     TemporaryBuf[i+2] := '';
    end;


   if TestBranch(i) and (SKIP(i) = false) and						// bcc @+		; 1
      (pos('bcc @+', TemporaryBuf[i+1]) > 0) and					// jmp l_xxxx		; 2
      (pos('jmp l_', TemporaryBuf[i+2]) > 0) and
      (TemporaryBuf[i+3] = '@') then
    begin
     TemporaryBuf[i+1] := #9'jcs ' + copy(TemporaryBuf[i+2], 6, 256);
     TemporaryBuf[i+2] := '';
    end;


   if (TemporaryBuf[i] = #9'seq') and							// seq			; 0
      (pos('jmp l_', TemporaryBuf[i+1]) > 0) then					// jmp l_		; 1
    begin
     TemporaryBuf[i]   := #9'jne ' + copy(TemporaryBuf[i+1], 6, 256);
     TemporaryBuf[i+1] := '';
    end;

 end;

end;


procedure WriteOut(a: string);
var i: integer;
begin

 if iOut < High(TemporaryBuf) then begin
  TemporaryBuf[iOut] := a;
  inc(iOut);
 end else begin

  OptimizeTemporaryBuf;

  if (TemporaryBuf[0] <> '') or (outTmp <> TemporaryBuf[0]) then writeln(OutFile, TemporaryBuf[0]);

  outTmp := TemporaryBuf[0];

  for i:=1 to iOut do TemporaryBuf[i-1] := TemporaryBuf[i];

  TemporaryBuf[iOut] := a;

 end;

end;


procedure OptimizeASM;
(* -------------------------------------------------------------------------- *)
(* optymalizacja powiodla sie jesli na wyjsciu X=0
(* peephole optimization
(* -------------------------------------------------------------------------- *)
type
    TListing = array [0..511] of string;

var i, l, k, m: integer;
    x: integer;
    a, t, arg, arg0, arg1: string;
    inxUse, ifTmp: Boolean;
    t0, t1, t2, t3: string;
    listing, listing_tmp: TListing;
    cnt: array [0..7, 0..3] of integer;
    s: array [0..15,0..3] of string;

// -----------------------------------------------------------------------------


   function GetBYTE(i: integer): integer;
   begin
    Result := GetVAL(copy(listing[i], 6, 4));
   end;

   function GetWORD(i,j: integer): integer;
   begin
    Result := GetVAL(copy(listing[i], 6, 4)) + GetVAL(copy(listing[j], 6, 4)) shl 8;
   end;


   function TAY(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'tay'
   end;

   function TYA(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'tya'
   end;

   function INY(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'iny'
   end;

   function DEY(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'dey';
   end;

   function INX(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'inx';
   end;

   function DEX(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'dex';
   end;

   function LDA_BP_Y(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'lda (:bp),y';
   end;

   function STA_BP_Y(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'sta (:bp),y';
   end;

   function STA_BP(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'sta :bp';
   end;

   function STA_BP_1(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'sta :bp+1';
   end;

   function LDA_BP2_Y(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'lda (:bp2),y';
   end;

   function STA_BP2(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'sta :bp2';
   end;

   function STA_BP2_1(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'sta :bp2+1';
   end;

   function STA_BP2_Y(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'sta (:bp2),y';
   end;

   function ADD_BP2_Y(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'add (:bp2),y';
   end;

   function ADC_BP2_Y(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'adc (:bp2),y';
   end;

   function LDA_IM_0(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'lda #$00';
   end;

   function ADD_IM_0(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'add #$00';
   end;

   function SUB_IM_0(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'sub #$00';
   end;

   function ADC_IM_0(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'adc #$00';
   end;

   function CMP_IM_0(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'cmp #$00';
   end;

   function SBC_IM_0(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'sbc #$00';
   end;

   function LDY_IM_0(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'ldy #$00';
   end;

   function ROL_A(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'rol @';
   end;

   function ASL_A(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'asl @';
   end;

   function LDY_1(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'ldy #1';
   end;


   function IY(i: integer): Boolean;
   begin
    Result := pos(',y', listing[i]) > 0;
   end;

   function LDY_IM(i: integer): Boolean;
   begin
     Result := pos('ldy #', listing[i]) > 0;
   end;

   function LDY(i: integer): Boolean;
   begin
     Result := pos('ldy ', listing[i]) > 0;
   end;

   function LDY_STACK(i: integer): Boolean;
   begin
     Result := pos('ldy :STACK', listing[i]) > 0;
   end;

   function STY_STACK(i: integer): Boolean;
   begin
     Result := pos('sty :STACK', listing[i]) > 0;
   end;

   function ROR_STACK(i: integer): Boolean;
   begin
     Result := pos('ror :STACK', listing[i]) > 0;
   end;

   function LSR_STACK(i: integer): Boolean;
   begin
     Result := pos('lsr :STACK', listing[i]) > 0;
   end;

   function ROL_STACK(i: integer): Boolean;
   begin
     Result := pos('rol :STACK', listing[i]) > 0;
   end;

   function ASL_STACK(i: integer): Boolean;
   begin
     Result := pos('asl :STACK', listing[i]) > 0;
   end;

   function CMP(i: integer): Boolean;
   begin
     Result := pos('cmp ', listing[i]) > 0;
   end;

   function CMP_STACK(i: integer): Boolean;
   begin
     Result := pos('cmp :STACK', listing[i]) > 0;
   end;

   function MWA(i: integer): Boolean;
   begin
     Result := pos('mwa ', listing[i]) > 0;
   end;

   function MWY(i: integer): Boolean;
   begin
     Result := pos('mwy ', listing[i]) > 0;
   end;

   function MVA(i: integer): Boolean;
   begin
     Result := pos('mva ', listing[i]) > 0;
   end;

   function MVA_IM(i: integer): Boolean;
   begin
     Result := pos('mva #', listing[i]) > 0;
   end;

   function MVA_STACK(i: integer): Boolean;
   begin
     Result := pos('mva :STACK', listing[i]) > 0;
   end;

   function LDA(i: integer): Boolean;
   begin
     Result := pos('lda ', listing[i]) > 0;
   end;

   function LDA_IM(i: integer): Boolean;
   begin
     Result := pos('lda #', listing[i]) > 0;
   end;

   function LDA_STACK(i: integer): Boolean;
   begin
     Result := pos('lda :STACK', listing[i]) > 0;
   end;

   function STA(i: integer): Boolean;
   begin
     Result := pos('sta ', listing[i]) > 0;
   end;

   function STA_STACK(i: integer): Boolean;
   begin
     Result := pos('sta :STACK', listing[i]) > 0;
   end;


   function ADD(i: integer): Boolean;
   begin
     Result := (pos('add ', listing[i]) > 0);
   end;

   function ADD_IM(i: integer): Boolean;
   begin
     Result := (pos('add #', listing[i]) > 0);
   end;

   function ADC(i: integer): Boolean;
   begin
     Result := (pos('adc ', listing[i]) > 0);
   end;

   function ADC_IM(i: integer): Boolean;
   begin
     Result := (pos('adc #', listing[i]) > 0);
   end;

   function ADD_STACK(i: integer): Boolean;
   begin
     Result := (pos('add :STACK', listing[i]) > 0);
   end;

   function ADC_STACK(i: integer): Boolean;
   begin
     Result := (pos('adc :STACK', listing[i]) > 0);
   end;

   function ADD_SUB_STACK(i: integer): Boolean;
   begin
     Result := (pos('add :STACK', listing[i]) > 0) or (pos('sub :STACK', listing[i]) > 0);
   end;

   function ADC_SBC_STACK(i: integer): Boolean;
   begin
     Result := (pos('adc :STACK', listing[i]) > 0) or (pos('sbc :STACK', listing[i]) > 0);
   end;

   function SUB(i: integer): Boolean;
   begin
     Result := (pos('sub ', listing[i]) > 0);
   end;

   function SUB_IM(i: integer): Boolean;
   begin
     Result := (pos('sub #', listing[i]) > 0);
   end;

   function SBC(i: integer): Boolean;
   begin
     Result := (pos('sbc ', listing[i]) > 0);
   end;

   function SBC_IM(i: integer): Boolean;
   begin
     Result := (pos('sbc #', listing[i]) > 0);
   end;

   function SUB_STACK(i: integer): Boolean;
   begin
     Result := (pos('sub :STACK', listing[i]) > 0);
   end;

   function SBC_STACK(i: integer): Boolean;
   begin
     Result := (pos('sbc :STACK', listing[i]) > 0);
   end;

   function ADD_SUB(i: integer): Boolean;
   begin
     Result := (pos('add ', listing[i]) > 0) or (pos('sub ', listing[i]) > 0);
   end;

   function ADC_SBC(i: integer): Boolean;
   begin
     Result := (pos('adc ', listing[i]) > 0) or (pos('sbc ', listing[i]) > 0);
   end;

   function AND_ORA_EOR_STACK(i: integer): Boolean;
   begin
     Result := (pos('and :STACK', listing[i]) > 0) or (pos('ora :STACK', listing[i]) > 0) or (pos('eor :STACK', listing[i]) > 0);
   end;

   function AND_ORA_EOR(i: integer): Boolean;
   begin
     Result := (pos('and ', listing[i]) > 0) or (pos('ora ', listing[i]) > 0) or (pos('eor ', listing[i]) > 0);
   end;


   function MWY_BP2(i: integer): Boolean;
   begin
     Result := (pos('mwy ', listing[i]) > 0) and (pos(' :bp2', listing[i]) > 0);
   end;

   function MWA_BP2(i: integer): Boolean;
   begin
     Result := (pos('mwa ', listing[i]) > 0) and (pos(' :bp2', listing[i]) > 0);
   end;

   function ADD_SUB_AL_CL(i: integer): Boolean;
   begin
     Result := (listing[i] = #9'jsr addAL_CL') or (listing[i] = #9'jsr subAL_CL');
   end;

   function ADD_SUB_AX_CX(i: integer): Boolean;
   begin
     Result := (listing[i] = #9'jsr addAX_CX') or (listing[i] = #9'jsr subAX_CX');
   end;


   function SEQ(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'seq';
   end;

   function SNE(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'sne';
   end;

   function SPL(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'spl';
   end;

   function SMI(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'smi';
   end;

   function SCC(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'scc';
   end;

   function SCS(i: integer): Boolean; inline;
   begin
     Result := listing[i] = #9'scs';
   end;


   function SKIP(i: integer): Boolean;
   begin

     if i<0 then
      Result:=False
     else
      Result :=	seq(i) or sne(i) or spl(i) or smi(i) or scc(i) or scs(i) or
		(pos('bne ', listing[i]) > 0) or (pos('beq ', listing[i]) > 0) or
		(pos('bcc ', listing[i]) > 0) or (pos('bcs ', listing[i]) > 0) or
		(pos('bmi ', listing[i]) > 0) or (pos('bpl ', listing[i]) > 0);
   end;


   function IFDEF_MUL8(i: integer): Boolean;
   begin
      Result :=	(listing[i+4] = #9'eif') and
      		(listing[i+3] = #9'imulCL') and
      		(listing[i+2] = #9'els') and
		(listing[i+1] = #9'fmulu_8') and
		(listing[i]   = #9'.ifdef fmulinit');
   end;

   function IFDEF_MUL16(i: integer): Boolean;
   begin
      Result :=	(listing[i+4] = #9'eif') and
		(listing[i+3] = #9'imulCX') and
		(listing[i+2] = #9'els') and
		(listing[i+1] = #9'fmulu_16') and
      		(listing[i]   = #9'.ifdef fmulinit');
   end;

// -----------------------------------------------------------------------------

   procedure Rebuild;
   var k, i, n: integer;
       s: string;
   begin

    for i:=0 to High(listing_tmp) do listing_tmp[i] := '';

    k:=0;
    for i := 0 to l - 1 do
     if (listing[i] <> '') and (listing[i][1] <> ';') then begin

      s:='';
      n:=1;
      while n <= length(listing[i]) do begin

       if not(listing[i][n] in [CR, LF]) then
	s:=s + listing[i][n];

       if listing[i][n] = LF then begin
	listing_tmp[k] := s;
	inc(k);

	s:='';
       end;

       inc(n);
      end;

      if s<>'' then begin
       listing_tmp[k] := s;
       inc(k);
      end;

     end;

    listing := listing_tmp;

    l := k;
   end;


   procedure Clear;
   var i, k: integer;
   begin

    for i := 0 to High(s) do
     for k := 0 to 3 do s[i][k] := '';

    fillchar(cnt, sizeof(cnt), 0);

   end;


   function GetString(a:string): string;
   var i: integer;
   begin

    Result := '';
    i:=6;

    if a<>'' then
     while not(a[i] in [' ',#9]) and (i <= length(a)) do begin
      Result := Result + a[i];
      inc(i);
     end;

   end;


  function GetARG(n: byte; x: shortint; reset: Boolean = true): string;
  var i: integer;
      a: string;
  begin

   Result:='';

   if x < 0 then exit;

   a := s[x][n];

   if (a='') then begin

    case n of
     0: Result := ':STACKORIGIN+'+IntToStr(shortint(x+8));
     1: Result := ':STACKORIGIN+STACKWIDTH+'+IntToStr(shortint(x+8));
     2: Result := ':STACKORIGIN+STACKWIDTH*2+'+IntToStr(shortint(x+8));
     3: Result := ':STACKORIGIN+STACKWIDTH*3+'+IntToStr(shortint(x+8));
    end;

   end else begin

    i := 6;

    while a[i] in [' ',#9] do inc(i);

    while not(a[i] in [' ',#9]) and (i <= length(a)) do begin
     Result := Result + a[i];
     inc(i);
    end;

    if reset and (not ifTmp) then s[x][n] := '';

   end;

  end;


  function Num(i: integer): integer;
  var j, k: integer;
  begin

    Result := 0;
    arg:='';

    for j := 0 to 6 do
     for k := 0 to 3 do
      if pos(GetARG(k, j, false), listing[i]) > 0 then begin
       arg:=GetARG(k, j, false);
       Result := cnt[j, k];
       Break;
      end;

  end;


  procedure RemoveUnusedSTACK;
  type
      TStackBuf = record
		   name: string;
		   line: integer;
		  end;

  var i,j,k: integer;
      stackBuf: array of TStackBuf;
      yes: Boolean;


      procedure Remove(i: integer);
      var k: integer;
      begin

	listing[i] := '';

	if rol_a(i-1) then begin
	 listing[i-1] := '';

	 for k := i-1 downto 0 do begin

	  if lda_im_0(k) then begin
	   listing[k] := '';

	   if adc_im_0(k+1) or sbc_im_0(k+1) then listing[k+1] := '';

	   Break;
	  end;

	  if listing[k] = #9'rol @' then listing[k] := '';
	 end;

	end;

      end;


  begin
 // szukamy pojedynczych odwolan do :STACKORIGIN+N

  Rebuild;

  Clear;

  SetLength(stackBuf, 1);

  for i := 0 to l - 1 do	       // zliczamy odwolania do :STACKORIGIN+N
   for j := 0 to 6 do
    for k := 0 to 3 do
     if pos(GetARG(k, j, false), listing[i]) > 0 then inc( cnt[j, k] );


//  for i := 0 to l - 1 do
//   if Num(i) <> 0 then listing[i] := listing[i] + #9'; '+IntToStr( Num(i) );


  for i := 1 to l - 1 do begin

   if sta_stack(i) or sty_stack(i) then begin

    yes:=true;
    for j:=0 to High(stackBuf)-1 do
      if stackBuf[j].name = listing[i] then begin

       Remove(stackBuf[j].line);	// usun dotychczasowe odwolanie

       stackBuf[j].line := i;		// nadpisz nowym

       yes:=false;
       Break;
      end;

    if yes then begin		// dodaj nowy wpis
     k:=High(stackBuf);
     stackBuf[k].name := listing[i];
     stackBuf[k].line := i;
     SetLength(stackBuf, k+2);
    end;

   end;


   if ((pos('sta :STACK', listing[i]) = 0) and (pos('sty :STACK', listing[i]) = 0)) and
      (pos(' :STACK', listing[i]) > 0) then
   begin

    for j:=0 to High(stackBuf)-1 do	// odwolania inne niz STA|STY resetuja wpisy
      if copy(stackBuf[j].name, 6, 256) = copy(listing[i], 6, 256) then begin
       stackBuf[j].name := '';		// usun wpis
       Break;
      end;

   end;


  if Num(i) = 1 then
   if rol_a(i-1) then

    Remove(i)			// pojedyncze odwolanie do :STACKORIGIN+N jest eliminowane

   else begin

    a := listing[i];		// zamieniamy na 'illegal instruction'
    k:=pos(' :STACK', a);
    delete(a, k, length(a));
    insert(' #$00', a, k);

    if (pos('ldy #$00', a) > 0) or (pos('lda #$00', a) > 0) then
     listing[i] := ''
    else
     listing[i] := a;

   end;

  end;    // for

   Rebuild;

   SetLength(stackBuf, 0);

  end;


 function PeepholeOptimization_STACK: Boolean;
 var i, p, q: integer;
     tmp: string;


  procedure asl_;
  begin
        case p of
	  2: listing[i+2] := #9'asl @';

	  4: begin
	      listing[i+2] := #9'asl @';
	      listing[i+3] := #9'asl @';
	     end;

	  8: begin
	      listing[i+2] := #9'asl @';
	      listing[i+3] := #9'asl @';
	      listing[i+4] := #9'asl @';
	     end;

	 16: begin
	      listing[i+2] := #9'asl @';
	      listing[i+3] := #9'asl @';
	      listing[i+4] := #9'asl @';
	      listing[i+5] := #9'asl @';
	     end;

	 32: begin
	      listing[i+2] := #9'asl @';
	      listing[i+3] := #9'asl @';
	      listing[i+4] := #9'asl @';
	      listing[i+5] := #9'asl @';
	      listing[i+6] := #9'asl @';
	     end;
	end;
  end;


 begin

  Result := true;

  Rebuild;

  tmp:='';

  for i := 0 to l - 1 do begin

   if (pos('jsr ', listing[i])  > 0) or (pos('cmp ', listing[i]) > 0) or
      (pos('bne ', listing[i]) > 0) or (pos('beq ', listing[i]) > 0) or
      (pos('bcc ', listing[i]) > 0) or (pos('bcs ', listing[i]) > 0) or
      (pos('bmi ', listing[i]) > 0) or (pos('bpl ', listing[i]) > 0) or
      spl(i) or smi(i) or seq(i) or sne(i) then Break;

   if mwa_bp2(i) then
    if tmp = listing[i] then
     listing[i] := ''
    else
     tmp := listing[i];

  end;

  Rebuild;

  for i := 0 to l - 1 do begin

    if (listing[i] <> '' ) and (listing[i][1] = ';') and (listing[i][2] <> TAB) then begin
     Result := false;
    end;


    if dex(i) and inx(i+1) then									// dex
     begin											// inx
       listing[i]   := '';
       listing[i+1] := '';
       Result:=false;
     end;


    if inx(i) and dex(i+1) then									// inx
     begin											// dex
       listing[i]   := '';
       listing[i+1] := '';
       Result:=false;
     end;


    if lda_stack(i) and sta_stack(i+1) then							// lda :STACKORIGIN+9
     if copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256) then begin			// sta :STACKORIGIN+9
       listing[i]   := '';
       listing[i+1] := '';
       Result:=false;
     end;


    if (listing[i] = #9'sta :STACKORIGIN,x') and						// sta :STACKORIGIN,x		; 0
       mva_stack(i+1) then									// mva :STACKORIGIN,x TILE	; 1
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) then
     begin
       listing[i]   := '';
       listing[i+1] := #9'sta ' + copy(listing[i+1], pos(',x ',listing[i+1])+3,256 );

       Result:=false;
     end;


    if (i>1) and										// mva A	; -2
       mva(i) and										// inx		; -1
       inx(i-1) and										// mva A	; 0
       mva(i-2) then										// inx		; 1
     if listing[i] = listing[i-2] then begin							// mva A	; 2
       listing[i] := #9'sta ' + copy(listing[i], pos(':STACK', listing[i]), 256);
       if inx(i+1) and (listing[i-2] = listing[i+2]) then
	listing[i+2] := #9'sta ' + copy(listing[i+2], pos(':STACK', listing[i+2]), 256);

       Result:=false;
     end;


    if mva(i) and (iy(i) = false) and								// mva aa :STACKORIGIN,x		; 0
       ldy_1(i+1) and										// ldy #1				; 1
       (listing[i+2] = #9'lda :STACKORIGIN-1,x') and						// lda :STACKORIGIN-1,x			; 2
       (listing[i+3] = #9'cmp :STACKORIGIN,x') then						// cmp :STACKORIGIN,x			; 3
     if (pos(':STACKORIGIN,x', listing[i]) > 0) then
     begin
       listing[i+3] := #9'cmp ' + copy(listing[i], 6, pos(':STACK', listing[i])-7 );
       listing[i]   := '';

       Result:=false;
     end;


    if mva(i) and 										// mva aa :STACKORIGIN,x		; 0
       inx(i+1) and										// inx					; 1
       ldy_1(i+2) and										// ldy #1				; 2
       (listing[i+3] = #9'lda :STACKORIGIN-1,x') then						// lda :STACKORIGIN-1,x			; 3
     if (pos(':STACKORIGIN,x', listing[i]) > 0) then
     begin
       listing[i+3] := #9'lda ' + copy(listing[i], 6, pos(':STACK', listing[i])-7 );
       listing[i]   := '';

       Result:=false;
     end;


    if mva(i) and 										// mva aa :STACKORIGIN,x		; 0
       (listing[i+1] = #9'jsr andAL_CL') and							// jst andAL_CL				; 1
       ldy_1(i+2) and										// ldy #1				; 2
       (listing[i+3] = #9'lda :STACKORIGIN-1,x') then						// lda :STACKORIGIN-1,x			; 3
     if (pos(':STACKORIGIN,x', listing[i]) > 0) then
     begin
       listing[i+1] := listing[i+2];
       listing[i+2] := listing[i+3];

       listing[i+3] := #9'and ' + copy(listing[i], 6, pos(':STACK', listing[i])-7 );
       listing[i]   := '';

       Result:=false;
     end;


    if lda(i) and										// lda                                  ; 0
       cmp_im_0(i+1) and									// cmp #$00				; 1
       ((listing[i+2] = #9'bne @+') or (listing[i+2] = #9'beq @+')) and				// bne @+				; 2
       dey(i+3) and										// dey                  		; 3
       (listing[i+4] = '@') and									// @					; 4
       sty_stack(i+5) then									// sty :STACK				; 5
     begin
       listing[i+1] := '';

       Result:=false;
     end;


    if (listing[i] = '@') and									// @					; 0
       (listing[i+1] = #9'sty :STACKORIGIN-1,x') and						// sty :STACKORIGIN-1,x			; 1
       dex(i+2) and										// dex					; 2
       dex(i+3) and										// dex					; 3
       (listing[i+4] = #9'lda :STACKORIGIN+1,x') then						// lda :STACKORIGIN+1,x			; 4
     begin
       listing[i+1] := '';
       listing[i+4] := #9'tya';

       Result:=false;
     end;


    if (listing[i] = #9'ldy #1') and								// ldy #1				; 0
       (listing[i+1] = #9'lda :STACKORIGIN-1,x') and						// lda :STACKORIGIN-1,x			; 1
       (listing[i+2] = #9'beq @+') and								// beq @+				; 2
       dey(i+3) and										// dey					; 3
       (listing[i+4] = '@') and									//@					; 4
       dex(i+5) and										// dex					; 5
       dex(i+6) and										// dex					; 6
       tya(i+7) and										// tya					; 7
       (pos('jeq l_', listing[i+8]) > 0) then							// jeq					; 8
     begin
       listing[i]   := #9'dex';
       listing[i+1] := #9'dex';
       listing[i+2] := #9'lda :STACKORIGIN+1,x';
       listing[i+3] := #9'jne ' + copy(listing[i+8], 6, 256);

       listing[i+4] := '';
       listing[i+5] := '';
       listing[i+6] := '';
       listing[i+7] := '';
       listing[i+8] := '';

       Result:=false;
     end;


    if (listing[i] = #9'ldy #1') and								// ldy #1				; 0
       (listing[i+1] = #9'lda :STACKORIGIN-1,x') and						// lda :STACKORIGIN-1,x			; 1
       cmp(i+2) and										// cmp					; 2
       (listing[i+3] = #9'beq @+') and								// beq @+				; 3
       dey(i+4) and										// dey					; 4
       (listing[i+5] = '@') and									//@					; 5
       dex(i+6) and										// dex					; 6
       dex(i+7) and										// dex					; 7
       tya(i+8) and										// tya					; 8
       (pos('jeq l_', listing[i+9]) > 0) then							// jeq					; 9
     begin
       listing[i+3] := listing[i+2];

       listing[i]   := #9'dex';
       listing[i+1] := #9'dex';
       listing[i+2] := #9'lda :STACKORIGIN+1,x';

       listing[i+4] := #9'jne ' + copy(listing[i+9], 6, 256);

       listing[i+5] := '';
       listing[i+6] := '';
       listing[i+7] := '';
       listing[i+8] := '';
       listing[i+9] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and										// mva aa :STACKORIGIN,x		; 1
       ((listing[i+2] = #9'jsr orAL_CL') or (listing[i+2] = #9'jsr andAL_CL') or		// jsr or|and|xor AL_CL                 ; 2
        (listing[i+2] = #9'jsr xorAL_CL')) and							// dex                                  ; 3
       dex(i+3) then
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) then
     begin
       listing[i] := #9'lda :STACKORIGIN,x';

       if listing[i+2] = #9'jsr orAL_CL' then listing[i+1] := #9'ora ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 ) else
        if listing[i+2] = #9'jsr andAL_CL' then listing[i+1] := #9'and ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 ) else
         if listing[i+2] = #9'jsr xorAL_CL' then listing[i+1] := #9'eor ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       listing[i+2] := #9'sta :STACKORIGIN,x';
       listing[i+3] := '';

       Result:=false;
     end;


    if //inx(i) and										// inx					; 0
       mva(i+1) and										// mva a :STACKORIGIN			; 1
       mva(i+2) and (iy(i+2) = false) and							// mva a+1 :STACKORIGIN+STACKWIDTH	; 2
       (listing[i+3] = #9'lda :STACKORIGIN,x') and						// lda :STACKORIGIN			; 3
       (listing[i+4] = #9'ldy :STACKORIGIN+STACKWIDTH,x') then					// ldy :STACKORIGIN+STACKWIDTH		; 4
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) then
     begin
       listing[i+3]  := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );
       listing[i+4]  := #9'ldy ' + copy(listing[i+2], 6, pos(':STACK', listing[i+2])-7 );

       listing[i+1] := '';
       listing[i+2] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and 										// mva aa :STACKORIGIN			; 1
       lda(i+3) and add_stack(i+4) and								// mva bb|#$00 :STACKORIGIN+STACKWIDTH	; 2
       tay(i+5) and										// lda					; 3
       lda(i+6) and adc_stack(i+7) and								// add :STACKORIGIN			; 4
       sta_bp_1(i+8) and									// tay					; 5
       lda_bp_y(i+9) then									// lda					; 6
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and						// adc :STACKORIGIN+STACKWIDTH		; 7
	(pos(':STACKORIGIN,x', listing[i+4]) > 0) and						// sta :bp+1				; 8
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) and				// lda (:bp),y				; 9
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+7]) > 0) then
     begin
       listing[i+4]  := #9'add ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );
       listing[i+7]  := #9'adc ' + copy(listing[i+2], 6, pos(':STACK', listing[i+2])-7 );

       listing[i+1] := '';
       listing[i+2] := '';

       if adc_im_0(i+7) then
	if copy(listing[i+3], 6, 256)+'+1' = copy(listing[i+6], 6, 256) then begin
	 listing[i+3] := #9'mwa ' + copy(listing[i+3], 6, 256) + ' :bp2';
	 listing[i+4] := #9'ldy ' + copy(listing[i+4], 6, 256);
	 listing[i+5] := '';
	 listing[i+6] := '';
	 listing[i+7] := '';
	 listing[i+8] := '';
	 listing[i+9] := #9'lda (:bp2),y';
	end;

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and mva(i+2) and								// mva aa :STACKORIGIN,x		; 1
       lda(i+3) and add_stack(i+4) and								// mva bb :STACKORIGIN+STACKWIDTH,x	; 2
       sta(i+5) and										// lda					; 3
       lda(i+6) and adc_stack(i+7) and								// add :STACKORIGIN,x			; 4
       sta(i+8) then										// sta					; 5
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and						// lda					; 6
	(pos(':STACKORIGIN,x', listing[i+4]) > 0) and						// adc :STACKORIGIN+STACKWIDTH,x	; 7
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) and				// sta					; 8
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+7]) > 0) then
     begin
       listing[i+4]  := #9'add ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );
       listing[i+7]  := #9'adc ' + copy(listing[i+2], 6, pos(':STACK', listing[i+2])-7 );

       listing[i+1] := '';
       listing[i+2] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and mva(i+2) and								// mva aa :STACKORIGIN,x		; 1
       sta_stack(i+3) and sta_stack(i+4) and							// mva bb :STACKORIGIN+STACKWIDTH,x	; 2
       lda_stack(i+5) and lda_stack(i+7) and							// sta :STACKORIGIN+STACKWIDTH*2,x	; 3
       lda_stack(i+9) and lda_stack(i+11) and							// sta :STACKORIGIN+STACKWIDTH*3,x	; 4
       (listing[i+6] = #9'sta :ecx') and (listing[i+8] = #9'sta :ecx+1') and			// lda :STACKORIGIN,x			; 5
       (listing[i+10] = #9'sta :ecx+2') and (listing[i+12] = #9'sta :ecx+3') then		// sta :ecx				; 6
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and						// lda :STACKORIGIN+STACKWIDTH,x	; 7
	(pos(':STACKORIGIN,x', listing[i+5]) > 0) and						// sta :ecx+1				; 8
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) and				// lda :STACKORIGIN+STACKWIDTH*2,	; 9
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+7]) > 0) and				// sta :ecx+2				; 10
	(pos(':STACKORIGIN+STACKWIDTH*2,x', listing[i+3]) > 0) and				// lda :STACKORIGIN+STACKWIDTH*3,x	; 11
	(pos(':STACKORIGIN+STACKWIDTH*2,x', listing[i+9]) > 0) and				// sta :ecx+3				; 12
	(pos(':STACKORIGIN+STACKWIDTH*3,x', listing[i+4]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH*3,x', listing[i+11]) > 0) then
     begin
       listing[i+7]  := listing[i+2];
       listing[i+8]  := listing[i+3];
       listing[i+9]  := listing[i+4];
       listing[i+10] := #9'sta :ecx+1';
       listing[i+11] := #9'sta :ecx+2';

       listing[i+2] := '';
       listing[i+3] := '';
       listing[i+4] := '';
       listing[i+5] := '';

       Result:=false;
     end;


    if //inx(i) and										// inx					; 0
       mva(i+1) and (iy(i+1) = false) and							// mva xx :STACKORIGIN,x		; 1
       sta(i+2) and										// sta :STACKORIGIN+STACKWIDTH,x	; 2
       ldy_stack(i+3) and									// ldy :STACKORIGIN,x			; 3
       (pos('mva adr.', listing[i+4]) > 0) then							// mva adr.__,y :STACKORIGIN,x		; 4
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
	(pos(':STACKORIGIN,x', listing[i+3]) > 0) and
	(pos(':STACKORIGIN,x', listing[i+4]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) then
     begin
       listing[i+2] := '';
       listing[i+3] := #9'ldy ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );
       listing[i+1] := '';
       Result:=false;
     end;


    if //inx(i) and										// inx					; 0
       mva(i+1) and (iy(i+1) = false) and							// mva xx :STACKORIGIN,x		; 1
       mva(i+2) and										// mva yy :STACKORIGIN+STACKWIDTH,x	; 2
       ldy_stack(i+3) and									// ldy :STACKORIGIN,x			; 3
       (pos('mva adr.', listing[i+4]) > 0) then							// mva adr.__,y :STACKORIGIN,x		; 4
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
	(pos(':STACKORIGIN,x', listing[i+3]) > 0) and
	(pos(':STACKORIGIN,x', listing[i+4]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) then
     begin
       listing[i+2] := '';
       listing[i+3] := #9'ldy ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );
       listing[i+1] := '';
       Result:=false;
     end;


    if //inx(i) and										// inx					; 0
       mva(i+1) and (iy(i+1) = false) and							// mva xx :STACKORIGIN,x		; 1
       ldy_stack(i+2) and									// ldy :STACKORIGIN,x			; 2
       (pos('mva adr.', listing[i+3]) > 0) then							// mva adr.__,y :STACKORIGIN,x		; 3
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
	(pos(':STACKORIGIN,x', listing[i+2]) > 0) and
	(pos(':STACKORIGIN,x', listing[i+3]) > 0) then
     begin
       listing[i+2] := #9'ldy ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );
       listing[i+1] := '';
       Result:=false;
     end;


    if //inx(i) and										// inx					; 0
       ldy(i+1) and 										// ldy 					; 1
       (pos('mva adr.', listing[i+2]) > 0) and							// mva adr.	.STACKORIGIN,x		; 2
       inx(i+3) and										// inx					; 3
       ldy(i+4) and 										// ldy 					; 4
       (pos('mva adr.', listing[i+5]) > 0) then							// mva adr.	.STACKORIGIN,x		; 5
     if (listing[i+1] = listing[i+4]) and
	(pos(':STACKORIGIN,x', listing[i+2]) > 0) and
	(pos(':STACKORIGIN,x', listing[i+5]) > 0) then
     begin
       listing[i+4] := '';
       Result:=false;
     end;


    if //inx(i) and										// inx					; 0
       mva(i+1) and (iy(i+1) = false) and							// mva xx :STACKORIGIN,x		; 1
       mva(i+2) and										// mva yy :STACKORIGIN+STACKWIDTH,x	; 2
       mva(i+3) and										// mva zz :STACKORIGIN+STACKWIDTH*2,x	; 3
       mva(i+4) and										// mva qq :STACKORIGIN+STACKWIDTH*3,x	; 4
       ldy_stack(i+5) and									// ldy :STACKORIGIN,x			; 5
       (pos('mva adr.', listing[i+6]) > 0) then							// mva adr.__,y :STACKORIGIN,x		; 6
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+5]) > 0) and
	(pos(':STACKORIGIN,x', listing[i+6]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH*2,x', listing[i+3]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH*3,x', listing[i+4]) > 0) then
     begin
       listing[i+2] := '';
       listing[i+3] := '';
       listing[i+4] := '';
       listing[i+5] := #9'ldy ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );
       listing[i+1] := '';
       Result:=false;
     end;


    if (pos('mva adr.', listing[i]) > 0) and							// mva adr.  :STACKORIGIN,x		; 0
       (pos('mva adr.', listing[i+1]) > 0) and							// mva adr.  :STACKORIGIN+STACKWIDTH,x	; 1
       mva_stack(i+2) and									// mva :STACKORIGIN,x TILE		; 2
       mva_stack(i+3) then									// mva :STACKORIGIN+STACKWIDTH,x TILE+1	; 3
     if (pos(':STACKORIGIN,x', listing[i]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+2]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+1]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+3]) > 0) then
     begin

       delete(listing[i], pos(':STACK', listing[i]), 256);
       delete(listing[i+1], pos(':STACK', listing[i+1]), 256);

       listing[i]   := listing[i] + copy(listing[i+2], pos(',x ', listing[i+2])+3, 256);
       listing[i+1] := listing[i+1] + copy(listing[i+3], pos(',x ', listing[i+3])+3, 256);

       listing[i+2] := '';
       listing[i+3] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva_im(i+1) and										// mva # :STACKORIGIN,x			; 1
       inx(i+2) and										// inx					; 2
       mva_im(i+3) and										// mva # :STACKORIGIN,x			; 3
       add_sub_AL_CL(i+4) then									// jsr addAL_CL|subAL_CL		; 4
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) then
     begin

       p := GetBYTE(i+1);
       q := GetBYTE(i+3);

       if listing[i+4] = #9'jsr addAL_CL' then
        p:=p + q
       else
        p:=p - q;

       listing[i+1] := #9'mva #$'+IntToHex(p and $ff, 2) + ' :STACKORIGIN,x';

       listing[i+2] := '';
       listing[i+3] := '';
       listing[i+4] := #9'inx';

       Result:=false;
     end;


    if inx(i) and (iy(i+1) = false) and								// inx					; 0
       mva(i+1) and (mva_im(i+1) = false) and							// mva  :STACKORIGIN,x			; 1
       inx(i+2) and										// inx					; 2
       (pos('mva #$01', listing[i+3]) > 0) and							// mva #$01 :STACKORIGIN,x		; 3
       add_sub_AL_CL(i+4) then									// jsr addAL_CL|subAL_CL		; 4
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) then
     begin

       listing[i+1] := #9'ldy ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if listing[i+4] = #9'jsr addAL_CL' then
        listing[i+2] := #9'iny'
       else
        listing[i+2] := #9'dey';

       listing[i+3] := #9'sty :STACKORIGIN,x';
       listing[i+4] := #9'inx';

       Result:=false;
     end;


    if (iy(i) = false) and									// mva  :STACKORIGIN,x			; 0
       mva(i) and (mva_im(i) = false) and							// inx					; 1
       inx(i+1) and										// mva #$01 :STACKORIGIN,x		; 2
       (pos('mva #$01', listing[i+2]) > 0) and							// jsr addAL_CL|subAL_CL		; 3
       add_sub_AL_CL(i+3) and									// dex					; 4
       dex(i+4) then
     if (pos(':STACKORIGIN,x', listing[i]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+2]) > 0) then
     begin

       listing[i] := #9'ldy ' + copy(listing[i], 6, pos(':STACK', listing[i])-7 );

       if listing[i+3] = #9'jsr addAL_CL' then
        listing[i+1] := #9'iny'
       else
        listing[i+1] := #9'dey';

       listing[i+2] := #9'sty :STACKORIGIN,x';
       listing[i+3] := '';
       listing[i+4] := '';

       Result:=false;
     end;


    if (pos('jsr ', listing[i]) > 0) and							// jsr					; 0
       inx(i+1) and										// inx					; 1
       mva(i+2) and										// mva  :STACKORIGIN,x			; 2
       add_sub_AL_CL(i+3) and									// jsr addAL_CL|subAL_CL		; 3
       dex(i+4) then										// dex					; 4
     if (pos(':STACKORIGIN,x', listing[i+2]) > 0) then
     begin

       listing[i+1] := #9'lda :STACKORIGIN,x';

       if listing[i+3] = #9'jsr addAL_CL' then
        listing[i+2] := #9'add ' + copy(listing[i+2], 6, pos(':STACK', listing[i+2])-7 )
       else
        listing[i+2] := #9'sub ' + copy(listing[i+2], 6, pos(':STACK', listing[i+2])-7 );

       listing[i+3] := #9'sta :STACKORIGIN,x';
       listing[i+4] := '';

       Result:=false;
     end;


    if inx(i) and (iy(i+1) = false) and								// inx					; 0
       mva(i+1) and 										// mva  :STACKORIGIN,x			; 1
       inx(i+2) and (iy(i+3) = false) and							// inx					; 2
       mva(i+3) and										// mva  :STACKORIGIN,x			; 3
       add_sub_AL_CL(i+4) then									// jsr addAL_CL|subAL_CL		; 4
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) then
     begin

       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if listing[i+4] = #9'jsr addAL_CL' then
        listing[i+2] := #9'add ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 )
       else
        listing[i+2] := #9'sub ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 );

       listing[i+3] := #9'sta :STACKORIGIN,x';
       listing[i+4] := #9'inx';

       Result:=false;
     end;


    if inx(i) and (iy(i+1) = false) and								// inx					; 0
       mva(i+1) and 										// mva  :STACKORIGIN,x			; 1
       inx(i+2) and 										// inx					; 2
       ldy_im(i+3) and										// ldy #				; 3
       (pos('mva adr.', listing[i+4]) > 0) and iy(i+4) and					// mva adr. ,y  :STACKORIGIN,x		; 4
       add_sub_AL_CL(i+5) then									// jsr addAL_CL|subAL_CL		; 5
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+4]) > 0) then
     begin

       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if listing[i+5] = #9'jsr addAL_CL' then
        listing[i+2] := #9'add ' + copy(listing[i+4], 6, pos(',y :', listing[i+4])-6 ) + '+' + copy(listing[i+3], 7, 256)
       else
        listing[i+2] := #9'sub ' + copy(listing[i+4], 6, pos(',y :', listing[i+4])-6 ) + '+' + copy(listing[i+3], 7, 256);

       listing[i+3] := '';
       listing[i+4] := #9'sta :STACKORIGIN,x';
       listing[i+5] := #9'inx';

       Result:=false;
     end;


    if ldy_im(i) and										// ldy #				; 0
       (pos('mva adr.', listing[i+1]) > 0) and iy(i+1) and					// mva adr. ,y  :STACKORIGIN,x		; 1
       inx(i+2) and (iy(i+3) = false) and							// inx					; 2
       mva(i+3) and 										// mva  :STACKORIGIN,x			; 3
       add_sub_AL_CL(i+4) and									// jsr addAL_CL|subAL_CL		; 4
       dex(i+5) then 										// dex					; 5
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) then
     begin

       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(',y :', listing[i+1])-6 ) + '+' + copy(listing[i], 7, 256);

       listing[i] := '';

       if listing[i+4] = #9'jsr addAL_CL' then
        listing[i+2] := #9'add ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 )
       else
        listing[i+2] := #9'sub ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 );

       listing[i+3] := #9'sta :STACKORIGIN,x';
       listing[i+4] := '';
       listing[i+5] := '';

       Result:=false;
     end;


    if inx(i) and (iy(i+1) = false) and								// inx					; 0
       mva(i+1) and 										// mva  :STACKORIGIN,x			; 1
       inx(i+2) and 										// inx					; 2
       mwa_bp2(i+3) and										// mwa ... :bp2				; 3
       ldy_im(i+4) and										// ldy #				; 4
       (pos('mva (:bp2),y', listing[i+5]) > 0) and 						// mva (:bp2),y :STACKORIGIN,x		; 5
       add_sub_AL_CL(i+6) then									// jsr addAL_CL|subAL_CL		; 6
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+5]) > 0) then
     begin

       tmp := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       listing[i+1] := listing[i+3];
       listing[i+2] := listing[i+4];
       listing[i+3] := tmp;

       if listing[i+6] = #9'jsr addAL_CL' then
        listing[i+4] := #9'add (:bp2),y'
       else
        listing[i+4] := #9'sub (:bp2),y';

       listing[i+5] := #9'sta :STACKORIGIN,x';
       listing[i+6] := #9'inx';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mwa_bp2(i+1) and										// mwa ... :bp2				; 1
       ldy_im(i+2) and										// ldy #				; 2
       LDA_BP2_Y(i+3) and 									// lda (:bp2),y 			; 3
       (listing[i+4] = #9'sta :STACKORIGIN,x') and 						// sta :STACKORIGIN,x			; 4
       inx(i+5) and (iy(i+6) = false) and							// inx					; 5
       mva(i+6) and 										// mva .. :STACKORIGIN,x		; 6
       add_sub_AL_CL(i+7) then									// jsr addAL_CL|subAL_CL		; 7
     if (pos(':STACKORIGIN,x', listing[i+6]) > 0) then
     begin

       if listing[i+7] = #9'jsr addAL_CL' then
        listing[i+4] := #9'add ' + copy(listing[i+6], 6, pos(':STACK', listing[i+6])-7 )
       else
        listing[i+4] := #9'sub ' + copy(listing[i+6], 6, pos(':STACK', listing[i+6])-7 );

       listing[i+5] := #9'sta :STACKORIGIN,x';
       listing[i+6] := #9'inx';

       listing[i+7] := '';

       Result:=false;
     end;


    if inx(i) and 										// inx					; 0
       mwa_bp2(i+1) and										// mwa ... :bp2				; 1
       ldy_im(i+2) and										// ldy #				; 2
       (pos('mva (:bp2),y', listing[i+3]) > 0) and 						// mva (:bp2),y :STACKORIGIN,x		; 3
       inx(i+4) and (iy(i+5) = false) and							// inx					; 4
       mva(i+5) and 										// mva .. :STACKORIGIN,x		; 5
       add_sub_AL_CL(i+6) then									// jsr addAL_CL|subAL_CL		; 6
     if (pos(':STACKORIGIN,x', listing[i+3]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+5]) > 0) then
     begin

       listing[i+3] := #9'lda (:bp2),y';

       if listing[i+6] = #9'jsr addAL_CL' then
        listing[i+4] := #9'add ' + copy(listing[i+5], 6, pos(':STACK', listing[i+5])-7 )
       else
        listing[i+4] := #9'sub ' + copy(listing[i+5], 6, pos(':STACK', listing[i+5])-7 );

       listing[i+5] := #9'sta :STACKORIGIN,x';
       listing[i+6] := #9'inx';

       Result:=false;
     end;


    if inx(i) and 										// inx					; 0
       mwa_bp2(i+1) and										// mwa ... :bp2				; 1
       ldy_im(i+2) and										// ldy #				; 2
       (pos('mva (:bp2),y', listing[i+3]) > 0) and 						// mva (:bp2),y :STACKORIGIN,x		; 3
       inx(i+4) and 										// inx					; 4
       ldy_im(i+5) and										// ldy #				; 5
       (pos('mva (:bp2),y', listing[i+6]) > 0) and	 					// mva (:bp2),y :STACKORIGIN,x		; 6
       add_sub_AL_CL(i+7) then									// jsr addAL_CL|subAL_CL		; 7
     if (pos(':STACKORIGIN,x', listing[i+3]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+6]) > 0) then
     begin

       listing[i+3] := #9'lda (:bp2),y';
       listing[i+4] := listing[i+5];

       if listing[i+7] = #9'jsr addAL_CL' then
        listing[i+5] := #9'add (:bp2),y'
       else
        listing[i+5] := #9'sub (:bp2),y';

       listing[i+6] := #9'sta :STACKORIGIN,x';
       listing[i+7] := #9'inx';

       Result:=false;
     end;


    if inx(i) and 										// inx					; 0
       ldy_im(i+1) and										// ldy #				; 1
       (pos('mva (:bp2),y', listing[i+2]) > 0) and 						// mva (:bp2),y :STACKORIGIN,x		; 2
       inx(i+3) and 										// inx					; 3
       ldy_im(i+4) and										// ldy #				; 4
       (pos('mva (:bp2),y', listing[i+5]) > 0) and	 					// mva (:bp2),y :STACKORIGIN,x		; 5
       add_sub_AL_CL(i+6) then									// jsr addAL_CL|subAL_CL		; 6
     if (pos(':STACKORIGIN,x', listing[i+2]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+5]) > 0) then
     begin

       listing[i+2] := #9'lda (:bp2),y';
       listing[i+3] := listing[i+4];

       if listing[i+6] = #9'jsr addAL_CL' then
        listing[i+4] := #9'add (:bp2),y'
       else
        listing[i+4] := #9'sub (:bp2),y';

       listing[i+5] := #9'sta :STACKORIGIN,x';
       listing[i+6] := #9'inx';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and 										// mva  :STACKORIGIN,x			; 1
       mva(i+2) and 										// mva  :STACKORIGIN+STACKWIDTH,x	; 2
       inx(i+3) and 										// inx					; 3
       mva(i+4) and 										// mva  :STACKORIGIN,x			; 4
       mva(i+5) and 										// mva  :STACKORIGIN+STACKWIDTH,x	; 5
       add_sub_AX_CX(i+6) and									// jsr addAX_CX|subAX_CX		; 6
       dex(i+7) then										// dex					; 7
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+4]) > 0) and
     	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) and
     	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+5]) > 0) then
     begin

       tmp := #9'lda ' + copy(listing[i+2], 6, pos(':STACK', listing[i+2])-7 );

       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+2] := #9'add ' + copy(listing[i+4], 6, pos(':STACK', listing[i+4])-7 )
       else
        listing[i+2] := #9'sub ' + copy(listing[i+4], 6, pos(':STACK', listing[i+4])-7 );

       listing[i+3] := #9'sta :STACKORIGIN,x';

       listing[i+4] := tmp;

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+5] := #9'adc ' + copy(listing[i+5], 6, pos(':STACK', listing[i+5])-7 )
       else
        listing[i+5] := #9'sbc ' + copy(listing[i+5], 6, pos(':STACK', listing[i+5])-7 );

       listing[i+6] := #9'sta :STACKORIGIN+STACKWIDTH,x';

       listing[i+7] :='';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and										// mva   :STACKORIGIN,x			; 1
       mva(i+2) and 										// mva   :STACKORIGIN+STACKWIDTH,x	; 2
       add_sub_AL_CL(i+3) then									// jsr addAL_CL|subAL_CL		; 3
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) then
     begin

       listing[i+2] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and										// mva   :STACKORIGIN,x			; 1
       mva(i+2) and 										// mva   :STACKORIGIN+STACKWIDTH,x	; 2
       mva(i+3) and 										// mva   :STACKORIGIN-1+STACKWIDTH,x	; 3
       add_sub_AL_CL(i+4) then									// jsr addAL_CL|subAL_CL		; 4
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) then
     begin

       listing[i+2] := '';
       listing[i+3] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva_im(i+1) and										// mva # :STACKORIGIN,x			; 1
       inx(i+2) and										// inx					; 2
       mva_im(i+3) and										// mva # :STACKORIGIN,x			; 3
       mva_im(i+4) and										// mva # :STACKORIGIN-1+STACKWIDTH,x	; 4
       mva_im(i+5) and 										// mva # :STACKORIGIN+STACKWIDTH,x	; 5
       add_sub_AX_CX(i+6) then									// jsr addAX_CX|subAX_CX		; 6
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) and
	(pos(':STACKORIGIN-1+STACKWIDTH,x', listing[i+4]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+5]) > 0) then
     begin

       p := GetWORD(i+1, i+4);
       q := GetWORD(i+3, i+5);

       if listing[i+6] = #9'jsr addAX_CX' then
        p:=p + q
       else
        p:=p - q;

       listing[i+1] := #9'mva #$'+IntToHex(p and $ff, 2) + ' :STACKORIGIN,x';
       listing[i+2] := #9'mva #$'+IntToHex(byte(p shr 8), 2) + ' :STACKORIGIN+STACKWIDTH,x';

       listing[i+3] := '';
       listing[i+4] := '';
       listing[i+5] := '';
       listing[i+6] := #9'inx';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and										// mva  :STACKORIGIN,x			; 1
       inx(i+2) and										// inx					; 2
       mva(i+3) and										// mva  :STACKORIGIN,x			; 3
       mva_im(i+4) and										// mva #  :STACKORIGIN-1+STACKWIDTH,x	; 4
       sta(i+5) and 										// sta :STACKORIGIN+STACKWIDTH,x	; 5
       add_sub_AX_CX(i+6) and									// jsr addAX_CX|subAX_CX		; 6
       dex(i+7) then										// dex					; 7
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) and
	(pos(':STACKORIGIN-1+STACKWIDTH,x', listing[i+4]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+5]) > 0) then
     begin

       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+2] := #9'add ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 )
       else
        listing[i+2] := #9'sub ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 );

       listing[i+3] := #9'sta :STACKORIGIN,x';

       tmp := copy(listing[i+4], 6, pos(':STACK', listing[i+4])-7 );

       listing[i+4] := #9'lda ' + tmp;

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+5] := #9'adc ' + tmp
       else
        listing[i+5] := #9'sbc ' + tmp;

       listing[i+6] := #9'sta :STACKORIGIN+STACKWIDTH,x';

       listing[i+7] :='';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and										// mva  :STACKORIGIN,x			; 1
       inx(i+2) and										// inx					; 2
       mva(i+3) and										// mva  :STACKORIGIN,x			; 3
       mva_im(i+4) and										// mva #  :STACKORIGIN+STACKWIDTH,x	; 4
       sta(i+5) and 										// sta :STACKORIGIN-1+STACKWIDTH,x	; 5
       add_sub_AX_CX(i+6) and									// jsr addAX_CX|subAX_CX		; 6
       dex(i+7) then										// dex					; 7
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+4]) > 0) and
	(pos(':STACKORIGIN-1+STACKWIDTH,x', listing[i+5]) > 0) then
     begin

       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+2] := #9'add ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 )
       else
        listing[i+2] := #9'sub ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 );

       listing[i+3] := #9'sta :STACKORIGIN,x';

       tmp := copy(listing[i+4], 6, pos(':STACK', listing[i+4])-7 );

       listing[i+4] := #9'lda ' + tmp;

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+5] := #9'adc ' + tmp
       else
        listing[i+5] := #9'sbc ' + tmp;

       listing[i+6] := #9'sta :STACKORIGIN+STACKWIDTH,x';

       listing[i+7] :='';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and										// mva  :STACKORIGIN,x			; 1
       inx(i+2) and										// inx					; 2
       mva(i+3) and										// mva  :STACKORIGIN,x			; 3
       mva(i+4) and										// mva  :STACKORIGIN+STACKWIDTH,x	; 4
       mva(i+5) and 										// mva  :STACKORIGIN-1+STACKWIDTH,x	; 5
       add_sub_AX_CX(i+6) and									// jsr addAX_CX|subAX_CX		; 6
       dex(i+7) then										// dex					; 7
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+4]) > 0) and
	(pos(':STACKORIGIN-1+STACKWIDTH,x', listing[i+5]) > 0) then
     begin

       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+2] := #9'add ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 )
       else
        listing[i+2] := #9'sub ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 );

       listing[i+3] := #9'sta :STACKORIGIN,x';

       tmp:=copy(listing[i+4], 6, pos(':STACK', listing[i+4])-7 );

       listing[i+4] := #9'lda ' + copy(listing[i+5], 6, pos(':STACK', listing[i+5])-7 );

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+5] := #9'adc ' + tmp
       else
        listing[i+5] := #9'sbc ' + tmp;

       listing[i+6] := #9'sta :STACKORIGIN+STACKWIDTH,x';

       listing[i+7] :='';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva_im(i+1) and										// mva # :STACKORIGIN,x			; 1
       mva_im(i+2) and										// mva # :STACKORIGIN+STACKWIDTH,x	; 2
       inx(i+3) and										// inx					; 3
       mva_im(i+4) and										// mva # :STACKORIGIN,x			; 4
       mva_im(i+5) and 										// mva # :STACKORIGIN+STACKWIDTH,x	; 5
       add_sub_AX_CX(i+6) then									// jsr addAX_CX|subAX_CX		; 6
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+4]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+5]) > 0) then
     begin

       p := GetWORD(i+1, i+2);
       q := GetWORD(i+4, i+5);

       if listing[i+6] = #9'jsr addAX_CX' then
        p:=p + q
       else
        p:=p - q;

       listing[i+1] := #9'mva #$'+IntToHex(p and $ff, 2) + ' :STACKORIGIN,x';
       listing[i+2] := #9'mva #$'+IntToHex(byte(p shr 8), 2) + ' :STACKORIGIN+STACKWIDTH,x';

       listing[i+3] := '';
       listing[i+4] := '';
       listing[i+5] := '';
       listing[i+6] := #9'inx';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and (mva_stack(i+1) = false) and						// mva ... :STACKORIGIN,x		; 1
       mva(i+2) and (mva_stack(i+2) = false) and						// mva ... :STACKORIGIN+STACKWIDTH,x	; 2
       inx(i+3) and										// inx					; 3
       mva(i+4) and (mva_stack(i+4) = false) and						// mva ... :STACKORIGIN,x		; 4
       mva(i+5) and (mva_stack(i+5) = false) and						// mva ... :STACKORIGIN+STACKWIDTH,x	; 5
       add_sub_AX_CX(i+6) and									// jsr addAX_CX|subAX_CX		; 6
       dex(i+7) and										// dex					; 7
       (listing[i+8] = #9'm@index2 0') and							// m@index2 0				; 8
       (listing[i+9] = #9'ldy :STACKORIGIN,x') and						// ldy :STACKORIGIN,x			; 9
       mva(i+10) and (pos(',y :STACKORIGIN,x', listing[i+10]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 10
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+4]) > 0) then
     begin
       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+2] := #9'add ' + copy(listing[i+4], 6, pos(':STACK', listing[i+4])-7 )
       else
        listing[i+2] := #9'sub ' + copy(listing[i+4], 6, pos(':STACK', listing[i+4])-7 );

       listing[i+3] := #9'asl @';
       listing[i+4] := #9'tay';

       if add_im_0(i+2) or sub_im_0(i+2) then listing[i+2]:='';

       listing[i+5] := '';
       listing[i+6] := '';
       listing[i+7] := '';
       listing[i+8] := '';
       listing[i+9] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and (mva_stack(i+1) = false) and						// mva ... :STACKORIGIN,x		; 1
       mva(i+2) and (mva_stack(i+2) = false) and						// mva ... :STACKORIGIN+STACKWIDTH,x	; 2
       inx(i+3) and										// inx					; 3
       mva(i+4) and (mva_stack(i+4) = false) and						// mva ... :STACKORIGIN,x		; 4
       mva(i+5) and (mva_stack(i+5) = false) and						// mva ... :STACKORIGIN+STACKWIDTH,x	; 5
       (listing[i+6] = #9'm@index4 0') and							// m@index4 0				; 6
       add_sub_AX_CX(i+7) and									// jsr addAX_CX|subAX_CX		; 7
       dex(i+8) and										// dex					; 8
       (listing[i+9] = #9'ldy :STACKORIGIN,x') and						// ldy :STACKORIGIN,x			; 9
       mva(i+10) and (pos(',y :STACKORIGIN,x', listing[i+10]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 10
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+4]) > 0) then
     begin

       if listing[i+7] = #9'jsr addAX_CX' then
        listing[i+5] := #9'add ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 )
       else
        listing[i+5] := #9'sub ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if add_im_0(i+5) or sub_im_0(i+5) then listing[i+5]:='';

       listing[i+2] := #9'lda ' + copy(listing[i+4], 6, pos(':STACK', listing[i+4])-7 );
       listing[i+3] := #9'asl @';
       listing[i+4] := #9'asl @';

       listing[i+6] := #9'tay';

       listing[i+1] := '';

       listing[i+7] := '';
       listing[i+8] := '';
       listing[i+9] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and (mva_stack(i+1) = false) and						// mva ... :STACKORIGIN,x		; 1
       inx(i+2) and										// inx					; 2
       mva(i+3) and (mva_stack(i+3) = false) and						// mva ... :STACKORIGIN,x		; 3
       mva(i+4) and (mva_stack(i+4) = false) and						// mva ... :STACKORIGIN+STACKWIDTH,x	; 4
       sta(i+5) and										// sta :STACK				; 5
       add_sub_AX_CX(i+6) and									// jsr addAX_CX|subAX_CX		; 6
       dex(i+7) and										// dex					; 7
       (listing[i+8] = #9'm@index2 0') and							// m@index2 0				; 8
       (listing[i+9] = #9'ldy :STACKORIGIN,x') and						// ldy :STACKORIGIN,x			; 9
       mva(i+10) and (pos(',y :STACKORIGIN,x', listing[i+10]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 10
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) then
     begin
       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

       if listing[i+6] = #9'jsr addAX_CX' then
        listing[i+2] := #9'add ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 )
       else
        listing[i+2] := #9'sub ' + copy(listing[i+3], 6, pos(':STACK', listing[i+3])-7 );

       listing[i+3] := #9'asl @';
       listing[i+4] := #9'tay';

       if add_im_0(i+2) then listing[i+2]:='';

       listing[i+5] := '';
       listing[i+6] := '';
       listing[i+7] := '';
       listing[i+8] := '';
       listing[i+9] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mwa_bp2(i+1) and										// mwa ... :bp2				; 1
       ldy_im_0(i+2) and									// ldy #$00				; 2
       (pos('mva (:bp2),y', listing[i+3]) > 0) and						// mva (:bp2),y :STACKORIGIN,x		; 3
       mva(i+4) and 										// mva 					; 4
       (listing[i+5] = #9'm@index2 0') and							// m@index2 0				; 5
       (listing[i+6] = #9'ldy :STACKORIGIN,x') and						// ldy :STACKORIGIN,x			; 6
       mva(i+7) and (pos(',y :STACKORIGIN,x', listing[i+7]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 7
     if (pos(':STACKORIGIN,x', listing[i+3]) > 0) then
     begin
       listing[i+3] := #9'lda (:bp2),y';
       listing[i+4] := #9'asl @';
       listing[i+5] := #9'tay';

       listing[i+6] := '';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and (mva_stack(i+1) = false) and						// mva ... :STACKORIGIN,x		; 1
       mva(i+2) and (mva_stack(i+2) = false) and						// mva ... :STACKORIGIN+STACKWIDTH,x	; 2
       (listing[i+3] = #9'm@index2 0') and							// m@index2 0				; 3
       (listing[i+4] = #9'ldy :STACKORIGIN,x') and						// ldy :STACKORIGIN,x			; 4
       mva(i+5) and (pos(',y :STACKORIGIN,x', listing[i+5]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 5
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) then
     begin
       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );
       listing[i+2] := #9'asl @';
       listing[i+3] := #9'tay';

       listing[i+4] := '';

       Result:=false;
     end;


    if (listing[i] = #9'sta :STACKORIGIN,x') and						// sta :STACKORIGIN,x			; 0
       mva(i+1) and (mva_stack(i+1) = false) and						// mva ... :STACKORIGIN+STACKWIDTH,x	; 1
       (listing[i+2] = #9'm@index2 0') and							// m@index2 0				; 2
       (listing[i+3] = #9'ldy :STACKORIGIN,x') then						// ldy :STACKORIGIN,x			; 3
     if (pos(':STACKORIGIN+STACKWIDTH,x', listing[i+1]) > 0) then
     begin
       listing[i+0] := '';
       listing[i+1] := '';
       listing[i+2] := #9'asl @';
       listing[i+3] := #9'tay';

       Result:=false;
     end;


    if (listing[i] = #9'sta :STACKORIGIN,x') and						// sta :STACKORIGIN,x			; 0
       (listing[i+1] = #9'ldy :STACKORIGIN-1,x') and						// ldy :STACKORIGIN-1,x			; 1
       mva_stack(i+2) and (pos(' adr.', listing[i+2]) > 0) then					// mva :STACKORIGIN,x adr. ,y		; 2
     if (pos(':STACKORIGIN,x', listing[i+2]) > 0) then
     begin
       listing[i] := '';

       listing[i+2] := #9'sta ' +  copy(listing[i+2], pos('adr.', listing[i+2]), 256 );

       Result:=false;
     end;


    if mva(i) and (mva_stack(i) = false) and 							// mva ... :STACKORIGIN,x		; 0
       (listing[i+1] = #9'ldy :STACKORIGIN,x') and						// ldy :STACKORIGIN,x			; 1
       (pos(' adr.', listing[i+2]) > 0) then							// mva adr. ,y				; 2
     if (pos(':STACKORIGIN,x', listing[i]) > 0) then
     begin

       if iy(i) then begin
	listing[i]   := #9'lda ' + copy(listing[i], 6, pos(':STACK', listing[i])-7 );
	listing[i+1] := #9'tay';
       end else begin
	listing[i+1] := #9'ldy ' + copy(listing[i], 6, pos(':STACK', listing[i])-7 );
	listing[i] := '';
       end;

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and (mva_stack(i+1) = false) and						// mva ... :STACKORIGIN,x		; 1
       mva(i+2) and (mva_stack(i+2) = false) and						// mva ... :STACKORIGIN+STACKWIDTH,x	; 2
       (listing[i+3] = #9'm@index4 0') and							// m@index4 0				; 3
       (listing[i+4] = #9'ldy :STACKORIGIN,x') and						// ldy :STACKORIGIN,x			; 4
       mva(i+5) and (pos(',y :STACKORIGIN,x', listing[i+5]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 5
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) then
     begin
       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );
       listing[i+2] := #9'asl @';
       listing[i+3] := #9'asl @';
       listing[i+4] := #9'tay';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva_im(i+1) and										// mva # :STACKORIGIN,x			; 1
       inx(i+2) and										// inx					; 2
       mva_im(i+3) and										// mva # :STACKORIGIN,x			; 3
       (listing[i+4] = #9'jsr imulBYTE') and							// jsr imulBYTE				; 4
       (listing[i+5] = #9'jsr movaBX_EAX') and							// jsr movaBX_EAX			; 5
       dex(i+6) then										// dex					; 6
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+3]) > 0) then
     begin

       p := GetBYTE(i+1) * GetBYTE(i+3);

       listing[i]   := #9'inx';
       listing[i+1] := #9'mva #$'+IntToHex(p and $ff, 2) + ' :STACKORIGIN,x';
       listing[i+2] := #9'mva #$'+IntToHex(byte(p shr 8), 2) + ' :STACKORIGIN+STACKWIDTH,x';
       listing[i+3] := '';//#9'mva #$00 :STACKORIGIN+STACKWIDTH*2,x';
       listing[i+4] := '';//#9'mva #$00 :STACKORIGIN+STACKWIDTH*3,x';
       listing[i+5] := #9'inx';

       Result:=false;
     end;


    if (listing[i] = #9'jsr movaBX_EAX') and							// jsr movaBX_EAX			; 0
       dex(i+1) and										// dex					; 1
       (listing[i+2] = #9'm@index2 0') and							// m@index2 0				; 2
       (listing[i+3] = #9'ldy :STACKORIGIN,x') and						// ldy :STACKORIGIN,x			; 3
       mva(i+4) and (pos(',y :STACKORIGIN,x', listing[i+4]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 4
     begin
       listing[i]   := #9'dex';
       listing[i+1] := #9'lda :eax';
       listing[i+2] := #9'asl @';
       listing[i+3] := #9'tay';

       Result:=false;
     end;


    if Result and
       (listing[i] = #9'm@index2 0') and							// m@index2 0				; 0
       (listing[i+1] = #9'ldy :STACKORIGIN,x') then						// ldy :STACKORIGIN,x			; 1
     begin

       if listing[i-1] = #9'mva #$00 :STACKORIGIN+STACKWIDTH,x' then listing[i-1] := '';

       listing[i] := #9'asl :STACKORIGIN,x';

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and										// mva OLD :STACKORIGIN,x		; 1
       inx(i+2) and										// inx					; 2
       mva_im(i+3) and 										// mva #$08 :STACKORIGIN,x		; 3
       (listing[i+4] = #9'jsr imulBYTE') and							// jsr imulBYTE				; 4
       (listing[i+5] = #9'jsr movaBX_EAX') and							// jsr movaBX_EAX			; 5
       dex(i+6) and										// dex					; 6
       ldy_stack(i+7) and									// ldy :STACKORIGIN,x			; 7
       mva(i+8) and (pos(',y :STACKORIGIN,x', listing[i+8]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 8
     begin
       p:=GetVal( copy(listing[i+3], 6, 4) );

       if p in [2,4,8,16,32] then begin

	listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';

	listing[i+7] := #9'tay';

	asl_;

        Result:=false;
       end;

     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and										// mva OLD :STACKORIGIN,x		; 1
       inx(i+2) and										// inx					; 2
       mva_im(i+3) and 										// mva #$08 :STACKORIGIN,x		; 3
       (listing[i+4] = #9'jsr imulBYTE') and							// jsr imulBYTE				; 4
       (listing[i+5] = #9'jsr movaBX_EAX') and							// jsr movaBX_EAX			; 5
       mva(i+6) and										// mva	:STACKORIGIN,x			; 6
       mva_im(i+7) and										// mva #$00 :STACKORIGIN+STACKWIDTH,x	; 7
       ADD_SUB_AX_CX(i+8) and									// jsr addAX_CX|subAX_CX		; 8
       dex(i+9) and										// dex					; 9
       ldy_stack(i+10) and									// ldy :STACKORIGIN,x			; 10
       mva(i+11) and (pos(',y :STACKORIGIN,x', listing[i+11]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 11
     if (pos(':STACKORIGIN,x', listing[i+6]) > 0) then
     begin
       p:=GetVal( copy(listing[i+3], 6, 4) );

       if p in [2,4,8,16,32] then begin

	listing[i+1] := #9'lda ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-7 );

	tmp := copy(listing[i+6], 6, pos(':STACK', listing[i+6])-7 );

	if tmp = '#$00' then
	 listing[i+7] := ''
	else
	if listing[i+8] = #9'jsr addAX_CX' then
	 listing[i+7] := #9'add ' + tmp
	else
	 listing[i+7] := #9'sub ' + tmp;

	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';

	listing[i+8] := '';
	listing[i+9] := '';

	listing[i+10] := #9'tay';

	asl_;

        Result:=false;
       end;

     end;


    if	(listing[i] = #9'jsr movaBX_EAX') and							// jsr movaBX_EAX			; 0
	(listing[i+1] = #9'mva #$00 :STACKORIGIN,x') and					// mva #$00 :STACKORIGIN,x		; 1
	(listing[i+2] = #9'sta :STACKORIGIN+STACKWIDTH,x') and					// sta:STACKORIGIN+STACKWIDTH,x		; 2
	ADD_SUB_AX_CX(i+3) then									// jsr addAX_CX|subAX_CX		; 3
     begin
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

        Result:=false;
     end;


    if inx(i) and										// inx					; 0
       lda(i+1) and										// lda					; 1
       add_sub(i+2) and										// add|sub				; 2
       sta_stack(i+3) and									// sta :STACKORIGIN,x			; 3
       lda(i+4) and										// lda					; 4
       adc_sbc(i+5) and										// adc|sbc				; 5
       sta_stack(i+6) and									// sta :STACKORIGIN+STACKWIDTH,x	; 6
       ldy_stack(i+7) and									// ldy :STACKORIGIN,x			; 7
       mva(i+8) and (pos(',y :STACKORIGIN,x', listing[i+8]) > 0) then				// mva adr. ,y :STACKORIGIN,X		; 8
     if (copy(listing[i+3], 6, 256) = copy(listing[i+7], 6, 256)) then
     begin
       listing[i+3] := #9'tay';

       listing[i+4] := '';
       listing[i+5] := '';
       listing[i+6] := '';
       listing[i+7] := '';

       Result:=false;
     end;


    if (listing[i+2] = listing[i+5]) and
       inx(i) and										// inx					; 0
       mva(i+1) and										// mva	:STACKORIGIN,x			; 1
       mva_im(i+2) and										// mva #$00 :STACKORIGIN+STACKWIDTH,x	; 2
       inx(i+3) and										// inx					; 3
       mva(i+4) and										// mva	:STACKORIGIN,x			; 4
       mva_im(i+5) and										// mva #$00 :STACKORIGIN+STACKWIDTH,x	; 5
       (listing[i+6] = #9'jsr imulWORD') then							// jsr imulWORD				; 6
     begin
       listing[i+2] := '';
       listing[i+5] := '';

       listing[i+6] := #9'jsr imulBYTE';
       Result:=false;
     end;


    if (listing[i] = #9'jsr movaBX_EAX') and							// jsr movaBX_EAX			; 0
       dex(i+1) and										// dex					; 1
       (pos('mva :STACKORIGIN,x', listing[i+2]) > 0) and					// mva :STACKORIGIN,x			; 2
       (pos('mva :STACKORIGIN+STACKWIDTH,x', listing[i+3]) > 0) and				// mva :STACKORIGIN+STACKWIDTH,x	; 3
       dex(i+4) then										// dex					; 4
     begin
       listing[i]   := '';

       listing[i+2] := #9'mva :eax ' + copy(listing[i+2], pos(',x', listing[i+2])+3, length(listing[i+2]) ) ;
       listing[i+3] := #9'mva :eax+1 ' + copy(listing[i+3], pos(',x', listing[i+3])+3, length(listing[i+3]) ) ;

       Result:=false;
     end;


    if (listing[i] = #9'jsr movaBX_EAX') and							// jsr movaBX_EAX			; 0
       dex(i+1) and										// dex					; 1
       (pos('mva :STACKORIGIN,x', listing[i+2]) > 0) and					// mva :STACKORIGIN,x			; 2
       dex(i+3) then										// dex					; 3
     begin
       listing[i]   := '';

       listing[i+2] := #9'mva :eax ' + copy(listing[i+2], pos(',x', listing[i+2])+3, length(listing[i+2]) ) ;

       Result:=false;
     end;


    if inx(i) and										// inx					; 0
       mva(i+1) and										// mva  :STACKORIGIN,x			; 1
       mva(i+2) and										// mva  :STACKORIGIN+STACKWIDTH,x	; 2
       mva(i+3) and										// mva  :STACKORIGIN+STACKWIDTH*2,x	; 3
       mva(i+4) and										// mva  :STACKORIGIN+STACKWIDTH*3,x	; 4
       inx(i+5) and										// inx					; 5
       mva(i+6) and										// mva  :STACKORIGIN,x			; 6
       mva(i+7) and 										// mva  :STACKORIGIN+STACKWIDTH,x	; 7
       mva(i+8) and										// mva  :STACKORIGIN+STACKWIDTH*2,x	; 8
       mva(i+9) and 										// mva  :STACKORIGIN+STACKWIDTH*3,x	; 9
       ((listing[i+10] = #9'jsr addEAX_ECX') or	(listing[i+10] = #9'jsr subEAX_ECX')) then	// jsr addEAX_ECX|subEAX_ECX		; 10
     if (pos(':STACKORIGIN,x', listing[i+1]) > 0) and
     	(pos(':STACKORIGIN,x', listing[i+6]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+2]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH,x', listing[i+7]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH*2,x', listing[i+3]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH*2,x', listing[i+8]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH*3,x', listing[i+4]) > 0) and
	(pos(':STACKORIGIN+STACKWIDTH*3,x', listing[i+9]) > 0) then
     begin

	if (listing[i+10] = #9'jsr addEAX_ECX') then
	       tmp := #9'm@addEAX_ECX '
	else
	       tmp := #9'm@subEAX_ECX ';

	listing[i+1] := tmp +
	       		copy(listing[i+1], 6, pos(':STACK', listing[i+1])-6 ) +
       			copy(listing[i+6], 6, pos(':STACK', listing[i+6])-6 ) +
			copy(listing[i+2], 6, pos(':STACK', listing[i+2])-6 ) +
			copy(listing[i+7], 6, pos(':STACK', listing[i+7])-6 ) +
			copy(listing[i+3], 6, pos(':STACK', listing[i+3])-6 ) +
			copy(listing[i+8], 6, pos(':STACK', listing[i+8])-6 ) +
			copy(listing[i+4], 6, pos(':STACK', listing[i+4])-6 ) +
			copy(listing[i+9], 6, pos(':STACK', listing[i+9])-6 );


       listing[i+2] := '';
       listing[i+3] := '';
       listing[i+4] := '';
       listing[i+5] := '';
       listing[i+6] := '';
       listing[i+7] := '';
       listing[i+8] := '';
       listing[i+9] := '';

       listing[i+10] := #9'inx';

       Result:=false;
     end;


    if mva(i) and (mva_stack(i) = false) and							// mva YY+3 :STACKORIGIN+STACKWIDTH*3,x	; 0
       (pos(' :STACK', listing[i]) > 0) and							// lda :STACKORIGIN+STACKWIDTH*3,x	; 1
       lda_stack(i+1) and									// and|ora|eor				; 2
       and_ora_eor(i+2) and									// sta :STACKORIGIN+STACKWIDTH*3,x	; 3
       sta_stack(i+3) then
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) and
	(pos(copy(listing[i+1], 6, 256), listing[i]) > 0 ) then
      begin
	listing[i]   := #9'lda ' + copy(listing[i], 6, pos(':STACK', listing[i])-7);
	listing[i+1] := '';

	Result:=false;
      end;


    if mva(i) and (mva_stack(i) = false) and							// mva YY :STACKORIGIN,x		; 0
       mva(i+1) and (mva_stack(i+1) = false) and						// mva YY+1 :STACKORIGIN+STACKWIDTH,x	; 1
       (listing[i+2] = #9'jsr hiWORD') then							// jsr hiWORD				; 2
     if (pos(' :STACKORIGIN,x', listing[i]) > 0 ) and
        (pos(' :STACKORIGIN+STACKWIDTH,x', listing[i+1]) > 0 ) then
      begin
	listing[i]   := #9'mva ' + copy(listing[i+1], 6, pos(':STACK', listing[i+1])-6) + ':STACKORIGIN,x';

	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
      end;


    if lda(i) and										// lda 					; 0
       ldy(i+1) and										// ldy					; 1
       (listing[i+2] = #9'jsr @printSTRING') then						// jsr @printSTRING			; 2
      begin
        tmp := copy(listing[i], 6, 256);

	if tmp + '+1' = copy(listing[i+1], 6, 256) then begin
	  listing[i+2] := #9'@printSTRING ' + tmp;

	  listing[i]   := '';
	  listing[i+1] := '';

  	  Result:=false;
	end;

      end;


    if mva_im(i) and										// mva #  :STACKORIGIN			; 0
       (listing[i+1] = #9'@printCHAR') then							// @printCHAR				; 1
     if (pos(' :STACKORIGIN,x', listing[i]) > 0 ) then
      begin
	listing[i+1] := #9'@print ' + copy(listing[i], 6, pos(':STACK', listing[i])-7);

	listing[i]   := '';

	Result:=false;
      end;


    if inx(i) and										// inx					; 0
       (pos(#9'@print', listing[i+1]) > 0) then							// @print				; 1
      begin

        p:=i+1;
	while pos(#9'@print', listing[p]) > 0 do inc(p);

	if dex(p) then begin
	 listing[i] := '';
	 listing[p] := '';

	 Result:=false;
	end;

      end;

    if lda(i) and (listing[i] = listing[i+5]) and						// lda I				; 0
       asl_a(i+1) and										// asl @				; 1
       tay(i+2) and										// tay					; 2
       mva(i+3) and										// mva xxxx :STACKORIGIN,x		; 3
       inx(i+4) and										// inx					; 4
       lda(i+5) and										// lda I				; 5
       asl_a(i+6) and										// asl @				; 6
       tay(i+7) then										// tay					; 7
      begin
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';

	Result:=false;
      end;


    if (listing[i] = #9'bne *+5') and								// bne *+5		; 0
       (pos('jmp l_', listing[i+1]) > 0) then							// jmp l_		; 1
     begin
       listing[i]   := '';
       listing[i+1] := #9'jeq ' + copy(listing[i+1], 6, 256);

       Result:=false;
     end;


    if (listing[i] = #9'beq *+5') and								// beq *+5		; 0
       (pos('jmp l_', listing[i+1]) > 0) then							// jmp l_		; 1
     begin
       listing[i]   := '';
       listing[i+1] := #9'jne ' + copy(listing[i+1], 6, 256);

       Result:=false;
     end;


    if Result and
       mva_im(i) and										// mva #$xx		; 0
       mva_im(i+1) and										// mva #$xx		; 1
       (mva_im(i+2) = false) then								// ~mva #$		; 2
     if (copy(listing[i], 6, 4) = copy(listing[i+1], 6, 4)) then
     begin

       listing[i+1] := #9'sta' + copy(listing[i+1], 10, 256);

       Result:=false;
     end;


    if Result and
       mva_im(i) and										// mva #$xx		; 0
       mva_im(i+1) and										// mva #$xx		; 1
       mva_im(i+2) then										// mva #$yy		; 2
     if (copy(listing[i], 6, 4) = copy(listing[i+1], 6, 4)) and
        (copy(listing[i+1], 6, 4) <> copy(listing[i+2], 6, 4)) then
     begin

       listing[i+1] := #9'sta' + copy(listing[i+1], 10, 256);

       Result:=false;
     end;

  end;

 end;


 function OptimizeAssignment: Boolean;
 // sprawdzamy odwolania do STACK, czy nastapil zapis STA
 // jesli pierwsze odwolanie do STACK to LDA (MVA) zastepujemy przez #$00

 var i, j, k: integer;
     a: string;
     v, emptyStart, emptyEnd: integer;


   function PeepholeOptimization_END: Boolean;
   var i, p: integer;
       old: string;
   begin

   Result:=true;

   Rebuild;

   for i := 0 to l - 1 do
    if listing[i] <> '' then begin

    p:=i;

    old := listing[p];

    while (pos('lda #', old) > 0) and sta(p+1) and lda_im(p+2) and (p<l-2) do begin	// lda #

     if (copy(old, 6, 256) = copy(listing[p+2], 6, 256)) then
      listing[p+2] := ''								// sta
     else
      old:=listing[p+2];

     inc(p, 2);										// lda #
    end;

   end;


   end;



   function PeepholeOptimization_STA: Boolean;
   var i, p: integer;
       tmp, old: string;
       yes: Boolean;
   begin

   tmp:='';
   old:='';

   Result:=true;

   Rebuild;

   for i := 0 to l - 1 do
    if listing[i] <> '' then begin

     if ADD_SUB_STACK(i) or ADC_SBC_STACK(i) then					// add|sub|adc|sbc STACK
      begin

	tmp:=copy(listing[i], 6, 256);

	for p:=i-1 downto 1 do
	 if (pos(tmp, listing[p]) > 0) then begin

	  if (p>0) and lda(p-1) and sta(p) then begin

	   listing[i] := copy(listing[i], 1, 5) +  copy(listing[p-1], 6, 256);

	   listing[p-1] := '';
	   listing[p] := '';

	   Result:=false;
	   Break;
	  end else
	   Break;

	 end else
	  if ldy(p) or iny(p) or dey(p) or tay(p) or tya(p) or
	  (pos(#9'.if', listing[p]) > 0) or (pos(#9'jsr', listing[p]) > 0) or (listing[p] = #9'eif') then Break;

      end;


     if lda_stack(i) and								// lda :STACK
        ( adc(i+1) or add(i+1) ) then							// add|adc
      begin

	tmp:=copy(listing[i], 6, 256);

	for p:=i-1 downto 1 do
	 if pos(tmp, listing[p]) > 0 then begin

	  if (p>0) and lda(p-1) and sta(p) and (sta(p+1) = false) then begin

	   listing[i]   := #9'lda ' + copy(listing[p-1], 6, 256);

	   listing[p-1] := '';
	   listing[p]   := '';

	   Result:=false;
	   Break;
	  end else
	   Break;

	 end else
	  if (listing[p] = '@') or (pos(copy(listing[i+1], 6, 256), listing[p]) > 0) or
	     ldy(p) or iny(p) or dey(p) or tay(p) or tya(p) or
	     (pos(#9'.if', listing[p]) > 0) or (pos(#9'jsr', listing[p]) > 0) or (listing[p] = #9'eif') then Break;

      end;


     if Result and									// lda :STACKORIGIN		; 0
	lda_stack(i) and								// sta				; 1
	sta(i+1) and (iy(i+1) = false) and						// ~sta				; 2
	(sta(i+2) = false) and
	( copy(listing[i], 6, 256) <> copy(listing[i+1], 6, 256) ) then
       begin

	tmp:=#9'sta ' + copy(listing[i], 6, 256);

	for p:=i-1 downto 0 do
	 if listing[p] = tmp then begin
	  listing[p]   := listing[i+1];
	  listing[i]   := '';
	  listing[i+1] := '';

	  Result:=false;
	  Break;
	 end else
	  if (listing[p] = '@') or
	     (pos(copy(listing[i], 6, 256), listing[p]) > 0) or
	     (copy(listing[i+1], 6, 256) = copy(listing[p], 6, 256)) or
	     (pos(#9'jsr', listing[p]) > 0) or (listing[p] = #9'eif') then Break;
     end;


     if lda(i) and 									// lda				; 0
	add_stack(i+1) and 								// add :STACKORIGIN+9		; 1
	tay(i+2) and									// tay				; 2
	lda(i+3) and									// lda				; 3
	adc_stack(i+4) and 								// adc :STACKORIGIN+STACKWIDTH	; 4
	sta_bp_1(i+5) then 								// sta :bp+1			; 5
      begin

	tmp:=#9'sta ' + copy(listing[i+1], 6, 256);

	for p:=i-1 downto 1 do
	 if (pos(tmp, listing[p]) > 0) then begin

	  if (p>1) and
	     lda(p-2) and					// lda :STACKORIGIN+9			; p-2
	     add_sub(p-1) and					// add #$80				; p-1
	     sta_stack(p) and					// sta :STACKORIGIN+9			; p
	     lda(p+1) and					// lda :STACKORIGIN+STACKWIDTH+9	; p+1
	     adc_sbc(p+2) and					// adc #$03				; p-1
	     sta_stack(p+3) and					// sta :STACKORIGIN+STACKWIDTH+9	; p+3
	     lda(p+4) and					// lda :STACKORIGIN+STACKWIDTH*2+9	; p+4
	     adc_sbc(p+5) and					// adc #$03				; p-1
	     sta_stack(p+6) and					// sta :STACKORIGIN+STACKWIDTH*2+9	; p+6
	     lda(p+7) and					// lda :STACKORIGIN+STACKWIDTH*3+9	; p+7
	     adc_sbc(p+8) and					// adc #$03				; p-1
	     sta_stack(p+9) then begin				// sta :STACKORIGIN+STACKWIDTH*3+9	; p+9

	   listing[p+4] := '';
	   listing[p+5] := '';
	   listing[p+6] := '';
	   listing[p+7] := '';
	   listing[p+8] := '';
	   listing[p+9] := '';

	   Result:=false;
	   Break;
	  end else
	   Break;

	 end else
	  if (listing[p] = '@') or (pos(#9'.if', listing[p]) > 0) or
	     (pos(#9'jsr', listing[p]) > 0) or (listing[p] = #9'eif') then Break;

      end;


    if lda(i) and									// lda				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+9		; 1
       lda(i+2) and									// lda 				; 2
       asl_stack(i+3) and								// asl :STACKORIGIN+9		; 3
       rol_a(i+4) then									// rol @			; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then			// ...
       begin										// sta :STACKORIGIN+STACKWIDTH+9

	yes:=false;
	for p:=i+4 to l-1 do
	 if sta_stack(p) and rol_a(p-1) then begin
	  tmp:=copy(listing[p], 6, 256);

	  if lda(p+1) and (pos('add ', listing[p+2]) > 0) and				// lda
	     (copy(listing[p+2], 6, 256) = copy(listing[i+1], 6, 256)) then		// add :STACKORIGIN+9
	       yes:=true;

	  Break;
	 end;

	if yes then begin

	 old:=listing[i+2];
	 listing[i+2]:=listing[i];
	 listing[i]:=old;
	 listing[i+1] := #9'sta ' + tmp;

	 p:=i+3;

	 old:=copy(listing[p], 6, 256);

	 while true do begin
	  if asl_stack(p) then listing[p] := #9'asl @';
	  if rol_a(p) then listing[p] := #9'rol ' + tmp;
	  if sta_stack(p) then begin listing[p] := #9'sta ' + old; Break end;

	  inc(p);
	 end;

	 Result:=false;
	end;

       end;


    if lda_stack(i) and									// lda :STACKORIGIN+9		; 0
       STA_BP2_Y(i+1) then								// sta (:bp2),y			; 1
       begin

 	tmp:=#9'sta ' + copy(listing[i], 6, 256);

	for p:=i-1 downto 1 do
	 if (p>0) and (listing[p] = tmp) and lda(p-1) and (iy(p-1) = false) then begin
	  listing[i] := listing[p-1];

//	  listing[p-1] := '';		//!!! zachowac 'lda'
//	  listing[p]   := '';

	  Result:=false;
	  Break;
	 end else
	  if (pos(copy(listing[i], 6, 256), listing[p]) > 0) or (listing[p] = '@') or
	     (pos(#9'jsr', listing[p]) > 0) or (listing[p] = #9'eif') then Break;

       end;


    if lda_stack(i) and									// lda :STACKORIGIN+9		; 0
       sta_bp2(i+1) and									// sta :bp2			; 1
       lda_stack(i+2) and								// lda :STACKORIGIN+STAWCKWIDTH	; 2
       sta_bp2_1(i+3) then								// sta :bp2+1			; 3
       begin

 	tmp := #9'sta ' + copy(listing[i], 6, 256);

	for p:=i-1 downto 0 do
	 if listing[p] = tmp then begin

	  if sta_stack(p) and							// sta :STACKORIGIN+9			; 0
	     lda(p+1) and							// lda :STACKORIGIN+STACKWIDTH+9	; 1
	     adc_sbc(p+2) and							// adc|sbc :STACKORIGIN+STACKWIDTH+11	; 2
	     sta_stack(p+3) and							// sta :STACKORIGIN+STACKWIDTH+9	; 3
	     lda(p+4) and							// lda :STACKORIGIN+STACKWIDTH*2+9	; 4
	     adc_sbc(p+5) and							// adc|sbc #$00				; 5
	     sta_stack(p+6) and							// sta :STACKORIGIN+STACKWIDTH*2+9	; 6
	     lda(p+7) and							// lda :STACKORIGIN+STACKWIDTH*3+9	; 7
	     adc_sbc(p+8) and							// adc|sbc #$00				; 8
	     sta_stack(p+9) then 						// sta :STACKORIGIN+STACKWIDTH*3+9	; 9
	  if copy(listing[i+2], 6, 256) = copy(listing[p+3], 6, 256) then
	  begin

	   listing[p+4] := '';
	   listing[p+5] := '';
	   listing[p+6] := '';
	   listing[p+7] := '';
	   listing[p+8] := '';
	   listing[p+9] := '';

	   Result:=false;
	   Break;
	  end;

	 end else
	  if listing[p] = #9'eif' then Break;

       end;


    if lda_stack(i) and									// lda :STACKORIGIN+9		; 0
       STA_BP2_Y(i+2) and								// add|sub|and|ora|eor		; 1
       (add_sub(i+1) or adc_sbc(i+1) or and_ora_eor(i+1)) then				// sta (:bp2),y			; 2
       begin

 	tmp := copy(listing[i], 6, 256);

	yes:=false;
	for p:=i-1 downto 1 do
	 if (p>0) and (pos(tmp, listing[p]) > 0) then begin

	  if (pos('sta '+tmp, listing[p]) > 0) and lda(p-1) and (iy(p-1) = false) then begin
	   listing[i]   := listing[p-1];
	   listing[p-1] := '';
	   listing[p]   := '';

	   Result:=false;
	  end else
	   Break;

	 end;
//	  else
//	  if (listing[p] = '@') or (pos(#9'jsr', listing[p]) > 0) then Break;

       end;


    if sta_stack(i) and									// sta :STACKORIGIN+9		; 0
       ldy(i+1) and									// ldy				; 1
       mva_stack(i+2) then								// mva :STACKORIGIN+9 ...	; 2
     if pos(copy(listing[i], 6, 256), listing[i+2]) > 0 then
       begin
	tmp:=copy(listing[i], 6, 256);

	listing[i+2] := #9'sta' + copy(listing[i+2], 6 + length(tmp), 256);

	listing[i] := '';

	Result:=false;
       end;


    if add_sub(i) and									// add|sub				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+9			; 1
       lda(i+2) and									// lda					; 2
       adc_sbc(i+3) and									// adc|sbc				; 3
       sta_stack(i+4) and								// sta :STACKORIGIN+STACKWIDTH+9	; 4
       lda(i+5) and									// lda					; 5
       adc_sbc(i+6) and									// adc|sbc				; 6
       sta_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH*2+9	; 7
       lda(i+8) and									// lda					; 8
       adc_sbc(i+9) and									// adc|sbc				; 9
       sta_stack(i+10) and								// sta :STACKORIGIN+STACKWIDTH*3+9	; 10
       lda_stack(i+11) and								// lda :STACKORIGIN+9			; 11
       and_ora_eor(i+12) and								// and|ora|eor				; 12
       sta(i+13) and (lda(i+14) = false) then						// sta					; 13
     if (copy(listing[i+1], 6, 256) = copy(listing[i+11], 6, 256)) then			// ~lda					; 14
       begin
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';

	Result:=false;
       end;


    if add_sub(i) and									// add|sub				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+9			; 1
       lda(i+2) and									// lda					; 2
       adc_sbc(i+3) and									// adc|sbc				; 3
       sta_stack(i+4) and								// sta :STACKORIGIN+STACKWIDTH+9	; 4
       lda(i+5) and									// lda					; 5
       adc_sbc(i+6) and									// adc|sbc				; 6
       sta_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH*2+9	; 7
       lda(i+8) and									// lda					; 8
       adc_sbc(i+9) and									// adc|sbc				; 9
       sta_stack(i+10) and								// sta :STACKORIGIN+STACKWIDTH*3+9	; 10
       lda_stack(i+11) and								// lda :STACKORIGIN+9			; 11
       and_ora_eor(i+12) and								// and|ora|eor				; 12
       ldy(i+13) and									// ldy					; 13
       sta(i+14) and (lda(i+15) = false) then						// sta ,y				; 14
     if (copy(listing[i+1], 6, 256) = copy(listing[i+11], 6, 256)) then			// ~lda 				; 15
       begin
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';

	Result:=false;
       end;


    if add_sub(i) and									// add|sub				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+9			; 1
       lda(i+2) and									// lda					; 2
       adc_sbc(i+3) and									// adc|sbc				; 3
       sta_stack(i+4) and								// sta :STACKORIGIN+STACKWIDTH+9	; 4
       lda(i+5) and									// lda					; 5
       adc_sbc(i+6) and									// adc|sbc				; 6
       sta_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH*2+9	; 7
       lda(i+8) and									// lda					; 8
       adc_sbc(i+9) and									// adc|sbc				; 9
       sta_stack(i+10) and								// sta :STACKORIGIN+STACKWIDTH*3+9	; 10
       lda_stack(i+11) and								// lda :STACKORIGIN+9			; 11
       add_sub(i+12) and								// add|sub				; 12
       sta(i+13) and									// sta					; 13
       lda_stack(i+14) and								// lda :STACKORIGIN+STACKWIDTH+9	; 14
       adc_sbc(i+15) and								// adc|sbc				; 15
       sta(i+16) and									// sta					; 16
       (lda_stack(i+17) = false) then							// ~lda :STACK				; 17
     if (copy(listing[i+1], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+4], 6, 256) = copy(listing[i+14], 6, 256)) then
       begin
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';

	Result:=false;
       end;


    if sta_stack(i) and									// sta :STACKORIGIN+9			; 0
       sty_stack(i+1) and								// sty :STACKORIGIN+STACKWIDTH+9	; 1
       sty_stack(i+2) and								// sty :STACKORIGIN+STACKWIDTH*2+9	; 2
       sty_stack(i+3) and								// sty :STACKORIGIN+STACKWIDTH*3+9	; 3
       lda(i+4) and									// lda					; 4
       add_sub(i+5) and									// add|sub :STACKORIGIN+9		; 5
       sta(i+6) and									// sta					; 6
       lda(i+7) and									// lda					; 7
       adc_sbc(i+8) and									// adc|sbc :STACKORIGIN+STACKWIDTH+9	; 8
       sta(i+9) and									// sta					; 9
       (lda(i+10) = false) then								// ~lda					; 10
     if (copy(listing[i], 6, 256) = copy(listing[i+5], 6, 256)) and
	(copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256)) then
       begin
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if sta_stack(i) and									// sta :STACKORIGIN+STACKWIDTH+9	; 0
       sty_stack(i+1) and								// sty :STACKORIGIN+STACKWIDTH*2+9	; 1
       sty_stack(i+2) and								// sty :STACKORIGIN+STACKWIDTH*3+9	; 2
       lda(i+3) and									// lda					; 3
       add_sub(i+4) and									// add|sub :STACKORIGIN+9		; 4
       sta(i+5) and									// sta					; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc :STACKORIGIN+STACKWIDTH+9	; 7
       sta(i+8) and									// sta					; 8
       (lda(i+9) = false) then								// ~lda					; 9
     if (copy(listing[i], 6, 256) = copy(listing[i+7], 6, 256)) then
       begin
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
       end;


    if sta_stack(i) and									// sta :STACKORIGIN+9	; 0
       lda_stack(i+3) and								// mwa SCRN bp2		; 1
       mwa_bp2(i+1) and									// ldy #$00		; 2
       ldy(i+2) then									// lda :STACKORIGIN+9	; 3
     if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then begin
	listing[i]   := '';
	listing[i+3] := '';

	listing[i+1] := #9'mwy '+copy(listing[i+1], 6, 256);

	Result:=false;
     end;


    if lda_stack(i) and									// lda :STACKORIGIN+9		; 0
       add_sub(i+1) and									// add|sub			; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9		; 2
       lda_stack(i+3) and								// lda :STACKORIGIN+STACKWIDTH+9; 3
       adc_sbc(i+4) and									// adc|sbc			; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9; 5
       lda_stack(i+6) and								// lda :STACKORIGIN+9		; 6
       add_sub(i+7) and									// add|sub			; 7
       sta(i+8) and									// sta				; 8
       (lda(i+9) = false) then								// ~lda				; 9
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and
	(copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) then
       begin
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda(i+9) and									// lda					; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
       lda_stack(i+12) and								// lda :STACKORIGIN+9			; 12
       add_sub(i+13) and								// add|sub				; 13
       sta_stack(i+14) then								// sta					; 14
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and			// ~lda :STACKORIGIN+STACKWIDTH+9	; 15
	(copy(listing[i+5], 6, 256) <> copy(listing[i+15], 6, 256)) then
       begin
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda_stack(i+6) and								// lda :STACKORIGIN+STACKWIDTH+9	; 6
       sta_bp_1(i+7) and								// sta :bp+1				; 7
       ldy_stack(i+8) and								// ldy :STACKORIGIN+9			; 8
       lda_stack(i+9) and								// lda :STACKORIGIN+10			; 9
       sta_bp_y(i+10) then								// sta (:bp),y				; 10
     if (copy(listing[i+2], 6, 256) = copy(listing[i+9], 6, 256)) and
	(copy(listing[i+2], 6, 256) <> copy(listing[i+8], 6, 256)) then
       begin
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+10	; 5
       ldy_stack(i+6) and								// ldy :STACKORIGIN+9			; 6
       lda_stack(i+7) and								// lda :STACKORIGIN+10			; 7
       sta_bp_y(i+8) then								// sta (:bp),y				; 8
     if (copy(listing[i+2], 6, 256) = copy(listing[i+7], 6, 256)) and
	(copy(listing[i+2], 6, 256) <> copy(listing[i+6], 6, 256)) then
       begin
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda(i+9) and									// lda					; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
       lda(i+12) and									// lda					; 12
       add_sub(i+13) and								// add|sub				; 13
       add_sub(i+14) and								// add|sub				; 14
       sta_stack(i+15) and								// sta :STACKORIGIN+10			; 15
       lda_stack(i+16) and								// lda :STACKORIGIN+STACKWIDTH+9	; 16
       sta_bp_1(i+17) and								// sta :bp+1				; 17
       ldy_stack(i+18) and								// ldy :STACKORIGIN+9			; 18
       lda_stack(i+19) and								// lda :STACKORIGIN+10			; 19
       sta_bp_y(i+20) then								// sta (:bp),y				; 20
     if (copy(listing[i+2], 6, 256) = copy(listing[i+18], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+16], 6, 256)) and
	(copy(listing[i+15], 6, 256) = copy(listing[i+19], 6, 256)) then
       begin
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda(i+9) and									// lda					; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
       lda(i+12) and									// lda					; 12
       add_sub(i+13) and								// add|sub				; 13
       sta_stack(i+14) and								// sta :STACKORIGIN+10			; 14
       lda_stack(i+15) and								// lda :STACKORIGIN+STACKWIDTH+9	; 15
       sta_bp_1(i+16) and								// sta :bp+1				; 16
       ldy_stack(i+17) and								// ldy :STACKORIGIN+9			; 17
       lda_stack(i+18) and								// lda :STACKORIGIN+10			; 18
       sta_bp_y(i+19) then								// sta (:bp),y				; 19
     if (copy(listing[i+2], 6, 256) = copy(listing[i+17], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+14], 6, 256) = copy(listing[i+18], 6, 256)) then
       begin
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda(i+9) and									// lda					; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
       lda_stack(i+12) and								// lda :STACKORIGIN+9			; 12
       add_sub(i+13) and								// add|sub				; 13
       tay(i+14) and									// tay					; 14
       lda_stack(i+15) and								// lda :STACKORIGIN+STACKWIDTH+9	; 15
       adc_sbc(i+16) and								// adc|sbc				; 16
       sta_bp_1(i+17) and								// sta :bp+1				; 17
       lda(i+18) and									// lda 					; 18
       sta_bp_y(i+19) then								// sta (:bp),y				; 19
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) then
       begin
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda_im_0(i) and									// lda #$00				; 0
       (listing[i+1] = #9'sta :eax+1') and						// sta :eax+1				; 1
       lda(i+2) and									// lda					; 2
       asl_a(i+3) and									// asl @				; 3
       (listing[i+4] = #9'rol :eax+1') and						// rol :eax+1				; 4
       asl_a(i+5) and									// asl @				; 5
       (listing[i+6] = #9'rol :eax+1') and						// rol :eax+1				; 6
       add(i+7) and									// add					; 7
       (listing[i+8] = #9'sta :eax') and						// sta :eax				; 8
       (listing[i+9] = #9'lda :eax+1') and						// lda :eax+1				; 9
       adc_im_0(i+10) and								// adc #$00				; 10
       (listing[i+11] = #9'sta :eax+1') and						// sta :eax+1				; 11
       (listing[i+12] = #9'asl :eax') and						// asl :eax				; 12
       (listing[i+13] = #9'rol :eax+1') and						// rol :eax+1				; 13
       (listing[i+14] = #9'lda :eax') and						// lda :eax				; 14
       add_sub(i+15) and								// add|sub 				; 15
       (tay(i+16) or									// tay|sta :STACK			; 16
       (sta_stack(i+16) and (pos(' :eax+1', listing[i+17]) = 0) )) then
       begin
	listing[i]   := '';
	listing[i+1] := '';

	listing[i+4] := '';
	listing[i+6] := '';

	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';

	listing[i+14] := #9'asl @';

	Result:=false;
       end;


    if lda_im_0(i) and									// lda #$00				; 0
       (listing[i+1] = #9'sta :eax+1') and						// sta :eax+1				; 1
       lda(i+2) and									// lda					; 2
       asl_a(i+3) and									// asl @				; 3
       (listing[i+4] = #9'rol :eax+1') and						// rol :eax+1				; 4
       asl_a(i+5) and									// asl @				; 5
       (listing[i+6] = #9'rol :eax+1') and						// rol :eax+1				; 6
       add(i+7) and									// add					; 7
       (listing[i+8] = #9'sta :eax') and						// sta :eax				; 8
       (listing[i+9] = #9'lda :eax+1') and						// lda :eax+1				; 9
       adc_im_0(i+10) and								// adc #$00				; 10
       (listing[i+11] = #9'sta :eax+1') and						// sta :eax+1				; 11
       (listing[i+12] = #9'asl :eax') and						// asl :eax				; 12
       (listing[i+13] = #9'rol :eax+1') and						// rol :eax+1				; 13
       lda(i+14) and 									// lda 					; 14
       add_sub(i+15) and								// add|sub 				; 15
       ((listing[i+16] = #9'add :eax') or (listing[i+16] = #9'sub :eax')) and		// add|sub :eax				; 16
       tay(i+17) then									// tay					; 17
       begin
	listing[i]   := '';
	listing[i+1] := '';

	listing[i+4] := '';
	listing[i+6] := '';

	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := #9'asl @';
	listing[i+13] := #9'sta :eax';

	Result:=false;
       end;


    if lda_im_0(i) and									// lda #$00				; 0
       (listing[i+1] = #9'sta :eax+1') and						// sta :eax+1				; 1
       lda(i+2) and									// lda					; 2
       asl_a(i+3) and									// asl @				; 3
       (listing[i+4] = #9'rol :eax+1') and						// rol :eax+1				; 4
       asl_a(i+5) and									// asl @				; 5
       (listing[i+6] = #9'rol :eax+1') and						// rol :eax+1				; 6
       add(i+7) and									// add					; 7
       (listing[i+8] = #9'sta :eax') and						// sta :eax				; 8
       (listing[i+9] = #9'lda :eax+1') and						// lda :eax+1				; 9
       adc_im_0(i+10) and								// adc #$00				; 10
       (listing[i+11] = #9'sta :eax+1') and						// sta :eax+1				; 11
       (listing[i+12] = #9'asl :eax') and						// asl :eax				; 12
       (listing[i+13] = #9'rol :eax+1') and						// rol :eax+1				; 13
       (listing[i+14] = #9'lda :eax') and						// lda :eax				; 14
       sta(i+15) and									// sta 					; 15
       (pos(' :eax+1', listing[i+16]) = 0) and						// ~ :eax+1				; 16
       (pos(' :eax+1', listing[i+17]) = 0) then						// ~ :eax+1				; 17
       begin
	listing[i]   := '';
	listing[i+1] := '';

	listing[i+4] := '';
	listing[i+6] := '';

	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	listing[i+12] := #9'asl @';
	listing[i+13] := #9'sta :eax';

	Result:=false;
       end;


    if lda_im_0(i) and									// lda #$00				; 0
       (listing[i+1] = #9'sta :eax+1') and						// sta :eax+1				; 1
       lda(i+2) and									// lda					; 2
       asl_a(i+3) and									// asl @				; 3
       (listing[i+4] = #9'rol :eax+1') and						// rol :eax+1				; 4
       asl_a(i+5) and									// asl @				; 5
       (listing[i+6] = #9'rol :eax+1') and						// rol :eax+1				; 6
       add(i+7) and									// add					; 7
       (listing[i+8] = #9'sta :eax') and						// sta :eax				; 8
       (listing[i+9] = #9'lda :eax+1') and						// lda :eax+1				; 9
       adc_im_0(i+10) and								// adc #$00				; 10
       (listing[i+11] = #9'sta :eax+1') and						// sta :eax+1				; 11
       (listing[i+12] = #9'asl :eax') and						// asl :eax				; 12
       (listing[i+13] = #9'rol :eax+1') and						// rol :eax+1				; 13
       (listing[i+14] = #9'lda :eax') and						// lda :eax				; 14
       add_sub(i+15) and								// add|sub 				; 15
       sta(i+16) and									// sta					; 16
       (pos(' :eax+1', listing[i+17]) = 0) and						// ~ :eax+1				; 17
       (pos(' :eax+1', listing[i+18]) = 0) then						// ~ :eax+1				; 18
       begin
	listing[i]   := '';
	listing[i+1] := '';

	listing[i+4] := '';
	listing[i+6] := '';

	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	listing[i+12] := #9'asl @';
	listing[i+13] := #9'sta :eax';

	Result:=false;
       end;


    if lda_im_0(i) and									// lda #$00				; 0
       (listing[i+1] = #9'sta :eax+1') and						// sta :eax+1				; 1
       lda(i+2) and									// lda					; 2
       asl_a(i+3) and									// asl @				; 3
       (listing[i+4] = #9'rol :eax+1') and						// rol :eax+1				; 4
       add(i+5) and									// add					; 5
       (listing[i+6] = #9'sta :eax') and						// sta :eax				; 6
       (listing[i+7] = #9'lda :eax+1') and						// lda :eax+1				; 7
       adc_im_0(i+8) and								// adc #$00				; 8
       (listing[i+9] = #9'sta :eax+1') and						// sta :eax+1				; 9
       (listing[i+10] = #9'lda :eax') and						// lda :eax				; 10
       sta(i+11) and									// sta					; 11
       (pos(' :eax+1', listing[i+12]) = 0) and						// ~ :eax+1				; 12
       (pos(' :eax+1', listing[i+13]) = 0) then						// ~ :eax+1				; 13
       begin
	listing[i]   := '';
	listing[i+1] := '';

	listing[i+4] := '';

	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';

	Result:=false;
       end;


    if lda_im_0(i) and									// lda #$00				; 0
       (listing[i+1] = #9'sta :eax+1') and						// sta :eax+1				; 1
       lda(i+2) and									// lda					; 2
       asl_a(i+3) and									// asl @				; 3
       (listing[i+4] = #9'rol :eax+1') and						// rol :eax+1				; 4
       add(i+5) and									// add					; 5
       (listing[i+6] = #9'sta :eax') and						// sta :eax				; 6
       (listing[i+7] = #9'lda :eax+1') and						// lda :eax+1				; 7
       adc_im_0(i+8) and								// adc #$00				; 8
       (listing[i+9] = #9'sta :eax+1') and						// sta :eax+1				; 9
       (listing[i+10] = #9'lda :eax') and						// lda :eax				; 10
       add_sub(i+11) and								// add|sub				; 11
       sta(i+12) and									// sta					; 12
       (pos(' :eax+1', listing[i+13]) = 0) and						// ~ :eax+1				; 13
       (pos(' :eax+1', listing[i+14]) = 0) then						// ~ :eax+1				; 14
       begin
	listing[i]   := '';
	listing[i+1] := '';

	listing[i+4] := '';

	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';

	Result:=false;
       end;


// add !!!
    if lda_stack(i) and									// lda :STACKORIGIN+10			; 0
       add(i+1) and									// add					; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda_stack(i+3) and								// lda :STACKORIGIN+STACKWIDTH+10	; 3
       adc_im_0(i+4) and								// adc #$00				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda_stack(i+6) and								// lda :STACKORIGIN+STACKWIDTH*2+10	; 6
       adc_im_0(i+7) and								// adc #$00				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda_stack(i+9) and								// lda :STACKORIGIN+STACKWIDTH*3+10	; 9
       adc_im_0(i+10) and								// adc #$00				; 10
       sta_stack(i+11) and								// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       lda_stack(i+12) and								// lda :STACKORIGIN+10			; 12
       sta(i+13) and									// sta ADDR				; 13
       lda(i+14) and (pos(' :STACK', listing[i+14]) = 0) and				// lda #$A0				; 14
       add_stack(i+15) and								// add :STACKORIGIN+STACKWIDTH+10	; 15
       sta(i+16) and									// sta ADDR+1				; 16
       (lda(i+17) = false) then								// ~lda					; 17
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+6], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+9], 6, 256) = copy(listing[i+11], 6, 256)) and
	(listing[i] = listing[i+12]) then
       begin
        listing[i+2] := listing[i+13];
	listing[i+4] := #9'adc ' + copy(listing[i+14], 6, 256);
	listing[i+5] := listing[i+16];

	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';
	listing[i+15] := '';
	listing[i+16] := '';

	Result:=false;
       end;


    if asl_stack(i) and									// asl :STACKORIGIN+10			; 0
       rol_stack(i+1) and								// rol :STACKORIGIN+STACKWIDTH+10	; 1
       lda(i+2) and									// lda					; 2
       add_sub_stack(i+3) and								// add|sub :STACKORIGIN+10		; 3
       sta(i+4) and									// sta					; 4
       (lda(i+5) = false) then								// ~lda					; 5
      if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then
       begin
	listing[i+1] := '';

	Result:=false;
       end;


    if lda(i) and									// lda 					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+10	; 5
       asl_stack(i+6) and								// asl :STACKORIGIN+10			; 6
       lda(i+7) and									// lda					; 7
       add_sub_stack(i+8) and								// add|sub :STACKORIGIN+10		; 8
       sta(i+9) and									// sta					; 9
       (lda(i+10) = false) then								// ~lda					; 10
      if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and
	 (copy(listing[i+6], 6, 256) = copy(listing[i+8], 6, 256)) then
       begin
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda_im_0(i) and									// lda #$00			; 0
       cmp_stack(i+1) and								// cmp :STACKORIGIN+9		; 1
       (listing[i+2] = #9'bne @+') then							// bne @+			; 2
     begin
       listing[i] := '';
       listing[i+1] := #9'lda ' + copy(listing[i+1], 6, 256) ;

       Result:=false;
      end;


    if (listing[i] = #9'lda :eax+1') and						// lda :eax+1			; 0
       adc_sbc(i+1) and									// adc|sbc			; 1
       (listing[i+2] = #9'sta :eax+1') and						// sta :eax+1			; 2
       lda(i+3) and									// lda 				; 3
       add_sub(i+4) and	(pos(' :eax', listing[i+4]) > 0) and 				// add|sub :eax			; 4
       sta(i+5) and									// sta				; 5
       (lda(i+6) = false) then								// ~lda				; 6
       begin
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
       end;


    if asl_stack(i) and									// asl :STACKORIGIN+9 			; 0
       rol_stack(i+1) and								// rol :STACKORIGIN+STACKWIDTH+9	; 1
       rol_stack(i+2) and								// rol :STACKORIGIN+STACKWIDTH*2+9	; 2
       rol_stack(i+3) and								// rol :STACKORIGIN+STACKWIDTH*3+9	; 3
       lda_stack(i+4) and								// lda :STACKORIGIN+9 			; 4
       add_sub(i+5) and									// add|sub 				; 5
       sta(i+6) and									// sta					; 6
       lda_stack(i+7) and								// lda :STACKORIGIN+STACKWIDTH+9	; 7
       adc_sbc(i+8) and									// adc|sbc				; 8
       sta(i+9) and									// sta					; 9
       (lda_stack(i+10) = false) then							// ~lda :STACKORIGIN+STACKWIDTH*2+9 	; 10
      if (copy(listing[i], 6, 256) = copy(listing[i+4], 6, 256)) and
	 (copy(listing[i+1], 6, 256) = copy(listing[i+7], 6, 256)) then
       begin
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and									// lda DX 			; 0
       add(i+1) and									// add DX			; 1
       sta(i+2) and									// sta DX			; 2
       lda(i+3) and									// lda DX+1			; 3
       adc(i+4) and									// adc DX+1			; 4
       sta(i+5) and									// sta DX+1			; 5
       lda(i+6) and									// lda DX+2			; 6
       adc(i+7) and									// adc DX+2			; 7
       sta(i+8) and									// sta DX+2			; 8
       lda(i+9) and									// lda DX+3			; 9
       adc(i+10) and									// adc DX+3			; 10
       sta(i+11) then									// sta DX+3			; 11
      if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) and
	 (copy(listing[i+1], 6, 256) = copy(listing[i+2], 6, 256)) and
	 (copy(listing[i+3], 6, 256) = copy(listing[i+4], 6, 256)) and
	 (copy(listing[i+4], 6, 256) = copy(listing[i+5], 6, 256)) and
	 (copy(listing[i+6], 6, 256) = copy(listing[i+7], 6, 256)) and
	 (copy(listing[i+7], 6, 256) = copy(listing[i+8], 6, 256)) and
	 (copy(listing[i+9], 6, 256) = copy(listing[i+10], 6, 256)) and
	 (copy(listing[i+10], 6, 256) = copy(listing[i+11], 6, 256)) then
       begin
	listing[i]   := #9'asl ' + copy(listing[i], 6, 256);
	listing[i+1] := #9'rol ' + copy(listing[i+3], 6, 256);
	listing[i+2] := #9'rol ' + copy(listing[i+6], 6, 256);
	listing[i+3] := #9'rol ' + copy(listing[i+9], 6, 256);

	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and									// lda DX 			; 0
       add(i+1) and									// add DX			; 1
       sta(i+2) and									// sta DX			; 2
       lda(i+3) and									// lda DX+1			; 3
       adc(i+4) and									// adc DX+1			; 4
       sta(i+5) then									// sta DX+1			; 5
      if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) and
	 (copy(listing[i+1], 6, 256) = copy(listing[i+2], 6, 256)) and
	 (copy(listing[i+3], 6, 256) = copy(listing[i+4], 6, 256)) and
	 (copy(listing[i+4], 6, 256) = copy(listing[i+5], 6, 256)) then
       begin
	listing[i]   := #9'asl ' + copy(listing[i], 6, 256);
	listing[i+1] := #9'rol ' + copy(listing[i+3], 6, 256);

	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and									// lda DX 			; 0
       add(i+1) and									// add DX			; 1
       sta(i+2) then									// sta DX			; 2
      if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) and
	 (copy(listing[i+1], 6, 256) = copy(listing[i+2], 6, 256)) then
       begin
	listing[i]   := #9'asl ' + copy(listing[i], 6, 256);

	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
       end;


    if lda(i) and									// lda TT+1 			; 0
       sta(i+1) and									// lda :STACKORIGIN+STACKWIDTH+9; 1
       lda(i+2) and									// lda TT			; 2
       asl_a(i+3) and									// asl @			; 3
       (pos('rol ', listing[i+4]) > 0) and						// rol :STACKORIGIN+STACKWIDTH+9; 4
       sta(i+5) and									// sta TT			; 5
       lda(i+6) and									// lda :STACKORIGIN+STACKWIDTH+9; 6
       sta(i+7) then									// lda TT+1			; 7
      if (copy(listing[i], 6, 256) = copy(listing[i+7], 6, 256)) and
	 (copy(listing[i+2], 6, 256) = copy(listing[i+5], 6, 256)) and
	 (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and
	 (copy(listing[i+4], 6, 256) = copy(listing[i+6], 6, 256)) then
       begin
	listing[i+6] := #9'asl ' + copy(listing[i+2], 6, 256);
	listing[i+7] := #9'rol ' + copy(listing[i], 6, 256);

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and									// lda TT 			; 0
       asl_a(i+1) and									// asl @			; 1
       sta(i+2) then									// sta TT			; 2
      if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then
       begin
	listing[i] := #9'asl ' + copy(listing[i], 6, 256);

	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
       end;


    if sta_stack(i) and									// sta :STACKORIGIN+STACKWIDTH		; 0
       lsr_stack(i+1) and								// lsr :STACKORIGIN+STACKWIDTH		; 1
       (listing[i+2] <> #9'ror @') and							// ~ror @				; 2
       (listing[i+3] <> #9'ror @') and							// ~ror @				; 3
       (listing[i+4] <> #9'ror @') then							// ~ror @				; 4
     if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) then
     begin
        listing[i+1] := listing[i];
	listing[i]   := #9'lsr @';

	Result:=false;
     end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda_stack(i+6) and								// lda :STACKORIGIN+9			; 6
       add(i+7) and									// add					; 7
       sta(i+8) and									// sta 					; 8
       lda_stack(i+9) and								// lda :STACKORIGIN+STACKWIDTH+9	; 9
       adc_im_0(i+10) and								// adc #$00				; 10
       sta(i+11) and (sta_stack(i+11) = false) and					// sta					; 11
       (lda_stack(i+12) = false) and							// ~lda					; 12
       (adc(i+13) = false) then								// ~adc					; 13
     if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+9], 6, 256)) then
       begin
	listing[i+5] := listing[i+11];

	listing[i+9]  := #9'scc';
	listing[i+10] := #9'inc ' + copy(listing[i+11], 6, 256);

	listing[i+11] := '';

	Result:=false;
       end;


    if add_sub(i) and									// add|sub				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+STACKWIDTH+9	; 1
       lda(i+2) and									// lda					; 2
       add(i+3) and									// add					; 3
       sta(i+4) and									// sta 					; 4
       lda_stack(i+5) and								// lda :STACKORIGIN+STACKWIDTH+9	; 5
       adc_im_0(i+6) and								// adc #$00				; 6
       sta(i+7) and									// sta					; 7
       (sta_stack(i+7) = false) and							// ~lda					; 8
       (adc(i+9) = false) then								// ~adc					; 9
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) then
       begin
	listing[i+1] := listing[i+7];

	listing[i+5] := #9'scc';
	listing[i+6] := #9'inc ' + copy(listing[i+7], 6, 256);

	listing[i+7] := '';

	Result:=false;
       end;


// -----------------------------------------------------------------------------
// ===				IMUL.					  === //
// -----------------------------------------------------------------------------

    if lda_im(i) and									// lda #$			; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx			; 1
       lda_im(i+2) and									// lda #$			; 2
       (listing[i+3] = #9'sta :eax') and						// sta :eax			; 3
       IFDEF_MUL8(i+4) then								// .ifdef fmulinit		; 4
     											// fmulu_8			; 5
      											// els				; 6
      											// imulCL			; 7
       		 									// eif				; 8
       begin
	p := GetBYTE(i) * GetBYTE(i+2);

	listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
	listing[i+1] := #9'sta :eax';
	listing[i+2] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
	listing[i+3] := #9'sta :eax+1';
	listing[i+4] := '';//#9'lda #$00';
	listing[i+5] := '';//#9'sta :eax+2';
	listing[i+6] := '';//#9'lda #$00';
	listing[i+7] := '';//#9'sta :eax+3';

	listing[i+8] := '';

	Result:=false;
       end;


    if lda_im(i) and									// lda #$			; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx			; 1
       lda_im(i+2) and									// lda #$			; 2
       (listing[i+3] = #9'sta :eax') and						// sta :eax			; 3
       IFDEF_MUL8(i+4) then								// .ifdef fmulinit		; 4
       											// fmulu_8			; 5
       											// els				; 6
       											// imulCL			; 7
      						 					// eif				; 8
       begin
	p := GetBYTE(i) * GetBYTE(i+2);

	listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
	listing[i+1] := #9'sta :eax';
	listing[i+2] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
	listing[i+3] := #9'sta :eax+1';
	listing[i+4] := '';//#9'lda #$00';
	listing[i+5] := '';//#9'sta :eax+2';
	listing[i+6] := '';//#9'lda #$00';
	listing[i+7] := '';//#9'sta :eax+3';

	listing[i+8] := '';

	Result:=false;
       end;


    if lda_im_0(i) and									// lda #$00	; 0
       (listing[i+1] = #9'sta :eax+2') and						// sta :eax+2	; 1
       lda_im_0(i+2) and								// lda #$00	; 2
       (listing[i+3] = #9'sta :eax+3') and						// sta :eax+3	; 3
       lda(i+4) and									// lda #$80	; 4
       (listing[i+5] = #9'sta :ecx') and						// sta :ecx	; 5
       lda(i+6) and									// lda #$01	; 6
       (listing[i+7] = #9'sta :ecx+1') and						// sta :ecx+1	; 7
       lda_im_0(i+8) and								// lda #$00	; 8
       (listing[i+9] = #9'sta :ecx+2') and						// sta :ecx+2	; 9
       lda_im_0(i+10) and								// lda #$00	; 10
       (listing[i+11] = #9'sta :ecx+3') and						// sta :ecx+3	; 11
       (listing[i+12] = #9'jsr imulECX') then						// jsr imulECX	; 12
      begin
	listing[i]   := listing[i+4];
	listing[i+1] := listing[i+5];
	listing[i+2] := listing[i+6];
	listing[i+3] := listing[i+7];

	listing[i+4] := #9'.ifdef fmulinit';
	listing[i+5] := #9'fmulu_16';
	listing[i+6] := #9'els';
	listing[i+7] := #9'imulCX';
	listing[i+8] := #9'eif';

	listing[i+9] := '';
	listing[i+10]:= '';
	listing[i+11]:= '';
	listing[i+12]:= '';

	Result:=false;
      end;


    if lda(i) and									// lda ztmp9		; 0
       (listing[i+1] = #9'bpl @+') and							// bpl @+		; 1
       lda(i+2) and									// lda 			; 2
       sub(i+3) and									// sub 			; 3
       (listing[i+4] = #9'sta :eax+2') and						// sta :eax+2		; 4
       lda(i+5) and									// lda 			; 5
       sbc(i+6) and									// sbc			; 6
       (listing[i+7] = #9'sta :eax+3') and 						// sta :eax+3		; 7
       (listing[i+8] = '@') and								//@			; 8
       (listing[i+9] = #9'lda :eax') and 						// lda :eax		; 9
       sta(i+10) and 									// sta 			; 10
       (listing[i+11] = #9'lda :eax+1') and 						// lda :eax+1		; 11
       sta(i+12) and 									// sta 			; 12
       (pos('lda :eax', listing[i+13]) = 0) then					// ~lda			; 13
     begin
	listing[i]  := '';
	listing[i+1]:= '';
	listing[i+2]:= '';
	listing[i+3]:= '';
	listing[i+4]:= '';
	listing[i+5]:= '';
	listing[i+6]:= '';
	listing[i+7]:= '';
	listing[i+8]:= '';

	Result:=false;
     end;


    if lda(i) and									// lda ztmp9		; 0
       (listing[i+1] = #9'bpl @+') and							// bpl @+		; 1
       lda(i+2) and									// lda 			; 2
       sub(i+3) and									// sub 			; 3
       (listing[i+4] = #9'sta :eax+2') and						// sta :eax+2		; 4
       lda(i+5) and									// lda 			; 5
       sbc(i+6) and									// sbc			; 6
       (listing[i+7] = #9'sta :eax+3') and 						// sta :eax+3		; 7
       (listing[i+8] = '@') and								//@			; 8
       mwa_bp2(i+9) and									// mwa BASE :bp2	; 9
       ldy_im_0(i+10) and 								// ldy #$00		; 10
       (listing[i+11] = #9'lda :eax') and 						// lda :eax		; 11
       add_sub(i+12) and (pos(' (:bp2),y', listing[i+12]) > 0) and   			// add (:bp2),y		; 12
       iny(i+13) and									// iny			; 13
       sta(i+14) and 									// sta			; 14
       (listing[i+15] = #9'lda :eax+1') and 						// lda :eax+1		; 15
       adc_sbc(i+16) and (pos(' (:bp2),y', listing[i+16]) > 0) and 			// adc (:bp2),y		; 16
       sta(i+17) and 									// sta			; 17
       (lda(i+18) = false) then								// ~lda			; 18
     begin
	listing[i]  := '';
	listing[i+1]:= '';
	listing[i+2]:= '';
	listing[i+3]:= '';
	listing[i+4]:= '';
	listing[i+5]:= '';
	listing[i+6]:= '';
	listing[i+7]:= '';
	listing[i+8]:= '';

	Result:=false;
     end;


    if lda(i) and									// lda ztmp9		; 0
       (listing[i+1] = #9'bpl @+') and							// bpl @+		; 1
       lda(i+2) and									// lda 			; 2
       sub(i+3) and									// sub 			; 3
       (listing[i+4] = #9'sta :eax+2') and						// sta :eax+2		; 4
       lda(i+5) and									// lda 			; 5
       sbc(i+6) and									// sbc			; 6
       (listing[i+7] = #9'sta :eax+3') and 						// sta :eax+3		; 7
       (listing[i+8] = '@') and								//@			; 8
       lda(i+9) and 									// lda			; 9
       add_sub(i+10) and (pos(' :eax', listing[i+10]) > 0) and 				// add|sub :eax		; 10
       sta(i+11) and 									// sta			; 11
       lda(i+12) and 									// lda			; 12
       adc_sbc(i+13) and (pos(' :eax+1', listing[i+13]) > 0) and			// adc|sbc :eax+1	; 13
       sta(i+14) and 									// sta			; 14
       (lda(i+15) = false) then 							// ~lda			; 15
     begin
	listing[i]  := '';
	listing[i+1]:= '';
	listing[i+2]:= '';
	listing[i+3]:= '';
	listing[i+4]:= '';
	listing[i+5]:= '';
	listing[i+6]:= '';
	listing[i+7]:= '';
	listing[i+8]:= '';

	Result:=false;
     end;


    if lda(i) and									// lda ztmp8		; 0
       (listing[i+1] = #9'bpl @+') and							// bpl @+		; 1
       lda(i+2) and									// lda  		; 2
       sub(i+3) and									// sub 			; 3
       (listing[i+4] = #9'sta :eax+1') and						// sta :eax+1		; 4
       (listing[i+5] = '@') and								//@			; 5
       lda_stack(i+6) and 								// lda :STACK		; 6
       ((listing[i+7] = #9'add :eax') or (pos('sub :eax', listing[i+7]) > 0)) and	// add|sub :eax		; 7
       sta_stack(i+8) and 								// sta :STACK		; 8
       (lda(i+9) = false) then								// ~lda			; 9
     if (copy(listing[i+4], 6, 256) <> copy(listing[i+7], 6, 256)) then
     begin
	listing[i]  := '';
	listing[i+1]:= '';
	listing[i+2]:= '';
	listing[i+3]:= '';
	listing[i+4]:= '';
	listing[i+5]:= '';

	Result:=false;
     end;


    if lda(i) and									// lda ztmp11		; 0
       (listing[i+1] = #9'bpl @+') and							// bpl @+		; 1
       (listing[i+2] = #9'lda :eax+2') and						// lda :eax+2 		; 2
       sub(i+3) and									// sub 			; 3
       (listing[i+4] = #9'sta :eax+2') and						// sta :eax+2		; 4
       (listing[i+5] = #9'lda :eax+3') and						// lda :eax+3 		; 5
       sbc(i+6) and									// sbc 			; 6
       (listing[i+7] = #9'sta :eax+3') and						// sta :eax+3		; 7
       (listing[i+8] = '@') and								//@			; 8
       (listing[i+9] = #9'lda :eax+1') and 						// lda :eax+1		; 9
       (sta(i+10) or									// sta			; 10
	(listing[i+11] = #9'lda :eax')) then 						// lda :eax		; 11
     if (copy(listing[i+4], 6, 256) <> copy(listing[i+11], 6, 256)) and
	(copy(listing[i+7], 6, 256) <> copy(listing[i+11], 6, 256)) then
     begin
	listing[i]  := '';
	listing[i+1]:= '';
	listing[i+2]:= '';
	listing[i+3]:= '';
	listing[i+4]:= '';
	listing[i+5]:= '';
	listing[i+6]:= '';
	listing[i+7]:= '';
	listing[i+8]:= '';

	Result:=false;
     end;


    if lda(i) and									// lda ztmp11		; 0
       (listing[i+1] = #9'bpl @+') and							// bpl @+		; 1
       (listing[i+2] = #9'lda :eax+2') and						// lda :eax+2 		; 2
       sub(i+3) and									// sub 			; 3
       (listing[i+4] = #9'sta :eax+2') and						// sta :eax+2		; 4
       (listing[i+5] = #9'lda :eax+3') and						// lda :eax+3 		; 5
       sbc(i+6) and									// sbc 			; 6
       (listing[i+7] = #9'sta :eax+3') and						// sta :eax+3		; 7
       (listing[i+8] = '@') and								//@			; 8
       (listing[i+9] = #9'lda :eax') and 						// lda :eax		; 9
       (pos(':eax+2', listing[i+10]) = 0) and
       (pos(':eax+2', listing[i+11]) = 0) and
       (pos(':eax+2', listing[i+12]) = 0) and
       (pos(':eax+2', listing[i+13]) = 0) and
       (pos(':eax+2', listing[i+14]) = 0) and
       (pos(':eax+2', listing[i+15]) = 0) and
       (pos(':eax+2', listing[i+16]) = 0) and
       (pos(':eax+2', listing[i+17]) = 0) and
       (pos(':eax+2', listing[i+18]) = 0) then
     if (copy(listing[i+4], 6, 256) <> copy(listing[i+9], 6, 256)) and
	(copy(listing[i+7], 6, 256) <> copy(listing[i+9], 6, 256)) then
     begin
	listing[i]  := '';
	listing[i+1]:= '';
	listing[i+2]:= '';
	listing[i+3]:= '';
	listing[i+4]:= '';
	listing[i+5]:= '';
	listing[i+6]:= '';
	listing[i+7]:= '';
	listing[i+8]:= '';

	Result:=false;
     end;


    if lda(i) and									// lda ztmp11		; 0
       (listing[i+1] = #9'bpl @+') and							// bpl @+		; 1
       (listing[i+2] = #9'lda :eax+1') and						// lda :eax+1 		; 2
       sub(i+3) and									// sub 			; 3
       (listing[i+4] = #9'sta :eax+1') and						// sta :eax+1		; 4
       (listing[i+5] = '@') and								//@			; 5
       (listing[i+6] = #9'lda :eax') and 						// lda :eax		; 6
       (pos(':eax+1', listing[i+7]) = 0) and
       (pos(':eax+1', listing[i+8]) = 0) and
       (pos(':eax+1', listing[i+9]) = 0) and
       (pos(':eax+1', listing[i+10]) = 0) and
       (pos(':eax+1', listing[i+11]) = 0) and
       (pos(':eax+1', listing[i+12]) = 0) and
       (pos(':eax+1', listing[i+13]) = 0) and
       (pos(':eax+1', listing[i+14]) = 0) and
       (pos(':eax+1', listing[i+15]) = 0) then
     if (copy(listing[i+2], 6, 256) <> copy(listing[i+6], 6, 256)) and
	(copy(listing[i+4], 6, 256) <> copy(listing[i+6], 6, 256)) then
     begin
	listing[i]  := '';
	listing[i+1]:= '';
	listing[i+2]:= '';
	listing[i+3]:= '';
	listing[i+4]:= '';
	listing[i+5]:= '';

	Result:=false;
     end;


    if asl_stack(i) and									// asl :STACKORIGIN+10	; 0
       rol_a(i+1) and									// rol @		; 1
       (listing[i+2] = #9'sta :eax+1') and						// sta :eax+1		; 2
       lda_stack(i+3) and								// lda :STACKORIGIN+10	; 3
       (listing[i+4] = #9'sta :eax') and						// sta :eax		; 4
       lda_im_0(i+5) and								// lda #$00		; 5
       (listing[i+6] = #9'sta :eax+2') and						// sta :eax+2		; 6
       lda_im_0(i+7) and								// lda #$00		; 7
       (listing[i+8] = #9'sta :eax+3') then 						// sta :eax+3		; 8
     if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then
     begin

	tmp:=#9'sta ' + copy(listing[i+3], 6, 256);
	insert('STACKWIDTH+', tmp, pos(':STACKORIGIN+', listing[i+3])+13);

	yes:=false;
	for p:=i+3 to l-1 do
	 if pos(':eax+1', listing[p]) > 0 then begin yes:=true; Break end;

	if not yes then listing[i+2] := tmp;

	listing[i+5]:= '';
	listing[i+6]:= '';
	listing[i+7]:= '';
	listing[i+8]:= '';

	Result:=false;
     end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda 					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda					; 6
       add_sub(i+7) and									// add|sub				; 7
       (listing[i+8] = #9'sta :ecx') and 						// sta :ecx				; 8
       sta(i+9) and 									// sta					; 9
       lda(i+10) and 									// lda					; 10
       adc_sbc(i+11) and								// adc|sbc				; 11
       (listing[i+12] = #9'sta :ecx+1') and 						// sta :ecx+1				; 12
       sta(i+13) and 									// sta					; 13
       lda_stack(i+14) and 								// lda :STACKORIGIN+9			; 14
       (listing[i+15] = #9'sta :eax') and 						// sta :eax				; 15
       sta(i+16) and 									// sta					; 16
       lda_stack(i+17) and 								// lda :STACKORIGIN+STACKWIDTH+9	; 17
       (listing[i+18] = #9'sta :eax+1') and 						// sta :eax+1				; 18
       sta(i+19) then 									// sta					; 19
     if (copy(listing[i+2], 6, 256) = copy(listing[i+14], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+17], 6, 256)) then
     begin

      listing_tmp[0]  := listing[i];
      listing_tmp[1]  := listing[i+1];
      listing_tmp[2]  := listing[i+15];
      listing_tmp[3]  := listing[i+16];

      listing_tmp[4]  := listing[i+3];
      listing_tmp[5]  := listing[i+4];
      listing_tmp[6]  := listing[i+18];
      listing_tmp[7]  := listing[i+19];

      listing_tmp[8]  := listing[i+6];
      listing_tmp[9]  := listing[i+7];
      listing_tmp[10] := listing[i+8];
      listing_tmp[11] := listing[i+9];
      listing_tmp[12] := listing[i+10];
      listing_tmp[13] := listing[i+11];
      listing_tmp[14] := listing[i+12];
      listing_tmp[15] := listing[i+13];

      listing[i+16] := '';
      listing[i+17] := '';
      listing[i+18] := '';
      listing[i+19] := '';

      for p:=0 to 15 do listing[i+p] := listing_tmp[p];

      Result:=false;
     end;


    if lda(i) and (lda_im(i) = false) and						// lda 					; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       lda(i+2) and (lda_im(i+2) = false) and						// lda 					; 2
       (listing[i+3] = #9'sta :ecx+1') and						// sta :ecx+1				; 3
       lda_im(i+4) and									// lda #$				; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       lda_im_0(i+6) and 								// lda #$00				; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       IFDEF_MUL16(i+8) then 								// .ifdef fmulinit			; 8
       											// fmulu_16				; 9
      											// els					; 10
       											// imulCX				; 11
     											// eif					; 12
     begin

      tmp := listing[i];
      listing[i]   := listing[i+4];
      listing[i+4] := tmp;

      tmp := listing[i+2];
      listing[i+2] := listing[i+6];
      listing[i+6] := tmp;

      Result:=false;
     end;


    if lda(i) and 									// lda 					; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       lda_im_0(i+2) and								// lda #$00				; 2
       (listing[i+3] = #9'sta :ecx+1') and						// sta :ecx+1				; 3
       lda(i+4) and									// lda 					; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       lda_im_0(i+6) and 								// lda #$00				; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       IFDEF_MUL16(i+8) then								// .ifdef fmulinit			; 8
     											// fmulu_16				; 9
      											// els					; 10
       											// imulCX				; 11
       											// eif					; 12
     begin
      listing[i+2] := '';
      listing[i+3] := '';

      listing[i+6] := '';
      listing[i+7] := '';

      listing[i+9]  := #9'fmulu_8';
      listing[i+11] := #9'imulCL';

      Result:=false;
     end;


    if (listing[i] = #9'lda #$02') and							// lda #$02				; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       lda_im_0(i+2) and								// lda #$00				; 2
       (listing[i+3] = #9'sta :ecx+1') and						// sta :ecx+1				; 3
       lda(i+4) and									// lda					; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       lda(i+6) and 									// lda					; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       IFDEF_MUL16(i+8) then			 					// .ifdef fmulinit			; 8
       											// fmulu_16				; 9
       											// els					; 10
       											// imulCX				; 11
       											// eif					; 12
     begin

      listing[i]   := listing[i+6];
      listing[i+1] := listing[i+7];
      listing[i+2] := listing[i+4];

      listing[i+3] := #9'asl @';
      listing[i+4] := #9'rol :eax+1';
      listing[i+5] := #9'sta :eax';

      listing[i+6]  := '';
      listing[i+7]  := '';
      listing[i+8]  := '';
      listing[i+9]  := '';
      listing[i+10] := '';
      listing[i+11] := '';
      listing[i+12] := '';

      Result:=false;
     end;


    if (listing[i] = #9'lda #$04') and							// lda #$04				; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       lda_im_0(i+2) and								// lda #$00				; 2
       (listing[i+3] = #9'sta :ecx+1') and						// sta :ecx+1				; 3
       lda(i+4) and									// lda					; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       lda(i+6) and 									// lda					; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       IFDEF_MUL16(i+8) then			 					// .ifdef fmulinit			; 8
       											// fmulu_16				; 9
      											// els					; 10
       											// imulCX				; 11
       											// eif					; 12
     begin

      listing[i]   := listing[i+6];
      listing[i+1] := listing[i+7];
      listing[i+2] := listing[i+4];

      listing[i+3] := #9'asl @';
      listing[i+4] := #9'rol :eax+1';
      listing[i+5] := #9'asl @';
      listing[i+6] := #9'rol :eax+1';
      listing[i+7] := #9'sta :eax';

      listing[i+8]  := '';
      listing[i+9]  := '';
      listing[i+10] := '';
      listing[i+11] := '';
      listing[i+12] := '';

      Result:=false;
     end;

(*
    if (listing[i] = #9'lda #$08') and							// lda #$08				; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       lda_im_0(i+2) and								// lda #$00				; 2
       (listing[i+3] = #9'sta :ecx+1') and						// sta :ecx+1				; 3
       lda(i+4) and									// lda					; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       lda(i+6) and 									// lda					; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       (listing[i+8] = #9'.ifdef fmulinit') and 					// .ifdef fmulinit			; 8
       (listing[i+9] = #9'fmulu_16') and						// fmulu_16				; 9
       (listing[i+10] = #9'els') and 							// els					; 10
       (listing[i+11] = #9'imulCX') and 						// imulCX				; 11
       (listing[i+12] = #9'eif') then 							// eif					; 12
     begin

      listing[i]   := listing[i+6];
      listing[i+1] := listing[i+7];
      listing[i+2] := listing[i+4];

      listing[i+3] := #9'asl @';
      listing[i+4] := #9'rol :eax+1';
      listing[i+5] := #9'asl @';
      listing[i+6] := #9'rol :eax+1';
      listing[i+7] := #9'asl @';
      listing[i+8] := #9'rol :eax+1';
      listing[i+9] := #9'sta :eax';

      listing[i+10] := '';
      listing[i+11] := '';
      listing[i+12] := '';

      Result:=false;
     end;


    if (listing[i] = #9'sta :eax+1') and 						// sta :eax+1				; 0
       (listing[i+1] = #9'lda #$08') and						// lda #$08				; 1
       (listing[i+2] = #9'sta :ecx') and						// sta :ecx				; 2
       lda_im_0(i+3) and								// lda #$00				; 3
       (listing[i+4] = #9'sta :ecx+1') and						// sta :ecx+1				; 4
       (listing[i+5] = #9'.ifdef fmulinit') and 					// .ifdef fmulinit			; 5
       (listing[i+6] = #9'fmulu_16') and						// fmulu_16				; 6
       (listing[i+7] = #9'els') and 							// els					; 7
       (listing[i+8] = #9'imulCX') and 							// imulCX				; 8
       (listing[i+9] = #9'eif') then 							// eif					; 9
     begin

      listing[i+1] := #9'asl :eax';
      listing[i+2] := #9'rol @';
      listing[i+3] := #9'asl :eax';
      listing[i+4] := #9'rol @';
      listing[i+5] := #9'asl :eax';
      listing[i+6] := #9'rol @';
      listing[i+7] := #9'sta :eax+1';

      listing[i+8] := '';
      listing[i+9] := '';

      Result:=false;
     end;
*)

    if (listing[i] = #9'lda #$08') and							// lda #$08				; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       lda(i+2) and									// lda 					; 2
       (listing[i+3] = #9'sta :eax') and						// sta :eax				; 3
       IFDEF_MUL8(i+4) and								// .ifdef fmulinit			; 4
       											// fmulu_8				; 5
       											// els					; 6
       											// imulCL				; 7
       											// eif					; 8
       (listing[i+9] = #9'ldy :eax') then						// ldy :eax				; 9
     begin

      listing[i]   := listing[i+2];

      listing[i+1] := #9'asl @';
      listing[i+2] := #9'asl @';
      listing[i+3] := #9'asl @';
      listing[i+4] := #9'tay';

      listing[i+5] := '';
      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';

      Result:=false;
     end;


    if (listing[i] = #9'lda #$08') and							// lda #$08				; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       lda(i+2) and									// lda 					; 2
       (listing[i+3] = #9'sta :eax') and						// sta :eax				; 3
       IFDEF_MUL8(i+4) and 								// .ifdef fmulinit			; 4
      											// fmulu_8				; 5
       											// els					; 6
       											// imulCL				; 7
       											// eif					; 8
       (listing[i+9] = #9'lda :eax') and						// lda :eax				; 9
       add_sub(i+10) and								// add|sub				; 10
       tay(i+11) then									// tay					; 11
     begin

      listing[i]   := listing[i+2];

      listing[i+1] := #9'asl @';
      listing[i+2] := #9'asl @';
      listing[i+3] := #9'asl @';

      listing[i+4] := '';
      listing[i+5] := '';
      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';

      Result:=false;
     end;


    if (listing[i] = #9'lda #$10') and							// lda #$10				; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       lda_im_0(i+2) and								// lda #$00				; 2
       (listing[i+3] = #9'sta :ecx+1') and						// sta :ecx+1				; 3
       lda(i+4) and									// lda					; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       lda(i+6) and 									// lda					; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       IFDEF_MUL16(i+8) then								// .ifdef fmulinit			; 8
       											// fmulu_16				; 9
       											// els					; 10
       											// imulCX				; 11
       											// eif					; 12
     begin

      listing[i]   := listing[i+6];
      listing[i+1] := listing[i+7];
      listing[i+2] := listing[i+4];

      listing[i+3] := #9'asl @';
      listing[i+4] := #9'rol :eax+1';
      listing[i+5] := #9'asl @';
      listing[i+6] := #9'rol :eax+1';
      listing[i+7] := #9'asl @';
      listing[i+8] := #9'rol :eax+1';
      listing[i+9] := #9'asl @';
      listing[i+10]:= #9'rol :eax+1';
      listing[i+11] := #9'sta :eax';

      listing[i+12] := '';

      Result:=false;
     end;


    if lda_im_0(i) and									// lda #$00				; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       (listing[i+2] = #9'lda #$01') and						// lda #$01				; 2
       (listing[i+3] = #9'sta :ecx+1') and						// sta :ecx+1				; 3
       lda(i+4) and									// lda					; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       lda(i+6) and 									// lda 					; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       IFDEF_MUL16(i+8) then								// .ifdef fmulinit			; 8
       											// fmulu_16				; 9
       											// els					; 10
       											// imulCX				; 11
       											// eif					; 12
     begin

      listing[i]   := '';
      listing[i+1] := '';
      listing[i+2] := '';
      listing[i+3] := '';

      listing[i+6] := listing[i+4];
      listing[i+4] := #9'lda #$00';

      listing[i+8] := '';
      listing[i+9] := '';
      listing[i+10] := '';
      listing[i+11] := '';
      listing[i+12] := '';

      Result:=false;
     end;


    if lda(i) and									// lda 					; 0
       (listing[i+1] = #9'sta :ecx') and						// sta :ecx				; 1
       lda(i+2) and									// lda 					; 2
       (listing[i+3] = #9'sta :ecx+1') and						// sta :ecx+1				; 3
       lda_im_0(i+4) and								// lda #$00				; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       (listing[i+6] = #9'lda #$01') and 						// lda #$01				; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       IFDEF_MUL16(i+8) then								// .ifdef fmulinit			; 8
       											// fmulu_16				; 9
       											// els					; 10
       											// imulCX				; 11
       											// eif					; 12
     begin
      listing[i+6] := listing[i];
      listing[i+4] := #9'lda #$00';

      listing[i]   := '';
      listing[i+1] := '';
      listing[i+2] := '';
      listing[i+3] := '';

      listing[i+8] := '';
      listing[i+9] := '';
      listing[i+10] := '';
      listing[i+11] := '';
      listing[i+12] := '';

      Result:=false;
     end;


    if	lda(i) and (lda_stack(i) = false) and						// lda					; 0
	(pos('sta :e', listing[i+1]) > 0) and						// sta :e..				; 1
	(listing[i+2] = #9'lda #$03') and 						// lda #$03				; 2
       	(pos('sta :e', listing[i+3]) > 0) and				 		// sta :e..				; 3
       	IFDEF_MUL8(i+4) and								// .ifdef fmulinit			; 4
      											// fmulu_8				; 5
       											// els					; 6
      											// imulCL				; 7
       											// eif					; 8
	lda(i+9) and									// lda					; 9
	((listing[i+10] = #9'add :eax') or (listing[i+10] = #9'sub :eax')) and		// add|sub :eax				; 10
	sta(i+11) then									// sta					; 11
     begin

	if lda(i+12) and								// lda					; 12
	   ((listing[i+13] = #9'adc :eax+1') or (listing[i+13] = #9'sbc :eax+1')) then	// adc|sbc :eax+1			; 13
	begin
	 listing[i+2] := listing[i];

	 listing[i]   := #9'lda #$00';
	 listing[i+1] := #9'sta :eax+1';

	 listing[i+3] := #9'asl @';
	 listing[i+4] := #9'rol :eax+1';

	 listing[i+5] := #9'add ' + copy(listing[i+2], 6, 256);
	 listing[i+6] := #9'sta :eax';
	 listing[i+7] := #9'scc';
	 listing[i+8] := #9'inc :eax+1';
	end else begin
	 listing[i+1] := #9'asl @';
	 listing[i+2] := #9'add ' + copy(listing[i], 6, 256);
	 listing[i+3] := #9'sta :eax';

	 listing[i+4] := '';
	 listing[i+5] := '';
	 listing[i+6] := '';
	 listing[i+7] := '';
	 listing[i+8] := '';
	end;

	Result:=false;
     end;


    if	(listing[i] = #9'lda #$03') and							// lda #$03				; 0
	(pos('sta :e', listing[i+1]) > 0) and						// sta :e..				; 1
	lda(i+2) and (lda_stack(i+2) = false) and					// lda 					; 2
       	(pos('sta :e', listing[i+3]) > 0) and				 		// sta :e..				; 3
       	IFDEF_MUL8(i+4) and								// .ifdef fmulinit			; 4
      											// fmulu_8				; 5
       											// els					; 6
      											// imulCL				; 7
       											// eif					; 8
	lda(i+9) and									// lda					; 9
	((listing[i+10] = #9'add :eax') or (listing[i+10] = #9'sub :eax')) and		// add|sub :eax				; 10
	sta(i+11) then									// sta					; 11
     begin

	if lda(i+12) and								// lda					; 12
	   ((listing[i+13] = #9'adc :eax+1') or (listing[i+13] = #9'sbc :eax+1')) then	// adc|sbc :eax+1			; 13
	begin
	 listing[i]   := #9'lda #$00';
	 listing[i+1] := #9'sta :eax+1';

	 listing[i+3] := #9'asl @';
	 listing[i+4] := #9'rol :eax+1';

	 listing[i+5] := #9'add ' + copy(listing[i+2], 6, 256);
	 listing[i+6] := #9'sta :eax';
	 listing[i+7] := #9'scc';
	 listing[i+8] := #9'inc :eax+1';
	end else begin
	 listing[i]   := '';
	 listing[i+1] := '';

	 listing[i+3] := #9'asl @';
	 listing[i+4] := #9'add ' + copy(listing[i+2], 6, 256);
	 listing[i+5] := #9'sta :eax';

	 listing[i+6] := '';
	 listing[i+7] := '';
	 listing[i+8] := '';
	end;

	Result:=false;
     end;


    if (listing[i] = #9'lda #$0A') and 							// lda #$0A				; 0
       (listing[i+1] = #9'sta :ecx') and 						// sta :ecx				; 1
       lda_im_0(i+2) and 								// lda #$00				; 2
       (listing[i+3] = #9'sta :ecx+1') and 						// sta :ecx+1				; 3
       lda(i+4) and (lda_stack(i+4) = false) and					// lda					; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       lda_im_0(i+6) and 								// lda #$00				; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       IFDEF_MUL16(i+8) and								// .ifdef fmulinit			; 8
       											// fmulu_16				; 9
       											// els					; 10
       											// imulCX				; 11
       											// eif					; 12
       (listing[i+13] = #9'lda :eax') and 						// lda :eax				; 13
       add_sub(i+14) and								// add|sub				; 14
       tay(i+15) then  									// tay					; 15
     begin

      listing[i]   := listing[i+4];
      listing[i+1] := #9'asl @';
      listing[i+2] := #9'asl @';
      listing[i+3] := #9'add ' + copy(listing[i], 6, 256);
      listing[i+4] := #9'asl @';

      listing[i+5] := '';
      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';

      listing[i+10] := '';
      listing[i+11] := '';
      listing[i+12] := '';
      listing[i+13] := '';

      Result:=false;
     end;


    if (listing[i] = #9'lda #$0A') and 							// lda #$0A				; 0
       (listing[i+1] = #9'sta :ecx') and 						// sta :ecx				; 1
       lda_im_0(i+2) and 								// lda #$00				; 2
       (listing[i+3] = #9'sta :ecx+1') and 						// sta :ecx+1				; 3
       lda(i+4) and (lda_stack(i+4) = false) and					// lda					; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       lda_im_0(i+6) and 								// lda #$00				; 6
       (listing[i+7] = #9'sta :eax+1') and 						// sta :eax+1				; 7
       IFDEF_MUL16(i+8) and 								// .ifdef fmulinit			; 8
       											// fmulu_16				; 9
       											// els					; 10
       											// imulCX				; 11
       											// eif					; 12
       lda(i+13) and 									// lda 					; 13
       add_sub(i+14) and								// add|sub				; 14
       ((listing[i+15] = #9'add :eax') or (listing[i+15] = #9'sub :eax')) and		// add|sub :eax				; 15
       tay(i+16) then 									// tay					; 16
     begin

      listing[i]   := listing[i+4];
      listing[i+1] := #9'asl @';
      listing[i+2] := #9'asl @';
      listing[i+3] := #9'add ' + copy(listing[i], 6, 256);
      listing[i+4] := #9'asl @';
      listing[i+5] := #9'sta :eax';

      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';

      listing[i+10] := '';
      listing[i+11] := '';
      listing[i+12] := '';

      Result:=false;
     end;


    if (listing[i] = #9'lda #$0A') and 							// lda #$0A				; 0
       (listing[i+1] = #9'sta :ecx') and 						// sta :ecx				; 1
       lda_im_0(i+2) and 								// lda #$00				; 2
       (listing[i+3] = #9'sta :ecx+1') and 						// sta :ecx+1				; 3
       IFDEF_MUL16(i+4) and 								// .ifdef fmulinit			; 4
       											// fmulu_16				; 5
       				 							// els					; 6
       											// imulCX				; 7
       											// eif					; 8
       (listing[i+9] = #9'lda :eax') and 						// lda :eax				; 9
       add_sub(i+10) and								// add|sub				; 10
       tay(i+11) then 									// tay					; 11
     begin

      listing[i]   := #9'lda :eax';
      listing[i+1] := #9'asl @';
      listing[i+2] := #9'asl @';
      listing[i+3] := #9'add :eax';
      listing[i+4] := #9'asl @';

      listing[i+5] := '';
      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';

      Result:=false;
     end;


    if (listing[i] = #9'lda #$0A') and 							// lda #$0A				; 0
       (listing[i+1] = #9'sta :ecx') and 						// sta :ecx				; 1
       lda_im_0(i+2) and 								// lda #$00				; 2
       (listing[i+3] = #9'sta :ecx+1') and 						// sta :ecx+1				; 3
       IFDEF_MUL16(i+4) and								// .ifdef fmulinit			; 4
       											// fmulu_16				; 5
       											// els					; 6
       											// imulCX				; 7
       											// eif					; 8
       lda(i+9) and 									// lda 					; 9
       AND_ORA_EOR(i+10) and								// and|ora|eor				; 10
       ((listing[i+11] = #9'add :eax') or (listing[i+11] = #9'sub :eax')) and		// add|sub :eax				; 11
       (tay(i+12) or sta_stack(i+12)) then						// tay|sta :STACK			; 12
     begin

      listing[i]   := #9'lda :eax';
      listing[i+1] := #9'asl @';
      listing[i+2] := #9'asl @';
      listing[i+3] := #9'add :eax';
      listing[i+4] := #9'asl @';
      listing[i+5] := #9'sta :eax';

      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';

      Result:=false;
     end;


    if ldy_im_0(i) and 									// ldy #$00				; 0
       lda(i+1) and 									// lda 					; 1
       spl(i+2) and 									// spl					; 2
       dey(i+3) and 									// dey					; 3
       (listing[i+4] = #9'sty :eax+1') and 						// sty :eax+1				; 4
       (listing[i+5] = #9'sta :eax') and 						// sta :eax				; 5
       (listing[i+6] = #9'lda #$0A') and 						// lda #$0a				; 6
       (listing[i+7] = #9'sta :ecx') and 						// sta :ecx				; 7
       lda_im_0(i+8) and 								// lda #$00				; 8
       (listing[i+9] = #9'sta :ecx+1') and 						// sta :ecx+1				; 9
       IFDEF_MUL16(i+10) and 								// .ifdef fmulinit			; 10
      											// fmulu_16				; 11
       											// els					; 12
       											// imulCX				; 13
       											// eif					; 14
       lda(i+15) and 									// lda 					; 15
       ((listing[i+16] = #9'add :eax') or (listing[i+16] = #9'sub :eax')) and		// add|sub :eax				; 16
       tay(i+17) then									// tay					; 17
     begin
      listing[i] := '';

      listing[i+2] := #9'asl @';
      listing[i+3] := #9'asl @';
      listing[i+4] := #9'add ' + copy(listing[i+1], 6, 256);
      listing[i+5] := #9'asl @';
      listing[i+6] := #9'sta :eax';

      listing[i+7]  := '';
      listing[i+8]  := '';
      listing[i+9]  := '';
      listing[i+10] := '';
      listing[i+11] := '';
      listing[i+12] := '';
      listing[i+13] := '';
      listing[i+14] := '';

      if listing[i+16] = #9'add :eax' then begin
	listing[i+15] := #9'add ' + copy(listing[i+15], 6, 256);

	listing[i+6] := '';
	listing[i+16] := '';
      end;

      Result:=false;
     end;


    if (listing[i] = #9'lda #$0A') and 							// lda #$0A				; 0
       (listing[i+1] = #9'sta :ecx') and 						// sta :ecx				; 1
       lda(i+2) and (lda_stack(i+2) = false) and					// lda 					; 2
       (listing[i+3] = #9'sta :eax') and 						// sta :eax				; 3
       IFDEF_MUL8(i+4) and 								// .ifdef fmulinit			; 4
     											// fmulu_8				; 5
       											// els					; 6
      											// imulCL				; 7
       											// eif					; 8
       (listing[i+9] = #9'lda :eax') and 						// lda :eax				; 9
       add_sub(i+10) and								// add|sub				; 10
       tay(i+11) then 									// tay					; 11
     begin

      listing[i] := listing[i+2];

      listing[i+1] := #9'asl @';
      listing[i+2] := #9'asl @';
      listing[i+3] := #9'add ' + copy(listing[i], 6, 256);
      listing[i+4] := #9'asl @';

      listing[i+5] := '';
      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';

      Result:=false;
     end;


    if lda(i) and									// lda 					; 0
       ((listing[i+1] = #9'sta :eax') or (listing[i+1] = #9'sta :ecx')) and		// sta :eax|:ecx			; 1
       (pos('sta ztmp', listing[i+2]) > 0) and						// sta ztmp...				; 2
       lda(i+3) and									// lda					; 3
       ((listing[i+4] = #9'sta :eax+1') or (listing[i+4] = #9'sta :ecx+1')) and		// sta :eax+1|:ecx+1			; 4
       (pos('sta ztmp', listing[i+5]) > 0) and 						// sta ztmp...				; 5
       lda(i+6) and 									// lda :STACKORIGIN+10			; 6
       ((listing[i+7] = #9'sta :ecx') or (listing[i+7] = #9'sta :eax')) and 		// sta :ecx|:eax			; 7
       (pos('sta ztmp', listing[i+8]) > 0) and						// sta ztmp...				; 8
       lda(i+9) and 									// lda					; 9
       ((listing[i+10] = #9'sta :ecx+1') or (listing[i+10] = #9'sta :eax+1')) and	// sta :ecx+1|:eax+1			; 10
       (pos('sta ztmp', listing[i+11]) > 0) and 					// sta ztmp...				; 11
       IFDEF_MUL16(i+12) and								// .ifdef fmulinit			; 12
      											// fmulu_16				; 13
       											// els					; 14
       											// imulCX				; 15
       											// eif					; 16
       (pos('lda ztmp', listing[i+17]) = 0) then 					// ~lda ztmp...				; 17
     begin
      listing[i+2]  := '';
      listing[i+5]  := '';
      listing[i+8]  := '';
      listing[i+11] := '';

      Result:=false;
     end;


    if dey(i) and									// dey					; 0
       ((listing[i+1] = #9'sty :eax+1') or (listing[i+1] = #9'sty :ecx+1')) and		// sty :eax+1|:ecx+1			; 1
       (pos('sty ztmp', listing[i+2]) > 0) and						// sty ztmp...				; 2
       ((listing[i+3] = #9'sta :eax') or (listing[i+3] = #9'sta :ecx')) and		// sta :eax+1|:ecx+1			; 3
       (pos('sta ztmp', listing[i+4]) > 0) and 						// sta ztmp...				; 4
       lda(i+5) and 									// lda :STACKORIGIN+10			; 5
       ((listing[i+6] = #9'sta :ecx') or (listing[i+6] = #9'sta :eax')) and 		// sta :ecx|:eax			; 6
       (pos('sta ztmp', listing[i+7]) > 0) and						// sta ztmp...				; 7
       lda(i+8) and 									// lda					; 8
       ((listing[i+9] = #9'sta :ecx+1') or (listing[i+9] = #9'sta :eax+1')) and		// sta :ecx+1|:eax+1			; 9
       (pos('sta ztmp', listing[i+10]) > 0) and 					// sta ztmp...				; 10
       IFDEF_MUL16(i+11) and								// .ifdef fmulinit			; 11
       											// fmulu_16				; 12
       											// els					; 13
       											// imulCX				; 14
       											// eif					; 15
       (pos('lda ztmp', listing[i+16]) = 0) then 					// ~lda ztmp...				; 16
     begin
      listing[i+2]  := '';
      listing[i+4]  := '';
      listing[i+7]  := '';
      listing[i+10] := '';

      Result:=false;
     end;


    if sta_stack(i) and									// sta :STACKORIGIN+STACKWIDTH+10	; 0
       lda(i+1) and									// lda 					; 1
       (listing[i+2] = #9'sta :ecx') and						// sta :ecx				; 2
       sta(i+3) and									// sta ztmp8				; 3
       lda(i+4) and									// lda					; 4
       (listing[i+5] = #9'sta :ecx+1') and 						// sta :ecx+1				; 5
       sta(i+6) and 									// sta ztmp9				; 6
       lda_stack(i+7) and 								// lda :STACKORIGIN+10			; 7
       (listing[i+8] = #9'sta :eax') and 						// sta :eax				; 8
       sta(i+9) and									// sta ztmp10				; 9
       lda_stack(i+10) and 								// lda :STACKORIGIN+STACKWIDTH+10	; 10
       (listing[i+11] = #9'sta :eax+1') and 						// sta :eax+1				; 11
       sta(i+12) then 									// sta ztmp11				; 12
     if copy(listing[i], 6, 256) = copy(listing[i+10], 6, 256) then
     begin
      listing_tmp[0]  := listing[i+7];
      listing_tmp[1]  := listing[i+8];
      listing_tmp[2]  := listing[i+9];
      listing_tmp[3]  := listing[i+10];
      listing_tmp[4]  := listing[i+11];
      listing_tmp[5]  := listing[i+12];

      listing_tmp[6]  := listing[i+1];
      listing_tmp[7]  := listing[i+2];
      listing_tmp[8]  := listing[i+3];
      listing_tmp[9]  := listing[i+4];
      listing_tmp[10] := listing[i+5];
      listing_tmp[11] := listing[i+6];

      for p:=0 to 11 do listing[i+1+p] := listing_tmp[p];

      Result:=false;
     end;

   end;

   end;


   function PeepholeOptimization: Boolean;
   var i, p, q, err: integer;
       old, tmp: string;
       btmp: array [0..15] of string;
       yes: Boolean;
   begin

   Result:=true;

   Rebuild;

  for i := 0 to l - 1 do
   if listing[i] <> '' then begin

// -----------------------------------------------------------------------------
// ===				optymalizacja LDA.			  === //
// -----------------------------------------------------------------------------

    if lda_im(i) and (pos('sta @FORTMP_', listing[i+1]) > 0) then	// zamiana na MVA aby zadzialala optymalizacja OPTYFOR
    begin
     listing[i+1] := #9'mva ' + copy(listing[i], 6, 4) + ' ' +  copy(listing[i+1], 6, 256);
     listing[i] := '';
     Result:=false;
    end;

  if pos('@FORTMP_', listing[i]) = 0 then begin				// !!! @FORTMP_ bez optymalizacji !!!


    if mva_im(i) and mva_im(i+1) and 								// mva #$xx	; 0
       mva_im(i+2) and mva_im(i+3) and								// mva #$xx	; 1
       (sta(i+4) = false) then									// mva #$xx	; 2
     if (copy(listing[i], 6, 4) = copy(listing[i+1], 6, 4)) and 				// mva #$xx	; 3
	(copy(listing[i+1], 6, 4) = copy(listing[i+2], 6, 4)) and
	(copy(listing[i+2], 6, 4) = copy(listing[i+3], 6, 4)) then begin

       listing[i+1] := #9'sta' + copy(listing[i+1], 10, 256);
       listing[i+2] := #9'sta' + copy(listing[i+2], 10, 256);
       listing[i+3] := #9'sta' + copy(listing[i+3], 10, 256);
       Result:=false;
     end;


    if mva_im(i) and mva_im(i+1) and								// mva #$xx	; 0
       mva_im(i+2) and mva_im(i+3) and								// mva #$yy	; 1
       (sta(i+4) = false) then									// mva #$zz	; 2
     if (copy(listing[i], 6, 4) = copy(listing[i+3], 6, 4)) and					// mva #$xx	; 3
	(copy(listing[i], 6, 4) <> copy(listing[i+1], 6, 4)) and
	(copy(listing[i+1], 6, 4) <> copy(listing[i+2], 6, 4)) and
	(copy(listing[i+2], 6, 4) <> copy(listing[i+3], 6, 4)) then begin

       tmp := listing[i];

       listing[i]   := listing[i+1];
       listing[i+1] := listing[i+2];
       listing[i+2] := tmp;

       listing[i+3] := #9'sta' + copy(listing[i+3], 10, 256);
       Result:=false;
     end;


    if mva_im(i) and mva_im(i+1) and 								// mva #$xx	; 0
       mva_im(i+2) and (sta(i+3) = false) then							// mva #$xx	; 1
     if (copy(listing[i], 6, 4) = copy(listing[i+1], 6, 4)) and 				// mva #$xx	; 2
	(copy(listing[i+1], 6, 4) = copy(listing[i+2], 6, 4)) then begin

       listing[i+1] := #9'sta' + copy(listing[i+1], 10, 256);
       listing[i+2] := #9'sta' + copy(listing[i+2], 10, 256);
       Result:=false;
     end;


    if mva_im(i) and mva_im(i+1) and								// mva #$xx	; 0
       mva_im(i+2) and (sta(i+3) = false) then							// mva #$yy	; 1
     if (copy(listing[i], 6, 4) = copy(listing[i+2], 6, 4)) and					// mva #$xx	; 2
	(copy(listing[i], 6, 4) <> copy(listing[i+1], 6, 4)) then begin

       tmp := listing[i];

       listing[i]   := listing[i+1];
       listing[i+1] := tmp;

       listing[i+2] := #9'sta' + copy(listing[i+2], 10, 256);
       Result:=false;
     end;


    if mva_im(i) and sta(i+1) and								// mva #$xx	; 0
       mva_im(i+2) and (sta(i+3) = false) then							// sta		; 1
     if (copy(listing[i], 6, 4) = copy(listing[i+2], 6, 4)) then begin				// mva #$xx	; 2

       listing[i+2] := #9'sta' + copy(listing[i+2], 10, 256);
       Result:=false;
     end;


    if mva_im(i) and mva_im(i+1) and								// mva #$xx	; 0
       (sta(i+2) = false) then									// mva #$xx	; 1
     if copy(listing[i], 6, 4) = copy(listing[i+1], 6, 4) then begin

       listing[i+1] := #9'sta' + copy(listing[i+1], 10, 256);
       Result:=false;
     end;


  end;  // @FORTMP_


    if lda_im_0(i) and										// lda #$00	; 0
       (sta(i+1) or ldy(i+1)) and								// sta|ldy	; 1
       (pos('mva #$00 ', listing[i+2]) > 0) then						// mva #$00	; 2
//       sta(i+3) then										// sta		; 3
     begin
	listing[i+2] := #9'sta ' + copy(listing[i+2], 11, 256);
	Result:=false;
     end;


    if (lda_im(i) = false) and (lda_im(i+2) = false) and					// lda TEMP	; 0
       lda(i) and sta(i+1) and									// sta		; 1
       lda(i+2) then										// lda TEMP	; 2
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and
	(copy(listing[i], 6, 256) <> copy(listing[i+1], 6, 256)) then begin
	listing[i+2] := '';
	Result:=false;
     end;


    if lda(i) and sta(i+1) and									// lda XI	; 0
       sta(i+2) and										// sta :ecx	; 1
       lda(i+3) and sta(i+4) and								// sta ztmp8	; 2
       sta(i+5) and										// lda XI+1	; 3
       lda(i+6) and sta(i+7) and								// sta :ecx+1	; 4
       sta(i+8) and										// sta ztmp9	; 5
       lda(i+9) and sta(i+10) and								// lda XI	; 6
       sta(i+11) then										// sta :eax	; 7
     if (listing[i] = listing[i+6]) and								// sta ztmp10	; 8
	(listing[i+3] = listing[i+9]) and							// lda XI+1	; 9
	(copy(listing[i], 6, 256) <> copy(listing[i+1], 6, 256)) and				// sta :eax+1	; 10
	(copy(listing[i+1], 6, 256) <> copy(listing[i+2], 6, 256)) and				// sta ztmp11	; 11
	(copy(listing[i+3], 6, 256) <> copy(listing[i+4], 6, 256)) and
	(copy(listing[i+4], 6, 256) <> copy(listing[i+5], 6, 256)) and
	(copy(listing[i+6], 6, 256) <> copy(listing[i+7], 6, 256)) and
	(copy(listing[i+7], 6, 256) <> copy(listing[i+8], 6, 256)) and
	(copy(listing[i+9], 6, 256) <> copy(listing[i+10], 6, 256)) and
	(copy(listing[i+10], 6, 256) <> copy(listing[i+11], 6, 256)) then
      begin
	tmp:=listing[i+4];

	listing[i+4]:=listing[i+7];
	listing[i+7]:=tmp;

	tmp:=listing[i+5];
	listing[i+5]:=listing[i+8];
	listing[i+8]:=tmp;

	listing[i+6]:=listing[i+9];

	listing[i+3] := '';
	listing[i+9] := '';

	Result:=false;
      end;


    if lda(i) and sta(i+1) and									// lda A	; 0
       lda(i+2) and sta(i+3) and								// sta :ecx	; 1
       lda(i+4) and sta(i+5) and								// lda A+1	; 2
       lda(i+6) and sta(i+7) then								// sta :ecx+1	; 3
     if (listing[i] = listing[i+4]) and								// lda A	; 4
	(listing[i+2] = listing[i+6]) and							// sta :eax	; 5
	(copy(listing[i], 6, 256) <> copy(listing[i+1], 6, 256)) and				// lda A+1	; 6
	(copy(listing[i+2], 6, 256) <> copy(listing[i+3], 6, 256)) and				// sta :eax+1	; 7
	(copy(listing[i+4], 6, 256) <> copy(listing[i+5], 6, 256)) and
	(copy(listing[i+6], 6, 256) <> copy(listing[i+7], 6, 256)) then
      begin
	listing[i+4] := listing[i+2];

	listing[i+2] := listing[i+5];

	listing[i+5] := '';
	listing[i+6] := listing[i+3];

	listing[i+3] := '';

	Result:=false;
      end;


    if lda(i) and sta(i+1) and									// lda 		; 0
       lda(i+2) and sta(i+3) and								// sta A	; 1
       lda(i+4) and sta(i+5) and								// lda 		; 2 --
       lda(i+6) and sta(i+7) then								// sta A+1	; 3  |
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and 				// lda A	; 4  | <> !!!
	(copy(listing[i+3], 6, 256) = copy(listing[i+6], 6, 256)) and				// sta		; 5 --
	(copy(listing[i+2], 6, 256) <> copy(listing[i+5], 6, 256)) then				// lda A+1	; 6
     begin											// sta		; 7
	listing[i+4] := listing[i];
	listing[i+6] := listing[i+2];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

      	Result:=false;
     end;


    if lda(i) and 										// lda					; 0
       sta_stack(i+1) and									// sta :STACKORIGIN+STACKWIDTH+10	; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+10			; 2
       ldy(i+3) and										// ldy					; 3
       lda_stack(i+4) and									// lda :STACKORIGIN+10			; 4
       sta(i+5) and										// sta					; 5
       lda_stack(i+6) and									// lda :STACKORIGIN+STACKWIDTH+10	; 6
       sta(i+7) then										// sta					; 7
     if (copy(listing[i+2], 6, 256) = copy(listing[i+4], 6, 256)) and
	(copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) then
      begin
	listing[i+4] := listing[i];
	listing[i+6] := listing[i];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
      end;


    if lda(i) and 										// lda					; 0
       add_sub(i+1) and										// add|sub				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+10			; 2
       lda(i+3) and										// lda					; 3
       adc_sbc(i+4) and										// add|sub				; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda_stack(i+6) and									// lda :STACKORIGIN+10			; 6
       sta(i+7) and										// sta					; 7
       sta(i+8) and										// sta					; 8
       lda(i+9) then										// lda					; 9
     if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) then
      begin
	listing[i+6] := listing[i+5];
	listing[i+5] := listing[i+4];
	listing[i+4] := listing[i+3];

	listing[i+2] := listing[i+7];
	listing[i+3] := listing[i+8];

	listing[i+7] := '';
	listing[i+8] := '';

	Result:=false;
      end;


// -----------------------------------------------------------------------------
// ===				optymalizacja regY.			  === //
// -----------------------------------------------------------------------------

    if Result and									// "samotna" instrukcja na koncu bloku
       (ldy(i) or lda(i)) and
       (listing[i+1] = '') then begin

	listing[i] := '';

	Result:=false;
       end;


    if (iny(i) or dey(i)) and								// iny|dey
       (ldy(i+1) or (pos('mvy ', listing[i+1]) > 0)) then				// ldy|mvy
       begin
	listing[i] := '';

	optyY := '';

	Result:=false;
       end;


    if ldy(i) and (pos('sty ', listing[i+1]) > 0) then					// ldy
       begin										// sty
	listing[i] := #9'lda ' + copy(listing[i], 6, 256);

	k:=i+1;
	while pos('sty ',listing[k]) > 0 do begin
	 listing[k] := #9'sta ' + copy(listing[k], 6, 256);
	 inc(k);
	end;

	optyY := '';

	Result:=false;
       end;


    if (pos('ldy #$', listing[i]) > 0) and (pos(' adr.', listing[i+1]) > 0) and		// ldy #$
       mva_im(i+1) and iy(i+1) then							// mva #$xx adr.xxx,y
       begin
	delete(listing[i+1], pos(',y', listing[i+1]), 2);
	listing[i+1] := listing[i+1] + '+' + copy(listing[i], 6+1, 256);

	tmp := listing[i];

	listing[i]   := listing[i+1];
	listing[i+1] := tmp;

	optyY := '';

	Result:=false;
       end;


//	ldy #$08
//	lda adr.PAC_SPRITES,y
//	sta :STACKORIGIN+10
//	lda adr.PAC_SPRITES+1,y
//	sta :STACKORIGIN+STACKWIDTH+10

    if (pos('ldy #$', listing[i]) > 0) and						// ldy #
       (pos('a adr.', listing[i+1]) > 0) and iy(i+1) then				// lda|sta adr.xxx,y
       begin

	yes := false;

	p:=i+1;
	while p < l do begin

	if (pos('cmp ', listing[p]) > 0) or (pos('bne ', listing[p]) > 0) or (pos('beq ', listing[p]) > 0) or	// wyjatki dla ktorych
	   (pos('bcc ', listing[p]) > 0) or (pos('bcs ', listing[p]) > 0) or					// musimy zachowac ldy #$xx
	   (pos('bpl ', listing[p]) > 0) or (pos('bmi ', listing[p]) > 0) or
	   seq(p) or sne(p) or spl(p) or smi(p) or scc(p) or scs(p) or
	   tya(p) or dey(p) or iny(p)
//	   (pos('jne ', listing[p]) > 0) or (pos('jeq ', listing[p]) > 0) or
//	   (pos('jmi ', listing[p]) > 0) or (pos('jpl ', listing[p]) > 0) or
//	   (pos('jcs ', listing[p]) > 0) or (pos('jcc ', listing[p]) > 0)
	then begin
	 yes:=true; Break
	end;

	if not( LDA(p) or STA(p) or AND_ORA_EOR(p) or ADD_SUB(p) or ADC_SBC(p) ) then Break;

	if (pos('a adr.', listing[p]) > 0) and iy(p) then begin
	 delete(listing[p], pos(',y', listing[p]), 2);
	 listing[p] := listing[p] + '+' + copy(listing[i], 6+1, 256);

	 optyY := '';
	end;

	inc(p);
       end;

       if not yes then begin listing[i] := ''; optyY:='' end;

       Result:=false;
       end;


//	ldy #$08
//	lda :STACKORIGIN+10
//	sta adr.PAC_SPRITES,y
//	lda :STACKORIGIN+STACKWIDTH+10
//	sta adr.PAC_SPRITES+1,y

    if (pos('ldy #$', listing[i]) > 0) and (iy(i+1) = false) and
       (pos('a adr.', listing[i+2]) > 0) and iy(i+2) then
       begin

	yes := false;

	p:=i+2;
	while p < l do begin

	if (pos('cmp ', listing[p]) > 0) or (pos('bne ', listing[p]) > 0) or (pos('beq ', listing[p]) > 0) or	// wyjatki dla ktorych
	   (pos('bcc ', listing[p]) > 0) or (pos('bcs ', listing[p]) > 0) or					// musimy zachowac ldy #$xx
	   (pos('bpl ', listing[p]) > 0) or (pos('bmi ', listing[p]) > 0) or
	   seq(p) or sne(p) or spl(p) or smi(p) or scc(p) or scs(p) or
	   tya(p) or dey(p) or iny(p)
//	   (pos('jne ', listing[p]) > 0) or (pos('jeq ', listing[p]) > 0) or
//	   (pos('jmi ', listing[p]) > 0) or (pos('jpl ', listing[p]) > 0) or
//	   (pos('jcs ', listing[p]) > 0) or (pos('jcc ', listing[p]) > 0)
	then begin
	 yes:=true; Break
	end;

	if not( LDA(p) or STA(p) or AND_ORA_EOR(p) or ADD_SUB(p) or ADC_SBC(p) ) then Break;

	if (pos('a adr.', listing[p]) > 0) and iy(p) then begin
	 delete(listing[p], pos(',y', listing[p]), 2);
	 listing[p] := listing[p] + '+' + copy(listing[i], 6+1, 256);

	 optyY := '';
	end;

	inc(p);
       end;

       if not yes then listing[i] := '';

       Result:=false;
       end;


    if lda(i) and sta(i+1) and (iy(i) = false) and						// lda 	~,y		; 0
       lda(i+2) and sta(i+3) and (iy(i+2) = false) and						// sta A		; 1
       lda(i+5) and sta(i+6) and								// lda 	~,y		; 2
       lda(i+7) and sta(i+8) and								// sta A+1		; 3
       ldy(i+4)  then										// ldy 			; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and 				// lda A		; 5
	(copy(listing[i+3], 6, 256) = copy(listing[i+7], 6, 256)) then				// sta			; 6
     begin											// lda A+1		; 7
	listing[i+5] := listing[i];								// sta			; 8
	listing[i+7] := listing[i+2];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

      	Result:=false;
     end;


    if lda(i) and (iy(i) = false) and								// lda			; 0
       ldy(i+1) and cmp(i+2) then								// ldy			; 1
       begin											// cmp			; 2
	tmp := listing[i];
	listing[i] := listing[i+1];
	listing[i+1] := tmp;
	Result:=false;
       end;


    if ldy(i) and lda(i+1) and sta(i+2) and							// ldy I		; 0
       ldy(i+3) then										// lda			; 1
      if listing[i] = listing[i+3] then								// sta :STACKORIGIN+9	; 2
       begin											// ldy I		; 3
	listing[i+3] := '';
	Result:=false;
       end;


    if ldy(i) and lda(i+1) and sta(i+3) and							// ldy I		; 0
       ldy(i+2) then										// lda adr...,y		; 1
      if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then begin			// ldy I		; 2
	listing[i+2] := '';									// sta adr...,y		; 3
	Result:=false;
       end;


    if ldy(i) and lda(i+1) and sta(i+4) and							// ldy I		; 0
       add_sub(i+2) and										// lda adr...,y		; 1
       ldy(i+3) then										// add|subadd|sub	; 2
      if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then begin			// ldy I		; 3
	listing[i+3] := '';									// sta adr...,y		; 4
	Result:=false;
       end;


    if lda(i) and (listing[i+1] = #9'add #$01') and 						// lda I		; 0
       sta_stack(i+2) then									// add #$01		; 1
     if ldy(i+3) and lda(i+4) and 								// sta :STACKORIGIN+9	; 2
	ldy_stack(i+5) then									// ldy I		; 3
      if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) and				// lda			; 4
	 (copy(listing[i+2], 6, 256) = copy(listing[i+5], 6, 256)) then begin			// ldy :STACKORIGIN+9	; 5
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+5] := #9'iny';
	Result:=false;
       end;


    if sta_stack(i) and										// sta :STACKORIGIN+9	; 0
       (lda(i+1) or AND_ORA_EOR(i+1)) and							// lda|ora|and|eor	; 1
       ldy_stack(i+2) and									// ldy :STACKORIGIN+9	; 2
       sta(i+3) then										// sta			; 3
      if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then
       begin
	listing[i]   := #9'tay';

	listing[i+2] := '';
	Result:=false;
       end;


    if ldy(i) and iny(i+1) and ldy(i+3) and							// ldy I		; 0
       ( lda(i+2) or sta(i+2)) then								// iny			; 1
       if copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256) then begin			// lda|sta xxx		; 2
	listing[i+3] := #9'dey';								// ldy I		; 3
	Result:=false;
       end;


// -----------------------------------------------------------------------------

//	lda adr.L_BLOCK,y		; 0
//	sta :STACKORIGIN+9		; 1
//	lda adr.H_BLOCK,y		; 2
//	sta :STACKORIGIN+STACKWIDTH+10	; 3
//	lda #$00			; 4
//	add :STACKORIGIN+9		; 5
//	sta TB				; 6
//	lda #$00			; 7
//	adc :STACKORIGIN+STACKWIDTH+10	; 8
//	sta TB+1			; 9

    if lda(i) and (iy(i) = false) and sta_stack(i+1) and
       add_stack(i+5)  then
       if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and
	  (pos(copy(listing[i+1], 6, 256), listing[i+2]) = 0) and
	  (pos(copy(listing[i+1], 6, 256), listing[i+3]) = 0) and
	  (pos(copy(listing[i+1], 6, 256), listing[i+4]) = 0) then
       begin
	listing[i+5] := #9'add '+copy(listing[i], 6, 256);
	listing[i]   := '';
	listing[i+1] := '';

	Result:=false;
       end;


    if lda(i) and (iy(i) = false) and sta_stack(i+1) and
       adc_stack(i+6)  then
       if (copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) and
	  (pos(copy(listing[i+1], 6, 256), listing[i+2]) = 0) and
	  (pos(copy(listing[i+1], 6, 256), listing[i+3]) = 0) and
	  (pos(copy(listing[i+1], 6, 256), listing[i+4]) = 0) and
	  (pos(copy(listing[i+1], 6, 256), listing[i+5]) = 0) then
       begin
	listing[i+6] := #9'adc '+copy(listing[i], 6, 256);
	listing[i]   := '';
	listing[i+1] := '';

	Result:=false;
       end;


    if sta_stack(i) and lda_stack(i+1) and							// sta :STACKORIGIN+10			; 0
       adc_sbc(i+2) and										// lda :STACKORIGIN+STACKWIDTH+10	; 1
       sta_stack(i+3) and									// adc|sbc				; 2
       ldy_stack(i+4) and lda_stack(i+5) and							// sta :STACKORIGIN+STACKWIDTH+10	; 3
       (pos('sta adr.', listing[i+6]) > 0) and							// ldy :STACKORIGIN+9			; 4
       lda_stack(i+7) and									// lda :STACKORIGIN+10			; 5
       (pos('sta adr.', listing[i+8]) > 0) then							// sta adr.MXD,y			; 6
     if (copy(listing[i], 6, 256) = copy(listing[i+5], 6, 256)) and 				// lda :STACKORIGIN+STACKWIDTH+10	; 7
	(copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) and				// sta adr.MXD+1,y			; 8
	(copy(listing[i+3], 6, 256) = copy(listing[i+7], 6, 256)) then
     begin
	listing[i+3] := listing[i+1];

	listing[i]   := listing[i+4];
	listing[i+1] := listing[i+6];

	listing[i+4] := listing[i+2];

	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';

      	Result:=false;
     end;


    if lda(i) and (iy(i) = false) and								// lda					; 0
       sta_stack(i+1) and									// sta :STACKORIGIN+9			; 1
       ldy(i+2) and										// ldy					; 2
       lda(i+3) and										// lda					; 3
       ldy_stack(i+4) then									// ldy :STACKORIGIN+9			; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) then
     begin
	listing[i+4] := #9'ldy ' + copy(listing[i], 6, 256);

	listing[i]   := '';
	listing[i+1] := '';

      	Result:=false;
     end;


    if lda(i) and										// lda					; 0
       asl_a(i+1) and										// asl @				; 1
       tay(i+2) and										// tay					; 2
       lda(i+3) and										// lda					; 3
       add_sub(i+4) and										// add|sub				; 4
       sta(i+5) and										// sta					; 5
       lda(i+6) and										// lda					; 6
       adc_sbc(i+7) and										// adc|sbc				; 7
       sta(i+8) and										// sta					; 8
       lda(i+9) and										// lda					; 9
       asl_a(i+10) and										// asl @				; 10
       tay(i+11) then										// tay					; 11
     if listing[i] = listing[i+9] then
     begin
	listing[i+9] := '';
	listing[i+10]:= '';
	listing[i+11]:= '';

      	Result:=false;
     end;


// -----------------------------------------------------------------------------
// ===				FILL.					  === //
// -----------------------------------------------------------------------------

    if lda_im(i) and										// lda #				; 0
       (listing[i+1] = #9'sta :edx') and							// sta :edx				; 1
       lda_im(i+2) and										// lda #				; 2
       (listing[i+3] = #9'sta :edx+1') and							// sta :edx+1				; 3
       lda_im(i+4) and										// lda #				; 4
       (listing[i+5] = #9'sta :ecx') and							// sta :ecx				; 5
       lda_im(i+6) and										// lda #				; 6
       (listing[i+7] = #9'sta :ecx+1') and							// sta :ecx+1				; 7
       lda(i+8) and										// lda 					; 8
       (listing[i+9] = #9'sta :eax') and							// sta :eax				; 9
       (listing[i+10] = #9'jsr @fill') then							// jsr @fill				; 10
       begin
	p := GetWORD(i, i+2);
	q := GetWORD(i+4, i+6);

	if q <= 256 then begin

	TMP:=IntToHex(q,2);

	if q = 0 then begin
	 listing[i]   := '';
	 listing[i+1] := '';
	 listing[i+2] := '';
	end else begin

	 listing[i]   := #9'ldy #256-$'+TMP;
	 listing[i+1] := listing[i+8];
	 listing[i+2] := #9'sta:rne $'+IntToHex(p,4)+'+$'+TMP+'-256,y+';

	 optyY:='';

	end;

	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';

	Result:=false;
	end;

       end;


    if lda_im(i) and										// lda #				; 0
       (listing[i+1] = #9'sta :ecx') and							// sta :ecx				; 1
       lda_im(i+2) and										// lda #				; 2
       (listing[i+3] = #9'sta :ecx+1') and							// sta :ecx+1				; 3
       lda(i+4) and										// lda 					; 4
       (listing[i+5] = #9'sta :eax') and							// sta :eax				; 5
       (listing[i+6] = #9'jsr @fill') then							// jsr @fill				; 6
       begin
	q := GetWORD(i, i+2);

	if (q <= 128) or (q = 256) then begin

	 case q of
	    0: begin
		listing[i]   := '';
		listing[i+1] := '';
		listing[i+2] := '';
	       end;

	  256: begin
		listing[i]   := #9'ldy #$00';

		if copy(listing[i], 6, 256) = copy(listing[i+4], 6, 256) then
		 listing[i+1] := #9'tya'
		else
		 listing[i+1] := listing[i+4];

		listing[i+2] := #9'sta:rne (:edx),y+';

		optyY:='';
	       end;

	 else

	  begin
	   listing[i]   := #9'ldy #$' + IntToHex(q-1, 2);
	   listing[i+1] := listing[i+4];
	   listing[i+2] := #9'sta:rpl (:edx),y-';

	   optyY:='';
	  end;

	end;

	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';

	Result:=false;
	end;

       end;


    if lda_im(i) and										// lda #				; 0
       (listing[i+1] = #9'sta :edx') and							// sta :edx				; 1
       lda_im(i+2) and										// lda #				; 2
       (listing[i+3] = #9'sta :edx+1') and							// sta :edx+1				; 3
       lda_im_0(i+4) and									// lda #$00				; 4
       (listing[i+5] = #9'sta :ecx') and							// sta :ecx				; 5
       lda_im(i+6) and										// lda #				; 6
       (listing[i+7] = #9'sta :ecx+1') and							// sta :ecx+1				; 7
       lda(i+8) and										// lda 					; 8
       (listing[i+9] = #9'sta :eax') and							// sta :eax				; 9
       (listing[i+10] = #9'jsr @fill') then							// jsr @fill				; 10
       begin
	p := GetWORD(i, i+2);
	q := (GetWORD(i+4, i+6) shr 8) shl 1;

	if q < 33 then begin

	 listing[i]   := #9'.LOCAL';
	 listing[i+1] := #9'ldy #$00';

	 if copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256) then
	  listing[i+2] := #9'tya'
	 else
	  listing[i+2] := listing[i+8];

	 listing[i+3] := 'fill'#9':'+IntToStr(q)+' sta $'+IntToHex(p,4)+'+#*$80,y';
	 listing[i+4] := #9'iny';
	 listing[i+5] := #9'bpl fill';
	 listing[i+6] := #9'.ENDL';

	 listing[i+7] := '';
	 listing[i+8] := '';
	 listing[i+9] := '';
	 listing[i+10] := '';

	 optyY:='';

	 Result:=false;
	end;

       end;


    if lda(i) and										// lda :STACKORIGIN+9			; 0
       add_sub(i+1) and										// add :STACKORIGIN+10			; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+9			; 2
       lda(i+3) and										// lda :STACKORIGIN+STACKWIDTH+9	; 3
       adc_sbc(i+4) and										// adc :STACKORIGIN+STACKWIDTH+10	; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and										// lda :STACKORIGIN+STACKWIDTH*2+9	; 6
       adc_sbc(i+7) and										// adc #$00				; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda(i+9) and										// lda :STACKORIGIN+STACKWIDTH*3+9	; 9
       adc_sbc(i+10) and									// adc #$00				; 10
       sta_stack(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
       lda_stack(i+12) and (listing[i+13] = #9'sta :edx') and					// lda :STACKORIGIN+9			; 12
       lda_stack(i+14) and (listing[i+15] = #9'sta :edx+1') then				// sta :edx				; 13
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH+9	; 14
	(copy(listing[i+5], 6, 256) = copy(listing[i+14], 6, 256)) then				// sta :edx+1				; 15
       begin
	listing[i+2] := listing[i+13];
	listing[i+5] := listing[i+15];

	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';
	listing[i+15] := '';

	Result:=false;
       end;


// -----------------------------------------------------------------------------
// ===				MOVE.					  === //
// -----------------------------------------------------------------------------

    if lda_im(i) and										// lda #				; 0
       (listing[i+1] = #9'sta :edx') and							// sta :edx				; 1
       lda_im(i+2) and										// lda #				; 2
       (listing[i+3] = #9'sta :edx+1') and							// sta :edx+1				; 3
       lda_im(i+4) and										// lda #				; 4
       (listing[i+5] = #9'sta :ecx') and							// sta :ecx				; 5
       lda_im(i+6) and										// lda #				; 6
       (listing[i+7] = #9'sta :ecx+1') and							// sta :ecx+1				; 7
       lda_im(i+8) and										// lda #				; 8
       (listing[i+9] = #9'sta :eax') and							// sta :eax				; 9
       lda_im(i+10) and										// lda #				; 10
       (listing[i+11] = #9'sta :eax+1') and							// sta :eax+1				; 11
       (listing[i+12] = #9'jsr @move') then							// jsr @move				; 12
       begin
	p:=GetWORD(i, i+2);		// src
	q:=GetWORD(i+4, i+6);		// dst
	k:=GetWORD(i+8, i+10);		// len

	if (k>0) and (k<=256) and (q < p) then begin

	  listing[i+11] := #9'ldy #256-'+IntToStr(k);
	  listing[i+12] := #9'mva:rne $' + IntToHex(p, 4) + '+' + IntToStr(k) + '-256,y $' +
	  				   IntToHex(q, 4) + '+' + IntToStr(k) + '-256,y+';
	  listing[i]   := '';
	  listing[i+1] := '';
	  listing[i+2] := '';
	  listing[i+3] := '';
	  listing[i+4] := '';
	  listing[i+5] := '';
	  listing[i+6] := '';
	  listing[i+7] := '';
	  listing[i+8] := '';
	  listing[i+9] := '';
	  listing[i+10] := '';

	  optyY:='';

	  Result:=false;
	end else
	 if (k>0) and (k<=128) and (q >= p) then begin

	  listing[i+11] := #9'ldy #$' + IntToHex(k-1, 2);
	  listing[i+12] := #9'mva:rpl $' + IntToHex(p, 4) + ',y $' + IntToHex(q, 4) + ',y-';

	  listing[i]   := '';
	  listing[i+1] := '';
	  listing[i+2] := '';
	  listing[i+3] := '';
	  listing[i+4] := '';
	  listing[i+5] := '';
	  listing[i+6] := '';
	  listing[i+7] := '';
	  listing[i+8] := '';
	  listing[i+9] := '';
	  listing[i+10] := '';

	  optyY:='';

	  Result:=false;
	 end;

       end;


    if lda(i) and										// lda					; 0
       ((listing[i+1] = #9'add :eax') or (listing[i+1] = #9'sub :eax')) and			// add|sub :eax				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+10			; 2
       lda(i+3) and										// lda 					; 3
       ((listing[i+4] = #9'adc :eax+1') or (listing[i+4] = #9'sbc :eax+1')) and			// adc|sbc :eax+1			; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and										// lda					; 6
       ((listing[i+7] = #9'adc :eax+2') or (listing[i+7] = #9'sbc :eax+2')) and			// adc|sbc :eax+2			; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda(i+9) and										// lda 					; 9
       ((listing[i+10] = #9'adc :eax+3') or (listing[i+10] = #9'sbc :eax+3')) and		// adc|sbc :eax+3			; 10
       sta_stack(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       lda_stack(i+12) and									// lda :STACKORIGIN+10			; 12
       add_sub(i+13) and									// add|sub 				; 13
       sta(i+14) and										// sta 					; 14
       lda_stack(i+15) and									// lda :STACKORIGIN+STACKWIDTH+10	; 15
       adc_sbc(i+16) and									// adc|sbc 				; 16
       sta(i+17) and										// sta 					; 17
       lda(i+18) then										// lda :STACKORIGIN+9			; 18
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+8], 6, 256) <> copy(listing[i+18], 6, 256)) then			// <>
       begin

	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and										// lda #$00				; 0
       ((listing[i+1] = #9'add :eax') or (listing[i+1] = #9'sub :eax')) and			// add|sub :eax				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+10			; 2
       lda(i+3) and										// lda #$A8				; 3
       ((listing[i+4] = #9'adc :eax+1') or (listing[i+4] = #9'sbc :eax+1')) and			// adc|sbc :eax+1			; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and										// lda #$00				; 6
       adc_sbc(i+7) and										// adc|sbc #$00				; 7
       (listing[i+8] = #9'sta :eax+2') and							// sta :eax+2				; 8
       lda(i+9) and										// lda #$00				; 9
       adc_sbc(i+10) and									// adc|sbc #$00				; 10
       (listing[i+11] = #9'sta :eax+3') and							// sta :eax+3				; 11
       lda_stack(i+12) and									// lda :STACKORIGIN+10			; 12
       add(i+13) and										// add #$A1				; 13
       sta_stack(i+14) and									// sta :STACKORIGIN+10			; 14
       lda_stack(i+15) and									// lda :STACKORIGIN+STACKWIDTH+10	; 15
       adc(i+16) and										// adc #$00				; 16
       sta_stack(i+17) and									// sta :STACKORIGIN+STACKWIDTH+10	; 17
       (lda_stack(i+18) = false) then								// ~lda					; 18
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+12], 6, 256) = copy(listing[i+14], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+15], 6, 256) = copy(listing[i+17], 6, 256)) then
       begin
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda_stack(i) and										// lda :STACKORIGIN+10			; 0
       add_sub(i+1) and										// add|sub #$35				; 1
       (listing[i+2] = #9'sta :edx') and							// sta :edx				; 2
       lda_stack(i+3) and									// lda :STACKORIGIN+STACKWIDTH+10	; 3
       adc_sbc(i+4) and										// adc|sbc #$00				; 4
       (listing[i+5] = #9'sta :edx+1') and							// sta :edx+1				; 5
       lda_stack(i+6) and									// lda :STACKORIGIN+STACKWIDTH*2+10	; 6
       adc_sbc(i+7) and										// adc|sbc #$00				; 7
       sta(i+8) and										// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda_stack(i+9) and									// lda :STACKORIGIN+STACKWIDTH*3+10	; 9
       adc_sbc(i+10) and									// adc|sbc #$00				; 10
       sta(i+11) then										// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
      begin
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and										// lda :STACKORIGIN+10			; 0
       add_sub(i+1) and										// add|sub #$35				; 1
       (listing[i+2] = #9'sta :ecx') and							// sta :ecx				; 2
       lda(i+3) and										// lda :STACKORIGIN+STACKWIDTH+10	; 3
       adc_sbc(i+4) and										// adc|sbc #$00				; 4
       (listing[i+5] = #9'sta :ecx+1') and							// sta :ecx+1				; 5
       lda(i+6) and										// lda :STACKORIGIN+STACKWIDTH*2+10	; 6
       adc_sbc(i+7) and										// adc|sbc #$00				; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda(i+9) and										// lda :STACKORIGIN+STACKWIDTH*3+10	; 9
       adc_sbc(i+10) and									// adc|sbc #$00				; 10
       sta_stack(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       lda(i+12) and										// lda #$B3				; 12
       (listing[i+13] = #9'sta :edx') and							// sta :edx				; 13
       lda(i+14) and										// lda #$20				; 14
       (listing[i+15] = #9'sta :edx+1') then							// sta :edx+1				; 15
     if (copy(listing[i+6], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+9], 6, 256) = copy(listing[i+11], 6, 256)) then
       begin
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and										// lda :STACKORIGIN+10			; 0
       add_sub(i+1) and										// add|sub #$35				; 1
       (listing[i+2] = #9'sta :ecx') and							// sta :ecx				; 2
       lda(i+3) and										// lda :STACKORIGIN+STACKWIDTH+10	; 3
       adc_sbc(i+4) and										// adc|sbc #$00				; 4
       (listing[i+5] = #9'sta :ecx+1') and							// sta :ecx+1				; 5
       lda(i+6) and										// lda :STACKORIGIN+STACKWIDTH*2+10	; 6
       adc_sbc(i+7) and										// adc|sbc #$00				; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda(i+9) and										// lda #$B3				; 12
       (listing[i+10] = #9'sta :edx') and							// sta :edx				; 13
       lda(i+11) and										// lda #$20				; 14
       (listing[i+12] = #9'sta :edx+1') then							// sta :edx+1				; 15
     if (copy(listing[i+6], 6, 256) = copy(listing[i+8], 6, 256)) then
       begin
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';

	Result:=false;
       end;


    if ldy_im_0(i) and										// ldy #$00				; 0
       lda_stack(i+1) and									// lda :STACKORIGIN+STACKWIDTH+11	; 1
       spl(i+2) and										// spl					; 2
       dey(i+3) and										// dey					; 3
       sta_stack(i+4) and									// sta :STACKORIGIN+STACKWIDTH+11	; 4
       sty_stack(i+5) and									// sty :STACKORIGIN+STACKWIDTH*2+11	; 5
       sty_stack(i+6) and									// sty :STACKORIGIN+STACKWIDTH*3+11	; 6
       lda(i+7) and										// lda 					; 7
       add_sub_stack(i+8) and									// add|sub :STACKORIGIN+11		; 8
       (listing[i+9] = #9'sta :ecx') and							// sta :ecx				; 9
       lda(i+10) and										// lda 					; 10
       adc_sbc_stack(i+11) and									// adc|sbc :STACKORIGIN+STACKWIDTH+11	; 11
       (listing[i+12] = #9'sta :ecx+1') and							// sta :ecx+1				; 12
       (lda(i+13) = false) then									// ~lda
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and
	(copy(listing[i+4], 6, 256) = copy(listing[i+11], 6, 256)) then
       begin
	listing[i+5] := '';
	listing[i+6] := '';

	Result:=false;
       end;


    if ldy_im_0(i) and										// ldy #$00				; 0
       lda(i+1) and										// lda 					; 1
       spl(i+2) and										// spl					; 2
       dey(i+3) and										// dey					; 3
       sta_stack(i+4) and									// sta :STACKORIGIN+11			; 4
       sty_stack(i+5) and									// sty :STACKORIGIN+STACKWIDTH+11	; 5
       sty_stack(i+6) and									// sty :STACKORIGIN+STACKWIDTH*2+11	; 6
       sty_stack(i+7) and									// sty :STACKORIGIN+STACKWIDTH*3+11	; 7
       lda_stack(i+8) and									// lda :STACKORIGIN+11			; 8
       sta(i+9) and										// sta 					; 9
       lda_stack(i+10) and									// lda :STACKORIGIN+STACKWIDTH+11	; 10
       sta(i+11) and										// sta 					; 11
       lda_stack(i+12) and									// lda :STACKORIGIN+STACKWIDTH*2+11	; 12
       sta(i+13) and										// sta 					; 13
       lda_stack(i+14) and									// lda :STACKORIGIN+STACKWIDTH*3+11	; 14
       sta(i+15) then										// sta 					; 15
     if (copy(listing[i+4], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+10], 6, 256)) and
	(copy(listing[i+6], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+7], 6, 256) = copy(listing[i+14], 6, 256)) then
       begin
	listing[i+4] := #9'sta ' + copy(listing[i+9], 6, 256);
	listing[i+5] := #9'sty ' + copy(listing[i+11], 6, 256);
	listing[i+6] := #9'sty ' + copy(listing[i+13], 6, 256);
	listing[i+7] := #9'sty ' + copy(listing[i+15], 6, 256);

	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';
	listing[i+15] := '';

	Result:=false;
       end;


    if lda(i) and										// lda					; 0
       add_sub(i+1) and										// add|sub :STACKORIGIN+11		; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+10			; 2
       lda(i+3) and										// lda					; 3
       adc_sbc(i+4) and										// adc|sbc :STACKORIGIN+STACKWIDTH+11	; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and										// lda 					; 6
       adc_sbc(i+7) and 									// adc|sbc :STACKORIGIN+STACKWIDTH*2+11	; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda(i+9) and										// lda					; 9
       adc_sbc(i+10) and									// adc|sbc :STACKORIGIN+STACKWIDTH*3+11	; 10
       sta_stack(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       lda_stack(i+12) and (listing[i+13] = #9'sta :edx') and					// lda :STACKORIGIN+9			; 12
       lda_stack(i+14) and (listing[i+15] = #9'sta :edx+1') and					// sta :edx				; 13
       lda_stack(i+16) and									// lda :STACKORIGIN+STACKWIDTH+9	; 14
       (listing[i+17] = #9'sta :ecx') and							// sta :edx+1				; 15
       lda_stack(i+18) and									// lda :STACKORIGIN+10			; 16
       (listing[i+19] = #9'sta :ecx+1') then							// sta :ecx				; 17
     if (copy(listing[i+2], 6, 256) = copy(listing[i+16], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH+10	; 18
	(copy(listing[i+5], 6, 256) = copy(listing[i+18], 6, 256)) then				// sta :ecx+1				; 19
       begin
	listing[i+2] := listing[i+17];
	listing[i+5] := listing[i+19];

	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	listing[i+16] := '';
	listing[i+17] := '';
	listing[i+18] := '';
	listing[i+19] := '';

	Result:=false;
       end;


    if lda(i) and										// lda :STACKORIGIN+10			; 0
       add_sub(i+1) and										// add|sub :STACKORIGIN+11		; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+10			; 2
       lda(i+3) and										// lda :STACKORIGIN+STACKWIDTH+10	; 3
       adc_sbc(i+4) and										// adc|sbc :STACKORIGIN+STACKWIDTH+11	; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and										// lda :STACKORIGIN+STACKWIDTH*2+10	; 6
       adc_sbc(i+7) and										// adc|sbc :STACKORIGIN+STACKWIDTH*2+11	; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda(i+9) and										// lda :STACKORIGIN+STACKWIDTH*3+10	; 9
       adc_sbc(i+10) and									// adc|sbc :STACKORIGIN+STACKWIDTH*3+11	; 10
       sta_stack(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       mwa_bp2(i+12) and									// mwa xx bp2				; 12
       ldy(i+13) and										// ldy #$0A				; 13
       LDA_BP2_Y(i+14) and sta_stack(i+15) and							// lda (:bp2),y				; 14
       lda_stack(i+16) and (listing[i+17] = #9'sta :edx') and					// sta :STACKORIGIN+11			; 15
       lda_stack(i+18) and (listing[i+19] = #9'sta :edx+1') and					// lda :STACKORIGIN+9			; 16
       lda_stack(i+20) and 									// sta :edx				; 17
       (listing[i+21] = #9'sta :ecx') and							// lda :STACKORIGIN+STACKWIDTH+9	; 18
       lda_stack(i+22) and									// sta :edx+1				; 19
       (listing[i+23] = #9'sta :ecx+1') then							// lda :STACKORIGIN+10			; 20
     if (copy(listing[i+2], 6, 256) = copy(listing[i+20], 6, 256)) and				// sta :ecx				; 21
	(copy(listing[i+5], 6, 256) = copy(listing[i+22], 6, 256)) then				// lda :STACKORIGIN+STACKWIDTH+10	; 22
       begin											// sta :ecx+1				; 23
	listing[i+2] := listing[i+21];
	listing[i+5] := listing[i+23];

	listing[i+20] := '';
	listing[i+21] := '';
	listing[i+22] := '';
	listing[i+23] := '';

	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if LDA_BP2_Y(i) and										// lda (:bp2),y				; 0
       sta_stack(i+1) and									// sta :STACKORIGIN+9			; 1
       iny(i+2) and										// iny					; 2
       LDA_BP2_Y(i+3) and									// lda (:bp2),y				; 3
       sta_stack(i+4) and									// sta :STACKORIGIN+STACKWIDTH+9	; 4
       lda(i+5) and										// lda #$80				; 5
       add(i+6) and										// add PAC.SY				; 6
       (listing[i+7] = #9'sta :ecx') and							// sta :ecx				; 7
       lda(i+8) and										// lda #$C1				; 8
       adc(i+9) and										// adc PAC.SY+1				; 9
       (listing[i+10] = #9'sta :ecx+1') and							// sta :ecx+1				; 10
       lda_stack(i+11) and (listing[i+12] = #9'sta :edx') and					// lda :STACKORIGIN+9			; 11
       lda_stack(i+13) and (listing[i+14] = #9'sta :edx+1') then				// sta :edx				; 12
     if (copy(listing[i+1], 6, 256) = copy(listing[i+11], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH+9	; 13
	(copy(listing[i+4], 6, 256) = copy(listing[i+13], 6, 256)) then				// sta :edx+1				; 14
       begin
	listing[i+1] := listing[i+12];
	listing[i+4] := listing[i+14];

	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';

	Result:=false;
       end;


    if LDA_BP2_Y(i) and										// lda (:bp2),y				; 0
       sta_stack(i+1) and									// sta :STACKORIGIN+9			; 1
       iny(i+2) and										// iny					; 2
       LDA_BP2_Y(i+3) and									// lda (:bp2),y				; 3
       sta_stack(i+4) and									// sta :STACKORIGIN+STACKWIDTH+9	; 4
       lda_stack(i+5) and									// lda :STACKORIGIN+9			; 5
       sta(i+6) and										// sta					; 6
       lda_stack(i+7) and									// lda :STACKORIGIN+STACKWIDTH+9	; 7
       sta(i+8) then										// sta					; 8
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and
	(copy(listing[i+4], 6, 256) = copy(listing[i+7], 6, 256)) then
       begin
	listing[i+1] := listing[i+6];
	listing[i+4] := listing[i+8];

	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';

	Result:=false;
       end;


    if lda(i) and										// lda K				; 0
       add_sub(i+1) and										// add #$15				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+9			; 2
       lda(i+3) and										// lda K+1				; 3
       adc_sbc(i+4) and										// adc #$00				; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and										// lda Q				; 6
       add_sub(i+7) and										// sub #$05				; 7
       (listing[i+8] = #9'sta :ecx') and							// sta :ecx				; 8
       lda(i+9) and										// lda Q+1				; 9
       adc_sbc(i+10) and									// sbc #$00				; 10
       (listing[i+11] = #9'sta :ecx+1') and							// sta :ecx+1				; 11
       lda_stack(i+12) and (listing[i+13] = #9'sta :edx') and					// lda :STACKORIGIN+9			; 12
       lda_stack(i+14) and (listing[i+15] = #9'sta :edx+1') then				// sta :edx				; 13
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH+9	; 14
	(copy(listing[i+5], 6, 256) = copy(listing[i+14], 6, 256)) then				// sta :edx+1				; 15
       begin
	listing[i+2] := listing[i+13];
	listing[i+5] := listing[i+15];

	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';
	listing[i+15] := '';

	Result:=false;
       end;


    if lda(i) and										// lda					; 0
       add_sub(i+1) and										// add|sub PAC.SY			; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+10			; 2
       lda(i+3) and										// lda					; 3
       adc_sbc(i+4) and										// adc|sbc PAC.SY+1			; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and (listing[i+7] = #9'sta :edx') and						// lda :STACKORIGIN+9			; 6
       lda(i+8) and  (listing[i+9] = #9'sta :edx+1') and					// sta :edx				; 7
       lda_stack(i+10) and (listing[i+11] = #9'sta :ecx') and					// lda :STACKORIGIN+STACKWIDTH+9	; 8
       lda_stack(i+12) and (listing[i+13] = #9'sta :ecx+1') then				// sta :edx+1				; 9
     if (copy(listing[i+2], 6, 256) = copy(listing[i+10], 6, 256)) and				// lda :STACKORIGIN+10			; 10
	(copy(listing[i+5], 6, 256) = copy(listing[i+12], 6, 256)) then				// sta :ecx				; 11
       begin											// lda :STACKORIGIN+STACKWIDTH+10	; 12
												// sta :ecx+1				; 13
	listing[i+2] := listing[i+11];
	listing[i+5] := listing[i+13];

	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';

	Result:=false;
       end;


    if lda(i) and sta_stack(i+1) and								// lda $0058				; 0
       lda(i+2) and sta_stack(i+3) and								// sta :STACKORIGIN+10			; 1
       lda_stack(i+4) and (listing[i+5] = #9'sta :edx') and					// lda $0058+1				; 2
       lda_stack(i+6) and  (listing[i+7] = #9'sta :edx+1') and					// sta :STACKORIGIN+STACKWIDTH+10	; 3
       lda_stack(i+8) and (listing[i+9] = #9'sta :ecx') and					// lda :STACKORIGIN+9			; 4
       lda_stack(i+10) and (listing[i+11] = #9'sta :ecx+1') then				// sta :edx				; 5
     if (copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH+9	; 6
	(copy(listing[i+3], 6, 256) = copy(listing[i+10], 6, 256)) then				// sta :edx+1				; 7
       begin											// lda :STACKORIGIN+10			; 8
	listing[i+8]  := listing[i];								// sta :ecx				; 9
	listing[i+10] := listing[i+2];								// lda :STACKORIGIN+STACKWIDTH+10	; 10
	listing[i]    := '';									// sta :ecx+1				; 11
	listing[i+1]  := '';
	listing[i+2]  := '';
	listing[i+3]  := '';

	Result:=false;
       end;


    if (i>0) and
       lda_stack(i) and										// lda :STACKORIGIN+9			; 0
       (listing[i+1] = #9'sta :edx') and							// sta :edx				; 1
       lda_stack(i+2) and									// lda :STACKORIGIN+STACKWIDTH+9	; 2
       (listing[i+3] = #9'sta :edx+1') and							// sta :edx+1				; 3
       lda(i+4) and										// lda					; 4
       (listing[i+5] = #9'sta :ecx') and							// sta :ecx				; 5
       lda(i+6) and										// lda					; 6
       (listing[i+7] = #9'sta :ecx+1') then							// sta :ecx+1				; 7
     begin

	tmp:='sta ' + copy(listing[i], 6, 256);
	yes:=false;
	for p:=i-1 downto 0 do begin
	 if (listing[p] = #9'eif') or (pos('jsr ', listing[p]) > 0) or (listing[p] = '@') then Break;

	 if pos(tmp, listing[p]) > 0 then begin yes:=true; listing[p] := #9'sta :edx'; Break end;
	end;

	if yes then begin
	 listing[i]   := '';
	 listing[i+1] := '';
	 Result:=false;
	end;

	tmp:='sta ' + copy(listing[i+2], 6, 256);
	yes:=false;
	for p:=i-1 downto 0 do begin
	 if (listing[p] = #9'eif') or (pos('jsr ', listing[p]) > 0) or (listing[p] = '@') then Break;

	 if pos(tmp, listing[p]) > 0 then begin yes:=true; listing[p] := #9'sta :edx+1'; Break end;
	end;

	if yes then begin
	 listing[i+2] := '';
	 listing[i+3] := '';
	 Result:=false;
	end;

     end;


    if (i>0) and
       lda_stack(i) and										// lda :STACKORIGIN+9			; 0
       (listing[i+1] = #9'sta :edx') and							// sta :edx				; 1
       lda_stack(i+2) and									// lda :STACKORIGIN+STACKWIDTH+9	; 2
       (listing[i+3] = #9'sta :edx+1') and							// sta :edx+1				; 3
       lda(i+4) and										// lda					; 4
       (listing[i+5] = #9'sta :eax') and							// sta :eax				; 5
       lda(i+6) and										// lda					; 6
       (listing[i+7] = #9'sta :eax+1') then							// sta :eax+1				; 7
     begin

	tmp:='sta ' + copy(listing[i], 6, 256);
	yes:=false;
	for p:=i-1 downto 0 do begin
	 if (listing[p] = #9'eif') or (pos('jsr ', listing[p]) > 0) or (listing[p] = '@') then Break;

	 if pos(tmp, listing[p]) > 0 then begin yes:=true; listing[p] := #9'sta :edx'; Break end;
	end;

	if yes then begin
	 listing[i]   := '';
	 listing[i+1] := '';
	 Result:=false;
	end;

	tmp:='sta ' + copy(listing[i+2], 6, 256);
	yes:=false;
	for p:=i-1 downto 0 do begin
	 if (listing[p] = #9'eif') or (pos('jsr ', listing[p]) > 0) or (listing[p] = '@') then Break;

	 if pos(tmp, listing[p]) > 0 then begin yes:=true; listing[p] := #9'sta :edx+1'; Break end;
	end;

	if yes then begin
	 listing[i+2] := '';
	 listing[i+3] := '';
	 Result:=false;
	end;

     end;


    if (i>0) and
       lda_stack(i) and										// lda :STACKORIGIN+9			; 0
       (listing[i+1] = #9'sta :ecx') and							// sta :ecx				; 1
       lda_stack(i+2) and									// lda :STACKORIGIN+STACKWIDTH+9	; 2
       (listing[i+3] = #9'sta :ecx+1') and							// sta :ecx+1				; 3
       lda(i+4) and										// lda					; 4
       (listing[i+5] = #9'sta :eax') and							// sta :eax				; 5
       lda(i+6) and										// lda					; 6
       (listing[i+7] = #9'sta :eax+1') then							// sta :eax+1				; 7
     begin

	tmp:='sta ' + copy(listing[i], 6, 256);
	yes:=false;
	for p:=i-1 downto 0 do begin
	 if (listing[p] = #9'eif') or (pos('jsr ', listing[p]) > 0) or (listing[p] = '@') then Break;

	 if pos(tmp, listing[p]) > 0 then begin yes:=true; listing[p] := #9'sta :ecx'; Break end;
	end;

	if yes then begin
	 listing[i]   := '';
	 listing[i+1] := '';
	 Result:=false;
	end;

	tmp:='sta ' + copy(listing[i+2], 6, 256);
	yes:=false;
	for p:=i-1 downto 0 do begin
	 if (listing[p] = #9'eif') or (pos('jsr ', listing[p]) > 0) or (listing[p] = '@') then Break;

	 if pos(tmp, listing[p]) > 0 then begin yes:=true; listing[p] := #9'sta :ecx+1'; Break end;
	end;

	if yes then begin
	 listing[i+2] := '';
	 listing[i+3] := '';
	 Result:=false;
	end;

     end;

{
    if add_sub(i) and										// add|sub				; 0
       sta_stack(i+1) and									// sta :STACKORIGIN+10			; 1
       lda(i+2) and										// lda					; 2
       adc_sbc(i+3) and										// adc|sbc				; 3
       sta_stack(i+4) and									// sta :STACKORIGIN+STACKWIDTH+10	; 4
       lda(i+5) and										// lda					; 5
       adc_sbc(i+6) and										// adc|sbc				; 6
       sta_stack(i+7) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 7
       lda(i+8) and										// lda					; 8
       adc_sbc(i+9) and										// adc|sbc				; 9
       sta_stack(i+10) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 10
       ldy(i+11) and										// ldy					; 11
       lda_stack(i+12) and									// lda :STACKORIGIN+10			; 12
       ADD_BP2_Y(i+13) and									// add (:bp2),y				; 13
       iny(i+14) and										// iny					; 14
       (listing[i+15] = #9'sta :ecx') and							// sta :ecx				; 15
       lda_stack(i+16) and									// lda :STACKORIGIN+STACKWIDTH+10	; 16
       ADC_BP2_Y(i+17) and									// adc (:bp2),y				; 17
       (listing[i+18] = #9'sta :ecx+1') then							// sta :ecx+1				; 18
     if (copy(listing[i+1], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+4], 6, 256) = copy(listing[i+16], 6, 256)) then
       begin
	listing[i+5]  := '';
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';

	Result:=false;
       end;
}

    if sta_stack(i) and										// sta :STACKORIGIN+10			; 0
       lda(i+1) and										// lda					; 1
       add_sub(i+2) and										// add|sub				; 2
       sta_stack(i+3) and									// sta :STACKORIGIN+STACKWIDTH+10	; 3
       lda(i+4) and										// lda					; 4
       adc_sbc(i+5) and										// adc|sbc				; 5
       sta_stack(i+6) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 6
       lda(i+7) and										// lda					; 7
       adc_sbc(i+8) and										// adc|sbc				; 8
       sta_stack(i+9) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 9
       mwa_bp2(i+10) and									// mwa ... :bp2				; 10
       ldy(i+11) and										// ldy					; 11
       lda_stack(i+12) and									// lda :STACKORIGIN+10			; 12
       ADD_BP2_Y(i+13) and									// add (:bp2),y				; 13
       iny(i+14) and										// iny					; 14
       (listing[i+15] = #9'sta :ecx') and							// sta :ecx				; 15
       lda_stack(i+16) and									// lda :STACKORIGIN+STACKWIDTH+10	; 16
       ADC_BP2_Y(i+17) and									// adc (:bp2),y				; 17
       (listing[i+18] = #9'sta :ecx+1') and							// sta :ecx+1				; 18
       (lda_stack(i+19) = false) then								// ~lda :STACK
     if (copy(listing[i], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+16], 6, 256)) then
       begin

	listing[i+4]  := '';
	listing[i+5]  := '';
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9] := '';

	Result:=false;
       end;


// -----------------------------------------------------------------------------
// ===				LSR.					  === //
// -----------------------------------------------------------------------------

    if lda(i) and sta_stack(i+1) and								// lda C				; 0
       lda(i+2) and sta_stack(i+3) and								// sta :STACKORIGIN+9			; 1
       lda(i+4) and sta_stack(i+5) and								// lda C+1				; 2
       lda(i+6) and sta_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH		; 3
       lsr_stack(i+8) and									// lda C+2				; 4
       ror_stack(i+9) and									// sta :STACKORIGIN+STACKWIDTH*2	; 5
       ror_stack(i+10) and									// lda C+3				; 6
       ror_stack(i+11) then									// sta :STACKORIGIN+STACKWIDTH*3	; 7
     if (copy(listing[i+1], 6, 256) = copy(listing[i+11], 6, 256)) and				// lsr :STACKORIGIN+STACKWIDTH*3	; 8
	(copy(listing[i+3], 6, 256) = copy(listing[i+10], 6, 256)) and				// ror :STACKORIGIN+STACKWIDTH*2	; 9
	(copy(listing[i+5], 6, 256) = copy(listing[i+9], 6, 256)) and				// ror :STACKORIGIN+STACKWIDTH		; 10
	(copy(listing[i+7], 6, 256) = copy(listing[i+8], 6, 256)) then 				// ror :STACKORIGIN+9			; 11
       begin

	p:=0;
	while (listing[i+8] = listing[i+8+p*4]) and (listing[i+9] = listing[i+9+p*4]) and
	      (listing[i+10] = listing[i+10+p*4]) and (listing[i+11] = listing[i+11+p*4]) do inc(p);

	listing[i+7+p*4] := listing[i+7];
	dec(p);

	while p>=0 do begin
	 listing[i+7+p*4] := #9'lsr @';
	 listing[i+8+p*4] := #9'ror ' + copy(listing[i+5], 6, 256) ;
	 listing[i+9+p*4] := #9'ror ' + copy(listing[i+3], 6, 256) ;
	 listing[i+10+p*4] := #9'ror ' + copy(listing[i+1], 6, 256) ;
	 dec(p);
	end;

	Result:=false;
       end;


    if lda(i) and 										// lda					; 0
       adc_sbc(i+1) and										// adc|sbc				; 1
       lsr_stack(i+2) and									// lsr :STACKORIGIN+STACKWIDTH*2+9	; 2
       ror_stack(i+3) and									// ror :STACKORIGIN+STACKWIDTH+9	; 3
       ror_stack(i+4) and									// ror :STACKORIGIN+9			; 4
       lda_stack(i+5) then									// lda :STACKORIGIN+9			; 5
     if (copy(listing[i+4], 6, 256) = copy(listing[i+5], 6, 256)) then
     begin
      listing[i]   := '';
      listing[i+1] := '';

      Result:=false;
     end;


    if (listing[i] = #9'lsr @') and 								// lsr @				; 0
       ror_stack(i+1) and									// ror :STACKORIGIN+STACKWIDTH*3	; 1
       ror_stack(i+2) and									// ror :STACKORIGIN+STACKWIDTH*2	; 2
       ror_stack(i+3) and									// ror :STACKORIGIN+STACKWIDTH*1	; 3
       (listing[i+4] = #9'sta #$00') then							// sta #$00				; 4
     begin

	p:=0;
	while (listing[i] = listing[i-p*4]) and (listing[i+1] = listing[i+1-p*4]) and
	      (listing[i+2] = listing[i+2-p*4]) and (listing[i+3] = listing[i+3-p*4]) do inc(p);

	if (pos('lda ', listing[i+3-p*4]) > 0) or (listing[i+3-p*4] = #9'tya') then begin
	 if (pos(',y', listing[i+3-p*4]) > 0) and ((pos('ldy ', listing[i+2-p*4]) > 0) or (listing[i+2-p*4] = #9'iny')) then listing[i+2-p*4]:='';
	 listing[i+3-p*4] := '';
	end;

	dec(p);
	while p>=0 do begin
	 listing[i-p*4] := '';
	 listing[i+1-p*4] := #9'lsr ' + copy(listing[i+1-p*4], 6, 256) ;
	 dec(p);
	end;

	listing[i+4] := '';
	Result:=false;
     end;


    if (listing[i] = #9'lsr @') and 								// lsr @				; 0
       ror_stack(i+1) and									// ror :STACKORIGIN+STACKWIDTH*3	; 1
       ror_stack(i+2) and									// ror :STACKORIGIN+STACKWIDTH*2	; 2
       (listing[i+3] = #9'sta #$00') then							// sta #$00				; 3
     begin

	p:=0;
	while (listing[i] = listing[i-p*3]) and (listing[i+1] = listing[i+1-p*3]) and
	      (listing[i+2] = listing[i+2-p*3]) do inc(p);

	if (pos('lda ', listing[i+2-p*3]) > 0) or (listing[i+2-p*3] = #9'tya') then begin
	 if (pos(',y', listing[i+2-p*3]) > 0) and ((pos('ldy ', listing[i+1-p*3]) > 0) or (listing[i+1-p*3] = #9'iny')) then listing[i+1-p*3]:='';
	 listing[i+2-p*3] := '';
	end;

	dec(p);
	while p>=0 do begin
	 listing[i-p*3] := '';
	 listing[i+1-p*3] := #9'lsr ' + copy(listing[i+1-p*3], 6, 256) ;
	 dec(p);
	end;

	listing[i+3] := '';
	Result:=false;
     end;


    if (listing[i] = #9'lsr @') and 								// lsr @				; 0
       ror_stack(i+1) and									// ror :STACKORIGIN+STACKWIDTH*3	; 1
       (listing[i+2] = #9'sta #$00') then							// sta #$00				; 2
     begin

	p:=0;
	while (listing[i] = listing[i-p*2]) and (listing[i+1] = listing[i+1-p*2]) do inc(p);

	if (pos('lda ', listing[i+1-p*2]) > 0) or (listing[i+1-p*2] = #9'tya') then begin
	 if (pos(',y', listing[i+1-p*2]) > 0) and ((pos('ldy ', listing[i-p*2]) > 0) or (listing[i-p*2] = #9'iny')) then listing[i-p*2]:='';
	 listing[i+1-p*2] := '';
	end;

	dec(p);
	while p>=0 do begin
	 listing[i-p*2] := '';
	 listing[i+1-p*2] := #9'lsr ' + copy(listing[i+1-p*2], 6, 256) ;
	 dec(p);
	end;

	listing[i+2] := '';
	Result:=false;
     end;


    if lda(i) and										// lda					; 0
       sta_stack(i+1) and									// sta :STACKORIGIN			; 1
       lda(i+2) and										// lda					; 2
       sta_stack(i+3) and									// sta :STACKORIGIN+STACKWIDTH		; 3
       lda(i+4) and										// lda					; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH*2	; 5
       lsr_stack(i+6) and									// lsr :STACKORIGIN+STACKWIDTH*2	; 6
       ror_stack(i+7) and									// ror :STACKORIGIN+STACKWIDTH		; 7
       ror_stack(i+8) then									// ror :STACKORIGIN			; 8
     if (copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+7], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+6], 6, 256)) then
     begin
	tmp := listing[i+4];
	listing[i+4] := listing[i];
	listing[i] := tmp;

	tmp := listing[i+5];
	listing[i+5] := listing[i+1];
	listing[i+1] := tmp;

	p:=i+6;
	while (listing[p]=listing[p+3]) and (listing[p+1]=listing[p+4]) and (listing[p+2]=listing[p+5]) do inc(p, 3);

	if (pos('lda :STACK', listing[p+3]) > 0) and
	   (copy(listing[p+2], 6, 256) = copy(listing[p+3], 6, 256)) then begin

		listing[p+3] := '';
		listing[i+5] := '';

		p:=i+6;
		while (listing[p]=listing[p+3]) and (listing[p+1]=listing[p+4]) and (listing[p+2]=listing[p+5]) do begin
		 listing[p+2] := #9'ror @';
		 inc(p, 3);
		end;

		listing[p+2] := #9'ror @';
	end;

	Result:=false;
     end;


    if ldy_im(i) and										// ldy #				; 0
       LDA_BP2_Y(i+1) and									// lda (:bp2),y				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN			; 2
       iny(i+3) and										// iny					; 3
       LDA_BP2_Y(i+4) and									// lda (:bp2),y				; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH		; 5
       iny(i+6) and										// iny					; 6
       LDA_BP2_Y(i+7) and									// lda (:bp2),y				; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2	; 8
       lsr_stack(i+9) and									// lsr :STACKORIGIN+STACKWIDTH*2	; 9
       ror_stack(i+10) and									// ror :STACKORIGIN+STACKWIDTH		; 10
       ror_stack(i+11) then									// ror :STACKORIGIN			; 11
     if (copy(listing[i+2], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+10], 6, 256)) and
	(copy(listing[i+8], 6, 256) = copy(listing[i+9], 6, 256)) then
     begin
	tmp := listing[i+8];
	listing[i+8] := listing[i+2];
	listing[i+2] := tmp;

	listing[i+3] := #9'dey';
	listing[i+6] := #9'dey';

	listing[i] := listing[i] + '+2';

	p:=i+9;
	while (listing[p]=listing[p+3]) and (listing[p+1]=listing[p+4]) and (listing[p+2]=listing[p+5]) do inc(p, 3);

	if (pos('lda :STACK', listing[p+3]) > 0) and
	   (copy(listing[p+2], 6, 256) = copy(listing[p+3], 6, 256)) then begin

		listing[p+3] := '';
		listing[i+8] := '';

		p:=i+9;
		while (listing[p]=listing[p+3]) and (listing[p+1]=listing[p+4]) and (listing[p+2]=listing[p+5]) do begin
		 listing[p+2] := #9'ror @';
		 inc(p, 3);
		end;

		listing[p+2] := #9'ror @';
	end;

	Result:=false;
     end;


    if sta_stack(i) and										// sta :STACKORIGN+STACKWIDTH		; 0
       sty_stack(i+1) and									// sty :STACKORIGIN+STACKWIDTH*2	; 1
       lsr_stack(i+2) and									// lsr :STACKORIGIN+STACKWIDTH*2	; 2
       ror_stack(i+3) and									// ror :STACKORIGIN+STACKWIDTH		; 3
       ror_stack(i+4) and									// ror :STACKORIGIN			; 4
       lda_stack(i+5) and									// lda :STACKORIGIN			; 5
       sta(i+6) and										// sta					; 6
       (lda(i+7) = false) then									// ~lda					; 7
     if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) and
	(copy(listing[i+1], 6, 256) = copy(listing[i+2], 6, 256)) and
	(copy(listing[i+4], 6, 256) = copy(listing[i+5], 6, 256)) then
     begin
	listing[i+1]:='';
	listing[i+2]:='';

	listing[i+3] := #9'lsr ' + copy(listing[i+3], 6, 256);

	Result:=false;
     end;


    if lda(i) and										// lda					; 0
       sta_stack(i+1) and									// sta :STACKORIGIN			; 1
       lda(i+2) and										// lda					; 2
       sta_stack(i+3) and									// sta :STACKORIGIN+STACKWIDTH		; 3
       lsr_stack(i+4) and									// lsr :STACKORIGIN+STACKWIDTH		; 4
       ror_stack(i+5) and									// ror :STACKORIGIN			; 5
       lda_stack(i+6) and									// lda :STACKORIGIN			; 6
       sta(i+7) then										// sta					; 7
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+6], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+4], 6, 256)) then
     begin
	listing[i+1] := listing[i+3];
	listing[i+3] := listing[i];
	listing[i]   := listing[i+2];
	listing[i+2] := '';

	listing[i+5] := #9'ror @';
	listing[i+6] := '';

	Result:=false;
     end;


    if lda(i) and										// lda					; 0
       add_sub(i+1) and										// add|sub				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN			; 2
       lda(i+3) and										// lda					; 3
       adc_sbc(i+4) and										// adc|sbc				; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH		; 5
       lda(i+6) and										// lda					; 6
       adc_sbc(i+7) and										// adc|sbc				; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2	; 8
       lsr_stack(i+9) and									// lsr :STACKORIGIN+STACKWIDTH*2	; 9
       ror_stack(i+10) and									// ror :STACKORIGIN+STACKWIDTH		; 10
       ror_stack(i+11) and									// ror :STACKORIGIN			; 11
       lda_stack(i+12) and									// lda :STACKORIGIN			; 12
       sta(i+13) and										// sta 					; 13
       (lda_stack(i+14) = false) then								// ~lda :STACKORIGIN+STACKWIDTH		; 14
     if (copy(listing[i+2], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+11], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+10], 6, 256)) and
	(copy(listing[i+8], 6, 256) = copy(listing[i+9], 6, 256)) then
     begin
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';

	listing[i+10] := #9'lsr ' + copy(listing[i+10], 6, 256);

	Result:=false;
     end;


    if lda_im_0(i) and										// lda #$00				; 0
       (pos('sta :STACKORIGIN+STACKWIDTH*2', listing[i+1]) > 0) and				// sta :STACKORIGIN+STACKWIDTH*2	; 1
       (listing[i+2] = #9'lsr @') and								// lsr @				; 2
       (pos('ror :STACKORIGIN+STACKWIDTH*2', listing[i+3]) > 0) and				// ror :STACKORIGIN+STACKWIDTH*2	; 3
       ror_stack(i+4) and									// ror :STACKORIGIN+STACKWIDTH		; 4
       ror_stack(i+5) and									// ror :STACKORIGIN			; 5
       sta(i+6) then										// sta					; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then
     begin
	listing[i]   := #9'lsr ' + copy(listing[i+4], 6, 256);
	listing[i+1] := listing[i+5];
	listing[i+2] := #9'lda #$00';
	listing[i+3] := #9'sta ' + copy(listing[i+3], 6, 256);
	listing[i+4] := #9'lda #$00';
	listing[i+5] := listing[i+6];
	listing[i+6] := '';

	Result:=false;
     end;


    if lda_im_0(i) and										// lda #$00				; 0
       (pos('sta :STACKORIGIN+STACKWIDTH*2', listing[i+1]) > 0) and				// sta :STACKORIGIN+STACKWIDTH*2	; 1
       (pos('lsr :STACKORIGIN+STACKWIDTH*2', listing[i+2]) > 0) and				// lsr :STACKORIGIN+STACKWIDTH*2	; 2
       ror_stack(i+3) and									// ror :STACKORIGIN+STACKWIDTH		; 3
       ror_stack(i+4) then									// ror :STACKORIGIN			; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+2], 6, 256)) then
     begin
	listing[i]   := #9'lsr ' + copy(listing[i+3], 6, 256);
	listing[i+1] := listing[i+4];

	listing[i+3] := #9'lda #$00';
	listing[i+4] := #9'sta ' + copy(listing[i+2], 6, 256);

	listing[i+2] := '';

	Result:=false;
     end;


    if (pos('lsr :STACKORIGIN+STACKWIDTH*2', listing[i]) > 0) and				// lsr :STACKORIGIN+STACKWIDTH*2	; 0
       (pos('ror :STACKORIGIN+STACKWIDTH', listing[i+1]) > 0 ) and				// ror :STACKORIGIN+STACKWIDTH		; 1
       (listing[i+2] = #9'ror @') and								// ror @				; 2
       (pos('ora ', listing[i+3]) > 0) and							// ora					; 3
       sta(i+4) and										// sta 					; 4
       (lda(i+5) = false) then									// ~lda 				; 5
     begin
        listing[i]   := '';
	listing[i+1] := #9'lsr ' + copy(listing[i+1], 6, 256);

	Result:=false;
     end;


    if (pos('lsr :STACKORIGIN+STACKWIDTH*2', listing[i]) > 0) and				// lsr :STACKORIGIN+STACKWIDTH*2	; 0
       (pos('ror :STACKORIGIN+STACKWIDTH', listing[i+1]) > 0 ) and				// ror :STACKORIGIN+STACKWIDTH		; 1
       (listing[i+2] = #9'ror @') and								// ror @				; 2
       (pos('lsr :STACKORIGIN+STACKWIDTH', listing[i+3]) > 0 ) and				// lsr :STACKORIGIN+STACKWIDTH		; 3
       (listing[i+4] = #9'ror @') then								// ror @				; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then
     begin
        listing[i]   := '';
	listing[i+1] := #9'lsr ' + copy(listing[i+1], 6, 256);

	Result:=false;
     end;


    if lda(i) and										// lda TEMP				; 0
       (listing[i+1] = #9'lsr @') and								// lsr @				; 1
       (pos('sta ', listing[i+2]) > 0 ) then							// sta TEMP				; 2
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then
     begin
	listing[i] := #9'lsr ' + copy(listing[i], 6, 256);

	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
     end;


// -----------------------------------------------------------------------------
// ===				ASL.					  === //
// -----------------------------------------------------------------------------

    if asl_stack(i) and										// asl :STACKORIGIN+9			; 0
       rol_stack(i+1) and									// rol :STACKORIGIN+STACKWIDTH+9	; 1
       rol_stack(i+2) and									// rol :STACKORIGIN+STACKWIDTH*2+9	; 2
       rol_stack(i+3) and									// rol :STACKORIGIN+STACKWIDTH*3+9	; 3
       lda(i+4) and										// lda					; 4
       add_sub_stack(i+5) and									// add|sub :STACKORIGIN+9		; 5
       sta(i+6) and										// sta					; 6
       lda(i+7) and										// lda					; 7
       adc_sbc(i+8) and										// adc|sbc				; 8
       sta(i+9) and										// sta					; 9
       (lda(i+10) = false) then									// ~lda					; 10
     if (copy(listing[i], 6, 256) = copy(listing[i+5], 6, 256)) then begin

	yes:=(pos(' :STACK', listing[i+8]) > 0);

	k:=i;
	while (listing[i]=listing[k-4]) and (listing[i+1]=listing[k-4+1]) and (listing[i+2]=listing[k-4+2]) and (listing[i+3]=listing[k-4+3]) do begin

	 if not yes then listing[k-4+1] := '';

	 listing[k-4+2] := '';
	 listing[k-4+3] := '';

	 dec(k, 4);
	end;

	if not yes then listing[i+1] := '';

	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if asl_stack(i) and										// asl :STACKORIGIN+9			; 0
       rol_stack(i+1) and									// rol :STACKORIGIN+STACKWIDTH+9	; 1
       rol_stack(i+2) and									// rol :STACKORIGIN+STACKWIDTH*2+9	; 2
       rol_stack(i+3) and									// rol :STACKORIGIN+STACKWIDTH*3+9	; 3
       lda(i+4) and asl_a(i+5) and								// lda					; 4
       tay(i+6) and										// asl @				; 5
       lda_stack(i+7) and									// tay					; 6
       add_sub(i+8) and										// lda :STACKORIGIN+9			; 7
       sta(i+9) and										// add|sub				; 8
       lda(i+10) and										// sta					; 9
       adc_sbc(i+11) and									// lda :STACKORIGIN+STACKWIDTH+9	; 10
       sta(i+12) and										// adc|sbc				; 11
       (lda_stack(i+13) = false) then								// sta					; 12
     if (copy(listing[i], 6, 256) = copy(listing[i+7], 6, 256)) {and
	(copy(listing[i+1], 6, 256) = copy(listing[i+10], 6, 256))} then begin

	yes:=(pos(' :STACK', listing[i+10]) > 0);

	k:=i;
	while (listing[i]=listing[k-4]) and (listing[i+1]=listing[k-4+1]) and (listing[i+2]=listing[k-4+2]) and (listing[i+3]=listing[k-4+3]) do begin

	 if not yes then listing[k-4+1] := '';

	 listing[k-4+2] := '';
	 listing[k-4+3] := '';

	 dec(k, 4);
	end;

	 if not yes then listing[i+1] := '';

	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if asl_stack(i) and										// asl :STACKORIGIN+9			; 0
       rol_stack(i+1) and									// rol :STACKORIGIN+STACKWIDTH+9	; 1
       rol_stack(i+2) and									// rol :STACKORIGIN+STACKWIDTH*2+9	; 2
       rol_stack(i+3) and									// rol :STACKORIGIN+STACKWIDTH*3+9	; 3
       lda_stack(i+4) and									// lda :STACKORIGIN+9			; 4
       sta(i+5) and										// sta					; 5
       lda_stack(i+6) and									// lda :STACKORIGIN+STACKWIDTH+9	; 6
       sta(i+7) and										// sta					; 7
       (lda_stack(i+8) = false)  then								// ~lda :STACKORIGIN+STACKWIDTH*2+9	; 8
     if (copy(listing[i], 6, 256) = copy(listing[i+4], 6, 256)) and
	(copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) then begin

	k:=i;
	while (listing[i]=listing[k-4]) and (listing[i+1]=listing[k-4+1]) and (listing[i+2]=listing[k-4+2]) and (listing[i+3]=listing[k-4+3]) do begin

	 listing[k-4+2] := '';
	 listing[k-4+3] := '';

	 dec(k, 4);
	end;

	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and										// lda					; 0
       add_sub(i+1) and										// sub adr.VEL,y			; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+9			; 2
       lda(i+3) and										// lda					; 3
       adc_sbc(i+4) and										// sbc adr.VEL+1,y			; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and										// lda					; 6
       adc_sbc(i+7) and										// sbc #$00				; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda(i+9) and asl_a(i+10) and								// lda I				; 9
       tay(i+11) and										// asl @				; 10
       lda_stack(i+12) and									// tay					; 11
       add_sub(i+13) and									// lda :STACKORIGIN+9			; 12
       sta(i+14) and										// sub adr.BALL,y			; 13
       lda_stack(i+15) and									// sta T				; 14
       adc_sbc(i+16) and									// lda :STACKORIGIN+STACKWIDTH+9	; 15
       sta(i+17) and										// sbc adr.BALL+1,y			; 16
       (lda_stack(i+18) = false) then								// sta T+1				; 17
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) then begin

	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';

	Result:=false;
       end;


    if asl_stack(i) and										// asl :STACKORIGIN+9			; 0
       rol_stack(i+1) and									// rol :STACKORIGIN+STACKWIDTH+9	; 1
       rol_stack(i+2) and									// rol :STACKORIGIN+STACKWIDTH*2+9	; 2
       rol_stack(i+3) and									// rol :STACKORIGIN+STACKWIDTH*3+9	; 3
       mwa_bp2(i+4) and										// mwa XX bp2				; 4
       ldy(i+5) and										// ldy					; 5
       lda_stack(i+6) and STA_BP2_Y(i+7) and							// lda :STACKORIGIN+9			; 6
       iny(i+8) and										// sta (:bp2),y				; 7
       lda_stack(i+9) and STA_BP2_Y(i+10) and							// iny					; 8
       (iny(i+11) = false) then									// lda :STACKORIGIN+STACKWIDTH+9	; 9
     if (copy(listing[i], 6, 256) = copy(listing[i+6], 6, 256)) and				// sta (:bp2),y				; 10
	(copy(listing[i+1], 6, 256) = copy(listing[i+9], 6, 256)) then begin

	k:=i;
	while (listing[i]=listing[k-4]) and (listing[i+1]=listing[k-4+1]) and (listing[i+2]=listing[k-4+2]) and (listing[i+3]=listing[k-4+3]) do begin

	 listing[k-4+2] := '';
	 listing[k-4+3] := '';

	 dec(k, 4);
	end;

	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if asl_stack(i) and										// asl :STACKORIGIN+9			; 0
       rol_stack(i+1) and									// rol :STACKORIGIN+STACKWIDTH+9	; 1
       rol_stack(i+2) and									// rol :STACKORIGIN+STACKWIDTH*2+9	; 2
       rol_stack(i+3) and									// rol :STACKORIGIN+STACKWIDTH*3+9	; 3
       lda(i+4) and										// lda					; 4
       ADD_SUB_STACK(i+5) and									// add|sub :STACKORIGIN+9		; 5
       sta(i+6) and										// sta					; 6
       (lda(i+7) = false) then									// ~lda					; 7
     if (copy(listing[i], 6, 256) = copy(listing[i+5], 6, 256)) then begin

	k:=i;
	while (listing[i]=listing[k-4]) and (listing[i+1]=listing[k-4+1]) and (listing[i+2]=listing[k-4+2]) and (listing[i+3]=listing[k-4+3]) do begin

	 listing[k-4+1] := '';
	 listing[k-4+2] := '';
	 listing[k-4+3] := '';

	 dec(k, 4);
	end;

	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
     end;


    if lda(i) and										// lda				; 0
       asl_stack(i+1) and									// asl :STACKORIGIN+9		; 1
       lda(i+2) then										// lda				; 2
      begin
	listing[i] := '';

	Result:=false;
      end;


    if sta(i) and (pos('asl ', listing[i+1]) > 0) and						// sta :STACKORIGIN+9		; 0
       (listing[i+2] = #9'sta #$00') then							// asl :STACKORIGIN+9		; 1
      if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) then				// sta #$00			; 2
       begin
	listing[i+1] := listing[i];
	listing[i]   := #9'asl @';
	listing[i+2] := '';
	Result:=false;
       end;


    if sta(i) and (pos('asl ', listing[i+1]) > 0) and						// sta :STACKORIGIN+9		; 0
       (pos('asl ', listing[i+2]) > 0) and							// asl :STACKORIGIN+9		; 1
       (listing[i+3] = #9'sta #$00') then							// asl :STACKORIGIN+9		; 2
      if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) and				// sta #$00			; 3
	 (copy(listing[i+1], 6, 256) = copy(listing[i+2], 6, 256)) then
       begin
	listing[i+2] := listing[i];
	listing[i]   := #9'asl @';
	listing[i+1] := #9'asl @';
	listing[i+3] := '';
	Result:=false;
       end;


    if lda(i) and 										// lda				; 0
       ( lda(i+3) or mwa(i+3) ) and					// sta :STACKORIGIN		; 1
       sta_stack(i+1) and									// asl :STACKORIGIN		; 2
       asl_stack(i+2) then									// lda|mwa			; 3
      if (copy(listing[i+1], 6, 256) = copy(listing[i+2], 6, 256)) then
       begin
	listing[i+2] := listing[i+1];
	listing[i+1] := #9'asl @';
	Result:=false;
       end;


    if sta_stack(i) and										// sta :STACKORIGIN+9		; 0
       lda(i+1) and										// lda				; 1
       adc_sbc(i+2) and										// adc|sbc			; 2
       sta_stack(i+3) and									// sta :STACKORIGIN+STACKWIDTH+9; 3
       asl_stack(i+4) and									// asl :STACKORIGIN+9		; 4
       asl_stack(i+5) then									// asl :STACKORIGIN+9		; 5
      if (copy(listing[i], 6, 256) = copy(listing[i+4], 6, 256)) and
	 (copy(listing[i], 6, 256) = copy(listing[i+5], 6, 256)) then
       begin
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	Result:=false; ;
       end;


    if lda(i) and										// lda U			; 0
       asl_a(i+1) and										// asl @			; 1
       tay(i+2) and										// tay				; 2
       lda(i+5) and										// lda adr.MX,y			; 3
       asl_a(i+6) and										// sta :STACKORIGIN+9		; 4
       tay(i+7) and										// lda U			; 5
       (pos('lda adr.', listing[i+3]) > 0) and							// asl @			; 6
       sta_stack(i+4) and									// tay				; 7
       lda_stack(i+8) and									// lda :STACKORIGIN+9		; 8
       sta(i+10) and										// sub adr.MY,y			; 9
       ((pos('add adr.', listing[i+9]) > 0) or (pos('sub adr.', listing[i+9]) > 0)) then	// sta U			; 10
     if (copy(listing[i+4], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i], 6, 256) = copy(listing[i+5], 6, 256)) then
       begin
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';

	Result:=false;
       end;


// add !!!
    if (listing[i] = #9'sta :eax+1') and							// sta :eax+1			; 0
       (listing[i+1] = #9'asl :eax') and							// asl :eax			; 1
       (listing[i+2] = #9'rol :eax+1') and							// rol :eax+1			; 2
       lda(i+3) and										// lda 				; 3
       (listing[i+4] = #9'add :eax+1') and							// add :eax+1			; 4
       sta(i+5) then										// sta 				; 5
      begin
	listing[i+2] := #9'rol @';
	listing[i+3] := #9'add ' + copy(listing[i+3], 6, 256);
	listing[i+4] := '';

	Result:=false;
      end;


    if lda(i) and										// lda I			; 0
       asl_a(i+1) and										// asl @			; 1
       tay(i+2) and										// tay				; 2
       lda(i+7) and										// lda adr.BALL,y		; 3
       asl_a(i+8) and										// sta :STACKORIGIN+9		; 4
       tay(i+9) and										// lda adr.BALL+1,y		; 5
       (pos('lda adr.', listing[i+3]) > 0) and							// sta :STACKORIGIN+STACKWIDTH+9; 6
       sta_stack(i+4) and									// lda I			; 7
       (pos('lda adr.', listing[i+5]) > 0) and							// asl @			; 8
       sta_stack(i+6) and									// tay				; 9
       lda_stack(i+10) and									// lda :STACKORIGIN+9		; 10
       add_sub(i+11) and									// add adr.VEL,y		; 11
       sta(i+12) and										// sta T			; 12
       lda_stack(i+13) and									// lda :STACKORIGIN+STACKWIDTH+9; 13
       adc_sbc(i+14) and									// adc adr.VEL+1,y		; 14
       sta(i+15) then										// sta T+1			; 15
     if (copy(listing[i+4], 6, 256) = copy(listing[i+10], 6, 256)) and
	(copy(listing[i+6], 6, 256) = copy(listing[i+13], 6, 256)) and
	(copy(listing[i], 6, 256) = copy(listing[i+7], 6, 256)) then
       begin
	listing[i+10] := listing[i+3];
	listing[i+13] := listing[i+5];

	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';

	Result:=false;
       end;


    if lda(i) and lda(i+2) and									// lda I			; 0
       sta_stack(i+1) and sta_stack(i+3) and							// sta :STACKORIGIN+9		; 1
       asl_stack(i+4) and rol_stack(i+5) then							// lda I+1			; 2
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and				// sta :STACKORIGIN+STACKWIDTH+9; 3
	(copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) then				// asl :STACKORIGIN+9		; 4
       begin											// rol :STACKORIGIN+STACKWIDTH+9; 5

	p:=0;
	while (listing[i+4] = listing[i+4+p*2]) and (listing[i+5] = listing[i+5+p*2]) do inc(p);

	yes:=true;										// zamien ':STACKORIGIN+STACKWIDTH+9' na '@'

	if (pos('lda :STACK', listing[i+4+p*2]) > 0) then
	 yes := (copy(listing[i+4+p*2], 6, 256) = copy(listing[i+5], 6, 256))
	else
	if (pos('lda ', listing[i+4+p*2]) > 0) and (pos('add :STACK', listing[i+5+p*2]) > 0) then begin
	 yes := (copy(listing[i+5+p*2], 6, 256) = copy(listing[i+5], 6, 256));

	 tmp:=listing[i+4+p*2];
	 listing[i+4+p*2] := #9'lda ' + copy(listing[i+5+p*2], 6, 256);
	 listing[i+5+p*2] := #9'add ' + copy(tmp, 6, 256);
	end;

	if yes then begin
	 tmp:=copy(listing[i+4], 6, 256);

	 listing[i+3+p*2] := #9'sta ' + copy(listing[i+5], 6, 256);
	 dec(p);
	 while p>=0 do begin
	  listing[i+3+p*2] := #9'asl ' + tmp;
	  listing[i+4+p*2] := #9'rol @';
	  dec(p);
	 end;

	end else begin
	 tmp:=listing[i];
	 listing[i] := listing[i+2];
	 listing[i+2] := tmp;

	 listing[i+1] := listing[i+3];

	 tmp:=copy(listing[i+5], 6, 256);

	 listing[i+3+p*2] := #9'sta ' + copy(listing[i+4], 6, 256);
	 dec(p);
	 while p>=0 do begin
	  listing[i+3+p*2] := #9'asl @';
	  listing[i+4+p*2] := #9'rol ' + tmp;
	  dec(p);
	 end;

	end;

	Result:=false;
       end;


    if asl_stack(i) and										// asl :STACKORIGIN+11			; 0
       rol_a(i+1) and										// rol @				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+STACKWIDTH+11	; 2
       lda_stack(i+3) and									// lda :STACKORIGIN+9			; 3
       add_sub_stack(i+4) and									// add :STACKORIGIN+11			; 4
       sta(i+5) and										// sta YOFF				; 5
       lda_stack(i+6) and									// lda :STACKORIGIN+STACKWIDTH+9	; 6
       adc_sbc_stack(i+7) then									// adc :STACKORIGIN+STACKWIDTH+11	; 7
     if (copy(listing[i], 6, 256) = copy(listing[i+4], 6, 256)) and
	(copy(listing[i+2], 6, 256) = copy(listing[i+7], 6, 256)) then
       begin

	tmp:=copy(listing[i+3], 6, 256);
	p:=i+2;
	yes:=false;
	while p > 0 do begin
	 if copy(listing[p], 6, 256) = tmp then begin yes:=(p>0); Break end;
	 dec(p);
	end;

	if yes then
	 if sta_stack(p) and lda(p-1) and (iy(p-1) = false) then begin
	  listing[i+3] := listing[p-1];

	  Result:=false;
	 end;

	tmp:=copy(listing[i+6], 6, 256);
	p:=i+2;
	yes:=false;
	while p > 0 do begin
	 if copy(listing[p], 6, 256) = tmp then begin yes:=(p>0); Break end;
	 dec(p);
	end;

	if yes then
	 if sta_stack(p) and lda(p-1) and (iy(p-1) = false) then begin
	  listing[i+6] := listing[p-1];

	  Result:=false;
	 end;

       end;


// wspolna procka dla Nx ASL

    if (add_sub(i) or										// add|sub|			; 0
	lda(i) or										// lda|and|ora|eor		; 0
	AND_ORA_EOR(i)) and 									// sta :STACKORIGIN+9		; 1
       sta_stack(i+1) and									// asl :STACKORIGIN+9		; 2
       asl_stack(i+2) then									// lda :STACKORIGIN+9		; 3
     if (copy(listing[i+1], 6, 256) = copy(listing[i+2], 6, 256)) then
       begin

	p:=0;
	while listing[i+2] = listing[i+2+p] do inc(p);

	if (p>0) and (pos('lda ', listing[i+2+p]) > 0) then begin

	   // if (copy(listing[i+2], 6, 256) = copy(listing[i+2+p], 6, 256)) then

	    if p>1 then
	     listing[i+1] := #9':'+IntToStr(p)+' asl @'
	    else
	     listing[i+1] := #9'asl @';

	    tmp := #9'sta ' + copy(listing[i+2], 6, 256);

	    while p>0 do begin
	     dec(p);
	     listing[i+2+p] := '';
	    end;

	    listing[i+2] := tmp;

	   Result := false;
	end;

       end;


    if lda(i) and lda(i+3) and									// lda I			; 0
       asl_a(i+1) and asl_a(i+4) and								// asl @			; 1
       sta_stack(i+2) and tay(i+5) then								// sta :STACKORIGIN+9		; 2
      if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then				// lda 	I			; 3
       begin											// asl @			; 4
	listing[i+2] := '';									// tay				; 5
	listing[i+3] := '';
	listing[i+4] := '';

	Result:=false;
       end;


    if lda(i) and										// lda U			; 0
       asl_a(i+1) and										// asl @			; 1
       tay(i+2) and										// tay				; 2
       lda(i+5) and										// lda adr.MX,y			; 3
       asl_a(i+6) and										// sta :STACKORIGIN+9		; 4
       tay(i+7) and										// lda U			; 5
       (pos('lda adr.', listing[i+3]) > 0) and							// asl @			; 6
       sta_stack(i+4) and									// tay				; 7
       (pos('lda adr.', listing[i+8]) > 0) and							// lda adr.MY,y			; 8
       sta(i+10) and										// add :STACKORIGIN+9		; 9
       add_sub_stack(i+9) then									// sta U			; 10
     if (copy(listing[i+4], 6, 256) = copy(listing[i+9], 6, 256)) and
	(copy(listing[i], 6, 256) = copy(listing[i+5], 6, 256)) then
       begin
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := copy(listing[i+9], 1, 5) + copy(listing[i+8], 6, 256);
	listing[i+9] := '';

	Result:=false;
       end;


    if sta_stack(i) and lda(i+1) and								// sta :STACKORIGIN+10		; 0
       adc_sbc(i+2) and										// lda				; 1
       (asl_stack(i+3) or lsr_stack(i+3)) and							// adc|sbc			; 2
       ((pos('rol ', listing[i+4]) = 0) and (pos('ror ', listing[i+4]) = 0)) then		// asl|lsr :STACKORIGIN+10	; 3
     if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then begin			// <> rol|ror			; 4
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
     end;


    if sta_stack(i) and lda(i+1) and								// sta :STACKORIGIN+STACK	; 0
       adc_sbc(i+2) and										// lda				; 1
       ((pos('asl ', listing[i+3]) > 0) or (pos('lsr ', listing[i+3]) > 0)) and			// adc|sbc			; 2
       (listing[i+4] = #9'sta #$00') and 							// asl|lsr			; 3
       (ror_stack(i+5) or rol_stack(i+5)) then							// sta #$00			; 4
     if (copy(listing[i], 6, 256) = copy(listing[i+5], 6, 256)) then begin			// ror|rol :STACKORIGIN+STACK	; 5
	listing[i+4] := '';

	Result:=false;
     end;


    if (pos('asl :STACKORIGIN', listing[i]) > 0) and						// asl :STACKORIGIN		; 0
       (pos('rol :STACKORIGIN+STACKWIDTH', listing[i+1]) > 0) and				// rol :STACKORIGIN+STACKWIDTH	; 1
       (pos('rol :STACKORIGIN+STACKWIDTH*2', listing[i+2]) > 0) and				// rol :STACKORIGIN+STACKWIDTH*2; 2
       (listing[i+3] = #9'rol #$00')  then							// rol #$00			; 3
     begin
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
     end;


    if asl_stack(i) and (listing[i+1] = #9'rol #$00') then					// asl :STACKORIGIN+9
     begin											// rol #$00
	listing[i+1] := '';

	Result:=false;
     end;


    if rol_stack(i) and (listing[i+1] = #9'rol #$00') then					// rol :STACKORIGIN
     begin											// rol #$00
	listing[i+1] := '';

	Result:=false;
     end;


    if (listing[i] = #9'asl @') and (listing[i+1] = #9'sta #$00') then				// asl @
     begin											// sta #$00
	listing[i+1] := '';

	Result:=false;
     end;


    if sta_stack(i) and										// sta :STACKORIGIN+9		; 0
       asl_stack(i+1) and asl_stack(i+2) and							// asl :STACKORIGIN+9		; 1
       ldy_stack(i+3) then									// asl :STACKORIGIN+9		; 2
     if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) and				// ldy :STACKORIGIN+9		; 3
	(copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and
	(copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then
      begin
	listing[i]   := '';
	listing[i+1] := #9'asl @';
	listing[i+2] := #9'asl @';
	listing[i+3] := #9'tay';

	Result:=false;
      end;


    if sta_stack(i) and lda(i+1) and								// sta :STACKORIGIN+9		; 0
       asl_stack(i+2) and asl_stack(i+3) and							// lda				; 1
       ldy_stack(i+4) then									// asl :STACKORIGIN+9		; 2
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and				// asl :STACKORIGIN+9		; 3
	(copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) and				// ldy :STACKORIGIN+9 | lda	; 4
	(copy(listing[i], 6, 256) = copy(listing[i+4], 6, 256)) then
      begin
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := #9'asl @';
	listing[i+3] := #9'asl @';
	listing[i+4] := #9'tay';

	Result:=false;
      end;


    if sta_stack(i) and asl_stack(i+1) and							// sta :STACKORIGIN+9		; 0
       ldy_stack(i+2) then									// asl :STACKORIGIN+9		; 1
     if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) and				// ldy :STACKORIGIN+9		; 2
	(copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then
      begin
	listing[i]   := '';
	listing[i+1] := #9'asl @';
	listing[i+2] := #9'tay';

	Result:=false;
      end;


    if sta_stack(i) and lda(i+1) and								// sta :STACKORIGIN+9		; 0
       asl_stack(i+2) and ldy_stack(i+3) then							// lda				; 1
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and				// asl :STACKORIGIN+9		; 2
	(copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then				// ldy :STACKORIGIN+9		; 3
      begin
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := #9'asl @';
	listing[i+3] := #9'tay';

	Result:=false;
      end;


    if lda(i) and sta_stack(i+1) and								// lda 				; 0
       lda(i+2) and sta_stack(i+3) and								// sta :STACKORIGIN		; 1
       lda(i+4) and sta_stack(i+5) and								// lda 				; 2
       lda(i+6) and sta_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH	; 3
       asl_stack(i+8) and rol_stack(i+9) and							// lda				; 4
       rol_stack(i+10) and rol_stack(i+11) and							// sta :STACKORIGIN+STACKWIDTH*2; 5
       lda_stack(i+12) and sta(i+13) and							// lda 				; 6
       lda_stack(i+14) and sta(i+15) and							// sta :STACKORIGIN+STACKWIDTH*3; 7
       lda_stack(i+16) and sta(i+17) and							// asl :STACKORIGIN		; 8
       lda_stack(i+18) and sta(i+19) then							// rol :STACKORIGIN+STACKWIDTH	; 9
     if (copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256)) and				// rol :STACKORIGIN+STACKWIDTH*2; 10
	(copy(listing[i+8], 6, 256) = copy(listing[i+12], 6, 256)) and				// rol :STACKORIGIN+STACKWIDTH*3; 11
	(copy(listing[i+3], 6, 256) = copy(listing[i+9], 6, 256)) and				// lda :STACKORIGIN		; 12
	(copy(listing[i+9], 6, 256) = copy(listing[i+14], 6, 256)) and				// sta				; 13
	(copy(listing[i+5], 6, 256) = copy(listing[i+10], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH	; 14
	(copy(listing[i+10], 6, 256) = copy(listing[i+16], 6, 256)) and				// sta 				; 15
	(copy(listing[i+7], 6, 256) = copy(listing[i+11], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH*2; 16
	(copy(listing[i+11], 6, 256) = copy(listing[i+18], 6, 256)) then			// sta 				; 17
     begin											// lda :STACKORIGIN+STACKWIDTH*3; 18
	listing[i+1] := listing[i+13];								// sta				; 19
	listing[i+3] := listing[i+15];
	listing[i+5] := listing[i+17];
	listing[i+7] := listing[i+19];

	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';
	listing[i+15] := '';
	listing[i+16] := '';
	listing[i+17] := '';
	listing[i+18] := '';
	listing[i+19] := '';

	listing[i+8]  := #9'asl ' + copy(listing[i+1], 6, 256);
	listing[i+9]  := #9'rol ' + copy(listing[i+3], 6, 256) ;
	listing[i+10] := #9'rol ' + copy(listing[i+5], 6, 256) ;
	listing[i+11] := #9'rol ' + copy(listing[i+7], 6, 256) ;

      	Result:=false;
     end;


    if (listing[i] = #9'lda :eax') and								// lda :eax			; 0
       sta(i+1) and										// sta B			; 1
       (listing[i+2] = #9'lda :eax+1') and							// lda :eax+1			; 2
       sta(i+3) and										// sta B+1			; 3
       (listing[i+4] = #9'lda :eax+2') and							// lda :eax+2			; 4
       sta(i+5) and										// sta B+2			; 5
       (listing[i+6] = #9'lda :eax+3') and							// lda :eax+3			; 6
       sta(i+7) and										// sta B+3			; 7
       (pos('asl ', listing[i+8]) > 0) and							// asl B			; 8
       (pos('rol ', listing[i+9]) > 0) and							// rol B+1			; 9
       (pos('rol ', listing[i+10]) > 0) and							// rol B+2			; 10
       (pos('rol ', listing[i+11]) > 0) then							// rol B+3			; 11
     if (copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+9], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+10], 6, 256)) and
	(copy(listing[i+7], 6, 256) = copy(listing[i+11], 6, 256)) then
     begin
	listing[i]   := #9'asl :eax';
	listing[i+1] := #9'rol :eax+1';
	listing[i+2] := #9'rol :eax+2';
	listing[i+3] := #9'rol :eax+3';

	listing[i+4] := #9'lda :eax';
	listing[i+5] := #9'sta ' + copy(listing[i+8], 6, 256);
	listing[i+6] := #9'lda :eax+1';
	listing[i+7] := #9'sta ' + copy(listing[i+9], 6, 256);
	listing[i+8] := #9'lda :eax+2';
	listing[i+9] := #9'sta ' + copy(listing[i+10], 6, 256);
	listing[i+10] := #9'lda :eax+3';
	listing[i+11] := #9'sta ' + copy(listing[i+11], 6, 256);

      	Result:=false;
     end;


    if (ldy(i) or tay(i)) and									// tay|ldy A			; 0
       (pos('lda adr.', listing[i+1]) > 0) and							// lda adr.???,y		; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+9		; 2
       (ldy(i+3) or iny(i+3)) and								// iny|ldy B			; 3
       (pos('lda adr.', listing[i+4]) > 0) and							// lda adr.???,y		; 4
       and_ora_eor_stack(i+5) then								// ora|and|eor :STACKORIGIN+9	; 5
     if copy(listing[i+2], 6, 256) = copy(listing[i+5], 6, 256) then
      begin
	listing[i+2] := '';
	listing[i+4] := copy(listing[i+5], 1, 5) + copy(listing[i+4], 6, 256);
	listing[i+5] := '';

	Result:=false;
      end;


    if (ldy(i) or tay(i)) and									// tay|ldy A			; 0
       (pos('lda adr.', listing[i+1]) > 0) and							// lda adr.???,y		; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+9		; 2
       (ldy(i+3) or iny(i+3)) and								// iny|ldy B			; 3
       (pos('lda adr.', listing[i+4]) > 0) and							// lda adr.???,y		; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+10		; 5
       lda_stack(i+6) and									// lda :STACKORIGIN+9		; 6
       and_ora_eor(i+7) then									// ora|and|eor :STACKORIGIN+10	; 7
     if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+7], 6, 256)) then
      begin
	listing[i+2] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+4] := copy(listing[i+7], 1, 5) + copy(listing[i+4], 6, 256);
	listing[i+7] := '';

	Result:=false;
      end;


    if lda(i) and										// lda				; 0
       sta_stack(i+1) and									// sta :STACKORIGIN+9		; 1
       lda(i+2) and (lda_stack(i+2) = false) and						// lda 				; 2
       AND_ORA_EOR_STACK(i+3) then 								// ora|and|eor :STACKORIGIN+9	; 3
       if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then
       begin
	listing[i+3] := copy(listing[i+3], 1, 5) + copy(listing[i], 6, 256);

	listing[i]   := '';
	listing[i+1] := '';
	Result:=false;
       end;


    if (ldy(i) or tay(i)) and									// tay|ldy A			; 0
       (pos('lda adr.', listing[i+1]) > 0) and							// lda adr.???,y		; 1
       sta_stack(i+2) and									// sta :STACKORIGIN		; 2
       (pos('lda adr.', listing[i+3]) > 0) and							// lda adr.???+1,y		; 3
       sta_stack(i+4) and									// sta :STACKORIGIN+STACKWIDTH	; 4
       lda_stack(i+5) and									// lda :STACKORIGIN		; 5
       (add_sub(i+6) or AND_ORA_EOR(i+6)) and							// add|sub|and|ora|eor		; 6
       sta(i+7) and lda_stack(i+8) and								// sta				; 7
       (adc_sbc(i+9) or AND_ORA_EOR(i+9)) then							// lda :STACKORIGIN+STACKWIDTH	; 8
     if (copy(listing[i+2], 6, 256) = copy(listing[i+5], 6, 256)) and				// adc|sbc			; 9
	(copy(listing[i+4], 6, 256) = copy(listing[i+8], 6, 256)) then
      begin
	listing[i+2] := '';
	listing[i+5] := listing[i+1];
	listing[i+8] := listing[i+3];
	listing[i+1] := '';
	listing[i+3] := '';
	listing[i+4] := '';

	Result:=false;
      end;


    if (ldy(i) or										// tay|ldy A				; 0
    	tay(i)) and										// lda adr.???,y			; 1
       (pos('lda adr.', listing[i+1]) > 0) and sta_stack(i+2) and				// sta :STACKORIGIN			; 2
       (pos('lda adr.', listing[i+3]) > 0) and sta_stack(i+4) and				// lda adr.???+1,y			; 3
       lda(i+5) and										// sta :STACKORIGIN+STACKWIDTH		; 4
       add_sub_stack(i+6) and									// lda					; 5
       sta(i+7) and lda(i+8) and								// add|sub :STACKORIGIN			; 6
       adc_sbc_stack(i+9) then									// sta					; 7
     if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and				// lda					; 8
	(copy(listing[i+4], 6, 256) = copy(listing[i+9], 6, 256)) then				// adc|sbc :STACKORIGIN+STAWCKWIDTH	; 9
      begin
	listing[i+2] := '';
	listing[i+6] := copy(listing[i+6], 1, 5) + copy(listing[i+1], 6, 256);
	listing[i+9] := copy(listing[i+9], 1, 5) + copy(listing[i+3], 6, 256);
	listing[i+1] := '';
	listing[i+3] := '';
	listing[i+4] := '';

	Result:=false;
      end;


    if (ldy(i) or tay(i)) and									// tay|ldy A			; 0
       (pos('lda adr.', listing[i+1]) > 0) and							// lda adr.???,y		; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+9		; 2
       (pos('lda adr.', listing[i+3]) > 0) and							// lda adr.???+1,y		; 3
       sta_stack(i+4) and									// sta :STACKORIGIN+10		; 4
       lda_stack(i+5) and									// lda :STACKORIGIN+9		; 5
       add_sub_stack(i+6) and									// add|sub :STACKORIGIN+10	; 6
       sta(i+7) and										// sta				; 7
       (adc_sbc_stack(i+9) = false) then							// ~lda				; 9
     if (copy(listing[i+2], 6, 256) = copy(listing[i+5], 6, 256)) and				// ~adc|sbc			; 10
	(copy(listing[i+4], 6, 256) = copy(listing[i+6], 6, 256)) then
      begin
	listing[i+5] := copy(listing[i+5], 1, 5) + copy(listing[i+1], 6, 256);
	listing[i+6] := copy(listing[i+6], 1, 5) + copy(listing[i+3], 6, 256);
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';

	Result:=false;
      end;


    if lda(i) and sta_stack(i+1) and								// lda				; 0
       lda_stack(i+2) and									// sta :STACKORIGIN+10		; 1
       add_sub_stack(i+3) then									// lda :STACKORIGIN+9		; 2
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then begin			// add|sub :STACKORIGIN+10	; 3
	listing[i+3] := copy(listing[i+3], 1, 5) + copy(listing[i], 6, 256);
	listing[i]   := '';
	listing[i+1] := '';

	Result:=false;
     end;


    if (ldy(i) or tay(i)) and									// tay|ldy B			; 0
       (pos('lda adr.', listing[i+1]) > 0) and							// lda adr.MY,y			; 1
       sta_stack(i+2) and ldy(i+3) and								// sta :STACKORIGIN+9		; 2
       (pos('lda adr.', listing[i+4]) > 0) and tay(i+5) then					// ldy B			; 3
     if (listing[i] = listing[i+3]) and (listing[i+1] = listing[i+4]) then			// lda adr.MY,y			; 4
      begin											// tay				; 5
	listing[i+3] := '';
	listing[i+4] := '';

	Result:=false;
      end;


    if sta_stack(i) and iny(i+1) and								// sta :STACKORIGIN		; 0
       lda_stack(i+2) then									// iny				; 1
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then				// lda :STACKORIGIN		; 2
      begin
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
      end;


    if sta_stack(i) and										// sta :STACKORIGIN+STACKWIDTH+9	; 0
       sty_stack(i+1) and									// sty :STACKORIGIN+STACKWIDTH*2+9	; 1
       sty_stack(i+2) and									// sty :STACKORIGIN+STACKWIDTH*3+9	; 2
       asl_stack(i+3) and									// asl :STACKORIGIN+9			; 3
       rol_stack(i+4) and									// rol :STACKORIGIN+STACKWIDTH+9	; 4
       (rol_stack(i+5) = false) then								// ~rol :STACKORIGIN+STACKWIDTH*2+9	; 5
     if (copy(listing[i], 6, 256) = copy(listing[i+4], 6, 256)) then
      begin
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
      end;


    if lda_im_0(i) and										// lda #$00				; 0
       (listing[i+1] = #9'sta :eax+1') and							// sta :eax+1				; 1
       lda(i+2) and										// lda					; 2
       asl_a(i+3) and										// asl @				; 3
       (listing[i+4] = #9'rol :eax+1') and							// rol :eax+1				; 4
       asl_a(i+5) and										// asl @				; 5
       (listing[i+6] = #9'rol :eax+1') and							// rol :eax+1				; 6
       asl_a(i+7) and										// asl @				; 7
       (listing[i+8] = #9'rol :eax+1') and							// rol :eax+1				; 8
       tay(i+9) then										// tay					; 9
      begin
	listing[i]   := '';
	listing[i+1] := '';

	listing[i+4] := '';
	listing[i+6] := '';
	listing[i+8] := '';

	Result:=false;
      end;


    if lda_im_0(i) and										// lda #$00				; 0
       (listing[i+1] = #9'sta :eax+1') and							// sta :eax+1				; 1
       lda(i+2) and										// lda					; 2
       asl_a(i+3) and										// asl @				; 3
       (listing[i+4] = #9'rol :eax+1') and							// rol :eax+1				; 4
       asl_a(i+5) and										// asl @				; 5
       (listing[i+6] = #9'rol :eax+1') and							// rol :eax+1				; 6
       asl_a(i+7) and										// asl @				; 7
       (listing[i+8] = #9'rol :eax+1') and							// rol :eax+1				; 8
       add_sub(i+9) and										// add|sub				; 9
       tay(i+10) then										// tay					; 10
      begin
	listing[i]   := '';
	listing[i+1] := '';

	listing[i+4] := '';
	listing[i+6] := '';
	listing[i+8] := '';

	Result:=false;
      end;


// -----------------------------------------------------------------------------
// ===			SPL. konwersja liczby ze znakiem	  	  === //
// -----------------------------------------------------------------------------

    if ldy_im_0(i) and lda_im(i+1) and								// ldy #$00		; 0
       spl(i+2) and dey(i+3) then								// lda #$		; 1
     begin											// spl			; 2
	val(copy(listing[i+1], 7, 256), p, err);						// dey			; 3

	listing[i+2] := '';
	listing[i+3] := '';

	if p > 127 then listing[i] := #9'ldy #$FF';

	Result:=false;
     end;


    if ldy_im_0(i) and lda(i+1) and								// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda			; 1
       (listing[i+4] = #9'sty #$00') and							// spl			; 2
       (sta(i+5) = false) then									// dey			; 3
     begin											// sty #$00		; 4
       listing[i]   := '';									// ~sta			; 5

       listing[i+2] := '';
       listing[i+3] := '';
       listing[i+4] := '';

       Result:=false;
     end;


    if sty_stack(i) and										// sty :STACK		; 0
       (listing[i+1] = #9'sty #$00') then							// sty #$00		; 1
     begin
       listing[i+1] := '';

       Result:=false;
     end;


    if ldy_im_0(i) and lda(i+1) and								// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda			; 1
       (pos('sta :STACKORIGIN', listing[i+4]) > 0) and						// spl			; 2
       (listing[i+5] = #9'sty #$00') then							// dey			; 3
     begin											// sta :STACKORIGIN	; 4
       listing[i+5] := '';									// sty #$00		; 5
       err:=0;
       if pos('sty #$00', listing[i+6]) > 0 then begin listing[i+6] := ''; inc(err) end;
       if pos('sty #$00', listing[i+7]) > 0 then begin listing[i+7] := ''; inc(err) end;

       if err = 2 then begin
	listing[i]   := '';
	listing[i+2] := '';
	listing[i+3] := '';
       end;

       Result:=false;
     end;


    if ldy_im_0(i) and lda(i+1) and								// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda			; 1
       (listing[i+4] = #9'sty #$00') and							// spl			; 2
       (pos('sta :STACKORIGIN', listing[i+5]) > 0) then						// dey			; 3
     begin											// sty #$00		; 4
       listing[i]   := '';									// sta :STACKORIGIN	; 5

       listing[i+2] := '';
       listing[i+3] := '';
       listing[i+4] := '';

       Result:=false;
     end;


     if ldy_im_0(i) and lda(i+1) and								// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda A		; 1
       (listing[i+4] = #9'sty #$00') and							// spl			; 2
       add_sub(i+5) then									// dey			; 3
     begin											// sty #$00		; 4
      listing[i]   := '';									// add|sub		; 5

      listing[i+2] := '';
      listing[i+3] := '';
      listing[i+4] := '';

      Result:=false;
     end;


    if ldy_im_0(i) and lda(i+1) and								// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda A		; 1
       (listing[i+4] = #9'sty #$00') and							// spl			; 2
       (lda(i+5) or sta(i+5)) then								// dey			; 3
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) then begin			// sty #$00		; 4
      listing[i]   := '';									// lda|sta A		; 5

      listing[i+2] := '';
      listing[i+3] := '';
      listing[i+4] := '';
      listing[i+5] := '';

      Result:=false;
     end;


    if ldy_im_0(i) and lda(i+1) and								// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda			; 1
       sta(i+4) and (pos('sty ', listing[i+5]) = 0) then					// spl			; 2
     begin											// dey			; 3
	listing[i]   := '';									// sta			; 4
	listing[i+2] := '';									// <> sty		; 5
	listing[i+3] := '';

	Result:=false;
     end;


    if ldy_im_0(i) and lda(i+1) and								// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda			; 1
       (listing[i+4] = #9'sta #$00') then							// spl			; 2
     begin											// dey			; 3
	listing[i]   := '';									// sta #$00		; 4

	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';

	if (pos('sty ', listing[i+5]) > 0) and (pos('sty ', listing[i+6]) > 0) and (pos('sty ', listing[i+7]) > 0) then begin
	 listing[i+5] := '';
	 listing[i+6] := '';
	 listing[i+7] := '';
	end else
	if (pos('sty ', listing[i+5]) > 0) and (pos('sty ', listing[i+6]) > 0) then begin
	 listing[i+5] := '';
	 listing[i+6] := '';
	end else
	if (pos('sty ', listing[i+5]) > 0) then
	 listing[i+5] := '';

	Result:=false;
     end;


    if ldy_im_0(i) and lda(i+1) and								// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda			; 1
       sty_stack(i+4) and (listing[i+5] = #9'sta #$00') then					// spl			; 2
     begin											// dey			; 3
	listing[i+5] := '';									// sty :STACKORIGIN	; 4
	Result:=false; 										// sta #$00		; 5
     end;


    if ldy_im_0(i) and lda_stack(i+1) and							// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda :STACKORIGIN+9	; 1
       sty_stack(i+4) and									// spl			; 2
       (sta_stack(i+5) or lda_stack(i+5)) then							// dey			; 3
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) then begin			// sty :STACKORIGIN+STA	; 4
	listing[i+5] := '';									// lda|sta :STACKORN+9	; 5
	Result:=false;
     end;


    if ldy_im_0(i) and lda_stack(i+1) and							// ldy #$00		; 0
       spl(i+2) and dey(i+3) and								// lda :STACKORIGIN+9	; 1
       lda_stack(i+4) then									// spl			; 2
     if listing[i+1] = listing[i+4] then begin							// dey			; 3
	listing[i]   := '';									// lda :STACKORIGIN+9	; 4
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
     end;


    if sty_stack(i) and add(i+1) and								// sty :STACKORIGIN	; 0
       sta(i+2) and lda_stack(i+3) then								// add			; 1
     if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then begin			// sta			; 2
	listing[i]   := '';									// lda :STACKORIGIN	; 3
	listing[i+3] := #9'tya';

	Result:=false;
     end;


    if sta_stack(i) and ldy_im_0(i+1) and							// sta :STACKORIGIN+STACKWIDTH+9	; 0
       lda_stack(i+2) and									// ldy #$00				; 1
       spl(i+3) and dey(i+4) and								// lda :STACKORIGIN+9			; 2
       sta_stack(i+5) and sty_stack(i+6) then							// spl					; 3
     if (copy(listing[i], 6, 256) = copy(listing[i+6], 6, 256)) and				// dey					; 4
	(copy(listing[i+2], 6, 256) = copy(listing[i+5], 6, 256)) and 				// sta :STACKORIGIN+9			; 5
	(copy(listing[i], 6, 256) <> copy(listing[i+2], 6, 256)) then begin			// sty :STACKORIGIN+STACKWIDTH+9	; 6

	listing[i]  := '';

	Result:=false;
     end;


    if ldy(i) and										// ldy					; 0
       lda(i+1) and										// lda 					; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+STACKWIDTH+9	; 2
       (listing[i+3] = #9'sty #$00') and							// sty #$00				; 3
       (listing[i+4] = #9'sty #$00') then							// sty #$00				; 4
     begin
	listing[i]   := '';
	listing[i+3] := '';
	listing[i+4] := '';

	Result:=false;
     end;


    if lda_im(i) and										// lda #				; 0
       sta_stack(i+1) and									// sta :STACKORIGIN+9			; 1
       lda_im(i+2) and										// lda #				; 2
       sta_stack(i+3) and									// sta :STACKORIGIN+STACKWIDTH+9	; 3
       ldy_im_0(i+4) and									// ldy #$00				; 4
       lda_stack(i+5) and									// lda :STACKORIGIN+9			; 5
       spl(i+6) and dey(i+7) and								// spl					; 6
       sty_stack(i+8) then									// dey					; 7
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and				// sty :STACKORIGIN+STACKWIDTH+9	; 8
	(copy(listing[i+3], 6, 256) = copy(listing[i+8], 6, 256)) then
       begin
	listing[i+4]  := '';
	listing[i+5]  := '';
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';

	Result:=false;
       end;


    if spl(i) and										// spl					; 0
       dey(i+1) and										// dey					; 1
       sty_stack(i+2) and									// sty :STACKORIGIN+STACKWIDTH+9	; 2
       (listing[i+3] = #9'sta :eax') and							// sta :eax				; 3
       lda(i+4) and										// lda 					; 4
       (listing[i+5] = #9'sta :ecx') and							// sta :ecx				; 5
       lda(i+6) and										// lda					; 6
       (listing[i+7] = #9'sta :ecx+1') and							// sta :ecx+1				; 7
       lda_stack(i+8) and									// lda :STACKORIGIN+STACKWIDTH+9	; 8
       (listing[i+9] = #9'sta :eax+1') then							// sta :eax+1				; 9
     if (copy(listing[i+2], 6, 256) = copy(listing[i+8], 6, 256)) then
       begin
	listing[i+2] := #9'sty :eax+1';

	listing[i+8]  := '';
	listing[i+9]  := '';

	Result:=false;
       end;


    if lda(i) and										// lda 					; 0
       sta_stack(i+1) and									// sta :STACKORIGIN+9			; 1
       lda(i+2) and										// lda 					; 2
       sta_stack(i+3) and									// sta :STACKORIGIN+STACKWIDTH+9	; 3
       ldy_im_0(i+4) and									// ldy #$00				; 4
       lda(i+5) and										// lda					; 5
       spl(i+6) and										// spl					; 6
       dey(i+7) and										// dey					; 7
       add_sub_stack(i+8) and									// add|sub :STACKORIGIN+9		; 8
       sta(i+9) and										// sta					; 9
       tya(i+10) and										// tya					; 10
       adc_sbc_stack(i+11) and									// adc|sbc :STACKORIGIN+STACKWIDTH+9	; 11
       sta(i+12) then										// sta :STACKORIGIN+STACKWIDTH+9	; 12
     if (copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+11], 6, 256)) then
       begin

	if pos('add :STACK', listing[i+8]) > 0 then
	 listing[i+8] := #9'add ' + copy(listing[i], 6, 256)
	else
	 listing[i+8] := #9'sub ' + copy(listing[i], 6, 256);

	if pos('adc :STACK', listing[i+11]) > 0 then
	 listing[i+11] := #9'adc ' + copy(listing[i+2], 6, 256)
	else
	 listing[i+11] := #9'sbc ' + copy(listing[i+2], 6, 256);

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if ldy_im_0(i) and										// ldy #$00				; 0
       lda(i+1) and										// lda					; 1
       spl(i+2) and										// spl					; 2
       dey(i+3) and										// dey					; 3
       add_sub(i+4) and										// add|sub				; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+9			; 5
       tya(i+6) and										// tya					; 6
       ldy_stack(i+7) and									// ldy :STACKORIGIN+9			; 7
       (lda(i+8) or mva(i+8)) then								// lda|mva				; 8
     if (copy(listing[i+5], 6, 256) = copy(listing[i+7], 6, 256)) then
       begin
	listing[i] := '';

	listing[i+2] := '';
	listing[i+3] := '';

	listing[i+6] := '';

	Result:=false;
       end;


    if ldy_im_0(i) and										// ldy #$00				; 0
       lda(i+1) and										// lda					; 1
       spl(i+2) and										// spl					; 2
       dey(i+3) and										// dey					; 3
       sty_stack(i+4) and									// sty :STACKORIGIN+STACKWIDTH+10	; 4
       sta(i+5) and										// sta 					; 5
       sta(i+6) and										// sta 					; 6
       lda_stack(i+7) and									// lda :STACKORIGIN+STACKWIDTH+10	; 7
       sta(i+8) and 										// sta 					; 8
       sta(i+9) then 										// sta 					; 9
     if copy(listing[i+4], 6, 256) = copy(listing[i+7], 6, 256) then
     begin
      listing[i+7] := listing[i+6];
      listing[i+6] := listing[i+5];

      listing[i+4] := #9'sty ' + copy(listing[i+8], 6, 256);
      listing[i+5] := #9'sty ' + copy(listing[i+9], 6, 256);

      listing[i+8] := '';
      listing[i+9] := '';

      Result:=false;
     end;


    if sta_stack(i) and										// sta :STACKORIGIN+9			; 0
       lda(i+1) and										// lda					; 1
       adc_sbc(i+2) and										// adc|sbc				; 2
       sta_stack(i+3) and									// sta :STACKORIGIN+STACKWIDTH+9	; 3
       lda(i+4) and										// lda 					; 4
       adc_sbc(i+5) and										// adc|sbc				; 5
       sta_stack(i+6) and									// sta :STACKORIGIN+STACKWIDTH*2+9	; 6
       lda(i+7) and										// lda 					; 7
       adc_sbc(i+8) and										// adc|sbc				; 8
       sta_stack(i+9) and									// sta :STACKORIGIN+STACKWIDTH*3+9	; 9
       ldy_im_0(i+10) and									// ldy #$00				; 10
       lda_stack(i+11) and									// lda :STACKORIGIN+9			; 11
       (listing[i+12] = #9'spl') and dey(i+13) and						// spl					; 12
       sta_stack(i+14) and									// dey					; 13
       sty_stack(i+15) and									// sta :STACKORIGIN+9			; 14
       sty_stack(i+16) and									// sty :STACKORIGIN+STACKWIDTH+9	; 15
       sty_stack(i+17) then									// sty :STACKORIGIN+STACKWIDTH*2+9	; 16
     if (copy(listing[i], 6, 256) = copy(listing[i+11], 6, 256)) and				// sty :STACKORIGIN+STACKWIDTH*3+9	; 17
	(copy(listing[i+11], 6, 256) = copy(listing[i+14], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+6], 6, 256) = copy(listing[i+16], 6, 256)) and
	(copy(listing[i+9], 6, 256) = copy(listing[i+17], 6, 256)) then
       begin
	listing[i+1]  := '';
	listing[i+2]  := '';
	listing[i+3]  := '';
	listing[i+4]  := '';
	listing[i+5]  := '';
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';

	Result:=false;
       end;


    if ldy_im_0(i) and										// ldy #$00				; 0
       lda_stack(i+1) and									// lda :STACKORIGIN+STACKWIDTH+11	; 1
       spl(i+2) and										// spl					; 2
       dey(i+3) and										// dey 					; 3
       sta_stack(i+4) and									// sta :STACKORIGIN+STACKWIDTH+11	; 4
       sty_stack(i+5) and									// sty :STACKORIGIN+STACKWIDTH*2+11	; 5
       sty_stack(i+6) and									// sty :STACKORIGIN+STACKWIDTH*3+11	; 6
       lda(i+7) and										// lda :STACKORIGIN+10			; 7
       add_sub(i+8) and										// add|sub :STACKORIGIN+11		; 8
       sta(i+9) and										// sta 					; 9
       lda(i+10) and										// lda :STACKORIGIN+STACKWIDTH+10	; 10
       adc_sbc(i+11) and									// adc|sbc :STACKORIGIN+STACKWIDTH+11	; 11
       sta(i+12) then										// sta					; 12
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and				// ~lda					; 13
	(copy(listing[i+4], 6, 256) = copy(listing[i+11], 6, 256)) and				// ~adc|sbc :STACKORIGIN+STACKWIDTH*2+11; 14
	(copy(listing[i+5], 6, 256) <> copy(listing[i+14], 6, 256)) then
       begin
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';

	Result:=false;
       end;


// -----------------------------------------------------------------------------
// ===			optymalizacja BP2.				  === //
// -----------------------------------------------------------------------------

    if lda(i) and (lda_stack(i) = false) and							// lda T			; 0
       add_sub(i+1) and										// add|sub			; 1
       tay(i+2) and										// tay				; 2
       lda(i+3) and										// lda T+1			; 3
       (adc_im_0(i+4) or sbc_im_0(i+4)) and							// adc|sbc #$00			; 4
       sta_bp_1(i+5) and									// sta :bp+1			; 5
       LDA_BP_Y(i+6) then									// lda (:bp),y			; 6
       begin
        if (pos('lda <', listing[i]) > 0) and (pos('lda >', listing[i+3]) > 0) then
	 listing[i+4] := #9'mwy #' + copy(listing[i], 7, 256) + ' :bp2'
	else
	 listing[i+4] := #9'mwy ' + copy(listing[i], 6, 256) + ' :bp2';

	listing[i+5] := #9'ldy ' + copy(listing[i+1], 6, 256);
	listing[i+6] := #9'lda (:bp2),y';

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and (lda_stack(i) = false) and							// lda T			; 0
       add_sub(i+1) and										// add|sub			; 1
       tay(i+2) and										// tay				; 2
       lda(i+3) and										// lda T+1			; 3
       (adc_im_0(i+4) or sbc_im_0(i+4)) and							// adc|sbc #$00			; 4
       sta_bp_1(i+5) and									// sta :bp+1			; 5
       lda_stack(i+6) and 									// lda 				; 6
       sta_bp_y(i+7) then 									// sta (:bp),y			; 7
       begin
        if (pos('lda <', listing[i]) > 0) and (pos('lda >', listing[i+3]) > 0) then
	 listing[i+4] := #9'mwy #' + copy(listing[i], 7, 256) + ' :bp2'
	else
	 listing[i+4] := #9'mwy ' + copy(listing[i], 6, 256) + ' :bp2';

	listing[i+5] := #9'ldy ' + copy(listing[i+1], 6, 256);

	listing[i+7] := #9'sta (:bp2),y';

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if sta_stack(i) and										// sta :STACKORIGIN		; 0
       mwy_bp2(i+1) and										// mwy   :bp2			; 1
       ldy(i+2) and										// ldy 				; 2
       lda_stack(i+3) then									// lda STACKORIGIN		; 3
     if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then
       begin
	listing[i]   := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and										// lda				; 0
       mwy_bp2(i+1) and										// mwy   :bp2			; 1
       ldy(i+2) and										// ldy 				; 2
       lda(i+3) then										// lda 				; 3
       begin
	listing[i] := '';

	Result:=false;
       end;


    if lda(i) and										// lda 			; 0
       add_im_0(i+1) and									// add #$00		; 1
       tay(i+2) and 										// tay			; 2
       lda(i+3) and										// lda			; 3
       adc_im_0(i+4) and 									// adc #$00		; 4
       sta_bp_1(i+5) then 									// sta :bp+1		; 5
       begin
	listing[i] := #9'ldy ' + copy(listing[i], 6, 256);
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+4] := '';

	Result:=false;
       end;


    if lda_im(i) and										// lda #		; 0
       sta_bp_1(i+1) and									// sta :bp+1		; 1
       ldy_im(i+2) and 										// ldy #		; 2
       lda(i+3) and										// lda			; 3
       sta_bp_y(i+4) then 									// sta (:bp),y		; 4
       begin
	p := GetWORD(i+2, i);

	listing[i+4] := #9'sta $'+IntToHex(p, 4);

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
       end;


    if (l=4) and
       mwa_bp2(i) and (pos('mwa #', listing[i]) = 0) and					// mwa P0 :bp2		; 0
       ldy_im_0(i+1) and 									// ldy #$00		; 1
       lda(i+2) and										// lda TMP		; 2
       STA_BP2_Y(i+3) then 									// sta (:bp2),y		; 3
       begin
	tmp:=copy(listing[i], 6, pos(' :bp2', listing[i])-6);

	listing[i]   := #9'mva '+tmp+'+1 :bp+1';
	listing[i+1] := #9'ldy '+tmp;
	listing[i+3] := #9'sta (:bp),y';

	Result:=false;
       end;


    if (lda(i) or AND_ORA_EOR(i)) and								// lda|and|ora|eor	; 0
       mwy_bp2(i+1) and	(pos('mwy #', listing[i+1]) = 0) and					// mwy P0 :bp2		; 1
       ldy_im_0(i+2) and 									// ldy #$00		; 2
       STA_BP2_Y(i+3) and  									// sta (:bp2),y		; 3
       (listing[i+4] = '') then									// ~
       begin

        yes:=true;
	for p:=i-1 downto 0 do
	 if copy(listing[p], 6, 256) = copy(listing[i+1], 6, 256) then begin yes:=false; Break end;

	if yes then begin
	 tmp:=copy(listing[i+1], 6, pos(' :bp2', listing[i+1])-6);

	 listing[i+1] := #9'mvy '+tmp+'+1 :bp+1';
	 listing[i+2] := #9'ldy '+tmp;
	 listing[i+3] := #9'sta (:bp),y';

	 Result:=false;
	end;

       end;


    if ((pos('asl ', listing[i]) > 0) or (pos('lsr ', listing[i]) > 0)) and			// asl|lsr		; 0
       mwy_bp2(i+1) and (pos('mwy #', listing[i+1]) = 0) and					// mwy P0 :bp2		; 1
       ldy_im_0(i+2) and 									// ldy #$00		; 2
       STA_BP2_Y(i+3) and  									// sta (:bp2),y		; 3
       (listing[i+4] = '') then									// ~
       begin

        yes:=true;
	for p:=i-1 downto 0 do
	 if copy(listing[p], 6, 256) = copy(listing[i+1], 6, 256) then begin yes:=false; Break end;

	if yes then begin
	 tmp:=copy(listing[i+1], 6, pos(' :bp2', listing[i+1])-6);

	 listing[i+1] := #9'mvy '+tmp+'+1 :bp+1';
	 listing[i+2] := #9'ldy '+tmp;
	 listing[i+3] := #9'sta (:bp),y';

	 Result:=false;
	end;

       end;


    if lda(i) and sta_stack(i+1) and								// lda					; 0
       lda(i+2) and sta_stack(i+3) and								// sta :STACKORIGIN+9			; 1
       mwa_bp2(i+4) and										// lda 					; 2
       ldy_im_0(i+5) and 									// sta :STACKORIGIN+STACKWIDTH+9	; 3
       lda_stack(i+6) and STA_BP2_Y(i+7) and							// mwa X :bp2				; 4
       iny(i+8) and										// ldy #$00				; 5
       lda_stack(i+9) then 									// lda  :STACKORIGIN+9			; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) and				// sta (:bp2),y				; 7
	(copy(listing[i+3], 6, 256) = copy(listing[i+9], 6, 256)) then				// iny					; 8
       begin											// lda :STACKORIGIN+STACKWIDTH+9	; 9
	listing[i+6] := listing[i];
	listing[i+9] := listing[i+2];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and sta_stack(i+1) and								// lda					; 0
       lda(i+2) and sta_stack(i+3) and								// sta :STACKORIGIN+9			; 1
       mwa_bp2(i+4) and										// lda 					; 2
       ldy_im_0(i+5) and 									// sta :STACKORIGIN+STACKWIDTH+9	; 3
       lda_stack(i+6) and									// mwa X :bp2				; 4
       ADD_BP2_Y(i+7) and									// ldy #$00				; 5
       iny(i+8) and										// lda  :STACKORIGIN+9			; 6
       sta(i+9) and 										// add (:bp2),y				; 7
       lda_stack(i+10) and									// iny					; 8
       ADC_BP2_Y(i+11) then									// sta					; 9
     if (copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH+9	; 10
	(copy(listing[i+3], 6, 256) = copy(listing[i+10], 6, 256)) then				// adc (:bp2),y				; 11
       begin
	listing[i+6] := listing[i];
	listing[i+10] := listing[i+2];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and sta_stack(i+1) and								// lda :eax				; 0
       lda(i+2) and sta_stack(i+3) and								// sta :STACKORIGIN+9			; 1
       lda(i+4) and sta_stack(i+5) and								// lda :eax+1				; 2
       lda(i+6) and sta_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH+9	; 3
       mwa_bp2(i+8) and										// lda :eax+2				; 4
       ldy_im_0(i+9) and									// sta :STACKORIGIN+STACKWIDTH*2+9	; 5
       lda_stack(i+10) and									// lda :eax+3				; 6
       ADD_BP2_Y(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+9	; 7
       iny(i+12) and										// mwa BASE :bp2			; 8
       sta(i+13) and										// ldy #$00				; 9
       lda_stack(i+14) and									// lda :STACKORIGIN+9			; 10
       ADC_BP2_Y(i+15) and									// add (:bp2),y				; 11
       sta(i+16) and										// iny					; 12
       lda_stack(i+17) and									// sta LPOS				; 13
       adc(i+18) and										// lda :STACKORIGIN+STACKWIDTH+9	; 14
       sta(i+19) and										// adc (:bp2),y				; 15
       lda_stack(i+20) and									// sta LPOS+1				; 16
       adc(i+21) and										// lda :STACKORIGIN+STACKWIDTH*2+9	; 17
       sta(i+22) then										// adc #$00				; 18
     if (copy(listing[i+1], 6, 256) = copy(listing[i+10], 6, 256)) and				// sta LPOS+2				; 19
	(copy(listing[i+3], 6, 256) = copy(listing[i+14], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH*3+9	; 20
	(copy(listing[i+5], 6, 256) = copy(listing[i+17], 6, 256)) and				// adc #$00				; 21
	(copy(listing[i+7], 6, 256) = copy(listing[i+20], 6, 256)) then				// sta LPOS+3				; 22
       begin
	listing[i+10] := listing[i];
	listing[i+14] := listing[i+2];
	listing[i+17] := listing[i+4];
	listing[i+20] := listing[i+6];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';

	Result:=false;
       end;


    if lda(i) and sta_stack(i+1) and								// lda					; 0
       lda(i+2) and sta_stack(i+3) and								// sta :STACKORIGIN+9			; 1
       mwa_bp2(i+4) and										// lda 					; 2
       ldy_im_0(i+5) and 									// sta :STACKORIGIN+STACKWIDTH+9	; 3
       lda(i+6) and STA_BP2_Y(i+7) and								// mwa X bp2				; 4
       iny(i+8) and										// ldy #$00				; 5
       lda(i+9) and STA_BP2_Y(i+10) and 							// lda					; 6
       iny(i+11) and										// sta (:bp2),y				; 7
       lda_stack(i+12) and STA_BP2_Y(i+13) and 							// iny					; 8
       iny(i+14) and										// lda					; 9
       lda_stack(i+15) and STA_BP2_Y(i+16) then							// sta (:bp2),y				; 10
     if (copy(listing[i+1], 6, 256) = copy(listing[i+12], 6, 256)) and				// iny					; 11
	(copy(listing[i+3], 6, 256) = copy(listing[i+15], 6, 256)) then				// lda :STACKORIGIN+9			; 12
       begin											// sta (:bp2),y				; 13
	listing[i+12] := listing[i];								// iny					; 14
	listing[i+15] := listing[i+2];								// lda :STACKORIGIN+STACKWIDTH+9	; 15

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if ldy_im_0(i) and										// ldy #$00				; 0
       LDA_BP2_Y(i+1) and									// lda (:bp2),y				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN			; 2
       iny(i+3) and										// iny					; 3
       LDA_BP2_Y(i+4) and									// lda (:bp2),y				; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH		; 5
       iny(i+6) and										// iny					; 6
       LDA_BP2_Y(i+7) and									// lda (:bp2),y				; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2	; 8
       iny(i+9) and										// iny					; 9
       LDA_BP2_Y(i+10) and									// lda (:bp2),y				; 10
       sta_stack(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3	; 11
       lda(i+12) and add_sub(i+13) and								// lda SCRL				; 12
       sta(i+14) and										// add|sub :STACKORIGIN			; 13
       lda(i+15) and adc_sbc(i+16) and								// sta X				; 14
       sta(i+17) and										// lda SCRL+1				; 15
       lda(i+18) and adc_sbc(i+19) and								// adc|sbc :STACKORIGIN+STACKWIDTH	; 16
       sta(i+20) and										// sta X+1				; 17
       lda(i+21) and adc_sbc(i+22) and								// lda SCRL+2				; 18
       sta(i+23) then										// adc|sbc :STACKORIGIN+STACKWIDTH*2	; 19
     if (copy(listing[i+2], 6, 256) = copy(listing[i+13], 6, 256)) and				// sta X+2				; 20
	(copy(listing[i+5], 6, 256) = copy(listing[i+16], 6, 256)) and				// lda SCRL+3				; 21
	(copy(listing[i+8], 6, 256) = copy(listing[i+19], 6, 256)) and				// adc|sbc :STACKORIGIN+STACKWIDTH*3	; 22
	(copy(listing[i+11], 6, 256) = copy(listing[i+22], 6, 256)) then			// sta X+3				; 23
       begin
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';
	listing[i+11] := '';

	if pos('add ', listing[i+13]) > 0 then begin
	 listing[i+13] := #9'add (:bp2),y+';
	 listing[i+16] := #9'adc (:bp2),y+';
	 listing[i+19] := #9'adc (:bp2),y+';
	 listing[i+22] := #9'adc (:bp2),y';
	end else begin
	 listing[i+13] := #9'sub (:bp2),y+';
	 listing[i+16] := #9'sbc (:bp2),y+';
	 listing[i+19] := #9'sbc (:bp2),y+';
	 listing[i+22] := #9'sbc (:bp2),y';
	end;

	Result:=false;
       end;


    if lda(i) and add_sub(i+1) and								// lda :STACKORIGIN+10			; 0
       sta(i+2) and										// add :eax				; 1
       lda(i+3) and adc_sbc(i+4) and								// sta :STACKORIGIN+10			; 2
       sta(i+5) and										// lda :STACKORIGIN+STACKWIDTH+10	; 3
       lda(i+6) and adc_sbc(i+7) and								// adc :eax+1				; 4
       sta(i+8) and										// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+9) and adc_sbc(i+10) and								// lda :STACKORIGIN+STACKWIDTH*2+10	; 6
       sta(i+11) and										// adc :eax+2				; 7
       lda(i+12) and add_sub(i+13) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       sta_bp2(i+14) and									// lda :STACKORIGIN+STACKWIDTH*3+10	; 9
       lda(i+15) and adc_sbc(i+16) and								// adc :eax+3				; 10
       sta_bp2_1(i+17) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       ldy_im_0(i+18) and									// lda SINLOGO				; 12
       lda(i+19) and										// add :STACKORIGIN+9			; 13
       STA_BP2_Y(i+20) and									// sta :bp2				; 14
       iny(i+21) and										// lda SINLOGO+1			; 15
       lda(i+22) and										// adc :STACKORIGIN+STACKWIDTH+9	; 16
       STA_BP2_Y(i+23) and									// sta :bp2+1				; 17
       iny(i+24) and										// ldy #$00				; 18
       lda(i+25) and										// lda :STACKORIGIN+10			; 19
       STA_BP2_Y(i+26) and									// sta (:bp2),y				; 20
       iny(i+27) and										// iny					; 21
       lda(i+28) and										// lda :STACKORIGIN+STACKWIDTH+10	; 22
       STA_BP2_Y(i+29) then									// sta (:bp2),y				; 23
     if (copy(listing[i+2], 6, 256) <> copy(listing[i+12], 6, 256)) and				// iny					; 24
	(copy(listing[i+2], 6, 256) <> copy(listing[i+13], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH*2+10	; 25
	(copy(listing[i+2], 6, 256) = copy(listing[i+19], 6, 256)) and				// sta (:bp2),y				; 26
	(copy(listing[i+5], 6, 256) = copy(listing[i+22], 6, 256)) and				// iny					; 27
	(copy(listing[i+8], 6, 256) = copy(listing[i+25], 6, 256)) and				// lda :STACKORIGIN+STACKWIDTH*3+10	; 28
	(copy(listing[i+11], 6, 256) = copy(listing[i+28], 6, 256)) then			// sta (:bp2),y				; 29
       begin
	listing_tmp[0]  := listing[i+12];
	listing_tmp[1]  := listing[i+13];
	listing_tmp[2]  := listing[i+14];
	listing_tmp[3]  := listing[i+15];
	listing_tmp[4]  := listing[i+16];
	listing_tmp[5]  := listing[i+17];

	listing_tmp[6]  := listing[i+18];

	listing_tmp[7]  := listing[i];
	listing_tmp[8]  := listing[i+1];
	listing_tmp[9]  := listing[i+20];

	listing_tmp[10] := listing[i+21];

	listing_tmp[11] := listing[i+3];
	listing_tmp[12] := listing[i+4];
	listing_tmp[13] := listing[i+20];

	listing_tmp[14] := listing[i+21];

	listing_tmp[15] := listing[i+6];
	listing_tmp[16] := listing[i+7];
	listing_tmp[17] := listing[i+20];

	listing_tmp[18] := listing[i+21];

	listing_tmp[19] := listing[i+9];
	listing_tmp[20] := listing[i+10];
	listing_tmp[21] := listing[i+20];

	for p:=0 to 21 do
	 listing[i+p] := listing_tmp[p];

	listing[i+22] := '';
	listing[i+23] := '';
	listing[i+24] := '';
	listing[i+25] := '';
	listing[i+26] := '';
	listing[i+27] := '';
	listing[i+28] := '';
	listing[i+29] := '';

	Result:=false;
       end;


    if lda_im(i) and										// lda #$00				; 0
       sta(i+1) and										// sta :eax				; 1
       lda_im(i+2) and										// lda #$18				; 2
       sta(i+3) and										// sta :eax+1				; 3
       lda_im(i+4) and										// lda #$00				; 4
       sta(i+5) and										// sta :eax+2				; 5
       lda_im(i+6) and										// lda #$00				; 6
       sta(i+7) and										// sta :eax+3				; 7
       lda(i+8) and add_sub(i+9) and								// lda SINSCROL				; 8
       sta_bp2(i+10) and									// add|sub :STACKORIGIN+9		; 9
       lda(i+11) and adc_sbc(i+12) and								// sta :bp2				; 10
       sta_bp2_1(i+13) and									// lda SINSCROL+1			; 11
       ldy_im_0(i+14) and									// adc_sbc :STACKORIGIN+STACKWIDTH+9	; 12
       lda(i+15) and add_sub(i+16) and								// sta :bp2+1				; 13
       STA_BP2_Y(i+17) and									// ldy #$00				; 14
       iny(i+18) and										// lda :STACKORIGIN+10			; 15
       lda(i+19) and adc_sbc(i+20) and								// add|sub :eax				; 16
       STA_BP2_Y(i+21) and									// sta (:bp2),y				; 17
       iny(i+22) and										// iny					; 18
       lda(i+23) and adc_sbc(i+24) and								// lda :STACKORIGIN+STACKWIDTH+10	; 19
       STA_BP2_Y(i+25) and									// adc|sbc :eax+1			; 20
       iny(i+26) and										// sta (:bp2),y				; 21
       lda(i+27) and adc_sbc(i+28) and								// iny					; 22
       STA_BP2_Y(i+29) then									// lda :STACKORIGIN+STACKWIDTH*2+10	; 23
     if (copy(listing[i+1], 6, 256) = copy(listing[i+16], 6, 256)) and				// adc|sbc :eax+2			; 24
	(copy(listing[i+3], 6, 256) = copy(listing[i+20], 6, 256)) and				// sta (:bp2),y				; 25
	(copy(listing[i+5], 6, 256) = copy(listing[i+24], 6, 256)) and				// iny					; 26
	(copy(listing[i+7], 6, 256) = copy(listing[i+28], 6, 256)) then				// lda :STACKORIGIN+STACKWIDTH*3+10	; 27
												// adc|sbc :eax+3			; 28
												// sta (:bp2),y				; 29
       begin
	listing[i+16] := #9'add ' + copy(listing[i], 6, 256);
	listing[i+20] := #9'adc ' + copy(listing[i+2], 6, 256);
	listing[i+24] := #9'adc ' + copy(listing[i+4], 6, 256);
	listing[i+28] := #9'adc ' + copy(listing[i+6], 6, 256);

	listing[i] := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';

	Result:=false;
       end;


    if ldy_im_0(i) and										// ldy #$00				; 0
       LDA_BP2_Y(i+1) and									// lda (:bp2),y				; 1
       sta(i+2) and										// sta :STACKORIGIN+10			; 2
       iny(i+3) and										// iny					; 3
       LDA_BP2_Y(i+4) and									// lda (:bp2),y				; 4
       sta(i+5) and										// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and										// lda OFFSET				; 6
       sta_bp2(i+7) and										// sta :bp2				; 7
       lda(i+8) and										// lda OFFSET+1				; 8
       sta_bp2_1(i+9) and									// sta :bp2+1				; 9
       ldy_im_0(i+10) and									// ldy #$00				; 10
       lda(i+11) and										// lda :STACKORIGIN+10			; 11
       STA_BP2_Y(i+12) and									// sta (:bp2),y				; 12
       iny(i+13) and										// iny					; 13
       lda(i+14) and										// lda :STACKORIGIN+STACKWIDTH+10	; 14
       STA_BP2_Y(i+15) then									// sta (:bp2),y				; 15
     if (copy(listing[i+2], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+14], 6, 256)) then
       begin
	listing[i]   := listing[i+6];
	listing[i+1] := #9'sta :TMP';
	listing[i+2] := listing[i+8];
	listing[i+3] := #9'sta :TMP+1';

	listing[i+4] := #9'ldy #$00';
	listing[i+5] := #9'lda (:bp2),y';
	listing[i+6] := #9'sta (:TMP),y';
	listing[i+7] := #9'iny';
	listing[i+8] := #9'lda (:bp2),y';
	listing[i+9] := #9'sta (:TMP),y';

	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';
	listing[i+15] := '';

	Result:=false;
       end;


    if ldy_im_0(i) and										// ldy #$00				; 0
       LDA_BP2_Y(i+1) and									// lda (:bp2),y				; 1
       sta(i+2) and										// sta :STACKORIGIN+10			; 2
       iny(i+3) and										// iny					; 3
       LDA_BP2_Y(i+4) and									// lda (:bp2),y				; 4
       sta(i+5) and										// sta :STACKORIGIN+STACKWIDTH+10	; 5
       mwa_bp2(i+6) and										// mwa XXX :bp2				; 6
       ldy_im_0(i+7) and									// ldy #$00				; 7
       lda_stack(i+8) and									// lda :STACKORIGIN+10			; 8
       STA_BP2_Y(i+9) and									// sta (:bp2),y				; 9
       iny(i+10) and										// iny					; 10
       lda_im_0(i+11) and									// lda #$00				; 11
       STA_BP2_Y(i+12) then									// sta (:bp2),y				; 12
     if (copy(listing[i+2], 6, 256) = copy(listing[i+8], 6, 256)) then
       begin
	listing[i]   := copy(listing[i+6], 1, pos(':bp2', listing[i+6])) + 'TMP';		// :TMP

	listing[i+1] := #9'ldy #$00';
	listing[i+2] := #9'lda (:bp2),y';
	listing[i+3] := #9'sta (:TMP),y';
	listing[i+4] := #9'iny';
	listing[i+5] := #9'lda #$00';
	listing[i+6] := #9'sta (:TMP),y';

	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';

	Result:=false;
       end;


    if ldy_im_0(i) and										// ldy #$00				; 0
       LDA_BP2_Y(i+1) and									// lda (:bp2),y				; 1
       sta(i+2) and										// sta :STACKORIGIN+10			; 2
       iny(i+3) and										// iny					; 3
       LDA_BP2_Y(i+4) and									// lda (:bp2),y				; 4
       sta(i+5) and										// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and 										// lda OUTCODE				; 6
       add_sub(i+7) and										// add|sub				; 7
       tay(i+8) and										// tay					; 8
       lda(i+9) and 										// lda OUTCODE+1			; 9
       adc_sbc(i+10) and									// adc|sbc				; 10
       sta_bp_1(i+11) and									// sta :bp+1				; 11
       lda(i+12) then 										// lda :STACKORIGIN+10			; 12
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) then
       begin
	listing[i+3]  := '';
	listing[i+4]  := '';
	listing[i+5]  := '';

	Result:=false;
       end;


    if add_sub(i) and									// add|sub				; 0
       sta_bp2(i+1) and									// sta :bp2				; 1
       lda(i+2) and 									// lda 					; 2
       adc_sbc(i+3) and									// adc|sbc				; 3
       sta_bp2_1(i+4) and								// sta :bp2+1				; 4
       ldy_im_0(i+5) and								// ldy #$00				; 5
       LDA_BP2_Y(i+6) and								// lda (:bp2),y				; 6
       sta(i+7) and 									// sta 					; 7
       (listing[i+8] <> #9'iny') then							// ~iny					; 8
      begin
	listing[i+1]  := #9'tay';

	listing[i+4]  := #9'sta :bp+1';
	listing[i+5]  := '';
	listing[i+6]  := #9'lda (:bp),y';

	Result:=false;
      end;


    if ldy_im_0(i) and									// ldy #$00				; 0
       LDA_BP2_Y(i+1) and								// lda (:bp2),y				; 1
       sta(i+2) and									// sta :STACKORIGIN+10			; 2
       iny(i+3) and									// iny					; 3
       LDA_BP2_Y(i+4) and								// lda (:bp2),y				; 4
       sta(i+5) and									// sta :STACKORIGIN+STACKWIDTH+10	; 5
       iny(i+6) and									// iny					; 6
       LDA_BP2_Y(i+7) and								// lda (:bp2),y				; 7
       sta(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       iny(i+9) and									// iny					; 9
       LDA_BP2_Y(i+10) and								// lda (:bp2),y				; 10
       sta(i+11) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       lda(i+12) and									// lda OFFSET				; 12
       add_sub(i+13) and								// add|sub				; 13
       sta_bp2(i+14) and								// sta :bp2				; 14
       lda(i+15) and									// lda OFFSET+1				; 15
       adc_sbc(i+16) and								// add|sub				; 16
       sta_bp2_1(i+17) and								// sta :bp2+1				; 17
       ldy_im_0(i+18) and								// ldy #$00				; 18
       lda(i+19) and									// lda :STACKORIGIN+10			; 19
       STA_BP2_Y(i+20) and								// sta (:bp2),y				; 20
       iny(i+21) and									// iny					; 21
       lda(i+22) and									// lda :STACKORIGIN+STACKWIDTH+10	; 22
       STA_BP2_Y(i+23) and								// sta (:bp2),y				; 23
       iny(i+24) and									// iny					; 24
       lda(i+25) and									// lda :STACKORIGIN+STACKWIDTH*2+10	; 25
       STA_BP2_Y(i+26) and								// sta (:bp2),y				; 26
       iny(i+27) and									// iny					; 27
       lda(i+28) and									// lda :STACKORIGIN+STACKWIDTH*3+10	; 28
       STA_BP2_Y(i+29) then								// sta (:bp2),y				; 29
     if (copy(listing[i+2], 6, 256) = copy(listing[i+19], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+22], 6, 256)) and
	(copy(listing[i+8], 6, 256) = copy(listing[i+25], 6, 256)) and
	(copy(listing[i+11], 6, 256) = copy(listing[i+28], 6, 256)) and

	(copy(listing[i+2], 6, 256) <> copy(listing[i+12], 6, 256)) and
	(copy(listing[i+2], 6, 256) <> copy(listing[i+13], 6, 256)) then
       begin
	listing[i]   := listing[i+12];
	listing[i+1] := listing[i+13];
	listing[i+2] := #9'sta :TMP';
	listing[i+3] := listing[i+15];
	listing[i+4] := listing[i+16];
	listing[i+5] := #9'sta :TMP+1';

	listing[i+6]  := #9'ldy #$00';
	listing[i+7]  := #9'lda (:bp2),y';
	listing[i+8]  := #9'sta (:TMP),y';
	listing[i+9]  := #9'iny';
	listing[i+10] := #9'lda (:bp2),y';
	listing[i+11] := #9'sta (:TMP),y';
	listing[i+12] := #9'iny';
	listing[i+13] := #9'lda (:bp2),y';
	listing[i+14] := #9'sta (:TMP),y';
	listing[i+15] := #9'iny';
	listing[i+16] := #9'lda (:bp2),y';
	listing[i+17] := #9'sta (:TMP),y';

	listing[i+18] := '';
	listing[i+19] := '';
	listing[i+20] := '';
	listing[i+21] := '';
	listing[i+22] := '';
	listing[i+23] := '';
	listing[i+24] := '';
	listing[i+25] := '';
	listing[i+26] := '';
	listing[i+27] := '';
	listing[i+28] := '';
	listing[i+29] := '';

	Result:=false;
       end;


    if lda(i) and									// lda :STACKORIGIN+9			; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda :STACKORIGIN+STACKWIDTH+9	; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda :STACKORIGIN+STACKWIDTH*2+9	; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda(i+9) and									// lda :STACKORIGIN+STACKWIDTH*3+9	; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta_stack(i+11) and								// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
       mwa_bp2(i+12) and								// mwa  :bp2				; 12
       ldy_im(i+13) and									// ldy #				; 13
       lda_stack(i+14) and								// lda :STACKORIGIN+9			; 14
       STA_BP2_Y(i+15) and								// sta (:bp2),y				; 15
       iny(i+16) and									// iny					; 16
       lda_stack(i+17) and								// lda :STACKORIGIN+STACKWIDTH+9	; 17
       STA_BP2_Y(i+18) and								// sta (:bp2),y				; 18
       (iny(i+19) = false) then								// ~ iny				; 19
     if (copy(listing[i+2], 6, 256) = copy(listing[i+14], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+17], 6, 256)) then
       begin
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       mwa_bp2(i+6) and									// mwa  :bp2				; 6
       ldy_im(i+7) and									// ldy #				; 7
       lda_stack(i+8) and								// lda :STACKORIGIN+9			; 8
       STA_BP2_Y(i+9) and								// sta (:bp2),y				; 9
       iny(i+10) and									// iny					; 10
       lda_stack(i+11) and								// lda :STACKORIGIN+STACKWIDTH+9	; 11
       STA_BP2_Y(i+12) then								// sta (:bp2),y				; 12
     if (copy(listing[i+2], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+11], 6, 256)) then
       begin
	btmp[0] := listing[i+6];
	btmp[1] := listing[i+7];
	btmp[2] := listing[i];
	btmp[3] := listing[i+1];
	btmp[4] := listing[i+9];
	btmp[5] := listing[i+10];
	btmp[6] := listing[i+3];
	btmp[7] := listing[i+4];
	btmp[8] := listing[i+9];

	for p:=0 to 8 do listing[i+p]:=btmp[p];

	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+9			; 1
       lda(i+2) and									// lda					; 2
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH+9	; 3
       mwa_bp2(i+4) and									// mwa  :bp2				; 4
       ldy_im(i+5) and									// ldy #				; 5
       LDA_BP2_Y(i+6) and								// lda (:bp2),y				; 6
       sta_stack(i+7) and								// sta :STACKORIGIN+10			; 7
       lda_stack(i+8) and								// lda :STACKORIGIN+STACKWIDTH+9	; 8
       sta_bp_1(i+9) and								// sta :bp+1				; 9
       ldy_stack(i+10) and								// ldy :STACKORIGIN+9			; 10
       lda_stack(i+11) and								// lda :STACKORIGIN+10			; 11
       sta_bp_y(i+12) then								// sta (:bp),y				; 12
     if (copy(listing[i+3], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+1], 6, 256) = copy(listing[i+10], 6, 256)) and
	(copy(listing[i+7], 6, 256) = copy(listing[i+11], 6, 256)) then
       begin
	listing[i+8]  := listing[i+2];
	listing[i+10] := #9'ldy ' + copy(listing[i], 6, 256);

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+9			; 1
       lda(i+2) and									// lda					; 2
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH+9	; 3
       mwa_bp2(i+4) and									// mwa  :bp2				; 4
       ldy_im(i+5) and									// ldy #				; 5
       lda(i+6) and									// lda					; 6
       add_sub_stack(i+7) and								// add|sub :STACKORIGIN+9		; 7
       STA_BP2_Y(i+8) and								// sta (:bp2),y				; 8
       iny(i+9) and									// iny					; 9
       lda(i+10) and									// lda 					; 10
       adc_sbc_stack(i+11) and								// adc|sbc :STACKORIGIN+STACKWIDTH+9	; 11
       STA_BP2_Y(i+12) then								// sta (:bp2),y				; 12
     if (copy(listing[i+1], 6, 256) = copy(listing[i+7], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+11], 6, 256)) then
       begin

	if add_stack(i+7) then
 	 listing[i+7]  := #9'add ' + copy(listing[i], 6, 256)
	else
 	 listing[i+7]  := #9'sub ' + copy(listing[i], 6, 256);

	if adc_stack(i+11) then
 	 listing[i+11]  := #9'adc ' + copy(listing[i+2], 6, 256)
	else
 	 listing[i+11]  := #9'sbc ' + copy(listing[i+2], 6, 256);

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda_im(i) and									// lda #$			; 0
       sta_bp2(i+1) and									// sta :bp2			; 1
       lda_im(i+2) and									// lda #$			; 2
       sta_bp2_1(i+3) and								// sta :bp2+1			; 3
       ldy_im_0(i+4) and								// ldy #$00			; 4
       lda_stack(i+5) and								// lda :STACKORIGIN+10		; 5
       STA_BP2_Y(i+6) and								// sta (:bp2),y			; 6
       iny(i+7) and 									// iny				; 7
       lda_stack(i+8) and								// lda :STACKORIGIN+STACKWIDTH+	; 8
       STA_BP2_Y(i+9) and								// sta (:bp2),y			; 9
       (iny(i+10) = false) then								// ~iny				; 10
       begin
	p:=GetWORD(i, i+2);

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';

	listing[i+6] := #9'sta $' + IntToHex(p, 4);
	listing[i+7] := '';

	listing[i+9] := #9'sta $' + IntToHex(p+1, 4);

	Result:=false;
       end;


    if lda(i) and									// lda T			; 0
       add_sub(i+1) and									// add|sub Q			; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9		; 2
       lda(i+3) and									// lda T+1			; 3
       adc_sbc(i+4) and									// adc|sbc Q+1			; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9; 5
       lda(i+6) and									// lda T			; 6
       add_sub(i+7) and		 							// add|sub Q			; 7
       tay(i+8) and									// tay				; 8
       lda(i+9) and									// lda T+1			; 9
       adc_sbc(i+10) and								// adc|sbc Q+1			; 10
       sta_bp_1(i+11) then								// sta :bp+1			; 11
     if (listing[i] = listing[i+6]) and
        (listing[i+1] = listing[i+7]) and
        (listing[i+3] = listing[i+9]) and
        (listing[i+4] = listing[i+10]) then
       begin
	listing[i+7]  := #9'tay';
	listing[i+8]  := listing[i+3];
	listing[i+9]  := listing[i+4];
	listing[i+10] := listing[i+5];

	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';

	Result:=false;
       end;


    if lda(i) and									// lda T			; 0
       add_sub(i+1) and									// add|sub Q			; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9		; 2
       tay(i+3) and									// tay				; 3
       lda(i+4) and									// lda T+1			; 4
       adc_sbc(i+5) and									// adc|sbc Q+1			; 5
       sta_stack(i+6) and								// sta :STACKORIGIN+STACKWIDTH+9; 6
       sta_bp_1(i+7) and								// sta :bp+1			; 7
       lda_bp_y(i+8) and								// lda (:bp),y			; 8
       and_ora_eor(i+9) and								// ora|and|eor			; 9
       sta_stack(i+10) and								// sta :STACKORIGIN+10		; 10
       lda_stack(i+11) and								// lda :STACKORIGIN+STACKWIDTH+9; 11
       sta_bp_1(i+12) and								// sta :bp+1			; 12
       ldy_stack(i+13) and								// ldy :STACKORIGIN+9		; 13
       lda_stack(i+14) then								// lda :STACKORIGI+10		; 14
     if (copy(listing[i+2], 6, 256) = copy(listing[i+13], 6, 256)) and
	(copy(listing[i+6], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+10], 6, 256) = copy(listing[i+14], 6, 256)) then
       begin
	listing[i+2] := '';
	listing[i+6] := '';

	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';

	Result:=false;
       end;


// -----------------------------------------------------------------------------
// ===			optymalizacja ORA.				  === //
// -----------------------------------------------------------------------------

    if lda(i) and (listing[i+1] = #9'ora #$00') and					// lda			; 0
       sta(i+2) then									// ora #$00		; 1
     begin										// sta			; 2
	listing[i+1] := '';

	Result:=false;
     end;


    if lda_im_0(i) and (pos('ora ', listing[i+1]) > 0) and				// lda #$00		; 0
       sta(i+2) then									// ora 			; 1
     begin										// sta			; 2
	listing[i]   := #9'lda ' + copy(listing[i+1], 6, 256) ;
	listing[i+1] := '';

	Result:=false;
     end;


    if sta_stack(i) and 								// sta :STACKORIGIN+10	; 0
       lda(i+1) and 									// lda 			; 1
       (pos('ora :STACK', listing[i+2]) > 0) then					// ora :STACKORIGIN+10	; 2
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then
       begin
	listing[i] := '';
	listing[i+2] := '';
	listing[i+1] := #9'ora ' + copy(listing[i+1], 6, 256);

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       sta_stack(i+1) and sta_stack(i+2) and						// sta :STACKORIGIN+9			; 1
       lda_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH+9	; 2
       (pos('ora ', listing[i+4]) > 0) and 						// lda :STACKORIGIN+9			; 3
       sta(i+5) and									// ora					; 4
       lda_stack(i+6) and								// sta					; 5
       (pos('ora ', listing[i+7]) > 0) then 						// lda  :STACKORIGIN+STACKWIDTH+9	; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) and			// ora					; 7
	(copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) then
       begin
	listing[i+3] := listing[i];
	listing[i+6] := listing[i];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
       end;


    if lda(i) and									// lda :eax				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+10			; 1
       lda(i+2) and									// lda :eax+1				; 2
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH+10	; 3
       lda(i+4) and									// lda :eax+2				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 5
       lda(i+6) and									// lda :eax+3				; 6
       sta_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH*3+10	; 7
       lda(i+8) and									// lda ERROR				; 8
       (pos('ora :STACK', listing[i+9]) > 0) and					// ora :STACKORIGIN+10			; 9
       sta(i+10) and									// sta ERROR				; 10
       lda(i+11) and									// lda ERROR+1				; 11
       (pos('ora :STACK', listing[i+12]) > 0) and					// ora :STACKORIGIN+STACKWIDTH+10	; 12
       sta(i+13) and									// sta ERROR+1				; 13
       lda(i+14) and									// lda ERROR+2				; 14
       (pos('ora :STACK', listing[i+15]) > 0) and					// ora :STACKORIGIN+STACKWIDTH*2+10	; 15
       sta(i+16) and									// sta ERROR+2				; 16
       lda(i+17) and									// lda ERROR+3				; 17
       (pos('ora :STACK', listing[i+18]) > 0) and					// ora :STACKORIGIN+STACKWIDTH*3+10	; 18
       sta(i+19) then									// sta ERROR+3				; 19
     if (copy(listing[i+1], 6, 256) = copy(listing[i+9], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+7], 6, 256) = copy(listing[i+18], 6, 256)) then
	begin
	listing[i+9]  := #9'ora ' + copy(listing[i], 6, 256);
	listing[i+12] := #9'ora ' + copy(listing[i+2], 6, 256);
	listing[i+15] := #9'ora ' + copy(listing[i+4], 6, 256);
	listing[i+18] := #9'ora ' + copy(listing[i+6], 6, 256);

	listing[i] := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';

	Result:=false;
	end;


    if ldy(i) and									// ldy #$00				; 0
       LDA_BP2_Y(i+1) and								// lda (:bp2),y				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       iny(i+3) and									// iny					; 3
       LDA_BP2_Y(i+4) and								// lda (:bp2),y				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and									// lda :STACKORIGIN+9			; 6
       (pos('ora :STACK', listing[i+7]) > 0) and					// ora :STACKORIGIN+10			; 7
       sta(i+8) and									// sta C				; 8
       lda(i+9) and									// lda :STACKORIGIN+STACKWIDTH+9	; 9
       (pos('ora :STACK', listing[i+10]) > 0) and					// ora :STACKORIGIN+STACKWIDTH+10	; 10
       sta(i+11) then									// sta C+1				; 11
     if (copy(listing[i+2], 6, 256) = copy(listing[i+7], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+10], 6, 256)) and
	(copy(listing[i+2], 6, 256) <> copy(listing[i+6], 6, 256)) and
	(copy(listing[i+5], 6, 256) <> copy(listing[i+9], 6, 256)) then
	begin

	  listing[i+1] := listing[i+6];
	  listing[i+2] := #9'ora (:bp2),y';
	  listing[i+3] := listing[i+8];
	  listing[i+4] := #9'iny';
	  listing[i+5] := listing[i+9];
	  listing[i+6] := #9'ora (:bp2),y';
	  listing[i+7] := listing[i+11];

	  listing[i+8] := '';
	  listing[i+9] := '';
	  listing[i+10] := '';
	  listing[i+11] := '';

	  Result:=false;
	end;


// -----------------------------------------------------------------------------
// ===			optymalizacja EOR.				  === //
// -----------------------------------------------------------------------------

    if lda(i) and sta_stack(i+1) and
       lda(i+2) and sta_stack(i+3) and
       lda(i+4) and sta_stack(i+5) and
       lda(i+6) and sta_stack(i+7) and
       lda(i+8) and (pos('eor :STACK', listing[i+9]) > 0) and sta(i+10) and
       lda(i+11) and (pos('eor :STACK', listing[i+12]) > 0) and sta(i+13) and
       lda(i+14) and (pos('eor :STACK', listing[i+15]) > 0) and sta(i+16) and
       lda(i+17) and (pos('eor :STACK', listing[i+18]) > 0) and sta(i+19) then
     if (copy(listing[i+1], 6, 256) = copy(listing[i+9], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+7], 6, 256) = copy(listing[i+18], 6, 256)) then
	begin
{
	lda :eax			; 0
	sta :STACKORIGIN+10		; 1
	lda :eax+1			; 2
	sta :STACKORIGIN+STACKWIDTH+10	; 3
	lda :eax+2			; 4
	sta :STACKORIGIN+STACKWIDTH*2+10; 5
	lda :eax+3			; 6
	sta :STACKORIGIN+STACKWIDTH*3+10; 7
	lda ERROR			; 8
	eor :STACKORIGIN+10		; 9
	sta ERROR			; 10
	lda ERROR+1			; 11
	eor :STACKORIGIN+STACKWIDTH+10	; 12
	sta ERROR+1			; 13
	lda ERROR+2			; 14
	eor :STACKORIGIN+STACKWIDTH*2+10; 15
	sta ERROR+2			; 16
	lda ERROR+3			; 17
	eor :STACKORIGIN+STACKWIDTH*3+10; 18
	sta ERROR+3			; 19
}
	listing[i+9]  := #9'eor ' + copy(listing[i], 6, 256);
	listing[i+12] := #9'eor ' + copy(listing[i+2], 6, 256);
	listing[i+15] := #9'eor ' + copy(listing[i+4], 6, 256);
	listing[i+18] := #9'eor ' + copy(listing[i+6], 6, 256);

	listing[i] := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';

	Result:=false;
	end;


// -----------------------------------------------------------------------------
// ===			optymalizacja ADD.				  === //
// -----------------------------------------------------------------------------

    if lda(i) and									// lda			; 0
       add(i+1) and									// add			; 1
       sta(i+2) and									// sta			; 2
       lda(i+3) and									// lda			; 3
       adc_im_0(i+4) and								// adc #$00		; 4
       add(i+5) then									// add			; 5
     begin
	listing[i+4] := #9'adc ' + copy(listing[i+5], 6, 256);
	listing[i+5] := '';

	Result:=false;
     end;


    if (l = 3) and lda(i) and (iy(i) = false) and					// lda X 		; 0
       (listing[i+1] = #9'add #$01') and (iy(i) = false) and				// add #$01		; 1
       sta(i+2) and (iy(i+2) = false) then						// sta Y		; 2
     if copy(listing[i], 6, 256) <> copy(listing[i+2], 6, 256) then
     begin
	listing[i]   := #9'ldy '+copy(listing[i], 6, 256);
	listing[i+1] := #9'iny';
	listing[i+2] := #9'sty '+copy(listing[i+2], 6, 256);

	Result:=false;
     end;


    if sta_stack(i) and									// sta :STACKORIGIN+9	; 0
       lda_stack(i+1) and								// lda :STACKORIGIN+10	; 1
       add_stack(i+2) then								// add :STACKORIGIN+9	; 2
     if copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256) then
     begin
	listing[i]   := #9'add ' + copy(listing[i+1], 6, 256);
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
     end;


    if sta_stack(i) and									// sta :STACKORIGIN+9	; 0
       add_stack(i+1) and								// add :STACKORIGIN+9	; 1
       sta(i+2) then									// sta			; 2
     if copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256) then
     begin
	listing[i]   := #9'add ' + copy(listing[i+2], 6, 256);
	listing[i+1] := '';

	Result:=false;
     end;


    if (l = 3) and
       lda(i) and sta(i+2) and								// lda W		; 0
       (listing[i+1] = #9'add #$01') then						// add #$01		; 1
      if copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256) then			// sta W		; 2
       begin
	listing[i]   := #9'inc '+copy(listing[i], 6, 256);
	listing[i+1] := '';
	listing[i+2] := '';

	Result := false;
       end;


    if sta(i) and									// sta :eax		; 0
       lda(i+1) and									// lda			; 1
       (listing[i+2] = #9'add #$01') and						// add #$01		; 2
       add(i+3) and									// add :eax		; 3
       tay(i+4) then									// tay			; 4
      if copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256) then
       begin
	listing[i] := '';

	listing[i+1] := #9'add ' + copy(listing[i+1], 6, 256);
	listing[i+2] := #9'tay';
	listing[i+3] := #9'iny';

	listing[i+4] := '';

	Result := false;
       end;


    if lda(i) and									// lda			; 0
       add_sub(i+1) and 								// add|sub		; 1
       lda(i+2) and									// lda			; 2
       (adc_sbc(i+3) = false) then							// ~adc|sbc		; 3
       begin
	listing[i]   := '';
	listing[i+1] := '';

	Result := false;
       end;


    if (listing[i] = #9'clc') and							// clc			; 0
       lda(i+1) and 									// lda			; 1
       adc(i+2) then									// adc			; 2
       begin
	listing[i]   := '';
	listing[i+2] := #9'add ' + copy(listing[i+2], 6, 256);

	Result := false;
       end;


    if (listing[i] = #9'clc') and							// clc			; 0
       lda(i+1) and									// lda			; 1
       add(i+2) then									// add			; 2
     begin
	listing[i] := '';

	Result:=false;
     end;


    if lda(i) and 									// lda			; 0	!!! zadziala tylko dla ADD|ADC !!!
       add_im_0(i+1) and								// add #$00		; 1
       sta(i+2) and 									// sta			; 2
       lda(i+3) and									// lda			; 3
       adc(i+4) then									// adc			; 4
     begin
      listing[i+1] := '';
      listing[i+4] := #9'add ' + copy(listing[i+4], 6, 256);

      Result:=false;
     end;


    if lda_im_0(i) and									// lda #$00		; 0	!!! zadziala tylko dla ADD|ADC !!!
       add(i+1) and									// add			; 1
       sta(i+2) and									// sta			; 2
       lda(i+3) and 									// lda 			; 3
       adc(i+4) then									// adc			; 4
     begin
	listing[i]   := '';
	listing[i+1] := #9'lda ' + copy(listing[i+1], 6, 256);
	listing[i+4] := #9'add ' + copy(listing[i+4], 6, 256);

	Result:=false;
     end;


    if Result and
       lda(i) and 									// lda			; 0
       add_im_0(i+1) and								// add #$00		; 1
       sta(i+2) and 									// sta			; 2
       (iny(i+3) = false) and								// ~iny			; 3
       (adc(i+4) = false) then								// ~adc			; 4
     begin
      listing[i+1] := '';

      Result:=false;
     end;


    if Result and
       lda_im_0(i) and 									// lda #$00		; 0
       add(i+1) and									// add			; 1
       sta(i+2) and 									// sta			; 2
       (iny(i+3) = false) and								// ~iny			; 3
       (adc(i+4) = false) then								// ~adc			; 4
     begin
      listing[i] := '';
      listing[i+1] := #9'lda ' + copy(listing[i+1], 6, 256);

      Result:=false;
     end;


    if lda(i) and 									// lda 			; 0
       add_im_0(i+1) and								// add #$00		; 1
       sta(i+2) and 									// sta			; 2
       iny(i+3) and									// iny			; 3
       lda(i+4) and									// lda 			; 4
       adc(i+5) then									// adc			; 5
     begin
      listing[i+1] := '';
      listing[i+5] := #9'add ' + copy(listing[i+5], 6, 256);

      Result:=false;
     end;


    if lda_im_0(i) and 									// lda #$00		; 0
       add(i+1) and									// add			; 1
       sta(i+2) and 									// sta			; 2
       iny(i+3) and									// iny			; 3
       lda(i+4) and									// lda 			; 4
       adc(i+5) then									// adc			; 5
     begin
      listing[i]   := '';
      listing[i+1] := #9'lda ' + copy(listing[i+1], 6, 256);
      listing[i+5] := #9'add ' + copy(listing[i+5], 6, 256);

      Result:=false;
     end;


    if sta(i) and									// sta :eax+1				; 0
       lda_stack(i+1) and sta(i+2) and							// lda :STACKORIGIN+9			; 1
       lda(i+3) and									// sta D				; 2
       add(i+4) and									// lda 					; 3
       sta(i+5) and									// add :eax+1				; 4
       (lda(i+6) = false) and								// sta D+1				; 5
       (adc(i+7) = false) then								// ~lda					; 6
     if (copy(listing[i], 6, 256) = copy(listing[i+4], 6, 256)) and			// ~adc					; 7
	(pos(listing[i+2], listing[i+5]) > 0) then					// !!! zadziala tylko dla ADD !!!
       begin
	listing[i] := #9'add ' + copy(listing[i+3], 6, 256);

	listing[i+3] := listing[i+1];
	listing[i+4] := listing[i+2];

	listing[i+1] := listing[i+5];

	listing[i+2] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if sta(i) and									// sta :eax+1				; 0
       lda_stack(i+1) and sta(i+2) and							// lda :STACKORIGIN+9			; 1
       lda(i+3) and									// sta D				; 2
       add_sub(i+4) and									// lda :eax+1				; 3
       sta(i+5) and									// add|sub				; 4
       (lda(i+6) = false) and								// sta D+1				; 5
       (adc_sbc(i+7) = false) then							// ~lda					; 6
     if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) and			// ~adc|sbc				; 7
	(pos(listing[i+2], listing[i+5]) > 0) then
       begin
	listing[i] := listing[i+4];

	listing[i+3] := listing[i+1];
	listing[i+4] := listing[i+2];

	listing[i+1] := listing[i+5];

	listing[i+2] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta(i+5) and									// sta					; 5
       lda(i+6) and									// lda 					; 6
       add_sub_stack(i+7) and								// add|sub :STACKORIGIN+10		; 7
       sta(i+8) and									// sta					; 8
       (lda(i+9) = false) then								// ~lda					; 9
    if (copy(listing[i+2], 6, 256) = copy(listing[i+7], 6, 256)) then
       begin
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta(i+5) and									// sta					; 5
       lda(i+6) and									// lda 					; 6
       add_stack(i+7) and								// add :STACKORIGIN+10			; 7
       sub(i+8) and									// sub					; 8
       sta(i+9) and									// sta					; 9
       (lda(i+10) = false) then								// ~lda					; 10
    if (copy(listing[i+2], 6, 256) = copy(listing[i+7], 6, 256)) then
       begin
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       sta_stack(i+1) and sta_stack(i+2) and						// sta :STACKORIGIN+9			; 1
       lda(i+3) and									// sta :STACKORIGIN+STACKWIDTH+9	; 2
       add_sub_stack(i+4) and								// lda 					; 3
       sta(i+5) and									// add|sub :STACKORIGIN+9		; 4
       lda(i+6) and									// sta					; 5
       adc_sbc_stack(i+7) then								// lda 					; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and			// adc|sbc :STACKORIGIN+STACKWIDTH+9	; 7
	(copy(listing[i+2], 6, 256) = copy(listing[i+7], 6, 256)) then
       begin
	listing[i+4] := copy(listing[i+4], 1, 5) + copy(listing[i], 6, 256);
	listing[i+7] := copy(listing[i+7], 1, 5) + copy(listing[i], 6, 256);

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       sta_stack(i+1) and sta_stack(i+2) and						// sta :STACKORIGIN+9			; 1
       lda_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH+9	; 2
       add_sub(i+4) and 								// lda :STACKORIGIN+9			; 3
       sta(i+5) and									// add|sub				; 4
       lda_stack(i+6) and								// sta					; 5
       adc_sbc(i+7) then 								// lda :STACKORIGIN+STACKWIDTH+9	; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) and			// adc|sbc 				; 7
	(copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) then
       begin
	listing[i+3] := listing[i];
	listing[i+6] := listing[i];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
       end;


    if lda(i) and									// lda				; 0
       add_sub(i+1) and									// add|sub			; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10		; 2
       lda(i+3) and 									// lda				; 3
       adc_sbc(i+4) and									// adc|sbc			; 4
       sta_bp_1(i+5) and								// sta :bp+1			; 5
       ldy_stack(i+6) and 								// ldy :STACKORIGIN+10		; 6
       lda(i+7) and 	 								// lda 				; 7
       sta_bp_y(i+8) then	 							// sta (:bp),y			; 8
     if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) then
       begin
	listing[i+2]  := #9'tay';
	listing[i+6]  := '';

	Result:=false;
       end;


    if lda(i) and									// lda				; 0
       add_sub(i+1) and									// add|sub			; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10		; 2
       lda(i+3) and 									// lda				; 3
       adc_sbc(i+4) and									// adc|sbc			; 4
       sta_bp_1(i+5) and								// sta :bp+1			; 5
       ldy_stack(i+6) and 								// ldy :STACKORIGIN+10		; 6
       lda_bp_y(i+7) then 								// lda (:bp),y			; 7
     if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) then
       begin
	listing[i+2]  := #9'tay';
	listing[i+6]  := '';

	Result:=false;
       end;


    if lda(i) and									// lda GD				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 1
       lda(i+2) and									// lda GD+1				; 2
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH*3+10	; 3
       lda(i+4) and									// lda					; 4
       add_sub(i+5) and									// add|sub				; 5
       sta_stack(i+6) and								// sta :STACKORIGIN+10			; 6
       lda(i+7) and									// lda					; 7
       adc_sbc(i+8) and									// adc|sbc				; 8
       sta_stack(i+9) and								// sta :STACKORIGIN+STACKWIDTH+10	; 9
       lda(i+10) and									// lda :STACKORIGIN+STACKWIDTH*2+10	; 10
       adc_sbc(i+11) and								// adc|sbc				; 11
       sta_stack(i+12) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 12
       lda(i+13) and									// lda :STACKORIGIN+STACKWIDTH*3+10	; 13
       adc_sbc(i+14) and								// adc|sbc				; 14
       sta_stack(i+15) then								// sta :STACKORIGIN+STACKWIDTH*3+10	; 15
     if (copy(listing[i+1], 6, 256) = copy(listing[i+10], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+13], 6, 256)) then
       begin
	listing[i+10] := listing[i];
	listing[i+13] := listing[i+2];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and									// lda P				; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda P+1				; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda_stack(i+9) and								// lda :STACKORIGIN+9			; 9
       add_sub(i+10) and								// add|sub H				; 10
       sta_stack(i+11) and								// sta :STACKORIGIN+9			; 11
       lda_stack(i+12) and								// lda :STACKORIGIN+STACKWIDTH+9	; 12
       adc_sbc(i+13) and								// adc|sbc				; 13
       sta_stack(i+14) and								// sta :STACKORIGIN+STACKWIDTH+9	; 14
       lda_stack(i+15) and								// lda :STACKORIGIN+STACKWIDTH*2+9	; 15
       adc_sbc(i+16) and								// adc|sbc				; 16
       sta_stack(i+17) and								// sta :STACKORIGIN+STACKWIDTH*2+9	; 17
       lda_stack(i+18) and								// lda :STACKORIGIN+STACKWIDTH*3+9	; 18
       adc_sbc(i+19) and								// adc|sbc				; 19
       sta_stack(i+20) then								// sta :STACKORIGIN+STACKWIDTH*3+9	; 20
     if (copy(listing[i+9], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+12], 6, 256) = copy(listing[i+14], 6, 256)) and
	(copy(listing[i+15], 6, 256) = copy(listing[i+17], 6, 256)) and
	(copy(listing[i+18], 6, 256) = copy(listing[i+20], 6, 256)) and
	(listing[i+2] = listing[i+11]) and
	(listing[i+5] = listing[i+14]) and
	(listing[i+8] = listing[i+17]) then
       begin
	listing[i+18] := '';
	listing[i+19] := '';
	listing[i+20] := '';

	Result:=false;
       end;


    if sty_stack(i) and add(i+1) and							// sty :STACKORIGIN+10	; 0
       sta(i+2) and lda(i+3) and							// add			; 1
       adc_stack(i+4) and sta(i+5) then							// sta			; 2
     if (copy(listing[i], 6, 256) = copy(listing[i+4], 6, 256)) then			// lda			; 3
       begin										// adc :STACKORIGIN+10	; 4
											// sta			; 5
	listing[i]   := '';
	listing[i+4] := #9'adc ' + copy(listing[i+3], 6, 256);
	listing[i+3] := #9'tya';

	Result:=false;
       end;


    if lda(i) and									// lda 					; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+10			; 1
       lda(i+2) and									// lda					; 2
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH+10	; 3
       lda_stack(i+4) and								// lda :STACKORIGIN+10			; 4
       add(i+5) and									// add  				; 5
       sta_stack(i+6) then								// sta :STACKORIGIN+10			; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and
	(copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) and
	(copy(listing[i+3], 6, 256) <> copy(listing[i+7], 6, 256)) then
       begin
	listing[i+4] := listing[i];

	listing[i]   := '';
	listing[i+1] := '';

	Result:=false;
       end;


    if lda(i) and									// lda 					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda(i+3) and									// lda 					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda(i+9) and									// lda 					; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta_stack(i+11) and								// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       lda_stack(i+12) and								// lda :STACKORIGIN+10			; 12
       add_sub(i+13) and								// add|sub				; 13
       sta(i+14) and									// sta 					; 14
       lda_stack(i+15) and								// lda :STACKORIGIN+STACKWIDTH+10	; 15
       adc_sbc(i+16) and								// adc|sbc				; 16
       sta(i+17) and									// sta					; 17
       (lda_stack(i+18) = false) and							// ~lda :STACKORIGIN+STACKWIDTH*2+10	; 18
       (adc_sbc(i+19) = false) then							// ~adc|sbc				; 19
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and
        (copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) then
       begin
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and									// lda 					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda(i+3) and									// lda 					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda(i+9) and									// lda 					; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta_stack(i+11) and								// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       lda_stack(i+12) and								// lda :STACKORIGIN+10			; 12
       add_sub(i+13) and								// add|sub				; 13
       sta(i+14) and									// sta 					; 14
       (lda_stack(i+15) = false) and							// ~lda :STACKORIGIN+STACKWIDTH+10	; 15
       (adc_sbc(i+16) = false) then							// ~adc|sbc				; 16
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) then
       begin
	listing[i+3]  := '';
	listing[i+4]  := '';
	listing[i+5]  := '';
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda_stack(i) and									// lda :STACKORIGIN+10			; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda_stack(i+3) and								// lda :STACKORIGIN+STACKWIDTH+10	; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda_stack(i+6) and								// lda :STACKORIGIN+STACKWIDTH*2+10	; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda_stack(i+9) and								// lda :STACKORIGIN+STACKWIDTH*3+10	; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta_stack(i+11) and								// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
       lda(i+12) and sta_bp_1(i+13) and							// lda :STACKORIGIN+STACKWIDTH+9	; 12
       ldy(i+14) and									// sta :bp+1				; 13
       lda_stack(i+15) and sta_bp_y(i+16) then						// ldy :STACKORIGIN+9			; 14
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and			// lda :STACKORIGIN+10			; 15
	(copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) and			// sta (:bp),y				; 16
	(copy(listing[i+6], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+9], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+2], 6, 256) = copy(listing[i+15], 6, 256)) then
       begin
	listing[i+3]  := '';
	listing[i+4]  := '';
	listing[i+5]  := '';
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda_stack(i) and									// lda :STACKORIGIN+9			; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda_stack(i+3) and								// lda :STACKORIGIN+STACKWIDTH+9	; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda_stack(i+6) and								// lda :STACKORIGIN+STACKWIDTH*2+9	; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda_stack(i+9) and								// lda :STACKORIGIN+STACKWIDTH*3+9	; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta_stack(i+11) and								// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
       lda_stack(i+12) and sta_bp_1(i+13) and						// lda :STACKORIGIN+STACKWIDTH+9	; 12
       ldy_stack(i+14) and								// sta :bp+1				; 13
       lda(i+15) and sta_bp_y(i+16) then						// ldy :STACKORIGIN+9			; 14
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and			// lda #$70				; 15
	(copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) and			// sta (:bp),y				; 16
	(copy(listing[i+6], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+9], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+2], 6, 256) = copy(listing[i+14], 6, 256)) then
       begin
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and									// lda P				; 0
       (listing[i+1] = #9'add #$01') and						// add #$01				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+11			; 2
       lda(i+3) and									// lda P+1				; 3
       adc_im_0(i+4) and								// adc #$00				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+11	; 5
       lda(i+6) and add_stack(i+7) and							// lda LEVELDATA			; 6
       tay(i+8) and									// add :STACKORIGIN+11			; 7
       lda(i+9) and adc_stack(i+10) and							// tay					; 8
       sta_bp_1(i+11) then								// lda LEVELDATA+1			; 9
     if (copy(listing[i+2], 6, 256) = copy(listing[i+7], 6, 256)) and			// adc :STACKORIGIN+STACKWIDTH+11	; 10
	(copy(listing[i+5], 6, 256) = copy(listing[i+10], 6, 256)) then			// sta :bp+1				; 11
       begin
	listing[i+7]  := #9'sec:adc ' + copy(listing[i], 6, 256);
	listing[i+10] := #9'adc ' + copy(listing[i+3], 6, 256);

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and sta_stack(i+1) and							// lda XR				; 0
       lda(i+2) and sta_stack(i+3) and							// sta :STACKORIGIN+STACKWIDTH*2+11	; 1
       lda(i+4) and									// lda XR+1				; 2
       sta(i+5) and									// sta :STACKORIGIN+STACKWIDTH*3+11	; 3
       lda(i+6) and									// lda YR				; 4
       sta(i+7) and									// sta 					; 5
       (listing[i+8] = #9'clc') and							// lda YR+1				; 6
       lda(i+9) and									// sta 					; 7
       adc_stack(i+10) and								// clc					; 8
       sta(i+11) and									// lda #$00				; 9
       lda(i+12) and									// adc :STACKORIGIN+STACKWIDTH*2+11	; 10
       adc_stack(i+13) and								// sta					; 11
       sta(i+14) then									// lda #$00				; 12
     if (copy(listing[i+1], 6, 256) = copy(listing[i+10], 6, 256)) and			// adc :STACKORIGIN+STACKWIDTH*3+11	; 13
	(copy(listing[i+3], 6, 256) = copy(listing[i+13], 6, 256)) then			// sta					; 14
       begin
	listing[i+10] := #9'adc ' + copy(listing[i], 6, 256);
	listing[i+13] := #9'adc ' + copy(listing[i+2], 6, 256);

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and									// lda :eax			; 0
       sta_stack(i+1) and								// sta :STACKORIGIN		; 1
       lda(i+2) and									// lda :eax+1			; 2
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH	; 3
       lda(i+4) and									// lda 				; 4
       asl_a(i+5) and									// asl @			; 5
       tay(i+6) and									// tay 				; 6
       lda_stack(i+7) and								// lda :STACKORIGIN		; 7
       add(i+8) and									// add				; 8
       sta(i+9) and									// sta				; 9
       lda_stack(i+10) and								// lda :STACKORIGIN+STACKWIDTH	; 10
       adc(i+11) and									// adc				; 11
       sta(i+12) then									// sta 				; 12
     if (copy(listing[i+1], 6, 256) = copy(listing[i+7], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+10], 6, 256)) then
       begin
        listing[i+7]  := listing[i];
	listing[i+10] := listing[i+2];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+10			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH		; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2	; 8
       lda(i+9) and									// lda					; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta_stack(i+11) and ldy(i+12) and						// sta :STACKORIGIN+STACKWIDTH*3	; 11
       lda_stack(i+13) and (pos('sta adr.', listing[i+14]) > 0) and			// ldy :STACKORIGIN+9			; 12
       lda_stack(i+15) and (pos('sta adr.', listing[i+16]) > 0) and			// lda :STACKORIGIN+10			; 13
       (lda_stack(i+17) = false) then							// sta adr.SPAWNERS,y			; 14
     if (copy(listing[i+2], 6, 256) = copy(listing[i+13], 6, 256)) and			// lda :STACKORIGIN+STACKWIDTH		; 15
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) then			// sta adr.SPAWNERS+1,y			; 16
       begin
	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       ldy_stack(i+6) and								// ldy :STACKORIGIN+9			; 6
       (pos(' adr.', listing[i+7]) > 0) and						// mva V adr.BUF,y			; 7
       (listing[i+8] = '') then
     if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) then
       begin
	listing[i+3]  := '';
	listing[i+4]  := '';
	listing[i+5]  := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda V				; 6
       AND_ORA_EOR(i+7) and								// ora|and|eor				; 7
       ldy_stack(i+8) and								// ldy :STACKORIGIN+9			; 8
       (pos(' adr.', listing[i+9]) > 0) and						// sta adr.BUF,y			; 9
       (listing[i+10] = '') then
     if (copy(listing[i+2], 6, 256) = copy(listing[i+8], 6, 256)) then
       begin
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	listing[i+2] := #9'tay';
	listing[i+8] := '';

	Result:=false;
       end;


    if lda(i) and									// lda					; 0
       add_sub(i+1) and									// add|sub				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda					; 3
       adc_sbc(i+4) and									// adc|sbc				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda					; 6
       adc_sbc(i+7) and									// adc|sbc				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda(i+9) and									// lda					; 9
       adc_sbc(i+10) and								// adc|sbc				; 10
       sta_stack(i+11) and								// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
       lda_stack(i+12) and sta_bp2(i+13) and						// lda :STACKORIGIN+9			; 12
       lda_stack(i+14) and sta_bp2_1(i+15) and						// sta :bp2				; 13
       ldy_im_0(i+16) then								// lda :STACKORIGIN+STACKWIDTH+9	; 14
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and			// sta :bp2+1				; 15
	(copy(listing[i+5], 6, 256) = copy(listing[i+14], 6, 256)) then			// ldy #$00				; 16
       begin
	listing[i+2] := listing[i+13];
	listing[i+5] := listing[i+15];

	listing[i+6]  := '';
	listing[i+7]  := '';
	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';
	listing[i+15] := '';

	Result:=false;
       end;


    if lda(i) and sta_stack(i+1) and							// lda					; 0
       lda(i+2) and sta_stack(i+3) and							// sta :STACKORIGIN+10			; 1
       lda(i+4) and sta_stack(i+5) and							// lda 					; 2
       lda_stack(i+6) and								// sta :STACKORIGIN+STACKWIDTH+10	; 3
       add(i+7) and sta(i+8) and							// lda 					; 4
       lda_stack(i+9) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 5
       adc(i+10) and sta(i+11) and							// lda :STACKORIGIN+10			; 6
       lda_stack(i+12) and								// add					; 7
       adc(i+13) and sta(i+14) then							// sta					; 8
     if (copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) and			// lda :STACKORIGIN+STACKWIDTH+10	; 9
	(copy(listing[i+3], 6, 256) = copy(listing[i+9], 6, 256)) and			// adc 					; 10
	(copy(listing[i+5], 6, 256) = copy(listing[i+12], 6, 256)) then			// sta					; 11
       begin										// lda :STACKORIGIN+STACKWIDTH*2+10	; 12
	listing[i+6]  := listing[i];							// adc					; 13
	listing[i+9]  := listing[i+2];							// sta					; 14
	listing[i+12] := listing[i+4];							// ?lda :STACKORIGIN+STACKWIDTH*3+	; 15
											// ?adc					; 16
	listing[i]   := '';								// ?sta					; 17
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	if (pos('lda :STACKORIGIN+STACKWIDTH*3+', listing[i+15]) > 0) and
	   adc(i+16) and sta(i+17) then
	begin
	 listing[i+15] := '';
	 listing[i+16] := '';
	 listing[i+17] := '';
	end;

	Result:=false;
       end;


    if lda(i) and add_stack(i+1) and							// lda					; 0
       sta_stack(i+2) and								// add :STACKORIGIN+10			; 1
       lda(i+3) and adc_stack(i+4) and							// sta :STACKORIGIN+9			; 2
       sta_stack(i+5) and								// lda					; 3
       mwa_bp2(i+6) and									// adc :STACKORIGIN+STACKWIDTH+10	; 4
       ldy(i+7) and									// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda_stack(i+8) and STA_BP2_Y(i+9) and						// mwa xxx bp2				; 6
       iny(i+10) and									// ldy					; 7
       lda_stack(i+11) and STA_BP2_Y(i+12) then						// lda :STACKORIGIN+9			; 8
     if {(copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and}			// sta (:bp2),y				; 9
	(copy(listing[i+2], 6, 256) = copy(listing[i+8], 6, 256)) and			// iny 					; 10
	{(copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) and}			// lda :STACKORIGIN+STACKWIDTH+9 	; 11
	(copy(listing[i+5], 6, 256) = copy(listing[i+11], 6, 256)) then			// sta (:bp2),y				; 12
       begin

	btmp[0]  := listing[i+6];
	btmp[1]  := listing[i+7];
	btmp[2]  := listing[i];
	btmp[3]  := listing[i+1];
	btmp[4]  := listing[i+9];
	btmp[5]  := listing[i+10];
	btmp[6]  := listing[i+3];
	btmp[7]  := listing[i+4];
	btmp[8]  := listing[i+12];

	listing[i]   := btmp[0];
	listing[i+1] := btmp[1];
	listing[i+2] := btmp[2];
	listing[i+3] := btmp[3];
	listing[i+4] := btmp[4];
	listing[i+5] := btmp[5];
	listing[i+6] := btmp[6];
	listing[i+7] := btmp[7];
	listing[i+8] := btmp[8];

	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';

	Result:=false;
       end;


    if LDA_BP2_Y(i) and sta_stack(i+1) and						// lda (:bp2),y				; 0
       iny(i+2) and									// sta :STACKORIGIN+9			; 1
       LDA_BP2_Y(i+3) and sta_stack(i+4) and						// iny					; 2
       lda(i+5) and add_stack(i+6) and							// lda (:bp2),y				; 3
       sta(i+7) and									// sta :STACKORIGIN+STACKWIDTH+9	; 4
       lda(i+8) and adc_stack(i+9) and							// lda 					; 5
       sta(i+10) then									// add :STACKORIGIN+9			; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) and			// sta					; 7
	(copy(listing[i+4], 6, 256) = copy(listing[i+9], 6, 256)) then			// lda 					; 8
	begin										// adc :STACKORIGIN+STACKWIDTH+9	; 9
	  listing[i]   := '';								// sta					; 10
	  listing[i+1] := '';
	  listing[i+2] := '';
	  listing[i+3] := '';

	  listing[i+4] := listing[i+5];
	  listing[i+5] := #9'add (:bp2),y';
	  listing[i+6] := #9'iny';

	  listing[i+9] := #9'adc (:bp2),y';

	  Result:=false;
	end;


    if LDA_BP2_Y(i) and sta_stack(i+1) and						// lda (:bp2),y				; 0
       iny(i+2) and									// sta :STACKORIGIN+9			; 1
       LDA_BP2_Y(i+3) and sta_stack(i+4) and						// iny					; 2
       lda_stack(i+5) and add(i+6) and							// lda (:bp2),y				; 3
       sta(i+7) and									// sta :STACKORIGIN+STACKWIDTH+9	; 4
       lda_stack(i+8) and adc(i+9) and							// lda :STACKORIGIN+9			; 5
       sta(i+10) then									// add					; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and			// sta					; 7
	(copy(listing[i+4], 6, 256) = copy(listing[i+8], 6, 256)) then			// lda :STACKORIGIN+STACKWIDTH+9	; 8
	begin										// adc					; 9
	  listing[i+1] := '';								// sta					; 10
	  listing[i+3] := '';
	  listing[i+4] := '';
	  listing[i+5] := '';

	  listing[i+8] := listing[i];

	  Result:=false;
	end;


    if lda(i) and									// lda YR				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+10			; 1
       lda(i+2) and									// lda YR+1				; 2
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH+10	; 3
       lda(i+4) and									// lda FLOODFILLSTACK			; 4
       add(i+5) and									// add :STACKORIGIN+9			; 5
       sta_bp2(i+6) and									// sta :bp2				; 6
       lda(i+7) and									// lda FLOODFILLSTACK+1			; 7
       adc(i+8) and									// adc :STACKORIGIN+STACKWIDTH+9	; 8
       sta_bp2_1(i+9) and								// sta :bp2+1				; 9
       ldy_im_0(i+10) and								// ldy #$00				; 10
       lda_stack(i+11) and								// lda :STACKORIGIN+10			; 11
       STA_BP2_Y(i+12) and								// sta (:bp2),y				; 12
       iny(i+13) and									// iny					; 13
       lda_stack(i+14) and								// lda :STACKORIGIN+STACKWIDTH+10	; 14
       STA_BP2_Y(i+15) then								// sta (:bp2),y				; 15
     if (copy(listing[i+1], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+14], 6, 256)) then
       begin
	listing[i+11] := listing[i];
	listing[i+14] := listing[i+2];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and									// lda XR				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 1
       lda(i+2) and									// lda XR+1				; 2
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH*3+10	; 3
       lda(i+4) and									// lda FLOODFILLSTACK			; 4
       add(i+5) and									// add :STACKORIGIN+9			; 5
       sta_bp2(i+6) and									// sta :bp2				; 6
       lda(i+7) and									// lda FLOODFILLSTACK+1			; 7
       adc(i+8) and									// adc :STACKORIGIN+STACKWIDTH+9	; 8
       sta_bp2_1(i+9) and								// sta :bp2+1				; 9
       ldy_im_0(i+10) and								// ldy #$00				; 10
       lda(i+11) and									// lda YR				; 11
       STA_BP2_Y(i+12) and								// sta (:bp2),y				; 12
       iny(i+13) and									// iny					; 13
       lda(i+14) and									// lda YR+1				; 14
       STA_BP2_Y(i+15) and								// sta (:bp2),y				; 15
       iny(i+16) and									// iny					; 16
       lda_stack(i+17) and								// lda :STACKORIGIN+STACKWIDTH*2+10	; 17
       STA_BP2_Y(i+18) and								// sta (:bp2),y				; 18
       iny(i+19) and									// iny					; 19
       lda_stack(i+20) and								// lda :STACKORIGIN+STACKWIDTH*3+10	; 20
       STA_BP2_Y(i+21) then								// sta (:bp2),y				; 21
     if (copy(listing[i+1], 6, 256) = copy(listing[i+17], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+20], 6, 256)) then
	begin
	listing[i+17] := listing[i];
	listing[i+20] := listing[i+2];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
	end;


    if mwa_bp2(i) and									// mwa ...	:bp2			; 0
       ldy(i+1) and									// ldy #$05				; 1
       LDA_BP2_Y(i+2) and								// lda (:bp2),y				; 2
       iny(i+3) and									// iny					; 3
       add_sub(i+4) and									// add #$01				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+9			; 5
       LDA_BP2_Y(i+6) and								// lda (:bp2),y				; 6
       adc_sbc(i+7) and									// adc #$00				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH+9	; 8
       mwa_bp2(i+9) and									// mwa ...	:bp2			; 9
       ldy(i+10) and									// ldy #$05				; 10
       lda_stack(i+11) and								// lda :STACKORIGIN+9			; 11
       STA_BP2_Y(i+12) and								// sta (:bp2),y				; 12
       iny(i+13) and									// iny					; 13
       lda_stack(i+14) and								// lda :STACKORIGIN+STACKWIDTH+9	; 14
       STA_BP2_Y(i+15) then								// sta (:bp2),y				; 15
     if (listing[i] = listing[i+9]) and
     	(listing[i+1] = listing[i+10]) and
     	(copy(listing[i+5], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+8], 6, 256) = copy(listing[i+14], 6, 256)) then
       begin
	listing[i+3] := listing[i+4];
	listing[i+4] := listing[i+12];
	listing[i+5] := listing[i+13];

	listing[i+8] := listing[i+12];

	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';
	listing[i+15] := '';

	Result:=false;
       end;


    if lda(i) and									// lda :eax				; 0
       sta(i+1) and									// sta :STACKORIGIN+10			; 1
       lda(i+2) and									// lda :eax+1				; 2
       sta(i+3) and									// sta :STACKORIGIN+STACKWIDTH+10	; 3
       lda(i+4) and									// lda :eax+2				; 4
       sta(i+5) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 5
       lda(i+6) and									// lda :eax+3				; 6
       sta(i+7) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 7
       lda(i+8) and									// lda ERROR				; 8
       add(i+9) and									// add :STACKORIGIN+10			; 9
       sta(i+10) and									// sta ERROR				; 10
       lda(i+11) and									// lda ERROR+1				; 11
       adc(i+12) and									// adc :STACKORIGIN+STACKWIDTH+10	; 12
       sta(i+13) and									// sta ERROR+1				; 13
       lda(i+14) and									// lda ERROR+2				; 14
       adc(i+15) and									// adc :STACKORIGIN+STACKWIDTH*2+10	; 15
       sta(i+16) and									// sta ERROR+2				; 16
       lda(i+17) and									// lda ERROR+3				; 17
       adc(i+18) and									// adc :STACKORIGIN+STACKWIDTH*3+10	; 18
       sta(i+19) then									// sta ERROR+3				; 19
     if (copy(listing[i+1], 6, 256) = copy(listing[i+9], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+7], 6, 256) = copy(listing[i+18], 6, 256)) then
	begin
	listing[i+9]  := #9'add ' + copy(listing[i], 6, 256);
	listing[i+12] := #9'adc ' + copy(listing[i+2], 6, 256);
	listing[i+15] := #9'adc ' + copy(listing[i+4], 6, 256);
	listing[i+18] := #9'adc ' + copy(listing[i+6], 6, 256);

	listing[i] := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';

	Result:=false;
	end;


    if lda(i) and									// lda :eax				; 0
       sta(i+1) and									// sta :STACKORIGIN+10			; 1
       lda(i+2) and									// lda :eax+1				; 2
       sta(i+3) and									// sta :STACKORIGIN+STACKWIDTH+10	; 3
       lda(i+4) and									// lda :eax+2				; 4
       sta(i+5) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 5
       sta(i+6) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 6
       lda(i+7) and									// lda ERROR				; 7
       add(i+8) and									// add :STACKORIGIN+10			; 8
       sta(i+9) and									// sta ERROR				; 9
       lda(i+10) and									// lda ERROR+1				; 10
       adc(i+11) and									// adc :STACKORIGIN+STACKWIDTH+10	; 11
       sta(i+12) and									// sta ERROR+1				; 12
       lda(i+13) and									// lda ERROR+2				; 13
       adc(i+14) and									// adc :STACKORIGIN+STACKWIDTH*2+10	; 14
       sta(i+15) and									// sta ERROR+2				; 15
       lda(i+16) and									// lda ERROR+3				; 16
       adc(i+17) and									// adc :STACKORIGIN+STACKWIDTH*3+10	; 17
       sta(i+18) then									// sta ERROR+3				; 18
     if (copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+14], 6, 256)) and
	(copy(listing[i+6], 6, 256) = copy(listing[i+17], 6, 256)) then
	begin
	listing[i+8]  := #9'add ' + copy(listing[i], 6, 256);
	listing[i+11] := #9'adc ' + copy(listing[i+2], 6, 256);
	listing[i+14] := #9'adc ' + copy(listing[i+4], 6, 256);
	listing[i+17] := #9'adc ' + copy(listing[i+4], 6, 256);

	listing[i] := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';

	Result:=false;
	end;


    if lda(i) and									// lda #$00				; 0
       (listing[i+1] = #9'sta :eax+2') and						// sta :eax+2				; 1
       lda(i+2) and									// lda #$00				; 2
       (listing[i+3] = #9'sta :eax+3') and						// sta :eax+3				; 3
       lda(i+4) and									// lda #$80				; 4
       (listing[i+5] = #9'add :eax') and						// add :eax				; 5
       sta(i+6) and									// sta W				; 6
       lda(i+7) and									// lda #$B0				; 7
       (listing[i+8] = #9'adc :eax+1') and						// adc :eax+1				; 8
       sta(i+9) and									// sta W+1				; 9
       (lda(i+10) = false) and								// ~lda					; 10
       (pos('adc ', listing[i+11]) = 0) then						// ~adc					; 11
       begin
	listing[i] := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
       end;


    if lda(i) and									// lda :eax				; 0
       sta_stack(i+1) and								// sta :STACKORIGIN+10			; 1
       lda(i+2) and									// lda :eax+1				; 2
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH+10	; 3
       lda(i+4) and									// lda :eax+2				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 5
       lda(i+6) and									// lda :eax+3				; 6
       sta_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH*3+10	; 7
       lda_stack(i+8) and								// lda :STACKORIGIN+10			; 8
       add(i+9) and									// add 					; 9
       sta(i+10) and									// sta ERROR				; 10
       lda_stack(i+11) and								// lda :STACKORIGIN+STACKWIDTH+10	; 11
       adc(i+12) and									// adc 					; 12
       sta(i+13) and									// sta ERROR+1				; 13
       lda_stack(i+14) and								// lda :STACKORIGIN+STACKWIDTH*2+10	; 14
       adc(i+15) and									// adc 					; 15
       sta(i+16) and									// sta ERROR+2				; 16
       lda_stack(i+17) and								// lda :STACKORIGIN+STACKWIDTH*3+10	; 17
       adc(i+18) and									// adc 					; 18
       sta(i+19) then									// sta ERROR+3				; 19
     if (copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+11], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+14], 6, 256)) and
	(copy(listing[i+7], 6, 256) = copy(listing[i+17], 6, 256)) then
	begin
	listing[i+8]  := #9'lda ' + copy(listing[i], 6, 256);
	listing[i+11] := #9'lda ' + copy(listing[i+2], 6, 256);
	listing[i+14] := #9'lda ' + copy(listing[i+4], 6, 256);
	listing[i+17] := #9'lda ' + copy(listing[i+6], 6, 256);

	listing[i] := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';

	Result:=false;
	end;


    if lda(i) and sta_stack(i+1) and							// lda					; 0
       lda(i+2) and sta_stack(i+3) and							// sta :STACKORIGIN			; 1
       lda_stack(i+4) and add(i+5) and							// lda					; 2
       sta(i+6) and lda_stack(i+7) and							// sta :STACKORIGIN+STACKWIDTH		; 3
       adc(i+8) and sta(i+9) then							// lda :STACKORIGIN			; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and			// add					; 5
	(copy(listing[i+3], 6, 256) = copy(listing[i+7], 6, 256)) then begin		// sta					; 6
	listing[i+4] := listing[i];							// lda :STACKORIGIN+STACKWIDTH		; 7
	listing[i+7] := listing[i+2];							// adc					; 8
	listing[i]   := '';								// sta					; 9
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
     end;


    if lda(i) and sta_stack(i+1) and							// lda					; 0
       lda_stack(i+2) and add(i+3) and							// sta :STACKORIGIN+STACKWIDTH		; 1
       sta(i+4) and lda_stack(i+5) and							// lda :STACKORIGIN			; 2
       adc(i+6) and sta(i+7) then							// add					; 3
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) then			// sta					; 4
      begin										// lda :STACKORIGIN+STACKWIDTH		; 5
	listing[i+5] := listing[i];							// adc					; 6
	listing[i]   := '';								// sta					; 7
	listing[i+1] := '';

	Result:=false;
      end;


    if lda(i) and sta(i+1) and								// lda				; 0
       lda(i+2) and									// sta :eax			; 1
       add(i+3) and									// lda 				; 2
       sta(i+4) then									// add :eax			; 3
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then			// sta				; 4
      begin
	listing[i+3] := #9'add ' + copy(listing[i], 6, 256);
	listing[i]   := '';
	listing[i+1] := '';

	Result:=false;
      end;


    if (lda(i) = false) and								// ~lda 			; 0
       sta(i+1) and									// sta :eax			; 1
       lda(i+2) and									// lda 				; 2
       add(i+3) and									// add :eax			; 3
       sta(i+4) then									// sta				; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then
      begin
	listing[i+3] := #9'add ' + copy(listing[i+2], 6, 256);
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
      end;


    if lda(i) and sta(i+1) and								// lda				; 0
       lda(i+2) and sta(i+3) and							// sta :eax			; 1
       lda(i+4) and									// lda				; 2
       add(i+5) and									// sta :eax+1			; 3
       sta(i+6) and									// lda				; 4
       lda(i+7) and									// add :eax			; 5
       adc(i+8) then									// sta				; 6
       //sta(i+9) then									// lda				; 7
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and			// adc :eax+1			; 8
	(copy(listing[i+3], 6, 256) = copy(listing[i+8], 6, 256)) then			// sta				; 9
      begin
	listing[i+5] := #9'add ' + copy(listing[i], 6, 256);
	listing[i+8] := #9'adc ' + copy(listing[i+2], 6, 256);
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
      end;


    if lda_stack(i) and									// lda :STACKORIGIN+9			; 0
       (listing[i+1] = #9'sta :eax') and						// sta :eax				; 1
       lda_stack(i+2) and								// lda :STACKORIGIN+STACKWIDTH+9	; 2
       (listing[i+3] = #9'sta :eax+1') and						// sta :eax+1				; 3
       lda(i+4) and									// lda					; 4
       (listing[i+5] = #9'add :eax') and						// add :eax				; 5
       sta(i+6) and									// sta					; 6
       (lda(i+7) = false) then								// ~lda					; 7
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) then
      begin
	listing[i+5] := #9'add ' + copy(listing[i], 6, 256);
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
      end;


    if add_sub(i) and									// add|sub				; 0
       sta_stack(i+1) and lda(i+2) and							// sta :STACKORIGIN+9			; 1
       adc_sbc(i+3) and									// lda					; 2
       sta_stack(i+4) and								// adc|sbc				; 3
       lda_stack(i+5) and sta(i+6) and							// sta :STACKORIGIN+STACKWIDTH+9	; 4
       lda_stack(i+7) and sta(i+8) then							// lda :STACKORIGIN+9			; 5
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and			// sta					; 6
	(copy(listing[i+4], 6, 256) = copy(listing[i+7], 6, 256)) then			// lda :STACKORIGIN+STACKWIDTH+9	; 7
      begin										// sta					; 8
	listing[i+1] := listing[i+6];
	listing[i+4] := listing[i+8];

	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';

	Result:=false;
      end;


    if lda_im(i) and									// lda #				; 0
       add_im(i+1) and									// add #				; 1
       sta(i+2) and									// sta :STACKORIGIN+10			; 2
       lda_im(i+3) and									// lda #				; 3
       adc_im(i+4) and									// adc #$00				; 4
       sta(i+5) and									// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda_im(i+6) and									// lda #				; 6
       adc_im(i+7) and									// adc #$00				; 7
       sta(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda_im(i+9) and									// lda #				; 9
       adc_im(i+10) and									// adc #$00				; 10
       sta(i+11) then									// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
      begin
	p :=  GetVAL(copy(listing[i], 6, 256)) + GetVAL(copy(listing[i+3], 6, 256)) shl 8 + GetVAL(copy(listing[i+6], 6, 256)) shl 16 + GetVAL(copy(listing[i+9], 6, 256)) shl 24;
	err := GetVAL(copy(listing[i+1], 6, 256)) + GetVAL(copy(listing[i+4], 6, 256)) shl 8 + GetVAL(copy(listing[i+7], 6, 256)) shl 16 + GetVAL(copy(listing[i+10], 6, 256)) shl 24;

	p:=p + err;

	listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
	listing[i+3] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
	listing[i+6] := #9'lda #$' + IntToHex(byte(p shr 16), 2);
	listing[i+9] := #9'lda #$' + IntToHex(byte(p shr 24), 2);

	listing[i+1] := '';
	listing[i+4] := '';
	listing[i+7] := '';
	listing[i+10] := '';

	Result:=false;
       end;


    if (listing[i] = #9'clc') and							// clc		; 0
       lda_im(i+1) and sta(i+3) and							// lda #$	; 1
       lda_im(i+4) and sta(i+6) and							// adc #$	; 2
       adc_im(i+2) and adc_im(i+5) and							// sta 		; 3
       (lda_im(i+7) = false) and (adc(i+8) = false) then				// lda #$	; 4
     begin										// adc #$	; 5
											// sta 		; 6
      p := GetWORD(i+1, i+4);
      err := GetWORD(i+2, i+5);

      p:=p + err;

      listing[i]   := '';
      listing[i+1] := #9'lda #$' + IntToHex(p and $ff, 2);
      listing[i+2] := '';
      listing[i+4] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
      listing[i+5] := '';

      Result:=false;
     end;


    if lda_im(i) and sta(i+2) and							// lda #$	; 0
       lda_im(i+3) and sta(i+5) and							// add #$	; 1
       add_im(i+1) and adc_im(i+4) and							// sta 		; 2
       (lda_im(i+6) = false) and (adc(i+7) = false) then				// lda #$	; 3
     begin										// adc #$	; 4
											// sta 		; 5
      p := GetWORD(i, i+3);
      err := GetWORD(i+1, i+4);

      p:=p + err;

      listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
      listing[i+1] := '';
      listing[i+3]   := #9'lda #$' + IntToHex(byte(p shr 8), 2);
      listing[i+4] := '';

      Result:=false;
     end;


    if lda_im(i) and sta(i+2) and							// lda #$	; 0
       lda_im(i+3) and sta(i+5) and							// add #$	; 1
       lda_im(i+6) and sta(i+8) and							// sta 		; 2
       add_im(i+1) and									// lda #$	; 3
       adc_im(i+4) and									// adc #$	; 4
       adc_im(i+7) and									// sta 		; 5
       (lda_im(i+9) = false) and (adc(i+10) = false) then				// lda #$	; 6
     begin										// adc #$	; 7
											// sta 		; 8
      p := GetVAL(copy(listing[i], 6, 256)) + GetVAL(copy(listing[i+3], 6, 256)) shl 8 + GetVAL(copy(listing[i+6], 6, 256)) shl 16;
      err := GetVAL(copy(listing[i+1], 6, 256)) + GetVAL(copy(listing[i+4], 6, 256)) shl 8 + GetVAL(copy(listing[i+7], 6, 256)) shl 16;

      p:=p + err;

      listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
      listing[i+1] := '';
      listing[i+3] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
      listing[i+4] := '';
      listing[i+6] := #9'lda #$' + IntToHex(byte(p shr 16), 2);
      listing[i+7] := '';

      Result:=false;
     end;


    if lda_im(i) and									// lda #$80			; 0
       add(i+1) and									// add :eax			; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9		; 2
       lda_im(i+3) and									// lda #$B0			; 3
       adc(i+4) and									// adc :eax+1			; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9; 5
       lda_stack(i+6) and								// lda :STACKORIGIN+9		; 6
       add_im(i+7) and									// add #$03			; 7
       sta(i+8) and									// sta P			; 8
       lda_stack(i+9) and								// lda :STACKORIGIN+STACKWIDTH+9; 9
       adc_im(i+10) and									// adc #$00			; 10
       sta(i+11) then									// sta P+1			; 11
      if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and
	 (copy(listing[i+5], 6, 256) = copy(listing[i+9], 6, 256)) then
     begin

      p := GetWORD(i, i+3);
      err := GetWORD(i+7, i+10);

      p:=p + err;

      listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
      listing[i+2] := listing[i+8];
      listing[i+3] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
      listing[i+5] := listing[i+11];

      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';
      listing[i+10] := '';
      listing[i+11] := '';

      Result:=false;
     end;


    if lda(i) and									// lda W			; 0
       add_im(i+1) and									// add #			; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9		; 2
       lda(i+3) and									// lda W+1			; 3
       adc_im(i+4) and									// adc #			; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9; 5
       lda_stack(i+6) and								// lda :STACKORIGIN+9		; 6
       sub_im(i+7) and									// sub #			; 7
       sta(i+8) and									// sta 				; 8
       lda_stack(i+9) and								// lda :STACKORIGIN+STACKWIDTH+9; 9
       sbc_im(i+10) and									// sbc #			; 10
       sta(i+11) then									// sta 				; 11
      if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and
	 (copy(listing[i+5], 6, 256) = copy(listing[i+9], 6, 256)) then
     begin
      p := GetWORD(i+1, i+4);
      err := GetWORD(i+7, i+10);

      p:=p - err;

      listing[i+1] := #9'add #$' + IntToHex(p and $ff, 2);
      listing[i+4] := #9'adc #$' + IntToHex(byte(p shr 8), 2);

      listing[i+2] := listing[i+8];
      listing[i+5] := listing[i+11];

      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';
      listing[i+10] := '';
      listing[i+11] := '';

      Result:=false;
     end;


    if lda(i) and									// lda W				; 0
       add_im(i+1) and									// add #$00				; 1
       sta_stack(i+2) and								// sta :STACKORIGIN+9			; 2
       lda(i+3) and									// lda W+1				; 3
       adc_im(i+4) and									// adc #$04				; 4
       sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda(i+6) and									// lda W+2				; 6
       adc_im(i+7) and									// adc #$00				; 7
       sta_stack(i+8) and								// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda(i+9) and									// lda W+3				; 9
       adc_im(i+10) and									// adc #$00				; 10
       sta_stack(i+11) and								// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
       lda_stack(i+12) and								// lda :STACKORIGIN+9			; 12
       add_im(i+13) and									// add #$36				; 13
       sta(i+14) and									// sta W				; 14
       lda_stack(i+15) and								// lda :STACKORIGIN+STACKWIDTH+9	; 15
       adc_im(i+16) and									// adc #$00				; 16
       sta(i+17) and									// sta W+1				; 17
       lda_stack(i+18) and								// lda :STACKORIGIN+STACKWIDTH*2+9	; 18
       adc_im(i+19) and									// adc #$00				; 19
       sta(i+20) and									// sta W+2				; 20
       lda_stack(i+21) and								// lda :STACKORIGIN+STACKWIDTH*3+9	; 21
       adc_im(i+22) and									// adc #$00				; 22
       sta(i+23) then									// sta W+3				; 23
      if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and
	 (copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	 (copy(listing[i+8], 6, 256) = copy(listing[i+18], 6, 256)) and
	 (copy(listing[i+11], 6, 256) = copy(listing[i+21], 6, 256)) and
	 (copy(listing[i], 6, 256) = copy(listing[i+14], 6, 256)) and
	 (copy(listing[i+3], 6, 256) = copy(listing[i+17], 6, 256)) and
	 (copy(listing[i+6], 6, 256) = copy(listing[i+20], 6, 256)) and
	 (copy(listing[i+9], 6, 256) = copy(listing[i+23], 6, 256)) then
     begin
      p := GetVAL(copy(listing[i+1], 6, 256)) + GetVAL(copy(listing[i+4], 6, 256)) shl 8 + GetVAL(copy(listing[i+7], 6, 256)) shl 16 + GetVAL(copy(listing[i+10], 6, 256)) shl 24;
      err :=  GetVAL(copy(listing[i+13], 6, 256)) + GetVAL(copy(listing[i+16], 6, 256)) shl 8 + GetVAL(copy(listing[i+19], 6, 256)) shl 16 + GetVAL(copy(listing[i+22], 6, 256)) shl 24;

      p:=p+err;

      listing[i+1] := #9'add #$' + IntToHex(p and $ff, 2);
      listing[i+4] := #9'adc #$' + IntToHex(byte(p shr 8), 2);
      listing[i+7] := #9'adc #$' + IntToHex(byte(p shr 16), 2);
      listing[i+10] := #9'adc #$' + IntToHex(byte(p shr 24), 2);

      listing[i+2] := listing[i+14];
      listing[i+5] := listing[i+17];
      listing[i+8] := listing[i+20];
      listing[i+11] := listing[i+23];

      listing[i+12] := '';
      listing[i+13] := '';
      listing[i+14] := '';
      listing[i+15] := '';
      listing[i+16] := '';
      listing[i+17] := '';
      listing[i+18] := '';
      listing[i+19] := '';
      listing[i+20] := '';
      listing[i+21] := '';
      listing[i+22] := '';
      listing[i+23] := '';

      Result:=false;
     end;


   if lda(i) and									// lda W			; 0
      add_im(i+1) and									// add #$00			; 1
      sta_stack(i+2) and								// sta :STACKORIGIN+9		; 2
      lda(i+3) and									// lda W+1			; 3
      adc_im(i+4) and									// adc #$04			; 4
      sta_stack(i+5) and								// sta :STACKORIGIN+STACKWIDTH+9; 5
      lda_stack(i+6) and								// lda :STACKORIGIN+9		; 6
      add_im(i+7) and									// add #$36			; 7
      sta(i+8) and									// sta W			; 8
      lda_stack(i+9) and								// lda :STACKORIGIN+STACKWIDTH+9; 9
      adc_im(i+10) and									// adc #$00			; 10
      sta(i+11) then									// sta W+1			; 11
      if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and
	 (copy(listing[i+5], 6, 256) = copy(listing[i+9], 6, 256)) then
     begin
      p := GetWORD(i+1, i+4);
      err := GetWORD(i+7, i+10);

      p:=p + err;

      listing[i+1] := #9'add #$' + IntToHex(p and $ff, 2);
      listing[i+2] := listing[i+8];
      listing[i+4] := #9'adc #$' + IntToHex(byte(p shr 8), 2);
      listing[i+5] := listing[i+11];

      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';
      listing[i+10] := '';
      listing[i+11] := '';

      Result:=false;
     end;


    if (lda_stack(i) = false) and
       lda(i) and									// lda K			; 0
       (listing[i+1] = #9'add #$01') and						// add #$01			; 1
       sta(i+2) and									// sta K			; 2
       lda(i+3) and									// lda K+1			; 3
       adc_im_0(i+4) and								// adc #$00			; 4
       sta(i+5) and									// sta K+1			; 5
       lda(i+6) and									// lda K+2			; 6
       adc_im_0(i+7) and								// adc #$00			; 7
       sta(i+8) and									// sta K+2			; 8
       lda(i+9) and									// lda K+3			; 9
       adc_im_0(i+10) and								// adc #$00			; 10
       sta(i+11) then									// sta K+3			; 11
      if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and
	 (copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) and
	 (copy(listing[i+6], 6, 256) = copy(listing[i+8], 6, 256)) and
	 (copy(listing[i+9], 6, 256) = copy(listing[i+11], 6, 256)) then
     begin
	listing[i] := #9'ind ' + copy(listing[i], 6, 256);

	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';
	listing[i+8] := '';
	listing[i+9] := '';
	listing[i+10] := '';
	listing[i+11] := '';

	Result:=false;
    end;


    if lda(i) and (lda_stack(i) = false) and						// lda W		; 0
       add(i+1) and (add_im_0(i+1) = false) and						// add 			; 1
       sta(i+2) and									// sta W		; 2
       lda(i+3) and									// lda W+1		; 3
       adc_im_0(i+4) and								// adc #$00		; 4
       sta(i+5) and									// sta W+1		; 5
       (lda(i+6) = false) then								// ~lda			; 6
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) then
     begin

	if copy(listing[i+1], 6, 256) = '#$01' then begin
	 listing[i]   := #9'inw '+copy(listing[i], 6, 256);
	 listing[i+1] := '';
	 listing[i+2] := '';
	 listing[i+3] := '';
	 listing[i+4] := '';
	 listing[i+5] := '';
	end else begin
	 listing[i+3] := #9'scc';
	 listing[i+4] := #9'inc '+copy(listing[i+5], 6, 256);
	 listing[i+5] := '';
	end;

	Result:=false;
     end;


    if lda_im_0(i) and sta_stack(i+1) and						// lda #$00		; 0
       add_stack(i+2) and sta(i+3) then							// sta :STACKORIGIN+10	; 1
     if (copy(listing[i+1], 6, 256) = copy(listing[i+2], 6, 256)) then begin		// add :STACKORIGIN+10	; 2
	listing[i+1] := '';								// sta			; 3
	listing[i+2] := #9'add #$00';

	Result:=false;
     end;


    if lda(i) and add(i+1) and								// lda			; 0
       ldy(i+2) and lda(i+3) then							// add			; 1
     begin										// ldy			; 2
	listing[i]   := '';								// lda 			; 3
	listing[i+1] := '';

	Result := false;
     end;


    if lda(i) and (listing[i+1] = #9'add #$01') and					// lda I		; 0
       tay(i+2) and (iy(i) = false) and							// add #$01		; 1
       ( (pos(' adr.', listing[i+3]) > 0) and iy(i+3) ) then				// tay			; 2
     begin										// lda adr.TAB,y	; 3
	listing[i]   := #9'ldy '+copy(listing[i], 6, 256);
	listing[i+1] := #9'iny';
	listing[i+2] := '';

	Result := false;
     end;


    if lda(i) and iy(i) and								// lda adr.MY,y				; 0
       lda(i+2) and iy(i+2) and								// sta :STACKORIGIN+10			; 1
       lda(i+4) and iy(i+4) and								// lda adr.MY+1,y			; 2
       lda(i+6) and iy(i+6) and								// sta :STACKORIGIN+STACKWIDTH+10	; 3
       sta_stack(i+1) and								// lda adr.MY+2,y			; 4
       sta_stack(i+3) and								// sta :STACKORIGIN+STACKWIDTH*2+10	; 5
       sta_stack(i+5) and 								// lda adr.MY+3,y			; 6
       sta_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH*3+10	; 7
       lda(i+8) and lda(i+11) and							// lda X				; 8
       lda(i+14) and lda(i+17) and							// add :STACKORIGIN+10			; 9
       sta(i+10) and sta(i+13) and							// sta A				; 10
       sta(i+16) and sta(i+19) and							// lda X+1				; 11
       add_stack(i+9) and 								// adc :STACKORIGIN+STACKWIDTH+10	; 12
       adc_stack(i+12) and								// sta A+1				; 13
       adc_stack(i+15) and 								// lda X+2				; 14
       adc_stack(i+18) then								// adc :STACKORIGIN+STACKWIDTH*2+10	; 15
     if (copy(listing[i+1], 6, 256) = copy(listing[i+9], 6, 256)) and			// sta A+2				; 16
	(copy(listing[i+3], 6, 256) = copy(listing[i+12], 6, 256)) and			// lda X+3				; 17
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and			// adc :STACKORIGIN+STACKWIDTH*3+10	; 18
	(copy(listing[i+7], 6, 256) = copy(listing[i+18], 6, 256)) then 		// sta A+3				; 19
	begin
	 listing[i+9]  := #9'add ' + copy(listing[i], 6, 256);
	 listing[i+12] := #9'adc ' + copy(listing[i+2], 6, 256);
	 listing[i+15] := #9'adc ' + copy(listing[i+4], 6, 256);
	 listing[i+18] := #9'adc ' + copy(listing[i+6], 6, 256);

	 listing[i]   := '';
	 listing[i+1] := '';
	 listing[i+2] := '';
	 listing[i+3] := '';
	 listing[i+4] := '';
	 listing[i+5] := '';
	 listing[i+6] := '';
	 listing[i+7] := '';

	 Result := false;
	end;


    if (i=0) and									// lda TB		; 0
       lda(i) and add_im_0(i+1) and							// add #$00		; 1
       tay(i+2) and 									// tay			; 2
       lda(i+3) and									// lda TB+1		; 3
       adc_im_0(i+4) and sta_bp_1(i+5) and						// adc #$00		; 4
       lda_bp_y(i+6) then								// sta :bp+1		; 5
      begin										// lda (:bp),y		; 6
	listing[i]   := #9'ldy ' + copy(listing[i], 6, 256);
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+4] := '';

	Result := false;
      end;


    if LDA_BP2_Y(i) and LDA_BP2_Y(i+3) and
       LDA_BP2_Y(i+6) and LDA_BP2_Y(i+9) and
       sta_stack(i+1) and sta_stack(i+4) and
       sta_stack(i+7) and sta_stack(i+10) and
       iny(i+2) and iny(i+5) and iny(i+8) and
       lda_stack(i+11) and lda_stack(i+14) and
       lda_stack(i+17) and lda_stack(i+20) and
       sta(i+13) and sta(i+16) and
       sta(i+19) and sta(i+22) and
       add_stack(i+12) and adc_stack(i+15) and
       adc_stack(i+18) and adc_stack(i+21) then
     if (copy(listing[i+1], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+4], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+7], 6, 256) = copy(listing[i+18], 6, 256)) and
	(copy(listing[i+10], 6, 256) = copy(listing[i+21], 6, 256)) then begin
{
	lda (:bp2),y			; 0
	sta :STACKORIGIN+10		; 1
	iny				; 2
	lda (:bp2),y			; 3
	sta :STACKORIGIN+STACKWIDTH+10	; 4
	iny				; 5
	lda (:bp2),y			; 6
	sta :STACKORIGIN+STACKWIDTH*2+10; 7
	iny				; 8
	lda (:bp2),y			; 9
	sta :STACKORIGIN+STACKWIDTH*3+10; 10
	lda :STACKORIGIN+9		; 11
	add :STACKORIGIN+10		; 12
	sta X				; 13
	lda :STACKORIGIN+STACKWIDTH+9	; 14
	adc :STACKORIGIN+STACKWIDTH+10	; 15
	sta X+1				; 16
	lda :STACKORIGIN+STACKWIDTH*2+9	; 17
	adc :STACKORIGIN+STACKWIDTH*2+10; 18
	sta X+2				; 19
	lda :STACKORIGIN+STACKWIDTH*3+9	; 20
	adc :STACKORIGIN+STACKWIDTH*3+10; 21
	sta X+3				; 22
}
	 listing[i+12] := #9'add (:bp2),y+';
	 listing[i+15] := #9'adc (:bp2),y+';
	 listing[i+18] := #9'adc (:bp2),y+';
	 listing[i+21] := #9'adc (:bp2),y';

	 listing[i]    := '';
	 listing[i+1]  := '';
	 listing[i+2]  := '';
	 listing[i+3]  := '';
	 listing[i+4]  := '';
	 listing[i+5]  := '';
	 listing[i+6]  := '';
	 listing[i+7]  := '';
	 listing[i+8]  := '';
	 listing[i+9]  := '';
	 listing[i+10] := '';

	 Result := false;
	end;


    if ldy(i) and ldy(i+3) and									// ldy				; 0	0=3 mnemonic
       (pos('lda adr.', listing[i+1]) > 0) and (pos('lda adr.', listing[i+4]) > 0) and		// lda adr.???,y		; 1	1=4 arg
       iy(i+1) and iy(i+4) and			// sta :STACKORIGIN+10		; 2	2=6 arg
       sta_stack(i+2) and lda_stack(i+6) and							// ldy				; 3
       sta_stack(i+5) and									// lda adr.???,y		; 4
       add_sub_stack(i+7) then									// sta :STACKORIGIN+11		; 5	5=7 arg
     if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and				// lda :STACKORIGIN+10		; 6
	(copy(listing[i+5], 6, 256) = copy(listing[i+7], 6, 256)) then 				// add|sub :STACKORIGIN+11	; 7
       begin
	listing[i+2] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+4] := copy(listing[i+7], 1, 5) + copy(listing[i+4], 6, 256);
	listing[i+7] := '';

	Result:=false;
       end;


    if lda(i) and 										// lda					; 0
       add_sub(i+1) and										// add					; 1
       sta_stack(i+2) and 									// sta :STACKORIGIN+9			; 2
       lda(i+3) and 										// lda					; 3
       adc_sbc(i+4) and										// adc					; 4
       sta_stack(i+5) and 									// sta :STACKORIGIN+STACKWIDTH+9	; 5
       ldy_stack(i+6) and 									// ldy :STACKORIGIN+9			; 6
       (pos('lda adr.', listing[i+7]) > 0) then							// lda adr.BOARD,y			; 7
     if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) then
       begin
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
       end;


    if lda(i) and 										// lda 					; 0
       sta_stack(i+1) and									// sta :STACKORIGIN+10			; 1
       lda(i+2) and 										// lda					; 2
       add_sub(i+3) and	 									// add|sub				; 3
       ldy(i+4) and										// ldy :STACKORIGIN+9			; 4
       sta(i+5) and 										// sta					; 5
       lda_stack(i+6) and 									// lda :STACKORIGIN+10			; 6
       adc_sbc(i+7) and										// adc|sbc				; 7
       sta(i+8) then										// sta					; 8
     if (copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) and
        (copy(listing[i+1], 6, 256) <> copy(listing[i+4], 6, 256)) then
       begin
	listing[i+6] := listing[i];

	listing[i]   := '';
	listing[i+1] := '';

	Result:=false;
       end;


    if lda(i) and (lda_im(i) = false) and							// lda M				; 0
       add(i+1) and										// add #$10				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+9			; 2
       lda_im_0(i+3) and									// lda #$00				; 3
       adc_im_0(i+4) and									// adc #$00				; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda_im_0(i+6) and									// lda #$00				; 6
       adc_im_0(i+7) and									// adc #$00				; 7
       sta_stack(i+8) and									// sta :STACKORIGIN+STACKWIDTH*2+9	; 8
       lda_im_0(i+9) and									// lda #$00				; 9
       adc_im_0(i+10) and									// adc #$00				; 10
       sta_stack(i+11) then									// sta :STACKORIGIN+STACKWIDTH*3+9	; 11
     begin
      listing[i+7]  := '';
      listing[i+10] := '';

      Result:=false;
     end;


// -----------------------------------------------------------------------------
// ===			optymalizacja SUB.				  === //
// -----------------------------------------------------------------------------

    if lda(i) and										// lda			; 0
       lda(i+1) and										// lda			; 1
       add_sub(i+2) then									// add|sub		; 2
      begin
	listing[i] := '';

	Result := false;
      end;


    if (l = 3) and lda(i) and (iy(i) = false) and					// lda X 		; 0
       (listing[i+1] = #9'sub #$01') and							// sub #$01		; 1
       sta(i+2) and (iy(i+2) = false) then						// sta Y		; 2
      if copy(listing[i], 6, 256) <> copy(listing[i+2], 6, 256) then
     begin

       if lda_im(i) then begin
	p := GetBYTE(i);

	listing[i]   := #9'lda #$' + IntToHex((p-1) and $ff, 2);
	listing[i+1] := '';
       end else begin
	listing[i]   := #9'ldy '+copy(listing[i], 6, 256);
	listing[i+1] := #9'dey';
	listing[i+2] := #9'sty '+copy(listing[i+2], 6, 256);
       end;

	Result:=false;
     end;


    if (l = 3) and
       lda(i) and sta(i+2) and									// lda W		; 0
       (listing[i+1] = #9'sub #$01') then							// sub #$01		; 1
       if copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256) then				// sta W		; 2
       begin
	 listing[i]   := #9'dec '+copy(listing[i], 6, 256);
	 listing[i+1] := '';
	 listing[i+2] := '';

	 Result := false;
       end;


    if sta(i) and										// sta :eax		; 0
       lda(i+1) and										// lda			; 1
       (listing[i+2] = #9'sub #$01') and							// sub #$01		; 2
       add(i+3) and										// add :eax		; 3
       tay(i+4) then										// tay			; 4
      if copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256) then
       begin
	listing[i] := '';

	listing[i+1] := #9'add ' + copy(listing[i+1], 6, 256);
	listing[i+2] := #9'tay';
	listing[i+3] := #9'dey';

	listing[i+4] := '';

	Result := false;
       end;


    if (listing[i] = #9'sec') and								// sec			; 0
       lda(i+1) and 										// lda			; 1
       sbc(i+2) then										// sbc			; 2
       begin
	listing[i]   := '';
	listing[i+2] := #9'sub ' + copy(listing[i+2], 6, 256);

	Result := false; ;
       end;


    if (listing[i] = #9'sec') and								// sec			; 0
       lda(i+1) and										// lda			; 1
       sub(i+2) then										// sub			; 2
     begin
	listing[i] := '';

	Result:=false; ;
     end;


    if lda(i) and 										// lda			; 0
       sub_im_0(i+1) and									// sub #$00		; 1
       sta(i+2) and 										// sta			; 2
       lda(i+3) and										// lda			; 3
       sbc(i+4) then										// sbc			; 4
     begin
      listing[i+1] := '';
      listing[i+4] := #9'sub ' + copy(listing[i+4], 6, 256);

      Result:=false; ;
     end;



    if Result and
       lda(i) and 										// lda			; 0
       sub_im_0(i+1) and									// sub #$00		; 1
       sta(i+2) and 										// sta			; 2
       (lda(i+3) = false) and									// ~lda			; 3
       (sbc(i+4) = false) then									// ~sbc			; 4
     begin
      listing[i+1] := '';

      Result:=false; ;
     end;


    if lda(i) and sub_stack(i+1) and								// lda					; 0
       sta_stack(i+2) and									// sub :STACKORIGIN+10			; 1
       lda(i+3) and sbc_stack(i+4) and								// sta :STACKORIGIN+9			; 2
       sta_stack(i+5) and									// lda					; 3
       mwa_bp2(i+6) and										// sbc :STACKORIGIN+STACKWIDTH+10	; 4
       ldy(i+7) and										// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda_stack(i+8) and STA_BP2_Y(i+9) and							// mwa xxx bp2				; 6
       iny(i+10) and										// ldy					; 7
       lda_stack(i+11) and STA_BP2_Y(i+12) then							// lda :STACKORIGIN+9			; 8
     if {(copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and}				// sta (:bp2),y				; 9
	(copy(listing[i+2], 6, 256) = copy(listing[i+8], 6, 256)) and				// iny 					; 10
	{(copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) and}				// lda :STACKORIGIN+STACKWIDTH+9 	; 11
	(copy(listing[i+5], 6, 256) = copy(listing[i+11], 6, 256)) then				// sta (:bp2),y				; 12
       begin

	btmp[0]  := listing[i+6];
	btmp[1]  := listing[i+7];
	btmp[2]  := listing[i];
	btmp[3]  := listing[i+1];
	btmp[4]  := listing[i+9];
	btmp[5]  := listing[i+10];
	btmp[6]  := listing[i+3];
	btmp[7]  := listing[i+4];
	btmp[8]  := listing[i+12];

	listing[i]   := btmp[0];
	listing[i+1] := btmp[1];
	listing[i+2] := btmp[2];
	listing[i+3] := btmp[3];
	listing[i+4] := btmp[4];
	listing[i+5] := btmp[5];
	listing[i+6] := btmp[6];
	listing[i+7] := btmp[7];
	listing[i+8] := btmp[8];

	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';

	Result:=false;
       end;


    if LDA_BP2_Y(i) and sta_stack(i+1) and							// lda (:bp2),y			; 0
       iny(i+2) and										// sta :STACKORIGIN+9		; 1
       LDA_BP2_Y(i+3) and sta_stack(i+4) and							// iny				; 2
       lda(i+5) and sub_stack(i+6) and								// lda (:bp2),y			; 3
       sta(i+7) and										// sta :STACKORIGIN+STACKWIDTH+9; 4
       lda(i+8) and sbc_stack(i+9) and								// lda 				; 5
       sta(i+10) then										// sub :STACKORIGIN+9		; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+6], 6, 256)) and				// sta				; 7
	(copy(listing[i+4], 6, 256) = copy(listing[i+9], 6, 256)) then				// lda 				; 8
												// sbc :STACKORIGIN+STACKWIDTH+9; 9
												// sta				; 10
	begin
	  listing[i]   := '';
	  listing[i+1] := '';
	  listing[i+2] := '';
	  listing[i+3] := '';

	  listing[i+4] := listing[i+5];
	  listing[i+5] := #9'sub (:bp2),y';
	  listing[i+6] := #9'iny';

	  listing[i+9] := #9'sbc (:bp2),y';

	  Result:=false;
	end;


    if LDA_BP2_Y(i) and sta_stack(i+1) and							// lda (:bp2),y			; 0
       iny(i+2) and										// sta :STACKORIGIN+9		; 1
       LDA_BP2_Y(i+3) and sta_stack(i+4) and							// iny				; 2
       lda_stack(i+5) and sub(i+6) and								// lda (:bp2),y			; 3
       sta(i+7) and										// sta :STACKORIGIN+STACKWIDTH+9; 4
       lda_stack(i+8) and sbc(i+9) and								// lda :STACKORIGIN+9		; 5
       sta(i+10) then										// sub				; 6
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and				// sta				; 7
	(copy(listing[i+4], 6, 256) = copy(listing[i+8], 6, 256)) then				// lda :STACKORIGIN+STACKWIDTH+9; 8
	begin											// sbc				; 9
												// sta				; 10
	  listing[i+1] := '';
	  listing[i+3] := '';
	  listing[i+4] := '';
	  listing[i+5] := '';

	  listing[i+8] := listing[i];

	  Result:=false;
	end;


    if lda(i) and sta_stack(i+1) and
       lda(i+2) and sta_stack(i+3) and
       lda(i+4) and sta_stack(i+5) and
       lda(i+6) and sta_stack(i+7) and
       lda(i+8) and sub_stack(i+9) and sta(i+10) and
       lda(i+11) and sbc_stack(i+12) and sta(i+13) and
       lda(i+14) and sbc_stack(i+15) and sta(i+16) and
       lda(i+17) and sbc_stack(i+18) and sta(i+19) then
     if (copy(listing[i+1], 6, 256) = copy(listing[i+9], 6, 256)) and
	(copy(listing[i+3], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	(copy(listing[i+7], 6, 256) = copy(listing[i+18], 6, 256)) then
	begin
{
	lda :eax			; 0
	sta :STACKORIGIN+10		; 1
	lda :eax+1			; 2
	sta :STACKORIGIN+STACKWIDTH+10	; 3
	lda :eax+2			; 4
	sta :STACKORIGIN+STACKWIDTH*2+10; 5
	lda :eax+3			; 6
	sta :STACKORIGIN+STACKWIDTH*3+10; 7
	lda ERROR			; 8
	sub :STACKORIGIN+10		; 9
	sta ERROR			; 10
	lda ERROR+1			; 11
	sbc :STACKORIGIN+STACKWIDTH+10	; 12
	sta ERROR+1			; 13
	lda ERROR+2			; 14
	sbc :STACKORIGIN+STACKWIDTH*2+10; 15
	sta ERROR+2			; 16
	lda ERROR+3			; 17
	sbc :STACKORIGIN+STACKWIDTH*3+10; 18
	sta ERROR+3			; 19
}
	listing[i+9]  := #9'sub ' + copy(listing[i], 6, 256);
	listing[i+12] := #9'sbc ' + copy(listing[i+2], 6, 256);
	listing[i+15] := #9'sbc ' + copy(listing[i+4], 6, 256);
	listing[i+18] := #9'sbc ' + copy(listing[i+6], 6, 256);

	listing[i] := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';
	listing[i+6] := '';
	listing[i+7] := '';

	Result:=false;
	end;


    if lda(i) and sub(i+1) and sta_stack(i+2) and
       lda(i+3) and sbc(i+4) and sta_stack(i+5) and
       lda(i+6) and sbc(i+7) and sta_stack(i+8) and
       lda(i+9) and sbc(i+10) and sta_stack(i+11) and
       lda_stack(i+12) and sta(i+13) and
       lda_stack(i+14) and sta(i+15) and
       lda_stack(i+16) and sta(i+17) and
       lda_stack(i+18) and sta(i+19) then
     if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and
	(copy(listing[i+5], 6, 256) = copy(listing[i+14], 6, 256)) and
	(copy(listing[i+8], 6, 256) = copy(listing[i+16], 6, 256)) and
	(copy(listing[i+11], 6, 256) = copy(listing[i+18], 6, 256)) then
	begin
{
	lda Y				; 0
	sub #$01			; 1
	sta :STACKORIGIN+11		; 2
	lda Y+1				; 3
	sbc #$00			; 4
	sta :STACKORIGIN+STACKWIDTH+11	; 5
	lda #$00			; 6
	sbc #$00			; 7
	sta :STACKORIGIN+STACKWIDTH*2+11; 8
	lda #$00			; 9
	sbc #$00			; 10
	sta :STACKORIGIN+STACKWIDTH*3+11; 11
	lda :STACKORIGIN+11		; 12
	sta :ecx			; 13
	lda :STACKORIGIN+STACKWIDTH+11	; 14
	sta :ecx+1			; 15
	lda :STACKORIGIN+STACKWIDTH*2+11; 16
	sta :ecx+2			; 17
	lda :STACKORIGIN+STACKWIDTH*3+11; 18
	sta :ecx+3			; 19
}
	listing[i+2]  := listing[i+13];
	listing[i+5]  := listing[i+15];
	listing[i+8]  := listing[i+17];
	listing[i+11] := listing[i+19];

	listing[i+12] := '';
	listing[i+13] := '';
	listing[i+14] := '';
	listing[i+15] := '';
	listing[i+16] := '';
	listing[i+17] := '';
	listing[i+18] := '';
	listing[i+19] := '';

	Result:=false;
	end;


    if lda(i) and sta_stack(i+1) and								// lda				; 0
       lda(i+2) and sta_stack(i+3) and								// sta :STACKORIGIN+9		; 1
       lda_stack(i+4) and sub(i+5) and								// lda				; 2
       sta(i+6) and lda_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH+9; 3
       sbc(i+8) and sta(i+9) then								// lda :STACKORIGIN+9		; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and				// sub				; 5
	(copy(listing[i+3], 6, 256) = copy(listing[i+7], 6, 256)) then begin			// sta				; 6
	listing[i+4] := listing[i];								// lda :STACKORIGIN+STACKWIDTH+9; 7
	listing[i+7] := listing[i+2];								// sbc				; 8
	listing[i]   := '';									// sta				; 9
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
     end;


    if lda(i) and sta_stack(i+1) and								// lda				; 0
       lda(i+2) and sta_stack(i+3) and								// sta :STACKORIGIN+9		; 1
       lda(i+4) and sub_stack(i+5) and								// lda				; 2
       sta(i+6) and lda(i+7) and								// sta :STACKORIGIN+STACKWIDTH+9; 3
       sbc_stack(i+8) and sta(i+9) then								// lda				; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and				// sub :STACKORIGIN+9		; 5
	(copy(listing[i+3], 6, 256) = copy(listing[i+8], 6, 256)) then begin			// sta				; 6
	listing[i+5] := #9'sub ' + copy(listing[i], 6, 256);					// lda				; 7
	listing[i+8] := #9'sbc ' + copy(listing[i+2], 6, 256);					// sbc :STACKORIGIN+STACKWIDTH+9; 8
	listing[i]   := '';									// sta				; 9
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
     end;


    if sty_stack(i) and sub(i+1) and								// sty :STACKORIGIN+10		; 0
       sta(i+2) and lda_stack(i+3) and								// sub				; 1
       sbc(i+4) and sta(i+5) then								// sta				; 2
     if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then				// lda :STACKORIGIN+10		; 3
       begin											// sbc				; 4
												// sta				; 5
	listing[i]   := '';
	listing[i+3] := #9'tya';

	Result:=false;
       end;


    if (l = 6) and lda(i) and sta(i+2) and							// lda W			; 0
       lda(i+3) and sta(i+5) and								// sub #$01..$ff		; 1
       sub_im(i+1) and sbc_im_0(i+4) and							// sta W			; 2
       (listing[i+1] <> #9'sub #$00') then							// lda W+1			; 3
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and				// sbc #$00			; 4
	(copy(listing[i+3], 6, 256) = copy(listing[i+5], 6, 256)) then				// sta W+1			; 5
     begin

	if copy(listing[i+1], 6, 256) = '#$01' then begin
	 listing[i]   := #9'dew '+copy(listing[i], 6, 256);
	 listing[i+1] := '';
	 listing[i+2] := '';
	 listing[i+3] := '';
	 listing[i+4] := '';
	 listing[i+5] := '';
	end else begin
	 listing[i+3] := #9'scs';
	 listing[i+4] := #9'dec '+copy(listing[i+5], 6, 256);
	 listing[i+5] := '';
	end;

	Result:=false;
     end;


    if (listing[i] = #9'sec') and								// sec			; 0
       lda_im(i+1) and sta(i+3) and								// lda #$		; 1
       lda_im(i+4) and sta(i+6) and								// sbc #$		; 2
       sbc_im(i+2) and sbc_im(i+5) and								// sta 			; 3
       (lda_im(i+7) = false) and (sbc(i+8) = false) then					// lda #$		; 4
     begin											// sbc #$		; 5
												// sta 			; 6
      p := GetWORD(i+1, i+4);
      err := GetWORD(i+2, i+5);

      p:=p - err;

      listing[i]   := '';
      listing[i+1] := #9'lda #$' + IntToHex(p and $ff, 2);
      listing[i+2] := '';
      listing[i+4] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
      listing[i+5] := '';

      Result:=false;
     end;


    if lda_im(i) and sta(i+2) and								// lda #$		; 0
       lda_im(i+3) and sta(i+5) and								// sub #$		; 1
       sub_im(i+1) and										// sta 			; 2
       sbc_im(i+4) and										// lda #$		; 3
       (lda_im(i+6) = false) and								// sbc #$		; 4
       (sbc(i+7) = false) then									// sta 			; 5
     begin											// ~lda			; 6
      p := GetWORD(i, i+3);
      err := GetWORD(i+1, i+4);

      p:=p - err;

      listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
      listing[i+1] := '';
      listing[i+3] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
      listing[i+4] := '';

      Result:=false;
     end;


    if lda_im(i) and sub_im(i+1) and								// lda #$		; 0
       sta(i+2) and										// sub #$		; 1
       (lda_im(i+3) = false) and (sbc(i+4) = false) then					// sta 			; 2
     begin
      p := GetBYTE(i);
      err := GetBYTE(i+1);

      p:=p - err;

      listing[i] := '';

      listing[i+1] := #9'lda #$' + IntToHex(p and $ff, 2);

      Result:=false;
     end;


    if lda_im(i) and sta(i+2) and								// lda #$		; 0
       lda_im(i+3) and sta(i+5) and								// sub #$		; 1
       lda_im(i+6) and sta(i+8) and								// sta 			; 2
       sub_im(i+1) and										// lda #$		; 3
       sbc_im(i+4) and										// sbc #$		; 4
       sbc_im(i+7) and										// sta 			; 5
       (lda_im(i+9) = false) and								// lda #$		; 6
       (sbc(i+10) = false) then									// sbc #$		; 7
     begin											// sta 			; 8

      p := GetVAL(copy(listing[i], 6, 256)) + GetVAL(copy(listing[i+3], 6, 256)) shl 8 + GetVAL(copy(listing[i+6], 6, 256)) shl 16;
      err := GetVAL(copy(listing[i+1], 6, 256)) + GetVAL(copy(listing[i+4], 6, 256)) shl 8 + GetVAL(copy(listing[i+7], 6, 256)) shl 16;

      p:=p - err;

      listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
      listing[i+1] := '';
      listing[i+3] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
      listing[i+4] := '';
      listing[i+6] := #9'lda #$' + IntToHex(byte(p shr 16), 2);
      listing[i+7] := '';

      Result:=false;
     end;


    if lda(i) and										// lda W				; 0
       sub_im(i+1) and										// sub #$00				; 1
       sta_stack(i+2) and									// sta :STACKORIGIN+9			; 2
       lda(i+3) and										// lda W+1				; 3
       sbc_im(i+4) and										// sbc #$04				; 4
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH+9	; 5
       lda_stack(i+6) and									// lda :STACKORIGIN+9			; 6
       sub_im(i+7) and										// sub #$36				; 7
       sta(i+8) and										// sta W				; 8
       lda_stack(i+9) and									// lda :STACKORIGIN+STACKWIDTH+9	; 9
       sbc_im(i+10) and										// sbc #$00				; 10
       sta(i+11) then										// sta W+1				; 11
      if (copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and
	 (copy(listing[i+5], 6, 256) = copy(listing[i+9], 6, 256)) and
	 (copy(listing[i], 6, 256) = copy(listing[i+8], 6, 256)) and
	 (copy(listing[i+3], 6, 256) = copy(listing[i+11], 6, 256)) then
     begin
      p := GetWORD(i+1, i+4);
      err := GetWORD(i+7, i+10);

      p:=p+err;

      listing[i+1] := #9'sub #$' + IntToHex(p and $ff, 2);
      listing[i+4] := #9'sbc #$' + IntToHex(byte(p shr 8), 2);

      listing[i+2] := listing[i+8];
      listing[i+5] := listing[i+11];

      listing[i+6] := '';
      listing[i+7] := '';
      listing[i+8] := '';
      listing[i+9] := '';
      listing[i+10] := '';
      listing[i+11] := '';

      Result:=false;
     end;


    if lda_im(i) and										// lda #				; 0
       sub_im(i+1) and										// sub #				; 1
       sta(i+2) and										// sta :STACKORIGIN+10			; 2
       lda_im(i+3) and										// lda #				; 3
       sbc_im(i+4) and										// sbc #$00				; 4
       sta(i+5) and										// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda_im(i+6) and										// lda #				; 6
       sbc_im(i+7) and										// sbc #$00				; 7
       sta(i+8) and										// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
       lda_im(i+9) and										// lda #				; 9
       sbc_im(i+10) and										// sbc #$00				; 10
       sta(i+11) then										// sta :STACKORIGIN+STACKWIDTH*3+10	; 11
      begin
	p := GetVAL(copy(listing[i], 6, 256)) + GetVAL(copy(listing[i+3], 6, 256)) shl 8 + GetVAL(copy(listing[i+6], 6, 256)) shl 16 + GetVAL(copy(listing[i+9], 6, 256)) shl 24;
	err := GetVAL(copy(listing[i+1], 6, 256)) + GetVAL(copy(listing[i+4], 6, 256)) shl 8 + GetVAL(copy(listing[i+7], 6, 256)) shl 16 + GetVAL(copy(listing[i+10], 6, 256)) shl 24;

	p:=p - err;

	listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
	listing[i+3] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
	listing[i+6] := #9'lda #$' + IntToHex(byte(p shr 16), 2);
	listing[i+9] := #9'lda #$' + IntToHex(byte(p shr 24), 2);

	listing[i+1] := '';
	listing[i+4] := '';
	listing[i+7] := '';
	listing[i+10] := '';

	Result:=false;
       end;


    if lda_im(i) and										// lda #				; 0
       sub_im(i+1) and										// sub #				; 1
       sta(i+2) and										// sta :STACKORIGIN+10			; 2
       lda_im(i+3) and										// lda #				; 3
       sbc_im(i+4) and										// sbc #$00				; 4
       sta(i+5) and										// sta :STACKORIGIN+STACKWIDTH+10	; 5
       lda_im(i+6) and										// lda #				; 6
       sbc_im(i+7) and										// sbc #$00				; 7
       sta(i+8) then										// sta :STACKORIGIN+STACKWIDTH*2+10	; 8
      begin
	p := GetVAL(copy(listing[i], 6, 256)) + GetVAL(copy(listing[i+3], 6, 256)) shl 8 + GetVAL(copy(listing[i+6], 6, 256)) shl 16;
	err := GetVAL(copy(listing[i+1], 6, 256)) + GetVAL(copy(listing[i+4], 6, 256)) shl 8 + GetVAL(copy(listing[i+7], 6, 256)) shl 16;
	p:=p - err;

	listing[i]   := #9'lda #$' + IntToHex(p and $ff, 2);
	listing[i+3] := #9'lda #$' + IntToHex(byte(p shr 8), 2);
	listing[i+6] := #9'lda #$' + IntToHex(byte(p shr 16), 2);

	listing[i+1] := '';
	listing[i+4] := '';
	listing[i+7] := '';

	Result:=false;
       end;


    if lda(i) and sub_im(i+1) and sta_stack(i+2) and
       lda(i+3) and sbc_im(i+4) and sta_stack(i+5) and
       lda(i+6) and sbc_im(i+7) and sta_stack(i+8) and
       lda(i+9) and sbc_im(i+10) and sta_stack(i+11) and
       lda_stack(i+12) and sub_im(i+13) and sta(i+14) and
       lda_stack(i+15) and sbc_im(i+16) and sta(i+17) and
       lda_stack(i+18) and sbc_im(i+19) and sta(i+20) and
       lda_stack(i+21) and sbc_im(i+22) and sta(i+23) then
      if (copy(listing[i+2], 6, 256) = copy(listing[i+12], 6, 256)) and
	 (copy(listing[i+5], 6, 256) = copy(listing[i+15], 6, 256)) and
	 (copy(listing[i+8], 6, 256) = copy(listing[i+18], 6, 256)) and
	 (copy(listing[i+11], 6, 256) = copy(listing[i+21], 6, 256)) and
	 (copy(listing[i], 6, 256) = copy(listing[i+14], 6, 256)) and
	 (copy(listing[i+3], 6, 256) = copy(listing[i+17], 6, 256)) and
	 (copy(listing[i+6], 6, 256) = copy(listing[i+20], 6, 256)) and
	 (copy(listing[i+9], 6, 256) = copy(listing[i+23], 6, 256)) then
     begin
{
	lda W				; 0
	sub #$00			; 1
	sta :STACKORIGIN+9		; 2
	lda W+1				; 3
	sbc #$04			; 4
	sta :STACKORIGIN+STACKWIDTH+9	; 5
	lda W+2				; 6
	sbc #$00			; 7
	sta :STACKORIGIN+STACKWIDTH*2+9	; 8
	lda W+3				; 9
	sbc #$00			; 10
	sta :STACKORIGIN+STACKWIDTH*3+9	; 11
	lda :STACKORIGIN+9		; 12
	sub #$36			; 13
	sta W				; 14
	lda :STACKORIGIN+STACKWIDTH+9	; 15
	sbc #$00			; 16
	sta W+1				; 17
	lda :STACKORIGIN+STACKWIDTH*2+9	; 18
	sbc #$00			; 19
	sta W+2				; 20
	lda :STACKORIGIN+STACKWIDTH*3+9	; 21
	sbc #$00			; 22
	sta W+3				; 23
}
      p := GetVAL(copy(listing[i+1], 6, 256)) + GetVAL(copy(listing[i+4], 6, 256)) shl 8 + GetVAL(copy(listing[i+7], 6, 256)) shl 16 + GetVAL(copy(listing[i+10], 6, 256)) shl 24;
      err :=  GetVAL(copy(listing[i+13], 6, 256)) + GetVAL(copy(listing[i+16], 6, 256)) shl 8 + GetVAL(copy(listing[i+19], 6, 256)) shl 16 + GetVAL(copy(listing[i+22], 6, 256)) shl 24;

      p:=p+err;

      listing[i+1] := #9'sub #$' + IntToHex(p and $ff, 2);
      listing[i+4] := #9'sbc #$' + IntToHex(byte(p shr 8), 2);
      listing[i+7] := #9'sbc #$' + IntToHex(byte(p shr 16), 2);
      listing[i+10] := #9'sbc #$' + IntToHex(byte(p shr 24), 2);

      listing[i+2] := listing[i+14];
      listing[i+5] := listing[i+17];
      listing[i+8] := listing[i+20];
      listing[i+11] := listing[i+23];

      listing[i+12] := '';
      listing[i+13] := '';
      listing[i+14] := '';
      listing[i+15] := '';
      listing[i+16] := '';
      listing[i+17] := '';
      listing[i+18] := '';
      listing[i+19] := '';
      listing[i+20] := '';
      listing[i+21] := '';
      listing[i+22] := '';
      listing[i+23] := '';

      Result:=false;
     end;


    if lda(i) and sta(i+1) and									// lda				; 0
       lda(i+2) and sta(i+3) and								// sta :eax			; 1
       lda(i+4) and 										// lda				; 2
       sub(i+5) and										// sta :eax+1			; 3
       sta(i+6) and										// lda				; 4
       lda(i+7) and										// sub :eax			; 5
       sbc(i+8) and										// sta				; 6
       sta(i+9) then										// lda				; 7
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and				// sbc :eax+1			; 8
	(copy(listing[i+3], 6, 256) = copy(listing[i+8], 6, 256)) then				// sta				; 9
     begin
	listing[i+5] := #9'sub ' + copy(listing[i], 6, 256);
	listing[i+8] := #9'sbc ' + copy(listing[i+2], 6, 256);
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
     end;

{
    if (listing[i] = #9'lda :eax') and sta_stack(i+1) and					// lda :eax			; 0
       (listing[i+2] = #9'lda :eax+1') and sta_stack(i+3) and					// sta :STACKORIGIN+10		; 1
       lda_stack(i+4) and sub_stack(i+5) and							// lda :eax+1			; 2
       sta(i+6) and lda_stack(i+7) and								// sta :STACKORIGIN+STACKWIDTH+10; 3
       sbc_stack(i+8) and sta(i+9) then								// lda :STACKORIGIN+9		; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and				// sub :STACKORIGIN+10		; 5
	(copy(listing[i+3], 6, 256) = copy(listing[i+8], 6, 256)) then begin			// sta				; 6
	listing[i+5] := #9'sub ' + copy(listing[i], 6, 256);					// lda :STACKORIGIN+STACKWIDTH+9; 7
	listing[i+8] := #9'sbc ' + copy(listing[i+2], 6, 256);					// sbc :STACKORIGIN+STACKWIDTH+10; 8
	listing[i]   := '';									// sta				; 9
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
     end;
}

    if lda_stack(i) and sta(i+1) and								// lda :STACKORIGIN+9		; 0
       lda_stack(i+2) and sta(i+3) and								// sta :eax			; 1
       lda(i+4) and sub(i+5) and								// lda :STACKORIGIN+STACKWIDTH+9; 2
       sta(i+6) and										// sta :eax+1			; 3
       (lda(i+7) = false) then									// lda				; 4
     if (copy(listing[i+1], 6, 256) = copy(listing[i+5], 6, 256)) and				// sub :eax			; 5
	(pos(listing[i+1], listing[i+3]) > 0) then						// sta				; 6
      begin											// ~lda				; 7
	listing[i+5] := #9'sub ' + copy(listing[i], 6, 256);
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

	Result:=false;
      end;


    if lda_stack(i) and sta(i+1) and								// lda :STACKORIGIN+9	; 0
       lda(i+2) and										// sta :eax		; 1
       sub(i+3) and										// lda 			; 2
       sta(i+4) then										// sub :eax		; 3
     if (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then				// sta			; 4
      begin
	listing[i+3] := #9'sub ' + copy(listing[i], 6, 256);
	listing[i]   := '';
	listing[i+1] := '';

	Result:=false;
      end;


// -----------------------------------------------------------------------------
// ===		     optymalizacja STA #$00.				  === //
// -----------------------------------------------------------------------------

    if (i=0) and (listing[i] = #9'sta #$00') then begin						// jedno linijkowy sta #$00
       listing[i] := '';
       Result:=false;
     end;


    if (listing[i]= #9'lda :eax') and								// lda :eax			; 0
       sta_stack(i+1) and									// sta :STACKORIGIN		; 1
       (listing[i+2]= #9'lda :eax+1') and							// lda :eax+1			; 2
       sta_stack(i+3) and									// sta :STACKORIGIN+STACKWIDTH	; 3
       (listing[i+4]= #9'lda :eax+3') and							// lda :eax+3			; 4
       (listing[i+5]= #9'sta #$00') then							// sta #$00			; 5
      begin
       listing[i+4] := '';
       listing[i+5] := '';
       Result:=false;
     end;


    if (i>1) and (listing[i] = #9'sta #$00') then						// lda 			; -2
     if adc_sbc(i-1) then begin									// adc|sbc		; -1
												// sta #$00		; 0
       if adc_sbc(i-1) and lda(i-2) then listing[i-2] := '';

       listing[i-1] := '';
       listing[i]   := '';
       Result:=false;
     end;


    if add_sub(i) and										// add|sub		; 0
       (listing[i+1] = #9'sta #$00') then							// sta #$00		; 1
     begin
	listing[i+1] := '';
	Result:=false;
     end;


    if (i>1) and (listing[i] = #9'sta #$00') then						// iny			; -2
     if LDA_BP2_Y(i-1) then									// lda (:bp2),y		; -1
      begin											// sta #$00		; 0

	if iny(i-2) then listing[i-2] := '';

	listing[i-1] := '';
	listing[i]   := '';
	Result:=false;
      end;


    if AND_ORA_EOR(i) and									// and|ora|eor		; 0
       (listing[i+1] = #9'sta #$00') then							// sta #$00		; 1
     begin
	listing[i]   := '';
	listing[i+1] := '';
	Result:=false;
     end;


    if adc_stack(i) and (listing[i+1] = #9'sta #$00') then					// adc STACK
     begin											// sta #$00
	listing[i]   := '';
	listing[i+1] := '';
	Result:=false;
     end;


    if (listing[i] = #9'lsr @') and								// lsr @
       (listing[i+1] = #9'sta #$00') then							// sta #$00
     begin
	listing[i+1] := '';
	Result:=false;
     end;


    if (listing[i] = #9'sta #$00') and								// sta #$00		; 0
       (lda(i+1) or mwa(i+1)) then								// lda|mwa		; 1
     begin
	listing[i] := '';
	Result:=false;
     end;


    if (listing[i] = #9'sta #$00') and								// sta #$00		; 0
       ldy(i+1) and										// ldy 			; 1
       lda(i+2) then										// lda			; 2
     begin
	listing[i] := '';
	Result:=false;
     end;


    if (listing[i] = #9'sta #$00') and								// sta #$00		; 0
       ldy(i+1) and										// ldy 			; 1
       (listing[i+2] = #9'.LOCAL') and								// .LOCAL		; 2
       lda(i+3) then										// lda			; 3
     begin
	listing[i] := '';
	Result:=false;
     end;


    if sta(i) and (listing[i+1] = #9'sta #$00') then						// sta
     begin											// sta #$00
	listing[i+1] := '';
	Result:=false;
     end;


    if (pos('scc', listing[i]) > 0) and (pos('inc #$00', listing[i+1]) > 0) then		// scc
     begin											// inc #$00
	listing[i]   := '';
	listing[i+1] := '';
	Result:=false;
     end;


    if (pos('scs', listing[i]) > 0) and (pos('dec #$00', listing[i+1]) > 0) then		// scs
     begin											// dec #$00
	listing[i]   := '';
	listing[i+1] := '';
	Result:=false;
     end;


    if lda(i) and sta(i+1) then									// lda :STACKORIGIN+9
     if copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256) then begin			// sta :STACKORIGIN+9

       if (pos('sta #$00', listing[i+1]) = 0) then listing[i] := '';

       listing[i+1] := '';
       Result:=false;
     end;


    if lda_im_0(i) and										// lda #$00		; 0
       (adc_im_0(i+1) or sbc_im_0(i+1)) and							// adc|sbc #$00		; 1
       (listing[i+2] = #9'sta #$00') then							// sta #$00		; 2
     begin
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
     end;


// -----------------------------------------------------------------------------
// ===		     optymalizacja LDA.			  	  	  === //
// -----------------------------------------------------------------------------

    if sta_stack(i) and lda(i+1) and								// sta :STACKORIGIN+10
       add_stack(i+2) and									// lda
       ( sta(i+3) or tay(i+3) ) then								// add :STACKORIGIN+10
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then begin			// sta|tay
	listing[i]   := '';
	listing[i+1] := #9'add ' + copy(listing[i+1], 6, 256) ;
	listing[i+2] := '';
	Result:=false;
     end;


    if sta_stack(i) and (pos('ora :STACK', listing[i+2]) > 0) and				// sta :STACKORIGIN+10
       lda(i+1) and sta(i+3) then								// lda B
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and				// ora :STACKORIGIN+10
	(copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then begin			// sta B
	listing[i]   := '';
	listing[i+2] := '';

	listing[i+1] := #9'ora '+copy(listing[i+1], 6, 256);
	Result:=false;
     end;


    if (i>0) and
       (ldy(i-1) = false) and (tay(i-1) = false) and						// sta :STACKORIGIN+9	; 0
       sta(i) and lda(i+2) and 									// clc|sec		; 1
       ((listing[i+1] = #9'clc') or (listing[i+1] = #9'sec')) then				// lda :STACKORIGIN+9	; 2
     if copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256) then begin
	listing[i]   := '';
	listing[i+2] := '';
	Result:=false;
     end;


    if (i>0) and
       (ldy(i-1) = false) and (tay(i-1) = false) and						// sta :STACKORIGIN+9	; 0
       sta(i) and lda(i+1) and 									// lda :STACKORIGIN+9	; 1
       ((add(i+2) = false) or (sub(i+2) = false)) then						// add|sub		; 2
     if copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256) then begin
	listing[i]   := '';
	listing[i+1] := '';
	Result:=false;
     end;


    if adc_sbc(i) and										// adc|sbc STACK	; 0
       (lda(i+1) or mwa(i+1)) then					// lda|mwa		; 1
     begin
	listing[i]   := '';
	Result:=false;
    end;


    if (lda(i) or adc_sbc(i)) and								// lda|adc|sbc		; 0
       ldy(i+1) and										// ldy			; 1
       (lda(i+2) or mva(i+2) or									// lda|mva|mwa		; 2
       mwa(i+2)) then
     begin
      listing[i] := '';
      Result:=false;
     end;


    if (pos('ldy #$', listing[i]) > 0) and lda_im(i+1) and 					// ldy #$xx		; 0
       sta(i+2) and (listing[i+3] = '') then							// lda #$xx		; 1
     if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) then				// sta			; 2
     begin
	listing[i+1] := #9'tya';
	Result:=false;
     end;


    if LDA_BP2_Y(i) and iny(i+1) and								// lda (:bp2),y
       LDA_BP2_Y(i+2) then begin									// iny
	listing[i] := '';									// lda (:bp2),y
	Result:=false;
    end;


    if iny(i) and LDA_BP2_Y(i+1) and								// iny
       iny(i+2) then begin									// lda (:bp2),y
	listing[i]   := '';									// iny
	listing[i+1] := '';
	listing[i+2] := '';
	Result:=false;
    end;


    if LDA_BP2_Y(i) and lda(i+1) then								// iny			; -1
     begin											// lda (:bp2),y		; 0
     												// lda			; 1
      listing[i] := '';
      if (i>0) and iny(i-1) then listing[i-1] := '';
      Result:=false;
     end;


    if lda(i) and (iy(i) = false) and						// lda			; 0
       (lda(i+1) or mva(i+1) or 								// lda|mva|mwa		; 1
        mwa(i+1)) then
     begin
      listing[i] := '';
      Result:=false;
     end;


    if lda(i) and mwa(i+2) then 						// lda			; 0
     if (tay(i+1) = false) and (sta(i+1) = false) then						// ~sta|tay		; 1
     begin											// mwa			; 2
      listing[i]   := '';
      listing[i+1] := '';
      Result:=false;
     end;


    if lda(i) and										// lda 			; 0
       (listing[i+1] = #9'and #$00') and							// and #$00		; 1
       sta(i+2) then										// sta 			; 2
     begin
	listing[i]   := '';
	listing[i+1] := #9'lda #$00';
	Result:=false;
     end;


    if sta_stack(i) and										// sta :STACK		; 0
       lda(i+1) and										// lda			; 1
       (pos('and :STACK', listing[i+2]) > 0) then						// and :STACK		; 2
      if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then
     begin
	listing[i]   := '';
	listing[i+1] := #9'and ' + copy(listing[i+1], 6, 256);
	listing[i+2] := '';
	Result:=false;
     end;


    if lda(i) and										// lda 			; 0
       (listing[i+1] = #9'ora #$00') and							// ora #$00		; 1
       sta(i+2) then										// sta 			; 2
     begin
	listing[i+1] := '';
	Result:=false;
     end;


    if lda(i) and										// lda 			; 0
       (listing[i+1] = #9'eor #$00') and							// eor #$00		; 1
       sta(i+2) then										// sta 			; 2
     begin
	listing[i+1] := '';
	Result:=false;
     end;


    if lda(i) and										// lda 			; 0
       (pos('and #$FF', listing[i+1]) > 0) and							// and #$FF		; 1
       sta(i+2) then										// sta 			; 2
     begin
	listing[i+1] := '';
	Result:=false;
     end;

    if lda(i) and										// lda 			; 0
       (pos('ora #$FF', listing[i+1]) > 0) and							// ora #$FF		; 1
       sta(i+2) then										// sta 			; 2
     begin
	listing[i]   := '';
	listing[i+1] := #9'lda #$FF';
	Result:=false;
     end;


    if lda_im(i) and										// lda #		; 0
       (pos('eor #', listing[i+1]) > 0) and							// eor #		; 1
       sta(i+2) then										// sta 			; 2
     begin

	p := GetBYTE(i) xor GetBYTE(i+1);

	listing[i]   := #9'lda #$'+IntToHex(p, 2);
	listing[i+1] := '';
	Result:=false;
     end;


{  !!! ta optymalizacja nie sprawdzila sie !!!

    if (lda(i) or sbc(i) or sub(i) or adc(i) or add(i)) and					// lda|sub|sbc|add|adc
       (lda(i+1) or mwa(i+1) or mva(i+1) ) then begin   			// lda|mva|mwa
	listing[i] := '';
	Result:=false;
       end;
}

    if Result and				// mamy pewnosc ze jest to pierwszy test sposrod wszystkich
       (add(i+1) = false) and (adc(i+1) = false) and					// clc		; 0
       (add(i+2) = false) and (adc(i+2) = false) then 					// <> add|adc	; 1
    if (listing[i] = #9'clc') then							// <> add|adc	; 2
    begin
	listing[i] := '';
	Result:=false;
    end;


    if (pos('sta :STACKORIGIN+STACKWIDTH', listing[i]) > 0) and				// sta :STACKORIGIN+STACKWIDTH	; 0
       (pos('lda :STACKORIGIN+STACKWIDTH*2', listing[i+1]) > 0) and			// lda :STACKORIGIN+STACKWIDTH*2; 1
       adc_sbc(i+2) and									// adc|sbc			; 2
       (pos('sta :STACKORIGIN+STACKWIDTH*2', listing[i+3]) > 0) and			// sta :STACKORIGIN+STACKWIDTH*2; 3
       (pos('lda :STACKORIGIN+STACKWIDTH*3', listing[i+4]) = 0) then			// ~lda :STACKORIGIN+STACKWIDTH*3; 4	skracamy do dwoch bajtow
     begin
       listing[i+1] := '';
       listing[i+2] := '';
       listing[i+3] := '';
       Result:=false;
     end;


    if (i>0) and
       (pos('lda :STACKORIGIN+STACKWIDTH*3', listing[i]) > 0) and			// lda :STACKORIGIN+STACKWIDTH*3; 0	wczesniej musi wystapic zapis do ':STACKORIGIN+STACKWIDTH*3'
       adc_sbc(i+1) and									// adc|sbc			; 1
       (pos('sta :STACKORIGIN+STACKWIDTH*3', listing[i+2]) > 0) then			// sta :STACKORIGIN+STACKWIDTH*3; 2
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) then
     begin

       yes:=false;
       for p:=i-1 downto 0 do
	if copy(listing[p], 6, 256) = copy(listing[i+2], 6, 256) then begin yes:=true; Break end;

       if not yes then begin
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';

	Result:=false;
       end;

     end;


    if (listing[i] = #9'lsr #$00') and (listing[i+1] = #9'ror @')  then			// lsr #$00
     begin										// ror @
	listing[i]   := #9'lsr @';
	listing[i+1] := '';
	Result:=false;
     end;


    if (listing[i] = #9'lsr #$00') and ror_stack(i+1) then				// lsr #$00
     begin										// ror :STACKORIGIN+STACKWIDTH*2+9
	listing[i]   := '';
	listing[i+1] := #9'lsr ' + copy(listing[i+1], 6, 256);
	Result:=false;
     end;


    if (listing[i] = #9'bne @+') and (listing[i+1] = #9'bne @+') then begin		// bne @+
	listing[i]   := '';								// bne @+
	listing[i+1] := '';
	Result:=false;
     end;


    if lda(i) and 									// lda #$00	; 0
       STA_BP2_Y(i+1) and 								// sta (:bp2),y	; 1
       iny(i+2) and									// iny		; 2 5 8
       lda(i+3) and 									// lda #$00	; 3 6 9
       STA_BP2_Y(i+4) then								// sta (:bp2),y ; 4 7 10
      if listing[i] = listing[i+3] then begin

	listing[i+3] := '';

	if iny(i+5) and lda(i+6) and STA_BP2_Y(i+7) then
	  if listing[i] = listing[i+6] then begin

	   listing[i+6] := '';

	   if iny(i+8) and lda(i+9) and STA_BP2_Y(i+10) then
	     if listing[i] = listing[i+9] then listing[i+9] := '';

	  end;

	Result:=false;
      end;


    if (listing[i] = #9'lsr #$00') and (listing[i+1] = #9'ror #$00') and
       ror_stack(i+2) and ror_stack(i+3) then begin
	listing[i]   := '';								// lsr #$00
	listing[i+1] := '';								// ror #$00
	listing[i+2] := #9'lsr ' + copy(listing[i+2], 6, 256);				// ror :STACKORIGIN+STACKWIDTH+9
	listing[i+3] := #9'ror ' + copy(listing[i+3], 6, 256);				// ror :STACKORIGIN+9
	Result:=false;
     end;


    if sty_stack(i) and 								// sty :STACKORIGIN+10
       lda_stack(i+1) then								// lda :STACKORIGIN+10
     if copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256) then begin
	listing[i]   := #9'tya';
	listing[i+1] := '';
	Result:=false;
     end;


    if sty_stack(i) and 								// sty :STACKORIGIN+10		; 0
       lda(i+1) and									// lda				; 1
       AND_ORA_EOR_STACK(i+2) then							// and|ora|eor :STACKORIGIN+10	; 2
     if copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256) then begin
	listing[i]   := #9'tya';

	listing[i+1] := copy(listing[i+2], 1,5) + copy(listing[i+1], 6, 256);

	listing[i+2] := '';
	Result:=false;
     end;


    if tya(i) and									// tya
       lda(i+1) and									// lda
       sta(i+2) then									// sta
     begin
	listing[i] := '';
	Result:=false;
     end;


    if sty_stack(i) and (pos('sty ', listing[i+1]) > 0) and				// sty :STACKORIGIN+10	; 0
       lda_stack(i+2) then								// sty			; 1
     if copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256) then begin		// lda :STACKORIGIN+10	; 2
	old := listing[i];
	listing[i]   := listing[i+1];
	listing[i+1] := old;
	Result:=false;
     end;


    if sta_stack(i) and (pos('sty ', listing[i+1]) > 0) and				// sta :STACKORIGIN+10	; 0
       (pos('sty ', listing[i+2]) > 0) and lda_stack(i+3) then				// sty			; 1
     if copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256) then begin		// sty			; 2
	listing[i]   := '';								// lda :STACKORIGIN+10	; 3
	listing[i+3] := '';
	Result:=false;
     end;


    if sta_stack(i) and (pos('sty ', listing[i+1]) > 0) and				// sta :STACKORIGIN+10	; 0
       lda_stack(i+2) then								// sty			; 1
     if copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256) then begin		// lda :STACKORIGIN+10	; 2
	listing[i]   := '';
	listing[i+2] := '';
	Result:=false;
     end;


    if sta_stack(i) and									// sta :STACKORIGIN+10	; 0
       ldy_stack(i+1) and								// ldy :STACKORIGIN+9	; 1
       lda_stack(i+2) and								// lda :STACKORIGIN+10	; 2
       sta_bp_y(i+3) then								// sta (:bp),y		; 3
     if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and
        (copy(listing[i], 6, 256) <> copy(listing[i+1], 6, 256)) then
      begin
	listing[i]   := '';
	listing[i+2] := '';
	Result:=false;
      end;


    if (listing[i] = #9'lda :eax') and tay(i+1) then					// lda :eax
     begin										// tay
	listing[i]   := #9'ldy :eax';
	listing[i+1] := '';
	Result:=false;
     end;


    if (pos('sta #', listing[i]) = 0) and						// sta :STACKORIGIN+10	; 0
       sta(i) and ldy(i+1) then								// ldy :STACKORIGIN+10	; 1
     if copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256) then begin
	listing[i]   := #9'tay';
	listing[i+1] := '';
	Result:=false;
     end;


    if lda(i) and (iy(i) = false) and							// lda
       tay(i+1) and iy(i+2) then							// tay
     begin										// lda|sta xxx,y
	listing[i]   := #9'ldy ' + copy(listing[i], 6, 256);
	listing[i+1] := '';
	Result:=false;
     end;


    if lda(i) and ldy(i+1) and								// lda		; 0
       (mwa(i+2) or lda(i+2)) then				// ldy		; 1
     begin										// mwa|lda	; 2
	listing[i] := '';
	Result:=false;
     end;


    if lda(i) and (iy(i) = false) and							// lda		; 0
       (listing[i+1] = #9'sub #$01') and						// sub #$01	; 1
       tay(i+2) and 									// tay		; 2
       (sbc(i+4) = false) then								// lda		; 3
     begin										// ~sbc		; 4
	if lda_im(i) then begin
	 p := GetBYTE(i);

	 listing[i]   := #9'ldy #$' + IntToHex((p-1) and $ff, 2);
	 listing[i+1] := '';
	 listing[i+2] := '';

	end else begin
	 listing[i]   := #9'ldy '+copy(listing[i], 6, 256);
	 listing[i+1] := #9'dey';
	 listing[i+2] := '';
	end;

	Result:=false;
     end;


    if ldy_im_0(i) and									// ldy #$00
       iny(i+1) then									// iny
     begin
	listing[i]   := #9'ldy #$01';
	listing[i+1] := '';
	Result:=false;
     end;


    if ldy_im(i) and lda_im(i+1) and							// ldy #
       (pos('sty ', listing[i+2]) > 0) and sta(i+3) then				// lda #
     if (copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256)) then begin		// sty
	listing[i+1] := '';								// sta
	listing[i+3] := #9'sty '+copy(listing[i+3], 6, 256);
	Result:=false;
     end;


    if sta_stack(i) and
       lda_stack(i+1) and sta(i+2) and							// sta :STACK+WIDTH+10	; 0
       lda_stack(i+3) and sta(i+4) and							// lda :STACK+10	; 1
       ldy(i+5) and lda(i+6) and							// sta :eax		; 2
       sta(i+7) and lda(i+8) and							// lda :STACK+WIDTH+10	; 3
       sta(i+9) then									// sta :eax+1		; 4
     if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) and 			// ldy :eax		; 5
	(copy(listing[i+2], 6, 256) = copy(listing[i+5], 6, 256)) then			// lda			; 6
     begin										// sta ,y		; 7
     	//listing[i]   := '';								// lda 			; 8
	listing[i+2] := #9'tay';							// sta ,y		; 9
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

      	Result:=false;
     end;


    if sta_stack(i) and									// sta STACK+9		; 0
       (iy(i+1) = false) and (iy(i+3) = false) and					// lda 			; 1
       lda(i+1) and sta_stack(i+2) and							// sta STACK+10		; 2
       lda(i+3) and sta_stack(i+4) and							// lda 			; 3
       ldy_stack(i+5) and lda_stack(i+6) and						// sta STACK+WIDTH+10	; 4
       sta(i+7) and lda_stack(i+8) and							// ldy STACK+9		; 5
       sta(i+9) then									// lda STACK+10		; 6
     if (copy(listing[i], 6, 256) = copy(listing[i+5], 6, 256)) and 			// sta			; 7
	(copy(listing[i+2], 6, 256) = copy(listing[i+6], 6, 256)) and			// lda STACK+WIDTH+10	; 8
	(copy(listing[i+4], 6, 256) = copy(listing[i+8], 6, 256)) then			// sta			; 9
     begin
	listing[i+6] := listing[i+1];
	listing[i+8] := listing[i+3];
	listing[i]   := #9'tay';

	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

      	Result:=false;
     end;


{
    if sta_stack(i) and lda_stack(i+1) and						// sta :STACKORIGIN+STACKWIDTH+11	// optymalizacje byte = byte * ? psuje
       (listing[i+2] = #9'sta :eax') and lda_stack(i+3) and				// lda :STACKORIGIN+11
       (listing[i+4] = #9'sta :eax+1') then 						// sta :eax
    if (copy(listing[i], 6, 256) = copy(listing[i+3], 6, 256)) then			// lda :STACKORIGIN+STACKWIDTH+11
     begin										// sta :eax+1
      	listing[i] := listing[i+4];
	listing[i+3] := '';
	listing[i+4] := '';
	Result:=false;
     end;
}

    if mwa_bp2(i) and									// mwa FIRST bp2		; 0
       mwa_bp2(i+7) and									// ldy #			; 1
       (listing[i+1] = listing[i+8]) and (listing[i+4] = listing[i+11]) and		// lda (:bp2),y			; 2
       LDA_BP2_Y(i+2) and LDA_BP2_Y(i+5) and						// sta :STACKORIGIN+9		; 3
       STA_BP2_Y(i+10) and STA_BP2_Y(i+13) and						// iny				; 4
       sta_stack(i+3) and sta_stack(i+6) and						// lda (:bp2),y			; 5
       lda_stack(i+9) and lda_stack(i+12) then						// sta :STACKORIGIN+STACKWIDTH+9; 6
     if (copy(listing[i+3], 6, 256) = copy(listing[i+9], 6, 256)) and			// mwa LAST bp2			; 7
	(copy(listing[i+6], 6, 256) = copy(listing[i+12], 6, 256)) then begin		// ldy #			; 8
											// lda :STACKORIGIN+9		; 9
	delete(listing[i+7], pos(' :bp2', listing[i+7]), 256);				// sta (:bp2),y			; 10
											// iny				; 11
	listing[i+1] := listing[i+7] + ' ztmp';						// lda :STACKORIGIN+STACKWIDTH+9; 12
	listing[i+2] := listing[i+8];							// sta (:bp2),y			; 13
	listing[i+3] := #9'lda (:bp2),y';
	listing[i+4] := #9'sta (ztmp),y';
	listing[i+5] := #9'iny';
	listing[i+6] := #9'lda (:bp2),y';
	listing[i+7] := #9'sta (ztmp),y';

	listing[i+8]  := '';
	listing[i+9]  := '';
	listing[i+10] := '';
	listing[i+11] := '';
	listing[i+12] := '';
	listing[i+13] := '';

	Result:=false;
     end;


// -----------------------------------------------------------------------------
// ===			optymalizacja :eax.			 	  === //
// -----------------------------------------------------------------------------

    if (listing[i] = #9'lda :eax') and (pos('sta :STACKORIGIN', listing[i+1]) > 0) and		// lda :eax			; 0
       (listing[i+2] = #9'lda :eax+1') and							// sta :STACKORIGIN		; 1
       (pos('sta :STACKORIGIN+STACKWIDTH', listing[i+3]) > 0) and				// lda :eax+1			; 2
       (listing[i+4] = #9'lda :eax+2') and							// sta :STACKORIGIN+STACKWIDTH	; 3
       (pos('sta :STACKORIGIN+STACKWIDTH*2', listing[i+5]) > 0) and				// lda :eax+2			; 4
       (listing[i+6] = #9'lda :eax+3') and							// sta :STACKORIGIN+STACKWIDTH*2; 5
       (pos('sta :STACKORIGIN+STACKWIDTH*3', listing[i+7]) > 0) and				// lda :eax+3			; 6
       (pos('lda :STACKORIGIN', listing[i+8]) > 0) and						// sta :STACKORIGIN+STACKWIDTH*3; 7
       sta(i+9) and										// lda :STACKORIGIN		; 8
       (listing[i+10] = '') then								// sta				; 9
     if (copy(listing[i+1], 6, 256) = copy(listing[i+8], 6, 256)) then
     begin
      listing[i+8] := listing[i];
      listing[i]   := '';
      listing[i+1] := '';
      listing[i+2] := '';
      listing[i+3] := '';
      listing[i+4] := '';
      listing[i+5] := '';
      listing[i+6] := '';
      listing[i+7] := '';

      Result:=false;
     end;


     if lda_stack(i) and (listing[i+1] = #9'sta :eax') and					// lda STACK	; 0
       lda_stack(i+2) and (listing[i+3] = #9'sta :eax+1') and					// sta :eax	; 1
       (listing[i+4] = #9'lda :eax') and sta_stack(i+5) and					// lda STACK+	; 2
       (pos('lda :eax+1', listing[i+6]) = 0) then						// sta :eax+1	; 3
     if (copy(listing[i+1], 6, 256) = copy(listing[i+4], 6, 256)) and 				// lda :eax	; 4
	(copy(listing[i+3], 6, 256) <> copy(listing[i+6], 6, 256)) then				// sta STACK	; 5
     begin											// lda Y	; 6
	listing[i+4] := listing[i];

	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	listing[i+3] := '';

      	Result:=false;
     end;


    if lda_stack(i) and (listing[i+1] = #9'sta :eax+1') and					// lda STACK	; 0
       lda_im_0(i+2) and (listing[i+3] = #9'sta :eax+2') and					// sta :eax+1	; 1
       (listing[i+4] = #9'sta :eax+3') then 							// lda #$00	; 2
     begin											// sta :eax+2	; 3
//     	listing[i+2] := '';									// sta :eax+3	; 4
	listing[i+3] := '';
	listing[i+4] := '';

      	Result:=false;
     end;


    if sta(i) and mva(i+1) and									// sta :eax	; 0
       (pos(copy(listing[i], 6, 256), listing[i+1]) = 6) then					// mva :eax v	; 1
     begin
	tmp := copy(listing[i], 6, 256);
	delete( listing[i+1], pos(tmp, listing[i+1]), length(tmp) + 1 );
	listing[i]   := #9'sta ' + copy(listing[i+1], 6, 256);
	listing[i+1] := '';

	Result:=false;
     end;


    if lda_stack(i) and (listing[i+1] = #9'sta :eax+1') and					// lda STACK	; 0	byte = byte * ?
       (pos('mva :eax ', listing[i+2]) > 0) and (pos('mva :eax+1 ', listing[i+3]) = 0) then	// sta :eax+1	; 1
     begin											// mva :eax v	; 2
	listing[i]   := '';
	listing[i+1] := '';

	Result:=false;
     end;


    if lda_stack(i) and										// lda :STACKORIGIN+10		; 0	word = byte * ?
       (listing[i+1] = #9'sta :eax') and							// sta :eax			; 1
       lda_stack(i+2) and 									// lda :STACKORIGIN+STACKWIDTH	; 2
       (listing[i+3] = #9'sta :eax+1') and							// sta :eax+1			; 3
       (pos('mva :eax ', listing[i+4]) > 0) and 						// mva :eax V			; 4
       (pos('mva :eax+1 ', listing[i+5]) > 0) then						// mva :eax+1 V+1		; 5
     begin
	delete( listing[i+4], pos(':eax', listing[i+4]), 4);
	delete( listing[i+5], pos(':eax+1', listing[i+5]), 6);
	listing[i+1] := #9'mva ' + copy(listing[i], 6, 256) + copy(listing[i+4], 6, 256);
	listing[i]   := #9'mva ' + copy(listing[i+2], 6, 256) + copy(listing[i+5], 6, 256);

	listing[i+2] := '';
	listing[i+3] := '';
	listing[i+4] := '';
	listing[i+5] := '';

	Result:=false;
     end;


// y:=256; while word(y)>=100  -> nie zadziala dla n/w optymalizacji
//
//    if lda(i) and cmp_im_0(i+1) and								// lda	   tylko dla <>0 lub =0
//       ((pos('beq ', listing[i+2]) > 0) or (pos('bne ', listing[i+2]) > 0)) then		// cmp #$00
//     begin											// beq | bne
//	listing[i+1] := '';
//     end;


  end;

  RemoveUnusedSTACK;

  end;


 begin				// OptimizeAssignment

 Result:=true;

 Rebuild;

 Clear;

 // czy zmienna STACK... zostala zaincjowana poprzez zapis wartosci ( = numer linii)
  for i := 0 to l - 1 do begin
    a := listing[i];

    if pos(':STACK', a) > 0 then begin

      if (pos('sta :STACK', a) > 0) or (pos('sty :STACK', a) > 0) then		// z 'ldy ' CIRCLE wygeneruje bledny kod
       v:=i
      else
       v:=-1;

      for j := 0 to 6 do
       for k := 0 to 3 do
	if pos(GetARG(k, j, false), a) > 0 then
	 if cnt[j, k] = 0 then cnt[j, k] := v else
	  if (cnt[j, k] > 0) and (v>0) then cnt[j, k] := v;

    end;

  end;


 // podglad
//  for i := 0 to l - 1 do
//   if Num(i) <> 0 then listing[i] := listing[i] + #9'; '+IntToStr( Num(i) );


 // jesli CNT < 0 podstawiamy #$00

  emptyStart := 0;
  emptyEnd := -1;

  //optimize.assign := false;

 if optimize.assign then

  for i := 0 to l - 1 do begin
     a := listing[i];

     if (pos('rol @', listing[i-1])=0) and (pos('ror @', listing[i-1])=0) then

     if pos(':STACK', a) = 6 then begin
      v := Num(i);

      if v < 0 then begin
	k:=pos(arg, a);
	delete(a, k, length(arg));
	insert('#$00', a, k);

	Result:=false;

// zostawiamy 'illegal instruction' aby eliminowac je podczas optymalizacji

//       if (pos('sta #$00', a) > 0) or (pos('sty #$00', a) > 0) or (pos('rol #$00', a) > 0) or (pos('ror #$00', a) > 0) then
//	listing[i] := ''
//       else

	listing[i] := a;
      end;


      if pos('mva :STACK', a) > 0 then begin

       if v+1 > emptyStart then emptyStart := v + 1;


       if (pos('(:bp2),y', a) > 0) then begin				// indexed mode (:bp2),y

	if emptyEnd<0 then emptyEnd := i - 2;

       end else
       if (pos(' adr.', a) > 0) and (pos(',y', a) > 0) then begin	// indexed mode  adr.NAME,y

	if emptyEnd<0 then emptyEnd := i - 1;

	listing[v] := listing[i-1] + #13#10+copy(listing[v], 1, pos(arg, listing[v])-1) + copy(a, pos(arg, a) + length(arg) + 1, 256);   // na ostatniej znanej pozycji podmieniamy
	listing[i-1] := ';' + listing[i - 1];
	listing[i] := ';' + listing[i];

	Result:=false;

       end else begin

	if emptyEnd<0 then emptyEnd := i;

	listing[v] := copy(listing[v], 1, pos(arg, listing[v])-1) + copy(a, pos(arg, a) + length(arg) + 1, 256);   // na ostatniej znanej pozycji podmieniamy
	listing[i] := ';' + listing[i];

	Result:=false;

       end;

      end;

     end;//if pos(':STACK',

  end;//for //if


  for i := emptyStart to emptyEnd-1 do		// usuwamy wszystko co nie jest potrzebne
   listing[i] := ';' + listing[i];


  repeat until PeepholeOptimization;
  repeat until PeepholeOptimization_STA;
  repeat until PeepholeOptimization_END;

  repeat until PeepholeOptimization;
  repeat until PeepholeOptimization_STA;
  repeat until PeepholeOptimization_END;

  repeat until PeepholeOptimization;
  repeat until PeepholeOptimization_STA;
  repeat until PeepholeOptimization_END;

 end;



 function OptimizeRelation: Boolean;
 var i, j, p: integer;
     a: string;
 begin
  // optymalizacja warunku

  Result := true;

  Rebuild;

  for i := 0 to l - 1 do
   if ldy_1(i) or cmp(i) then begin optimize.assign := false; Break end;


  // usuwamy puste '@'
  for i := 0 to l - 1 do begin
   if (pos('@+', listing[i]) > 0) then Break;
   if listing[i] = '@' then listing[i] := '';
  end;

  Rebuild;


  if not optimize.assign then
   for i := 0 to l - 1 do
    if listing[i] <> '' then begin

    if lda(i) and ldy_1(i+1) and								// lda		; 0
       (listing[i+2] = #9'and #$00') and (listing[i+3] = #9'bne @+') and			// ldy #1	; 1
       lda(i+4) then										// and #$00	; 2
     begin											// bne @+	; 3
	listing[i] := '';									// lda		; 4
	listing[i+2] := '';
	listing[i+3] := '';
	Result:=false;
     end;


    if (pos('and #$00', listing[i]) > 0) and (i>0) then						// lda #$00	; -1
     if pos('lda #$00', listing[i-1]) > 0 then begin						// and #$00	; 0
	listing[i] := '';
	Result:=false;
     end;


    if lda_im_0(i) and										// lda #$00	; 0
       (pos('bne ', listing[i+1]) > 0) and							// bne		; 1
       lda(i+2) then										// lda		; 2
     begin
	listing[i]   := '';
	listing[i+1] := '';
	Result:=false;
     end;


    if sta_stack(i) and										// sta :STACKORIGIN+9		; 0
       lda_stack(i+1) and									// lda :STACKORIGIN+10		; 1
       AND_ORA_EOR_STACK(i+2) and 								// ora|and|eor :STACKORIGIN+9	; 2
       sta_stack(i+3) then									// sta :STACKORIGIN+10		; 3
       if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and
          (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then
       begin
	listing[i]   := '';
	listing[i+1] := copy(listing[i+2], 1, 5) + copy(listing[i+1], 6, 256);
	listing[i+2] := '';
	Result:=false;
       end;


    if sty_stack(i) and lda_stack(i+1) and							// sty :STACKORIGIN+10		; 0
       AND_ORA_EOR_STACK(i+2) and								// lda :STACKORIGIN+9		; 1
       sta_stack(i+3) then									// ora|and|eor :STACKORIGIN+10	; 2
       if (copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256)) and				// sta :STACKORIGIN+9		; 3
          (copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256)) then
       begin
	listing[i]   := #9'tya';
	listing[i+1] := copy(listing[i+2], 1, 5) + copy(listing[i+1], 6, 256);
	listing[i+2] := '';
	Result:=false;
       end;


    if lda(i) and (listing[i+1] = #9'cmp #$80') and						// lda			; 0	>= 128
       (listing[i+2] = #9'bcs @+') and dey(i+3) then						// cmp #$80		; 1
     begin											// bcs @+		; 2
	listing[i+1] := #9'bmi @+';								// dey			; 3
	listing[i+2] := '';
	Result:=false;
     end;


    if lda(i) and (listing[i+1] = #9'cmp #$7F') and						// lda			; 0	> 127
       seq(i+2) and (listing[i+3] = #9'bcs @+') and						// cmp #$7F		; 1
       dey(i+4) then										// seq			; 2
     begin											// bcs @+		; 3
	listing[i+1] := #9'bmi @+';								// dey			; 4
	listing[i+2] := '';
	listing[i+3] := '';
	Result:=false;
     end;


    if lda(i) and (listing[i+1] = #9'cmp #$7F') and						// lda			; 0	<= 127
       (listing[i+2] = #9'bcc @+') and (listing[i+3] = #9'beq @+') and				// cmp #$7F		; 1
       dey(i+4) then										// bcc @+		; 2
     begin											// beq @+		; 3
	listing[i+1] := #9'bpl @+';								// dey			; 4
	listing[i+2] := '';
	listing[i+3] := '';
	Result:=false;
     end;


    if lda(i) and (listing[i+1] = #9'cmp #$7F') and						// lda			; 0	<= 127	FOR
       (listing[i+2] = #9'bcc *+7') and (listing[i+3] = #9'beq *+5') then			// cmp #$7F		; 1
     begin											// bcc *+7		; 2
	listing[i+1] := #9'bpl *+5';								// beq *+5		; 3
	listing[i+2] := '';
	listing[i+3] := '';
	Result:=false;
     end;


    if lda(i) and 										// lda			; 0	!!! tylko dla <>0 lub =0 !!!  beq|bne !!!
       cmp_im_0(i+1) and									// cmp #$00		; 1	!!! to oznacza krotki test !!!
       dey(i+3) and										// beq|bne|seq|sne	; 2
       ((pos('beq ', listing[i+2]) > 0) or (pos('bne ', listing[i+2]) > 0) or			// dey			; 3
	seq(i+2) or sne(i+2)) then
     begin
	listing[i+1] := '';
	Result:=false;
     end;


    if lda(i) and										// lda			; 0	!!! tylko dla <>0 lub =0 !!!  beq|bne !!!
       cmp_im_0(i+1) and									// cmp #$00		; 1
       (listing[i+2] = '@') and									// @			; 2	!!! to oznacza krotki test !!!
       dey(i+4) and										// beq|bne		; 3
       ((pos('beq ', listing[i+3]) > 0) or (pos('bne ', listing[i+3]) > 0)) then		// dey			; 4
     begin
	listing[i+1] := '';
	Result:=false;
     end;


    if lda(i) and										// lda			; 0	!!! tylko dla <>0 lub =0 !!!  beq|bne !!!
       cmp_im_0(i+1) and									// cmp #$00		; 1
       ((pos('beq ', listing[i+2]) > 0) or (pos('bne ', listing[i+2]) > 0)) and			// beq|bne		; 2
       lda(i+3) and										// lda			; 3
       (listing[i+4] = '@') and									// @			; 4
       ((pos('beq ', listing[i+5]) > 0) or (pos('bne ', listing[i+5]) > 0)) and			// beq|bne		; 5
       dey(i+6) then										// dey			; 6
     begin
	listing[i+1] := '';
	Result:=false;
     end;


    if lda(i) and										// lda			; 0	!!! tylko dla <>0 lub =0 !!!  beq|bne !!!
       cmp_im_0(i+1) and									// cmp #$00		; 1
       (listing[i+2] = '@') and									// @			; 2	!!! to oznacza krotki test !!!
       dey(i+5) and										// seq			; 3
       seq(i+3) and										// bpl|bcs		; 4
       ((pos('bpl ', listing[i+4]) > 0) or (pos('bcs ', listing[i+4]) > 0)) then		// dey			; 5
     begin
	listing[i+1] := '';
	Result:=false;
     end;


     if lda_im_0(i) and										// lda #$00		; 0	!!! tylko dla <>0 lub =0 !!!  beq|bne !!!
        cmp_im_0(i+1) and									// cmp #$00		; 1
       	(pos('bne ', listing[i+2]) > 0) then							// bne 			; 2	!!! to oznacza krotki test !!!
     begin
	listing[i]   := '';
	listing[i+1] := '';
	listing[i+2] := '';
	Result:=false;
     end;


    if and_ora_eor(i) and 									// and|ora|eor #	; 0
       (iy(i) = false) and									// ldy #1		; 1
       ldy_1(i+1) and										// cmp #$00		; 2
       cmp_im_0(i+2) and									// beq|bne		; 3
       ((pos('beq ', listing[i+3]) > 0) or (pos('bne ', listing[i+3]) > 0) ) then
     begin
	a := listing[i];
	listing[i]   := listing[i+1];
	listing[i+1] := a;
	listing[i+2] := '';
	Result:=false;
     end;


    if sta_stack(i) and lda_stack(i+1) then							// sta :STACKORIGIN+9	; 0
     if copy(listing[i], 6, 256) = copy(listing[i+1], 6, 256) then begin			// lda :STACKORIGIN+9	; 1
	listing[i]   := '';
	listing[i+1] := '';
	Result:=false;
     end;


    if and_ora_eor(i) and (iy(i) = false) and							// and|ora|eor		; 0
       sta_stack(i+1) and ldy_1(i+2) and							// sta :STACKORIGIN+N	; 1
       lda_stack(i+3) and 									// ldy #1		; 2
       ((listing[i+4] = #9'bne @+') or (listing[i+4] = #9'beq @+')) then			// lda :STACKORIGIN+N	; 3
     if copy(listing[i+1], 6, 256) = copy(listing[i+3], 6, 256) then begin			// beq @+|bneQ+		; 4
       listing[i+1] := '';
       listing[i+3] := listing[i];
       listing[i]   := '';
       Result:=false;
      end;


    if sta_stack(i) and										// sta :STACKORIGIN+9	; 0
       lda(i+1) and 										// lda			; 1
       cmp_stack(i+2) and	 								// cmp :STACKORIGIN+9	; 2
       ((pos('jeq l_', listing[i+3]) > 0) or (pos('jne l_', listing[i+3]) > 0)) then		// jeq|jne		; 3
     if copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256) then begin
       listing[i+1] := #9'cmp ' + copy(listing[i+1], 6, 256);

       listing[i]   := '';
       listing[i+2] := '';
       Result:=false;
      end;


    if (cmp(i) or lda(i) or and_ora_eor(i)) and							// cmp|lda|and|ora|eor	; 0
       ((listing[i+1] = #9'beq @+') or (listing[i+1] = #9'bne @+') or				// beq|bne @+		; 1
        (listing[i+1] = #9'bcc @+')) and							// bcc|bcs @+		; 1
       dey(i+2) and	 									// dey			; 2
       (listing[i+3] = '@') and									//@			; 3
       tya(i+4) and										// tya			; 4
       (pos('jeq l_', listing[i+5]) > 0) then							// jeq			; 5
     begin

       if listing[i+1] = #9'bcc @+' then
        listing[i+1] := #9'jcs ' + copy(listing[i+5], 6, 256)
       else
       if listing[i+1] = #9'bne @+' then
        listing[i+1] := #9'jeq ' + copy(listing[i+5], 6, 256)
       else
        listing[i+1] := #9'jne ' + copy(listing[i+5], 6, 256);

       listing[i+2] := '';
       listing[i+3] := '';
       listing[i+4] := '';
       listing[i+5] := '';

	for p:=i-1 downto 0 do
	 if listing[p] = #9'ldy #1' then begin listing[p]:=''; Break end;

       Result:=false;
      end;


    if ldy_1(i) and lda(i+1) and 								// ldy #1		; 0
       sta_stack(i+2) and iy(i+1) and								// lda ,y		; 1
       lda(i+3) and (iy(i+3) = false) and							// sta :STACKORIGIN+N	; 2
       cmp_stack(i+4) then			 						// lda 			; 3
     if copy(listing[i+2], 6, 256) = copy(listing[i+4], 6, 256) then begin			// cmp :STACKORIGIN+N	; 4
       listing[i+4] := #9'cmp ' + copy(listing[i+1], 6, 256);
       listing[i+1] := '';
       listing[i+2] := '';
       Result:=false;
      end;


    if sta_stack(i) and										// sta :STACKORIGIN+N	; 0
       ldy_1(i+1) and										// ldy #1		; 1
       lda_stack(i+2) and									// lda :STACKORIGIN+N	; 2
       (cmp(i+3) or AND_ORA_EOR(i+3)) then							// cmp|and|ora|eor	; 3
     if copy(listing[i], 6, 256) = copy(listing[i+2], 6, 256) then begin
       listing[i]   := '';
       listing[i+2] := '';
       Result:=false;
      end;


    if (iy(i) = false) and (iy(i+2) = false) and						// lda :eax				; 0
       (iy(i+4) = false) and (iy(i+6) = false) and						// sta :STACKORIGIN+10			; 1
       lda(i) and										// lda :eax+1				; 2
       sta_stack(i+1) and									// sta :STACKORIGIN+STACKWIDTH+10	; 3
       lda(i+2) and										// lda :eax+2				; 4
       sta_stack(i+3) and									// sta :STACKORIGIN+STACKWIDTH*2+10	; 5
       lda(i+4) and										// lda :eax+3				; 6
       sta_stack(i+5) and									// sta :STACKORIGIN+STACKWIDTH*3+10	; 7
       lda(i+6) and										// ldy #1				; 8
       sta_stack(i+7) and									// lda					; 9
       ldy_1(i