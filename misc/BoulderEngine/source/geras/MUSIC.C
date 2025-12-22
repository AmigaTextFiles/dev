#include "MUSICKERNEL.C"
/* =========================================
   == Music Routines for BOULDER DASH     ==
   ==  VER1.1          1994.03.10-14      ==
   =========================================
*/
AudioON()
{
 InitIOA();
 makewaves();
}
AudioOFF()
{
 StopVoices();
 FinishProg(0);
}

Audiopirst()
{
BYTE *wft;
int i,j,k;
 unitno=voiceMap[0]; wft=wptr;
 setwpv(wft,256,307,63,0);
 unitno=voiceMap[3]; wft=wptr;
 setwpv(wft,256,230,63,3);
 unitno=voiceMap[2]; wft=wptr+woffsets[2];
 setwpv(wft,83,200,63,2);
}
Audiopirst2(volume)
int volume;
{
  unitno=voiceMap[0];
  setpv(307,volume);
  unitno=voiceMap[3];
  setpv(230,volume);
  unitno=voiceMap[2];
  setpv(200,volume);
}

Audiodzin()
{
BYTE *wft;
int i,j,k;
LONG a0,a3;
 a0=voiceMap[0]; wft=wptr2+woffsets[6]; unitno=a0;
 setwpv(wft,wlen[6],261,63,0);
 a3=voiceMap[3]; wft=wptr2+woffsets[6]; unitno=a3;
 setwpv(wft,wlen[6],260,63,3);
}
Audiopip(volume)
int volume;
{
 unitno=voiceMap[0]; setpv(270,volume);
 unitno=voiceMap[3]; setpv(275,volume);
}
Audiodzin2(volume)
int volume;
{
 unitno=voiceMap[0];
 setpv(261,volume);
 unitno=voiceMap[3];
 setpv(260,volume);
}

