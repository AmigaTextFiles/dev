
/* data.c */

/* dprintf.c */
VOID ChooseParallelOutput(VOID);
VOID DVPrintf(const STRPTR format, const va_list varArgs);
VOID DPrintf(const STRPTR format, ...);

/* dump.c */
VOID VoiceComplaint(UBYTE trap, UWORD sr, ULONG pc, ULONG *stackFrame, const STRPTR format, ...);

/* main.c */
int main(int argc, char **argv);

/* patches.c */
VOID AddPatches(VOID);
VOID RemovePatches(VOID);

/* segtracker.c */
BOOL FindAddress(ULONG address, LONG nameLen, STRPTR nameBuffer, ULONG *segmentPtr, ULONG *offsetPtr);

/* showcrashinfo.c */
VOID ASM ShowCrashInfo(REG (d0 )UBYTE trapType, REG (d1 )ULONG pc, REG (d2 )UWORD sr, REG (a0 )ULONG *stackFrame);

/* timer.c */
VOID StopTimer(VOID);
VOID StartTimer(ULONG seconds, ULONG micros);
VOID DeleteTimer(VOID);
BYTE CreateTimer(VOID);

/* tools.c */
VOID StrcpyN(LONG MaxLen, STRPTR To, const STRPTR From);
BOOL VSPrintfN(LONG MaxLen, STRPTR Buffer, const STRPTR FormatString, const va_list VarArgs);
BOOL SPrintfN(LONG MaxLen, STRPTR Buffer, const STRPTR FormatString, ...);
VOID ConvertTimeAndDate(const struct timeval *tv, STRPTR dateTimeBuffer);

/* system_headers.c */
