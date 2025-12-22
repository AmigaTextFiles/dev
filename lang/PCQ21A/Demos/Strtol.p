PROGRAM Strtol;

{$I "Include:PCQUtils/CStrings.i"}
{$I "Include:PCQUtils/Args.i"}

VAR
    v    : INTEGER;
    tail : STRING;
    buff : ARRAY [0..100] OF Char;
    buffer : STRING;

BEGIN
    buffer := @buff;
    IF ParamCount = 2 THEN BEGIN
        v := strtol(ParamStr(1),tail,atoi(ParamStr(2)));
        sprintf(buffer,"V = %ld, tail = %s\n",v,tail);
        Write(buffer);
        Exit(0);
    END ELSE BEGIN
        WriteLN("StrTol <STRING> <base>");
        WriteLN("StrTol 0123abc 0");
        WriteLN("StrTol 0x1000 0");
        WriteLN("StrTol 123abc 16");
        WriteLN("StrTol $FFF 0");
        Exit(1);
    END;
END.



