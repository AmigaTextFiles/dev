/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_fsquery()
 *
*/

#include "../gid.h"

/*
 * Lets examine parent directory as there is more stuff in
 * it.
*/
#define QUERYPATH   "/"

/*
 * ExAllData buffer and user buffer can be adjusted. In the
 * first case values from 4096 to say 16384 are considered
 * optimal. It can be 1024 as well on a low memory system.
 * The other buffer is for user's use. Treat it as a handy,
 * temporary buffer pointed to by fc_userptr.
*/
#define EXALLSIZE   4096
#define USERSIZE    1024

/*
 * Next thing is amount of data to get. We want ED_NAME &
 * ED_TYPE, all other things are out of scope.
*/
#define INFOSIZE    ED_TYPE



struct userstruct
{
  LONG us_var1;
  LONG us_var2;
  LONG us_var3;
};



BOOL myfsqcb(struct nfo_fsq_cb *fc)
{
  struct userstruct *us = fc->fc_userdata;


  /*
   * Can access us_var#? here. Lets do something useless.
  */
  us->us_var1++;

  /*
   * Can use fc_userptr as a temporary stack/storage with
   * the length of fc_userlen.
  */
  txt_psnprintf(fc->fc_userptr, fc->fc_userlen, "%s%s%s",
                        (fc->fc_ead->ed_Type == ST_FILE ?
                                  "(FILE) " : "(DIR ) "),
                       fc->fc_file, fc->fc_ead->ed_Name);

  FPrintf(Output(), "%s\n", (LONG)fc->fc_userptr);

  /*
   * Continue to iterate. Returning FALSE stops the query!
  */
  return TRUE;
}

int GID_main(void)
{
  struct userstruct us;


  /*
   * Fill in our dummy structure.
  */
  us.us_var1 = 1;

  us.us_var2 = 2;

  us.us_var3 = 3;

  /*
   * Now just query the filesystem
  */
  if (!(nfo_fsquery(USERSIZE, EXALLSIZE, QUERYPATH,
                INFOSIZE, SIGBREAKF_CTRL_C, &us, myfsqcb)))
  {
    FPrintf(Output(),
       "Unable to access path = '%s'!\n", (LONG)QUERYPATH);
  }

  return 0;
}
