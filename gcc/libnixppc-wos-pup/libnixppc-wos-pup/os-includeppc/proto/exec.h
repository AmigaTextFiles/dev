/* Automatically generated header! Do not edit! */

#ifndef PPCPROTO_EXEC_H
#define PPCPROTO_EXEC_H

#ifndef EXEC_IO_H
#include <exec/io.h>
#endif /* !EXEC_IO_H */
#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif /* !EXEC_MEMORY_H */
#ifndef EXEC_DEVICES_H
#include <exec/devices.h>
#endif /* !EXEC_DEVICES_H */
#ifndef EXEC_PORTS_H
#include <exec/ports.h>
#endif /* !EXEC_PORTS_H */
#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif /* !EXEC_SEMAPHORES_H */

#include <clib/exec_protos.h>

#ifdef __GNUC__
#include <powerup/ppcinline/exec.h>
#endif /* __GNUC__ */

#ifndef __NOLIBBASE__
extern struct ExecBase *
#ifdef __CONSTLIBBASEDECL__
__CONSTLIBBASEDECL__
#endif /* __CONSTLIBBASEDECL__ */
SysBase;
#endif /* !__NOLIBBASE__ */

#endif /* !PPCPROTO_EXEC_H */
