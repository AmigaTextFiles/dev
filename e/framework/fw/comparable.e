
-> This class is very usefull as many objects such as integers and
-> strings are comparable. It will allow to get best benefits from
-> sorted structured such as trees.

-> Copyright © Guichard Damien 01/04/1996

OPT MODULE
OPT EXPORT

MODULE 'fw/storable'

OBJECT comparable OF storable
ENDOBJECT

-> Is object less than other.
PROC isLessThan(other:PTR TO comparable) OF comparable IS EMPTY

-> Is object egal to other.
PROC isEqualTo(other:PTR TO comparable) OF comparable IS self=other

-> Is object greater than other.
PROC isGreaterThan(other:PTR TO comparable) OF comparable IS EMPTY

