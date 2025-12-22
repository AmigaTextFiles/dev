/*
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
 *
 * 'qdev' -  A library that helps in Amiga related software development
 * by Burnt Chip Dominators
 *
 * sup_c2p2c.h
 *
 * --- LICENSE --------------------------------------------------------
 *
 * 'C2P2C'  is   free  software;  you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the  Free  Software  Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * 'C2P2C'  is   distributed  in  the  hope  that  it  will  be useful,
 * but  WITHOUT  ANY  WARRANTY;  without  even  the implied warranty of
 * MERCHANTABILITY  or  FITNESS  FOR  A  PARTICULAR  PURPOSE.  See  the
 * GNU General Public License for more details.
 *
 * You  should  have  received a copy of the GNU General Public License
 * along  with  'qdev';  if not, write to the Free Software Foundation,
 * Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301   USA
 *
 * --- VERSION --------------------------------------------------------
 *
 * $VER: a-sup_c2p2c.h 1.01 (12/06/2010) C2P2C
 * AUTH: Wanja Pernath, megacz
 *
 * --- COMMENT --------------------------------------------------------
 *
 * C2P  and  P2C  routines by Morten Eriksen. Following inlines for use
 * with 'gcc' by Wanja Pernath.
 *
   * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*/

#ifndef ___C2P2C_H_INCLUDED___
#define ___C2P2C_H_INCLUDED___

#define sup_c2p(c2p)                          \
({                                            \
  register struct c2pStruct *_res __asm("a0") \
                                        = c2p;\
  __asm volatile ("jbsr _ChunkyToPlanarAsm"   \
  : /* no output */                           \
  : "r"(_res)                                 \
  : "d0", "d1", "a0", "a1", "fp0", "fp1",     \
                              "cc", "memory");\
})

#define sup_p2c(p2c)                          \
({                                            \
  register struct p2cStruct *_res __asm("a0") \
                                        = p2c;\
  __asm volatile ("jbsr _PlanarToChunkyAsm"   \
  : /* no output */                           \
  : "r"(_res)                                 \
  : "d0", "d1", "a0", "a1", "fp0", "fp1",     \
                              "cc", "memory");\
})



struct c2pStruct
{
  struct BitMap *bmap;
  UWORD          startX;
  UWORD          startY;
  UWORD          width;
  UWORD          height;
  UBYTE         *chunkybuffer;
};

struct p2cStruct
{
  struct BitMap *bmap;
  UWORD          startX;
  UWORD          startY;
  UWORD          width;
  UWORD          height;
  UBYTE         *chunkybuffer;
};



void ChunkyToPlanarAsm(struct c2pStruct *);
void PlanarToChunkyAsm(struct p2cStruct *);

#endif /* ___C2P2C_H_INCLUDED___ */
