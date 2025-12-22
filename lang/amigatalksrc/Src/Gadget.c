/****h* AmigaTalk/Gadget.c [3.0] ************************************
*
* NAME
*    Gadget.c
*
* DESCRIPTION
*    Functions that handle AmigaTalk gadget primitives.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
*    26-Mar-2002 added code for Getting/Setting Userdata field.
*
* FUNCTIONAL INTERFACE:
*
*  PUBLIC OBJECT *HandleGadgets( int numargs, OBJECT **args );
*
* NOTES
*    $VER: AmigaTalk:Src/Gadget.c 3.0 (25-Oct-2004) by J.T. Steichen
*********************************************************************
*
*/

#include <stdio.h>

#include <exec/Types.h>
#include <exec/Lists.h>
#include <exec/Nodes.h>
#include <AmigaDOSErrs.h>

#include <proto/locale.h>

#ifdef __amigaos4__

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/graphics.h>

IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct GraphicsIFace  *IGraphics;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h" 
#include "Object.h"
#include "FuncProtos.h"
#include "IStructs.h"
#include "Constants.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *o_nil;
IMPORT UBYTE  *AllocProblem;
IMPORT UBYTE  *ErrMsg;
 
IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// ------------------------------------------------------------------

#define  CHIPMEM  MEMF_PUBLIC | MEMF_CHIP | MEMF_CLEAR
#define  FASTMEM  MEMF_PUBLIC | MEMF_FAST | MEMF_CLEAR

/****h* GadgetRemove() *************************************
*
* NAME
*    GadgetRemove()
*
* DESCRIPTION
*    <primitive 183 0 private>
************************************************************
*
*/

METHODFUNC void GadgetRemove( OBJECT *gadgetObj )
{
   struct Gadget *gptr = (struct Gadget *) CheckObject( gadgetObj );

   if (gptr) // != NULL)
      AT_FreeVec( gptr, "Gadget", TRUE );   

   return;
}

/****i* GadgetAdd() ****************************************
*
* NAME
*    GadgetAdd()
*
* DESCRIPTION
*    ^ <primitive 183 1>
************************************************************
*
*/

METHODFUNC OBJECT *GadgetAdd( void )
{
   struct Gadget *gptr = (struct Gadget *) NULL;
   OBJECT        *rval = o_nil;

   gptr = (struct Gadget *) AT_AllocVec( sizeof( struct Gadget ), 
                                         CHIPMEM, "Gadget", TRUE
                                       );
   if (!gptr) // == NULL)
      return( rval );
   else
      {
      gptr->Flags      = GADGHCOMP;   // Some default values.
      gptr->GadgetType = BOOLGADGET;
      gptr->Activation = RELVERIFY;
      
      return( AssignObj( new_address( (ULONG) gptr ) ) );
      }
}

/****i* GetGadgetPart() ************************************
*
* NAME
*    GetGadgetPart()
*
* DESCRIPTION
*    ^ <primitive 183 2 whichPart private>
************************************************************
*
*/

METHODFUNC OBJECT *GetGadgetPart( int whichpart, OBJECT *gadgetObj )
{
   struct Gadget      *gptr = (struct Gadget *) CheckObject( gadgetObj );
   struct StringInfo  *si   = (struct StringInfo *) NULL;
   struct PropInfo    *pi   = (struct PropInfo   *) NULL;
   OBJECT             *rval = o_nil;

   if (!gptr) // == NULL)
      return( rval );
         
   switch (whichpart)
      {
      case 0:
         rval = AssignObj( new_int( gptr->LeftEdge ) );
         break;

      case 1:
         rval = AssignObj( new_int( gptr->TopEdge ) );
         break;

      case 2:
         rval = AssignObj( new_int( gptr->Width ) );
         break;

      case 3:
         rval = AssignObj( new_int( gptr->Height ) );
         break;

      case 4:
         rval = AssignObj( new_int( gptr->Flags ) );
         break;

      case 5:
         rval = AssignObj( new_int( gptr->Activation ) );
         break;

      case 6:
         rval = AssignObj( new_int( gptr->GadgetType ) );
         break;

      case 7:
         rval = AssignObj( new_int( gptr->GadgetID ) );
         break;

      case 8:  
         rval = AssignObj( new_address( (ULONG) gptr->NextGadget ));
         break;
         
      case 9:
         rval = AssignObj( new_str( gptr->GadgetText->IText ));
         break;

      case 10: 
         rval = AssignObj( new_address( (ULONG) gptr->GadgetRender ));
         break;
         
      case 11: 
         rval = AssignObj( new_address( (ULONG) gptr->SelectRender ));
         break; 

      case 12:
         si   = (struct StringInfo *) gptr->SpecialInfo; 
         rval = AssignObj( new_int( si->MaxChars ) );
         break;

      case 13:
         pi   = (struct PropInfo *) gptr->SpecialInfo;
         rval = AssignObj( new_int( pi->Flags ) ); 
         break;

      case 14:
         pi   = (struct PropInfo *) gptr->SpecialInfo;
         rval = AssignObj( new_int( pi->HorizPot ) );
         break;

      case 15:
         pi   = (struct PropInfo *) gptr->SpecialInfo;
         rval = AssignObj( new_int( pi->VertPot ) );
         break;

      case 16:
         pi   = (struct PropInfo *) gptr->SpecialInfo;
         rval = AssignObj( new_int( pi->HorizBody ) ); 
         break;

      case 17:
         pi   = (struct PropInfo *) gptr->SpecialInfo;
         rval = AssignObj( new_int( pi->VertBody ) );  
         break;
      
      case 18: // Added on 17-Jan-2002
         rval = AssignObj( new_address( (ULONG) gptr->GadgetText ) );
         break;

      case 19: // Added on 26-Mar-2002
         rval = AssignObj( new_address( (ULONG) gptr->UserData ) );
         break;

      default:
         break;
      }

   return( rval );
}

/****i* SetGadgetPart() ************************************
*
* NAME
*    SetGadgetPart()
*
* DESCRIPTION
*    <primitive 183 3 whichPart valueObj private>
************************************************************
*
*/

METHODFUNC void SetGadgetPart( int     whichpart, 
                               OBJECT *whatvalue, 
                               OBJECT *gadgetObj
                             )
{
   struct Gadget *gptr = (struct Gadget *) CheckObject( gadgetObj );
   
   if (!gptr) // == NULL)
      return;
         
   switch (whichpart)
      {
      case 0:
         gptr->LeftEdge = int_value( whatvalue );   
         break;

      case 1:
         gptr->TopEdge = int_value( whatvalue );   
         break;

      case 2:
         gptr->Width = int_value( whatvalue );   
         break;

      case 3:
         gptr->Height = int_value( whatvalue );   
         break;

      case 4:
         gptr->Flags = int_value( whatvalue );   
         break;

      case 5:
         gptr->Activation = int_value( whatvalue );   
         break;

      case 6:
         gptr->GadgetType = int_value( whatvalue );   
         break;

      case 7:
         gptr->GadgetID = int_value( whatvalue );   
         break;

      case 8:  // Change NextGadget:
         {
         struct Gadget *ng = (struct Gadget *) CheckObject( whatvalue );
         
         gptr->NextGadget = ng;
         }

         break;

      case 9:  // Change GadgetText
         {
         struct IntuiText *et = (struct IntuiText *) CheckObject( whatvalue );

         gptr->GadgetText = et;
         }

         break;

      case 10: // Change Rendering:
         {
         APTR render = (APTR) CheckObject( whatvalue );
         
         gptr->GadgetRender = render;
         }

         break;

      case 11: // Change Select Rendering:
         {
         APTR srender = (APTR) CheckObject( whatvalue );
         
         gptr->SelectRender = srender;
         }
         break;

      case 12: // Added on 26-Mar-2002:
         gptr->UserData = (void *) addr_value( whatvalue );   
         break;


      default:
         break;
      }

   return;
}

/****i* ModifyGProp() **************************************
*
* NAME
*    ModifyGProp()
*
* DESCRIPTION
*    <primitive 183 4 flags hpot vpot hbody vbody winObj private>
************************************************************
*
*/

METHODFUNC void ModifyGProp( int flags, int hpot, int vpot, int hbody, 
                             int vbody, OBJECT *winObj, OBJECT *gadgetObj
                           )
{
   struct Window *wp   = (struct Window *) CheckObject( winObj );
   struct Gadget *gptr = (struct Gadget *) CheckObject( gadgetObj );   

   if (!gptr || !wp) // == NULL)
      return;

   ModifyProp( gptr, wp, NULL, flags, hpot, vpot, hbody, vbody );

   return;
}

/****i* SetBufferSize() *********************************
*
* NAME
*    SetBufferSize()
*
* DESCRIPTION
*    <primitive 183 5 newSize private>
************************************************************
*
*/

METHODFUNC void SetBufferSize( int newsize, OBJECT *gadgetObj )
{
   struct Gadget     *gptr    = (struct Gadget *) CheckObject( gadgetObj );   
   struct StringInfo *sptr    = (struct StringInfo *) NULL;
   UBYTE             *newbuff = NULL;
   UBYTE             *newundo = NULL;
   
   if (!gptr) // == NULL)
      return;

   sptr = (struct StringInfo *) gptr->SpecialInfo; 

   if (sptr->Buffer) // != NULL)
      AT_FreeVec( sptr->Buffer, "strGadgetBuffer", TRUE );

   if (sptr->UndoBuffer) // != NULL)
      AT_FreeVec( sptr->UndoBuffer, "strGadgetUndoBuffer", TRUE );

   newbuff = (UBYTE *) AT_AllocVec( newsize, CHIPMEM, "strGadgetBuffer", TRUE );
   newundo = (UBYTE *) AT_AllocVec( newsize, CHIPMEM, "strGadgetUndoBuffer", TRUE );

   if (!newbuff || !newundo) // == NULL)
      {
      MemoryOut( GadgCMsg( MSG_GA_STRGAD_BUF_GADGET ) );

      if (newbuff) // != NULL)
         AT_FreeVec( newbuff, "strGadgetBuffer", TRUE );

      if (newundo) // != NULL)
         AT_FreeVec( newundo, "strGadgetUndoBuffer", TRUE );

      return;      
      }

   sptr->Buffer     = newbuff;
   sptr->UndoBuffer = newundo;
   sptr->MaxChars   = newsize;

   return;     
}

/****i* SetPropValues() ************************************
*
* NAME
*    SetPropValues()
*
* DESCRIPTION
*    <primitive 183 6 flags hpot vpot hbody vbody private>
************************************************************
*
*/

METHODFUNC void SetPropValues( int flags, int hpot, int vpot, int hbody,
                               int vbody, OBJECT *gadgetObj
                             )
{
   struct PropInfo *pi   = (struct PropInfo *) NULL;
   struct Gadget   *gptr = (struct Gadget *) CheckObject( gadgetObj );   
   
   if (!gptr) // == NULL)
      return;

   pi = (struct PropInfo *) gptr->SpecialInfo;

   if (!pi) // == NULL)
      return;

   pi->Flags     = flags;
   pi->HorizPot  = hpot;
   pi->VertPot   = vpot;
   pi->HorizBody = hbody;
   pi->VertBody  = vbody;

   return;
}

/*
VOID NewModifyProp( struct Gadget *gadget, struct Window *window,
                    struct Requester *requester, ULONG flags, ULONG horizPot, 
                    ULONG vertPot, ULONG horizBody, ULONG vertBody, LONG numGad 
                  );

VOID GadgetMouse( struct Gadget *gadget, struct GadgetInfo *gInfo, WORD *mousePoint );
*/

/****h* HandleGadgets() ************************************
*
* NAME
*    HandleGadgets()
*
* DESCRIPTION
*    Primitive (183) 
************************************************************
*
*/

PUBLIC OBJECT *HandleGadgets( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 183 );
      return( rval );
      }
   
   switch (int_value( args[0] ))
      {
      case 0: // dispose [private]
         if (NullChk( args[1] ) == FALSE)
            {
            GadgetRemove( args[1] );
            }

         break;
      
      case 1: // OBJECT *GadgetAdd( void )
         rval = GadgetAdd();

         break;

      case 2: // OBJECT *GetGadgetPart( int whichpart, OBJECT *gadgetObj )
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 183 );
         else
            rval = GetGadgetPart( int_value( args[1] ), args[2] );

         break;
      
      case 3: // void SetGadgetPart( int whichpart, OBJECT *value, OBJECT *gadgetObj
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 183 );
         else
            SetGadgetPart( int_value( args[1] ), args[2], args[3] ); 

         break;
      
      case 4: // <primitive 183 4 flags hpot vpot hbody vbody winObj private>
         if (ChkArgCount( 8, numargs, 183 ) != 0)
            return( ReturnError() );
       
         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ) 
                                     || !is_integer( args[4] )
                                     || !is_integer( args[5] ))
            (void) PrintArgTypeError( 183 );
         else
            ModifyGProp( int_value( args[1] ), 
                         int_value( args[2] ),
                         int_value( args[3] ), 
                         int_value( args[4] ),
                         int_value( args[5] ), 
                                    args[6], args[7]
                       );  
         break;
      
      case 5: // <primitive 183 5 newSize private>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 183 );
         else
            SetBufferSize( int_value( args[1] ), args[2] ); 

         break;

      case 6: // <primitive 183 6 flags hpot vpot hbody vbody private>
         if (ChkArgCount( 7, numargs, 183 ) != 0)
            return( ReturnError() );
       
         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ) 
                                     || !is_integer( args[4] )
                                     || !is_integer( args[5] ))
            (void) PrintArgTypeError( 183 );
         else
            SetPropValues( int_value( args[1] ), 
                           int_value( args[2] ),
                           int_value( args[3] ), 
                           int_value( args[4] ),
                           int_value( args[5] ), 
                                      args[6]
                         );
         break;

      default:
         (void) PrintArgTypeError( 183 );
         break;
      }

   return( rval );
}

/* -------------------- END of Gadget.c file! ------------------------ */
