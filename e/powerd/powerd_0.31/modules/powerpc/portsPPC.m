MODULE 'powerpc/semaphoresPPC'

OBJECT MsgPortPPC
  Port:MsgPort,
  IntMsg:List,
  Semaphore:SignalSemaphorePPC

CONST NT_MSGPORTPPC=101
/* status returned by PutPublicMsgPPC */
ENUM PUBMSG_SUCCESS=-1,
 PUBMSG_NOPORT
/* status returned by AddUniquePortPPC */
ENUM UNIPORT_SUCCESS=-1,
 UNIPORT_NOTUNIQUE
