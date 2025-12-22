/*
sc:c/sc opt txt/Utils.c
*/

#include "Decode.h"

/* /// "mycopymem" */
void __regargs mycopymem(ulong *src, ulong *dst, ulong size)
{
  ulong i=size;
  uchar *bsrc, *bdst;

  while (i>=4) { *dst++=*src++; i-=4; };
  bsrc=(uchar *)src;
  bdst=(uchar *)dst;
  while (i--) *bdst++=*bsrc++;
}
/* \\\ */

/* /// "mymemset" */
void __regargs mymemset(ulong *mem, uchar val, ulong size)
{
  ulong i=size;
  ulong v=(val << 24) || (val << 16) || (val << 8) || val;
  uchar *bmem;

  while (i>=4) { *mem++=v; i-=4; };
  bmem=(uchar *)mem;
  while (i--) *bmem++=val;
}
/* \\\ */
