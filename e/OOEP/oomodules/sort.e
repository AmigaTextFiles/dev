-> sortobj.e: An abstract data manipulation class for Amiga E
-> It's written by Trey Van Riper of the Cheese Olfactory Workshop.
OPT MODULE
OPT EXPORT

MODULE 'oomodules/object'

-> This is a totally abstract object to handle comparable objects.

OBJECT sort OF object
/****** sort/--sort-- ******************************************

    NAME
        sort of object

    PURPOSE
        The sort object basically handles sortable objects.  Objects that
        can be sorted in any way (alphanumerically, numerically, category,
        etc) should be derived from Sort. All one should really have to do
        to make their Sort object work is to create a method 'cmp()', per
        below.

    ATTRIBUTES
        None at all.

    NOTES
        The following functions are comparitive functions for deciding what
        is greater than, less than, or equal to what.  You'll note that to
        make all of these work, one only needs to define 'cmp()' in one's
        own derived object... the rest of these will auto-magically work!

******************************************************************************

History


*/
ENDOBJECT


-> lt() means 'less than'.

PROC lt(item:PTR TO sort) OF sort IS IF self.cmp(item)<0 THEN TRUE ELSE FALSE
/****** sort/lt ******************************************

    NAME 
        lt() -- Test if an item is lower than itself.

    SYNOPSIS
        self.lt(item:PTR TO sort)

    FUNCTION
        It tests if the item provided is in some way lower than itself.

    INPUTS
        item:PTR TO sort -- Item to compare to.

    RESULT
        TRUE if item is lower than itself, FALSE otherwise.

    SEE ALSO
        cmp()
******************************************************************************

History


*/

-> gt() means 'greater than'.

PROC gt(item:PTR TO sort) OF sort IS IF self.cmp(item)>0 THEN TRUE ELSE FALSE
/****** sort/gt ******************************************

    NAME 
        lt() -- Test if an item is greater than itself.

    SYNOPSIS
        self.gt(item:PTR TO sort)

    FUNCTION
        It tests if the item provided is in some way greater than itself.

    INPUTS
        item:PTR TO sort -- Item to compare to.

    RESULT
        TRUE if item is greater than itself, FALSE otherwise.

    SEE ALSO
        cmp()
******************************************************************************

History


*/

-> et() means 'equal to'.

PROC et(item:PTR TO sort) OF sort IS IF self.cmp(item)=0 THEN TRUE ELSE FALSE
/****** sort/et ******************************************

    NAME 
        lt() -- Test if an item is equal to itself.

    SYNOPSIS
        self.et(item:PTR TO sort)

    FUNCTION
        It tests if the item provided is the same as itself.

    INPUTS
        item:PTR TO sort -- Item to compare to.

    RESULT
        TRUE if item is the same as itself, FALSE otherwise.

    SEE ALSO
        cmp()
******************************************************************************

History


*/

-> le() means 'Less than/Equal to'.

PROC le(item:PTR TO sort) OF sort IS IF self.lt(item) OR self.et(item) THEN TRUE ELSE FALSE
/****** sort/le ******************************************

    NAME 
        le() -- Test if an item is lower than or equal to itself.

    SYNOPSIS
        self.le(item:PTR TO sort)

    FUNCTION
        It tests if the item provided is in some way lower than or equal
        to itself.

    INPUTS
        item:PTR TO sort -- Item to compare to.

    RESULT
        TRUE if item is lower than or equal to itself, FALSE otherwise.

    SEE ALSO
        cmp()
******************************************************************************

History


*/

-> ge() means 'Greater than/Equal to'.

PROC ge(item:PTR TO sort) OF sort IS IF self.gt(item) OR self.et(item) THEN TRUE ELSE FALSE
/****** sort/ge ******************************************

    NAME 
        ge() -- Test if an item is greater than or equal to itself.

    SYNOPSIS
        self.ge(item:PTR TO sort)

    FUNCTION
        It tests if the item provided is in some way greater than or equal
        to itself.

    INPUTS
        item:PTR TO sort -- Item to compare to.

    RESULT
        TRUE if item is greater than or equal to itself, FALSE otherwise.

    SEE ALSO
        cmp()
******************************************************************************

History


*/

-> ne() means 'Not Equal to'.

PROC ne(item:PTR TO sort) OF sort IS IF self.et(item) THEN FALSE ELSE TRUE
/****** sort/ne ******************************************

    NAME 
        ne() -- Test if an item is not equeal to itself.

    SYNOPSIS
        self.ne(item:PTR TO sort)

    FUNCTION
        It tests if the item provided is not equal to itself.

    INPUTS
        item:PTR TO sort -- Item to compare to.

    RESULT
        TRUE if item is not equal to itself, FALSE otherwise.

    SEE ALSO
        cmp()
******************************************************************************

History


*/

-> cmp() means 'Compare', and will return 1, 0, or -1 depending upon whether
-> the internal item is Less than, Equal to, or Greater than the incoming item.
-> All the other comparative functions above depend upon this one, so don't
-> mess it up <grin>.

PROC cmp(item:PTR TO sort) OF sort IS self.derivedClassResponse()
/****** sort/cmp ******************************************

    NAME 
        cmp() -- Compare an item to itself.

    SYNOPSIS
        self.cmp(item:PTR TO sort)

    FUNCTION
        cmp() means 'Compare', and will return 1, 0, or -1 depending upon
        whether the internal item is Less than, Equal to, or Greater than
        the incoming item. All the other comparative functions above depend
        upon this one, so don't mess it up <grin>.

    INPUTS
        item:PTR TO sort -- Item to compare to.

    RESULT
        -1 -- item is lower than itself
         0 -- item is equal to itself
        +1 -- item is greater than itself

******************************************************************************

History


*/

-> set() merely sets a value.

PROC set(in) OF sort IS self.derivedClassResponse()
/****** sort/set ******************************************

    NAME 
        set() -- Set value of instance.

    SYNOPSIS
        sort.set(objectSpecific)

    FUNCTION
        Set the value of the instance.

    INPUTS
        objectSpecific -- use it as you want.

    NOTES
        Does nothing.

******************************************************************************

History


*/

-> write() creates a string of an item to print.

PROC write() OF sort IS self.derivedClassResponse()
/****** sort/write ******************************************

    NAME 
        write() -- Create printable string from object.

    SYNOPSIS
        sort.write()

    FUNCTION
        Creates a string of an item to print.

    NOTES
        Does nothing.

******************************************************************************

History


*/

-> get() returns the item itself (if appropriate).

PROC get() OF sort IS self.derivedClassResponse()
/****** sort/get ******************************************

    NAME 
        get() -- Get instance value.

    SYNOPSIS
        sort.get()

    FUNCTION
        Gets the instance's value.

    RESULT
        Hopefully the value.

    NOTES
        Does nothing for now.

    SEE ALSO
        set()
******************************************************************************

History


*/

-> name() returns a unique name for the type of object.

PROC name() OF sort IS 'Sort'
/****** sort/name ******************************************

    NAME 
        name() -- Get name of object.

    SYNOPSIS
        sort.name()

    FUNCTION
        Gets the name of the object.

    RESULT
        Pointer to string containing the name.

******************************************************************************

History


*/
/*EE folds
1
10 29 
EE folds*/
