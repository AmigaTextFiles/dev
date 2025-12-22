#ifndef	CLIB_VEKTORIAL_H
#define	CLIB_VEKTORIAL_H

#include	<wild/tdcore.h>

void	VekLookingAt(struct Vek *origin,struct Vek *lookat);
void	CamLookingAt(struct Ref *camera,struct Vek *lookat,ULONG mode);
void	RotateDD(struct Vek *pnt,ULONG angle,ULONG offsX,ULONG offsY);

#endif