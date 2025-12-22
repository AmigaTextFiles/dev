/*************************************************************/
/*     Test Linux Dynamic Function Loading                              */
/*                                                                      */
/*     void       *dlopen(const char *filename, int flag)                       */
/*              Opens dynamic library and return handle         */
/*                                                                      */
/*     const char *dlerror(void)                                        */
/*           Returns string describing the last error.                       */
/*                                                                      */
/*     void       *dlsym(void *handle, char *symbol)                    */
/*              Return pointer to symbol's load point.                  */
/*              If symbol is undefined, NULL is returned.                       */
/*                                                                      */
/*     int        dlclose (void *handle)                                        */
/*              Close the dynamic library handle.                               */
/*                                                                      */
/*                                                                      */
/*                                                                      */
/*************************************************************/
#include<stdio.h>
#include        <stdlib.h>
 
/*                                                              */
/* 1-dll include file and variables     */
/*                                                              */
#include        <dlfcn.h>
void  *FunctionLib;             /*  Handle to shared lib file   */
int   (*Function)();            /*  Pointer to loaded routine   */
const char *dlError;            /*  Pointer to error string             */

main( argc, argv )
{
  int   rc;                             /*  return codes                        */
  char HelloMessage[] = "HeLlO WoRlD\n";
 
/*                                                              */
/* 2-print the original message                                 */
/*                                                              */
  printf(" dlTest  2-Original message \n");
  printf("%s", HelloMessage);

/*                                               */
/*  3-Open Dynamic Loadable Libary with absolute path      */
/*                                              */
  FunctionLib = dlopen("/home/dlTest/UPPERCASE.so",RTLD_LAZY);
  dlError = dlerror();
  printf(" dlTest  3-Open Library with absolute path return-%s- \n", dlError);
  if( dlError ) exit(1);

/*                                                              */
/* 4-Find the first loaded function     */
/*                                                              */
  Function    = dlsym( FunctionLib, "printUPPERCASE");
  dlError = dlerror();
  printf(" dlTest  4-Find symbol printUPPERCASE return-%s- \n", dlError);
  if( dlError ) exit(1);

/*                                                              */
/* 5-Execute the first loaded function                          */
/*                                                              */
  rc = (*Function)( HelloMessage );
  printf(" dlTest  5-printUPPERCASE return-%s- \n", dlError);

/*                                                              */
/* 6-Close the shared library handle                                    */
/* Note:  after the dlclose, "printUPPERCASE" is not loaded           */
/*                                                              */
  rc = dlclose(FunctionLib);
  dlError = dlerror();
  printf(" dlTest  6-Close handle return-%s-\n",dlError); 
  if( rc ) exit(1);


/*                                                              */
/*  7-Open Dynamic Loadable Libary using LD_LIBRARY path        */
/*                                                              */
  FunctionLib = dlopen("lowercase.so",RTLD_LAZY);
  dlError = dlerror();
  printf(" dlTest  7-Open Library with relative path return-%s- \n", dlError);
  if( dlError ) exit(1);

/*                                                              */
/* 8-Find the second loaded function                            */
/*                                                              */
  Function    = dlsym( FunctionLib, "printLowercase");
  dlError = dlerror();
  printf(" dlTest  8-Find symbol printLowercase return-%s- \n", dlError);
  if( dlError ) exit(1);

/*                                                              */
/* 8-execute the second loaded function                         */
/*                                                              */
  rc = (*Function)( HelloMessage );
  printf(" dlTest  9-printLowercase return-%s- \n", dlError);

/*                                                              */
/* 10-Close the shared library handle                           */
/*                                                              */
  rc = dlclose(FunctionLib);
  dlError = dlerror();
  printf(" dlTest 10-Close handle return-%s-\n",dlError); 
  if( rc ) exit(1);

  return(0);

}
