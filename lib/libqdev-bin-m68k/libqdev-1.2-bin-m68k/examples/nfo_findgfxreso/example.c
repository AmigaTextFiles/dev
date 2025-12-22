/*
 * The purpose of this file is to demonstrate how to use the following
 * function(s):
 *
 * nfo_findgfxreso()
 *
*/

#include "../gid.h"

/*
 * Lets define the range excluding boot monitor, so that no wierd
 * modeid values will be returned. At this point we do allow all
 * screenmodes.
*/
#define RANGE_LO   0x0000FFFF
#define RANGE_HI   0xFFFFFFFF

/*
 * We are interested in 640x512x8 specifically, but due to flags
 * who are defined below we will tolerate some skews.
*/
#define RESO_X     640
#define RESO_Y     512
#define DEPTH        8

/*
 * Right. We really require that the modeid be capable of certain
 * things. It has to be laced resolution, but we will appreciate
 * NTSC(400) or VGA(480) total rows as well.
*/
#define ID_FLAGS   (DIPF_IS_LACE | DIPF_IS_YCOFACT)



int GID_main(void)
{
  ULONG modeid;


  /*
   * As a building block requisite, this little function allows
   * to deduce modeid off resolution and depth.
  */
  modeid = nfo_findgfxreso(
            RESO_X, RESO_Y, DEPTH, ID_FLAGS, RANGE_LO, RANGE_HI);

  FPrintf(Output(), "modeid = 0x%08lx\n", modeid);

  return 0;
}
