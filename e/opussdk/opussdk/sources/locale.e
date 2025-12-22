/*****************************************************************************

 Locale

 *****************************************************************************/
OPT MODULE
OPT EXPORT

MODULE 'libraries/locale'

-> Locale marker
OBJECT dOpusLocale
    localeBase:PTR TO LONG
    catalog:PTR TO LONG
    builtIn:PTR TO CHAR
    locale:PTR TO locale
ENDOBJECT
