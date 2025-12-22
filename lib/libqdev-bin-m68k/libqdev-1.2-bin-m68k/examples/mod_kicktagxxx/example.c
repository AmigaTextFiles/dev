/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * mod_kicktaglink()
 * mod_kicktagunlink()
 *
*/

#include "../gid.h"

#define CODE_MEMTYPE  MEMF_LOCAL
#define CODE_LOWER    QDEV_MOD_ADE_24BITLOWER
#define CODE_UPPER    QDEV_MOD_ADE_32BITUPPER



struct mymodule
{
  struct mod_ktl_head  mm_kh;
  UBYTE                mm_name[128];
  UBYTE                mm_idstr[128];
  LONG                 mm_code;
};



/*
 * In order to demonstrate how to use these two functions we
 * will have to create a dummy module. It will do nothing.
*/
int GID_main(void)
{
  struct mymodule *mm;
  LONG size;


  /*
   * Gotta align the memory cus 'mem_allocmemregion()' does
   * allocate exact amount of memory and this includes the
   * MemChunk!
  */
  size = QDEV_MEM_REGALIGN(sizeof(struct mymodule));

  if ((mm = mem_allocmemregion(size, CODE_MEMTYPE,
                                   CODE_LOWER, CODE_UPPER)))
  {
    /*
     * The code to execute is really short just stuff 0 in
     * d0 and return to system.
    */
    mm->mm_code = QDEV_MOD_ADE_DUMMYCODE;

    /*
     * Now get into strings. They must generally be within
     * 'mm' allocation!
    */
    mm->mm_name[0] = '\0';

    txt_strncat(mm->mm_name,
                    "TheSuperbModule", sizeof(mm->mm_name));

    mm->mm_idstr[0] = '\0';

    txt_strncat(mm->mm_idstr,
                         "TheSuperbModule 1.0 (21.08.2012)",
                                      sizeof(mm->mm_idstr));

    /*
     * At this point Resident structure must be filled. It
     * can be something like this.
    */
    mm->mm_kh.kh_rt.rt_Type = NT_USER;

    mm->mm_kh.kh_rt.rt_Pri = 0;

    mm->mm_kh.kh_rt.rt_Flags = RTF_COLDSTART;

    mm->mm_kh.kh_rt.rt_Init = (void *)&mm->mm_code;

    mm->mm_kh.kh_rt.rt_Version = 1;

    mm->mm_kh.kh_rt.rt_Name = mm->mm_name;

    mm->mm_kh.kh_rt.rt_IdString = mm->mm_idstr;

    mm->mm_kh.kh_rt.rt_MatchWord = RTC_MATCHWORD;

    mm->mm_kh.kh_rt.rt_MatchTag = &mm->mm_kh.kh_rt;

    mm->mm_kh.kh_rt.rt_EndSkip = (UBYTE *)((LONG)mm + size);

    /*
     * Having ROMTAG now its just a matter of MemList. Our
     * MemList has just one MemEntry, its ourselves.
    */
    mm->mm_kh.kh_ml.ml_NumEntries = 1;

    mm->mm_kh.kh_ml.ml_ME[0].me_Addr = mm;

    mm->mm_kh.kh_ml.ml_ME[0].me_Length = size;

    /*
     * Voila! Can now call the main event function.
    */
    if ((mod_kicktaglink((struct mod_ktl_head *)mm)))
    {
      FPrintf(Output(),
              "Module installed, press CTRL+C to abort.\n");

      Wait(SIGBREAKF_CTRL_C);

      mod_kicktagunlink((struct mod_ktl_head *)mm);
    }
    
    mem_freememregion(mm, size);
  }

  return 0;
}
