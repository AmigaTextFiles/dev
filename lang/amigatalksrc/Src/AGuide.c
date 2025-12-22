/****h* AmigaTalk/AGuide.c [3.0] *************************************
*
* NAME 
*   AGuide.c
*
* DESCRIPTION
*   Functions that handle AmigaGuide to AmigaTalk primitives.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *HandleAmigaGuide( int numargs, OBJECT **args ); <209 2 ???>
*
* HISTORY
*   24-Oct-2004 - Added AmigaOS$ & gcc support.
*   27-Dec-2001 - Created this file.
*
* NOTES
*   $VER: AmigaTalk:Src/AGuide.c 3.0 (24-Oct-2004) by J.T. Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>

#include <dos/dos.h>

#include <AmigaDOSErrs.h>

#include <libraries/amigaguide.h>

#ifndef __amigaos4__
# include <clib/amigaguide_protos.h>
# include <clib/intuition_protos.h>
# include <clib/exec_protos.h>
#else
# define __USE_INLINE__

# include <proto/amigaguide.h>
# include <proto/intuition.h>
# include <proto/exec.h>

PRIVATE struct AmigaGuideIFace *IAmigaGuide;

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"

#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"

IMPORT OBJECT *o_nil, *o_true, *o_false;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT *ReturnError( void );
IMPORT OBJECT *PrintArgTypeError( int primnumber );

// See Global.c for these: --------------------------------------------

IMPORT UBYTE *SystemProblem;

IMPORT UBYTE *ErrMsg;

// --------------------------------------------------------------------

PUBLIC struct Library *AmigaGuideBase = NULL;

// private  is APTR   from OpenAmigaGuide()
// private2 is APTR   from AddAmigaGuideHostA()
// private3 is struct NewAmigaGuide

/****i* closeAmigaGuide() [3.0] ***************************************
*
* NAME
*    closeAmigaGuide()
*
* DESCRIPTION
*    <primitive 209 2 0 private>
***********************************************************************
*
*/

METHODFUNC void closeAmigaGuide( OBJECT *aguideObj ) // private
{
   APTR ag = (APTR) CheckObject( aguideObj );
   
   if (NullChk( (OBJECT *) ag ) == FALSE)
      CloseAmigaGuide( ag );

   return;
}

/****i* openAmigaGuide() [3.0] ****************************************
*
* NAME
*    openAmigaGuide()
*
* DESCRIPTION
*    ^ private <- <primitive 209 2 1 private3 tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *openAmigaGuide( OBJECT *nagObj, OBJECT *tagArray )
{
   struct NewAmigaGuide *nag  = (struct NewAmigaGuide *) CheckObject( nagObj );
   struct TagItem       *tags = NULL;
   OBJECT               *rval = o_nil;
   APTR                  ag   = 0; // NULL;

   if (NullChk( (OBJECT *) nag ) == TRUE)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }
   
   ag = OpenAmigaGuideA( nag, tags );
   
   if (ag) // != NULL)
      rval = AssignObj( new_address( (ULONG) ag ) );
      
   if (tags) // != NULL)
      AT_FreeVec( tags, "openAmigaGuideTags", TRUE );
      
   return( rval );
}

/****i* addAmigaGuideHost() [3.0] *************************************
*
* NAME
*    addAmigaGuideHost()
*
* DESCRIPTION
*    ^ private2 <- <primitive 209 2 2 hookObj objName tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *addAmigaGuideHost( OBJECT *hookObj, char *objName,
                                      OBJECT *tagArray
                                    )
{
   struct TagItem *tags = NULL;
   struct Hook    *hook = (struct Hook *) CheckObject( hookObj );
   OBJECT         *rval = o_nil;
   APTR            hndl = 0; // NULL;

   if (NullChk( (OBJECT *) hook ) == TRUE)  // The reason for this function!
      return( rval );
         
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   hndl = AddAmigaGuideHostA( hook, objName, tags );
   
   if (hndl) // != NULL)
      rval = AssignObj( new_address( (ULONG) hndl ) );
      
   if (tags) // != NULL)
      AT_FreeVec( tags, "AmigaGuideHostTags", TRUE );
      
   return( rval );
}

/****i* removeAmigaGuideHost() [3.0] **********************************
*
* NAME
*    removeAmigaGuideHost()
*
* DESCRIPTION
*    ^ <primitive 209 2 3 hostObj tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *removeAmigaGuideHost( OBJECT *hostObj, 
                                         OBJECT *tagArray 
                                       ) //" tagArray should be nil for now. "
{
   struct TagItem *tags = NULL;
   APTR            host = (APTR) CheckObject( hostObj );
   OBJECT         *rval = o_nil;
   LONG            chk  = 0L;
   
   if (NullChk( (OBJECT *) host ) == TRUE)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   chk  = RemoveAmigaGuideHostA( host, tags );

   rval = AssignObj( new_int( (int) chk ) );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "removeAmigaGuideHostTags", TRUE );
      
   return( rval );
}

/****i* getAmigaGuideSignal() [3.0] ***********************************
*
* NAME
*    getAmigaGuideSignal()
*
* DESCRIPTION
*    ^ <primitive 209 2 4 private>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAmigaGuideSignal( OBJECT *agObj )
{
   APTR ag = (APTR) CheckObject( agObj );
   
   if (NullChk( (OBJECT *) ag ) == TRUE)
      return( o_nil );
   else
      return( AssignObj( new_int( (int) AmigaGuideSignal( ag ) ) ) );
}

/****i* getAmigaGuideAttr() [3.0] *************************************
*
* NAME
*    getAmigaGuideAttr()
*
* DESCRIPTION
*    ^ <primitive 209 2 5 attr private storageObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAmigaGuideAttr( Tag attr, OBJECT *agObj, ULONG *storage )
{
   APTR ag = (APTR) CheckObject( agObj );
   
   if (NullChk( (OBJECT *) ag ) == TRUE)
      return( o_nil );
   else
      return( AssignObj( new_address( (ULONG) GetAmigaGuideAttr( attr, ag, storage ))));
}

/****i* getAmigaGuideMsg() [3.0] **************************************
*
* NAME
*    getAmigaGuideMsg()
*
* DESCRIPTION
*    ^ <primitive 209 2 6 private>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAmigaGuideMsg( OBJECT *agObj )
{
   struct AmigaGuideMsg *msg  = NULL;
   APTR                  ag   = (APTR) CheckObject( agObj );
   OBJECT               *rval = o_nil;
   
   if (NullChk( (OBJECT *) ag ) == TRUE)
      return( rval );

   msg = GetAmigaGuideMsg( ag );
   
   if (msg) // != NULL)
      rval = AssignObj( new_address( (ULONG) msg ) );
      
   return( rval );
}

/****i* getAmigaGuideString() [3.0] ***********************************
*
* NAME
*    getAmigaGuideString()
*
* DESCRIPTION
*    ^ <primitive 209 2 7 stringIDNumber>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAmigaGuideString( LONG stringIDNumber )
{
   return( AssignObj( new_str( GetAmigaGuideString( stringIDNumber ))));
}

/****i* lockAmigaGuideBase() [3.0] ************************************
*
* NAME
*    lockAmigaGuideBase()
*
* DESCRIPTION
*    You DO NOT (normally) need to use this method!!
*    ^ <primitive 209 2 8 private>
***********************************************************************
*
*/

METHODFUNC OBJECT *lockAmigaGuideBase( OBJECT *agObj )
{
   APTR ag = (APTR) CheckObject( agObj );
   
   if (NullChk( (OBJECT *) ag ) == TRUE)
      return( o_nil );
   else   
      return( AssignObj( new_int( (int) LockAmigaGuideBase( ag ))));
}

/****i* unlockAmigaGuideBase() [3.0] **********************************
*
* NAME
*    unlockAmigaGuideBase()
*
* DESCRIPTION
*    You DO NOT (normally) need to use this method!!
*    <primitive 209 2 9 key>
***********************************************************************
*
*/

METHODFUNC void unlockAmigaGuideBase( LONG key )
{
   UnlockAmigaGuideBase( key );
   
   return;
}

/****i* openAmigaGuideASync() [3.0] ***********************************
*
* NAME
*    openAmigaGuideASync()
*
* DESCRIPTION
*    ^ <primitive 209 2 10 private3 tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *openAmigaGuideASync( OBJECT *nagObj, OBJECT *tagArray )
{
   struct TagItem       *tags = NULL;
   struct NewAmigaGuide *nag  = (struct NewAmigaGuide *) CheckObject( nagObj );
   OBJECT               *rval = o_nil;
   APTR                  chk  = 0; // NULL;
   
   if (NullChk( (OBJECT *) nag ) == TRUE)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   chk = OpenAmigaGuideAsyncA( nag, tags );

   if (chk) // != NULL)
      rval = AssignObj( new_int( (int) chk ) );
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "openAmigaGuideASyncTags", TRUE );
      
   return( rval );
}

/****i* replyAmigaGuideMsg() [3.0] ************************************
*
* NAME
*    replyAmigaGuideMsg()
*
* DESCRIPTION
*    <primitive 209 2 11 aMsgObj>
***********************************************************************
*
*/

METHODFUNC void replyAmigaGuideMsg( OBJECT *aMsgObj )
{
   struct AmigaGuideMsg *msg = (struct AmigaGuideMsg *) CheckObject( aMsgObj );
   
   if (NullChk( (OBJECT *) msg ) == TRUE)
      return;
   
   ReplyAmigaGuideMsg( msg );
   
   return;
}

/****i* sendAmigaGuideCmd() [3.0] *************************************
*
* NAME
*    sendAmigaGuideCmd()
*
* DESCRIPTION
*    ^ <primitive 209 2 12 private cmdString tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *sendAmigaGuideCmd( OBJECT *agObj, char *cmdString, 
                                      OBJECT *tagArray
                                    ) // " tagArray should be nil for now. "
{
   struct TagItem *tags = NULL;
   APTR           *ag   = (APTR) CheckObject( agObj );
   OBJECT         *rval = o_nil;
   
   if (NullChk( (OBJECT *) ag ) == TRUE)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   rval = AssignObj( new_int( (int) SendAmigaGuideCmdA( ag, cmdString, tags )));

   if (tags) // != NULL)
      AT_FreeVec( tags, "sendAmigaGuideCmdTags", TRUE );
      
   return( rval );
}

/****i* sendAmigaGuideContext() [3.0] *********************************
*
* NAME
*    sendAmigaGuideContext()
*
* DESCRIPTION
*    tagArray should be nil for now.
*    ^ <primitive 209 2 13 private tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *sendAmigaGuideContext( OBJECT *agObj, OBJECT *tagArray )
{
   struct TagItem *tags = NULL;
   APTR           *ag   = (APTR) CheckObject( agObj );
   OBJECT         *rval = o_nil;
   
   if (NullChk( (OBJECT *) ag ) == TRUE)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   rval = AssignObj( new_int( (int) SendAmigaGuideContextA( ag, tags )));
   
   if (tags) // != NULL)
      AT_FreeVec( tags, "sendAmigaGuideContextTags", TRUE );
      
   return( rval );
}

/****i* setAmigaGuideAttrs() [3.0] ************************************
*
* NAME
*    setAmigaGuideAttrs()
*
* DESCRIPTION
*    tagArray should be nil for now.
*    ^ <primitive 209 2 14 private tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *setAmigaGuideAttrs( OBJECT *agObj, OBJECT *tagArray )
{
   struct TagItem *tags = NULL;
   APTR           *ag   = (APTR) CheckObject( agObj );
   OBJECT         *rval = o_nil;
   
   if (NullChk( (OBJECT *) ag ) == TRUE)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   rval = AssignObj( new_int( (int) SetAmigaGuideAttrsA( ag, tags )));

   if (tags) // != NULL)
      AT_FreeVec( tags, "setAmigaGuideAttrsTags", TRUE );
      
   return( rval );
}

/****i* setAmigaGuideContext() [3.0] **********************************
*
* NAME
*    setAmigaGuideContext()
*
* DESCRIPTION
*    tagArray should be nil for now.
*    ^ <primitive 209 2 15 private idNumber tagArray>
***********************************************************************
*
*/

METHODFUNC OBJECT *setAmigaGuideContext( OBJECT *agObj, ULONG id, OBJECT *tagArray )
{
   struct TagItem *tags = NULL;
   APTR           *ag   = (APTR) CheckObject( agObj );
   OBJECT         *rval = o_nil;
   
   if (NullChk( (OBJECT *) ag ) == TRUE)
      return( rval );
      
   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   rval = AssignObj( new_int( (int) SetAmigaGuideContextA( ag, id, tags )));

   if (tags) // != NULL)
      AT_FreeVec( tags, "setAmigaGuideContextTags", TRUE );
      
   return( rval );
}

/****i* lockXRef() [3.0] **********************************************
*
* NAME
*    lockXRef()
*
* DESCRIPTION
*    ^ <primitive 209 2 18 dirLock fileName>
***********************************************************************
*
*/

METHODFUNC OBJECT *loadXRef( BPTR dirLock, char *fileName )
{
   return( AssignObj( new_int( (int) LoadXRef( dirLock, fileName ))));
}

/****i* expungeXRef() [3.0] *******************************************
*
* NAME
*    expungeXRef()
*
* DESCRIPTION
*    Unload the cross-reference table from memory.
*    <primitive 209 2 19>
***********************************************************************
*
*/

METHODFUNC void expungeXRef( void )  
{
   ExpungeXRef();

   return;
}

/****i* setNAGDirectoryLock() [3.0] ***********************************
*
* NAME
*    setNAGDirectoryLock()
*
* DESCRIPTION
*    <primitive 209 2 20 private3 dirLock>
***********************************************************************
*
*/

METHODFUNC void setNAGDirectoryLock( OBJECT *nagObj, BPTR dirLock )
{
   struct NewAmigaGuide *nag = (struct NewAmigaGuide *) CheckObject( nagObj );

   if (NullChk( (OBJECT *) nag ) == TRUE)
      return;

   nag->nag_Lock = dirLock;
         
   return;
}

/****i* setNAGName() [3.0] ********************************************
*
* NAME
*    setNAGName()
*
* DESCRIPTION
*    <primitive 209 2 21 private3 dbaseName>
***********************************************************************
*
*/

METHODFUNC void setNAGName( OBJECT *nagObj, char *dbaseName )
{
   struct NewAmigaGuide *nag = (struct NewAmigaGuide *) CheckObject( nagObj );

   if (NullChk( (OBJECT *) nag ) == TRUE)
      return;

   nag->nag_Name = dbaseName;
         
   return;
}

/****i* setNAGScreen() [3.0] ******************************************
*
* NAME
*    setNAGScreen()
*
* DESCRIPTION
*    <primitive 209 2 22 private3 scrObject>
***********************************************************************
*
*/

METHODFUNC void setNAGScreen( OBJECT *nagObj, OBJECT *scrObj )
{
   struct Screen        *sptr = (struct Screen        *) CheckObject( scrObj );
   struct NewAmigaGuide *nag  = (struct NewAmigaGuide *) CheckObject( nagObj );

   if ((NullChk( (OBJECT *) nag ) == TRUE) || (NullChk( (OBJECT *) sptr ) == TRUE))
      {
      return;
      }

   nag->nag_Screen = sptr;
         
   return;
}

/****i* setNAGPublicScreen() [3.0] *************************************
*
* NAME
*    setNAGPublicScreen()
*
* DESCRIPTION
*    <primitive 209 2 23 private3 scrnName>
***********************************************************************
*
*/

METHODFUNC void setNAGPublicScreen( OBJECT *nagObj, char *scrnName )
{
   struct NewAmigaGuide *nag = (struct NewAmigaGuide *) CheckObject( nagObj );

   if (NullChk( (OBJECT *) nag ) == TRUE)
      return;

   nag->nag_PubScreen = scrnName;
         
   return;
}

/****i* setNAGARexxClientPort() [3.0] *********************************
*
* NAME
*    setNAGARexxClientPort()
*
* DESCRIPTION
*    <primitive 209 2 24 private3 clientPortName>
***********************************************************************
*
*/

METHODFUNC void setNAGARexxClientPort( OBJECT *nagObj, char *portName )
{
   struct NewAmigaGuide *nag = (struct NewAmigaGuide *) CheckObject( nagObj );

   if (NullChk( (OBJECT *) nag ) == TRUE)
      return;

   nag->nag_ClientPort = portName;
         
   return;
}

/****i* setNAGFlags() [3.0] *******************************************
*
* NAME
*    setNAGFlags()
*
* DESCRIPTION
*    <primitive 209 2 25 private3 newFlags>
***********************************************************************
*
*/

METHODFUNC void setNAGFlags( OBJECT *nagObj, ULONG newFlags )
{
   struct NewAmigaGuide *nag = (struct NewAmigaGuide *) CheckObject( nagObj );

   if (NullChk( (OBJECT *) nag ) == TRUE)
      return;
      
   nag->nag_Flags = newFlags;
   
   return;
}

// Called only by setNagContextStrings():

SUBFUNC void FreePrevContextArray( STRPTR *nagStrArray )
{
   int j = 0;

   if (!nagStrArray) // == NULL)
      return;
         
   while (nagStrArray[j] != NULL)
      {
      AT_FreeVec( nagStrArray[j], "aguideString", TRUE );

      j++;
      }
            
   AT_FreeVec( nagStrArray, "aguideStrArray", TRUE );

   return;         
}

PRIVATE BOOL setPrevContext = FALSE;

/****i* setNAGContextStrings() [3.0] **********************************
*
* NAME
*    setNAGContextStrings()
*
* DESCRIPTION
*    Last element of strArray MUST be nil!
*    <primitive 209 2 26 private3 nodeStringsArray>
***********************************************************************
*
*/

METHODFUNC void setNAGContextStrings( OBJECT *nagObj,
                                      OBJECT *strArray
                                    ) 
{
   struct NewAmigaGuide *nag = (struct NewAmigaGuide *) CheckObject( nagObj );

   STRPTR               *newArray = NULL;
   int                   i, numelements = objSize( strArray );
   
   if (NullChk( (OBJECT *) nag ) == TRUE || numelements < 1)
      return;

   // verify each element of strArray is indeed a String first:
   for (i = 0; i < numelements - 1; i++)
      {
      if (is_string( strArray->inst_var[i] ) == FALSE)
         return;
      }

   if (setPrevContext == TRUE)
      {
      FreePrevContextArray( nag->nag_Context );

      setPrevContext = FALSE;
      }

   // Allocate a new Context Array of STRPTRs:      
   newArray = (STRPTR *) AT_AllocVec( numelements * sizeof( STRPTR ), MEMF_CLEAR | MEMF_ANY, 
                                      "aguideStrArray", TRUE 
                                    );
   
   if (!newArray) // == NULL)
      {
      SetIoErr( ERROR_NO_FREE_STORE );
      
      return;
      }
      
   for (i = 0; i < numelements - 1; i++) // Leave last element cleared.
      {
      STRPTR  newStrPtr = NULL;
      char   *sptr      = string_value( (STRING *) strArray->inst_var[i] );
      int     len;
      
      len       = StringLength( sptr ) + 1;
      newStrPtr = (STRPTR) AT_AllocVec( len, MEMF_CLEAR | MEMF_ANY,
                                        "aguideString", TRUE
                                      );
      
      if (!newStrPtr) // == NULL)
         {
         int j;
         
         SetIoErr( ERROR_NO_FREE_STORE );

         for (j = 0; j < i; j++)
            AT_FreeVec( newArray[j], "aguideString", TRUE );
            
         AT_FreeVec( newArray, "aguideStrArray", TRUE );
         
         return;
         }

      newArray[i] = newStrPtr;
 
      strcpy( newStrPtr, sptr );
      }

   nag->nag_Context = newArray;
   
   setPrevContext = TRUE;            

   return;
}

/****i* setNAGStartNode() [3.0] ***************************************
*
* NAME
*    setNAGStartNode()
*
* DESCRIPTION
*    <primitive 209 2 27 private3 nodeName>
***********************************************************************
*
*/

METHODFUNC void setNAGStartNode( OBJECT *nagObj, char *nodeName )
{
   struct NewAmigaGuide *nag = (struct NewAmigaGuide *) CheckObject( nagObj );

   if (NullChk( (OBJECT *) nag ) == TRUE)
      return;

   nag->nag_Node = nodeName;
         
   return;
}

/****i* setNAGStartLine() [3.0] ***************************************
*
* NAME
*    setNAGStartLine()
*
* DESCRIPTION
*    <primitive 209 2 28 private3 lineNumber>
***********************************************************************
*
*/

METHODFUNC void setNAGStartLine( OBJECT *nagObj, LONG lineNumber )
{
   struct NewAmigaGuide *nag = (struct NewAmigaGuide *) CheckObject( nagObj );

   if (NullChk( (OBJECT *) nag ) == TRUE)
      return;

   nag->nag_Line = lineNumber;
         
   return;
}

/****i* setNAGTags() [3.0] ********************************************
*
* NAME
*    setNAGTags()
*
* DESCRIPTION
*    <primitive 209 2 29 private3 tagArray>
***********************************************************************
*
*/

METHODFUNC void setNAGTags( OBJECT *nagObj, OBJECT *tagArray )
{
   struct TagItem       *tags = NULL;
   struct NewAmigaGuide *nag  = (struct NewAmigaGuide *) CheckObject( nagObj );

   if (NullChk( (OBJECT *) nag ) == TRUE)
      return;

   if (NullChk( tagArray ) == FALSE)
      {
      tags = ArrayToTagList( tagArray );
      }

   if (tags) // != NULL)
      {    
            // src,  destination,     howmuch
      CopyMem( tags, nag->nag_Extens, objSize(tagArray ) * sizeof( ULONG )); // ->size * sizeof( ULONG ) );

      AT_FreeVec( tags, "setNAGTags", TRUE );
      }

   return;
}

/****i* disposeContextArray() [3.0] ***********************************
*
* NAME
*    disposeContextArray()
*
* DESCRIPTION
*    Last element of strArray MUST be nil!
*    <primitive 209 2 30 private3 nodeStringsArray>
***********************************************************************
*
*/

METHODFUNC void disposeContextArray( OBJECT *nagObj )
{
   struct NewAmigaGuide *nag = (struct NewAmigaGuide *) CheckObject( nagObj );
   int    i;
   
   if (NullChk( (OBJECT *) nag ) == TRUE)
      return;
      
   if (setPrevContext == TRUE)
      {
      i = 0;
      
      while (nag->nag_Context[i] != NULL)
         {
         AT_FreeVec( nag->nag_Context[i], "aguideContextElement", TRUE );
         
         i++;
         }
         
      AT_FreeVec( nag->nag_Context, "aguideContext[]", TRUE );

      setPrevContext = FALSE;   
      }

   return;
}

/****i* getAGMsgType() [3.0] ******************************************
*
* NAME
*    getAGMsgType()
*
* DESCRIPTION
*    ^ <primitive 209 2 31 aGuideMsgObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAGMsgType( OBJECT *aGuideMsgObj )
{
   struct AmigaGuideMsg *msg  = (struct AmigaGuideMsg *) CheckObject( aGuideMsgObj );
   OBJECT               *rval = o_nil;

   if (NullChk( (OBJECT *) msg ) == TRUE)
      return( rval );
      
   return( AssignObj( new_int( (int) msg->agm_Type ) ) );
}
        
/****i* getAGMsgData() [3.0] ******************************************
*
* NAME
*    getAGMsgData()
*
* DESCRIPTION
*    ^ <primitive 209 2 32 aGuideMsgObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAGMsgData( OBJECT *aGuideMsgObj )
{
   struct AmigaGuideMsg *msg  = (struct AmigaGuideMsg *) CheckObject( aGuideMsgObj );
   OBJECT               *rval = o_nil;

   if (NullChk( (OBJECT *) msg ) == TRUE)
      return( rval );
      
   return( AssignObj( new_address( (ULONG) msg->agm_Data ) ) );
}
            
/****i* getAGMsgDataType() [3.0] **************************************
*
* NAME
*    getAGMsgDataType()
*
* DESCRIPTION
*    ^ <primitive 209 2 33 aGuideMsgObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAGMsgDataType( OBJECT *aGuideMsgObj )
{
   struct AmigaGuideMsg *msg  = (struct AmigaGuideMsg *) CheckObject( aGuideMsgObj );
   OBJECT               *rval = o_nil;

   if (NullChk( (OBJECT *) msg ) == TRUE)
      return( rval );
      
   return( AssignObj( new_int( (int) msg->agm_DType ) ) );
}

/****i* getAGMsgDataSize() [3.0] **************************************
*
* NAME
*    getAGMsgDataSize()
*
* DESCRIPTION
*    ^ <primitive 209 2 34 aGuideMsgObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAGMsgDataSize( OBJECT *aGuideMsgObj )
{
   struct AmigaGuideMsg *msg  = (struct AmigaGuideMsg *) CheckObject( aGuideMsgObj );
   OBJECT               *rval = o_nil;

   if (NullChk( (OBJECT *) msg ) == TRUE)
      return( rval );
      
   return( AssignObj( new_int( (int) msg->agm_DSize ) ) );
}

/****i* getAGMsgReturnValue() [3.0] ***********************************
*
* NAME
*    getAGMsgReturnValue()
*
* DESCRIPTION
*    ^ <primitive 209 2 35 aGuideMsgObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAGMsgReturnValue( OBJECT *aGuideMsgObj )
{
   struct AmigaGuideMsg *msg  = (struct AmigaGuideMsg *) CheckObject( aGuideMsgObj );
   OBJECT               *rval = o_nil;

   if (NullChk( (OBJECT *) msg ) == TRUE)
      return( rval );
      
   return( AssignObj( new_int( (int) msg->agm_Pri_Ret ) ) );
}

/****i* getAGMsgSecondaryValue() [3.0] ********************************
*
* NAME
*    getAGMsgSecondaryValue()
*
* DESCRIPTION
*    ^ <primitive 209 2 36 aGuideMsgObj>
***********************************************************************
*
*/

METHODFUNC OBJECT *getAGMsgSecondaryValue( OBJECT *aGuideMsgObj )
{
   struct AmigaGuideMsg *msg  = (struct AmigaGuideMsg *) CheckObject( aGuideMsgObj );
   OBJECT               *rval = o_nil;

   if (NullChk( (OBJECT *) msg ) == TRUE)
      return( rval );
      
   return( AssignObj( new_int( (int) msg->agm_Sec_Ret ) ) );
}

/****i* setNAGBaseName() [3.0] ****************************************
*
* NAME
*    setNAGBaseName()
*
* DESCRIPTION
*    <primitive 209 2 37 appBaseName>
***********************************************************************
*
*/

METHODFUNC void setNAGBaseName( char *appBaseName )
{
   return;
}

/****h* HandleAmigaGuide() [3.0] ******************************************
*
* NAME
*    HandleAmigaGuide() {Primitive 209 2 xx}
*
* DESCRIPTION
*    The function that the Primitive handler calls for 
*    AmigaGuide interfacing methods.
************************************************************************
*
*/

PRIVATE BOOL OpenedAGuideLibrary = FALSE;

PUBLIC OBJECT *HandleAmigaGuide( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 209 );

      return( rval );
      }

   if (OpenedAGuideLibrary == FALSE)
      {
#     ifdef __SASC
      if ((AmigaGuideBase = OpenLibrary( "amigaguide.library", 39L )))
         {
         OpenedAGuideLibrary = TRUE;
	 }
#     else
      if ((AmigaGuideBase = OpenLibrary( "amigaguide.library", 50L )))
         {
	 if (!(IAmigaGuide = (struct AmigaGuideIFace *) GetInterface( AmigaGuideBase, "main", 1, NULL )))
	    {
	    CloseLibrary( AmigaGuideBase );
	    AmigaGuideBase      = NULL;
            OpenedAGuideLibrary = FALSE;
	    
            NotOpened( 4 ); // "amigaguide.library!" );

            return( rval );
	    }
	 else
	    OpenedAGuideLibrary = TRUE;
	 }
#     endif
      else
         {
         OpenedAGuideLibrary = FALSE;

         NotOpened( 4 ); // "amigaguide.library!" );

         return( rval );
         }
      }
      
//   numargs--; // Not needed yet!
   
   switch (int_value( args[0] ))
      {
      case 0: // closeAmigaGuide [private]
         closeAmigaGuide( args[1] );

         break;

      case 1: // openAmigaGuide: [private3] tagArray
              // ^ private <- <primitive 209 2 1 private3 tagArray>
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = openAmigaGuide( args[1], args[2] );

         break;
      
      case 2: // addAmigaGuideHost: hostNameString hook: hookObj tags: tagArray
              // ^ private2 <- <209 2 2  hookObj objName tagArray>
         if (!is_string( args[2] ) || !is_array( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = addAmigaGuideHost( args[1], string_value( (STRING *) args[2] ),
                                      args[3]
                                    );
         break;

      case 3: // removeAmigaGuideHost: [private2] tagArray " tagArray should be nil for now. "
              // ^ <primitive 209 2 3 private2 tagArray>
          rval = removeAmigaGuideHost( args[1], args[2] );
          break;

      case 4: // getAmigaGuideSignal [private]
              // ^ <primitive 209 2 4 private>
          rval = getAmigaGuideSignal( args[1] );
          break;

      case 5: // getAmigaGuideAttribute: attrTag [private] into: storageObj
              // ^ <primitive 209 2 5 attrTag private storageObj>
         if (!is_integer( args[1] ) || !is_address( args[3] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = getAmigaGuideAttr(     (Tag)  int_value( args[1] ),
                                                            args[2],
                                      (ULONG *) addr_value( args[3] )
                                    );
         break;

      case 6: // getAmigaGuideMsg [private]
              // ^ <primitive 209 2 6 private>
         rval = getAmigaGuideMsg( args[1] );
         break;

      case 7: // getAmigaGuideString: stringIDNumber
              // ^ string <- <primitive 209 2 7 stringIDNumber>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = getAmigaGuideString( (LONG) int_value( args[1] ) );

      case 8: // lockAmigaGuideBase [private] " You DO NOT need to use this method!! "
              // ^ long_int <primitive 209 2 8 private>
         rval = lockAmigaGuideBase( args[1] );
         break;

      case 9: // unlockAmigaGuideBase: keyFromLockMethod " You DO NOT need to use!! "
              // <primitive 209 2 9 keyFromLockMethod>
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            unlockAmigaGuideBase( (LONG) int_value( args[1] ) );
   
         break;
         
      case 10: // openAmigaGuideASync: tagArray
               // ^ private <- <primitive 209 2 10 private3 tagArray>
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = openAmigaGuideASync( args[1], args[2] );

         break;
         
      case 11: // replyAmigaGuideMsg: amigaGuideMsgObj
               // <primitive 209 2 11 amigaGuideMsgObj>
         replyAmigaGuideMsg( args[1] );
         break;

      case 12: // sendAmigaGuideCommand: commandString tags: tagArray " tagArray is nil for now. "
               // ^ <primitive 209 2 12 private commandString tagArray>
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = sendAmigaGuideCmd( args[1], string_value( (STRING *) args[2] ),
                                      args[3] 
                                    );
         break;
         
      case 13: // sendAmigaGuideContext: tagArray " tagArray should be nil for now. "
               // ^ <primitive 209 2 13 private tagArray> 
         rval = sendAmigaGuideContext( args[1], args[2] );
         break;

      case 14: // setAmigaGuideAttributes: tagArray
               // ^ <primitive 209 2 14 private tagArray>
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = setAmigaGuideAttrs( args[1], args[2] );
         
         break;

      case 15: // setAmigaGuideContext: idNumber tags: tagArray " tagArray is nil for now. "
               // ^ <primitive 209 2 15 private idNumber tagArray>
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            rval = setAmigaGuideContext(                    args[1], 
                                         (ULONG) int_value( args[2] ),
                                                            args[3]
                                       );
         break;

      // 16 & 17 are for non-existent functions!
         
      case 18: // loadCrossReferencesFrom: fileName from: directoryLock
               // ^ <primitive 209 2 18 directoryLock fileName>
         if (!is_address( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 209 );
         else
            rval = loadXRef( (BPTR) addr_value( args[1] ),
                                  string_value( (STRING *) args[2] )
                           );
         break;
          
      case 19: // expungeCrossReferences " Unload the cross-reference table from memory. "
               // <primitive 209 2 19> 
         expungeXRef();
         break;
         
      case 20: // setNAGDirectoryLock: directoryLock
               // <primitive 209 2 20 private3 directoryLock>     
         if (is_address( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            setNAGDirectoryLock( args[1], addr_value( args[2] ) );
         break;
         
      case 21: // setNAGName: databaseName
               // <primitive 209 2 21 private3 databaseName>     
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            setNAGName( args[1], string_value( (STRING *) args[2] ) );
             
         break;

      case 22: // setNAGScreen: screenObject
               // <primitive 209 2 22 private3 screenObject>
         setNAGScreen( args[1], args[2] );         
         break;

      case 23: // setNAGPulicScreen: screenObject
               // <primitive 209 2 23 private3 screenObject>     
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            setNAGPublicScreen( args[1], string_value( (STRING *) args[2] ) );

         break;

      case 24: // setNAGARexxClientPort: clientPortName
               // <primitive 209 2 24 private3 clientPortName>
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            setNAGARexxClientPort( args[1], string_value( (STRING *) args[2] ) );

         break;

      case 25: // setNAGFlags: newFlags
               // <primitive 209 2 25 private3 newFlags>     
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            setNAGFlags( args[1], (ULONG) int_value( args[2] ) );

         break;

      case 26: // setNAGContextStrings: nodeStringsArray " Last element of Array MUST be nil! "
               // <primitive 209 2 26 private3 nodeStringsArray>     
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            setNAGContextStrings( args[1], args[2] );
            
         break;

      case 27: // setNAGStartNode: nodeName
               // <primitive 209 2 27 private3 nodeName>     
         if (is_string( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            setNAGStartNode( args[1], string_value( (STRING *) args[2] ) );

         break;

      case 28: // setNAGStartLine: lineNumber
               // <primitive 209 2 28 private3 lineNumber>     
         if (is_integer( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            setNAGStartLine( args[1], (LONG) int_value( args[2] ) );
            
         break;

      case 29: // setNAGTags: tagArray
               // <primitive 209 2 29 private3 tagArray>
         if (is_array( args[2] ) == FALSE)
            (void) PrintArgTypeError( 209 );
         else
            setNAGTags( args[1], args[2] );
   
         break;

      case 30: // disposeContext   <primitive 209 2 30 private3>
         disposeContextArray( args[1] );
         break;

      case 31: // getAGMsgType: aGuideMsgObj
               // ^ <primitive 209 2 31 aGuideMsgObj>
         rval = getAGMsgType( args[1] );
         break;

      case 32: // getAGMsgData: aGuideMsgObj
               // ^ <primitive 209 2 32 aGuideMsgObj>
         rval = getAGMsgData( args[1] );
         break;

      case 33: // getAGMsgDataType: aGuideMsgObj
               // ^ <primitive 209 2 33 aGuideMsgObj>
         rval = getAGMsgDataType( args[1] );
         break;

      case 34: // getAGMsgDataSize: aGuideMsgObj
               // ^ <primitive 209 2 34 aGuideMsgObj>
         rval = getAGMsgDataSize( args[1] );
         break;

      case 35: // getAGMsgReturnValue: aGuideMsgObj
               // ^ <primitive 209 2 35 aGuideMsgObj>
         rval = getAGMsgReturnValue( args[1] );
         break;

      case 36: // getAGMsgSecondaryValue: aGuideMsgObj
               // ^ <primitive 209 2 36 aGuideMsgObj>
         rval = getAGMsgSecondaryValue( args[1] );
         break;

      case 37: // setNAGBaseName: appBaseName      " appBaseName can be nil "
               // <primitive 209 2 37 appBaseName>
         setNAGBaseName( string_value( (STRING *) args[1] ) );
         break;

      default:
         (void) PrintArgTypeError( 209 );

         break;
      }

   if (OpenedAGuideLibrary == TRUE)
      {
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) IAmigaGuide );
      IAmigaGuide = NULL;
      
#     endif
      CloseLibrary( AmigaGuideBase );

      if (AmigaGuideBase->lib_OpenCnt == 0)
         AmigaGuideBase = NULL; 

      OpenedAGuideLibrary = FALSE;
      }

   return( rval );
}

/* ---------------------- END of AGuide.c file! ----------------------- */
