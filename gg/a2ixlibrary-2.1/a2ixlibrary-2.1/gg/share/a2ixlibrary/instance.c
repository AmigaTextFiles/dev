#include <proto/exec.h>
#include <exec/execbase.h>

#include "a2ixlibrary.h"

typedef void (*func_ptr) (void);

extern int __datadata_relocs();
extern int __a4_offset();
extern func_ptr __DTOR_LIST__[];

/* The a4 pointers are stored *before* the start of this struct! */
struct user {
	/* both a magic cookie and a way to get at the library base thru u */
	void 	*u_ixbase;
	void 	*u_reserved;		/* for future use */

	long	u_a4_pointers_size;	/* number of a4 pointers */
	long	u_a4_pointers[0];
};

#ifdef INSTANCE_LIBS
INSTANCE_LIBS
#endif

#define u  (*(struct user *)(SysBase->ThisTask->tc_TrapData))

long lib_open(long base)
{
  char *origdata, *newdata;
  int datasize, numrel, i;
  long *relocs = (long *)__datadata_relocs;
  int offset = (-(long)__a4_offset) / 4 - 1;
  /* cannot use the global SysBase variable because A4 isn't (yet) initialized */
  struct ExecBase *SysBase = (struct ExecBase *)(*((long *)4));

  if (offset < 0 || offset >= u.u_a4_pointers_size)
    return 0;
  if (u.u_a4_pointers[-offset - 4])
    return base;
  asm ("movel #___data_size,%0; addl #___bss_size,%0" : "=r" (datasize));
  asm ("movel #__sdata,%0" : "=r" (origdata));
  newdata = AllocMem(datasize, 0);
  if (!newdata) {
    return 0;
  }
  for (i = 0; i < datasize; i++)
    newdata[i] = origdata[i];
  numrel = relocs[0];
  while (numrel--)
    *(long *)(newdata + *++relocs) -= origdata - newdata;
  u.u_a4_pointers[-offset - 4] = (long)(newdata + 0x7ffe);
#ifdef INSTANCE_LIBS
  if (!open_libs()) {
    close_libs();
    u.u_a4_pointers[-offset - 4] = 0;
    FreeMem(newdata, datasize);
    return 0;
  }
#endif
#ifdef CALL_INITS
  CALL_INITS
#endif
  return base;
}

void __LibCloseInstance(void)
{
  int datasize;
  int offset = (-(long)__a4_offset) / 4 - 1;
  /* A4 may be invalid here, so we don't use the global SysBase */
  struct ExecBase *SysBase = (struct ExecBase *)(*((long *)4));

  if (u.u_a4_pointers[-offset - 4])
  {
    func_ptr *p;

    for (p = __DTOR_LIST__ + 1; *p; )
      (*p++) ();

#ifdef INSTANCE_LIBS
    close_libs();
#endif

    asm ("movel #___data_size,%0; addl #___bss_size,%0" : "=r" (datasize));
    FreeMem((void *)(u.u_a4_pointers[-offset - 4] - 0x7ffe), datasize);
    u.u_a4_pointers[-offset - 4] = 0;
  }
}
