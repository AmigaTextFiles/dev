/****h* AmigaTalk/CursesPrims.c [3.0] *********************************
*
* NAME
*   CursesPrims.c The primitive functions that allow AmigaTalk to
*                 utilize the Curses library.
*
* DESCRIPTION
*   The primitive functions that allow AmigaTalk to
*   utilize the Curses library.
*
* FUNCTIONAL INTERFACE:
*
*   PUBLIC OBJECT *CursesPrim( int numargs, OBJECT **args );
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    08-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*   $VER: AmigaTalk:Src/CursesPrims.c 3.0 (25-Oct-2004) by J.T. Steichen
*
*   Some of the curses functions won't do anything on the Amiga &
*   some aren't implemented by AmigaTalk.  Those that aren't 
*   implemented can be emulated by one or more calls to other 
*   functions.  The primitive number for most of the calls to 
*   curses is 124; primitive number 126 is equivalent to: 
*
*     move( int_value( args[2] ), int_value( args[1] ) );
*     addstr( string_value( args[0] ) );
*     refresh();
*     move( 0, LINES - 1 );
*
*   which is:  int mvaddstr(  int line, int col, char *str );
***********************************************************************
*
*/

#include <stdio.h>
#include <ctype.h>
#include <math.h>
#include <errno.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include "Env.h"

#ifdef CURSES

# include <curses.h>

# include "CPGM:GlobalObjects/CommonFuncs.h"

# include "ATStructs.h"

# include "object.h"

# include "Constants.h"

# include "StringConstants.h"
# include "StringIndexes.h"
# include "FuncProtos.h"

IMPORT int     ChkArgCount(   int need,    int numargs, int primnumber );
IMPORT OBJECT *ArgCountError( int numargs, int primnumber );

IMPORT OBJECT  *o_true, *o_false;
IMPORT OBJECT  *o_nil;

IMPORT UBYTE   *UserPgmError;

# ifndef  TRUE
#  define  TRUE  1
#  define  FALSE 0
# endif

# define MAX_WIN 50  // This should be more than enough!

WINDOW **CWindowList = NULL;

/****i* AllocateCWindowList() [1.0] ********************************
*
* NAME
*    AllocateCWindowList()
*
* DESCRIPTION
*    Make a list for the Curses windows.
********************************************************************
*
*/

PRIVATE int AllocateCWindowList( WINDOW **wlist )
{
   if (wlist) // != NULL)
      return( 0 );
   else   
      {
      wlist = (WINDOW **) AT_AllocVec( MAX_WIN * sizeof( WINDOW *), 
                                       MEMF_CLEAR | MEMF_FAST, 
                                       "cursesWinList", TRUE
                                     );

      if (!wlist) // == NULL)
         {
         MemoryOut( CursCMsg( MSG_CP_ALLCWL_FUNC_CURSE ) );

         return( -1 );
         }
      }

   CWindowList = wlist;

   return( 0 );
}

/****i* CloseCWindow() [1.0] ***************************************
*
* NAME
*    CloseCWindow()
*
* DESCRIPTION
*    Search through wlist[] & close the wptr Curses Window.
********************************************************************
*
*/

PRIVATE void CloseCWindow( WINDOW **wlist, WINDOW *wptr )
{
   int i = 0;
   
   while (i < MAX_WIN)
      {
      if (wlist[i] == wptr)
         {
         delwin( wptr );
         wlist[i] = NULL;

         return;
         }

      i++;
      }

   return;
}

/****i* AddCWindow() [1.0] *****************************************
*
* NAME
*    AddCWindow()
*
* DESCRIPTION
*    Add the given Window to the Window List.
********************************************************************
*
*/

PRIVATE int AddCWindow( WINDOW **wlist, WINDOW *wptr )
{
   int i = 0;

   if (!wlist) // == NULL)
      return( -2 );

   while (i < MAX_WIN)
      {
      if (!wlist[i]) // == NULL)
         {
         // Found an empty slot:
         wlist[i] = wptr;

         return( i );
         }
      }

   return( -1 ); // No more empty slots.
}

/****i* FreeCWindowList() [1.0] ************************************
*
* NAME
*    FreeCWindowList()
*
* DESCRIPTION
*    Close ALL Curses Windows & FreeMem() them.
********************************************************************
*
*/

PRIVATE void FreeCWindowList( WINDOW **wlist )
{
   int i;
   
   if (!wlist) // == NULL)
      return;
      
   for (i = 0; i < MAX_WIN; i++)
      {
      if (wlist[i]) // != NULL)
         {
         delwin( wlist[i] );

         wlist[i] = NULL;
         }
      }

   AT_FreeVec( wlist, "cursesWinList", TRUE );

   wlist = NULL;

   return;
}

/****h* CursesPrim() [1.5] *****************************************
*
* NAME
*    CursesPrim()
*
* DESCRIPTION
*    Translate primitives (124) into calls to the Curses library.
********************************************************************
*
*/

PUBLIC OBJECT *CursesPrim( int numargs, OBJECT **args )
{
   OBJECT *rval  = o_nil;
   WINDOW *wtemp = (WINDOW *) NULL;
   char    tb[81], *tbuffer = &tb[0];
   int     rtemp = 0;
      
   if (!CWindowList) // == NULL)
      if (AllocateCWindowList( CWindowList ) < 0)
         {
         return( rval );
         }
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 124 );

      return( rval );
      }

   numargs--;
   
   switch (int_value( args[0] ))
      {
      case 0: // Shutdown the curses screen:
         rval        = AssignObj( new_int( endwin() ) );
         FreeCWindowList( CWindowList );
         CWindowList = NULL;
         break;

      case 1: // initialize the curses screen:
         rval = AssignObj( new_int( initscr() ) );
         break;

      case 2: // open a new curses window:
         if (numargs != 4)
            return( ArgCountError( 4, 124 ) );

         if (  !is_integer( args[1] ) || !is_integer( args[2] )
            || !is_integer( args[3] ) || !is_integer( args[4] )) 
            return( PrintArgTypeError( 124 ) );
         
         wtemp = newwin( int_value( args[1] ), // lines
                         int_value( args[2] ), // columns 
                         int_value( args[3] ), // beginning line, 
                         int_value( args[4] )  // beginning column
                       );

         rtemp = AddCWindow( CWindowList, wtemp );

         if (rtemp < 0)
            {
            UserInfo( CursCMsg( MSG_CP_TOO_MANY_CURSE ), UserPgmError );

            rval = AssignObj( new_int( 0 ) );

            break;
            }

         rval = AssignObj( new_int( rtemp ) );
         break;

      case 3: // close a curses window:

         if (numargs != 1)
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         CloseCWindow( CWindowList, CWindowList[ int_value( args[1] ) ] );
         break;

      case 4: // open a curses sub-window:
         if (numargs != 5)
            return( ArgCountError( 5, 124 ) );

         if (  !is_integer( args[1] ) || !is_integer( args[2] )
            || !is_integer( args[3] ) || !is_integer( args[4] )
                                      || !is_integer( args[5] ))
            return( PrintArgTypeError( 124 ) );

         wtemp = subwin( CWindowList[ int_value( args[1] ) ],
                         int_value( args[2] ), // lines
                         int_value( args[3] ), // columns
                         int_value( args[4] ), // beginning line
                         int_value( args[5] )  // beginning column
                       );

         rtemp = AddCWindow( CWindowList, wtemp );

         if (rtemp < 0)
            {
            UserInfo( CursCMsg( MSG_CP_TOO_MANY_CURSE ), UserPgmError );

            rval = AssignObj( new_int( 0 ) );

            break;
            }

         rval = AssignObj( new_int( rtemp ) );
         break;

      case 5: // draw a box around the curses window:
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if (  !is_integer( args[1] ) || !is_character( args[2] )
                                      || !is_character( args[3] )) 
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( box( CWindowList[ int_value( args[1] ) ],
                              char_value( args[2] ), // vertical
                              char_value( args[3] )  // horizontal
                                       )
                                  )
                         );
         break;

      case 6: // check for curses color operation:
         rtemp = has_colors();
         
         if (rtemp > 0)
            rval = o_true;
         else
            rval = o_false;
            
         break;

      case 7: /* tell curses to use colors (argument is Depth 
              ** of screen): 
              */
         if (numargs == 0)
            {
            rval = AssignObj( new_int( start_color() ) );
            } 
         else if (numargs == 1) 
            {
            if (is_integer( args[1] ) == FALSE)
               return( PrintArgTypeError( 124 ) );
      
            rval = AssignObj( new_int( StartColor( int_value( args[1] ) ) ) );
            }
         else
            return( ArgCountError( numargs, 124 ) );

         break; 
      
      case 8: // Set a curses color register:
         if (numargs != 4) 
            return( ArgCountError( 4, 124 ) );

         if (  !is_integer( args[1] ) || !is_integer( args[2] )
            || !is_integer( args[3] ) || !is_integer( args[4] )) 
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( init_color( int_value( args[1] ), // reg #
                                                int_value( args[2] ), // red
                                                int_value( args[3] ), // green 
                                                int_value( args[4] )  // blue
                                              )
                                  ) 
                         ); 
         break;

      case 9: // refresh entire curses screen:
         rval = AssignObj( new_int( refresh() ) );
         break;

      case 10: // refresh a curses window:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE) 
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wrefresh( CWindowList[ int_value( args[1] )] )));
         break;

      case 11: // refresh all windows on update list:
         rval = AssignObj( new_int( doupdate() ) );
         break; 

      case 12: // add a window to the update list:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE) 
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wnoutrefresh( CWindowList[ int_value( args[1])] )));
         break;

      case 13: // get a character from the keyboard:
         rval = AssignObj( new_char( getch() ) );
         break;

      case 14: /* get a character from the keyboard in 
               ** the window specified: 
               */
         if (numargs != 1)
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[0] ) == FALSE) 
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_char( wgetch( CWindowList[ int_value( args[1]) ] )));
         break;
         
      case 15: // get a character from the keyboard:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )) 
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_char( mvgetch( int_value( args[1] ), // line
                                              int_value( args[2] )  // column
                                            )
                                   ) 
                         );
         break;

      case 16: /* get a character from the keyboard in
               ** the window specified: 
               */
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3])) 
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_char( mvwgetch( CWindowList[ int_value(args[1]) ],
                                               int_value( args[2] ), //line
                                               int_value( args[3] )  // column
                                             )
                                   ) 
                         );
         break;

      case 17: // get a string from the keyboard:

         rtemp = getstr( tbuffer );

         if (rtemp != 0)
            rval = o_nil;
         else
            rval = AssignObj( new_str( tbuffer ) );

         break;

      case 18: /* get a string from the keyboard in
               ** the window specified: 
               */
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rtemp = wgetstr( CWindowList[ int_value( args[1] ) ], tbuffer );

         if (rtemp != 0)
            rval = o_nil;
         else
            rval = AssignObj( new_str( tbuffer ) );

         break;

      case 19: // get a string from the keyboard:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rtemp = mvgetstr( int_value( args[1] ), // line 
                           int_value( args[2] ), // column
                           tbuffer 
                         );

         if (rtemp != 0)
            rval = o_nil;
         else
            rval = AssignObj( new_str( tbuffer ) );

         break;

      case 20: /* get a string from the keyboard in
               ** the window specified: 
               */
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ))
            return( PrintArgTypeError( 124 ) );

         rtemp = mvwgetstr( CWindowList[ int_value( args[1] ) ],
                            int_value( args[2] ), // line
                            int_value( args[3] ), // column
                            tbuffer
                          );

         if (rtemp != 0)
            rval = o_nil;
         else
            rval = AssignObj( new_str( tbuffer ) );

         break;

      case 21: // get a char from the curses screen at current pos:
         rval = AssignObj( new_char( inch() ) );
         break;

      case 22: // get a char from the curses window at current pos:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_char( winch( CWindowList[ int_value( args[1] )] )));
         break;

      case 23: /* get a character from the curses screen at the given
               ** position: 
               */
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_char( mvinch( int_value( args[1] ), // line
                                             int_value( args[2] )  // column
                                           )
                                   )
                         );
         break;

      case 24: /* get a character from the curses window at the given
               ** position: 
               */
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_char( mvwinch( CWindowList[ int_value( args[1] )],
                                              int_value( args[2] ), // line
                                              int_value( args[3] )  // column
                                            )
                                   )
                         );
         break;

      case 25: /* insert a character into the curses screen at
               ** the current position: 
               */
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_character( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );
         
         rval = AssignObj( new_int( insch( char_value( args[1] ))));
         break;

      case 26: /* insert a character into the curses window at
               ** the current position: 
               */
         if (numargs != 2) 
            return( ArgCountError( 1, 124 ) );

         if ( !is_integer( args[1] ) || !is_character( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( winsch( CWindowList[ int_value( args[1] ) ],
                                            char_value( args[2] )
                                          )
                                  )
                         );
         break;

      case 27: /* insert a character into the curses screen at
               ** the given position: 
               */
         if (numargs != 3) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_character( args[3] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvinsch( int_value( args[1] ), // line
                                             int_value( args[2] ), // column
                                             char_value( args[3] )
                                           )
                                  )
                         );
         break;

      case 28: /* insert a character into the curses window at
               ** the given position: 
               */
         if (numargs != 4) 
            return( ArgCountError( 4, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] )
                                     || !is_character( args[4] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvwinsch( CWindowList[ int_value( args[1] )],
                                              int_value( args[2] ), // line
                                              int_value( args[3] ), // column
                                              char_value( args[4] )
                                            )
                                  )
                         );
         break;

      case 29: /* insert a line into the curses screen at
               ** the current position: 
               */
         rval = AssignObj( new_int( insertln() ) );
         break;

      case 30: /* insert a line into the curses window at
               ** the current position: 
               */
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( winsertln( CWindowList[ int_value( args[1] )] )));
         break;

      case 31: // delete a character at the current position:
         rval = AssignObj( new_int( delch() ) );
         break;
        
      case 32: /* delete a character in the curses window at
               ** the current position: 
               */
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wdelch( CWindowList[ int_value( args[1] )] )));
         break;

      case 33: /* delete a character in the curses screen at
               ** the given position: 
               */
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvdelch( int_value( args[1] ), // line
                                             int_value( args[2] )  // column
                                           )
                                  )
                         );
         break;

      case 34: /* delete a character in the curses window at
               ** the given position: 
               */
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvwdelch( CWindowList[ int_value( args[1] )],
                                              int_value( args[2] ), // line
                                              int_value( args[3] )  // column
                                            )
                                  )
                         );
         break;

      case 35: /* delete a line in the curses screen at
               ** the current position: 
               */
         rval = AssignObj( new_int( deleteln() ) );
         break;

      case 36: /* delete a line in the curses window at
               ** the current position: 
               */
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wdeleteln( CWindowList[ int_value( args[1] )] )));
         break;

      case 37: // print a character at the current position:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_character( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( addch( char_value( args[1] ))));
         break;
        
      case 38: /* print a character in the curses window at
               ** the current position: 
               */
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_character( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( waddch( CWindowList[ int_value( args[1] )],
                                            char_value( args[2] )
                                          )
                                  )
                         );
         break;

      case 39: /* print a character in the curses screen at
               ** the given position: 
               */
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ) 
                                     || !is_character( args[3] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvaddch( int_value( args[1] ), // line
                                             int_value( args[2] ), // column
                                             char_value( args[3] )
                                           )
                                  )
                         );
         break;

      case 40: /* print a character in the curses window at
               ** the given position: 
               */
         if (numargs != 4) 
            return( ArgCountError( 4, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] )
                                     || !is_character( args[4] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvwaddch( CWindowList[ int_value( args[1] )],
                                              int_value( args[2] ), // line
                                              int_value( args[3] ), // column
                                              char_value( args[4] )
                                            )
                                  )
                         );
         break;

      case 41: // print a string at the current position:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_string( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( addstr( string_value( (STRING *) args[1] ))));
         break;
        
      case 42: /* print a string in the curses window at
               ** the current position: 
               */
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_string( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( waddstr( CWindowList[ int_value( args[1] )],
                                             string_value( (STRING *) args[2] )
                                           )
                                  )
                         );
         break;

      case 43: /* print a string in the curses screen at
               ** the given position: 
               */
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ) 
                                     || !is_string( args[3] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvaddstr( int_value( args[1] ), // line
                                              int_value( args[2] ), // column
                                              string_value( (STRING *) args[3] )
                                            )
                                  )
                         );
         break;

      case 44: /* print a string in the curses window at
               ** the given position: 
               */
         if (numargs != 4) 
            return( ArgCountError( 4, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] )
                                     || !is_string( args[4] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvwaddstr( CWindowList[ int_value( args[1] )],
                                               int_value( args[2] ), // line
                                               int_value( args[3] ), // column
                                               string_value( (STRING *) args[4] )
                                             )
                                  )
                         );
         break;

      case 45: // empty the screen buffer (fill buffer with spaces):
         rval = AssignObj( new_int( erase() ) );
         break;
         
      case 46: // empty the window buffer (fill buffer with spaces):
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( werase( CWindowList[ int_value( args[1] ) ] )));
         break;

      case 47: /* send a clear sequence to screen on
               ** next refresh() call: 
               */ 
         rval = AssignObj( new_int( clear() ) );
         break;
         
      case 48: /* send a clear sequence to window on
               ** next refresh() call:
               */
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wclear( CWindowList[ int_value( args[1] ) ] )));
         break;

      case 49: /* on next refresh() call, clear from current
               ** position to bottom right-hand corner.
               */ 
         rval = AssignObj( new_int( clrtobot() ));
         break;
         
      case 50: /* on next refresh() call, clear from current
               ** position to bottom right-hand corner.
               */
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wclrtobot( CWindowList[ int_value( args[1] ) ] )));
         break;

      case 51: /* on next refresh() call, clear from current
               ** position to end of the line:
               */ 
         rval = AssignObj( new_int( clrtoeol() ));
         break;
         
      case 52: /* on next refresh() call, clear from current
               ** position to end of the line:
               */
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wclrtoeol( CWindowList[ int_value( args[1] ) ] )));
         break;

      case 53: // set the attributes for the curses screen:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( attrset( int_value( args[1] ))));
         break;

      case 54: // set the attributes for the curses window:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wattrset( CWindowList[ int_value( args[1] ) ],
                                              int_value( args[2] )
                                            )
                                  )
                         );
         break;

      case 55: // add the attributes to the curses screen:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( attron( int_value( args[1] ) ) ) );
         break;

      case 56: // add the attributes to the curses window:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wattron( CWindowList[ int_value( args[1] ) ],
                                             int_value( args[2] )
                                           )
                                  )
                         );
         break;

      case 57: // remove the attributes to the curses screen:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( attroff( int_value( args[1] ) ) ) );
         break;

      case 58: // remove the attributes to the curses window:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wattroff( CWindowList[ int_value( args[1] ) ],
                                              int_value( args[2] )
                                            )
                                  )
                         );
         break;

      case 59: // turn on inverse video for the curses screen:
         rval = AssignObj( new_int( standout() ) );
         break;

      case 60: // turn on inverse video for the curses window:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wstandout( CWindowList[ int_value( args[1] ) ] )));
         break;

      case 61: // turn off inverse video for the curses screen:
         rval = AssignObj( new_int( standend() ));
         break;

      case 62: // turn off inverse video for the curses window:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wstandend( CWindowList[ int_value( args[1] ) ] )));
         break;

      case 63: // move the current position for the curses screen:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( move( int_value( args[1] ), // line
                                          int_value( args[2] )  // column
                                        )
                                  )
                         );
         break;

      case 64: // move the current position for the curses window:
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wmove( CWindowList[ int_value( args[1] ) ],
                                           int_value( args[2] ),
                                           int_value( args[3] )
                                         )
                                  )
                         );
         break;

      case 65: /* Place terminal in CBREAK mode, making characters 
               ** typed available immediately: 
               */
         rval = AssignObj( new_int( cbreak() ) );
         break;

      case 66: /* Place terminal in NOCBREAK mode, making characters 
               ** typed unavailable until <RETURN> is pressed: 
               */
         rval = AssignObj( new_int( nocbreak() ) );
         break;

      case 67: /* Causes newline to newline/return mapping on output
               ** & return to newline mapping on input:
               */
         rval = AssignObj( new_int( nl() ) ); // This is the default.
         break;

      case 68: /* Disable newline to newline/return mapping on output
               ** & return to newline mapping on input:
               */
         rval = AssignObj( new_int( nonl() ) );
         break;

      case 69: /* Cause characters read from the keyboard to be echoed
               ** to the display:
               */
         rval = AssignObj( new_int( echo() ) ); // This is the default.
         break;

      case 70: // Disable echo():
         rval = AssignObj( new_int( noecho() ) );
         break;

      case 71: // Set or reset clear status:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         if (args[2] == o_true)
            rval = AssignObj( new_int( clearok( CWindowList[ int_value( args[1] ) ],
                                                TRUE
                                              )
                                     )
                            );
         else
            rval = AssignObj( new_int( clearok( CWindowList[ int_value( args[1] ) ],
                                                FALSE
                                              )
                                     )
                            );
         break;

      case 72: // Set or reset cursor status:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         if (args[2] == o_true)
            rval = AssignObj( new_int( leaveok( CWindowList[ int_value( args[1] ) ],
                                                TRUE
                                              )
                                     )
                            );
         else
            rval = AssignObj( new_int( leaveok( CWindowList[ int_value( args[1] ) ],
                                                FALSE
                                              )
                                     )
                            );
         break;


      case 73: // Set or reset delay status:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         if (args[2] == o_true)
            rval = AssignObj( new_int( nodelay( CWindowList[ int_value( args[1] ) ],
                                                TRUE
                                              )
                                     )
                            );
         else
            rval = AssignObj( new_int( nodelay( CWindowList[ int_value( args[1] ) ],
                                                FALSE
                                              )
                                     )
                            );
         break;

      case 74: // Move a curses window:
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvwin( CWindowList[ int_value( args[1] ) ],
                                           int_value( args[2] ), // new line
                                           int_value( args[3] )  // new column
                                         )
                                  )
                         );
         break;

      case 75: // Set or reset ANSI sequences for function keys:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         if (args[2] == o_true)
            rval = AssignObj( new_int( keypad( CWindowList[ int_value( args[1] ) ],
                                               TRUE
                                             )
                                     )
                            );
         else
            rval = AssignObj( new_int( keypad( CWindowList[ int_value( args[1] ) ],
                                               FALSE
                                             )
                                     )
                            );
         break;

      case 76: // Set or reset scrolling status:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         if (args[2] == o_true)
            rval = AssignObj( new_int( scrollok( CWindowList[ int_value( args[1] ) ],
                                                 TRUE
                                               )
                                     )
                            );
         else
            rval = AssignObj( new_int( scrollok( CWindowList[ int_value( args[1] ) ],
                                                 FALSE
                                               )
                                     )
                            );
         break;

      case 77: // Scroll window up one line:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( scroll( CWindowList[ int_value( args[1] ) ] )));
         break;

      case 78: // Set scrolling region from line top to bottom:
         if (numargs != 2) 
            return( ArgCountError( 2, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( setscrreg( int_value( args[1] ), // top
                                               int_value( args[2] )  // bottom
                                             )
                                  )
                         );
         break;

      case 79: // Set scrolling region from line top to bottom:
         if (numargs != 3) 
            return( ArgCountError( 3, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( wsetscrreg( CWindowList[ int_value( args[1] ) ],
                                                int_value( args[2] ), // top
                                                int_value( args[3] )  // bottom
                                              )
                                  )
                         );
         break;

      case 80: // Force window refresh on next refresh():
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( touchwin( CWindowList[ int_value( args[1] ) ] )));
         break;

      case 81: // Empty the keyboard buffer:
         rval = AssignObj( new_int( flushinp() ) );
         break;

      case 82: // Move the cursor:
         if (numargs != 4) 
            return( ArgCountError( 4, 124 ) );

         if ( !is_integer( args[1] ) || !is_integer( args[2] )
                                     || !is_integer( args[3] )
                                     || !is_integer( args[4] ))
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( mvcur( int_value( args[1] ),  // old line
                                           int_value( args[2] ),  // old column
                                           int_value( args[3] ),  // new line
                                           int_value( args[4] )   // new column
                                         )
                                  )
                         );
         break;

      case 83: // Issue a CTRL-G (Bel) character to screen:
         rval = AssignObj( new_int( beep() ) );
         break;

      case 84: // Complement the screen color:
         rval = AssignObj( new_int( flash() ) );
         break;

      case 85: // Set the foreground pen register:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( Set_FPen( (UWORD) int_value( args[1] ) ) ) );
         break;

      case 86: // Set the background pen register:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( Set_BPen( (UWORD) int_value( args[1] ) ) ) );
         break;

      case 87: // Set the Drawing Mode:
         if (numargs != 1) 
            return( ArgCountError( 1, 124 ) );

         if (is_integer( args[1] ) == FALSE)
            return( PrintArgTypeError( 124 ) );

         rval = AssignObj( new_int( Set_DrawMode( (UWORD) int_value( args[1] ) ) ) );
         break;
   
      /*   The following Curses functions are not implemented:
      ** 
      **   int printw( char *fmt, ... );
      **   int wprintw( WINDOW *win, char *fmt, ... );
      **   int mvprintw( int line, int col, char *fmt, ... );
      **   int mvwprintw( WINDOW *win, int line, int col, char *fmt, ... );
      **   int scanw( char *fmt, ... );
      **   int wscanw( WINDOW *win, char *fmt, ... );
      **   int mvscanw( int line, int col, char *fmt, ... );
      **   int mvwscanw( WINDOW *win, int line, int col, char *fmt, ... );
      */
      
      default: 
         break;
      }

   return( rval );      
}

#endif

/* --------------------- END of CursesPrims.c file! --------------- */
