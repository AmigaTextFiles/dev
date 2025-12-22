/*
 * commands.c V1.0.00
 *
 * UMS SMTP (client) command queueing routines (ESMTP PIPELINE support)
 *
 * (c) 1994-97 Stefan Becker
 */

#include "umssmtp.h"

/* Local data structures */
struct QueueEntry {
 ULONG     qe_Type;
 UMSMsgNum qe_MsgNum;
};

/* Local data */
static fd_set FDSet;
static struct QueueEntry  CommandQueue[QUEUELEN];
static struct QueueEntry *NextFree;
static ULONG MaxQueueLength;
static ULONG Outstanding;
static ULONG LastResponse;

/* Initialize module data */
static void InitQueueData(void)
{
 /* Initialize file descriptor set */
 FD_ZERO(&FDSet);

 /* Initialize command queue */
 NextFree       = CommandQueue;
 Outstanding    = 0;
 LastResponse   = SMTP_ACTION_OK;
}

/* Disable command queueing */
void DisableQueue(void)
{
 /* Set maximum queue length to 1 */
 MaxQueueLength = 1;

 /* Initialize data */
 InitQueueData();
}

/* Enable command queueing */
void EnableQueue(void)
{
 /* Set maximum queue length to maximum */
 MaxQueueLength = QUEUELEN;

 /* Initialize data */
 InitQueueData();
}

/* Empty queue */
ULONG EmptyQueue(void)
{
 ULONG rc;

 /* Are there any outstanding responses? */
 if (Outstanding) {
  struct QueueEntry *qe = CommandQueue;

  /* Yes, initialize file descriptor set */
  FD_SET(SMTPSocket, &FDSet);

  DEBUGLOG(kprintf("Waiting for input on socket.\n");)

  /* Wait until there is something to read from the socket */
  WaitSelect(SMTPSocket + 1, &FDSet, NULL, NULL, NULL, NULL);

  /* For each outstanding response */
  while (Outstanding--) {

   /* Read response */
   if ((rc = GetReturnCode()) == SMTP_SERVICE_NOT_AVAILABLE)

    /* Connection lost, leave loop */
    break;

   DEBUGLOG(kprintf("Response %ld for Cmd %ld (MsgNum %ld), left %ld\n",
                    rc, qe->qe_Type, qe->qe_MsgNum, Outstanding);)

   /* Handle response code depending on the type of the command */
   switch (qe->qe_Type) {

    case QUEUETYPE_MAILFROM:
     HandleMAILFROMResponse(rc);
     break;

    case QUEUETYPE_RCPTTO:
     HandleRCPTTOResponse(rc, qe->qe_MsgNum);
     break;

    case QUEUETYPE_IGNORE:
     /* Ignore return code */
     break;
   }

   /* Move pointer to next outstanding response */
   qe++;
  }

  /* Queue empty */
  Outstanding = 0;
  NextFree    = CommandQueue;

  /* Set last response code */
  LastResponse = rc;

 } else

  /* No, just return the last response code */
  rc = LastResponse;

 return(rc);
}

/* Queue one command */
ULONG QueueCommand(const char *cmd, ULONG len, ULONG type, UMSMsgNum msgnum)
{
 ULONG rc = SMTP_ACTION_OK;

 /* Maximum queue length reached? */
 if (Outstanding >= MaxQueueLength)

  /* Yes, empty queue */
  rc = EmptyQueue();

 /* All OK? */
 if (rc != SMTP_SERVICE_NOT_AVAILABLE) {

  /* Send command */
  Send(SMTPSocket, cmd, len, 0);

  /* Queue command */
  NextFree->qe_Type   = type;
  NextFree->qe_MsgNum = msgnum;
  NextFree++;
  Outstanding++;
 }

 /* Return last response code */
 return(rc);
}
