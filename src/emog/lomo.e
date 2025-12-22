/* -- ----------------------------------------------------------------- -- *
 * -- Program.....: lomo.e                                              -- *
 * -- Author......: Daniel Kasmeroglu                                   -- *
 * -- E-Mail......: raptor@cs.tu-berlin.de                              -- *
 * --               daniel.kasmeroglu@daimlerchrysler.com               -- *
 * -- Original....: Wouter van Oortmerssen                              -- *
 * -- Description.: Shows contents of an emodule                        -- *
 * -- ----------------------------------------------------------------- -- */

/* -- ----------------------------------------------------------------- -- *
 * --                              Options                              -- *
 * -- ----------------------------------------------------------------- -- */

OPT PREPROCESS       -> enable preprocessor
OPT MODULE           -> generate e-module


/* -- ----------------------------------------------------------------- -- *
 * --                              Modules                              -- *
 * -- ----------------------------------------------------------------- -- */

->> LIST OF MODULES
MODULE  'tools/file'        ,
	'amigalib/lists'    ,
	'dos/doshunks'      ,
	'exec/lists'        ,
	'exec/nodes'
-><


/* -- ----------------------------------------------------------------- -- *
 * --                         Public Constants                          -- *
 * -- ----------------------------------------------------------------- -- */

EXPORT  CONST   CPU_68000 = 0   ,
		CPU_68020 = 1   ,
		CPU_68030 = 1   ,
		CPU_68040 = 2   ,
		CPU_68060 = 2

EXPORT  CONST   FPU_NONE  = 0   ,
		FPU_68881 = 1   ,
		FPU_68882 = 1   ,
		FPU_68040 = 2   ,
		FPU_68060 = 2


/* -- ----------------------------------------------------------------- -- *
 * --                             Constants                             -- *
 * -- ----------------------------------------------------------------- -- */

->> Job values
ENUM JOB_DONE    ,  -> nothing more to do
     JOB_CONST   ,  -> let's handle constants
     JOB_OBJ     ,  -> the following describes an object
     JOB_CODE    ,  -> codesize is following
     JOB_PROCS   ,  -> procedure descriptions are following
     JOB_SYS     ,  -> some informations for needed system
     JOB_LIB     ,  -> this is a library include
     JOB_RELOC   ,  -> number of reloc entries is following
     JOB_GLOBS   ,  -> list of global vars is following
     JOB_MODINFO ,  -> what is imported
     JOB_DEBUG   ,  -> some debug information
     JOB_MACROS     -> some macros
-><

->> Error constants
ENUM ER_NONE        ,
     ER_FILE        ,
     ER_ARGS        ,
     ER_JOBID       ,
     ER_BREAK       ,
     ER_FILETYPE    ,
     ER_TOONEW      ,
     ER_MEM = "MEM"
-><

->> Various other constants
CONST MODVERS  = 10        ,   -> upto which version we understand
      SKIPMARK = $FFFF8000
-><

->> Structure specifying constants
EXPORT ENUM MI_MODULENAME ,
     MI_PROCEDURE  ,
     MI_STRUCTURE  ,
     MI_LABEL

EXPORT ENUM TP_LABEL      ,
     TP_PROC       ,
     TP_STUPIDARGS

EXPORT ENUM SI_STRUCTBEGIN ,
     SI_COMPONENT   ,
     SI_METHOD      ,
     SI_STRUCTEND   ,
     SI_PRIVATE

EXPORT ENUM TC_0 ,
     TC_1 ,
     TC_2 ,
     TC_3

-><



/* -- ----------------------------------------------------------------- -- *
 * --                            Structures                             -- *
 * -- ----------------------------------------------------------------- -- */

->> STRUCTURE sizeof
EXPORT OBJECT sizeof OF mln
  name : PTR TO CHAR
  size : INT
ENDOBJECT
-><

->> STRUCTURE libfunc
EXPORT OBJECT libfunc OF mln
  regs [ 16 ] : ARRAY OF CHAR   -> registers used
  name        : PTR TO CHAR     -> name of the function
  numargs     : PTR TO CHAR     -> number of used args
  offset      : INT             -> offset to library base
  length      : INT             -> length of name
ENDOBJECT
-><

->> STRUCTURE modinfo
EXPORT OBJECT modinfo OF mln
  type    : INT                 -> MI_MODULENAME, MI_PROCEDURE, MI_STRUCTURE, MI_LABEL
  name    : PTR TO CHAR         -> name of module, procedure etc.
  times   : INT                 -> how many times this ref is used
  numargs : INT                 -> number of args
ENDOBJECT
-><

->> STRUCTURE macro
EXPORT OBJECT macro OF mln
  name    : PTR TO CHAR         -> name of the macro
  numargs : INT                 -> number of args
ENDOBJECT
-><

->> STRUCTURE constant
EXPORT OBJECT constant OF mln
  name          : PTR TO CHAR       -> name of the constant
  value         : LONG              -> the value
  length        : INT               -> length of constant name
  isflag        : INT               -> true if it is a flag
  vallength     : INT               -> length of the value
  buffer        : PTR TO CHAR       -> buffer to keep the value
ENDOBJECT
-><

->> STRUCTURE proc
EXPORT OBJECT proc OF mln
  type    : INT                 -> TP_PROC, TP_LABEL, TP_STUPIDARGS
  name    : PTR TO CHAR         -> the name
  args    : PTR TO LONG         -> list of argnames
  defargs : PTR TO LONG         -> default args
  numargs : INT                 -> number of args
  numdefs : INT                 -> number of available default args
ENDOBJECT
-><

->> STRUCTURE structinfo
->
-> TC_0 >   Einfacher Typ   :    Bezeichner      Datentyp
-> TC_1 > * Einfacher Typ   :    Bezeichner      Datentyp
-> TC_2 > * Komplexer Typ   :    Bezeichner      Typbezeichner
-> TC_3 >   Reihung         :    Bezeichner      Datentyp/Typbezeichner    Länge
->
EXPORT OBJECT structinfo OF mln
  type     : INT             -> SI_STRUCTBEGIN/SI_COMPONENT/SI_METHOD/SI_STRUCTEND/SI_PRIVATE
  name     : PTR TO CHAR     -> basename/componentname/methodname/-/-
  tycon    : LONG            -> -/TC_0,TC_1,TC_2,TC_3/-/-/-
  value    : LONG            -> -/arraylen/-/sizeof/-
  tname    : LONG            -> -/0,1,2,4,typename/-/-/-
  offset   : INT             -> -/offset/-/-/-
  compsize : INT             -> -/componentsize/-/-/-
  isptr    : LONG            -> -/TRUE,FALSE/-/-/-
  typesize : INT             -> size of the type
ENDOBJECT
-><

->> STRUCTURE global
EXPORT OBJECT global OF mln
  name : PTR TO CHAR           -> name of global variable
ENDOBJECT
-><


->> STRUCTURE moduleinfo
EXPORT OBJECT moduleinfo
  osversion      : INT                  -> osversion
  cpu            : INT                  -> 1 = 020/030, 2 = 040/060
  fpu            : INT                  -> 1 = 881/882, 2 = 040/060
  modversion     : INT                  -> module version
  codesize       : LONG                 -> size of codearea
  relocs         : INT                  -> number of relocatable entries
  evarsize       : LONG                 -> size of evar debug information
  linesize       : LONG                 -> size of line debug information
  privates       : INT                  -> number of private global vars
  libbasename    : PTR TO CHAR          -> name of library base
  external       : mlh                  -> external structures, procs etc.
  libfuncs       : mlh                  -> module is of type library
  macros         : mlh                  -> list of macros
  globals        : mlh                  -> names of global vars
  constants      : mlh                  -> list of constants
  procs          : mlh                  -> list of procedures
  structinfos    : mlh                  -> list of structure information
ENDOBJECT
-><


/* -- ----------------------------------------------------------------- -- *
 * --                               Main                                -- *
 * -- ----------------------------------------------------------------- -- */

->> PROC loadModule
->
-> SPEC     loadModule(path) = ptr
-> DESC     Simply loads a complete module under path <path> and
->          returns a pointer <ptr> which allows to access every
->          information of it.
-> PRE      path <> NIL
-> POST     ptr  <> NIL <=> All went okay
->
EXPORT PROC loadModule( loa_modpath ) HANDLE
DEF loa_minfo : PTR TO moduleinfo
DEF loa_mem,loa_flen

  loa_minfo         := NewR( SIZEOF moduleinfo )
  loa_mem, loa_flen := readfile( loa_modpath )
  IF loa_mem = NIL THEN Raise( ER_FILE )

  job_Complete( loa_minfo, loa_mem, loa_flen )

  IF loa_mem <> NIL THEN freefile( loa_mem )

EXCEPT

  IF loa_mem <> NIL THEN freefile( loa_mem )
  RETURN NIL

ENDPROC loa_minfo
-><


/* -- ----------------------------------------------------------------- -- *
 * --                          Job Procedures                           -- *
 * -- ----------------------------------------------------------------- -- */

->> PROCEDURE job_Complete      [READY]
PROC job_Complete( com_moduleinfo : PTR TO moduleinfo, com_o : PTR TO INT, com_flen )
DEF com_end,com_job

  com_moduleinfo.osversion      := 0
  com_moduleinfo.cpu            := CPU_68000
  com_moduleinfo.fpu            := FPU_NONE
  com_moduleinfo.modversion     := 0
  com_moduleinfo.codesize       := 0
  com_moduleinfo.relocs         := 0
  com_moduleinfo.evarsize       := 0
  com_moduleinfo.linesize       := 0
  com_moduleinfo.privates       := 0
  com_moduleinfo.libbasename    := NIL

  newList( com_moduleinfo.external    )
  newList( com_moduleinfo.libfuncs    )
  newList( com_moduleinfo.macros      )
  newList( com_moduleinfo.globals     )
  newList( com_moduleinfo.constants   )
  newList( com_moduleinfo.procs       )
  newList( com_moduleinfo.structinfos )

  com_end := com_o + com_flen
  IF ^com_o++ <> "EMOD" THEN Raise( ER_FILETYPE )

  WHILE com_o < com_end

    com_job := com_o[]++

    SELECT com_job
->>   CASE JOB_CODE     [READY]
    CASE JOB_CODE
      com_moduleinfo.codesize := ^com_o++ * 4
      com_o                   := com_moduleinfo.codesize + com_o
-><
->>   CASE JOB_RELOC    [READY]
    CASE JOB_RELOC
      com_moduleinfo.relocs := ^com_o++
      com_o                 := com_moduleinfo.relocs * 4 + com_o
-><
->>   CASE JOB_LIB      [READY]
    CASE JOB_LIB     ; com_o := job_LIB( com_o, com_moduleinfo, com_end )
-><
->>   CASE JOB_SYS      [READY]
    CASE JOB_SYS     ; com_o := job_SYS( com_o, com_moduleinfo )
-><
->>   CASE JOB_PROCS    [READY]
    CASE JOB_PROCS   ; com_o := job_PROCS( com_o, com_moduleinfo )
-><
->>   CASE JOB_GLOBS    [READY]
    CASE JOB_GLOBS   ; com_o := job_GLOBS( com_o, com_moduleinfo )
-><
->>   CASE JOB_OBJ      [READY]
    CASE JOB_OBJ     ; com_o := job_OBJ( com_o, com_moduleinfo )
-><
->>   CASE JOB_CONST    [READY]
    CASE JOB_CONST   ; com_o := job_CONST( com_o, com_moduleinfo )
-><
->>   CASE JOB_MODINFO  [READY]
    CASE JOB_MODINFO ; com_o := job_MODINFO( com_o, com_moduleinfo )
-><
->>   CASE JOB_DEBUG    [READY]
    CASE JOB_DEBUG   ; com_o := job_DEBUG( com_o, com_moduleinfo )
-><
->>   CASE JOB_MACROS   [READY]
    CASE JOB_MACROS  ; com_o := job_MACROS( com_o, com_moduleinfo )
-><
->>   CASE JOB_DONE     [READY]
    CASE JOB_DONE    ; com_o := com_end
-><
->>   DEFAULT           [READY]
    DEFAULT          ; Raise( ER_JOBID )
-><
    ENDSELECT

  ENDWHILE

ENDPROC
-><

->> PROCEDURE job_LIB           [READY]
PROC job_LIB( lib_o, lib_moduleinfo : PTR TO moduleinfo, lib_end )
DEF lib_libfunc : PTR TO libfunc
DEF lib_offset,lib_reg,lib_len

  lib_offset := 30

  WHILE lib_o[]++ DO NOP

  lib_len                    := StrLen( lib_o ) + 1
  lib_moduleinfo.libbasename := NewR( lib_len )
  AstrCopy( lib_moduleinfo.libbasename, lib_o, lib_len )

  WHILE lib_o[]++ DO NOP

  WHILE (lib_o[] <> $FF) AND (lib_o < lib_end)

    IF lib_o[] = 16
      lib_o++
    ELSE

      lib_libfunc         := NewR( SIZEOF libfunc )
      lib_libfunc.offset  := lib_offset
      lib_len             := StrLen( lib_o ) + 1
      lib_libfunc.name    := NewR( lib_len )
      AstrCopy( lib_libfunc.name, lib_o, lib_len )

      lib_libfunc.numargs := 0

      WHILE lib_o[]++ > " " DO NOP
      lib_o--
      lib_reg   := lib_o[]
      lib_o[]++ := 0

      IF lib_reg <> 16
	WHILE lib_reg < 16
	  lib_libfunc.regs[ lib_libfunc.numargs ] := lib_reg
	  lib_libfunc.numargs                     := lib_libfunc.numargs + 1
	  lib_reg                                 := lib_o[]++
	ENDWHILE
	lib_o--
      ENDIF

      AddTail( lib_moduleinfo.libfuncs, lib_libfunc )

    ENDIF

    lib_offset := lib_offset + 6

  ENDWHILE

ENDPROC lib_end
-><

->> PROCEDURE job_SYS           [READY]
PROC job_SYS( sys_o : PTR TO  INT, sys_mi : PTR TO moduleinfo )

  sys_o             := sys_o + 4
  sys_mi.osversion  := sys_o[]++
  sys_o             := sys_o + 4
  sys_mi.cpu        := sys_o[]++
  sys_mi.fpu        := sys_o[]++
  sys_o             := sys_o + 2
  sys_mi.modversion := sys_o[]++
  sys_o             := sys_o + 4

  IF sys_mi.modversion > MODVERS THEN Raise( ER_TOONEW )

ENDPROC sys_o
-><

->> PROCEDURE job_PROCS         [READY]
PROC job_PROCS( pro_o : PTR TO INT, pro_mi : PTR TO moduleinfo )
DEF pro_proc : PTR TO proc
DEF pro_parlist,pro_len
DEF pro_nlen

  WHILE (pro_len := pro_o[]++) > 0

    pro_proc      := NewR( SIZEOF proc )
    pro_nlen      := StrLen( pro_o ) + 1
    pro_proc.name := NewR( pro_nlen )

    AstrCopy( pro_proc.name, pro_o, pro_len )

    pro_o         := pro_o + pro_len + 4

    IF pro_o[]++ = 1

      pro_proc.numargs := pro_o[]++
      pro_o++
      pro_proc.numdefs := pro_o[]++
      pro_proc.defargs := pro_o
      pro_o            := pro_proc.numdefs * 4 + pro_o
      pro_parlist      := pro_o[]++

      IF pro_parlist <> FALSE
	pro_proc.type  := TP_PROC
	intern_GetParameter( pro_proc, pro_o )
      ELSE
	pro_proc.type  := TP_STUPIDARGS
      ENDIF

      pro_o            := pro_o + pro_parlist

    ELSE
      pro_proc.type    := TP_LABEL
    ENDIF

    AddTail( pro_mi.procs, pro_proc )

  ENDWHILE

ENDPROC pro_o
-><

->> PROCEDURE job_GLOBS         [READY]
->
-> [ length (2)      ]
-> [ NAME   (length) ]
-> [ DATA   (4)      ] if thisvers > 10 : [ DATA (6) ]
->
PROC job_GLOBS( glo_o : PTR TO INT, glo_mi : PTR TO moduleinfo )
DEF glo_global : PTR TO global
DEF glo_len,glo_nlen

  IF glo_o[] = SKIPMARK THEN glo_o := glo_o + 6

  WHILE (glo_len := glo_o[]++) >= 0

    IF glo_len > 0
      glo_global      := NewR( SIZEOF global )
      glo_nlen        := StrLen( glo_o ) + 1
      glo_global.name := NewR( glo_nlen )
      AstrCopy( glo_global.name, glo_o, glo_nlen )
      AddTail( glo_mi.globals, glo_global )
      glo_o           := glo_o + glo_len
    ELSE
      glo_mi.privates := glo_mi.privates + 1
    ENDIF

    WHILE (glo_len := ^glo_o++) <> 0
      IF glo_mi.modversion >= 10 THEN glo_o++
    ENDWHILE

  ENDWHILE

ENDPROC glo_o
-><

->> PROCEDURE job_OBJ           [READY]
PROC job_OBJ( obj_o : PTR TO INT, obj_mi : PTR TO moduleinfo )
DEF obj_structinfo : PTR TO structinfo
DEF obj_len,obj_reg,obj_c
DEF obj_nlen

  IF obj_mi.modversion >= 6 THEN obj_o := obj_o + 4

  obj_reg := 0
  obj_len := obj_o[]++

  obj_structinfo        := NewR( SIZEOF structinfo )
  obj_structinfo.type   := SI_STRUCTBEGIN
  obj_nlen              := StrLen( obj_o + 4 ) + 1
  obj_structinfo.name   := NewR( obj_nlen )
  AstrCopy( obj_structinfo.name, obj_o + 4, obj_nlen )
  obj_structinfo.offset := -1
  AddTail( obj_mi.structinfos, obj_structinfo )

  obj_o := obj_o + 4 + obj_len
  WHILE (obj_len := obj_o[]++) <> 0

    obj_structinfo        := NewR( SIZEOF structinfo )
    obj_structinfo.type   := SI_COMPONENT
    obj_structinfo.value  := 0
    obj_structinfo.isptr  := FALSE
    obj_structinfo.tname  := obj_o[]++
    obj_structinfo.offset := obj_o[]++
    IF obj_len > 0

      obj_nlen             := StrLen( obj_o ) + 1
      obj_structinfo.name  := NewR( obj_nlen )
      AstrCopy( obj_structinfo.name, obj_o, obj_nlen )
      obj_o                := obj_o + obj_len
      obj_reg              := 0

      IF obj_mi.modversion >= 6

	obj_c := obj_o[]++
	IF obj_c < 0
	  IF obj_structinfo.tname <> 0
	    obj_structinfo.isptr := TRUE
	  ELSE
	    obj_structinfo.value := -1
	  ENDIF
	  obj_len                := obj_o[]++
	  obj_structinfo.tname   := obj_o
	  obj_o                  := obj_o + obj_len
	ELSEIF obj_c > 0
	  IF obj_structinfo.tname <> 0
	    obj_structinfo.isptr := TRUE
	  ELSE
	    obj_structinfo.value := Int( obj_o + IF obj_o[] <> 0 THEN 4 ELSE 2 ) - obj_structinfo.offset / obj_c
	  ENDIF
	  obj_structinfo.tname   := obj_c
	ENDIF

      ENDIF

      IF obj_structinfo.isptr <> FALSE
	IF obj_structinfo.tname > 4
	  obj_structinfo.tycon := TC_2
	ELSE
	  obj_structinfo.tycon := TC_1
	ENDIF
      ELSE
	IF obj_structinfo.value <> 0
	  obj_structinfo.tycon := TC_3
	ELSE
	  obj_structinfo.tycon := TC_0
	ENDIF
      ENDIF

    ELSE
      IF obj_reg++ = 0
	obj_structinfo.type   := SI_PRIVATE
	obj_structinfo.offset := -1
      ENDIF
    ENDIF

    AddTail( obj_mi.structinfos, obj_structinfo )

  ENDWHILE

  obj_reg := obj_o[]++
  IF obj_mi.modversion >= 7

    IF obj_o[]++

      obj_o   := obj_o + 4
      obj_len := obj_o[]++
      obj_o   := obj_o + obj_len + 4

      WHILE (obj_c := obj_o[]++) <> -1

	obj_structinfo        := NewR( SIZEOF structinfo )
	obj_structinfo.type   := SI_METHOD
	obj_o++
	obj_len               := obj_o[]++
	obj_nlen              := StrLen( obj_o ) + 1
	obj_structinfo.name   := NewR( obj_nlen )
	AstrCopy( obj_structinfo.name, obj_o, obj_nlen )

	obj_o                 := obj_o + obj_len
	obj_len               := obj_o[]++
	obj_structinfo.value  := obj_len
	obj_len               := obj_o[]++
	obj_o                 := obj_len * 4 + obj_o
	obj_structinfo.offset := -2

	AddTail( obj_mi.structinfos, obj_structinfo )

      ENDWHILE

      WHILE obj_o[]++ <> -1 DO obj_o := obj_o + 4

    ENDIF

  ENDIF

  obj_structinfo        := NewR( SIZEOF structinfo )
  obj_structinfo.type   := SI_STRUCTEND
  obj_structinfo.value  := obj_reg
  obj_structinfo.offset := -1

  AddTail( obj_mi.structinfos, obj_structinfo )

ENDPROC obj_o
-><

->> PROCEDURE job_CONST         [READY]
->
->  [ ?          (4)      ]    _______
->  [ length     (2)      ]      /|\
->  [ LONGVAL    (4)      ]       |
->  [ NAME       (length) ]       |
->  [ length     (2)      ]       |
->
PROC job_CONST( con_o : PTR TO INT, con_mi : PTR TO moduleinfo )
DEF con_constant : PTR TO constant
DEF con_len,con_nlen

  IF con_mi.modversion >= 6 THEN con_o := con_o + 4

  con_len := con_o[]++
  WHILE con_len > 0

    con_constant        := NewR( SIZEOF constant )
    con_constant.buffer := String( 10 )
    IF con_constant.buffer = NIL THEN Raise( ER_MEM )

    con_constant.value  := ^con_o++

    con_nlen            := StrLen( con_o ) + 1
    con_constant.name   := NewR( con_nlen )
    AstrCopy( con_constant.name, con_o, con_len )

    con_constant.isflag := intern_IsFlag( con_constant.value )

    AddTail( con_mi.constants, con_constant )

    con_o               := con_o + con_len
    con_len             := con_o[]++

  ENDWHILE

ENDPROC con_o
-><

->> PROCEDURE job_MODINFO       [READY]
->
-> [ ?            (4)      ]
-> [ length       (2)      ]
-> [ MODULEPATH   (length) ]
-> [ c            (2)      ]
-> [ length       (2)      ]
-> [ NAME         (length) ]
->
->   c = 2
->
->     [ numargs      (2)         ]
->     [ times        (2)         ]
->     [ DATA         (times * 4) ]
->
->   c <> 2
->
->     [ times         (2)         ]
->     [ DATA          (times * 6) ]
->
PROC job_MODINFO( mod_o : PTR TO INT, mod_mi : PTR TO moduleinfo )
DEF mod_modinfo : PTR TO modinfo
DEF mod_len,mod_c,mod_nlen

  mod_o := mod_o + 4

  WHILE (mod_len := mod_o[]++) > 0

    mod_modinfo      := NewR( SIZEOF modinfo )
    mod_modinfo.type := MI_MODULENAME

    mod_nlen         := StrLen( mod_o ) + 1
    mod_modinfo.name := NewR( mod_nlen )
    AstrCopy( mod_modinfo.name, mod_o, mod_nlen )

    AddTail( mod_mi.external, mod_modinfo )
    mod_o            := mod_o + mod_len

    WHILE (mod_c := mod_o[]++) <> 0

      mod_len          := mod_o[]++
      mod_modinfo      := NewR( SIZEOF modinfo )
      mod_nlen         := StrLen( mod_o ) + 1
      mod_modinfo.name := NewR( mod_nlen )
      AstrCopy( mod_modinfo.name, mod_o, mod_nlen )

      mod_o            := mod_o + mod_len

      IF mod_c = 2

	IF mod_o[] <> -1
	  mod_modinfo.type    := MI_PROCEDURE
	  mod_modinfo.numargs := mod_o[]
	ELSE
	  mod_modinfo.type    := MI_LABEL
	ENDIF

	mod_o++
	mod_c            := 4

      ELSE
	mod_modinfo.type := MI_STRUCTURE
	mod_c            := 6
      ENDIF

      mod_modinfo.times := mod_o[]++
      mod_o             := mod_modinfo.times * mod_c + mod_o

      AddTail( mod_mi.external, mod_modinfo )

    ENDWHILE

  ENDWHILE

ENDPROC mod_o
-><

->> PROCEDURE job_DEBUG         [READY]
->
-> [ VALUE: HUNK_DEBUG  (4)              ]
-> [ length             (4)              ]
-> [ ?                  (4)              ]
-> [ dataidentifier     (4)              ]
-> [ data               (length * 4 - 8) ]
->
PROC job_DEBUG( deb_o : PTR TO INT, deb_mi : PTR TO moduleinfo )
DEF deb_len,deb_c

  WHILE ^deb_o++ = HUNK_DEBUG

    deb_len := ^deb_o++ * 4
    deb_o   := deb_o + 4
    deb_c   := ^deb_o++
    deb_o   := deb_len + deb_o - 8

    IF deb_c = "EVAR"
      deb_mi.evarsize := deb_len
    ELSE
      deb_mi.linesize := deb_len
    ENDIF

  ENDWHILE

ENDPROC deb_o
-><

->> PROCEDURE job_MACROS        [READY]
->
-> [ length    (2)        ]
-> [ MACRONAME (length)   ]
-> [ NUMARGS   (2)        ]
-> [ ?         (2)        ]
-> [ macrolen  (2)        ]
-> [ MACRODATA (macrolen) ]
->
PROC job_MACROS( mac_o : PTR TO INT, mac_mi : PTR TO moduleinfo )
DEF mac_macro : PTR TO macro
DEF mac_len,mac_nlen

  WHILE (mac_len := mac_o[]++) > 0

    mac_macro         := NewR( SIZEOF macro )
    mac_nlen          := StrLen( mac_o ) + 1
    mac_macro.name    := NewR( mac_nlen )
    AstrCopy( mac_macro.name, mac_o, mac_nlen )

    mac_o             := mac_o + mac_len
    mac_macro.numargs := mac_o[]++
    mac_o++
    mac_o             := mac_o[]++ + mac_o

    AddTail( mac_mi.macros, mac_macro )

  ENDWHILE

ENDPROC mac_o
-><


/* -- ----------------------------------------------------------------- -- *
 * --                             Procedures                            -- *
 * -- ----------------------------------------------------------------- -- */

->> PROCEDURE intern_GetParameter
PROC intern_GetParameter( get_proc : PTR TO proc, get_args ) HANDLE
DEF get_run,get_index

  get_proc.args := NewR( get_proc.numargs * 4 )
  FOR get_run := 0 TO get_proc.numargs - 1

    get_index := InStr( get_args, ',', 0 )
    IF get_index = -1 THEN get_index := StrLen( get_args )

    get_proc.args[ get_run ] := String( get_index + 1 )
    IF get_proc.args[ get_run ] = NIL THEN Raise( ER_MEM )

    StrCopy( get_proc.args[ get_run ], get_args, get_index )
    get_args := get_args + get_index + 1

  ENDFOR

EXCEPT
  Raise( ER_MEM )
ENDPROC
-><

->> PROCEDURE intern_IsFlag
PROC intern_IsFlag( isf_value )
DEF isf_run,isf_val,isf_set

  isf_set := 0
  isf_val := 1
  FOR isf_run := 1 TO 32
    IF (isf_value AND isf_val) <> 0
      IF isf_set <> 0 THEN RETURN 0
      isf_set := isf_run
    ENDIF
    isf_val := Shl( isf_val, 1 )
  ENDFOR

ENDPROC isf_set
-><



