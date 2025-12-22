
-> Copyright © 1995, Guichard Damien.

-> Eiffel entities (most general software-abstraction)

-> The Eiffel language and method is object-oriented, so should be the
-> compiler. This means that the units of the compiler are of the same
-> nature as the units of software development: they are data abstraction too.
-> These are called software-abstractions. Among them, entity is the most
-> general software-abstraction. Any part or construct of the Eiffel language is
-> said to be an entity, classes, features, constant and variable attributes,
-> routines, routine arguments, local entities are all eiffel entities.

OPT MODULE
OPT EXPORT

MODULE '*ame'
MODULE '*class'

OBJECT entity
  name:PTR TO CHAR  -> name of the entity
  type:PTR TO class -> type of the entity
ENDOBJECT

-> Entity value adresse mode
-> Use connected with AME (Abstract Machine for Eiffel)
PROC access() OF entity IS M_NONE

-> Index for access to entity value
-> Use connected with AME (Abstract Machine for Eiffel)
PROC index() OF entity IS 0

-> Vector for routine call
-> Use connected with AME (for routines only)
PROC vector() OF entity IS 0

