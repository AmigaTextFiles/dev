
-> Copyright © 1995, Guichard Damien.

-> Eiffel functions

-> Functions are very much like procedures except their type is not NIL

-> TO DO :
->   infix and prefix functions

OPT MODULE
OPT EXPORT

MODULE '*ame'
MODULE '*procedure'

OBJECT function OF procedure
ENDOBJECT

-> Make a procedure.
PROC copy() OF function
  DEF other:PTR TO function
ENDPROC NEW other

-> Is feature a procedure?
PROC is_procedure() OF function IS FALSE

-> Is feature a function?
PROC is_function() OF function IS TRUE

-> Feature value access mode
PROC access() OF function IS M_REGISTER

-> Index for access to feature value
PROC index() OF function IS 0

