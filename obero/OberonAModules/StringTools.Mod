(*
StringTools.MOD ©1998-99 Morten Bjergstrøm
EMail: mbjergstroem@hotmail.com
*)

<*MAIN-*>
MODULE StringTools;

IMPORT
  Strings;



PROCEDURE CompareString*(string1,string2:ARRAY OF CHAR):SHORTINT;

VAR
  counter:INTEGER;
  length:INTEGER;
  returnvalue:SHORTINT;
  same:BOOLEAN;

BEGIN

  same:=FALSE;
  counter:=0;

  IF Strings.Length(string1)>Strings.Length(string2) THEN
    length:=Strings.Length(string2);
  ELSE
    length:=Strings.Length(string2);
  END;

  LOOP

    IF ORD(string1[counter])=ORD(string2[counter]) THEN
      same:=TRUE;
    END;

    IF ORD(string1[counter])<ORD(string2[counter]) THEN
      returnvalue:=-1;
      same:=FALSE;
      EXIT;
    END;

    IF ORD(string1[counter])>ORD(string2[counter]) THEN
      returnvalue:=1;
      same:=FALSE;
      EXIT;
    END;

    INC(counter);
    IF counter=length THEN EXIT END;

  END;

  IF same=TRUE THEN
    returnvalue:=0;
  END;

  RETURN returnvalue;


END CompareString;


END StringTools.
