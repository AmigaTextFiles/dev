
{* A demo of Exec alerts. *}

'..From C header exec/alerts.h
CONST AT_Recovery = &H00000000
CONST AO_Unknown  = &H00008035

LIBRARY "exec.library"
DECLARE FUNCTION Alert(LONGINT alertNum) LIBRARY exec

Alert(AT_Recovery OR AO_Unknown)

LIBRARY CLOSE
