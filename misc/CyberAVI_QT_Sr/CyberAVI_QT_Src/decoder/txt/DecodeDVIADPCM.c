/*
sc:c/sc opt txt/DecodeDVIADPCM.c
*/

#include "Decode.h"
#include "ADPCM.h"

struct DVIADPCMData {
  short blockCnt;
};

/* /// "DecodeDVIADPCMMono()" */
__asm ulong DecodeDVIADPCMMono(REG(a0) uchar *from,
                               REG(a1) short *toL,
                               REG(a2) short *toR,
                               REG(d0) ulong size,
                               REG(a3) struct DVIADPCMData *spec)
{
  long todo=size;
  ulong decoded=0;

  ulong blockCnt=spec->blockCnt;

  while (todo>0) {
    long valPred;
    long index;
    long step;
    ushort n;
    uchar firstNibble;

    valPred=get16pc(from);
    if (valPred & 0x8000) valPred-=0x10000;
    index=*from;
    from+=2;
    if (index>88) index=88;
    step=stepSizeTable[index];
    todo-=4;
    if (todo<=0) {decoded=0; goto dviadpcmMDecode4BitExit;}

    *toL++=(uchar)(valPred>>8);
    decoded++;

    firstNibble=1;
    for(n=1; n<blockCnt; n++) {
      ulong loNibble, hiNibble;

      if (firstNibble) {
/* /// "new style" */
        loNibble=*from++;
        hiNibble=(loNibble>>4) & 0x0f;
        loNibble &= 0x0f;
/* \\\ */
/* /// "old style"
        hiNibble=*from++;
        loNibble=(hiNibble>>4) & 0x0f;
        hiNibble &= 0x0f;
\\\ */
        todo--;
        if (todo<0) goto dviadpcmMDecode4BitExit;
        firstNibble=0;
      } else {
        loNibble=hiNibble;
        firstNibble=1;
      }
      calcDVI(valPred,loNibble,index,step);
      *toL++=valPred;
      decoded++;
    }
  }

dviadpcmMDecode4BitExit:
  return decoded;
}
/* \\\ */

/* /// "DecodeDVIADPCMStereo()" */
__asm ulong DecodeDVIADPCMStereo(REG(a0) uchar *from,
                                 REG(a1) short *toL,
                                 REG(a2) short *toR,
                                 REG(d0) ulong size,
                                 REG(a3) struct DVIADPCMData *spec)
{
  long todo=size;
  ulong decoded=0;

  ulong blockCnt=spec->blockCnt;

  while (todo>0) {
    long lValPred, rValPred;
    long lIndex, rIndex;
    long lStep, rStep;
    ushort n;

    lValPred=get16pc(from);
    if (lValPred & 0x8000) lValPred-=0x10000;
    lIndex=*from;
    from+=2;
    if (lIndex>88) lIndex=88;
    lStep=stepSizeTable[lIndex];

    rValPred=get16pc(from);
    if (rValPred & 0x8000) rValPred-=0x10000;
    rIndex=*from;
    from+=2;
    if (rIndex>88) rIndex=88;
    rStep=stepSizeTable[rIndex];

    todo-=8;
    if (todo<=0) {decoded=0; goto dviadpcmSDecode4BitExit;}

    *toL++=lValPred;
    *toR++=rValPred;
    decoded++;
/* /// "new style" */
    for (n=1; n<blockCnt; n+=8) {
      ulong lStore, rStore, flag;
      lStore=get32pc(from);
      rStore=get32pc(from);
      todo-=8;
      if (todo<0) goto dviadpcmSDecode4BitExit;
      for (flag=0; flag<8; flag++) {
        ulong nibble;
        nibble=lStore & 0x0f;
        calcDVI(lValPred,nibble,lIndex,lStep);
        *toL++=lValPred;
        nibble=rStore & 0x0f;
        calcDVI(rValPred,nibble,rIndex,rStep);
        *toR++=rValPred;
        decoded++;
        lStore>>=4;
        rStore>>=4;
      }
    }
/* \\\ */
/* /// "old style"
    firstNibble=1;
    for(n=1; n<blockCnt; n++) {
      ulong loNibbleL, hiNibbleL;
      ulong loNibbleR, hiNibbleR;

      if (firstNibble) {
        loNibbleL=*from++;
        hiNibbleL=(loNibbleL>>4) & 0x0f;
        loNibbleL &= 0x0f;
        loNibbleR=*from++;
        hiNibbleR=(loNibbleR>>4) & 0x0f;
        loNibbleR &= 0x0f;
        todo--;
        if (todo<0) goto dviadpcmSDecode4BitExit;
        firstNibble=0;
      } else {
        loNibbleL=hiNibbleL;
        loNibbleR=hiNibbleR;
        firstNibble=1;
      }
      calcDVI(lValPred,loNibbleL,lIndex,lStep);
      *toL++=lValPred;
      calcDVI(rValPred,loNibbleR,rIndex,rStep);
      *toR++=rValPred;
      decoded++;
    }
\\\ */
  }

dviadpcmSDecode4BitExit:
  return decoded;
}
/* \\\ */

