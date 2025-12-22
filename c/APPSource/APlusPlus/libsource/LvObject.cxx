/******************************************************************************
 **
 **   C++ Class Library for the Amiga© system software.
 **
 **   Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **   All Rights Reserved.
 **
 **   $Source: apphome:RCS/libsource/LvObject.cxx,v $
 **   $Revision: 1.6 $
 **   $Date: 1994/07/27 11:50:56 $
 **   $Author: Armin_Vogt $
 **
 ******************************************************************************/

// Living Objects depend on the AMIPROC package by Doug Walker and Steve Krueger.
// At the moment it is therefore impossible to compile with GNU-C++.
#ifdef __SASC


#ifdef __SASC

extern "C" {
#ifdef __SASC
#include <proto/exec.h>
#endif
}

#include <APlusPlus/exec/LvObject.h>

static const char rcs_id[] = "$Id: LvObject.cxx,v 1.6 1994/07/27 11:50:56 Armin_Vogt Exp Armin_Vogt $";

// runtime type inquiry support
typeinfo(LivingObject, no_bases, rcs_id)


LivingObject::LivingObject()
{
   ap_msg = NULL;
}

BOOL LivingObject::activate()
{
   if (ap_msg) return TRUE;

   ap_msg = AmiProc_Start((int (*)(void*))func,(void*)this);
   return (ap_msg!=NULL);
}

LivingObject::~LivingObject()
{
   AmiProc_Wait(ap_msg);
}

BOOL LivingObject::isLiving()
{
   return (ap_msg!=NULL);
}

int LivingObject::func(void *thisPtr)
{
   return ((LivingObject*)thisPtr)->main();
}

#endif   // #ifdef __SASC

#endif
