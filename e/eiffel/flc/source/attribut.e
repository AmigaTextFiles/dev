
-> Copyright © 1995, Guichard Damien.

-> An attribute is a feature that is not a routine

OPT MODULE
OPT EXPORT

MODULE '*feature','*class'

OBJECT attribut OF feature
ENDOBJECT

-> Is feature an attribute?
PROC is_attribute() OF attribut IS TRUE

