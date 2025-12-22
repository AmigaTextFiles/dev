/*
 * mod_fnv128ai.hl
 *
 * True monster! 128 bits!
*/

#define MOD_XXX_VERSION    5
#define MOD_XXX_REVISION   0
#define MOD_XXX_STRING     "mod_fnv128ai.hl"
#define MOD_XXX_DATESTR    "(19/08/2014)"



#include "hashlab.h"

_HASHLAB_MODULEHEADER(MOD_XXX_STRING, MOD_XXX_VERSION,
                          MOD_XXX_REVISION, MOD_XXX_DATESTR)



static struct _hashlab hl;



void *_HASHLAB_MODULEIFUNC(void)
{
  hl.hl_text = MOD_XXX_STRING;

  hl.hl_ver = MOD_XXX_VERSION;

  hl.hl_rev = MOD_XXX_REVISION;

  hl.hl_flags = _HASHLAB_F_EQCASE | _HASHLAB_F_128BIT;

  return &hl;
}

void _HASHLAB_MODULECFUNC(void *ptr)
{
}

LONG _HASHLAB_MODULERFUNC(void *ptr, VUQ128 *vu, UBYTE *str)
{
  txt_fnv128ihash(vu, str);

  return _HASHLAB_R_ALLOKAY;
}
