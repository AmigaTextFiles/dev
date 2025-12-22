/****h* AmigaTalk/ITextFont.c [3.0] ***********************************
*
* NAME 
*    ITextFont.c
*
* DESCRIPTION
*    Functions that handle AmigaTalk IntuiText & Font primitives.
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleIText( int numargs, OBJECT **args );
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    28-Nov-2003 - Added the getTextHeight( 188 2 9 ) & 
*                  setITextByContents( 188 ) primitives.
*
*    04-Oct-2003 - Added the openFont() & closeFont() functions.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES 
*    $VER: AmigaTalk:Src/ITextFont.c 3.0 (25-Oct-2004) by J.T Steichen
***********************************************************************
*
*/

#include <stdio.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#ifdef    __SASC
# include <clib/diskfont_protos.h>

# define  FASTMEM  MEMF_CLEAR | MEMF_FAST | MEMF_PUBLIC
# define  CHIPMEM  MEMF_CLEAR | MEMF_CHIP | MEMF_PUBLIC

#else

# define __USE_INLINE__

# include <proto/diskfont.h>
# include <proto/exec.h>
# include <proto/intuition.h>

IMPORT struct ExecIFace      *IExec;
IMPORT struct IntuitionIFace *IIntuition;
IMPORT struct DiskfontIFace  *IDiskfont;

# define  FASTMEM  MEMF_CLEAR | MEMF_FAST | MEMF_SHARED
# define  CHIPMEM  MEMF_CLEAR | MEMF_CHIP | MEMF_SHARED

#endif

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "ATStructs.h"
#include "Object.h"
#include "Constants.h"
#include "FuncProtos.h"
#include "IStructs.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *o_nil;

IMPORT UBYTE  *AllocProblem;
IMPORT UBYTE  *ErrMsg;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT  *ReturnError( void );
IMPORT OBJECT  *PrintArgTypeError( int primnumber );

/* --------------- Font primitive Support functions: ----------------- */

PRIVATE struct TextAttr DefaultTA =  {

   "topaz.font", 8, FS_NORMAL, FPF_ROMFONT
};

/****i* FontRemove() [1.0] *******************************************
*
* NAME
*    FontRemove() (188 4)
*
* DESCRIPTION
*    <primitive 188 4 private>
**********************************************************************
*
*/

METHODFUNC void FontRemove( OBJECT *fntObj )
{
   struct TextAttr *fnt = (struct TextAttr *) CheckObject( fntObj );

   if (!fnt || (fnt == &DefaultTA))
      return;

   AT_FreeVec( fnt->ta_Name, "FontName", TRUE );
   AT_FreeVec( fnt, "Font", TRUE );

   fnt = NULL;
   
   return;
}

/****i* CopyDefaultFont() [1.0] **************************************
*
* NAME
*    CopyDefaultFont()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC void CopyDefaultFont( struct TextAttr *newta )
{
   CopyMem( (char *) &DefaultTA, (char *) newta,
            (long) sizeof( struct TextAttr )
          );

   return;
}

/****i* FontAdd() [1.0] **********************************************
*
* NAME
*    FontAdd() (188 5)
*
* DESCRIPTION
*    ^ <primitive 188 5 fontNameString>
**********************************************************************
*
*/

METHODFUNC OBJECT *FontAdd( char *FontString )
{
   struct TextAttr *newta   = (struct TextAttr *) NULL;
   char            *newName = NULL;
   OBJECT          *rval    = o_nil;
      
   newta  = (struct TextAttr *) AT_AllocVec( sizeof( struct TextAttr ),
                                             CHIPMEM, "Font", TRUE
                                           );

   newName = (char *) AT_AllocVec( strlen( FontString ) + 1, 
                                   CHIPMEM, "FontName", TRUE 
                                 );
   
   if (!newta || !newName) // == NULL)
      {
      MemoryOut( ITxtCMsg( MSG_ITF_FONTADD_FUNC_ITEXT ) );

      if (newta) // != NULL)
         AT_FreeVec( newta, "Font", TRUE );
         
      if (newName) // != NULL)
         AT_FreeVec( newName, "FontName", TRUE );
         
      return( rval );
      }

   CopyDefaultFont( newta );

   StringCopy( newName, FontString );

   newta->ta_Name = newName;

   return( rval = AssignObj( new_address( (ULONG) newta ) ) );
}

/****i* GetFontPart() [1.0] ******************************************
*
* NAME
*    GetFontPart() (188 6 ??)
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC OBJECT *GetFontPart( int whichpart, OBJECT *fntObj )
{
   struct TextAttr *fnt  = (struct TextAttr *) CheckObject( fntObj );
   OBJECT          *rval = o_nil;
   
   if (!fnt) // == NULL)
      return( rval );
   
   switch (whichpart)
      {
      case 0:
         rval = AssignObj( new_str( fnt->ta_Name ) );
         break;
      
      case 1:
         rval = AssignObj( new_int( fnt->ta_YSize ) );
         break;
         
      case 2:
         rval = AssignObj( new_int( fnt->ta_Style ) );
         break;
      
      case 3:
         rval = AssignObj( new_int( fnt->ta_Flags ) );
         break;
      
      default:
         break;
      }

   return( rval );   
}

/****i* SetFontString() [1.0] ****************************************
*
* NAME
*    SetFontString()
*
* DESCRIPTION
*    <primitive 188 7 0 newName private> 
**********************************************************************
*
*/

METHODFUNC void SetFontString( char *FontString, OBJECT *fntObj )
{
   struct TextAttr *fnt     = (struct TextAttr *) CheckObject( fntObj );
   char            *newname = NULL;
      
   if (!fnt) // == NULL)
      return;

   if (fnt != &DefaultTA)
      AT_FreeVec( fnt->ta_Name, "FontName", TRUE );

   newname = (char *) AT_AllocVec( strlen( FontString ) + 1, 
                                   CHIPMEM, "FontName", TRUE 
                                 );

   if (!newname) // == NULL)
      {
      MemoryOut( ITxtCMsg( MSG_ITF_SETFONT_FUNC_ITEXT ) );

      return;
      }

   StringCopy( newname, FontString );

   fnt->ta_Name = newname;

   return;
}

/****i* SetFontPart() [1.0] ******************************************
*
* NAME
*    SetFontPart()
*
* DESCRIPTION
*    <primitive 188 7 whichPart whatValue private>
**********************************************************************
*
*/

METHODFUNC void SetFontPart( int whichpart, int whatvalue, OBJECT *fntObj )
{
   struct TextAttr *fnt = (struct TextAttr *) CheckObject( fntObj );
   
   if (!fnt) // == NULL)
      return;

   switch (whichpart)
      {
      case 1: fnt->ta_YSize = whatvalue;
              break;
      case 2: fnt->ta_Style = whatvalue;
              break;
      case 3: fnt->ta_Flags = whatvalue;
              break;
      default: 
         break;
      }

   return;
}

/* ----------------- IntuiText-related functions: -------------------- */

PRIVATE char            def_font[] = "topaz.font";
PRIVATE struct TextAttr def_ta     = { (UBYTE *) def_font, 8, 
                                       FS_NORMAL, FPF_ROMFONT };

PRIVATE struct IntuiText  Default_Text = {

   0, 1, JAM2, 0, 0, &def_ta, (UBYTE *) NULL, NULL
};


/****i* ITextRemove() [1.0] ******************************************
*
* NAME
*    ITextRemove()
*
* DESCRIPTION
*    <primitive 188 0 private>
**********************************************************************
*
*/

METHODFUNC void ITextRemove( OBJECT *itextObj )
{
   struct IntuiText *et = (struct IntuiText *) CheckObject( itextObj );

   if (!et) // == NULL)
      return;

   // DO NOT free the Default_Text!
   if (StringComp( et->IText, (char *) Default_Text.IText ) == 0)
      return;
 
   AT_FreeVec( et->IText, "itxtString", TRUE );
   AT_FreeVec( et,        "IntuiText" , TRUE );
   
   et = NULL;
        
   return;   
}

/****i* GetITextPart() [1.0] *****************************************
*
* NAME
*    GetITextPart()
*
* DESCRIPTION
*    ^ <primitive 188 2 whichpart private>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetITextPart( int whichpart, OBJECT *itextObj )
{
   struct IntuiText *et   = (struct IntuiText *) CheckObject( itextObj );
   OBJECT           *rval = o_nil;
      
   if (!et) // == NULL)
      return;

   switch ( whichpart )
      {
      case 0:  
         rval = AssignObj( new_int( et->FrontPen ) );
         break;
      
      case 1:  
         rval = AssignObj( new_int( et->BackPen ) );
         break;
         
      case 2:  
         rval = AssignObj( new_int( et->DrawMode ) );
         break;
      
      case 3:  
         rval = AssignObj( new_int( et->LeftEdge ) );
         break;

      case 4:  
         rval = AssignObj( new_int( et->TopEdge ) );
         break;

      case 5:  
         if (et->ITextFont->ta_Name) // != NULL)
            rval = AssignObj( new_str( et->ITextFont->ta_Name ) );

         break;

      case 6:
         rval = AssignObj( new_str( et->IText ) );
         break;

      case 7:  
         if (et->NextText->IText) // != NULL)
            rval = AssignObj( new_str( et->NextText->IText ) );

         break;
      
      case 8:
         if (et->NextText) // != NULL)
            rval = AssignObj( new_address( (ULONG) et->NextText ) );
         
         break;

      case 9: // getTextHeight()
         {
         struct TextAttr *ta = et->ITextFont;
         
         if (ta) // != NULL)
            rval = AssignObj( new_int( (int) ta->ta_YSize ) );
         else
            rval = AssignObj( new_int( 8 ) );
         }
         break;
                  
      default:
         break;
      }   

   return( rval );
}

/****i* CopyDefaultIText() [1.0] *************************************
*
* NAME
*    CopyDefaultIText()
*
* DESCRIPTION
*
* NOTES
*    IText field will be set somewhere outside this function
**********************************************************************
*
*/

SUBFUNC void CopyDefaultIText( struct IntuiText *newtext )
{
   if (!Default_Text.IText) // == NULL)
      Default_Text.IText = (UBYTE *) ITxtCMsg( MSG_ITF_DEFAULT_TXT_ITEXT );
   
   CopyMem( (char *) &Default_Text, (char *) newtext,
            (long) sizeof( struct IntuiText )
          );

   return;
}

/****i* SetITextPart() [1.0] *****************************************
*
* NAME
*    SetITextPart()
*
* DESCRIPTION
*    <primitive 188 3 whichpart whatvalue private>
**********************************************************************
*
*/

METHODFUNC void SetITextPart( int     whichpart, 
                              OBJECT *whatvalue, 
                              OBJECT *itextObj
                            )
{
   struct IntuiText *et = (struct IntuiText *) CheckObject( itextObj );
      
   if (!et) // == NULL)
      return;

   switch (whichpart)
      {
      case 0:
         et->FrontPen = int_value( whatvalue );
         break;
      
      case 1:
         et->BackPen  = int_value( whatvalue );
         break;
      
      case 2:
         et->DrawMode = int_value( whatvalue );
         break;
      
      case 3:
         et->LeftEdge = int_value( whatvalue );
         break;
     
      case 4:
         et->TopEdge  = int_value( whatvalue );
         break;
      
      case 5:
         et->ITextFont = (struct TextAttr *) addr_value( whatvalue );
         
         break;
         
      case 6:
         {
         UBYTE *itname = et->IText;
         UBYTE *newit  = NULL;
         char  *wvalue = string_value( (STRING *) whatvalue );
          
         if (strcmp( itname, Default_Text.IText ) == 0)
            return; // Do NOT mess with the Default_Text!!

         AT_FreeVec( itname, "itxtString", TRUE ); 

         newit = (UBYTE *) AT_AllocVec( strlen( wvalue ) + 1, 
                                        FASTMEM, "itxtString", TRUE 
                                      );

         if (!newit) // == NULL)
            {
            MemoryOut( ITxtCMsg( MSG_ITF_SETPART_FUNC_ITEXT ) );

            return;
            }

         StringCopy( newit, wvalue );

         et->IText = newit;
         }
         break;

      case 7:
         et->NextText = (struct IntuiText *) addr_value( whatvalue );

         break;

      default:
         break;
      }

   return;
}

/****i* ITextAdd() [1.0] *********************************************
*
* NAME
*    ITextAdd()
*
* DESCRIPTION
*    ^ <primitive 188 1 newString>
**********************************************************************
*
*/

METHODFUNC OBJECT *ITextAdd( char *thetext )
{
   struct IntuiText *newitext = (struct IntuiText *) NULL;
   UBYTE            *newtext  = NULL;
   OBJECT           *rval     = o_nil;
      
   newitext = (struct IntuiText *) AT_AllocVec( sizeof( struct IntuiText ),
                                                CHIPMEM, "IntuiText", TRUE
                                              );

   newtext  = (char *) AT_AllocVec( strlen( thetext ) + 1, 
                                    FASTMEM, "itxtString", TRUE 
                                  );

   if ((!newitext) || (!newtext)) // == NULL))
      {
      MemoryOut( ITxtCMsg( MSG_ITF_TXTADD_FUNC_ITEXT ) );

      if (newitext) // != NULL)
         AT_FreeVec( newitext, "IntuiText", TRUE );

      if (newtext) // != NULL)
         AT_FreeVec( newtext, "itxtString", TRUE );

      return( rval );
      }

   CopyDefaultIText( newitext );

   (void) StringCopy( newtext, thetext );

   newitext->IText = newtext;
   
   rval = AssignObj( new_address( (ULONG) newitext ) );
   
   return( rval );
}

/****i* openFont() [3.0] *********************************************
*
* NAME
*    openFont()
*
* DESCRIPTION
*    Open the DiskFont that corresponds to the given TextAttr struct.
*    ^ <primitive 188 8 private>
**********************************************************************
*
*/

METHODFUNC OBJECT *openFont( struct TextAttr *ta )
{
   OBJECT          *rval = o_nil;
   struct TextFont *Font = (struct TextFont *) NULL;
   
   if (!ta || (ta == (struct TextAttr *) o_nil))
      return( rval );
      
   if ((Font = (struct TextFont *) OpenDiskFont( ta ))) // != NULL)
      rval = AssignObj( new_address( (ULONG) Font ) );
      
   return( rval );   
}      

/****i* GetITextLength() [1.0] ***************************************
*
* NAME
*    GetITextLength()
*
* DESCRIPTION
*    Get the horizontal pixel length of the IntuiText.
*    ^ <primitive 188 9 private>
**********************************************************************
*
*/

  
METHODFUNC int GetITextLength( OBJECT *itextObj )
{
   struct IntuiText *et = (struct IntuiText *) CheckObject( itextObj );
      
   if (!et) // == NULL)
      return( 0 );

   return( IntuiTextLength( et ) );
} 

/****i* closeFont() [3.0] ********************************************
*
* NAME
*    closeFont()
*
* DESCRIPTION
*    Close the DiskFont.
*    <primitive 188 10 diskFont>
**********************************************************************
*
*/

METHODFUNC void closeFont( struct TextFont *tf )
{
   if (!tf || (tf == (struct TextFont *) o_nil))
      return;
      
   CloseFont( tf );

   return;
}

/****h* HandleIText() [1.9] ******************************************
*
* NAME
*    HandleIText()
*
* DESCRIPTION
*    Handle Font (4->7) & IText primitives 188 0 through 188 9
**********************************************************************
*
*/

PUBLIC OBJECT *HandleIText( int numargs, OBJECT **args )
{
   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 188 );

      return( rval );
      }

   if (Default_Text.IText == NULL)
      Default_Text.IText = (UBYTE *) ITxtCMsg( MSG_ITF_DEFAULT_TXT_ITEXT );

   switch (int_value( args[0] ))
      {
      case 0: // dispose [private]
         if (NullChk( args[1] ) == FALSE)
            {
            ITextRemove( args[1] );
            }

         break;
      
      case 1: // new: newString  ^ private
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 188 );
         else
            rval = ITextAdd( string_value( (STRING *) args[1] ) );

         break;
      
      case 2: // getITextPart [whichpart private]
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 188 );
         else
            rval = GetITextPart( int_value( args[1] ), args[2] );

         break;
      
      case 3: // setITextPart: [whichpart] newValue [private]
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 188 );
         else
            SetITextPart( int_value( args[1] ), args[2], args[3] );

         break;

      case 4: // xxxDispose [private]           Memory FreeVec()
         if (NullChk( args[1] ) == FALSE)
            {
            FontRemove( args[1] );
            }

         break;
      
      case 5: // xxxNew: newFontName ^ private  Memory AllocVec()
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 188 );
         else
            rval = FontAdd( string_value( (STRING *) args[1] ) );

         break;
      
      case 6: // getFontPart [whichPart private]
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 188 );
         else
            rval = GetFontPart( int_value( args[1] ), args[2] );

         break;

      case 7: // setFontPart: [whichpart] newValue [private]
         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 188 );
         else
            SetFontPart( int_value( args[1] ), int_value( args[2] ), args[3] );

         break;

      case 8: // diskFont <- <primitive 188 8 [private]>
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 188 );
         else
            rval = openFont( (struct TextAttr *) addr_value( args[1] ) );

         break;
      
      case 9:
         rval = AssignObj( new_int( GetITextLength( args[1] ) ) );

         break;

      case 10: // closeFont [diskFont]
         if (is_address( args[1] ) == FALSE)
            (void) PrintArgTypeError( 188 );
         else
            closeFont( (struct TextFont *) addr_value( args[1] ) );

         break;

      default:
         break;
      }

   return( rval );
}

/* ----------------- END of ITextFont.c file! ------------------------- */
