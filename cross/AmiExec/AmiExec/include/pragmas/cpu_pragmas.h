/* $Id: cpu_pragmas.h,v 3.1 1994/06/27 16:27:49 wjm Exp $
 *
 * Function descriptors for cpu.resource.
 *
***** 0 private functions. *****
 */
#pragma libcall CPUResource AllocCPUResource 6 8002
#pragma libcall CPUResource FreeCPUResource C 001
#pragma libcall CPUResource SetSerialSettings 12 8002
#pragma libcall CPUResource GetSerialSettings 18 8002
#pragma libcall CPUResource CPU_PutChar 1E 1002
#pragma libcall CPUResource CPU_ReadChar 24 8002
#pragma libcall CPUResource CPU_GetChar 2A 801

/*
 *     7 total functions
 *     7 public
 *     0 private
 */
