/* ==========================================================================
**
**                               Interactor.h
**
** PObject<GraphicObject<Interactor
**
** An Interactor is a virtual class, derrived from class GraphicObject.
** Interactors are things with which the user interacts.
** (generally gadgets (or sets of gadgets)).
**
** Along with the functions prototyped here, you can also use the
** the funtions defined for a GraphicObject. (See GraphicObject.h)
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef INTERACTOR_H
#define INTERACTOR_H

#include "GraphicObject.h"
#include "Intuition_typedefs.h"



typedef struct Interactor
   {
      const PClass             *isa;
      char              *PObjectName;
      void              *Next;   /* Points to next Interactor in chain. */
      struct pcgWindow  *IaWindow; /* window where this interactor lives. */
      Point              Location;
      Point              Size;
   } Interactor;

   /*
   ** NOTE: Do *NOT* set these fields directly!  Instead, use the
   ** supplied methods 'SetInteractorWindow()', 'SetLocation()',
   ** 'SetSize()' etc.  There is more to setting the window/location/size
   ** of a interactor than simply assigning to these fields.
   */



/*
** NOTE: Interactor & pcgWindow have circular dependencies.
** Each contain pointers to the other.
*/


void Interactor_Init __PARMS((
                        Interactor *self
                ));



struct pcgWindow *InteractorWindow __PARMS((
                                    Interactor *self
                              ));
   /*
   ** Returns a pointer to the Precognition Window to which this
   ** interactor belongs. (or NULL)
   */


void SetInteractorWindow __PARMS((
                           Interactor *self,
                           struct pcgWindow *window
                    ));


struct Gadget *FirstGadget __PARMS((
                              Interactor *self
                      ));

   /*
   ** Returns the address of the first gadget in the interactor.
   ** If there are no gadgets, returns NULL.
   **
   ** This is useful for building composite Interactors out of
   ** other Interactors.
   */

USHORT nGadgets __PARMS((
                     Interactor *self
           ));
   /*
   ** Returns the # of gadgets in an interactor.
   */


ULONG IDCMPFlags __PARMS((
                     Interactor *self
              ));
   /*
   ** Returns the IDCMP flags that 'self' needs to function.
   */


USHORT ClaimEvent __PARMS((
                     Interactor    *self,
                     IntuiMessage *event
            ));
   /*
   ** Returns TRUE if 'self' would respond to 'event'.
   ** (This is useful to determine if an Interactor will respond before
   ** it actually does.)
   */


USHORT Respond __PARMS((
                     Interactor    *self,
                     IntuiMessage  *event
         ));
   /*
   ** Respond() is THE routine for Interactors.  Calling Respond()
   ** for an IntuiMessage tells the Interactor to do whatever it should
   ** do for that message.
   **
   ** Returns a response code with the following bits:
   **
   **    RESPONDED      : Interactor paid attention to this event.
   **                     If not set, Interactor ignored event.
   **
   **    CONSUMED_EVENT : Interactor guarantees that this event
   **                     is _only_ for this Interactor.  This signals
   **                     the event loop that it need not bother sending
   **                     this event to any other interactor.
   **
   **    CHANGED_STATE  : The event caused the Interactor to change state.
   **                     (e.g. Slider moved, text entered, button
   **                     pressed.)
   **                     Certain events (e.g. REFRESHWINDOW) cause
   **                     the Interactor to respond without changing
   **                     state.
   **
   **    DEACTIVATED    : The event caused the interactor to go from an active
   **                     to an inactive state (string gadgets)
   */

#define RESPONDED      1
#define CONSUMED_EVENT 2
#define CHANGED_STATE  4
#define DEACTIVATED    8

void Refresh __PARMS((
                     Interactor *self
              ));
   /* Draws a interactor to a window.
   **
   ** I know what you're thinking: "Class 'GraphicObject' already has a
   ** Render() methOD which does this, why do we need another?".  Because
   ** Render() draws to a RastPort, and the Intuition function to refresh
   ** Gadgets requires a pointer to a Window.  Therefore, we need a new
   ** method.  (although the default action of 'Refresh()' is simply to
   ** call 'Render() with the window's RastPort).
   */


BOOL EnableIactor __PARMS((
                     Interactor *self,
                     BOOL        enable
             ));
   /*
   ** This turns an Interactor On/Off.  i.e. 'EnableIactor( interactor, FALSE )'
   ** will ghost an interactor.  'EnableIactor( interactor, TRUE )' un-ghosts.
   */


BOOL isEnabled __PARMS((
                     Interactor *self
          ));





 /* These next two refer to Text-based Interactors only
 ** (i.e. String gadgets) All other interactors return FALSE.
 */

BOOL Activate __PARMS((
                     Interactor *self,
                     BOOL        activate
        ));

   /* If 'activate' = TRUE, Interactor gains control of keyboard.
   ** Returns FALSE if Interactor does not use the keyboard.
   */

BOOL isActive __PARMS((
                     Interactor *self
         ));



BOOL ActivateNext __PARMS((
                     Interactor *self
              ));
   /*
   ** Attempts to activate the next interactor in a chain.
   */


#endif

