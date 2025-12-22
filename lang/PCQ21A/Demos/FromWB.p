PROGRAM FromWB;

{$I "Include:PCQUtils/Utils.i"}

VAR
    i : INTEGER;

BEGIN
    IF FromWB THEN
        i := EasyReqArgs(NIL,"Started from Workbench","OK")
    ELSE i := EasyReqArgs(NIL,"Started from Cli","OK");
END.


