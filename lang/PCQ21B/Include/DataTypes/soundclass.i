  { Only V39+ }

  { Interface definitions for DataType sound objects. }

{$I "Include:Utility/TagItem.i"}
{$I "Include:DataTypes/DataTypesClass.i"}
{$I "Include:Libraries/IFFParse.i"}

const
{***************************************************************************}

   SOUNDDTCLASS          =  "sound.datatype";

{***************************************************************************}

{ Sound attributes }
   SDTA_Dummy            =  (DTA_Dummy + 500);
   SDTA_VoiceHeader      =  (SDTA_Dummy + 1);
   SDTA_Sample           =  (SDTA_Dummy + 2);
   { (UBYTE *) Sample data }

   SDTA_SampleLength     =  (SDTA_Dummy + 3);
   { (ULONG) Length of the sample data in UBYTEs }

   SDTA_Period           =  (SDTA_Dummy + 4);
    { (UWORD) Period }

   SDTA_Volume           =  (SDTA_Dummy + 5);
    { (UWORD) Volume.  Range from 0 to 64 }

   SDTA_Cycles           =  (SDTA_Dummy + 6);

{ The following tags are new for V40 }
   SDTA_SignalTask       =  (SDTA_Dummy + 7);
    { (struct Task *) Task to signal when sound is complete or
        next buffer needed. }

   SDTA_SignalBit        =  (SDTA_Dummy + 8);
    { (BYTE) Signal bit to use on completion or -1 to disable }

   SDTA_Continuous       =  (SDTA_Dummy + 9);
    { (ULONG) Playing a continuous stream of data.  Defaults to
        FALSE. }

{***************************************************************************}

   CMP_NONE     = 0;
   CMP_FIBDELTA = 1;

Type
 VoiceHeader = Record
    vh_OneShotHiSamples,
    vh_RepeatHiSamples,
    vh_SamplesPerHiCycle : Integer;
    vh_SamplesPerSec     : WORD;
    vh_Octaves,
    vh_Compression       : Byte;
    vh_Volume            : Integer;
 end;
 VoiceHeaderPtr = ^VoiceHeader;

{***************************************************************************}

const
{ IFF types }
   ID_8SVX = 944985688;
   ID_VHDR = 1447576658;

{***************************************************************************}

