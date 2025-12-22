
#ifndef _POWERPCLIBRARY_H
#define _POWERPCLIBRARY_H

#include <utility/tagitem.h>
#include <devices/timer.h>
#include <powerpc/portsPPC.h>
#include <powerpc/tasksPPC.h>
#include <powerpc/semaphoresPPC.h>
// #include <pragma/powerpc_lib.h>

class PowerPCLibrary
{
public:
	PowerPCLibrary();
	~PowerPCLibrary();

	static class PowerPCLibrary Default;

	ULONG RunPPC(struct PPCArgs * PPStruct);
	ULONG WaitForPPC(struct PPCArgs * PPStruct);
	ULONG GetCPU();
	VOID PowerDebugMode(ULONG debuglevel);
	APTR AllocVec32(ULONG memsize, ULONG attributes);
	VOID FreeVec32(APTR memblock);
	VOID SPrintF68K(STRPTR Formatstring, APTR values);
	struct Message * AllocXMsg(ULONG bodysize, struct MsgPort * replyport);
	VOID FreeXMsg(struct Message * message);
	VOID PutXMsg(struct MsgPortPPC, struct Message * message);
	ULONG GetPPCState();
	void SetCache68K(ULONG flags, void * addr, ULONG length);
	struct TaskPPC * CreatePPCTask(struct TagItem * taglist);
	void CausePPCInterrupt();
	ULONG Run68K(struct PPCArgs * PPStruct);
	ULONG WaitFor68K(struct PPCArgs * PPStruct);
	VOID SPrintF(STRPTR Formatstring, APTR Values);
	APTR AllocVecPPC(ULONG size, ULONG flags, ULONG align);
	LONG FreeVecPPC(APTR memblock);
	struct TaskPPC * CreateTaskPPC(struct TagItem * taglist);
	VOID DeleteTaskPPC(struct TaskPPC * PPCtask);
	struct TaskPPC * FindTaskPPC(STRPTR name);
	LONG InitSemaphorePPC(struct SignalSemaphorePPC * SemaphorePPC);
	VOID FreeSemaphorePPC(struct SignalSemaphorePPC * SemaphorePPC);
	VOID AddSemaphorePPC(struct SignalSemaphorePPC * SemaphorePPC);
	VOID RemSemaphorePPC(struct SignalSemaphorePPC * SemaphorePPC);
	void ObtainSemaphoreP(int SemaphorePPC);
	void AttemptSemaphore(int SemaphorePPC);
	void ReleaseSemaphore(int SemaphorePPC);
	struct SignalSemaphorePPC * FindSemaphorePPC(STRPTR name);
	VOID InsertPPC(struct List * list, struct Node * node, struct Node * pred);
	VOID AddHeadPPC(struct List * list, struct Node * node);
	VOID AddTailPPC(struct List * list, struct Node * node);
	VOID RemovePPC(struct Node * node);
	struct Node * RemHeadPPC(struct List * list);
	struct Node * RemTailPPC(struct Node * list);
	VOID EnqueuePPC(struct List * list, struct Node * node);
	struct Node * FindNamePPC(struct List * list, STRPTR name);
	struct TagItem * FindTagItemPPC(ULONG value, struct TagItem * taglist);
	ULONG GetTagDataPPC(ULONG value, ULONG default, struct TagItem * taglist);
	struct TagItem * NextTagItemPPC(struct TagItem ** tagitem);
	LONG AllocSignalPPC(LONG signum);
	VOID FreeSignalPPC(LONG signum);
	ULONG SetSignalPPC(ULONG signals, ULONG mask);
	VOID SignalPPC(struct TaskPPC * task, ULONG signals);
	ULONG WaitPPC(ULONG signals);
	LONG SetTaskPriPPC(struct TaskPPC * task, LONG pri);
	VOID Signal68K(struct Task * task, ULONG signals);
	VOID SetCache(ULONG flags, APTR start, ULONG length);
	APTR SetExcHandler(struct TagItem * taglist);
	VOID RemExcHandler(APTR xlock);
	ULONG Super();
	VOID User(ULONG key);
	ULONG SetHardware(ULONG flags, APTR param);
	VOID ModifyFPExc(ULONG fpflags);
	ULONG WaitTime(ULONG signals, ULONG time);
	struct TaskPtr * LockTaskList(int node);
	VOID UnLockTaskList();
	VOID SetExcMMU();
	VOID ClearExcMMU();
	VOID ChangeMMU(ULONG mode);
	VOID GetInfo(struct TagItem * taglist);
	struct MsgPortPPC * CreateMsgPortPPC(int port);
	VOID DeleteMsgPortPPC(struct MsgPortPPC * port);
	VOID AddPortPPC(struct MsgPortPPC * port);
	VOID RemPortPPC(struct MsgPortPPC * port);
	struct MsgPortPPC * FindPortPPC(STRPTR port);
	struct Message * WaitPortPPC(struct MsgPortPPC * port);
	VOID PutMsgPPC(struct MsgPortPPC * port, struct Message * message);
	struct Message * GetMsgPPC(struct MsgPortPPC * port);
	VOID ReplyMsgPPC(struct Message * message);
	VOID FreeAllMem();
	VOID CopyMemPPC(APTR source, APTR dest, ULONG size);
	struct Message * AllocXMsgPPC(ULONG length, struct MsgPortPPC * port);
	VOID FreeXMsgPPC(struct Message * message);
	VOID PutXMsgPPC(struct MsgPort * port, struct Message * message);
	VOID GetSysTimePPC(struct timeval * timeval);
	VOID AddTimePPC(struct timeval * dest, struct timeval * source);
	VOID SubTimePPC(struct timeval * dest, struct timeval * source);
	LONG CmpTimePPC(struct timeval * dest, struct timeval * source);
	struct MsgPortPPC * SetReplyPortPPC(struct Message * message, struct MsgPortPPC * port);
	ULONG SnoopTask(struct TagItem * taglist);
	VOID EndSnoopTask(ULONG id);
	VOID GetHALInfo(struct TagItem * taglist);
	VOID SetScheduling(struct TagItem * taglist);
	struct TaskPPC * FindTaskByID(LONG id);
	LONG SetNiceValue(struct TaskPPC * task, LONG nice);
	LONG TrySemaphorePPC(struct SignalSemaphorePPC * SemaphorePPC, ULONG timeout);

private:
	struct Library *Base;
};

PowerPCLibrary PowerPCLibrary::Default;

#endif

