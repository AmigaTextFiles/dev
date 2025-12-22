/****h* AmigaTalk/FuncProtos.h [2.5] *********************************
*
* NAME
*    FuncProtos.h
* 
* DESCRIPTION
*    Function prototypes for all AmigaTalk functions, except for 
*    the ARexx interface.
**********************************************************************
*
*/

#ifndef  FILE
# include <stdio.h>
#endif

#ifndef EXEC_TYPES_H
# include <exec/types.h>
#endif

# ifndef COMMONFUNCS_H
#  include <CommonFuncs.h> // Moved to SDK:local/Include/ "CPGM:GlobalObjects/CommonFuncs.h"
# endif
 
#ifndef  AMIGATALK_STRUCTS_H
# include "ATStructs.h"
#endif

#ifndef ITEM_STRUCTS_H
# include "IStructs.h"
#endif

# ifndef METHODFUNC
#  define METHODFUNC static
# endif

# ifndef SUBFUNC
#  define SUBFUNC static
# endif

// For the FDEV in the commandLine arguments, (BOOL FDEV is in Global.c):

IMPORT BOOL FDEV; // In Global.c

# define FBEGIN( p )   if (FDEV == TRUE) p
# define FEND(   p )   if (FDEV == TRUE) p

// --- Possible obsolete functions: --------------------------

IMPORT int   ATSystem( char *cmdstr );
IMPORT void  gettemp(  char *buffer );
IMPORT char *brk(      int   addr   );

// ----------------- functions in CatFuncs1.c: ----------------

IMPORT STRPTR CMsg(    int strIndex, STRPTR defaultString );
IMPORT STRPTR ATECMsg( int strIndex, STRPTR defaultString );

IMPORT STRPTR APrintCMsg( int whichString ); // APrintf.c
IMPORT STRPTR PalCMsg(    int whichString ); // ATalkPalette.c
IMPORT STRPTR AudCMsg(    int whichString ); // Audio.c 
IMPORT STRPTR BlkCMsg(    int whichString ); // Block.c 
IMPORT STRPTR BoopCMsg(   int whichString ); // Boopsi.c
IMPORT STRPTR BdrCMsg(    int whichString ); // Border.c 
IMPORT STRPTR CDROMCMsg(  int whichString ); // CDROM.c
IMPORT STRPTR ClassCMsg(  int whichString ); // Class.c
IMPORT STRPTR CLDCMsg(    int whichString ); // ClDict.c 
IMPORT STRPTR ClipCMsg(   int whichString ); // Clipboard.c
IMPORT STRPTR ConCMsg(    int whichString ); // Console.c 
IMPORT STRPTR CourCMsg(   int whichString ); // Courier.c
IMPORT STRPTR CursCMsg(   int whichString ); // CurPrims.c
IMPORT STRPTR DBaseCMsg(  int whichString ); // DBase.c
IMPORT STRPTR MainCMsg(   int whichString ); // Main.c
IMPORT STRPTR EnvCMsg(    int whichString ); // ATalkEnviron.c
IMPORT STRPTR SetupCMsg(  int whichString ); // Setup.c
IMPORT STRPTR AboutCMsg(  int whichString ); // ATAbout.c
IMPORT STRPTR ATTCMsg(    int whichString ); // ATalkTracer.c
IMPORT STRPTR GadCMsg(    int whichString ); // ATGadgets.c
IMPORT STRPTR ATHBCMsg(   int whichString ); // ATHB.c 
IMPORT STRPTR USRCMsg(    int whichString ); // UserScriptReq.c 
IMPORT STRPTR HelpCMsg(   int whichString ); // ATHelper.c
IMPORT STRPTR MenuCMsg(   int whichString ); // ATMenus.c
IMPORT STRPTR GlobCMsg(   int whichString ); // Global.c

IMPORT int CatalogADOS1(      void );         // ADOS1.c
IMPORT int TraceCatalog(      void );         // ATalkTracer.c
IMPORT int CatalogATGadgets(  void );         // ATGadgets.c
IMPORT int CatalogATHelper(   void );         // ATHelper.c
IMPORT int CatalogATMenus(    void );         // ATMenus.c
IMPORT int CatalogCDROM(      void );         // CDROM.c
IMPORT int CatalogClipboard(  void );         // Clipboard.c
IMPORT int CatalogConsole(    void );         // Console.c
IMPORT int CatalogGlobal(     void );         // Global.c
IMPORT int CatalogUserScript( void );         // UserScriptReq.c

// ----------------- functions in CatFuncs2.c: ----------------

IMPORT int CatalogDisk2(    void );            // For Disk2.c
IMPORT int CatalogIcon(     void );            // For Icon.c
IMPORT int CatalogIconDsp(  void );            // For IconDsp.c
IMPORT int CatalogInterp(   void );            // For Interp.c
IMPORT int CatalogIO(       void );            // For IO.c
IMPORT int CatalogMenu(     void );            // For Menus.c
IMPORT int CatalogNarrator( void );            // For Narrator.c

IMPORT STRPTR DiskCMsg(  int whichString ); // For Disk.c & Disk2.c
IMPORT STRPTR DriveCMsg( int whichString ); // Drive.c
IMPORT STRPTR DTypeCMsg( int whichString ); // DTInterface.c
IMPORT STRPTR FileCMsg(  int whichString ); // File.c
IMPORT STRPTR GadgCMsg(  int whichString ); // Gadget.c
IMPORT STRPTR GToolCMsg( int whichString ); // GadTools.c
IMPORT STRPTR GameCMsg(  int whichString ); // GamePort.c
IMPORT STRPTR IconCMsg(  int whichString ); // Icon.c & IconDsp.c
IMPORT STRPTR IFFCMsg(   int whichString ); // IFF.c
IMPORT STRPTR IntrpCMsg( int whichString ); // Interp.c
IMPORT STRPTR IOCMsg(    int whichString ); // IO.c
IMPORT STRPTR ITxtCMsg(  int whichString ); // ITextFont.c
IMPORT STRPTR LexCMsg(   int whichString ); // Lex.c
IMPORT STRPTR LCmdCMsg(  int whichString ); // LexCmd.c
IMPORT STRPTR LineCMsg(  int whichString ); // Line.c
IMPORT STRPTR MenusCMsg( int whichString ); // Menus.c
IMPORT STRPTR MPortCMsg( int whichString ); // MsgPort.c
IMPORT STRPTR NarrCMsg(  int whichString ); // Narrator.c

// ----------------- functions in CatFuncs3.c: ----------------

IMPORT int CatalogParallel(   void );         // Parallel.c
IMPORT int CatalogPrinter(    void );         // Printer.c
IMPORT int CatalogErrStrings( void );         // ReportErrs.c
IMPORT int CatalogRexx(       void );         // RExx.c
IMPORT int CatalogScreen(     void );         // Screen.c
IMPORT int CatalogSystem(     void );         // System.c
IMPORT int CatalogTools(      void );         // Tools.c
PUBLIC int CatalogTracer(     void );         // Tracer.c
PUBLIC int CatalogTracer2(    void );         // Tracer2.c

IMPORT STRPTR NumbCMsg(  int whichString ); // Number.c
IMPORT STRPTR ObjCMsg(   int whichString ); // Object.c
IMPORT STRPTR ParCMsg(   int whichString ); // Parallel.c
IMPORT STRPTR PrtCMsg(   int whichString ); // Printer.c
IMPORT STRPTR PlotCMsg(  int whichString ); // PlotFuncs.c
IMPORT STRPTR PFuncCMsg( int whichString ); // PrimFuncs.c
IMPORT STRPTR PrimCMsg(  int whichString ); // Primitive.c
IMPORT STRPTR ProcCMsg(  int whichString ); // Process.c
IMPORT STRPTR RErrsCMsg( int whichString ); // ReportErrs.c
IMPORT STRPTR ReqCMsg(   int whichString ); // Requester.c
IMPORT STRPTR RexxCMsg(  int whichString ); // Rexx.c
IMPORT STRPTR ScrnCMsg(  int whichString ); // Screen.c
IMPORT STRPTR SCSICMsg(  int whichString ); // SCSI.c
IMPORT STRPTR SDictCMsg( int whichString ); // SDict.c
IMPORT STRPTR SGrphCMsg( int whichString ); // SGraphs.c
IMPORT STRPTR StrCMsg(   int whichString ); // String.c
IMPORT STRPTR SymCMsg(   int whichString ); // Symbols.c
IMPORT STRPTR SysCMsg(   int whichString ); // System.c
IMPORT STRPTR TagCMsg(   int whichString ); // TagFuncs.c
IMPORT STRPTR ToolsCMsg( int whichString ); // Tools.c
IMPORT STRPTR TraceCMsg( int whichString ); // Tracer.c & Tracer2.c

// ========== functions in ReportErrs.c: =============================

IMPORT void givepause( void );

// ---------- For AmigaTalk Problems:  -------------------------------

IMPORT BOOL NullFound(       char *where );
IMPORT void CouldNotPerform( char *func, char *forMe );
IMPORT void InternalProblem( char *msg );
IMPORT int  cant_happen(     int n );

// ---------- For User Program Problems: -----------------------------

IMPORT int  ChkArgCount(   int need, int numargs, int primnumber );
IMPORT void OutOfRange(    char *item, int lower, int upper, int actual );
IMPORT void FoundNullPtr(  char *funcName );
IMPORT void AlreadyOpen(   char *whatIs );
IMPORT void ObjectWasZero( char *whatIs );

// ---------- For User Problems: -------------------------------------

IMPORT void CheckToolType( char *whichOne );
IMPORT void NotFound(      char *what );
IMPORT void InvalidItem(   char *what );
     
// ---------- For System Problems: -----------------------------------

IMPORT void MemoryOut(         char *whereAt );
IMPORT void Unsupported(       char *what, char *operation );
IMPORT void CannotOpenFile(    char *fileName );
IMPORT void CannotCreatePort(  char *portType );
IMPORT void CannotCreateStdIO( char *forWho );
IMPORT void CannotCreateExtIO( char *forWho );
IMPORT void CannotOpenDevice(  char *deviceType );
IMPORT void CannotCreate(      char *what );
IMPORT void CannotSetup(       char *what );
IMPORT void NotOpened(         int   what );
// ====================================================================

// ----------------- functions in Address.c: -----------------

IMPORT ULONG addr_value( OBJECT *obj );

IMPORT void freeVecAllAddresses( void );
IMPORT void free_address( AT_ADDRESS *b );

IMPORT OBJECT *new_address( ULONG addr );

//SUBFUNC AT_ADDRESS *allocAddress( void )
//SUBFUNC void storeAddress( AT_ADDRESS *b, AT_ADDRESS **last, AT_ADDRESS **list )
//SUBFUNC AT_ADDRESS *findFreeAddress( void )
//SUBFUNC void recycleAddress( AT_ADDRESS *killMe )

// ----------------- functions in Setup.c: -------------------

IMPORT int  firstSetup( void );
IMPORT int  InitATalk(  void );
IMPORT void ShutDown(   void );

IMPORT void freeVecMemorySpaces(   void );
IMPORT int  freeSlackMemorySpaces( void );

/*
**   InitATalk() calls these functions:
**
**   PRIVATE  int   SetupScreen( void );
**
**   PRIVATE  int   OpenATWindow( void );
**   PRIVATE  int   SetupListViewer( void );
**
**   IMPORT  void InitAList( void );
**   ---------------------------------------------------------
**   ShutDown() calls these functions:
**
**   IMPORT  void KillList( void );
**
**   PRIVATE void CloseATWindow( void );
**   PRIVATE void CloseDownScreen( void );
**   PRIVATE void CloseATLibs( void );
*/

// ----------------- functions in ATGadgets.c: ---------------

IMPORT void ClearCommandStrGadget( void ); // Used in ATMenus.c

IMPORT void GetCommand( char *buffer );    // Used in Line.c
IMPORT void AddToPgmLV( char *string );    // Used in ATMenus.c

// ----------------- functions in ATMenus.c: -----------------

IMPORT int ATAddUserScript(    void ); // Added on 03-Oct-2003
IMPORT int ATRemoveUserScript( void ); // Added on 03-Oct-2003

IMPORT int ATHelpProgram(    void );
IMPORT int ATLoadProgram(    void );
IMPORT int ATSaveProgram(    void );
IMPORT int ATSaveAsProgram(  void );
IMPORT int ATQuitAmigaTalk(  void );
IMPORT int ATAboutAmigaTalk( void );
IMPORT int ATOpenBrowser(    void );
IMPORT int ATEditFile(       void );

// ----------------- functions in Tools.c:  -------------------

IMPORT void *processToolTypes( STRPTR *toolptr );

IMPORT void SetupDefaultTools( void );

// ----------------- functions in Global.c: -------------------

# ifdef __amigaos4__
IMPORT void OS4SetTagItem( struct TagItem tagList[], ULONG searchTag, ULONG newValue );

IMPORT int hexStrToLong( char *inString,  long *output );
IMPORT int longToHexStr( char *outString, long  input  );

IMPORT ULONG VARARGS68K BreakPointDBG( UBYTE *title, char *format, ... );
# else  // Older OS3.9 function required:
IMPORT ULONG BreakPointDBG( UBYTE *title, char *format, ... );
# endif

IMPORT void TurnOnBreakPoints(  void );
IMPORT void TurnOffBreakPoints( void );

IMPORT void *AT_AllocVec( ULONG  size,     ULONG flags, char *msg, BOOL prtFlag );
IMPORT void  AT_FreeVec(  void  *memBlock,              char *msg, BOOL prtFlag );
IMPORT void *AT_calloc(   ULONG  number,   ULONG size,  char *msg, BOOL prtFlag );
IMPORT void  AT_free(     void  *memBlock,              char *msg, BOOL prtFlag );

//# ifndef ObjActionFuncPtr
//IMPORT typedef  OBJECT * (**ObjActionFuncPtr)( OBJECT * );
//# endif

IMPORT OBJECT *ObjActionByType( OBJECT *obj, 
                                OBJECT *(**action)( OBJECT * ) );

IMPORT void *makeMemoryPool(  ULONG maxSize, ULONG threshold );
IMPORT void  drainMemoryPool( void *PoolHeader );

IMPORT char *Class_Name( OBJECT *thisObj );              // Added in V2.5

IMPORT void ClearLVMNodeStrs( struct ListViewMem *lvm ); // Added in V2.4

IMPORT int getNumberMethods( char *className );          // Added in V2.4

IMPORT int getFileLineCount( char *className );          // Added in V2.4

IMPORT void KillObject( OBJECT * ); // zero out ref_count.

IMPORT void RemoveObject( OBJECT * ); // FreeVec an OBJECT.

IMPORT void *CheckObject( OBJECT *obj );

IMPORT CLASS *FindSuper( CLASS *thisClass ); // Added in V2.3

IMPORT int ConvertToInt( UWORD fixedpoint );

IMPORT OBJECT *FindGadgetValue( struct Gadget *g );

IMPORT char *FindMenuString( UWORD code, struct Window *wptr );

IMPORT struct Gadget *FindGadgetPointer( struct Window *wp, int gadg );

IMPORT void ExecuteExternalScript( char *filename );

IMPORT OBJECT *HandleSupervisor( int numargs, OBJECT **args );

IMPORT BOOL NullChk( OBJECT *testMe );

IMPORT void *ObjectToAddress( OBJECT *obj );

IMPORT int fgetHexStr( FILE *fp, int numdigits, char *delimiters );

IMPORT void indentTrace( void );

IMPORT BOOL IsScreen( ULONG address );

IMPORT void SetupLV( struct List *LVList,
                     struct Node *nodes, 
                     char        *buffer,
                     int          numitems, 
                     int          itemsize
                   );

IMPORT int  OpenStatusWindow( int Height );
IMPORT void CloseStatusWindow( void );

IMPORT BOOL IndexChk( int index, int boundary, char *arrayname );

IMPORT void dspMethod( char *cp, char *mp );


IMPORT BOOL STREQ( char *a, char *b );

IMPORT struct Screen *FindScreenPtr( char *screentitle );
IMPORT struct Window *FindWindowPtr( char *windowname );

IMPORT char *Class_Name( OBJECT *thisObj );

// Former Macros:

IMPORT BOOL is_bltin(       OBJECT *obj );
IMPORT BOOL is_address(     OBJECT *obj ); // Added on 08-Dec-2003
IMPORT BOOL is_block(       OBJECT *obj );
IMPORT BOOL is_bytearray(   OBJECT *obj );
IMPORT BOOL is_array(       OBJECT *obj ); // added on 13-Jan-2002
IMPORT BOOL is_character(   OBJECT *obj );

# ifdef      __SASC
IMPORT __far BOOL is_class( OBJECT *obj );
# else
IMPORT BOOL is_class(       OBJECT *obj );
# endif

IMPORT BOOL is_file(        OBJECT *obj );
IMPORT BOOL is_float(       OBJECT *obj );
IMPORT BOOL is_integer(     OBJECT *obj );
IMPORT BOOL is_interpreter( OBJECT *obj );
IMPORT BOOL is_process(     OBJECT *obj );
IMPORT BOOL is_string(      OBJECT *obj );
IMPORT BOOL is_symbol(      OBJECT *obj );
IMPORT BOOL is_driver(      OBJECT *obj );

IMPORT char *symbol_value( SYMBOL    *symbol );
IMPORT char *string_value( STRING    *str    );
IMPORT char *BYTE_VALUE(   BYTEARRAY *ba     );

// ----------------- functions in Main.c: ---------------------

IMPORT int  main( int argc, char **argv );

IMPORT void cleanOutInterpreters( void );

IMPORT void KillLogo( struct MsgPort *masterPort );

IMPORT void print_usage( char *pgm_name );

IMPORT int  AmigaLoop( char *buffer );          // See line.c file.

// ----------------- functions in Amiga_Printf.c: --------------

IMPORT void APrint( char *outstr ); // replacement for Amiga_Printf()

// PRIVATE int Amiga_Printf( char *fmtstr, ... );

// ----------------- functions in TagFuncs.c: ----------------

IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray );

IMPORT void TagListToArray( struct TagItem *tags, OBJECT *tagArray );

IMPORT void ATSetTagItem( OBJECT *theArray, OBJECT *theTag, 
                          OBJECT *theValue 
                        );

IMPORT OBJECT *ATGetTagItem( OBJECT *theArray, OBJECT *theTag );

IMPORT OBJECT *AddTagItem( OBJECT *theArray, OBJECT *theTag, 
                           OBJECT *theValue 
                         );

IMPORT OBJECT *DeleteTagItem( OBJECT *theArray, OBJECT *theTag );

// ----------------- functions in System.c: -----------------------

IMPORT OBJECT *HandleSystem( int numargs, OBJECT **args );

// ----------------- functions in WBench.c: -----------------------

IMPORT OBJECT *HandleLibIntfc( int numargs, OBJECT **args ); // <209>

// ----------------- functions in GadTools.c: ---------------------

IMPORT OBJECT *HandleGadTools( int numargs, OBJECT **args ); // <239>

// ----------------- functions in Boopsi.c: -----------------------

IMPORT OBJECT *HandleBoopsi( int numargs, OBJECT **args );   // <238>

// ----------------- functions in DTInterface.c: ------------------

IMPORT OBJECT *HandleDT( int numargs, OBJECT **args );       // <210>

// ----------------- functions in Screen.c: --------------------

IMPORT OBJECT *HandleScreens( int numargs, OBJECT **arguments ); // <180>

// ----------------- functions in Window.c: --------------------

IMPORT OBJECT *HandleWindows( int numargs, OBJECT **arguments ); // <181>

// ----------------- functions in Alert.c: ---------------------
//IMPORT OBJECT *HandleAlerts( int numargs, OBJECT **arguments );

// ----------------- functions in Border.c: --------------------

IMPORT ULONG FindIntuiPointer( char *title, int which );

IMPORT OBJECT *HandleBorders( int numargs, OBJECT **arguments );

IMPORT OBJECT *HandleBitMaps( int numargs, OBJECT **arguments );

// ----------------- functions in Gadget.c: --------------------

IMPORT OBJECT *HandleGadgets( int numargs, OBJECT **args );

// ----------------- functions in ITextFont.c: -----------------

IMPORT OBJECT *HandleIText( int numargs, OBJECT **args );

// ----------------- functions in Array.c: ---------------------

IMPORT OBJECT *new_iarray( int size               );

IMPORT OBJECT *new_array(  int size, BOOL initial );

// ----------------- functions in SGraphs.c: -------------------

IMPORT OBJECT *HandleSimpleGraphs( int numargs, OBJECT **args );

// ----------------- functions in Disk.c: ----------------------

IMPORT OBJECT *HandleDisk( int numargs, OBJECT **args );

// ----------------- functions in Disk2.c: ---------------------

IMPORT int DisplayBytes( BYTEARRAY *bytes, char *windowTitle );

// ----------------- functions in Block.c: ---------------------

IMPORT void freeVecAllBlocks(     void ); // Memory Mgmt support.
IMPORT int  freeSlackBlockMemory( void );

IMPORT OBJECT *new_block( INTERPRETER *anInterpreter, int argcount, 
                          int arglocation 
                        );

IMPORT void free_block( BLOCK *b );

IMPORT INTERPRETER *block_execute( INTERPRETER *sender, BLOCK *aBlock,
                                   int numargs, OBJECT **args 
                                 );
                            
IMPORT void  block_return( INTERPRETER *blockInterpreter, OBJECT *anObject );

// ----------------- functions in Byte.c: ----------------------

IMPORT void *allocByteArrayPool( ULONG poolSize );

IMPORT void  freeVecAllByteArrays(     void );
IMPORT int   freeSlackByteArrayMemory( void );

IMPORT OBJECT *new_bytearray(  UBYTE *values, int size );

IMPORT void    free_bytearray( BYTEARRAY *obj );

// ----------------- functions in Class.c: ---------------------

IMPORT void freeVecAllClasses(    void );
IMPORT int  freeSlackClassMemory( void );

IMPORT int  free_class( CLASS *c );

# ifndef __amigaos4__
IMPORT __far CLASS  *fnd_class( OBJECT *anObject );
# else
IMPORT CLASS  *fnd_class( OBJECT *anObject );
# endif

IMPORT CLASS  *new_class( void );
IMPORT CLASS  *mk_class( char *classname, OBJECT **args );

IMPORT OBJECT *new_sinst( CLASS *aclass, OBJECT *super );
IMPORT OBJECT *new_inst( CLASS *aclass );

// ----------------- functions in ClDict.c: --------------------

IMPORT void *allocClassEntryPool(       int size );
IMPORT void  freeVecAllClassEntries(    void );
IMPORT int   freeSlackClassEntryMemory( void );

IMPORT struct class_entry *getClassDictionary( void ); // For Delete Class only!

IMPORT void enter_class( char *name, OBJECT *description, OBJECT *special );

IMPORT OBJECT *FindClassTypeSymbol( CLASS *classPtr ); // Singleton support.
IMPORT OBJECT *FindClassSpecial(    char  *className );
IMPORT OBJECT *GetClassTypeFlags(   CLASS *classPtr );
IMPORT OBJECT *GetInstanceVar(      CLASS *classPtr );
IMPORT void    SetInstanceVar(      CLASS *classPtr, OBJECT *newObject );

IMPORT CLASS *lookup_class( char *name );

IMPORT BYTEARRAY *lookup_method( CLASS *classptr, char *methodName );

IMPORT void free_all_classes( void );

IMPORT void class_list( CLASS *c, int n );

IMPORT OBJECT *HandleClassInfo( int numargs, OBJECT **args ); // <137>

// ----------------- functions in Courier.c: -------------------

IMPORT void prnt_messages( CLASS *aClass );

IMPORT char *getBackTrace( INTERPRETER *current );
IMPORT void  resetBTInterpreter( void );

IMPORT char *Bytes2Str( BYTEARRAY *bytes );

IMPORT void send_mess( INTERPRETER *sender, 
                       OBJECT      *receiver, 
                       char        *message, 
                       OBJECT     **args,
                       int          numargs 
                     );

IMPORT BOOL responds_to( char *message, CLASS *aClass );

IMPORT OBJECT *FindMethodObj( CLASS *classptr, char *messsage );

// ----------------- functions in Drive.c: ---------------------

IMPORT struct varPage *retrieveVarPages(  void );
IMPORT ULONG           retrieveVarCount(  void );
IMPORT OBJECT         *retrieveVarValues( void );
IMPORT OBJECT         *makeVarNameObject( void );
IMPORT void            freeVecVariables(  void );

IMPORT BOOL test_driver( BOOL block, BOOL bypass ); // Added bypass on 28-Jan-2002

IMPORT void lexerr(   char *s, char *v );
IMPORT void lexIerr(  char *s, int   v );

IMPORT void drv_init( void );
IMPORT void drv_free( void );     // Marked for deletion!!

IMPORT void expect( char *str );
IMPORT void genvar( char *name );

IMPORT int  gensend( char *message, int numargs );
IMPORT int  primary( BOOL must );

IMPORT int  bld_interpreter( void );

IMPORT int  parse( void );

// ----------------- functions in File.c: ----------------------

IMPORT void freeVecAllFiles( void );

IMPORT OBJECT *new_file( void );
IMPORT OBJECT *file_read( struct file_struct *phil );

IMPORT int    getw( FILE *fp );

IMPORT void   free_file( struct file_struct *phil );
IMPORT void   file_err( char *msg );
IMPORT void   file_open( struct file_struct *phil, char *name, char *type );
IMPORT void   file_write( struct file_struct *phil, OBJECT *obj );

IMPORT void   putw( int val, FILE *fp );

// ----------------- functions in Interp.c: --------------------

IMPORT void *allocInterpPool( ULONG poolSize );

IMPORT void  freeVecAllInterpreters(     void );
IMPORT int   freeSlackInterpreterMemory( void );

IMPORT INTERPRETER *cr_interpreter( INTERPRETER *sender, 
                                    OBJECT      *receiver, 
                                    OBJECT      *literals, 
                                    OBJECT      *bitearray, 
                                    OBJECT      *context 
                                  );

IMPORT void free_terpreter( INTERPRETER *anInterpreter );

IMPORT void copy_arguments( INTERPRETER *anInterpreter, int argLocation, 
                            int argCount, OBJECT **argArray 
                          );

//IMPORT void push( INTERPRETER *anInterpreter, OBJECT *x );
IMPORT void push_object( INTERPRETER *anInterpreter, OBJECT *anObject );

IMPORT int  nextbyte( INTERPRETER *anInterpreter );

IMPORT void resume( register INTERPRETER *anInterpreter );

// ----------------- functions in Lex.c: -----------------------

IMPORT int  nextlex( void );

// ----------------- functions in LexCmd.c: --------------------

IMPORT char *brk( int addr );

// char *sbrk( int incr );

IMPORT int  lexedit( char *name );

IMPORT void lexread( char *name );
IMPORT void lexinclude( char *name );
IMPORT void dolexcommand( char *p );

// ----------------- functions in Line.c: ----------------------

IMPORT void set_file( FILE *fd );

IMPORT int  line_grabber( int block, char *inbuff );

// ----------------- functions in Number.c: --------------------

IMPORT void *allocIntegerPool(       ULONG poolSize );
IMPORT void  freeVecAllIntegers(     void           );
IMPORT int   freeSlackIntegerMemory( void           );

IMPORT OBJECT *new_int(  int value );
IMPORT OBJECT *new_char( int value );

IMPORT OBJECT *new_cori( int val, int type );

IMPORT void   int_init( char *integerFileName );
IMPORT void   free_integer( INTEGER *i );

IMPORT void   freeVecAllFloats(     void );
IMPORT int    freeSlackFloatMemory( void );

IMPORT OBJECT *new_float(  double val );
IMPORT void    free_float( SFLOAT *f );

// ----------------- functions in Object.c: --------------------

IMPORT void *allocObjectPool(       ULONG poolSize );
IMPORT void  freeVecAllObjects(     void           );
IMPORT int   freeSlackObjectMemory( void           );

IMPORT void    setRefCount( OBJECT *obj, int   newCount );
IMPORT void    setObjSize(  OBJECT *obj, ULONG newSize  );

IMPORT int     objRefCount( OBJECT *obj );
IMPORT int     objSize(     OBJECT *obj );
IMPORT int     objType(     OBJECT *obj );
IMPORT BOOL    objIsFree(   OBJECT *obj );
IMPORT OBJECT *nextObject(  OBJECT *obj );
IMPORT CLASS  *objClass(    OBJECT *obj );

IMPORT int   free_obj( OBJECT *obj, BOOL dofree );

IMPORT OBJECT *new_obj( CLASS *nclass, int nsize, int alloc );

IMPORT OBJECT *fnd_super( OBJECT *anObject );

IMPORT int obj_inc( OBJECT *x );
IMPORT int obj_dec( OBJECT *x ); 

IMPORT char *o_alloc(     unsigned int ObjectSize );
IMPORT void *structalloc( int obj_size            ); // calls o_alloc().

// Replacement for sassign(), assign(), & safeassign():
IMPORT OBJECT *AssignObj(  OBJECT *value );

// ----------------- functions in Primitive.c: -----------------

IMPORT OBJECT *ArgCountError( int numargs, int primnumber );

IMPORT OBJECT *primitive( int primnumber, int numargs, OBJECT **args );

IMPORT int     writeable( char *name );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );
IMPORT OBJECT *PrintNumberError( void );
IMPORT OBJECT *PrintIndexError( void );
IMPORT OBJECT *PrintArrayError( OBJECT *obj );

// Added for V2.5+: --------------------------------------------

IMPORT OBJECT *makeArgsArray( int numelements );
IMPORT void    setArgInArray( OBJECT *argArray, int index, OBJECT *newArg );
IMPORT OBJECT *getArgInArray( OBJECT *argArray, int index );

// ----------------- functions in Process.c: -------------------

// PRIVATE OBJECT *SafeAssign( OBJECT *variable, OBJECT *value );

IMPORT PROCESS *cr_process( INTERPRETER *anInterpreter );

IMPORT void freeVecAllProcesses(    void ); // Part of new memory Mgmt
IMPORT int  freeSlackProcessMemory( void ); // Part of new memory Mgmt

IMPORT int  init_process( INTERPRETER *newproc );
IMPORT int  free_process( PROCESS *aProcess );
IMPORT int  flush_processes( void );
IMPORT int  link_to_process( INTERPRETER *anInterpreter );
IMPORT int  set_state( PROCESS *aProcess, int state );
IMPORT int  brkfun( void );
IMPORT int  start_execution( BOOL directControl ); // added directControl on 28-Jan-2002

IMPORT void terminate_process( PROCESS *aProcess);

// ----------------- functions in String.c: ------------------

IMPORT void freeVecAllStrings(     void );
IMPORT int  freeSlackStringMemory( void );

IMPORT char   *walloc( char *val, int size );

IMPORT STRING *new_istr( char *text );

IMPORT OBJECT *new_str( char *text );

IMPORT void   free_string( STRING *s );

// ----------------- functions in Symbol.c: ------------------

IMPORT void   *allocSymbolPool( ULONG poolSize );
IMPORT void    freeTheSymbols(  void );

IMPORT SYMBOL *sy_search( char *word, int insert ); // binary srch
IMPORT SYMBOL *new_sym(   char *symbol_string );

IMPORT char   *w_search( char *word, int insert );

IMPORT int     WriteSymbolFile( void );
IMPORT int     sym_init(        void );

IMPORT OBJECT *HandleMiscSymbolOps( int numargs, OBJECT **args );

/* --------------- END of FuncProtos.h file! ------------------ */
