MODULE argtst;

IMPORT A:Arguments,io:InOut;

VAR s:ARRAY[0..10] OF CHAR;

  i:INTEGER;

BEGIN

 FOR i:=0 TO A.NumArgs() DO
  A.GetArg(i,s);
  io.WriteString(s);
  io.WriteLn;
 END;
END argtst.
