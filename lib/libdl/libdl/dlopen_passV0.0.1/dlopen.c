/* Copyright GPL mmc Mike Chirico mchirico@users.sourceforge.net
   program: dlopen.c
   dependences: plugin.so

   description: This program is an example of dlopen
   
   compiling this program:
gcc -o plugin.so -shared plugin.c
gcc -ldl -o dlopen dlopen.c

   output:
   $./dlopen
in function one.
in function two.
in function three.


*/

#include <stdio.h>
#include <dlfcn.h>
#include <stdlib.h>

int main(int argc, char **argv)
{
  void *hndl;
  int (*fptr)(int );
  char *error;
  int i=1;



  if(argc > 1)
    fprintf(stderr,"See readme no arguments: ./dlopen \n");
  

  hndl = dlopen("./plugin.so",RTLD_LAZY);
  if ( hndl == NULL ){
    fprintf(stderr,"%s dlopen failure: %s\n",argv[0],dlerror());
    exit(1);
  }

  *(void **)(&fptr) = dlsym(hndl,"one");
  if ((error = dlerror()) != NULL) {
    fprintf (stderr, "%s\n", error);
    exit(1);
  }

  i=(*fptr)(i);


  *(void **)(&fptr) = dlsym(hndl,"two");
  if ((error = dlerror()) != NULL) {
    fprintf (stderr, "%s\n", error);
    exit(1);
  }

  i=(*fptr)(i);


  *(void **)(&fptr) = dlsym(hndl,"three");
  if ((error = dlerror()) != NULL) {
    fprintf (stderr, "%s\n", error);
    exit(1);
  }

  i=(*fptr)(i);


  printf("i = %d\n",i);

  dlclose(hndl);
  exit(0);
}


