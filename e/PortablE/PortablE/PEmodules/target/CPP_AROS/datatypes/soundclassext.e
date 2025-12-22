OPT NATIVE
MODULE 'target/datatypes/soundclass'
{#include <datatypes/soundclassext.h>}
NATIVE {DATATYPES_SOUNDCLASSEXT_H} CONST

NATIVE {SDTA_SampleType}	    CONST SDTA_SAMPLETYPE	    = (SDTA_DUMMY + 30)
NATIVE {SDTA_Panning}	    CONST SDTA_PANNING	    = (SDTA_DUMMY + 31)
NATIVE {SDTA_Frequency}	    CONST SDTA_FREQUENCY	    = (SDTA_DUMMY + 32)

NATIVE {SDTST_M8S}   	    CONST SDTST_M8S   	    = 0
NATIVE {SDTST_S8S}   	    CONST SDTST_S8S   	    = 1
NATIVE {SDTST_M16S}  	    CONST SDTST_M16S  	    = 2
NATIVE {SDTST_S16S}  	    CONST SDTST_S16S  	    = 3

NATIVE {SDTM_ISSTEREO} CONST	->SDTM_ISSTEREO(sampletype)   ((sampletype) & 1)
NATIVE {SDTM_CHANNELS} CONST	->SDTM_CHANNELS(sampletype)   (1 + SDTM_ISSTEREO(sampletype))
NATIVE {SDTM_BYTESPERSAMPLE} CONST	->SDTM_BYTESPERSAMPLE(x)	    (((x) >= SDTST_M16S ) ? 2 : 1)
NATIVE {SDTM_BYTESPERPOINT} CONST	->SDTM_BYTESPERPOINT(x)	    (SDTM_CHANNELS(x) * SDTM_BYTESPERSAMPLE(x))
PROC sdtm_isstereo(sampletype) IS sampletype AND 1
PROC sdtm_channels(sampletype) IS 1 + sdtm_isstereo(sampletype)
PROC sdtm_bytespersample(x) IS IF x >= SDTST_M16S THEN 2 ELSE 1
PROC sdtm_bytesperpoint(x) IS sdtm_channels(x) * sdtm_bytespersample(x)
