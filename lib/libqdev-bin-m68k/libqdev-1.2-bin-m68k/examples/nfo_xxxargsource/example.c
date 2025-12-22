/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getargsource()
 * nfo_freeargsource()
 *
*/

/*
 * Activate CLI boomerang, so that copy of WBenchMsg will
 * be accessible.
*/
#define ___QDEV_LIBINIT_CLIONLY ___QDEV_LIBINIT_CLISTREAM

#include "../gid.h"

/*
 * If you will create such a file in the 'example's dir.
 * then it will be read as a global configuration! Of
 * course cmd line arguments can shadow globals, but be
 * aware that ToolTypes and/or comment field cannot be
 * then used!
*/
#define DEFAULTCONFIG "example.conf"



/*
 * With 'nfo_getargsource()' its amazingly easy to write
 * progs who can use same arguments interface both from
 * CLI and/or Workbench. No need to implement additional
 * parser! Try to play with this 'example' using '.info'
 * stub, command line or comment field of this binary.
 * You can define certain defaults by creating an icon
 * for this binary too!
*/
int GID_main(void)
{
  struct WBStartup *sm;
  struct RDArgs *rdi;
  struct RDArgs *rda[2] = {NULL, NULL};
  LONG argv[3];
  void *rdiptr;
  UBYTE *ttfile = NULL;
  LONG loops = 1;
  LONG olock = 0;


  /*
   * Zero-out the 'argv' array before reading arguments.
  */
  QDEV_HLP_QUICKFILL(&argv[0], LONG, 0, sizeof(argv));

  /*
   * For max. usage comfort lets utilise the copy of WB
   * message so that '.info' stubs can easily be used.
  */
  if ((sm = mem_getwbstartup(NULL)))
  {
    if (sm->sm_NumArgs > 1)
    {
      /*
       * The [1] entry contains the '.info' stub filename.
       * Changing curr. dir. to the stub's dir. makes it
       * all a lot simplier.
      */
      olock = CurrentDir(sm->sm_ArgList[1].wa_Lock);

      ttfile = sm->sm_ArgList[1].wa_Name;
    }
  }

  /*
   * OK. Aside from normal argument parsing you can also
   * allow ToolTypes to contain command line arguments.
   * Before calling this function it is important to set
   * 'loops' to 1 !
  */
  rdi = nfo_getargsource(&loops, ttfile, DEFAULTCONFIG);

  rdiptr = rdi;

  while (loops--)
  {
    rda[loops] = ReadArgs("ARG1,"
                          "ARG2/K,"
                          "ARG3/K",
    argv, rdiptr);

    /*
     * Switch to command line parsing after 1st attempt.
    */
    rdiptr = NULL;
  }

  /*
   * If only Comment field or ToolTypes were parsed then
   * flush input! Actually flush it anyways.
  */
  Flush(Input());

  /*
   * Now we have two argument spaces that get possibly
   * mixed ;-) .
  */
  if ((rda[0]) || (rda[1]))
  {
    if (argv[0])
    {
      FPrintf(Output(), "ARG1 = %s\n", argv[0]);
    }

    if (argv[1])
    {
      FPrintf(Output(), "ARG2 = %s\n", argv[1]);
    }

    if (argv[2])
    {
      FPrintf(Output(), "ARG3 = %s\n", argv[2]);
    }

    /*
     * OK, we are complete. Gotta free parser memories.
    */
    if (rda[0])
    {
      FreeArgs(rda[0]);
    }

    if (rda[1])
    {
      FreeArgs(rda[1]);
    }
  }

  /*
   * Free the ext. argument source if it was allocated.
  */
  if (rdi)
  {
    nfo_freeargsource(rdi);
  }

  /*
   * Restore previous directory if it was changed by the
   * startup resolver.
  */
  if (olock)
  {
    CurrentDir(olock);
  }

  return 0;
}
