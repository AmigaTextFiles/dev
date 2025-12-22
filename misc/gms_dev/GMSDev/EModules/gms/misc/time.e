/*
**  $VER: time.e V1.0
**
**  Time Object.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved.
*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'gms/dpkernel/dpkernel','gms/system/register'

/****************************************************************************
** Time Object.
*/

CONST VER_TIME = 1

OBJECT time
  head[1] :ARRAY OF head  /* Standard header */
  year    :INT            /* Year   (-ve for BC, +ve for AD) */
  month   :INT            /* Month  (1 - 12) */
  day     :INT            /* Day    (1 - 31) */
  hour    :INT            /* Hour   (0 - 23) */
  minute  :INT            /* Minute (0 - 59) */
  second  :INT            /* Second (0 - 59) */
  micro   :INT            /* Micro  (0 - 99 micro-seconds) */
ENDOBJECT

