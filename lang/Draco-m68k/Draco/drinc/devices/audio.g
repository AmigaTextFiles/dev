/*ÅrequiresÅpreviousÅinclusionÅofÅinclude:exec/io.gÅ*/
*charÅAUDIONAMEÅ=Å"audio.device";

uintÅADHARD_CHANNELSÅ=Å4;

int
ÑADALLOC_MINPRECÅ=Å-128,
ÑADALLOC_MAXPRECÅ=Å+127;

uint
ÑADCMD_FREEä=ÅCMD_NONSTDÅ+Å0,
ÑADCMD_SETPRECá=ÅCMD_NONSTDÅ+Å1,
ÑADCMD_FINISHà=ÅCMD_NONSTDÅ+Å2,
ÑADCMD_PERVOLà=ÅCMD_NONSTDÅ+Å3,
ÑADCMD_LOCKä=ÅCMD_NONSTDÅ+Å4,
ÑADCMD_WAITCYCLEÖ=ÅCMD_NONSTDÅ+Å5,
ÑADCMDB_NOUNITá=Å5,
ÑADCMDF_NOUNITá=Å1Å<<ÅADCMDB_NOUNIT,
ÑADCMD_ALLOCATEÜ=ÅADCMDF_NOUNITÅ+Å0,

ÑADIOB_PERVOLà=Å4,
ÑADIOF_PERVOLà=Å1Å<<ÅADIOB_PERVOL,
ÑADIOB_SYNCCYCLEÖ=Å5,
ÑADIOF_SYNCCYCLEÖ=Å1Å<<ÅADIOB_SYNCCYCLE,
ÑADIOB_NOWAITà=Å6,
ÑADIOF_NOWAITà=Å1Å<<ÅADIOB_NOWAIT,
ÑADIOB_WRITEMESSAGEÇ=Å7,
ÑADIOF_WRITEMESSAGEÇ=Å1Å<<ÅADIOB_WRITEMESSAGE;

int
ÑADIOERR_NOALLOCATIONà=Å-10,
ÑADIOERR_ALLOCFAILEDâ=Å-11,
ÑADIOERR_CHANNELSTOLENá=Å-12;

type
ÑIOAudio_tÅ=ÅstructÅ{
àIORequest_tÅioa_Request;
àintÅioa_AllocKey;
à*shortÅioa_Data;
àulongÅioa_Length;
àuintÅioa_Period;
àuintÅioa_Volume;
àuintÅioa_Cycles;
àMessage_tÅioa_WriteMsg;
Ñ};
