/* EE OpenNew - Open EE window and load arg <filename> */

ADDRESS COMMAND
OPTIONS FAILAT 10

PARSE ARG filename .


/* Start EE and/or wait for it's port to become registered. */
IF ~Show(PORTS, 'EE.0') THEN DO
  'Run E:bin/EE'
  notRunning=1
END

DO WHILE ~Show(PORTS, 'EE.0')
  CALL Delay(50)
END

ADDRESS 'EE.0'
OPTIONS RESULTS

LockWindow
IF notRunning=1 THEN
  Open filename
ELSE
  OpenNew filename
UnlockWindow
