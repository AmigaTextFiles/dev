/****** library/--background-- ******************************************

    PURPOSE
        Basic implementation of the Library object.

    CREATION
        back in Februaray of 1995 by Gregor Goldbach

    HISTORY
        Joseph E. van Riper III overworked everything a bit.

    SEE ALSO
        library/device

******************************************************************************

History


*/
OPT MODULE
OPT EXPORT

MODULE 'oomodules/object'

OBJECT library OF object
/****** library/--library-- ******************************************

    NAME
         library

    ATTRIBUTES
         libName -- the name of the library

         version -- version of the library. 33 is v1.2 of the AmigaOS,
         37 is OS2.04, 39 is OS3.0, 40 is OS3.1

    CREATION
         back in February of 1995 by Gregor Goldbach

    HISTORY
         JEVR3 changes; removed 'base', included 'name' and 'version',
         now included in the 'oomodules' hierarchy.
******************************************************************************

History


*/
 identifier
 version
ENDOBJECT

PROC select(opts,i) OF library
/****** library/select ******************************************

    NAME
        select -- selection of actions via taglist

    SYNOPSIS
        library.select()

    FUNCTION
        Select an action for this object upon initialization. See
        documentation of Object's new() and select.

        These items are recognized:
          "name" -- next item is library name

          "ver" -- next item is library version

    INPUTS
        opts -- Optionslist

        i -- index of optionlist

******************************************************************************

History


*/
DEF item

  item:=ListItem(opts,i)

  SELECT item

    CASE "name"

    INC i
    self.identifier:=ListItem(opts,i)

    CASE "ver"

    INC i
    self.version:=ListItem(opts,i)

  ENDSELECT

ENDPROC i

PROC open() OF library IS self.derivedClassResponse()
/****** library/open ******************************************

    NAME
        open() -- Open the library

    SYNOPSIS
        library.open()

    FUNCTION
        
        Open the library. Not functional in this basic object, the
        derived objects have to take care of that.

******************************************************************************

History


*/

PROC close() OF library IS self.derivedClassResponse()
/****** library/close ******************************************

    NAME
        close() -- Close the library

    SYNOPSIS
        library.close()

    FUNCTION
        Close the library. Not functional in this basic object, the
        derived objects have to take care of that.

******************************************************************************

History


*/

PROC end() OF library
/****** library/end ******************************************

    NAME
        end() -- Free resources.

    SYNOPSIS
        library.end()

    FUNCTION
        Frees all resources used by this object. Automatically called
        when ENDing the object.

    NOTES
        JEVR3 addition; seemed logical to make 'end()' close() the library.

******************************************************************************

History


*/

 self.close()
ENDPROC
/*EE folds
-1
143 23 
EE folds*/
