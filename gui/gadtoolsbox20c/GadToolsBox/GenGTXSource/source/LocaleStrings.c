/*
**      $Filename: LocaleStrings.c
**      $Release: 1.0 $
**      $Revision: 38.1 $
**
**      Import locale strings.
**
**      (C) Copyright 1992 Jaba Development.
**          Written by Jan van den Baard
**/

#define STRINGARRAY
#include "GenGTXSource_locale.h"

#define Prototype       extern

UWORD                      NumAppStrings = ( sizeof( AppStrings ) / sizeof( struct AppString ));

Prototype struct AppString AppStrings[];
Prototype UWORD            NumAppStrings;


