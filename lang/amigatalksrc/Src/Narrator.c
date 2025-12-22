/****h* AmigaTalk/Narrator.c [3.0] ***************************************
*
* NAME
*    Narrator.c
* 
* DESCRIPTION
*    Implement AmigaTalk control over serial devices.
*
* HISTORY
*    25-Oct-2004 - Added AmigaOS4 & gcc Support.
*
*    07-Jan-2003 - Moved all string constants to StringConstants.h
*
* TODO
*    Change these functions to use timed serial I/O.
*
* NOTES
*    $VER: AmigaTalk:Src/Narrator.c 3.0 (25-Oct-2004) by J.T. Steichen
************************************************************************
*
*/

#include <exec/types.h>
#include <exec/memory.h>
#include <exec/exec.h>

#include <AmigaDOSErrs.h> 

#include <devices/narrator.h>
#include <libraries/translator.h> // just error codes here.

#ifdef    __SASC
# include <clib/exec_protos.h>
# include <clib/translator_protos.h>
#else

# define  __CLIB_PRAGMA_LIBCALL
# include <pragmas/translator_pragmas.h> // will this work??

# define __USE_INLINE__

# include <proto/exec.h>

//# include <proto/translator.h> //This is broken
//PRIVATE struct TranslatorIFace *ITranslator; //this does NOT exist!

#endif

PRIVATE struct Library *TranslatorBase = NULL;

#include "CPGM:GlobalObjects/CommonFuncs.h"

#include "Constants.h"
#include "IStructs.h"
#include "FuncProtos.h"

#include "StringConstants.h"
#include "StringIndexes.h"

IMPORT BOOL   debug;
IMPORT UBYTE *AllocProblem;
IMPORT UBYTE *ErrMsg;

IMPORT int      ChkArgCount( int need, int numargs, int primnumber );

IMPORT OBJECT   *ReturnError( void );
IMPORT OBJECT   *PrintArgTypeError( int primnumber );
IMPORT OBJECT   *PrintNumberError( void );

/*

// Error Codes that might occur:

#define ND_NoMem	-2	// Can't allocate memory
#define ND_NoAudLib	-3	// Can't open audio device
#define ND_MakeBad	-4	// Error in MakeLibrary call
#define ND_UnitErr	-5	// Unit other than 0
#define ND_CantAlloc	-6	// Can't allocate audio channel(s)
#define ND_Unimpl	-7	// Unimplemented command
#define ND_NoWrite	-8	// Read for mouth without write first
#define ND_Expunged	-9	// Can't open, deferred expunge bit set
#define ND_PhonErr     -20	// Phoneme code spelling error
#define ND_CentPhonErr -28	// Invalid central phoneme

// Standard Read request

struct mouth_rb {

   struct narrator_rb voice;  // Speech IORB
   UBYTE              width;  // Width (returned value)
   UBYTE              height; // Height (returned value)
   UBYTE              shape;  // Internal use, do not modify
   UBYTE              sync;   // Returned sync events

};

*/

PRIVATE BYTE                audio_chan[4] = { 3, 5, 10, 12 };
     
PRIVATE struct MsgPort     *narPort = NULL;
PRIVATE struct narrator_rb *ATalker = NULL;

PRIVATE struct MsgPort     *MouthMP = NULL;
PRIVATE struct mouth_rb    *ATMouth = NULL;

PRIVATE BOOL NarratorDeviceOpened = FALSE;

IMPORT char *NarrErrMsgs[33]; // Located in CatFuncs2.c

/****i* NarratorErrIs() [1.6] ******************************************
*
* NAME
*    NarratorErrIs() <230 21 errNum>
*
* DESCRIPTION
*    Translate the error number to a string.
************************************************************************
*
*/

METHODFUNC char *NarratorErrIs( int errnum )
{
   if ((errnum < 0) && (errnum > -30))
      return( NarrErrMsgs[ -errnum ] );
   else if ((errnum <= 30) && (errnum >= 0))
      return( NarrErrMsgs[ errnum ] );
   else
      {
      sprintf( ErrMsg, NarrCMsg( MSG_NAERR_BADNUMBER_NARR ), errnum );
      
      return( ErrMsg );
      } 
}

/****i* CloseMouth() [1.6] *********************************************
*
* NAME
*    CloseMouth()
*
* DESCRIPTION
*    De-allocate memory & ports for the mouth_rb structs.
************************************************************************
*
*/

SUBFUNC void CloseMouth( void )
{
   if (ATMouth) // != NULL)
      {
      AT_FreeVec( ATMouth, "ATMouth", TRUE );
      ATMouth = NULL;
      }
      
   if (MouthMP) // != NULL)
      {
      DeletePort( MouthMP );
      MouthMP = NULL;
      }
      
   return;
}

/****i* CreateMouth() [1.6] ********************************************
*
* NAME
*    CreateMouth()
*
* DESCRIPTION
*    Allocate memory & ports for the mouth_rb structs.
************************************************************************
*
*/

SUBFUNC int CreateMouth( struct narrator_rb *ATalker )
{
   if (!MouthMP) // == NULL)
      {
      if (!(MouthMP = (struct MsgPort *) 
                      CreatePort( "AmigaTalkNarr.read", 0 ))) // == NULL)
         {
         // error
         return( -29 );
         }
      }

   if (!ATMouth) // == NULL)
      {
      if (!(ATMouth = (struct mouth_rb *)
                      AT_AllocVec( sizeof( struct mouth_rb ),
                                   MEMF_CLEAR | MEMF_PUBLIC, 
                                   "ATMouth", TRUE ))) // == NULL)
         { 
         CloseMouth();
         return( ND_NoMem );
         }
      }      

   ATMouth->voice                                 = *ATalker;
   ATMouth->voice.message.io_Message.mn_ReplyPort = MouthMP;
   
   return( 0 );
}

/****i* sendNarratorCommand() [1.6] **********************************
*
* NAME
*    sendNarratorCommand()
*
* DESCRIPTION
*    send a command to the narrator device.  This function only 
*    sets up the command field, you must set related parameters
*    before you call this function.
**********************************************************************
*
*/

SUBFUNC int sendNarratorCommand( int command )
{
   if (ATalker) // != NULL)
      {
      ATalker->message.io_Command = command;
      
      DoIO( (struct IORequest *) ATalker );
      
      return( ATalker->message.io_Error );
      }

   return( -1 );
}

/****i* CloseNarrator() [1.6] ******************************************
*
* NAME
*    CloseNarrator()
*
* DESCRIPTION
*    Close the narrator.device & remove it from AmigaTalk program space.
************************************************************************
*
*/

METHODFUNC void CloseNarrator( void )
{
   IMPORT int ATSystem( char *command );

   if (ATalker) // != NULL)
      {
      sendNarratorCommand( CMD_STOP  );
      sendNarratorCommand( CMD_FLUSH );
      
      if (CheckIO( (struct IORequest *) ATalker ) == 0)
         AbortIO( (struct IORequest *) ATalker );

      WaitIO(      (struct IORequest *) ATalker );
      }

   if (NarratorDeviceOpened == TRUE)
      {
      CloseDevice( (struct IORequest *) ATalker );
      NarratorDeviceOpened = FALSE;
      }

   if (ATalker) // != NULL)
      {
      DeleteIORequest( (struct IORequest *) ATalker );
      ATalker = NULL;
      }

   if (narPort) // != NULL)
      {
      DeletePort( narPort );
      narPort = NULL;
      }

   if (TranslatorBase) // != NULL)
      {
/*
#     ifdef __amigaos4__
      DropInterface( (struct Interface *) ITranslator );
      ITranslator = NULL;
#     endif
*/
      CloseLibrary( TranslatorBase );
      TranslatorBase = NULL;
      }

   /* This call to Avail FLUSH is necessary to get rid of the
   ** narrator.device in memory so that the next run of AmigaTalk
   ** will NOT hang up at the first DoIO() of the first
   ** narrator command:
   */
   ATSystem( NarrCMsg( MSG_AVAIL_COMMAND_NARR ) );

   return;
}

#ifdef __SASC
# define  FASTMEM        MEMF_CLEAR | MEMF_PUBLIC | MEMF_FAST
#else
# define  FASTMEM        MEMF_CLEAR | MEMF_SHARED | MEMF_FAST
#endif

PRIVATE int BufferSize = 0;

/****i* OpenNarrator() [1.6] *******************************************
*
* NAME
*    OpenNarrator()
*
* DESCRIPTION
*
************************************************************************
*
*/

METHODFUNC int OpenNarrator( void )
{
   int chk = 0;

   if (!TranslatorBase) // == NULL)
      {
#     ifdef  __SASC
      if (!(TranslatorBase = OpenLibrary( "translator.library", 37L ))) // == NULL)
         {
         return( ND_MakeBad );
         }
#     else
      if ((TranslatorBase = OpenLibrary( "translator.library", 50L ))) // != NULL)
         {
/*
	 if (!(ITranslator = (struct TranslatorIFace *) GetInterface( TranslatorBase, "main", 1, NULL )))
	    {
	    CloseLibrary( TranslatorBase );
   
            return( ND_MakeBad );
	    }
*/
	 }
      else
         return( ND_MakeBad );
#     endif
      }
         
   if (!narPort) // == NULL)
      {
      if (!(narPort = (struct MsgPort *) CreatePort( "ATalkNarr.MPort", 0 ))) // == NULL)
         {
         // error
/*
#        ifdef __amigaos4__     
         DropInterface( (struct Interface *) ITranslator );
#        endif
*/
         CloseLibrary( TranslatorBase );

         return( -29 );
         }
      }

   if (!ATalker) // == NULL)
      {
      if (!(ATalker = (struct narrator_rb *) CreateIORequest( narPort, sizeof( struct narrator_rb ) ))) // == NULL)
         {
         CloseNarrator();

         return( -30 );
         }
      }      

   chk = OpenDevice( "narrator.device", 0, 
                     (struct IORequest *) ATalker, 0 
                   );
   
   if (chk != 0)
      {
      NarratorDeviceOpened = FALSE;

      CloseNarrator();

      return( ND_NoAudLib );
      }
   else
      NarratorDeviceOpened = TRUE;

   if (!ATMouth) // == NULL)
      {
      if ((chk = CreateMouth( ATalker )) < 0)
         {
         CloseNarrator();

         return( chk );
         }
      }

   // Set up default values here:

   ATalker->ch_masks     = &audio_chan[0];
   ATalker->nm_masks     = sizeof( audio_chan );
   ATalker->flags        = NDF_NEWIORB;
   ATalker->sampfreq     = DEFFREQ;
   ATalker->F0enthusiasm = DEFF0ENTHUS;
   ATalker->F0perturb    = DEFF0PERT;

   ATalker->F1adj        = 0;
   ATalker->F2adj        = 0;
   ATalker->F3adj        = 0;
   ATalker->A1adj        = 0;
   ATalker->A2adj        = 0;
   ATalker->A3adj        = 0;

   ATalker->articulate   = DEFARTIC;   
   ATalker->centralize   = DEFCENTRAL;
   ATalker->centphon     = "AE";
   ATalker->AVbias       = 0;
   ATalker->AFbias       = 0;
   ATalker->priority     = DEFPRIORITY;

   ATalker->volume       = MAXVOL / 2;
   ATalker->mode         = DEFMODE;
   ATalker->sex          = FEMALE;
   ATalker->pitch        = 260;       // contralto
   ATalker->rate         = DEFRATE;   // 150 wpm.
   ATalker->mouths       = 0xFF;      // Now we use CMD_READ.

   ATalker->message.io_Command = CMD_WRITE;
   ATalker->message.io_Offset  = 0;
   ATalker->message.io_Data    = NULL;   
   ATalker->message.io_Length  = 0;

   return( 0 );      
}

/****i* setNarratorVolume() [1.6] ************************************
*
* NAME
*    setNarratorVolume()  <230 2 newVolume>
*
* DESCRIPTION
*
**********************************************************************
*
*/

METHODFUNC int setNarratorVolume( int newVolume )
{
   int vol;
   
   if (newVolume > MAXVOL)
      vol = MAXVOL;
   else if (newVolume < MINVOL)
      vol = MINVOL;
   else
      vol = newVolume;

   ATalker->volume = vol;

   return( sendNarratorCommand( CMD_WRITE ) );
}

/****i* setNarratorSex() [1.6] ***************************************
*
* NAME
*    setNarratorSex()  <230 3 newSex>
*
* DESCRIPTION
*    set the Narrator sex.  Only Male or Female are available.
**********************************************************************
*
*/

METHODFUNC int setNarratorSex( int sex )
{
   switch (sex)
      {
      case FEMALE: // 1	= Female vocal tract
         break;
         
      case MALE:   // 0 = Male vocal tract
         break;
         
      default:     // use DEFSEX
         sex = DEFSEX;
         break;
      }

   ATalker->sex = sex;

   return( sendNarratorCommand( CMD_WRITE ) );      
}

/****i* setNarratorPitch() [1.6] *************************************
*
* NAME
*    setNarratorPitch()  <230 4 newPitch>
*
* DESCRIPTION
*    set the Narrator pitch.
**********************************************************************
*
*/

METHODFUNC int setNarratorPitch( int newPitch )
{
   if      (newPitch < MINPITCH)
      ATalker->pitch = MINPITCH;
   else if (newPitch > MAXPITCH)
      ATalker->pitch = MAXPITCH;
   else
      ATalker->pitch = newPitch;
      
   return( sendNarratorCommand( CMD_WRITE ) );
}        

/****i* setNarratorMode() [1.6] **************************************
*
* NAME
*    setNarratorMode()  <230 5 newMode>
*
* DESCRIPTION
*    set the Narrator speech mode.
**********************************************************************
*
*/

#ifdef __amigaos4__
# define __USE_INLINE__  
# include <proto/utility.h>
   IMPORT struct UtilityIFace *IUtility;
#endif    

METHODFUNC int setNarratorMode( char *newMode )
{
#  ifdef __amigaos4__
   if (StringIComp( newMode, NarrCMsg( MSG_NA_MODE_ROBOTIC_NARR ) ) == 0)
      ATalker->mode = ROBOTICF0;
   else if (StringIComp( newMode, NarrCMsg( MSG_NA_MODE_MANUAL_NARR ) ) == 0)
      ATalker->mode = MANUALF0;
#  else
   if (strnicmp( newMode, NarrCMsg( MSG_NA_MODE_ROBOTIC_NARR ), 5 ) == 0)
      ATalker->mode = ROBOTICF0;
   else if (strnicmp( newMode, NarrCMsg( MSG_NA_MODE_MANUAL_NARR ), 5 ) == 0)
      ATalker->mode = MANUALF0;
#  endif
   else
      ATalker->mode = NATURALF0;
       
   return( sendNarratorCommand( CMD_WRITE ) );
}

/****i* setWordRate() [1.6] ******************************************
*
* NAME
*    setWordRate()   <230 6 newRate>
*
* DESCRIPTION
*    set the Narrator words/minute speaking rate.
**********************************************************************
*
*/

METHODFUNC int setWordRate( int newRate )
{
   if      (newRate < MINRATE)
      ATalker->rate = MINRATE;
   else if (newRate > MAXRATE)
      ATalker->rate = MAXRATE;
   else
      ATalker->rate = newRate;

   return( sendNarratorCommand( CMD_WRITE ) );      
}

/****i* setFormant1() [1.6] ******************************************
*
* NAME
*    setFormant1()   <230 7 1 deviation>
*
* DESCRIPTION
*    Change the tuning of the lowest formant frequency.
*    Positive values raise the formant frequency (Default = 0).
*    RANGE: -100 to 100 by 5%
**********************************************************************
*
*/

METHODFUNC int setFormant1( int deviation )
{
   ATalker->F1adj = (BYTE) (deviation & 0xFF);

   return( sendNarratorCommand( CMD_WRITE ) );      
}

/****i* setFormant2() [1.6] ******************************************
*
* NAME
*    setFormant2()   <230 7 2 deviation>
*
* DESCRIPTION
*    Change the tuning of the middle formant frequency.
*    Positive values raise the formant frequency (Default = 0).
*    RANGE: -100 to 100 by 5%
**********************************************************************
*
*/

METHODFUNC int setFormant2( int deviation )
{
   ATalker->F2adj = (BYTE) (deviation & 0xFF);

   return( sendNarratorCommand( CMD_WRITE ) );      
}

/****i* setFormant3() [1.6] ******************************************
*
* NAME
*    setFormant3()   <230 7 3 deviation>
*
* DESCRIPTION
*    Change the tuning of the highest formant frequency.
*    Positive values raise the formant frequency (Default = 0).
*    RANGE: -100 to 100 by 5%
**********************************************************************
*
*/

METHODFUNC int setFormant3( int deviation )
{
   ATalker->F3adj = (BYTE) (deviation & 0xFF);

   return( sendNarratorCommand( CMD_WRITE ) );      
}

/****i* setForm1Amp() [1.6] ******************************************
*
* NAME
*    setForm1Amp()   <230 8 1 amplitude>
*
* DESCRIPTION
*    Change the amplitude of the lowest formant frequency.  
*    Positive values raise the formant Amplitude.
*    RANGE: 31 to -32 dB (= OFF)
**********************************************************************
*
*/

METHODFUNC int setForm1Amp( int amplitude )
{
   ATalker->A1adj = amplitude; 

   return( sendNarratorCommand( CMD_WRITE ) );      
}

/****i* setForm2Amp() [1.6] ******************************************
*
* NAME
*    setForm2Amp()   <230 8 2 amplitude>
*
* DESCRIPTION
*    Change the amplitude of the middle formant frequency.  
*    Positive values raise the formant Amplitude.
*    RANGE: 31 to -32 dB (= OFF)
**********************************************************************
*
*/

METHODFUNC int setForm2Amp( int amplitude )
{
   ATalker->A2adj = amplitude; 

   return( sendNarratorCommand( CMD_WRITE ) );      
}

/****i* setForm3Amp() [1.6] ******************************************
*
* NAME
*    setForm3Amp()   <230 8 3 amplitude>
*
* DESCRIPTION
*    Change the amplitude of the highest formant frequency.  
*    Positive values raise the formant Amplitude.
*    RANGE: 31 to -32 dB (= OFF)
**********************************************************************
*
*/

METHODFUNC int setForm3Amp( int amplitude )
{
   ATalker->A3adj = amplitude; 

   return( sendNarratorCommand( CMD_WRITE ) );      
}

/****i* setEnthusiasm() [1.6] ****************************************
*
* NAME
*    setEnthusiasm()   <230 9 scale>
*
* DESCRIPTION
*    Change the scaling of pitch (F0) excursions used on accented 
*    syllables.
*    RANGE: 1/32 to 32/32  (32/32 = default)
**********************************************************************
*
*/

METHODFUNC int setEnthusiasm( double scale )
{
   if (scale < (1.0/32.0))
      ATalker->F0enthusiasm = 1.0 / 32.0;
   else if (scale > 1.0)
      ATalker->F0enthusiasm = 1.0;
   else
      ATalker->F0enthusiasm = scale;

   return( sendNarratorCommand( CMD_WRITE ) );
}

/****i* setNarratorPri() [1.6] ***************************************
*
* NAME
*    setNarratorPri()   <230 10 newPri>
*
* DESCRIPTION
*    set the system priority of the narrator device (default = 100).
**********************************************************************
*
*/

METHODFUNC int setNarratorPri( int newPri )
{
   BYTE pri = (BYTE) (newPri & 0xFF);
   
   ATalker->priority = pri;
   
   return( sendNarratorCommand( CMD_WRITE ) );
}


/****i* setModulation() [1.6] ****************************************
*
* NAME
*    setModulation()   <230 11 newMod>
*
* DESCRIPTION
*    Set the modulation of F0.  Range: 0 to 255 (max).
**********************************************************************
*
*/

METHODFUNC int setModulation( int newMod )
{
   UBYTE mod = (UBYTE) (newMod & 0xFF);

   ATalker->F0perturb = mod;
   
   return( sendNarratorCommand( CMD_WRITE ) );
}

/****i* setArticulation() [1.6] **************************************
*
* NAME
*    setArticulation()   <230 12 artAmt>
*
* DESCRIPTION
*    Set the amount of slurring of words.  Range: 0 to 255 (max).
*    100% = default
**********************************************************************
*
*/

METHODFUNC int setArticulation( int artAmt )
{
   UBYTE articulate = (UBYTE) (artAmt & 0xFF);

   ATalker->articulate = articulate;   

   return( sendNarratorCommand( CMD_WRITE ) );
}

/****i* setPhonemes() [1.6] ******************************************
*
* NAME
*    setPhonemes()   <230 13 phString>
*
* DESCRIPTION
*    Set the target vowel used by centralizing code.
*    Valid strings are:
*
*      IY  long  e as in beet,   eat.
*      IH  short i as in bit,    in.
*      EH  short e as in bet,    end.
*      AE  short a as in bat,    ad.
*      AA  short o as in bottle, on.
*      AH  short u as in but,    up.
*      AO  short a as in ball,   awl.
*      OW  long  o as in boat,   own.     (diphthong)
*      UH  short u as in book,   soot.
*      ER  short i as in bird,   early.
*      UW  long  u as in brew,   boolean. (diphthong)
*
* NOTES
*    Used in conjunction with setCentralizeValue: method to alter
*    the Narrator's acccent.
**********************************************************************
*
*/

METHODFUNC int setPhonemes( char *phString )
{
   ATalker->centphon = phString;  // No error checking, user beware!

   return( sendNarratorCommand( CMD_WRITE ) );
}

/****i* setCentralize() [1.6] ****************************************
*
* NAME
*    setCentralize()   <230 14 pullValue>
*
* DESCRIPTION
*    Change the accent of the Narrator.  Range: 0 to 100%
**********************************************************************
*
*/

METHODFUNC int setCentralize( int pullValue )
{
   if      (pullValue < MINCENT)
      ATalker->centralize = MINCENT;
   else if (pullValue > MAXCENT)
      ATalker->centralize = MAXCENT;
   else
      ATalker->centralize = pullValue;

   return( sendNarratorCommand( CMD_WRITE ) );
}

/****i* setNarratorFlags() [1.6] *************************************
*
* NAME
*    setNarratorFlags()  <230 15 newFlags>
*
* DESCRIPTION
*    set one or more of the following narrator flags: 
*
*    NDF_NEWIORB   1 // Use new extended IORB
*    NDF_WORDSYNC  2 // Generate word sync messages
*    NDF_SYLSYNC   4 // Generate syllable sync messages
**********************************************************************
*
*/

METHODFUNC int setNarratorFlags( int flags )
{
   ATalker->flags = (UBYTE) (flags & 0x07);
   
   return( sendNarratorCommand( CMD_WRITE ) );
}

/****i* setVoiceAmp() [1.6] ******************************************
*
* NAME
*    setVoiceAmp()   <230 16 newAVBias>
*
* DESCRIPTION
*    Change the amplitude of the voicing bias.  Range: -32 to 31 dB.
**********************************************************************
*
*/

METHODFUNC int setVoiceAmp( int newAVBias )
{
   if      (newAVBias < -32)
      ATalker->AVbias = -32;
   else if (newAVBias > 31)
      ATalker->AVbias = 31;
   else
      ATalker->AVbias = newAVBias;
      
   return( sendNarratorCommand( CMD_WRITE ) );
}
                  
/****i* setFricAmp() [1.6] *******************************************
*
* NAME
*    setFricAmp()   <230 17 newAFBias>
*
* DESCRIPTION
*    Change the amplitude of the frication bias.  Range: -32 to 31 dB.
**********************************************************************
*
*/

METHODFUNC int setFricAmp( int newAFBias )
{
   if      (newAFBias < -32)
      ATalker->AFbias = -32;
   else if (newAFBias > 31)
      ATalker->AFbias = 31;
   else
      ATalker->AFbias = newAFBias;
      
   return( sendNarratorCommand( CMD_WRITE ) );
}                  

/****i* speakText() [1.6] ********************************************
*
* NAME
*    speakText()   <230 18 aString>
*
* DESCRIPTION
*    Translate the normalString into a phonetic string & have the
*    Narrator speak it.
**********************************************************************
*
*/

METHODFUNC int speakText( char *aString )
{
   int    len      = strlen( aString );

   UBYTE *phbuffer = AT_AllocVec( 2 * len, MEMF_ANY | MEMF_CLEAR, 
                                  "SpeakBuff", TRUE 
                                );
   LONG   rcode    = 0L;

   if (!phbuffer) // == NULL)
      {
      return( ND_NoMem );
      }
      
   if (TranslatorBase) // != NULL)
      {
      if ((rcode = Translate( aString, len, phbuffer, 2 * len )) != 0)
         {
         int   newpos = -rcode, len2;
         char *next   = NULL;
         
         ATalker->message.io_Data   = phbuffer;
         ATalker->message.io_Length = strlen( phbuffer );
         sendNarratorCommand( CMD_WRITE );
         
         len2 = StringLength( &aString[ newpos ] ); 

         next = AT_AllocVec( len * 2, MEMF_ANY | MEMF_CLEAR, 
                             "nextSpeak", TRUE 
                           );
         
         if (!next) // == NULL)
            {
            if (phbuffer) // != NULL)
               {
               AT_FreeVec( phbuffer, "SpeakBuff", TRUE );
               phbuffer = NULL;
               }

            return( ND_NoMem );
            }
         else
            {
            int rval = 0;

            rcode = Translate( &aString[ newpos ], len2, next, len * 2 );
            
            if (rcode != 0)
               {
               if (debug != 0)
                  fprintf( stderr, NarrCMsg( MSG_FMT_NA_TOOSMALL_NARR ), rcode );
               }
               
            ATalker->message.io_Data   = next;
            ATalker->message.io_Length = strlen( next );
               
            rval = sendNarratorCommand( CMD_WRITE );

            AT_FreeVec( next, "nextSpeak", TRUE );
            AT_FreeVec( phbuffer, "SpeakBuff", TRUE );

            return( rval );
            }
         }
      else // Translation was okay!
         {
         ATalker->message.io_Data   = phbuffer;
         ATalker->message.io_Length = strlen( phbuffer );

         rcode = sendNarratorCommand( CMD_WRITE );
         
         AT_FreeVec( phbuffer, "SpeakBuff", TRUE );

         return( (int) rcode );
         }
      }   

   return( -31 ); // User did not use 'open:' first!
}                  

/****i* speakPhon() [1.6] ********************************************
*
* NAME
*    speakPhon()   <230 19 phString>
*
* DESCRIPTION
*    Have the Narrator speak the phonetic string.
**********************************************************************
*
*/

METHODFUNC int speakPhon( char *phString )
{
   int len = StringLength( phString );

   ATalker->message.io_Data   = phString;
   ATalker->message.io_Length = len;
   
   return( sendNarratorCommand( CMD_WRITE ) );
}

/****i* translatedText() [1.6] ***************************************
*
* NAME
*    translatedText()   <230 20 inString>
*
* DESCRIPTION
*    Use Translate() from the translator.library to change an 
*    ordinary string into phonemes.
**********************************************************************
*
*/

METHODFUNC OBJECT *translatedText( char *inString )
{
   IMPORT OBJECT *o_nil;

   OBJECT *rval     = o_nil;
   int     len      = StringLength( inString );
   char   *phbuffer = AT_AllocVec( len * 2, 
                                   MEMF_CLEAR, 
                                   "TranslateBuff", TRUE
                                 );
   LONG    rcode    = 0L;

   if (!phbuffer) // == NULL)
      {
      if (debug != 0)
         MemoryOut( NarrCMsg( MSG_NA_TRANSLATED_FUNC_NARR ) ); 

      return( rval );
      }
      
   rcode = Translate( inString, len, phbuffer, len * 2 );

   if (rcode == 0)
      {
      rval = AssignObj( new_str( phbuffer ) );

      AT_FreeVec( phbuffer, "TranslateBuff", TRUE );

      return( rval );
      }
   else
      {
      AT_FreeVec( phbuffer, "TranslateBuff", TRUE );
      
      phbuffer = (char *) AT_AllocVec( len * 4, MEMF_CLEAR, 
                                       "Translate2Buff", TRUE 
                                     );

      if (!phbuffer) // == NULL)
         {
         if (debug != 0)
            MemoryOut( NarrCMsg( MSG_NA_TRANSLATED_FUNC_NARR ) ); 

         return( rval );
         }
      
      rcode = Translate( inString, len, phbuffer, len * 4 );

      if (rcode == 0)
         {
         rval = AssignObj( new_str( phbuffer ) );
         }
      else
         {
         if (debug != 0)
            fprintf( stderr, 
                     NarrCMsg( MSG_FMT_NA_TOOLARGE_NARR ), 
                     NarrCMsg( MSG_NA_TRANSLATED_FUNC_NARR ) 
                   ); 
         }

      AT_FreeVec( phbuffer, "Translate2Buff", TRUE );

      return( rval );
      }

   // Unreachable
}

/****h* HandleNarrator() [1.6] *****************************************
*
* NAME
*    HandleNarrator()
*
* DESCRIPTION
*    Translate the primitive 230 calls to Narrator device functions.
**********************************************************************
*
*/

PUBLIC OBJECT *HandleNarrator( int numargs, OBJECT **args )
{
   IMPORT OBJECT *o_nil;

   OBJECT *rval = o_nil;
   
   if (is_integer( args[0] ) == FALSE)
      {
      (void) PrintArgTypeError( 230 );

      return( rval );
      }

   switch (int_value( args[0] ))
      {
      case 0: // close [self]
         CloseNarrator();
         
         break;
         
      case 1: // open
         rval = AssignObj( new_int( OpenNarrator() ) );

         break;
         
      case 2: // setVolume: newSpeakingVolume
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setNarratorVolume( int_value( args[1] ))));

         break;
         
      case 3: // setSex: newSpeakerSex
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setNarratorSex( int_value( args[1] ))));

         break;
         
      case 4: // setPitch: newSpeakingPitch
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setNarratorPitch( int_value( args[1] ))));

         break;

      case 5: // setMode: newSpeakingMode
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setNarratorMode( string_value( (STRING *)
                                             args[1] ) ) 
                                     )
                            );
         break;
         
      case 6: // setRate: newSpeakingRate
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setWordRate( int_value( args[1] ))));

         break;
         
      case 7: // setFormant: percentDeviation
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            {
            int deviation = 0;
            
            if (is_integer( args[2] ) == FALSE)
               {
               (void) PrintArgTypeError( 230 );

               return( rval );
               }
            else
               {
               if (int_value( args[2] ) < -100)
                  deviation = -100;
               else if (int_value( args[2] ) > 100)
                  deviation = 100;
               else
                  deviation = int_value( args[2] );
               }

            switch (int_value( args[1] ))
               {
               case 1: // setFormant1: percentDeviation
                  rval = AssignObj( new_int( setFormant1( deviation )));
                  break;

               case 2: // setFormant2: percentDeviation
                  rval = AssignObj( new_int( setFormant2( deviation )));
                  break;

               case 3: // setFormant3: percentDeviation
                  rval = AssignObj( new_int( setFormant3( deviation )));
                  break;

               default:
                  PrintNumberError();
                  break;
               }
            }

         break;
         
      case 8: // setFormatAmplitude: newAmplitude
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            {
            int amp = 0;
            
            if (is_integer( args[2] ) == FALSE)
               {
               (void) PrintArgTypeError( 230 );

               return( rval );
               }
            else
               {
               if (int_value( args[2] ) < -32)
                  amp = -32;
               else if (int_value( args[2] ) > 31)
                  amp = 31;
               else
                  amp = int_value( args[2] );
               }

            switch (int_value( args[1] ))
               {
               case 1: // setFormant1Amplitude: newAmplitude
                  rval = AssignObj( new_int( setForm1Amp( amp )));
                  break;

               case 2: // setFormant2Amplitude: newAmplitude      
                  rval = AssignObj( new_int( setForm2Amp( amp )));
                  break;

               case 3: // setFormant3Amplitude: newAmplitude
                  rval = AssignObj( new_int( setForm3Amp( amp )));
                  break;

               default:
                  PrintNumberError();
                  break;
               }
            }

         break;
         
      case 9: // setEnthusiasm: 1/32 to 32/32
         if (is_float( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setEnthusiasm( float_value( args[1] ))));

         break;
         
      case 10: // setPriority: newSpeakingPriority
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setNarratorPri( int_value( args[1] ))));

         break;
         
      case 11: // setPitchModulation: newSpeakerModulation
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setModulation( int_value( args[1] ))));

         break;
         
      case 12: // setArticulation: newPercentArticulation
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setArticulation( int_value( args[1] ))));

         break;
         
      case 13: // setPhonemes: phonemeString
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setPhonemes( string_value( (STRING *) args[1] )
                                                  )
                                     )
                            );
         break;
         
      case 14: // setCentralizeValue: newCentralizePercent
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setCentralize( int_value( args[1] ))));

         break;
         
      case 15: // setFlags:  NDB_NEWIORB, NDB_WORDSYNC, NDB_SYLSYNC.
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setNarratorFlags( int_value( args[1] ))));

         break;

      case 16: // setVoicingAmplitude: newAVBias  RANGE: 31 to -32 dB.
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setVoiceAmp( int_value( args[1] ))));

         break;
                  
      case 17: // setFricationAmplitude: newAFBias RANGE: 31 to -32 dB.
         if (is_integer( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( setFricAmp( int_value( args[1] ))));

         break;
                  
      case 18: // speak: normalString
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( speakText( string_value( (STRING *) args[1] ))));

         break;
                  
      case 19: // speakPhonetics: phoneticString   
         if (is_string( args[1] ) == FALSE)
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_int( speakPhon( string_value( (STRING *) args[1] ))));
   
         break;

      case 20: // translateText: aString
         if (is_string( args[1] ) == FALSE)      
            (void) PrintArgTypeError( 230 );
         else
            rval = translatedText( string_value( (STRING *) args[1] ) );

         break;
      
      case 21: // <230 21 errNum>
         if (is_integer( args[1] ) == FALSE)      
            (void) PrintArgTypeError( 230 );
         else
            rval = AssignObj( new_str( NarratorErrIs( int_value( args[1] ))));

         break;
        
      /*
      Still need to add code for using the mouth_rb struct.
      */                            

      default:
         (void) PrintArgTypeError( 230 );

         break;
      }

   return( rval );
}

/* --------------------- END of Narrator.c file! ----------------------- */
