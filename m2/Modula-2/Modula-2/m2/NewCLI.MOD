MODULE NewCLI;

FROM AMIGADos IMPORT AMIGAFile, Close, Delay, Execute, Open;
FROM Terminal IMPORT WriteString, WriteLn;

VAR f1, f2: AMIGAFile;
    ok: BOOLEAN;

BEGIN
  WriteString('NewCLI Demo'); WriteLn;
  WriteString('==========='); WriteLn; WriteLn;
  WriteString('Use EndCLI in new window to exit!'); WriteLn;
  Delay(50);
  f1:=Open("CON:300/20/320/160/Modula-2 created NewCLI", TRUE);
  f2:=AMIGAFile(0);
  Execute("", f1, f2, ok);
  Close(f1);
  WriteString('Here we are again'); WriteLn;
END NewCLI.
