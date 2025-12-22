/****** object/--background-- ******************************************

    PURPOSE
        The base object for everything in the oomodules/ hierarchy.

    CREATION
        in early 1995 by Trey van Riper

    HISTORY

******************************************************************************

History


*/

OPT MODULE
OPT EXPORT,PREPROCESS

#define LOCALE_SUPPORT 1


MODULE  'other/stderr'

#ifdef LOCALE_SUPPORT

MODULE  'oomodules/library/locale/catalogList',
        'oomodules/old'

EXPORT DEF catalogList:PTR TO catalogList

#endif


OBJECT object
/****** object/--object-- ******************************************

    NAME
        object

    NOTES
        The Object object (hmm.. sounds redundant) has no attributes, and
        tons of methods.

        We may decide to create one or two very important global variables
        in the future.  These variables will hold information on various
        system settings which will allow a smoother halt() and some other
        handy functions.  At the moment, though, no global variables exist
        in the Object module.

******************************************************************************

History


*/
ENDOBJECT

PROC new(opts=0) OF object
/****** object/new ******************************************

    NAME
        new() -- Create a new instance of an object.

    SYNOPSIS
        object.new(opts=0)

    FUNCTION
        This allows new instances of objects to be created.  It takes as
        an argument an Amiga E list ['such','as','this'] which is then
        parsed by the opts() method, which places a call to the select()
        method.  My might want to read up on those.

        In general, you will only want to create new select() statements
        for your objects... new() most likely can be left alone.

    INPUTS
        opts=0 -- The optionlist

    EXAMPLE
        When folks go to use objects, they ought to do something like the
        following:

          NEW object.new()

        or if there are options to parse...

          NEW object.new(["boo",'SCREAM'])

    SEE ALSO
        select(), init()
******************************************************************************

History


*/
 /*
  * NEW the global catalog list. Don't do it in init() for it could be needed
  * in there...
  */

#ifdef LOCALE_SUPPORT

  IF catalogList = NIL THEN NEW catalogList.new()

#endif


  self.init()
  self.opts(opts)

ENDPROC

PROC init() OF object IS EMPTY
/****** object/init ******************************************

    NAME
        init() -- Initialize an object.

    SYNOPSIS
        object.init()

    FUNCTION
        Initializes an object to default startup values.  You very likely
        will want to create your own init() method in your derived objects,
        in order to properly initialize your attributes.  This init()
        method does nothing.  If you're not concerned about the internal
        attributes during initialization, then this method can be left
        alone.

    SEE ALSO
        new(), select()
******************************************************************************

History


*/


PROC size() OF object IS 4
/****** object/size ******************************************

    NAME
        size() -- Get the size of the object in bytes

    SYNOPSIS
        object.size()

    FUNCTION
        This returns the SIZEOF the current object.  Most likely, this is
        a superfluous method, and might need to be reconsidered.  In the
        meantime, if you want this method to have any meaning at all, you
        need to calculate the 'SIZEOF' your object either by adding up all
        the attributes and adding four more bytes (for the pointer to its
        methods), or by compiling the object and using ShowModule to see
        the SIZEOF it comes up with.

    RESULT
        The size in bytes

******************************************************************************

History


*/

PROC opts(opts) OF object
/****** object/opts ******************************************

    NAME
        opts() -- Parse options.

    SYNOPSIS
        object.opts(optionlist)

    FUNCTION
        This runs a FOR/ENDFOR loop that calls select().  It's most
        unlikely that you'll need to modify this method. This method
        may disappear in the future (it might be absorbed by new()).

    INPUTS
        optionlist -- The optionlist to parse.

    SEE ALSO
        select(), new()
******************************************************************************

History


*/
 DEF i,next
 IF opts=0 THEN RETURN
 next:=opts
-> REPEAT
  FOR i:=0 TO ListLen(next)-1
   i:=self.select(next,i)
  ENDFOR
->  next:=Next(next)
-> UNTIL next=NIL
ENDPROC

PROC select(opt,i) OF object IS i
/****** object/select ******************************************

    NAME
        select() -- Selection of action on initialization.

    SYNOPSIS
        object.select(optionlist,index)

    FUNCTION
        You'll definately want to create a 'select' statement if you want
        new() to have options enabled.  All select statements should have
        this general format:

        PROC select(optionlist,index) OF myBlowOutObject
        DEF item
          item:=ListItem(optionlist,index)
          SELECT item
            -> various cases and perhaps a default.. could look like this:
            CASE "boo"
           INC index
           self.boo(ListItem(optionlist,index))
          ENDSELECT
        ENDPROC i

        NOTE THE LAST LINE!  If you fail to return i, you could wind up
        with an endless loop!  This would be a bad thing.

    INPUTS
        optionlist -- An elist with tags (or options) that define object
            specific actions.

        index -- Position of item we process next in the list.

    SEE ALSO
        new(), init()
******************************************************************************

History


*/

PROC error(string,number) OF object
/****** object/error ******************************************

    NAME
        error() -- Report error to stderr

    SYNOPSIS
        object.error(string,number)

    FUNCTION
        This calles err_WriteF(a,b) as it stands, and returns NIL. You may
        want to overload this behavior to do something else, or perhaps
        call this from within your own error() routine via SUPER.  The
        err_WriteF() procedure was written by Joseph E. Van Riper III as
        an easy kind of standard error port for Amiga E... it should be
        found in the emodules:other directory of your structure. If you
        don't have it, you can get it from aminet:dev/e.

        If err_WriteF() is ever called, the programmer must end hir main()
        program with 'err_Dispose()' before exiting.  This is due to
        certain housekeeping matters in Van Riper's StdErr port.

    INPUTS
        string -- String to report.

******************************************************************************

History


*/
 err_WriteF(string,[number])
 RETURN NIL
ENDPROC

PROC name() OF object IS 'Object'
/****** object/name ******************************************

    NAME
        name() -- Get the name of the object.

    SYNOPSIS
        object.name()

    FUNCTION
        This method should be overloaded for each new class.  It should
        return a short string of the name of the object.  In the object
        Object, it's called 'Object'.  This is useful for trying to track
        down certain internal things in the system (particularly some of
        the really funky stuff in the Numbers hierarchy).

    RESULT
        A string with the name of the object.

******************************************************************************

History


*/

PROC end() OF object IS EMPTY
/****** object/end ******************************************

    NAME
        end() -- Global destructor.

    SYNOPSIS
        object.end()

    FUNCTION
        This is the automatic deallocator.  Whenever an object is ENDed,
        this will be called.  While the Object's end() statement does
        nothing, other objects in the hierarchy may be doing some kind
        of housekeeping before deallocating the object.  If you do not
        know whether or not your parent object needs to do some kind of
        housekeeping, do a SUPER self.end() somewhere within your own
        end() statement (if you even need an end() statement).

    SEE ALSO
        new()
******************************************************************************

History


*/

PROC derivedClassResponse() OF object
/****** object/derivedClassResponse ******************************************

    NAME
        derivedClassResponse() -- Standard proc for derived responsibility.

    SYNOPSIS
        object.derivedClassResponse()

    FUNCTION
        Call this proc in a method that is non-functional by now, but is
        functional in objects that derive from this. It writes a message
        to stdout that tells that this method isn't implemented.

******************************************************************************

History


*/
DEF msg:PTR TO CHAR

#ifdef LOCALE_SUPPORT

  IF catalogList

    catalogList.setCurrentCatalog(NIL,OLDC_OBJECT, OLDL_ENGLISH)
    msg := catalogList.getString(OLDM_OBJECT_DERIVED_RESPONSE, 'Method not implemented for this derived class')

  ELSE
#endif
    msg := 'Method not implemented for this derived class'
#ifdef LOCALE_SUPPORT
  ENDIF
#endif


  WriteF('\s:\s\n',self.name(), msg)

ENDPROC

PROC halt(i) OF object
/****** object/halt ******************************************

    NAME
        halt() -- Stop program execution immediately.

    SYNOPSIS
        object.halt(i)

    FUNCTION
        This is intended to stop the entire program dead in its tracks.
        Use this with extreme prejudice, as it doesn't bother to
        deallocate anything (yet), and will likely leave filehandles
        open or memory allocated or any of a hundred other horrible
        system-unfriendly things (it calls CleanUp()).

        In the future, this statement will likely be used to Raise() an
        exception rather than die.

    INPUTS
        i -- Anything you like. Passed to CleanUp().

******************************************************************************

History


*/
 CleanUp(i)
ENDPROC

PROC sameAs(a:PTR TO object) OF object IS IF a.name() = self.name() THEN TRUE ELSE FALSE
/****** object/sameAs ******************************************

    NAME
        sameAs() -- Compare to another object.

    SYNOPSIS
        object.sameAs(obj:PTR TO object)

    FUNCTION
        This method determines whether or not the current object is the
        same kind of object as the parameter object.  obj is assumed to
        be in the Object heirarchy at some point. Basically, this simply
        compares self.name() to a.name() to see if it's the same value.

    INPUTS
        obj:PTR TO object -- Pointer to any object in the oomodules/
            hierarchy.

    RESULT
        TRUE if both objects are the same, FALSE if not.

******************************************************************************

History


*/

PROC differentFrom(a) OF object IS self.derivedClassResponse()
/****** object/differentFrom ******************************************

    NAME
        differentFrom() -- Are the objects not of the same kind?

    SYNOPSIS
        object.differentFrom(obj)

    FUNCTION
        This method determines whether or not the current object is a
        different kind of object from the parameter object.  obj is
        assumed to be in the Object heirarchy at some point.

    INPUTS
        obj -- Pointer to any object in the oomodules/ hierarchy.

    RESULT
        TRUE if objects are different, FALSE if the same.

    NOTES
        Doesn't do anything by now, derived objects have to handle this.

******************************************************************************

History


*/

PROC update(a=0) OF object IS self.derivedClassResponse()
/****** object/update ******************************************

    NAME
        update() -- Update the object.

    SYNOPSIS
        object.update(a)

    FUNCTION
        This method currently does nothing, but the idea behind this method
        is to cause the object to update itself (freshen its current
        information, perhaps).

    INPUTS
        a -- Use it as you want.

******************************************************************************

History


*/
