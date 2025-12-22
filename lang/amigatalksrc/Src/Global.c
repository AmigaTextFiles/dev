/****h* AmigaTalk/Global.c [3.0] *************************************
*
* NAME
*    Global.c
*
* DESCRIPTION
*    This file contains functions that are used in several Amiga 
*    modules, like Border.c.  The functions are declared in the 
*    order of the most-used functions being toward the top of this
*    file.
*
* HISTORY
*    08-Jan-2005 - Added the DebugBreak() function.
*
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    19-Dec-2003 - Rolled Version number due to bug in Drive.c.
*                  Added memory Alloc & Free functions that
*                  log their activity.
*       
*    10-Nov-2003 - Created the ObjActionByType() function.
*
*    09-Nov-2003 - Moved free_obj(), o_alloc(), structalloc() &
*                  AssignObj() back to Object.c
*
*    03-Sep-2003 - Started V2.5 additions, so had to roll Version #.
*                  Added Class_Name() function also.
*
* NOTES
*    $VER: AmigaTalk:Src/Global.c 3.0 (25-Oct-2004) by J.T. Steichen
**********************************************************************
*
*/

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#ifdef    __SASC
# include <stdarg.h>
#else
# include <sys/amigaos-va.h>
#endif

#include <ctype.h>

#include <exec/types.h>
#include <exec/memory.h>


#include <AmigaDOSErrs.h>

#include <intuition/intuitionbase.h>

#include <libraries/asl.h>

#include <utility/tagitem.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/dos_protos.h>
# include <clib/intuition_protos.h>
# include <rexx/rxslib.h> // for struct RxsLib definition only.

IMPORT struct IntuitionBase *IntuitionBase;
IMPORT struct RxsLib        *RexxSysBase;  // Moved from ARexxCmd.h V2.3
IMPORT struct Library       *CyberGfxBase;  // Added for V2.0

IMPORT BOOL HaveCyberLibrary; // Added for V2.0

#else

# define __USE_INLINE__

# include <proto/dos.h>
# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/rexxsyslib.h>

// --------- Located in main.c: --------------------------------
IMPORT struct Library *DOSBase;
IMPORT struct Library *SysBase;
IMPORT struct Library *IntuitionBase;
//IMPORT struct Library *CyberGfxBase;  // Added for V2.0
//IMPORT struct Library *GfxBase; 
//IMPORT struct Library *LocaleBase; 
//IMPORT struct Library *GadToolsBase; 
//IMPORT struct Library *RexxSysBase;
//IMPORT struct Library *IconBase; 

IMPORT struct DOSIFace       *IDOS;
IMPORT struct ExecIFace      *IExec;
IMPORT struct IntuitionIFace *IIntuition;

//IMPORT struct CyberGfxIFace  *ICyberGfx;
//IMPORT struct GraphicsIFace  *IGraphics;
//IMPORT struct LocaleIFace    *ILocale;
//IMPORT struct GadToolIFace   *IGadTools;
//IMPORT struct IconIFace      *IIcon;
//IMPORT struct RexxSysIFace   *IRexxSys;

// -------------------------------------------------------------

IMPORT BOOL HaveCyberLibrary;                    // Added for V2.0

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Env.h"

#include "ATStructs.h"
#include "CProtos.h"
#include "IStructs.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "FuncProtos.h"

#define   ALLOCATE_ERR_STRINGS
# include "CantHappen.h"
#undef    ALLOCATE_ERR_STRINGS

#define   ALLOCATE
# include <Author.h> // My name & EMail address.
#undef    ALLOCATE

// -------------------------- Stuff from Main.c file:

IMPORT struct Screen        *Scr;

// -------------------------------------------------------------------

PUBLIC BOOL FDEV = FALSE; // TRUE means print Function entries & exits

PUBLIC void *MainPoolHeader = NULL;

//PUBLIC UBYTE *authorName;  in Author.h
//PUBLIC UBYTE *authorEMail;

#define COPYRIGHT   " 1998-2005"
#define PROGRAMNAME "AmigaTalkPPC"
#define VERSION     "3.0"

PUBLIC UBYTE *Version       = VERSION;
PUBLIC UBYTE CopyRight[32]  = COPYRIGHT;
PUBLIC UBYTE PgmName[80]    = PROGRAMNAME;     // Default program name.

PUBLIC UBYTE *scrtitle = PROGRAMNAME COPYRIGHT " by J.T. Steichen";

PUBLIC struct Console *st_console = NULL;

PUBLIC UBYTE em[512]= { 0, }, *ErrMsg = &em[0]; // Used everywhere!!

PUBLIC char  outmsg[512] = { 0, }; // For APrint() calls.

#ifdef __SASC
PRIVATE UBYTE *ver = "\0$VER:  AmigaTalk " VERSION " "__AMIGADATE__" by J.T. Steichen\0";

PUBLIC UWORD ATScrWidth   = 640;
PUBLIC UWORD ATScrHeight  = 480;
PUBLIC UWORD ATStatWidth  = 640; // Added on 29-Oct-2002.
PUBLIC UWORD ATStatHeight = 200;
PUBLIC UWORD ATStatLeft   = 0;
PUBLIC UWORD ATStatTop    = 261;

#else // __amigaos4__ is defined!

PRIVATE UBYTE *ver = "\0$VER:  " PROGRAMNAME " " VERSION " " __DATE__ "by J.T. Steichen\0";

PUBLIC UWORD ATScrWidth   = 1024;
PUBLIC UWORD ATScrHeight  = 768;
PUBLIC UWORD ATStatWidth  = 1024; // Added on 29-Oct-2002.
PUBLIC UWORD ATStatHeight = 256;
PUBLIC UWORD ATStatLeft   = 0;
PUBLIC UWORD ATStatTop    = 510;
#endif

// ----  From all of the original Little Smalltalk files: ------------

PUBLIC int ca_address  = 0; // Used in Address.c

// From Object.c:

PUBLIC int n_incs      = 0; // number of increments counter.
PUBLIC int n_decs      = 0; // number of decrements counter (should be equal)
PUBLIC int n_mallocs   = 0; // number of mallocs counter

PUBLIC int ca_obj      = 0;       // count the # of allocations made
PUBLIC int ca_objTotal = 0;

PUBLIC int ca_cobj[5] = { 0, };  // count how many alloc's for small vals

// From Block.c:

PUBLIC int ca_block  = 0;   // number of block allocations

// From Byte.c:

PUBLIC int ca_barray = 0;
PUBLIC int ca_bsize  = 0;
PUBLIC int btabletop = 0;

// From Class.c:

PUBLIC int ca_class = 0;   // count class allocations

// From ClDict.c:

PUBLIC int ca_cdict = 0;

// From Drive.c:

PUBLIC char ab[ MAXBUFFER ] = { 0, };
PUBLIC char *allocd_buffer = &ab[0], *top_linebuffer = &ab[0];

PUBLIC int  buffindex = 0;

// From Interp.c:

PUBLIC int ca_terp  = 0; // counter for interpreter allocations

// From line.c:

PUBLIC int inisstd  = 0; // use stdin or not?

// From Number.c:

PUBLIC int ca_int   = 0;  // count the number of integer allocations
PUBLIC int ca_float = 0;

// From Process.c:

PUBLIC int atomcnt = 0;     // atomic action flag

/* currently running process, may be different from currentProcess
** during process termination :
*/

PUBLIC PROCESS *runningProcess = NULL;

// From String.c:

PUBLIC int ca_str     = 0;
PUBLIC int ca_wal     = 0;
PUBLIC int wtop       = 0;
PUBLIC int ca_walSize = 0;

// From Symbol.c:

PUBLIC int ca_sym      = 0; // symbol allocation counter
PUBLIC int ca_symSpace = 0;

IMPORT int x_tmax; // Number of entries in x_tab[] array (SymList.h).

PUBLIC char *SymbolStringSpace = NULL; // Used for FreeVec() in main.c

// From Main.c:

PUBLIC BOOL initial = FALSE;   // not making initial image.

// Disable Ctrl-C checking in the SAS startup code:

PUBLIC int CXBRK(    void ) { return 0; }
PUBLIC int chkabort( void ) { return 0; }


/****i* CommandSwitches ***********************************************
*
* NAME
*    Command Line Switches
*
* DESCRIPTION
*    -h print usage information.
*    -i display logo (set hailLogo to 1).
*    -b Set to FALSE for no status window (EnbStatus = 0).
*    -s silence is desired on output (silence = 1).
*    -l or -n 1 if no loading of std prelude is desired (noload = 1).
*    -f 1 if doing a fast load of saved image, (fastload = 1)
*    -m sets fastload = 0.
*    -a printing final allocation figures is wanted (prallocs = 1).
*    -dx 1 or 2 and commands will be printed as eval'd (prntcmd = x).
*    -z printing during lex is desired (for debug, lexprnt = 1).
*    -y set TraceFile to stdout & enable tracing!
***********************************************************************
*
*/

PUBLIC int hailLogo  = 0;
PUBLIC int EnbStatus = 1;
PUBLIC int silence   = 0;
PUBLIC int noload    = 0;
PUBLIC int fastload  = 0;
PUBLIC int prallocs  = 0;
PUBLIC int prntcmd   = 1;
PUBLIC int lexprnt   = 0;
PUBLIC int debug     = 0;
PUBLIC int started   = 0;
PUBLIC int developer = 0;

// For tracing execution:

PUBLIC BOOL  traceByteCodes = FALSE;
PUBLIC FILE *TraceFile      = NULL;
PUBLIC int   TraceIndent    = 0;    // indent the bytecodes.


// pseudo-variables:

PUBLIC OBJECT *o_acollection = NULL; // arrayed collection (used internally)
PUBLIC OBJECT *o_drive       = NULL; // driver interpreter
PUBLIC OBJECT *o_empty       = NULL; // the empty array (used during initial)
PUBLIC OBJECT *o_false       = NULL; // value for pseudo variable false
PUBLIC OBJECT *o_magnitude   = NULL; // instance of class Magnitude
PUBLIC OBJECT *o_nil         = NULL; // value for pseudo variable nil
PUBLIC OBJECT *o_number      = NULL; // instance of class Number
PUBLIC OBJECT *o_object      = NULL; // instance of class Object
PUBLIC OBJECT *o_tab         = NULL; // string with tab character only
PUBLIC OBJECT *o_true        = NULL; // value of pseudo variable true
PUBLIC OBJECT *o_smalltalk   = NULL; // value of pseudo variable smalltalk

PUBLIC OBJECT *o_IDCMP_rval  = NULL; // Added on 04-Feb-2002.

// -------------------------------------------------------------------

#define  FR_LEFTEDGE    70
#define  FR_TOPEDGE     16
#define  FR_WIDTH       500
#define  FR_HEIGHT      400

PUBLIC struct TagItem FontTags[] = {

    ASLFO_Window,          0L,   
    ASLFO_Screen,          0L,
    ASLFO_TitleText,       0L,
    ASLFO_InitialHeight,   FR_HEIGHT,
    ASLFO_InitialWidth,    FR_WIDTH,
    ASLFO_InitialTopEdge,  FR_TOPEDGE,
    ASLFO_InitialLeftEdge, FR_LEFTEDGE,
    ASLFO_PositiveText,    0L,
    ASLFO_NegativeText,    0L,
    ASLFO_Flags,           FOF_DOSTYLE | FOF_DODRAWMODE,

    ASLFO_SampleText,      0L,
    ASLFO_DoDrawMode,      1, // Display DrawMode Cycle Gadget.
    ASLFO_DoStyle,         1, // Display Style Checkboxes.
    ASLFO_SleepWindow,     1,
    ASLFO_PrivateIDCMP,    1,
    ASLFO_PopToFront,      1,
    ASLFO_Activate,        1,
    TAG_DONE 
};

PUBLIC struct TagItem ScreenTags[] = {

    ASLSM_Window,           0L,   
    ASLSM_Screen,           0L,
    ASLSM_TitleText,        0L,
    ASLSM_InitialHeight,    FR_HEIGHT,
    ASLSM_InitialWidth,     FR_WIDTH,
    ASLSM_InitialTopEdge,   FR_TOPEDGE,
    ASLSM_InitialLeftEdge,  FR_LEFTEDGE,
    
    ASLSM_InitialDisplayID,     0x40D2001,
    ASLSM_InitialDisplayWidth,  640,
    ASLSM_InitialDisplayHeight, 480,
    ASLSM_InitialDisplayDepth,  8,

    ASLSM_DoWidth,          1,
    ASLSM_DoHeight,         1,
    ASLSM_DoDepth,          1,
    
    ASLSM_MinWidth,         640, 
    ASLSM_MinHeight,        400, 

    ASLSM_PositiveText,     0L,
    ASLSM_NegativeText,     0L,

    ASLSM_SleepWindow,      1,
    ASLSM_PrivateIDCMP,     1,
    ASLSM_PopToFront,       1,
    ASLSM_Activate,         1,
    TAG_DONE 
};

PUBLIC struct TagItem LoadTags[] = {

    ASLFR_Window,          0L,   
    ASLFR_Screen,          0L,
    ASLFR_TitleText,       0L,
    ASLFR_InitialHeight,   FR_HEIGHT,
    ASLFR_InitialWidth,    FR_WIDTH,
    ASLFR_InitialTopEdge,  FR_TOPEDGE,
    ASLFR_InitialLeftEdge, FR_LEFTEDGE,
    ASLFR_PositiveText,    0L,
    ASLFR_NegativeText,    0L,
    ASLFR_InitialPattern,  (ULONG) "#?",
    ASLFR_InitialFile,     (ULONG) EMPTY_STRING,
    ASLFR_InitialDrawer,   (ULONG) "AmigaTalk:",
    ASLFR_Flags1,          FRF_DOPATTERNS,
    ASLFR_Flags2,          FRF_REJECTICONS,
    ASLFR_SleepWindow,     1,
    ASLFR_PrivateIDCMP,    1,
    ASLFR_PopToFront,      1,
    ASLFR_Activate,        1,

    TAG_DONE 
};

PUBLIC struct TagItem SaveTags[] = {

    ASLFR_Window,          0L,   
    ASLFR_Screen,          0L,
    ASLFR_TitleText,       0L,
    ASLFR_InitialHeight,   FR_HEIGHT,
    ASLFR_InitialWidth,    FR_WIDTH,
    ASLFR_InitialTopEdge,  FR_TOPEDGE,
    ASLFR_InitialLeftEdge, FR_LEFTEDGE,
    ASLFR_PositiveText,    0L,
    ASLFR_NegativeText,    0L,
    ASLFR_InitialPattern,  (ULONG) "#?",
    ASLFR_InitialFile,     (ULONG) EMPTY_STRING,
    ASLFR_InitialDrawer,   (ULONG) "AmigaTalk:",
    ASLFR_Flags1,          FRF_DOPATTERNS | FRF_DOSAVEMODE,
    ASLFR_Flags2,          FRF_REJECTICONS,
    ASLFR_SleepWindow,     1,
    ASLFR_PrivateIDCMP,    1,
    ASLFR_PopToFront,      1,
    ASLFR_Activate,        1,

    TAG_DONE 
};

// -------------------------------------------------------------------

/****h* OS4SetTagItem() [3.0] *****************************************
*
* NAME
*    OS4SetTagItem()
*
* DESCRIPTION 
*    For some reason, the SetTagItem() function in CommonFuncsPPC.o 
*    does not always work, so we forgo the call to FindTagItem() in
*    the utility.library & do it the hard way in here.  If this is a
*    problem elsewhere, we will make this function PUBLIC & place it
*    in Global.c for all to use, or else replace SetTagItem() in 
*    CommonFuncs.c with this version.
***********************************************************************
*
*/

#ifdef __amigaos4__
PUBLIC void OS4SetTagItem( struct TagItem tagList[], ULONG searchTag, ULONG newValue )
{
   struct TagItem *item = NULL;
   int             i    = 0;
   
   if (!tagList)
      return;
   
   item = &tagList[0];
   
   while (item)
      {
      if (item->ti_Tag == searchTag)
         {
	 item->ti_Data = newValue;
	
	 break;
         }
      else if (item->ti_Tag == TAG_END)
         break;
	       
      item = &tagList[ ++ i ];
      }

   return;
}
#endif

/*
   NAME
        RawDoFmt -- format data into a character stream.

   SYNOPSIS
        APTR NextData = RawDoFmt( STRPTR FormatString, APTR DataStream, void (*)() PutChProc, APTR PutChData );

   FUNCTION
        perform "C"-language-like formatting of a data stream, outputting
        the result a character at a time.  Where % formatting commands are
        found in the FormatString, they will be replaced with the
        corresponding element in the DataStream.  %% must be used in the
        string if a % is desired in the output.

   INPUTS
        FormatString - a "C"-language-like NULL terminated format string,
        with the following supported % options:

         %[flags][width.limit][length]type

        flags      - only one allowed. '-' specifies left justification.
        width      - field width.  If the first character is a '0', the
                     field will be padded with leading 0's.
          .        - must follow the field width, if specified
        limit      - maximum number of characters to output from a string.
                     (only valid for %s).
        length     - size of input data defaults to WORD for types d, x,
                     and c, 'l' changes this to long (32-bit), while 'h' means
                     short (the default, included for compatibiliy)

        type       - supported types are:
                        b - BSTR, data is 32-bit BPTR to byte count followed
                            by a byte string, or NULL terminated byte string.
                            A NULL BPTR is treated as an empty string.
                            (Added in V36 exec)
                        d - decimal
                        u - unsigned decimal (Added in V37 exec)
                        x - hexadecimal
                        s - string, a 32-bit pointer to a NULL terminated
                            byte string.  In V36, a NULL pointer is treated
                            as an empty string
                        c - character
                        p - pointer, written as if the format was 0x%08x

        DataStream - a stream of data that is interpreted according to
                     the format string.  Often this is a pointer into
                     the task's stack.
                     Character data must be passed as shorts (or longs when %lc
                     is used).
                     The function will take care not to throw alignment
                     exceptions, however, it is advised not to use shorts anymore.
                     The ability is just retained for backward compatibility.

        PutChProc  - the procedure to call with each character to be
                     output, called as:

                         PutChProc(Char,  PutChData);

                     the procedure is called with a NULL Char at the end of
                     the format string.
                     Starting with V45.1, this pointer may be NULL. In that
                     case, the default "stuffChar" procedure is used.

        PutChData  - a value that is passed through to the PutChProc
                     procedure.  This is untouched by RawDoFmt, and may be
                     modified by the PutChProc.

   RESULT
        Under V36, RawDoFmt() returns a pointer to the end of the DataStream
        (The next argument that would have been processed).  This allows
        multiple formatting passes to be made using the same data.

   WARNING
        This Amiga ROM function formats word values in the data stream.  If
        your compiler defaults to longs, you must add an "l" to your
        % specifications.  This can get strange for characters, which might
        look like "%lc".
   NOTE
        After locale.library is installed in the system, RawDoFmt() is in fact
        replaced by locale.library/FormatString(). Then the putChProc pointer
        will be handled as follows:

        - If it points to 68K code, this code will be called with putChData in A3
          and the character to output in D0, the code has to return the modified
          putChData pointer in A3. Simplest function is "move.b d0,(a3)+"
          followed by "rts".

        - If it points to PPC code, this code will be called with
          "(*putChProc)(character, putChData)", the code does not have to modify
          putChData (no return code).

        - If it points to NULL, a default routine will be used.
*/

SUBFUNC ULONG MessageBoxA( UBYTE *gadgetsString, UBYTE *title, char *format, APTR args )
{
   char    buffer[ 1024 ] = { 0, };
   ULONG   result         = 0;

//   memset( buffer, 0, 1024 );

   RawDoFmt( format, args, NULL, buffer );

   SetReqButtons( gadgetsString );

   result = (ULONG) GetUserResponse( buffer, title, NULL );

   SetReqButtons( "CONTINUE|ABORT!" );
   
   return( result );
}

#define CONTINUE_DEBUG 1
#define IGNORE_BREAKS  0

PRIVATE ULONG dbgResult = CONTINUE_DEBUG;

#ifdef __amigaos4__

PUBLIC ULONG VARARGS68K BreakPointDBG( UBYTE *title, char *format, ... )
{
   va_list  ap;

   va_startlinear( ap, format );

   if (dbgResult == CONTINUE_DEBUG)
      dbgResult = MessageBoxA( "CONTINUE|TURN OFF BkPts", title, format, va_getlinearva( ap, void * ) );

   va_end( ap );

   return( dbgResult );
}

#else  // Older OS3.9 function required:

PUBLIC ULONG BreakPointDBG( UBYTE *title, char *format, ... )
{
   va_list  ap;

   char     buffer[ 1024 ] = { 0, };

   va_start( ap, format );

   if (dbgResult == CONTINUE_DEBUG)
      {
      //   memset( buffer, 0, 1024 );
      RawDoFmt( format, (APTR) ap, NULL, buffer );

      SetReqButtons( "CONTINUE|TURN OFF BkPts" );

      dbgResult = (ULONG) GetUserResponse( buffer, title, NULL );

      SetReqButtons( "CONTINUE|ABORT!" );
      }

   va_end( ap );

   return( dbgResult );
}

#endif

PUBLIC void TurnOnBreakPoints( void )
{
   dbgResult = CONTINUE_DEBUG;

   return;
}

PUBLIC void TurnOffBreakPoints( void )
{
   dbgResult = IGNORE_BREAKS;

   return;
}

#ifdef __amigaos4__

/****h* hexStrToLong() [3.0] *****************************************
*
* NAME
*    hexStrToLong()
*
* DESCRIPTION
*    gcc does not have SAS-C function stch_l( char *, long * ), so we 
*    need to write one.
**********************************************************************
* 
*/

PUBLIC int hexStrToLong( char *inString, long *output )
{
   char *end;
   
   *output = strtol( inString, &end, 16 );
   
   return( *output );
}

/****h* longToHexStr() [3.0] *****************************************
*
* NAME
*    longToHexStr()
*
* DESCRIPTION
*    gcc does not have SAS-C function stcl_h( char *, long ), so we 
*    need to write one.
**********************************************************************
* 
*/

PUBLIC int longToHexStr( char *outString, long input )
{
   char hex[]  = "0123456789ABCDEF";
   long number = input;
   int  digit  = 0;
   
   if (!outString) 
      return( -1 ); // No buffer space.
   else
      {
      digit        = (number & 0xF0000000) >> 28;
      outString[0] = hex[digit];

      digit        = (number & 0x0F000000) >> 24;
      outString[1] = hex[digit];
      
      digit        = (number & 0x00F00000) >> 20;
      outString[2] = hex[digit];

      digit        = (number & 0x000F0000) >> 16;
      outString[3] = hex[digit];

      digit        = (number & 0x0000F000) >> 12;
      outString[4] = hex[digit];

      digit        = (number & 0x00000F00) >> 8;
      outString[5] = hex[digit];

      digit        = (number & 0x000000F0) >> 4;
      outString[6] = hex[digit];

      digit        = (number & 0x0000000F);
      outString[7] = hex[digit];

      outString[8] = '\0';
      }

   return( 0 );
}

#endif
     
/****h* ObjActionByType() [2.5] **************************************
*
* NAME
*    ObjActionByType()
*
* DESCRIPTION
*    Since a switch statement based on Object Type occurs so 
*    frequently, I decided to create this function to encapsulate the
*    switch statement in one place.
*
* SYNOPSIS
*    OBJECT *ObjActionByType( OBJECT            *thisObject,
*                             ObjActionFuncPtr **theAction   );
*
* INPUTS
*    thisObject - the Object that the switch is preformed on.
*    theAction  - An array of ObjActionFuncPtr functions that
*                 perform an action for each type of Object, of which
*                 there are 16 different cases.  Be sure that your
*                 array conforms to the order expected for the
*                 Object's type value.
*
* RESULT
*    an Object pointer is returned. 
*
* NOTES
*    Each file that calls this function has to declare & define an
*    array of function pointers with 16 elements.
*
*       PRIVATE ObjActionFuncPtr ActionFunctions[] = {
*
*          &ObjectAction, &ClassAction, &ByteArrayAction, &SymbolAction,
*          etc,
*       };
**********************************************************************
*
*/

//#ifndef ObjActionFuncPtr
//PUBLIC typedef  OBJECT * (*ObjActionFuncPtr)( OBJECT * );
//#endif

PUBLIC OBJECT *ObjActionByType( OBJECT *thisObject, 
                                OBJECT *(**theAction)( OBJECT * )
                              )
{
   OBJECT *result = (OBJECT *) NULL;

   switch (objType( thisObject )) // Only 16 different values
      {
      default: // objType() was zero (Not a built-in Object):
         FBEGIN( printf( "ObjActionByType( Obj = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[0])( thisObject );
         break;
            
      case MMF_CLASS:   
         FBEGIN( printf( "ObjActionByType( Class = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[1])( thisObject );
         break;
         
      case MMF_BYTEARRAY: 
         FBEGIN( printf( "ObjActionByType( ByteArray = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[2])( thisObject );
         break;
   
      case MMF_SYMBOL:  
         FBEGIN( printf( "ObjActionByType( Symbol = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[3])( thisObject );
         break;
         
      case MMF_INTERPRETER:
         FBEGIN( printf( "ObjActionByType( Interp = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[4])( thisObject );
         break;
         
      case MMF_PROCESS:
         FBEGIN( printf( "ObjActionByType( Process = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[5])( thisObject );
         break;
         
      case MMF_BLOCK:   
         FBEGIN( printf( "ObjActionByType( Block = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[6])( thisObject );
         break;
         
      case MMF_FILE:    
         FBEGIN( printf( "ObjActionByType( File = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[7])( thisObject );
         break;
         
      case MMF_CHARACTER:    
         FBEGIN( printf( "ObjActionByType( Char = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[8])( thisObject );
         break;
         
      case MMF_INTEGER: 
         FBEGIN( printf( "ObjActionByType( Integer = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[9])( thisObject );
         break;
         
      case MMF_STRING:  
         FBEGIN( printf( "ObjActionByType( String = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[10])( thisObject );
         break;

      case MMF_FLOAT:   
         FBEGIN( printf( "ObjActionByType( Float = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[11])( thisObject );
         break;
         
      case MMF_CLASS_SPEC:   
         FBEGIN( printf( "ObjActionByType( Class_Spec = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[12])( thisObject );
         break;
         
      case MMF_CLASS_ENTRY:
         FBEGIN( printf( "ObjActionByType( ClassEntry = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[13])( thisObject );
         break;
            
      case MMF_SDICT:   // MMF_RESERVED1: // System Dictionaries
         FBEGIN( printf( "ObjActionByType( SDict = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[14])( thisObject );
         break;
         
      case MMF_ADDRESS: // MMF_RESERVED2: // Addresses
         FBEGIN( printf( "ObjActionByType( Address = 0x%08LX, 0x%08LX )\n", thisObject, theAction ));
         result = (theAction[15])( thisObject );
         break;
      }

   FEND( printf( "result = 0x%08LX = ObjActionByType()\n", result ) );

   return( result );
}

/****h* AT_AllocVec() [3.0] ******************************************
*
* NAME
*    AT_AllocVec()
*
* DESCRIPTION
*    Allocate memory from the System & log the activity (if set).
**********************************************************************
*
*/

PUBLIC void *AT_AllocVec( ULONG size, ULONG flags, char *msg, BOOL prtFlag )
{
   void *rval = NULL;
   
#  if (! __DISABLE_MEMF_PUBLIC && ! __REPLACE_MEMF_PUBLIC && __amigaos4__)
	// guarantee that MEMF_SHARED is always present...
   rval = AllocVec( size, flags | MEMF_SHARED );
#  elif (! __DISABLE_MEMF_PUBLIC && ! __REPLACE_MEMF_PUBLIC)
   rval = AllocVec( size, flags | MEMF_PUBLIC ); // For Amiga Classic machines
#  else
   rval = AllocVec( size, flags );
#  endif
   
#  ifdef MEMDEBUG
   if (prtFlag == TRUE)
      fprintf( stdout, "%s -> 0x%08LX = AllocVec( %d = 0x%08LX )\n", msg, rval, size, size );
#  endif   

   return( rval );
}

/****h* AT_FreeVec() [3.0] *******************************************
*
* NAME
*    AT_FreeVec()
*
* DESCRIPTION
*    Deallocate memory from the System & log the activity (if set).
**********************************************************************
*
*/

PUBLIC void AT_FreeVec( void *memBlock, char *msg, BOOL prtFlag )
{
#  ifdef MEMDEBUG
   if (prtFlag == TRUE)
      fprintf( stdout, "FreeVec( %s = 0x%08LX )\n", msg, memBlock );
#  endif   

   if (memBlock)
      FreeVec( memBlock );
   
   return;
}

/****h* AT_calloc() [3.0] ********************************************
*
* NAME
*    AT_calloc()
*
* DESCRIPTION
*    Allocate memory from the System & log the activity (if set).
**********************************************************************
*
*/

PUBLIC void *AT_calloc( ULONG number, ULONG size, char *msg, BOOL prtFlag )
{
   void *rval = NULL;

   // rval = AT_AllocVec( number * size, MEMF_CLEAR | MEMF_ANY, msg, prtFlag );
   rval = (void *) calloc( number, size );
   
#  ifdef MEMDEBUG
   if (prtFlag == TRUE)
      fprintf( stdout, "%s -> 0x%08LX = calloc( %d, %d = 0x%08LX )\n",
                        msg, rval, number, size, size 
             );
#  endif   

   return( rval );
}

/****h* AT_free() [3.0] **********************************************
*
* NAME
*    AT_free()
*
* DESCRIPTION
*    Deallocate memory from the System & log the activity (if set).
**********************************************************************
*
*/

PUBLIC void AT_free( void *memBlock, char *msg, BOOL prtFlag )
{
#  ifdef MEMDEBUG
   if (prtFlag == TRUE)
      fprintf( stdout, "free( %s = 0x%08LX )\n", msg, memBlock );
#  endif   

   // AT_FreeVec( memBlock, msg, prtFlag );
   if (memBlock)
      free( memBlock );
   
   return;
}

/****h* makeMemoryPool() [2.5] ***************************************
*
* NAME
*    makeMemoryPool()
*
* DESCRIPTION
*    Allocate a large pool of memory from the System Fast Memory.
**********************************************************************
*
*/

PUBLIC void *makeMemoryPool( ULONG maxSize, ULONG threshold )
{
   void *PoolHeader = NULL;

   FBEGIN( printf( "makeMemoryPool( 0x%08LX, %d )\n", maxSize, threshold ) );   

   PoolHeader = AT_AllocVec( maxSize, MEMF_CLEAR | MEMF_FAST, "PoolHeader", TRUE );

   FEND( printf( "PoolHeader = 0x%08LX makeMemoryPool()\n", PoolHeader ) );   
           
   return( PoolHeader );   
}

/****h* drainMemoryPool() [2.5] **************************************
*
* NAME
*    drainMemoryPool()
*
* DESCRIPTION
*    Free a pool of memory back to the System Fast Memory list.
**********************************************************************
*
*/

PUBLIC void drainMemoryPool( void *PoolHeader )
{
   FBEGIN( printf( "void drainMemoryPool( 0x%08LX )\n", PoolHeader ) );

   if (PoolHeader) // != NULL)
      AT_FreeVec( PoolHeader, "PoolHeader", TRUE );
    
   return;
}

/****h* ClearLVMNodeStrs() [2.4] *************************************
*
* NAME
*    ClearLVMNodeStrs()
*
* DESCRIPTION
*    Null out the string space for a ListViewMem structure.
**********************************************************************
*
*/

PUBLIC void ClearLVMNodeStrs( struct ListViewMem *lvm )
{
   int i, len = lvm->lvm_NumItems * lvm->lvm_NodeLength;

   FBEGIN( printf( "void ClearLVMNodeStrs( 0x%08LX )\n" ) );

   for (i = 0; i < len; i++)
      *(lvm->lvm_NodeStrs + i) = '\0'; 

   return;
}

/****h* getNumberMethods() [2.4] *********************************
*
* NAME
*    getNumberMethods()
*
* DESCRIPTION
*    Return the size of the message_names array associated with
*    the given class.
******************************************************************
*
*/

PUBLIC int getNumberMethods( char *className )
{
   CLASS  *objClass = lookup_class( className );
   OBJECT *msgArray = objClass->message_names;

   FBEGIN( printf( "%d = getNumberMethods( %s )\n", objSize( msgArray ), className ) );

   return( objSize( msgArray ) );
}

/****h* getFileLineCount() [2.4] *********************************
*
* NAME
*    getFileLineCount()
*
* DESCRIPTION
*    Return the number of lines in a source file associated with
*    the given class.
******************************************************************
*
*/

PUBLIC int getFileLineCount( char *className )
{
   CLASS  *objClass = lookup_class( className );
   OBJECT *fnSymbol = objClass->file_name;
   FILE   *srcFile  = fopen( ((SYMBOL *) fnSymbol)->value, "r" );
   int     rval     = 0, ch;

   FBEGIN( printf( "getFileLineCount( %s )\n", className ) );

   if (!srcFile) // == NULL)
      goto exitGetFileLineCount;

   ch = fgetc( srcFile );
   
   while (ch != EOF)
      {
      if (ch == '\n')
         rval++;
         
      ch = fgetc( srcFile );
      }

   fclose( srcFile );

exitGetFileLineCount:

   FEND( printf( "%d = getFileLineCount()\n", rval ) );                              

   return( rval );
}


/****h* KillObject() [1.9] *******************************************
*
* NAME
*    KillObject()
*
* DESCRIPTION
*    Decrement an Object's reference count until it equals zero, then
*    decrement it once more so that it gets freed from AmigaTalk.
**********************************************************************
*
*/

PUBLIC void KillObject( OBJECT *killMe )
{
   FBEGIN( printf( "void KillObject( 0x%08LX )\n", killMe ) );   

   if (!killMe) // == NULL)
      return;

   while (killMe->ref_count > 0)
      (void) obj_dec( killMe );

   if (killMe->ref_count == 0)   
      (void) obj_dec( killMe ); // This will call the de-allocation code.

   FEND( printf( "KillObject() exits\n" ) );

   return;
}

/****h* NullChk() [1.8] **********************************************
* 
* NAME
*    NullChk()
*
* DESCRIPTION
*    See if an Object is NULL or o_nil.  Return TRUE if NULL or o_nil
**********************************************************************
*
*/

PUBLIC BOOL NullChk( OBJECT *testMe )
{
   BOOL rval = FALSE;
   
   if ((!testMe) || (testMe == o_nil))
      rval = TRUE;
      
   return( rval );
}

/****h* ObjectToAddress() [1.9] **************************************
* 
* NAME
*    ObjectToAddress()
*
* DESCRIPTION
*    Convert an Object to an Amiga struct Address.
**********************************************************************
*
*/

PUBLIC void *ObjectToAddress( OBJECT *obj )
{
   void *rval = NULL;
   
   if (NullChk( obj ) == TRUE)
      return( rval );
      
   if (is_integer( obj ) == TRUE)
      rval = (void *) int_value( obj );
   else if (is_address( obj ) == TRUE)
      rval = (void *) addr_value( obj );
   else
      {
      if (NullChk( (OBJECT *) obj->inst_var[0] ) == TRUE)
         return( rval );
      else
         rval = (void *) int_value( obj->inst_var[0] );
      }
      
   return( rval );
}

/****h* CheckObject() [1.9] ******************************************
*
* NAME
*    CheckObject()
*
* DESCRIPTION
*    Verify that an OBJECT has a valid value.  Return the value of the
*    OBJECT as a pointer.  NULL indicates failure.
**********************************************************************
*
*/

PUBLIC void *CheckObject( OBJECT *obj )
{
   void *rval = NULL;
   
   if (NullChk( obj ) == TRUE)
      return( rval );

   rval = (void *) ObjectToAddress( obj );

   return( rval );
}

/****h* FindSuper() [2.3] ********************************************
*
* NAME
*    FindSuper()
*
* DESCRIPTION
*    Locate a super Class 
**********************************************************************
*
*/

PUBLIC CLASS *FindSuper( CLASS *thisClass )
{
   CLASS *rval = (CLASS *) o_nil;

   FBEGIN( printf( "FindSuper( CLASS * 0x%08LX )\n", thisClass ) );   

   if (NullChk( thisClass->super_class ) == TRUE)
      goto exitFindSuper;

   rval = (CLASS *) thisClass->super_class;
   
   if (is_symbol( (OBJECT *) rval ) == FALSE) // No Parent for Class Object
      {
      rval = (CLASS *) o_nil;
      
      goto exitFindSuper;
      }
   else
      rval = lookup_class( symbol_value( (SYMBOL *) rval ) );
      
   if (NullChk( (OBJECT *) rval ) == TRUE)
      rval =  (CLASS *) o_nil;

exitFindSuper:

   FEND( printf( "CLASS 0x%08LX = FindSuper()\n", rval ) );

   return( rval );
}
         
/****h* ConvertToInt() [1.0] *****************************************
*
* NAME
*    ConvertToInt()
*
* DESCRIPTION
*    Convert a 16-bit fixedpoint number to an integer representing a
*    percentage (range:  0 to 100).  Also used in Window.c
**********************************************************************
*
*/

PUBLIC int ConvertToInt( UWORD fixedpoint )
{
   int      rval = 0;
   USHORT   pos  = fixedpoint;
   
   pos >>= 1;
   pos  &= 0x7FFF;
   rval  = ((float) pos / (float) 0x7FFF);

   return( rval );
}

/****i* FindGadgetValue() [1.0] **************************************
*
* NAME
*    FindGadgetValue()
*
* DESCRIPTION
*    Used in Window.c only
**********************************************************************
*
*/

PUBLIC OBJECT *FindGadgetValue( struct Gadget *g )
{
   struct StringInfo *si = (struct StringInfo *) NULL;
   struct PropInfo   *pi = (struct PropInfo   *) NULL;

   OBJECT *rval  = o_nil;
   UWORD   gtype = g->GadgetType & GTYP_GTYPEMASK;

   switch (gtype)
      {
      default: // <-- Might have to delete this later.

      case GTYP_BOOLGADGET:
         if (g->Flags && GFLG_SELECTED == GFLG_SELECTED)
            return( o_true );
         else
            return( o_false );
         
      case GTYP_PROPGADGET:
         pi = (struct PropInfo *) g->SpecialInfo;

         if ((pi->Flags & FREEHORIZ) == FREEHORIZ)
            return( (rval = new_int( ConvertToInt( pi->HorizPot ) )));
         else
            return( (rval = new_int( ConvertToInt( pi->VertPot ) )));

         break;
         
      case GTYP_STRGADGET:
         si = (struct StringInfo *) g->SpecialInfo;

         if ((g->Flags & LONGINT) == LONGINT) // GACT_LONGINT???
            return( (rval = new_int( si->LongInt )));
         else
            return( (rval = new_str( si->Buffer )));

         break;
          
      case GTYP_CUSTOMGADGET:
      case GTYP_GADGET0002:
         break;
      }

   return( rval );
}

/****i* FindMenuString() [1.0] ***************************************
*
* NAME
*    FindMenuString()
*
* DESCRIPTION
*    Used in Window.c & GadTools.c
**********************************************************************
*
*/

PUBLIC char *FindMenuString( UWORD code, struct Window *wptr )
{
   struct Menu       *mp = wptr->MenuStrip;
   struct MenuItem   *ip = (struct MenuItem *) NULL;
   struct MenuItem   *sp = (struct MenuItem *) NULL;
   
   int    menu = 0;
   int    item = 0;
   int    sub  = 0;
   int    i    = 0;

   if (!mp) // == NULL)
      return( NULL );

   menu = (int) MENUNUM( code );
   item = (int) ITEMNUM( code );
   sub  = (int) SUBNUM(  code );
   
   if ((menu > 0) && (menu != (int) NOMENU))
      for (i = 0; i < menu; i++)
         mp = mp->NextMenu;
   
   ip = mp->FirstItem;

   if ((item > 0) && (item != (int) NOITEM))
      for (i = 0; i < item; i++)
         ip = ip->NextItem;
   
   sp = ip->SubItem;

   if ((sub > 0) && (sub != (int) NOSUB))
      {
      for (i = 0; i < sub; i++)
         sp = sp->NextItem;

      return( ((struct IntuiText *) sp->ItemFill)->IText );
      }

   if ((sub >= 0) && (sub != (int) NOSUB))
      return( ((struct IntuiText *) sp->ItemFill)->IText );
   
   if ((item >= 0) && (item != (int) NOITEM))
      return( ((struct IntuiText *) ip->ItemFill)->IText );

   if ((menu >= 0) && (menu != (int) NOITEM))
      return( mp->MenuName );
   else
      return( NULL );
}

/****i* FindGadgetPointer() ******************************************
*
* NAME
*    FindGadgetPointer()
*
* DESCRIPTION
*    Retrieve a Gadget Pointer given the Window & GadgetID.
*    OBSOLETE!!
**********************************************************************
*  
*/

PUBLIC struct Gadget *FindGadgetPointer( struct Window *wp, int gadg )
{
   struct Gadget *rval = (struct Gadget *) NULL;
   struct Gadget *strt = (struct Gadget *) NULL;
   
   if (wp) // != NULL)
      {
      strt = wp->FirstGadget;
      
      while (strt) // != NULL)
         {
         if (strt->GadgetID == gadg)
            {
            rval = strt;
            break;
            }
            
         strt = strt->NextGadget;
         }
      }

   return( rval );
}

/****h* ExecuteExternalScript() [1.9] ********************************
* 
* NAME
*    ExecuteExternalScript()
*
* DESCRIPTION
*    Run an external file of AmigaTalk commands through the 
*    interpreter.
*
* WARNING
*    Since there is no way of checking, make sure that the script
*    file is debugged BEFORE you use this!
**********************************************************************
*
*/

# define RUN_EXT_SCRIPT    ")r %s\n"

PUBLIC void ExecuteExternalScript( char *filename )
{
   FBEGIN( printf( "void ExecuteExternalScript( %s )\n", filename ) );

   if (!filename || (StringLength( filename ) < 1))
      return;
      
   sprintf( allocd_buffer, RUN_EXT_SCRIPT, filename );

   start_execution( TRUE ); // bypass line_grabber() is TRUE.

   FEND( printf( "ExecuteExternalScript() exit:\n" ) );

   return;
}

/****i* readInPrimitiveFile() [1.9] **********************************
* 
* NAME
*    readInPrimitiveFile()
*
* DESCRIPTION
*    File-in a .p file by running it through the Interpreter.
*
* WARNING
*    Since there is no way of checking, make sure that the file
*    is debugged BEFORE you use this!
* 
* SYNOPSIS
*    readInPrimitiveFile: fileName
*       <primitive 138 0 0 fileName>
**********************************************************************
*
*/

METHODFUNC void readInPrimitiveFile( char *fileName )
{
   ExecuteExternalScript( fileName );

   return;
}

/****h* HandleSupervisor() [2.1] *************************************
* 
* NAME
*    HandleSupervisor()
*
* DESCRIPTION
*    Do mighty deeds from within AmigaTalk, such as filing in .p files,
*    reading & executing external files of AmigaTalk commands  &
*    running them through the interpreter.
*
* WARNING
*    Since there is no way of checking, make sure that the file
*    is debugged BEFORE you use this!
*    ^ <primitive 138 xx xx parms>
**********************************************************************
*
*/

PUBLIC OBJECT *HandleSupervisor( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;

   FBEGIN( printf( "<138> HandleSupervisor( %d, 0x%08LX )\n", numargs, args ) );   

   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 138 );

      goto exitHandleSupervisor;
      }

   numargs--;
            
   switch (int_value( args[0] ))
      {
      case 0:
         numargs--;
         
         switch (int_value( args[1] ))
            {
            case 0: // readInPrimitiveFile: fileName
               if (is_string( args[2] ) == FALSE)
                  (void) PrintArgTypeError( 138 );
               else
                  readInPrimitiveFile( string_value( (STRING *) args[2] ) );

               break;

            default:
               break;
            }

         break;

      case 1:
            
      default:
         break;
      }

exitHandleSupervisor:

   FEND( printf( "0x%08LX = HandleSupervisor()\n" ) );
         
   return( rval );
}

// strlen() might not count the newline as a valid character:

SUBFUNC int RealStrLen( char *string )
{
   int i = 0;
   
   while (*(string + i) != NIL_CHAR)
      i++;
   
   return( i ); 
}

/****h* fgetHexStr() [1.9] *******************************************
* 
* NAME
*    fgetHexStr()
*
* DESCRIPTION
*    Get a hexadecimal string from a file & convert it to an integer.
*    Used by SetImageData() in SGraphs.c
**********************************************************************
*
*/

PUBLIC int fgetHexStr( FILE *fp, int numdigits, char *delimiters )
{
   char temp[10] = { 0, };

   int i,  len  = RealStrLen( delimiters );
   int ch, rval = 0; 

   if (numdigits > 8)
      numdigits = 8;          // Correct user errors.
   else if (numdigits < 1)
      return( rval );
               
   for (i = 0; i < numdigits; i++)
      {
      int j;
      
      ch = fgetc( fp );
      
      for (j = 0; j < len; j++)
         {
         if (ch == delimiters[j])
            goto ConvertToInt;
         }  
      
      temp[i] = toupper( ch );
      }

ConvertToInt:
      
   for (i = 0; i < numdigits; i++)
      {
      ch = temp[i];
         
      if (ch >= ZERO_CHAR && ch <= NINE_CHAR)
         ch = ch - ZERO_CHAR;
      else if (ch >= CAP_A_CHAR && ch <= CAP_F_CHAR)
         ch = ch - CAP_A_CHAR + 10;
         
      rval += (ch & 0x0F); // only one hex digit is valid.
      rval  = rval << 4;   // shift by one hex digit.
      }

   rval = rval >> 4;       // Final adjustment.
        
   return( rval );
}

/****h* indentTrace() ************************************************
* 
* NAME
*    indentTrace()
*
* DESCRIPTION
*    indent the TraceFile output to indicate nesting of the 
*    bytecodes.
**********************************************************************
*
*/

PUBLIC void indentTrace( void )
{
   int indentlevel = TraceIndent;

   if ((indentlevel == 0) || (!TraceFile)) // == NULL))
      return;
      
   while (indentlevel > 0)
      {
      fputs( TWO_SPACES, TraceFile );

      indentlevel--;
      }

   return;
}

/****h* IsScreen() ***************************************************
* 
* NAME
*    IsScreen()
*
* DESCRIPTION
*    Check the IntuitionBase Screen list for the existence of the 
*    address.  If NOT present, return FALSE.
**********************************************************************
*
*/

PUBLIC BOOL IsScreen( ULONG address )
{
   struct Screen *scr   = (struct Screen *) NULL;

   ULONG          ilock = 0L;
   BOOL           rval  = FALSE;

   if (!address) // == NULL)
      return( rval );    // NULL is NOT a valid Screen address!
          
   ilock = LockIBase( 0 );

#    ifdef  __SASC
     scr = IntuitionBase->FirstScreen;
#    else
     scr = ((struct IntuitionBase *) IIntuition->Data.LibBase)->FirstScreen;
#    endif

     while (scr) // != NULL)
        {
        if (scr == (struct Screen *) address)
           {
           rval = TRUE;

           break;
           }

        scr = scr->NextScreen;
        }
     
   UnlockIBase( ilock );

   return( rval );
}

/****h* SetupLV() **************************************************
*
* NAME
*    SetupLV()
*
* DESCRIPTION
*    Put together a basic List of Nodes for a ListView gadget.
*
* NOTES
*    Used for the ListView gadget.
********************************************************************
*
*/

PUBLIC void SetupLV( struct List *LVList,
                     struct Node *nodes, 
                     char        *buffer,
                     int          numitems, 
                     int          itemsize
                   )
{
   struct ListViewMem lvm;

   FBEGIN( printf( "SetupLV( 0x%08LX, 0x%08LX, 0x%08LX, %d, %d )\n", LVList,nodes,buffer,numitems,itemsize ) );   

   lvm.lvm_NodeStrs   = buffer;
   lvm.lvm_Nodes      = nodes;
   lvm.lvm_NumItems   = numitems;
   lvm.lvm_NodeLength = itemsize;

   SetupList( LVList, &lvm ); // In CommonFuncs.o

   FEND( printf( "SetupLV() exit.\n" ) );

   return;
}

// -------------------------------------------------------------------


PRIVATE struct Window  *st_win = NULL;

PRIVATE struct NewWindow statwind = {

  0, 430, 640, 50, 1, 0,
  IDCMP_CLOSEWINDOW,

  WFLG_CLOSEGADGET | WFLG_DRAGBAR | WFLG_SMART_REFRESH 
  | WFLG_ACTIVATE | WFLG_RMBTRAP,

  NULL, NULL, NULL, NULL, NULL, // (UBYTE *) MSG_GL_STATUS_TITLE_STR
  300, 30, 640, 480, CUSTOMSCREEN
};

// -------------------------------------------------------------------

/****h* OpenStatusWindow() [2.2] ***********************************
*
* NAME
*    OpenStatusWindow()
*
* DESCRIPTION
*    Open the AmigaTalk to User message window.
********************************************************************
*
*/

PUBLIC int OpenStatusWindow( int Height )
{
   IMPORT UWORD ATTop, ATHeight;

   UWORD statTop;

   statwind.Title = GlobCMsg( MSG_GL_STATUS_TITLE_GLOB );
   
   statTop = ATHeight + ATTop + Scr->WBorBottom + Scr->BarHeight 
                      + Scr->BarVBorder;

   if (st_win) // != NULL)
      return( 0 );
             
   if (Height < (Scr->Height - statTop))
      statwind.Height = Height;
   else
      statwind.Height = Scr->Height - statTop;


   if (ATStatWidth > Scr->Width)
      statwind.Width  = Scr->Width;
   else
      statwind.Width = ATStatWidth;

   statwind.Screen = Scr;

   if (!(st_win = OpenWindowTags( &statwind,

                   WA_Top,   statTop,
                      
                   WA_IDCMP, IDCMP_CLOSEWINDOW | IDCMP_RAWKEY,
                   
                   WA_Flags, WFLG_DRAGBAR | WFLG_DEPTHGADGET 
                     | WFLG_CLOSEGADGET | WFLG_SMART_REFRESH 
                     | WFLG_ACTIVATE | WFLG_RMBTRAP, // | WFLG_SIZEGADGET,
                   
                   TAG_DONE )
      )) // == NULL)
      return( -2 );
       
   if (!st_console) // == NULL)
      if (!(st_console = AttachConsole( st_win, STATUS_CONSOLENAME ))) // == NULL)
         {
         CloseWindow( st_win );

         return( -3 );
         }
        
   // Reset these for UpdateEnvFile():
   ATStatWidth  = statwind.Width;
   ATStatHeight = statwind.Height;
   ATStatTop    = statTop;
   ATStatLeft   = statwind.LeftEdge;

   return( 0 );
}

PUBLIC void  CloseStatusWindow( void )
{
   if (st_console) // != NULL)
      {
      DetachConsole( st_console );
      st_console = NULL;
      }

   if (st_win) // != NULL)    
      {
      CloseWindow( st_win );
      st_win = NULL;
      }

   return;
}

/****h* IndexChk() [1.0] *********************************************
*
* NAME
*    IndexChk()
*
* DESCRIPTION
*
* NOTES
*    Verify that the given index is within the bounds of the array.
**********************************************************************
*
*/

PUBLIC BOOL IndexChk( int index, int boundary, char *arrayname )
{
   FBEGIN( printf( "IndexChk( %d, %d, 0x%08LX )\n", index, boundary, arrayname ) );    

   if ((index > boundary) || (index < 0))
      {
      sprintf( ErrMsg, GlobCMsg( MSG_GL_BAD_INDEX_GLOB ), index, boundary, arrayname );

      InternalProblem( ErrMsg );

      FEND( printf( "IndexChk() failed!\n" ) );

      return( FALSE );
      }
   else
      {
      FEND( printf( "IndexChk() passed!\n" ) );

      return( TRUE );
      }
}

// -------------------------------------------------------------------

PUBLIC BOOL STR_EQ( char *a, char *b )
{
   if (StringComp( a, b ) == 0)
      return( TRUE );
   else
      return( FALSE );
}

PUBLIC int ATSystem( char *command )
{
   return( (int) SystemTags( command, TAG_DONE ) );
}

PUBLIC void dspMethod( char *cp, char *mp )
{
   char nil[256] = { 0, }, *msg = &nil[0];
   
   StringCopy( msg, cp );
   StringCat(  msg, NEWLINE_STR );
   StringCat(  msg, mp );

   UserInfo( msg, GlobCMsg( MSG_METHOD_COLON_GLOB ) );

   return;
}

/* /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/ */

PUBLIC struct Screen *FindScreenPtr( char *screentitle )
{
   struct Screen *s     = NULL;
   ULONG          ilock = 0L;

   ilock = LockIBase( 0 );

#    ifdef  __SASC
     s = IntuitionBase->FirstScreen;
#    else
     s = ((struct IntuitionBase *) IIntuition->Data.LibBase)->FirstScreen;
#    endif

     while (s) // != NULL)
        {   
        if (s->Title) // != NULL)
           {
           if (StringComp( s->Title, screentitle ) == 0)
	      {
	      UnlockIBase( ilock );
              
	      return( s );
	      }
           }

        s = s->NextScreen;
        }
        
   UnlockIBase( ilock );

   return( NULL );
}

PUBLIC struct Window *FindWindowPtr( char *windowname )
{
   struct Screen *s     = (struct Screen *) NULL;
   ULONG          ilock = 0L;

   ilock = LockIBase( 0 );

#    ifdef  __SASC
     s = IntuitionBase->FirstScreen;
#    else
     s = ((struct IntuitionBase *) IIntuition->Data.LibBase)->FirstScreen;
#    endif

     while (s) // != NULL)
        {   
        struct Window *w = s->FirstWindow;
        
        while (w) // != NULL)
           {
           if (w->Title) // != NULL)
              {
              if (StringComp( w->Title, windowname ) == 0)
	         {
		 UnlockIBase( ilock );

                 return( w );
		 }
              }
           
           w = w->NextWindow;
           }

        s = s->NextScreen;
        }
        
   UnlockIBase( ilock );

   return( NULL );
}

/*************************************************************************
** objects with non-object value (classes, integers, etc) have a
** negative size field, the particular value being used to indicate
** the type of object (the class field cannot be used for this purpose
** since all classes, even those for built in objects, can be redefined
**
** check_bltin was a macro that tested the size field for a particular
** value.  it was used to define other macros, such as is_class, that
** test each particular type of object.
**
** The following classes are builtin
**
**    Block
**    ByteArray
**    Char 
**    Class
**    File
**    Float
**    Integer
**    Interpreter
**    Process
**    String
**    Symbol
**    CLASS_SPEC
**
** These macros were changed to functions for several reasons:
**    1. The Compiler will check for correct argument passing to 
**       functions (this cannot be done with a macro!)
**    2. The return type is clear & unambiguous.
**    3. Speed is not as important as being able to find bugs in
**       the source code.
**    4. My Amiga is fast enough to make up for the overhead.
**************************************************************************
*/

/****h* AmigaTalk/is_bltin() [1.0] ************************************
*
* NAME
*    is_bltin()
*
* DESCRIPTION
*    See if an Object is a built-in Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_bltin( OBJECT *obj )
{
   if (obj && (objType( obj ) != 0))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/Class_Name() [2.5] **********************************
*
* NAME
*    Class_Name()
*
* DESCRIPTION
*    Return the name of the Object's class
***********************************************************************
*
*/

PUBLIC char *Class_Name( OBJECT *thisObj )
{
   CLASS *oClass = NULL;

   FBEGIN( printf( "Class_Name( 0x%08LX )\n", thisObj ) );   

   if (thisObj) // != NULL)
      {
      oClass = (CLASS *) thisObj->Class;

      FEND( printf( "%s = Class_Name()\n", symbol_value( (SYMBOL *) oClass->class_name )) );

      return( symbol_value( (SYMBOL *) oClass->class_name ) );
      }
   else
      {
      FEND( printf( "**NULL** = Class_Name()\n" ) );

      return( NULL );
      }
}

/****h* AmigaTalk/is_array() [1.9] ************************************
*
* NAME
*    is_array()
*
* DESCRIPTION
*    See if an Object is an Array Object.
***********************************************************************
*
*/

PUBLIC BOOL is_array( OBJECT *obj )
{
   char  *ClassName = NULL;
   
   if (obj && obj != o_nil)
      {
      ClassName = Class_Name( obj );
      }
   else
      return( FALSE );
      
   if (StringComp( ARRAY_NAME, ClassName ) == 0)
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_block() [1.0] ************************************
*
* NAME
*    is_block()
*
* DESCRIPTION
*    See if an Object is a Block Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_block( OBJECT *obj )
{
   if (obj && ((objType( obj ) == MMF_BLOCK))) // BLOCKSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_bytearray() [1.0] ********************************
*
* NAME
*    is_bytearray()
*
* DESCRIPTION
*    See if an Object is a ByteArray Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_bytearray( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_BYTEARRAY)) // ->size == BYTEARRAYSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_character() [1.0] ********************************
*
* NAME
*    is_character()
*
* DESCRIPTION
*    See if an Object is a Char Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_character( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_CHARACTER)) // ->size == CHARSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_class() [1.0] ************************************
*
* NAME
*    is_class()
*
* DESCRIPTION
*    See if an Object is a Class Object.  This used to be a macro.
***********************************************************************
*
*/

#ifdef   __SASC
PUBLIC __far BOOL is_class( OBJECT *obj )
#else
PUBLIC BOOL is_class( OBJECT *obj )
#endif
{
   if (obj && (objType( obj ) == MMF_CLASS)) // ->size == CLASSSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_file() [1.0] *************************************
*
* NAME
*    is_file()
*
* DESCRIPTION
*    See if an Object is a File Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_file( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_FILE)) // ->size == FILESIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_float() [1.0] ************************************
*
* NAME
*    is_float()
*
* DESCRIPTION
*    See if an Object is a Float Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_float( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_FLOAT)) // ->size == FLOATSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_integer() [1.0] **********************************
*
* NAME
*    is_integer()
*
* DESCRIPTION
*    See if an Object is an Integer Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_integer( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_INTEGER)) // ->size == INTEGERSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_interpreter() [1.0] ******************************
*
* NAME
*    is_interpreter()
*
* DESCRIPTION
*    See if an Object is an Interpreter Object.  
*    This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_interpreter( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_INTERPRETER)) // ->size == INTERPSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_process() [1.0] **********************************
*
* NAME
*    is_process()
*
* DESCRIPTION
*    See if an Object is a Process Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_process( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_PROCESS)) // ->size == PROCSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_string() [1.0] ***********************************
*
* NAME
*    is_string()
*
* DESCRIPTION
*    See if an Object is a String Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_string( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_STRING)) // ->size == STRINGSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_symbol() [1.0] ***********************************
*
* NAME
*    is_symbol()
*
* DESCRIPTION
*    See if an Object is a Symbol Object.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_symbol( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_SYMBOL)) // ->size == SYMBOLSIZE))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_address() [2.5] **********************************
*
* NAME
*    is_address()
*
* DESCRIPTION
*    See if an Object is an AmigaTalk Address Object.
***********************************************************************
*
*/

PUBLIC BOOL is_address( OBJECT *obj )
{
   if (obj && (objType( obj ) == MMF_ADDRESS))
      return( TRUE );
   else
      return( FALSE );
}

/****h* AmigaTalk/is_driver() [1.0] ***********************************
*
* NAME
*    is_driver()
*
* DESCRIPTION
*    See if an Object is o_drive.  This used to be a macro.
***********************************************************************
*
*/

PUBLIC BOOL is_driver( OBJECT *obj )
{
   if (obj && (obj == o_drive))
      return( TRUE );
   else
      return( FALSE );
}

// # define symbol_value(x) (( (SYMBOL *) x)->y_value)

/****h* AmigaTalk/symbol_value() [1.0] ********************************
*
* NAME
*    symbol_value()
*
* DESCRIPTION
*    Return the string that represents the symbol.  Used to be a Macro.
***********************************************************************
*
*/

PUBLIC char *symbol_value( SYMBOL *symbol )
{
   if (!symbol || symbol == (SYMBOL *) o_nil)
      return( "NULL" );
      
   return( symbol->value );
}

/****h* AmigaTalk/string_value() [1.0] ********************************
*
* NAME
*    string_value()
*
* DESCRIPTION
*    Return the string that's attached to a STRING.  
*    Used to be a Macro.
***********************************************************************
*
*/

PUBLIC char *string_value( STRING *str )
{
   return( str->value );
}

PUBLIC char *str_value( STRING *str ) // Synonym for string_value()
{
   return( str->value );
}

/****h* AmigaTalk/BYTE_VALUE() [1.0] **********************************
*
* NAME
*    BYTE_VALUE()
*
* DESCRIPTION
*    Return a pointer to the array of bytes from ByteArray.
*    Used to be a Macro.
***********************************************************************
*
*/

PUBLIC char *BYTE_VALUE( BYTEARRAY *ba )
{
   return( ba->bytes );
}

/* ------------------- END of Global.c file! -------------------- */
