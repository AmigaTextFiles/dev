#ifndef  CLIB_RTRACK_PROTOS_H
#define  CLIB_RTRACK_PROTOS_H

/*
**	$VER: rtrack_protos.h 0.1 (15.8.95)
**	RTrack Release 0.1
**
**	C prototypes. For use with 32 bit integers only.
**
**	(C) Copyright 1995 Proxity Softworks
**	    All Rights Reserved
*/

/* rkAddLib.c */
void KillAddLib ( APTR data );
void rkAddLibrary ( struct Library *library );

/* rkAddMemHandler.c */
void KillAddMemHandler ( APTR data );
void rkAddMemHandler ( struct Interrupt *mh );

/* rkAddPort.c */
void KillAddPort ( APTR data );
void rkAddPort ( struct MsgPort *port );

/* rkLock.c */
void KillLock ( APTR data );
BPTR rkLock ( STRPTR name , LONG accessMode );

/* rkOpen.c */
void KillOpen ( APTR data );
BPTR rkOpen ( STRPTR name , LONG mode );

/* rkOpenDev.c */
void KillOpenDev ( APTR data );
BYTE rkOpenDevice ( STRPTR devName , ULONG unitNumber , struct IORequest *iORequest , ULONG flags );

/* rkRemLib.c */
void rkRemLib ( struct Library *library );

/* rkAddDev.c */
void KillAddDev ( APTR data );
void rkAddDevice ( struct Device *dev );

/* rkFreeArgs.c */
void rkFreeArgs ( struct RDArgs *rdargs );

/* rkFreeDosObj.c */
void rkFreeDosObj ( APTR dosObj );

/* rkRemPort.c */
void rkRemPort ( struct MsgPort *port );

/* rkAllocAny.c */
void KillAllocAny ( APTR data );
APTR rkAllocAny ( ULONG byteSize );

/* rkAllocDosObj.c */
void KillAllocDosObj ( struct RTrackDosObj *data );
APTR rkAllocDosObject ( ULONG type , struct TagItem *tags );

/* rkAddRes.c */
void KillAddRes ( APTR data );
void rkAddResource ( APTR res );

/* rkAllocSig.c */
void KillAllocSig ( APTR data );
BYTE rkAllocSignal ( BYTE signalNum );

/* rkAllocVec.c */
void KillAllocVec ( APTR data );
APTR rkAllocVec ( ULONG byteSize , ULONG attributes );

/* rkRemMemHandler.c */
void rkRemMemHandler ( struct Interrupt *mh );

/* rkClose.c */
void rkClose ( BPTR file );

/* rkCurrentDir.c */
void KillCurrentDir ( APTR data );
BPTR rkCurrentDir ( BPTR lock );

/* rkDump.c */
void rkDump ( void );

/* rkCloseDev.c */
void rkCloseDev ( struct IORequest *iORequest );

/* rkCloseLib.c */
void rkCloseLibrary ( struct Library *library );

/* rkFreeVec.c */
void rkFreeVec ( APTR memory );

/* rkFreeAny.c */
void rkFreeAny ( APTR memory );

/* rkFreeSig.c */
void rkFreeSignal ( BYTE signalNum );

/* rkOpenLib.c */
void KillOpenLib ( APTR data );
struct Library *rkOpenLibrary ( STRPTR libName , ULONG version );

/* rkReadArgs.c */
void KillReadArgs ( APTR data );
struct RDArgs *rkReadArgs ( STRPTR arg_template , LONG *array , struct RDArgs *args );

/* rkRemDev.c */
void rkRemDevice ( struct Device *dev );

/* rkRemRes.c */
void rkRemResource ( APTR res );

/* rkUnlock.c */
void rkUnlock ( BPTR lock );

#endif	/* CLIB_RTRACK_PROTOS_H */
