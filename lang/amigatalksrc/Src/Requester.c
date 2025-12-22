/****h* AmigaTalk/Requester.c [3.0] *********************************
*
* NAME
*    Requester.c
*
* DESCRIPTION
*    Functions that handle AmigaTalk requester primitives.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    06-Jan-2003 - Moved all string constants to StringConstants.h
*
* TODO 
*    Simplify this mess by using the EasyRequester stuff in 
*    CommonFuncs.o.
*
* NOTES
*    $VER: AmigaTalk/Src/Requester.c 3.0 (25-Oct-2004) by J.T. Steichen
*********************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"
#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"
#include "IStructs.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *o_nil;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

#ifdef __SASC
# define  CHIPMEM  MEMF_PUBLIC | MEMF_CHIP | MEMF_CLEAR
# define  FASTMEM  MEMF_PUBLIC | MEMF_FAST | MEMF_CLEAR
#else
# define  CHIPMEM  MEMF_SHARED | MEMF_CHIP | MEMF_CLEAR
# define  FASTMEM  MEMF_SHARED | MEMF_FAST | MEMF_CLEAR
#endif

/****i* RequesterRemove() [1.0] **************************************
*
* NAME
*    RequesterRemove()
*
* DESCRIPTION
*    Deallocate a Requester from memory & the AmigaTalk program.
*    <primitive 185 0 private>
**********************************************************************
*
*/

METHODFUNC void  RequesterRemove( OBJECT *reqObj )
{
   struct Requester *rp = (struct Requester *) CheckObject( reqObj );
   
   if (!rp) // == NULL)
      return;
  
   if (rp->ReqBorder) // != NULL)
      return;

   if (rp->ReqGadget) // != NULL)
      return;

   if (rp->ReqText) // != NULL)   
      return;

   if (rp->ImageBMap) // != NULL)
      return;

   AT_FreeVec( rp, "Requester", TRUE ); // It's safe to Free the Requester (whew!)
   
   return;
}

/****i* RequesterAdd() [1.0] *****************************************
*
* NAME
*    RequesterAdd()
*
* DESCRIPTION
*    Add a Requester to the AmigaTalk program space.
*    ^ <primitive 185 1>
**********************************************************************
*
*/

METHODFUNC OBJECT *RequesterAdd( void )
{
   struct Requester *rptr = NULL;
   
   rptr  = (struct Requester *) AT_AllocVec( sizeof( struct Requester ),
                                             CHIPMEM, "Requester", TRUE
                                           );

   if (!rptr) // == NULL)
      {
      MemoryOut( ReqCMsg( MSG_REQADD_FUNC_REQ ) );
         
      return( o_nil );   
      }

   return( AssignObj( new_address( (ULONG) rptr ) ) );
}

/****i* GetRequesterPart() [1.0] *************************************
*
* NAME
*    GetRequesterPart()
*
* DESCRIPTION
*    ^ <primitive 185 whichPart private>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetRequesterPart( int whichpart, OBJECT *reqObj )
{
   struct Requester *rp   = (struct Requester *) CheckObject( reqObj );
   OBJECT           *rval = o_nil;
   
   if (!rp) // == NULL)
      return( rval );
   
   switch (whichpart)
      {
      case 0:
         rval = AssignObj( new_int( rp->LeftEdge ) );
         break;
         
      case 1:
         rval = AssignObj( new_int( rp->TopEdge ) );
         break;
         
      case 2:
         rval = AssignObj( new_int( rp->Width ) );
         break;
         
      case 3:
         rval = AssignObj( new_int( rp->Height ) );
         break;
         
      case 4:
         rval = AssignObj( new_int( rp->RelLeft ) );
         break;
         
      case 5:
         rval = AssignObj( new_int( rp->RelTop ) );
         break;
         
      case 6:
         rval = AssignObj( new_int( rp->Flags ) );
         break;
         
      case 7:
         rval = AssignObj( new_address( (ULONG) rp->BackFill ) );
         break;

      case 8:
         rval = AssignObj( new_address( (ULONG) rp->ReqText ) );
         break;

      case 9:
         rval = AssignObj( new_address( (ULONG) rp->ReqGadget ) );
         break;
         
      case 10:
         rval = AssignObj( new_address( (ULONG) rp->ReqBorder ) );
         break;

      case 11:
         rval = AssignObj( new_address( (ULONG) rp->ImageBMap ) );
         break;

      case 12:
         rval = AssignObj( new_address( (ULONG) rp->ReqImage ) );
         break;
         
      case 13:
         rval = AssignObj( new_address( (ULONG) rp->ReqLayer ) );
         break;
         
      default:
         break;
      }

   return( rval );
}

/****i* SetRequesterPart() [1.0] *************************************
*
* NAME
*    SetRequesterPart()
*
* DESCRIPTION
*    <primitive 185 3 whichPart valueObj private>
**********************************************************************
*
*/

METHODFUNC void SetRequesterPart( int whichpart, OBJECT *value, OBJECT *reqObj )
{
   struct Requester *rp = (struct Requester *) CheckObject( reqObj );
   
   if (!rp) // == NULL)
      return;
   
   switch (whichpart)
      {
      case 0:
         rp->LeftEdge = int_value( value );
         break;

      case 1:
         rp->TopEdge  = int_value( value );
         break;

      case 2:
         rp->Width    = int_value( value );
         break;

      case 3:
         rp->Height   = int_value( value );
         break;

      case 4:
         rp->RelLeft  = int_value( value );
         break;

      case 5:
         rp->RelTop   = int_value( value );
         break;

      case 6:
         rp->Flags    = int_value( value );
         break;

      case 7:
         rp->BackFill = addr_value( value );
         break;

      case 8:
         {
         struct IntuiText *tp = (struct IntuiText *) CheckObject( value );
         
         rp->ReqText = tp;
         }
         
         break;

      case 9:
         {
         struct Gadget *gp = (struct Gadget *) CheckObject( value );
         
         rp->ReqGadget = gp;
         }

         break;
         
      case 10:
         {
         struct Border *bp = (struct Border *) CheckObject( value );
         
         rp->ReqBorder = bp;
         }

         break;

      case 11:
         {
         struct BitMap *bp = (struct BitMap *) CheckObject( value );

         rp->ImageBMap = bp;
         }
         
         break;
         
      case 12:
         {
         struct Image *ip = (struct Image *) CheckObject( value );

         rp->ReqImage = ip;
         }
         
         break;
         
      case 13:
         {
         struct Layer *lp = (struct Layer *) CheckObject( value );

         rp->ReqLayer = lp;
         }
         
         break;
         
      default:
         break;
      }   

   return;
}

/*
VOID EndRequest( struct Requester *requester, struct Window *window );
VOID InitRequester( struct Requester *requester );
BOOL Request( struct Requester *requester, struct Window *window );
*/

/****h* HandleRequesters() [1.9] *************************************
*
* NAME
*    HandleRequesters()
*
* DESCRIPTION
*    Translate primitive 185 calls to Requester functions.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleRequesters( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 185 );
      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // dispose
         if (NullChk( args[1] ) == FALSE)
            {
            RequesterRemove( args[1] );
            }

         break;
      
      case 1: // Requester new ^ private
         rval = RequesterAdd();
         break;

      case 2: // getReqPart [whichPart private]
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 185 );
         else
            rval = GetRequesterPart( int_value( args[1] ), args[2] );

         break;
      
      case 3: // setReqPart: [whichPart] valueObj [private]
         if (is_integer( args[1] ) == FALSE)
           (void) PrintArgTypeError( 185 );
         else
           SetRequesterPart( int_value( args[1] ), args[2], args[3] ); 

         break;

      default:
         (void) PrintArgTypeError( 185 );
         break;
      }

   return( rval );
}

/* -------------------- END of Requester.c file! --------------------- */
