/*
** $PROJECT: xrefsupport.lib
**
** $VER: timecalc.c 1.3 (24.09.94)
**
** by
**
** Stefan Ruppert , Windthorststraße 5 , 65439 Flörsheim , GERMANY
**
** (C) Copyright 1994
** All Rights Reserved !
**
** $HISTORY:
**
** 24.09.94 : 001.003 :  if totalsize == actualsize), set secs
** 17.09.94 : 001.002 :  tc_Update now check for <= 0 , this fixes a devision by zero bug
** 11.09.94 : 001.001 :  initial
*/

/* ------------------------------- includes ------------------------------- */

#include "/source/def.h"

#include "xrefsupport.h"

/* ------------------------------ functions ------------------------------- */

void time_calc(struct TimeCalc *time,ULONG actual,ULONG total)
{
   ULONG sec;
   ULONG mic;

   CurrentTime(&sec,&mic);

   sec -= time->tc_BeginSec;

   if(sec > 0)
      mic = (1000000 - time->tc_BeginMic) + mic;

   sec += (mic / 1000000);

   if(sec > time->tc_LastSec)
   {
      time->tc_LastSec = sec;

      if(time->tc_TimeCalled > 3)
         time->tc_Update += 5;
      else if(time->tc_TimeCalled < 3)
      {
         time->tc_Update -= 5;
         if(time->tc_Update <= 0)
            time->tc_Update = 1;
      }

      if(total > 1024 * 1024 / 2 && actual > 1024)
      {
         total  >>=  10;
         actual >>=  10;
      }

      time->tc_TimeCalled = 0;

      time->tc_Secs[0] = sec;
      time->tc_Secs[1] = (sec * total) / actual;
      time->tc_Secs[2] = time->tc_Secs[1] - time->tc_Secs[0];

   } else if(actual == total)
   {
      time->tc_Secs[0] = sec;
      time->tc_Secs[1] = sec;
      time->tc_Secs[2] = 0;
   } else
      time->tc_TimeCalled++;
}

void time_init(struct TimeCalc *time,ULONG update)
{
   CurrentTime(&time->tc_BeginSec,&time->tc_BeginMic);
   time->tc_Update = update;
}

