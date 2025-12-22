/* -- ----------------------------------------------------- -- *
 * -- Name........: egen.e                                  -- *
 * -- Description.: Here we got the source generator which  -- *
 * --               runs through the syntax tree and        -- *
 * --               produces the E source according to it.  -- *
 * -- Author......: Daniel Kasmeroglu                       -- *
 * -- E-Mail......: raptor@cs.tu-berlin.de                  -- *
 * --               daniel.kasmeroglu@daimlerchrysler.com   -- *
 * -- Date........: 05-Mar-00                               -- *
 * -- Version.....: 0.1                                     -- *
 * -- ----------------------------------------------------- -- */


/* -- ----------------------------------------------------- -- *
 * --                         Options                       -- *
 * -- ----------------------------------------------------- -- */

OPT MODULE


/* -- ----------------------------------------------------- -- *
 * --                         Modules                       -- *
 * -- ----------------------------------------------------- -- */

MODULE  'exec/lists'    ,
	'*tools'        ,
	'*absy'


/* -- ----------------------------------------------------- -- *
 * --                        Constants                      -- *
 * -- ----------------------------------------------------- -- */

CONST   ALIGN_CONSTANT  = 30 ,
	ALIGN_COMPONENT = 20 ,
	ALIGN_COMPTYPE  = 20


/* -- ----------------------------------------------------- -- *
 * --                        Functions                      -- *
 * -- ----------------------------------------------------- -- */

->> PROC generateE()
->
-> SPEC     generateE( absy, sourcename, desthandle )
-> DESC     Generates the E sourcecode corresponding to the C source
-> ARGS     {absy}        :   Tree containing the parsed structure of the C source
->          {sourcename}  :   Name of the C-Header
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {absy} <> NIL, {sourcename} <> NIL, {desthandle} <> NIL
-> POST     true
->
EXPORT PROC generateE( gen_absy : PTR TO includefile, gen_source, gen_output )

  PrintF( 'Generating...\n' )

  displayGauge()

  storeHeader( FilePart( gen_source ), gen_output )
  writeSource( gen_absy, gen_output )

ENDPROC
-><


/* -- --------------------------------------------------------------- -- *
 * --                         Private Functions                       -- *
 * -- --------------------------------------------------------------- -- */

->> PROC storeHeader()
->
-> SPEC     storeHeader( filename, desthandle )
-> DESC     Stores a simple header at the top of the sourcefile
-> ARGS     {filename}    :   Name of the C-Header (only filepart)
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {filename} <> NIL, desthandle <> NIL
-> POST     true
->
PROC storeHeader( sto_filename, sto_output )
DEF sto_buffer [46] : STRING
DEF sto_len

  displayGauge()

  FOR sto_len := 0 TO 44 DO sto_buffer [ sto_len ] := " "

  sto_len                := 45 - StrLen( sto_filename )
  sto_buffer [ sto_len ] := 0

  VfPrintf( sto_output , '\s'                , [ { lab_header_top } ] )
  VfPrintf( sto_output , ' * -- \s\s -- *\n' , [ sto_filename       , sto_buffer ] )
  VfPrintf( sto_output , '\s'                , [ { lab_header_end } ] )

ENDPROC
-><

->> PROC writeSource()
->
-> SPEC     writeSource( includefile, desthandle )
-> DESC     This is the function which does the main stuff.
-> ARGS     {includefile} :   A tree containing the parsed structure of the C source
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {includefile} <> NIL, {desthandle} <> NIL
-> POST     true
->
PROC writeSource( wri_absy : PTR TO absy, wri_destfile )
DEF wri_variant

  /*
   * This function generates the source according to
   * the current absy-variant. As you can see there
   * are various markers for the variants with the
   * following meaning:
   *
   *    UNREACHED    - Temporarily used ABSY-variant which doesn't occur
   *                   directly or is included in another variant.
   *    NYI          - Not implemented ABSY-variant.
   *
   */

  displayGauge()

  wri_variant := wri_absy.variant
  SELECT wri_variant
->> CASE VARIANT_INCLUDEFILE
  CASE VARIANT_INCLUDEFILE  ; writeIncludeFile( wri_absy, wri_destfile )
-><
->> CASE VARIANT_STRUCT
  CASE VARIANT_STRUCT       ; writeStruct( wri_absy, wri_destfile )
-><
->> CASE VARIANT_POINTING           [   UNREACHED   ]
  CASE VARIANT_POINTING     ;
-><
->> CASE VARIANT_TYPE               [   UNREACHED   ]
  CASE VARIANT_TYPE         ;
-><
->> CASE VARIANT_ARGUMENT           [   UNREACHED   ]
  CASE VARIANT_ARGUMENT     ;
-><
->> CASE VARIANT_ARGS               [   UNREACHED   ]
  CASE VARIANT_ARGS         ;
-><
->> CASE VARIANT_FUNCTION           [   NYI         ]
  CASE VARIANT_FUNCTION     ;
-><
->> CASE VARIANT_EXPRESSION         [   NYI         ]
  CASE VARIANT_EXPRESSION   ;
-><
->> CASE VARIANT_CONSTANT
  CASE VARIANT_CONSTANT     ; writeConstant( wri_absy, wri_destfile )
-><
->> CASE VARIANT_INCFILE
  CASE VARIANT_INCFILE      ; writeIncFile( wri_absy, wri_destfile )
-><
->> CASE VARIANT_CONDITIONAL
  CASE VARIANT_CONDITIONAL  ; writeConditional( wri_absy, wri_destfile )
-><
->> CASE VARIANT_IDELIST            [   UNREACHED   ]
  CASE VARIANT_IDELIST      ;
-><
->> CASE VARIANT_COMPONENT          [   UNREACHED   ]
  CASE VARIANT_COMPONENT    ;
-><
->> CASE VARIANT_COMPS              [   UNREACHED   ]
  CASE VARIANT_COMPS        ;
-><
->> CASE VARIANT_VARIABLE           [   NYI         ]
  CASE VARIANT_VARIABLE     ;
-><
->> CASE VARIANT_IDEARRAYED         [   UNREACHED   ]
  CASE VARIANT_IDEARRAYED   ;
-><
->> CASE VARIANT_COMPRIGHT          [   UNREACHED   ]
  CASE VARIANT_COMPRIGHT    ;
-><
->> CASE VARIANT_CAST               [   NYI         ]
  CASE VARIANT_CAST         ;
-><
->> CASE VARIANT_FAULTY             [   UNUSED      ]
  CASE VARIANT_FAULTY       ;
-><
  ENDSELECT

ENDPROC
-><

->> PROC writeIncludeFile()
->
-> SPEC     writeIncludeFile( includefile, desthandle )
-> DESC     This function traverses through each item of an Include-File-Block.
-> ARGS     {includefile} :   A tree containing the parsed structure of the C source
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {includefile} <> NIL, {desthandle} <> NIL
-> POST     true
->
PROC writeIncludeFile( wri_includefile : PTR TO includefile, wri_destfile )
DEF wri_absy : PTR TO absy

  displayGauge()

  -> Simple traversion of a double linked list.
  wri_absy := wri_includefile.entries.head
  WHILE wri_absy.succ <> NIL
    writeSource( wri_absy, wri_destfile )
    wri_absy := wri_absy.succ
  ENDWHILE

ENDPROC
-><

->> PROC writeStruct()
->
-> SPEC     writeStruct( struct, desthandle )
-> DESC     Converts a struct-definition to an OBJECT-definition.
-> ARGS     {struct}      :   Basic infos about the structure including a list of the components.
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {struct} <> NIL, {desthandle} <> NIL
-> POST     true
->
PROC writeStruct( wri_struct : PTR TO struct, wri_destfile )
DEF wri_comps : PTR TO comps
DEF wri_comp  : PTR TO component

  displayGauge()

  -> NOTE: The identifier must be modified to make sure that
  ->       it will be accepted by the E-Compiler.
  VfPrintf( wri_destfile , '\nOBJECT \s\n' , [ modifyIdentifier( wri_struct.name ) ] )

  -> Write the source for each component
  wri_comps := wri_struct.components
  wri_comp  := wri_comps.components.head
  WHILE wri_comp.succ <> NIL
    writeComponent( wri_comp, wri_destfile )
    wri_comp := wri_comp.succ
  ENDWHILE

  -> Here's the end of the structure
  VfPrintf( wri_destfile , 'ENDOBJECT\n\n' , NIL )

ENDPROC
-><

->> PROC writeComponent()
->
-> SPEC     writeComponent( component, desthandle )
-> DESC     Writes the source for a structure component assuming we are writing
->          the definition of a complete structure.
-> ARGS     {component}   :   Description of the component
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {includefile} <> NIL, {desthandle} <> NIL
-> POST     true
->
PROC writeComponent( wri_comp : PTR TO component, wri_destfile )
DEF wri_typestring    [128] : STRING
DEF wri_buffer1       [128] : STRING
DEF wri_buffer2       [128] : STRING
DEF wri_comment       [128] : STRING
DEF wri_type                : PTR TO type
DEF wri_compright           : PTR TO compright
DEF wri_pointing            : PTR TO pointing
DEF wri_idearrayed          : PTR TO idearrayed
DEF wri_identifier, wri_times, wri_tptr

  displayGauge()

  wri_tptr := FALSE                 -> pointer declared indirectly
  wri_type := wri_comp.type


  -> Check out the corresponding type for the C-type.
  -> This passage is a bit critical since some names
  -> of the types are implicating a pointer declaration.
  -> For better type-mapping it is needed to recognize
  -> "typedef" and scan included modules. Also the list
  -> must be processed in two stages, where the first
  -> is used to collect all necessary informations for
  -> type-mapping and the second for generating the code.

  StringF( wri_typestring, '\s', wri_type.name )
  LowerStr( wri_typestring )

  IF     StrCmp( wri_typestring , 'ulong'  )
    StringF( wri_typestring , 'LONG' )
  ELSEIF StrCmp( wri_typestring , 'long'   )
    StringF( wri_typestring , 'LONG' )
  ELSEIF StrCmp( wri_typestring , 'uint'   )
    StringF( wri_typestring , 'INT'  )
  ELSEIF StrCmp( wri_typestring , 'int'    )
    StringF( wri_typestring , 'INT'  )
  ELSEIF StrCmp( wri_typestring , 'uword'  )
    StringF( wri_typestring , 'INT'  )
  ELSEIF StrCmp( wri_typestring , 'word'   )
    StringF( wri_typestring , 'INT'  )
  ELSEIF StrCmp( wri_typestring , 'uchar'  )
    StringF( wri_typestring , 'CHAR' )
  ELSEIF StrCmp( wri_typestring , 'char'   )
    StringF( wri_typestring , 'CHAR' )
  ELSEIF StrCmp( wri_typestring , 'ubyte'  )
    StringF( wri_typestring , 'CHAR' )
  ELSEIF StrCmp( wri_typestring , 'byte'   )
    StringF( wri_typestring , 'CHAR' )
  ELSEIF StrCmp( wri_typestring , 'aptr'   )
    StringF( wri_typestring , 'LONG' )
    wri_tptr := TRUE
  ELSEIF StrCmp( wri_typestring , 'void'   )
    StringF( wri_typestring , 'LONG' )
  ELSEIF StrCmp( wri_typestring , 'strptr' )
    StringF( wri_typestring , 'CHAR' )
    wri_tptr := TRUE
  ENDIF


  -> Yeah, yeah, yeah, Arnold would say (Happy days !).
  -> In a C structure you can write a type name
  -> at the left side and a list of component names
  -> at the other side. Each occuring component name
  -> may be modified with one or more wildcards
  -> denoting a pointer or it may be appended by
  -> bracketpair denoting an array or it may be
  -> a combination of both. Here we are traversing
  -> through each component of the list.
  -> A programmer who wants to keep his code in a
  -> beauty way would use one line for one component !
  wri_compright := wri_comp.idelist.comprights.head
  WHILE wri_compright.succ <> NIL

    wri_idearrayed  := wri_compright.idearrayed
    wri_pointing    := wri_compright.pointing
    wri_identifier  := modifyIdentifier( wri_idearrayed.identifier )
    wri_times       := wri_idearrayed.times

    StringF( wri_comment , ''     )
    StringF( wri_buffer1 , '  \s' , wri_identifier )

    IF wri_tptr <> FALSE

      -> strptr     x
      -> strptr    *x
      -> aptr       x
      -> aptr      *x

      IF wri_pointing <> NIL
	StringF( wri_comment, '-> pointer to \aPTR TO \s\a', wri_typestring )
	StringF( wri_buffer2, 'PTR TO LONG' )
      ELSE
	StringF( wri_buffer2, 'PTR TO \s', wri_typestring )
      ENDIF

    ELSEIF wri_pointing <> FALSE

      -> type *x[y]
      -> type *x

      IF wri_times = 0
	StringF( wri_buffer2, 'PTR TO \s', wri_typestring )
      ELSE
	StringF( wri_comment, '-> pointer to \aPTR TO \s\a', wri_typestring )
	StringF( wri_buffer2, 'PTR TO LONG' )
      ENDIF

    ELSE

      -> type x[y]
      -> type x

      IF wri_times = 0
	StringF( wri_buffer2 , '\s'          , wri_typestring )
      ELSE
	StringF( wri_buffer1 , '  \s [\d]'   , wri_identifier , wri_times )
	StringF( wri_buffer2 , 'ARRAY OF \s' , wri_typestring )
      ENDIF

    ENDIF

    -> Now we are writing the code. Note, that the code is aligned,
    -> so the generated code should be readable.
    alignWrite( wri_buffer1, ALIGN_COMPONENT, wri_destfile )
    VfPrintf( wri_destfile, ': ', NIL )
    alignWrite( wri_buffer2, ALIGN_COMPTYPE, wri_destfile )
    VfPrintf( wri_destfile, '\s\n', wri_comment )

    wri_compright   := wri_compright.succ

  ENDWHILE

ENDPROC
-><

->> PROC writeConditional()
->
-> SPEC     writeConditional( cond, desthandle )
-> DESC     This writes a conditional block of C-source.
-> ARGS     {cond}        :   Description of the conditional block.
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {cond} <> NIL, {desthandle} <> NIL
-> POST     true
->
PROC writeConditional( wri_cond : PTR TO conditional, wri_destfile )

  -> This one isn't really done. We are always assuming that the
  -> conditional code should be generated. In most cases this is
  -> a good choice since C sources are often starting with something
  -> like this:
  ->
  ->    #ifndef _MYHEADER_H_
  ->    #define _MYHEADER_H_
  ->     .
  ->     .
  ->     .
  ->    #endif
  ->
  -> One way to make this function working properly is popping up
  -> a simple requester, asking the user if we should assume the
  -> macro "_MYHEADER_H_" as set or not. Another way would be the
  -> one to one implementation of the C source. I would prefer the
  -> primary way since the secondary would reduce the readability
  -> of E sources and I don't like it to have preprocessor
  -> instructions in the E code.

  displayGauge()
  writeSource( wri_cond.include, wri_destfile )

ENDPROC
-><

->> PROC writeIncFile()
->
-> SPEC     writeIncFile( incfile, desthandle )
-> DESC     Simple structure which describes an included file.
-> ARGS     {incfile}     :   Valid structure containing the included file.
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {incfile} <> NIL, {desthandle} <> NIL
-> POST     true
->
PROC writeIncFile( wri_incfile : PTR TO incfile, wri_destfile )
DEF wri_current, wri_len, wri_path

  displayGauge()

  -> Kill the ".h" appendix of each include file.
  -> Theoritically it should be possible to write
  -> something like this in the C-code:
  ->
  ->  #include "mylib"
  ->
  -> This case would be problematic but I never
  -> haven't seen this so I assume the appendix
  -> ".h" is present.
  ->
  wri_path                  := wri_incfile.path
  wri_len                   := StrLen( wri_path )
  wri_path [ wri_len - 2 ]  := 0

  -> #include "x.h"         ->> MODULE '*x'
  -> #include <x.h>         ->> MODULE 'x'
  wri_current               := IF wri_incfile.current THEN '*' ELSE ''

  -> A way to beautify the code would be a global
  -> which marks if a MODULE declaration was done.
  -> This would allow to build a list of modules
  -> without using the keyword MODULE everytime.
  VfPrintf( wri_destfile, 'MODULE \a\s\s\a\n', [ wri_current, wri_path ] )

ENDPROC
-><

->> PROC writeConstant()
->
-> SPEC     writeConstant( constant, desthandle )
-> DESC     Simple structure which describes an included file.
-> ARGS     {constant}    :   Constant description
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {constant} <> NIL, {desthandle} <> NIL
-> POST     true
->
PROC writeConstant( wri_const : PTR TO constant, wri_destfile )
DEF wri_buffer [128] : STRING
DEF wri_ident

  displayGauge()

  -> Here we are generating a valid name for the constant.
  -> The first two letters must be uppercase but if an
  -> underscore is present I'm making each letter until
  -> the underscore uppercase. This looks better when
  -> some constants are having a prefix like TAG_XXX for
  -> example. The buffer of the constant will be modified
  -> directly because I know that I don't need it afterwards.
  wri_ident := modifyConstant( wri_const.id )
  IF containsDefine( wri_const.expr )

    -> Damn, the expression contains a shift "<<" or ">>" .
    -> These functions cannot be evaluated during compilation
    -> which forces us to use a macro instead. This macro
    -> calls the runtime function "Shl" or "Shr" .
    -> A simple workaround would be the replacement of
    -> "<<" with a multiplication or ">>" with a division.
    -> An occuring problem would be the fact that not all
    -> definitions of this kind are having a direct value.
    -> Evaluating C code like "#define MYCONST  D_CONST<<E_CONST"
    -> would require to know the value of E_CONST .
    -> Another thing is the fact that multiplication or
    -> division with big values isn't looking good and
    -> it might be unclear for the reader what's the meaning
    -> is. The current implementation work because it
    -> uses the C like declaration but it's not optimal.

    StringF( wri_buffer, '#define \s', wri_ident )
    alignWrite( wri_buffer, ALIGN_CONSTANT, wri_destfile )
    VfPrintf( wri_destfile, ' ', NIL )
    writeDefine( wri_const.expr, wri_destfile )

  ELSE

    -> Yeah, we can build up an expression in E comparable
    -> to the one in C
    StringF( wri_buffer, 'CONST \s', wri_ident )
    alignWrite( wri_buffer, ALIGN_CONSTANT, wri_destfile )
    VfPrintf( wri_destfile, ' = ', NIL )
    writeConst( wri_const.expr, wri_destfile )

  ENDIF

  VfPrintf( wri_destfile, '\n', NIL )

ENDPROC
-><

->> PROC writeDefine()
->
-> SPEC     writeDefine( expr, desthandle )
-> DESC     Writes the source a simple expression
-> ARGS     {expr}        :   Expression definition
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {expr} <> NIL, {desthandle} <> NIL
-> POST     true
->
PROC writeDefine( wri_expr : PTR TO expression, wri_destfile )
DEF wri_extyp

  displayGauge()

  wri_extyp := wri_expr.extyp
  SELECT wri_extyp
->> CASE EXTYP_ID
  CASE EXTYP_ID
    VfPrintf( wri_destfile, '\s', [ wri_expr.id ] )
-><
->> CASE EXTYP_SIGNED
  CASE EXTYP_SIGNED
    VfPrintf( wri_destfile, '-', NIL )
    writeDefine( wri_expr.left, wri_destfile )
-><
->> CASE EXTYP_STRING
  CASE EXTYP_STRING
    VfPrintf( wri_destfile, '\a\s\a', [ toe( wri_expr.id ) ] )
-><
->> CASE EXTYP_HEXVALUE
  CASE EXTYP_HEXVALUE
    VfPrintf( wri_destfile, '$\h', [ wri_expr.value ] )
-><
->> CASE EXTYP_DECVALUE
  CASE EXTYP_DECVALUE
    VfPrintf( wri_destfile, '\d', [ wri_expr.value ] )
-><
->> CASE EXTYP_NEGOTIATE
  CASE EXTYP_NEGOTIATE
    VfPrintf( wri_destfile, 'Not( ', NIL )
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ')', NIL )
-><
->> CASE EXTYP_SHIFTLEFT
  CASE EXTYP_SHIFTLEFT
    VfPrintf( wri_destfile, 'Shl( ', NIL )
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ', ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
    VfPrintf( wri_destfile, ' )', NIL )
-><
->> CASE EXTYP_SHIFTRIGHT
  CASE EXTYP_SHIFTRIGHT
    VfPrintf( wri_destfile, 'Shr( ', NIL )
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ', ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
    VfPrintf( wri_destfile, ' )', NIL )
-><
->> CASE EXTYP_PLUS
  CASE EXTYP_PLUS
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' + ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_MINUS
  CASE EXTYP_MINUS
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' - ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_BITAND
  CASE EXTYP_BITAND
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' AND ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_BITOR
  CASE EXTYP_BITOR
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' OR ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_MUL
  CASE EXTYP_MUL
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' * ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_DIV
  CASE EXTYP_DIV
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' / ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
  ENDSELECT

ENDPROC
-><

->> PROC writeConst()
->
-> SPEC     writeDefine( expr, desthandle )
-> DESC     Writes the source a simple expression
->          The difference to "writeDefine" is the fact that
->          shifting won't occur.
-> ARGS     {expr}        :   Expression definition
->          {desthandle}  :   BCPL pointer where the source will be written to
-> PRE      {expr} <> NIL, {desthandle} <> NIL
-> POST     true
->
PROC writeConst( wri_expr : PTR TO expression, wri_destfile )
DEF wri_extyp

  displayGauge()

  wri_extyp := wri_expr.extyp
  SELECT wri_extyp
->> CASE EXTYP_ID
  CASE EXTYP_ID
    VfPrintf( wri_destfile, '\s', [ wri_expr.id ] )
-><
->> CASE EXTYP_SIGNED
  CASE EXTYP_SIGNED
    VfPrintf( wri_destfile, '-', NIL )
    writeDefine( wri_expr.left, wri_destfile )
-><
->> CASE EXTYP_HEXVALUE
  CASE EXTYP_HEXVALUE
    VfPrintf( wri_destfile, '$\h', [ wri_expr.value ] )
-><
->> CASE EXTYP_DECVALUE
  CASE EXTYP_DECVALUE
    VfPrintf( wri_destfile, '\d', [ wri_expr.value ] )
-><
->> CASE EXTYP_PLUS
  CASE EXTYP_PLUS
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' + ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_MINUS
  CASE EXTYP_MINUS
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' - ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_BITAND
  CASE EXTYP_BITAND
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' AND ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_BITOR
  CASE EXTYP_BITOR
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' OR ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_MUL
  CASE EXTYP_MUL
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' * ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
->> CASE EXTYP_DIV
  CASE EXTYP_DIV
    writeDefine( wri_expr.left, wri_destfile )
    VfPrintf( wri_destfile, ' / ', NIL )
    writeDefine( wri_expr.right, wri_destfile )
-><
  ENDSELECT

ENDPROC
-><


/* -- --------------------------------------------------------------- -- *
 * --                       Supporting functions                      -- *
 * -- --------------------------------------------------------------- -- */

->> PROC modifyIdentifier()
->
-> SPEC     modifyIdentifier( buffer )
-> DESC     Makes the first to characters or the string up
->          to the underscore to lowercase characters.
-> ARGS     {buffer}      :   Valid changable buffer
-> PRE      {buffer} <> NIL
-> POST     LowerStr( {buffer} ) == LowerStr( modifyIdentifier( {buffer} ) )
->
PROC modifyIdentifier( mod_ident )
DEF mod_until,mod_index

  displayGauge()

  mod_until := InStr( mod_ident, '_', 0 )
  IF mod_until = -1 THEN mod_until := 2
  mod_until := mod_until - 1

  FOR mod_index := 0 TO mod_until

    IF (mod_ident[ mod_index ] >= "A") AND (mod_ident[ mod_index ] <= "Z")
      mod_ident[ mod_index ] := mod_ident[ mod_index ] + " "
    ENDIF

  ENDFOR

ENDPROC mod_ident
-><

->> PROC modifyConstant()
->
-> SPEC     modifyConstant( buffer )
-> DESC     Makes the first to characters or the string up
->          to the underscore to uppercase characters.
-> ARGS     {buffer}      :   Valid changable buffer
-> PRE      {buffer} <> NIL
-> POST     LowerStr( {buffer} ) == LowerStr( modifyConstant( {buffer} ) )
->
PROC modifyConstant( mod_ident )
DEF mod_until,mod_index

  displayGauge()

  mod_until := InStr( mod_ident, '_', 0 )
  IF mod_until = -1 THEN mod_until := 2
  mod_until := mod_until - 1

  FOR mod_index := 0 TO mod_until

    IF (mod_ident[ mod_index ] >= "a") AND (mod_ident[ mod_index ] <= "z")
      mod_ident[ mod_index ] := mod_ident[ mod_index ] - " "
    ENDIF

  ENDFOR

ENDPROC mod_ident
-><

->> PROC containsDefine()
->
-> SPEC     containsDefine( expr ) = b
-> DESC     Checks whether an expression must be written using a macro or not.
-> ARGS     {expr}      :   Expression tree of the C source
-> PRE      {expr} <> NIL
-> POST     b <=> Writing the source must be done using "#define ...."
->
PROC containsDefine( con_expr : PTR TO expression )
DEF con_typ

  displayGauge()

  con_typ := con_expr.extyp
  SELECT con_typ
  CASE EXTYP_PLUS       ; RETURN containsDefine( con_expr.left ) OR containsDefine( con_expr.right )
  CASE EXTYP_MINUS      ; RETURN containsDefine( con_expr.left ) OR containsDefine( con_expr.right )
  CASE EXTYP_BITAND     ; RETURN containsDefine( con_expr.left ) OR containsDefine( con_expr.right )
  CASE EXTYP_BITOR      ; RETURN containsDefine( con_expr.left ) OR containsDefine( con_expr.right )
  CASE EXTYP_MUL        ; RETURN containsDefine( con_expr.left ) OR containsDefine( con_expr.right )
  CASE EXTYP_DIV        ; RETURN containsDefine( con_expr.left ) OR containsDefine( con_expr.right )
  CASE EXTYP_SIGNED     ; RETURN containsDefine( con_expr.left )
  CASE EXTYP_STRING     ; RETURN TRUE
  CASE EXTYP_NEGOTIATE  ; RETURN TRUE
  CASE EXTYP_SHIFTLEFT  ; RETURN TRUE
  CASE EXTYP_SHIFTRIGHT ; RETURN TRUE
  ENDSELECT

ENDPROC FALSE
-><

->> PROC toe()
->
-> SPEC     toe( buffer ) = str
-> DESC     Converts a string written in C to a style comparable in E.
->          This is required since special characters are denoted in
->          special ways. This function must be extend in future because
->          currently only processed the escape character. It replaces
->          each "\33" with "\e" .
-> ARGS     {buffer}      :   Buffer containing the string
-> PRE      {buffer} <> NIL
-> POST     true
->
PROC toe( toe_str )
DEF toe_buffer [1024] : STRING
DEF toe_temp   [1024] : STRING
DEF toe_in,toe_new

  displayGauge()

  StringF( toe_buffer, '\s', toe_str )

  REPEAT

    toe_in := InStr( toe_buffer, '\\33', 0 )
    IF toe_in <> -1

      StrCopy( toe_temp, toe_buffer, toe_in )
      StrAdd( toe_temp, '\\e' )
      StrAdd( toe_temp, toe_buffer + toe_in + 3 )
      StringF( toe_buffer, '\s', toe_temp )

    ENDIF

  UNTIL toe_in = -1

  toe_new := String( StrLen( toe_buffer ) + 1 )
  StringF( toe_new, '\s', toe_buffer )

ENDPROC toe_new
-><

->> PROC alignWrite()
->
-> SPEC     alignWrite( str, val, desthandle )
-> DESC     Writes the string {str} to {destfile} and prints
->          some spaces until a supplied boundary. If the
->          length of the string {str} is bigger than {val}
->          no filling spaces will be printed.
-> ARGS     {str}         :   Buffer containing the string
->          {desthandle}  :   BCPL pointer where the source will be written to
->          {val}         :   Value specifying the boundary
-> PRE      {str} <> NIL, {desthandle} <> NIL, 0 <= {val} <= 255
-> POST     true
->
PROC alignWrite( ali_str, ali_num, ali_destfile )
DEF ali_buffer [ 256 ] : STRING
DEF ali_index, ali_len

  displayGauge()

  ali_len := StrLen( ali_str )

  StringF( ali_buffer, '\s', ali_str )
  FOR ali_index := ali_len TO 255 DO ali_buffer [ ali_index ] := " "

  ali_buffer [ ali_num ] := 0

  VfPrintf( ali_destfile, ali_buffer, NIL )

ENDPROC
-><


/* -- --------------------------------------------------------------- -- *
 * --                               Data                              -- *
 * -- --------------------------------------------------------------- -- */

lab_header_top:
CHAR    '/* -- --------------------------------------------- -- *\n', 0

lab_header_end:
CHAR    ' * -- --------------------------------------------- -- *\n'    ,
	' * -- This file was generated automatically.        -- *\n'    ,
	' * -- This was done using EMOG which is             -- *\n'    ,
	' * -- (c) Copyright by Daniel Kasmeroglu (Kasisoft) -- *\n'    ,
	' * -- --------------------------------------------- -- */\n\n' ,
	'OPT MODULE         -> Generate E module\n'                     ,
	'OPT PREPROCESS     -> Enable preprocessor\n'                   ,
	'OPT EXPORT         -> Export all\n\n\n'                        , 0


