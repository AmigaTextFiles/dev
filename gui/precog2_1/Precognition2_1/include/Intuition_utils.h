#ifndef INTUITION_UTILS_H
#define INTUITION_UTILS_H

#include <exec/types.h>
#include <intuition/intuition.h>
#include <intuition/screens.h>
#include <graphics/gfx.h>        /* for type 'Point' */

#include "parms.h"

/* ~~~~~~~~~~~~~~~~~~~ Intuition_Utils ~~~~~~~~~~~~~~~~~~~~~~~~~~

   This is a collection of handy Intuition-related utilities.
   These do not depend on any of the Precognition types or routines
   and can be reused outside of the Precognition environment.

   Note: the strange comment headers are for use with a tool
   which automatically builds man pages from the comments.
*/


/*F:is_Workbench_v2*

----------------------------------------------------

         is_Workbench_v2

----------------------------------------------------

Name:    is_Workbench_v2 - returns TRUE if running AmigaDOS version >= 2.0
Syntax:  | result = is_Workbench_v2();
         | BOOL result;
Author:  Lee R. Willis
*/

BOOL is_Workbench_v2 __PARMS(( void ));



/*F:is_Workbench_v2_1*

----------------------------------------------------

         is_Workbench_v2_1

----------------------------------------------------

Name:    is_Workbench_v2_1 - returns TRUE if running AmigaDOS version >= 2.1
Syntax:  | result = is_Workbench_v2_1();
         | BOOL result;
Author:  Edward D. Berger, Lee R. Willis
*/

BOOL is_Workbench_v2_1 __PARMS(( void ));



/*F:is_Workbench_v3*

----------------------------------------------------

         is_Workbench_v3

----------------------------------------------------

Name:    is_Workbench_v3 - returns TRUE if running AmigaDOS version >= 3.0
Syntax:  | result = is_Workbench_v3();
         | BOOL result;
Author:  Edward D. Berger, Lee R. Willis
*/

BOOL is_Workbench_v3 __PARMS(( void ));



/*F:is_Workbench_v3_1*

----------------------------------------------------

         is_Workbench_v3_1

----------------------------------------------------

Name:    is_Workbench_v3_1 - returns TRUE if running AmigaDOS version >= 3.1
Syntax:  | result = is_Workbench_v3_1();
         | BOOL result;
Author:  Edward D. Berger, Lee R. Willis
*/

BOOL is_Workbench_v3_1 __PARMS(( void ));



/*F:GadgetRelativeCoords*

----------------------------------------------------

               GadgetRelativeCoords

----------------------------------------------------

Name:          GadgetRelativeCoords - translates mouse coords relative to gadget
Syntax:        | GadgetRelativeCoords( gadget, event, point );
               | struct Gadget *gadget;
               | struct IntuiMessage *event;
               | Point *point;
Description:   'GadgetRelativeCoords()' is a function which translates
               the MouseX and MouseY fields of an IntuiMessage to be
               relative the supplied gadget.  (MouseX and MouseY are
               returned by Intuition relative to the window, not the
               gadget.)

Notes:         AmigaDOS version 2.0 intuition.library has
               a built-in function to do this.

Author:  Lee R. Willis
*/

void GadgetRelativeCoords __PARMS(( struct Gadget       *gadget,
                           struct IntuiMessage *event,
                           Point               *point ));



/*F:SetWaitPointer*

-------------------------------------------------

               SetWaitPointer

-------------------------------------------------

Name:          SetWaitPointer - sets the pointer to the standard 2.0 'clock'.
Syntax:        | SetWaitPointer( w );
               | struct Window *w;
Description:   'SetWaitPointer()' sets the mouse pointer to look like
               the standard Workbench 2.0 wait pointer (a clock).
Author:        Lee R. Willis
*/

void SetWaitPointer __PARMS(( struct Window *w ));


/*F:WaitForMessage

----------------------------------------------------

               WaitForMessage

----------------------------------------------------

Name:          WaitForMessage - waits for and returns an IntuiMessage.
Syntax:        | imgs = WaitForMessage( mport );
               | struct IntuiMessage *imsg;
               | struct MsgPort *mport;

Description:   Most Intuition event loops start out with the
               following statements to get a message:
               |
               | for(;;)
               | {
               |    msg = (struct IntuiMessage*) GetMsg( window->UserPort );
               |    if (msg == NULL)
               |    {
               |       WaitPort(window->UserPort);
               |       continue;
               |    }
               |
               This grabs a message from the port, and if no message is there,
               does a Wait, and tries again.  I always found this code
               somewhat confusing and very ugly.  So I wrote WaitForMessage
               to hide it.

               'WaitForMessage()' does not return until it finds a message,
               so the above code can be replaced by:
               |
               | for(;;)
               | {
               |    msg = WaitForMessage( window->UserPort );
               |

Author:        Lee R. Willis
*/


struct IntuiMessage *WaitForMessage __PARMS(( struct MsgPort *mport ));


/*F:OpenWindowWithSharedUserPort*

------------------------------------------------------------

               OpenWindowWithSharedUserPort

------------------------------------------------------------

Name:          OpenWindowWithSharedUserPort - opens a window with a shared port.
Syntax:        | window = OpenWindowWithSharedPort( nw, port );
               | struct Window    *window;
               | struct NewWindow *nw;
               | struct MsgPort   *port;

Description:   To handle multiple windows within the one application, the
               best method (usually) is to have all the windows share the
               same UserPort.  This way, one can still do a 'WaitPort()' or
               'WaitForMessage()'.  (Otherwise one has to mess with signal
               bits.)

               In order to force a window to have a specific UserPort, one
               must first create the port (using 'CreatePort()'), and then
               there is a sequence of steps involved in opening the window.
               (This is described in the 1.3 RKM Libraries and Devices manual
               on page 167 "SETTING UP YOUR OWN IDCMP MONITOR TASK AND USER
               PORT")

               'OpenWindowWithSharedPort()' does all the steps after the
               creation of the MsgPort.   All you do is pass in the NewWindow
               structure and the message port, and
               'OpenWindowWithSharedUserPort' will open the window and do
               the UserPort setup.

Note:          Windows opened with this function must be closed using
               'CloseWindowWithSharedUserPort()', NOT 'CloseWindow()'!

See Also:      CloseWindowWithSharedUserPort
Author:        Lee R. Willis
*/

struct Window *OpenWindowWithSharedUserPort __PARMS(( struct NewWindow *nw,
                                             struct MsgPort   *shared ));


/*F:CloseWindowWithSharedUserPort*

------------------------------------------------------------

               CloseWindowWithSharedUserPort

------------------------------------------------------------

Name:          CloseWindowWithSharedUserPort - closes a window with a shared port.
Syntax:        | CloseWindowWithSharedPort( w );
               | struct Window *w;
Description:   To handle multiple windows within the one application, the
               best method (usually) is to have all the windows share the
               same UserPort.  This way, one still to a 'WaitPort()' or
               'WaitForMessage()'.  (Otherwise one has to mess with signal
               bits.)

               Closing such a window requires some care, as Intuition normally
               deallocates the UserPort for such a window on closing, and
               since the port is shared, other windows are still using it!
               (This is described in the 1.3 RKM Libraries and Devices manual
               on page 167 "SETTING UP YOUR OWN IDCMP MONITOR TASK AND USER
               PORT")

               'CloseWindowWithSharedUserPort()' does all this for you.

See Also:      OpenWindowWithSharedUserPort
Author:        Lee R. Willis
*/

void CloseWindowWithSharedUserPort __PARMS(( struct Window *w ));
   /* Taken from 1.3 RKM:L&D, page 171 'CloseWindowSafely' */


/*F:WindowSanityCheck

------------------------------------------------------------

               WindowSanityCheck

------------------------------------------------------------

Name:          WindowSanityCheck - checks the size and location of a window
Syntax:        | ok = WindowSanityCheck( screen, location, size );
               | BOOL ok;
               | struct Screen *screen;
               | Point *location;
               | Point *size;

Description:   WindowSanityCheck checks a proposed new size and location
               for a window to make sure those dimensions will not exceed
               the screen size.

               WindowSanityCheck returns TRUE if the proposed dimensions
               are ok, and FALSE if the window dimensions must be changed.
               If the return is FALSE, the values of 'location' and 'size'
               are returned modified to the closest legal dimensions.

Author:        Lee R. Willis
*/

BOOL WindowSanityCheck __PARMS(( struct Screen *screen,
                        Point         *location,
                        Point         *size ));


/*F:SmartOpenScreen

-----------------------------------------------------------------

               SmartOpenScreen

-----------------------------------------------------------------

Name:          SmartOpenScreen - Opens a screen in WB2.0 style if appropriate.
Syntax:        | screen = SmartOpenScreen( newscreen );
               | struct Screen *screen;
               | struct NewScreen *newscreen;

Description:   SmartOpenScreen opens a screen.  If you're running under
               1.3, it just calls OpenScreen.  If you're running under
               2.0, it does the minimal processing required so that windows
               on the screen get the 3D look.

Author:        Lee R Willis
*/

struct Screen *SmartOpenScreen __PARMS(( struct NewScreen *newscreen ));


/*F:SmartOpenScreen

-----------------------------------------------------------------

               SmartOpenWindow

-----------------------------------------------------------------

Name:          SmartOpenScreen - Opens a screen in WB3.0 style if appropriate.
Syntax:        | window = SmartOpenWindow( newwindow );
               | struct Window *window;
               | struct NewWindow *newwindow;

Description:   SmartOpenWindow opens a window.  If you're running under
               1.3, it just calls OpenWindow.  If you're running under
               3.0, it does the minimal processing required so that menus
               under 3.0 Amiga OS get the new black text on white background
               look. This also requires a change to the menu code as well.


Author:        Edward D. Berger
*/

struct Window *SmartOpenWindow __PARMS(( struct NewWindow *newwindow ));


/*F:RemapImage

------------------------------------------------------------------

      RemapImage

------------------------------------------------------------------

Name:          RemapImage() - flips planes 1&2 of an image
Syntax:        | RemapImage( image );
               | struct Image *image;

Description:   RemapImage exchanges the first two planes of an image data
               structure.  This converts from the look of Workbench 1.2/3
               to the look of Workbench 2.0.

               It ASSUMES that there are two planes (i.e. don't feed
               it PlanePick'ed images.)

Author:        Lee R Willis
*/
void RemapImage __PARMS(( struct Image *image ));

#endif
