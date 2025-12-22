/*
sc:c/sc opt txt/DecodeDummy.c
*/

#include "Decode.h"
#include "YUV.h"

/* /// "DecodeDummy()" */
__asm void DecodeDummy(REG(a0) uchar *from,
                       REG(a1) uchar *to,
                       REG(d0) ulong width,
                       REG(d1) ulong height,
                       REG(d2) ulong encSize,
                       REG(a2) uchar *spec)
{
}
/* \\\ */

