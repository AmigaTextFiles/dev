/*====================================*/
/*   AmigaE module for InfoText.mcc   */
/*      by QXY (qxyka@elender.hu)     */
/*                                    */
/* InfoText.mcc (C)Benny Kjær Nielsen */
/*====================================*/

OPT MODULE
OPT EXPORT
OPT PREPROCESS

MODULE 'libraries/mui', 'exec/types'

/*** MUI Defines ***/

#define MUIC_InfoText 'InfoText.mcc'
#define InfoTextObject Mui_NewObjectA(MUIC_InfoText,[TAG_IGNORE,0

/*** Methods ***/

CONST MUIM_InfoText_TimeOut = $FCF70101

/*** Attributes ***/

CONST MUIA_InfoText_Contents         = $FCF70110,
      MUIA_InfoText_ExpirationPeriod = $FCF70111,
      MUIA_InfoText_FallBackText     = $FCF70112

