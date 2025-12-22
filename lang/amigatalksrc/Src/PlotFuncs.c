/****h* AmigaTalk/PlotFuncs.c [3.0] ***********************************
*
* NAME
*   PlotFuncs.c
*
* DESCRIPTION
*    The primitive function has been changed to call primitives via 
*    an array of function pointers returning object *.
*    This file contains functions used to implement an Amiga-specific
*    Plotting interface.  The Plot devices are simple Intuition
*    Windows.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*    03-Sep-2003 - Added PlotArc() to the code <primitive 168>
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
* NOTES
*    $VER: AmigaTalk:Src/PlotFuncs.c 3.0 (25-Oct-2004) by J.T Steichen
***********************************************************************
*
*/

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>
#include <errno.h>

#include <exec/types.h>
#include <AmigaDOSErrs.h>

#include <graphics/gfxmacros.h> // DrawCircle() & SetDrPt(), etc.

#ifdef    __SASC

# include <clib/intuition_protos.h>

#else

# define __USE_INLINE__

# include <proto/intuition.h>

#endif

#include "Env.h"  // PLOT3 is #defined in here.

#ifdef PLOT3

# include "CPGM:GlobalObjects/CommonFuncs.h"

# include "ATStructs.h"

# include "object.h"
# include "drive.h"
# include "file.h" 

# include "Constants.h"
# include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT int cant_happen( int );
IMPORT int ChkArgCount( int need, int numargs, int primnumber );

IMPORT OBJECT  *o_object, *o_true, *o_false;
IMPORT OBJECT  *o_nil;

// In Global.c -----------------------------------------------------

IMPORT int    debug;

IMPORT UBYTE *AaarrggButton;
IMPORT UBYTE *DefaultButtons;
IMPORT UBYTE *ATalkProblem;
IMPORT UBYTE *UserProblem;
IMPORT UBYTE *ErrMsg;

// -----------------------------------------------------------------

/* Globals used by the functions, defined in NewPrimitive.c file: */

IMPORT OBJECT    *resultobj;
IMPORT OBJECT    *leftarg;
IMPORT OBJECT    *rightarg;

IMPORT int        leftint, rightint; // args[0] & args[1]
IMPORT int        i, j;              // also args[2] & args[3]

IMPORT char      *leftp;             // args[0] == string
IMPORT char      *rightp;            // args[1] == string

// --------------- PLOT3 Functions & Data: ---------------------------

struct plotenv {
   
   char          *pe_PlotName;
   struct Window *pe_PlotWindow;
};

# define MAX_PLOTENV  20   // S/B more than enough!

PRIVATE UBYTE  plotenvcount = 0;

PRIVATE struct plotenv PlotList[ MAX_PLOTENV ] = { 0, };

PRIVATE struct Window *CurrentPlotWindow = NULL;

PRIVATE struct NewWindow hidden_pw = {

   0, 0, 640, 480, 0xFF, 0xFF, 0, // No IDCMPs!!

   WFLG_ACTIVATE | WFLG_SMART_REFRESH | WFLG_RMBTRAP | WFLG_DRAGBAR,
   NULL, NULL, NULL, NULL, NULL,
   10, 10, 640, 480, WBENCHSCREEN
};

PRIVATE int FindVacantPlotEnv( struct plotenv *plotlist )
{
   int rval = 0;
   
   while (rval < MAX_PLOTENV)
      {
      if (!plotlist[ rval ].pe_PlotWindow) // == NULL)
         {
         return( rval );
         }
      
      rval++;
      }

   // Code should never reach this spot since we check for overflow
   // in PlotEnv():
   if (rval == MAX_PLOTENV)
      {
      sprintf( ErrMsg, PlotCMsg( MSG_FMT_TOO_MANY_PLOTS_PLOT ), MAX_PLOTENV );

      UserInfo( ErrMsg, UserProblem );

      return( -1 );
      }
}

/****i* MovePlotEnvironment() [1.0] **********************************
*
* NAME
*    MovePlotEnvironment( title, x, y )
*
* DESCRIPTION
*    Move a PLOT3 Window.
**********************************************************************
*
*/

PRIVATE OBJECT *MovePlotEnvironment( int numargs, OBJECT **args )
{
   char *plotname = (char *) string_value( (STRING *) args[1] );

   int   dx = int_value( args[2] );
   int   dy = int_value( args[3] );
   int   i  = 0;

   while (i < MAX_PLOTENV)
      {
      if (PlotList[i].pe_PlotName != NULL) // Kill Enforcer hits.
         {
         if (StringComp( PlotList[ i ].pe_PlotName, PlotCMsg( MSG_UNKNOWN_PLOT_PLOT ) ) == 0)
            {
            MoveWindow(            PlotList[i].pe_PlotWindow, dx, dy );
            RefreshWindowFrame(    PlotList[i].pe_PlotWindow );
            WindowToFront(         PlotList[i].pe_PlotWindow );
            (void) ActivateWindow( PlotList[i].pe_PlotWindow );

            return( o_true );
            }
         else if (StringComp( PlotList[ i ].pe_PlotName, plotname ) == 0)
            {
            MoveWindow(            PlotList[i].pe_PlotWindow, dx, dy );
            RefreshWindowFrame(    PlotList[i].pe_PlotWindow );
            WindowToFront(         PlotList[i].pe_PlotWindow );
            (void) ActivateWindow( PlotList[i].pe_PlotWindow );

            return( o_true );
            }

         i++;
         }
      
      // Didn't find the given plotname Window:
      sprintf( ErrMsg, PlotCMsg( MSG_FMT_NO_FINDPLOT_PLOT ), plotname );

      UserInfo( ErrMsg, UserProblem );

      return( o_false );
      } 
}

/****h* PlotArc() [3.0] **********************************************
*
* NAME
*    PlotArc( Xs, Ys, ArcAngle, Xc, Yc )
*
* DESCRIPTION
*    Draw an Arc (primitive 168).
*    The radius of the arc has Xs,Ys & Xc,Yc as it endpoints.  The arc
*    is drawn with Xc,Yc as the pivot point for the ArcAngle.
*    Return a o_true Object (always).
**********************************************************************
*
*/

#ifndef  PI
# define PI      3.14159265358979323846
#endif

PRIVATE const double TWO_PI = PI * 2.0;
PRIVATE const double PI_180 = PI / 180.0;

PUBLIC OBJECT *PlotArc( int numargs, OBJECT **args )
{
   double xs, ys, xc, yc, angle, radius;
   
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_ARC_PLOT ), numargs, args );

   if (CurrentPlotWindow) // != NULL)
      {
      xs    = (double) int_value( args[0] );
      ys    = (double) int_value( args[1] );
      angle = (double) float_value( args[2] );
      xc    = (double) int_value( args[3] );
      yc    = (double) int_value( args[4] );

      if (fabs( angle ) >= TWO_PI)
         {
         double xr, yr;
   
         xr     = fabs( xs - xc );
         yr     = fabs( ys - yc );
         radius = sqrt( xr * xr + yr * yr );

         DrawCircle( CurrentPlotWindow->RPort, int_value( args[3] ), 
                                               int_value( args[4] ), 
                                               (int) radius
                   );
         }
      else if (angle < 0)
         {
         double ax, ay;
         int    i; 
                  
         Move( CurrentPlotWindow->RPort, int_value( args[0] ), int_value( args[1] ) );

         for (i = 0; i > -360; i--)          
            {
            double tx, ty;
            
            tx = xs - xc;
            ty = ys - yc;
            
            ax = tx * cos( i * PI_180 ) - ty * sin( i * PI_180 );
            ay = tx * sin( i * PI_180 ) + ty * cos( i * PI_180 );
            
            tx = ax + xc;
            ty = ay + yc;
            
            Draw( CurrentPlotWindow->RPort, (int) tx, (int) ty );

            if (fabs( ((double) i) * PI_180 ) > angle)
               break;
            }
         }
      else
         {
         double ax, ay;
         int    i; 

         Move( CurrentPlotWindow->RPort, int_value( args[0] ), int_value( args[1] ) );

         for (i = 0; i < 360; i++)          
            {
            double tx, ty;
            
            tx = xs - xc;
            ty = ys - yc;
            
            ax = tx * cos( i * PI_180 ) - ty * sin( i * PI_180 );
            ay = tx * sin( i * PI_180 ) + ty * cos( i * PI_180 );
            
            tx = ax + xc;
            ty = ay + yc;
            
            Draw( CurrentPlotWindow->RPort, (int) tx, (int) ty );

            if (((double) i) * PI_180 > angle)
               break;
            }
         }

      RefreshWindowFrame(    CurrentPlotWindow );
      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_true );
}

/****h* PlotEnv() [1.5] **********************************************
*
* NAME
*    PlotEnv( 1, title, width, height )  Open  a Plot3 Window.
*    PlotEnv( 0, title )                 Close a Plot3 Window.
*    PlotEnv( 2, title, x, y )           Move  a Plot3 Window.
*
* DESCRIPTION
*    Open & Close the Plot3 Environment (primitive 169).
*    Return a o_true Object if successful, o_false if not.
**********************************************************************
*
*/

PUBLIC OBJECT *PlotEnv( int numargs, OBJECT **args )
{
   IMPORT struct Screen *Scr; // in Main.c file.

   int plotFunction = int_value( args[0] );

   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_ENV_PLOT ), numargs, args );

   // Argument types & number of arg's have already been checked.
   switch (plotFunction)
      {
      default:
         sprintf( ErrMsg, PlotCMsg( MSG_FMT_PEN_ERR_PLOT ), plotFunction );

         UserInfo( ErrMsg, ATalkProblem );

         return( o_false );
         
      case 2:
         return( MovePlotEnvironment( numargs, args ) );

      case 1:
         {
         char *plotname = (char *) string_value( (STRING *) args[1] );
         int   width    = int_value( args[2] );
         int   height   = int_value( args[3] );
         int   newindex = -1;
      
         if ((plotenvcount + 1) > MAX_PLOTENV) // Check the guard.
            {
            sprintf( ErrMsg, PlotCMsg( MSG_FMT_TOO_MANY_PLOTS_PLOT ), MAX_PLOTENV );

            UserInfo( ErrMsg, UserProblem );

            return( o_false );
            }
      
         newindex = FindVacantPlotEnv( &PlotList[0] );

         if (newindex >= 0)
            {
            struct Window *wptr = NULL;
         
            PlotList[ newindex ].pe_PlotName = plotname;
         
            wptr = OpenWindowTags( &hidden_pw,

                                   WA_Title,             plotname,
                                   WA_Width,             width,
                                   WA_Height,            height,
                                   WA_PubScreen,         Scr, 
                                   WA_PubScreenFallBack, TRUE,
                                   TAG_END
                                 );
            if (wptr) // != NULL)
               {
               PlotList[ newindex ].pe_PlotWindow = wptr; 

               CurrentPlotWindow = wptr; // Only one active plot at a time.

               WindowToFront( CurrentPlotWindow );

               (void) ActivateWindow( CurrentPlotWindow );

               plotenvcount++;   // Increment safety guard.
               return( o_true ); // Valid exit point.
               }
            else
               {
               // The Plot3 Window didn't open!!
               PlotList[ newindex ].pe_PlotName = NULL;
               
               sprintf( ErrMsg, PlotCMsg( MSG_FMT_PLOT_WINDOW_PLOT ), plotname );

               NotOpened( 1 );

               return( o_false );
               }
            }
         else
            {
            // This is probably an impossible condition:
            sprintf( ErrMsg, PlotCMsg( MSG_PL_IMPOSSIBLE_PLOT ) );

            UserInfo( ErrMsg, ATalkProblem );

            return( o_false );
            }
         }

      case 0: // Close a Plot3 Window:
         {
         char *plotname = (char *) string_value( (STRING *) args[1] );
         int   i = 0;

         while (i < MAX_PLOTENV)
            {
            if (PlotList[i].pe_PlotName) // != NULL) // Kill Enforcer hits.
               {
               if (StringComp( PlotList[ i ].pe_PlotName, plotname ) == 0)
                  {
                  if (plotenvcount > 0) // Check the guard.
                     {
                     int j = MAX_PLOTENV;
                  
                     plotenvcount--; // Decrement safety guard.
                     CloseWindow( PlotList[i].pe_PlotWindow );

                     PlotList[i].pe_PlotWindow = NULL;
                     PlotList[i].pe_PlotName   = NULL;
               
                     while (j > 0) // Activate the next PlotWindow:
                        {
                        if (PlotList[j].pe_PlotWindow) // != NULL)
                           {
                           CurrentPlotWindow = PlotList[j].pe_PlotWindow;

                           WindowToFront( CurrentPlotWindow );

                           (void) ActivateWindow( CurrentPlotWindow );

                           return( o_true );
                           }
                  
                        j--;
                        }

                     return( o_true );
                     }
                  else  // Guard says User is crazed!!                     
                     {
                     // All Plot3 Windows are already closed:
                     CurrentPlotWindow = NULL;

                     sprintf( ErrMsg, PlotCMsg( MSG_PL_ALL_CLOSED_PLOT ) );

                     UserInfo( ErrMsg, UserProblem );

                     return( o_false );
                     }
                  }
               }

            i++;
            }     // END while (i < MAX_PLOTENV)
         }        // END case 0:
      }           // END switch( plotFunction )

   return( o_false ); // S/B unreachable!!
}

/****i* GetBkgPen() [1.0] ********************************************
*
* NAME
*    GetBkgPen( void )
*
* DESCRIPTION
*    Get the pen number to erase the Plot3 interface with.
**********************************************************************
*
*/

PRIVATE int GetBkgPen( struct Window *wptr )
{
   struct Screen   *scr  = wptr->WScreen;
   struct DrawInfo *di   = GetScreenDrawInfo( scr );
   int              rval = 0;

   if (di) // != NULL)   
      {
      rval = (int) di->dri_Pens[ BACKGROUNDPEN ];
      FreeScreenDrawInfo( scr, di );
      }
   else
      rval = wptr->WScreen->BlockPen;
      
   return( rval );
}

/****h* PlotClear() [1.5] ********************************************
*
* NAME
*    PlotClear( void )
*
* DESCRIPTION
*    Clear the screen, using the Plot interface (170).
**********************************************************************
*
*/

PUBLIC OBJECT *PlotClear( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_CLEAR_PLOT ), numargs, args );

   // No arguments, so no error checking has to be done!

   if (CurrentPlotWindow) // != NULL)
      {
      int erasePen = GetBkgPen( CurrentPlotWindow );

      SetAPen( CurrentPlotWindow->RPort, erasePen );

      RectFill( CurrentPlotWindow->RPort,
                CurrentPlotWindow->BorderLeft,
                CurrentPlotWindow->BorderTop,
                CurrentPlotWindow->Width - CurrentPlotWindow->BorderRight 
                                         - 1,
                CurrentPlotWindow->Height - 1
                        - CurrentPlotWindow->BorderBottom                
              );

      RefreshWindowFrame(    CurrentPlotWindow );
      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

/****h* PlotMove() [1.5] *********************************************
*
* NAME
*    PlotMove( x, y )  (171)
*
* DESCRIPTION
*    Move the cursor to the given location (move( x, y )).
**********************************************************************
*
*/

PUBLIC OBJECT *PlotMove( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_MOVE_PLOT ), numargs, args );

   // Error Checking already done!
   if (CurrentPlotWindow) // != NULL)
      {
      Move( CurrentPlotWindow->RPort, leftint, rightint );

      RefreshWindowFrame(    CurrentPlotWindow );
      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

/****h* PlotContinue() [1.5] *****************************************
*
* NAME
*    PlotContinue( x, y ) (172) 
*
* DESCRIPTION
*    Draw a line from the current position to the position given
*    by the two argument coordinates.
**********************************************************************
*
*/

PUBLIC OBJECT *PlotContinue( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_CONT_PLOT ), numargs, args );

   // Error Checking already done!
   if (CurrentPlotWindow) // != NULL)
      {
      Draw( CurrentPlotWindow->RPort, leftint, rightint );

      RefreshWindowFrame(    CurrentPlotWindow );
      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

/****h* PlotPoint() [1.5] ********************************************
*
* NAME
*    PlotPoint( x, y )   (173)
*
* DESCRIPTION
*    Draw a point at the given coordinates.
**********************************************************************
*
*/

PUBLIC OBJECT *PlotPoint( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_POINT_PLOT ), numargs, args );

   // Error Checking already done!
   if (CurrentPlotWindow) // != NULL)
      {
      WritePixel( CurrentPlotWindow->RPort, leftint, rightint );

      RefreshWindowFrame(    CurrentPlotWindow );
      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

/****h* PlotCircle() [1.5] *******************************************
*
* NAME
*    PlotCircle()  (174)
*
* DESCRIPTION
*    Draw a circle at the center point (Arg1, Arg2) with the given
*    radius (Arg3).
**********************************************************************
*
*/

PUBLIC OBJECT *PlotCircle( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_CIRCLE_PLOT ), numargs, args );

   if (CurrentPlotWindow) // != NULL)
      {
      DrawCircle( CurrentPlotWindow->RPort, int_value( args[0] ), 
                                            int_value( args[1] ), 
                                            int_value( args[2] )
                );

      RefreshWindowFrame(    CurrentPlotWindow );
      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

/****h* PlotBox() [1.5] **********************************************
*
* NAME
*    PlotBox()  (175)
*
* DESCRIPTION
*    Draw a Box( x1, y1, x2, y2 ).
**********************************************************************
*
*/

PUBLIC OBJECT *PlotBox( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_BOX_PLOT ), numargs, args );

   // Error Checking already done!
   if (CurrentPlotWindow) // != NULL)
      {
      int x2, y2; 
      
      x2 = abs( i - leftint  );  // Convert width & height to (x,y) coord's
      y2 = abs( j - rightint );

      Move( CurrentPlotWindow->RPort, leftint, rightint );
      Draw( CurrentPlotWindow->RPort, x2,      rightint );
      Draw( CurrentPlotWindow->RPort, x2,      y2       );
      Draw( CurrentPlotWindow->RPort, leftint, y2       );
      Draw( CurrentPlotWindow->RPort, leftint, rightint );

      RefreshWindowFrame(    CurrentPlotWindow );
      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

/****h* PlotSetPens() [1.5] ******************************************
*
* NAME
*    PlotSetPens()  (1.5)
*
* DESCRIPTION
*    Set the Front & Background plotting colors.
**********************************************************************
*
*/

PUBLIC OBJECT *PlotSetPens( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_SETPENS_PLOT ), numargs, args );

   // Error Checking already done!
   if (CurrentPlotWindow) // != NULL)
      {
      SetAPen( CurrentPlotWindow->RPort, leftint  );
      SetBPen( CurrentPlotWindow->RPort, rightint );

      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

/****h* PlotLine() [1.5] *********************************************
*
* NAME
*    PlotLine()  (177)
*
* DESCRIPTION
*    Draw a line from one point to another.
**********************************************************************
*
*/

PUBLIC OBJECT *PlotLine( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_LINE_PLOT ), numargs, args );

   // Error Checking already done!
   if (CurrentPlotWindow) // != NULL)
      {
      Move( CurrentPlotWindow->RPort, leftint, rightint );
      Draw( CurrentPlotWindow->RPort, i,       j        );

      RefreshWindowFrame(    CurrentPlotWindow );
      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

/****h* PlotLabel() [1.5] ********************************************
*
* NAME
*    PlotLabel( text, x, y )  (178)
*
* DESCRIPTION
*    Print a label at the given location.  This call is NOT
*    the same as the one used in Little Smalltalk.  We need three
*    arguments, one string of text & two integers.
*
* TODO
*    Keep the text from over-writing the Window Border by clipping it.
**********************************************************************
*
*/

PUBLIC OBJECT *PlotLabel( int numargs, OBJECT **args )
{
   struct IntuiText it = { 0, };
    
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_LABEL_PLOT ), numargs, args );

   // Error Checking already done!
   if (CurrentPlotWindow) // != NULL)
      {
      it.IText    = (UBYTE*) leftp; // The text from the user.
      it.LeftEdge = int_value( args[1] );
      it.TopEdge  = int_value( args[2] );
      it.DrawMode = JAM1;
      it.FrontPen = int_value( args[3] );
      it.BackPen  = int_value( args[4] );
            
      PrintIText( CurrentPlotWindow->RPort, &it, 0, 0 );

      RefreshWindowFrame(    CurrentPlotWindow );
      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

/****h* PlotLineType() [1.5] *****************************************
*
* NAME
*    PlotLineType( bitpattern )  (179)
*
* DESCRIPTION
*    Establish a line type for the plotter.  This call is NOT
*    the same as the one used in Little Smalltalk.  We need an
*    integer argument, not a string.
**********************************************************************
*
*/
   
PUBLIC OBJECT *PlotLineType( int numargs, OBJECT **args )
{
   if (debug == TRUE)
      fprintf( stderr, PlotCMsg( MSG_PL_PLOT_LINETYPE_PLOT ), numargs, args );

   // Error Checking already done!
   if (CurrentPlotWindow) // != NULL)
      {
      SetDrPt( CurrentPlotWindow->RPort, leftint );

      WindowToFront(         CurrentPlotWindow );
      (void) ActivateWindow( CurrentPlotWindow );
      }

   return( o_nil );
}

#endif // PLOT3

/* ------------------- END of PlotFuncs.c file! ------------------- */
