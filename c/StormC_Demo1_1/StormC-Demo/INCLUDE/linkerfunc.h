#ifndef _INCLUDE_LINKERFUNC_H
#define _INCLUDE_LINKERFUNC_H

/*
**  $VER: linkerfunc.h 1.01 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif

void InitModules(void);
void CleanupModules(void);

void GetBaseReg(void);
void geta4(void); // only for compatibility, use GetBaseReg()

#ifdef __cplusplus
}
#endif

#endif
