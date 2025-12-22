/*
sc:c/sc opt txt/DecodeIMAADPCM.c
*/

#include "Decode.h"
#include "ADPCM.h"

struct IMAADPCMData {
  uchar downScale;
};

/* /// "DecodeIMAADPCM4Mono()" */
__asm ulong DecodeIMAADPCM4Mono(REG(a0) uchar *from,
                                REG(a1) uchar *toL,
                                REG(a2) uchar *toR,
                                REG(d0) ulong size,
                                REG(a3) struct IMAADPCMData *spec)
{
  long todo=(size/0x40*0x22);
  ulong decoded=0;

  ulong blockCnt=0x40;
  uchar downScale=spec->downScale;

  while (todo>0) {
    long valPred;
    long index;
    long step;
    ulong n;
    uchar firstNibble;

    valPred=get16(from);
    index=valPred & 0x7f;
    if (index>88) index=88;
    valPred &= 0xff80;
    if (valPred & 0x8000) valPred-=0x10000;

    step=stepSizeTable[index];
    todo-=2;
    if (todo<=0) {decoded=0; goto ima4MonoDecodeExit;}

    firstNibble=1;
    for(n=0; n<blockCnt; n++) {
      ulong loNibble, hiNibble;

      if (firstNibble) {
        loNibble=*from++;
        hiNibble=(loNibble>>4) & 0x0f;
        loNibble &= 0x0f;
        todo--;
        if (todo<0) goto ima4MonoDecodeExit;
        if (downScale)
          n++;
        else
          firstNibble=0;
      } else {
        loNibble=hiNibble;
        firstNibble=1;
      }
      calcDVI(valPred,loNibble,index,step);
      *toL++=(uchar)(valPred>>8);
      decoded++;
    }
  }

ima4MonoDecodeExit:
  return decoded;
}
/* \\\ */

/* /// "DecodeIMAADPCM4Stereo()" */
__asm ulong DecodeIMAADPCM4Stereo(REG(a0) uchar *from,
                                  REG(a1) uchar *toL,
                                  REG(a2) uchar *toR,
                                  REG(d0) ulong size,
                                  REG(a3) struct IMAADPCMData *spec)
{
  long todo=((size>>1)/0x40*0x22);
  ulong decoded=0;

  ulong blockCnt=0x40;
  uchar downScale=spec->downScale;
  uchar *fromLeft=from;
  uchar *fromRight=from+0x22;

  while (todo>0) {
    long lValPred, rValPred;
    long lIndex, rIndex;
    long lStep, rStep;
    ulong n;
    uchar firstNibble;

    lValPred=get16(fromLeft);
    lIndex=lValPred & 0x7f;
    if (lIndex>88) lIndex=88;
    lValPred &= 0xff80;
    if (lValPred & 0x8000) lValPred-=0x10000;
    lStep=stepSizeTable[lIndex];

    rValPred=get16(fromRight);
    rIndex=rValPred & 0x7f;
    if (rIndex>88) rIndex=88;
    rValPred &= 0xff80;
    if (rValPred & 0x8000) rValPred-=0x10000;
    rStep=stepSizeTable[rIndex];

    todo-=2;
    if (todo<=0) {decoded=0; goto ima4StereoDecodeExit;}

    firstNibble=1;
    for(n=0; n<blockCnt; n++) {
      ulong loNibbleL, hiNibbleL;
      ulong loNibbleR, hiNibbleR;

      if (firstNibble) {
        loNibbleL=*fromLeft++;
        hiNibbleL=(loNibbleL>>4) & 0x0f;
        loNibbleL &= 0x0f;
        loNibbleR=*fromRight++;
        hiNibbleR=(loNibbleR>>4) & 0x0f;
        loNibbleR &= 0x0f;
        todo--;
        if (todo<0) goto ima4StereoDecodeExit;
        if (downScale)
          n++;
        else
          firstNibble=0;
      } else {
        loNibbleL=hiNibbleL;
        loNibbleR=hiNibbleR;
        firstNibble=1;
      }
      calcDVI(lValPred,loNibbleL,lIndex,lStep);
      *toL++=(uchar)(lValPred>>8);
      calcDVI(rValPred,loNibbleR,rIndex,rStep);
      *toR++=(uchar)(rValPred>>8);
      decoded++;
    }
    fromLeft+=0x22;
    fromRight+=0x22;
  }

ima4StereoDecodeExit:
  return decoded;
}
/* \\\ */

