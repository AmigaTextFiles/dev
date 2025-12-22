#ifndef _INLINE_VEKTORIAL_H
#define _INLINE_VEKTORIAL_H

#ifndef __INLINE_MACROS_H
#include <inline/macros.h>
#endif

#ifndef VEKTORIAL_BASE_NAME
#define VEKTORIAL_BASE_NAME VektorialBase
#endif

#define VekLookingAt(Origin, LookAt) \
	LP2NR(0x1E, VekLookingAt, struct Vek *, Origin, a0, struct Vek *, LookAt, a1, \
	, VEKTORIAL_BASE_NAME)

#define CamLookingAt(Camera, LookAt, Mode) \
	LP3NR(0x24, CamLookingAt, struct Ref *, Camera, a0, struct Vek *, LookAt, a1, ULONG, Mode, d0, \
	, VEKTORIAL_BASE_NAME)

#define RotateDD(Vekt, Angle, X, Y) \
	LP4NR(0x2A, RotateDD, struct Vek *, Vekt, a0, ULONG, Angle, d0, ULONG, X, d1, ULONG, Y, d2, \
	, VEKTORIAL_BASE_NAME)

#endif /*  _INLINE_VEKTORIAL_H  */
