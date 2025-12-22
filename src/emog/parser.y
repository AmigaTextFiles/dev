%{

OPT PREPROCESS

MODULE  'amigalib/lists'    ,
	'*tools'            ,
	'*absy'

/*
   If SHOWCALLS is set, each call of a function will be
   shown in more or less complex form.
   If SHOWRAISE is set, everytime an exception is raised,
   this will be shown including the place where this happened.

 */

-> #define SHOWCALLS
-> #define SHOWRAISE


EXPORT DEF result
EXPORT DEF glinput
DEF keyword

->> ALLFUNCS

/*

  Following functions are of primitive kind since they only
  are used for constructing the syntax tree.

 */

->> PROC allocAbsy
PROC allocAbsy( all_variant, all_top = 0 )
DEF all_absy : PTR TO absy

#ifdef SHOWCALLS
  WriteF( 'allocAbsy()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  all_absy := NIL

  SELECT all_variant
  CASE VARIANT_INCLUDEFILE     ; all_absy := New( all_top + SIZEOF includefile    )
  CASE VARIANT_STRUCT          ; all_absy := New( all_top + SIZEOF struct         )
  CASE VARIANT_POINTING        ; all_absy := New( all_top + SIZEOF pointing       )
  CASE VARIANT_TYPE            ; all_absy := New( all_top + SIZEOF type           )
  CASE VARIANT_ARGUMENT        ; all_absy := New( all_top + SIZEOF argument       )
  CASE VARIANT_ARGS            ; all_absy := New( all_top + SIZEOF args           )
  CASE VARIANT_FUNCTION        ; all_absy := New( all_top + SIZEOF function       )
  CASE VARIANT_EXPRESSION      ; all_absy := New( all_top + SIZEOF expression     )
  CASE VARIANT_CONSTANT        ; all_absy := New( all_top + SIZEOF constant       )
  CASE VARIANT_INCFILE         ; all_absy := New( all_top + SIZEOF incfile        )
  CASE VARIANT_CONDITIONAL     ; all_absy := New( all_top + SIZEOF conditional    )
  CASE VARIANT_IDELIST         ; all_absy := New( all_top + SIZEOF idelist        )
  CASE VARIANT_COMPONENT       ; all_absy := New( all_top + SIZEOF component      )
  CASE VARIANT_COMPS           ; all_absy := New( all_top + SIZEOF comps          )
  CASE VARIANT_STRUCT          ; all_absy := New( all_top + SIZEOF struct         )
  CASE VARIANT_VARIABLE        ; all_absy := New( all_top + SIZEOF variable       )
  CASE VARIANT_IDEARRAYED      ; all_absy := New( all_top + SIZEOF idearrayed     )
  CASE VARIANT_COMPRIGHT       ; all_absy := New( all_top + SIZEOF compright      )
  CASE VARIANT_CAST            ; all_absy := New( all_top + SIZEOF cast           )
  ENDSELECT

  IF all_absy = NIL
#ifdef SHOWRAISE
    WriteF( 'RAISE PARS: allocAbsy()\n' )
#endif
    Raise( "PARS" )
  ENDIF

  all_absy.variant := all_variant

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: allocAbsy()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC all_absy
-><

->> PROC newCast()
PROC newCast( new_name, new_isstruct, new_pointing : PTR TO pointing )
DEF new_cast : PTR TO cast
DEF new_len

#ifdef SHOWCALLS
  WriteF( 'newCast()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_len           := StrLen( new_name ) + 1
  new_cast          := allocAbsy( VARIANT_CAST, new_len )
  new_cast.pointing := new_pointing
  new_cast.isstruct := new_isstruct
  new_cast.name     := new_cast + SIZEOF cast
  AstrCopy( new_cast.name, new_name )

ENDPROC new_cast
-><

->> PROC newPointing()
PROC newPointing( new_pointing : PTR TO pointing )

#ifdef SHOWCALLS
  WriteF( 'newPointing()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  IF new_pointing = NIL
    new_pointing        := allocAbsy( VARIANT_POINTING )
    new_pointing.number := 0
  ENDIF

  new_pointing.number := new_pointing.number + 1

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newPointing()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_pointing
-><

->> PROC newType()
PROC newType( new_spec, new_name )
DEF new_type : PTR TO type
DEF new_len

#ifdef SHOWCALLS
  WriteF( 'newType( TYP = \d, \s )\n', new_spec, new_name )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_len                := StrLen( new_name ) + 1
  new_type               := allocAbsy( VARIANT_TYPE, new_len )
  new_type.specification := new_spec
  new_type.name          := new_type + SIZEOF type
  AstrCopy( new_type.name, new_name, new_len )

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newType()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_type
-><

->> PROC newArgument()
PROC newArgument( new_type, new_pointing, new_name )
DEF new_arg : PTR TO argument
DEF new_len

#ifdef SHOWCALLS
  WriteF( 'newArgument()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_len           := IF new_name = NIL THEN 0 ELSE StrLen( new_name ) + 1
  new_arg           := allocAbsy( VARIANT_ARGUMENT, new_len )
  new_arg.type      := new_type
  new_arg.pointing  := new_pointing

  IF new_len = 0
    new_arg.name    := NIL
  ELSE
    new_arg.name    := new_arg + SIZEOF argument
    AstrCopy( new_arg.name, new_name, new_len )
  ENDIF

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newArgument()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_arg
-><

->> PROC newArgs()
PROC newArgs( new_args : PTR TO args, new_arg : PTR TO argument )

#ifdef SHOWCALLS
  WriteF( 'newArgs()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  IF new_args = NIL
    new_args := allocAbsy( VARIANT_ARGS )
    newList( new_args.arguments )
  ENDIF

  AddTail( new_args.arguments, new_arg )

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newArgs()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_args
-><

->> PROC newIdeList()
PROC newIdeList( new_idelist : PTR TO idelist, new_cr )

#ifdef SHOWCALLS
  WriteF( 'newIdeList()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  IF new_idelist = NIL
    new_idelist := allocAbsy( VARIANT_IDELIST )
    newList( new_idelist.comprights )
  ENDIF

  AddTail( new_idelist.comprights, new_cr )

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newIdeList()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_idelist
-><

->> PROC newFunc()
PROC newFunc( new_type, new_pointing, new_name, new_args : PTR TO args, new_func : PTR TO function )
DEF new_len

#ifdef SHOWCALLS
  WriteF( 'newFunc()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  IF new_func = NIL

    new_len           := StrLen( new_name ) + 1
    new_func          := allocAbsy( VARIANT_FUNCTION, new_len )
    new_func.args     := new_args
    new_func.name     := new_func + SIZEOF function
    AstrCopy( new_func.name, new_name, new_len )

  ELSE
    new_func.type     := new_type
    new_func.pointing := new_pointing
  ENDIF

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newFunc()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_func
-><

->> PROC newExpr()
PROC newExpr( new_extyp, new_val, new_str, new_left, new_right )
DEF new_expr : PTR TO expression
DEF new_len

#ifdef SHOWCALLS
  IF (new_extyp = EXTYP_ID) OR (new_extyp = EXTYP_STRING)
    WriteF( 'newExpr( TYP = \d, str = \s )\n', new_extyp, new_str )
  ELSEIF new_extyp = EXTYP_HEXVALUE
    WriteF( 'newExpr( TYP = \d, val = $\h )\n', new_extyp, new_val )
  ELSEIF new_extyp = EXTYP_DECVALUE
    WriteF( 'newExpr( TYP = \d, val = \d )\n', new_extyp, new_val )
  ELSE
    WriteF( 'newExpr( TYP = \d )\n', new_extyp )
  ENDIF
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  IF (new_extyp = EXTYP_ID) OR (new_extyp = EXTYP_STRING)
    new_len      := StrLen( new_str ) + 1
  ELSE
    new_len      := 0
  ENDIF

  new_expr       := allocAbsy( VARIANT_EXPRESSION, new_len )
  new_expr.extyp := new_extyp
  new_expr.value := new_val
  new_expr.left  := new_left
  new_expr.right := new_right
  new_expr.id    := NIL
  new_expr.cast  := NIL

  IF new_len > 0
    new_expr.id  := new_expr + SIZEOF expression
    AstrCopy( new_expr.id, new_str, new_len )
  ENDIF

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newExpr()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_expr
-><

->> PROC modifyExpr()
PROC modifyExpr( mod_expr : PTR TO expression, mod_cast : PTR TO cast )

#ifdef SHOWCALLS
  WriteF( 'Modifying expression !\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  mod_expr.cast := mod_cast

ENDPROC
-><

->> PROC newConstant()
PROC newConstant( new_name, new_expr )
DEF new_const : PTR TO constant
DEF new_len

#ifdef SHOWCALLS
  WriteF( 'newConstant()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_len           := StrLen( new_name ) + 1
  new_const         := allocAbsy( VARIANT_CONSTANT, new_len )
  new_const.expr    := new_expr
  new_const.id      := new_const + SIZEOF constant
  AstrCopy( new_const.id, new_name, new_len )

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newConstant()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_const
-><

->> PROC newIncfile()
PROC newIncfile( new_curr, new_path )
DEF new_incfile : PTR TO incfile

#ifdef SHOWCALLS
  WriteF( 'newIncfile()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_incfile         := allocAbsy( VARIANT_INCFILE )
  new_incfile.current := new_curr
  new_incfile.path    := new_path

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newIncfile()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_incfile
-><

->> PROC newConditional()
PROC newConditional( new_name, new_incfile )
DEF new_cond : PTR TO conditional
DEF new_len

#ifdef SHOWCALLS
  WriteF( 'newConditional()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_len           := StrLen( new_name ) + 1
  new_cond          := allocAbsy( VARIANT_CONDITIONAL, new_len )
  new_cond.include  := new_incfile
  new_cond.neg      := FALSE
  new_cond.test     := new_cond + SIZEOF conditional
  AstrCopy( new_cond.test, new_name, new_len )

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newConditional()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_cond
-><

->> PROC newComp()
PROC newComp( new_type, new_idelist )
DEF new_comp : PTR TO component

#ifdef SHOWCALLS
  WriteF( 'newComp()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_comp          := allocAbsy( VARIANT_COMPONENT )
  new_comp.type     := new_type
  new_comp.idelist  := new_idelist

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newComp()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_comp
-><

->> PROC newComps()
PROC newComps( new_comps : PTR TO comps, new_component : PTR TO component )

#ifdef SHOWCALLS
  WriteF( 'newComps()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  IF new_comps = NIL
    new_comps := allocAbsy( VARIANT_COMPS )
    newList( new_comps.components )
  ENDIF

  AddTail( new_comps.components, new_component )

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newComps()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_comps
-><

->> PROC newStruct()
PROC newStruct( new_name, new_components )
DEF new_struct : PTR TO struct
DEF new_len

#ifdef SHOWCALLS
  WriteF( 'newStruct()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_len               := StrLen( new_name ) + 1
  new_struct            := allocAbsy( VARIANT_STRUCT, new_len )
  new_struct.components := new_components
  new_struct.name       := new_struct + SIZEOF struct
  AstrCopy( new_struct.name, new_name, new_len )

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newStruct()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_struct
-><

->> PROC newVar()
PROC newVar( new_type, new_idelist )
DEF new_var : PTR TO variable

#ifdef SHOWCALLS
  WriteF( 'newVar()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_var         := allocAbsy( VARIANT_VARIABLE )
  new_var.type    := new_type
  new_var.idelist := new_idelist

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newVar()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_var
-><

->> PROC newIncludeFile()
PROC newIncludeFile( new_incfile : PTR TO includefile, new_absy )

#ifdef SHOWCALLS
  WriteF( 'newIncludeFile()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  IF new_incfile = NIL
    new_incfile := allocAbsy( VARIANT_INCLUDEFILE )
    newList( new_incfile.entries )
  ENDIF

  AddTail( new_incfile.entries, new_absy )

  result := new_incfile

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newIncludeFile()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_incfile
-><

->> PROC newIdeArrayed()
PROC newIdeArrayed( new_str, new_times )
DEF new_ide : PTR TO idearrayed

#ifdef SHOWCALLS
  WriteF( 'newIdeArrayed( \s, \d )\n', new_str, new_times )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_ide            := allocAbsy( VARIANT_IDEARRAYED )
  new_ide.identifier := new_str
  new_ide.times      := new_times

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newIdeArrayed()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_ide
-><

->> PROC newCompRight()
PROC newCompRight( new_pointing : PTR TO pointing, new_idearrayed )
DEF new_cr : PTR TO compright

#ifdef SHOWCALLS
  IF new_pointing <> NIL
    WriteF( 'newCompRight( \d )\n', new_pointing.number )
  ELSE
    WriteF( 'newCompRight( 0  )\n' )
  ENDIF
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  new_cr            := allocAbsy( VARIANT_COMPRIGHT )
  new_cr.pointing   := new_pointing
  new_cr.idearrayed := new_idearrayed

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: newCompRight()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC new_cr
-><

->> PROC negotiateCond()
PROC negotiateCond( neg_cond : PTR TO conditional )

#ifdef SHOWCALLS
  WriteF( 'negotiateCond()\n' )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  neg_cond.neg := TRUE

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: negotiateCond()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC neg_cond
-><

->> PROC concatStr()
PROC concatStr( con_str1, con_str2 )
DEF con_buffer [1024] : STRING
DEF con_len,con_new

  IF con_str1 = NIL THEN con_str1 := ''
  IF con_str2 = NIL THEN con_str2 := ''

#ifdef SHOWCALLS
  WriteF( 'concatStr( \s, \s )', con_str1, con_str2 )
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  StringF( con_buffer, '\s\s', con_str1, con_str2 )
  con_len := StrLen( con_buffer ) + 1

  con_new := New( con_len )
  IF con_new = NIL
#ifdef SHOWRAISE
    WriteF( 'RAISE PARS: concatStr()\n' )
#endif
    Raise( "PARS" )
  ENDIF

  AstrCopy( con_new, con_buffer, con_len )

#ifdef SHOWCALLS
  WriteF( ' = \s\n', con_new )
#endif

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: concatStr()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC con_new
-><

->> PROC asStr()
PROC asStr( ass_value, ass_hex )
DEF ass_buf [20] : STRING
DEF ass_new,ass_len

#ifdef SHOWCALLS
  IF ass_hex
    WriteF( 'asStr( val = $\h, TRUE )\n', ass_value )
  ELSE
    WriteF( 'asStr( val = \d, FALSE )\n', ass_value )
  ENDIF
#endif
#ifndef SHOWCALLS
  displayGauge()
#endif

  IF ass_hex <> FALSE
    StringF( ass_buf , '0x\h' , ass_value )
  ELSE
    StringF( ass_buf , '\d'   , ass_value )
  ENDIF

  ass_len := StrLen( ass_buf ) + 1

  ass_new := New( ass_len )
  IF ass_new = NIL THEN Raise( "PARS" )
  AstrCopy( ass_new, ass_buf, ass_len )

  IF CtrlC()
#ifdef SHOWRAISE
    WriteF( 'RAISE CTRL: asStr()\n' )
#endif
    Raise( "CTRL" )
  ENDIF

ENDPROC ass_new
-><

-><


%}

%start INCLUDEFILE

%token PID PDECVALUE PHEXVALUE PEOF

%left '-' '+'
%left '|' '&'
%left '*' '/'
%left '<' '>'
%left '~'
%left '(' ')'
%left '[' ']'
%left '"'

%%

INCLUDEFILE             : CONSTANT                                      { $$ := newIncludeFile( NIL , $1 )                          }
			| INCLUSION                                     { $$ := newIncludeFile( NIL , $1 )                          }
			| CONDITIONAL                                   { $$ := newIncludeFile( NIL , $1 )                          }
			| STRUCT                                        { $$ := newIncludeFile( NIL , $1 )                          }
			| FUNC                                          { $$ := newIncludeFile( NIL , $1 )                          }
			| VARIABLE                                      { $$ := newIncludeFile( NIL , $1 )                          }
			| INCLUDEFILE CONSTANT                          { $$ := newIncludeFile( $1  , $2 )                          }
			| INCLUDEFILE INCLUSION                         { $$ := newIncludeFile( $1  , $2 )                          }
			| INCLUDEFILE CONDITIONAL                       { $$ := newIncludeFile( $1  , $2 )                          }
			| INCLUDEFILE STRUCT                            { $$ := newIncludeFile( $1  , $2 )                          }
			| INCLUDEFILE FUNC                              { $$ := newIncludeFile( $1  , $2 )                          }
			| INCLUDEFILE VARIABLE                          { $$ := newIncludeFile( $1  , $2 )                          }
			;

/*

  Yeah, yeah, some things aren't done yet.


CAST                    : '(' CASTRIGHT                                 { $$ := $2                                                  }
			;

CASTRIGHT               : PID CASTEND                                   { $$ := newCast( $1 , FALSE , $2 )                          }
			| STRUCTTYPE CASTEND                            { $$ := newCast( $1 , TRUE  , $2 )                          }
			;

CASTEND                 : ')'                                           { $$ := NIL                                                 }
			| POINTING ')'                                  { $$ := $1                                                  }
			;
 */

STRUCT                  : STRUCTTYPE '{' COMPS '}' ';'                  { $$ := newStruct( $1 , $3 )                                }
			;

TYPE                    : STRUCTTYPE                                    { $$ := newType( TYP_STRUCT  , $1 )                         }
			| PID                                           { $$ := newType( TYP_DEFINED , $1 )                         }
			;

STRUCTTYPE              : 's' 't' 'r' 'u' 'c' 't' PID                   { $$ := $7                                                  }
			;

INCLUSION               : '#' 'i' 'n' 'c' 'l' 'u' 'd' 'e' INCFILE       { $$ := $9                                                  }
			;

CONSTANT                : '#' 'd' 'e' 'f' 'i' 'n' 'e' PID EXPRESSION    { $$ := newConstant( $8 , $9 )                              }
			;

COMPS                   : COMPONENT                                     { $$ := newComps( NIL , $1 )                                }
			| COMPS COMPONENT                               { $$ := newComps( $1  , $2 )                                }
			;

COMPONENT               : TYPE IDELIST ';'                              { $$ := newComp( $1 , $2 )                                  }
			;

IDELIST                 : COMPRIGHT                                     { $$ := newIdeList( NIL , $1 )                              }
			| IDELIST ',' COMPRIGHT                         { $$ := newIdeList( $1  , $3 )                              }
			;

COMPRIGHT               : POINTING IDEARRAYED                           { $$ := newCompRight( $1  , $2 )                            }
			| IDEARRAYED                                    { $$ := newCompRight( NIL , $1 )                            }
			;

IDEARRAYED              : PID                                           { $$ := newIdeArrayed( $1 , 0  )                            }
			| PID '[' PDECVALUE ']'                         { $$ := newIdeArrayed( $1 , $3 )                            }
			| PID '[' PHEXVALUE ']'                         { $$ := newIdeArrayed( $1 , $3 )                            }
			;

CONDITIONAL             : '#' 'i' 'f' 'd' 'e' 'f' CONDRIGHT             { $$ := $7                                                  }
			| '#' 'i' 'f' 'n' 'd' 'e' 'f' CONDRIGHT         { $$ := negotiateCond( $8 )                                 }
			;

CONDRIGHT               : PID INCLUDEFILE '#' 'e' 'n' 'd' 'i' 'f'       { $$ := newConditional( $1 , $2 )                           }
			;

INCFILE                 : '<' PATH '>'                                  { $$ := newIncfile( FALSE , $2 )                            }
			| '"' PATH '"'                                  { $$ := newIncfile( TRUE  , $2 )                            }
			;

PATH                    : PID                                           { $$ := concatStr( $1  , '' )                               }
			| PID PATH                                      { $$ := concatStr( $1  , $2 )                               }
			| '.' PATH                                      { $$ := concatStr( '.' , $2 )                               }
			| '/' PATH                                      { $$ := concatStr( '/' , $2 )                               }
			;

STRING                  : PID                                           { $$ := concatStr( $1                  , '' )               }
			| PID STRING                                    { $$ := concatStr( $1                  , $2 )               }
			| '.' STRING                                    { $$ := concatStr( '.'                 , $2 )               }
			| '/' STRING                                    { $$ := concatStr( '/'                 , $2 )               }
			| '\\' STRING                                   { $$ := concatStr( '\\'                , $2 )               }
			| PHEXVALUE STRING                              { $$ := concatStr( asStr( $1 , TRUE  ) , $2 )               }
			| PDECVALUE STRING                              { $$ := concatStr( asStr( $1 , FALSE ) , $2 )               }
			;

EXPRESSION              : '(' EXPRESSION ')'                            { $$ := $2                                                  }
			| '~' EXPRESSION                                { $$ := newExpr( EXTYP_NEGOTIATE  , 0  , NIL , $2  , NIL )  }
			| '-' EXPRESSION                                { $$ := newExpr( EXTYP_SIGNED     , 0  , NIL , $2  , NIL )  }
			| '"' STRING '"'                                { $$ := newExpr( EXTYP_STRING     , 0  , $2  , NIL , NIL )  }
			| PID                                           { $$ := newExpr( EXTYP_ID         , 0  , $1  , NIL , NIL )  }
			| PHEXVALUE                                     { $$ := newExpr( EXTYP_HEXVALUE   , $1 , NIL , NIL , NIL )  }
			| PDECVALUE                                     { $$ := newExpr( EXTYP_DECVALUE   , $1 , NIL , NIL , NIL )  }
			| EXPRESSION '<' '<' EXPRESSION                 { $$ := newExpr( EXTYP_SHIFTLEFT  , 0  , NIL , $1  , $4  )  }
			| EXPRESSION '>' '>' EXPRESSION                 { $$ := newExpr( EXTYP_SHIFTRIGHT , 0  , NIL , $1  , $4  )  }
			| EXPRESSION '+' EXPRESSION                     { $$ := newExpr( EXTYP_PLUS       , 0  , NIL , $1  , $3  )  }
			| EXPRESSION '-' EXPRESSION                     { $$ := newExpr( EXTYP_MINUS      , 0  , NIL , $1  , $3  )  }
			| EXPRESSION '|' EXPRESSION                     { $$ := newExpr( EXTYP_BITOR      , 0  , NIL , $1  , $3  )  }
			| EXPRESSION '&' EXPRESSION                     { $$ := newExpr( EXTYP_BITAND     , 0  , NIL , $1  , $3  )  }
			| EXPRESSION '*' EXPRESSION                     { $$ := newExpr( EXTYP_MUL        , 0  , NIL , $1  , $3  )  }
			| EXPRESSION '/' EXPRESSION                     { $$ := newExpr( EXTYP_DIV        , 0  , NIL , $1  , $3  )  }
			;

POINTING                : '*'                                           { $$ := newPointing( NIL )                                  }
			| POINTING '*'                                  { $$ := newPointing( $1  )                                  }
			;

FUNC                    : TYPE POINTING FUNCRIGHT                       { $$ := newFunc( $1 , $2  , NIL , NIL , $3 )                }
			| TYPE FUNCRIGHT                                { $$ := newFunc( $1 , NIL , NIL , NIL , $2 )                }
			;

FUNCRIGHT               : PID '(' ARGS ')' ';'                          { $$ := newFunc( NIL , NIL , $1 , $3 , NIL )                }
			;

VARIABLE                : TYPE IDELIST ';'                              { $$ := newVar( $1 , $2 )                                   }
			;

ARGS                    : ARGUMENT                                      { $$ := newArgs( NIL , $1 )                                 }
			| ARGS ',' ARGUMENT                             { $$ := newArgs( $1  , $3 )                                 }
			;

ARGUMENT                : TYPE POINTING PID                             { $$ := newArgument( $1 , $2 , $3  )                        }
			| TYPE POINTING                                 { $$ := newArgument( $1 , $2 , NIL )                        }
			;


%%

->> PROC yylex()
PROC yylex()
DEF lex_buffer [512] : STRING
DEF lex_new          : PTR TO CHAR
DEF lex_ptr,lex_first

  IF keyword <> NIL
    lex_first := keyword[]++
    IF keyword[] = 0 THEN keyword := NIL
    RETURN lex_first
  ENDIF

  IF ReadStr( glinput, lex_buffer ) = -1 THEN RETURN 0
  lex_ptr   := lex_buffer
  lex_first := lex_ptr[]++

  SELECT lex_first
->> CASE k
  CASE "k"
    lex_first := StrLen( lex_ptr ) + 1
    lex_new   := New( lex_first )
    IF lex_new = NIL THEN Raise( "MEM" )
    AstrCopy( lex_new, lex_ptr, lex_first )
    keyword   := lex_new + 1
    RETURN lex_new[]
-><
->> CASE i
  CASE "i"
    lex_first := StrLen( lex_ptr ) + 1
    lex_new   := New( lex_first )
    IF lex_new = NIL THEN Raise( "MEM" )
    AstrCopy( lex_new, lex_ptr, lex_first )
    RETURN PID, lex_new
-><
->> CASE d
  CASE "d"
    RETURN PDECVALUE, Val( lex_ptr )
-><
->> CASE h
  CASE "h"
    lex_ptr[1] := "$"
    RETURN PHEXVALUE, Val( lex_ptr + 1 )
-><
  ENDSELECT

ENDPROC lex_ptr[]
-><

->> PROC yyerror()
PROC yyerror( n )

  IF n = YYERRSTACK
    WriteF( 'Parse stack overflow !\n> '      )
  ELSEIF n = YYERRPARSE
    WriteF( 'Parse error !\n' )
  ENDIF

ENDPROC
-><


