/* $Id: narrator.h,v 1.11 2005/11/10 15:31:33 hjfrieden Exp $ */
OPT NATIVE
MODULE 'target/exec/io'
MODULE 'target/exec/types'
{#include <devices/narrator.h>}
NATIVE {DEVICES_NARRATOR_H} CONST

        /*        Device Options    */

NATIVE {NDB_NEWIORB}  CONST NDB_NEWIORB  = 0    /* Use new extended IORB           */
NATIVE {NDB_WORDSYNC} CONST NDB_WORDSYNC = 1    /* Generate word sync messages     */
NATIVE {NDB_SYLSYNC}  CONST NDB_SYLSYNC  = 2    /* Generate syllable sync messages */


NATIVE {NDF_NEWIORB}  CONST NDF_NEWIORB  = $1
NATIVE {NDF_WORDSYNC} CONST NDF_WORDSYNC = $2
NATIVE {NDF_SYLSYNC}  CONST NDF_SYLSYNC  = $4



        /*        Error Codes        */

NATIVE {ND_NoMem}       CONST ND_NOMEM       = - 2    /* Can't allocate memory                  */
NATIVE {ND_NoAudLib}    CONST ND_NOAUDLIB    = - 3    /* Can't open audio device                */
NATIVE {ND_MakeBad}     CONST ND_MAKEBAD     = - 4    /* Error in MakeLibrary call              */
NATIVE {ND_UnitErr}     CONST ND_UNITERR     = - 5    /* Unit other than 0                      */
NATIVE {ND_CantAlloc}   CONST ND_CANTALLOC   = - 6    /* Can't allocate audio channel(s)        */
NATIVE {ND_Unimpl}      CONST ND_UNIMPL      = - 7    /* Unimplemented command                  */
NATIVE {ND_NoWrite}     CONST ND_NOWRITE     = - 8    /* Read for mouth without write first     */
NATIVE {ND_Expunged}    CONST ND_EXPUNGED    = - 9    /* Can't open, deferred expunge bit set   */
NATIVE {ND_PhonErr}     CONST ND_PHONERR     = -20    /* Phoneme code spelling error            */
NATIVE {ND_RateErr}     CONST ND_RATEERR     = -21    /* Rate out of bounds                     */
NATIVE {ND_PitchErr}    CONST ND_PITCHERR    = -22    /* Pitch out of bounds                    */
NATIVE {ND_SexErr}      CONST ND_SEXERR      = -23    /* Sex not valid                          */
NATIVE {ND_ModeErr}     CONST ND_MODEERR     = -24    /* Mode not valid                         */
NATIVE {ND_FreqErr}     CONST ND_FREQERR     = -25    /* Sampling frequency out of bounds       */
NATIVE {ND_VolErr}      CONST ND_VOLERR      = -26    /* Volume out of bounds                   */
NATIVE {ND_DCentErr}    CONST ND_DCENTERR    = -27    /* Degree of centralization out of bounds */
NATIVE {ND_CentPhonErr} CONST ND_CENTPHONERR = -28    /* Invalid central phon                   */



        /* Input parameters and defaults */

NATIVE {DEFPITCH}    CONST DEFPITCH    = 110       /* Default pitch                    */
NATIVE {DEFRATE}     CONST DEFRATE     = 150       /* Default speaking rate (wpm)      */
NATIVE {DEFVOL}      CONST DEFVOL      = 64        /* Default volume (full)            */
NATIVE {DEFFREQ}     CONST DEFFREQ     = 22200     /* Default sampling frequency (Hz)  */
NATIVE {MALE}        CONST MALE        = 0         /* Male vocal tract                 */
NATIVE {FEMALE}      CONST FEMALE      = 1         /* Female vocal tract               */
NATIVE {NATURALF0}   CONST NATURALF0   = 0         /* Natural pitch contours           */
NATIVE {ROBOTICF0}   CONST ROBOTICF0   = 1         /* Monotone pitch                   */
NATIVE {MANUALF0}    CONST MANUALF0    = 2         /* Manual setting of pitch contours */
NATIVE {DEFSEX}      CONST DEFSEX      = MALE      /* Default sex                      */
NATIVE {DEFMODE}     CONST DEFMODE     = NATURALF0 /* Default mode                     */
NATIVE {DEFARTIC}    CONST DEFARTIC    = 100       /* 100% articulation (normal)       */
NATIVE {DEFCENTRAL}  CONST DEFCENTRAL  = 0         /* No centralization                */
NATIVE {DEFF0PERT}   CONST DEFF0PERT   = 0         /* No F0 Perturbation               */
NATIVE {DEFF0ENTHUS} CONST DEFF0ENTHUS = 32        /* Default F0 enthusiasm (in 32nds) */
NATIVE {DEFPRIORITY} CONST DEFPRIORITY = 100       /* Default speaking priority        */


            /*    Parameter bounds    */

NATIVE {MINRATE}     CONST MINRATE     = 40      /* Minimum speaking rate            */
NATIVE {MAXRATE}     CONST MAXRATE     = 400     /* Maximum speaking rate            */
NATIVE {MINPITCH}    CONST MINPITCH    = 65      /* Minimum pitch                    */
NATIVE {MAXPITCH}    CONST MAXPITCH    = 320     /* Maximum pitch                    */
NATIVE {MINFREQ}     CONST MINFREQ     = 5000    /* Minimum sampling frequency       */
NATIVE {MAXFREQ}     CONST MAXFREQ     = 28000   /* Maximum sampling frequency       */
NATIVE {MINVOL}      CONST MINVOL      = 0       /* Minimum volume                   */
NATIVE {MAXVOL}      CONST MAXVOL      = 64      /* Maximum volume                   */
NATIVE {MINCENT}     CONST MINCENT     = 0       /* Minimum degree of centralization */
NATIVE {MAXCENT}     CONST MAXCENT     = 100     /* Maximum degree of centralization */

        /*    Standard Write request    */

NATIVE {narrator_rb} OBJECT ndi
    {message}	iostd	:iostd /* Standard IORB                  */
    {rate}	rate	:UINT              /* Speaking rate (words/minute)   */
    {pitch}	pitch	:UINT             /* Baseline pitch in Hertz        */
    {mode}	mode	:UINT              /* Pitch mode                     */
    {sex}	sex	:UINT               /* Sex of voice                   */
    {ch_masks}	chmasks	:PTR TO UBYTE         /* Pointer to audio alloc maps    */
    {nm_masks}	nummasks	:UINT          /* Number of audio alloc maps     */
    {volume}	volume	:UINT            /* Volume. 0 (off) thru 64        */
    {sampfreq}	sampfreq	:UINT          /* Audio sampling freq            */
    {mouths}	mouths	:UBYTE            /* If non-zero, generate mouths   */
    {chanmask}	chanmask	:UBYTE          /* Which ch mask used (internal)  */
    {numchan}	numchan	:UBYTE           /* Num ch masks used (internal)   */
    {flags}	flags	:UBYTE             /* New feature flags              */
    {F0enthusiasm}	f0enthusiasm	:UBYTE      /* F0 excursion factor            */
    {F0perturb}	f0perturb	:UBYTE         /* Amount of F0 perturbation      */
    {F1adj}	f1adj	:BYTE             /* F1 adjustment in ±5% steps     */
    {F2adj}	f2adj	:BYTE             /* F2 adjustment in ±5% steps     */
    {F3adj}	f3adj	:BYTE             /* F3 adjustment in ±5% steps     */
    {A1adj}	a1adj	:BYTE             /* A1 adjustment in decibels      */
    {A2adj}	a2adj	:BYTE             /* A2 adjustment in decibels      */
    {A3adj}	a3adj	:BYTE             /* A3 adjustment in decibels      */
    {articulate}	articulate	:UBYTE        /* Transition time multiplier     */
    {centralize}	centralize	:UBYTE        /* Degree of vowel centralization */
    {centphon}	centphon	:PTR TO CHAR         /* Pointer to central ASCII phon  */
    {AVbias}	avbias	:BYTE            /* AV bias                        */
    {AFbias}	afbias	:BYTE            /* AF bias                        */
    {priority}	priority	:BYTE          /* Priority while speaking        */
    {pad1}	pad1	:BYTE              /* For alignment                  */
ENDOBJECT

        /*    Standard Read request    */

NATIVE {mouth_rb} OBJECT mrb
    {voice}	ndi	:ndi /* Speech IORB                 */
    {width}	width	:UBYTE              /* Width (returned value)      */
    {height}	height	:UBYTE             /* Height (returned value)     */
    {shape}	shape	:UBYTE              /* Internal use, do not modify */
    {sync}	sync	:UBYTE               /* Returned sync events        */
ENDOBJECT
