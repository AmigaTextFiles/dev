/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_getsystime()
 *
*/

#include "../gid.h"



int GID_main(void)
{
  struct DateTime dat;
  struct timeval tv = {0, 0};
  UBYTE buftime[LEN_DATSTRING] = {0};


  /*
   * Not only 'DateStamp()' can be used for that ;-) . This
   * function has very low overhead compared to the former!
  */
  nfo_getsystime(&tv, NULL);

  /*
   * Now just do the conversion.
  */
  QDEV_HLP_TVTODS(&dat.dat_Stamp, &tv);

  dat.dat_Format = FORMAT_DOS;
      
  dat.dat_Flags = 0;
      
  dat.dat_StrDay = NULL;
      
  dat.dat_StrDate = NULL;
      
  dat.dat_StrTime = buftime;
      
  DateToStr(&dat);

  FPrintf(Output(), "%s\n", (LONG)dat.dat_StrTime);

  return 0;
}
