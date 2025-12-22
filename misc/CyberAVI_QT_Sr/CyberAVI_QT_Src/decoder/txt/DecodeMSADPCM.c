/*
sc:c/sc opt txt/DecodeMSADPCM.c
*/

#include "Decode.h"

#define MSADPCM_NUM_COEF        (7)
#define MSADPCM_MAX_CHANNELS    (2)

#define MSADPCM_CSCALE          (8)
#define MSADPCM_PSCALE          (8)
#define MSADPCM_CSCALE_NUM      (1 << MSADPCM_CSCALE)
#define MSADPCM_PSCALE_NUM      (1 << MSADPCM_PSCALE)

#define MSADPCM_DELTA4_MIN      (16)

#define MSADPCM_OUTPUT4_MAX     (7)
#define MSADPCM_OUTPUT4_MIN     (-8)

#define bBitsPerSample 8
#define bPredictors 7
#define wBlockHeaderBytes 7

struct MSADPCMData {
  short samplesPerBlock;
};

short gaiP4[]={
  230, 230, 230, 230, 307, 409, 512, 614, 768, 614, 512, 409, 307, 230, 230, 230
};

short gaiCoef1[]={
  256, 512,   0, 192, 240, 460, 392
};

short gaiCoef2[]={
    0,-256,  0,   64,   0,-208,-232
};

/* /// "DecodeMSADPCMMono()" */
__asm ulong DecodeMSADPCMMono(REG(a0) uchar *from,
                              REG(a1) short *toL,
                              REG(a2) short *toR,
                              REG(d0) ulong size,
                              REG(a3) struct MSADPCMData *spec)
{
  short wSamplesPerBlock;
  ulong dwTotalPos, dwDecoded, dwSrcLen;

  wSamplesPerBlock=spec->samplesPerBlock;
  dwDecoded=0;
  dwTotalPos=0;
  dwSrcLen=size;

  while (dwTotalPos<dwSrcLen) {
    short n;
    short aiSamp1, aiSamp2;
    short aiCoef1, aiCoef2;
    short aiDelta;
    long  lSamp, lPrediction;
    short iInput, iNextInput;
    short iFirstNibble, iDelta;
    uchar bPredictor;

    dwTotalPos+=wBlockHeaderBytes;
    if (dwTotalPos>dwSrcLen) goto adpcmDecode4BitExit;

    bPredictor=*from++;
    if (bPredictor>=bPredictors) {
      dwDecoded=0;
      goto adpcmDecode4BitExit;
    }
    aiCoef1=gaiCoef1[bPredictor];
    aiCoef2=gaiCoef2[bPredictor];
    aiDelta=get16pc(from);
    aiSamp1=get16pc(from);
    aiSamp2=get16pc(from);

    *toL++=aiSamp2;
    *toL++=aiSamp1;

    dwDecoded+=2;
        
    iFirstNibble=1;
    for (n=2; n<wSamplesPerBlock; n++) {
      char hiNibble,loNibble;

      if (iFirstNibble) {
        dwTotalPos++;
        if (dwTotalPos>dwSrcLen) goto adpcmDecode4BitExit;
        hiNibble=(*from) & 240;
        loNibble=(*from) << 4;
        iNextInput=((short)loNibble)/16;
        iInput=((short)hiNibble)/16;
        from++;
        iFirstNibble=0;
      } else {
        iInput=iNextInput;
        iFirstNibble=1;
      }

      iDelta=aiDelta;
      aiDelta=(short)((gaiP4[iInput & 15] * (long)iDelta) >> MSADPCM_PSCALE);
      if (aiDelta<MSADPCM_DELTA4_MIN) aiDelta=MSADPCM_DELTA4_MIN;

      lPrediction=(((long)aiSamp1*aiCoef1)+((long)aiSamp2*aiCoef2)) >> MSADPCM_CSCALE;
      lSamp=((long)iInput*iDelta)+lPrediction;

      if (lSamp>32767)
        lSamp=32767;
      else
        if (lSamp<-32768) lSamp=-32768;

      *toL++=lSamp;

      aiSamp2=aiSamp1;
      aiSamp1=(short)lSamp;
      dwDecoded++;
    }
  }
  adpcmDecode4BitExit:
  return dwDecoded;
}
/* \\\ */

/* /// "DecodeMSADPCMStereo()" */
__asm ulong DecodeMSADPCMStereo(REG(a0) uchar *from,
                                REG(a1) ushort *toL,
                                REG(a2) ushort *toR,
                                REG(d0) ulong size,
                                REG(a3) struct MSADPCMData *spec)
{
  short wSamplesPerBlock;
  ulong dwTotalPos,dwDecoded,dwSrcLen;

  wSamplesPerBlock=spec->samplesPerBlock;
  dwDecoded=0;
  dwTotalPos=0;
  dwSrcLen=size;

  while (dwTotalPos<dwSrcLen) {
    short n;
    short aiSamp1[2], aiSamp2[2];
    short aiCoef1[2], aiCoef2[2];
    short aiDelta[2];
    long  lSamp, lPrediction;
    short iInput, iNextInput;
    short iFirstNibble, iDelta;
    uchar bPredictor;
    ulong cnt;

    dwTotalPos+=wBlockHeaderBytes;
    if (dwTotalPos>dwSrcLen) goto adpcmDecode4BitExit;

    for (cnt=0; cnt<2; cnt++) {
      bPredictor=*from++;
      if (bPredictor>=bPredictors) {
        dwDecoded=0;
        goto adpcmDecode4BitExit;
      }
      aiCoef1[cnt]=gaiCoef1[bPredictor];
      aiCoef2[cnt]=gaiCoef2[bPredictor];
    }
    for (cnt=0; cnt<2; cnt++) aiDelta[cnt]=get16pc(from);
    for (cnt=0; cnt<2; cnt++) aiSamp1[cnt]=get16pc(from);
    for (cnt=0; cnt<2; cnt++) aiSamp2[cnt]=get16pc(from);

    *toL++=aiSamp2[0];
    *toL++=aiSamp1[0];
    *toR++=aiSamp2[1];
    *toR++=aiSamp1[1];

    dwDecoded+=2;

    iFirstNibble=1;
    for (n=2; n<wSamplesPerBlock; n++) {
      char hiNibble,loNibble;

      for (cnt=0; cnt<2; cnt++) {
        if (iFirstNibble) {
          dwTotalPos++;
          if (dwTotalPos>dwSrcLen) goto adpcmDecode4BitExit;
          hiNibble=(*from) & 240;
          loNibble=(*from) << 4;
          iNextInput=((short)loNibble)/16;
          iInput=((short)hiNibble)/16;
          from++;
          iFirstNibble=0;
        } else {
          iInput=iNextInput;
          iFirstNibble=1;
        }

        iDelta=aiDelta[cnt];
        aiDelta[cnt]=(short)((gaiP4[iInput & 15] * (long)iDelta) >> MSADPCM_PSCALE);
        if (aiDelta[cnt]<MSADPCM_DELTA4_MIN) aiDelta[cnt]=MSADPCM_DELTA4_MIN;

        lPrediction=(((long)aiSamp1[cnt]*aiCoef1[cnt])+((long)aiSamp2[cnt]*aiCoef2[cnt])) >> MSADPCM_CSCALE;
        lSamp=((long)iInput*iDelta)+lPrediction;

        if (lSamp>32767)
          lSamp=32767;
        else
          if (lSamp<-32768) lSamp=-32768;

        if (cnt==0)
          *toL++=lSamp;
        else
          *toR++=lSamp;

        aiSamp2[cnt]=aiSamp1[cnt];
        aiSamp1[cnt]=(short)lSamp;
      }
      dwDecoded++;
    }
  }
  adpcmDecode4BitExit:
  return dwDecoded;
}
/* \\\ */

