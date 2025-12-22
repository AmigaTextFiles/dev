/* ==========================================================================
**
**                               pcgWindow.h
**
** PObject<GraphicObject<Interactor<pcgWindow
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef PCGWINDOW_H
#define PCGWINDOW_H


#include <intuition/intuition.h>
#include "PObject.h"
#include "Interactor.h"

typedef struct pcgWindow
   {
      PClass                 *isa;
      char                  *PObjectName;
      void                  *Next;      /* Not used. */
      struct pcgWindow      *IaWindow;  /* not used. */
      Point                  Location;
      Point                  Size;
      struct NewWindow       NewWindow;
      struct Window         *Window;
      ULONG                  IDCMPFlags;
      struct Interactor     *FirstInteractor;
      struct GraphicObject  *FirstGraphic;
      struct MsgPort        *SharedUserPort;
      Menu                  *MenuStrip;
   } pcgWindow;

/*
   The field 'IDCMPFlags' maintains the current IDCMP values.  The field
   NewWindow.IDCMPFlags contains the bare minimum IDCMP values that the
   window must have.  (Other IDCMP flags are set automagically by adding
   Interactors to the window.

   NOTE: If SharedUserPort is not NULL, it is assumed to be a pointer to
   a valid MessagePort structure, and that the window is to use this
   MessagePort as its UserPort instead of creating its own.

   This is useful for having multiple windows sharing one MessagePort.
   (See the Amiga 1.3 RKMs:  Libraries and Devices, Chapter 7, page 171
   for more details on sharing UserPorts.
 */




void pcgWindow_Init __PARMS((
                     pcgWindow     *self,
                     UWORD          leftedge,
                     UWORD          topedge,
                     UWORD          width,
                     UWORD          height,
                     UWORD          minwidth,
                     UWORD          minheight,
                     UWORD          maxwidth,
                     UWORD          maxheight,
                     char          *title,
                     ULONG          IDCMPFlags,
                     ULONG          flags,
                     struct Screen *screen
                   ));



struct Window *pcgOpenWindow __PARMS((
                  pcgWindow *self
                  ));

void pcgCloseWindow __PARMS((
                        pcgWindow  *self
                     ));

struct Window *iWindow __PARMS(( pcgWindow *self ));
   /* returns a pointer to the Intuition window. */

RastPort *RPort __PARMS(( pcgWindow *self ));

ULONG SetIDCMPFlags __PARMS((
                        pcgWindow *self,
                        ULONG newflags
                   ));


void AddWindowPObject  __PARMS((
                         pcgWindow       *window,
                         GraphicObject   *graphic
                      ));


void RemoveWindowPObject __PARMS((
                           pcgWindow      *window,
                           GraphicObject  *graphic
                        ));


void AddMenuStrip __PARMS((
                     pcgWindow *window, Menu *menustrip
                 ));


void RemoveMenuStrip __PARMS((
                        pcgWindow *window
                    ));

/* Additions for missing Builder prototypes -- EDB */

void AddInteractor __PARMS(( pcgWindow *self, Interactor *interactor ));

void AddGraphicObject __PARMS(( pcgWindow *self, GraphicObject *graphic ));


#endif
