
-> Copyright © 1995, Guichard Damien.

->  This is a classic old-fashionned recursive-descent LL(1) parser.
->  It performs 2 passes.
->  The first pass deals with classes and features.
->  It resolves inheritance, client and cyclic dependancies.
->  The second pass deals with routines and generates the AME code.
->  Basic classes are separated from other classes.
->  You can inherit from ANY, STRING classes and redefine their features,
->  but you can not inherit from INTEGER, BOOLEAN, REAL, DOUBLE, CHARACTER
->  as they are expanded classes, which is not yet supported.
->  Currently you can not even use ARRAY as genericity is not supported
->  and no specific alternative is available.

-> As a convenience procedures have Eiffel 3.0 syntax construct names, post
-> fixed with 1 or 2 when necessary to avoid confusion between passes 1 and 2.

-> TO DO :
->   S-validity checking
->   'Result' should be a reserved word
->   ANY, ARRAY and Void should not be reserved words
->   generic classes/types
->   expanded classes/types
->   'like entity' and 'like argument' anchored types
->   multiple inheritance
->   repeated inheritance and selection
->   unique constants
->   multiple feature declaration
->   more stuff for obsolete classes
->   feature merging
->   more stuff for class invariants
->   infix and prefix functions
->   more stuff for obsolete routines
->   routine redefinition to a variable attribute
->   exceptions
->   more stuff for preconditions
->   more stuff for postconditions
->   more stuff for rescue clauses
->   once routines
->   external routines
->   reverse assignment attempt

OPT MODULE

MODULE '*strings','*errors'
MODULE '*eiffel_lex','*prime_server'
MODULE '*entity','*entity_tree','*kernel_class','*current'
MODULE '*class','*feature','*function','*procedure','*variable','*constant'
MODULE '*argument','*local'
MODULE '*unnamer'
MODULE '*code','*ame','*ame_code','*label_server'

-> The Eiffel system (set of classes)
EXPORT DEF system:PTR TO entity_tree

-> special classes
EXPORT DEF any_class:PTR TO class
EXPORT DEF none_class:PTR TO kernel_class
EXPORT DEF integer_class:PTR TO kernel_class
EXPORT DEF boolean_class:PTR TO kernel_class
EXPORT DEF character_class:PTR TO kernel_class
EXPORT DEF real_class:PTR TO kernel_class
EXPORT DEF double_class:PTR TO kernel_class
EXPORT DEF pointer_class:PTR TO kernel_class
EXPORT DEF string_class:PTR TO class
EXPORT DEF array_class:PTR TO class

EXPORT DEF current:PTR TO current   -> 'Current' class (passes 1 and 2)
EXPORT DEF class:PTR TO class       -> class beeing parsed (passes 1 and 2)

DEF parent:PTR TO class      -> parent class (pass 1)
DEF client:PTR TO class      -> feature client (pass 1)
DEF arguments:PTR TO argument
DEF routine:PTR TO procedure -> routine beeing parsed (pass 2)

DEF e:PTR TO entity          -> an eiffel entity (pass 2)
DEF f:PTR TO feature         -> an eiffel feature (pass 2)
DEF r:PTR TO procedure       -> an eiffel routine (pass 2)

DEF result:PTR TO class      -> result class/type of expressions (pass 2)

DEF adaptation               -> feature adaptation (pass 1)
DEF reg:LONG                 -> AME registers used (pass 2)

EXPORT DEF lex:PTR TO eiffel_lex     -> lexical analyser (passes 1 and 2)
EXPORT DEF prime:PTR TO prime_server -> Prime stream (pass 1)
EXPORT DEF ll:PTR TO label_server    -> local label server (pass 2)
EXPORT DEF gl:PTR TO label_server    -> global label server (pass 1)
EXPORT DEF code:PTR TO ame_code      -> executable code generated (pass 2)

-> Class_declaration (pass 1)
EXPORT PROC class_declaration1()
  DEF oldclient
  DEF oldargs
  oldclient:=client
  oldargs:=arguments
  class.supplier()
  lex:=class.lex
  current.set(class)
  indexing()
  obsolete()
  class_header()
  parent_list()
  class.lex.store()
  creators1()
  features1()
  invariant()
  IF lex.last<>LEX_END THEN Raise(ER_SYNTAX)
  lex.read()
  IF lex.last<>LEX_EOF THEN Raise(ER_SYNTAX)
  client:=oldclient
  arguments:=oldargs
ENDPROC

-> Class_declaration (pass 2)
EXPORT PROC class_declaration2()
  DEF label
  IF class.status=SUPPLIER
    class.lex.restore()
    lex:=class.lex
    current.set(class)
    creators2()
    features2()
    lex.detach_text()
    code.ame(I_CLASSFIELDS,M_IMMEDIATE,class.fields(),R_NONE)
    code.ame(I_TABLE,class.access(),class.index(),R_NONE)
    IF label:=class.first_routine()
      REPEAT
        code.ame(I_LINK,M_LABEL,label,R_NONE)
        label:=class.next_routine()
      UNTIL label=0
    ENDIF
  ENDIF
ENDPROC

-> Type
PROC type()
  DEF type:PTR TO class
  DEF oldclass:PTR TO class
  DEF last
  last:=lex.last
  SELECT last
  CASE LEX_LIKE
    lex.read()
    IF lex.last<>LEX_CURRENT THEN Raise(ER_NOT_IMPLEMENTED)
    type:=current
  CASE LEX_ANY
    type:=any_class
  CASE LEX_INTEGER
    type:=integer_class
  CASE LEX_BOOLEAN
    type:=boolean_class
  CASE LEX_CHARACTER
    type:=character_class
  CASE LEX_STRING
    type:=string_class
  CASE LEX_ARRAY
    type:=array_class
  CASE LEX_NONE
    type:=none_class
  CASE LEX_IDENT
    IF type:=system.find(lex.ident)
    ELSE
      NEW type.set_name(lex.ident,prime.next(),gl.next())
      system.add(type)
    ENDIF
    IF type.status<>SUPPLIER
      oldclass:=class
      class:=type
      class_declaration1()
      class_declaration2()
      class:=oldclass
      lex:=oldclass.lex
      current.set(class)
    ENDIF
  DEFAULT
    Raise(ER_SYNTAX)
  ENDSELECT
  lex.read()
ENDPROC type

-> Clients
PROC clients()
  DEF last
  client:=any_class
  IF lex.last="{"
    lex.read()
    last:=lex.last
    SELECT last
    CASE LEX_ANY
      lex.read()
    CASE LEX_NONE
      lex.read()
      client:=none_class
    CASE LEX_IDENT
      IF client:=system.find(lex.ident)
      ELSE
        NEW client.set_name(lex.ident,prime.next(),gl.next())
        system.add(client)
      ENDIF
      lex.read()
    CASE "}"
      client:=none_class
    DEFAULT
      Raise(ER_SYNTAX)
    ENDSELECT
    IF lex.last="," THEN Raise(ER_NOT_IMPLEMENTED)
    IF lex.last<>"}" THEN Raise(ER_SYNTAX)
    lex.read()
  ENDIF
ENDPROC


-> Indexing
PROC indexing()
  IF lex.last=LEX_INDEXING
    lex.read()
    WHILE lex.last>=LEX_IDENT
      IF lex.last=LEX_IDENT
        lex.read()
        IF (lex.last=":") OR (lex.last=",")
          lex.read()
          index_terms()
        ENDIF
      ELSE
        index_terms()
      ENDIF
      IF lex.last=";" THEN lex.read()
    ENDWHILE
  ENDIF
ENDPROC

-> Index_terms
PROC index_terms()
  WHILE TRUE
    IF lex.last<LEX_IDENT THEN Raise(ER_SYNTAX)
    lex.read()
    EXIT lex.last<>","
    lex.read()
  ENDWHILE
ENDPROC

-> Obsolete
PROC obsolete()
  IF lex.last=LEX_OBSOLETE
    lex.read()
    IF lex.last<>LEX_STR THEN Raise(ER_SYNTAX)
    lex.read()
  ENDIF
ENDPROC

-> Class_header
PROC class_header()
  IF lex.last=LEX_DEFERRED
    lex.read()
    class.defer()
  ENDIF
  IF lex.last=LEX_EXPANDED THEN Raise(ER_NOT_IMPLEMENTED)
  IF lex.last<>LEX_CLASS THEN Raise(ER_SYNTAX)
  lex.read()
  IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
  IF StrCmp(class.name,lex.ident,ALL)=FALSE THEN Raise(ER_SYNTAX)
  lex.read()
  IF lex.last="[" THEN Raise(ER_NOT_IMPLEMENTED)
ENDPROC

-> Parent_list (single inheritance only)
-> You can inherit from basic classes ANY and STRING and redefine their
-> features
PROC parent_list()
  parent:=NIL
  IF lex.last=LEX_INHERIT
    lex.read()
    IF lex.last=LEX_ANY
      lex.read()
      parent:=any_class
    ELSEIF lex.last=LEX_STRING
      lex.read()
      parent:=string_class
    ELSEIF lex.last=LEX_IDENT
      parent:=type()
      IF lex.last="[" THEN Raise(ER_NOT_IMPLEMENTED)
    ENDIF
  ENDIF
  IF parent
    class.add_parent(parent)
    feature_adaptation()
    IF lex.last=";" THEN lex.read()
    IF lex.last=LEX_IDENT THEN Raise(ER_NOT_IMPLEMENTED)
  ELSE
    class.add_parent(any_class)
  ENDIF
ENDPROC

-> Feature_adaptation
PROC feature_adaptation()
  adaptation:=FALSE
  rename()
  new_exports()
  undefine()
  redefine()
  IF lex.last=LEX_SELECT THEN Raise(ER_NOT_IMPLEMENTED)
  IF adaptation
    IF lex.last<>LEX_END THEN Raise(ER_SYNTAX)
    lex.read()
  ENDIF
ENDPROC

-> Invariant()
PROC invariant()
  IF lex.last=LEX_INVARIANT THEN lex.read()
ENDPROC

-> As only single inheritance is implemented there is no use to check
-> from which parent a feature is inherited

-> Rename
PROC rename()
  DEF unnamer:PTR TO unnamer
  IF lex.last=LEX_RENAME
    lex.read()
    adaptation:=TRUE
    IF lex.last=LEX_IDENT
      WHILE TRUE
        IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
        f:=parent.find_feature(lex.ident)
        IF f=NIL THEN Raise(ER_VHRC1)
        f:=class.find_feature(lex.ident)
        IF f=NIL THEN Raise(ER_VHRC2)
        lex.read()
        NEW unnamer.old_name(f.name)
        class.add_feature(unnamer)
        IF lex.last<>LEX_AS THEN Raise(ER_SYNTAX)
        lex.read()
        IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
        class.add_feature(f.rename(lex.ident))
        lex.read()
        EXIT lex.last<>","
        lex.read()
      ENDWHILE
    ENDIF
  ENDIF
ENDPROC

-> New_exports
PROC new_exports()
  IF lex.last=LEX_EXPORT
    lex.read()
    adaptation:=TRUE
    WHILE lex.last="{"
      clients()
      WHILE TRUE
        IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
        f:=class.find_feature(lex.ident)
        IF f=NIL THEN Raise(ER_VLEL2)
        lex.read()
        class.add_feature(f.new_exports(client))
        EXIT lex.last<>","
        lex.read()
      ENDWHILE
      IF lex.last=";" THEN lex.read()
    ENDWHILE
  ENDIF
ENDPROC

-> Undefine
PROC undefine()
  IF lex.last=LEX_UNDEFINE
    lex.read()
    adaptation:=TRUE
    IF lex.last=LEX_IDENT
      WHILE TRUE
        IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
        f:=class.find_feature(lex.ident)
        IF f=NIL THEN Raise(ER_VDUS1)
        IF f.is_frozen() THEN Raise(ER_VDUS2)
        IF f.is_attribute() THEN Raise(ER_VDUS2)
        IF f.is_deferred() THEN Raise(ER_VDUS3)
        class.add_feature(f.undefine())
        class.undefine()
        lex.read()
        EXIT lex.last<>","
        lex.read()
      ENDWHILE
    ENDIF
  ENDIF
ENDPROC

-> Redefine
PROC redefine()
  IF lex.last=LEX_REDEFINE
    lex.read()
    adaptation:=TRUE
    IF lex.last=LEX_IDENT
      WHILE TRUE
        IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
        f:=class.find_feature(lex.ident)
        IF f=NIL THEN Raise(ER_VDRS1)
        IF f.is_constant() THEN Raise(ER_VDRS2)
        IF f.is_frozen() THEN Raise(ER_VDRS2)
        class.redefine()
        lex.read()
        EXIT lex.last<>","
        lex.read()
      ENDWHILE
    ENDIF
  ENDIF
ENDPROC

-> Creators (pass 1)
PROC creators1()
  WHILE lex.last=LEX_CREATION
    lex.read()
    clients()
    IF lex.last=LEX_IDENT
      IF class.is_deferred THEN Raise(ER_VGCP1)
      WHILE TRUE
        IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
        lex.read()
        class.creators_section()
        EXIT lex.last<>","
        lex.read()
      ENDWHILE
    ENDIF
  ENDWHILE
ENDPROC

-> Features (pass 1)
PROC features1()
  WHILE lex.last=LEX_FEATURE
    lex.read()
    clients()
    WHILE (lex.last=LEX_FROZEN) OR (lex.last=LEX_IDENT)
      feature_declaration1()
      IF lex.last=";" THEN lex.read()
    ENDWHILE
    IF lex.last=LEX_INFIX THEN Raise(ER_NOT_IMPLEMENTED)
    IF lex.last=LEX_PREFIX THEN Raise(ER_NOT_IMPLEMENTED)
  ENDWHILE
  class.prepare_links()
  IF class.all_redefined()=FALSE THEN Raise(ER_VDRS4)
  IF class.is_deferred
    IF class.all_effected() THEN Raise(ER_VCCH2)
  ELSEIF class.all_effected()=FALSE
    Raise(ER_VCCH1)
  ENDIF
ENDPROC

-> Feature_declaration (pass 1)
PROC feature_declaration1()
  DEF tok
  DEF frozen=FALSE
  DEF name:PTR TO CHAR
  DEF type_mark=NIL:PTR TO class
  DEF const:PTR TO constant
  DEF var:PTR TO variable
  DEF proc:PTR TO procedure
  DEF func:PTR TO function
  IF lex.last=LEX_FROZEN
    lex.read()
    frozen:=TRUE
  ENDIF
  IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
  name:=clone(lex.ident)
  lex.read()
  arguments:=NIL
  formal_arguments1()
  IF lex.last=":"
    lex.read()
    type_mark:=type()
  ENDIF
  IF f:=class.find_feature(name)
    IF f.is_conform(arguments,type_mark)=FALSE THEN Raise(ER_VDRD2)
    IF f.is_constant() THEN Raise(ER_VDRD4)
    IF f.is_variable()
      f:=f.redefine(client,NIL,type_mark)
    ELSEIF f.is_routine()
      r:=f
      f:=r.redefine(client,arguments,type_mark)
      IF lex.last<>LEX_IS THEN Raise(ER_NOT_IMPLEMENTED)
      lex.read()
      obsolete()
      precondition()
      local_declarations1()
      IF lex.last=LEX_DO
        IF r.is_deferred()
          class.effected()
        ELSE
          class.redefined()
        ENDIF
      ELSEIF lex.last=LEX_DEFERRED
        IF r.is_deferred()=FALSE THEN Raise(ER_VDRD5)
        r:=f
        r.defer()
        class.redefined()
      ELSE
        Raise(ER_SYNTAX)
      ENDIF
      lex.read()
      effective1()
    ENDIF
    f.create(name,client,type_mark)
    IF frozen THEN f.freeze()
    class.redeclare_feature(f)
    RETURN
  ELSEIF lex.last=LEX_IS
    lex.read()
    tok:=lex.last
    SELECT tok
    CASE LEX_TRUE
      lex.read()
      IF arguments THEN Raise(ER_VFFD1)
      IF type_mark<>boolean_class THEN Raise(ER_VQMC)
      f:=NEW const.set_value(TRUE)
    CASE LEX_FALSE
      lex.read()
      IF arguments THEN Raise(ER_VFFD1)
      IF type_mark<>boolean_class THEN Raise(ER_VQMC)
      f:=NEW const.set_value(FALSE)
    CASE LEX_NUMERAL
      IF arguments THEN Raise(ER_VFFD1)
      IF type_mark<>integer_class THEN Raise(ER_VQMC)
      f:=NEW const.set_value(lex.value)
      lex.read()
    CASE LEX_CHAR
      IF arguments THEN Raise(ER_VFFD1)
      IF type_mark<>character_class THEN Raise(ER_VQMC)
      f:=NEW const.set_value(lex.value)
      lex.read()
    DEFAULT
      obsolete()
      precondition()
      local_declarations1()
      IF type_mark
        f:=NEW func.add_arguments(arguments)
      ELSE
        f:=NEW proc.add_arguments(arguments)
      ENDIF
      r:=f
      tok:=lex.last
      SELECT tok
      CASE LEX_DO
      CASE LEX_DEFERRED
        r.defer()
        class.effecting()
      CASE LEX_EXTERNAL
        Raise(ER_NOT_IMPLEMENTED)
      CASE LEX_ONCE
        Raise(ER_NOT_IMPLEMENTED)
      DEFAULT
        Raise(ER_SYNTAX)
      ENDSELECT
      lex.read()
      effective1()
    ENDSELECT
  ELSE
    IF arguments THEN Raise(ER_VFFD1)
    IF type_mark=NIL THEN Raise(ER_VFFD1)
    f:=NEW var
  ENDIF
  f.create(name,client,type_mark)
  IF frozen THEN f.freeze()
  class.add_feature(f)
ENDPROC

-> Formal_arguments (pass 1)
PROC formal_arguments1()
  IF lex.last="("
    lex.read()
    WHILE TRUE
      new_arg1()
      EXIT lex.last<>";"
      lex.read()
    ENDWHILE
    IF lex.last<>")" THEN Raise(ER_SYNTAX)
    lex.read()
  ENDIF
ENDPROC

-> Formal_arguments (pass 2)
PROC formal_arguments2()
  DEF arity=0
  IF lex.last="("
    lex.read()
    WHILE TRUE
      WHILE TRUE
        IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
        IF class.find_feature(lex.ident) THEN Raise(ER_VRFA)
        lex.read()
        INC arity
        EXIT lex.last<>","
        lex.read()
      ENDWHILE
      IF lex.last<>":" THEN Raise(ER_SYNTAX)
      lex.read()
      type()
      EXIT lex.last<>";"
      lex.read()
    ENDWHILE
    IF lex.last<>")" THEN Raise(ER_SYNTAX)
    lex.read()
  ENDIF
ENDPROC arity

-> Multiple formal arg declaration
PROC new_arg1()
  DEF newarg:PTR TO argument
  IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
  IF class.find_feature(lex.ident) THEN Raise(ER_VRFA)
  IF arguments THEN
    IF arguments.find(lex.ident) THEN Raise(ER_VREG)
  NEW newarg.create(clone(lex.ident))
  lex.read()
  IF arguments THEN
    arguments.add(newarg) ELSE arguments:=newarg
  IF lex.last=","
    lex.read()
    newarg.set_type(new_arg1())
  ELSE
    IF lex.last<>":" THEN Raise(ER_SYNTAX)
    lex.read()
    newarg.set_type(type())
  ENDIF
ENDPROC newarg.type

-> Creators (pass 2)
PROC creators2()
  WHILE lex.last=LEX_CREATION
    lex.read()
    clients()
    IF lex.last=LEX_IDENT
      WHILE TRUE
        IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
        f:=class.find_feature(lex.ident)
        IF f=NIL THEN Raise(ER_VGCP3)
        lex.read()
        IF f.is_procedure()=FALSE THEN Raise(ER_VGCP3)
        r:=f
        r.as_creator(class,client)
        EXIT lex.last<>","
        lex.read()
      ENDWHILE
    ENDIF
  ENDWHILE
ENDPROC

-> Features (pass 2)
PROC features2()
  WHILE lex.last=LEX_FEATURE
    lex.read()
    clients()
    WHILE (lex.last=LEX_FROZEN) OR (lex.last=LEX_IDENT)
      feature_declaration2()
      IF lex.last=";" THEN lex.read()
    ENDWHILE
  ENDWHILE
ENDPROC

-> Feature_declaration (pass 2)
PROC feature_declaration2()
  DEF arity
  DEF label
  IF lex.last=LEX_FROZEN THEN lex.read()
  IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
  f:=class.find_feature(lex.ident)
  lex.read()
  arity:=formal_arguments2()
  IF lex.last=":"
    lex.read()
    type()
  ENDIF
  IF f.is_constant()
    IF lex.last<>LEX_IS THEN Raise(ER_SYNTAX)
    lex.read()
    lex.read()
  ELSEIF f.is_variable()
  ELSEIF f.is_routine()
    IF lex.last<>LEX_IS THEN Raise(ER_SYNTAX)
    lex.read()
    reg:=1
    routine:=f
    label:=IF routine.is_deferred() THEN 1 ELSE gl.next()
    class.link_routine(routine.vector(),label)
    IF routine.is_deferred()=FALSE THEN
      code.ame(I_ROUTINE,M_LABEL,label,R_NONE)
    obsolete()
    precondition()
    IF routine.is_deferred()
      deferred()
    ELSE
      local_declarations2()
      effective2()
      code.ame(I_ENDROUTINE,M_IMMEDIATE,arity,R_NONE)
      routine.wipe_out_locals()
    ENDIF
    ll.reset()
  ENDIF
ENDPROC

-> Precondition (pass 1, pass 2)
PROC precondition()
  IF lex.last=LEX_REQUIRE
    lex.read()
    IF lex.last=LEX_ELSE THEN lex.read()
  ENDIF
ENDPROC

-> Postcondition (pass 1, pass 2)
PROC postcondition()
  IF lex.last=LEX_ENSURE
    lex.read()
    IF lex.last=LEX_THEN THEN lex.read()
  ENDIF
ENDPROC

-> Rescue (pass 2)
PROC rescue()
  IF lex.last=LEX_RESCUE
    lex.read()
  ENDIF
ENDPROC

-> Local_declarations (pass 1)
PROC local_declarations1()
  IF lex.last=LEX_LOCAL
    lex.read()
    WHILE lex.last=LEX_IDENT
      WHILE TRUE
        IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
        lex.read()
        EXIT lex.last<>","
        lex.read()
      ENDWHILE
      IF lex.last<>":" THEN Raise(ER_SYNTAX)
      lex.read()
      type()
      IF lex.last=";" THEN lex.read()
    ENDWHILE
  ENDIF
ENDPROC

-> Local_declarations (pass 2)
PROC local_declarations2()
  DEF result:PTR TO local
  IF routine.is_function()
    NEW result.create('result')
    result.set_type(routine.type)
    routine.add_local(result)
  ENDIF
  IF lex.last=LEX_LOCAL
    lex.read()
    WHILE lex.last=LEX_IDENT
      new_local2()
      IF lex.last=";" THEN lex.read()
    ENDWHILE
  ENDIF
  IF routine.local_entities() THEN
    code.ame(I_LOCALS,M_IMMEDIATE,routine.local_entities(),R_NONE)
ENDPROC

-> Multiple local entity declaration
PROC new_local2()
  DEF newlocal:PTR TO local
  IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
  IF class.find_feature(lex.ident) THEN Raise(ER_VRLE1)
  IF routine.find_argument(lex.ident) THEN Raise(ER_VRLE2)
  IF routine.find_local(lex.ident) THEN Raise(ER_VREG)
  NEW newlocal.create(lex.ident)
  lex.read()
  routine.add_local(newlocal)
  IF lex.last=","
    lex.read()
    newlocal.set_type(new_local2())
  ELSE
    IF lex.last<>":" THEN Raise(ER_SYNTAX)
    lex.read()
    newlocal.set_type(type())
  ENDIF
ENDPROC newlocal.type

-> Effective (pass 1)
PROC effective1()
  DEF last
  LOOP
    last:=lex.last
    lex.read()
    SELECT last
    CASE LEX_IF
      effective1()
    CASE LEX_INSPECT
      effective1()
    CASE LEX_FROM
      effective1()
    CASE LEX_DEBUG
      effective1()
    CASE LEX_END
      RETURN
    CASE LEX_EOF
      Raise(ER_SYNTAX)
    CASE "!"
      IF lex.last=LEX_IDENT THEN type()
      IF lex.last<>"!" THEN Raise(ER_SYNTAX)
      lex.read()
    ENDSELECT
  ENDLOOP
ENDPROC

-> Effective (pass 2)
PROC effective2()
  IF lex.last<>LEX_DO THEN Raise(ER_SYNTAX)
  lex.read()
  WHILE TRUE
    EXIT lex.last=LEX_ENSURE
    EXIT lex.last=LEX_RESCUE
    EXIT lex.last=LEX_END
    instruction()
  ENDWHILE
  postcondition()
  rescue()
  IF lex.last<>LEX_END THEN Raise(ER_SYNTAX)
  lex.read()
ENDPROC

-> Deferred (pass 2)
PROC deferred()
  IF lex.last<>LEX_DEFERRED THEN Raise(ER_SYNTAX)
  lex.read()
  IF lex.last=LEX_ENSURE THEN lex.read()
  IF lex.last<>LEX_END THEN Raise(ER_SYNTAX)
  lex.read()
ENDPROC


-> Instruction
PROC instruction()
  DEF last
  last:=lex.last
  SELECT last
  CASE LEX_CHECK
    lex.read()
    IF lex.last<>LEX_END THEN Raise(ER_SYNTAX)
    lex.read()
  CASE LEX_DEBUG
    lex.read()
    Raise(ER_NOT_IMPLEMENTED)
  CASE LEX_IF
    lex.read()
    conditional()
  CASE LEX_INSPECT
    lex.read()
    Raise(ER_NOT_IMPLEMENTED)
  CASE LEX_FROM
    lex.read()
    loop()
  CASE LEX_RETRY
    lex.read()
    Raise(ER_NOT_IMPLEMENTED)
  CASE "!"
    lex.read()
    creation()
  CASE LEX_IDENT
    assignment_or_call()
  CASE ";"
    lex.read()
  DEFAULT
    Raise(ER_SYNTAX)
  ENDSELECT
ENDPROC

-> Creation
PROC creation()
  DEF creation_type=NIL:PTR TO class
  IF lex.last=LEX_IDENT THEN creation_type:=type()
  IF lex.last<>"!" THEN Raise(ER_SYNTAX)
  lex.read()
  IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
  IF e:=routine.find_local(lex.ident)
  ELSEIF e:=class.find_feature(lex.ident)
    IF e.access()<>M_ATTRIBUT THEN Raise(ER_SYNTAX)
  ELSE
    Raise(ER_SYNTAX)
  ENDIF
  result:=e.type.base()
  IF creation_type
    IF creation_type.is_heir_of(result)=FALSE THEN Raise(ER_VGCC3)
    result:=creation_type
  ENDIF
  lex.read()
  code.ame(I_CREATE,result.access(),result.index(),R_NONE)
  code.ame(I_ASSIGN,e.access(),e.index(),0)
  IF result.has_creators
    IF lex.last<>"." THEN Raise(ER_VGCC5)
    lex.read()
    code.ame(I_CURRENT,M_REGISTER,0,R_NONE)
    IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
    f:=result.find_feature(lex.ident)
    IF f=NIL THEN Raise(ER_VGCC5)
    lex.read()
    IF f.is_procedure()=FALSE THEN Raise(ER_VGCC6)
    r:=f
    IF r.is_creator(result,class)=FALSE THEN Raise(ER_VGCC6)
    e:=r
    call()
  ELSEIF lex.last="."
    Raise(ER_VGCC4)
  ENDIF
ENDPROC

-> Assignment or Call
PROC assignment_or_call()
  IF e:=routine.find_argument(lex.ident)
  ELSEIF e:=routine.find_local(lex.ident)
  ELSEIF e:=class.find_feature(lex.ident)
  ELSE
    Raise(ER_SYNTAX)
  ENDIF
  lex.read()
  IF lex.last=":="
    lex.read()
    IF e.access()=M_ARG THEN Raise(ER_SYNTAX)
    assignment()
  ELSE
    call()
    IF result THEN Raise(ER_VKCN)
  ENDIF
ENDPROC

-> Assignment
PROC assignment()
  DEF e2:PTR TO entity
  e2:=e
  expression()
  IF result=NIL THEN Raise(ER_VKCN)
  IF result.is_heir_of(e2.type.base())=FALSE THEN Raise(ER_VJAR)
  code.ame(I_ASSIGN,e2.access(),e2.index(),reg)
ENDPROC

-> Call
PROC call()
  DEF regs=1
  DEF pointed=FALSE
  DEF oldcurrent
  oldcurrent:=current.base()
  LOOP
    IF e.vector()
      r:=e
      IF reg>1
        code.ame(I_PUSHREGS,M_IMMEDIATE,reg-1,R_NONE)
        regs:=reg
        reg:=1
      ENDIF
      IF r.arguments
        actuals()
      ELSEIF lex.last="("
        Raise(ER_VUAR1)
      ENDIF
      code.ame(I_CALL,M_ROUTINE,e.vector(),R_NONE)
      IF regs>1
        code.ame(I_POPREGS,M_IMMEDIATE,reg-1,R_NONE)
        reg:=regs
      ENDIF
    ENDIF
    IF lex.last="."
      lex.read()
      pointed:=TRUE
      IF e.type=NIL THEN Raise(ER_VUEX1)
      result:=e.type.base()
      IF result.is_kernel_class() THEN Raise(ER_VUEX1)
      code.ame(I_CURRENT,e.access(),e.index(),R_NONE)
      IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
      f:=result.find_feature(lex.ident)
      IF f=NIL THEN Raise(ER_VUEX1)
      lex.read()
      IF class.is_heir_of(f.client)=FALSE THEN Raise(ER_VUEX2)
      current.set(result)
      e:=f
    ELSE
      IF e.access()<>M_NONE THEN
        code.ame(I_CALL,e.access(),e.index(),reg)
      result:=IF e.type THEN e.type.base() ELSE NIL
      current.set(oldcurrent)
      IF pointed THEN code.ame(I_CURRENT,M_CURRENT,R_NONE,R_NONE)
      RETURN
    ENDIF
  ENDLOOP
ENDPROC

-> Actuals
PROC actuals()
  DEF arg:PTR TO argument
  DEF oldcurrent
  DEF old_e
  old_e:=e
  oldcurrent:=current.base()
  arg:=r.arguments
  IF lex.last<>"(" THEN Raise(ER_VUAR1)
  lex.read()
  WHILE TRUE
    current.set(class)
    expression()
    IF result=NIL THEN Raise(ER_VKCN)
    current.set(oldcurrent)
    IF result.is_heir_of(arg.type.base())=FALSE THEN Raise(ER_VUAR2)
    code.ame(I_PUSH,M_REGISTER,reg,R_NONE)
    arg:=arg.next
    EXIT arg=NIL
    EXIT lex.last<>","
    lex.read()
  ENDWHILE
  IF arg THEN Raise(ER_VUAR1)
  IF lex.last<>")" THEN Raise(ER_VUAR1)
  lex.read()
  e:=old_e
ENDPROC

-> Conditional
PROC conditional()
  DEF last,lab1,lab2
  expression()
  IF result<>boolean_class THEN Raise(ER_VWBE)
  IF lex.last<>LEX_THEN THEN Raise(ER_SYNTAX)
  lex.read()
  code.ame(I_JFALSE,M_LABEL,lab1:=ll.next(),R_NONE)
  lab2:=ll.next()
  LOOP
    last:=lex.last
    SELECT last
    CASE LEX_ELSEIF       -> multiple ELSEIFs
      lex.read()
      code.ame(I_JALWAYS,M_LABEL,lab2,R_NONE)
      code.ame(I_LABEL,M_LABEL,lab1,R_NONE)
      expression()
      IF result<>boolean_class THEN Raise(ER_VWBE)
      IF lex.last<>LEX_THEN THEN Raise(ER_SYNTAX)
      lex.read()
      code.ame(I_JFALSE,M_LABEL,lab1:=ll.next(),R_NONE)
    CASE LEX_ELSE         -> single ELSE
      lex.read()
      code.ame(I_JALWAYS,M_LABEL,lab2,R_NONE)
      code.ame(I_LABEL,M_LABEL,lab1,R_NONE)
      WHILE lex.last<>LEX_END DO instruction()
      lex.read()
      code.ame(I_LABEL,M_LABEL,lab2,R_NONE)
      RETURN
    CASE LEX_END
      lex.read()
      code.ame(I_LABEL,M_LABEL,lab1,R_NONE)
      code.ame(I_LABEL,M_LABEL,lab2,R_NONE)
      RETURN
    DEFAULT
      instruction()
    ENDSELECT
  ENDLOOP
ENDPROC

-> Loop
PROC loop()
  DEF lab,lab2
  WHILE TRUE
    EXIT lex.last=LEX_INVARIANT
    EXIT lex.last=LEX_VARIANT
    EXIT lex.last=LEX_UNTIL
    instruction()
  ENDWHILE
  IF lex.last=LEX_INVARIANT THEN lex.read()
  IF lex.last=LEX_VARIANT THEN lex.read()
  IF lex.last<>LEX_UNTIL THEN Raise(ER_SYNTAX)
  lex.read()
  code.ame(I_LABEL,M_LABEL,lab:=ll.next(),R_NONE)
  expression()
  IF result<>boolean_class THEN Raise(ER_VWBE)
  code.ame(I_JTRUE,M_LABEL,lab2:=ll.next(),R_NONE)
  IF lex.last<>LEX_LOOP THEN Raise(ER_SYNTAX)
  lex.read()
  WHILE lex.last<>LEX_END DO instruction()
  lex.read()
  code.ame(I_JALWAYS,M_LABEL,lab,R_NONE)
  code.ame(I_LABEL,M_LABEL,lab2,R_NONE)
ENDPROC

-> From  here  syntax  is  no more from B. Meyer's book "Eiffel:The Language"
-> Because  standard  Eiffel  syntax  doesn't  handle operators priorities we
-> define  our own equivalent LL(1) syntax for Eiffel Expressions. This could
-> be  avoided  with  the  use  of  Yacc  or Bison parser generator but LL(1)
-> parsing  is  a much more concise and human-readeable approach and anyway I
-> have  access to a pascal Yacc version but not to an Oberon one. Moreover I
-> have  only little experience with Yacc especially in multi pass compilers,
-> I  have  never  seen  compiler  sources  making  extensive  use  of it and
-> therefore   I   wonder   about   its   suitability.  Interactive  Software
-> Engineering's  2.2  compiler used Lex and Yacc tools so I guess I am wrong
-> and  I  will  use  them in future as soon as I am enthousiastic. Up to now
-> LL(1) seems not to be an expensive overload.

-> Expression ::= Implies
PROC expression()
  implies()
ENDPROC

-> Implies ::= Or { implies Or }
PROC implies()
  DEF shortcut=0
  DEF branch
  or()
  LOOP
    IF lex.last=LEX_IMPLIES
      lex.read()
      IF shortcut=0 THEN shortcut:=ll.next()
      code.ame(I_JFALSE,M_LABEL,shortcut,R_NONE)
      or()
    ELSE
      IF shortcut
        code.ame(I_JALWAYS,M_LABEL,branch:=ll.next(),R_NONE)
        code.ame(I_LABEL,M_LABEL,shortcut,R_NONE)
        code.ame(I_CALL,M_TRUE,R_NONE,reg)
        code.ame(I_LABEL,M_LABEL,branch,R_NONE)
      ENDIF
      RETURN
    ENDIF
  ENDLOOP
ENDPROC

-> Or ::= And { ( or [else] | xor ) And }
PROC or()
  DEF shortcut=0
  DEF last
  and()
  LOOP
    last:=lex.last
    SELECT last
    CASE LEX_OR
      lex.read()
      IF lex.last=LEX_ELSE
        lex.read()
        IF shortcut=0 THEN shortcut:=ll.next()
        code.ame(I_JTRUE,M_LABEL,shortcut,R_NONE)
        and()
      ELSE
        INC reg
        IF result<>boolean_class THEN Raise(ER_VWBE)
        and()
        IF result<>boolean_class THEN Raise(ER_VWBE)
        DEC reg
        code.ame(I_OR,M_REGISTER,reg+1,reg)
      ENDIF
    CASE LEX_XOR
      lex.read()
      INC reg
      IF result<>boolean_class THEN Raise(ER_VWBE)
      and()
      IF result<>boolean_class THEN Raise(ER_VWBE)
      DEC reg
      code.ame(I_XOR,M_REGISTER,reg+1,reg)
    DEFAULT
      IF shortcut THEN code.ame(I_LABEL,M_LABEL,shortcut,R_NONE)
      RETURN
    ENDSELECT
  ENDLOOP
ENDPROC

-> And ::= Comparator {and [then] Comparator }
PROC and()
  DEF shortcut=0
  comparator()
  IF lex.last<>LEX_AND THEN RETURN
  IF result<>boolean_class THEN Raise(ER_VWBE)
  LOOP
    IF lex.last<>LEX_AND
      IF shortcut THEN code.ame(I_LABEL,M_LABEL,shortcut,R_NONE)
      RETURN
    ENDIF
    lex.read()
    IF lex.last=LEX_THEN
      lex.read()
      IF shortcut=0 THEN shortcut:=ll.next()
      code.ame(I_JFALSE,M_LABEL,shortcut,R_NONE)
      comparator()
    ELSE
      INC reg
      comparator()
      IF result<>boolean_class THEN Raise(ER_VWBE)
      DEC reg
      code.ame(I_AND,M_REGISTER,reg+1,reg)
    ENDIF
  ENDLOOP
ENDPROC

-> Comparator ::= Simple (= | /= | >= | <= | > | <) Simple
PROC comparator()
  DEF source:PTR TO class,last,id
  simple()
  source:=result
  last:=lex.last
  SELECT last
  CASE "="
    lex.read()
    INC reg
    IF source=NIL THEN Raise(ER_VKCN)
    simple()
    IF result=NIL THEN Raise(ER_VKCN)
    IF source.is_heir_of(result)=FALSE THEN
      IF result.is_heir_of(source)=FALSE THEN Raise(ER_VWEQ)
    DEC reg
    code.ame(I_EQUAL,M_REGISTER,reg+1,reg)
    result:=boolean_class
    RETURN
  CASE "/="
    lex.read()
    INC reg
    IF source=NIL THEN Raise(ER_VKCN)
    simple()
    IF result=NIL THEN Raise(ER_VKCN)
    IF source.is_heir_of(result)=FALSE THEN
      IF result.is_heir_of(source)=FALSE THEN Raise(ER_VWEQ)
    DEC reg
    code.ame(I_NOTEQUAL,M_REGISTER,reg+1,reg)
    result:=boolean_class
    RETURN
  CASE ">="
    id:=I_NOTLESS
  CASE "<="
    id:=I_NOTGREATER
  CASE ">"
    id:=I_GREATERTHAN
  CASE "<"
    id:=I_LESSTHAN
  DEFAULT
    RETURN
  ENDSELECT
  lex.read()
  IF source<>integer_class THEN
    IF source<>character_class THEN Raise(ER_SYNTAX)
  INC reg
  simple()
  IF result<>source THEN Raise(ER_SYNTAX)
  DEC reg
  code.ame(id,M_REGISTER,reg+1,reg)
  result:=boolean_class
ENDPROC

-> Simple ::= Term { ( - | + ) Term }
PROC simple()
  DEF last,id
  term()
  LOOP
    last:=lex.last
    SELECT last
    CASE "+"
      id:=I_ADD
    CASE "-"
      id:=I_SUB
    DEFAULT
      RETURN
    ENDSELECT
    lex.read()
    INC reg
    IF result<>integer_class THEN Raise(ER_SYNTAX)
    term()
    IF result<>integer_class THEN Raise(ER_SYNTAX)
    DEC reg
    code.ame(id,M_REGISTER,reg+1,reg)
  ENDLOOP
ENDPROC

-> Term ::= Factor { ( * | / | \\ ) Factor }
PROC term()
  DEF last,id
  factor()
  LOOP
    last:=lex.last
    SELECT last
    CASE "*"
      id:=I_MUL
    CASE "//"
      id:=I_DIV
    CASE "\\\\"
      id:=I_MOD
    DEFAULT
      RETURN
    ENDSELECT
    lex.read()
    INC reg
    IF result<>integer_class THEN Raise(ER_SYNTAX)
    factor()
    IF result<>integer_class THEN Raise(ER_SYNTAX)
    DEC reg
    code.ame(id,M_REGISTER,reg+1,reg)
  ENDLOOP
ENDPROC

-> Factor ::= (not | + | -) Expression | "(" Expression ")"
PROC factor()
  DEF last
  last:=lex.last
  SELECT last
  CASE LEX_VOID
    lex.read()
    code.ame(I_CALL,M_VOID,R_NONE,reg)
    result:=none_class
  CASE LEX_NUMERAL
    code.ame(I_CALL,M_IMMEDIATE,lex.value,reg)
    lex.read()
    result:=integer_class
  CASE LEX_STR
    code.ame(I_CREATE,string_class.access(),string_class.index(),R_NONE)
    code.ame(I_CALL,M_STRING,lex.ident,R_NONE)
    code.ame(I_CALL,M_REGISTER,0,reg)
    lex.read()
    result:=string_class
  CASE LEX_CHAR
    code.ame(I_CALL,M_IMMEDIATE,lex.value,reg)
    lex.read()
    result:=character_class
  CASE LEX_TRUE
    code.ame(I_CALL,M_TRUE,R_NONE,reg)
    lex.read()
    result:=boolean_class
  CASE LEX_FALSE
    code.ame(I_CALL,M_FALSE,R_NONE,reg)
    lex.read()
    result:=boolean_class
  CASE LEX_NOT
    lex.read()
    expression()
    IF result<>boolean_class THEN Raise(ER_SYNTAX)
    code.ame(I_NOT,M_NONE,R_NONE,reg)
  CASE "+"
    lex.read()
    factor()
    IF result<>integer_class THEN Raise(ER_SYNTAX)
  CASE "-"
    lex.read()
    factor()
    IF result<>integer_class THEN Raise(ER_SYNTAX)
    code.ame(I_NEG,M_NONE,R_NONE,reg)
  CASE "("
    lex.read()
    expression()
    IF lex.last<>")" THEN Raise(ER_SYNTAX)
    lex.read()
  DEFAULT
    IF lex.last=LEX_CURRENT
      lex.read()
      IF lex.last="."
        lex.read()
        f:=class.find_feature(lex.ident)
        IF f=NIL THEN Raise(ER_VUEX1)
        IF class.is_heir_of(f.client)=FALSE THEN Raise(ER_VUEX2)
        lex.read()
        e:=f
        call()
        RETURN
      ELSE
        code.ame(I_CALL,M_CURRENT,R_NONE,reg)
        result:=class
        RETURN
      ENDIF
    ENDIF
    IF lex.last<>LEX_IDENT THEN Raise(ER_SYNTAX)
    IF e:=routine.find_local(lex.ident)
      lex.read()
      call()
      RETURN
    ENDIF
    IF e:=routine.find_argument(lex.ident)
      lex.read()
      call()
      RETURN
    ENDIF
    e:=class.find_feature(lex.ident)
    IF e=NIL THEN Raise(ER_VEEN)
    lex.read()
    call()
  ENDSELECT
ENDPROC

