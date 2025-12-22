
OPT MODULE      /* compile as module */
OPT PREPROCESS  /* use preprocessor */
OPT EXPORT      /* export all items */

MODULE 'muimaster','utility/tagitem'

/*
**  HTMLtext.mcc
**  Copyright Dirk Holtwick, 1997
*/

-> AmigaE include conversion by Thorsten Stocksmeier <flavour@teuto.de>

#define MUIC_HTMLtext  'HTMLtext.mcc'
#define HTMLtextObject Mui_NewObjectA(MUIC_HTMLtext,[TAG_IGNORE,0

/*** Attributes ***/
CONST MUIA_HTMLtext_Contents      =$90A40001
CONST MUIA_HTMLtext_Title         =$90A40003
CONST MUIA_HTMLtext_Path          =$90A40004
CONST MUIA_HTMLtext_OpenURLHook   =$90A40005
CONST MUIA_HTMLtext_URL           =$90A40006
CONST MUIA_HTMLtext_LoadImages    =$90A4000C
CONST MUIA_HTMLtext_Block         =$90A4000D
CONST MUIA_HTMLtext_DoubleClick   =$90A4000F

