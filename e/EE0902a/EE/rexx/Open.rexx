/* EE OpenNew - Open EE window and load arg <filename> */

ADDRESS COMMAND
OPTIONS FAILAT 10

PARSE ARG filename

/* Start EE and/or wait for it's port to become registered. */
IF ~Show(PORTS, 'EE.0') THEN 'Run E:bin/EE'
DO WHILE ~Show(PORTS, 'EE.0')
  CALL Delay(50)
END

ADDRESS 'EE.0'
OPTIONS RESULTS

LockWindow
Open filename
UnlockWindow
