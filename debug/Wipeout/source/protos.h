
/* addresstest.c */
BOOL IsValidAddress(ULONG address);
BOOL IsInvalidAddress(ULONG address);
BOOL IsOddAddress(ULONG address);
BOOL IsAllocatedMemory(ULONG address, ULONG size);

/* allocator.c */
ULONG CalculateChecksum(const ULONG *mem, ULONG memSize);
VOID FixTrackHeaderChecksum(struct TrackHeader *th);
VOID PerformDeallocation(struct TrackHeader *th);
BOOL PerformAllocation(ULONG pc, struct PoolHeader *poolHeader, ULONG memSize, ULONG attributes, UBYTE type, APTR *resultPtr);
BOOL IsValidTrackHeader(struct TrackHeader *th);
BOOL IsTrackHeaderChecksumCorrect(struct TrackHeader *th);
BOOL IsTrackedAllocation(ULONG address, struct TrackHeader **resultPtr);
VOID SetupAllocationList(VOID);
VOID CheckAllocatedMemory(VOID);
VOID ShowUnmarkedMemory(VOID);
VOID ChangeMemoryMarks(BOOL markSet);
BOOL IsAllocationListConsistent(VOID);
BOOL IsMemoryListConsistent(struct MinList *mlh);

/* data.c */

/* dprintf.c */
VOID ChooseParallelOutput(VOID);
VOID DVPrintf(const STRPTR format, const va_list varArgs);
VOID DPrintf(const STRPTR format, ...);

/* dump.c */
VOID DumpWall(const UBYTE *wall, int wallSize, UBYTE fillChar);
VOID VoiceComplaint(ULONG *stackFrame, struct TrackHeader *th, const STRPTR format, ...);
VOID DumpPoolOwner(const struct PoolHeader *ph);

/* fillchar.c */
VOID SetFillChar(UBYTE newFillChar);
UBYTE NewFillChar(VOID);
BOOL WasStompedUpon(UBYTE *mem, LONG memSize, UBYTE fillChar, UBYTE **stompPtr, LONG *stompSize);

/* filter.c */
VOID ClearFilterList(VOID);
VOID InitFilterList(VOID);
BOOL UpdateFilter(const STRPTR filterString);
BOOL CanAllocate(VOID);
VOID CheckFilter(VOID);

/* installpatches.c */
VOID InstallPatches(VOID);

/* main.c */
int main(int argc, char **argv);

/* mungmem.c */
VOID MungMem(ULONG *mem, ULONG numBytes, ULONG magic);
VOID BeginMemMung(VOID);

/* monitoring.c */
BOOL CheckStomping(ULONG *stackFrame, struct TrackHeader *th);
APTR ASM NewAllocMem(REG (d0 )ULONG byteSize, REG (d1 )ULONG attributes, REG (a2 )ULONG *stackFrame);
VOID ASM NewFreeMem(REG (a1 )APTR memoryBlock, REG (d0 )ULONG byteSize, REG (a2 )ULONG *stackFrame);
APTR ASM NewAllocVec(REG (d0 )ULONG byteSize, REG (d1 )ULONG attributes, REG (a2 )ULONG *stackFrame);
VOID ASM NewFreeVec(REG (a1 )APTR memoryBlock, REG (a2 )ULONG *stackFrame);
APTR ASM NewCreatePool(REG (d0 )ULONG memFlags, REG (d1 )ULONG puddleSize, REG (d2 )ULONG threshSize, REG (a2 )ULONG *stackFrame);
VOID ASM NewDeletePool(REG (a0 )APTR poolHeader, REG (a2 )ULONG *stackFrame);
APTR ASM NewAllocPooled(REG (a0 )APTR poolHeader, REG (d0 )ULONG memSize, REG (a2 )ULONG *stackFrame);
VOID ASM NewFreePooled(REG (a0 )APTR poolHeader, REG (a1 )APTR memoryBlock, REG (d0 )ULONG memSize, REG (a2 )ULONG *stackFrame);

/* nametag.c */
LONG GetNameTagLen(ULONG pc);
VOID FillNameTag(APTR mem, LONG size);
BOOL GetNameTagData(const APTR mem, LONG size, STRPTR *programNamePtr, ULONG *segmentPtr, ULONG *offsetPtr, STRPTR *taskNamePtr);

/* pools.c */
VOID SetupPoolList(VOID);
VOID HoldPoolSemaphore(struct PoolHeader *ph, ULONG pc);
VOID ReleasePoolSemaphore(struct PoolHeader *ph);
BOOL PuddleIsInPool(struct PoolHeader *ph, APTR mem);
VOID RemovePuddle(struct TrackHeader *th);
VOID AddPuddle(struct PoolHeader *ph, struct TrackHeader *th);
struct PoolHeader *FindPoolHeader(APTR poolHeader);
BOOL DeletePoolHeader(ULONG *stackFrame, struct PoolHeader *ph);
struct PoolHeader *CreatePoolHeader(ULONG attributes, ULONG puddleSize, ULONG threshSize, ULONG pc);
VOID CheckPools(VOID);
VOID ShowUnmarkedPools(VOID);
VOID ChangePuddleMarks(BOOL markSet);
BOOL IsPuddleListConsistent(struct PoolHeader *ph);

/* privateallocvec.c */
APTR PrivateAllocVec(ULONG byteSize, ULONG attributes);
VOID PrivateFreeVec(APTR memoryBlock);

/* segtracker.c */
BOOL FindAddress(ULONG address, LONG nameLen, STRPTR nameBuffer, ULONG *segmentPtr, ULONG *offsetPtr);

/* taskinfo.c */
STRPTR GetTaskTypeName(LONG type);
LONG GetTaskType(struct Task *whichTask);
BOOL GetTaskName(struct Task *whichTask, STRPTR name, LONG nameLen);

/* timer.c */
VOID StopTimer(VOID);
VOID StartTimer(ULONG seconds, ULONG micros);
VOID DeleteTimer(VOID);
BYTE CreateTimer(VOID);

/* tools.c */
VOID StrcpyN(LONG MaxLen, STRPTR To, const STRPTR From);
BOOL VSPrintfN(LONG MaxLen, STRPTR Buffer, const STRPTR FormatString, const va_list VarArgs);
BOOL SPrintfN(LONG MaxLen, STRPTR Buffer, const STRPTR FormatString, ...);
BOOL DecodeNumber(const STRPTR number, LONG *valuePtr);
VOID ConvertTimeAndDate(const struct timeval *tv, STRPTR dateTime);
struct Node *FindIName(const struct List *list, const STRPTR name);
BOOL IsTaskStillAround(const struct Task *whichTask);

/* system_headers.c */
