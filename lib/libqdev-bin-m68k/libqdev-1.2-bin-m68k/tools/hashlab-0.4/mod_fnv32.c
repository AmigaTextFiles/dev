/*
 * mod_fnv32.hl
 *
 * This  function  was  stripped from Arash Partow "General Hash
 * Function Source Code" available at:
 *
 *    http://partow.net/programming/hashfunctions/index.html
 *
 * Warning! What you see here differs a bit in construction from
 * the original!
 *
 * This hashing routine is most probably the best of all 32bit
 * competitors, plus its really simple. Prime numbers rule, FNV
 * rules!
*/

#define MOD_XXX_VERSION    1
#define MOD_XXX_REVISION   0
#define MOD_XXX_STRING     "mod_fnv32.hl"
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
 * FNV Hash Function.
*/
LONG _HASHLAB_MODULERFUNC(void *ptr, VUQ128 *vu, UBYTE *str)
{
  vu->vuhi_hi = 0;

  vu->vuhi_lo = 0;

  vu->vulo_hi = 0;

  vu->vulo_lo = QDEV_HLP_FNV32HASH(str);

  return _HASHLAB_R_ALLOKAY;
}
