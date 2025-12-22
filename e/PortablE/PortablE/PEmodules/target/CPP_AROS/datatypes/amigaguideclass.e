/* $VER: amigaguideclass.h 1.1 (04.09.03) */
OPT NATIVE
MODULE 'target/utility/tagitem', 'target/datatypes/datatypesclass', 'target/libraries/iffparse'
{#include <datatypes/amigaguideclass.h>}
NATIVE {DATATYPES_AMIGAGUIDECLASS_H} CONST

NATIVE {AMIGAGUIDEDTCASS}  CONST
STATIC amigaguidedtcass  = 'amigaguide.datatype'

NATIVE {AGDTA_Dummy}      CONST AGDTA_DUMMY      = (DTA_DUMMY + 700)
NATIVE {AGDTA_Secure}     CONST AGDTA_SECURE     = (AGDTA_DUMMY + 1)
NATIVE {AGDTA_HelpGroup}  CONST AGDTA_HELPGROUP  = (AGDTA_DUMMY + 2)
