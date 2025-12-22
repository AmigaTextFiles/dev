#include <exec/resident.h>
#include <amigem/utils.h>
#include "exec.h"

long Exec_Start(void) /* Error return if started as a program */
{ return -1; }

void __Exec_Init(void);	/* Some globals */
extern const long Exec_EndCode;

const char Exec_Name[]=LIB_NAME;
const char Exec_VStr[]=LIB_VERSTRING(LIB_NAME,LIB_VERSION,LIB_REVISION,LIB_DATE);

const struct Resident Exec_RomTag=
{
  RTC_MATCHWORD,
  (struct Resident *)&Exec_RomTag,
  (APTR)&Exec_EndCode,
  0,
  LIB_VERSION,
  NT_LIBRARY,
  0,
  (char *)Exec_Name,
  (char *)LIB_ID(Exec_VStr),
  (APTR)&__Exec_Init
};

const long Exec_EndCode=0; /* Mark the end of the area in which no romtags can be found */
