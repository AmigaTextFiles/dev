/*
 *   The structures and include files used in BlitLab.
 */
#define BANNER \
   "BlitLab 1.4, Copyright 1987-9 Radical Eye Software"
#include "exec/exec.h"
#include "intuition/intuition.h"
#include "functions.h"
#include "graphics/display.h"
#include "graphics/gfx.h"
#include "graphics/gfxmacros.h"
#include "graphics/gfxbase.h"
#include "hardware/dmabits.h"
#include "hardware/blit.h"
#include "stdio.h"
/*
 *   This is the blitter register structure we use.
 */
struct blitregs {
   short con0, con1, size, afwm, alwm ;
   short pth[4] ;
   short ptl[4] ;
   short mod[4] ;
   short dat[4] ;
} ;
/*
 *   A few macros to use the correct names for the above variables.
 */
#define BLTCON0 blitregs.con0
#define BLTCON1 blitregs.con1
#define BLTSIZE blitregs.size
#define BLTAFWM blitregs.afwm
#define BLTALWM blitregs.alwm
#define BLTAPTH blitregs.pth[0]
#define BLTAPTL blitregs.ptl[0]
#define BLTAMOD blitregs.mod[0]
#define BLTADAT blitregs.dat[0]
#define BLTBPTH blitregs.pth[1]
#define BLTBPTL blitregs.ptl[1]
#define BLTBMOD blitregs.mod[1]
#define BLTBDAT blitregs.dat[1]
#define BLTCPTH blitregs.pth[2]
#define BLTCPTL blitregs.ptl[2]
#define BLTCMOD blitregs.mod[2]
#define BLTCDAT blitregs.dat[2]
#define BLTDPTH blitregs.pth[3]
#define BLTDPTL blitregs.ptl[3]
#define BLTDMOD blitregs.mod[3]
#define BLTDDAT blitregs.dat[3]
/*
 *   Here we number the gadgets.
 */
#define GDGPNTREG (0)
#define GDGGO (1)
#define GDGSX (2)
#define GDGSY (3)
#define GDGEX (4)
#define GDGEY (5)
#define GDGLINE (6)
#define GDGH (7)
#define GDGV (8)
#define GDGDESC (9)
#define GDGFCI (10)
#define GDGIFE (11)
#define GDGEFE (12)
#define GDGSETUP (13)
#define GDGFUNC (14)
#define GDGUSEA (15)
#define GDGUSEB (16)
#define GDGUSEC (17)
#define GDGUSED (18)
#define GDGAPT (19)
#define GDGBPT (20)
#define GDGCPT (21)
#define GDGDPT (22)
#define GDGAMOD (23)
#define GDGBMOD (24)
#define GDGCMOD (25)
#define GDGDMOD (26)
#define GDGADAT (27)
#define GDGBDAT (28)
#define GDGCDAT (29)
#define GDGASH (30)
#define GDGBSH (31)
#define GDGAFWM (32)
#define GDGALWM (33)
#define GDGCALC (34)
#define GDGSIGN (35)
#define GDGOVF (36)
#define GDGUNDO (37)
#define GDGSIM (38)
#define GDGLF (39)
#define MAXGADG (40)
/*
 *   These defines set the size of the screen and various subareas of
 *   the screen, including most gadget locations.
 */
#define HWINSTART (0)
#define VWINSTART (2)
#define HWINSIZE (640)
#define VWINSIZE (198)
#define HBITSTART (4)
#define VBITSTART (11)
#define HBITSIZE (96 * 6)
#define VBITSIZE (32 * 3 + 1)
#define HLMGSTART (HBITSIZE + HBITSTART + 2)
#define HLMGSIZE (HWINSIZE - HLMGSTART - 5)
#define VLMGSIZE (11)
#define VLMG1 (VBITSTART + 1)
/*#define VLMG2 (VLMG1 + 11)*/
#define VLMG3 (VLMG1 + 11)
/*#define VLMG4 (VLMG3 + 9)*/
#define VLMG5 (VLMG3 + 34)
#define VGOSTART (VLMG5 + 11)
#define HGOSTART (HLMGSTART)
#define HGOSIZE (HLMGSIZE)
#define VGOSIZE (11)
#define VLMG7 (VGOSTART + 11)
#define VLMG8 (VLMG7 + 11)
#define VSTRSIZE (11)
#define HSTRSIZE(a) (8 * (a) + 4)
#define HMGSIZE (62)
#define FUNCSIZE ((HWINSIZE-HMG4START-6)/2)
#define HMGSSIZE (52)
#define VMGSIZE (11)
#define HMGINT (1)
#define VMGINT (0)
#define HMG1START (HBITSTART)
#define HMG2START (HMG1START + HMGSIZE + HMGINT)
#define HMG3START (HMG2START + HMGSIZE + HMGINT)
#define HMG4START (HMG3START + HMGSIZE + HMGINT)
#define HMGFLSTART (HMG4START + FUNCSIZE)
#define HMG5START (HMG4START + HMGSIZE + HMGINT)
#define HMG6START (HMG5START + HMGSIZE + HMGINT - 2)
#define HMG7START (HMG6START + HMGSSIZE + HMGINT)
#define HMG8START (HMG7START + HMGSSIZE + HMGINT)
#define HMG9START (HMG8START + HMGSSIZE + HMGINT)
#define HMG10START (HMG9START + HMGSSIZE + HMGINT)
#define HMG11START (HMG10START + HMGSSIZE + HMGINT)
#define VMG1START (VBITSTART + VBITSIZE)
#define VMG2START (VMG1START + VMGSIZE + VMGINT)
#define VRVSTART (VMG2START + VMGSIZE)
#define VRVL1 (VRVSTART + 4)
#define VRVL2 (VRVL1 + 10)
#define VRVL3 (VRVL2 + 10)
#define VRVL4 (VRVL3 + 10)
#define VRVL5 (VRVL4 + 10)
#define VRVL6 (VRVL5 + 11)
#define VRVLL1 (VRVSTART + 2)
#define VRVLL2 (VRVLL1 + 9)
#define VRVLL3 (VRVLL2 + 11)
#define VRVLL4 (VRVLL3 + 11)
#define VRVLL5 (VRVLL4 + 11)
#define VRVLL6 (VRVLL5 + 11)
#define VRG1 (VRVLL1 + 8)
#define VRVSIZE (VWINSIZE - VRVSTART - 2)
#define HRVSIZE (HWINSIZE - HBITSTART - 3)
#define HRVSTART (HBITSTART)
#define HRVC1 (HRVSTART + 6)
#define HRVC2 (HRVC1 + 5 * 8)
#define HRVC3 (HRVC2 + 5 * 8)
#define HRVC4 (HRVC3 + 2 * 8)
#define HRVC5 (HRVC4 + 5 * 8)
#define HRVC6 (HRVC5 + 5 * 8)
#define HRVC6B (HRVC6 + 5 * 8)
#define HMVSTART (HRVC6B + 35)
#define HRVC7 (HRVC6B + 5 * 8)
#define HRVC8 (HRVC7 + 2 * 8)
#define HRVC9 (HRVC8 + 3 * 8 + 4)
#define HRVC10 (HRVC9 + 9 * 8)
#define HRVC11 (HRVC10 + 7 * 8)
#define HRVC12 (HRVC11 + 19 * 8)
#define VTEXTOFF (2)
#define HTEXTOFF (2)
/*
 *   Colors.
 */
#define BLUE (0)
#define WHITE (1)
#define BLACK (2)
#define ORANGE (3)

