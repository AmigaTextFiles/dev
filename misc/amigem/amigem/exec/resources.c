#include <exec/execbase.h>

#include <amigem/fd_lib.h>
#define LIBBASE struct ExecBase *SysBase

FD1(81,void,AddResource,APTR resource,A1)
{}

FD1(82,void,RemResource,APTR resource,A1)
{}

FD1(83,APTR,OpenResource,STRPTR resName,A1)
{ return NULL; }

