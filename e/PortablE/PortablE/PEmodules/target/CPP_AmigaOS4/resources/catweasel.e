/* $Id: catweasel.h,v 1.5 2005/09/24 15:10:37 dwuerkner Exp $ */
OPT NATIVE
MODULE 'target/exec/types'
{#include <resources/catweasel.h>}
NATIVE {RESOURCES_CATWEASEL_H} CONST

NATIVE {JoyDat}       CONST JOYDAT       = $c0
NATIVE {PaddleSelect} CONST PADDLESELECT = $c4
NATIVE {Joybutton}    CONST JOYBUTTON    = $c8
NATIVE {Joybuttondir} CONST JOYBUTTONDIR = $cc
NATIVE {KeyDat}       CONST KEYDAT       = $d0
NATIVE {KeyStatus}    CONST KEYSTATUS    = $d4
NATIVE {SidDat}       CONST SIDDAT       = $d8
NATIVE {SidCommand}   CONST SIDCOMMAND   = $dc
NATIVE {CatMem}       CONST CATMEM       = $e0
NATIVE {CatAbort}     CONST CATABORT     = $e4
NATIVE {CatControl}   CONST CATCONTROL   = $e8
NATIVE {CatOption}    CONST CATOPTION    = $ec
NATIVE {CatStartA}    CONST CATSTARTA    = $f0
NATIVE {CatStartB}    CONST CATSTARTB    = $f4
