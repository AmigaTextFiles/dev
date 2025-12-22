/*
 * mod_sfh32i.hl
 *
 * This  is  Paul Hsieh own hasing  routine  i did modify a bit
 * so it handles NULL terminated strings, the original is at:
 *
 *    http://www.azillionmonkeys.com/qed/hash.html
 *
 * I did add case equalizer to see if it can compete with other
 * routines.
 *
*/

#define MOD_XXX_VERSION    1
#define MOD_XXX_REVISION   0
#define MOD_XXX_STRING     "mod_sfh32i.hl"
#define MOD_XXX_DATESTR    "(24/07/2011)"



#include "hashlab.h"

_HASHLAB_MODULEHEADER(MOD_XXX_STRING, MOD_XXX_VERSION,
                          MOD_XXX_REVISION, MOD_XXX_DATESTR)



#define ___SFH32_16BITS(d)                       \
((((ULONG)(((UBYTE *)___SFH32EQRT(d))[1])) << 8) \
+ (ULONG)(((UBYTE *)___SFH32EQRT(d))[0]))
#define ___SFH32EQRT    QDEV_HLP_EQUALIZELC



static struct _hashlab hl;



void *_HASHLAB_MODULEIFUNC(void)
{
  hl.hl_text = MOD_XXX_STRING;

  hl.hl_ver = MOD_XXX_VERSION;

  hl.hl_rev = MOD_XXX_REVISION;

  hl.hl_flags = _HASHLAB_F_EQCASE | _HASHLAB_F_32BIT;

  return &hl;
}

void _HASHLAB_MODULECFUNC(void *ptr)
{
}

LONG _HASHLAB_MODULERFUNC(void *ptr, VUQ128 *vu, UBYTE *str)
{
  UBYTE *strreg = str;
  ULONG hash;
  ULONG temp;
  LONG rem;
  LONG len ;


  vu->vuhi_hi = 0;

  vu->vuhi_lo = 0;

  vu->vulo_hi = 0;

  /*
   * Compute string length.
  */
  while(*strreg)
  {
    strreg++;
  }

  len = ((LONG)strreg - (LONG)str);

  strreg = str;

  /*
   * Now set it up like in the original routine.
  */
  hash = len;

  rem = len & 3;

  len >>= 2;

  /*
   * Compute the hash.
  */
  for (;len > 0; len--)
  {
    hash += ___SFH32_16BITS(strreg);

    temp = (___SFH32_16BITS(strreg + 2) << 11) ^ hash;

    hash = (hash << 16) ^ temp;

    strreg += 2 * sizeof(UWORD);

    hash += hash >> 11;
  }

  /*
   * Handle end cases.
  */
  switch (rem)
  {
    case 3:
    {
      hash += ___SFH32_16BITS(strreg);

      hash ^= hash << 16;

      hash ^= ___SFH32EQRT(strreg[sizeof(UWORD)]) << 18;

      hash += hash >> 11;

      break;
    }

    case 2:
    {
      hash += ___SFH32_16BITS(strreg);

      hash ^= hash << 11;

      hash += hash >> 17;

      break;
    }

    case 1:
    {
      hash += ___SFH32EQRT(*strreg);

      hash ^= hash << 10;

      hash += hash >> 1;

      break;
    }

    default:

    ;
  }

  /*
   * Force "avalanching" of final 127 bits.
  */
  hash ^= hash << 3;

  hash += hash >> 5;

  hash ^= hash << 4;

  hash += hash >> 17;

  hash ^= hash << 25;

  hash += hash >> 6;

  vu->vulo_lo = hash;

  return _HASHLAB_R_ALLOKAY;
}
