/* Programmheader

	Name:		EasyTest.c
	Main:		example
	Versionstring:	$VER: EasyTest.c 1.0 (21.09.2002)
	Author:		SDI
	Distribution:	Freeware
	Description:	the example library test program

 1.0   21.09.02 : first version
*/

#include <proto/dos.h>
#include <proto/exec.h>

int main(int argc, char **argv)
{
  struct Library *ExampleBase;

  if((ExampleBase = OpenLibrary("example.library", 1)))
  {
    Printf("Loaded Library\n");
    Printf("ln_Type:      9 --> %ld\n", ExampleBase->lib_Node.ln_Type);
    Printf("ln_Name:      %s\n", ExampleBase->lib_Node.ln_Name);
    Printf("lib_Flags:    4(6) --> %ld\n", ExampleBase->lib_Flags);
    Printf("lib_Version:  %ld\n", ExampleBase->lib_Version);
    Printf("lib_Revision: %ld\n", ExampleBase->lib_Revision);
    Printf("lib_IdString: %s\n", ExampleBase->lib_IdString);

    CloseLibrary(ExampleBase);
  }
  else
    Printf("Failed to open example.library\n");
  return 0;
}
