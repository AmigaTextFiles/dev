  IFND  THREAD_I
THREAD_I  SET 1



**
**  $Filename: libraries/thread.i $
**  $Release: 2.0 $
**  $Revision: 1.0 $
**  $Date: 99/03/12 $
**
**  Assembly include file for thread.library.
**
**  (C) Copyright 1999 Gabriele Budelacci
**    All Rights Reserved
**



*
* Global constants of the library.
*

TL_NULL   EQU 0
TL_NONE   EQU 0
TL_TRUE   EQU -1
TL_FALSE  EQU 0



*
* RegMask bitfield values
*

TL_D2     EQU 1
TL_D3     EQU 2
TL_D4     EQU 4
TL_D5     EQU 8
TL_D6     EQU 16
TL_D7     EQU 32
TL_A2     EQU 64
TL_A3     EQU 128
TL_A4     EQU 256
TL_A5     EQU 512
TL_A6     EQU 1024

TL_AMIGAE EQU TL_A4



    ENDC  ; THREAD_I
