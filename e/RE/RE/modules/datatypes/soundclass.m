#ifndef	DATATYPES_SOUNDCLASS_H
#define	DATATYPES_SOUNDCLASS_H

#ifndef	UTILITY_TAGITEM_H
MODULE  'utility/tagitem'
#endif
#ifndef	DATATYPES_DATATYPESCLASS_H
MODULE  'datatypes/datatypesclass'
#endif
#ifndef	LIBRARIES_IFFPARSE_H
MODULE  'libraries/iffparse'
#endif

#define	SOUNDDTCLASS		'sound.datatype'


#define	SDTA_Dummy		(DTA_Dummy + 500)
#define	SDTA_VoiceHeader	(SDTA_Dummy + 1)
#define	SDTA_Sample		(SDTA_Dummy + 2)
   
#define	SDTA_SampleLength	(SDTA_Dummy + 3)
   
#define	SDTA_Period		(SDTA_Dummy + 4)
    
#define	SDTA_Volume		(SDTA_Dummy + 5)
    
#define	SDTA_Cycles		(SDTA_Dummy + 6)

#define	SDTA_SignalTask		(SDTA_Dummy + 7)
    
#define	SDTA_SignalBit		(SDTA_Dummy + 8)
    
#define	SDTA_Continuous		(SDTA_Dummy + 9)
    

#define CMP_NONE     0
#define CMP_FIBDELTA 1
OBJECT VoiceHeader

    OneShotHiSamples:LONG
    RepeatHiSamples:LONG
    SamplesPerHiCycle:LONG
    SamplesPerSec:UWORD
    Octaves:UBYTE
    Compression:UBYTE
    Volume:LONG
ENDOBJECT



#define ID_8SVX MAKE_ID("8","S","V","X")
#define ID_VHDR MAKE_ID("V","H","D","R")
#define ID_BODY MAKE_ID("B","O","D","Y")

#endif	
