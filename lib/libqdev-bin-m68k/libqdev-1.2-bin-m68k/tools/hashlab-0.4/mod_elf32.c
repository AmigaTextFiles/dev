/*
 * mod_elf32.hl
 *
 * This  function  was  stripped from Arash Partow "General Hash
 * Function Source Code" available at:
 *
 *    http://partow.net/programming/hashfunctions/index.html
 *
 * Warning! What you see here differs a bit in construction from
 * the original!
*/

#define MOD_XXX_VERSION    1
#define MOD_XXX_REVISION   0
#define MOD_XXX_STRING     "mod_elf32.hl"
#define MOD_XXX_DATESTR    "(25/07/2011)"



#include "hashlab.h"

_HASHLAB_MODULEHEADER(MOD_XXX_STRING, MOD_XXX_VERSION,
                          MOD_XXX_REVISION, MOD_XXX_DATESTR)



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

/*
 * ELF Hash Function - Same results as PJW32!
*/
LONG _HASHLAB_MODULERFUNC(void *ptr, VUQ128 *vu, UBYTE *str)
{
  UBYTE *strreg = str;
  ULONG hash = 0;
  ULONG test = 0;


  vu->vuhi_hi = 0;

  vu->vuhi_lo = 0;

  vu->vulo_hi = 0;

  while(*strreg)
  {
    hash = (hash << 4) + (*strreg++);

    if ((test = hash & 0xF0000000L))
    {
      hash ^= (test >> 24);
    }

    hash &= ~test;
  }

  vu->vulo_lo = hash;

  return _HASHLAB_R_ALLOKAY;
}
