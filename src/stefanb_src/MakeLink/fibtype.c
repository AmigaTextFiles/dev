#include <stdlib.h>
#include <clib/dos_protos.h>

char Template[]="OBJECT/A";
struct {
        char *objname;
       } ArgDef={NULL};
#define NAMELEN 50
char progname[NAMELEN];

__stkargs void _main()
{
 register struct RDArgs *rda;
 register long rc=RETURN_ERROR;

 if (!GetProgramName(progname,NAMELEN-1)) progname[0]='\0';

 if (rda=ReadArgs(Template,(LONG *) &ArgDef,NULL))
  {
   register LONG lock;

   if (lock=Lock(ArgDef.objname,EXCLUSIVE_LOCK))
    {
     register struct FileInfoBlock *fib;

     if (fib=AllocDosObject(DOS_FIB,NULL))
      {
       if (Examine(lock,fib))
        {
         struct {
                 char *name;
                 long type;
                } outarray;

         outarray.name=ArgDef.objname;
         outarray.type=fib->fib_DirEntryType;
         VPrintf("Object %s is of type %ld\n",(LONG *) &outarray);
         rc=RETURN_OK;
        }
       FreeDosObject(DOS_FIB,fib);
      }
     UnLock(lock);
    }
   FreeArgs(rda);
  }

 if (rc) PrintFault(IoErr(),progname);

 _exit(rc);
}
