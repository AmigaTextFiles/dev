/****h* AmigaTalk/DTInterface.c [3.0] *********************************
*
* NAME 
*   DTInterface.c
*
* DESCRIPTION
*   Functions that handle DataType to AmigaTalk primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleDT( int numargs, OBJECT **args ); <210>
*
* HISTORY
*   25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*   08-Jan-2003 - Moved all string constants to StringConstants.h
*
*   28-May-2001 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/DTInterface.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#include <dos/dos.h>

#include <datatypes/datatypes.h>
#include <datatypes/datatypesclass.h>

#include <intuition/classusr.h> // for struct Msg.

#include <utility/tagitem.h>


#ifdef __SASC

# include <pragmas/datatypes_pragmas.h>

# include <clib/datatypes_protos.h>
# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/datatypes.h>
# include <proto/intuition.h>

PRIVATE struct DataTypesIFace *IDataTypes;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

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

PRIVATE struct Library *DataTypesBase = NULL;

#define PTRCHK( obj ) ((obj) != o_nil && (obj) != NULL)

/****i* OpenDTLibrary() [1.8] *****************************************
*
* NAME
*    OpenDTLibrary()
*
* DESCRIPTION
*    Open the datatypes.library.
***********************************************************************
*
*/

SUBFUNC struct Library *OpenDTLibrary( void )
{
#  ifdef  __SASC
   if (!DataTypesBase) // == NULL)
      DataTypesBase = OpenLibrary( "datatypes.library", 39L );
#  else
   if (!DataTypesBase) // == NULL)
      {
      DataTypesBase = OpenLibrary( "datatypes.library", 50L );

      if (!(IDataTypes = (struct DataTypesIFace *) GetInterface( DataTypesBase, "main", 1, NULL )))
         {
	 CloseLibrary( DataTypesBase );
	 DataTypesBase = NULL;
	 }
      }
#  endif
      
   return( DataTypesBase );
}

/****i* CloseDTLibrary() [1.8] ****************************************
*
* NAME
*    CloseDTLibrary()
*
* DESCRIPTION
*    Close the datatypes.library.
***********************************************************************
*
*/

SUBFUNC void CloseDTLibrary( void )
{
   if (DataTypesBase) // != NULL)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IDataTypes );
      IDataTypes = NULL;
#     endif

      CloseLibrary( DataTypesBase );
      DataTypesBase = NULL;
      }
      
   return;
}

/****i* TranslateDTErrorNum() [1.8] ***********************************
*
* NAME
*    TranslateDTErrorNum() <primitive 210 16>
*
* DESCRIPTION
*    Return a string for the IoErr() code.
***********************************************************************
*
*/

METHODFUNC OBJECT *TranslateDTErrorNum( void )
{
   char buffer[128] = { 0, };
   int  length = 127, result = 0;

   result = Fault( IoErr(), DTypeCMsg( MSG_DT_ERROR_STR_DTYPE ), buffer, length );

   (void) SetIoErr( 0 );         // Reset IoErr value

   if (result != 0)
      {
      return( AssignObj( new_str( buffer ) ) );
      }
   else
      {
      return( AssignObj( new_str( DTypeCMsg( MSG_BO_NO_ERR_DTYPE ))));
      }
}
      
/****i* ATNewDTObjectA() [1.8] ****************************************
*
* NAME
*    ATNewDTObjectA()
*    ^ private <- <primitive 210 0 dtName tagArray>
*
* DESCRIPTION
*    Create a new DataType Object.
*    This is the method for creating datatype objects from
*    'boopsi' classes.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATNewDTObjectA( APTR dtName, OBJECT *tagArray )
{
   struct TagItem *tags = (struct TagItem *) NULL; 
   Object         *rval = (Object         *) NULL;

   if (PTRCHK( tagArray ) == TRUE)
      tags = ArrayToTagList( tagArray );

   if (!tags) // == NULL)
      {
      return( o_nil );
      }
   
   rval = NewDTObjectA( dtName, tags );

   if (!rval) // == NULL)
      {
      return( o_nil );
      }
      
   AT_FreeVec( tags, "NewDTObjectTags", TRUE );

   return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* ATDisposeDTObject() [1.8] *************************************
*
* NAME
*    ATDisposeDTObject()  <primitive 210 1 self>
*
* DESCRIPTION
*    Delete a DataType Object (from NewDTObjectA()) from memory.
***********************************************************************
*
*/

METHODFUNC void ATDisposeDTObject( OBJECT *dtObject )
{
   Object *obj = (Object *) CheckObject( dtObject );

   if (obj) // != NULL)   
      DisposeDTObject( obj );

   return;
}

/****i* ATAddDTObject() [1.8] *****************************************
*
* NAME
*    ATAddDTObject() <primitive 210 2 window glistPos private>
*
* DESCRIPTION
*    Add a DataType Object to the given window gadget list & place it 
*    in the glistPos slot.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATAddDTObject( OBJECT *windowObj, 
                                  OBJECT *pos,
                                  OBJECT *dtObject 
                                )
{
   struct Window *wp  = (struct Window *) CheckObject( windowObj );
          Object *obj = (Object        *) CheckObject( dtObject  );
            
   int rval = AddDTObject( wp, NULL, // Requester is always NULL (for now!).
                           obj, (LONG) int_value( pos ) 
                         );

   return( AssignObj( new_address( (ULONG) rval ) ) );
}

/****i* ATRemoveDTObject() [1.8] **************************************
*
* NAME
*    ATRemoveDTObject() <primitive 210 3 windowObj private>
*
* DESCRIPTION
*    Remove a DataType Object from the given window.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATRemoveDTObject( OBJECT *windowObj, OBJECT *dtObject )
{
   struct Window *wp   = (struct Window *) CheckObject( windowObj );
          Object *obj  = (Object        *) CheckObject( dtObject  );

   ULONG          rval = RemoveDTObject( wp, obj );

   return( AssignObj( new_int( (int) rval ) ) );
}

/****i* ATDoAsyncLayout() [1.8] ***************************************
*
* NAME
*    ATDoAsyncLayout() <primitive 210 4 private layoutMsg>
*
* DESCRIPTION
*    Call the DTM_ASYNCLAYOUT method on a separate process
*
* FUNCTION
*    This function is used to asyncronously perform the object's
*    DTM_ASYNCLAYOUT method.  This is used to offload the layout method
*    from input.device.
*
*    The DTM_ASYNCLAYOUT method must exit when SIGBREAKF_CTRL_C signal
*    is set.   This indicates that the data has become obsolete and
*    the DTM_ASYNCLAYOUT method will be called again.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATDoAsyncLayout( OBJECT *dtObject, OBJECT *gplayout )
{
   struct gpLayout *gp   = (struct gpLayout *) CheckObject( gplayout );
          Object   *obj  = (Object          *) CheckObject( dtObject );
          
   ULONG            rval = DoAsyncLayout( obj, gp );

   return( AssignObj( new_int( (int) rval ) ) );
}

/****i* ATDoDTMethod() [1.8] ******************************************
*
* NAME
*    ATDoDTMethod() 
*
* DESCRIPTION
*    Perform the given DataType Method.
*    <primitive 210 5 private windowObj reqObj message>
***********************************************************************
*
*/

METHODFUNC OBJECT *ATDoDTMethod( OBJECT *dtObject, 
                                 OBJECT *windowObj,
                                 OBJECT *reqObj,
                                 OBJECT *msg
                               )
{
   struct Window    *wp   = (struct Window    *) CheckObject( windowObj );
          Object    *obj  = (Object           *) CheckObject( dtObject  );
   struct Requester *req  = (struct Requester *) CheckObject( reqObj    );
          Msg        MSg  = (Msg               ) CheckObject( msg       );

   ULONG  rval = DoDTMethodA( obj, wp, req, MSg );

   return( AssignObj( new_int( (int) rval ) ) );
}

/****i* ATGetDTAttrs() [1.8] ******************************************
*
* NAME
*    ATGetDTAttrs() <primitive 210 6 private tagArray>
*
* DESCRIPTION
*    Retrieve the DataType attributes requested & place them in the
*    given tagArray OBJECT, overwriting any old values found there.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATGetDTAttrs( OBJECT *dtObject, OBJECT *tagArray )
{
   Object         *obj  = (Object *) CheckObject( dtObject );
   ULONG           rval = 0;
   struct TagItem *tags = ArrayToTagList( tagArray );
   
   if (!obj) // == NULL)
      return( o_nil );
      
   if (!tags) // == NULL)
      {
      return( o_nil ); // Error flagged already!
      }
   
   rval = GetDTAttrsA( obj, tags );

   TagListToArray( tags, tagArray );

   AT_FreeVec( tags, "GetDTAttrsTags", TRUE ); // done with the temporary tags memory!
      
   return( AssignObj( new_int( (int) rval ) ) );
}

/****i* ATGetDTMethods() [1.8] ****************************************
*
* NAME
*    ATGetDTMethods() <primitive 210 7 private>
*
* DESCRIPTION
*    Retrieve an array of methods that the DataType object supports.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATGetDTMethods( OBJECT *dtObject )
{
   int     cnt  = 0;
   Object *obj  = (Object *) CheckObject( dtObject );
   
   ULONG  *list = (ULONG *) NULL;
   OBJECT *rval = o_nil;

   if (!obj) // == NULL)
      return( rval );
   else
      list = GetDTMethods( obj );

   while (list[cnt] != ~0) // ~0 terminates the array!
      cnt++;

   if (cnt > 0)
      {
      int i;
      
      rval = AssignObj( new_array( cnt, FALSE ) );

      // Now copy the list elements to the new Array:      
      for (i = 0; i < cnt; i++)
         {
         rval->inst_var[i] = AssignObj( new_int( (int) list[cnt] ) );
         }
      }   

   return( rval );
}

/****i* ATGetDTTriggerMethods() [1.8] *********************************
*
* NAME
*    ATGetDTTriggerMethods()  <primitive 210 9 private>
*
* DESCRIPTION
*    Retrieve an array of DTMethod structs that the DataType object
*    responds to.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATGetDTTriggerMethods( OBJECT *dtObject )
{
   Object *obj  = (Object *) CheckObject( dtObject );
   OBJECT *rval = o_nil;
   int     cnt  = 0;

   ULONG  *dtm  = (ULONG *) NULL;
   
   if (!obj) // == NULL)
      return( rval );
   else
      dtm = (ULONG *) GetDTTriggerMethods( obj );

   while (*(dtm + cnt)) // != NULL)
      cnt++;
   
   if (cnt > 0)
      {
      int i;
      
      rval = AssignObj( new_array( cnt, FALSE ) );

      // Now copy the list elements to the new Array:      
      for (i = 0; i < cnt; i++)
         {
         rval->inst_var[i] = AssignObj( new_int( (int) *(dtm + cnt) ) );
         }
      }   

   return( rval );
      
}

/****i* ATObtainDataTypeA() [1.8] *************************************
*
* NAME
*    ATObtainDataTypeA()  <primitive 210 10 | 11 handle tagArray>
*
* DESCRIPTION
*    Examine the data that the file (or clipboard) points to & 
*    return a DataType record that describes the data.
***********************************************************************
*
*/

METHODFUNC OBJECT *ATObtainDataTypeA( int     type, 
                                      OBJECT *handle,
                                      OBJECT *tagArray
                                    )
{
   struct DataType  *chk  = (struct DataType *) NULL;
   struct TagItem   *tags = (struct TagItem  *) NULL;
   OBJECT           *rval = o_nil;

   if (tagArray != o_nil)
      {
      if (!(tags = ArrayToTagList( tagArray ))) // == NULL)
         return( rval );
      }
   else
      tags = (struct TagItem *) NULL;
            
   switch (type)
      {   
      case DTST_FILE:
         {
         BPTR lock = (BPTR) NULL;
         APTR alock;
         
         if (!(lock = Lock( string_value( (STRING *) handle ), MODE_OLDFILE ))) // == NULL)
            {
            goto exitATObtain;
            }
         
         alock = (APTR) ((int) lock * 4);

         if (!(chk = ObtainDataTypeA( type, alock, tags ))) // == NULL)
            {
            UnLock( lock );
            goto exitATObtain;
            }

         UnLock( lock );

         rval = AssignObj( new_address( (ULONG) chk ) );
         }

         break;
         
      case DTST_CLIPBOARD:
         {
         struct IFFHandle *cb   = NULL;
         
         if (!(cb = (struct IFFHandle *) int_value( handle ))) // == NULL)
            goto exitATObtain;

         if (!(chk = ObtainDataTypeA( type, cb, tags ))) // == NULL)
            goto exitATObtain;

         rval = AssignObj( new_address( (ULONG) chk ) );
         }
      }

exitATObtain:

   if (tagArray != o_nil)
      {
      AT_FreeVec( tags, "ObtainDataTypeTags", TRUE );
      }
      
   return( rval ); // rval is a pointer to struct DataType.
}

/****i* ATPrintDTObjectA() [1.8] **************************************
*
* NAME
*    ATPrintDTObjectA() 
*
* DESCRIPTION
*    Tell the DataType Object to call the DTM_PRINT Method on a 
*    separate process.
*
*    ^ <primitive 210 12 private windowObj reqObj prtMsg>
***********************************************************************
*
*/

METHODFUNC OBJECT *ATPrintDTObjectA( OBJECT *dtObject, 
                                     OBJECT *windowObj,
                                     OBJECT *reqObj,
                                     OBJECT *prtMsg
                                   )
{
   struct Window    *win = (struct Window    *) CheckObject( windowObj );
   struct Requester *req = (struct Requester *) CheckObject( reqObj    );
   struct dtPrint   *prt = (struct dtPrint   *) CheckObject( prtMsg    );  
          Object    *obj = (Object           *) CheckObject( dtObject  );

   BOOL   result = FALSE;

   result = PrintDTObjectA( obj, win, req, prt );

   if (result == TRUE)
      return( o_true );
   else
      return( o_false );
}

/****i* ATRefreshDTObjectA() [1.8] ************************************
*
* NAME
*    ATRefreshTObjectA() 
*
* DESCRIPTION
*    Refresh the specified object, by sending GM_RENDER to it.
*    <primitive 210 13 private windowObj tagArray>
***********************************************************************
*
*/

METHODFUNC void ATRefreshDTObjectA( OBJECT *dtObject, 
                                    OBJECT *windowObj,
                                    // OBJECT *reqObj,
                                    OBJECT *tagArray
                                  )
{
// Not currently used by AmigaOS:
// struct Requester *req = (struct Requester *) int_value( reqObj );

   Object         *dto  = (Object        *) CheckObject( dtObject );
   struct Window  *win  = (struct Window *) CheckObject( windowObj );
   struct TagItem *tags = (struct TagItem *) NULL;
   
   if (tagArray != o_nil)
      {
      if (!(tags = ArrayToTagList( tagArray ))) // == NULL)
         return;
      }
      
   RefreshDTObjectA( dto, win, NULL, tags );
  
   if (tags) // != NULL)
      AT_FreeVec( tags, "RefreshDTObjectTags", TRUE );
      
   return;
}      

/****i* ATReleaseDataType() [1.8] *************************************
*
* NAME
*    ATReleaseDataType() <primitive 210 14 private>
*
* DESCRIPTION
*    Release a DataType struct obtained via ATObtainDataTypeA().
***********************************************************************
*
*/

METHODFUNC OBJECT *ATReleaseDataType( OBJECT *dtObject )
{
   struct DataType *obj = (struct DataType *) CheckObject( dtObject );

   ReleaseDataType( obj );

   return( o_nil );
}

/****i* ATSetDTAttrsA() [1.8] *****************************************
*
* NAME
*    ATSetDTAttrsA()
*
* DESCRIPTION
*    Set the attributes for a DataType Object.
*    ^ <primitive 210 15 private windowObj reqObj tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *ATSetDTAttrsA( OBJECT *dtObject, 
                                  OBJECT *windowObj,
                                  OBJECT *reqObj,
                                  OBJECT *tagArray
                                )
{
   struct Window    *win  = (struct Window    *) CheckObject( windowObj );
   struct Requester *req  = (struct Requester *) CheckObject( reqObj    );
          Object    *obj  = (Object           *) CheckObject( dtObject  );
   struct TagItem   *tags = (struct TagItem *) NULL;
   OBJECT           *rval = o_nil;
   ULONG             chk  = 0;

   if (tagArray != o_nil)
      {
      if (!(tags = ArrayToTagList( tagArray ))) // == NULL)
         return( rval );
      }

   if (PTRCHK( dtObject ) == FALSE)
      {
      AT_FreeVec( tags, "setDTAttrstags", TRUE );

      return( rval );
      }

   chk = SetDTAttrsA( obj, win, req, tags );

   AT_FreeVec( tags, "setDTAttrstags", TRUE );
   
   rval = AssignObj( new_address( (ULONG) chk ) );
   
   return( rval );
}

/****i* ATCopyDTMethods() [1.8] ****************************************
*
* NAME
*    ATCopyDTMethods()  <primitive 210 17 array incArray excArray>
*
* DESCRIPTION
*    Clone and modify DTA_Methods array (V45)
*
* SYNOPSIS
*    ULONG *newMethods = ATCopyDTMethods( ULONG *methods, 
*                                         ULONG *include, 
*                                         ULONG *exclude 
*                                       );
*
* FUNCTION
*    Copy and modify array of supported methods.
*
*    This function is used for subclass implementors, who want to
*    add their methods (like DTM_TRIGGER) to the array of supported
*    methods.
*
* INPUTS
*    methods - Methods array, as obtained by GetDTMethods or DTA_Methods.
*              NULL causes the function to return NULL.
*
*    include - Methods to include, ~0UL terminated. May be NULL.
*
*    exclude - Methods to exclude, ~0UL terminated. May be NULL.
*
* RESULT
*    newmethods - New array of methods or NULL (no memory).
************************************************************************
*
*/

METHODFUNC OBJECT *ATCopyDTMethods( OBJECT *array, 
                                    OBJECT *incarrayObj,
                                    OBJECT *excarrayObj
                                  )
{
   ULONG  *methods  = (ULONG *) CheckObject( array       );
   ULONG  *incarray = (ULONG *) CheckObject( incarrayObj );
   ULONG  *excarray = (ULONG *) CheckObject( excarrayObj );
   ULONG  *chk      = (ULONG *) NULL;
   OBJECT *rval     = o_nil;
   
   chk = CopyDTMethods( methods, incarray, excarray );
   
   if (!chk) // == NULL)
      return( rval );
   else
      return( rval = AssignObj( new_address( (ULONG) chk ) ) );
}

/****i* ATCopyDTTriggerMethods() [1.8] *********************************
*
* NAME
*    ATCopyDTTriggerMethods()
*
* DESCRIPTION
*    Clone and modify DTA_TriggerMethods array.                (V45)
*    <primitive 210 18 byteArray ibArray ebArray>
* 
* SYNOPSIS
*    struct DTMethod *CopyDTTriggerMethods( struct DTMethod *methods,
*                                           struct DTMethod *incarray,
*                                           struct DTMethod *excarray
*                                         );
* FUNCTION
*    Copy and modify a DTMethods array.
*    This function is for subclass implementors for an easy way to
*    add their trigger methods to existing ones, or disable some because
*    they're internally used.
*
* INPUTS
*    methods - Methods array, as obtained by GetDTTriggerMethods or
*              DTA_TriggerMethods.  NULL causes the function to 
*              return NULL.
*
*    include - Trigger methods to include. May be NULL.
*
*    exclude - Trigger methods to exclude. May be NULL.
*              The dtm_Command and dtm_Method fields may have
*              the options described in FindTriggerMethod to
*              filter/match out the given entries.
*
* NOTES
*    It is assumed that the dtm_Label and dtm_Command strings are
*    valid as long as the object exists. They are NOT copied.
*
*    Subclasses which implements DTM_TRIGGER __MUST__ send unknown
*    trigger methods to it's superclass.
*
* RESULT
*    newmethods - New array of methods or NULL (no memory).
************************************************************************
*
*/

METHODFUNC OBJECT *ATCopyDTTriggerMethods( OBJECT *mobj, 
                                           OBJECT *iobj,
                                           OBJECT *eobj
                                         )
{
   struct DTMethod *methods  = (struct DTMethod *) CheckObject( mobj );
   struct DTMethod *incarray = (struct DTMethod *) CheckObject( iobj );
   struct DTMethod *excarray = (struct DTMethod *) CheckObject( eobj );
   struct DTMethod *chk      = (struct DTMethod *) NULL;
   OBJECT          *rval     = o_nil;
   
   chk = CopyDTTriggerMethods( methods, incarray, excarray );
   
   if (!chk) // == NULL)
      return( rval );
   else
      return( rval = AssignObj( new_address( (ULONG) chk ) ) );
}            

/****i* ATDoDTDomainA() [1.8] ******************************************
*
* NAME
*    ATDoDTDomainA()
*
* DESCRIPTION
*    Obtain the min/nom/max domains of a dt object.(V45)
*    ^ <primitive 210 19 obj w r rp which pArray tagArray>
*
* SYNOPSIS
*    ULONG rval = ATDoDTDomainA( Object           *o, 
*                                struct Window    *win, 
*                                struct Requester *req,
*                                struct RastPort  *rport, 
*                                ULONG             which, 
*                                struct IBox      *domain, 
*                                struct TagItem   *attrTags
*                              );
*
* INPUTS
*    o      - Object like returned from NewDTObjectA
*    win    - Window the object is attached to
*    req    - Requester the object is attached to
*    rport  - RastPort, used for domain calculations
*    which  - one of the GDOMAIN_#? identifiers from
*             <intuition/gadgetclass.h>
*    domain - resulting domain box
*    attrs  - Additional attributes
*
* RETURNS
*    retval - The return value returned by GM_DOMAIN or 0UL for an error.
*
*    domain - On success, the domain box will be filled with the
*             gadget's domain dimensions for this particular GDOMAIN_#?
*             id.
*
* NOTES
*    This function cannot handle the GM_DOMAIN method without
*    an object. To do this, you have to use CoreceMethodA manually.
************************************************************************
*
*/
# ifdef __SASC
METHODFUNC OBJECT *ATDoDTDomainA( OBJECT *obj,
                                  OBJECT *wobj,
                                  OBJECT *robj,
                                  OBJECT *rpobj,
                                  OBJECT *whichObj,
                                  OBJECT *dObj,
                                  OBJECT *tagArray
                                )
{
   struct TagItem   *tags   = (struct TagItem   *) NULL;
   struct Window    *win    = (struct Window    *) CheckObject( wobj  ); 
   struct Requester *req    = (struct Requester *) CheckObject( robj  );
   struct RastPort  *rport  = (struct RastPort  *) CheckObject( rpobj );
   struct IBox      *domain = (struct IBox      *) CheckObject( dObj  );
   Object           *object = (Object           *) CheckObject( obj   );

   ULONG   which = (ULONG) int_value( whichObj );
   ULONG   chk   = 0L;
   OBJECT *rval  = o_nil;

   if (tagArray != o_nil)
      {
      if (!(tags = ArrayToTagList( tagArray ))) // == NULL)
         return( rval );
      }

   chk = DoDTDomainA( object, win, req, rport, which, domain, tags );

   AT_FreeVec( tags, "DoDTDomainTags", TRUE );

   if (chk == FALSE)
      return( rval );
   else
      return( rval = AssignObj( new_int( (int) chk ) ) );
}
#endif

/****i* ATDrawDTObjectA() [1.8] ****************************************
*
* NAME
*    ATDrawDTObjectA()
*
* DESCRIPTION
*    Draw a DataTypes object.         (V39)
*    ^ <primitive 210 20 obj rastPort x y w h htop vtop attrTags>
*
*  SYNOPSIS
*    BOOL DrawDTObjectA( struct RastPort *rp, 
*                        Object          *obj, 
*                        LONG             x, 
*                        LONG             y,
*                        LONG             w, 
*                        LONG             h, 
*                        LONG             th, 
*                        LONG             tv,
*                        struct TagItem  *attrs 
*                      );
*
* FUNCTION
*    This function is used to draw a DataTypes object into a RastPort.
*
*    This function can be used for strip printing the object or
*    embedding it within a document.
*
*    You must successfully call ObtainDTDrawInfoA before using
*    this function.
*
*    This function invokes the object's DTM_DRAW method.
*
*    Clipping MUST be turned on within the RastPort.  This means
*    that there must be a valid layer structure attached to the
*    RastPort, otherwise some datatypes can't draw (FALSE returned).
*
* INPUTS
*    rp    - Pointer to the RastPort to draw into.
*            Starting with V45, a NULL arg will result in a NOP.
*
*    o     - Pointer to an object returned by NewDTObjectA.
*            Starting with V45, a NULL arg will result in a NOP.
*
*    x     - Left edge of area to draw into.
*
*    y     - Top edge of area to draw into.
*
*    w     - Width of area to draw into.
*
*    h     - Height of area to draw into.
*
*    th    - Horizontal top in units.
*
*    tv    - Vertical top in units.
*
*    attrs - Additional attributes.
*
* TAGS
*    Good args are ADTA_Frame for animationclass objects (requires
*    animationclass V41), which selects the frame being drawn.
*
* RETURNS
*    TRUE to indicate that it was able to render, FALSE on failure;
************************************************************************
*
*/

METHODFUNC OBJECT *ATDrawDTObjectA( OBJECT *rpobj,
                                    OBJECT *obj,
                                    OBJECT *xobj,
                                    OBJECT *yobj,
                                    OBJECT *wobj,
                                    OBJECT *hobj,
                                    OBJECT *thobj,
                                    OBJECT *tvobj,
                                    OBJECT *tagArray
                                  )
{
   struct TagItem  *attrs  = (struct TagItem  *) NULL;
   struct RastPort *rport  = (struct RastPort *) CheckObject( rpobj );
   Object          *object = (Object          *) CheckObject( obj   );
   
   OBJECT *rval = o_false;
   BOOL    chk  = FALSE;

   if (tagArray != o_nil)
      {
      if (!(attrs = ArrayToTagList( tagArray ))) // == NULL)
         return( rval );
      }

   chk = DrawDTObjectA( rport, object, int_value( xobj ),
                        int_value( yobj ), int_value( wobj ),
                        int_value( hobj ), int_value( thobj ),
                        int_value( tvobj ), attrs
                      );

   AT_FreeVec( attrs, "DrawDTObjectTags", TRUE );
   
   if (chk == TRUE)
      rval = o_true;
   else
      rval = o_false;
      
   return( rval );
}

/****i* ATFindMethod() [1.8] ********************************************
*
* NAME
*    ATFindMethod()
*
* DESCRIPTION
*    find a specified method in methods array (V45)
*    ^ <primitive 210 21 methodsArray theMethod>
*
* SYNOPSIS
*    ULONG *method = ATFindMethod( ULONG *methods, ULONG searchmethodid );
*
* FUNCTION
*    This function searches for a given method in a given methods
*    array like that obtained from GetDTMethods.
*
* INPUTS
*    methods - methods array, like that obtained from GetDTMethods or 
*              DTA_Methods.  NULL is a valid arg.
*
*    searchmethodid - method id to find.
*
* RETURNS
*    Pointer to the method table entry or NULL if not found.
*************************************************************************
*
*/

METHODFUNC OBJECT *ATFindMethod( OBJECT *metObjs, OBJECT *searchObj )
{
   OBJECT *rval     = o_nil;
   ULONG  *methods  = (ULONG *) CheckObject( metObjs   );
   ULONG   searchID = (ULONG  ) CheckObject( searchObj );

   ULONG  *chk      = FindMethod( methods, searchID );
   
   if (!chk) // == NULL)
      return( rval );
   else
      return( rval = AssignObj( new_address( (ULONG) chk ) ) );
}

/****i* ATFindToolNodeA() [1.8] *****************************************
*
* NAME
*    ATFindToolNodeA()
*
* DESCRIPTION 
*    Find a tool node (V45)
*    ^ <primitive 210 22 toolList attrTags>
*
* SYNOPSIS
*    struct ToolNode *tn = FindToolNodeA( struct List    *toollist, 
*                                         struct TagItem *attrs 
*                                       );
*
* FUNCTION
*    This function searches for a given tool in a list of tool nodes.
*
* INPUTS
*    toollist - struct List * or a struct ToolNode * (which will be
*               skipped) to search in.  NULL is a valid arg.
*
*    attrs    - Search tags.  A NULL arg returns simple the following node.
*
* TAGS
*    TOOLA_Program    - name of the program to search for
*    TOOLA_Which      - one of the TW_#? types.
*    TOOLA_LaunchType - Launch mode; TF_SHELL, TF_WORKBENCH or TF_RX
*
* RETURNS
*    struct ToolNode * or NULL.
*
* NOTES
*    This function is not limited to the (&(DataType->dtn_ToolList));
*    programmers can set up their own lists.
*    The (&(DataType->dtn_ToolList)) entries are valid as long as 
*    the application obtains a lock to the DataType (as obtained from
*    a dt object, ObtainDataTypeA or LockDataType).
*************************************************************************
*
*/
#ifdef  __SASC
METHODFUNC OBJECT *ATFindToolNodeA( OBJECT *tlistobj, OBJECT *tagArray )
{
   struct List     *toollist = (struct List *) CheckObject( tlistobj );
   struct ToolNode *tn       = (struct ToolNode *) NULL;
   struct TagItem  *tags     = (struct TagItem  *) NULL;
   OBJECT          *rval     = o_nil;

   if (tagArray != o_nil)
      {
      if (!(tags = ArrayToTagList( tagArray ))) // == NULL)
         return( rval );
      }

   tn = (struct ToolNode *) FindToolNodeA( toollist, tags );
   
   AT_FreeVec( tags, "FindToolNodeTags", TRUE );
   
   if (!tn) // == NULL)
      return( rval );
   else
      return( rval = AssignObj( new_address( (ULONG) tn ) ) );
}
#endif

/****i* ATFindTriggerMethod() [1.8] *************************************
*
* NAME
*    ATFindTriggerMethod()
*
* DESCRIPTION 
*    find a specified trigger method in trigger methods array. (V45)
*    ^ <primitive 210 23 dtnObj command method>
*
* SYNOPSIS
*    struct DTMethod *method = ATFindTriggerMethod( struct DTMethod *dtm, 
*                                                   STRPTR command, 
*                                                   ULONG  method 
*                                                 );
*
* FUNCTION
*    This function searches for a given trigger method in a given methods
*    array like that obtained from GetDTTriggerMethods.
*
*    If one of the "command" or "method" args matches a array item, this
*    function returns a pointer to it.
*
* INPUTS
*    methods - trigger methods array, like got from GetDTTriggerMethods
*              or DTA_TriggerMethods.  NULL is a valid arg.
*
*    command - trigger method command name (case-insensitive match),
*              may be NULL (don't match).
*
*    method  - trigger method id, may be ~0UL (don't match).
*
* RETURNS
*    Pointer to the trigger method table entry (struct DTMethod *) or
*    NULL if not found.
*************************************************************************
*
*/

METHODFUNC OBJECT *ATFindTriggerMethod( OBJECT *dtmObj,
                                        OBJECT *cmdObj,
                                        OBJECT *method
                                      )
{
   struct DTMethod *obj  = (struct DTMethod *) CheckObject( dtmObj );
   struct DTMethod *dtm  = (struct DTMethod *) NULL;

   STRPTR           cmd  = (STRPTR) string_value( (STRING *) cmdObj );
   ULONG            trig = (ULONG ) int_value(    method );
   OBJECT          *rval = o_nil;

   dtm = FindTriggerMethod( obj, cmd, trig );

   if (dtm) // != NULL)
      rval = AssignObj( new_address( (ULONG) dtm ) );

   return( rval );
}
                                      
/****i* ATFreeDTMethods() [1.8] *****************************************
*
* NAME
*    ATFreeDTMethods()
*    <primitive 210 24 methodsArray>
*
* DESCRIPTION
*    Free methods array obtained by CopyDT#?Methods   (V45)
*
* SYNOPSIS
*    void ATFreeDTMethods( APTR methods );
*
* INPUTS
*    methods - Methods array, as obtained by CopyDTMethods or
*              CopyDTTriggerMethods. NULL is a valid input.
************************************************************************
*
*/

METHODFUNC void ATFreeDTMethods( OBJECT *methodsObj )
{
   // methodsObj type already checked: 
   FreeDTMethods( (APTR) addr_value( methodsObj ) );

   return;
}

/****i* ATGetDTTriggerMethodDataFlags() [1.8] **************************
*
* NAME
*    ATGetDTTriggerMethodDataFlags()
*
* DESCRIPTION
*    Get data type of dtt_Data value (V45)
*    ^ <primitive 210 25 methodNumber>
*
* SYNOPSIS
*    ULONG type = ATGetDTTriggerMethodDataFlags( ULONG method );
*
* FUNCTION
*    This function returns the kind of data which can be attached
*    to the stt_Data field in the dtTrigger method body.
*
*    The data type can be specified by or'ing the method id (within
*    STMF_METHOD_MASK value) with one of the STMD_#? identifiers:
*
*    STMD_VOID    - stt_Data MUST be NULL
*    STMD_ULONG   - stt_Data contains an unsigned long value
*    STMD_STRPTR  - stt_Data is a string pointer
*    STMD_TAGLIST - stt_Data points to an array of struct TagItem's,
*                   terminated with TAG_DONE
*
*    The trigger methods below STM_USER are explicitly handeled, as
*    described in <datatypes/datatypesclass.h>, e.g. STM_COMMAND
*    return STMD_STRPTR, instead of STMD_VOID.
*
* INPUTS
*    method - dtt_Method ID from struct DTMethod
*
* RESULT
*    type - one of the STMD_#? #defines in <datatypes/datatypesclass.h>
*
* EXAMPLE
*    struct DTMethod htmldtc_dtm[] = {
*
*       ...
*
*       "Stop Loading", "STOP",       (STM_STOP | STMD_VOID),
*       "Load Images",  "LOADIMAGES", ((STM_USER + 20) | STMD_VOID),
*       "Goto URL",     "GOTOURL",    ((STM_USER + 21) | STMD_STRPTR),
*       ...
*
*       NULL,           NULL,         0L
*    };
*
*    Sets up three methods:
*
*       "STOP"       takes no arguments,
*       "LOADIMAGES" takes no arguments and
*       "GOTOURL"    takes a STRPTR as an argument.
*************************************************************************
*
*/
#ifdef  __SASC
METHODFUNC OBJECT *ATGetDTTriggerMethodDataFlags( OBJECT *method )
{
   OBJECT *rval = o_nil;

   ULONG   mthd = (ULONG) CheckObject( method );

   ULONG   type = GetDTTriggerMethodDataFlags( mthd );
   
   rval = AssignObj( new_address( (ULONG) type ) );

   return( rval );
}
#endif

/****i* ATLaunchToolA() [1.8] *******************************************
*
* NAME
*    ATLaunchToolA()
*
* DESCRIPTION
*    invoke a given tool with project. (V45)
*    ^ <primitive 210 26 toolObj projectString attrTags>
*
* SYNOPSIS
*    ULONG success = ATLaunchToolA( struct Tool    *tool, 
*                                   STRPTR          project, 
*                                   struct TagItem *attrs 
*                                 );
*
* FUNCTION
*    This function launches an application with a specified project.
*    The application and it's launch mode and other attributes are
*    specified through the "Tool" structure.
*
* INPUTS
*    tool    - Pointer to a Tool structure.  NULL is a valid arg.
*    project - Name of the project to execute or NULL.
*    attrs   - Additional attributes.
*
* TAGS
*    NP_Priority (BYTE) - sets the priority of the launched tool
*                         Defaults to the current process's priority for
*    Shell and ARexx programs; Workbench applications
*    defaults to 0 except overridden by the TOOLPRI tooltype.
*
*    NP_Synchronous (BOOL) - don't return until lauched application 
*                            process finishes.  Defaults to FALSE.
*
*    Other tags are __currently__ ignored.
*
* RETURNS
*    FALSE for failure, non-zero for success.
*
* NOTES
*    - This function requrires the "RX" command when lauching ARexx
*      scripts.
*
*    - This function must be launched from a process, not a simple task.
*
*    - This function is not limited to use the struct DataType->dtn_Tools
*      tools.  Applications can set up their own struct Tool's as long
*      as these structures contains no rubbish.
*      If you don't know the TW_#? ("which") type of your custom tool, 
*      set tn_Which to TW_MISC.
*
* TODO
*    - Should support multiple projects for WB programs.
*    - Shell tools should have a setable stack size...
*
* BUGS
*    - The WB launcher does not search the WB path for "Default Tools".
*    - The "%a" (Arguments) option for shell launched tools does
*      not currently work.
*      Will be fixed.
*    - The path of the launched tools depends on the parents path.
*      If there is no path, shell tools can only launch other tools
*      with their full path.
*************************************************************************
*
*/

#ifdef __SASC
METHODFUNC OBJECT *ATLaunchToolA( OBJECT *toolObj, 
                                  OBJECT *projString, 
                                  OBJECT *tagArray
                                )
{
   struct TagItem *attrs = (struct TagItem *) NULL;
   struct Tool    *tool  = (struct Tool *) CheckObject( toolObj );
   STRPTR          str   = (STRPTR)        string_value( (STRING *) projString );

   OBJECT         *rval  = o_false;
   ULONG           chk   = FALSE;

   if (tagArray != o_nil)
      {
      if (!(attrs = ArrayToTagList( tagArray ))) // == NULL)
         return( rval );
      }

   chk = LaunchToolA( tool, str, attrs );
                      
   AT_FreeVec( attrs, "LaunchToolATags", TRUE );
   
   if (chk != FALSE)
      rval = o_true;
      
   return( rval );
}

/****i* ATLockDataType() [1.8] ******************************************
*
* NAME
*    ATLockDataType()
*
* DESCRIPTION
*    Lock a DataType structure.         (V45)
*    <primitive 210 27 dtObj>
*
* SYNOPSIS
*    void ATLockDataType( struct DataType *dtn );
*
* FUNCTION
*    This function is used to lock a DataType structure obtained
*    by ObtainDataTypeA or a datatypes object (DTA_DataType attribute).
*
*    All calls to LockDataType or ObtainDataTypeA must match the same
*    number of ReleaseDataType calls, otherwise havoc will break out.
*
* INPUTS
*    dtn - DataType structure returned by ObtainDataTypeA. NULL
*          is a valid input.
*
* NOTES
*    This function has been made public to allow getting a DataType
*    structure from an object (DTA_DataType attribute), and keep the
*    reference valid after the object has been disposed of (which
*    unlocks the DataType structure locked in NewDTObjectA).
*************************************************************************
*
*/

METHODFUNC void ATLockDataType( OBJECT *dtnBytes )
{
   struct DataType *dtn = (struct DataType *) CheckObject( dtnBytes );
   
   LockDataType( dtn );
   
   return;   
}
#endif // __amigaos4__

/****i* ATObtainDTDrawInfoA() [1.8] *************************************
*
* NAME
*    ATObtainDTDrawInfoA()
*
* DESCRIPTION
*    Obtain a DataTypes object for drawing. (V39)
*    ^ <primitive 210 28 object attrTags>
*
* SYNOPSIS
*    APTR handle = ATObtainDTDrawInfoA( Object *o, struct TagItem *attrs );
*
* FUNCTION
*    This function is used to prepare a DataTypes object for
*    drawing into a RastPort.
*
*    This function will send the DTM_OBTAINDRAWINFO method
*    to the object using the opSet message structure.
*
* INPUTS
*    o     - Pointer to an object as returned by NewDTObjectA.
*            Starting with V45, a NULL arg results in a NOP.
*
*    attrs - Additional attributes.
*
* RETURNS
*    Returns a PRIVATE handle that must be passed to ReleaseDTDrawInfo
*    when the application is done drawing the object.
*    A NULL return value indicates failure.
*
* TAGS
*    Good args are:
*    PDTA_Screen for pictureclass objects and
*    ADTA_Screen for animationclass objects.
*
* NOTES
*    You cannot handle the same datatypesclass object as a gadget in
*    a window/requester and as an image using ObtainDTDrawInfoA/
*    DrawDTObjectA/ReleaseDTDrawInfo at the same time.
*    But using it as a gadget, then remove it from window, then use 
*    it as an image is valid and __must__ be supported.
************************************************************************
*
*/

METHODFUNC OBJECT *ATObtainDTDrawInfoA( OBJECT *obj, OBJECT *tArray )
{
   struct TagItem *attrs  = (struct TagItem *) NULL;
   Object         *object = (Object *) CheckObject( obj );
   OBJECT         *rval   = o_nil;
   APTR            chk    = NULL;

   if (tArray != o_nil)
      {
      if (!(attrs = ArrayToTagList( tArray ))) // == NULL)
         return( rval );
      }

   chk = ObtainDTDrawInfoA( object, attrs );

   AT_FreeVec( attrs, "ObtainDTDrawInfoTags", TRUE );

   if (!chk) // == NULL)
      return( rval );
   else
      return( rval = AssignObj( new_address( (ULONG) chk ) ) );
}

/****i* ATReleaseDTDrawInfo() [1.8] ************************************
*
* NAME
*    ReleaseDTDrawInfo()
*
* DESCRIPTION
*    Release a DataTypes object from drawing. (V39)
*    <primitive 210 29 anObject aHandle>
*
* SYNOPSIS
*    void ReleaseDTDrawInfo( Object *o, APTR handle );
*
* FUNCTION
*    This function is used to release the information obtained
*    with ObtainDTDrawInfoA.
*
*    This function invokes the object's DTM_RELEASEDRAWINFO method
*    using the dtReleaseDrawInfo message structure.
*
* INPUTS
*    o      - Object returned by NewDTObjectA.
*             Starting with V45, a NULL arg results in a NOP.
*
*    handle - Pointer to an private handle obtained by ObtainDTDrawInfoA.
************************************************************************
*
*/

METHODFUNC void ATReleaseDTDrawInfo( OBJECT *obj, OBJECT *diObj )
{
   Object *object = (Object *) CheckObject( obj   );
   APTR    handle =     (APTR) CheckObject( diObj );

   ReleaseDTDrawInfo( object, handle );
   
   return;
}

/****i* ATSaveDTObjectA() [1.8] ****************************************
*
* NAME
*    ATSaveDTObjectA()
*
* DESCRIPTION
*    Save object's contents.   (V45)
*    ^ <primitive 210 30 obj windowObj reqObj filename filemode 
*                        saveIconBool attrTags>  
*
* SYNOPSIS
*    BOOL SaveDTObjectA( Object           *o, 
*                        struct Window    *win, 
*                        struct Requester *req,
*                        STRPTR            filename, 
*                        ULONG             filemode, 
*                        BOOL              saveicon, 
*                        struct TagItem   *attrs 
*                      );
*
* FUNCTION
*    This function saves the contents of an object into a file.
*
*    The function opens the named file and saves the object's contexts
*    into it (DTM_WRITE). Then it closes the file.
*    If the DTM_WRITE method returns success and the saveicon option is
*    TRUE, matching icon is saved.
*
*    If DTM_WRITE returns 0, the file will be deleted.
*
* INPUTS
*    o        - Object like returned from NewDTObjectA
*    win      - Window the object is attached to
*    req      - Requester the object is attached to
*    file     - file name to save to
*    mode     - Save mode, (RAW, IFF etc.), one of the DTWM_#? identifiers
*    saveicon - Save icon ?
*    attrs    - Additional attributes.
*
* RETURNS
*    success - The return value returned by DTM_WRITE or NULL for an
*              error.
*
* BUGS
*    - Does currently not delete the file on failure.
*
*    - In V45.2 and before, the file was closed after the icon was
*      written. This caused Workbench to show the size of the icon
*      instead of the real file.
*      Fixed.
*
*    - Starting with V45.3, the return value of Close will be watched
*      correctly and may cause failure of this function.
************************************************************************
*
*/

METHODFUNC OBJECT *ATSaveDTObjectA( OBJECT *obj,
                                    OBJECT *wobj,
                                    OBJECT *reqobj,
                                    OBJECT *filename,
                                    OBJECT *fmode,
                                    OBJECT *saveflag,
                                    OBJECT *tagsObj 
                                  )
{
   Object           *object = (Object *) NULL;
   struct Window    *win    = (struct Window    *) CheckObject( wobj   );
   struct Requester *req    = (struct Requester *) CheckObject( reqobj );

   char             *fname  = string_value( (STRING *) filename );
   int               mode   = int_value( fmode );
   BOOL              sflag  = (saveflag == o_true) ? TRUE : FALSE;

   struct TagItem   *tags   = (struct TagItem *) NULL;
   OBJECT           *rval   = o_nil;
   ULONG             chk    = 0L;
   
   if (PTRCHK( obj ) == TRUE)
      {
      object = (Object *) CheckObject( obj );

      if (!object) // == NULL)
         return( rval );
      }
      
   if (PTRCHK( tagsObj ) == TRUE)
      {
      tags = ArrayToTagList( tagsObj );

      if (!(tags = ArrayToTagList( tagsObj ))) // == NULL)
         return( rval );
      }

   chk = SaveDTObjectA( object, win, req, fname, mode, sflag, tags );

   AT_FreeVec( tags, "SaveDTObjectTags", TRUE );

   if (!chk) // == NULL)
      return( rval );
   else
      return( rval = AssignObj( new_int( chk ) ) );   
}

/****i* ATStartDragSelect() [1.8] **************************************
*
* NAME
*    ATStartDragSelect()    <primitive 210 31 onObject>
*
* DESCRIPTION
*    Start drag-selection   (V45)
*
* SYNOPSIS
*    BOOL success = StartDragSelect( Object *o );
*
* FUNCTION
*    This function starts drag-selection by the user (marking).
*
*    This function replaces the old flag-fiddling method to
*    start drag-select.
*
*    The drag-select will only be started of the object supports
*    DTM_SELECT, is in a window or requester and no layout-process
*    is working on the object. If all conditions are good, it sets
*    the DTSIF_DRAGSELECT flag and returns TRUE for success.
*
*    Starting with V45.4 Resul2 (IoErr()) contains some extra info
*    about the cause:
*      ERROR_ACTION_NOT_KNWON -- DTM_SELECT not supported
*      ERROR_OBJECT_IN_USE    -- async layout etc. peding etc.
*
* INPUTS
*    o - object like that returned from NewDTObjectA
*
* RETURNS
*    TRUE for success, FALSE for failure.
************************************************************************
*
*/

METHODFUNC OBJECT *ATStartDragSelect( OBJECT *obj )
{
   Object *ob   = (Object *) CheckObject( obj );
   OBJECT *rval = o_false;

   if (StartDragSelect( ob ) == TRUE)
      rval = o_true;
      
   return( rval );
}

/****i* ATGetFileType() [2.4] ******************************************
*
* NAME
*    ATGetFileType()    <primitive 210 37 fileName>
*
* DESCRIPTION
*    Determine the type of a dataType file.
*
* RETURNS
*    DataType String or nil for failure.
************************************************************************
*
*/

METHODFUNC OBJECT *ATGetFileType( char *fileName )
{
   struct DataType *dt       = (struct DataType *) NULL;
   BPTR             lock     = 0; // NULL;
   char             buf[256] = { 0, };
   OBJECT          *rval     = o_nil;
   APTR             alock    = 0; // NULL;
         
   if (!(lock = Lock( fileName, SHARED_LOCK ))) // == NULL)
      return( rval );
   else
      alock = (APTR) ((int) lock * 4);
   
   if (!(dt = ObtainDataTypeA( DTST_FILE, alock, NULL ))) // == NULL)
      goto ExitGetFileType;
   
   (void) StringNCopy( buf, dt->dtn_Header->dth_Name, 256 );

   rval = AssignObj( new_str( &buf[0] ) );

ExitGetFileType:
       
   UnLock( lock );
      
   return( rval );   
}
    
/****h* HandleDT() [1.8] ***********************************************
*
* NAME
*    HandleDT() {Primitive 210}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    DataType interfacing methods.
************************************************************************
*
*/

PUBLIC OBJECT *HandleDT( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 210 );
      return( rval );
      }

   // Guarantee that the datatypes.library is open:

   if (!OpenDTLibrary()) // == NULL)
      {
      NotOpened( 4 ); // DT_LIB_VERS );

      return( rval );
      }

   switch (int_value( args[0] ))
      {
      case 0: // newDTObject: dtName tags: tagArray
              //   ^ <primitive 210 0 dtName tagArray>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATNewDTObjectA( (APTR) string_value( (STRING *) args[1] ),
                                   args[2]
                                 );
         break;

      case 1: // disposeDTObject: theObject
              //   <primitive 210 1 theObject>
         if (ChkArgCount( 1, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            ATDisposeDTObject( args[1] );

         break;
      
      case 2: // addDTObject: windowObj position: glistPos
              //   ^ <primitive 210 2 window glistPos private>
         if (ChkArgCount( 3, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE || is_integer( args[2] ) == FALSE
            || is_address( args[3] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATAddDTObject( args[1], args[2], args[3] );

         break;
      
      case 3: // removeDTObject: windowObj
              //   ^ <primitive 210 3 windowObj private>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE || is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATRemoveDTObject( args[1], args[2] );

         break;
      
      case 4: // doAsyncLayout: layoutMsg
              //   ^ <primitive 210 4 private layoutMsg>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE || is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATDoAsyncLayout( args[1], args[2] );

         break;
      
      case 5: // doDTMethod: windowObj req: reqObj msg: message
              //   ^ <primitive 210 5 private windowObj reqObj message>
         if (ChkArgCount( 4, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE   || is_address( args[2] ) == FALSE
            || is_address( args[3] ) == FALSE || is_address( args[4] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATDoDTMethod( args[1], args[2], args[3], args[4] );

         break;
      
      case 6: // getDTAttrs: tagArray
              //   ^ <primitive 210 6 private tagArray>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATGetDTAttrs( args[1], args[2] );

         break;

      case 7: // getDTMethods
              //   ^ <primitive 210 7 private>
         if (ChkArgCount( 1, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATGetDTMethods( args[1] );

         break;

      case 8: // getDTString: stringID
              //   ^ <primitive 210 8 stringID>
         /*
         ** - Error codes from 1-499 belongs to DOS, error codes from
         **   500-999 belongs to ENVOY and error codes from 2000-2099
         **   belongs to DataTypes. Codes between 2100 and 2999 are
         **   used to access localized DataTypes strings.
         **
         ** - Does not support the ENVOY error code nor the DOS error code space
         **   (use dos.library/Fault in this case).
         */
         {
         int  errnum = 0;
         char buffer[256];
                  
         if (ChkArgCount( 1, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_integer( args[1] ) == FALSE)
            {
            (void) PrintArgTypeError( 210 );
            break; 
            }

         errnum = int_value( args[1] );

         if (errnum > 0 && errnum < 500)
            {
            if (Fault( errnum, DTypeCMsg( MSG_DT_DOS_ERROR_DTYPE ), 
                               buffer, 256 ) != 0)
               rval = AssignObj( new_str( buffer ) );
            }
         else if (errnum >= 500 && errnum < 1000)         
            {
            if (Fault( errnum, DTypeCMsg( MSG_DT_ENV_ERROR_DTYPE ),
                               buffer, 256 ) != 0)
               rval = AssignObj( new_str( buffer ) );
            }
         else if (errnum >= 2000 && errnum < 2100)
            rval = AssignObj( new_str( (char *) GetDTString( (ULONG) errnum )));
         else if (errnum >= 2100 && errnum < 3000)
            rval = AssignObj( new_str( (char *) GetDTString( (ULONG) errnum )));
         }

         break;

      case 9: // getDTTriggerMethods
              //   ^ <primitive 210 9 private>
         if (ChkArgCount( 1, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else 
            rval = ATGetDTTriggerMethods( args[1] );

         break;

      case 10: // examineFile: filename attrs: tagArray
               //   ^ <primitive 210 10 filename tagArray>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else 
            rval = ATObtainDataTypeA( DTST_FILE, args[1], args[2] );

         break;

      case 11: // examineClip: clipHandle attrs: tagArray
               //   ^ <primitive 210 11 clipHandle tagArray>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else 
            rval = ATObtainDataTypeA( DTST_CLIPBOARD, args[1], args[2] );

         break;

      case 12: // printDTObject: windowObj req: reqObj prtObj: prtMsg
               //   ^ <primitive 210 12 private windowObj reqObj prtMsg>
         if (ChkArgCount( 4, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE   || is_address( args[2] ) == FALSE
            || is_address( args[3] ) == FALSE || is_address( args[4] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATPrintDTObjectA( args[1], args[2], args[3], args[4] );

         break;
      
      case 13: // refreshDTObject: windowObj attrs: tagArray
               //   ^ <primitive 210 13 private windowObj tagArray>
         if (ChkArgCount( 3, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE || is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            ATRefreshDTObjectA( args[1], args[2], args[3] );

         break;
      
      case 14: // releaseDTObject
               //   ^ <primitive 210 14 private>
         if (ChkArgCount( 1, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            ATReleaseDataType( args[1] );

         break;
      
      case 15: // setDTAttrs: windowObj req: reqObj tags: tagArray
               //   ^ <primitive 210 15 private windowObj reqObj tagArray>
         if (ChkArgCount( 4, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE || is_address( args[2] ) == FALSE
                                            || is_address( args[3] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATSetDTAttrsA( args[1], args[2], args[3], args[4] );

         break;
      
      case 16: // translateDTErrorNum
               // ^ <primitive 210 16>

         rval = TranslateDTErrorNum();
         break;

      case 17: // copyDTMethods: array including: incArray excluding: excArray
               // <primitive 210 17 array incArray excArray>
         if (ChkArgCount( 3, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_integer( args[1] ) == FALSE || is_integer( args[2] ) == FALSE
                                            || is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATCopyDTMethods( args[1], args[2], args[3] );
   
         break; 

      case 18: // copyDTTriggerMethods: byteArray including: ibArray excluding: ebArray
               // <primitive 210 18 byteArray ibArray ebArray> 
         if (ChkArgCount( 3, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE || is_address( args[2] ) == FALSE
                                            || is_address( args[3] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATCopyDTTriggerMethods( args[1], args[2], args[3] );
   
         break; 

#     ifdef    __SASC
      case 19: // doDTDomain: obj window: w req: r rport: rp flag: which
               //     domain: pArray tags: tagArray       
               //  ^ <primitive 210 19 obj w r rp which pArray tagArray>
         if (ChkArgCount( 7, numargs, 210 ) != 0)
            return( ReturnError() );
         
         if (!is_address( args[1] )   || !is_address( args[2] )   
            || !is_address( args[3] ) || !is_integer( args[4] ) 
            || !is_address( args[5] ) || !is_integer( args[6] ))
            (void) PrintArgTypeError( 210 );
         else               
            rval = ATDoDTDomainA( args[1], args[2], args[3], args[4],
                                  args[5], args[6], args[7]
                                );
         break; 
#     endif

      case 20: // drawDTObject: obj rport: rastPort start: pt1 end: pt2 h: v: attrs:
               //  ^ <primitive 210 20 obj rastPort x y w h htop vtop attrTags>
         if (ChkArgCount( 9, numargs, 210 ) != 0)
            return( ReturnError() );

         if (!is_address( args[1] )   || !is_address( args[2] )   
            || !is_integer( args[3] ) || !is_integer( args[4] ) 
            || !is_integer( args[5] ) || !is_integer( args[6] )
            || !is_integer( args[7] ) || !is_integer( args[8] ))
            (void) PrintArgTypeError( 210 );
         else
            rval = ATDrawDTObjectA( args[1], args[2], args[3], args[4],
                                    args[5], args[6], args[7], args[8],
                                    args[9]
                                  );
         break; 

      case 21: // findThisMethod: theMethod in: methodsArray
               //   ^ <primitive 210 21 methodsArray theMethod>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATFindMethod( args[1], args[2] );
      
         break; 

#     ifdef    __SASC
      case 22: // findToolNode: toolList attrs: attrTags
               //   ^ <primitive 210 22 toolList attrTags>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATFindToolNodeA( args[1], args[2] );

         break;
#     endif

      case 23: // findTriggerMethod: dtnObj command: cmdStr method: methodNumber
               //   ^ <primitive 210 23 dtnObj cmdStr methodNumber>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );
         
         if (is_address( args[1] ) == FALSE || is_string( args[2]) == FALSE 
                                            || is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATFindTriggerMethod( args[1], args[2], args[3] );

         break; 

      case 24: // freeDTMethods: methodsArrayPointer
               // <primitive 210 24 methodsArrayPointer>
         if (ChkArgCount( 1, numargs, 210 ) != 0)
            return( ReturnError() );
         
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            ATFreeDTMethods( args[1] );

         break; 

#     ifdef    __SASC
      case 25: // getDTTriggerMethodDataFlags: methodNumber
               // <primitive 210 25 methodNumber>
         if (ChkArgCount( 1, numargs, 210 ) != 0)
            return( ReturnError() );
         
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATGetDTTriggerMethodDataFlags( args[1] );
   
         break; 

      case 26: // launchTool: toolObj project: projectString attrs: attrTags
               //   ^ <primitive 210 26 toolObj projectString attrTags>
         if (ChkArgCount( 3, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE || is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else         
            rval = ATLaunchToolA( args[1], args[2], args[3] ); // return o_true or o_false
   
         break; 

      case 27: // lockDataType: dtnObj
               // <primitive 210 27 dtnObj>
         if (ChkArgCount( 1, numargs, 210 ) != 0)
            return( ReturnError() );
         
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            ATLockDataType( args[1] );

         break; 

#     endif // __amigaos4__

      case 28: // obtainDTDrawInfo: object attrs: attrTags
               // ^ <primitive 210 28 object attrTags>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATObtainDTDrawInfoA( args[1], args[2] );
   
         break; 

      case 29: // releaseDTDrawInfo: anObject handle: aHandle
               // <primitive 210 29 anObject aHandle>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE || is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            ATReleaseDTDrawInfo( args[1], args[2] );

         break; 

      case 30: // saveDTObject: obj    window: wObj       req: reqobj file: filename
               //         mode: filemode flag: saveflag attrs: tagsObj
               // <primitive 210 30 obj wobj reqobj filename fmode saveflag tagsObj>  
         if (ChkArgCount( 7, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE   || is_address( args[2] ) == FALSE 
            || is_address( args[3] ) == FALSE || is_string( args[4] ) == FALSE 
            || is_integer( args[5] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATSaveDTObjectA( args[1], args[2], args[3], args[4],
                                    args[5], args[6], args[7]
                                  );
         break; 

      case 31: // startDragSelect: onObject
               // <primitive 210 31 onObject>  
         if (ChkArgCount( 1, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else 
            rval = ATStartDragSelect( args[1] ); // rval == true or false
         
         break; 

      // Calls to functions in TagFuncs.c:

      case 32: // setTagItem: tag value: newTagValue
               // <primitive 210 32 self tag newTagValue>
         if (ChkArgCount( 3, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_integer( args[2] ) == FALSE || is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            ATSetTagItem( args[1], args[2], args[3] );
   
         break;
         
      case 33: // getTagValue: tag 
               //   ^ <primitive 210 33 self tag>
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_integer( args[2] ) == FALSE) 
            (void) PrintArgTypeError( 210 );
         else
            rval = ATGetTagItem( args[1], args[2] );

         break;
         
      case 34: // addTagItem: newTag value: newTagValue 
               //   ^ <primitive 210 34 self newTag newTagValue> 
         if (ChkArgCount( 3, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_integer( args[2] ) == FALSE || is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = AddTagItem( args[1], args[2], args[3] );

         break;
         
      case 35: // deleteTagItem: theTag
               //   ^ <primitive 210 34 self theTag> 
         if (ChkArgCount( 2, numargs, 210 ) != 0)
            return( ReturnError() );

         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = DeleteTagItem( args[1], args[2] );

         break;

      // User has to explicitly close the datatypes.library:

      case 36: // cleanupDataTypes
               // <primitive 210 36>

         CloseDTLibrary();

         break;

      case 37: // getFileType: fileName
               // ^ <primitive 210 37 fileName>
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 210 );
         else
            rval = ATGetFileType( string_value( (STRING *) args[1] ) );
         
         break;
                         
      default:
         (void) PrintArgTypeError( 210 );

         break;
      }

   return( rval );
}

/* -------------------- END of DTInterface.c file! ------------------- */
