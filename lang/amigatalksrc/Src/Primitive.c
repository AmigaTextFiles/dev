/****h* AmigaTalk/Primitive.c [3.0] ********************************
*
* NAME
*    Primitive.c
*
* DESCRIPTION
*    The primitive function has been changed to call primitives via 
*    an array of function pointers returning object *.
*
* NOTES
*    Most of the primitive functionality can be found in PrimFuncs.c
*
*    $VER: AmigaTalk:Src/Primitive.c 3.0 (28-Nov-2003) by J.T Steichen
*
* HISTORY
*    28-Nov-2003 - Added the needRadix flag for <26>.
*
*    09-Nov-2003 - Added TraceFile test for NULL(s).
*
*    07-Oct-2003 - Added primitive <95> instanceVarAccess().
* 
***********************************************************************
*
*/

#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <errno.h>
#include <time.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <dos/dos.h>

#ifdef __SASC

# include <clib/dos_protos.h>

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>

IMPORT struct Library *SysBase;
IMPORT struct Library *DOSBase;

IMPORT struct ExecIFace *IExec;
IMPORT struct DOSIFace  *IDOS;
 
#endif

#include "Env.h"

#ifdef     CURSES
# include <curses.h>    // Needs more primitive support.
#endif

#include "ATStructs.h"

#include "object.h"
#include "drive.h"
#include "file.h"

#include "Constants.h"
#include "FuncProtos.h"
#include "PFProtos.h"   // functions in PrimFuncs.c

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "StringConstants.h"
#include "StringIndexes.h"

// --------- Stuff from Global.c file: ------------------------------

IMPORT UBYTE *ErrMsg;       // For making error messages.

IMPORT BOOL  traceByteCodes;
IMPORT int   traceIndent;    // Not currently used.
IMPORT FILE *TraceFile;

IMPORT int cant_happen( int );
IMPORT int ChkArgCount( int need, int numargs, int primnumber );

// ------------------------------------------------------------------

IMPORT double  modf();
//IMPORT long    time();
IMPORT char   *ctime();

IMPORT int      errno;
IMPORT int      prntcmd;

IMPORT PROCESS *runningProcess;
IMPORT OBJECT  *o_object, *o_true, *o_false;
IMPORT OBJECT  *o_nil, *o_number, *o_magnitude;

#ifndef   TRUE

# define  TRUE  1
# define  FALSE 0

#endif

PUBLIC const int MAX_PRIM_BUFFER_SIZE = BUFF_SIZE;

PRIVATE char ErrorBuffer[ BUFF_SIZE ] = { 0, };

/* Globals used by the functions in PrimFuncs.c: */

PUBLIC struct file_struct *phil = NULL; 

PUBLIC int          leftint    = 0;
PUBLIC int          rightint   = 0; // args[0] & args[1]
PUBLIC int          i          = 0;
PUBLIC int          j          = 0; // also args[2] & args[3]
PUBLIC double       leftfloat  = 0.0;
PUBLIC double       rightfloat = 0.0;
PUBLIC long         myClock    = 0L;
PUBLIC BOOL         miscFlag   = FALSE;
PUBLIC BOOL         needRadix  = TRUE; // Added on 28-Nov-2003

PUBLIC OBJECT      *resultobj = NULL;
PUBLIC OBJECT      *leftarg   = NULL;
PUBLIC OBJECT      *rightarg  = NULL;

PUBLIC char        *leftp     = NULL; // args[0] == string
PUBLIC char        *rightp    = NULL; // args[1] == string

PUBLIC char        *errp      = &ErrorBuffer[0];
PUBLIC CLASS       *aClass    = NULL;
PUBLIC BYTEARRAY   *byarray   = NULL;

PUBLIC char         strbuffer[ BUFF_SIZE ] = { 0, }; // MAX_PRIM_BUFFER_SIZE ];
PUBLIC char         tempname[ 100 ]        = { 0, };

// --------------------------------------------------------------------

/****h* makeArgsArray() [3.0] *****************************************
*
* NAME
*    makeArgsArray()
*
* DESCRIPTION
*    make an Object that can be sent to primitive() as an argument
*    Array.  This is really a synonym for new_obj().
***********************************************************************
*
*/

PUBLIC OBJECT *makeArgsArray( int numelements )
{
   return( new_obj( (CLASS *) NULL, numelements, FALSE ) );
}

/****h* setArgInArray() [3.0] *****************************************
*
* NAME
*    setArgInArray()
*
* DESCRIPTION
*    Set an argument in an argument Array for primitive()
***********************************************************************
*
*/

PUBLIC void setArgInArray( OBJECT *argArray, int index, OBJECT *newArg )
{
   if ((index < 0) || (index > objSize( argArray )))
      return; // Index was out of bounds.
      
   argArray->inst_var[ index ] = AssignObj( newArg );
   
   return;
}

/****h* getArgInArray() [3.0] *****************************************
*
* NAME
*    getArgInArray()
*
* DESCRIPTION
*    Get an argument from an argument Array used by primitive()
*
* WARNINGS
*    If the supplied index is out of bounds nil will be returned.
***********************************************************************
*
*/

PUBLIC OBJECT *getArgInArray( OBJECT *argArray, int index )
{
   OBJECT *rval = o_nil;
   
   if ((index < 0) || (index > objSize( argArray )))
      return( rval ); // Index was out of bounds.
      
   rval = argArray->inst_var[ index ];
   
   return( rval );
}

/****i* ChkFileAttr() [2.3] ******************************************
*
* NAME
*    ChkFileAttr()
*
* DESCRIPTION
*    See if a file has a certain file attribute (protection) bit set.
*    Currently, only the writeable() function uses this.
**********************************************************************
*
*/

SUBFUNC BOOL ChkFileAttr( char *filename, char attr )
{
   struct FileInfoBlock *fib  = (struct FileInfoBlock *) NULL;
   BPTR                  lock = (BPTR) NULL;
   BOOL                  rval = FALSE, chk = FALSE;
   
   if (StringLength( filename ) < 1)
      return( rval );
      
   switch (attr) // Check for valid attr char:
      {
      case SMALL_R_CHAR: // readable
      case SMALL_W_CHAR: // writeable
      case SMALL_E_CHAR: // executable
      case SMALL_D_CHAR: // deleteable

      case SMALL_A_CHAR: // archived
      case SMALL_H_CHAR: // hidden
      case SMALL_P_CHAR: // pure
      case SMALL_S_CHAR: // script
         break;
         
      default:
         return( rval = FALSE ); // Invalid attribute
      }

   if (!(fib = (struct FileInfoBlock *) AllocDosObject( DOS_FIB, TAG_DONE ))) // == NULL)
      {
      MemoryOut( PrimCMsg( MSG_PR_CHKFILEATTR_PRIM ) );

      return( rval );
      }
      
   lock = Lock( filename, ACCESS_READ );

   if (((chk = Examine( lock, fib )) != FALSE)
         && (fib->fib_DirEntryType < 0))  // Found a file.
      {
      switch (attr)
         {
         case SMALL_R_CHAR: // readable
            if ((fib->fib_Protection & FIBF_READ) == 0)
               rval = TRUE;
            else
               rval = FALSE;
            
            break;
            
         case SMALL_W_CHAR: // writeable
            if ((fib->fib_Protection & FIBF_WRITE) == 0)
               rval = TRUE;
            else
               rval = FALSE;
            
            break;

         case SMALL_E_CHAR: // executable
            if ((fib->fib_Protection & FIBF_EXECUTE) == 0)
               rval = TRUE;
            else
               rval = FALSE;
            
            break;
            
         case SMALL_D_CHAR: // deleteable
            if ((fib->fib_Protection & FIBF_DELETE) == 0)
               rval = TRUE;
            else
               rval = FALSE;
            
            break;
            
         case SMALL_A_CHAR: // archived
            if ((fib->fib_Protection & FIBF_ARCHIVE) == FIBF_ARCHIVE)
               rval = TRUE;
            else
               rval = FALSE;
            
            break;
            
         case SMALL_H_CHAR: // hidden // FIBF_HOLD for __amigaos4__
            if ((fib->fib_Protection & FIBF_HIDDEN) == FIBF_HIDDEN)
               rval = TRUE;
            else
               rval = FALSE;
            
            break;
            
         case SMALL_P_CHAR: // pure
            if ((fib->fib_Protection & FIBF_PURE) == FIBF_PURE)
               rval = TRUE;
            else
               rval = FALSE;
            
            break;
            
         case SMALL_S_CHAR: // script
            if ((fib->fib_Protection & FIBF_SCRIPT) == FIBF_SCRIPT)
               rval = TRUE;
            else
               rval = FALSE;
            
            break;
         }
      }

   FreeDosObject( DOS_FIB, (void *) fib );
   
   UnLock( lock );
      
   return( rval );
}

/****i* writeable() [1.0] ********************************************
*
* NAME
*    writeable()
*
* DESCRIPTION
*    See if a file can be written to.
**********************************************************************
*
*/

PUBLIC int writeable( char *name )
{
   if (debug == TRUE)
      fprintf( stderr, PrimCMsg( MSG_PR_WRITEABLE_PRIM ), name );

   if (ChkFileAttr( name, SMALL_W_CHAR ) == TRUE)
      return( TRUE );
   else
      return( FALSE );
}

/* Primitive argument checkers: */

PUBLIC OBJECT *primitive( int, int, OBJECT ** );

/****h* ReturnError() [1.6] ******************************************
*
* NAME
*    ReturnError()
*
* DESCRIPTION
*    Inform User of messed-up messages or objects.
**********************************************************************
*
*/

PUBLIC OBJECT *ReturnError( void )
{
   char nil[256] = { 0, }, *msg = &nil[0];
      
   if (debug == TRUE)
      fprintf( stderr, PrimCMsg( MSG_PR_RETURNERROR_PRIM ) );

   sprintf( msg, PrimCMsg( MSG_FMT_PR_ERROR_PRIM ), errp );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, "\n%s\n", msg );
      }
            
   resultobj = AssignObj( new_str( errp ) );

   (void) primitive( ERRPRINT, 1, &resultobj );
   (void) obj_dec( resultobj );

   return( o_nil );
}

/****h* PrintArgTypeError() [1.6] ************************************
*
* NAME
*    PrintArgTypeError()
*
* DESCRIPTION
*    Inform User of wrong argument type being present.
**********************************************************************
*
*/

PUBLIC OBJECT *PrintArgTypeError( int primnumber )
{
   if (debug == TRUE)
      fprintf( stderr, PrimCMsg( MSG_PR_PRTARGTYPEERR_PRIM ), primnumber );

   sprintf( strbuffer, PrimCMsg( MSG_FMT_PR_ARGTYPE_PRIM ), primnumber );

   StringCopy( errp, strbuffer );

   return( ReturnError() );
}

/****h* PrintNumberError() [1.6] *************************************
*
* NAME
*    PrintNumberError()
*
* DESCRIPTION
*    Inform User of wrong number being present.
**********************************************************************
*
*/

PUBLIC OBJECT *PrintNumberError( void )
{
   if (debug == TRUE)
      fprintf( stderr, PrimCMsg( MSG_PR_PRTNUMBERERR_PRIM ) );

   StringCopy( errp, PrimCMsg( MSG_PR_NUMERICALERR_PRIM ) ); 

   return( ReturnError() );
}

/****h* PrintIndexError() [1.6] **************************************
*
* NAME
*    PrintIndexError()
*
* DESCRIPTION
*    Inform User of wrong index being present.
**********************************************************************
*
*/

PUBLIC OBJECT *PrintIndexError( void )
{
   if (debug == TRUE)
      fprintf( stderr, PrimCMsg( MSG_PR_PRTINDEXERR_PRIM ) );

   StringCopy( errp, PrimCMsg( MSG_PR_PRIMINDEXERR_PRIM ) );

   return( ReturnError() );
}

/****h* PrintArrayError() [1.6] **************************************
*
* NAME
*    PrintArrayError()
*
* DESCRIPTION
*    Inform User of wrong array element.
**********************************************************************
*
*/

PUBLIC OBJECT *PrintArrayError( OBJECT *obj )
{
   if (debug == TRUE)
      fprintf( stderr, PrimCMsg( MSG_PR_PRTARRAYERR_PRIM ), obj );

   StringCopy( errp, PrimCMsg( MSG_PR_PRIMARRAYERR_PRIM ) );

   if (obj->Class) // != NULL)
      {
      if (obj->Class->class_name) // != NULL)
         StringCat( errp, string_value( (STRING *) obj->Class->class_name ) );
      else
         StringCat( errp, PrimCMsg( MSG_PR_UNKCLASSNAME_PRIM ) );
      }
   else
      StringCat( errp, PrimCMsg( MSG_PR_BOOTSTRAP_PRIM ) );

   return( ReturnError() );
}

/* Functions called by the primitive numbers.  These functions are in
** numerical order: 
*/

/****i* UnusedPrimitive() [1.6] **************************************
*
* NAME
*    UnusedPrimitive()
*
* DESCRIPTION
*    Inform User that an unused primitive number was found.
*
* NOTES
*    Primitves 0, 27, 31, 40, 41, 48, 49, 74, 83, 87,
*              147, 166-167  are not used
**********************************************************************
*
*/

OBJECT *UnusedPrimitive( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PrimCMsg( MSG_PR_UNKPRIMITIVE_PRIM ), 
                       numargs, args, int_value( args[0] )
             );

   sprintf( ErrMsg, PrimCMsg( MSG_FMT_PR_UNUSED_PRIM ), int_value( args[0] ));

   UserInfo( ErrMsg, PrimCMsg( MSG_PR_PROGRMR_ERR_PRIM ) );

   if (TraceFile && traceByteCodes == TRUE)
      {
      fprintf( TraceFile, "\n%s\n", ErrMsg );
      }

   return( o_nil );   
}

/*  90 in Symbol.c */
IMPORT OBJECT *HandleMiscSymbolOps( int numargs, OBJECT **args );

/*  96 in PrimFuncs.c */
IMPORT OBJECT *ASCIIValue( int numargs, OBJECT **args );

/* 137 in ClDict.c */
IMPORT OBJECT *HandleClassInfo( int numargs, OBJECT **args );

/* 138 in Global.c */
IMPORT OBJECT *HandleSupervisor( int numargs, OBJECT **args );

/* 144 in PrimFuncs.c */
IMPORT OBJECT *BlockNumArgs( int numargs, OBJECT **args );

/* 180 in Screen.c */
IMPORT OBJECT *HandleScreens( int numargs, OBJECT **args );

/* 181 in Window.c */
IMPORT OBJECT *HandleWindows( int numargs, OBJECT **args ); 

/* 182 in Menus.c  */
IMPORT OBJECT *HandleMenus( int numargs, OBJECT **args );

/* 183 in Gadget.c */
IMPORT OBJECT *HandleGadgets( int numargs, OBJECT **args );

/* 184 in Colors.c */
IMPORT OBJECT *HandleColors( int numargs, OBJECT **args );

/* 185 in Requester.c */
IMPORT OBJECT *HandleRequesters( int numargs, OBJECT **args );

/* 186 in IO.c */
IMPORT OBJECT *HandleIO( int numargs, OBJECT **args );

/* 187 in Border.c */
IMPORT OBJECT *HandleBorders( int numargs, OBJECT **args );

/* 188 in ITextFont.c */
IMPORT OBJECT *HandleIText( int numargs, OBJECT **args );

/* 189 in Border.c */
IMPORT OBJECT *HandleBitMaps( int numargs, OBJECT **args );

/* 190 in Library.c */
IMPORT OBJECT *HandleLibraries( int numargs, OBJECT **args );

// 191 in MsgPorts.c
IMPORT OBJECT *HandleMsgPorts( int numargs, OBJECT **args );

/* 192 */
OBJECT *HandleTasks( int numargs, OBJECT **args )
{
   return( o_nil );
}

/* 193 */
OBJECT *HandleProcesses( int numargs, OBJECT **args ) 
{
   return( o_nil );
}

/* 194 */
OBJECT *HandleMemory( int numargs, OBJECT **args ) 
{
   return( o_nil );
}

/* 195 */
OBJECT *HandleLists( int numargs, OBJECT **args ) 
{
   return( o_nil );
}

/* 196 */
OBJECT *HandleInterrupts( int numargs, OBJECT **args ) 
{
   return( o_nil );
}

/* 197 */
OBJECT *HandleSemaphores( int numargs, OBJECT **args ) 
{
   return( o_nil );
}

/* 198 */
OBJECT *HandleSignals( int numargs, OBJECT **args ) 
{
   return( o_nil );
}

/* 199 */
OBJECT *HandleExceptions( int numargs, OBJECT **args ) 
{
   return( o_nil );
}

/* 200 in SimpleGraphs.c */
IMPORT OBJECT *HandleSimpleGraphs( int numargs, OBJECT **args );

/* 201 */
OBJECT *HandleAreas( int numargs, OBJECT **args ) 
{   
   return( o_nil );
}

OBJECT *HandleViewPorts( int numargs, OBJECT **args )
{
   return( o_nil );
}

OBJECT *HandleViews( int numargs, OBJECT **args )
{
   return( o_nil );
}

OBJECT *HandlePlayFields( int numargs, OBJECT **args )
{
   return( o_nil );
}

// 206 in SDict.c:
IMPORT OBJECT *HandleSDict( int numargs, OBJECT **args );

// 207 in Layers.c
IMPORT OBJECT *HandleLayers( int numargs, OBJECT **args );

// 209 in WBench.c
IMPORT OBJECT *HandleLibIntfc( int numargs, OBJECT **args );

// 210 in DTInterface.c (also some functions in TagFuncs.c):
IMPORT OBJECT *HandleDT( int numargs, OBJECT **args );

// 211 in Rexx.c
IMPORT OBJECT *HandleARexx( int numargs, OBJECT **args );

// 218 in CDROM.c:
IMPORT OBJECT *HandleMiscDevices( int numargs, OBJECT **args );

// 219 in Icon.c:
IMPORT OBJECT *HandleIcons( int numargs, OBJECT **args );

// 220 in Audio.c:
IMPORT OBJECT *HandleAudio( int numargs, OBJECT **args );

// 221 in ClipBoard.c:
IMPORT OBJECT *HandleClipBoard( int numargs, OBJECT **args );

// 222 in Keyboard.c:
IMPORT OBJECT *HandleConsoleKeys( int numargs, OBJECT **args );

// 223 in GamePort.c:
IMPORT OBJECT *HandleGamePort( int numargs, OBJECT **args );

// 224 in Parallel.c:
IMPORT OBJECT *HandleParallel( int numargs, OBJECT **args );

// 225 in Printer.c:
IMPORT OBJECT *HandlePrinter( int numargs, OBJECT **args );

// 226 in SCSI.c:
IMPORT OBJECT *HandleSCSI( int numargs, OBJECT **args );

// 227 in Serial.c:
IMPORT OBJECT *HandleSerial( int numargs, OBJECT **args );

// 229 in Disk.c:
IMPORT OBJECT *HandleDisk( int numargs, OBJECT **args );

#ifdef __SASC
// 230 in Narrator.c:
IMPORT OBJECT *HandleNarrator( int numargs, OBJECT **args );
#else
OBJECT *HandleNarrator( int numargs, OBJECT **args )
{
   return( o_nil );
}
#endif

// 238 in Boopsi.c:
IMPORT OBJECT *HandleBoopsi( int numargs, OBJECT **args ); 

// 239 in GadTools.c:
IMPORT OBJECT *HandleGadTools( int numargs, OBJECT **args ); 

// 240 in IFF.c:
IMPORT OBJECT *HandleIFF( int numargs, OBJECT **args ); 

// 246 in ADOS1.c:
IMPORT OBJECT *HandleADosSafe( int numargs, OBJECT **args );

// 247 in ADOS2.c:
IMPORT OBJECT *HandleADosUnSafe( int numargs, OBJECT **args );

// 248 in ADOS3.c:
IMPORT OBJECT *HandleADosDanger( int numargs, OBJECT **args );

// 249 in ADOS4.c:
IMPORT OBJECT *HandleADosVD( int numargs, OBJECT **args );

// 250 in System.c:
IMPORT OBJECT *HandleSystem( int numargs, OBJECT **args );

/* ------------------- Main function & support: ------------------------ */

typedef  OBJECT * (*ObjectFuncPtr)( int, OBJECT ** );

/* Primitives 0, 27, 31, 40, 41, 48, 49, 74, 83, 87,
**            144, 147, 166-167  are not used:
*/

// NOTE:  Change PrimStrs.h if any additions are made to this table:

ObjectFuncPtr  PrimitiveFunction[ 256 ] = {

   &UnusedPrimitive,    &FindObjectClass,     &FindSuperObject,   /* 2   */
   &ClassRespondsToNew, &ObjectSize,          &ObjectHashNum,     /* 5   */
   &ObjectSameType,     &ObjectsEqual,        &ToggleDebug,       /* 8   */
   &GeneralityCompare,  &AddIntegers,         &SubIntegers,       /* 11  */
   &Int_CharLessThan,   &Int_CharGreaterThan, &Int_CharLEQ,       /* 14  */
   &Int_CharGEQ,        &Int_CharEQ,          &Int_CharNEQ,       /* 17  */
   &MultIntegers,       &DSlashIntegers,      &GCDIntegers,       /* 20  */
   &BitAt,              &BitOR,               &BitAND,            /* 23  */
   &BitXOR,             &BitShift,            &IntegerRadix,      /* 26  */
   &UnusedPrimitive,    &DivIntegers,         &ModulusIntegers,   /* 29  */
   &DoPrimitive_2Args,  &UnusedPrimitive,     &RandomFloat,       /* 32  */
   &BitInverse,         &HighBit,             &RandomNumber,      /* 35  */
   &IntegerToChar,      &IntegerToString,     &Factorial,         /* 38  */
   &IntegerToFloat,     &UnusedPrimitive,     &UnusedPrimitive,   /* 41  */
   &Int_CharLessThan,   &Int_CharGreaterThan, &Int_CharLEQ,       /* 44  */
   &Int_CharGEQ,        &Int_CharEQ,          &Int_CharNEQ,       /* 47  */
   &UnusedPrimitive,    &UnusedPrimitive,     &DigitValue,        /* 50  */
   &IsVowelPf,          &IsAlphaPf,           &IsLowerPf,         /* 53  */
   &IsUpperPf,          &IsSpacePf,           &IsAlNumPf,         /* 56  */
   &ChangeCase,         &CharToString,        &CharToInteger,     /* 59  */
   &AddFloats,          &SubFloats,           &FloatLessThan,     /* 62  */
   &FloatGreaterThan,   &FloatLEQ,            &FloatGEQ,          /* 65  */
   &FloatEQ,            &FloatNEQ,            &MultFloats,        /* 68  */
   &DivFloats,          &NaturalLog,          &SquareRoot,        /* 71  */
   &Floor,              &Ceiling,             &UnusedPrimitive,   /* 74  */
   &IntegerPart,        &FractionPart,        &GammaFunc,         /* 77  */
   &FloatToString,      &Exponent,            &NormalizeRadian,   /* 80  */
   &Sin_,               &Cos_,                &UnusedPrimitive,   /* 83  */
   &ASin_,              &ACos_,               &ATan_,             /* 86  */
   &Power,              &FloatRadixPrint,     &SymbolCompare,     /* 89  */
   &HandleMiscSymbolOps,&SymbolCompare,       &SymbolToString,    /* 92  */
   &SymbolAsString,     &SymbolPrint,         &instanceVarAccess, /* 95  */
   &ASCIIValue,         &NewClass,            &InstallClass,      /* 98  */
   &FindClass,          &StringLen,           &StringCompare,     /* 101 */
   &StringCompNoCase,   &String_Cat,          &StringAt,          /* 104 */
   &StringAtPut,        &CopyFromLength,      &String_Copy,       /* 107 */
   &StringAsSymbol,     &StrPrintString,      &New_Object,        /* 110 */
   &ObjectAt,           &ObjectAtPut,         &ObjectGrow,        /* 113 */
   &NewArray,           &NewString,           &NewByteArray,      /* 116 */
   &ByteArraySize,      &ByteArrayAt,         &ByteArrayAtPut,    /* 119 */
   &PrintNOReturn,      &Print_Return,        &FormatError,       /* 122 */

   &ErrorPrint,

#  ifdef CURSES   
   &CursesPrim,
#  else
   &UnusedPrimitive,
#  endif
                                              &SystemCall,        /* 125 */

   &PrintAt,            &BlockReturn,         &ReferenceError,    /* 128 */
   &DoesNotRespond,     &FileOpen,            &FileRead,          /* 131 */
   &FileWrite,          &SetFileMode,         &GetFileSize,       /* 134 */
   &SetFilePosition,    &GetFilePosition,     &HandleClassInfo,   /* 137 */
   &HandleSupervisor,   &FileClose,           &BlockExecute,      /* 140 */
   &NewProcessPrim,     &TerminateProcess,    &Perform_W_Args,    /* 143 */
   &BlockNumArgs,       &SetProcessState,     &GetProcessState,   /* 146 */
   &UnusedPrimitive,    &BeginAtomicAction,   &EndAtomicAction,   /* 149 */
   &EditClass,          &FindSuperClass,      &GetClassName,      /* 152 */
   &ClassNew,           &PrintMessages,       &ClassRespondsTo,   /* 156 */
   &ViewClass,          &ListSubClasses,      &ClassesInstVars,   /* 158 */
   &GetByteCodeArray,   &GetCurrentTime,      &TimeCounter,       /* 161 */
   &PFClearScreen,      &GetString,           &StringToInteger,   /* 164 */
   &StringToFloat,      &UnusedPrimitive,     &UnusedPrimitive,   /* 167 */

#ifdef   PLOT3   
   &PlotArc,                                                      // 168  
   &PlotEnv,            &PlotClear,           &PlotMove,          /* 171 */
   &PlotContinue,       &PlotPoint,           &PlotCircle,        /* 174 */
   &PlotBox,            &PlotSetPens,         &PlotLine,          /* 177 */
   &PlotLabel,          &PlotLineType,
#else
   &UnusedPrimitive,                                              // 168
   &UnusedPrimitive,    &UnusedPrimitive,     &UnusedPrimitive,
   &UnusedPrimitive,    &UnusedPrimitive,     &UnusedPrimitive,
   &UnusedPrimitive,    &UnusedPrimitive,     &UnusedPrimitive,
   &UnusedPrimitive,    &UnusedPrimitive,
#endif
      
   &HandleScreens,                                                /* 180 */
   &HandleWindows,      &HandleMenus,         &HandleGadgets,     /* 183 */
   &HandleColors,       &HandleRequesters,    &HandleIO,          /* 186 */
   &HandleBorders,      &HandleIText,         &HandleBitMaps,     /* 189 */
   &HandleLibraries,    &HandleMsgPorts,      &HandleTasks,       /* 192 */
   &HandleProcesses,    &HandleMemory,        &HandleLists,       /* 196 */
   &HandleInterrupts,   &HandleSemaphores,    &HandleSignals,     /* 198 */
   &HandleExceptions,   &HandleSimpleGraphs,  &HandleAreas,       /* 201 */
   &HandleViewPorts,    &HandleViews,         &HandlePlayFields,  /* 204 */
   &UnusedPrimitive,    &HandleSDict,         &HandleLayers,      /* 207 */
   &UnusedPrimitive,    &HandleLibIntfc,      &HandleDT,          /* 210 */
   &HandleARexx,        &UnusedPrimitive,     &UnusedPrimitive,   /* 213 */
   &UnusedPrimitive,    &UnusedPrimitive,     &UnusedPrimitive,   /* 216 */
   &UnusedPrimitive,    &HandleMiscDevices,   &HandleIcons,       /* 219 */
   &HandleAudio,        &HandleClipBoard,     &HandleConsoleKeys, /* 222 */
   &HandleGamePort,     &HandleParallel,      &HandlePrinter,     /* 225 */
   &HandleSCSI,         &HandleSerial,        &UnusedPrimitive,   /* 228 */
   &HandleDisk,         &HandleNarrator,      &UnusedPrimitive,   /* 231 */
   &UnusedPrimitive,    &UnusedPrimitive,     &UnusedPrimitive,   /* 234 */
   &UnusedPrimitive,    &UnusedPrimitive,     &UnusedPrimitive,   /* 237 */
   &HandleBoopsi,       &HandleGadTools,      &HandleIFF,         /* 240 */
   &UnusedPrimitive,    &UnusedPrimitive,     &UnusedPrimitive,   /* 243 */
   &UnusedPrimitive,    &UnusedPrimitive,     &HandleADosSafe,    /* 246 */
   &HandleADosUnSafe,   &HandleADosDanger,    &HandleADosVD,      /* 249 */
   &HandleSystem,       &UnusedPrimitive,     &UnusedPrimitive,   /* 252 */
   &UnusedPrimitive,    &UnusedPrimitive,     &UnusedPrimitive    /* 255 */
    
};

/****h* ArgCountError() [1.6] ****************************************
*
* NAME
*    ArgCountError()
*
* DESCRIPTION
*    Tell the User that a primitive has the wrong number of arg's!
**********************************************************************
*
*/

PUBLIC OBJECT *ArgCountError( int numargs, int primnumber )
{
   if (debug == TRUE)
      fprintf( stderr, PrimCMsg( MSG_PR_ARGCNT_ERR_PRIM ), numargs, primnumber );

   sprintf( strbuffer, PrimCMsg( MSG_FMT_PR_ARGCNT_PRIM ), numargs, primnumber );

   StringCopy( errp, strbuffer );

   return( ReturnError() );   
}

/****h* primitive() [1.6] ********************************************
*
* NAME
*    primitive()
*
* DESCRIPTION  
*    Decode a primitive & execute the code that corresponds to it. 
**********************************************************************
*
*/

PUBLIC OBJECT *primitive( int primnumber, int numargs, OBJECT **args )
{
   int opnumber = primnumber % 10;

   OBJECT *rval = NULL;
   
/* Produces a lot of output!!
#  ifdef DEBUG
   fprintf( stderr, "primnumber = %d, numargs = %d, **args = 0x%08LX, ",
                    primnumber, numargs, args
          );

   fprintf( stderr, "opnumber = %d\n", opnumber );
#  endif 
*/
   FBEGIN( printf( "primitive( %d, %d, OBJ ** 0x%08LX )\n", primnumber, numargs, args ));

   i = primnumber / 10;
   
   /* first do argument type checking for SmallTalk primitives: */
   switch (i) 
      {
      case 0: // misc operations:
         if (opnumber <= 5 && numargs != 1)
            {
            rval = ArgCountError( 1, primnumber );
            
            goto exitPrimitive;
            }

         leftarg = args[0];

         break;

      case 1: // integer operations:
      case 2: 
         if (primnumber == 26)
            {
            if (numargs != 4)
               {
               rval = ArgCountError( 4, primnumber );
      
               goto exitPrimitive;
               }
            
            if (args[2] == o_true)
               miscFlag = TRUE;   // Treat Integer as signed value.
            else
               miscFlag = FALSE;  // Treat Integer as unsigned value.
               
            if (args[3] == o_true)
               needRadix = TRUE;   // add the radix indicator also.
            else
               needRadix = FALSE;  // Leave off the radix indicator.
            }
         else
            {
            if (numargs != 2)
               {
               rval = ArgCountError( 2, primnumber );
      
               goto exitPrimitive;
               }
            }

         rightarg = args[1];

         if (is_integer( rightarg ) == FALSE && is_address( rightarg ) == FALSE) 
            {
            rval = PrintArgTypeError( primnumber );

            goto exitPrimitive;
            }

         rightint = int_value( rightarg );

      case 3: // Integer operations:
         if (i == 3 && opnumber && numargs != 1)
            {
            rval = ArgCountError( 1, primnumber );

            goto exitPrimitive;
            }

         leftarg = args[0];

         if (is_integer( leftarg ) == FALSE && is_address( leftarg ) == FALSE)
            { 
            rval = PrintArgTypeError( primnumber );

            goto exitPrimitive;
            }

         leftint = int_value( leftarg );

         break;

      case 4: // character operations:
         if (numargs != 2) 
            {
            rval = ArgCountError( 2, primnumber );

            goto exitPrimitive;
            }

         rightarg = args[1];

         if (is_character( rightarg ) == FALSE)
            {
            rval = PrintArgTypeError( primnumber );

            goto exitPrimitive;
            }

         rightint = int_value( rightarg );

         break;

      case 5: // Character unary operations:
         if (i == 5 && numargs != 1) 
            {
            rval = ArgCountError( 1, primnumber );

            goto exitPrimitive;
            }

         leftarg = args[0];

         if (is_character( leftarg ) == FALSE) 
            {
            rval = PrintArgTypeError( primnumber );

            goto exitPrimitive;
            }

         leftint = int_value( leftarg );

         break;

      case 6: // floating point operations:
         if (numargs != 2) 
            {
            rval = ArgCountError( 2, primnumber );
            
            goto exitPrimitive;
            }

         rightarg = args[1];

         if (is_float( rightarg ) == FALSE) 
            {
            rval =  PrintArgTypeError( primnumber );

            goto exitPrimitive;
            }

         rightfloat = float_value( rightarg );

         // FALL THROUGH:

      case 7: // More floating point operations:
         if (i == 7 && numargs != 1) 
            {
            rval = ArgCountError( 1, primnumber );

            goto exitPrimitive;
            }

         // FALL THROUGH:
      
      case 8: // Numerical operations:
         if (i == 8 && opnumber < 8 && numargs != 1) 
            {
            rval = ArgCountError( 1, primnumber );

            goto exitPrimitive;
            }

         leftarg = args[0];

         if (is_float( leftarg ) == FALSE) 
            {
            rval = PrintArgTypeError( primnumber );

            goto exitPrimitive;
            }

         leftfloat = float_value( leftarg );

         break;

      case 9: // symbol operations (except for 95, 96 & 90):
         if (primnumber == 95)
            {
            // instanceVarAccess():
            leftint = int_value( args[0] );
            
            if (numargs != 3 && leftint == 0)
               {
               rval = ArgCountError( 3, primnumber );
               
               goto exitPrimitive;
               }
               
            else if (numargs != 4 && leftint == 1)
               {
               rval = ArgCountError( 4, primnumber );

               goto exitPrimitive;
               }

            if (is_integer( args[1] ) == FALSE) 
               {
               rval = PrintArgTypeError( 95 );
               
               goto exitPrimitive;
               }
            
            if (int_value( args[1] ) < 1)
               {
               rval = PrintIndexError();
               
               goto exitPrimitive;
               }
            }
         else if (primnumber != 96 && primnumber != 90)
            {
            leftarg = args[0];
 
            if (is_symbol( leftarg ) == FALSE)
               {
               rval = PrintArgTypeError( primnumber );

               goto exitPrimitive;
               }

            leftp = symbol_value( (SYMBOL *) leftarg );
            }

         break;

      case 10: // string operations:
         if (numargs < 1) 
            {
            rval = ArgCountError( 1, primnumber );
            
            goto exitPrimitive;
            }

         leftarg = args[0];

         if (is_string( leftarg ) == FALSE) 
            {
            rval = PrintArgTypeError( primnumber );
            
            goto exitPrimitive;
            }

         leftp = string_value( (STRING *) leftarg );

         if (opnumber && opnumber <= 3) 
            {
            if (numargs != 2) 
               {
               rval = ArgCountError( 2, primnumber );
               
               goto exitPrimitive;
               }

            rightarg = args[1];

            if (is_string( rightarg ) == FALSE)
               {
               rval = PrintArgTypeError( primnumber );
      
               goto exitPrimitive;
               }

            rightp = string_value( (STRING *) rightarg );
            }
         else if ((opnumber >= 4) && (opnumber <= 6)) 
            {
            if (numargs < 2) 
               {
               rval = ArgCountError( 2, primnumber );
               
               goto exitPrimitive;
               }

            if (is_integer( args[1] ) == FALSE) 
               {
               rval = PrintArgTypeError( primnumber );
               
               goto exitPrimitive;
               }

            i = int_value( args[1] ) - 1;

            if ((i < 0) || (i >= strlen( leftp )) )
               {
               rval = PrintIndexError();
               
               goto exitPrimitive;
               }
            }
         else if ((opnumber >= 7) && (numargs != 1))
            {
            rval = ArgCountError( 1, primnumber );
            
            goto exitPrimitive;
            }

         break;

      case 11: // Array operations:
         if (opnumber == 1)
            {
            if (is_bltin( args[0] ) == TRUE) // args[0] s/b variable name
               {
               rval = PrintArgTypeError( primnumber );
               
               goto exitPrimitive;
               }

            if (numargs != 2) 
               {
               rval = ArgCountError( 2, primnumber );
               
               goto exitPrimitive;
               }

            if (is_integer( args[1] ) == FALSE) // args[1] == index value 
               {
               rval = PrintArgTypeError( primnumber );
               
               goto exitPrimitive;
               }

            i = int_value( args[1] );
            }
         else if (opnumber == 2) // #112 has 3 arguments!
            {
            /* args[0] == NewObject * from <110 xx>
            ** args[1] == array index number
            ** args[2] == array or bytecode array 
            */
            if (is_bltin( args[0] ) == TRUE) // args[0] s/b variable name
               {
               rval = PrintArgTypeError( primnumber );
               
               goto exitPrimitive;
               }

            if (numargs < 2) 
               {
               rval = ArgCountError( 2, primnumber );
               
               goto exitPrimitive;
               }

            if (is_integer( args[1] ) == FALSE) // args[1] == index value 
               {
               rval = PrintArgTypeError( primnumber );
      
               goto exitPrimitive;
               }

            i = int_value( args[1] );

            if (i < 1 || i > objSize( args[0] )) 
               {
               // args[0] is the array, not [2]!
               rval = PrintArrayError( args[0] );
               
               goto exitPrimitive;
               }
            }
         else if ((opnumber >= 4) && (opnumber <= 6)) 
            {
            // NewArray = 114, NewByteArray = 116:
            if (numargs != 1) 
               {
               rval = ArgCountError( 1, primnumber );
               
               goto exitPrimitive;
               }

            if (is_integer( args[0] ) == FALSE) 
               {
               rval = PrintArgTypeError( primnumber );
      
               goto exitPrimitive;
               }

            i = int_value( args[0] );

            if (i < 0) 
               {
               rval = PrintArrayError( args[0] );
      
               goto exitPrimitive;
               }
            }
         else if (opnumber >= 7) // #117 = ByteArraySize
            {
            if (numargs < 1) 
               {
               rval = ArgCountError( 1, primnumber );
      
               goto exitPrimitive;
               }

            if (is_bytearray( args[0] ) == FALSE) 
               {
               rval = PrintArgTypeError( primnumber );
      
               goto exitPrimitive;
               }

            byarray = (BYTEARRAY *) args[0];

            if (opnumber >= 8) // 3rd arg isn't checked for #119 here:
               {
               if (numargs < 2) 
                  {
                  rval = ArgCountError( 2, primnumber );
         
                  goto exitPrimitive;
                  }

               if (is_integer( args[1] ) == FALSE)
                  {
                  rval = PrintArgTypeError( primnumber );
      
                  goto exitPrimitive;
                  }

               i = int_value( args[1] ) - 1;

               if (i < 0 || i >= byarray->bsize)
                  {
                  rval = PrintArrayError( args[0] );
       
                  goto exitPrimitive;
                  }
               }
            }

         break;

      case 12: // string i/o operations:
         if (opnumber == 4) // Curses primitives.
            break;
             
         if (opnumber < 6) 
            {
            if (numargs < 1) 
               {
               rval = ArgCountError( 1, primnumber );
      
               goto exitPrimitive;
               }

            leftarg = args[0];

            if (is_string( leftarg ) == FALSE) 
               {
               rval = PrintArgTypeError( primnumber );
      
               goto exitPrimitive;
               }

            leftp = string_value( (STRING *) leftarg );
            }

         break;

      case 13: // operations on files:
         // HandleClassInfo() & HandleSupervisor() do error checking.
         if (primnumber == 137 || primnumber == 138)
            break;
            
         if (numargs < 1) 
            {
            rval = ArgCountError( 1, primnumber );
      
            goto exitPrimitive;
            }

         if (is_file( args[0] ) == FALSE) 
            {
            rval = PrintArgTypeError( primnumber );
      
            goto exitPrimitive;
            }

         phil = (struct file_struct *) args[0];

         if (opnumber && !phil->fp) // == (FILE *) NULL)) 
            {
            StringCopy( errp, PrimCMsg( MSG_PR_FILEUNOPENED_PRIM ) );

            rval = ReturnError();
      
            goto exitPrimitive;
            }

         break;

      // case 14: // Block operations (processed in the functions).

      case 15: // operations on classes:
         if (opnumber < 3 && numargs != 1) 
            {
            rval = ArgCountError( 1, primnumber );
      
            goto exitPrimitive;
            }

         if (is_class( args[0] ) == FALSE) 
            {
            rval = PrintArgTypeError( primnumber );
      
            goto exitPrimitive;
            }

         aClass = (CLASS *) args[0];

         break;

#     ifdef PLOT3
      case 16:
         if (primnumber == 168) // PlotArc() call:
            {
            if (ChkArgCount( 5, numargs, 168 ) != 0)
               {
               rval = ArgCountError( 5, 168 );
      
               goto exitPrimitive;
               }

            if ((is_integer( args[0] ) == FALSE)  
                 || (is_integer( args[1] ) == FALSE) 
                 || (is_float(   args[2] ) == FALSE)
                 || (is_integer( args[3] ) == FALSE)
                 || (is_integer( args[4] ) == FALSE))
               {     
               rval = PrintArgTypeError( primnumber );
      
               goto exitPrimitive;
               }
            }
         
         if (primnumber == 169) // We've got a PlotEnv() call.
            {
            if ((leftint = int_value( args[0] )) == 1)
               {
               // Open a Plot Environment:
               if (numargs != 4)
                  {
                  rval = ArgCountError( 4, primnumber );
      
                  goto exitPrimitive;
                  }

               if ((is_string( args[1] ) == FALSE)  
                     || (is_integer( args[2] ) == FALSE) 
                     || (is_integer( args[3] ) == FALSE)) 
                  {
                  rval = PrintArgTypeError( primnumber );
      
                  goto exitPrimitive;
                  }
               }
            else if ((leftint == int_value( args[0] )) == 0)
               {
               // Close a Plot Environment:
               if (numargs != 2)
                  {
                  rval = ArgCountError( 2, primnumber );
      
                  goto exitPrimitive;
                  }

               if (is_string( args[1] ) == FALSE) // No PlotName!!
                  {
                  rval = PrintArgTypeError( primnumber );
       
                  goto exitPrimitive;
                  }
              } 
            else if ((leftint == int_value( args[0] )) == 2)
               {
               // Move a Plot Environment Window:
               if (numargs != 4)
                  {
                  rval = ArgCountError( 4, primnumber );
      
                  goto exitPrimitive;
                  }

               if ((is_string( args[1] ) == FALSE)
                    || (is_integer( args[2] ) == FALSE)
                    || (is_integer( args[3] ) == FALSE))
                  {
                  rval = PrintArgTypeError( primnumber );
      
                  goto exitPrimitive;
                  }
               } 
            }

         break;

      case 17: // plot(3) interface (cont'd):
         switch (opnumber)
            {
            case 1: // PlotMove(     x, y );
            case 2: // PlotContinue( x, y );
            case 3: // PlotPoint(    x, y );
               if (numargs != 2) 
                  {
                  rval = ArgCountError( 2, primnumber );
      
                  goto exitPrimitive;
                  }

               if ((is_integer( args[0] ) == FALSE) 
                     || (is_integer( args[1] ) == FALSE))
                  {
                  rval = PrintArgTypeError( primnumber );
      
                  goto exitPrimitive;
                  }

               leftint  = int_value( args[0] );
               rightint = int_value( args[1] );

               break;

            case 4: // PlotCircle( x, y, radius );
               if (ChkArgCount( 3, numargs, 174 ) != 0)
                  {
                  rval = ArgCountError( 3, 174 );
      
                  goto exitPrimitive;
                  }

               for (i = 0; i < 3; i++)
                  {
                  if (is_integer( args[i] ) == FALSE) 
                     {
                     rval = PrintArgTypeError( 174 );
      
                     goto exitPrimitive;
                     }
                  }

               break;

            case 5: // PlotBox(  x1, y1, x2, y2 );
            case 7: // PlotLine( x1, y1, x2, y2 );
               if (numargs != 4) 
                  {
                  rval = ArgCountError( 4, primnumber );
      
                  goto exitPrimitive;
                  }

               for (i = 0; i < 4; i++)
                  if (is_integer( args[i] ) == FALSE)
                     {
                     rval = PrintArgTypeError( primnumber );
      
                     goto exitPrimitive;
                     }

               leftint  = int_value( args[0] );
               rightint = int_value( args[1] );
               i        = int_value( args[2] );
               j        = int_value( args[3] );

               break;

            case 6:  // Changed to PlotSetPens( fpen, bpen ).
               if (numargs != 2) 
                  {
                  rval = ArgCountError( 2, primnumber );
      
                  goto exitPrimitive;
                  }

               if ((is_integer( args[0] ) == FALSE) 
                     || (is_integer( args[1] ) == FALSE))
                  {
                  rval = PrintArgTypeError( primnumber );
      
                  goto exitPrimitive;
                  }

               leftint  = int_value( args[0] );
               rightint = int_value( args[1] );

               break;
            
            case 8: // PlotLabel( text, x, y, fpen, bpen );
               if (numargs != 5) 
                  {  
                  rval = ArgCountError( 5, primnumber );
      
                  goto exitPrimitive;
                  }

               if ((is_string( args[0] ) == FALSE)
                     || (is_integer( args[1] ) == FALSE) 
                     || (is_integer( args[2] ) == FALSE)
                     || (is_integer( args[3] ) == FALSE)
                     || (is_integer( args[4] ) == FALSE))
                  {
                  rval = PrintArgTypeError( primnumber );
      
                  goto exitPrimitive;
                  }

               leftp = string_value( (STRING *) args[0] );

               break;
            
            case 9: // PlotSetLineType( bitPattern );
               if (numargs != 1) 
                  {
                  rval = ArgCountError( 1, primnumber );
      
                  goto exitPrimitive;
                  }

               if (is_integer( args[0] ) == FALSE) 
                  {
                  rval = PrintArgTypeError( primnumber );
      
                  goto exitPrimitive;
                  }
 
               leftint = int_value( args[0] );

               break;

            case 0:     // No arguments for PlotClear().               
            default:

               break;
            }

         break;
#endif

      /* Argument checking for Amiga additions is done in the primitive
      ** functions! 
      */
      case 18:
      case 19:
      case 20:
      case 21:
      case 22:
      case 23:
      case 24:
      case 25:

         break;
      }
      
   // Now, do the actual primitive call:

   rval = (PrimitiveFunction[ primnumber ])( numargs, args );
   
exitPrimitive:

   FEND( printf( "0x%08LX = primitive() exits\n", rval ) );

   return( rval );   
}

/* --------------------- END of Primitive.c file! ---------------------- */
