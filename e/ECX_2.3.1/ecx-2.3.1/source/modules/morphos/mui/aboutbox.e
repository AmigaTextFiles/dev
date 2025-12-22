OPT MODULE, EXPORT, PREPROCESS
/*
 *  Aboutbox.mcc
 *
 *  Copyright © 2007 Christian Rosentreter <tokai@binaryriot.org>
 *  All rights reserved.
 */


#define MUIC_Aboutbox  'Aboutbox.mcc'
#define AboutboxObject Mui_NewObjectA(MUIC_Aboutbox, [TAG_IGNORE,0


/*   attributes
 */
CONST MUIA_Aboutbox_Credits           = $FED10001    /* [I..] STRPTR  v20.1  */
CONST MUIA_Aboutbox_LogoData          = $FED10002    /* [I..] APTR    v20.2  */
CONST MUIA_Aboutbox_LogoFallbackMode  = $FED10003    /* [I..] ULONG   v20.2  */
CONST MUIA_Aboutbox_LogoFile          = $FED10004    /* [I..] STRPTR  v20.2  */
CONST MUIA_Aboutbox_Build             = $FED1001E    /* [I..] STRPTR  v20.12 */


/*   methods
 */



/*   special values
 */

/*
 *   the fallback mode defines in which order Aboutbox.mcc tries to get valid image
 *   data for the logo:
 *
 *   D = PROGDIR:<executablefilename>.info
 *   E = file specified in MUIA_Aboutbox_LogoFile
 *   I = data specified with MUIA_Aboutbox_LogoData
 */
CONST MUIV_Aboutbox_LogoFallbackMode_NoLogo    = 0
CONST MUIV_Aboutbox_LogoFallbackMode_Auto      = "DEI\0"


/*   messages
 */


