
{$I "Include:DOS/Dos.i"}
{$I "Include:Utils/StringLib.i"}

{$C+}
PROCEDURE Printf(Str : String; ...);
VAR Objects : Array[0..50] of Address;
    ArgPtr : Address;
    i : Integer;
    ParamNum : Integer;
BEGIN
  VA_Start(ArgPtr);

  ParamNum:=0;
  For i:=0 to StrLen(Str) do IF Str[i]='%' THEN Inc(ParamNum);  { Prozent-Zeichen zählen }

  For i:=0 to ParamNum-1 do Objects[i]:=VA_Arg(ArgPtr,Address);
  i:=VPrintf(Str,adr(Objects));
END;
{$C-}

