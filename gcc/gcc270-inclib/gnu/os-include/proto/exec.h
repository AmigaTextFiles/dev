#ifndef PROTO_EXEC_H
#define PROTO_EXEC_H

#ifndef EXEC_IO_H
#include <exec/io.h>
#endif
#ifndef EXEC_MEMORY_H
#include <exec/memory.h>
#endif
#ifndef EXEC_DEVICES_H
#include <exec/devices.h>
#endif
#ifndef EXEC_PORTS_H
#include <exec/ports.h>
#endif
#ifndef EXEC_SEMAPHORES_H
#include <exec/semaphores.h>
#endif
#include <clib/exec_protos.h>
#if defined(__OPTIMIZE__) && !defined(__NOINLINES__)
#ifdef _USEOLDEXEC_
#define SysBase ((struct ExecBase *)*(struct Library **)4)
#define BASE_EXT_DECL
#define BASE_EXT_DECL0
#define BASE_NAME SysBase
#endif
#include <inline/exec.h>
#endif
#if !defined(__NOLIBBASE__) && !defined(_USEOLDEXEC_)
extern struct ExecBase *SysBase;
#endif

#endif
