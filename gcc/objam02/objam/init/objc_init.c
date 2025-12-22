/*
** ObjectiveAmiga: Initialization module source
** See GNU:lib/libobjam/ReadMe for details
*/


#include <headers/stabs.h>
#include <proto/exec.h>
#include <proto/objc.h>
#include <stdlib.h>
#include <objc/runtime.h> /* The kitchen sink */


struct ObjcBase *ObjcBase;


/************************************************************ initialization */

void objc_libopen_fatal(void)
{
  PutStr("*** Objective C initialisation error:\n  Can't open " OBJCNAME ".\n  Aborting.\n");
  exit(20);
}

static void __Objc_Init(void)
{
  register void *globaldata asm("a4");
  struct __objclib_init_data *libinitdata;

  if(!(ObjcBase=(struct ObjcBase *)OpenLibrary(OBJCNAME,OBJCVERSION)))
    objc_libopen_fatal();
  if(!(libinitdata=(struct __objclib_init_data *)malloc(sizeof(struct __objclib_init_data))))
    objc_libopen_fatal();
  libinitdata->globaldata=globaldata;
  libinitdata->abort=abort;
  __objclib_init(libinitdata);
}

static void __Objc_Exit(void)
{
  if(ObjcBase)
  {
    CloseLibrary((struct Library *)ObjcBase);
    ObjcBase=NULL;
  }
}


/********************************************************************* stabs */

/* ADD2INIT(__Objc_Init,0); */
/* ADD2EXIT(__Objc_Exit,0); */

ADD2LIST(__Objc_Init,__CTOR_LIST__,22);
ADD2LIST(__Objc_Exit,__DTOR_LIST__,22);
