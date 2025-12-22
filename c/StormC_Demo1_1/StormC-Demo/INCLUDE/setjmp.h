#ifndef _INCLUDE_SETJMP_H
#define _INCLUDE_SETJMP_H

/*
**  $VER: setjmp.h 1.0 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifdef __cplusplus
extern "C" {
#endif

#define _JMP_BUF_SIZE 16
typedef int jmp_buf[_JMP_BUF_SIZE];

int setjmp(jmp_buf);
void longjmp(jmp_buf, int);

#ifdef __cplusplus
}
#endif

#endif
