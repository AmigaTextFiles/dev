
#ifndef _REALTIMELIBRARY_CPP
#define _REALTIMELIBRARY_CPP

#include <libclasses/ExecLibrary.cpp>
#include <libclasses/RealTimeLibrary.h>

RealTimeLibrary::RealTimeLibrary()
{
	Base = ExecLibrary::Default.OpenLibrary("realtime.library", 0);
	if ( Base == 0 )
	{
		throw( Exception("Could not open realtime.library") );
	}
}

RealTimeLibrary::~RealTimeLibrary()
{
	if ( Base != 0 )
	{
		ExecLibrary::Default.CloseLibrary(Base);
	}
}

APTR RealTimeLibrary::LockRealTime(ULONG lockType)
{
	register APTR _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register unsigned int d0 __asm("d0") = lockType;

	__asm volatile ("jsr a6@(-30)"
	: "=r" (_res)
	: "r" (a6), "r" (d0)
	: "d0");
	return (APTR) _res;
}

VOID RealTimeLibrary::UnlockRealTime(APTR lock)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = lock;

	__asm volatile ("jsr a6@(-36)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

struct Player * RealTimeLibrary::CreatePlayerA(CONST struct TagItem * tagList)
{
	register struct Player * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = tagList;

	__asm volatile ("jsr a6@(-42)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Player *) _res;
}

VOID RealTimeLibrary::DeletePlayer(struct Player * player)
{
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = player;

	__asm volatile ("jsr a6@(-48)"
	: 
	: "r" (a6), "r" (a0)
	: "a0");
}

BOOL RealTimeLibrary::SetPlayerAttrsA(struct Player * player, CONST struct TagItem * tagList)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = player;
	register const void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-54)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (BOOL) _res;
}

LONG RealTimeLibrary::SetConductorState(struct Player * player, ULONG state, LONG time)
{
	register LONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = player;
	register unsigned int d0 __asm("d0") = state;
	register int d1 __asm("d1") = time;

	__asm volatile ("jsr a6@(-60)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (LONG) _res;
}

BOOL RealTimeLibrary::ExternalSync(struct Player * player, LONG minTime, LONG maxTime)
{
	register BOOL _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register void * a0 __asm("a0") = player;
	register int d0 __asm("d0") = minTime;
	register int d1 __asm("d1") = maxTime;

	__asm volatile ("jsr a6@(-66)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (d0), "r" (d1)
	: "a0", "d0", "d1");
	return (BOOL) _res;
}

struct Conductor * RealTimeLibrary::NextConductor(CONST struct Conductor * previousConductor)
{
	register struct Conductor * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = previousConductor;

	__asm volatile ("jsr a6@(-72)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Conductor *) _res;
}

struct Conductor * RealTimeLibrary::FindConductor(CONST_STRPTR name)
{
	register struct Conductor * _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const char * a0 __asm("a0") = name;

	__asm volatile ("jsr a6@(-78)"
	: "=r" (_res)
	: "r" (a6), "r" (a0)
	: "a0");
	return (struct Conductor *) _res;
}

ULONG RealTimeLibrary::GetPlayerAttrsA(CONST struct Player * player, CONST struct TagItem * tagList)
{
	register ULONG _res __asm("d0");
	register void * a6 __asm("a6") = Base;
	register const void * a0 __asm("a0") = player;
	register const void * a1 __asm("a1") = tagList;

	__asm volatile ("jsr a6@(-84)"
	: "=r" (_res)
	: "r" (a6), "r" (a0), "r" (a1)
	: "a0", "a1");
	return (ULONG) _res;
}


#endif

