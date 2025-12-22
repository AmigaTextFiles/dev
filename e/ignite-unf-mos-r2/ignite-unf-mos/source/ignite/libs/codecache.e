OPT POWERPC, MORPHOS, NOSTARTUP, PREPROCESS, EXENAME = 'codecache.library'

-> codecache.library by LS 2007, needs ECX to compile

MODULE 'morphos/exec/libraries'
MODULE 'morphos/exec/resident'
MODULE 'morphos/emul/emulinterface'

MODULE 'exec/memory'
MODULE 'exec/nodes'
MODULE 'exec/lists'
MODULE 'exec/execbase'
MODULE 'exec/semaphores'

MODULE 'dos/dosextens'

#ifdef DEBUG
#define DEBUGF(str,...) DebugF(str,...)
#else
#define DEBUGF(str,...)
#endif


#define LIB_NAME 'codecache.library'
#define LIB_IDSTR 'codecache.library by LS ' + _DATE_

CONST LIB_VERSION = 1,
      LIB_REVISION = 0

PROC norun() IS -1

STATIC libname = LIB_NAME,
       libidstr = LIB_IDSTR,
       libtag = [RTC_MATCHWORD,
                 libtag,
                 endskip,
                 RTF_PPC,
                 LIB_VERSION,
                 NT_LIBRARY,
                 0,
                 libname,
                 libidstr,
                 sysv_rtinit,
                 0,
                 NIL]:rt,
   functions = [
      FUNCARRAY_BEGIN,
         FUNCARRAY_32BIT_NATIVE,
           m68_Open,
           m68_Close,
           m68_Expunge,
           m68_Reserved,
           -1,
         FUNCARRAY_32BIT_SYSTEMV,
           sysv_OpenCode,
           sysv_CloseCode,
           -1,
      FUNCARRAY_END
               ]



OBJECT librarybase OF lib
   dum:WORD
   seglist:LONG
   execbase:LONG
   dosbase:LONG
   mempool:LONG
   semaphore:ss
   codelist:mlh
ENDOBJECT

OBJECT codenode OF ln
   namelen -> _with_ nilterm
   code
   seglist
   count
ENDOBJECT

OBJECT seg
   size:LONG @ -4
   bptrNext:LONG
ENDOBJECT

PROC sysv_rtinit(dum,seglist,execbase:PTR TO execbase)
   DEF lib=NIL:PTR TO librarybase, dosbase=NIL, mempool=NIL

   DEBUGF('LIB_init\n')

   mempool := CreatePool(4096,4096,MEMF_PUBLIC)
   IF mempool = NIL THEN JUMP rtinit_error

   dosbase := OpenLibrary('dos.library', 50)
   IF dosbase = NIL THEN JUMP rtinit_error

   lib := MakeLibrary({functions}, NIL, NIL, SIZEOF librarybase, seglist)
   IF lib = NIL THEN JUMP rtinit_error

   lib.mempool := mempool
   lib.dosbase := dosbase
   lib.seglist := seglist
   lib.execbase := execbase
   lib.version := LIB_VERSION
   lib.revision := LIB_REVISION
   lib.flags := LIBF_SUMUSED OR LIBF_CHANGED
   lib.ln.name := libname
   lib.idstring := libidstr
   lib.ln.type := NT_LIBRARY

   lib.codelist.head := lib.codelist + 4
   lib.codelist.tail := NIL
   lib.codelist.tailpred := lib.codelist

   InitSemaphore(lib.semaphore)

   AddLibrary(lib)

   DEBUGF('LIB_init DONE lib=$\h\n', lib)

   RETURN lib

rtinit_error:

   DEBUGF('LIB_init ERROR\n')

   IF mempool THEN DeletePool(mempool)
   IF dosbase THEN CloseLibrary(dosbase)

ENDPROC NIL

GETBASE68K MACRO
   DEF lib:PTR TO librarybase, eh:PTR TO emulhandle
   eh := R2
   lib := eh.an[6]
ENDM

PROC m68_Open()
   GETBASE68K
   DEBUGF('LIB_open\n')
   lib.opencnt++
   lib.flags AND= Not(LIBF_DELEXP)
ENDPROC lib

PROC m68_Close()
   GETBASE68K
   DEBUGF('LIB_close\n')
   IF lib.opencnt-- = 0
      IF lib.flags AND LIBF_DELEXP
         RETURN sysv_Expunge(lib)
      ENDIF
   ENDIF
ENDPROC NIL

PROC sysv_Expunge(lib:PTR TO librarybase)
   DEF execbase, dosbase, seglist, node:PTR TO codenode, next

   seglist := lib.seglist
   execbase := lib.execbase
   dosbase := lib.dosbase

   -> check if there are any unused codenodes, remove and free them if so..
   ObtainSemaphore(lib.semaphore)
   node := lib.codelist.head
   WHILE next := node.succ
      IF node.count = 0
         UnLoadSeg(node.seglist)
         Remove(node)
         FreePooled(lib.mempool, node.name, node.namelen)
         FreePooled(lib.mempool, node, SIZEOF codenode)
      ENDIF
      node := next
   ENDWHILE
   ReleaseSemaphore(lib.semaphore)

   IF lib.opencnt > 0
      lib.flags OR= LIBF_DELEXP
      RETURN NIL
   ENDIF

   CloseLibrary(dosbase)
   DeletePool(lib.mempool)
   Remove(lib)
   FreeMem(lib - lib.negsize, lib.negsize + lib.possize)
ENDPROC seglist

PROC m68_Expunge()
   GETBASE68K
   DEBUGF('LIB_expunge lib=$\h\n', lib)
ENDPROC sysv_Expunge(lib)

PROC m68_Reserved()
ENDPROC NIL



GETBASESYSV MACRO
   DEF lib:PTR TO librarybase
   lib := R12
ENDM

PROC sysv_OpenCode(name)
   DEF execbase, dosbase, node=NIL:PTR TO codenode, seglist=NIL, seg:PTR TO seg
   GETBASESYSV

   DEBUGF('LIB_opencode base=$\h name="\s"\n', lib, name)

   execbase := lib.execbase
   dosbase := lib.dosbase
   DEBUGF('LIB_opencode execbase=$\hdosbase=$\h\n', execbase,dosbase)
   ObtainSemaphore(lib.semaphore)
   DEBUGF('LIB_opencode obtained semaphore\n')
   node := FindName(lib.codelist, name)
   IF node
      node.count++
      ReleaseSemaphore(lib.semaphore)
      DEBUGF('LIB_opencode found name, returning\n')
      RETURN node.code
   ELSE
      ReleaseSemaphore(lib.semaphore)
   ENDIF
   DEBUGF('LIB_opencode about to loadseg\n')
   seglist := LoadSeg(name)
   IF seglist = NIL THEN JUMP opencode_error
   node := AllocPooled(lib.mempool, SIZEOF codenode)
   IF node = NIL THEN JUMP opencode_error
   node.seglist := seglist
   node.namelen := StrLen(name) + 1
   node.name := AllocPooled(lib.mempool, node.namelen)
   IF node.name = NIL THEN JUMP opencode_error
   AstrCopy(node.name, name, node.namelen)
   seg := seglist << 2

   -> ppc code is in seg 1 (not 0)...
   seg := seg.bptrNext << 2
   node.code := seg + 4

   node.count := 1
   ObtainSemaphore(lib.semaphore)
   AddTail(lib.codelist, node)
   ReleaseSemaphore(lib.semaphore)

   DEBUGF('LIB_opencode DONE\n')

   RETURN node.code
opencode_error:

   DEBUGF('LIB_opencode ERROR seglist=$\h, node=$\h, seg=$\h\n', seglist,node,seg)

   IF seglist THEN UnLoadSeg(seglist)
   IF node
      IF node.name THEN FreePooled(lib.mempool, node.name, node.namelen)
      FreePooled(lib.mempool, node, SIZEOF codenode)
   ENDIF
ENDPROC NIL

PROC sysv_CloseCode(code)
   DEF node:PTR TO codenode, next, execbase
   GETBASESYSV

   DEBUGF('LIB_closecode\n')

   execbase := lib.execbase
   ObtainSemaphore(lib.semaphore)
   node := lib.codelist.head
   WHILE next := node.succ
      IF node.code = code
         node.count--
         JUMP closecode_end
      ENDIF
      node := next
   ENDWHILE
closecode_end:
   ReleaseSemaphore(lib.semaphore)
ENDPROC NIL



endskip:

