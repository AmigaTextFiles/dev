/*
sc:c/sc opt txt/DecodeTWOS.c
*/

#include "Decode.h"

struct TWOSData {
  ulong dummy;
};

/* /// "DecodeTWOS8Mono()" */
__asm ulong DecodeTWOS8Mono(REG(a0) uchar *from,
                            REG(a1) uchar *toL,
                            REG(a2) uchar *toR,
                            REG(d0) ulong size,
                            REG(a3) struct TWOSData *spec)
{
  ulong s, sr, d;

  s=sr=size;
  while(s--) {
    d=*from++;
    if (d & 0x80) d-=0x100;
    *toL++=d;
  }
  return sr;
}
/* \\\ */

/* /// "DecodeTWOS8Stereo()" */
__asm ulong DecodeTWOS8Stereo(REG(a0) uchar *from,
                              REG(a1) uchar *toL,
                              REG(a2) uchar *toR,
                              REG(d0) ulong size,
                              REG(a3) struct TWOSData *spec)
{
  ulong s, sr, d;

  s=sr=size/2;
  while(s--) {
    d=from[0];
    if (d & 0x80) d-=0x100;
    *toL++=d;
    d=from[1];
    if (d & 0x80) d-=0x100;
    *toR++=d;
    from+=2;
  }
  return sr;
}
/* \\\ */

/* /// "DecodeTWOS16Mono()" */
__asm ulong DecodeTWOS16Mono(REG(a0) ushort *from,
                             REG(a1) short *toL,
                             REG(a2) short *toR,
                             REG(d0) ulong size,
                             REG(a3) struct TWOSData *spec)
{
  ulong s, sr, d;

  s=sr=size/2;
  while(s--) {
    d=*from++;
    if (d & 0x8000) d-=0x10000;
    *toL++=d;
  }
  return sr;
}
/* \\\ */

/* /// "DecodeTWOS16Stereo()" */
__asm ulong DecodeTWOS16Stereo(REG(a0) ushort *from,
                               REG(a1) short *toL,
                               REG(a2) short *toR,
                               REG(d0) ulong size,
                               REG(a3) struct TWOSData *spec)
{
  ulong s, sr, d;

  s=sr=size/4;
  while(s--) {
    d=from[0];
    if (d & 0x8000) d-=0x10000;
    *toL++=d;
    d=from[1];
    if (d & 0x8000) d-=0x10000;
    *toR++=d;
    from+=2;
  }
  return sr;
}
/* \\\ */

