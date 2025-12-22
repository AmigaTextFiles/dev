/****h* AmigaTalk/GadTools.c [3.0] *************************************
*
* NAME
*    GadTools.c
*
* DESCRIPTION
*    This file uses NewGadgets & GadTools, which simplifies
*    the creation of GUIs. <239 ??>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    03-Dec-2003 - Added <239 0 25 lvList lvm> to ensure that
*                  ListView Gadgets have a viable display List.
* 
*    02-Dec-2003 - Added primitives to create & destroy the ListView
*                  exec List structure.
*
* NOTES
*    FUNCTIONAL INTERFACE:
*       PUBLIC OBJECT *HandleGadTools( int numargs, OBJECT **args );
*
*    $VER: GadTools.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <string.h>

#include <exec/types.h>
#include <exec/memory.h>

#include <AmigaDOSErrs.h>

#include <intuition/intuition.h>
#include <intuition/classes.h>
#include <intuition/classusr.h>
#include <intuition/imageclass.h>
#include <intuition/gadgetclass.h>

#include <libraries/gadtools.h>
#include <libraries/iffparse.h> // For the MAKE_ID macro only

#include <graphics/displayinfo.h>
#include <graphics/gfxbase.h>

#ifdef __SASC

# include <clib/exec_protos.h>
# include <clib/intuition_protos.h>
# include <clib/gadtools_protos.h>
# include <clib/graphics_protos.h>
# include <clib/utility_protos.h>

#define MEMFLAGS MEMF_CLEAR | MEMF_ANY

#else

# define __USE_INLINE__

# include <proto/exec.h>
# include <proto/intuition.h>
# include <proto/gadtools.h>
# include <proto/graphics.h>
# include <proto/utility.h>

IMPORT struct GadToolsIFace *IGadTools;

#define MEMFLAGS MEMF_CLEAR | MEMF_SHARED

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"   // for new_char() #define
#include "CantHappen.h"
#include "Env.h"
#include "ATStructs.h"
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

#ifndef  StrBfPtr
# define StrBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->Buffer)
# define IntBfPtr( g ) (((struct StringInfo *)g->SpecialInfo)->LongInt)
#endif

#define UDATA_SIZE 5 // Number of LONG's in struct MyUserData

#define TYPE_FIELD 0
#define ID_FIELD   1
#define SYM_FIELD  2
#define KEY_FIELD  3
#define VAL_FIELD  4

/*
struct MyUserData {

   ULONG mud_Type;
   ULONG mud_ID;           // Integer for Gadget, String for Menu Item
   ULONG mud_Symbol;
   ULONG mud_HotKey;
   ULONG mud_Value;        // Really useful for Gadgets
};
*/

#define ID_RKEY MAKE_ID( 'R', 'K', 'E', 'Y' ) // Raw Key
#define ID_VKEY MAKE_ID( 'V', 'K', 'E', 'Y' ) // Vanilla Key

#define ID_SGAD MAKE_ID( 'S', 'G', 'A', 'D' ) // System Gadget
#define ID_CLOW MAKE_ID( 'C', 'L', 'O', 'W' ) // Close Window
#define ID_CHGW MAKE_ID( 'C', 'H', 'G', 'W' ) // Change Window
#define ID_SIZW MAKE_ID( 'S', 'I', 'Z', 'W' ) // Size Window

#define ID_VERI MAKE_ID( 'V', 'E', 'R', 'I' ) // Verify event
#define ID_SVER MAKE_ID( 'S', 'V', 'E', 'R' ) // SizeVerify
#define ID_MVER MAKE_ID( 'M', 'V', 'E', 'R' ) // MenuVerify

#define ID_MOUS MAKE_ID( 'M', 'O', 'U', 'S' ) // Mouse Event
#define ID_MBUT MAKE_ID( 'M', 'B', 'U', 'T' ) // MouseButtons
#define ID_MMOV MAKE_ID( 'M', 'M', 'O', 'V' ) // MouseMove
//#define ID_DMOV MAKE_ID( 'D', 'M', 'O', 'V' ) // DeltaMove

#define ID_REQU MAKE_ID( 'R', 'E', 'Q', 'U' ) // Requester
#define ID_RSET MAKE_ID( 'R', 'S', 'E', 'T' ) // ReqSet
#define ID_RVER MAKE_ID( 'R', 'V', 'E', 'R' ) // ReqVerify
#define ID_RCLR MAKE_ID( 'R', 'C', 'L', 'R' ) // ReqClear

#define ID_PREF MAKE_ID( 'P', 'R', 'E', 'F' ) // NewPrefs
#define ID_NEWP MAKE_ID( 'N', 'E', 'W', 'P' ) // NewPrefs

#define ID_DISK MAKE_ID( 'D', 'I', 'S', 'K' ) // Disk Event
#define ID_DINS MAKE_ID( 'D', 'I', 'N', 'S' ) // Disk Inserted
#define ID_DREM MAKE_ID( 'D', 'R', 'E', 'M' ) // Disk Removed

#define ID_WIND MAKE_ID( 'W', 'I', 'N', 'D' ) // Window Event
#define ID_ACTW MAKE_ID( 'A', 'C', 'T', 'W' ) // Active Window
#define ID_INAW MAKE_ID( 'I', 'N', 'A', 'W' ) // Inactive Window

#define ID_TIMR MAKE_ID( 'T', 'I', 'M', 'R' ) // Timer Event
#define ID_ITCK MAKE_ID( 'I', 'T', 'C', 'K' ) // IntuiTicks

#define ID_UPDT MAKE_ID( 'U', 'P', 'D', 'T' ) // IDCMPUpdate

#define ID_HELP MAKE_ID( 'H', 'E', 'L', 'P' ) // Help Event
#define ID_MHLP MAKE_ID( 'M', 'H', 'L', 'P' ) // MenuHelp
#define ID_GHLP MAKE_ID( 'G', 'H', 'L', 'P' ) // GadgetHelp

// ----------------------------------------------------------------------

IMPORT OBJECT *o_nil, *o_true, *o_false; // , *o_IDCMP_rval;
IMPORT UBYTE  *ErrMsg;

// ----------------------------------------------------------------------

/****i* DisposeGadgetList() [2.0] ***************************************
*
* NAME
*    DisposeGadgetList()
*
* DESCRIPTION
*    FreeGadgets() & kill the memory pointer.  
*    <239 0 0 private>
*
* NOTES
*    (glist) points to the gadgets created by CreateContext() & are
*    freed by FreeGadgets().  glist & (glist) are not changed until
*    FreeVec( glist ) is called.
*************************************************************************
*
*/

METHODFUNC void DisposeGadgetList( OBJECT *glistObj )
{
   struct Gadget **glist = (struct Gadget **) CheckObject( glistObj );
   
   if (!glist) // == NULL)
      return;

   FreeGadgets( *glist );
   
   AT_FreeVec( glist, "gadgetList", TRUE );

   return;
}

/****i* allocateGadgetList() [2.0] **************************************
*
* NAME
*    allocateGadgetList()
*
* DESCRIPTION
*    Simply allocate a Gadget **GadList pointer.    <primitive 239 0 1>
*************************************************************************
*
*/

METHODFUNC OBJECT *allocateGadgetList( void )
{
   struct Gadget **glist = (struct Gadget **) NULL;
   OBJECT         *rval  = o_nil;

   glist = (struct Gadget **) AT_AllocVec( sizeof( struct Gadget *),
                                        MEMF_CLEAR | MEMF_ANY, 
                                        "gadgetList", TRUE 
                                      );
   if (!glist) // == NULL)
      return( rval );
   else
      {
      *glist = (struct Gadget *) NULL; // only the inside pointer is NULL.

      return( AssignObj( new_address( (ULONG) glist ) ) );
      }
}

/****i* createGadgetList() [2.0] ****************************************
*
* NAME
*    createGadgetList()
*
* DESCRIPTION
*    CreateContext() for NewGadgets.  
*      ^ <primitive 239 0 2 glistObj>
*
* NOTES
*    CreateContext() allocates a gadget & places its pointer in glist
*    & returns it as gptr.
*************************************************************************
*
*/

METHODFUNC OBJECT *createGadgetList( OBJECT *glistObj )
{
   struct Gadget **glist = (struct Gadget **) CheckObject( glistObj );
   OBJECT         *rval  = o_nil;

   if (!glist) // == NULL)
      return( rval );
   else
      {
      struct Gadget *gptr = (struct Gadget *) NULL;

      gptr = CreateContext( glist );
                   
      return( AssignObj( new_address( (ULONG) gptr ) ) );
      }
}

// Called by makeNewGadgetStruct() only:

SUBFUNC void SetupUserData( char   *dest, 
                            OBJECT *gadgetType,
                            OBJECT *gadgetID,
                            OBJECT *userData, 
                            OBJECT *hotKey,
                            OBJECT *gadgetValue 
                          )
{
   ULONG gt = (ULONG) CheckObject( gadgetType  );
   ULONG id = (ULONG) CheckObject( gadgetID    );
   ULONG hk = (ULONG) char_value(  hotKey      );
   ULONG gv = (ULONG) CheckObject( gadgetValue );

   ULONG ud = 0; // NULL; // Usually a Symbol
   
   if (is_bltin( userData ) == TRUE) 
      {
      switch (objType( userData )) 
         {
         case MMF_CLASS_SPEC: // SPECIALSIZE: // This should never appear.
         case MMF_BLOCK: // SIZE:   // Just return a pointer to the AmigaTalk struct:
         case MMF_FILE:
         case MMF_CLASS: 
         case MMF_INTERPRETER:
         case MMF_PROCESS:
         case MMF_FLOAT:
         case MMF_INTEGER: 
         case MMF_CHARACTER:
         case MMF_STRING:
         case MMF_SYMBOL:     // Could be a method to call!
         case MMF_BYTEARRAY:
            ud = (ULONG) userData;
            
         default:   
            break;
         }

      }
   else if (userData == o_nil)
      ud = 0;
   else       // Don't know what it is, return a zero!
      ud = 0;

   dest[0]  = (char) ((gt & 0xFF000000) >> 24); // The Gadget Type addition.
   dest[1]  = (char) ((gt & 0x00FF0000) >> 16);
   dest[2]  = (char) ((gt & 0x0000FF00) >> 8);
   dest[3]  = (char)  (gt & 0x000000FF);
             
   dest[4]  = (char) ((id & 0xFF000000) >> 24); // The Gadget ID addition.
   dest[5]  = (char) ((id & 0x00FF0000) >> 16);
   dest[6]  = (char) ((id & 0x0000FF00) >> 8);
   dest[7]  = (char)  (id & 0x000000FF);
             
   dest[8]  = (char) ((ud & 0xFF000000) >> 24); // UserData (usually a Symbol)
   dest[9]  = (char) ((ud & 0x00FF0000) >> 16); 
   dest[10] = (char) ((ud & 0x0000FF00) >> 8); 
   dest[11] = (char)  (ud & 0x000000FF); 

   dest[12] = (char) ((hk & 0xFF000000) >> 24); // The HotKey addition.
   dest[13] = (char) ((hk & 0x00FF0000) >> 16); 
   dest[14] = (char) ((hk & 0x0000FF00) >> 8); 
   dest[15] = (char)  (hk & 0x000000FF);

   dest[16] = (char) ((gv & 0xFF000000) >> 24); // The Gadget Value.
   dest[17] = (char) ((gv & 0x00FF0000) >> 16); 
   dest[18] = (char) ((gv & 0x0000FF00) >> 8); 
   dest[19] = (char)  (gv & 0x000000FF);
   
   return; 
}

/****i* makeNewGadgetStruct() [2.0] *************************************
*
* NAME
*    makeNewGadgetStruct()
*
* DESCRIPTION
*    Allocate a NewGadget struct & initialize it with the fields from
*    structArray.
*       ^ <primitive 239 0 3 structArray chkSize>
*
* NOTES
*    We allocate a special array of 5 longs for the UserData field.
*    The first long is Gadget Type, the 2nd is the GadgetID value,
*    the 3rd long is a pointer to the real UserData OBJECT, 
*    the 4th is a HotKey value & the last is the Gadget value.
*************************************************************************
*
*/

METHODFUNC OBJECT *makeNewGadgetStruct( OBJECT *structArray, ULONG chkSize )
{
   struct NewGadget *ngad = (struct NewGadget *) NULL;
   char             *text = NULL;
   char             *udat = NULL;
   OBJECT           *rval = o_nil;
   int               len  = 0;
      
   if (NullChk( structArray ) == TRUE)
      return( rval );
      
   if (objSize( structArray ) != chkSize)
      return( rval );
      
   ngad = (struct NewGadget *) AT_AllocVec( sizeof( struct NewGadget ),
                                         MEMF_CLEAR | MEMF_ANY, 
                                         "newGadget", TRUE 
                                       );

   if (!ngad) // == NULL)
      {
      MemoryOut( GToolCMsg( MSG_GT_NEWGS_FUNC_GTOOL ) );

      return( rval );
      }

   len  = StringLength( string_value( (STRING *) structArray->inst_var[4] ) );
   text = AT_AllocVec( len + 1, MEMF_CLEAR | MEMF_ANY, 
                       "ng_GadgetLabel", TRUE
                     );
   
   if (!text) // == NULL)
      {
      MemoryOut( GToolCMsg( MSG_GT_NEWGS_FUNC_GTOOL ) );

      AT_FreeVec( ngad, "newGadget", TRUE );

      return( rval );
      }
   else
      StringCopy( text, string_value( (STRING *) structArray->inst_var[4] ) );
             
   udat = (char *) AT_AllocVec( UDATA_SIZE * sizeof( LONG ), 
                                MEMF_CLEAR | MEMF_ANY, 
                                "ng_UserData", TRUE 
                              );
   
   if (!udat) // == NULL)
      {
      MemoryOut( GToolCMsg( MSG_GT_NEWGS_FUNC_GTOOL ) );

      AT_FreeVec( text, "ng_GadgetLabel", TRUE );
      AT_FreeVec( ngad, "newGadget"     , TRUE );
      
      return( rval );
      }
         
   ngad->ng_LeftEdge   = (WORD) int_value( structArray->inst_var[0] );
   ngad->ng_TopEdge    = (WORD) int_value( structArray->inst_var[1] );
   ngad->ng_Width      = (WORD) int_value( structArray->inst_var[2] );
   ngad->ng_Height     = (WORD) int_value( structArray->inst_var[3] );

   ngad->ng_GadgetText = (UBYTE *) text;

   ngad->ng_TextAttr   = (struct TextAttr *) ObjectToAddress( structArray->inst_var[5] );

   ngad->ng_GadgetID   = (UWORD) int_value( structArray->inst_var[6] );
   ngad->ng_Flags      = (ULONG) int_value( structArray->inst_var[7] );

   ngad->ng_VisualInfo = (APTR) int_value( structArray->inst_var[8] );
   ngad->ng_UserData   = (APTR) udat;
   
   SetupUserData( udat, structArray->inst_var[10],  // Gadget Type
                        structArray->inst_var[6],   // Gadget ID
                        structArray->inst_var[9],   // Gadget UserData
                        structArray->inst_var[11],  // Gadget HotKey
                        structArray->inst_var[10]   // Temporarily the Gadget Type
                );

   rval = AssignObj( new_address( (ULONG) ngad ) );
   
   return( rval );
}

/****i* addGadgetToList() [2.0] *****************************************
*
* NAME
*    addGadgetToList()
*
* DESCRIPTION
*    CreateGadgetA() call. 
*    ^ <primitive 239 0 4 gadObj newGadObj type tagArray>
*
* NOTES
*    tagArray can be nil here.
*************************************************************************
*
*/

METHODFUNC OBJECT *addGadgetToList( OBJECT *gObj,    // struct Gadget * 
                                    OBJECT *newGObj, // struct NewGadget *
                                    int     type,    // ULONG
                                    OBJECT *tagArray // struct TagItem * 
                                  )
{
   struct NewGadget *ngad = (struct NewGadget *) CheckObject( newGObj );
   struct Gadget    *gad  = (struct Gadget    *) CheckObject( gObj    );
   struct Gadget    *next = (struct Gadget    *) NULL;
   struct TagItem   *tags = (struct TagItem   *) NULL;
   OBJECT           *rval = o_nil;

   if (!ngad || !gad) // == NULL)
      return( rval );

   if ((type < 0) || (type >= NUM_KINDS) || (type == 10))
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   if (!(next = CreateGadgetA( type, gad, ngad, tags ))) // != NULL)
      rval = AssignObj( new_address( (ULONG) next ) );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "gadgetListTags", TRUE );
      
   return( rval );
}

/****i* setGadgetAttrs() [2.0] ******************************************
*
* NAME
*    setGadgetAttrs()
*
* DESCRIPTION
*    GT_SetGadgetAttrsA() call. <239 0 5 private winObj tagArray>
*************************************************************************
*
*/

METHODFUNC void setGadgetAttrs( OBJECT *gadgObj, OBJECT *winObj, OBJECT *tagArray )
{
   struct Window  *wptr = (struct Window *) CheckObject( winObj  );
   struct Gadget  *gad  = (struct Gadget *) CheckObject( gadgObj );
   struct TagItem *tags = (struct TagItem *) NULL;

   if (!gad || !wptr) // == NULL)
      return;

   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   GT_SetGadgetAttrsA( gad, wptr, NULL, tags );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "setGadgetAttrTags", TRUE );
      
   return;
}

/****i* getGadgetAttrs() [2.0] ******************************************
*
* NAME
*    getGadgetAttrs()
*
* DESCRIPTION
*    <239 0 6 private winObj tagArray>
*************************************************************************
*
*/

METHODFUNC OBJECT *getGadgetAttrs( OBJECT *gadgObj, OBJECT *winObj, OBJECT *tagArray )
{
   struct Window  *wptr = (struct Window *) CheckObject( winObj  );
   struct Gadget  *gad  = (struct Gadget *) CheckObject( gadgObj );
   struct TagItem *tags = (struct TagItem *) NULL;
   OBJECT         *rval = o_nil;
   
   if (!gad || !wptr) // == NULL)
      return( rval );

   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   // Returns the number of tags processed:
   rval = AssignObj( new_int( (int) GT_GetGadgetAttrsA( gad, wptr, NULL, tags ) ) );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "getGadgetAttrsTags", TRUE );
      
   return( rval );
}

/****i* disposeNewGadget() [2.0] ****************************************
*
* NAME
*    disposeNewGadget()
*
* DESCRIPTION
*    De-Allocate a NewGadget struct.
*    <primitive 239 0 7 newGadgetObj>
*************************************************************************
*
*/

METHODFUNC void disposeNewGadget( OBJECT *newGObj )
{
   struct NewGadget *ngad = (struct NewGadget *) CheckObject( newGObj );
   OBJECT           *udat = o_nil;
   LONG             *data = 0; // NULL;
   
   if (!ngad) // == NULL)
      return;

   data = (LONG *) ngad->ng_UserData;

   udat = (OBJECT *) data[ SYM_FIELD ];

   if (udat && is_bltin( udat ) == TRUE)
      obj_dec( udat );
      
   AT_FreeVec( ngad->ng_GadgetText, "ng_GadgetLabel", TRUE );
   AT_FreeVec( ngad->ng_UserData,   "ng_UserData"   , TRUE ); // UDATA_SIZE LONG's
   AT_FreeVec( ngad,                "newGadget"     , TRUE );
   
   return;
}

/****i* getGadgetUserData() [2.0] ***************************************
*
* NAME
*    getGadgetUserData()
*
* DESCRIPTION
*    ^ <primitive 239 0 8 intuiMsgObj>
*************************************************************************
*
*/

METHODFUNC OBJECT *getGadgetUserData( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj );
   struct Gadget       *gptr = (struct Gadget *) NULL;
   OBJECT              *data = (OBJECT *) NULL;
   LONG                *udat = (ULONG  *) NULL;
   
   if (!imsg) // == NULL)
      return( o_nil );
   
   gptr = (struct Gadget *) imsg->IAddress; // Debug this!!
   udat =          (LONG *) gptr->UserData;

   if (udat) // != NULL)
      data = (OBJECT *) udat[ SYM_FIELD ]; // Might have to kill this.

   if (NullChk( data ) == TRUE)
      return( o_nil );
   else
      return( data );
}

/****i* getGadgetID() [2.0] *********************************************
*
* NAME
*    getGadgetID()
*
* DESCRIPTION
*    ^ <primitive 239 0 9 intuiMsgObj>
*************************************************************************
*
*/

METHODFUNC OBJECT *getGadgetID( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj );
   UWORD                id   = 0;
   
   if (!imsg) // == NULL)
      return( o_nil );
   
   id = ((struct Gadget *) imsg->IAddress)->GadgetID;
      
   return( AssignObj( new_int( (int) id ) ) );
}         

/****i* getGadgetType_UserData() [2.0] **********************************
*
* NAME
*    getGadgetType_UserData()
*
* DESCRIPTION
*    This method should not be necessary, but is included to completely
*    access all of the UserData associated with a NewGadget.
*    ^ <primitive 239 0 10 intuiMsgObj>
*************************************************************************
*
*/

METHODFUNC OBJECT *getGadgetType_UserData( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj );
   struct Gadget       *gptr = (struct Gadget       *) NULL;
   int                 *data = (int  *) NULL;
   LONG                *udat = (LONG *) NULL;
   
   if (!imsg) // == NULL)
      return( o_nil );
   
   gptr = (struct Gadget *) imsg->IAddress; // Debug this!!
   udat =          (LONG *) gptr->UserData;
   data =           (int *) &udat[0];
   
   return( AssignObj( new_int( (int) *data ) ) );
}

/****i* getGadgetHotKey() [2.1] *****************************************
*
* NAME
*    getGadgetHotKey()
*
* DESCRIPTION
*    ^ <primitive 239 0 11 intuiMsgObj>
*************************************************************************
*
*/

METHODFUNC OBJECT *getGadgetHotKey( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj );
   struct Gadget       *gptr = (struct Gadget *) NULL;
   int                 *data = (int           *) NULL;
   LONG                *udat = (LONG          *) NULL;
   
   if (!imsg) // == NULL)
      return( o_nil );
   
   gptr = (struct Gadget *) imsg->IAddress; // Debug this!!
   udat =          (LONG *) gptr->UserData;
   data =           (int *) udat[ KEY_FIELD ];
   
   return( AssignObj( new_int( (int) *data ) ) );
}

/****i* addGadgetHotKey() [2.1] *****************************************
*
* NAME
*    addGadgetHotKey()
*
* DESCRIPTION
*    addHotKey: keyValue to: controlObject
*       <primitive 239 0 12 intuiMsgObj>
*************************************************************************
*
*/

METHODFUNC void addGadgetHotKey( ULONG keyValue, OBJECT *gadgObj )
{
   struct Gadget *gptr = (struct Gadget *) CheckObject( gadgObj );
   ULONG         *udat = (ULONG *) NULL;
   
   if (gptr && gptr->UserData) // != NULL)
      {
      udat              = (ULONG *) gptr->UserData;
      udat[ KEY_FIELD ] = keyValue;
      }

   return;
}
        
/****i* getGadgetValue() [3.0] ******************************************
*
* NAME
*    getGadgetValue()
*
* DESCRIPTION
*    ^ <239 0 13 private winObj gadgetType>
*************************************************************************
*
*/

METHODFUNC OBJECT *getGadgetValue( OBJECT *gadgObj, 
                                   OBJECT *wObj, 
                                   int     gType
                                 )
{
   struct Window *wptr = (struct Window *) CheckObject( wObj    );
   struct Gadget *gad  = (struct Gadget *) CheckObject( gadgObj );

   OBJECT        *rval = o_nil;

   if (gad && wptr) // != NULL)
      {
      switch (gType)
         {
         case GENERIC_KIND:
         case BUTTON_KIND:
         case NUMBER_KIND: // These are write-only gadgets:
         case TEXT_KIND:
            break;

         case CHECKBOX_KIND:
            if ((gad->Flags & GFLG_SELECTED) != 0)
               rval = o_true;
            else
               rval = o_false;
               
            break;
         
         case INTEGER_KIND:
            rval = AssignObj( new_int( IntBfPtr( gad ) ) );
            break;
            
         case LISTVIEW_KIND:
            {
//            struct Node *node   = NULL;
//            LONG         labels = 0L;
            LONG         choice = 0L;
            
            (void) GT_GetGadgetAttrs( gad, wptr, NULL, 
//                                      GTLV_Labels,   &labels,
                                      GTLV_Selected, &choice, TAG_DONE
                                    );  
            
            if (choice == ~0) // Once working, this can come out.
               choice = 0;
            
//            node = (struct Node *) ((struct List *) labels)->lh_Head;

//               rval = AssignObj( new_str( node[ choice ].ln_Name ) );

            rval = AssignObj( new_int( (int) choice + 1 ) );
            // else rval == o_nil!
            }
            break;
         
         case MX_KIND:
            {
            LONG choice = 0;
            
            (void) GT_GetGadgetAttrs( gad, wptr, NULL, 
                                      GTMX_Active, &choice, TAG_DONE
                                    );  
                                    
            rval = AssignObj( new_int( (int) choice + 1 ) );
            }
            break;
            
         case CYCLE_KIND:
            {
            LONG choice = 0;
            
            (void) GT_GetGadgetAttrs( gad, wptr, NULL, 
                                      GTCY_Active, &choice, TAG_DONE
                                    );  
                                    
            rval = AssignObj( new_int( (int) choice + 1 ) );
            }
            break;
            
         case PALETTE_KIND:
            {
            LONG choice = 0;
            
            (void) GT_GetGadgetAttrs( gad, wptr, NULL, 
                                      GTPA_Color, &choice, TAG_DONE
                                    );  
                                    
            rval = AssignObj( new_int( (int) choice + 1 ) );
            }
            break;
         
         case SCROLLER_KIND:
            {
            LONG value = 0;
            
            (void) GT_GetGadgetAttrs( gad, wptr, NULL, 
                                      GTSC_Top, &value, TAG_DONE
                                    );  
                                    
            rval = AssignObj( new_int( (int) value ) );
            }
            break;
            
         case SLIDER_KIND:
            {
            LONG level = 0;
            
            (void) GT_GetGadgetAttrs( gad, wptr, NULL, 
                                      GTSL_Level, &level, TAG_DONE
                                    );  
                                    
            rval = AssignObj( new_int( (int) level ) );
            }
            break;
                                 
         case STRING_KIND:
            rval = AssignObj( new_str( StrBfPtr( gad ) ) );
            break;
         }
      }

   return( rval );
}

/****i* setGadgetValue() [3.0] ******************************************
*
* NAME
*    setGadgetValue()
*
* DESCRIPTION
*    <239 0 14 private windowObj value>
*
*    value is o_true or o_false for CHECKBOX_KIND & BUTTON_KIND,
*    String for STRING_KIND & TEXT_KIND, Integer for everything else!
*    value can be nil also.
*************************************************************************
*
*/

METHODFUNC void setGadgetValue( OBJECT *gadgObj, OBJECT *wObj, OBJECT *valObj )
{
   struct Gadget *gad  = (struct Gadget *) CheckObject( gadgObj );
   struct Window *wptr = (struct Window *) CheckObject( wObj );
   
   int     gtype = 0;
   int     ival  = 0;
   char   *str   = NULL;
   ULONG  *udata = 0L;

   if (!gad || !wptr) // == NULL)
      return;
      
   udata = (ULONG *) gad->UserData;
   gtype = (int)     udata[0];

   udata[ VAL_FIELD ] = (LONG) valObj;
   
   switch (gtype)
      {
      default:
      case GENERIC_KIND: // Cannot do anything with generics
         break;
         
      case BUTTON_KIND:
         if ((gad->Activation & GACT_TOGGLESELECT) == GACT_TOGGLESELECT)
            {
            ival = valObj == o_true ? TRUE : FALSE;
            
            GT_SetGadgetAttrs( gad, wptr, NULL, GA_Selected, ival, TAG_DONE );
            }
            
         break;
                        
      case CHECKBOX_KIND:
         ival = valObj == o_true ? TRUE : FALSE;
            
         GT_SetGadgetAttrs( gad, wptr, NULL, GTCB_Checked, ival, TAG_DONE );

         break;
       
      case NUMBER_KIND:
         if (NullChk( valObj ) == FALSE)
            ival = int_value( valObj );
         else
            ival = 0;
            
         GT_SetGadgetAttrs( gad, wptr, NULL, GTNM_Number, ival, TAG_DONE );

         break;
                  
      case INTEGER_KIND:
         if (NullChk( valObj ) == FALSE)
            ival = int_value( valObj );
         else
            ival = 0;
            
         GT_SetGadgetAttrs( gad, wptr, NULL, GTIN_Number, ival, TAG_DONE );

         break;
                        
      case LISTVIEW_KIND:
         {
         if (NullChk( valObj ) == FALSE)
            ival = int_value( valObj ) > 0 ? int_value( valObj ) - 1 : 0; 
         else
            ival = 0;
            
         if (   is_string( (OBJECT *) udata[ VAL_FIELD ] ) == TRUE
            || is_integer( (OBJECT *) udata[ VAL_FIELD ] ) == TRUE)
            {
            obj_dec( (OBJECT *) udata[ VAL_FIELD ] );
            }

         GT_SetGadgetAttrs( gad, wptr, NULL, GTLV_Selected, ival, TAG_DONE );

         udata[ VAL_FIELD ] = (LONG) new_int( ival + 1 );
         }

         break;

      case MX_KIND:
         {
         if (NullChk( valObj ) == FALSE)
            ival = int_value( valObj ) > 0 ? int_value( valObj ) - 1 : 0; 
         else
            ival = 0;
         
         GT_SetGadgetAttrs( gad, wptr, NULL, GTMX_Active, ival, TAG_DONE );

         if (   is_string( (OBJECT *) udata[ VAL_FIELD ] ) == TRUE
            || is_integer( (OBJECT *) udata[ VAL_FIELD ] ) == TRUE)
            {
            obj_dec( (OBJECT *) udata[ VAL_FIELD ] );
            }

         udata[ VAL_FIELD ] = (LONG) new_int( ival + 1 ); // str( ptr[ ival ] );
         }
         break;
                                 
      case CYCLE_KIND:
         if (NullChk( valObj ) == FALSE)
            ival = int_value( valObj ) > 0 ? int_value( valObj ) - 1 : 0; 
         else
            ival = 0;
         
         GT_SetGadgetAttrs( gad, wptr, NULL, GTCY_Active, ival, TAG_DONE );

         if (   is_string( (OBJECT *) udata[ VAL_FIELD ] ) == TRUE
            || is_integer( (OBJECT *) udata[ VAL_FIELD ] ) == TRUE)
            {
            obj_dec( (OBJECT *) udata[ VAL_FIELD ] );
            }

         udata[ VAL_FIELD ] = (LONG) new_int( ival + 1 );
         
         break;
                        
      case PALETTE_KIND:
         if (NullChk( valObj ) == FALSE)
            ival = int_value( valObj ) > 0 ? int_value( valObj ) - 1 : 0; 
         else
            ival = 0;
         
         GT_SetGadgetAttrs( gad, wptr, NULL, GTPA_Color, ival, TAG_DONE );

         break;
                        
      case SCROLLER_KIND:
         if (NullChk( valObj ) == FALSE)
            ival = int_value( valObj );
         else
            ival = 0;
         
         GT_SetGadgetAttrs( gad, wptr, NULL, GTSC_Top, ival, TAG_DONE );

         break;
                        
      case SLIDER_KIND:
         if (NullChk( valObj ) == FALSE)
            ival = int_value( valObj );
         else
            ival = 0;
         
         GT_SetGadgetAttrs( gad, wptr, NULL, GTSL_Level, ival, TAG_DONE );

         break;
               
      case STRING_KIND:
         if (NullChk( valObj ) == FALSE)
            str = string_value( (STRING *) valObj );
         else 
            str = NULL;
                   
         GT_SetGadgetAttrs( gad, wptr, NULL, GTST_String, str, TAG_DONE );

         break;
      
      case TEXT_KIND:
         if (NullChk( valObj ) == FALSE)
            str = string_value( (STRING *) valObj );
         else 
            str = NULL;
         
         GT_SetGadgetAttrs( gad, wptr, NULL, GTTX_Text, str, TAG_DONE );

         break;
      }

   return;
}

/****i* initGetFileClass() [3.0] ****************************************
*
* NAME
*    initGetFileClass()
*
* DESCRIPTION
*    Create a BOOPSI GetFile Button Class Object.
*    ^ <239 0 15>
*************************************************************************
*
*/
#ifdef  __SASC
METHODFUNC OBJECT *initGetFileClass( void )
{
   IMPORT Class *initGet( void );
   
   Class  *gClass = (Class *) NULL;
   OBJECT *rval   = o_nil;
   
   if (!(gClass = (Class *) initGet())) // != NULL)
      rval = AssignObj( new_address( (ULONG) gClass ) );

   return( rval );
}
#endif

/****i* initGetFileImage() [3.0] ****************************************
*
* NAME
*    initGetFileImage()
*
* DESCRIPTION
*    Create a BOOPSI GetFile Button Image Object.
*    ^ <239 0 16 gClass viObject>
*************************************************************************
*
*/

METHODFUNC OBJECT *initGetFileImage( OBJECT *gClassObj, OBJECT *viObj )
{
   struct _Object *gImage = (struct _Object *) NULL;
   
   Class  *gClass = (Class *) CheckObject( gClassObj );
   APTR    vi     =    (APTR)   int_value( (INTEGER *) viObj );
   OBJECT *rval   = o_nil;

   if (!gClass || !vi) // == NULL)
      return( rval );
      
   if (!(gClass = (Class *) int_value( gClassObj ))) // == NULL)
      return( rval );
   
   if (!(gImage = NewObject( gClass, NULL, GT_VisualInfo, vi, TAG_DONE ))) // != NULL)
      rval = AssignObj( new_address( (ULONG) gImage ) );
      
   return( rval );   
}

/****i* disposeGetFileClass() [3.0] *************************************
*
* NAME
*    disposeGetFileClass()
*
* DESCRIPTION
*    Free a BOOPSI GetFile Button Class Object.
*    ^ <239 0 17 gClass>
*************************************************************************
*
*/

METHODFUNC void disposeGetFileClass( OBJECT *gClassObj )
{
   Class *gClass = (Class *) CheckObject( gClassObj );

   if (!gClass) // == NULL)
      return;
      
   if (!(gClass = (Class *) addr_value( gClassObj ))) // != NULL)
      {
      FreeClass( gClass );

      obj_dec( gClassObj );
      }
   
   return;
}

/****i* disposeGetFileImage() [3.0] *************************************
*
* NAME
*    disposeGetFileImage()
*
* DESCRIPTION
*    Free a BOOPSI GetFile Button Image Object.
*    ^ <239 0 18 gImage>
*************************************************************************
*
*/

METHODFUNC void disposeGetFileImage( OBJECT *gImageObj )
{                             
   struct _Object *gImage = (struct _Object *) CheckObject( gImageObj );
   
   if (!gImage) // == NULL)
      return;
      
   if ((gImage = (struct _Object *) addr_value( gImageObj ))) // != NULL)
      {
      DisposeObject( gImage );

      obj_dec( gImageObj );
      }

   return;
}

/****i* adjustGetFileGadget() [3.0] *************************************
*
* NAME
*    adjustGetFileGadget()
*
* DESCRIPTION
*    Ensure that a BOOPSI GetFile Button Object has the correct settings.
*    ^ <239 0 19 gadObject gImage>
*************************************************************************
*
*/

METHODFUNC OBJECT *adjustGetFileGadget( OBJECT *gObj, OBJECT *gImageObj )
{
   struct Gadget  *gad    = (struct Gadget  *) CheckObject( gObj      );
   struct _Object *gImage = (struct _Object *) CheckObject( gImageObj );
   OBJECT         *rval   = gObj;

   if (!(gad = (struct Gadget *) addr_value( gObj ))) // == NULL)
      return( o_nil );

   if (!(gImage = (struct _Object *) addr_value( gImageObj ))) // == NULL)
      return( o_nil );
  
   // Ensure that a GetFile Gadget has the following settings:   

   gad->Flags        |= GFLG_GADGIMAGE | GFLG_GADGHIMAGE;
   gad->Activation   |= GACT_RELVERIFY;
   gad->GadgetRender  = (APTR) gImage;
   gad->SelectRender  = (APTR) gImage;
   
   return( rval );
}

/****i* setStringArray() [3.0] ******************************************
*
* NAME
*    setStringArray()
*
* DESCRIPTION
*    Transform an Array of Strings into something that can be used by
*    either Cycle or MX Gadgets.  This has to be done BEFORE
*    the Gadget gets created!.
*
*    ^ <239 0 20 gadgetType strSize stringArray>
*************************************************************************
*
*/

METHODFUNC OBJECT *setStringArray( int gType, int strSize, OBJECT *strArray )
{
   OBJECT  *rval     = o_nil;  
   char   **newArray = NULL;
   int      i, size = objSize( strArray );

   if (strSize < 1)
      return( rval );

   // newArray is temporary to this function:
         
   if (!(newArray = (char **) AT_AllocVec( (size + 1) * sizeof( char * ),
                                           MEMF_CLEAR| MEMF_ANY,
                                           "ngadStringArray", TRUE ))) // == NULL)
      {
      MemoryOut( GToolCMsg( MSG_GT_SSA_FUNC_GTOOL ) );

      return( rval );
      }
      
   for (i = 0; i < size; i++)
      newArray[i] = string_value( (STRING *) strArray->inst_var[i] );
   
   newArray[i] = NULL; // Terminate the array of Strings.

   switch (gType)
      {
      default:
         AT_FreeVec( &newArray[0], "ngadStringArray", TRUE ); // USER PROGRAM ERROR!
         break;
         
      case MX_KIND:
      case CYCLE_KIND:
         rval = AssignObj( new_address( (ULONG) &newArray[0] ) );
         break;   
      }   

   return( rval );
}

/****i* freeStringArray() [3.0] *****************************************
*
* NAME
*    freeStringArray()
*
* DESCRIPTION
*    FreeVec any memory associated with either Cycle or MX 
*    Gadgets.
*    <239 0 21 private2 gType>
*    private2 is an Integer that points to an array of String pointers.
*************************************************************************
*
*/

METHODFUNC void freeStringArray( char *strPtr, int gType )
{
   switch (gType)
      {
      case CYCLE_KIND:
      case MX_KIND:
         if (strPtr) // != NULL)
            AT_FreeVec( strPtr, "ngadStringArray", TRUE );
            
         break;   
      
      default:
         break;
      }

   return;
}

/****i* findMaximumString() [3.0] ***************************************
*
* NAME
*    findMaximumString()
*
* DESCRIPTION
*    Find the length of the largest string in strArray (& add one for the
*    NULL at the end).
*    Called only by setLVArray().
*************************************************************************
*
*/

SUBFUNC int findMaximumString( OBJECT *strArray )
{
   int rval = 0, thisLen = 0, i, aSize = objSize( strArray );
   
   for (i = 0; i < aSize; i++)
      {
      thisLen = StringLength( string_value( (STRING *) strArray->inst_var[i] ) ) + 1;
      
      if (rval <= thisLen)
         rval = thisLen;
      }
      
   return( rval );
}

/****i* setLVArray() [3.0] **********************************************
*
* NAME
*    setLVArray()
*
* DESCRIPTION
*    Transform an Array of Strings into a ListViewMem struct for
*    ListViewers.  This has to be done BEFORE
*    the Gadget gets created!.
*
*    ^ private3 <- <239 0 22 stringArray>
*************************************************************************
*
*/

METHODFUNC OBJECT *setLVArray( OBJECT *strArray )
{
   struct ListViewMem *lvm  = (struct ListViewMem *) NULL;
   OBJECT             *rval = o_nil;  
   int                 size = objSize( strArray );
   int                 i, strSize;

   if ((strSize = findMaximumString( strArray )) < 1)
      return( rval );

   if (!(lvm = Guarded_AllocLV( size, strSize ))) // == NULL)  // size + 1, strSize )) == NULL)
      {
      MemoryOut( GToolCMsg( MSG_GT_SSA_FUNC_GTOOL ) );

      return( rval );
      }

   for (i = 0; i < size; i++)
      {
      StringCopy( &lvm->lvm_NodeStrs[i * strSize], 
                  string_value( (STRING *) strArray->inst_var[i] ) 
                );
      }

   rval = AssignObj( new_address( (ULONG) lvm ) );

   return( rval );
}

/****i* setupListLV() [3.0] *********************************************
*
* NAME
*    setupListLV()
*
* DESCRIPTION
*    Create the List structure for a ListView Gadget.
*    This has to be done BEFORE the Gadget gets created!.
*
*    ^ private2 <- <239 0 23 private3>
*************************************************************************
*
*/

METHODFUNC OBJECT *setupListLV( struct ListViewMem *lvm )
{
   OBJECT      *rval   = o_nil;  
   struct List *lvList = (struct List *) NULL;

   if (!(lvList = (struct List *) 
                  AT_AllocVec( sizeof( struct List ), 
                               MEMF_CLEAR | MEMF_ANY,
                               "lvList", TRUE ))) // == NULL)
      {
      MemoryOut( GToolCMsg( MSG_GT_SSA_FUNC_GTOOL ) );
       
      return( rval );
      }
         
   SetupList( lvList, lvm );
         
   rval = AssignObj( new_address( (ULONG) lvList ) );

   return( rval );
}

/****i* freeListViewStuff() [3.0] ***************************************
*
* NAME
*    freeListViewStuff()
*
* DESCRIPTION
*    FreeVec any memory associated with a ListView Gadget.
*       <239 0 24 private2 private3>
*
*    private2 is an Integer that points to a List,
*    private3 is an Integer that points to a ListVIewMem struct.
*************************************************************************
*
*/

METHODFUNC void freeListViewStuff( struct List        *lvList,
                                   struct ListViewMem *lvm 
                                 )
{
   if (lvm) // != NULL)
      Guarded_FreeLV( lvm );
      
   if (lvList) // != NULL)
      AT_FreeVec( lvList, "lvList", TRUE );

   return;
}

/****i* initializeLV() [3.0] ********************************************
*
* NAME
*    initializeLV()
*
* DESCRIPTION
*    Ensure that the ListView has correct Tags & a List!
*    ^ <239 0 25 private2 (super gadget) (super window) tagArray>
*
*    private2 is an Integer that points to a List.
*    Return value is o_true on Success!
*************************************************************************
*
*/

METHODFUNC OBJECT *initializeLV( OBJECT *listObj, OBJECT *gadObj,
                                 OBJECT *wObj,    OBJECT *tagArray // can be o_nil
                               )
{
   IMPORT ULONG tagGrabbers[]; // Located in TagFuncs.c
   
   struct List   *lvList   = (struct   List *) CheckObject( listObj );
   struct Gadget *lvGadget = (struct Gadget *) CheckObject( gadObj  );
   struct Window *wptr     = (struct Window *) CheckObject( wObj    );
   OBJECT        *rval     = o_false;
   ULONG         *tags     = NULL;
   int            tagSize  = 0;
   
   // -----------------------------------------------------------
   
   if (NullChk( (OBJECT *) wptr ) == TRUE)
      return( rval );
      
   if (NullChk( (OBJECT *) lvGadget ) == TRUE)
      return( rval );
      
   if (NullChk( (OBJECT *) lvList ) == TRUE)
      return( rval );
   
   if (NullChk( tagArray ) == FALSE)
      {
      tagSize = objSize( tagArray ) + 2;

      tags = (ULONG *) AT_AllocVec( tagSize * sizeof( ULONG ), 
                                    MEMFLAGS, "initializeLVTags", TRUE 
                                  );
      
      if (!tags) // == NULL)
         {
         MemoryOut( "initializeLV()" );

         return( rval );
         }
      else
         {
         int i, j;

         tags[0] = GTLV_Labels;
         tags[1] = (ULONG) lvList;
         
         for (i = 0, j = 2; j < tagSize; i++, j++)
            {
            OBJECT *x = tagArray->inst_var[i];
         
            if ((x == o_nil) || (x == o_false)) // Goofy things a User might do.
               tags[j] = FALSE;
            else if (x == o_true)
               tags[j] = TRUE;
            else
               {
               tags[j] = (ULONG) // tagGrabbers in TagFuncs.c
                         ObjActionByType( x, (OBJECT * (**)( OBJECT * )) tagGrabbers );
               }
            }
         }          
      }
   else // Create our own tagList:
      {
      tagSize = 5;

      tags = (ULONG *) AT_AllocVec( tagSize * sizeof( ULONG ), 
                                    MEMFLAGS, "initializeLVTags", TRUE 
                                  );

      if (!tags) // == NULL)
         {
         MemoryOut( "initializeLV()" );

         return( rval );
         }
      else
         {
         tags[0] = GTLV_Labels;
         tags[1] = (ULONG) lvList;
         tags[2] = GTLV_Selected;
         tags[3] = 0;
         tags[4] = TAG_DONE;
         } 
      }

   GT_SetGadgetAttrsA( lvGadget, wptr, NULL, (struct TagItem *) tags );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "initializeLVTags", TRUE );
      
   rval = o_true;
   
   return( rval );      
}

/****h* HandleNGadgets() [3.0] *****************************************
*
* NAME
*    HandleNGadgets()
*
* DESCRIPTION
*    The function that the Primitive handler calls for GadTools
*    Gadget stuff. <primitive 239 0 xx parms>
************************************************************************
*
*/

METHODFUNC OBJECT *HandleNGadgets( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 239 );

      return( rval );
      }

   switch (int_value( args[0] ))
      {
      case 0: // dispose [private0 == gadgetList]
         if (NullChk( args[1] ) == FALSE)
            {
            DisposeGadgetList( args[1] ); // FreeGadgets() call
            }
         
         break;
             
      case 1: // private0 <- allocateGadgetList
         rval = allocateGadgetList();
         
         break;
       
      case 2: // ^ [private1 == firstGadget] <- createGadgetList [private0]
         rval = createGadgetList( args[1] );
         
         break;
         
      case 3: // ^ newGadgetObj <- makeNewGadget: newGadgetArray [chkSize]
         if (!is_array( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 239 );
         else
            rval = makeNewGadgetStruct( args[1], (ULONG) int_value( args[2] ) );
         
         break;   
      case 4: // addGadgetToList: [private] newGadgetObj type: type tags: tagArray    
         if (!is_address( args[1] ) || !is_address( args[2] )
                                    || !is_integer( args[3] ))
            (void) PrintArgTypeError( 239 );
         else    // CreateGadgetA() call 
            rval = addGadgetToList(            args[1],   // gadgetObject
                                               args[2],   // newGadgetObject
                                    int_value( args[3] ), // gadgetType
                                               args[4]    // tagArray
                                  );
         break;
      
      case 5: // setGadgetAttrs: [private] windowObj tags: tagArray
         if (is_array( args[3] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            setGadgetAttrs( args[1], args[2], args[3] );
            
         break;
         
      case 6: // ^ getGadgetAttrs: [private] windowObj tags: tagArray
         if (is_array( args[3] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            rval = getGadgetAttrs( args[1], args[2], args[3] );
            
         break;     
      
      case 7: // disposeNewGadget: newGadgetObj
         if (NullChk( args[1] ) == FALSE)
            {
            disposeNewGadget( args[1] );
            }

         break;

      case 8: // getUserData: intuiMsgObj
         rval = getGadgetUserData( args[1] );
         break;
         
      case 9: // getGadgetID: intuiMsgObj
         rval = getGadgetID( args[1] );
         break;
         
      case 10: // getGadgetType: intuiMsgObj
         rval = getGadgetType_UserData( args[1] );
         break;

      case 11: // getGadgetHotKey: intuiMsgObj
               // ^ <primitive 239 0 11 intuiMsgObj>
         rval =  getGadgetHotKey( args[1] );
         break;

      case 12: // addHotKey: keyValue to: controlObject
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            addGadgetHotKey( (ULONG) int_value( args[1] ), args[2] );
         break;

      case 13: // getGadgetValue()
               // ^ <239 0 13 private winObj gadgetType>
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            rval = getGadgetValue( args[1], args[2], int_value( args[3] ) );
   
         break;

      case 14: // setGadgetValue()
               //   <239 0 14 private windowObj value>
         setGadgetValue( args[1], args[2], args[3] );
         
         break;

#     ifdef    __SASC
      case 15: // initGadgetClass BOOPSI getFileGadget
         rval = initGetFileClass();  
         break;
#     endif
                             
      case 16: // initGadgetImage [gClass viObj] BOOPSI getFileGadget
         if (is_address( args[1] ) == FALSE || is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            rval = initGetFileImage( args[1], args[2] );
             
         break;
                             
      case 17: // disposeGadgetClass [gClass] BOOPSI getFileGadget
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            disposeGetFileClass( args[1] );
            
         break;
                             
      case 18: // disposeGadgetImage [gImage]
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            disposeGetFileImage( args[1] );
              
         break;

      case 19: // adjustGetFileGadget [gadget gImage]
         if (is_address( args[1] ) == FALSE || is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            rval = adjustGetFileGadget( args[1], args[2] );
            
         break;

      case 20: // setStringArray: gadType size: strSize array: strArray
               // ^ <239 0 20 gadgetType lvStringSize stringArray>
         if (!is_integer( args[1] ) || !is_integer( args[2] )
                                    || !is_array( args[3] ))
            (void) PrintArgTypeError( 239 );
         else
            rval = setStringArray( int_value( args[1] ),
                                   int_value( args[2] ), 
                                   args[3]
                                 );
         break;
      
      case 21: // freeStringArray: private2 type: gType
               // <239 0 21 private2 gadgetType>
         if (!is_address( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 239 );
         else
            freeStringArray( (char *) addr_value( args[1] ), 
                                      int_value( args[2] ) 
                           );
         break;

      case 22: // setLVArray()  ^ private3 <- <239 0 22 stringArray>
         if (is_array( args[1] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            rval = setLVArray( args[1] );
           
         break;
      
      case 23: // setupListLV   ^ private2 <- <239 0 23 private3>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            rval = setupListLV( (struct ListViewMem *) addr_value( args[1] ) );

         break;
      
      case 24: // freeListViewStuff  <239 0 24 private2 private3>
         if (!is_address( args[1] ) || !is_address( args[2] ))
            (void) PrintArgTypeError( 239 );
         else
            freeListViewStuff( (struct        List *) addr_value( args[1] ),
                               (struct ListViewMem *) addr_value( args[2] )
                             );
         break;

      case 25: // ^ <239 0 25 private2 (super gadget) (super window) tagArray>
         rval = initializeLV( args[1], args[2], args[3], args[4] );
         break;

      default:
         break;
      }
   
   return( rval );
} 

/****i* DisposeNewMenus() [3.0] *****************************************
*
* NAME
*    DisposeNewMenus()
*
* DESCRIPTION
*    <239 1 0 newMenuObj>
*************************************************************************
*
*/

METHODFUNC void DisposeNewMenus( OBJECT *newMObj )
{
   struct NewMenu *nm = (struct NewMenu *) CheckObject( newMObj );
      
   if (nm) // != NULL)
      {
      AT_FreeVec( nm, "NewMenu", TRUE );
      }

   return;
}

/****i* allocateNewMenu() [2.0] *****************************************
*
* NAME
*    allocateNewMenu()
*
* DESCRIPTION
*    Make some NewMenu structures (as an Array) to be filled in later.
*    <239 1 1 numItems> ^ newMenuObj <- allocateNewMenu: numItems
*************************************************************************
*
*/

METHODFUNC OBJECT *allocateNewMenu( int numItems )
{
   struct NewMenu *newMenus = (struct NewMenu *) NULL;
   OBJECT         *rval     = o_nil;
   int             i        = 0, size = sizeof( struct NewMenu );
   
   if ((numItems < 0) || (numItems > 60543)) // 31 menus * 63 items * 31 subs)
      {
               // item,         low, upper, actual 
      OutOfRange( GToolCMsg( MSG_GT_MENU_ITEMS_GTOOL ), 0, 60543, numItems );
      
      return( rval );
      }

   rval     = AssignObj( new_array( numItems, FALSE ) ); // NULL's been checked.

   newMenus = (struct NewMenu *) AT_AllocVec( size * numItems, 
                                              MEMF_CLEAR | MEMF_ANY,
                                              "NewMenu", TRUE 
                                            );

   if (!newMenus) // == NULL)
      {
      MemoryOut( GToolCMsg( MSG_GT_NEWMN_FUNC_GTOOL ) );

      return( o_nil );
      }

   for (i = 0; i < numItems; i++)
      {
      // only char * does arithmetic correctly:
      int   offset = i * size;
      char *ptr    = (((char *) newMenus) + offset);

      rval->inst_var[i] = AssignObj( new_address( (ULONG) ptr ) );
      }

   return( rval );
}

/****i* fillNewMenuItem() [2.0] *****************************************
*
* NAME
*    fillNewMenuItem()
*
* DESCRIPTION
*    Fill in a NewMenu structure (newMenuObj is an Array) from 
*    newMenuArray at location itemNumber - 1.
*
*      structureArray is an Array Object with the following
*      elements in the given order:
*      ele[1] <- nm_Type,          ele[2] <- nm_Label,
*      ele[3] <- nm_CommKey,       ele[4] <- nm_Flags,
*      ele[5] <- nm_MutualExclude, ele[6] <- nm_UserData 
*      ele[6] is an Array as follows:
*
*        udele[0] <- menu Type
*        udele[1] <- menu ID Integer or String (nm_Label?),
*        udele[2] <- userData (Usually a #methodSymbol,
*        udele[3] <- equivalent to ele[3] (nm_CommKey)
*        udele[4] <- menu Value
*
*    <239 1 2 itemNumber structArray> 
*    ^ fillNewMenuItem: itemNumber with: structArray [private]
*************************************************************************
*
*/

METHODFUNC OBJECT *fillNewMenuItem( int     itemNumber, 
                                    OBJECT *newMenuArray, // Array Object
                                    OBJECT *newMenuObj    // Array Object 
                                  )  
{
   struct NewMenu *newMen = (struct NewMenu *) NULL; // (struct NewMenu *) CheckObject( newMenuObj );
   OBJECT         *rval   = o_nil;

   if (NullChk( newMenuObj ) == TRUE) // newMen == NULL)
      return( rval );
         
   if (itemNumber <= 0 || itemNumber > objSize( newMenuObj ))
      {
      OutOfRange( GToolCMsg( MSG_GT_FILLM_FUNC_GTOOL ), 1, objSize( newMenuObj ), itemNumber );
      
      return( rval );
      }

   newMen = (struct NewMenu *) addr_value( newMenuObj->inst_var[ itemNumber - 1 ] );

   switch (int_value( newMenuArray->inst_var[0] ))
      {
      case NM_TITLE: // Validate the nm_Type supplied:
      case NM_ITEM:
      case NM_SUB:
      case NM_END:
      case -1:          // NM_BARLABEL:
      case IM_ITEM:
      case IM_SUB:
      case NM_IGNORE:

         newMen->nm_Type = (UBYTE) int_value( newMenuArray->inst_var[0] );
         break;
      
      default:
         newMen->nm_Type = NM_END;
         break;
      }

   if (NullChk( newMenuArray->inst_var[1] ) == FALSE)
      newMen->nm_Label = string_value( (STRING *) newMenuArray->inst_var[1] );
   else
      newMen->nm_Label = NULL;
      
   if (NullChk( newMenuArray->inst_var[2] ) == FALSE)
      newMen->nm_CommKey = string_value( (STRING *) newMenuArray->inst_var[2] );
   else
      newMen->nm_CommKey = NULL;
      
   if (NullChk( newMenuArray->inst_var[3] ) == FALSE)
      newMen->nm_Flags = (UWORD) int_value( newMenuArray->inst_var[3] );
   else
      newMen->nm_Flags = 0;
   
   if (NullChk( newMenuArray->inst_var[4] ) == FALSE)
      newMen->nm_MutualExclude = (LONG) int_value( newMenuArray->inst_var[4] );
   else
      newMen->nm_MutualExclude = 0L;

   /* newMenuArray->inst_var[5] is an Array of 5 elements, the first
   ** being the menu Type, 2nd is the ID (nm_Label), 3rd being UserData,
   ** the 4th being a HotKey value equivalent to
   ** the nm_CommKey value & the last being the menu Value
   */
   if (NullChk( newMenuArray->inst_var[5] ) == FALSE)
      newMen->nm_UserData = (APTR) AssignObj( newMenuArray->inst_var[5] ); // ref_count++
   else
      newMen->nm_UserData = (APTR) NULL;
      
   rval = o_true;

   return( rval );
}

/****i* createNewMenus() [2.0] ******************************************
*
* NAME
*    createNewMenus()
*
* DESCRIPTION
*    <239 1 3 newMenuArrayObj tagArray>
*    ^ menuStrip <- createMenuStrip: [newMenuArrayObj] tagArray
*************************************************************************
*
*/

METHODFUNC OBJECT *createNewMenus( OBJECT *newMenuObj, OBJECT *tagArray )
{
   struct NewMenu *newMen = (struct NewMenu *) CheckObject( newMenuObj );
   struct Menu    *retmen = (struct Menu    *) NULL;
   struct TagItem *tags   = (struct TagItem *) NULL;
   OBJECT         *rval   = o_nil;
   
   if (!newMen) // == NULL)
      return( rval );   

   if (NullChk( tagArray ) == FALSE)
      tags = ArrayToTagList( tagArray );

   retmen = CreateMenusA( newMen, tags );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "createMenusTags", TRUE );

   rval = AssignObj( new_address( (ULONG) retmen ) );
   
   return( rval );
}

/****i* initializeMenus() [2.0] *****************************************
*
* NAME
*    initializeMenus()
*
* DESCRIPTION
*    LayoutMenusA() call
*    <239 1 4 menuObj viObj tagArray>
*************************************************************************
*
*/

METHODFUNC OBJECT *initializeMenus( OBJECT *menuObj, OBJECT *viObj, OBJECT *tagArray )
{
   struct TagItem *tags = (struct TagItem *) NULL;
   struct Menu    *menu = (struct Menu *) CheckObject( menuObj );
   APTR            vi   =          (APTR)   int_value( (INTEGER *) viObj );
   OBJECT         *rval = o_nil;
    
   if (!menu || !vi) // == NULL)
      return( rval );
   
   if ((NullChk( tagArray ) == FALSE) 
       && (NullChk( tagArray->inst_var[0] ) == FALSE))
      {
      tags = ArrayToTagList( tagArray );
      }

   if (LayoutMenusA( menu, vi, tags ) == FALSE)
      rval = o_false;
   else
      rval = o_true;
      
   if (tags) // != NULL)
      AT_FreeVec( tags, "LayoutMenusTags", TRUE );

   return( rval );
}

/****i* getMenuUserData() [2.0] *****************************************
*
* NAME
*    getMenuUserData()
*
* DESCRIPTION
*    ^ <239 1 5 windowObj intuiMsgCode>
*************************************************************************
*
*/

METHODFUNC OBJECT *getMenuUserData( OBJECT *winObj, UWORD msgCode )
{
   struct Window *wptr = (struct Window *) CheckObject( winObj );
   OBJECT        *rval = o_nil;

   if (!wptr) // == NULL)
      return( rval );
         
   if (msgCode != MENUNULL)
      {
      struct MenuItem *item = ItemAddress( wptr->MenuStrip, msgCode );

      /* The Menu UserData is an Array of 5 elements, the first
      ** being a Type, 2nd is a String (nm_Label), the 3rd being the 
      ** UserData, the 4th being a  HotKey value equivalent to
      ** the nm_CommKey value & the last being the menu Value
      */
      rval = AssignObj( new_address( (ULONG) GTMENUITEM_USERDATA( item ) ) );
      }

   return( rval );
}

/****i* getMenuItem() [2.0] *********************************************
*
* NAME
*    getMenuItem()
*
* DESCRIPTION
*    ^ <239 1 6 windowObj intuiMsgCode>
*************************************************************************
*
*/

METHODFUNC OBJECT *getMenuItem( OBJECT *winObj, UWORD msgCode )
{        
   struct Window *wptr = (struct Window *) CheckObject( winObj );
   OBJECT        *rval = o_nil;

   if (!wptr) // == NULL)
      return( rval );
         
   if (msgCode != MENUNULL)
      {
      struct MenuItem *item = ItemAddress( wptr->MenuStrip, msgCode );

      rval = AssignObj( new_address( (ULONG) item ) );
      }

   return( rval );
}

/****i* isMenuNull() [2.0] **********************************************
*
* NAME
*    isMenuNull()
*
* DESCRIPTION
*    ^ <239 1 7 private intuiMsgCode>
*************************************************************************
*
*/

METHODFUNC OBJECT *isMenuNull( OBJECT *menuObj, UWORD msgCode )
{
   if (msgCode == MENUNULL)
      return( o_true );
   else
      return( o_false );
}

/****i* getMenuNumber() [2.0] *******************************************
*
* NAME
*    getMenuNumber()
*
* DESCRIPTION
*    ^ <239 1 8 intuiMsgCode>
*************************************************************************
*
*/

METHODFUNC OBJECT *getMenuNumber( UWORD msgCode )
{
   if (msgCode == MENUNULL)
      return( o_nil );
      
   return( AssignObj( new_int( (int) MENUNUM( msgCode ) ) ) );
}

/****i* getMenuItemNumber() [2.0] ***************************************
*
* NAME
*    getMenuItemNumber()
*
* DESCRIPTION
*    ^ <239 1 9 intuiMsgCode>
*************************************************************************
*
*/

METHODFUNC OBJECT *getMenuItemNumber( UWORD msgCode )
{
   if (msgCode == MENUNULL)
      return( o_nil );
      
   return( AssignObj( new_int( (int) ITEMNUM( msgCode ) ) ) );
}

/****i* getSubNumber() [2.0] ********************************************
*
* NAME
*    getSubNumber()
*
* DESCRIPTION
*    ^ <239 1 10 intuiMsgCode>
*************************************************************************
*
*/

METHODFUNC OBJECT *getSubNumber( UWORD msgCode )
{
   if (msgCode == MENUNULL)
      return( o_nil );
      
   return( AssignObj( new_int( (int) SUBNUM( msgCode ) ) ) );
}

/****i* getFullMenuNumber() [2.0] ***************************************
*
* NAME
*    getFullMenuNumber()
*
* DESCRIPTION
*    ^ <239 1 11 intuiMsgCode>
*************************************************************************
*
*/

METHODFUNC OBJECT *getFullMenuNumber( UWORD msgCode )
{
   UWORD m, i, s;
   
   if (msgCode == MENUNULL)
      return( o_nil );

   m = MENUNUM( msgCode );
   i = ITEMNUM( msgCode );
   s = SUBNUM(  msgCode );
   
   return( AssignObj( new_int( (int) FULLMENUNUM( m, i, s ) ) ) );
}

/****i* addMenuHotKey() [2.1] *******************************************
*
* NAME
*    addMenuHotKey()
*
* DESCRIPTION
*    <239 1 12 keyValue menuObj>
*************************************************************************
*
*/

METHODFUNC void addMenuHotKey( UBYTE keyValue, OBJECT *menuObj )
{
   struct MenuItem *mi = (struct MenuItem *) CheckObject( menuObj );
   
   if (mi) // != NULL)
      {
      ULONG *udata = (ULONG *) GTMENUITEM_USERDATA( mi );
      
      if ((udata) && (&udata[KEY_FIELD])) // != NULL)) // Kill Bugs!
         udata[KEY_FIELD] = keyValue;
      }
      
   return;
}

/****h* HandleNewMenus() [2.0] *****************************************
*
* NAME
*    HandleNewMenus()
*
* DESCRIPTION
*    The function that the Primitive handler calls for GadTools
*    Menu stuff. <primitive 239 1 xx 0-4 parms>
************************************************************************
*
*/

METHODFUNC OBJECT *HandleNewMenus( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 239 );

      return( rval );
      }

   switch (int_value( args[0] ))
      {
      case 0: // disposeMenu [newMenuObj]
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            DisposeNewMenus( args[1] ); // FreeMenus() call
            
         break;
         
      case 1: // ^ newMenuArrayObj <- allocateNewMenu: numItems
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            rval = allocateNewMenu( int_value( args[1] ) );
            
         break;
       
      case 2: // ^ chk <- fillNewMenuItem: itemNumber with: structArray [private]
         if (!is_integer( args[1] ) || !is_array( args[2] )
                                    || !is_array( args[3] ))
            (void) PrintArgTypeError( 239 );
         else
            rval = fillNewMenuItem( int_value( args[1] ), args[2], args[3] );
         
         break;   
       
      case 3: // ^ menuStrip <- createMenuStrip: [newMenuArrayObj] tagArray
         if (!is_array( args[1] ) || !is_array( args[2] ))
            (void) PrintArgTypeError( 239 );
         else
            rval = createNewMenus( args[1], args[2] );
         
         break;   

      case 4: // ^ success <- initializeMenus: [private] viObj tags: tagArray
         if (!is_array( args[3] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 239 );
         else
            rval = initializeMenus( args[1], args[2], args[3] );
            
         break;  

      case 5: // ^ dataObj <- getMenuUserData: [windowObj] intuiMsgCode
         if (is_integer( args[2] ) == FALSE)          
            (void) PrintArgTypeError( 239 );
         else
            rval = getMenuUserData( args[1], (UWORD) int_value( args[2] ) );

         break;

      case 6: // ^ itemObj <- getMenuItem: [windowObj] intuiMsgCode      
         if (is_integer( args[2] ) == FALSE)          
            (void) PrintArgTypeError( 239 );
         else
            rval = getMenuItem( args[1], (UWORD) int_value( args[2] ) );

         break;

      case 7: // isMenuNull: [private] intuiMsgCode
         if (is_integer( args[2] ) == FALSE)          
            (void) PrintArgTypeError( 239 );
         else
            rval = isMenuNull( args[1], (UWORD) int_value( args[2] ) );

         break;

      case 8: // getMenuNumber: intuiMsgCode  // ^ <239 1 8 intuiMsgCode>
         if (is_integer( args[1] ) == FALSE)          
            (void) PrintArgTypeError( 239 );
         else
            rval = getMenuNumber( (UWORD) int_value( args[1] ) );
         
         break;
          
      case 9: // getMenuItemNumber: intuiMsgCode // ^ <239 1 9 intuiMsgCode>
         if (is_integer( args[2] ) == FALSE)          
            (void) PrintArgTypeError( 239 );
         else
            rval = getMenuItemNumber( (UWORD) int_value( args[1] ) );
         
         break;

      case 10: // getSubNumber: intuiMsgCode  //  ^ <239 1 10 intuiMsgCode>
         if (is_integer( args[2] ) == FALSE)          
            (void) PrintArgTypeError( 239 );
         else
            rval = getSubNumber( (UWORD) int_value( args[1] ) );
         
         break;
      
      case 11: // getFullMenuNumber: intuiMsgCode // ^ <239 1 11 intuiMsgCode>   
         if (is_integer( args[2] ) == FALSE)          
            (void) PrintArgTypeError( 239 );
         else
            rval = getFullMenuNumber( (UWORD) int_value( args[1] ) );
         
         break;

      case 12: // addMenuHotKey: keyValue to: menuObject
               // <239 1 12 keyValue menuObj>
         if (!is_integer( args[1] ) && !is_character( args[1] ))
            (void) PrintArgTypeError( 239 );

         else if (is_integer( args[1] ) == TRUE)
            addMenuHotKey( (UBYTE) int_value( args[1] ), args[2] );

         else
            addMenuHotKey( (UBYTE) char_value( args[1] ), args[2] );
  
         break;
         
      default:
         break;
      }
   
   return( rval );
} 

/****i* drawBevelBox() [2.0] ********************************************
*
* NAME
*    drawBevelBox()
*
* DESCRIPTION
*    <239 2 winObj x y w h tagArray> 
*    drawBox: winObj from: sPoint to: ePoint tags: tagArray
*************************************************************************
*
*/

METHODFUNC void drawBevelBox( OBJECT *winObj, int x, int y, int w, int h, OBJECT *tagArray )
{
   struct Window  *wptr = (struct Window *) CheckObject( winObj );
   struct TagItem *tags = (struct TagItem *) NULL;
   
   if (!wptr) // == NULL)
      return;
         
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   DrawBevelBoxA( wptr->RPort, x, y, w, h, tags );

   if (tags) // != NULL)
      AT_FreeVec( tags, "BevelBoxTags", TRUE );
   
   return;
}

/****i* freeVisualInfo() [2.0] ******************************************
*
* NAME
*    freeVisualInfo()
*
* DESCRIPTION
*    <239 3 0 viObj> freeVisualInfo: viObj
*************************************************************************
*
*/

METHODFUNC void freeVisualInfo( OBJECT *viObj )
{
   APTR vi = (APTR) int_value( (INTEGER *) viObj );
   
   if (vi) // != NULL)
      FreeVisualInfo( vi );
   
   return;
}

/****i* getVisualInfo() [2.0] *******************************************
*
* NAME
*    getVisualInfo()
*
* DESCRIPTION
*    <239 3 1 scrObj tagArray> getVisualInfo: scrObj tags: tagArray
*************************************************************************
*
*/

METHODFUNC OBJECT *getVisualInfo( OBJECT *scrObj, OBJECT *tagArray )
{
   struct TagItem *tags = (struct TagItem *) NULL;
   struct Screen  *sptr = (struct Screen *) CheckObject( scrObj );
   APTR            vi   = 0; // NULL;
   OBJECT         *rval = o_nil;
   
   if (!sptr) // == NULL)
      return( o_nil );
         
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   if ((vi = GetVisualInfoA( sptr, tags )) != NULL)
      rval = (vi == NULL) ? AssignObj( new_address( 0 ) ) 
                          : AssignObj( new_address( (ULONG) vi ) );
      
   if (tags) // != NULL)
      AT_FreeVec( tags, "visualInfoTags", TRUE );
   
   return( rval );
}

/****i* beginRefresh() [2.0] ********************************************
*
* NAME
*    beginRefresh()
*
* DESCRIPTION
*    <239 3 2 winObj> beginRefresh: winObj
*************************************************************************
*
*/

METHODFUNC void beginRefresh( OBJECT *winObj )
{
   struct Window *wptr = (struct Window *) CheckObject( winObj );
   
   if (!wptr) // == NULL)
      return;

   GT_BeginRefresh( wptr );
   
   return;
}

/****i* endRefresh() [2.0] **********************************************
*
* NAME
*    endRefresh()
*
* DESCRIPTION
*    <239 3 3 winObj flag> endRefresh: [winObj] completeFlag
*************************************************************************
*
*/

METHODFUNC void endRefresh( OBJECT *winObj, int completeFlag )
{
   struct Window *wptr = (struct Window *) CheckObject( winObj );
   
   if (!wptr) // == NULL)
      return;

   GT_EndRefresh( wptr, completeFlag );
   
   return;
}

/****i* getIMsg() [2.0] *************************************************
*
* NAME
*    getIMsg()
*
* DESCRIPTION
*    <239 3 4 winObj> ^ imsgObj <- getIMsg [winObj]
*************************************************************************
*
*/

METHODFUNC OBJECT *getIMsg( OBJECT *winObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) NULL;
   struct Window       *wptr = (struct Window *) CheckObject( winObj );
   OBJECT              *rval = o_nil;

   if (!wptr) // == NULL)
      return( rval );

   imsg = GT_GetIMsg( wptr->UserPort );
   
   rval = AssignObj( new_address( (ULONG) imsg ) );
   
   return( rval );
}

/****i* replyIMsg() [2.0] ***********************************************
*
* NAME
*    replyIMsg()
*
* DESCRIPTION
*    <239 3 5 imsgObj> replyIMsg [imsgObj]
*************************************************************************
*
*/

METHODFUNC void replyIMsg( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj );

   if (!imsg) // == NULL)
      return;

   GT_ReplyIMsg( imsg );
   
   return;
}

/****i* refreshWindow() [2.0] *******************************************
*
* NAME
*    refreshWindow()
*
* DESCRIPTION
*    <239 3 6 winObj> refreshWindow [winObj]
*************************************************************************
*
*/

METHODFUNC void refreshWindow( OBJECT *winObj )
{
   struct Window *wptr = (struct Window *) CheckObject( winObj );

   if (!wptr) // == NULL)
      return;

   GT_RefreshWindow( wptr, NULL );
   
   return;
}

/****i* postFilterIMsg() [2.0] ******************************************
*
* NAME
*    postFilterIMsg()
*
* DESCRIPTION
*    <239 3 7 imsgObj> ^ imsgObj <- postFilterIMsg [imsgObj]
*************************************************************************
*
*/

METHODFUNC OBJECT *postFilterIMsg( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj );
   struct IntuiMessage *rmsg = (struct IntuiMessage *) NULL;
   OBJECT              *rval = o_nil;
   
   if (!imsg) // == NULL)
      return( rval );

   rmsg = GT_PostFilterIMsg( imsg );
   
   rval = AssignObj( new_address( (ULONG) rmsg ) );
   
   return( rval );
}

/****i* filterIMsg() [2.0] **********************************************
*
* NAME
*    filterIMsg()
*
* DESCRIPTION
*    <239 3 8 imsgObj> ^ imsgObj <- filterIMsg [imsgObj]
*************************************************************************
*
*/

METHODFUNC OBJECT *filterIMsg( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj );
   struct IntuiMessage *rmsg = (struct IntuiMessage *) NULL;
   OBJECT              *rval = o_nil;
   
   if (!imsg) // == NULL)
      return( rval );

   rmsg = GT_FilterIMsg( imsg );
   
   rval = AssignObj( new_address( (ULONG) rmsg ) );
   
   return( rval );
}

// ======================================================================

// Get a Gadget value & convert into an OBJECT, based on Gadget Type:

SUBFUNC OBJECT *GetGenericValue( struct Gadget *gptr, struct Window *wp )
{
   return( o_nil ); // This should never happen!
}

SUBFUNC OBJECT *GetButtonValue( struct Gadget *gptr, struct Window *wp )
{
   // If button is NOT a toggle button, simply return true:
   if ((gptr->Activation & GACT_TOGGLESELECT) != GACT_TOGGLESELECT)
      return( o_true );
   
   // Gadget is a Toggle button so see if it was selected:
       
   if ((gptr->Flags & GFLG_SELECTED) == GFLG_SELECTED)
      return( o_true );
   else
      return( o_false );
}

SUBFUNC OBJECT *GetChkBoxValue( struct Gadget *gptr, struct Window *wp )
{
   LONG bVal = FALSE;
   
   GT_GetGadgetAttrs( gptr, wp, NULL, GTCB_Checked, &bVal, TAG_DONE );
   
   if (bVal == TRUE)
      return( o_true );
   else
      return( o_false );
}

SUBFUNC OBJECT *GetIntegerValue( struct Gadget *gptr, struct Window *wp )
{
   return( AssignObj( new_int( (int) IntBfPtr( gptr ) ) ) );
}

SUBFUNC OBJECT *GetListViewValue( struct Gadget *gptr, struct Window *wp )
{
   struct Node *myNode   = NULL;
   LONG         ptr      = 0L;
   LONG         whichOne = 0L;

   GT_GetGadgetAttrs( gptr, wp, NULL, GTLV_Labels,   &ptr,
                                      GTLV_Selected, &whichOne, TAG_DONE
                    );

   if (!ptr) // == NULL)
      fprintf( stderr, "ptr in GetListViewValue() was 0x%08LX!\n", ptr );

   if (whichOne == ~0) // Why is this happening??
      whichOne = 0;
                
   if (ptr) // != NULL)
      {
      myNode = ((struct List *) ptr)->lh_Head;
      
      return( AssignObj( new_str( myNode[ whichOne ].ln_Name ) ) );
      }                    
   else
      return( o_nil );
}

SUBFUNC OBJECT *GetRadioValue( struct Gadget *gptr, struct Window *wp )
{
   LONG selection = 0;
   
   GT_GetGadgetAttrs( gptr, wp, NULL, GTMX_Active, &selection, TAG_DONE );
   
   // ordinals start at zero but we want it to start at 1:
   return( AssignObj( new_int( (int) selection + 1 ) ) );
}
                        
SUBFUNC OBJECT *GetCycleValue( struct Gadget *gptr, struct Window *wp )
{
   LONG     which  = 0L;
   char   **labels = (char **) NULL;
   STRING *str     = (STRING *) NULL;

   GT_GetGadgetAttrs( gptr, wp, NULL, GTCY_Labels, (LONG) &labels,
                                      GTCY_Active, (LONG) &which, 
                                      TAG_DONE 
                    );

   str = (STRING *) new_str( labels[ which ] );

   return( AssignObj( (OBJECT *) str ) );
}
                        
SUBFUNC OBJECT *GetPaletteValue( struct Gadget *gptr, struct Window *wp )
{
   LONG color = 0L;
   
   GT_GetGadgetAttrs( gptr, wp, NULL, GTPA_Color, &color, TAG_DONE );
   
   return( AssignObj( new_int( (int) color ) ) );
}
                        
SUBFUNC OBJECT *GetScrollerValue( struct Gadget *gptr, struct Window *wp )
{
   LONG number = 0L;

   GT_GetGadgetAttrs( gptr, wp, NULL, GTSC_Top, &number, TAG_DONE );

   return( AssignObj( new_int( (int) number ) ) );
}
                        
SUBFUNC OBJECT *GetSliderValue( struct Gadget *gptr, struct Window *wp )
{
   LONG value = 0L;
   
   GT_GetGadgetAttrs( gptr, wp, NULL, GTSL_Level, &value, TAG_DONE );
   
   return( AssignObj( new_int( (int) value ) ) );
}

SUBFUNC OBJECT *GetStringValue( struct Gadget *gptr, struct Window *wp )
{
   return( AssignObj( new_str( StrBfPtr( gptr ) ) ) );
}

// ----------------------------------------------------------------------------

SUBFUNC OBJECT *GetScrollerValueByKey( struct Gadget *gptr, struct Window *wp )
{
   LONG number = 0L;

   /*
   ** There is some sort of shadow gadget in front of the real Scroller
   ** that will be found by findGadgetByKey() before the correct Gadget,
   ** so we simply use the NexGadget field to get to the correct Gadget.
   ** This behavior must be watched carefully: 
   */   
   GT_GetGadgetAttrs( gptr->NextGadget, wp, NULL, GTSC_Top, &number, TAG_DONE );

   return( AssignObj( new_int( (int) number ) ) );
}
                        
SUBFUNC OBJECT *GetSliderValueByKey( struct Gadget *gptr, struct Window *wp )
{
   LONG value = 0L;
   
   /*
   ** There is some sort of shadow gadget in front of the real Slider
   ** that will be found by findGadgetByKey() before the correct Gadget,
   ** so we simply use the NexGadget field to get to the correct Gadget. 
   ** This behavior must be watched carefully: 
   */   
   GT_GetGadgetAttrs( gptr->NextGadget, wp, NULL, GTSL_Level, &value, TAG_DONE );
   
   return( AssignObj( new_int( (int) value ) ) );
}

// -----------------------------------------------------------------------------

/*                        
   These are Read-Only Gadgets:

SUBFUNC OBJECT *GetNumberValue( struct Gadget *gptr, struct Window *wp )
{
   return( AssignObj( new_int( (int) IntBfPtr( gptr ) ) ) );
}
                        
SUBFUNC OBJECT *GetTextValue( struct Gadget *gptr, struct Window *wp )
{
   return( AssignObj( new_str( StrBfPtr( gptr ) ) ) );
}
*/

// ======================================================================

/****i* searchMenuStrip() [2.1] **************************************
*
* NAME
*    searchMenuStrip()
*
* DESCRIPTION
*    Search the MenuItems for the first HotKey that corresponds 
*    to keyCode:
**********************************************************************
*
*/

SUBFUNC OBJECT *searchMenuStrip( struct Menu *menustrip, UWORD keyCode )
{
   struct Menu     *mp   = menustrip;
   struct MenuItem *mi   = mp->FirstItem;
   struct MenuItem *sub  = mi->SubItem;
   OBJECT          *rval = o_nil;

   while (mp) // != NULL) // mp DOES NOT have a COMMSEQ, so just traverse them.
      {
      mi = mp->FirstItem;
      
      while (mi) // != NULL)
         {
         sub = mi->SubItem;
         
         if ((mi->Flags & COMMSEQ) == COMMSEQ)
            {
            if (mi->Command == (keyCode & 0xFF))
               {
               // DEBUG this:
               rval = AssignObj( new_address( (ULONG) GTMENUITEM_USERDATA( mi ) ) );

               goto Exitsearch;
               }
            }

         while (sub) // != NULL)
            {
            if ((sub->Flags & COMMSEQ) == COMMSEQ)
               {
               if (sub->Command == (keyCode & 0xFF))
                  {
                  // DEBUG this:
                  rval = AssignObj( new_address( (ULONG) GTMENUITEM_USERDATA( sub ) ) );
   
                  goto Exitsearch;
                  }
               }
            
            sub = sub->NextItem;
            }
         
         mi = mi->NextItem;
         }
         
      mp = mp->NextMenu;
      }

Exitsearch:

   return( rval );
}

/****i* findHotKey() [2.1] *******************************************
*
* NAME
*    findHotKey()
*
* DESCRIPTION
*    Search the GadTools & MenuItems for the first HotKey that
*    corresponds to Msg.Code.  Return the UserData OBJECT.
**********************************************************************
*
*/

SUBFUNC OBJECT *findHotKey( struct Window *wptr, struct IntuiMessage *msg, int *tFlag )
{
   struct Gadget *gads  = wptr->FirstGadget;
   struct Menu   *men   = wptr->MenuStrip;
   ULONG         *udata = (ULONG *) NULL;
   OBJECT        *rval  = o_nil;
         
   // return GadTool or MenuItem UserData.

   while (gads) // != NULL)
      {
      // Search the Gadgets first, since they are always visible:
      udata = (ULONG *) gads->UserData;

      if (!udata) // == NULL)
         goto skipOver; // No point in checking NULL UserData!
         
      //  Should we check for GACT_ALTKEYMAP?????      

      if (  (udata[KEY_FIELD] & 0xFF) == tolower( msg->Code )
         || (udata[KEY_FIELD] & 0xFF) == toupper( msg->Code ))   // + msg.Qualifier))
         {
         rval = AssignObj( new_address( (ULONG) udata ) );
         
         *tFlag = 1;

         return( rval );
         }

skipOver:

      gads = gads->NextGadget;
      }

   if (men) // != NULL)
      {
      rval = searchMenuStrip( men, msg->Code );

      *tFlag = 2;

      return( rval );
      }

   *tFlag = 0;

   return( o_nil );
               
}                       

/****i* findGadgetByKey() [3.0] **************************************
*
* NAME
*    findGadgetByKey()
*
* DESCRIPTION
*    Search the Gadgets attached to a window for the first HotKey that
*    corresponds to Msg.Code.  IDCMP_VANILLAKEY does not know anything
*    about Msg.IAddress, so we need to do this function.
**********************************************************************
*
*/

SUBFUNC struct Gadget *findGadgetByKey( struct Window       *wptr, 
                                        struct IntuiMessage *msg
                                      )
{
   struct Gadget *gads  = wptr->FirstGadget;
   struct Gadget *rval  = (struct Gadget *) NULL;
   ULONG         *udata = (ULONG *) NULL;
   
   while (gads) // != NULL)
      {
      // Search the Gadgets first, since they are always visible:
      udata = (ULONG *) gads->UserData;

      if (!udata) // == NULL)
         goto skipOver; // No point in checking NULL UserData!
         
      if (  (udata[KEY_FIELD] & 0xFF) == tolower( msg->Code )
         || (udata[KEY_FIELD] & 0xFF) == toupper( msg->Code ))
         {
         rval = gads;
         
         break;
         }

skipOver:

      gads = gads->NextGadget;
      }
   
   return( rval );  
}

// ASCII values in msg->Code order for RawKeys:

PRIVATE UBYTE rkeys[] = {

   '`', '1', '2', '3', '4','5','6','7','8','9', '0', '-', '=', '\\', ' ', '0', // 0x00-0F
   'q', 'w', 'e', 'r', 't','y','u','i','o','p', '[', ']', ' ',  '1', '2', '3', // 0x10-1F
   'a', 's', 'd', 'f', 'g','h','j','k','l',';','\'', ' ', ' ',  '4', '5', '6', // 0x20-2F  
   ' ', 'z', 'x', 'c', 'v','b','n','m',',','.', '/', ' ', '.',  '7', '8', '9', // 0x30-3F

   ' ','\b','\t','\n','\n',0x1B,0x7F,' ',' ',' ','-',' ',0x8C,0x8D,0x8E,0x8F,  // 0x40-4F
   0x90,0x91,0x92,0x93,0x94,0x95,0x96,0x97,0x98,0x99,'(',')','/','*','+',0x9F, // 0x50-5F
   0xA0,0xA1,0xA2,0xA3,0xA4,0xA5,0xA6,0xA7,' ',' ',' ',' ',' ',' ',' ',' ',    // 0x60-6F
   
   // Shifted values:
   
   '~','!','@','#','$','%','^','&','*','(',')','_','+','|',' ','0',            // 0x70-7F
   'Q','W','E','R','T','Y','U','I','O','P','{','}',' ','1','2','3',            // 0x80-8F
   'A','S','D','F','G','H','J','K','L',':','"',' ',' ','4','5','6',            // 0x90-9F
   ' ','Z','X','C','V','B','N','M','<','>','?',' ','.','7','8','9',            // 0xA0-AF

   ' ','\b','\t','\n','\n',0x1B,0x7F,' ',' ',' ','-',' ',0xCC,0xCD,0xCE,0xCF,  // 0xB0-BF
   0xD0,0xD1,0xD2,0xD3,0xD4,0xD5,0xD6,0xD7,0xD8,0xD9,'(',')','/','*','+',0xDF, // 0xC0-CF
   0xE0,0xE1,0xE2,0xE3,0xE4,0xE5,0xE6,0xE7,' ',' ',' ',' ',' ',' ',' ',' ',    // 0xD0-DF
    
};

/****i* makeRawKey() [2.1] *******************************************
*
* NAME
*    makeRawKey()
*
* DESCRIPTION
*    Convert the msg->Code & msg->Qualifier field into a rawKey value.
*    See Also, System/AmigaChar.st file
**********************************************************************
*
*/

SUBFUNC OBJECT *makeRawKey( struct IntuiMessage *msg )
{
   UWORD shiftMask = IEQUALIFIER_LSHIFT || IEQUALIFIER_RSHIFT;

   UBYTE chr       = rkeys[ msg->Code ];
   
   if ((msg->Qualifier & shiftMask) != 0)
      chr += 0x70;
            
   return( AssignObj( new_char( chr ) ) );
}

/****i* HandleGT_IDCMP() [3.0] ***************************************
*
* NAME
*    HandleGT_IDCMP()
*
* DESCRIPTION
*
* NOTES
*    Smalltalk code has to call this <primitive 239 3 9 winObj>
*    inside a loop if there is more than one IDCMP event expected.
*    rval <- gadTools handleGTIDCMP: winObj.  This function returns
*    an Array OBJECT with 5 elements:
*       ele[0] <- Gadget or Menu Type
*       ele[1] <- Gadget ID or Menu Label
*       ele[2] <- Gadget or Menu UserData
*       ele[3] <- HotKey
*       ele[4] <- Gadget Value
*
*    ^ <primitive 239 3 9 winObj>
**********************************************************************
*
*/

PRIVATE struct IntuiMessage HanMsg = { 0, };

METHODFUNC OBJECT *HandleGT_IDCMP( OBJECT *winObj )
{
   IMPORT OBJECT *o_IDCMP_rval; // In Global.c, setup in Main.c
   
   struct Window       *wp   = (struct Window *) CheckObject( winObj ); 
   struct Gadget       *gptr = (struct Gadget *) NULL;
   struct IntuiMessage *message, *mptr = &HanMsg;

   OBJECT              *rval     = o_nil;
   int                  checking = TRUE;

   if (!wp) // == NULL)
      return( rval );

   while (checking == TRUE)    
      {
      if (!(message = GT_GetIMsg( wp->UserPort ))) // == NULL)
         {
         (void) Wait( 1L << wp->UserPort->mp_SigBit );

         continue;
         }

      CopyMem( (char *) message, (char *) &HanMsg, 
               (long) sizeof( struct IntuiMessage )
             );

      (void) GT_ReplyIMsg( message );

      switch (HanMsg.Class)   
         {
         case IDCMP_REFRESHWINDOW:
            GT_BeginRefresh( wp );
            GT_EndRefresh( wp, TRUE );
            break;

         case IDCMP_VANILLAKEY:
            /* Search the GadTools & MenuItems for the first HotKey that
            ** corresponds to Msg.Code & Msg.Qualifier:
            */
            {
            int     type  = 0;
            OBJECT *udObj = findHotKey( wp, &HanMsg, &type );
            int    *udata = NULL;
            
            rval = o_IDCMP_rval;

            if (NullChk( udObj ) == TRUE) // This is NOT an assigned hotkey!
               {
               checking = FALSE; // break out of the loop

               rval     = o_IDCMP_rval;

               rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_VKEY ) );
               rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "vanillaKey" ) );
               rval->inst_var[KEY_FIELD]  = AssignObj( new_char( HanMsg.Code ) );
               rval->inst_var[ID_FIELD]   = rval->inst_var[KEY_FIELD];
               rval->inst_var[VAL_FIELD]  = o_nil;               

               break;
               }
            else
               udata = (int *) int_value( udObj );

            switch (type) // type is set by findHotKey()
               {
               case 0:   // o_nil
                  break; 
                  
               case 1:   // Gadget
                  gptr = findGadgetByKey( wp, &HanMsg );

                  rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) udata[TYPE_FIELD] ));
                  rval->inst_var[ID_FIELD]   = AssignObj( new_int( gptr->GadgetID & 0xFFFF ));
                  rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) udata[SYM_FIELD] );
                  rval->inst_var[KEY_FIELD]  = AssignObj( new_char( udata[KEY_FIELD] & 0xFF ));
                               
                  switch (udata[TYPE_FIELD])
                     {
                     // NUMBER_KIND & TEXT_KIND are read-only, so no entries here:

                     case BUTTON_KIND:
                        rval->inst_var[VAL_FIELD] = GetButtonValue( gptr, wp );
                        break;
                        
                     case CHECKBOX_KIND:
                        rval->inst_var[VAL_FIELD] = GetChkBoxValue( gptr, wp );
                        break;
                        
                     case INTEGER_KIND:
                        rval->inst_var[VAL_FIELD] = GetIntegerValue( gptr, wp );
                        break;
                        
                     case LISTVIEW_KIND:
                        rval->inst_var[VAL_FIELD] = GetListViewValue( gptr, wp );
                        break;
                        
                     case CYCLE_KIND:
                        rval->inst_var[VAL_FIELD] = GetCycleValue( gptr, wp );
                        break;
                        
                     case PALETTE_KIND:
                        rval->inst_var[VAL_FIELD] = GetPaletteValue( gptr, wp );
                        break;
                        
                     case SCROLLER_KIND:
                        rval->inst_var[VAL_FIELD] = GetScrollerValueByKey( gptr, wp );
                        break;
                        
                     case SLIDER_KIND:
                        rval->inst_var[VAL_FIELD] = GetSliderValueByKey( gptr, wp );
                        break;
                        
                     case STRING_KIND:
                        rval->inst_var[VAL_FIELD] = GetStringValue( gptr, wp );
                        break;
                  
                     default:
                        break;
                     }

                  break;
                  
               case 2: // Menu Item
                  {
                  struct MenuItem *n  = (struct MenuItem *) NULL;
                  OBJECT          *ud = o_nil;

                  rval->inst_var[TYPE_FIELD] = o_nil;
                  rval->inst_var[ID_FIELD]   = AssignObj( new_str( FindMenuString( HanMsg.Code, wp )));
                  rval->inst_var[VAL_FIELD]  = rval->inst_var[ID_FIELD];
                  
                  n = ItemAddress( wp->MenuStrip, HanMsg.Code );
    
                  if (n) // != NULL)
                     {
                     ud = (OBJECT *) GTMENUITEM_USERDATA( n );
                     
                     ud = ud->inst_var[SYM_FIELD];
                     }

                  rval->inst_var[SYM_FIELD] = AssignObj( ud );
                  rval->inst_var[KEY_FIELD] = AssignObj( new_char( n->Command ) );
                  
                  break;
                  }
               }
            }

            checking = FALSE; 
            break;
                        
         case IDCMP_GADGETUP:
            {
            ULONG *udata = (ULONG *) ((struct Gadget *) HanMsg.IAddress)->UserData;

            gptr = (struct Gadget *) HanMsg.IAddress;

            rval = o_IDCMP_rval; // Temporary storage Array(5)

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) udata[TYPE_FIELD] )); // Gadget Type
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) udata[ID_FIELD] ));   // GadgetID
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *)     udata[SYM_FIELD] );   // #Symbol 
            rval->inst_var[KEY_FIELD]  = AssignObj( new_char( udata[KEY_FIELD] & 0xFF )); // hotKey
             
            switch (udata[TYPE_FIELD])
               {
               // NUMBER_KIND & TEXT_KIND are read-only, so no entries here:

               case BUTTON_KIND:
                  rval->inst_var[VAL_FIELD] = GetButtonValue( gptr, wp );
                  break;
                        
               case CHECKBOX_KIND:
                  rval->inst_var[VAL_FIELD] = GetChkBoxValue( gptr, wp );
                  break;
                        
               case INTEGER_KIND:
                  rval->inst_var[VAL_FIELD] = GetIntegerValue( gptr, wp );
                  break;
                        
               case LISTVIEW_KIND:
                  rval->inst_var[VAL_FIELD] = GetListViewValue( gptr, wp );
                  break;
                        
               case CYCLE_KIND:
                  rval->inst_var[VAL_FIELD] = GetCycleValue( gptr, wp );
                  break;
                        
               case PALETTE_KIND:
                  rval->inst_var[VAL_FIELD] = GetPaletteValue( gptr, wp );
                  break;
                        
               case SCROLLER_KIND:
                  rval->inst_var[VAL_FIELD] = GetScrollerValue( gptr, wp );
                  break;
                        
               case SLIDER_KIND:
                  rval->inst_var[VAL_FIELD] = GetSliderValue( gptr, wp );
                  break;
                        
               case STRING_KIND:
                  rval->inst_var[VAL_FIELD] = GetStringValue( gptr, wp );
                  break;
                  
               default:
                  break;
               }
            }

            checking = FALSE; 
            break;

         case IDCMP_GADGETDOWN:
            {
            ULONG *udata = (ULONG *) ((struct Gadget *) HanMsg.IAddress)->UserData;

            gptr = (struct Gadget *) HanMsg.IAddress;

            rval = o_IDCMP_rval; // Temporary storage Array(5)

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) udata[TYPE_FIELD] )); // Gadget Type
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) udata[ID_FIELD] ));   // GadgetID
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) udata[SYM_FIELD] );  // #Symbol 
            rval->inst_var[KEY_FIELD]  = AssignObj( new_char( udata[KEY_FIELD] & 0xFF )); // hotKey

            switch (udata[TYPE_FIELD]) // gadget Type
               {
               // NUMBER_KIND & TEXT_KIND are read-only, so no entries here:

               case GENERIC_KIND:
                  rval->inst_var[VAL_FIELD] = GetGenericValue( gptr, wp );
                  break;
                        
               case BUTTON_KIND:      // ARROWIDCMP is a button also.
                  rval->inst_var[VAL_FIELD] = GetButtonValue( gptr, wp );
                  break;
                        
               case LISTVIEW_KIND:
                  rval->inst_var[VAL_FIELD] = GetListViewValue( gptr, wp );
                  break;
                        
               case MX_KIND:
                  rval->inst_var[VAL_FIELD] = GetRadioValue( gptr, wp );
                  break;
                        
               case SCROLLER_KIND:
                  rval->inst_var[VAL_FIELD] = GetScrollerValue( gptr, wp );
                  break;
                        
               case SLIDER_KIND:
                  rval->inst_var[VAL_FIELD] = GetSliderValue( gptr, wp );
                  break;

               default:
                  break;
               }
            }

            checking = FALSE; 
            break;

         case IDCMP_MENUPICK:
            if (MENUNUM( HanMsg.Code ) != MENUNULL)
               {
               struct MenuItem *n  = (struct MenuItem *) NULL;
               OBJECT          *ud = o_nil;
               
               rval = o_IDCMP_rval;
               
               rval->inst_var[TYPE_FIELD] = o_nil; // AssignObj( o_nil );
               rval->inst_var[ID_FIELD]   = AssignObj( new_str( FindMenuString( HanMsg.Code,wp)));
               rval->inst_var[VAL_FIELD]  = rval->inst_var[ID_FIELD]; // Not really necessary

               n = ItemAddress( wp->MenuStrip, HanMsg.Code );
    
               if (n) // != NULL)
                  {
                  ud = (OBJECT *) GTMENUITEM_USERDATA( n );
                  
                  ud = ud->inst_var[SYM_FIELD];
                  }

               rval->inst_var[SYM_FIELD] = AssignObj( ud );        // #Symbol
               rval->inst_var[KEY_FIELD] = AssignObj( new_char( n->Command )); // hotKey
                  
               checking = FALSE;
               } 

            break;

         case IDCMP_RAWKEY:
            checking          = FALSE;
            rval              = o_IDCMP_rval;
            
            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_RKEY ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( HanMsg.Code & 0xFFFF ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "rawKey" ) );
            rval->inst_var[KEY_FIELD]  = makeRawKey( &HanMsg );
            rval->inst_var[VAL_FIELD]  = makeRawKey( &HanMsg );

            break;

         case IDCMP_CLOSEWINDOW: // user has to explicitly Close the window!  
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_SGAD ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_CLOW ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "closeWindow" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;

         case IDCMP_MOUSEBUTTONS:
         case IDCMP_MOUSEMOVE:
            break;

/*
         case IDCMP_CHANGEWINDOW:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_SGAD ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_CHGW ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "changeWindow" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;

         case IDCMP_NEWSIZE:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_SGAD ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_SIZW ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "newSizeWindow" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;

         case IDCMP_SIZEVERIFY:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_VERI ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_SVER ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "sizeVerify" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;
            
         case IDCMP_MOUSEBUTTONS:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_MOUS ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_MBUT ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "mouseButtons" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
            break;

         case IDCMP_MOUSEMOVE:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_MOUS ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_MMOV ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "mouseMove" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
            break;

         case IDCMP_REQSET:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_REQU ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_RSET ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "reqSet" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;
            
         case IDCMP_REQVERIFY:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_VERI ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_RVER ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "reqVerify" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;
            
         case IDCMP_REQCLEAR:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_REQU ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_RCLR ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "reqClear" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;
            
         case IDCMP_MENUVERIFY:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_VERI ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_MVER ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "menuVerify" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;
            
         case IDCMP_NEWPREFS:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_PREF ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_NEWP ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "newPrefs" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;
            
         case IDCMP_DISKINSERTED:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_DISK ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_DINS ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "diskInserted" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;
            
         case IDCMP_DISKREMOVED:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_DISK ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_DREM ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "diskRemoved" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;
            
         case IDCMP_ACTIVEWINDOW:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_WIND ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_ACTW ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "activeWindow" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;
            
         case IDCMP_INACTIVEWINDOW:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_WIND ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_INAW ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "inactiveWindow" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = o_nil;
            
            break;

         case IDCMP_INTUITICKS:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_TIMR ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_ITCK ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "intuiTicks" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
            break;

         case IDCMP_IDCMPUPDATE:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_WIND ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_UPDT ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "idcmpUpdate" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
            break;
            
         case IDCMP_MENUHELP:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_HELP ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_MHLP ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "menuHelp" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
            break;
            
         case IDCMP_GADGETHELP:
            checking          = FALSE;
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_HELP ));
            rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_GHLP ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "gadgetHelp" ) );
            rval->inst_var[KEY_FIELD]  = o_nil;
            rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
            break;
*/
         default:             
            break;
         }
      }                // End of while Loop!!

   return( rval );
}

/****h* getMessageClass() [2.0] ****************************************
*
* NAME
*    getMessageClass()
*
* DESCRIPTION
*    Return the Class field of an IntuiMessage Object.
*    <primitive 239 3 10 intuiMsgObject>
************************************************************************
*
*/

METHODFUNC OBJECT *getMessageClass( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj ); 
   OBJECT              *rval = o_nil;

   if (!imsg) // == NULL)
      return( rval );
      
   return( AssignObj( new_int( (int) imsg->Class ) ) );
}

/****h* getMessageCode() [2.0] *****************************************
*
* NAME
*    getMessageCode()
*
* DESCRIPTION
*    Return the Code field of an IntuiMessage Object.
*    <primitive 239 3 11 intuiMsgObject>
************************************************************************
*
*/

METHODFUNC OBJECT *getMessageCode( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj ); 
   OBJECT              *rval = o_nil;

   if (!imsg) // == NULL)
      return( rval );
      
   return( AssignObj( new_int( (int) imsg->Code ) ) );
}

/****h* getMessageQualifier() [2.0] ************************************
*
* NAME
*    getMessageQualifier()
*
* DESCRIPTION
*    Return the Qualifier field of an IntuiMessage Object.
*    <primitive 239 3 12 intuiMsgObject>
************************************************************************
*
*/

METHODFUNC OBJECT *getMessageQualifier( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj ); 
   OBJECT              *rval = o_nil;

   if (!imsg) // ==NULL))
      return( rval );
      
   return( AssignObj( new_int( (int) imsg->Qualifier ) ) );
}

/****h* getMessageIAddress() [2.0] *************************************
*
* NAME
*    getMessageIAddress()
*
* DESCRIPTION
*    Return the IAddress field of an IntuiMessage Object.
*    <primitive 239 3 13 intuiMsgObject>
************************************************************************
*
*/

METHODFUNC OBJECT *getMessageIAddress( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj ); 
   OBJECT              *rval = o_nil;

   if (!imsg) // ==NULL))
      return( rval );

   switch (imsg->Class)
      {      
      case IDCMP_GADGETDOWN:
      case IDCMP_GADGETUP:
      case IDCMP_RAWKEY:
      case IDCMP_IDCMPUPDATE:
      case IDCMP_MOUSEMOVE:
         return( AssignObj( new_address( (ULONG) imsg->IAddress ) ) );
      
      default:
         return( rval );
      }
}

/****h* getMessageMouseX() [2.0] ***************************************
*
* NAME
*    getMessageMouseX()
*
* DESCRIPTION
*    Return the MouseX field of an IntuiMessage Object.
*    <primitive 239 3 14 intuiMsgObject>
************************************************************************
*
*/

METHODFUNC OBJECT *getMessageMouseX( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj ); 
   OBJECT              *rval = o_nil;

   if (!imsg) // ==NULL))
      return( rval );
      
   return( AssignObj( new_int( (int) imsg->MouseX ) ) );
}

/****h* getMessageMouseY() [2.0] ***************************************
*
* NAME
*    getMessageMouseY()
*
* DESCRIPTION
*    Return the MouseY field of an IntuiMessage Object.
*    <primitive 239 3 15 intuiMsgObject>
************************************************************************
*
*/

METHODFUNC OBJECT *getMessageMouseY( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj ); 
   OBJECT              *rval = o_nil;

   if (!imsg) // ==NULL))
      return( rval );
      
   return( AssignObj( new_int( (int) imsg->MouseY ) ) );
}

/****h* getMessageSeconds() [2.0] **************************************
*
* NAME
*    getMessageSeconds()
*
* DESCRIPTION
*    Return the Seconds field of an IntuiMessage Object.
*    <primitive 239 3 16 intuiMsgObject>
************************************************************************
*
*/

METHODFUNC OBJECT *getMessageSeconds( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj ); 
   OBJECT              *rval = o_nil;

   if (!imsg) // ==NULL))
      return( rval );
      
   return( AssignObj( new_int( (int) imsg->Seconds ) ) );
}

/****h* getMessageMicros() [2.0] ***************************************
*
* NAME
*    getMessageMicros()
*
* DESCRIPTION
*    Return the Micros field of an IntuiMessage Object.
*    <primitive 239 3 17 intuiMsgObject>
************************************************************************
*
*/

METHODFUNC OBJECT *getMessageMicros( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj ); 
   OBJECT              *rval = o_nil;

   if (!imsg) // ==NULL))
      return( rval );
      
   return( AssignObj( new_int( (int) imsg->Micros ) ) );
}

/****h* getGadgetType() [2.0] ******************************************
*
* NAME
*    getGadgetType()
*
* DESCRIPTION
*    Return the GadgetType field of an IAddress (imsgObj) Object.
*    <primitive 239 3 18 intuiMsgObject>
************************************************************************
*
*/

METHODFUNC OBJECT *getGadgetType( OBJECT *imsgObj )
{
   struct IntuiMessage *imsg = (struct IntuiMessage *) CheckObject( imsgObj ); 
   OBJECT              *rval = o_nil;

   if (!imsg) // ==NULL))
      return( rval );
      
   return( AssignObj( new_int( (int) ((struct Gadget *) imsg->IAddress)->GadgetType )));
}

/****i* CheckGT_IDCMP() [3.0] ****************************************
*
* NAME
*    CheckGT_IDCMP()
*
* DESCRIPTION
*    This function differs from HandleGT_IDCMP() in that it does NOT
*    wait for an IDCMP event.  o_nil is returned if there is no
*    IDCMP event to decode.
*
* NOTES
*    Smalltalk code has to call this <primitive 239 3 19 winObj>
*    inside a loop if there is more than one IDCMP event expected.
*    rval <- gadTools handleGTIDCMP: winObj.  This function returns
*    an Array OBJECT with five elements:
*
*       ele[0] <- Gadget or Menu Type
*       ele[1] <- Gadget ID or Menu Label
*       ele[2] <- Gadget or Menu UserData
*       ele[3] <- HotKey
*       ele[4] <- Gadget Value
*
*    ^ <primitive 239 3 19 winObj>
**********************************************************************
*
*/

PRIVATE struct IntuiMessage ChkMsg = { 0, };
    
METHODFUNC OBJECT *CheckGT_IDCMP( OBJECT *winObj )
{
   IMPORT OBJECT *o_IDCMP_rval; // In Global.c, setup in Main.c
   
   struct Window       *wp   = (struct Window *) CheckObject( winObj ); 
   struct Gadget       *gptr = (struct Gadget *) NULL;
   struct IntuiMessage *message, *mptr = &ChkMsg;

   OBJECT              *rval = o_nil;

   if (!wp) // == NULL)
      return( rval );

   if (!(message = GT_GetIMsg( wp->UserPort ))) // == NULL)
      return( rval );

   CopyMem( (char *) message, (char *) &ChkMsg, 
            (long) sizeof( struct IntuiMessage )
          );

   (void) GT_ReplyIMsg( message );

   switch (ChkMsg.Class)
      {
      case IDCMP_REFRESHWINDOW:
         GT_BeginRefresh( wp );
         GT_EndRefresh( wp, TRUE );
         break;

      case IDCMP_VANILLAKEY:
         /* Search the GadTools & MenuItems for the first HotKey that
         ** corresponds to Msg.Code & Msg.Qualifier:
         */
         {
         int     type  = 0;
         OBJECT *udObj = findHotKey( wp, &ChkMsg, &type );
         int    *udata = NULL;
            
         rval = o_IDCMP_rval;

         if (NullChk( udObj ) == TRUE) // This is NOT an assigned hotkey!
            {
            rval              = o_IDCMP_rval;

            rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_VKEY ));
            rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "vanillaKey" ) );
            rval->inst_var[KEY_FIELD]  = AssignObj( new_char( ChkMsg.Code ));
            rval->inst_var[ID_FIELD]   = rval->inst_var[KEY_FIELD];
            rval->inst_var[VAL_FIELD]  = o_nil;
               
            break;
            }
         else
            udata = (int *) int_value( udObj );

         switch (type)
            {
            case 0:   // o_nil
               break; 
                  
            case 1:   // Gadget
               gptr = findGadgetByKey( wp, &ChkMsg );

               rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) udata[TYPE_FIELD] ));
               rval->inst_var[ID_FIELD]   = AssignObj( new_int( gptr->GadgetID & 0xFFFF ));
               rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) udata[SYM_FIELD] );
               rval->inst_var[KEY_FIELD]  = AssignObj( new_char( udata[KEY_FIELD] & 0xFF ));
                               
               switch (udata[TYPE_FIELD]) // udata[TYPE_FIELD] == Gadget Type
                  {
                  case BUTTON_KIND:
                     rval->inst_var[VAL_FIELD] = GetButtonValue( gptr, wp );
                     break;
                        
                  case CHECKBOX_KIND:
                     rval->inst_var[VAL_FIELD] = GetChkBoxValue( gptr, wp );
                     break;
                        
                  case INTEGER_KIND:
                     rval->inst_var[VAL_FIELD] = GetIntegerValue( gptr, wp );
                     break;
                        
                  case LISTVIEW_KIND:
                     rval->inst_var[VAL_FIELD] = GetListViewValue( gptr, wp );
                     break;
                        
                  case CYCLE_KIND:
                     rval->inst_var[VAL_FIELD] = GetCycleValue( gptr, wp );
                     break;
                        
                  case PALETTE_KIND:
                     rval->inst_var[VAL_FIELD] = GetPaletteValue( gptr, wp );
                     break;
                        
                  case SCROLLER_KIND:
                     rval->inst_var[VAL_FIELD] = GetScrollerValueByKey( gptr, wp );
                     break;
                        
                  case SLIDER_KIND:
                     rval->inst_var[VAL_FIELD] = GetSliderValueByKey( gptr, wp );
                     break;
                        
                  case STRING_KIND:
                     rval->inst_var[VAL_FIELD] = GetStringValue( gptr, wp );
                     break;
                  
                  default:
                     break;
                  }

               break;
                  
            case 2: // Menu Item
               {
               struct MenuItem *n  = (struct MenuItem *) NULL;
               OBJECT          *ud = o_nil;

               rval->inst_var[TYPE_FIELD] = o_nil;
               rval->inst_var[ID_FIELD]   = AssignObj( new_str( FindMenuString( ChkMsg.Code, wp )));
               rval->inst_var[VAL_FIELD]  = rval->inst_var[ID_FIELD];
                  
               n = ItemAddress( wp->MenuStrip, ChkMsg.Code );
    
               if (n) // != NULL)
                  {
                  ud = (OBJECT *) GTMENUITEM_USERDATA( n );
                  
                  ud = ud->inst_var[SYM_FIELD];
                  }

               rval->inst_var[SYM_FIELD] = AssignObj( ud );
               rval->inst_var[KEY_FIELD] = AssignObj( new_char( n->Command ));
                  
               break;
               }
            }
         }

         break;
                        
      case IDCMP_GADGETUP:
         {
         ULONG *udata = (ULONG *) ((struct Gadget *) ChkMsg.IAddress)->UserData;

         gptr = (struct Gadget *) ChkMsg.IAddress;

         rval = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) udata[TYPE_FIELD] )); // Gadget Type
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) udata[ID_FIELD] ));   // GadgetID
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) udata[SYM_FIELD] );  // #Symbol 
         rval->inst_var[KEY_FIELD]  = AssignObj( new_char( udata[KEY_FIELD] & 0xFF )); // hotKey
             
         switch (udata[TYPE_FIELD])
            {
            case BUTTON_KIND:
               rval->inst_var[VAL_FIELD] = GetButtonValue( gptr, wp );
               break;
                        
            case CHECKBOX_KIND:
               rval->inst_var[VAL_FIELD] = GetChkBoxValue( gptr, wp );
               break;
                        
            case INTEGER_KIND:
               rval->inst_var[VAL_FIELD] = GetIntegerValue( gptr, wp );
               break;
                        
            case LISTVIEW_KIND:
               rval->inst_var[VAL_FIELD] = GetListViewValue( gptr, wp );
               break;
                        
            case CYCLE_KIND:
               rval->inst_var[VAL_FIELD] = GetCycleValue( gptr, wp );
               break;
                        
            case PALETTE_KIND:
               rval->inst_var[VAL_FIELD] = GetPaletteValue( gptr, wp );
               break;
                        
            case SCROLLER_KIND:
               rval->inst_var[VAL_FIELD] = GetScrollerValue( gptr, wp );
               break;
                        
            case SLIDER_KIND:
               rval->inst_var[VAL_FIELD] = GetSliderValue( gptr, wp );
               break;
                        
            case STRING_KIND:
               rval->inst_var[VAL_FIELD] = GetStringValue( gptr, wp );
               break;
                  
            default:
               break;
            }
         }

         break;

      case IDCMP_GADGETDOWN:
         {
         ULONG *udata = (ULONG *) ((struct Gadget *) ChkMsg.IAddress)->UserData;

         gptr = (struct Gadget *) ChkMsg.IAddress;

         rval = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) udata[TYPE_FIELD] )); // Gadget Type
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) udata[ID_FIELD] )); // GadgetID
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) udata[SYM_FIELD] );  // #Symbol 
         rval->inst_var[KEY_FIELD]  = AssignObj( new_char( udata[KEY_FIELD] & 0xFF )); // hotKey

         switch (udata[TYPE_FIELD]) // gadget Type
            {
            case GENERIC_KIND:     // Should never happen.
               rval->inst_var[VAL_FIELD] = GetGenericValue( gptr, wp );
               break;
                        
            case BUTTON_KIND:      // ARROWIDCMP is a button also.
               rval->inst_var[VAL_FIELD] = GetButtonValue( gptr, wp );
               break;
                        
            case LISTVIEW_KIND:
               rval->inst_var[VAL_FIELD] = GetListViewValue( gptr, wp );
               break;
                        
            case MX_KIND:
               rval->inst_var[VAL_FIELD] = GetRadioValue( gptr, wp );
               break;
                        
            case SCROLLER_KIND:
               rval->inst_var[VAL_FIELD] = GetScrollerValue( gptr, wp );
               break;
                        
            case SLIDER_KIND:
               rval->inst_var[VAL_FIELD] = GetSliderValue( gptr, wp );
               break;

            default:
               break;
            }
         }

         break;

      case IDCMP_MENUPICK:
         if (MENUNUM( ChkMsg.Code ) != MENUNULL)
            {
            struct MenuItem *n  = (struct MenuItem *) NULL;
            OBJECT          *ud = o_nil;
               
            rval = o_IDCMP_rval;
               
            rval->inst_var[TYPE_FIELD] = o_nil;
            rval->inst_var[ID_FIELD]   = AssignObj( new_str( FindMenuString( ChkMsg.Code, wp )));
            rval->inst_var[VAL_FIELD]  = rval->inst_var[ID_FIELD]; // Not really necessary

            n = ItemAddress( wp->MenuStrip, ChkMsg.Code );
    
            if (n) // != NULL)
               {
               ud = (OBJECT *) GTMENUITEM_USERDATA( n );
               
               ud = ud->inst_var[SYM_FIELD];
               }

            rval->inst_var[SYM_FIELD] = AssignObj( ud );        // #Symbol
            rval->inst_var[KEY_FIELD] = AssignObj( new_char( n->Command )); // hotKey
            } 

         break;

      case IDCMP_RAWKEY:
         rval = o_IDCMP_rval;
            
         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_RKEY ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( ChkMsg.Code & 0xFFFF ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "rawKey" ) );
         rval->inst_var[KEY_FIELD]  = makeRawKey( &ChkMsg );
         rval->inst_var[VAL_FIELD]  = makeRawKey( &ChkMsg );

         break;

      case IDCMP_CLOSEWINDOW: // user has to explicitly Close the window!  
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_SGAD ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_CLOW ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "closeWindow" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;

      case IDCMP_MOUSEBUTTONS:
      case IDCMP_MOUSEMOVE:
         break;

/*
      case IDCMP_CHANGEWINDOW:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_SGAD ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_CHGW ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "changeWindow" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;

      case IDCMP_NEWSIZE:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_SGAD ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_SIZW ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "newSizeWindow" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;

      case IDCMP_SIZEVERIFY:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_VERI ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_SVER ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "sizeVerify" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;
            
      case IDCMP_MOUSEBUTTONS:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_MOUS ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_MBUT ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "mouseButtons" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
         break;
            
      case IDCMP_MOUSEMOVE:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_MOUS ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_MMOV ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "mouseMove" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
         break;
            
      case IDCMP_REQSET:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_REQU ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_RSET ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "reqSet" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;
            
      case IDCMP_REQVERIFY:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_VERI ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_RVER ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "reqVerify" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;
            
      case IDCMP_REQCLEAR:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_REQU ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_RCLR ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "reqClear" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;
            
      case IDCMP_MENUVERIFY:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_VERI ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_MVER ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "menuVerify" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;
            
      case IDCMP_NEWPREFS:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_PREF ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_NEWP ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "newPrefs" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;
            
      case IDCMP_DISKINSERTED:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_DISK ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_DINS ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "diskInserted" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;
            
      case IDCMP_DISKREMOVED:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_DISK ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_DREM ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "diskRemoved" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;
            
      case IDCMP_ACTIVEWINDOW:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_WIND ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_ACTW ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "activeWindow" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;
            
      case IDCMP_INACTIVEWINDOW:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_WIND ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_INAW ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "inactiveWindow" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = o_nil;
            
         break;

      case IDCMP_INTUITICKS:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_TIMR ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_ITCK ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "intuiTicks" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
         break;

      case IDCMP_IDCMPUPDATE:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_WIND ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_UPDT ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "idcmpUpdate" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
         break;
            
      case IDCMP_MENUHELP:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_HELP ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_MHLP ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "menuHelp" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
         break;
            
      case IDCMP_GADGETHELP:
         rval              = o_IDCMP_rval;

         rval->inst_var[TYPE_FIELD] = AssignObj( new_int( (int) ID_HELP ));
         rval->inst_var[ID_FIELD]   = AssignObj( new_int( (int) ID_GHLP ));
         rval->inst_var[SYM_FIELD]  = AssignObj( (OBJECT *) new_sym( "gadgetHelp" ) );
         rval->inst_var[KEY_FIELD]  = o_nil;
         rval->inst_var[VAL_FIELD]  = AssignObj( new_int( (int) mptr ) );
            
         break;
*/
      default:             
         break;
      }

   return( rval );
}


/****h* HandleMisc() [2.0] *********************************************
*
* NAME
*    HandleMisc()
*
* DESCRIPTION
*    Take care of calls to unusual GadTools library calls.
*    <primitive 239 3 0-19 parms>
************************************************************************
*
*/

METHODFUNC OBJECT *HandleMisc( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 239 );
      return( rval );
      }

   switch (int_value( args[0] ))
      {
      case 0: // freeVisualInfo: viObj
         if (NullChk( args[1] ) == FALSE)
            {
            freeVisualInfo( args[1] );
            }

         break;

      case 1: // <239 3 1 scrObj tagArray> getVisualInfo: scrObj tags: tagArray
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 239 );
         else
            rval = getVisualInfo( args[1], args[2] );
         
         break;

      case 2: // <239 3 2 winObj> beginRefresh: winObj
         beginRefresh( args[1] );

         break;

      case 3: // <239 3 3 winObj flag> endRefresh: winObj flag: completeFlag
         {
         BOOL completeFlag = FALSE;
         
         if (args[2] == o_true)
            completeFlag = TRUE;

         endRefresh( args[1], completeFlag );
         }
   
         break;

      case 4: // <239 3 4 winObj> ^ imsgObj <- getIMsg: winObj
         rval = getIMsg( args[1] );
         
         break;

      case 5: // <239 3 5 imsgObj> replyIMsg: imsgObj
         replyIMsg( args[1] );
         
         break;

      case 6: // <239 3 6 winObj> refreshWindow: winObj
         refreshWindow( args[1] );
         
         break;

      case 7: // <239 3 7 imsgObj> ^ imsgObj <- postFilterIMsg: imsgObj
         rval = postFilterIMsg( args[1] );
         
         break;

      case 8: // <239 3 8 imsgObj> ^ imsgObj <- filterIMsg: imsgObj
         rval = filterIMsg( args[1] );
         
         break;

      case 9: // handleGTIDCMP: winObj
      
         rval = HandleGT_IDCMP( args[1] );
         break;
         
      case 10: // getMessageClass: intuiMsgObject
      
         rval = getMessageClass( args[1] );
         break;
         
      case 11: // getMessageCode: intuiMsgObject
      
         rval = getMessageCode( args[1] );
         break;
         
      case 12: // getMessageQualifier: intuiMsgObject
      
         rval = getMessageQualifier( args[1] );
         break;

      case 13: // getMessageIAddress: intuiMsgObject
         rval = getMessageIAddress( args[1]  );
         break;
      
      case 14: // getMessageMouseX: intuiMsgObject
         rval = getMessageMouseX( args[1] );
         break;

      case 15: // getMessageMouseY: intuiMsgObject
         rval = getMessageMouseY( args[1] );
         break;

      case 16: // getMessageSeconds: intuiMsgObject
         rval = getMessageSeconds( args[1] );
         break;

      case 17: // getMessageMicros: intuiMsgObject
         rval = getMessageMicros( args[1] );
         break;

      case 18: // getGadgetType: intuiMsgObject
         rval =  getGadgetType( args[1] );
         break;

      case 19: // checkGTIDCMP: winObj
      
         rval = HandleGT_IDCMP( args[1] );
         break;
         
      default:
         break;
      }
      
   return( rval );
}

/****h* HandleGadTools() [2.0] *****************************************
*
* NAME
*    HandleGadTools()
*
* DESCRIPTION
*    The function that the Primitive handler calls for GadTools.library
*    stuff. <primitive 239 0-3 xx parms>
************************************************************************
*
*/

PUBLIC OBJECT *HandleGadTools(  int numargs, OBJECT **args )
{
   IMPORT struct Library *GadToolsBase;
   
   OBJECT *rval = o_nil;
   BOOL   libOpened = FALSE;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 239 );

      return( rval );
      }

   if (numargs < 2)
      {
      IMPORT char *errp;
      
      StringCopy( errp, GToolCMsg( MSG_GT_WRONG_ARGS_GTOOL ) );

      return( ReturnError() );
      }

   if (!GadToolsBase)
      {
#     ifdef  __SASC
      GadToolsBase = OpenLibrary( "gadtools.library", 39L );
      
      if (GadToolsBase) // != NULL)
         libOpened = TRUE;
      else
         cant_happen( ERR_LIBRARY_NOT_OPENED );
#     else
      if ((GadToolsBase = OpenLibrary( "gadtools.library", 50L )))
         {
	 if (!(IGadTools = (struct GadToolsIFace *) GetInterface( GadToolsBase, "main", 1, NULL )))
	    {
            CloseLibrary( GadToolsBase );
	    GadToolsBase = NULL;
	    cant_happen( ERR_LIBRARY_NOT_OPENED );
	    }
	 else
	    libOpened = TRUE;
	 }
      else
         cant_happen( ERR_LIBRARY_NOT_OPENED );
#     endif
      }
            
   switch (int_value( args[0] ))
      {
      case 0:
         rval = HandleNGadgets( numargs - 1, &args[1] );
         break;
      
      case 1: 
         rval = HandleNewMenus( numargs - 1, &args[1] );
         break;
         
      case 2: // drawBox: winObj from: sPoint to: ePoint tags: tagArray
         drawBevelBox( args[1], int_value( args[2] ),
                                int_value( args[3] ),
                                int_value( args[4] ),
                                int_value( args[5] ),
                       args[6] // tagArray
                     );
         break;
         
      case 3: 
         rval = HandleMisc( numargs - 1, &args[1] );
         break;
      
      default:
         break;
      }
   
   if (libOpened == TRUE)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IGadTools );
#     endif

      CloseLibrary( GadToolsBase );

      libOpened = FALSE;
      }   

   return( rval );
}

/* -------------------------- END of GadTools.c file! ------------------------ */
