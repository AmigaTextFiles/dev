#include "a2ixlibrary.h"

typedef void (*func_ptr) (void);

void *ixemulbase = 0;
int *ixemul_errno;
char *_ctype_;
void **__sF;
void **__pstk_limit;

extern func_ptr __CTOR_LIST__[];

#ifdef MISC_SETVARS
  MISC_SETVARS
#endif

void __LibSetVarsInstance(int argc, void *ixbase,
			  int *errnoptr, char *ctype, void **sf,
			  void **stk_limit)
{
  unsigned long nptrs, i;

  if (ixemulbase)
    return;

  switch (argc)
  {
    default:
    case 5:
      if (stk_limit) __pstk_limit = stk_limit;
    case 4:
      if (sf) __sF = sf;
    case 3:
      if (ctype) _ctype_ = ctype;
    case 2:
      if (errnoptr) ixemul_errno = errnoptr;
    case 1:
      if (ixbase) ixemulbase = ixbase;
    case 0:
  }

#ifdef CALL_SETVARS
  CALL_SETVARS
#endif

  /* Call constructors */
  nptrs = (unsigned long)__CTOR_LIST__[0];
  if (nptrs == -1)
    for (nptrs = 0; __CTOR_LIST__[nptrs + 1] != 0; nptrs++);
  for (i = nptrs; i >= 1; i--)
    __CTOR_LIST__[i]();
}
