#ifndef RESOURCES_CPU_H
#define RESOURCES_CPU_H 1
/**************************************************************************** 

$Source: MASTER:include/resources/cpu.h,v $
$Revision: 3.0 $
$Date: 1994/06/23 15:36:44 $

A public include containing, the macros, definitions, and structures,
required for use of a generic cpu.resource.  Most CPUs extend on what
is defined here.

****************************************************************************/
#ifndef  EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif


/* A CPU resource is an extended Library. */

struct CPUResource
   {
   struct Library library;
   char   *CPUName;        /* name of the CPU board - e.g. "Force CPU-6" */
   ULONG  VMEbusStandard;  /* base address or -1 if not VME system */
   ULONG  VMEbusShort;     /* base address or -1 if not VME system */
   };  

#endif
