/*
**
** Copyright © 1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: TimeText_mcc.e 12.0 (27.07.97)
**
*/

 OPT MODULE
 OPT EXPORT
 OPT PREPROCESS

 #ifndef MUI_TIMETEXT_MCC_H
   #define MUI_TIMETEXT_MCC_H

   #define MUIC_TimeText	'TimeText.mcc'
   #define TimeTextObject	Mui_NewObjectA(MUIC_TimeText,[TAG_IGNORE,0

   CONST MUIA_TimeText_TimeFormat	= $81ee0098

 #endif
