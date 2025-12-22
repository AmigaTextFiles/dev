
-> Copyright © 1995, Guichard Damien.

-> Eiffel classes (top-most language abstraction)

-> Class is the upper Eiffel language abstraction.
-> As genericity is not yet supported classes are also types.
-> The 'is_heir_of' method is the foundation of the conformity management.
-> The inheritance information is flattened into products of prime numbers.
-> Each class has a unique prime number identifier.
-> Then this prime number is multiplied by the prime of it parents.
-> So a class is a parent of another if its prime product divides the other.
-> ANY is a special class with prime_id=1   so every class inherit from ANY
-> NONE is a special class with prime_id=0  so any class is a parent of NONE

-> TO DO :
->   generic classes/types
->   expanded classes/types
->   anchored types
->   multiple inheritance
->   repeated inheritance and selection
->   more stuff for obsolete classes

OPT MODULE

MODULE '*strings'
MODULE '*treed_entity','*entity_tree'
MODULE '*eiffel_lex'
MODULE '*ame','*feature'

-> In a system, a class is either a client or a supplier
-> This dictinction avoid compilation of unused client classes
-> So a CLIENT class is not compiled, whereas a SUPPLIER class MUST be
EXPORT ENUM CLIENT,SUPPLIER

-> Features of all classes are placed in a binary hash tree for quick search
-> Classes still behave as each of them had their own features
DEF features:PTR TO entity_tree

-> Next static link to class routine
DEF static:PTR TO INT

-> class
EXPORT OBJECT class OF treed_entity PUBLIC
  status:CHAR                   -> client/supplier
  is_deferred:CHAR              -> is class deferred?
  has_creators:CHAR             -> has it a creators section?
  lex:PTR TO eiffel_lex         -> lexical analyser
PRIVATE
  variables:INT                 -> number of variable attributs
  routines:INT                  -> number of routines
  to_be_redefined:CHAR          -> number of routines to be redefined
  to_be_effected:CHAR           -> number of routines to be effected
PRIVATE
  parent:PTR TO class           -> parent of this class
  prime_id:LONG                 -> class prime product identifier
  label:INT                     -> class label
  table:PTR TO INT              -> class jump table
ENDOBJECT

-> This is not a kernel class.
PROC is_kernel_class() OF class IS FALSE

-> Base class of the class-type
PROC base() OF class IS self

-> Set class name
PROC set_name(name,prime,label) OF class
  IF features=NIL THEN NEW features
  self.int:=hash(name)
  self.name:=clone(name)
  self.prime_id:=prime
  self.status:=CLIENT
  self.label:=label
ENDPROC

-> Turn class into a supplier if needed
-> Requires the class to named
PROC supplier() OF class
  DEF lex:PTR TO eiffel_lex
  IF self.status=CLIENT
    self.lex:=NEW lex.attach_text(self.name)
    self.status:=SUPPLIER
  ENDIF
ENDPROC

-> Set class as deferred
PROC defer() OF class
  self.is_deferred:=TRUE
ENDPROC

-> ALL following methods require class to be a supplier

-> Add 'parent' to parent list of this class.
PROC add_parent(parent:PTR TO class) OF class
  self.parent:=parent
  self.prime_id:=Mul(self.prime_id,parent.prime_id)
  self.variables:=self.variables+parent.variables
  self.routines:=self.routines+parent.routines
  self.to_be_effected:=self.to_be_effected+parent.to_be_effected
ENDPROC

-> Add a feature to this class.
PROC add_feature(feature:PTR TO feature) OF class
  feature.set_class(self)
  IF feature.is_variable()
    self.variables:=self.variables+1
    feature.set_count(self.variables)
  ENDIF
  IF feature.is_routine()
    self.routines:=self.routines+1
    feature.set_count(self.routines)
  ENDIF
  features.add(feature)
ENDPROC

-> Redeclare a feature of this class.
PROC redeclare_feature(feature:PTR TO feature) OF class
  feature.set_class(self)
  features.add(feature)
ENDPROC

-> Find a feature named 'name' in this class, if possible.
PROC find_feature(name) OF class
  DEF f1:PTR TO feature
  DEF f2=NIL:PTR TO feature
  IF (f1:=features.find(name))=NIL THEN RETURN NIL
  LOOP
    IF self.is_heir_of(f1.class) THEN
      f2:=IF f1.has_final_name() THEN f1 ELSE NIL
    IF (f1:=features.continu(f1,name))=NIL THEN RETURN f2
  ENDLOOP
ENDPROC

-> One feature undefined.
PROC undefine() OF class
  self.to_be_effected:=self.to_be_effected+1
ENDPROC

-> One feature to be redefined.
PROC redefine() OF class
  self.to_be_redefined:=self.to_be_redefined+1
ENDPROC

-> One feature redefined.
PROC redefined() OF class
  self.to_be_redefined:=self.to_be_redefined-1
ENDPROC

-> One feature to be effected.
PROC effecting() OF class
  self.to_be_effected:=self.to_be_effected+1
ENDPROC

-> One deferred feature effected.
PROC effected() OF class
  self.to_be_effected:=self.to_be_effected-1
ENDPROC

-> Prepare class in order to link routines.
PROC prepare_links() OF class
  DEF sup:PTR TO INT
  DEF inf:PTR TO INT
  DEF counter
  IF self.routines
    inf:=NewR(self.routines*SIZEOF INT)
    self.table:=inf
    IF self.parent
      IF sup:=self.parent.table
        FOR counter:=1 TO self.parent.routines
          inf[]++:=sup[]++
        ENDFOR
      ENDIF
    ENDIF
  ENDIF
ENDPROC

-> Are all features redefined?
PROC all_redefined() OF class
ENDPROC self.to_be_redefined=0

-> Are all features effected?
PROC all_effected() OF class
ENDPROC self.to_be_effected=0

-> Link a routine label to class vector.
PROC link_routine(vector,label) OF class
  self.table[vector-1]:=label
ENDPROC

-> Label of first routine, 0 if none.
PROC first_routine() OF class
  IF self.routines=0 THEN RETURN 0
  static:=self.table
ENDPROC static[]++

-> Label of next routine, 0 if none.
PROC next_routine() OF class
  IF static-self.table/SIZEOF INT>=self.routines THEN RETURN 0
ENDPROC static[]++

-> The class has a creators section.
PROC creators_section() OF class
  self.has_creators:=TRUE
ENDPROC

-> Is class a heir of 'other'?
PROC is_heir_of(other:PTR TO class) OF class
  IF other.prime_id=0 THEN RETURN self.prime_id=0  -> NONE conforms to NONE!
ENDPROC Mod(self.prime_id,other.prime_id)=0

-> Entity value access mode
-> Use connected with AME code generation
PROC access() OF class IS M_LABEL

-> Index for access to entity value
-> Use connected with AME code generation
PROC index() OF class IS self.label

-> Use connected with AME code generation
PROC fields() OF class IS self.variables

-> Destructor
PROC end() OF class
  IF self.name THEN DisposeLink(self.name)
  self.lex.end()
ENDPROC

