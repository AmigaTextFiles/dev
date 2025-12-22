
-> Copyright © 1995, Guichard Damien.

-> Eiffel features (most general class element)

-> Design decisions must be discussed here.
-> The is_constant, is_variable, is_routine, ...  methods seem to be in
-> contradiction with polymorphism as the type is directly tested.
-> But most of validity contraints need this information and validity is
-> linked with parsing, not with features. Here is an example, VDRS2:
-> "That feature was not frozen and was not a constant attribute", so we must
-> known wether a feature is frozen or not, even if all kinds of features can
-> not be frozen. We must also check quickly if the feature is a constant.
-> So beeing a constant or beeing frozen is a real feature of features.

-> TODO :
->   unique constants
->   routine redefinition to a variable attribute
->   preconditions
->   postconditions
->   external routines
->   feature merging

OPT MODULE
OPT EXPORT

MODULE '*strings'
MODULE '*treed_entity'
MODULE '*class','*argument'

OBJECT feature OF treed_entity
  class:PTR TO class   -> To be used by 'class' only
  client:PTR TO class  -> Only one client
ENDOBJECT

-> The class in which the feature has been added
-> To be only used by class 'add_feature' method
PROC set_class(class) OF feature
  self.class:=class
ENDPROC

-> Set count of the feature
-> To be only used by class 'add_feature' method
PROC set_count(x) OF feature IS EMPTY

-> Create a feature.
PROC create(name,client,type) OF feature
  self.int:=hash(name)
  self.name:=name
  self.client:=client
  self.type:=type
ENDPROC

-> Freeze this feature.
PROC freeze() OF feature IS EMPTY

-> Is feature frozen?
PROC is_frozen() OF feature IS FALSE

-> Is feature deferred?
PROC is_deferred() OF feature IS FALSE

-> Has feature this final name in the class?
-> Use connected with feature renaming (see unnamer)
PROC has_final_name() OF feature IS TRUE


-> Is feature an attribute?
PROC is_attribute() OF feature IS FALSE

-> Is feature a constant attribute?
PROC is_constant() OF feature IS FALSE

-> Is feature a variable attribute?
PROC is_variable() OF feature IS FALSE

-> Is feature a routine?
PROC is_routine() OF feature IS FALSE

-> Is feature a procedure?
PROC is_procedure() OF feature IS FALSE

-> Is feature a function?
PROC is_function() OF feature IS FALSE


-> Make a copy renamed with 'name'
PROC rename(name) OF feature
ENDPROC

-> Make a copy exported to 'client'
PROC new_exports(client) OF feature
ENDPROC

-> Make an undefined copy.
PROC undefine() OF feature
ENDPROC

-> Make a copy redefined with 'client','arguments','type'
PROC redefine(client,arguments,type) OF feature
ENDPROC

-> Is signature conform to feature signature
PROC is_conform(arguments:PTR TO argument,type:PTR TO class) OF feature
  DEF result:PTR TO class
  IF arguments THEN RETURN FALSE
  IF type=NIL THEN RETURN self.type=NIL
  IF self.type=NIL THEN FALSE
  result:=type.base()
ENDPROC result.is_heir_of(self.type.base())

