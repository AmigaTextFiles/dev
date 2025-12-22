{
    PCQUtils/Convert.i

    Author:  Nils Sjoholm  (nils.sjoholm@mailbox.swipnet.se)
}


{
    Convert a float to a string. If fieldsize is bigger than
    the whole part of the real it will be paded with spaces.
    If digits are bigger than the fraction part the pading is with zeros.
}
FUNCTION FloatToStr(DataOut  : Real; FieldSize, Digits : Short): STRING;
EXTERNAL;

{
    Converts a string to float. Converr is false when there
    was some error in the translation.
}
FUNCTION StrToFloat(s : STRING; VAR converr : Boolean): Real;
EXTERNAL;

FUNCTION IntToHex(value : INTEGER): STRING;
EXTERNAL;

FUNCTION LongToStr(value : INTEGER): STRING;
EXTERNAL;

FUNCTION StrToInt(Str : STRING):INTEGER;
EXTERNAL;

FUNCTION HexToInt(Str : STRING): INTEGER;
EXTERNAL;








