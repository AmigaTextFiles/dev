#include <libraries/mui.h>
#include <proto/muimaster.h>
#include <proto/textfield.h>
#include <proto/exec.h>
#ifdef __SASC
#include <clib/alib_protos.h>
#else
#include <proto/alib.h>
#endif
#include <exec/memory.h>
#include <exec/types.h>
#include <intuition/icclass.h>
#include <intuition/classes.h>
#include <gadgets/textfield.h>
#include <intuition/gadgetclass.h>

struct ObjTextField
{
  APTR textfield;
  APTR text;
  APTR prop;
};

extern struct ObjTextField * CreateTextField( void );
extern void DisposeTextField( struct ObjTextField * );
