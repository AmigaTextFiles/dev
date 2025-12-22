/* Programmheader

	Name:		HookTest.c
	Main:		example
	Versionstring:	$VER: HookTest.c 1.0 (21.09.2002)
	Author:		SDI
	Distribution:	Freeware
	Description:	the example library test program

 1.0   21.09.02 : added hook test to Test.c
*/

#include <utility/hooks.h>
#include <proto/example.h>
#include <proto/utility.h>
#include <proto/dos.h>
#include <proto/exec.h>
#include <SDI_hook.h>

/* use global library, as this works for all compilers! */
struct ExampleBase *ExampleBase = 0;

HOOKPROTO(TestHookFunc, ULONG, STRPTR object, STRPTR param)
{
  struct {
    STRPTR a;
    STRPTR b;
  } CallArgs;
  CallArgs.a = object;
  CallArgs.b = param;
  ex_TestRequest2A("Callback test",
  "Your callback was called with object '%s' and param '%s'", "OK", &CallArgs);
  return 5001;
}
MakeStaticHook(TestHook, TestHookFunc);

int main(int argc, char **argv)
{
  if((ExampleBase = (struct ExampleBase *) OpenLibrary("example.library", 1)))
  {
    ULONG callret;
    ex_TestRequest("Test Message", "It really works!", "OK");

    {
/* The easy method :-) When using this for the others, we would need link
   libraries. */
#if defined(__SASC) || defined(__STORM__) || defined(__GNUC__)
      ex_TestRequest2("Test Message Number 2",
      "It worked %ld times now.\n"
      "You called the programm '%s' with %ld arguments", "OK",
      ExampleBase->exb_NumCalls, argv[0], argc-1);
#else
      struct {
        ULONG  a;
        STRPTR b;
        ULONG  c;
      } CallArgs;
      CallArgs.a = ExampleBase->exb_NumCalls;
      CallArgs.b = argv[0];
      CallArgs.c = argc-1;
      ex_TestRequest2A("Test Message Number 2",
      "It worked %ld times now.\n"
      "You called the programm '%s' with %ld arguments", "OK", &CallArgs);
#endif
    }

    callret = ex_TestRequest3(&TestHook);

    ex_TestRequest2A("CallBack test",
      "The callback hook returned value %ld.", "OK", &callret);

    CloseLibrary((struct Library *) ExampleBase);
  }
  else
    Printf("Failed to open example.library\n");
  return 0;
}
