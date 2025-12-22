#ifndef	READPICT_H
#define	READPICT_H
typedef	struct	{
ClientFrame	clientFrame;
UBYTE	foundBMHD;
UBYTE	nColorRegs;
BitMapHeader	bmHdr;
Color4	colorMap[32	];
}	ILBMFrame;
typedef	UBYTE	*UBytePtr;
typedef	UBytePtr	Allocator();
extern	IFFP	ReadPicture();
#endif	READPICT_H
