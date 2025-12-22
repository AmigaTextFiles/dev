#include <stdlib.h>
#include <stdio.h>

#include <exec/types.h>
#include <clib/exec_protos.h>
#include <clib/helloworld_protos.h>
#include <pragmas/exec_pragmas.h>
#include <pragmas/helloworld_pragmas.h>

extern struct Library *SysBase;
struct Library *HelloWorldBase;



int main(int argc, char *argv[])

{
  if (!(HelloWorldBase = OpenLibrary("libs/helloworld.library", 40)))
    {
      fprintf(stderr, "Cannot open 'helloworld.library'\n");
      exit(20);
    }

  if (argc == 1)
    {
      printf(HelloWorld(-1));
    }
  else
    {
      int i;

      for (i = 1;  i < argc;  i++)
	{ 
	  printf(HelloWorld(atol(argv[i])));
	}
    }

  CloseLibrary(HelloWorldBase);
}
