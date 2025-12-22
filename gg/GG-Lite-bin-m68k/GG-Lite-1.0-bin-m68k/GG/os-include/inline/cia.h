#ifndef _INLINE_CIA_H
#define _INLINE_CIA_H

#ifndef CLIB_CIA_PROTOS_H
#define CLIB_CIA_PROTOS_H
#endif

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef  EXEC_TYPES_H
#include <exec/types.h>
#endif
#ifndef  EXEC_INTERRUPTS_H
#include <exec/interrupts.h>
#endif
#ifndef  EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#define AddICRVector(resource, iCRBit, interrupt) \
	LP3UB(0x6, struct Interrupt *, AddICRVector, struct Library *, resource, a6, LONG, iCRBit, d0, struct Interrupt *, interrupt, a1)

#define RemICRVector(resource, iCRBit, interrupt) \
	LP3NRUB(0xc, RemICRVector, struct Library *, resource, a6, LONG, iCRBit, d0, struct Interrupt *, interrupt, a1)

#define AbleICR(resource, mask) \
	LP2UB(0x12, WORD, AbleICR, struct Library *, resource, a6, LONG, mask, d0)

#define SetICR(resource, mask) \
	LP2UB(0x18, WORD, SetICR, struct Library *, resource, a6, LONG, mask, d0)

#endif /*  _INLINE_CIA_H  */
