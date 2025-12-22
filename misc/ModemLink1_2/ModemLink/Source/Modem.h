/*
** NAME: Modem.h
*/

#ifndef MODEM_H
#define MODEM_H

#include <exec/types.h>
#include <devices/serial.h>
#include <utility/tagitem.h>

/*
** Tags to be used with ML_SendModemCMD()
*/
#define ML_DUMMY             (TAG_USER + 0x1000)

#define ML_DialTime          (ML_DUMMY + 0x00)
#define ML_AnswerTime        (ML_DUMMY + 0x01)
#define ML_DialPrefix        (ML_DUMMY + 0x02)
#define ML_Suffix            (ML_DUMMY + 0x03)
#define ML_OkText            (ML_DUMMY + 0x04)
#define ML_BusyText          (ML_DUMMY + 0x05)
#define ML_NoCarrierText     (ML_DUMMY + 0x06)
#define ML_NoDialText        (ML_DUMMY + 0x07)
#define ML_AutoAnsText       (ML_DUMMY + 0x08)


/*
** Return codes for the SendModemCMD() & Dial routine
** Note that most of these corresponde to what the modem itself
** would return.  However, the MODEM_CONNECT is returned when
** the Carrier Detect (CD) bit is set in serial device status bits.
** The MODEM_TIMEOUT is set when none of the other results codes
** occured in the specified amount of time for that command.
*/
#define MODEM_OK              0x0000
#define MODEM_ERROR           0x0001
#define MODEM_BUSY            0x0002
#define MODEM_NOCARRIER       0x0003
#define MODEM_NODIAL          0x0004
#define MODEM_OFF             0x0005
#define MODEM_CONNECT         0x0010
#define MODEM_TIMEOUT         0x0011


/*
** Prototypes
*/
ULONG __saveds __asm
ML_SendModemCMDTagList
(
  register __a0 struct IOExtSer *SerIO,
  register __a1 char *CMD,
  register __a2 struct TagItem *tagList
);

ULONG __saveds __asm
ML_DialTagList
(
  register __a0 struct IOExtSer *SerIO,
  register __a1 char *PhoneNum,
  register __a2 struct TagItem *tagList
);

ULONG __saveds __asm
ML_AnswerTagList
(
  register __a0 struct IOExtSer *SerIO,
  register __a1 struct TagItem *tagList
);

#endif
