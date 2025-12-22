#ifndef ML_TASK_H
#define ML_TASK_H


#define SOH 0x01         // Start Of Header
#define CAN 0x18         // used to cancle link
#define EOT 0x04         // final byte sent in transmission

#define ENQ 0x05         // ENQuire to see if other side is there
#define ACK 0x06         // ACKnowlegde             -- ACK!
#define NAK 0x15         // NAK - something wrong   -- GACK!
#define GACK NAK

// Error codes for ReadPacket()
#define RPERR_OK         0x0000
#define RPERR_NOPKT      0x0001
#define RPERR_PKTNUM     0x0002
#define RPERR_PKTCRC     0x0004

#define ID_LENGTH sizeof(BYTE)

void __saveds __asm AckTask(register __d0 ULONG Len, register __a0 char *PortName);

#endif
