/* Instruction cache flushing for hppa */

/*
 * Copyright 1995 Bruno Haible, <haible@ma2s2.mathematik.uni-karlsruhe.de>
 *
 * This is free software distributed under the GNU General Public Licence
 * described in the file COPYING. Contact the author if you don't have this
 * or can't live with it. There is ABSOLUTELY NO WARRANTY, explicit or implied,
 * on this software.
 */

/*
 * This assumes that the range [first_addr..last_addr] lies in at most two
 * cache lines.
 */
void __TR_clear_cache (char* first_addr, char* last_addr)
{
  register int tmp1;
  register int tmp2;
  asm volatile ("mfsp %%sr0,%1;"
                "ldsid (0,%4),%0;"
                "mtsp %0,%%sr0;"
                "fic 0(%%sr0,%2);"
                "fic 0(%%sr0,%3);"
                "sync;"
                "mtsp %1,%%sr0;"
                "nop; nop; nop; nop; nop; nop"
                : "=r" (tmp1), "=r" (tmp2)
                : "r" (first_addr), "r" (last_addr), "r" (first_addr)
               );
}
