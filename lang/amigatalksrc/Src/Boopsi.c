/****h* AmigaTalk/Boopsi.c [3.0] **************************************
*
* NAME 
*   Boopsi.c
*
* DESCRIPTION
*   Functions that handle Boopsi to AmigaTalk primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleBoopsi( int numargs, OBJECT **args ); <238>
*
* HISTORY
*   24-Oct-2004 - Added AmigaOS4 & gcc support.
*   08-Jan-2003 - Moved all string constants to StringConstants.h
*   06-Feb-2002 - Added DoSuperMethodA() function to primitives.
*   05-Feb-2002 - Edited for compilation.
*   27-Dec-2001 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/Boopsi.c 3.0 (24-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <intuition/classusr.h> // for struct Msg.

#include <utility/tagitem.h>

#ifdef    __SASC
# include <clib/intuition_protos.h>
#else

# include <clib/intuition_protos.h>

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>

IMPORT struct ExecIFace      *IExec;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// See TagFuncs.c for these: ------------------------------------------

IMPORT struct TagItem *ArrayToTagList( OBJECT *inArray );

IMPORT void TagListToArray( struct TagItem *tags, OBJECT *tagArray );

IMPORT void ATSetTagItem( OBJECT *theArray, OBJECT *theTag, 
                          OBJECT *theValue 
                        );

IMPORT OBJECT *ATGetTagItem( OBJECT *theArray, OBJECT *theTag );

IMPORT OBJECT *AddTagItem( OBJECT *theArray, OBJECT *theTag, 
                           OBJECT *theValue 
                         );

IMPORT OBJECT *DeleteTagItem( OBJECT *theArray, OBJECT *theTag );

// --------------------------------------------------------------------

/****i* ATDisposeBoopsiObject() [1.9] *********************************
*
* NAME
*    ATDisposeBoopsiObject()  <primitive 238 0 private>
*
* DESCRIPTION
*    Delete a BOOPSI Object (from NewDTObjectA()) from memory.
*
* FUNCTION
*    This function is used to dispose of a data type object that was
*    obtained with NewDTObjectA().
*
* INPUTS
*    o - Pointer to an object as returned by NewDTObjectA().
*        NULL is a valid input.
***********************************************************************
*
*/

#ifndef __amigaos4__
METHODFUNC void ATDisposeBoopsiObject( OBJECT *dtObject )
{
   APTR bp = (APTR) CheckObject( dtObject );
   
   if (NullChk( (OBJECT *) bp ) == FALSE)
      DisposeDTObject( bp );

   return;
}
#endif

/****i* ATNewBoopsiObjectA() [1.9] ************************************
*
* NAME
*    ATNewBoopsiObjectA()
*    ^ private <- <primitive 238 1 iclassObj classIDString tagArray>
*
* DESCRIPTION
*    Create a new BOOPSI Object.
*
* FUNCTION
*    This is the general method of creating objects from 'boopsi' classes.
*    ('Boopsi' stands for "basic object-oriented programming system for
*    Intuition".)
*
*    You specify a class either as a pointer (for a private class) or
*    by its ID string (for public classes).  If the class pointer
*    is NULL, then the classID is used.
*
*    You further specify initial "create-time" attributes for the
*    object via a TagItem list, and they are applied to the resulting
*    generic data object that is returned.  The attributes, their meanings,
*    attributes applied only at create-time, and required attributes
*    are all defined and documented on a class-by-class basis.
*
* INPUTS
*    class   = abstract pointer to a boopsi class gotten via MakeClass().
*    classID = the name/ID string of a public class.  This parameter is
*              only used if 'class' is NULL.
*    tagList = pointer to array of TagItems containing attribute/value
*              pairs to be applied to the object being created
*
* RESULT
*    A boopsi object, which may be used in different contexts such
*    as a gadget or image, and may be manipulated by generic functions.
*    You eventually free the object using DisposeObject().
***********************************************************************
*
*/

METHODFUNC OBJECT *ATNewBoopsiObjectA( OBJECT *iclassObj, char *classID, OBJECT *tagArray )
{
   struct TagItem *tags   = NULL; 
   struct IClass  *iclass = (struct IClass *) CheckObject( iclassObj );
   APTR            rval   = 0; // NULL;

   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );

   if (!tags) // == NULL)
      {
      return( o_nil );
      }
   
   rval = (APTR) NewObjectA( iclass, (CONST_STRPTR) classID, tags );

   if (!rval) // == NULL)
      {
      AT_FreeVec( tags, "NewBoopsiObjectTags", TRUE );
   
      return( o_nil );
      }
      
   AT_FreeVec( tags, "NewBoopsiObjectTags", TRUE );

   return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* ATAddClass() [1.9] ********************************************
*
* NAME
*    ATAddClass() 
*
* DESCRIPTION
*    Add a BOOPSI class to the system.
*    <primitive 238 2 iclassObj>
*
* FUNCTION
*    Adds a public boopsi class to the internal list of classes available
*    for public consumption.
*	
*    You must call this function after you call MakeClass().
*
* INPUTS
*    Class = pointer returned by MakeClass()
*
* BUGS
*    Although there is some protection against creating classes
*    with the same name as an existing class, this function
*    does not do any checking or other dealings with like-named
*    classes.  Until this is rectified, only officially registered
*    names can be used for public classes, and there is no
*    "class replacement" policy in effect.
***********************************************************************
*
*/

METHODFUNC void ATAddClass( OBJECT *iclassPtr )
{
   struct IClass *iclass = (struct IClass *) CheckObject( iclassPtr );
   
   if (!iclass) // == NULL)
      return;
   else
      AddClass( iclass );

   return;
}

/****i* ATRemoveClass() [1.9] *****************************************
*
* NAME
*    ATRemoveClass() <primitive 238 3 iclassObj>
*
* DESCRIPTION
*    Remove a IClass from the system.
*
* FUNCTION
*    Makes a public class unavailable for public consumption.
*    It's OK to call this function for a class which is not
*    yet in the internal public class list, or has been
*    already removed.
*	
* INPUTS
*    ClassPtr = pointer to *public* class created by MakeClass(),
*               may be NULL.
***********************************************************************
*
*/

METHODFUNC void ATRemoveClass( OBJECT *iclassPtr )
{
   struct IClass *iclass = (struct IClass *) CheckObject( iclassPtr );

   if (NullChk( (OBJECT *) iclass ) == TRUE)
      return;
   else
      RemoveClass( iclass );

   return;
}

/****i* ATFreeClass() [1.9] *******************************************
*
* NAME
*    ATFreeClass()
*
* DESCRIPTION
*    ^ <primitive 238 4 iclassObj>
*
* FUNCTION
*    For class implementors only.
*
*    Tries to free a boopsi class created by MakeClass().  This
*    won't always succeed: classes with outstanding objects or
*    with subclasses cannot be freed.  You cannot allow the code
*    which implements the class to be unloaded in this case.
*
*    For public classes, this function will *always* remove
*    the class (see RemoveClass() ) making it unavailable, whether
*    it succeeds or not.
*	
*    If you have a dynamically allocated data for your class (hanging
*    off of cl_UserData), try to free the class before you free the
*    user data, so you don't get stuck with a half-freed class.
*
* INPUTS
*    ClassPtr - pointer to a class created by MakeClass().
*
* RESULT
*    Returns FALSE if the class could not be freed.  Reasons include,
*    but will not be limited to, having non-zero cl_ObjectCount or
*    cl_SubclassCount.
*
*    Returns TRUE if the class could be freed.
*
*    Calls RemoveClass() for the class in either case.
*	
* EXAMPLE
*    Freeing a private class with dynamically allocated user data:
*
*    freeMyClass( struct IClass *cl )
*    {
*       struct MyPerClassData *mpcd;
*
*       mpcd = (struct MyPerClassData *) cl->cl_UserData;
*
*       if (FreeClass( cl ) != FALSE)
*          {
*          FreeMem( mpcd, sizeof mpcd );
*          
*          return ( TRUE );
*          }
*       else
*          {
*          return ( FALSE );
*          }
*    }
***********************************************************************
*
*/

METHODFUNC OBJECT *ATFreeClass( OBJECT *iclassPtr )
{
   struct IClass *iclass = (struct IClass *) CheckObject( iclassPtr );
   OBJECT        *rval   = o_false;
   
   if (NullChk( (OBJECT *) iclass ) == TRUE)
      return( rval );
      
   if (FreeClass( iclass ) != FALSE)
      rval = o_true;
      
   return( rval );
}

/****i* ATMakeClass() [1.9] *******************************************
*
* NAME
*    ATMakeClass() 
*
* DESCRIPTION
*    ^ <primitive 238 5 classID superClassID superClassObj size flags>
*
* FUNCTION
*    For class implementors only.
*	
*    This function creates a new public or private boopsi class.
*    The superclass should be defined to be another boopsi class:
*    all classes are descendants of the class "rootclass".
*
*    Superclasses can be public or private.  You provide a name/ID
*    for your class if it is to be a public class (but you must
*    have registered your class name and your attribute ID's with
*    Commodore before you do this!).  For a public class, you would
*    also call AddClass() to make it available after you have
*    finished your initialization.
*
*    Returns pointer to an IClass data structure for your
*    class.  You then initialize the Hook cl_Dispatcher for
*    your class methods code.  You can also set up special data
*    shared by all objects in your class, and point cl_UserData at it. 
*    The last step for public classes is to call AddClass().
*
*    You dispose of a class created by this function by calling
*    FreeClass().
*
* INPUTS
*    ClassID       = NULL for private classes, the name/ID string for public
*                    classes
*    SuperClassID  = name/ID of your new class's superclass.  NULL if
*                    superclass is a private class
*    SuperClassPtr = pointer to private superclass.  Only used if
*                    SuperClassID is NULL.  You are required never to provide
*                    a NULL superclass.
*    InstanceSize  = the size of the instance data that your class's
*                    objects will require, beyond that data defined for
*                    your superclass's objects.
*    Flags         = for future enhancement, including possible additional
*                    parameters.  Provide zero for now.
*
* RESULT
*    Pointer to the resulting class, or NULL if not possible:
*    - no memory for class data structure
*    - public superclass not found
*    - public class of same name/ID as this one already exists
*	
* EXAMPLE
*    Creating a private subclass of a public class:
*
*    // per-object instance data defined by my class
*    struct MyInstanceData {
*
*       ULONG mid_SomeData;
*    };
*
*    // some useful table I'll share use for all objects
*    UWORD myTable[] = { 5, 4, 3, 2, 1, 0 };
*
*    struct IClass *initMyClass( void )
*    {
*       ULONG __saveds myDispatcher();
*       ULONG          hookEntry();    // asm-to-C interface glue
*       struct IClass *cl;
*       struct IClass *MakeClass();
*
*       if ((cl =  MakeClass( NULL, SUPERCLASSID, NULL, // superclass is public
*                             sizeof( struct MyInstanceData ), 0 )) != NULL)
*          {
*          // initialize the cl_Dispatcher Hook
*          cl->cl_Dispatcher.h_Entry    = hookEntry;
*          cl->cl_Dispatcher.h_SubEntry = myDispatcher;
*          cl->cl_Dispatcher.h_Data     = (VOID *) 0xFACE; // unused
*
*          cl-cl_UserData = (ULONG) myTable;
*          }
*       
*       return ( cl );
*    }
*
* BUGS
*    The typedef 'Class' isn't consistently used.  Class pointers
*    used blindly should be APTR, or struct IClass for class implementors.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATMakeClass( char   *classID, 
                                char   *superClassID,
                                OBJECT *superClassObj,
                                ULONG   instanceSize,
                                ULONG   flags
                              )
{
   struct IClass *superClass = (struct IClass *) CheckObject( superClassObj );
   OBJECT        *rval       = o_nil;

   if (NullChk( (OBJECT *) superClass ) == FALSE)      
      rval = AssignObj( new_address( (ULONG) MakeClass( (CONST_STRPTR) classID, 
                                                        (CONST_STRPTR) superClassID, 
                                                        superClass, instanceSize, flags
                                                      )
                                   ) 
                      );
   
   return( rval );
}

/****i* obtainGIRPort() [1.9] *****************************************
*
* NAME
*    obtainGIRPort()
*
* DESCRIPTION
*    ^ <primitive 238 6 gadgetInfoObject>
*
* FUNCTION
*    Sets up a RastPort for use (only) by custom gadget hook routines.
*    This function must be called EACH time a hook routine needing
*    to perform gadget rendering is called, and must be accompanied
*    by a corresponding call to ReleaseGIRPort().
*
*    Note that if a hook function passes you a RastPort pointer,
*    i.e., GM_RENDER, you needn't call ObtainGIRPort() in that case.
*
* INPUTS
*    A pointer to a GadgetInfo structure, as passed to each custom
*    gadget hook function.
*
* RESULT
*    A pointer to a RastPort that may be used for gadget rendering.
*    This pointer may be NULL, in which case you should do no rendering.
*    You may (optionally) pass a null return value to ReleaseGIRPort().
*
***********************************************************************
*
*/

METHODFUNC OBJECT *obtainGIRPort( OBJECT *gadInfo )
{
   struct GadgetInfo *ginfo = (struct GadgetInfo *) CheckObject( gadInfo );
   struct RastPort   *rp    = (struct RastPort   *) NULL;
      
   if (!ginfo) // == NULL)
      {
      return( o_nil );
      }
   
   rp = (struct RastPort *) ObtainGIRPort( ginfo );
   
   return( AssignObj( new_address( (ULONG) rp ) ) );
}

/****i* releaseGIRPort() [1.9] ****************************************
*
* NAME
*    releaseGIRPort()
*
* DESCRIPTION
*    <primitive 238 7 rastPortObj>
*
* FUNCTION
*    The corresponding function to ObtainGIRPort(), it releases
*    arbitration used by Intuition for gadget RastPorts.
*
* INPUTS
*    Pointer to the RastPort returned by ObtainGIRPort().
*    This pointer can be NULL, in which case nothing happens.
***********************************************************************
*
*/

METHODFUNC void releaseGIRPort( OBJECT *rastPortObj )
{
   struct RastPort *rp = (struct RastPort *) CheckObject( rastPortObj );

   if (rp) // != NULL)
      ReleaseGIRPort( rp );
   
   return;
}

/****i* ATGetAttr() [1.9] *********************************************
*
* NAME
*    ATGetAttr()
*
* DESCRIPTION
*    ^ <primitive 238 8 attrID theObject storageObj>
*
* FUNCTION
*    Inquires from the specified object the value of the specified attribute.
*
*    You always pass the address of a long variable, which will
*    receive the same value that would be passed to SetAttrs() in
*    the ti_Data portion of a TagItem element.  See the documentation
*    for the class for exceptions to this general rule.
*	
*    Not all attributes will respond to this function.  Those that
*    will are documented on a class-by-class basis.
*
* INPUTS
*    AttrID     = the attribute tag ID understood by the object's class
*    Object     = abstract pointer to the boopsi object you are interested in
*    StoragePtr = pointer to appropriate storage for the answer
*
* RESULT
*    Returns FALSE (0) if the inquiries of attribute are not provided
*    by the object's class.
*	
* NOTES
*    This function invokes the OM_GET method of the object.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATGetAttr( ULONG attrID, OBJECT *Obj, ULONG *storagePtr )
{
   APTR    object = (APTR) CheckObject( Obj );
   ULONG   retn   = 0L;
   OBJECT *rval   = o_nil;

   if (!storagePtr) // == NULL)
      return( rval );
      
   retn = GetAttr( attrID, object, storagePtr );
   rval = AssignObj( new_int( (int) retn ) );
      
   return( rval );
}

/****i* ATSetAttrsA() [1.9] *******************************************
*
* NAME
*    ATSetAttrsA()
*
* DESCRIPTION
*    ^ <primitive 238 9 theObject tagArray>
*
* FUNCTION
*    Specifies a set of attribute/value pairs with meaning as
*    defined by a 'boopsi' object's class.
*
*    This function does not provide enough context information or
*    arbitration for boopsi gadgets which are attached to windows
*    or requesters.  For those objects, use SetGadgetAttrs().
*
* INPUTS
*    Object = abstract pointer to a boopsi object.
*    TagList = array of TagItem structures with attribute/value pairs.
*
* RESULT
*    The object does whatever it wants with the attributes you provide.
*    The return value tends to be non-zero if the changes would require
*    refreshing gadget imagery, if the object is a gadget.
*	
* NOTES
*    This function invokes the OM_SET method with a NULL GadgetInfo
*    parameter.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATSetAttrsA( OBJECT *Obj, OBJECT *tagArray )
{
   struct TagItem *tags   = NULL;
   APTR           *object = (APTR) CheckObject( Obj );
   OBJECT         *rval   = o_nil;
   ULONG           retn   = 0L;
   
   if (!object) // == NULL)
      return( rval );

   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );
   
   retn = SetAttrsA( object, tags );
   
   rval = AssignObj( new_int( (int) retn ) );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "SetAttrsATags", TRUE );
      
   return( rval );               
}

/****i* ATSetGadgetAttrsA() [1.9] *************************************
*
* NAME
*    ATSetGadgetAttrsA() 
*
* DESCRIPTION
*    Special set attribute call for gadgets
*    ^ <primitive 238 10 gadObj winObj reqObj tagArray>
*
* FUNCTION
*    Same as SetAttrs(), but provides context information and
*    arbitration for classes which implement custom Intuition gadgets.
*
*    You should use this function for boopsi gadget objects which have
*    already been added to a requester or a window, or for "models" which
*    propagate information to gadget already added.
*
*    Typically, the gadgets will refresh their visuals to reflect
*    changes to visible attributes, such as the value of a slider,
*    the text in a string-type gadget, the selected state of a button.
*
*    You can use this as a replacement for SetAttrs(), too, if you
*    specify NULL for the 'Window' and 'Requester' parameters.
*
* INPUTS
*    Gadget    = abstract pointer to a boopsi gadget
*    Window    = window gadget has been added to using AddGList() or AddGadget()
*    Requester = for REQGADGETs, requester containing the gadget
*    TagList   = array of TagItem structures with attribute/value pairs.
*
* RESULT
*    The object does whatever it wants with the attributes you provide,
*    which might include updating its gadget visuals.
*
*    The return value tends to be non-zero if the changes would require
*    refreshing gadget imagery, if the object is a gadget.
*	
* NOTES
*    This function invokes the OM_SET method with a GadgetInfo
*    derived from the 'Window' and 'Requester' pointers.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATSetGadgetAttrsA( OBJECT *gadObj,
                                      OBJECT *winObj,
                                      OBJECT *reqObj,
                                      OBJECT *tagArray
                                    )
{
   struct Gadget    *gad    = (struct Gadget    *) CheckObject( gadObj );
   struct Window    *win    = (struct Window    *) CheckObject( winObj );
   struct Requester *req    = (struct Requester *) CheckObject( reqObj );
   struct TagItem   *tags   = NULL;
   ULONG             result = 0L;
   OBJECT           *rval   = o_nil;
   
   if (!gad) // == NULL)
      return( o_nil );

   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );
   
   result = SetGadgetAttrsA( gad, win, req, tags );
   
   rval   = AssignObj( new_int( (int) result ) );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "setGadgetAttrsATags", TRUE );
      
   return( rval );
}

/****i* ATNextObject() [1.9] ******************************************
*
* NAME
*    ATNextObject() 
*
* DESCRIPTION
*    ^ <primitive 238 11 anObject>
*
* FUNCTION
*    This function is for boopsi class implementors only.
*
*    When you collect a set of boopsi objects on an Exec List
*    structure by invoking their OM_ADDMEMBER method, you
*    can (only) retrieve them by iterations of this function.
*
*    Works even if you remove and dispose the returned list
*    members in turn.
*
* INPUTS
*    Initially, you set a pointer variable to equal the
*    lh_Head field of the list (or mlh_Head field of a MinList).
*    You pass the *address* of that pointer repeatedly
*    to NextObject() until it returns NULL.
*	
* EXAMPLE
*
*    // here is the OM_DISPOSE case of some class's dispatcher
*    case OM_DISPOSE:
*       // dispose members
*       object_state = mydata->md_CollectionList.lh_Head;
*
*       while ((member_object = NextObject( &object_state )) != NULL)
*          {
*          DoMethod( member_object, OM_REMOVE ); // remove from list
*          DoMethodA( member, msg );             // and pass along dispose
*          }
*
* RESULT
*    Returns pointers to each object in the list in turn, and NULL
*    when there are no more.
*
***********************************************************************
*
*/

METHODFUNC OBJECT *ATNextObject( OBJECT *ObjectPtr )
{
   APTR *object = (APTR) CheckObject( ObjectPtr );

   if (!object) // == NULL)
      return( o_nil );
   else 
      return( AssignObj( new_address( (ULONG) NextObject( object ))));
}      

/****i* ATDoGadgetMethodA() [1.9] *************************************
*
* NAME
*    ATDoGadgetMethodA()
*
* DESCRIPTION
*    ^ <primitive 238 12 gadObj winObj reqObj msgObj>
*
* FUNCTION
*    Same as the DoMethod() function of amiga.lib, but provides context
*    information and arbitration for classes which implement custom
*    Intuition gadgets.
*
*    You should use this function for boopsi gadget objects,
*    or for "models" which propagate information to gadgets.
*
*    Unlike DoMethod(), this function provides a GadgetInfo pointer
*    (if possible) when invoking the method.  Some classes may
*    require or benefit from this.
*
* INPUTS
*    Gadget    = abstract pointer to a boopsi gadget
*    Window    = window gadget has been added to using AddGList() or AddGadget()
*    Requester = for REQGADGETs, requester containing the gadget
*    Msg       = the boopsi message to send
*
* RESULT
*    The object does whatever it wants with the message you sent,
*    which might include updating its gadget visuals.
*
*    The return value is defined per-method.
*	
* NOTES
*    This function invokes the specified method with a GadgetInfo
*    derived from the 'Window' and 'Requester' pointers.  The GadgetInfo
*    is passed as the second parameter of the message, except for
*    OM_NEW, OM_SET, OM_NOTIFY, and OM_UPDATE, where the GadgetInfo
*    is passed as the third parameter.
*
*    Implementers of new gadget methods should ensure that the
*    GadgetInfo is the second long-word of their message!
***********************************************************************
*
*/

METHODFUNC OBJECT *ATDoGadgetMethodA( OBJECT *gadObj,
                                      OBJECT *winObj,
                                      OBJECT *reqObj,
                                      OBJECT *msgObj
                                    )
{
   struct Gadget    *gad    = (struct Gadget    *) CheckObject( gadObj );
   struct Window    *win    = (struct Window    *) CheckObject( winObj );
   struct Requester *req    = (struct Requester *) CheckObject( reqObj );
   Msg               msg    = (Msg)                CheckObject( msgObj );

   if (!gad || !win || !msg) // == NULL)
      return( o_nil );
   else
      return( AssignObj( new_int( (int) DoGadgetMethodA( gad, win, req, msg ))));
}

/****i* TranslateBoopsiErrorNum() [1.9] ***********************************
*
* NAME
*    TranslateBoopsiErrorNum()
*
* DESCRIPTION
*    Return a string for the IoErr() code.
*    ^ <primitive 238 13>
***********************************************************************
*
*/

METHODFUNC OBJECT *TranslateBoopsiErrorNum( void )
{
   char buffer[128] = { 0, };
   int  length = 127, result = 0;

   result = Fault( IoErr(), BoopCMsg( MSG_BO_BOOPSI_ERR_BOOPSI ), buffer, length );

   (void) SetIoErr( 0 );         // Reset IoErr value

   if (result != 0)
      return( AssignObj( new_str( buffer ) ) );
   else
      return( AssignObj( new_str( BoopCMsg( MSG_BO_NO_ERR_BOOPSI ))));
}

/****i* ATDoSuperMethodA() [1.9] **************************************
*
* NAME
*    ATDoSuperMethodA()
*
* DESCRIPTION
*    ^ <primitive 238 14 classObj object msg>
*
* FUNCTION
*    Boopsi support function that invokes the supplied message
*    on the specified object, as though it were the superclass
*    of the specified class.
*
* INPUTS
*    cl  - pointer to boopsi class whose superclass is to
*          receive the message
*    obj - pointer to boopsi object
*    msg - pointer to method-specific message to send
*
* RESULT
*    result - class and message-specific result.
*
* NOTES
*    This function first appears in the V37 release of amiga.lib.
*    While it intrinsically does not require any particular release
*    of the system software to operate, it is designed to work with
*    the boopsi subsystem of Intuition, which was only introduced
*    in V36.
*    Some early example code may refer to this function as DSM().
***********************************************************************
*
*/

#ifdef __SASC
METHODFUNC OBJECT *ATDoSuperMethodA( OBJECT *classObj, OBJECT *Obj, OBJECT *msgObj )
{
   struct IClass *iclass = (struct IClass *) CheckObject( classObj );
   Object        *obj    = (Object        *) CheckObject( Obj      );
   Msg           *msg    = (Msg           *) CheckObject( msgObj   );
   OBJECT        *rval   = o_nil;
   ULONG          chk    = 0L;
   
   if (!iclass || !obj || !msg) // == NULL)
      return( rval );
      
   chk  = DoSuperMethodA( iclass, obj, msg );

   rval = AssignObj( new_int( (int) chk ) );
      
   return( rval );   
}
#endif
      
/****i* ATCoerceMethodA() [1.9] ***************************************
*
* NAME
*    ATCoerceMethodA()
*
* DESCRIPTION
*    ^ <primitive 238 15 classObj object msg>
*
* FUNCTION
*    Boopsi support function that invokes the supplied message
*    on the specified object, as though it were the specified
*    class.  Equivalent to CoerceMethodA(), but allows you to
*    build the message on the stack.
*
* INPUTS
*    cl  - pointer to boopsi class to receive the message
*    obj - pointer to boopsi object
*    msg - pointer to method-specific message to send
*
* RESULT
*    result - class and message-specific result.
*
* NOTES
*    This function first appears in the V37 release of amiga.lib.
*    While it intrinsically does not require any particular release
*    of the system software to operate, it is designed to work with
*    the boopsi subsystem of Intuition, which was only introduced
*    in V36.
*    Some early example code may refer to this function as CM().
***********************************************************************
*
*/

#ifdef __SASC
METHODFUNC OBJECT *ATCoerceMethodA( OBJECT *classObj, OBJECT *Obj, OBJECT *msgObj )
{
   struct IClass *iclass = (struct IClass *) CheckObject( classObj );
   Object        *obj    = (Object        *) CheckObject( Obj      );
   Msg           *msg    = (Msg           *) CheckObject( msgObj   );
   OBJECT        *rval   = o_nil;
   ULONG          chk    = 0L;
   
   if (!iclass || !obj || !msg) // == NULL)
      return( rval );
      
   chk  = CoerceMethodA( iclass, obj, msg );

   rval = AssignObj( new_int( (int) chk ) );
      
   return( rval );   
}
#endif

/****i* disposeObject() [2.6] *****************************************
*
* NAME
*    disposeObject()
*
* DESCRIPTION
*    <primitive 238 16 boopsiObject>
*
* FUNCTION
*    Deletes a boopsi object and all of it auxiliary data.
*    These objects are all created by NewObjectA().  Objects
*    of certain classes "own" other objects, which will also
*    be deleted when the object is passed to DisposeObject().
*    Read the per-class documentation carefully to be aware
*    of these instances.
*
* INPUTS
*    Object = abstract pointer to a boopsi object returned by NewObject().
*             The pointer may be NULL, in which case this function has
*             no effect.
*
* NOTES
*    This function invokes the OM_DISPOSE method.
***********************************************************************
*
*/

METHODFUNC void disposeObject( OBJECT *Obj )
{
   APTR *obj = (APTR) CheckObject( Obj );
   
   if (NullChk( (OBJECT *) obj ) == FALSE)
      DisposeObject( obj );

   return;   
}

/*
typedef struct {

   ULONG MethodID;

    // method-specific data follows, some examples below

}  *Msg;

// Dispatched method ID's
// NOTE: Applications should use Intuition entry points, not direct
// DoMethod() calls, for NewObject, DisposeObject, SetAttrs,
// SetGadgetAttrs, and GetAttr.

#define OM_Dummy	(0x100)
#define OM_NEW		(0x101)	/* 'object' parameter is "true class"
#define OM_DISPOSE	(0x102)	/* delete self (no parameters)
#define OM_SET		(0x103)	/* set attributes (in tag list)
#define OM_GET		(0x104)	/* return single attribute value
#define OM_ADDTAIL	(0x105)	/* add self to a List (let root do it)
#define OM_REMOVE	(0x106)	/* remove self from list
#define OM_NOTIFY	(0x107)	/* send to self: notify dependents
#define OM_UPDATE	(0x108)	/* notification message from somebody
#define OM_ADDMEMBER	(0x109)	/* used by various classes with lists
#define OM_REMMEMBER	(0x10A)	/* used by various classes with lists

// Parameter "Messages" passed to methods

// OM_NEW and OM_SET

struct opSet {

    ULONG		MethodID;
    struct TagItem	*ops_AttrList;	/* new attributes
    struct GadgetInfo	*ops_GInfo;	/* always there for gadgets,
					 * when SetGadgetAttrs() is used,
					 * but will be NULL for OM_NEW
};

// OM_NOTIFY, and OM_UPDATE

struct opUpdate {

    ULONG		MethodID;
    struct TagItem	*opu_AttrList;	/* new attributes
    struct GadgetInfo	*opu_GInfo;	/* non-NULL when SetGadgetAttrs or
					 * notification resulting from gadget
					 * input occurs.
    ULONG		opu_Flags;	/* defined below
};

// this flag means that the update message is being issued from
// something like an active gadget, a la GACT_FOLLOWMOUSE.  When
// the gadget goes inactive, it will issue a final update
// message with this bit cleared.  Examples of use are for
// GACT_FOLLOWMOUSE equivalents for propgadclass, and repeat strobes
// for buttons.

#define OPUF_INTERIM	(1<<0)

// OM_GET

struct opGet {

    ULONG  MethodID;
    ULONG  opg_AttrID;
    ULONG *opg_Storage;	// may be other types, but "int"
			// types are all ULONG
};

// OM_ADDTAIL

struct opAddTail {

    ULONG        MethodID;
    struct List *opat_List;
};

// OM_ADDMEMBER, OM_REMMEMBER

#define  opAddMember opMember

struct opMember {

   ULONG   MethodID;
   Object *opam_Object;
};

*/
      
/****h* HandleBoopsi() [2.6] ***********************************************
*
* NAME
*    HandleBoopsi() {Primitive 238}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    BOOPSI interfacing methods.
************************************************************************
*
*/

PUBLIC OBJECT *HandleBoopsi( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 238 );
      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
#     ifdef   __SASC
      case 0: // dispose [private]  <primitive 238 0 private>
         ATDisposeBoopsiObject( args[1] );

         break;
#     endif

      case 1: // ^ private <- newBOOPSIObject:in:tags:
              //   ^ <primitive 238 1 iclassObj classID tagArray>
         if (!is_string( args[2] ) || !is_array( args[3] ))
            (void) PrintArgTypeError( 238 );
         else
            rval = ATNewBoopsiObjectA(                          args[1],
                                       string_value( (STRING *) args[2] ),
                                                                args[3] 
                                     );
         break;
      
      case 2: // addBoopsiClass: iclassObj  <primitive 238 2 iclassObj>
         ATAddClass( args[1] );

         break;
      
      case 3: // removeBoopsiClass: iclassObj  <primitive 238 3 iclassObj>
         ATRemoveClass( args[1] );

         break;
      
      case 4: // freeBoopsiClass: iclassObj  ^ <primitive 238 4 iclassObj>
         rval = ATFreeClass( args[1] );

         break;
      
      case 5: // makeBoopsiClass:::::
              //   ^ <primitive 238 5 classID superClassID superClassObj size flags>
         if (ChkArgCount( 5, numargs, 238 ) != 0)
            return( ReturnError() );

         if (!is_string( args[1] ) || !is_string(  args[2] )
                                   || !is_integer( args[4] )
                                   || !is_integer( args[5] ))
            (void) PrintArgTypeError( 238 );
         else
            rval = ATMakeClass( string_value( (STRING *) args[1] ),
                                string_value( (STRING *) args[2] ),
                                                         args[3], 
                                (ULONG) int_value(       args[4] ),
                                (ULONG) int_value(       args[5] )
                              );
         break;
      
      case 6: // obtainGIRPort: gadgetInfoObject  ^ <primitive 238 6 gadgetInfoObject>
         rval = obtainGIRPort( args[1] );

         break;

      case 7: // releaseGIRPort: rastPortObject   <primitive 238 7 rastPortObject>
         releaseGIRPort( args[1] );

         break;

      case 8: // getAttribute: attrID from: object into: storageObj
              //   ^ <primitive 238 8 attrID object storageObj>
         if (!is_integer( args[1] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 238 );
         else
            rval = ATGetAttr( (ULONG  ) int_value( args[1] ), args[2],
                              (ULONG *) int_value( args[3] )
                            );
         break;

      case 9: // setAttributes: anObject tags: tagArray ^ <primitive 238 9 anObject tagArray>
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 238 );
         else 
            rval = ATSetAttrsA( args[1], args[2] );

         break;

      case 10: // setGadgetAttributes: ::::
               //   ^ <primitive 238 10 gadObj winObj reqObj tagArray>
         if (ChkArgCount( 4, numargs, 238 ) != 0)
            return( ReturnError() );

         if (is_array( args[4] ) == FALSE)
            (void) PrintArgTypeError( 238 );
         else 
            rval = ATSetGadgetAttrsA( args[1], args[2], args[3], args[4] );

         break;

      case 11: // nextObject: fromObject  ^ <primitive 238 11 fromObject>
         rval = ATNextObject( args[1] );

         break;

      case 12: // doGadgetMethod: gadObj from: winObj req: reqObj message: msgObj
               //   ^ <primitive 238 12 gadObj winObj reqObj msgObj>
         if (ChkArgCount( 4, numargs, 238 ) != 0)
            return( ReturnError() );

         rval = ATDoGadgetMethodA( args[1], args[2], args[3], args[4] );

         break;
      
      case 13: // translateBoopsiErrorNumber  ^ <primitive 238 13>
         rval = TranslateBoopsiErrorNum();

         break;

#     ifdef    __SASC
      case 14: // doSuperMethod: onObject for: classObj message: msgObj
               //   ^ <primitive 238 14 classObj onObject msgObj>                
         if (ChkArgCount( 3, numargs, 238 ) != 0)
            return( ReturnError() );

         rval = ATDoSuperMethodA( args[1], args[2], args[3] );

         break;
      
      case 15: // coerceMethod: onObject for: classObj message: msgObj
               //   ^ <primitive 238 15 classObj onObject msgObj>                
         if (ChkArgCount( 3, numargs, 238 ) != 0)
            return( ReturnError() );

         rval = ATCoerceMethodA( args[1], args[2], args[3] );

         break;
#     endif

      case 16: // <primitive 238 16 boopsiObject>
         if (is_address( args[1] ) == FALSE && is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 238 );
         else
            disposeObject( args[1] );
            
         break;
       
      default:
         (void) PrintArgTypeError( 238 );

         break;
      }

   return( rval );
}

/* ---------------------- END of Boopsi.c file! ----------------------- */
