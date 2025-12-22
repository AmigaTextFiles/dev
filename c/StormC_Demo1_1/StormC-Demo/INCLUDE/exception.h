#ifndef _INCLUDE_EXCEPTION_H
#define _INCLUDE_EXCEPTION_H

/*
**  $VER: exception.h 1.0 (18.1.96)
**  StormC Release 1.1
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#ifndef __cplusplus
#error <exception.h> must be compiled in C++ mode.
#pragma +
#endif

class Exception { 
public:
    virtual ~Exception() { };
};

void unexpected();
void terminate();

void (*set_unexpected(void(*)()))();
void (*set_terminate(void(*)()))();

#endif
