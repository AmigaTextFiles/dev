/*----------------------------------------------------------------------------*

  EMODULES: Prelude ( Prelude.library 2.64 )
                                             Date :25 Jul 98
 *----------------------------------------------------------------------------*/

OPT MODULE
OPT EXPORT

MODULE 'exec/nodes'

/***********************************************

FLAGS defined for prelude library routines.

***********************************************/

/*  These are BITs for the state of each channel*/

CONST PRL_PlayActive=$01,
      PRL_RecActive=$02,
      PRL_LeftActive=$10,
      PRL_RightActive=$20,

/*  These are INPUTs for the sampling device */

      PRL_InLINE=$00,
      PRL_InAUX1=$40,
      PRL_InMIC=$80,
      PRL_LoopBack=$c0,

/*  These are MODE BITs for the sampling device */

      PRL_Stereo=$10,          /* if this bit is NOT set, Mode is MONO        */
      PRL_Compressed=$20,      /* SET: means compressed sound data, format in
                                      PRL_FMT: 0 - ULAW
                                               1 - ALAW
                                 CLR: means linear sound data, format in
                                      PRL_FMT: 0 -  8 BIT
                                               1 - 16 BIT (LittleEndian)
                                */
      PRL_FMT=$40,              /* see above */
      PRL_FMTX=$80,             /* if this bit is SET there are more
                                 sampling/playback formats available:
                                 if using 16Bit uncompressed mode
                                    ( PRL_FMT = 1
                                      PRL_Compressed = 0 )
                                 BigEndian is used instead of LittleEndian
                                 if using 8Bit ULAW mode
                                    ( PRL_FMT = 0
                                      PRL_Compressed = 1 )
                                 ADPCM 4-bit (IMA compatible) is used.
                                other modes are not implemented and should
                                be left al1.
                               */

/* these are bits for the MONO amplifier of the Prelude */

      MONO_OUT_BYPASS=$20,     /* Mono In muted, Mono Out mixed  */
      MONO_OUT_THROUGH=$00,    /* Mono In mixed to Out */
      MONO_OUT_MUTE=$40,       /* Mono Out muted, Mono In mixed */

/*.......................................................................

  TAGs to change PrlCtrl structure

  .......................................................................*/

      PRL_VOL_LINE_LEFT=$80000000+14,    /* VolumeLeftLine */
      PRL_VOL_LINE_RIGHT=$80000000+15,   /* VolumeRightLine */
      PRL_VOL_A1_LEFT=$80000000+1 ,      /* VolumeLeftAux1; */
      PRL_VOL_A1_RIGHT=$80000000+2 ,     /* VolumeRightAux1; */
      PRL_VOL_A2_LEFT=$80000000+3 ,      /* VolumeLeftAux2; */ 
      PRL_VOL_A2_RIGHT=$80000000+4 ,     /* VolumeRightAux2; */
      PRL_VOL_MONO=$80000000+13,         /* VolumeMono Control */
      PRL_VOL_LOOPB=$80000000+16,        /* VolumeLoopback */
      PRL_VOL_DAC_LEFT=$80000000+5,      /* DACVolumeLeft; */  
      PRL_VOL_DAC_RIGHT=$80000000+6,     /* DACVolumeRight; */
      PRL_ING_LEFT=$80000000+7 ,         /* InputGainLeft; */
      PRL_ING_RIGHT=$80000000+8 ,        /* InputGainRight; */
      PRL_MING_LEFT=$80000000+21,        /* Left  MIC Gain */
      PRL_MING_RIGHT=$80000000+22,       /* Right MIC Gain */
      PRL_INPUT_LEFT=$80000000+9 ,       /* LeftInput; */
      PRL_INPUT_RIGHT=$80000000+10,      /* RightInput; */
      PRL_SMPL_MODE=$80000000+11,        /* SamplingMode */
      PRL_HPF=$80000000+20,              /* Enable/Disable HP-Filter */
      PRL_FREQUENCY=$80000000+12,        /* Frequency */
      PRL_IRQ_SIZE=$80000000+24,         /* IRQ Size*/

/*.......................................................................


  additional offset defines for use in PrlPlayBuff calls

  .......................................................................*/

      PRL_BUFF_1=$80000000+32,            /* Start of first buffer */
      PRL_BUFF_2=$80000000+33,            /* start of second buffer */
      PRL_BUFF_LENGTH=$80000000+36,       /* overall length in bytes
                                             of buffer */
      PRL_LOOP=$80000000+34,              /* start of loop */
      PRL_LOOP_END=$80000000+35,          /* end point of loop
                                             NOTE: if 1 of the
                                             running pointers has
                                             reached this address the
                                             loop is started at its
                                             start address */
      PRL_OSET_RUN=$80000000+37,          /* number of bytes to be
                                             played before skipping
                                             pause_offset bytes */
      PRL_OSET_PAUSE=$80000000+38,        /* number of bytes to be
                                             skipped - signed! */
      PRL_SIG_ADR=$80000000+40,           /* address where a signal
                                             shall be sent.
                                             NOTE: if 1 of the
                                             running pointers has
                                             reached this address the
                                             task is signalled. */
      PRL_SIG_TASK=$80000000+41,          /* (struct Task *) to be
                                              signalled */ 
      PRL_SIG_MASK=$80000000+42,          /* signal mask to be sent
                                             to the task*/
/*
-----------------------------------------------------------------------
                internal status bits
-----------------------------------------------------------------------
*/
      PRL_STATUS_PLAYING=$1000,
      PRL_STATUS_FIFOUSE=$2000,
      PRL_STATUS_IRQRUN=$4000,
      PRL_STATUS_NOIRQ=$8000,
      PRL_STATUS_PLAYPAUSE=$100,
      PRL_STATUS_RECPAUSE=$200,
      PRL_STATUS_REGISTER=$400,

/*-----------------------------------------------------------------
*/
      RL_err_ok=0,
      PRL_err_mem=1,
      PRL_err_ni=2,
      PRL_err_noIRQ=3,
      MANUID=$4231,
      MANUPROD=1



OBJECT prlctrl
   baseadress:LONG
   volumeleftline:CHAR
   volumerightline:CHAR
   volumeleftaux1:CHAR
   volumerightaux1:CHAR
   volumeleftaux2:CHAR
   volumerightaux2:CHAR
   volumemonoin:CHAR
   volumeloopback:CHAR         /* LoopBack control */
   volumeleftdac:CHAR
   volumerightdac:CHAR
   inputgainleft:CHAR
   inputgainright:CHAR
   leftinput:CHAR              /* which channel is to be used for sampling left */
   rightinput:CHAR             /* which channel is to be used for sampling right*/
   runningmode:CHAR
   samplingmode:CHAR           /* See Flags below */
   datalength:CHAR             /* 1 or 2 depending on Sampling Mode (8Bit or 16Bit) */
   dummy1:CHAR
   frequency:INT               /* possible frequencies are:
                                   5510 Hz
                                   6620 Hz    
                                   8000 Hz   - Telecom
                                   9600 Hz
                                  11025 Hz
                                  16000 Hz   - musical standard
                                  18900 Hz
                                  22050 Hz   - Amiga optimal sound ( CD/2 )
                                  27420 Hz
                                  32000 Hz   - DAT LongPlay / DSR
                                  33075 Hz
                                  37800 Hz
                                  44100 Hz   - CD (Philips Standard)
                                  48000 Hz   - DAT Standard
                                  ----------
                                  54860 HZ   - Works, but no warrenty
                                  64000 HZ   - Works, but no warrenty
                                          */

  filterenabled:CHAR             /* enables High Pass filter of the ADC.
                                   - forces the ADC offset to 0 ! */
   lmicgainenabled:CHAR          /* enables left  MIC 20dB Gain */
   rmicgainenabled:CHAR          /* enables right  MIC 20dB Gain */
   lasterror:CHAR
   play_samplestart1:LONG        /* These are pointers to actually used */
   play_samplestart2:LONG        /* memory areas */
   play_sampleend1:LONG
   play_sampleend2:LONG
   play_pointer1:LONG            /* They are updated by the library constantly */
   play_pointer2:LONG            /* and can be used e.g. to get the latest */
   rec_samplestart1:LONG         /* single sample value */ 
   rec_samplestart2:LONG
   rec_sampleend1:LONG
   rec_sampleend2:LONG
   rec_pointer1:LONG
   rec_pointer2:LONG
   pl_anchor:LONG                 /* Anchor for Playlist and other goodies */
   sig_sneak:LONG                 /* Sig Adress Pointer for Record and Play */
   pl_sigtask:LONG                /* Task to signal when getting new
                                      Playpointers from Playlist */
   pl_sigmask:LONG                /* SigMask to signal to that task */
   mprl_userdata:LONG
   play_offset:INT                /* actual value of bytes to play before adding
                                      pause_offset_play */
   record_offset:INT              /* actual value of bytes to record before adding
                                      pause_offset_record */
   pause_offset_play:INT          /* actual value to add after play_offset bytes
                                      have been played */
   pause_offset_record:INT        /* actual value to add after record_offset bytes
                                      have been recorded */
   prl_status:INT                 /* internal Status register */
   playcounter:LONG               /* on request. This pointer may be written to, it is
                                      incremented on every IRQ call by the number of bytes
                                      being transfered to the FIFOs. */
   reccounter:LONG                /* on request. This pointer may be written to, it is
                                      incremented on every IRQ call by the number of bytes
                                      being transfered from the FIFOs. */
   playlistcount:LONG             /* on request. This pointer may be written to, it is
                                     incremented every time a new playlist entry is being
                                     added by a play call - and decreased every time a
                                     playlist entry is being called into actual playback.
                                     */
   irqsize:LONG                   /* on heavy demand: this value can be set in
	                                  PreludeInit() only - it defines the amount of
	                                  data transferred in one IRQ. It must be at
	                                  least 16 and may have a maximum of 512.
                                     */
ENDOBJECT


OBJECT preludebase
   node:ln
   flags:CHAR
   pad:CHAR
   negsize:INT
   possize:INT
   version:INT
   revision:INT
   idstring:PTR TO CHAR
   sum:LONG
   opencnt:INT
   pr_flags:CHAR
   pr_count:CHAR
   pr_execbase:LONG
   pr_doslib:LONG
   pr_seglist:LONG
   pr_explib:LONG
   pr_cardad:LONG
   pr_prlctrl:LONG
   pr_irq:LONG
   pr_sigtask:LONG                   /*  for IRQ signalling    */
   pr_sigmask:LONG                   /*  e.g. Level Meter	  */
   pr_sneaktask:LONG                 /*  for Sneak Signalling  */
   pr_sneakmask:LONG                 /*  e.g. Record           */
   pr_lastplaypointer:LONG
   pr_lastrecpointer:LONG
   pr_cardsa:LONG
ENDOBJECT

