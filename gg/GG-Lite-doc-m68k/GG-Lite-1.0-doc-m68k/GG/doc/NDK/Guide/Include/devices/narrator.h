@DATABASE "gg:doc/NDK/Guide/Include/devices/narrator.h"
@MASTER   "gg:os-include/devices/narrator.h"
@REMARK   This file was created by ADtoHT 2.1 on 06-Jan-13 19:12:29
@REMARK   Do not edit
@REMARK   ADtoHT is © 1993-1995 Christian Stieber

@NODE MAIN "devices/narrator.h"
@TOC "gg:doc/NDK/Guide/TOC/MAIN"

@{"devices/narrator.h" LINK File}


@{b}Structures@{ub}

@{"mouth_rb" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 129}  @{"narrator_rb" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 94}


@{b}#defines@{ub}

@{"DEFARTIC" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 71}      @{"DEFCENTRAL" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 72}      @{"DEFF0ENTHUS" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 74}   @{"DEFF0PERT" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 73}    @{"DEFFREQ" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 63}
@{"DEFMODE" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 70}       @{"DEFPITCH" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 60}        @{"DEFPRIORITY" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 75}   @{"DEFRATE" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 61}      @{"DEFSEX" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 69}
@{"DEFVOL" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 62}        @{"FEMALE" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 65}          @{"MALE" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 64}          @{"MANUALF0" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 68}     @{"MAXCENT" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 89}
@{"MAXFREQ" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 85}       @{"MAXPITCH" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 83}        @{"MAXRATE" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 81}       @{"MAXVOL" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 87}       @{"MINCENT" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 88}
@{"MINFREQ" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 84}       @{"MINPITCH" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 82}        @{"MINRATE" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 80}       @{"MINVOL" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 86}       @{"NATURALF0" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 66}
@{"ND_CantAlloc" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 42}  @{"ND_CentPhonErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 54}  @{"ND_DCentErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 53}   @{"ND_Expunged" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 45}  @{"ND_FreqErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 51}
@{"ND_MakeBad" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 40}    @{"ND_ModeErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 50}      @{"ND_NoAudLib" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 39}   @{"ND_NoMem" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 38}     @{"ND_NoWrite" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 44}
@{"ND_PhonErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 46}    @{"ND_PitchErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 48}     @{"ND_RateErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 47}    @{"ND_SexErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 49}    @{"ND_Unimpl" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 43}
@{"ND_UnitErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 41}    @{"ND_VolErr" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 52}       @{"NDB_NEWIORB" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 25}   @{"NDB_SYLSYNC" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 27}  @{"NDB_WORDSYNC" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 26}
@{"NDF_NEWIORB" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 30}   @{"NDF_SYLSYNC" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 32}     @{"NDF_WORDSYNC" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 31}  @{"ROBOTICF0" LINK "gg:doc/NDK/Guide/Include/devices/narrator.h/File" 67}    

@ENDNODE
@NODE File "devices/narrator.h"
#ifndef DEVICES_NARRATOR_H
#define DEVICES_NARRATOR_H
/*
**      $VER: narrator.h 1.7 (12.3.1991)
**      Includes Release 45.1
**
**      V37 Narrator device C language include file
**
**      Copyright 1990, 1991 Joseph Katz/Mark Barton.
**      All rights reserved.
**
**      This include file (narrator.h) may be freely distributed
**      as long as the above copyright notice remains intact.
**
*/


#ifndef EXEC_IO_H
#include <@{"exec/io.h" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File"}>
#endif


                /*          Device Options      */

#define NDB_NEWIORB     0       /* Use new extended IORB                */
#define NDB_WORDSYNC    1       /* Generate word sync messages          */
#define NDB_SYLSYNC     2       /* Generate syllable sync messages      */


#define NDF_NEWIORB     (1 << @{"NDB_NEWIORB" LINK File 25})
#define NDF_WORDSYNC    (1 << @{"NDB_WORDSYNC" LINK File 26})
#define NDF_SYLSYNC     (1 << @{"NDB_SYLSYNC" LINK File 27})



                /*          Error Codes         */

#define ND_NoMem        -2      /* Can't allocate memory                */
#define ND_NoAudLib     -3      /* Can't open audio device              */
#define ND_MakeBad      -4      /* Error in @{"MakeLibrary" LINK "gg:doc/NDK/Guide/exec/MakeLibrary"} call            */
#define ND_UnitErr      -5      /* Unit other than 0                    */
#define ND_CantAlloc    -6      /* Can't allocate audio channel(s)      */
#define ND_Unimpl       -7      /* Unimplemented command                */
#define ND_NoWrite      -8      /* Read for mouth without write first   */
#define ND_Expunged     -9      /* Can't open, deferred expunge bit set */
#define ND_PhonErr     -20      /* Phoneme code spelling error                  */
#define ND_RateErr     -21      /* Rate out of bounds                   */
#define ND_PitchErr    -22      /* Pitch out of bounds                          */
#define ND_SexErr      -23      /* Sex not valid                        */
#define ND_ModeErr     -24      /* Mode not valid                       */
#define ND_FreqErr     -25      /* Sampling frequency out of bounds     */
#define ND_VolErr      -26      /* Volume out of bounds         */
#define ND_DCentErr    -27      /* Degree of centralization out of bounds */
#define ND_CentPhonErr -28      /* Invalid central phon                 */



                /* Input parameters and defaults */

#define DEFPITCH    110         /* Default pitch                        */
#define DEFRATE     150         /* Default speaking rate (wpm)                  */
#define DEFVOL      64          /* Default volume (full)                */
#define DEFFREQ     22200       /* Default sampling frequency (Hz)      */
#define MALE        0           /* Male vocal tract                     */
#define FEMALE      1           /* Female vocal tract                   */
#define NATURALF0   0           /* Natural pitch contours               */
#define ROBOTICF0   1           /* Monotone pitch                       */
#define MANUALF0    2           /* Manual setting of pitch contours     */
#define DEFSEX      @{"MALE" LINK File 64}        /* Default sex                                  */
#define DEFMODE     @{"NATURALF0" LINK File 66}   /* Default mode                 */
#define DEFARTIC    100         /* 100% articulation (normal)           */
#define DEFCENTRAL  0           /* No centralization                    */
#define DEFF0PERT   0           /* No F0 Perturbation                   */
#define DEFF0ENTHUS 32          /* Default F0 enthusiasm (in 32nds)     */
#define DEFPRIORITY 100         /* Default speaking priority            */


                        /*      Parameter bounds        */

#define MINRATE     40          /* Minimum speaking rate                */
#define MAXRATE     400         /* Maximum speaking rate                */
#define MINPITCH    65          /* Minimum pitch                        */
#define MAXPITCH    320         /* Maximum pitch                        */
#define MINFREQ     5000        /* Minimum sampling frequency           */
#define MAXFREQ     28000       /* Maximum sampling frequency           */
#define MINVOL      0           /* Minimum volume                       */
#define MAXVOL      64          /* Maximum volume                       */
#define MINCENT      0          /* Minimum degree of centralization     */
#define MAXCENT    100          /* Maximum degree of centralization     */


                /*    Standard Write request    */

struct narrator_rb {
        @{"struct IOStdReq" LINK "gg:doc/NDK/Guide/Include/exec/io.h/File" 27}  message;       /* Standard IORB                */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   rate;                   /* Speaking rate (words/minute) */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   pitch;                  /* Baseline pitch in Hertz              */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   mode;                   /* Pitch mode                   */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   sex;                    /* Sex of voice                 */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   *ch_masks;              /* Pointer to audio alloc maps  */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   nm_masks;               /* Number of audio alloc maps   */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   volume;                 /* Volume. 0 (off) thru 64      */
        @{"UWORD" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 55}   sampfreq;               /* Audio sampling freq                  */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   mouths;                 /* If non-zero, generate mouths */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   chanmask;               /* Which ch mask used (internal)*/
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   numchan;                /* Num ch masks used (internal) */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   flags;                  /* New feature flags            */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   F0enthusiasm;           /* F0 excursion factor          */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   F0perturb;              /* Amount of F0 perturbation    */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    F1adj;                  /* F1 adjustment in ±5% steps   */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    F2adj;                          /* F2 adjustment in ±5% steps   */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    F3adj;                  /* F3 adjustment in ±5% steps   */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    A1adj;                  /* A1 adjustment in decibels    */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    A2adj;                  /* A2 adjustment in decibels    */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    A3adj;                  /* A3 adjustment in decibels    */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   articulate;             /* Transition time multiplier   */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   centralize;             /* Degree of vowel centralization */
        char    *centphon;              /* Pointer to central ASCII phon  */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    AVbias;                 /* AV bias                      */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    AFbias;                 /* AF bias                      */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    priority;               /* Priority while speaking      */
        @{"BYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 58}    pad1;                   /* For alignment                */
    };



                /*    Standard Read request     */

struct mouth_rb {
        @{"struct  narrator_rb" LINK File 94} voice;      /* Speech IORB                  */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   width;                  /* Width (returned value)       */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   height;                 /* Height (returned value)      */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   shape;                  /* Internal use, do not modify  */
        @{"UBYTE" LINK "gg:doc/NDK/Guide/Include/exec/types.h/File" 62}   sync;                   /* Returned sync events         */
        };



#endif  /* DEVICES_NARRATOR_H */
@ENDNODE
