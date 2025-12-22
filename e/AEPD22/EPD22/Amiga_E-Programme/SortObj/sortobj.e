-> sortobj.e: An abstract data manipulation class for Amiga E
-> It's written by Trey Van Riper of the Cheese Olfactory Workshop.
OPT MODULE

-> This is a totally abstract object to handle comparable objects.

EXPORT OBJECT sortobj
ENDOBJECT

-> new() is the constructor.  You shouldn't have to create one.  Just make an
-> 'init()' and 'opts()' procedure (if you need them) and use NEW obj.new()
-> whenever you need to instantiate an object.

EXPORT PROC new(opts=0) OF sortobj
 self.init()
 self.opts(opts)
ENDPROC

-> opts() could be useful <grin>.  Allows you to handle various options while
-> invoking 'new()'... such as, perhaps, starting values.

EXPORT PROC opts(opts) OF sortobj IS EMPTY

-> init() sets up starting values for the object.

PROC init() OF sortobj IS EMPTY

-> The following seven functions are comparitive functions for deciding
-> what is greater than, less than, or equal to what.  You'll note that
-> to make all of these work, one only needs to define 'cmp()' in one's
-> own derived object... the rest of these will auto-magically work!

-> lt() means 'less than'.

EXPORT PROC lt(item:PTR TO sortobj) OF sortobj IS IF self.cmp(item)<0 THEN TRUE ELSE FALSE

-> gt() means 'greater than'.

EXPORT PROC gt(item:PTR TO sortobj) OF sortobj IS IF self.cmp(item)>0 THEN TRUE ELSE FALSE

-> et() means 'equal to'.

EXPORT PROC et(item:PTR TO sortobj) OF sortobj IS IF self.cmp(item)=0 THEN TRUE ELSE FALSE

-> le() means 'Less than/Equal to'.

EXPORT PROC le(item:PTR TO sortobj) OF sortobj IS IF self.lt(item) OR self.et(item) THEN TRUE ELSE FALSE

-> ge() means 'Greater than/Equal to'.

EXPORT PROC ge(item:PTR TO sortobj) OF sortobj IS IF self.gt(item) OR self.et(item) THEN TRUE ELSE FALSE

-> ne() means 'Not Equal to'.

EXPORT PROC ne(item:PTR TO sortobj) OF sortobj IS IF self.et(item) THEN FALSE ELSE TRUE

-> cmp() means 'Compare', and will return 1, 0, or -1 depending upon whether
-> the internal item is Less than, Equal to, or Greater than the incoming item.
-> All the other comparative functions above depend upon this one, so don't
-> mess it up <grin>.

EXPORT PROC cmp(item:PTR TO sortobj) OF sortobj IS EMPTY

-> set() merely sets a value.

EXPORT PROC set(in) OF sortobj IS EMPTY

-> write() creates a string of an item to print.

EXPORT PROC write() OF sortobj IS EMPTY

-> get() returns the item itself (if appropriate).

EXPORT PROC get() OF sortobj IS EMPTY

-> id() returns a unique id # for the type of object.

EXPORT PROC id() OF sortobj IS 0   -> the base class has '0' for its ID #.

-> end() is the de-allocator

PROC end() OF sortobj IS EMPTY
