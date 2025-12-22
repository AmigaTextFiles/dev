#ifndef MISC_TIME_H
#define MISC_TIME_H TRUE

/*
**  $VER: time.h V1.0
**
**  Time Object.
**
**  (C) Copyright 1996-1998 DreamWorld Productions.
**      All Rights Reserved
*/

/****************************************************************************
** Time Object.
*/

#define VER_TIME 1

typedef struct Time {
  struct Head Head;  /* Standard header */
  WORD   Year;       /* Year   (-ve for BC, +ve for AD) */
  WORD   Month;      /* Month  (1 - 12) */
  WORD   Day;        /* Day    (1 - 31) */
  WORD   Hour;       /* Hour   (0 - 23) */
  WORD   Minute;     /* Minute (0 - 59) */
  WORD   Second;     /* Second (0 - 59) */
  WORD   Micro;      /* Micro  (0 - 99 micro-seconds) */

  /*** Private fields ***/

  struct DateTime *prvDateTime;
} OBJ_TIME;

#endif /* MISC_TIME_H */
