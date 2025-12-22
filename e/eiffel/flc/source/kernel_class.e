
-> Copyright © 1995, Guichard Damien.

-> Eiffel basic classes
-> These are special classes with a unique status. All of them belong
-> to so-called fundamental Eiffel classes such as INTEGER, BOOLEAN ...

OPT MODULE
OPT EXPORT

MODULE '*class'

-> kernel_classes
OBJECT kernel_class OF class
ENDOBJECT

-> This is not a kernel class.
PROC is_kernel_class() OF kernel_class IS TRUE

