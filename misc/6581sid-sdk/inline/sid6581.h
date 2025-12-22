#ifndef _INLINE_SID6581_H
#define _INLINE_SID6581_H

#ifndef SID6581_BASE_NAME
#define SID6581_BASE_NAME SID6581Base
#endif

#define SID_AllocSID() \
	((struct SIDHandle * (*)(struct Library * __asm("a6"))) \
  (((char *) SID6581_BASE_NAME) - 30))(SID6581_BASE_NAME)

#define SID_FreeSID(Handle) \
	((void (*)(struct SIDHandle * __asm("a1"), struct Library * __asm("a6"))) \
  (((char *) SID6581_BASE_NAME) - 36))(Handle, SID6581_BASE_NAME)

#define SID_Interrupt() \
	((void (*)(struct Library * __asm("a6"))) \
  (((char *) SID6581_BASE_NAME) - 42))(SID6581_BASE_NAME)

#define SID_Initialize(Handle) \
	((void (*)(struct SIDHandle * __asm("a1"), struct Library * __asm("a6"))) \
  (((char *) SID6581_BASE_NAME) - 48))(Handle, SID6581_BASE_NAME)

#define SID_ResetSID(Handle) \
	((void (*)(struct SIDHandle * __asm("a1"), struct Library * __asm("a6"))) \
  (((char *) SID6581_BASE_NAME) - 54))(Handle, SID6581_BASE_NAME)

#define SID_IRQOnOff(Base, Flag) \
	((void (*)(struct Library * __asm("a1"), int __asm("d0"), struct Library * __asm("a6"))) \
  (((char *) SID6581_BASE_NAME) - 60))(Base, Flag, SID6581_BASE_NAME)

#define SID_ReadReg(Handle, Regnum) \
	((char (*)(struct SIDHandle * __asm("a1"), char __asm("d0"), struct Library * __asm("a6"))) \
  (((char *) SID6581_BASE_NAME) - 72))(Handle, Regnum, SID6581_BASE_NAME)

#define SID_WriteReg(Handle, Regnum, Byte) \
	((void (*)(struct SIDHandle * __asm("a1"), char __asm("d0"), char __asm("d1"), struct Library * __asm("a6"))) \
  (((char *) SID6581_BASE_NAME) - 78))(Handle, Regnum, Byte, SID6581_BASE_NAME)

#endif /*  _INLINE_SID6581_H  */
