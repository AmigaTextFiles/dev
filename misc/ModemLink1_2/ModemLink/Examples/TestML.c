/*
** NAME: TestML.c
** DESC: A terminal style program to test the modemlink.lib.  It will open the
**       serial.device using the settings saved in serial.prefs.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  06 Apr 1997 Created
** Mike Veroukis  13 Oct 1997 Added extra print statements to help make it
**                            clearer what it's doing.
*/


#include <exec/types.h>
#include <exec/memory.h>
#include <exec/io.h>
#include <devices/serial.h>
#include <utility/tagitem.h>

#include <proto/exec.h>
#include <proto/dos.h>
#include <proto/intuition.h>

#include <stdio.h>
#include <string.h>

#include <ModemLink/ModemLink.h>
#include <clib/ModemLink_protos.h>
#include "DeviceStuff.h"

void main(int argc, char **argv)
{
  struct IOExtLink *LinkWriteIO, *LinkReadIO;
  struct IOExtSer *SerIO;
  struct MsgPort *LinkWriteMP, *LinkReadMP, *SerMP;
  char buf[512];
  int Connect, BusyCount = 0;

  printf("Test ModemLink -- Let's hope this thing works!!!\n");

  if (argc < 3) {
    if (LinkWriteMP = CreateMsgPort()) {
      if (LinkWriteIO = CreateIORequest(LinkWriteMP, sizeof(struct IOExtLink))) {
        if (OpenSerialDevice(&SerMP, &SerIO, "serial.device", 0L)) {
          if (argc == 2)
            do {
              if (BusyCount)
                Delay(150);

              printf("Dialing %s....\n", argv[1]);

              Connect = ML_DialTags(SerIO, argv[1], TAG_DONE);
              printf("Dialer ReturnCode: %d\n", Connect);
            } while (Connect == MODEM_BUSY && BusyCount++ < 2);
          else {
            printf("Waiting for incomming call...\n");

            Connect = ML_AnswerTagList(SerIO, NULL);
          }

          printf("Modem ReturnCode: %d\n", Connect);

          if (Connect == MODEM_CONNECT) {
            Connect = ML_EstablishTagList(LinkWriteIO, SerIO, NULL);

            printf("Establish ReturnCode: %d\n", Connect);

            if (Connect == EstErr_OK) {
              printf("Connected!!!\n\n");
              printf("Type message and hit return to send\n");
              printf("Hit return to check for incomming messages\n");
              printf("Enter '.' and hit return on a new line to quit\n\n");

              if (CloneIO((struct IORequest *)LinkWriteIO, &LinkReadMP, (struct IORequest **)&LinkReadIO)) {
                LinkReadIO->IOLink.io_Command = CMD_READ;
                LinkReadIO->IOLink.io_Data = 0;
                ML_SendIO((struct IORequest *)LinkReadIO);

                while (1) {
                  printf("\n: ");
                  gets(buf);
                  if (buf[0] == '.' && buf[1] == 0)
                    break;

                  if (buf[0] > ' ') {
                    printf("Sending: [%s]\n", buf);

                    LinkWriteIO->IOLink.io_Command = CMD_WRITE;
                    LinkWriteIO->IOLink.io_Data = &buf;
                    LinkWriteIO->IOLink.io_Length = strlen(buf) + 1;
                    ML_DoIO((struct IORequest *)LinkWriteIO);
                  }

                  if (CheckIO((struct IORequest *)LinkReadIO)) {
                    WaitIO((struct IORequest *)LinkReadIO);
                    DisplayBeep(NULL);

                    if (!LinkReadIO->IOLink.io_Error) {
                      printf(">> [%s]\n", LinkReadIO->IOLink.io_Data);

                      FreeMem(LinkReadIO->IOLink.io_Data, LinkReadIO->IOLink.io_Length);

                      LinkReadIO->IOLink.io_Command = CMD_READ;
                      LinkReadIO->IOLink.io_Data = 0L;
                      ML_SendIO((struct IORequest *)LinkReadIO);
                    }
                    else
                      printf("io_Error: %X\n", LinkReadIO->IOLink.io_Error);
                  }

                  LinkWriteIO->IOLink.io_Command = MLCMD_QUERY;
                  ML_DoIO((struct IORequest *)LinkWriteIO);
                  if (LinkWriteIO->IOLink.io_Error)
                    break;
                }

                if (!LinkReadIO->IOLink.io_Error) {
                  ML_AbortIO((struct IORequest *)LinkReadIO);
                  if (!CheckIO((struct IORequest *)LinkReadIO))
                    WaitIO((struct IORequest *)LinkReadIO);
                }

                DeleteIO_MP(LinkReadMP, (struct IORequest *)LinkReadIO);
              }
              ML_Terminate(LinkWriteIO);
            }
          }
          SafeCloseDevice(SerMP, (struct IORequest *)SerIO);
        }
        DeleteIORequest((struct IORequest *) LinkWriteIO);
      }
      DeleteMsgPort(LinkWriteMP);
    }
  }
  else
    printf("\nUSAGE: TestML <PhoneNumber>\n");
}
