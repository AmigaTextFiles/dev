/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mem_scanlbl()
 *
*/

#include "../gid.h"

#define DATAFILE     "quiz.txt"
#define LINESIZE     1024
#define TERMSIG      SIGBREAKF_CTRL_C



LONG scanlblcb(struct mem_lbl_cb *lc)
{
  QDEV_TXT_INIPARSETYPE(ini);


  /*
   * If 'lc_linenum' is above 0 then the line was read,
   * if this changes to -1 then EOF was encountered.
  */
  if (lc->lc_linenum > 0)
  {
    if ((QDEV_TXT_INIPARSEINIT(lc->lc_lineptr, ':', ini)))
    {
      FPrintf(Output(), "QUESTION: %s\n"
                        "ANSWER  : %s\n\n", 
                                      (LONG)ini.ini_key,
                                      (LONG)ini.ini_data);

      QDEV_TXT_INIPARSETERM(ini);
    }
  }

  /*
   * All OK. Continue.
  */
  return -1;
}

/*
 * With 'mem_scanlbl()' it is possible to quickly and with
 * great comfort read the file line by line. The function
 * doubles LINESIZE, so that user can process the line in
 * the CB without the need to allocate extra memory.
*/
int GID_main(void)
{
  LONG fd;


  if ((fd = Open(DATAFILE, MODE_OLDFILE)))
  {
    if (mem_scanlbl(
             LINESIZE, fd, TERMSIG, NULL, scanlblcb) > -2)
    {
      FPrintf(Output(), "All OK.\n");
    }

    Close(fd);
  }
  
  return 0;
}
