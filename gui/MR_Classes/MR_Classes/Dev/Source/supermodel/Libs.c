#include <clib/extras_protos.h>
#include <extras/libs.h>

#include <proto/exec.h>
#include <proto/intuition.h>

struct ExecBase       *SysBase;
struct IntuitionBase  *IntuitionBase;
struct Library        *UtilityBase;

struct Libs MyLibs[]=
{
  (APTR *)&IntuitionBase, "intuition.library",          39,     0,
  (APTR *)&UtilityBase,   "utility.library",            39,     0,
  0
};
                      

BOOL i_OpenLibs(void)
{
  ULONG *LongMem=0;

  SysBase=(APTR)LongMem[1];

 	return(ex_OpenLibs(0, "supermodel.class", 0,0,0, MyLibs));
}

void i_CloseLibs(void)
{
  ex_CloseLibs(MyLibs);
}



