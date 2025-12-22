
-> Copyright © 1995, Guichard Damien.

-> Eiffel procedures

-> Procedures have their own arguments and local variables.

-> TO DO :
->   more stuff for obsolete routines
->   redefinition to a variable attribute
->   preconditions
->   postconditions
->   once routines
->   external routines

OPT MODULE

MODULE '*strings','*entity_tree'
MODULE '*ame'
MODULE '*class','*feature','*local','*argument'

DEF local_count
DEF locals:PTR TO entity_tree

ENUM NOT_CREATOR,CREATOR

EXPORT OBJECT procedure OF feature
PUBLIC
  arguments:PTR TO argument
PRIVATE
  frozen:CHAR
  deferred:CHAR
  creator:CHAR
  creation_client:PTR TO class
  count:INT
ENDOBJECT

-> Set count of the feature
PROC set_count(count) OF procedure
  self.count:=count
ENDPROC

-> Freeze this feature.
PROC freeze() OF procedure
  self.frozen:=TRUE
ENDPROC

-> Defer this feature.
PROC defer() OF procedure
  self.deferred:=TRUE
ENDPROC

-> Is procedure deferred?
PROC is_deferred() OF procedure
ENDPROC self.deferred

-> Turn this procedure into a creator
PROC as_creator(class:PTR TO class,client) OF procedure
  DEF other:PTR TO procedure
  IF self.class=class
    self.creator:=TRUE
    self.creation_client:=client
  ELSE
    NEW other
    other.name:=self.name
    other.client:=self.client
    other.type:=self.type
    other.arguments:=self.arguments
    other.frozen:=self.frozen
    other.creator:=TRUE
    other.creation_client:=client
    other.count:=self.count
    class.add_feature(other)
  ENDIF
ENDPROC

-> Is this procedure a creator?
PROC is_creator(class:PTR TO class,client:PTR TO class) OF procedure
  IF self.class<>class THEN RETURN FALSE
  IF self.creator=FALSE THEN RETURN FALSE
ENDPROC client.is_heir_of(self.creation_client)

-> Is feature frozen?
PROC is_frozen() OF procedure IS self.frozen

-> Is feature a routine?
PROC is_routine() OF procedure IS TRUE

-> Is feature a procedure?
PROC is_procedure() OF procedure IS TRUE

-> Feature value access mode
PROC access() OF procedure IS M_NONE

-> Vector for routine call
PROC vector() OF procedure IS self.count

-> Add procedure arguments.
PROC add_arguments(arguments:PTR TO argument) OF procedure
  IF locals=NIL THEN NEW locals
  self.arguments:=arguments
ENDPROC

-> Find an argument.
PROC find_argument(name) OF procedure
ENDPROC IF self.arguments THEN self.arguments.find(name) ELSE NIL


-> Add a local.
PROC add_local(local:PTR TO local) OF procedure
  INC local_count
  local.set_count(local_count)
  locals.add(local)
ENDPROC

-> Find a local.
PROC find_local(name) OF procedure
ENDPROC locals.find(name)

-> Local entities.
PROC local_entities() OF procedure
ENDPROC local_count

-> Wipe out locals.
PROC wipe_out_locals() OF procedure
  local_count:=0
  IF locals THEN locals.wipe_out()
ENDPROC

-> Make a copy renamed with 'name'
PROC rename(name) OF procedure
  DEF other:PTR TO procedure
  other:=self.copy()
  other.name:=clone(name)
  other.client:=self.client
  other.type:=self.type
  other.arguments:=self.arguments
  other.frozen:=self.frozen
  other.deferred:=self.deferred
  other.count:=self.count
ENDPROC other

-> Make a copy exported to 'client'
PROC new_exports(client) OF procedure
  DEF other:PTR TO procedure
  other:=self.copy()
  other.name:=self.name
  other.client:=client
  other.type:=self.type
  other.arguments:=self.arguments
  other.frozen:=self.frozen
  other.deferred:=self.deferred
  other.count:=self.count
ENDPROC other

-> Make an undefined copy.
PROC undefine() OF procedure
  DEF other:PTR TO procedure
  other:=self.copy()
  other.name:=self.name
  other.client:=self.client
  other.type:=self.type
  other.arguments:=self.arguments
  other.frozen:=self.frozen
  other.deferred:=TRUE
  other.count:=self.count
ENDPROC other

-> Make a copy redefined with 'client','arguments','type'
PROC redefine(client,arguments,type) OF procedure
  DEF other:PTR TO procedure
  other:=self.copy()
  other.name:=self.name
  other.client:=client
  other.type:=type
  other.arguments:=arguments
  other.count:=self.count
ENDPROC other

-> Is signature conform to procedure signature
PROC is_conform(arguments:PTR TO argument,type:PTR TO class) OF procedure
  DEF p:PTR TO argument
  DEF q:PTR TO argument
  DEF result:PTR TO class
  p:=arguments
  q:=self.arguments
  WHILE TRUE
    EXIT p=NIL
    EXIT q=NIL
    result:=p.type.base()
    IF result.is_heir_of(q.type.base())=FALSE THEN RETURN FALSE
    p:=p.next
    q:=q.next
  ENDWHILE
  IF p THEN RETURN FALSE
  IF q THEN RETURN FALSE
  IF type=NIL THEN RETURN self.type=NIL
  IF self.type=NIL THEN RETURN FALSE
  result:=type.base()
ENDPROC result.is_heir_of(self.type.base())

-> Make a procedure.
PROC copy() OF procedure
  DEF other:PTR TO procedure
ENDPROC NEW other

