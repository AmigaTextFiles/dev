/* ==========================================================================
**
**                   EmbossedGadget.h
**
** NOTE: EmbossedGadget is not a 'TRUE' object class.  Rather it is a
** a collection of routines that are shared by many different Interactor
** classes which have embossed gadgets as part of their structure.
**
** (This 'phony' class is a result of not having multiple inheritance
** in my PObject Oriented C paradigm.)
**
**           Lee Willis
**
**
** ©1991 WILLISoft
**
** ==========================================================================
*/

#ifndef EMBOSSEDGADGET_H
#define EMBOSSEDGADGET_H

#include "precognition3d.h"
#include "Interactor.h"
#include "pcgWindow.h"




typedef struct EmbossedGadget /* Gadget with a 3D border. */
   {
      const PClass             *isa;
      char              *PObjectName;
      void              *Next;
      struct pcgWindow  *IaWindow;
      Point              Location;
      Point              Size;
      pcg_3DPens         Pens;
      USHORT             state;    /* private! */
      ULONG              IDCMPbuf; /* private! */
      pcg_3DBox         *BoxBorder;
      PrecogText         LabelText;
      Gadget             g;
   } EmbossedGadget;

   /*
   ** NOTE: For gadgets where the border *exceeds* the hitbox,
   ** (i.e. PropGadgets, StringGadgets) 'Location' and 'Size'
   ** are the dimensions including the border.
   */

#define GADGDURATION (RELVERIFY | GADGIMMEDIATE)
/* By setting Activation = GADGDURATION, an embossed gadget will
** receive messages as long as its pressed.
*/



#endif
