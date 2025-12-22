/* Defines the types for all pattern_args.
** Used eq. in patternStringF and prefsFile.
*/

OPT MODULE

EXPORT ENUM PARGS_Type_END,
            PARGS_Type_Decimal,   -> its an decimal number
            PARGS_Type_String,    -> its an string
            PARGS_Type_Char,      -> its an character
            PARGS_Type_Hex,       -> its an hexadecimal number
            PARGS_Type_Float,     -> its an float (single ieee) number
            PARGS_Type_Ignore,    -> ignore it
            PARGS_Type_None,      -> insert seperator (keystr)
            PARGS_Type_COUNT


EXPORT OBJECT pattern_arg
  type                -> the type of this argument (PARGS_Type_XXX)
  keystr:PTR TO CHAR  -> the keystring
  data                -> datas (usages depends on implementation)
ENDOBJECT

