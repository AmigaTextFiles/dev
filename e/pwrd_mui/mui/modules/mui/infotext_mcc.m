/*
**
** $VER: InfoText_mcc.h V15.3
** Copyright © 1997 Benny Kjær Nielsen. All rights reserved.
**
** Translated into D ny Miklós Németh
**
*/

/*** Include stuff ***/

MODULE 'libraries/mui'
MODULE 'utility/tagitem'

CONST BKN_SERIAL = $fcf70000

/*** MUI Defines ***/

#define MUIC_InfoText 'InfoText.mcc'
#define InfoTextObject MUI_NewObjectA(MUIC_InfoText,[TAG_IGNORE, 0

/*** Methods ***/
#define MUIM_InfoText_TimeOut          (BKN_SERIAL | $101 )

/*** Attributes ***/
#define MUIA_InfoText_Contents         (BKN_SERIAL | $110 )
#define MUIA_InfoText_ExpirationPeriod (BKN_SERIAL | $111 )
#define MUIA_InfoText_FallBackText     (BKN_SERIAL | $112 )



