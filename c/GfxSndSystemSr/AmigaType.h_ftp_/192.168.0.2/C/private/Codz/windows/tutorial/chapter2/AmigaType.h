//===========================================================================
//
// Amiga Demo Tutorial - Alain Bocherens [alain@devils.ch]
//
// Nom: AmigaType.h
//
// Classes: -
//
// Fonction: definitions de types
//
//===========================================================================

//---------------------------------------------------------------------------
// Includes
//---------------------------------------------------------------------------
#ifndef _AMIGAINCLUDE
#define _AMIGAINCLUDE

#include <exec/exec.h>
#include <intuition/intuition.h>
#include <stdio.h>
#include <stdlib.h>
#include <proto/all.h>
#include <string.h>

struct PALETTEENTRY
{
  BYTE peRed;
  BYTE peGreen;
  BYTE peBlue;
};

#endif