/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/IntuiRoot.cxx,v $
 **   $Revision: 1.1 $
 **   $Date: 1994/07/27 11:49:28 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/intuition/IntuiRoot.h>


static const char rcs_id[] = "$Id: IntuiRoot.cxx,v 1.1 1994/07/27 11:49:28 Armin_Vogt Exp Armin_Vogt $";


/*------------------------- IntuiRoot methods --------------------------------*/

// initialise global static variable
IntuiRoot* IntuiRoot::APPIntuiRoot = NULL;

// runtime type inquiry support
intui_typeinfo(IntuiRoot, derived(from(ScreenC)), rcs_id)


IntuiRoot::IntuiRoot() : ScreenC(NULL,(UBYTE*)NULL)
{
   iob_count = 0;
   _dprintf("IntuiRoot initialised.\n");
}

IntuiRoot::~IntuiRoot()
{
   _dprintf("IntuiRoot::~IntuiRoot()\n");

   FOREACHSAFE(IntuiObject,this)
   {
      _dprintf("kill status=%ld at %lx\n ",node->status(),(APTR)node);
      delete node;
      _dprintf("\tkilled.\n");
   }
   NEXTSAFE
   _dprintf("IntuiRoot::~IntuiRoot() done.\n");

   /** This may prevent executing setAttributes() on a deleted object.
    ** But its the sendNotification() routine duty to check for the integrity of each
    ** addressed IntuiObject before calling setAttributes on it.
    ** Otherwise this may become a source of random enforcer hits when the deleted
    ** object's memory  may already have been overwritten or not!
    **/
   setAttributesIsRecurrent = TRUE;
}

BOOL IntuiRoot::APPinitialise(int argc, char* argv[])
   /* MUST be called before creating any A++ IntuiObject classes.
   */
{
   APPIntuiRoot = new IntuiRoot;
   if (APPOK(APPIntuiRoot))
   {
      _dprintf("IntuiRoot initialised.\n");
      return TRUE;
   }
   else return FALSE;
}

void IntuiRoot::APPexit()
{
   if (APPIntuiRoot)
   {
      delete APPIntuiRoot;
      APPIntuiRoot = NULL;
   }
}



int main(int argc,char *argv[])
{
   if (IntuiRoot::APPinitialise(argc,argv))
   {
      APPmain(argc,argv);     // user main
      IntuiRoot::APPexit();   // destroy all IntuiObjects
      return 0;
   }
   else
   {
      puterr("FATAL ERROR: could not create IntuiRoot! Programm exits.\n");
      return 1;
   }
}