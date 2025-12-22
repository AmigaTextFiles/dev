IMPLEMENTATION MODULE CliOnly ;

IMPORT M2Lib ;

BEGIN
  IF M2Lib.wbStarted THEN
    M2Lib._ErrorReq("This program will only","run from the CLI/SHELL")
  END ;
END CliOnly.
