#ifndef  _PROTO_EXEC_H
#define  _PROTO_EXEC_H

/*
**  $VER: exec.h 10.1 (19.7.95)
**  Includes Release 40.15
**
**  '(C) Copyright 1995/96 Haage & Partner Computer GmbH'
**	 All Rights Reserved
*/

#include <exec/types.h>
#include <clib/exec_protos.h>
//#ifdef (_USEOLDEXEC_) || !defined(__USE_SYSBASE)
#include <pragmas/exec_pragmas.h>
//#else
//extern struct ExecBase *SysBase;
//#include <pragmas/exec_sysbase_pragmas.h>
//#endif

/*------ Common support library functions ---------*/
#include <clib/alib_protos.h>
#endif
