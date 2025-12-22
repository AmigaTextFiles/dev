-> sortobj.e: An abstract data manipulation class for Amiga E
-> It's written by Trey Van Riper of the Cheese Olfactory Workshop.
OPT MODULE
OPT EXPORT

MODULE 'oomodules/object'

-> This is a totally abstract object to handle comparable objects.

OBJECT sort OF object
ENDOBJECT

-> The following seven functions are comparitive functions for deciding
-> what is greater than, less than, or equal to what.  You'll note that
-> to make all of these work, one only needs to define 'cmp()' in one's
-> own derived object... the rest of these will auto-magically work!

-> lt() means 'less than'.

PROC lt(item:PTR TO sort) OF sort IS IF self.cmp(item)<0 THEN TRUE ELSE FALSE

-> gt() means 'greater than'.

PROC gt(item:PTR TO sort) OF sort IS IF self.cmp(item)>0 THEN TRUE ELSE FALSE

-> et() means 'equal to'.

PROC et(item:PTR TO sort) OF sort IS IF self.cmp(item)=0 THEN TRUE ELSE FALSE

-> le() means 'Less than/Equal to'.

PROC le(item:PTR TO sort) OF sort IS IF self.lt(item) OR self.et(item) THEN TRUE ELSE FALSE

-> ge() means 'Greater than/Equal to'.

PROC ge(item:PTR TO sort) OF sort IS IF self.gt(item) OR self.et(item) THEN TRUE ELSE FALSE

-> ne() means 'Not Equal to'.

PROC ne(item:PTR TO sort) OF sort IS IF self.et(item) THEN FALSE ELSE TRUE

-> cmp() means 'Compare', and will return 1, 0, or -1 depending upon whether
-> the internal item is Less than, Equal to, or Greater than the incoming item.
-> All the other comparative functions above depend upon this one, so don't
-> mess it up <grin>.

PROC cmp(item:PTR TO sort) OF sort IS EMPTY

-> set() merely sets a value.

PROC set(in) OF sort IS EMPTY

-> write() creates a string of an item to print.

PROC write() OF sort IS EMPTY

-> get() returns the item itself (if appropriate).

PROC get() OF sort IS EMPTY

-> name() returns a unique name for the type of object.

PROC name() OF sort IS 'Sort'
