
#ifndef _THREAD_LIBRARY_INCLUDE_
#define _THREAD_LIBRARY_INCLUDE_

#define TL_TRUE -1
#define TL_FALSE 0

#define TL_D2 1
#define TL_D3 2
#define TL_D4 4
#define TL_D5 8
#define TL_D6 16
#define TL_D7 32
#define TL_A2 64
#define TL_A3 128
#define TL_A4 256
#define TL_A5 512
#define TL_A6 1024

#define TL_AMIGAE TL_A4


typedef LONG BOOL;


extern APTR TLCreate( APTR codeptr, ULONG regmask );
extern VOID TLExit( LONG value );
extern LONG TLJoin( APTR thread );
extern VOID TLDetach( LONG value );
extern BOOL TLCancel( APTR thread );
extern VOID TLSetCancel( BOOL boolean );
extern VOID TLSetPrio( LONG newprio );
extern LONG TLGetPrio( APTR thread );
extern APTR TLMutexInit( VOID );
extern VOID TLMutexDestroy( APTR mutex );
extern VOID TLMutexLock( APTR mutex );
extern BOOL TLMutexTryLock( APTR mutex );
extern VOID TLMutexUnlock( APTR mutex );

#endif
