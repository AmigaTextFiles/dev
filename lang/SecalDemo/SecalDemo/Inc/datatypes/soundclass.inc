include "inc/utility/tagitem.inc";
include "inc/datatypes/datatypesclass.inc";
include "inc/libraries/iffparse.inc";

def SOUNDDTCLASS = "sound.datatype";

def SDTA_Dummy = (DTA_Dummy+500);
def SDTA_VoiceHeader = (SDTA_Dummy+1);
def SDTA_Sample = (SDTA_Dummy+2);
def SDTA_SampleLength = (SDTA_Dummy+3);
def SDTA_Period = (SDTA_Dummy+4);
def SDTA_Volume = (SDTA_Dummy+5);
def SDTA_Cycles = (SDTA_Dummy+6);
def SDTA_SignalTask = (SDTA_Dummy+7);
def SDTA_SignalBit = (SDTA_Dummy+8);
def SDTA_Continuous = (SDTA_Dummy+9);

def CMP_NONE = 0;
def CMP_FIBDELTA = 1;

struct VoiceHeader is
  vh_OneShotHiSamples:ulong;
  vh_RepeatHiSamples:ulong;
  vh_SamplesPerHiCycle:ulong;
  vh_SamplesPerSec:uword;
  vh_Octaves:ubyte;
  vh_Compression:ubyte;
  vh_Volume:ulong;
;

