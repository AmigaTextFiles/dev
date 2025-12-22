/****h* AmigaTalk/Utility.c [3.0] *************************************
*
* NAME 
*   Utility.c
*
* DESCRIPTION
*   Functions that handle Utility.library to AmigaTalk primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleUtility( int numargs, OBJECT **args ); <209 3>
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    19-Feb-2002 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/Utility.c 3.0 (25-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>

#include <AmigaDOSErrs.h>

#ifdef __SASC

# include <clib/intuition_protos.h>
# include <clib/utility_protos.h>

#else

# define __USE_INLINE__

# include <proto/intuition.h>
# include <proto/utility.h>

IMPORT struct Library      *UtilityBase;
IMPORT struct UtilityIFace *IUtility;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// See Global.c for these: --------------------------------------------

IMPORT UBYTE *ErrMsg;

// See asmUtilLib.asm for these: --------------------------------------

#ifdef   __SASC
IMPORT __asm ULONG asmUnsigned32BitDivide( register __d0 ULONG, register __d1 ULONG );
IMPORT __asm LONG  asmSigned32BitDivide(   register __d0 LONG,  register __d1 LONG  );

IMPORT __asm ULONG asmUnsigned64BitMult( register __d0 ULONG, register __d1 ULONG );
IMPORT __asm LONG  asmSigned64BitMult(   register __d0 LONG,  register __d1 LONG  );

PUBLIC ULONG Quotient    = 0L; // asmUtilLib.asm has to use these!
PUBLIC ULONG Remainder   = 0L;
PUBLIC ULONG Lower32Bits = 0L;
PUBLIC ULONG Upper32Bits = 0L;
#endif

/****i* getTagData() [2.0] ********************************************
*
* NAME
*    getTagData()
*
* DESCRIPTION
*    ^ tagData<- <primitive 209 3 0 tagValue defaultValue tagListObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *getTagData( Tag tagValue, ULONG defaultVal, OBJECT *tagListObj )
{
   struct TagItem *tags = (struct TagItem *) CheckObject( tagListObj );
   OBJECT         *rval = o_nil;
   ULONG           valu = 0L;
   
   if (!tags) // == NULL)
      return( rval ); // No point in searching in a VOID!
         
   valu = GetTagData( tagValue, defaultVal, tags );
   rval = AssignObj( new_int( (int) valu ) );
   
   return( rval );
}

/****i* allocateTagItems() [2.0] **************************************
*
* NAME
*    allocateTagItems()
*
* DESCRIPTION
*    ^ tagListObject <- <primitive 209 3 1 howMany>
*
* NOTES
*    Note that to access the TagItems in 'tagList', you should use
*    the function NextTagItem(). This will insure you respect any
*    chaining (TAG_MORE) and secret hiding places (TAG_IGNORE) that
*    this function might generate.
*
*    An allocated tag list must eventually be freed using FreeTagItems().
***********************************************************************
*
*/

METHODFUNC OBJECT *allocateTagItems( ULONG howMany )
{
   OBJECT *rval = o_nil;
   
   if (howMany < 1)
      return( rval );

   rval = AssignObj( new_address( (ULONG) AllocateTagItems( howMany ) ) );

   return( rval );
}

/****i* findTagItem() [2.0] *******************************************
*
* NAME
*    findTagItem()
*
* DESCRIPTION
*    Returns a pointer to the item (ti_Tag == tagVal).
*    ^ tagItemObj <- <primitive 209 3 2 tagValue tagListObject>
***********************************************************************
*
*/

METHODFUNC OBJECT *findTagItem( Tag tagVal, OBJECT *tagListObj )
{
   struct TagItem *tags = (struct TagItem *) CheckObject( tagListObj );
   OBJECT         *rval = o_nil;

   if (tags) // != NULL)   
      rval = AssignObj( new_int( (int) FindTagItem( tagVal, tags ) ) );

   return( rval );
}

/****i* filterTagChanges() [2.0] **************************************
*
* NAME
*    filterTagChanges()
*
* DESCRIPTION
*    This function goes through changeList. For each item found in
*    changeList, if the item is also present in originalList, and their
*    data values are identical, then the tag is removed from changeList.
*    If the two tag's data values are different and the 'apply' value is
*    non-zero, then the tag data in originalList will be updated to match
*    the value from changeList.
*
*    ^ tagItemObj <- <primitive 209 3 3 chgTagObj orgTagObj boolApply>
***********************************************************************
*
*/

METHODFUNC void filterTagChanges( OBJECT *chgTagObj, OBJECT *orgTagObj, ULONG apply )
{
   struct TagItem *changes = (struct TagItem *) CheckObject( chgTagObj );
   struct TagItem *orgTags = (struct TagItem *) CheckObject( orgTagObj );
   BOOL            flag    = (apply != 0) ? TRUE : FALSE;

   FilterTagChanges( changes, orgTags, flag );
   
   return;
}

/****i* applyTagChanges() [2.0] ***************************************
*
* NAME
*    applyTagChanges()
*
* DESCRIPTION
*    <primitive 209 3 4 tagListObj changeTagsObject>
***********************************************************************
*
*/

METHODFUNC void applyTagChanges( OBJECT *tagListObj, OBJECT *chgTagObj )
{
   struct TagItem *changes = (struct TagItem *) CheckObject( chgTagObj  );
   struct TagItem *tags    = (struct TagItem *) CheckObject( tagListObj );

   if (!tags || !changes) // == NULL)
      return;
      
   ApplyTagChanges( tags, changes );

   return;
}

/****i* cloneTagItems() [2.0] *****************************************
*
* NAME
*    cloneTagItems()
*
* DESCRIPTION
*    <primitive 209 3 5 tagListObj>
*
* WARNING
*    The returned tag list must eventually by freed by calling FreeTagItems().
***********************************************************************
*
*/

METHODFUNC OBJECT *cloneTagItems( OBJECT *tagListObj )
{
   struct TagItem *tags = (struct TagItem *) CheckObject( tagListObj );
   OBJECT         *rval = o_nil;
   
   if (!tags) // == NULL)
      return( rval );
      
   return( AssignObj( new_address( (ULONG) CloneTagItems( tags ) ) ) );
}

/****i* filterTagItems() [2.0] ****************************************
*
* NAME
*    filterTagItems()
*
* DESCRIPTION
*    ^ <primitive 209 3 6 tagListObj tagFilterObj logicTypeFlag>
***********************************************************************
*
*/

METHODFUNC OBJECT *filterTagItems( OBJECT *tagListObj, 
                                   OBJECT *tagFiltObj, 
                                   ULONG   logicType 
                                 )
{
   struct TagItem *tags  = (struct TagItem *) CheckObject( tagListObj );
   Tag            *ftags = (Tag            *) CheckObject( tagFiltObj );

   return( AssignObj( new_address( (ULONG) FilterTagItems( tags, ftags, logicType ))));
}

/****i* freeTagItems() [2.0] ******************************************
*
* NAME
*    freeTagItems()
*
* DESCRIPTION
*    <primitive 209 3 7 tagListObj>
***********************************************************************
*
*/

METHODFUNC void freeTagItems( OBJECT *tagListObj )
{
   // tagListObj can be NULL with no problems:
   FreeTagItems( (struct TagItem *) CheckObject( tagListObj ) );

   return;
}

/****i* mapTags() [2.0] ***********************************************
*
* NAME
*    mapTags()
*
* DESCRIPTION
*    <primitive 209 3 8 tagListObj mapTagObj mapType>
***********************************************************************
*
*/

METHODFUNC void mapTags( OBJECT *tagListObj, OBJECT *mapTagObj, ULONG mapType )
{
   struct TagItem *tags  = (struct TagItem *) CheckObject( tagListObj );
   struct TagItem *mtags = (struct TagItem *) CheckObject( mapTagObj  );

   MapTags( tags, mtags, mapType );

   return;
}

/****i* nextTagItem() [2.0] *******************************************
*
* NAME
*    nextTagItem()
*
* DESCRIPTION
*    ^ tagItemObj <primitive 209 3 9 tagListObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *nextTagItem( OBJECT *tagListObj )
{
   struct TagItem *tags = (struct TagItem *) CheckObject( tagListObj );
   OBJECT         *rval = o_nil;
   
   if (!tags) // == NULL)
      return( rval );
      
   rval = AssignObj( new_int( (int) NextTagItem( &tags ) ) );
   
   return( rval );
}

/****i* packBoolTags() [2.0] ******************************************
*
* NAME
*    packBoolTags()
*
* DESCRIPTION
*    ^ <primitive 209 3 10 iFlags tagListObj boolTagObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *packBoolTags( ULONG iFlags, OBJECT *tagListObj, OBJECT *boolTagObj )
{
   struct TagItem *tags  = (struct TagItem *) CheckObject( tagListObj );
   struct TagItem *btags = (struct TagItem *) CheckObject( boolTagObj );

   return( AssignObj( new_address( (ULONG) PackBoolTags( iFlags, tags, btags )))); 
}

/****i* refreshTagItemClones() [2.0] **********************************
*
* NAME
*    refreshTagItemClones()
*
* DESCRIPTION
*    <primitive 209 3 11 cloneTagListObj tagListObj>
***********************************************************************
*
*/

METHODFUNC void refreshTagItemClones( OBJECT *clonTagObj, OBJECT *tagListObj )
{
   struct TagItem *tags  = (struct TagItem *) CheckObject( tagListObj );
   struct TagItem *ctags = (struct TagItem *) CheckObject( clonTagObj );

   RefreshTagItemClones( ctags, tags );
   
   return;
}

/****i* tagInArray() [2.0] ********************************************
*
* NAME
*    tagInArray()
*
* DESCRIPTION
*    ^ boolean <- <primitive 209 3 12 tagValue tagArrayObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *tagInArray( Tag tagValue, OBJECT *tagArrayObj )
{
   Tag *tagArray = (Tag *) CheckObject( tagArrayObj );

   if (!tagArray) // == NULL)
      return( o_false );
      
   if (TagInArray( tagValue, tagArray ) != TRUE)
      return( o_false );
   else
      return( o_true );
}

/****i* packStructureTags() [2.0] *************************************
*
* NAME
*    packStructureTags()
*
* DESCRIPTION
*    ^ <primitive 209 3 13 packArea packTable tagListObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *packStructureTags( OBJECT *packArea, 
                                      ULONG  *packTable, 
                                      OBJECT *tagListObj 
                                    )
{
   struct TagItem *tags = (struct TagItem *) CheckObject( tagListObj );
   APTR            pack =             (APTR) CheckObject( packArea   );
   
   if (!pack || !packTable) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) PackStructureTags( pack, packTable, tags ))));
}

/****i* unpackStructureTags() [2.0] ***********************************
*
* NAME
*    unpackStructureTags()
*
* DESCRIPTION
*    ^ <primitive 209 3 14 packArea packTable tagListObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *unpackStructureTags( OBJECT *packArea, 
                                        ULONG  *packTable, 
                                        OBJECT *tagListObj 
                                      )
{
   struct TagItem *tags = (struct TagItem *) CheckObject( tagListObj );
   APTR            pack =             (APTR) CheckObject( packArea   );
   
   if (!pack || !packTable) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) UnpackStructureTags( pack, packTable, tags ))));
}

//---- Hook functions: ------------------------------------------------

#ifdef  __SASC
SUBFUNC ULONG __asm hookEntry( register __a0 struct Hook *h,
                               register __a2 void        *object,
                               register __a1 void        *msg  
                             )
{
   if (h) // != NULL)
      return( (h->h_SubEntry)( h, object, msg ) );
   else
      return( ~0L );
}
#else
SUBFUNC ULONG hookEntry( struct Hook *h, APTR object, APTR msg )
{
   if (h) // != NULL)
      return( (h->h_SubEntry)( h, object, msg ) );
   else
      return( ~0L );
}
#endif

SUBFUNC void initHook( struct Hook *h, ULONG (*func)(), void *data )
{
   if (h) // != NULL)
      {
#     ifdef  __SASC
      h->h_Entry    = (ULONG (*)()) hookEntry;
#     else
      h->h_Entry    = (ULONG (*)( struct Hook *, APTR, APTR )) hookEntry;
#     endif

      h->h_SubEntry = func;
      h->h_Data     = data;
      }
   else
      {
      }
      
   return;
}

/****i* callExtHook() [2.4] *******************************************
*
* NAME
*    callExtHook()
*
* DESCRIPTION
*    ^ <primitive 209 3 15 self hookFileName paramsObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *callExtHook( OBJECT *hookObj, char *hFileName, void *parms )
{
   struct Hook *hook = (struct Hook *) CheckObject( hookObj->inst_var[0] );
   void        *data = NULL;
   char         cmd[512] = { 0, };
   ULONG        rval     = 0L;
   
   if (!hook || !hFileName || StringLength( hFileName ) < 1)
      return( o_nil );
   
   data = (void *) addr_value( hookObj->inst_var[1] );

   sprintf( cmd, "%s %ld %ld", hFileName, data, parms );

   rval = System( cmd, TAG_DONE );
   
   return( new_int( rval ) );
}

/****i* setHookData() [2.4] *******************************************
*
* NAME
*    setHookData()
*
* DESCRIPTION
*    ^ data<- <primitive 209 3 40 self newData>
***********************************************************************
*
*/

METHODFUNC OBJECT *setHookData( OBJECT *hookObj, OBJECT *data )
{
   struct Hook *hook = (struct Hook *) int_value( hookObj->inst_var[0] );
   
   if (!hook || hook == (struct Hook *) o_nil)
      return( o_nil );
      
   hook->h_Data = (void *) addr_value( data ); 
   
   return( data );
}

/****i* disposeHook() [2.4] *******************************************
*
* NAME
*    disposeHook()
*
* DESCRIPTION
*    <primitive 209 3 41 private>
*    private was allocated via <primitive 209 0 1 364>
***********************************************************************
*
*/

METHODFUNC void disposeHook( OBJECT *hookObj )
{
   IMPORT void GMfreeMemory( OBJECT *memPtr );
   
   GMfreeMemory( hookObj ); // in GrabMem.c
   
   return;            
}         

// ---- Date functions: -----------------------------------------------

/****i* amiga2Date() [2.0] ********************************************
*
* NAME
*    amiga2Date()
*
* DESCRIPTION
*    <primitive 209 3 16 seconds clkDataObj>
***********************************************************************
*
*/

METHODFUNC void amiga2Date( ULONG seconds, OBJECT *clkDataObj )
{
   struct ClockData *result = (struct ClockData *) CheckObject( clkDataObj );

   if (!result) // == NULL)
      return;
      
   Amiga2Date( seconds, result );

   return;
}

/****i* date2Amiga() [2.0] ********************************************
*
* NAME
*    date2Amiga()
*
* DESCRIPTION
*    ^ <primitive 209 3 17 clkDataObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *date2Amiga( OBJECT *clkDataObj )
{
   struct ClockData *date = (struct ClockData *) CheckObject( clkDataObj );

   if (!date) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) Date2Amiga( date ) ) ) );
}

/****i* checkDate() [2.0] *********************************************
*
* NAME
*    checkDate()
*
* DESCRIPTION
*    ^ <primitive 209 3 18 clkDataObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *checkDate( OBJECT *clkDataObj )
{
   struct ClockData *date = (struct ClockData *) CheckObject( clkDataObj );

   if (!date) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) CheckDate( date ) ) ) );
}

#ifdef __SASC

// ---- 32 bit integer muliply functions: -----------------------------

/****i* signed32BitMult() [2.0] ***************************************
*
* NAME
*    signed32BitMult()
*
* DESCRIPTION
*    ^ <primitive 209 3 19 arg1 arg2>
***********************************************************************
*
*/

METHODFUNC OBJECT *signed32BitMult( LONG arg1, LONG arg2 )
{
   return( AssignObj( new_int( (int) SMult32( arg1, arg2 ) ) ) );
}

/****i* unsigned32BitMult() [2.0] *************************************
*
* NAME
*    unsigned32BitMult()
*
* DESCRIPTION
*    ^ <primitive 209 3 20 arg1 arg2>
***********************************************************************
*
*/

METHODFUNC OBJECT *unsigned32BitMult( ULONG arg1, ULONG arg2 )
{
   return( AssignObj( new_int( (int) UMult32( arg1, arg2 ) ) ) );
}

/****i* signed32BitDivision() [2.0] ***********************************
*
* NAME
*    signed32BitDivision()
*
* DESCRIPTION
*    This method returns a LongInteger instance.
*    ^ <primitive 209 3 21 dividend divisor>
***********************************************************************
*
*/

METHODFUNC OBJECT *signed32BitDivision( LONG dividend, LONG divisor )
{
   OBJECT *rval = o_nil;
   CLASS  *LInt = lookup_class( "LongInteger" );
   LONG    chk  = 0UL;
   
   if (divisor == 0L)
      return( rval );

   chk  = asmSigned32BitDivide( dividend, divisor );
   
   rval = AssignObj( new_obj( LInt, 2, FALSE ) );
   
   rval->inst_var[0] = AssignObj( new_int( (int) Quotient  ) );
   rval->inst_var[1] = AssignObj( new_int( (int) Remainder ) );
 
   return( rval );
}

/****i* unsigned32BitDivision() [2.0] *********************************
*
* NAME
*    unsigned32BitDivision()
*
* DESCRIPTION
*    This method returns a LongInteger instance.
*    ^ <primitive 209 3 22 dividend divisor>
***********************************************************************
*
*/

METHODFUNC OBJECT *unsigned32BitDivision( ULONG dividend, ULONG divisor )
{
   OBJECT *rval = o_nil;
   CLASS  *LInt = lookup_class( "LongInteger" );
   ULONG   chk  = 0UL;
   
   if (divisor == 0L)
      return( rval );

   chk  = asmUnsigned32BitDivide( dividend, divisor );
   
   rval = AssignObj( new_obj( LInt, 2, FALSE ) );
   
   rval->inst_var[0] = AssignObj( new_int( (int) Quotient  ) );
   rval->inst_var[1] = AssignObj( new_int( (int) Remainder ) );
 
   return( rval );
}

/* 64 bit integer muliply functions. The results are 64 bit quantities */
/* returned in D0 and D1 */

/****i* signed64BitMult() [2.0] ***************************************
*
* NAME
*    signed64BitMult()
*
* DESCRIPTION
*    This method returns a LongInteger instance.
*    ^ <primitive 209 3 23 arg1 arg2>
***********************************************************************
*
*/

METHODFUNC OBJECT *signed64BitMult( LONG arg1, LONG arg2 )
{
   OBJECT *rval = o_nil;
   CLASS  *LInt = lookup_class( "LongInteger" );
   LONG    chk  = asmSigned64BitMult( arg1, arg2 );
   
   rval = AssignObj( new_obj( LInt, 2, FALSE ) );
   
   rval->inst_var[0] = AssignObj( new_int( (int) Upper32Bits ) );
   rval->inst_var[1] = AssignObj( new_int( (int) Lower32Bits ) );
 
   return( rval );
}

/****i* unsigned64BitMult() [2.0] *************************************
*
* NAME
*    unsigned64BitMult()
*
* DESCRIPTION
*    This method returns a LongInteger instance.
*    ^ <primitive 209 3 24 arg1 arg2>
***********************************************************************
*
*/

METHODFUNC OBJECT *unsigned64BitMult( ULONG arg1, ULONG arg2 )
{
   OBJECT *rval = o_nil;
   CLASS  *LInt = lookup_class( "LongInteger" );
   ULONG   chk  = asmUnsigned64BitMult( arg1, arg2 );
   
   rval = AssignObj( new_obj( LInt, 2, FALSE ) );
   
   rval->inst_var[0] = AssignObj( new_int( (int) Upper32Bits ) );
   rval->inst_var[1] = AssignObj( new_int( (int) Lower32Bits ) );
 
   return( rval );
}
#endif // __amigaos4__

/* International string routines */

/****i* UTstringCompare() [2.0] ***************************************
*
* NAME
*    UTstringCompare()
*
* DESCRIPTION
*    ^ <primitive 209 3 25 string1 string2>
***********************************************************************
*
*/

METHODFUNC OBJECT *UTstringCompare( char *string1, char *string2 )
{
   return( AssignObj( new_int( (int) Stricmp( string1, string2 ))));
}

/****i* UTstringICompare() [2.0] **************************************
*
* NAME
*    UTstringICompare()
*
* DESCRIPTION
*    ^ <primitive 209 3 26 string1 string2 compLength>
***********************************************************************
*
*/

METHODFUNC OBJECT *UTstringICompare( char *string1, char *string2, LONG length )
{
   return( AssignObj( new_int( (int) Strnicmp( string1, string2, length ))));
}

/****i* UTtoUpper() [2.0] *********************************************
*
* NAME
*    UTtoUpper()
*
* DESCRIPTION
*    ^ <primitive 209 3 27 character>
***********************************************************************
*
*/

METHODFUNC OBJECT *UTtoUpper( ULONG character )
{
   return( AssignObj( new_char( ToUpper( character ) ) ) );
}

/****i* UTtoLower() [2.0] *********************************************
*
* NAME
*    UTtoLower()
*
* DESCRIPTION
*    ^ <primitive 209 3 28 character>
***********************************************************************
*
*/

METHODFUNC OBJECT *UTtoLower( ULONG character )
{
   return( AssignObj( new_char( ToLower( character ) ) ) );
}

/* New, object-oriented NameSpaces */

/****i* addNamedObject() [2.0] ****************************************
*
* NAME
*    addNamedObject()
*
* DESCRIPTION
*    ^ <primitive 209 3 29 nameSpcObj namedObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *addNamedObject( OBJECT *nameSpcObj, OBJECT *object )
{
   struct NamedObject *nso = (struct NamedObject *) CheckObject( nameSpcObj );
   struct NamedObject *obj = (struct NamedObject *) CheckObject( object     );

   if (!nso || !obj) // == NULL)
      return( o_false );
      
   if (AddNamedObject( nso, obj ) == FALSE)
      return( o_false );
   else
      return( o_true );
}

/****i* allocNamedObject() [2.0] **************************************
*
* NAME
*    allocNamedObject()
*
* DESCRIPTION
*    ^ namedObj<- <primitive 209 3 30 nameString tagListOBj>
***********************************************************************
*
*/

METHODFUNC OBJECT *allocNamedObject( char *name, OBJECT *tagListObj )
{
   struct TagItem *tags = (struct TagItem *) CheckObject( tagListObj );
   
   return( AssignObj( new_address( (ULONG) AllocNamedObjectA( name, tags ))));
}

/****i* attemptRemNamedObject() [2.0] *********************************
*
* NAME
*    attemptRemNamedObject()
*
* DESCRIPTION
*    ^ <primitive 209 3 31 namedObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *attemptRemNamedObject( OBJECT *namedObj )
{
   struct NamedObject *nobj = (struct NamedObject *) CheckObject( namedObj );
   
   if (!nobj) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) AttemptRemNamedObject( nobj ))));
}

/****i* findNamedObject() [2.0] ***************************************
*
* NAME
*    findNamedObject()
*
* DESCRIPTION
*    ^ <primitive 209 3 32 namedSpcObj nameString lastNamedObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *findNamedObject( OBJECT *nameSpcObj, char *name, OBJECT *lastObj )
{
   struct NamedObject *nso  = (struct NamedObject *) CheckObject( nameSpcObj );
   struct NamedObject *last = (struct NamedObject *) CheckObject( lastObj    );
   
   if (!nso || !last) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_address( (ULONG) FindNamedObject( nso, name, last ))));
}

/****i* freeNamedObject() [2.0] ***************************************
*
* NAME
*    freeNamedObject()
*
* DESCRIPTION
*    <primitive 209 3 33 namedObj>
***********************************************************************
*
*/

METHODFUNC void freeNamedObject( OBJECT *namedObj )
{
   struct NamedObject *nobj = (struct NamedObject *) CheckObject( namedObj );

   if (!nobj) // == NULL)
      return;
      
   FreeNamedObject( nobj );
   
   return;
}

/****i* namedObjectName() [2.0] ***************************************
*
* NAME
*    namedObjectName()
*
* DESCRIPTION
*    ^ <primitive 209 3 34 namedObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *namedObjectName( OBJECT *namedObj )
{
   struct NamedObject *nobj = (struct NamedObject *) CheckObject( namedObj );

   if (!nobj) // == NULL)
      return( o_nil );
      
   return( AssignObj( new_str( NamedObjectName( nobj ) ) ) );
}

/****i* releaseNamedObject() [2.0] ************************************
*
* NAME
*    releaseNamedObject()
*
* DESCRIPTION
*    <primitive 209 3 35 namedObj>
***********************************************************************
*
*/

METHODFUNC void releaseNamedObject( OBJECT *namedObj )
{
   struct NamedObject *nobj = (struct NamedObject *) CheckObject( namedObj );

   if (!nobj) // == NULL)
      return;
      
   ReleaseNamedObject( nobj );
   
   return;
}

/****i* remNamedObject() [2.0] ****************************************
*
* NAME
*    remNamedObject()
*
* DESCRIPTION
*    <primitive 209 3 36 namedObj msgObj>
***********************************************************************
*
*/

METHODFUNC void remNamedObject( OBJECT *namedObj, OBJECT *msgObj )
{
   struct NamedObject *nobj = (struct NamedObject *) CheckObject( namedObj );
   struct Message     *msg  = (struct Message     *) CheckObject( msgObj   );

   if (!nobj) // == NULL)
      return;
         
   RemNamedObject( nobj, msg );
   
   return;
}

/* Unique ID generator */

/****i* getUniqueID() [2.0] *******************************************
*
* NAME
*    getUniqueID()
*
* DESCRIPTION
*    <primitive 209 3 37>
***********************************************************************
*
*/

METHODFUNC OBJECT *getUniqueID( void )
{
   return( AssignObj( new_int( (int) GetUniqueID() ) ) );
}     

/****i* getLower32Bits() [2.0] ****************************************
*
* NAME
*    getLower32Bits()
*
* DESCRIPTION
*    ^ <primitive 209 3 38 longInteger>
***********************************************************************
*
*/

METHODFUNC OBJECT *getLower32Bits( OBJECT *arg )
{
   OBJECT *rval = o_nil;
   CLASS  *lint = fnd_class( arg );
   
   if (StringComp( "LongInteger", symbol_value( (SYMBOL *) lint->class_name ) ) == 0)
      rval = arg->inst_var[1];
   
   return( rval );
} 
                  
/****i* getUpper32Bits() [2.0] ****************************************
*
* NAME
*    getUpper32Bits()
*
* DESCRIPTION
*    ^ <primitive 209 3 39 longInteger>
***********************************************************************
*
*/

METHODFUNC OBJECT *getUpper32Bits( OBJECT *arg )
{
   OBJECT *rval = o_nil;
   CLASS  *lint = fnd_class( arg );
   
   if (StringComp( "LongInteger", symbol_value( (SYMBOL *) lint->class_name ) ) == 0)
      rval = arg->inst_var[0];
   
   return( rval );
}

/* From intuition.library:
struct Hook *SetEditHook( struct Hook *hook );
*/
 
/****h* HandleUtility() [2.0] ******************************************
*
* NAME
*    HandleUtility() {Primitive 209 3 ??}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    Utility interfacing methods.
************************************************************************
*
*/

PUBLIC OBJECT *HandleUtility( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );
      return( rval );
      }

   // numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0:
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = getTagData(   (Tag) int_value( args[1] ),
                               (ULONG) int_value( args[2] ),
                                                  args[3]
                             );
         break;

      case 1:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = allocateTagItems( (ULONG) int_value( args[1] ) );
            
         break;

      case 2:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = findTagItem( (Tag) int_value( args[1] ), args[2] );
            
         break;

      case 3:
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            filterTagChanges( args[1], args[2], (ULONG) int_value( args[3] ) );
            
         break;
      
      case 4:
         applyTagChanges( args[1], args[2] );
         break;
      
      case 5:
         rval = cloneTagItems( args[1] );
         break;

      case 6:
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = filterTagItems( args[1], args[2], (ULONG) int_value( args[3] ));
         
         break;

      case 7:
         freeTagItems( args[1] );
         break;

      case 8:
         if (is_integer( args[3] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            mapTags( args[1], args[2], (ULONG) int_value( args[3] ) );
            
         break;

      case 9:
         rval = nextTagItem( args[1] );
         break;

      case 10:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = packBoolTags( (ULONG) int_value( args[1] ),
                                 args[2], args[3] 
                               );
         break;
         
      case 11:
         refreshTagItemClones( args[1], args[2] );
         break;

      case 12:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = tagInArray( (Tag) int_value( args[1] ), args[2] );
            
         break;

      case 13:
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = packStructureTags( args[1], (ULONG *) int_value( args[2] ),
                                      args[3]
                                    );
         break;
          
      case 14:
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = unpackStructureTags( args[1], (ULONG *) int_value( args[2] ),
                                        args[3] 
                                      );
         break;
         
      case 15: // callHook: hookFileName for: dataObject using: msgObject
               // ^ <primitive 209 3 15 self hookFileName msgObject>
         if (!is_string( args[2] ) || !is_address( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = callExtHook( args[1], string_value( (STRING *) args[2] ),
                                   (void *) addr_value( args[3] )
                              );
         break;

      case 16:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            amiga2Date( (ULONG) int_value( args[1] ), args[2] );
         
         break;

      case 17:
         rval = date2Amiga( args[1] );
         break;

      case 18:
         rval = checkDate( args[1] );
         break;

#     ifdef    __SASC
      case 19:
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = signed32BitMult( (LONG) int_value( args[1] ),
                                    (LONG) int_value( args[2] )
                                  );
         break;

      case 20:
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = unsigned32BitMult( (ULONG) int_value( args[1] ),
                                      (ULONG) int_value( args[2] )
                                    );
         break;

      case 21:
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = signed32BitDivision( (LONG) int_value( args[1] ),
                                        (LONG) int_value( args[2] )
                                      );
         break;

      case 22:
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = unsigned32BitDivision( (LONG) int_value( args[1] ),
                                          (LONG) int_value( args[2] )
                                        );
         break;

      case 23:
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = signed64BitMult( (LONG) int_value( args[1] ),
                                    (LONG) int_value( args[2] )
                                  );
         break;

      case 24:  
         if (!is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = unsigned64BitMult( (LONG) int_value( args[1] ),
                                      (LONG) int_value( args[2] )
                                    );
         break;
#     endif // __amigaos4__

      case 25:
         if (!is_string( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = UTstringCompare( string_value( (STRING *) args[1] ),
                                    string_value( (STRING *) args[2] )
                                  );
         break;

      case 26:
         if (!is_string( args[1] ) || !is_string(  args[2] )
                                   || !is_integer( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = UTstringICompare( string_value( (STRING *) args[1] ),
                                     string_value( (STRING *) args[2] ),
                                        int_value(            args[3] )
                                   );
         break;

      case 27:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = UTtoUpper( (ULONG) int_value( args[1] ) );
            
         break;

      case 28:
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = UTtoLower( (ULONG) int_value( args[1] ) );
            
         break;

      case 29:
         rval = addNamedObject( args[1], args[2] );
         break;

      case 30:
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = allocNamedObject( string_value( (STRING *) args[1] ),
                                                              args[2] 
                                   );
         break;
         
      case 31:
         rval = attemptRemNamedObject( args[1] );
         break;

      case 32:
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = findNamedObject( args[1], 
                                    string_value( (STRING *) args[2] ),
                                    args[3] 
                                  );
         break;

      case 33:
         freeNamedObject( args[1] );
         break;

      case 34:
         rval = namedObjectName( args[1] );
         break;

      case 35:
         releaseNamedObject( args[1] );
         break;

      case 36:
         remNamedObject( args[1], args[2] );
         break;

      case 37:      
         rval = getUniqueID();
         break;

      case 38: // getLower32Bits: longInteger
         rval = getLower32Bits( args[1] );
         break;
                   
      case 39: // getUppper32Bits: longInteger
         rval = getUpper32Bits( args[1] );
         break;

      // More ExternalHook primitives (see also <209 3 15>):

      case 40: // setData: newData
               // data <- <primitive 209 3 40 self newData>          
         
         rval = setHookData( args[1], args[2] );
         break;
         
      case 41: // dispose <primitive 209 3 41 private>          

         disposeHook( args[1] );
         break;
         
                   
      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   return( rval );
}

/* ---------------------- END of Utility.c file! ----------------------- */
