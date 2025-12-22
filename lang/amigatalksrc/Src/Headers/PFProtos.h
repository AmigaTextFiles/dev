/****h* AmigaTalk/PFProtos.h [2.5] ***********************************
*
* NAME
*    PFProtos.h
*
* DESCRIPTION
*    Header file of function prototypes for Primitive.c for the 
*    Functions located in PrimFuncs.c
*
* NOTES
*    $VER: PFProtos.h 2.5 (07-Oct-2003) by J.T. Steichen
**********************************************************************
* 
*/

#ifndef  PRIMFUNCPROTOS_H
# define PRIMFUNCPROTOS_H 1

IMPORT OBJECT *FindObjectClass(     int numargs, OBJECT **args ); // 1
IMPORT OBJECT *FindSuperObject(     int numargs, OBJECT **args );
IMPORT OBJECT *ClassRespondsToNew(  int numargs, OBJECT **args ); // 3
IMPORT OBJECT *ObjectSize(          int numargs, OBJECT **args );
IMPORT OBJECT *ObjectHashNum(       int numargs, OBJECT **args );
IMPORT OBJECT *ObjectSameType(      int numargs, OBJECT **args );
IMPORT OBJECT *ObjectsEqual(        int numargs, OBJECT **args );
IMPORT OBJECT *ToggleDebug(         int numargs, OBJECT **args );
IMPORT OBJECT *GeneralityCompare(   int numargs, OBJECT **args );
IMPORT OBJECT *AddIntegers(         int numargs, OBJECT **args ); // 10
IMPORT OBJECT *SubIntegers(         int numargs, OBJECT **args );
IMPORT OBJECT *Int_CharLessThan(    int numargs, OBJECT **args );
IMPORT OBJECT *Int_CharGreaterThan( int numargs, OBJECT **args );
IMPORT OBJECT *Int_CharLEQ(         int numargs, OBJECT **args );
IMPORT OBJECT *Int_CharGEQ(         int numargs, OBJECT **args );
IMPORT OBJECT *Int_CharEQ(          int numargs, OBJECT **args );
IMPORT OBJECT *Int_CharNEQ(         int numargs, OBJECT **args );
IMPORT OBJECT *MultIntegers(        int numargs, OBJECT **args );
IMPORT OBJECT *DSlashIntegers(      int numargs, OBJECT **args );
IMPORT OBJECT *GCDIntegers(         int numargs, OBJECT **args );
IMPORT OBJECT *BitAt(               int numargs, OBJECT **args );
IMPORT OBJECT *BitOR(               int numargs, OBJECT **args );
IMPORT OBJECT *BitAND(              int numargs, OBJECT **args );
IMPORT OBJECT *BitXOR(              int numargs, OBJECT **args );
IMPORT OBJECT *BitShift(            int numargs, OBJECT **args );
IMPORT OBJECT *IntegerRadix(        int numargs, OBJECT **args );
IMPORT OBJECT *DivIntegers(         int numargs, OBJECT **args );
IMPORT OBJECT *ModulusIntegers(     int numargs, OBJECT **args );

IMPORT OBJECT *DoPrimitive_2Args( int numargs, OBJECT **args ); /* 30 */
IMPORT OBJECT *RandomFloat(       int numargs, OBJECT **args ); /* 32 */
IMPORT OBJECT *BitInverse(        int numargs, OBJECT **args ); /* 33 */
IMPORT OBJECT *HighBit(           int numargs, OBJECT **args ); /* 34 */
IMPORT OBJECT *RandomNumber(      int numargs, OBJECT **args ); /* 35 */
IMPORT OBJECT *IntegerToChar(     int numargs, OBJECT **args ); /* 36 */
IMPORT OBJECT *IntegerToString(   int numargs, OBJECT **args ); /* 37 */
IMPORT OBJECT *Factorial(         int numargs, OBJECT **args ); /* 38 */
IMPORT OBJECT *IntegerToFloat(    int numargs, OBJECT **args ); /* 39 */

IMPORT OBJECT *DigitValue(    int numargs, OBJECT **args ); /* 50 */
IMPORT OBJECT *IsVowelPf(     int numargs, OBJECT **args ); /* 51 */
IMPORT OBJECT *IsAlphaPf(     int numargs, OBJECT **args ); /* 52 */
IMPORT OBJECT *IsLowerPf(     int numargs, OBJECT **args ); /* 53 */
IMPORT OBJECT *IsUpperPf(     int numargs, OBJECT **args ); /* 54 */
IMPORT OBJECT *IsSpacePf(     int numargs, OBJECT **args ); /* 55 */
IMPORT OBJECT *IsAlNumPf(     int numargs, OBJECT **args ); /* 56 */
IMPORT OBJECT *ChangeCase(    int numargs, OBJECT **args ); /* 57 */
IMPORT OBJECT *CharToString(  int numargs, OBJECT **args ); /* 58 */
IMPORT OBJECT *CharToInteger( int numargs, OBJECT **args ); /* 59 */

IMPORT OBJECT *AddFloats(        int numargs, OBJECT **args ); /* 60 */
IMPORT OBJECT *SubFloats(        int numargs, OBJECT **args ); /* 61 */
IMPORT OBJECT *FloatLessThan(    int numargs, OBJECT **args ); /* 62 */
IMPORT OBJECT *FloatGreaterThan( int numargs, OBJECT **args ); /* 63 */
IMPORT OBJECT *FloatLEQ(         int numargs, OBJECT **args ); /* 64 */
IMPORT OBJECT *FloatGEQ(         int numargs, OBJECT **args ); /* 65 */
IMPORT OBJECT *FloatEQ(          int numargs, OBJECT **args ); /* 66 */
IMPORT OBJECT *FloatNEQ(         int numargs, OBJECT **args ); /* 67 */
IMPORT OBJECT *MultFloats(       int numargs, OBJECT **args ); /* 68 */
IMPORT OBJECT *DivFloats(        int numargs, OBJECT **args ); /* 69 */

IMPORT OBJECT *NaturalLog(    int numargs, OBJECT **args ); /* 70 */
IMPORT OBJECT *SquareRoot(    int numargs, OBJECT **args ); /* 71 */
IMPORT OBJECT *Floor(         int numargs, OBJECT **args ); /* 72 */
IMPORT OBJECT *Ceiling(       int numargs, OBJECT **args ); /* 73 */
IMPORT OBJECT *IntegerPart(   int numargs, OBJECT **args ); /* 75 */
IMPORT OBJECT *FractionPart(  int numargs, OBJECT **args ); /* 76 */
IMPORT OBJECT *GammaFunc(     int numargs, OBJECT **args ); /* 77 */
IMPORT OBJECT *FloatToString( int numargs, OBJECT **args ); /* 78 */
IMPORT OBJECT *Exponent(      int numargs, OBJECT **args ); /* 79 */

IMPORT OBJECT *NormalizeRadian( int numargs, OBJECT **args ); /* 80 */
IMPORT OBJECT *Sin_(            int numargs, OBJECT **args ); /* 81 */
IMPORT OBJECT *Cos_(            int numargs, OBJECT **args ); /* 82 */
IMPORT OBJECT *ASin_(           int numargs, OBJECT **args ); /* 84 */
IMPORT OBJECT *ACos_(           int numargs, OBJECT **args ); /* 85 */
IMPORT OBJECT *ATan_(           int numargs, OBJECT **args ); /* 86 */
IMPORT OBJECT *Power(           int numargs, OBJECT **args ); /* 88 */
IMPORT OBJECT *FloatRadixPrint( int numargs, OBJECT **args ); /* 89 */

/* 90 - Not Used. */
IMPORT OBJECT *SymbolCompare(  int numargs, OBJECT **args ); /* 91 */
IMPORT OBJECT *SymbolToString( int numargs, OBJECT **args ); /* 92 */
IMPORT OBJECT *SymbolAsString( int numargs, OBJECT **args ); /* 93 */
IMPORT OBJECT *SymbolPrint(    int numargs, OBJECT **args ); /* 94 */

IMPORT OBJECT *instanceVarAccess( int numargs, OBJECT **args ); // 95 -- added on 07-Oct-2003

IMPORT OBJECT *ASCIIValue(     int numargs, OBJECT **args ); // 96
IMPORT OBJECT *NewClass(       int numargs, OBJECT **args ); /* 97 */
IMPORT OBJECT *InstallClass(   int numargs, OBJECT **args ); /* 98 */
IMPORT OBJECT *FindClass(      int numargs, OBJECT **args ); /* 99 */

IMPORT OBJECT *StringLen(        int numargs, OBJECT **args ); /* 100 */
IMPORT OBJECT *StringCompare(    int numargs, OBJECT **args ); /* 101 */
IMPORT OBJECT *StringCompNoCase( int numargs, OBJECT **args ); /* 102 */
IMPORT OBJECT *String_Cat(       int numargs, OBJECT **args ); /* 103 */
IMPORT OBJECT *StringAt(         int numargs, OBJECT **args ); /* 104 */
IMPORT OBJECT *StringAtPut(      int numargs, OBJECT **args ); /* 105 */
IMPORT OBJECT *CopyFromLength(   int numargs, OBJECT **args ); /* 106 */
IMPORT OBJECT *String_Copy(      int numargs, OBJECT **args ); /* 107 */
IMPORT OBJECT *StringAsSymbol(   int numargs, OBJECT **args ); /* 108 */
IMPORT OBJECT *StrPrintString(   int numargs, OBJECT **args ); /* 109 */

IMPORT OBJECT *New_Object(     int numargs, OBJECT **args ); /* 110 */
IMPORT OBJECT *ObjectAt(       int numargs, OBJECT **args ); /* 111 */
IMPORT OBJECT *ObjectAtPut(    int numargs, OBJECT **args ); /* 112 */
IMPORT OBJECT *ObjectGrow(     int numargs, OBJECT **args ); /* 113 */
IMPORT OBJECT *NewArray(       int numargs, OBJECT **args ); /* 114 */
IMPORT OBJECT *NewString(      int numargs, OBJECT **args ); /* 115 */
IMPORT OBJECT *NewByteArray(   int numargs, OBJECT **args ); /* 116 */
IMPORT OBJECT *ByteArraySize(  int numargs, OBJECT **args ); /* 117 */
IMPORT OBJECT *ByteArrayAt(    int numargs, OBJECT **args ); /* 118 */
IMPORT OBJECT *ByteArrayAtPut( int numargs, OBJECT **args ); /* 119 */

IMPORT OBJECT *PrintNOReturn(  int numargs, OBJECT **args ); /* 120 */
IMPORT OBJECT *Print_Return(   int numargs, OBJECT **args ); /* 121 */
IMPORT OBJECT *FormatError(    int numargs, OBJECT **args ); /* 122 */
IMPORT OBJECT *ErrorPrint(     int numargs, OBJECT **args ); /* 123 */
IMPORT OBJECT *CursesPrim(     int numargs, OBJECT **args ); /* 124 */
IMPORT OBJECT *SystemCall(     int numargs, OBJECT **args ); /* 125 */
IMPORT OBJECT *PrintAt(        int numargs, OBJECT **args ); /* 126 */
IMPORT OBJECT *BlockReturn(    int numargs, OBJECT **args ); /* 127 */
IMPORT OBJECT *ReferenceError( int numargs, OBJECT **args ); /* 128 */
IMPORT OBJECT *DoesNotRespond( int numargs, OBJECT **args ); /* 129 */

IMPORT OBJECT *FileOpen(        int numargs, OBJECT **args ); /* 130 */
IMPORT OBJECT *FileRead(        int numargs, OBJECT **args ); /* 131 */
IMPORT OBJECT *FileWrite(       int numargs, OBJECT **args ); /* 132 */
IMPORT OBJECT *SetFileMode(     int numargs, OBJECT **args ); /* 133 */
IMPORT OBJECT *GetFileSize(     int numargs, OBJECT **args ); /* 134 */
IMPORT OBJECT *SetFilePosition( int numargs, OBJECT **args ); /* 135 */
IMPORT OBJECT *GetFilePosition( int numargs, OBJECT **args ); /* 136 */
IMPORT OBJECT *HandleClassInfo( int numargs, OBJECT **args ); // 137  in ClDict.c
IMPORT OBJECT *HandleSupervisor(int numargs, OBJECT **args ); // 138  in Global.c
IMPORT OBJECT *FileClose(       int numargs, OBJECT **args ); // 139

IMPORT OBJECT *BlockExecute(      int numargs, OBJECT **args ); /* 140 */
IMPORT OBJECT *NewProcessPrim(    int numargs, OBJECT **args ); /* 141 */
IMPORT OBJECT *TerminateProcess(  int numargs, OBJECT **args ); /* 142 */
IMPORT OBJECT *Perform_W_Args(    int numargs, OBJECT **args ); /* 143 */
IMPORT OBJECT *SetProcessState(   int numargs, OBJECT **args ); /* 145 */
IMPORT OBJECT *GetProcessState(   int numargs, OBJECT **args ); /* 146 */
IMPORT OBJECT *BeginAtomicAction( int numargs, OBJECT **args ); /* 148 */
IMPORT OBJECT *EndAtomicAction(   int numargs, OBJECT **args ); /* 149 */

IMPORT OBJECT *EditClass(        int numargs, OBJECT **args ); /* 150 */
IMPORT OBJECT *FindSuperClass(   int numargs, OBJECT **args ); /* 151 */
IMPORT OBJECT *GetClassName(     int numargs, OBJECT **args ); /* 152 */
IMPORT OBJECT *ClassNew(         int numargs, OBJECT **args ); /* 153 */
IMPORT OBJECT *PrintMessages(    int numargs, OBJECT **args ); /* 154 */
IMPORT OBJECT *ClassRespondsTo(  int numargs, OBJECT **args ); /* 155 */
IMPORT OBJECT *ViewClass(        int numargs, OBJECT **args ); /* 156 */
IMPORT OBJECT *ListSubClasses(   int numargs, OBJECT **args ); /* 157 */
IMPORT OBJECT *ClassesInstVars(  int numargs, OBJECT **args ); /* 158 */
IMPORT OBJECT *GetByteCodeArray( int numargs, OBJECT **args ); /* 159 */

IMPORT OBJECT *GetCurrentTime(  int numargs, OBJECT **args ); /* 160 */
IMPORT OBJECT *TimeCounter(     int numargs, OBJECT **args ); /* 161 */
IMPORT OBJECT *PFClearScreen(   int numargs, OBJECT **args ); /* 162 */
IMPORT OBJECT *GetString(       int numargs, OBJECT **args ); /* 163 */
IMPORT OBJECT *StringToInteger( int numargs, OBJECT **args ); /* 164 */
IMPORT OBJECT *StringToFloat(   int numargs, OBJECT **args ); /* 165 */

# ifdef PLOT3

// Moved to PlotFuncs.c file:

IMPORT OBJECT *PlotArc(      int numargs, OBJECT **args ); /* 168 */
IMPORT OBJECT *PlotEnv(      int numargs, OBJECT **args ); /* 169 */
IMPORT OBJECT *PlotClear(    int numargs, OBJECT **args ); /* 170 */
IMPORT OBJECT *PlotMove(     int numargs, OBJECT **args ); /* 171 */
IMPORT OBJECT *PlotContinue( int numargs, OBJECT **args ); /* 172 */
IMPORT OBJECT *PlotPoint(    int numargs, OBJECT **args ); /* 173 */
IMPORT OBJECT *PlotCircle(   int numargs, OBJECT **args ); /* 174 */
IMPORT OBJECT *PlotBox(      int numargs, OBJECT **args ); /* 175 */
IMPORT OBJECT *PlotSetPens(  int numargs, OBJECT **args ); /* 176 */
IMPORT OBJECT *PlotLine(     int numargs, OBJECT **args ); /* 177 */
IMPORT OBJECT *PlotLabel(    int numargs, OBJECT **args ); /* 178 */
IMPORT OBJECT *PlotLineType( int numargs, OBJECT **args ); /* 179 */

# endif

#endif

/* ------------ END of PrimFuncProtos.h file! ------------------- */
