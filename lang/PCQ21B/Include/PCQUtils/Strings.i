{
     Include:PCQUtils/Strings.i

     This are some stringutils for PCQ Pascal
     Some mimics the functions for Delphi.


     Author: nils.sjoholm@mailbox.swipnet.se (Nils Sjoholm)
}

{
     A simple Val procedure, if TheErr is > 0 then there was
     some error.
}
PROCEDURE Val(Str : String ; VAR TheVal : Real ; VAR TheErr : Word);
EXTERNAL;

{
     Copy from Str, start at position pos with length characters.
}
FUNCTION Copy(Str : STRING; pos , length : Integer): STRING;
EXTERNAL;

{
     Delete characters from Str with start at Pos. It deletes
     Num characters.
}
PROCEDURE Delete(VAR Str : STRING; Pos, Num : Short);
EXTERNAL;

{
     StrInsert puts Insertion in Str at position ThePos.
}
PROCEDURE StrInsert(Str, Insertion : STRING; ThePos : Short);
EXTERNAL;

{
     InStr returns pos if Str2 is in Str1 beginning from startpos.
     If Str2 is not in Str2 it returns -1.
}
FUNCTION InStr( Str1, Str2 : STRING; startpos : Integer ): Integer;
EXTERNAL;

{
     Pos returns the position of obj in Str, if not found
     it returns -1.
}
FUNCTION Pos( Str, obj : STRING): Integer;
EXTERNAL;

{
     This are functions to mimic the basic functions.
     If you use this functions to translate some basic stuff
     just remember that PCQ strings start with [0].
}
FUNCTION Lefts(Str : STRING; len : Integer): STRING;
EXTERNAL;

FUNCTION Mids(Str : STRING; thepos, len : Integer): STRING;
EXTERNAL;

FUNCTION Rights(Str : STRING; len : Integer): STRING;
EXTERNAL;

{
     Trim trims leading and trailing spaces and control characters from the
     given string.
}
FUNCTION Trim(Str : STRING): STRING;
EXTERNAL;

{
     TrimLeft trims leading spaces and control characters from the given
     string.
}
FUNCTION TrimLeft(Str : STRING): STRING;
EXTERNAL;

{
     TrimRight trims trailing spaces and control characters from the given
     string.
}
FUNCTION TrimRight( Str : STRING): STRING;
EXTERNAL;

{
     Length gives the stringlength in characters for s.
     The same as strlen.
}
FUNCTION Length(Str : STRING): Integer;
EXTERNAL;

{
     IsValidIdent returns true if the given string is a valid identifier. An
     identifier is defined as a character from the set ['A'..'Z', 'a'..'z', '_']
     followed BY one or more characters from the set ['A'..'Z', 'a'..'z',
     '0..'9', '_'].
}
FUNCTION IsValidIdent(Ident : STRING): Boolean;
EXTERNAL;

FUNCTION LowCase(c : Char): Char;
EXTERNAL;

FUNCTION UpCase(c : Char): Char;
EXTERNAL;

{
      UpperCase converts all characters in the given string to upper case.
      The conversion uses the utility.library. No need to open utility.library.
}
FUNCTION UpperCase( Str :STRING): STRING;
EXTERNAL;

{
      LowerCase converts all characters in the given string to lower case.
      The conversion uses the utility.library. No need to open utility.library.
}
FUNCTION LowerCase( Str :STRING): STRING;
EXTERNAL;

{
      CompareText compares Str1 to Str2, without case-sensitivity. The return value is
      less than 0 IF Str1 < Str2, 0 if Str1 == Str2, or greater than 0 if Str1 > Str2.
      The compare operation done by utility.library.
}
FUNCTION CompareText(Str1, Str2 : STRING): Integer;
EXTERNAL;

{     AnsiNCompareText compares Str1 to Str2, without case-sensitivity. The compare
      operation is controlled by utility.library. The return value is the same as
      for CompareText. This functions never compares more than 'thelen' characters.
}
FUNCTION CompareNText(Str1, Str2 : STRING ; thelen : Integer): Integer;
EXTERNAL;

  
                          


