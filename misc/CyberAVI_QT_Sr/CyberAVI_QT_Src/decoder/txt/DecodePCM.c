/*
sc:c/sc opt txt/DecodePCM.c
*/

#include "Decode.h"

struct PCMData {
  ulong dummy;
};

/* /// "DecodePCM8Mono()" */
__asm ulong DecodePCM8Mono(REG(a0) uchar *from,
                           REG(a1) uchar *toL,
                           REG(a2) uchar *toR,
                           REG(d0) ulong size,
                           REG(a3) struct PCMData *spec)
{
  ulong s, sr;

  ulong *f=(ulong *)from, *t=(ulong *)toL;
  sr=size;
  s=(size+3)/4;
  while(s--) {
    *t++=(*f++)^0x80808080;
  }
  return sr;
}
/* \\\ */

/* /// "DecodePCM8Stereo()" */
__asm ulong DecodePCM8Stereo(REG(a0) ushort *from,
                             REG(a1) uchar *toL,
                             REG(a2) uchar *toR,
                             REG(d0) ulong size,
                             REG(a3) struct PCMData *spec)
{
  ulong s, sr;
  ushort d;

  s=sr=size/2;
  while(s--) {
    d=(from[0])^0x8080;
    *toL++=(uchar)(d>>8);
    *toR++=(uchar)(d);
    from++;
  }
  return sr;
}
/* \\\ */

/* /// "DecodePCM16Mono()" */
__asm ulong DecodePCM16Mono(REG(a0) ushort *from,
                            REG(a1) short *toL,
                            REG(a2) short *toR,
                            REG(d0) ulong size,
                            REG(a3) struct PCMData *spec)
{
  ulong s, sr;

  s=sr=size/2;
  while(s--) {
    *toL++=get16pc(from);
  }
  return sr;
}
/* \\\ */

/* /// "DecodePCM16Stereo()" */
__asm ulong DecodePCM16Stereo(REG(a0) ushort *from,
                              REG(a1) short *toL,
                              REG(a2) short *toR,
                              REG(d0) ulong size,
                              REG(a3) struct PCMData *spec)
{
  ulong s, sr;

  s=sr=size/4;
  while(s--) {
    *toL++=get16pc(from);
    *toR++=get16pc(from);
  }
  return sr;
}
/* \\\ */

