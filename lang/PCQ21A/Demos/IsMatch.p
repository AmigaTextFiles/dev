PROGRAM IsMatch;

{$I "Include:PCQUtils/CStrings.i"}
{$I "Include:PCQUtils/Args.i"}
{$I "Include:PCQUtils/Utils.i"}
{$I "Include:Utils/StringLib.i"}

VAR
    tail   : STRING;
    buff   : ARRAY [0..100] OF Char;
    buffer : STRING;
    dummy  : BOOLEAN;
BEGIN
    buffer := @buff;
    IF ParamCount = 2 THEN BEGIN
        dummy := Match(ParamStr(1),ParamStr(2));
        IF dummy THEN BEGIN
            sprintf(buffer,"The strings %s and %s matched\n",ParamStr(1),ParamStr(2));
            Write(buffer);
        END ELSE
            WriteLN("The strings didn't matched");
    END ELSE
        WriteLN("IsMatch <STRING> <wildcard>")
END.



