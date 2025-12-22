 
#include "exec/types.h"
#include "exec/memory.h"
#include "devices/audio.h"
#include "stdio.h"
 
#define  PRIORITY          10L    /* Priority for Audio Channel usage */
#define  NBR_IOA_STRUCTS   10L    /* Number of IOAudio structures used */
#define  PV_IOA_STRUCT     0L     /* index to ioapv struct */
#define  FIN_IOA_STRUCT    9L     /* index to finishioa struct */
#define  BIG_WAVE          256L   /* size of biggest waveform */
#define  NBR_WAVES         7L     /* number of waves per instrument */
#define  WAVES_TOTAL       1024L  /* alloc size for instrument's waves */
#define  YES               1L
#define  NO                0L
 
extern struct MsgPort *CreatePort();
extern void *AllocMem();
 
UBYTE aMap[] = { 0x0f };                  /* allocate four channels */
long  voiceMap[] = { 1, 2, 4, 8 };
struct IOAudio *ioa, *finishioa, *ioapv;
struct IOAudio *ioainuse[4];
struct IOAudio *freeioa[4];
long unitno = 1;
int error;
int waiting[4] = { NO, NO, NO, NO };
int woffsets[] =
   { 0, 256, 384, 448, 480, 496, 504, 508, 510 };
int wlen[] =
   { 256, 128, 64, 32, 16, 8, 4, 2, 1 };
int perval[] =
   { 428, 404, 381, 360, 339, 320, 302, 285, 269, 254, 240, 226, 214 };
BYTE *wptr,*wptr2;
BYTE *owptr[4] = { NULL, NULL, NULL, NULL };
 
char *portstring[] = {
   "Audio one",
   "Audio two",
   "Audio three",
   "Audio four",
   "Audio five",
   "Audio six",
   "Audio seven",
   "Audio eight" };              /* names for the CreatePorts */
 
STATIC BYTE Wave[]={
 0 , 3 , 8 , 12 , 16 , 13 , 20 , 23 , 21 , 39 , 38 , 38 , 51 , 39 , 58 ,
 61 , 53 , 56 , 62 , 65 , 69 , 69 , 64 , 63 , 60 , 78 , 74 , 73 , 64 , 84 , 79 ,
 81 , 86 , 85 , 78 , 83 , 79 , 84 , 80 , 84 , 86 , 88 , 86 , 87 , 90 , 91 , 96 ,
 98 , 103 , 97 , 100 , 102 , 109 , 100 , 101 , 115 , 115 , 117 , 124 , 106 , 114 , 113 , 103 ,
 114 , 118 , 105 , 109 , 106 , 115 , 121 , 102 , 98 , 99 , 101 , 112 , 107 , 113 , 105 , 102 ,
 103 , 97 , 92 , 92 , 93 , 91 , 87 , 86 , 87 , 86 , 88 , 81 , 90 , 85 , 85 , 86 ,
 89 , 78 , 74 , 68 , 74 , 70 , 77 , 62 , 62 , 63 , 68 , 77 , 61 , 50 , 61 , 53 ,
 54 , 56 , 61 , 43 , 36 , 39 , 46 , 40 , 27 , 27 , 19 , 27 , 21 , 13 , 12 , 7 ,
 3 , 0 ,-1 ,-4 ,-7 ,-7 ,-9 ,-10 ,-8 ,-6 ,-21 ,-11 ,-14 ,-15 ,-14 ,-16 ,
-13 ,-31 ,-17 ,-32 ,-21 ,-34 ,-47 ,-40 ,-26 ,-54 ,-38 ,-47 ,-57 ,-60 ,-57 ,-62 ,
-68 ,-65 ,-71 ,-73 ,-65 ,-76 ,-72 ,-76 ,-81 ,-81 ,-82 ,-86 ,-87 ,-87 ,-86 ,-84 ,
-86 ,-82 ,-82 ,-90 ,-78 ,-93 ,-86 ,-88 ,-84 ,-98 ,-86 ,-87 ,-93 ,-72 ,-71 ,-99 ,
-87 ,-80 ,-73 ,-95 ,-87 ,-83 ,-75 ,-84 ,-84 ,-84 ,-77 ,-78 ,-96 ,-91 ,-80 ,-85 ,
-86 ,-90 ,-92 ,-91 ,-85 ,-87 ,-87 ,-86 ,-82 ,-79 ,-78 ,-73 ,-76 ,-78 ,-73 ,-68 ,
-65 ,-58 ,-60 ,-55 ,-49 ,-40 ,-41 ,-53 ,-40 ,-53 ,-48 ,-50 ,-25 ,-25 ,-17 ,-42 ,
-26 ,-11 ,-26 ,-21 ,-32 ,-27 ,-18 ,-17 ,-6 ,-12 ,-4 ,-8 ,-6 ,-7 ,-5 ,-2 ,
-1 };
/* Sin Wave */
STATIC BYTE Wave2[]={
 0 , 3 , 6 , 9 , 12 , 15 , 18 , 21 , 24 , 27 , 30 , 33 , 36 , 39 , 42 ,
 45 , 48 , 51 , 53 , 56 , 59 , 62 , 64 , 67 , 70 , 72 , 75 , 77 , 79 , 82 , 84 ,
 86 , 89 , 91 , 93 , 95 , 97 , 99 , 101 , 103 , 104 , 106 , 108 , 109 , 111 , 112 , 113 ,
 115 , 116 , 117 , 118 , 119 , 120 , 121 , 122 , 122 , 123 , 124 , 124 , 125 , 125 , 125 , 125 ,
 125 , 126 , 125 , 125 , 125 , 125 , 125 , 124 , 124 , 123 , 122 , 122 , 121 , 120 , 119 , 118 ,
 117 , 116 , 115 , 113 , 112 , 111 , 109 , 108 , 106 , 104 , 103 , 101 , 99 , 97 , 95 , 93 ,
 91 , 89 , 86 , 84 , 82 , 79 , 77 , 75 , 72 , 70 , 67 , 64 , 62 , 59 , 56 , 53 ,
 51 , 48 , 45 , 42 , 39 , 36 , 33 , 30 , 27 , 24 , 21 , 18 , 15 , 12 , 9 , 6 ,
 3 , 0 ,-4 ,-7 ,-10 ,-13 ,-16 ,-19 ,-22 ,-25 ,-28 ,-31 ,-34 ,-37 ,-40 ,-43 ,
-46 ,-49 ,-52 ,-54 ,-57 ,-60 ,-63 ,-65 ,-68 ,-71 ,-73 ,-76 ,-78 ,-80 ,-83 ,-85 ,
-87 ,-90 ,-92 ,-94 ,-96 ,-98 ,-100 ,-102 ,-104 ,-105 ,-107 ,-109 ,-110 ,-112 ,-113 ,-114 ,
-116 ,-117 ,-118 ,-119 ,-120 ,-121 ,-122 ,-123 ,-123 ,-124 ,-125 ,-125 ,-126 ,-126 ,-126 ,-126 ,
-126 ,-126 ,-126 ,-126 ,-126 ,-126 ,-126 ,-125 ,-125 ,-124 ,-123 ,-123 ,-122 ,-121 ,-120 ,-119 ,
-118 ,-117 ,-116 ,-114 ,-113 ,-112 ,-110 ,-109 ,-107 ,-105 ,-104 ,-102 ,-100 ,-98 ,-96 ,-94 ,
-92 ,-90 ,-87 ,-85 ,-83 ,-80 ,-78 ,-76 ,-73 ,-71 ,-68 ,-65 ,-63 ,-60 ,-57 ,-54 ,
-52 ,-49 ,-46 ,-43 ,-40 ,-37 ,-34 ,-31 ,-28 ,-25 ,-22 ,-19 ,-16 ,-13 ,-10 ,-7 ,
-4 };

InitIOA()
   {
   int i;
   ioa = (struct IOAudio *)AllocMem((NBR_IOA_STRUCTS * (long)sizeof(*ioa)),
      MEMF_PUBLIC | MEMF_CLEAR);
   if (ioa == NULL)
      FinishProg(1);
   for (i = 0; i < 4; ++i)
      {
      ioainuse[i] = &ioa[i + 1];
      freeioa[i] = &ioa[i + 5];
      }
   ioapv = &ioa[PV_IOA_STRUCT];
   finishioa = &ioa[FIN_IOA_STRUCT];
   ioa->ioa_Request.io_Message.mn_Node.ln_Pri = PRIORITY;
   ioa->ioa_Request.io_Message.mn_ReplyPort =
      CreatePort("Audio zero", 0L);
   if (ioa->ioa_Request.io_Message.mn_ReplyPort == NULL)
      FinishProg(2);
   ioa->ioa_Data = aMap;
   ioa->ioa_Length = (long)sizeof(aMap);
   error = OpenDevice(AUDIONAME, 0L, ioa, 0L);
   if (error)
      FinishProg(3);
   *finishioa = *ioa;
   finishioa->ioa_Request.io_Flags = IOF_QUICK;
   ioapv->ioa_Request.io_Flags = IOF_QUICK;
 
   finishioa->ioa_Request.io_Command = ADCMD_FINISH;
   ioapv->ioa_Request.io_Command = ADCMD_PERVOL;
   for (i = 0; i < 4; ++i)
      {
      *freeioa[i] = *ioa;
      *ioainuse[i] = *ioa;
      freeioa[i]->ioa_Request.io_Message.mn_ReplyPort =
         CreatePort(portstring[i], 0L);
      ioainuse[i]->ioa_Request.io_Message.mn_ReplyPort =
         CreatePort(portstring[i + 4], 0L);
      }
   for (i = 0; i < 4; ++i)
      if (freeioa[i]->ioa_Request.io_Message.mn_ReplyPort == NULL ||
         ioainuse[i]->ioa_Request.io_Message.mn_ReplyPort == NULL)
         FinishProg(4);
   }
char *errormsgs[] = {
   "Finished!\n",
   "Cannot allocate memory for IOAudio structures\n",
   "Cannot create ReplyPort for OpenDevice call\n",
   "Cannot open Audio Device\n",
   "Cannot create ReplyPort(s) for remaining IOAudio structures\n",
   "Cannot allocate memory for waveform\n",
   "If you see this during execution, execute the programmer.\n" };
 
FinishProg(finishcode)
   int finishcode;
   {
   int i;
 
   printf(errormsgs[finishcode]);
   switch(finishcode)
      {
   case 0:
      /* free up the WaveNode list
       * (currently, just wptr)
       */
      FreeMem(wptr, WAVES_TOTAL);
      FreeMem(wptr2, WAVES_TOTAL);
   case 4:
   case 5:
      for (i = 0; i < 4; ++i)
         {
         if (freeioa[i]->ioa_Request.io_Message.mn_ReplyPort)
            DeletePort(freeioa[i]->ioa_Request.io_Message.mn_ReplyPort);
         if (ioainuse[i]->ioa_Request.io_Message.mn_ReplyPort)
            DeletePort(ioainuse[i]->ioa_Request.io_Message.mn_ReplyPort);
         }
      CloseDevice(ioa);
 
   case 3:
      DeletePort(ioa->ioa_Request.io_Message.mn_ReplyPort);
 
   case 2:
      FreeMem(ioa, (NBR_IOA_STRUCTS * (long)sizeof(*ioa)));
 
      }
   if (finishcode)
      exit(1L);
   exit(0L);
   }
 
setwpv(wf, len, per, vol, voice)
   char *wf;
   int len, per, vol, voice;
   {
   struct IOAudio *tmpioa;
   freeioa[voice]->ioa_Request.io_Command = CMD_WRITE;
   freeioa[voice]->ioa_Request.io_Flags = ADIOF_PERVOL | IOF_QUICK;
   freeioa[voice]->ioa_Cycles = 0;
   freeioa[voice]->ioa_Request.io_Unit = (struct Unit *)unitno;
   finishioa->ioa_Request.io_Unit = (struct Unit *)unitno;
   freeioa[voice]->ioa_Data = (UBYTE *)wf;
   freeioa[voice]->ioa_Length = len;
   freeioa[voice]->ioa_Period = per;
   freeioa[voice]->ioa_Volume = vol;
   if (waiting[voice])
      {
      BeginIO(finishioa);
      WaitIO(ioainuse[voice]);
      waiting[voice] = NO;
      }
 
   /* now start up the new voice
    */
   BeginIO(freeioa[voice]);
   error = CheckIO(freeioa[voice]);
   if (error)
      {
      printf("Error on CMD_WRITE\n");
      WaitIO(freeioa[voice]);
      }
   waiting[voice] = YES;
   tmpioa = ioainuse[voice];
   ioainuse[voice] = freeioa[voice];
   freeioa[voice] = tmpioa;
   }
 
setpv(per, vol)
   int per, vol;
   {
   ioapv->ioa_Period = per;
   ioapv->ioa_Volume = vol;
   ioapv->ioa_Request.io_Unit = (struct Unit *)unitno;
   BeginIO(ioapv);
   }
StopVoices()
   {
   int voice;
 
   for (voice = 0; voice < 4; ++voice)
      {
      if (waiting[voice])
         {
         unitno = voiceMap[voice];
         setpv(128, 0);
         finishioa->ioa_Request.io_Unit = (struct Unit *)unitno;
         BeginIO(finishioa);
         WaitIO(ioainuse[voice]);
         waiting[voice] = NO;
         }
      }
   }
 
setwave2(wfp)
BYTE *wfp;
  {
   int i;
   for(i=0;i<BIG_WAVE;++i) { wfp[i]=Wave2[i]; }
  }

setwave(wfp)
   BYTE *wfp;
   {
   int i;
   for(i=0;i<BIG_WAVE;++i)
    {
      wfp[i]=Wave[i];
    }
} 
xpandwave(wfp)
   BYTE *wfp;
   {
   int i, j, rate;
   BYTE *tptr;
 
   rate = 1;
   tptr = wfp + BIG_WAVE;
   for (i = 0; i < NBR_WAVES - 1; ++i)
      {
      rate *= 2;
      for (j = 0; j < BIG_WAVE; j += rate)
         *tptr++ = wfp[j];
      }
   }
 
makewaves()
   {
   /* allocate the memory for the waveform.
    */
   wptr = (BYTE *)AllocMem(WAVES_TOTAL, MEMF_CHIP);
   if (wptr == NULL)
      FinishProg(5);
   setwave(wptr);
   xpandwave(wptr);
   wptr2 = (BYTE *)AllocMem(WAVES_TOTAL, MEMF_CHIP);
   if (wptr == NULL)
      FinishProg(5);
   setwave2(wptr2);
   xpandwave(wptr2);
   }
 
strike(note, voice)
   int note, voice;
   {
   int per, oct, len;
   BYTE *wfp;
 
   unitno = voiceMap[voice];
   if (note >= 100)           /* play a rest. */
      {
      if (waiting[voice])
         setpv(200, 0);
      return;
      }
   oct = note / 12;
   per = perval[note % 12];
   wfp = wptr + woffsets[oct];
   if (wfp == owptr[voice])
      setpv(per, 32);         /* fixed volume */
   else
      {
      setwpv(wfp, wlen[oct], per, 32, voice);
      owptr[voice] = wfp;
      }
   }
 
