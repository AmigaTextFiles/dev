/*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: TimeString_mcc.e 12.5 (18.10.97)
**
*/

 OPT MODULE
 OPT EXPORT
 OPT PREPROCESS

 #ifndef MUI_TIMESTRING_MCC_H
   #define MUI_TIMESTRING_MCC_H

   #define MUIC_TimeString	'TimeString.mcc'
   #define TimeStringObject	Mui_NewObjectA(MUIC_TimeString,[TAG_IGNORE,0

   CONST MUIA_TimeString_TimeFormat	= $81ee008a

 #endif
