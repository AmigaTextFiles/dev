/*
**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: DateString_mcc.e 12.3 (04.04.97)
**
*/

 OPT MODULE
 OPT EXPORT
 OPT PREPROCESS

 #ifndef MUI_DATESTRING_MCC_H
   #define MUI_DATESTRING_MCC_H

   #define MUIC_DateString	'DateString.mcc'
   #define DateStringObject	Mui_NewObjectA(MUIC_DateString,[TAG_IGNORE,0


   CONST MUIA_DateString_DateFormat	= $81ee0047

 #endif
