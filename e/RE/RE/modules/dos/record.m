#ifndef DOS_RECORD_H
#define DOS_RECORD_H

#ifndef DOS_DOS_H
MODULE  'dos/dos'
#endif

#define REC_EXCLUSIVE		0
#define REC_EXCLUSIVE_IMMED	1
#define REC_SHARED		2
#define REC_SHARED_IMMED	3

OBJECT RecordLock
 
	FH:LONG		
	Offset:LONG	
	Length:LONG	
	Mode:LONG	
ENDOBJECT

#endif 
