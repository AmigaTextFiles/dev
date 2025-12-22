/******************************************************************************
 **
 **	C++ Class Library for the Amiga© system software.
 **
 **	Copyright (C) 1994 by Armin Vogt  **  EMail: armin@uni-paderborn.de
 **	All Rights Reserved.
 **
 **	$Source: apphome:RCS/libsource/Intui_TypeInfo.cxx,v $
 **	$Revision: 1.2 $
 **	$Date: 1994/07/27 11:50:37 $
 **	$Author: Armin_Vogt $
 **
 ******************************************************************************/


#include <APlusPlus/intuition/Intui_TypeInfo.h>


static const char rcs_id[] = "$Id: Intui_TypeInfo.cxx,v 1.2 1994/07/27 11:50:37 Armin_Vogt Exp Armin_Vogt $";

// runtime type inquiry support
typeinfo(Intui_Type_info, derived(from(Type_info)), rcs_id)


Intui_Type_info::Intui_Type_info(const char *name, const Type_info* bases[],const char* id)
   : Type_info(name,bases,id)
{
   
}

Intui_Type_info::~Intui_Type_info()
{
}