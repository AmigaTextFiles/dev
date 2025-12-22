/****h* AmigaTalk/Menus.c [3.0] ****************************************
* 
* NAME
*    Menus.c
* 
* DESCRIPTION
*    Functions that handle AmigaTalk menu primitives.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
* FUNCTIONAL INTERFACE:
*
*    PUBLIC OBJECT *HandleMenus( int numargs, OBJECT **args );
*
* NOTES
*    $VER: AmigaTalk:Src/Menus.c 3.0 (25-Oct-2004) by J.T Steichen
************************************************************************
*
*/

#include <stdio.h>
#include <exec/types.h>

#include <AmigaDOSErrs.h>

#ifdef __amigaos4__

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
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT OBJECT *o_nil;
IMPORT UBYTE  *AllocProblem;
IMPORT UBYTE  *ErrMsg;

IMPORT int     ChkArgCount( int need, int numargs, int primnumber );
IMPORT OBJECT  *ReturnError( void );
IMPORT OBJECT  *PrintArgTypeError( int primnumber );

// -------------------------------------------------------------------

PUBLIC struct Menu DefaultMenu = {

   NULL, 0, 0, 90, 10, MENUENABLED, NULL, NULL, 0, 0, 0, 0
};

PUBLIC struct IntuiText DefaultItemText = { 
    
   0, 1, JAM1, 0, 0, NULL, NULL, NULL 
};

PUBLIC struct MenuItem DefaultMenuItem = {

   NULL, 0, 10, 90, 10, ITEMTEXT | HIGHCOMP | ITEMENABLED, 0L, 
   &DefaultItemText, &DefaultItemText, 0x00, NULL, 0    
};

/****i* RemoveMenuItem() [1.5] ***************************************
*
* NAME
*    RemoveMenuItem()
*
* DESCRIPTION
*    This is for both MenuItems & SubItems, since their structures
*    are identical
**********************************************************************
*
*/

SUBFUNC void RemoveMenuItem( struct MenuItem *si )
{
   if (!si) // == NULL)
      return;
   
   if ((si->SubItem) || (si->NextItem)) // != NULL))
      return;

   if ((si->Flags & ITEMTEXT) == ITEMTEXT)
      {
      struct IntuiText *it = (struct IntuiText *) si->ItemFill;
      struct IntuiText *st = (struct IntuiText *) si->SelectFill;
      
      if (it && (it != &DefaultItemText))
         {
         return;
         }
      
      if (st && (st != &DefaultItemText))
         {
         return;
         }
      }
   else  // Menu subitem has Image rendering:
      {
      if (si->ItemFill) // != NULL)
         return;

      if (si->SelectFill) // != NULL)
         return;
      } 

   AT_FreeVec( si, "SubItem", TRUE ); // Nothing left, chop off the head!

   si = NULL;
   
   return;
}

/****h* RemoveMenu() [1.5] *******************************************
*
* NAME
*    RemoveMenu()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC void RemoveMenu( struct Menu *mi )
{
   if (!mi) // == NULL)
      return;
   
   if (mi->NextMenu || mi->FirstItem) // != NULL))
      return;

   if (mi->MenuName) // != NULL)
      FreeVec( mi->MenuName );
   
   AT_FreeVec( mi, "Menu", TRUE );

   return;
}


/****i* MenuRemove() [1.0] *******************************************
*
* NAME
*    MenuRemove()
*
* DESCRIPTION
*    <182 0 whattype menuObj>
**********************************************************************
*
*/

METHODFUNC void MenuRemove( int whattype, OBJECT *menuObj )
{
   struct Menu *menu = (struct Menu *) CheckObject( menuObj );

   if (!menu) // == NULL)
      return;
      
   switch (whattype)
      {
      case 0: // Remove a Menu struct:
         RemoveMenu( menu );
         
         menu = NULL;
          
         break;

      case 1: // Remove a MenuItem struct:
         {
         struct MenuItem *mi = (struct MenuItem *) CheckObject( menuObj );

         RemoveMenuItem( mi );

         mi = NULL;
         }
         break;

      case 2: // Remove a Sub - MenuItem struct:
         {
         struct MenuItem *si = (struct MenuItem *) CheckObject( menuObj );
         
         RemoveMenuItem( si );

         si = NULL;
         }
         break;
      
      default:
         break;
      }

   return;   
}

/****i* CopyDefaultMenu() [1.0] **************************************
*
* NAME
*    CopyDefaultMenu()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC void CopyDefaultMenu( struct Menu *newmenu )
{
   CopyMem( (char *) &DefaultMenu, (char *) newmenu,
            (long) sizeof( struct Menu )
          );

   return;      
}

/****i* CopyDefaultMenuItem() [1.0] **********************************
*
* NAME
*    CopyDefaultMenuItem()
*
* DESCRIPTION
*
**********************************************************************
*
*/

SUBFUNC void CopyDefaultMenuItem( struct MenuItem *newitem )
{
   CopyMem( (char *) &DefaultMenuItem, (char *) newitem,
            (long) sizeof( struct MenuItem )
          );

   return;      
}

#define  STRMEM   MEMF_CLEAR | MEMF_FAST | MEMF_PUBLIC
#define  CHIPMEM  MEMF_CLEAR | MEMF_CHIP

/****i* MenuAdd() [1.0] **********************************************
*
* NAME
*    MenuAdd()
*
* DESCRIPTION
*    ^ <182 1 whattype menuName>
**********************************************************************
*
*/

METHODFUNC OBJECT *MenuAdd( int whattype, char *menuname )
{
   struct Menu     *newmenu = NULL;
   struct MenuItem *newitem = NULL;
   UBYTE           *newname = NULL;
   OBJECT          *rval    = o_nil;
      
   switch (whattype)
      {
      case 0:
         {
         newmenu = (struct Menu *) AT_AllocVec( sizeof( struct Menu ), 
                                                CHIPMEM, "Menu", TRUE
                                              );

         newname = (UBYTE *) AT_AllocVec( strlen( menuname ) + 1,
                                          CHIPMEM, "MenuName", TRUE
                                        );

         if (!newmenu || !newname) // == NULL))
            {
            MemoryOut( MenusCMsg( MSG_MENUADD_FUNC_MEN ) );
         
            if (newmenu) // != NULL)
               AT_FreeVec( newmenu, "Menu", TRUE );

            if (newname) // != NULL)
               AT_FreeVec( newname, "MenuName", TRUE );

            return( rval );   
            }

         CopyDefaultMenu( newmenu );

         (void) StringCopy( newname, menuname );

         newmenu->MenuName = newname;
         
         rval = AssignObj( new_address( (ULONG) newmenu ) );
         }

         break;

      case 1: // MenuItems & SubItems are the same structure:
      case 2:
         {
         newitem = (struct MenuItem *) AT_AllocVec( sizeof( struct MenuItem ),
                                                    CHIPMEM, "MenuItem", TRUE
                                                  );

         if (!newitem) // == NULL)
            {
            MemoryOut( MenusCMsg( MSG_MENUADD_FUNC_MEN ) );
         
            return( rval );   
            }

         CopyDefaultMenuItem( newitem );

         rval = AssignObj( new_address( (ULONG) newitem ) );
         } 

         break;

      default: 
         break;         
      }

   return( rval );
}

/****i* GetMenuPiece() [1.0] *****************************************
*
* NAME
*    GetMenuPiece()
*
* DESCRIPTION
*    Return the part of the Menu struct requested.
*    <182 2 whichPart type menuObj>
**********************************************************************
*
*/

SUBFUNC OBJECT *GetMenuPiece( int whichpart, struct Menu *menuptr )
{
   OBJECT   *rval = o_nil;
   
   if (!menuptr) // == NULL)
      return( rval );
      
   switch (whichpart)
      {
      case 0: 
         rval = AssignObj( new_int( menuptr->LeftEdge ));    
         break;
      case 1: 
         rval = AssignObj( new_int( menuptr->TopEdge  ));    
         break;
      case 2: 
         rval = AssignObj( new_int( menuptr->Width    ));    
         break;
      case 3: 
         rval = AssignObj( new_int( menuptr->Height   ));    
         break;
      case 4: 
         rval = AssignObj( new_int( menuptr->Flags    ));    
         break;
      case 5: 
         rval = o_nil;
         break;
      case 6: 
         rval = o_nil;
         break;
      case 7: 
         rval = o_nil;
         break;
      case 8:
         rval = AssignObj( new_address( (ULONG) menuptr->NextMenu ));
         break;

      case 9:
         AssignObj( rval = new_address( (ULONG) menuptr->FirstItem ));
         break;

      case 10: 
         rval = o_nil;
         break;
      case 11: 
         rval = o_nil;
         break;
      case 12: 
         rval = o_nil;
         break;

      case 13: 
         rval = AssignObj( new_str( menuptr->MenuName ) );    
         break; 

      default:
         break;
      } 

   return( rval );
}

/****i* GetItemPiece() [1.0] *****************************************
*
* NAME
*    GetItemPiece()
*
* DESCRIPTION
*    Return the part of the MenuItem (SubItem) struct requested.
**********************************************************************
*
*/

SUBFUNC OBJECT *GetItemPiece( int whichpart, struct MenuItem *menuiptr )
{
   OBJECT *rval = o_nil;
   
   switch (whichpart)
      {
      case 0: rval = AssignObj( new_int( menuiptr->LeftEdge ));      break;
      case 1: rval = AssignObj( new_int( menuiptr->TopEdge  ));      break;
      case 2: rval = AssignObj( new_int( menuiptr->Width    ));      break;
      case 3: rval = AssignObj( new_int( menuiptr->Height   ));      break;
      case 4: rval = AssignObj( new_int( menuiptr->Flags    ));      break;
      case 5: rval = AssignObj( new_int( menuiptr->MutualExclude )); break;
      case 6: rval = AssignObj( new_int( menuiptr->Command  ));      break;

      case 7:
         rval = AssignObj( new_address( (ULONG) menuiptr->NextItem ));
         break;
      
      case 8: 
         rval = o_nil;
         break;
      
      case 9: 
         rval = o_nil;
         break;

      case 10:
         if (!menuiptr->ItemFill) // == NULL)
            return( rval );
                 
         rval = AssignObj( new_address( (ULONG) menuiptr->ItemFill ));

         break;

      case 11:
         if (!menuiptr->SelectFill) // == NULL)
            return( rval );
                 
         rval = AssignObj( new_address( (ULONG) menuiptr->SelectFill ));

         break;

      case 12:
         if (!menuiptr->SubItem) // == NULL)
            return( rval );

         rval = AssignObj( new_address( (ULONG) menuiptr->SubItem ));

         break;

      case 13:
      default:
         break;
      } 

   return( rval );
}

/****i* GetMenuPart() [1.0] ******************************************
*
* NAME
*    GetMenuPart()
*
* DESCRIPTION
*    Return the part of the MenuStrip requested.
*    ^ <182 2 whichPart type menuObj>
**********************************************************************
*
*/

METHODFUNC OBJECT *GetMenuPart( int whichpart, int whattype, OBJECT *menuObj )
{
   OBJECT *rval = o_nil;
   
   switch (whattype)
      {
      case 0:
         {
         struct Menu *mi = (struct Menu *) CheckObject( menuObj );
         
         if (!mi) // == NULL)
            return( rval );

         rval = GetMenuPiece( whichpart, mi );
         }
         break;

      case 1:
      case 2:
         {
         struct MenuItem *mi = (struct MenuItem *) CheckObject( menuObj );

         if (!mi) // == NULL)
            return( rval );
                     
         rval = GetItemPiece( whichpart, mi );
         }
         break;

      default:
         break;
      }

   return( rval );
}

/****i* SetMenuPiece() [1.0] *****************************************
*
* NAME
*    SetMenuPiece()
*
* DESCRIPTION
*    Set a Menu struct field to the supplied value.
**********************************************************************
*
*/

SUBFUNC void SetMenuPiece( int whichpart, int whatvalue, 
                           struct Menu *menuptr
                         )
{
   switch (whichpart)
      {
      case 0: menuptr->LeftEdge = whatvalue;    break;
      case 1: menuptr->TopEdge  = whatvalue;    break;
      case 2: menuptr->Width    = whatvalue;    break;
      case 3: menuptr->Height   = whatvalue;    break;
      case 4: menuptr->Flags    = whatvalue;    break;
      
      case 5:     // This is not defined for menus:
      case 6:     // This is not defined for menus:
      case 7:     // This is not defined for menus:
      case 10:    // This is not defined for menus:
      case 11:    // This is not defined for menus:
      case 12:    // This is not defined for menus:
      case 8:     // These cases are performed in SetMenuStrPiece():
      case 9:
      case 13:
      default: break;
      } 

   return;
} 

/****i* SetItemPiece() [1.0] *****************************************
*
* NAME
*    SetItemPiece()
*
* DESCRIPTION
*    Set a MenuItem (SubItem) struct field to the supplied value.
**********************************************************************
*
*/

SUBFUNC void SetItemPiece( int whichpart, int whatvalue, 
                           struct MenuItem *menuiptr
                         )
{
   switch (whichpart)
      {
      case 0: 
         menuiptr->LeftEdge = whatvalue;      
         break;
      
      case 1: 
         menuiptr->TopEdge  = whatvalue;      
         break;
      
      case 2: 
         menuiptr->Width    = whatvalue;      
         break;
      
      case 3: 
         menuiptr->Height   = whatvalue;      
         break;
      
      case 4: 
         menuiptr->Flags    = whatvalue;      
         break;
      
      case 5: 
         menuiptr->MutualExclude = whatvalue; 
         break;
      
      case 6: 
         menuiptr->Command  = whatvalue;      
         break;

      case 8:  // Not applicable to MenuItems:
      case 9:
      case 13:
      case 7:  // performed in SetItemStrPiece():
      case 10:
      case 11:
      case 12:
      default: break;
      } 

   return;
}

/****i* SetMenuPart() [1.0] ******************************************
*
* NAME
*    SetMenuPart()
*
* DESCRIPTION
*    Set a MenuStrip field to the supplied value.
*    <182 3 whichpart whatvalue menuObj>
**********************************************************************
*
*/

METHODFUNC void SetMenuPart( int whichpart, int whatvalue,
                             int whattype,  OBJECT *menuObj
                           )
{
   switch (whattype)
      {
      case 0:
         {
         struct Menu *mi = (struct Menu *) CheckObject( menuObj );
         
         if (!mi) // == NULL)
            return;
         else
            SetMenuPiece( whichpart, whatvalue, mi );
         }

         break;
               
      case 1:
      case 2:
         {
         struct MenuItem *mi = (struct MenuItem *) CheckObject( menuObj );
         
         if (!mi) // == NULL)
            return;
         else
            SetItemPiece( whichpart, whatvalue, mi );
         }

         break;
      
      default:
         break;
      }

   return;
}

/****i* SetMenuStrPiece() [1.0] **************************************
*
* NAME
*    SetMenuStrPiece()
*
* DESCRIPTION
*    Set a Menu struct string field to the supplied value.
**********************************************************************
*
*/

SUBFUNC void SetMenuStrPiece( int          whichpart,
                              OBJECT      *whatvalue, 
                              struct Menu *menuptr
                            )
{
   switch (whichpart)
      {
      case 8:
         {
         struct Menu *nxtname = (struct Menu *) CheckObject( whatvalue );
         
         if (nxtname == NULL)
            return;
            
         menuptr->NextMenu = nxtname;
         }

         break;

      case 9:
         {
         struct MenuItem *fname = (struct MenuItem *) CheckObject( whatvalue );
         
         if (!fname) // == NULL)
            return;
            
         menuptr->FirstItem = fname;
         }
         break;

      case 13:

      default:
         break;
      }

   return;
}

//PRIVATE struct IntuiText  Undefined_Text = {

//   0, 1, JAM2, 0, 0, NULL, (UBYTE *) NULL, NULL  // MSG_MEN_UNDEF_ITEXT_STR, NULL
//};

/****i* SetItemStrPiece() [1.0] **************************************
*
* NAME
*    SetItemStrPiece()
*
* DESCRIPTION
*    Set a MenuItem (SubItem) struct string field to the 
*    supplied value.
**********************************************************************
*
*/

SUBFUNC void SetItemStrPiece( int              whichpart,
                              OBJECT          *whatvalue, 
                              struct MenuItem *menuiptr
                            )
{
   UWORD HIGHMASK = 0x00F0;
   
   switch (whichpart)
      {    
      case 7: // NextItem:
         {
         struct MenuItem *ni = (struct MenuItem *) CheckObject( whatvalue );
         
         menuiptr->NextItem = ni;
         }

         break;

      case 10: // ItemFill:
         if ((menuiptr->Flags & HIGHMASK) == HIGHIMAGE)
            {
            struct Image *im = (struct Image *) CheckObject( whatvalue );
            
            menuiptr->ItemFill = (APTR) im;
            }
         else
            {
            struct IntuiText *it = (struct IntuiText *) CheckObject( whatvalue );
            
            menuiptr->ItemFill = (APTR) it;
            }

         break;

      case 11: // SelectFill:
         if ((menuiptr->Flags & HIGHMASK) == HIGHIMAGE)
            {
            struct Image *im = (struct Image *) CheckObject( whatvalue );
            
            menuiptr->SelectFill = (APTR) im;
            }
         else
            {
            struct IntuiText *it = (struct IntuiText *) CheckObject( whatvalue );
            
            menuiptr->SelectFill = (APTR) it;
            }

         break;

      case 12: // SubItem:
         {
         struct MenuItem *si = (struct MenuItem *) CheckObject( whatvalue );
         
         menuiptr->SubItem = si;
         }

         break;

      default:
         break;
      }

   return;
}

/****i* SetMenuString() [1.0] ****************************************
*
* NAME
*    SetMenuString()
*
* DESCRIPTION
*    Set a MenuStrip string field to the supplied value.
*    <182 3 whichpart whatvalue menuObj>
**********************************************************************
*
*/

METHODFUNC void SetMenuString( int whichpart, OBJECT *whatvalue, 
                               int whattype,  OBJECT *menuObj
                             )
{
   switch (whattype)
      {
      case 0: // for menus:
         {
         struct Menu *mi = (struct Menu *) CheckObject( menuObj );
         
         if (!mi) // == NULL)
            break;
         else
            SetMenuStrPiece( whichpart, whatvalue, mi );
         }

         break;

      case 1:  // for menuitems:
         {
         struct MenuItem *mi = (struct MenuItem *) CheckObject( menuObj );
         
         if (!mi) // == NULL)
            break;
         else 
            SetItemStrPiece( whichpart, whatvalue, mi );
         }

         break;

      case 2:  // for subitems:
         {
         struct MenuItem *mi = (struct MenuItem *) CheckObject( menuObj );
         
         if (!mi) // == NULL)
            break;
         else 
            SetItemStrPiece( whichpart, whatvalue, mi );
         }

         break;

      default:
         break;
      }

   return;
}

/*
struct MenuItem *ItemAddress( CONST struct Menu *menuStrip, ULONG menuNumber );
*/

/****h* AmigaTalk/HandleMenus [1.5] **********************************
*
* NAME
*    HandleMenus()
*
* DESCRIPTION
*    Execute Intuition menu primitives for AmigaTalk (182).
*
**********************************************************************
*
*/

PUBLIC OBJECT *HandleMenus( int numargs, OBJECT **args )
{
   OBJECT   *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 182 );
      return( rval );
      }

//   if (Undefined_Text.IText == NULL)
//      Undefined_Text.IText = MenusCMsg( MSG_UNDEF_ITEXT_MEN );
      
   switch (int_value( args[0] ))
      {
      case 0:
         if ( !is_integer( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 182 );
         else
            {
            MenuRemove( int_value( args[1] ), // type
                                   args[2]    // menuObj
                      );
            }

         break;

      case 1:
         if ( !is_integer( args[1] ) || !is_string( args[2] ))
            (void) PrintArgTypeError( 182 );
         else
            rval = MenuAdd(    int_value(            args[1] ), // type
                            string_value( (STRING *) args[2] )  // name
                          );
         break;

      case 2:
         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            (void) PrintArgTypeError( 182 );
         else
            rval = GetMenuPart( int_value( args[1] ),  // part
                                int_value( args[2] ),  // type
                                           args[3]     // menuObj
                              );
         break;

      case 3:
         if ( !is_integer( args[1] ) || !is_integer( args[3] ))
            (void) PrintArgTypeError( 182 );
         else
            {
            if (int_value( args[1] ) < 7)
               SetMenuPart( int_value( args[1] ), // part
                            int_value( args[2] ), // value
                            int_value( args[3]),  // type
                                       args[4]    // menuObj
                          );
            else
               SetMenuString( int_value( args[1] ), // part 
                                         args[2],   // whatvalue
                              int_value( args[3] ), // type
                                         args[4]    // menuObj
                            );
            }

         break;

      case 4: // setMenuParent (OBSOLETE!!)

      default:
         (void) PrintArgTypeError( 182 );
         break;
      }

   return( o_nil );
}

/* -------------------- END of Menus.c file! ------------------------- */
