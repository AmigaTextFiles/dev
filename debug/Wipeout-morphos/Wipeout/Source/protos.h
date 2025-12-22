
/* addresstest.c */
BOOL IsValidAddress(ULONG address);
BOOL IsInvalidAddress(ULONG address);
BOOL IsOddAddress(ULONG address);
BOOL IsAllocatedMemory(ULONG address, ULONG size);

/* allocator.c */
ULONG CalculateChecksum(const ULONG *mem, ULONG memSize);
VOID FixTrackHeaderChecksum(struct TrackHeader *th);
VOID PerformDeallocation(struct TrackHeader *th);
BOOL PerformAllocation(ULONG pc[TRACKEDCALLERSTACKSIZE], struct PoolHeader *poolHeader, ULONG memSize, ULONG attributes, UBYTE type, APTR *resultPtr);
BOOL PerformAllocationAligned(ULONG pc[TRACKEDCALLERSTACKSIZE], struct PoolHeader *poolHeader, ULONG memSize, ULONG attributes, ULONG align, ULONG offset, UBYTE type, APTR *resultPtr);
BOOL IsValidTrackHeader(struct TrackHeader *th);
BOOL IsTrackHeaderChecksumCorrect(struct TrackHeader *th);
struct TrackHeader *IsTrackedAllocation(ULONG	address);
VOID CheckAllocatedMemory(VOID);
VOID ShowUnmarkedMemory(VOID);
VOID ChangeMemoryMarks(BOOL markSet);
BOOL IsAllocationListConsistent(VOID);
BOOL IsMemoryListConsistent(struct MinList *mlh);

/* data.c */

/* dprintf.c */
VOID ChooseParallelOutput(VOID);
VOID DVPrintf(CONST_STRPTR format, va_list varArgs);
VOID DPrintf(CONST_STRPTR format, ...);

/* dump.c */
VOID DumpWall(const UBYTE *wall, int wallSize, UBYTE fillChar);
VOID DumpArea(const UBYTE *wall, int wallSize);
VOID VoiceComplaint(ULONG *stackFrame,ULONG pc[TRACKEDCALLERSTACKSIZE],struct TrackHeader *th, CONST_STRPTR format, ...);
VOID DumpPoolOwner(const struct PoolHeader *ph);

/* fillchar.c */
VOID SetFillChar(UBYTE newFillChar);
UBYTE NewFillChar(VOID);
BOOL WasStompedUpon(UBYTE *mem, LONG memSize, UBYTE fillChar, UBYTE **stompPtr, LONG *stompSize);

/* filter.c */
VOID ClearFilterList(VOID);
BOOL UpdateFilter(const STRPTR filterString);
BOOL CanAllocate(VOID);
VOID CheckFilter(VOID);

/* installpatches.c */
VOID InstallPatches(VOID);

/* main.c */
int wipeout_main(void);

/* mungmem.c */
VOID MungMem(ULONG *mem, ULONG numBytes, ULONG magic);
VOID BeginMemMung(VOID);

/* monitoring.c */
BOOL CheckStomping(ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE], struct TrackHeader *th);
APTR NewAllocMemAligned(ULONG byteSize, ULONG attributes, ULONG align, ULONG offset, ULONG pc[TRACKEDCALLERSTACKSIZE]);
APTR NewAllocMem(ULONG byteSize, ULONG	attributes, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
VOID NewFreeMem(APTR	memoryBlock, ULONG byteSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
APTR NewAllocVecAligned(ULONG byteSize, ULONG attributes, ULONG align, ULONG offset, ULONG pc[TRACKEDCALLERSTACKSIZE]);
APTR NewAllocVec(ULONG	byteSize, ULONG attributes, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
VOID NewFreeVec(APTR memoryBlock, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]);
APTR NewCreatePool(ULONG memFlags, ULONG puddleSize, ULONG threshSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
VOID NewDeletePool(APTR poolHeader, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
VOID NewFlushPool(APTR poolHeader, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
APTR NewAllocPooledAligned(APTR poolHeader, ULONG memSize, ULONG align, ULONG offset, ULONG pc[TRACKEDCALLERSTACKSIZE]);
APTR NewAllocPooled(APTR poolHeader, ULONG memSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
VOID NewFreePooled(APTR	poolHeader, APTR memoryBlock, ULONG	memSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
APTR NewAllocVecPooled(APTR poolHeader, ULONG memSize, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
VOID NewFreeVecPooled(APTR	poolHeader, APTR memoryBlock, ULONG *stackFrame, ULONG pc[TRACKEDCALLERSTACKSIZE]); 

/* nametag.c */
LONG GetNameTagLen(ULONG pc[TRACKEDCALLERSTACKSIZE]);
VOID FillNameTag(APTR mem, LONG size);
BOOL GetNameTagData(const APTR mem, LONG size, STRPTR *programNamePtr, ULONG *segmentPtr, ULONG *offsetPtr, STRPTR *taskNamePtr);

/* pools.c */
VOID SetupPoolList(VOID);
VOID HoldPoolSemaphore(struct PoolHeader *ph, ULONG pc[TRACKEDCALLERSTACKSIZE]);
VOID ReleasePoolSemaphore(struct PoolHeader *ph);
BOOL PuddleIsInPool(struct PoolHeader *ph, APTR mem);
VOID RemovePuddle(struct TrackHeader *th);
VOID AddPuddle(struct PoolHeader *ph, struct TrackHeader *th);
struct PoolHeader *FindPoolHeader(APTR poolHeader);
BOOL DeletePoolHeader(ULONG *stackFrame, struct PoolHeader *ph, ULONG pc[TRACKEDCALLERSTACKSIZE]);
BOOL FlushPoolHeader(ULONG *stackFrame, struct PoolHeader *ph, ULONG pc[TRACKEDCALLERSTACKSIZE]);
struct PoolHeader *CreatePoolHeader(ULONG attributes, ULONG puddleSize, ULONG threshSize, ULONG pc[TRACKEDCALLERSTACKSIZE]); 
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
CONST_STRPTR GetTaskTypeName(LONG type);
LONG GetTaskType(struct Task *whichTask);
BOOL GetTaskName(struct Task *whichTask, STRPTR name, LONG nameLen);

/* timer.c */
VOID StopTimer(VOID);
VOID StartTimer(ULONG seconds, ULONG micros);
VOID DeleteTimer(VOID);
BYTE CreateTimer(VOID);

/* tools.c */
#if defined(__MORPHOS__)
#define StrcpyN(len, to, from) stccpy(to, from, len)
#define DecodeNumber(str, ptr) StrToLong((STRPTR)str, ptr)
#else
VOID StrcpyN(LONG MaxLen, STRPTR To, const STRPTR From);
BOOL VSPrintfN(LONG MaxLen, STRPTR Buffer, const STRPTR FormatString, const va_list VarArgs);
BOOL SPrintfN(LONG MaxLen, STRPTR Buffer, const STRPTR FormatString, ...);
BOOL DecodeNumber(const STRPTR number, LONG *valuePtr);
#endif
VOID ConvertTimeAndDate(const struct timeval *tv, STRPTR dateTime);
struct Node *FindIName(const struct List *list, const STRPTR name);
BOOL IsTaskStillAround(const struct Task *whichTask);

/* system_headers.c */
