{
    This is PCQUtils/cstrings.i

    Author: Nils Sjoholm (nils.sjoholm@mailbox.swipnet.se)
}



{$C+}
(*
    This is the same as sprintf but no need to use
    long integers, it's also bigger.
*)
FUNCTION StrFmt(buffer, frmt : STRING;...): Integer;
EXTERNAL;

(*
    This is a standard sprintf with all the usual functions.
    You must use long integers for 32bits integers with this one, eg. %ld.
    It uses RawDoFmt wich is word aligned.
    It can't handle floats, if you need that use FloatToStr
    in PCQUtils/Convert.i and use the result string.
    eg. sprintf(buffer,"This is the result %s\n,FloatToStr(12.45,2,4));
*)
PROCEDURE sprintf(buffer, frmt : STRING; ...);
EXTERNAL;

(*
    Converts str to an integer , leading spaces are ignored.
    Base can be 0 or a number between 2 & 36.
    If base = 0 then it is assumed that base = 8 if str start with a 0 ,
    16 if str starts with  0x, 0X or $, base 10 otherwise.
*)
FUNCTION strtol(str : STRING; VAR tail : STRING; base : INTEGER): INTEGER;
EXTERNAL;

(*
    Convert str to an integer.
*)
FUNCTION atoi(str : STRING): INTEGER;
EXTERNAL;

(*
    The same as atoi.
*)
FUNCTION atol(str : STRING): INTEGER;
EXTERNAL;

(*
    This one converts the str to an integer.
    If the string starts with:

        0x,0X or $ : It's hex
        %          : It's bin
        &          : It's oct
        0-9        : It's dec
*)
FUNCTION ConvertNum(str : STRING; VAR value : INTEGER): BOOLEAN;
EXTERNAL;
{$C-}

