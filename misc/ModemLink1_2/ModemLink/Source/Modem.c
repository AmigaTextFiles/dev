/*
** NAME: Modem.c
** DESC: routines to use the modem to dial/answer or any other modem command.
**
** AUTHOR:        DATE:       DESCRIPTION:
** ~~~~~~~~~~~~~~ ~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
** Mike Veroukis  06 Apr 1997 Created
** Mike Veroukis  24 Oct 1997 re-worked SendModemCMD so that it now checks if
**                            modem is off only after it doesn't get a response
**                            from the modem.  Aso re-worked SendModemCMD to
**                            be more flexible and reduce the chance that it
**                            will confuse itself.  Changed the default Suffix
**                            tag to "\r" instead of "\n\r", and also made
**                            sure the modem commands return more meaningful
**                            error/return codes (according to docs).
*/


#include <exec/types.h>
#include <exec/memory.h>
#include <exec/io.h>
#include <exec/ports.h>
#include <devices/serial.h>
#include <devices/timer.h>
#include <dos/dosextens.h>
#include <dos/dostags.h>
#include <utility/tagitem.h>

#include <proto/dos.h>
#include <proto/exec.h>
#include <proto/utility.h>

#include <string.h>
#include <stdio.h>

#include "Modem.h"
#include "ModemLinkAPI.h"
#include "DeviceStuff.h"
#include "ModemLinkTask.h"


/*
** These are bits used by the serial device (via io_Status)
** They are used to determine if the modem is on, or if we've connected
*/
#define DSR    (1 << 3)
#define CD     (1 << 5)


/*
** This is a structure which holds all user configurable settings for
** the modem realated routines.
*/
struct Config {
  int DialTime;
  int AnswerTime;
  char *DialPrefix;
  char *Suffix;
  char *OkText;
  char *BusyText;
  char *NoCarrierText;
  char *NoDialText;
  char *AutoAnsText;
};

struct Config StdConfig = {
  45,
  30,
  "ATDT ",
  "\r",
  "OK",
  "BUSY",
  "NO CARRIER",
  "NO DIALTONE",
  "ATS0=1"
};


/*
** Prototypes
*/
ULONG ML_SendModemCMD(struct IOExtSer *SerIO, char *CMD, struct Config *cfg);


///////////////////////////////////////////////////////////////////////////////


void SetConfig(struct Config *cfg, struct TagItem *tagList)
{
  struct TagItem *tstate;
  struct TagItem *tag;
  ULONG tidata;

  *cfg = StdConfig;

  tstate = tagList;

  while (tag = NextTagItem(&tstate)) {
    tidata = tag->ti_Data;

    switch (tag->ti_Tag) {
      case ML_DialTime:
        cfg->DialTime = (int)tidata;
        break;
      case ML_AnswerTime:
        cfg->AnswerTime = (int)tidata;
        break;
      case ML_DialPrefix:
        cfg->DialPrefix = (char *)tidata;
        break;
      case ML_Suffix:
        cfg->Suffix = (char *)tidata;
        break;
      case ML_OkText:
        cfg->OkText = (char *)tidata;
        break;
      case ML_BusyText:
        cfg->BusyText = (char *)tidata;
        break;
      case ML_NoCarrierText:
        cfg->NoCarrierText = (char *)tidata;
        break;
      case ML_NoDialText:
        cfg->NoDialText = (char *)tidata;
        break;
      case ML_AutoAnsText:
        cfg->AutoAnsText = (char *)tidata;
        break;
    }
  }
}

ULONG __saveds __asm
ML_SendModemCMDTagList
(
  register __a0 struct IOExtSer *SerIO,
  register __a1 char *CMD,
  register __a2 struct TagItem *tagList
)
{
  struct Config ModemConfig;

  if (SerIO && CMD) {
    SetConfig(&ModemConfig, tagList);
    return (ML_SendModemCMD(SerIO, CMD, &ModemConfig));
  }
  return 0L;
}

ULONG ML_SendModemCMD(struct IOExtSer *SerIO, char *CMD, struct Config *cfg)
{
  ULONG buf_size;
  int i;
  ULONG ReturnCode = MODEM_NOCARRIER;
  char *buf, b;

  if (!cfg)
    cfg = &StdConfig;

  buf_size = strlen(CMD) + 16L;

  SerIO->IOSer.io_Command = SDCMD_QUERY;
  DoIO((struct IORequest *) SerIO);

  if (buf = (char *)AllocMem(buf_size, MEMF_CLEAR)) {
    strcpy(buf, CMD);
    if (cfg->Suffix)
      strcat(buf, cfg->Suffix);

    SerIO->IOSer.io_Command = CMD_WRITE;
    SerIO->IOSer.io_Length = strlen(buf);
    SerIO->IOSer.io_Data = (APTR)buf;
    TimedIO((struct IORequest *) SerIO, 2);

    SerIO->IOSer.io_Command = CMD_READ;
    SerIO->IOSer.io_Length = 1L;
    SerIO->IOSer.io_Data = (APTR)&b;

    if (!TimedIO((struct IORequest *) SerIO, 1))
      ReturnCode = MODEM_ERROR;

    if (ReturnCode != MODEM_ERROR) {
      i = 0;

      while (ReturnCode == MODEM_NOCARRIER) {

        SerIO->IOSer.io_Command = CMD_READ;
        SerIO->IOSer.io_Length = 1;
        SerIO->IOSer.io_Data = (APTR)&b;

        if (TimedIO((struct IORequest *) SerIO, cfg->DialTime)) {
          if (b < ' ') {
            buf[i] = 0;
            if (0 == stricmp(buf, cfg->OkText))
              ReturnCode = MODEM_OK;
            else if  (0 == stricmp(buf, cfg->BusyText))
              ReturnCode = MODEM_BUSY;
            else if  (0 == stricmp(buf, cfg->NoCarrierText))
              ReturnCode = MODEM_NOCARRIER;
            else if  (0 == stricmp(buf, cfg->NoDialText))
              ReturnCode = MODEM_NODIAL;

            SerIO->IOSer.io_Command = SDCMD_QUERY;
            DoIO((struct IORequest *) SerIO);

            if (!(SerIO->io_Status & CD))
              ReturnCode = MODEM_CONNECT;

            i = 0;
          }
          else if (i < buf_size-1)
            buf[i++] = b;
        }
        else
          ReturnCode = MODEM_TIMEOUT;
      }
    }
    else if (SerIO->io_Status & DSR)
      ReturnCode = MODEM_OFF;

    if (ReturnCode == MODEM_TIMEOUT) {
      strcpy(buf, cfg->Suffix);
      SerIO->IOSer.io_Command = CMD_WRITE;
      SerIO->IOSer.io_Length = strlen(cfg->Suffix);
      SerIO->IOSer.io_Data = (APTR)buf;
      DoIO((struct IORequest *) SerIO);

      SerIO->IOSer.io_Command = CMD_READ;
      SerIO->IOSer.io_Length = strlen(cfg->Suffix);
      SerIO->IOSer.io_Data = (APTR)buf;
      TimedIO((struct IORequest *) SerIO, 1);
    }


    if (ReturnCode != MODEM_OFF) {
      SerIO->IOSer.io_Command = SDCMD_QUERY;
      DoIO((struct IORequest *) SerIO);

      if (!(SerIO->io_Status & CD))
        ReturnCode = MODEM_CONNECT;

      SerIO->IOSer.io_Command = CMD_CLEAR;
      DoIO((struct IORequest *) SerIO);
    }

    FreeMem(buf, buf_size);
  }

  return (ReturnCode);
}

ULONG __saveds __asm
ML_DialTagList
(
  register __a0 struct IOExtSer *SerIO,
  register __a1 char *PhoneNum,
  register __a2 struct TagItem *tagList
)
{
  struct Config DialConfig;
  char buf[80];
  ULONG ReturnCode = MODEM_ERROR;

  SerIO->IOSer.io_Command = SDCMD_QUERY;
  DoIO((struct IORequest *) SerIO);

  if (!(SerIO->io_Status & CD))
    ReturnCode = MODEM_CONNECT;

  if ((ReturnCode != MODEM_CONNECT) && SerIO && PhoneNum) {
    SetConfig(&DialConfig, tagList);
    strcpy(buf, DialConfig.DialPrefix);
    strcat(buf, PhoneNum);

    ReturnCode = ML_SendModemCMD(SerIO, buf, &DialConfig);
  }

  return (ReturnCode);
}

ULONG __saveds __asm
ML_AnswerTagList
(
  register __a0 struct IOExtSer *SerIO,
  register __a1 struct TagItem *tagList
)
{
  struct Config AnswerConfig;
  struct timerequest *TimerIO = NULL;
  struct MsgPort *TimerMP = NULL;
  ULONG SerBit, TimerBit;
  ULONG booga;
  ULONG ReturnCode = MODEM_TIMEOUT;
  char buf[80];

  SerIO->IOSer.io_Command = SDCMD_QUERY;
  DoIO((struct IORequest *) SerIO);

  if (!(SerIO->io_Status & CD))
    ReturnCode = MODEM_CONNECT;

  if ((ReturnCode != MODEM_CONNECT) && SerIO) {
    if (OpenTimerDevice(&TimerMP, &TimerIO)) {
      SerBit = 1 << SerIO->IOSer.io_Message.mn_ReplyPort->mp_SigBit;
      TimerBit = 1 << TimerMP->mp_SigBit;

      SetConfig(&AnswerConfig, tagList);

      strcpy(buf, AnswerConfig.AutoAnsText);
      booga = ML_SendModemCMD(SerIO, buf, &AnswerConfig);

      if (booga == MODEM_OK) {
        /* Wait for first RING to come in from modem */
        SerIO->IOSer.io_Command = CMD_READ;
        SerIO->IOSer.io_Length = 1;
        SerIO->IOSer.io_Data = (APTR)buf;
        SendIO((struct IORequest *) SerIO);

        TimerIO->tr_node.io_Command = TR_ADDREQUEST;
        TimerIO->tr_time.tv_secs = AnswerConfig.AnswerTime;
        TimerIO->tr_time.tv_micro = 0;
        SendIO((struct IORequest *) TimerIO);

        while (1) {
          Wait(SerBit | TimerBit);

          if (CheckIO((struct IORequest *)SerIO)) {
            WaitIO((struct IORequest *)SerIO);

            SerIO->IOSer.io_Command = SDCMD_QUERY;
            DoIO((struct IORequest *) SerIO);

            if (!(SerIO->io_Status & CD)) {
              if (!CheckIO((struct IORequest *)TimerIO))
                AbortIO((struct IORequest *)TimerIO);
              WaitIO((struct IORequest *)TimerIO);
              break;
            }

            SerIO->IOSer.io_Command = CMD_READ;
            SerIO->IOSer.io_Length = 1;
            SerIO->IOSer.io_Data = (APTR)buf;
            SendIO((struct IORequest *) SerIO);
          }

          if (CheckIO((struct IORequest *)TimerIO)) {
            WaitIO((struct IORequest *)TimerIO);

            if (!CheckIO((struct IORequest *)SerIO))
              AbortIO((struct IORequest *)SerIO);
            WaitIO((struct IORequest *)SerIO);
            break;
          }
        }
      }
      else
        ReturnCode = booga;

      SafeCloseDevice(TimerMP, (struct IORequest *)TimerIO);
    }

    SerIO->IOSer.io_Command = SDCMD_QUERY;
    DoIO((struct IORequest *) SerIO);

    if (!(SerIO->io_Status & CD))
      ReturnCode = MODEM_CONNECT;

    Delay(10);
    SerIO->IOSer.io_Command = CMD_CLEAR;
    DoIO((struct IORequest *) SerIO);
  }

  return (ReturnCode);
}
