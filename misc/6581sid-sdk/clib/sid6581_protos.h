#ifndef  CLIB_SID6581_PROTOS_H
#define  CLIB_SID6581_PROTOS_H

/*
**      $VER: sid6581_protos.h 1.1 (25.07.2003)
**
**      C prototypes. For use with 32 bit integers only.
**
*/

#ifdef __cplusplus
extern "C" {
#endif

struct SIDHandle *SID_AllocSID(void);
void SID_FreeSID(struct SIDHandle * Handle );
void SID_Interrupt(void);
void SID_Initialize(struct SIDHandle * Handle );
void SID_ResetSID(struct SIDHandle * Handle );
void SID_IRQOnOff(struct SIDHandle * Handle , int Flag);
char SID_ReadReg(struct SIDHandle * Handle , char RegNum );
void SID_WriteReg(struct SIDHandle * Handle , char RegNum, char Byte);

#ifdef __cplusplus
};
#endif

#endif /* CLIB_SID6581_PROTOS_H */

