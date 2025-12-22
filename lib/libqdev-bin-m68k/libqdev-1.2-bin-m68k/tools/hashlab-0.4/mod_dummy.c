/*
 * mod_dummy.hl
 *
 * Demonstration/example module. It does not produce real life
 * hashes!!!
*/

/*
 * Setup module identification stuff.
*/
#define MOD_XXX_VERSION    1
#define MOD_XXX_REVISION   0
#define MOD_XXX_STRING     "mod_dummy.hl"
#define MOD_XXX_DATESTR    "(20/07/2011)"



/*
 * These things must be done exactly in this order, so dont
 * change anything or it will not work!
*/
#include "hashlab.h"

_HASHLAB_MODULEHEADER(MOD_XXX_STRING, MOD_XXX_VERSION,
                            MOD_XXX_REVISION, MOD_XXX_DATESTR)

/*
 * Select libraries you need to use in the module. See the
 * header file 'a-pre_xxxlibs.h' for more details.
*/
#define ___QDEV_LIBINIT_NOEXTRAS
#define ___QDEV_LIBINIT_SYS            36



#include "a-pre_xxxlibs.h"



/*
 * Create your private structure if hash routine needs some
 * additional setup, but remeber about 'struct _hashlab' to
 * be always first!
*/
struct _hashint
{
  struct _hashlab  hi_hl;            /* Hashlab public data                 */
  LONG             hi_cnt;           /* Dummy private data                  */
};



void *_HASHLAB_MODULEIFUNC(void)
{
  struct _hashint *hi = NULL;


  if (pre_openlibs())
  {
    if ((hi = AllocVec(sizeof(struct _hashint), MEMF_PUBLIC)))
    {
      hi->hi_hl.hl_text = MOD_XXX_STRING;

      hi->hi_hl.hl_ver = MOD_XXX_VERSION;

      hi->hi_hl.hl_rev = MOD_XXX_REVISION;

      hi->hi_hl.hl_flags =
                         _HASHLAB_F_EQCASE | _HASHLAB_F_32BIT;

      hi->hi_cnt = 0xABCDABCD;
    }
  }

  if (!(hi))
  {
    pre_closelibs();
  }

  return hi;
}

void _HASHLAB_MODULECFUNC(void *ptr)
{
  if (ptr)
  {
    FreeVec(ptr);
  }

  pre_closelibs();
}

LONG _HASHLAB_MODULERFUNC(void *ptr, VUQ128 *vu, UBYTE *str)
{
  struct _hashint *hi = ptr;


  /*
   * The world's fastest and yet unpredictable hashing routine
   * ever made ;-P .
  */
  vu->vuhi_hi = 0;

  vu->vuhi_lo = 0;

  vu->vulo_hi = 0;

  vu->vulo_lo = hi->hi_cnt++;

  return _HASHLAB_R_ALLOKAY;
}
