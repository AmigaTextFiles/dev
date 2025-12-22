/*
$VER: sound.h 51.4 (22.2.2007)
*/

/* sound objects methods and attributes */

#ifndef CLASSES_MULTIMEDIA_SOUND_H
#define CLASSES_MULTIMEDIA_SOUND_H

#include <classes/multimedia/multimedia.h>

/* formats */

#define MMF_AUDIOMASK            0x00001000
#define MMF_AUDIOBIT             12

#define MMF_AUDIO_PCM8           (MMF_AUDIOMASK | 1)	/* 8-bit PCM integer signed */
#define MMF_AUDIO_PCM16BE        (MMF_AUDIOMASK | 2)  /* 16-bit PCM integer signed big endian */
#define MMF_AUDIO_PCM24BE        (MMF_AUDIOMASK | 3)  /* 24-bit PCM integer signed big endian */
#define MMF_AUDIO_PCM32BE        (MMF_AUDIOMASK | 4)  /* 32-bit PCM integer signed big endian */
#define MMF_AUDIO_PCM16LE        (MMF_AUDIOMASK | 5)  /* 16-bit PCM integer signed low endian */
#define MMF_AUDIO_PCM24LE        (MMF_AUDIOMASK | 6)  /* 24-bit PCM integer signed low endian */
#define MMF_AUDIO_PCM32LE        (MMF_AUDIOMASK | 7)  /* 32-bit PCM integer signed low endian */
#define MMF_AUDIO_PCM8U          (MMF_AUDIOMASK | 8)  /* 8-bit PCM integer unsigned */
#define MMF_AUDIO_MPEG           (MMF_AUDIOMASK | 9)  /* MPEG audio, norm 1, 2, 2.5, layer I, II, III */
#define MMF_AUDIO_PCMF32LE       (MMF_AUDIOMASK | 10) /* 32-bit PCM floating point low endian */
#define MMF_AUDIO_MULAW          (MMF_AUDIOMASK | 11) /* 8-bit nonlinear mu-law PCM */
#define MMF_AUDIO_ALAW           (MMF_AUDIOMASK | 12) /* 8-bit nonlinear A-law PCM */
#define MMF_AUDIO_IMA_ADPCM      (MMF_AUDIOMASK | 13) /* 3/4 bit IMA ADPCM */
#define MMF_AUDIO_PCMF32BE       (MMF_AUDIOMASK | 14) /* 32-bit PCM floating point big endian */


/* methods */

#define MMM_Sound_SignalAtEnd    (MMA_Dummy + 352)

struct mmopSoundSignalAtEnd
{
	ULONG MethodID;
  struct Task *SigTask;         /* task to be signalled at end of sound */
  ULONG SigBit;                 /* signal NUMBER (not mask) to be sent */
};

#define MMM_Sound_ReplyMsgAtEnd (MMA_Dummy + 353)

struct mmopSoundReplyMsgAtEnd
{
	ULONG MethodID;
	struct Message *MsgToReply;   /* message to be replied at end of sound */
};


/* attributes */

#define MMA_Sound_Channels       (MMA_Dummy + 300) /* number of sound channels */
#define MMA_Sound_SampleRate     (MMA_Dummy + 301) /* sampling rate */

/* SNDA_FrameCount attribute is 64-bit, it takes a pointer to QUAD. */

#define MMA_Sound_FrameCount     (MMA_Dummy + 302) /* total frame count */
#define MMA_Sound_Volume         (MMA_Dummy + 303) /* default sound volume (max if not specified) */
#define MMA_Sound_BitsPerSample  (MMA_Dummy + 304) /* 64 max */
#define MMA_Sound_AhiUnit        (MMA_Dummy + 305) /* audio.output */

/*----------------------------------------------------------------------------*/
/*  fir.filter                                                                */
/*----------------------------------------------------------------------------*/

#define MMA_FirFilter_Table      (MMA_Dummy + 1000)  /* filter taps */
#define MMA_FirFilter_Taps       (MMA_Dummy + 1001)  /* number of filter taps */

/*----------------------------------------------------------------------------*/
/*  soundloop.filter                                                          */
/*----------------------------------------------------------------------------*/

#define MMA_SoundLoop_Start      (MMA_Dummy + 1002)
#define MMA_SoundLoop_End        (MMA_Dummy + 1003)
#define MMA_SoundLoop_Count      (MMA_Dummy + 1004)

#endif /* CLASSES_MULTIMEDIA_SOUND_H */
