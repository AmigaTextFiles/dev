/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_scanlblncc()
 *
*/

#include "../gid.h"

#define DATAFILE     "example.c"
#define LINESIZE     1024
#define TERMSIG      SIGBREAKF_CTRL_C



LONG scanlblncccb(struct mem_lbl_cb *lc)
{
  /*
   * If 'lc_linenum' is above 0 then the line was read,
   * if this changes to -1 then EOF was encountered.
  */
  if (lc->lc_linenum > 0)
  {
    FPuts(Output(), lc->lc_lineptr);
  }
  else
  {
    FPuts(Output(), "EOF\n");
  }

  /*
   * All OK. Continue.
  */
  return -1;
}

/*
 * With 'mem_scanlblncc()' it is possible to strip C like
 * comments off the file. This function behaves almost
 * like 'mem_scanlbl()' but will call the CB only when it
 * finds the non-commented text and on EOF.
*/
int GID_main(void)
{
  LONG fd;


  if ((fd = Open(DATAFILE, MODE_OLDFILE)))
  {
    if (mem_scanlblncc(
          LINESIZE, fd, TERMSIG, NULL, scanlblncccb) > -2)
    {
      FPrintf(Output(), "All OK.\n");
    }

    Close(fd);
  }
  
  return 0;
}
