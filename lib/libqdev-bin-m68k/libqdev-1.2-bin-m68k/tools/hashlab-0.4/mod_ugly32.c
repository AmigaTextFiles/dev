/*
 * mod_ugly32.hl
 *
 * This is the worst hashing routine ever created! It was made
 * for test purposes only of course :-] .
*/

#define MOD_XXX_VERSION    1
#define MOD_XXX_REVISION   0
#define MOD_XXX_STRING     "mod_ugly32.hl"
#define MOD_XXX_DATESTR    "(20/07/2011)"



#include "hashlab.h"

_HASHLAB_MODULEHEADER(MOD_XXX_STRING, MOD_XXX_VERSION,
                          MOD_XXX_REVISION, MOD_XXX_DATESTR)



#define ___HASHBASE  0x48415348     /* 'H' 'A' 'S' 'H'                      */



static struct _hashlab hl;



void *_HASHLAB_MODULEIFUNC(void)
{
  hl.hl_text = MOD_XXX_STRING;

  hl.hl_ver = MOD_XXX_VERSION;

  hl.hl_rev = MOD_XXX_REVISION;

  hl.hl_flags = _HASHLAB_F_32BIT;

  return &hl;
}

void _HASHLAB_MODULECFUNC(void *ptr)
{
}

LONG _HASHLAB_MODULERFUNC(void *ptr, VUQ128 *vu, UBYTE *str)
{
  UBYTE *strreg = str;
  ULONG hash = ___HASHBASE;
  ULONG value;


  vu->vuhi_hi = 0;

  vu->vuhi_lo = 0;

  vu->vulo_hi = 0;

  vu->vulo_lo = 0;

  if (strreg--)
  {
    while((value = *++strreg))
    {
      hash += value;

      hash -= (value << 8);

      hash -= (value << 16);

      hash += (value << 24);
    }

    vu->vulo_lo = hash;
  }

  return _HASHLAB_R_ALLOKAY;
}
