#ifndef DOS_DATETIME_H
#define DOS_DATETIME_H

#ifndef DOS_DOS_H
MODULE  'dos/dos'
#endif


OBJECT DateTime
 
	  Stamp:DateStamp	
	Format:UBYTE		
	Flags:UBYTE		
	StrDay:PTR TO UBYTE		
	StrDate:PTR TO UBYTE		
	StrTime:PTR TO UBYTE		
ENDOBJECT


#define	LEN_DATSTRING	16

#define DTB_SUBST	0		
#define DTF_SUBST	1
#define DTB_FUTURE	1		
#define DTF_FUTURE	2

#define FORMAT_DOS	0		
#define FORMAT_INT	1		
#define FORMAT_USA	2		
#define FORMAT_CDN	3		
#define FORMAT_MAX	FORMAT_CDN
#endif 
