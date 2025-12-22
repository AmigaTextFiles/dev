/*
 * mod_pjw64i.hl
 *
 * txt_pjw64ihash() wrapper. This routine aside from being,
 * so  simple  and  case  insensitive is amazingly good and
 * produces quite good hashes!
*/

#define MOD_XXX_VERSION    1
#define MOD_XXX_REVISION   0
#define MOD_XXX_STRING     "mod_pjw64i.hl"
#define MOD_XXX_DATESTR    "(20/07/2011)"



#include "hashlab.h"

_HASHLAB_MODULEHEADER(MOD_XXX_STRING, MOD_XXX_VERSION,
                          MOD_XXX_REVISION, MOD_XXX_DATESTR)



static struct _hashlab hl;



void *_HASHLAB_MODULEIFUNC(void)
{
  hl.hl_text = MOD_XXX_STRING;

  hl.hl_ver = MOD_XXX_VERSION;

  hl.hl_rev = MOD_XXX_REVISION;

  hl.hl_flags = _HASHLAB_F_EQCASE | _HASHLAB_F_64BIT;

  return &hl;
}

void _HASHLAB_MODULECFUNC(void *ptr)
{
}

LONG _HASHLAB_MODULERFUNC(void *ptr, VUQ128 *vu, UBYTE *str)
{
  vu->vuhi_hi = 0;

  vu->vuhi_lo = 0;

  txt_pjw64ihash((VUQUAD *)&vu->vulo_hi, str);

  return _HASHLAB_R_ALLOKAY;
}
