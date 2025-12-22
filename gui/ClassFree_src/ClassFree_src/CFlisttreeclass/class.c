/* Sample class  for StormC*/

#include <clib/alib_protos.h>
#include <proto/intuition.h>
#include <exec/libraries.h>
#include <intuition/classes.h>
#include <dos/dos.h>
#include "class.h"
#ifdef DEBUG
 #include "debug_protos.h"
 extern APTR console;
#endif

Class *initclass(struct classbase *base)
{
  Class *cl;

  if(cl = MakeClass("testclass","rootclass",NULL,
        /* Object instance data size */0,NULL))
  {
    cl->cl_Dispatcher.h_Entry = hookEntry;
    cl->cl_Dispatcher.h_SubEntry = dispatcher;
    AddClass(cl);
  }
  base->cl = cl;

  return(cl);
}

BOOL removeclass(struct classbase *base)
{
  BOOL result;

  if(result = FreeClass(base->cl)) base->cl = NULL;

  return(result);
}

ULONG dispatcher(Class *cl,Object *o,Msg msg)
{
  switch(msg->MethodID)
  {
    default:
      return(DoSuperMethodA(cl,o,msg));
  }
}

