/* packer.c -- by Jerry Morrison and Steve Shaw, Electronic Arts. */

#include <exec/types.h>

#define DUMP 0
#define RUN  1

#define MinRun 3
#define MaxRun 128
#define MaxDat 128

/* When used on global definitions, static means private. */
static LONG putSize;
static char buf[256];

#define GetByte()	(*source++)
#define PutByte(c)	{ *dest++ = (c); ++putSize; }

static BYTE * PutDump(BYTE * dest, int nn)
{
	int i;
	
	PutByte(nn-1);
	for (i=0; i<nn; i++) PutByte(buf[i]);
	return(dest);
}

static BYTE * PutRun (BYTE * dest, int nn, int cc)
{
	PutByte(-(nn-1));
	PutByte(cc);
	return(dest);
}


#define OutDump(nn)	dest = PutDump(dest, nn)
#define OutRun(nn,cc)	dest = PutRun(dest, nn, cc)

/* PackRow */

LONG PackRow (BYTE **pSource, BYTE ** pDest, LONG rowSize)
{
	BYTE * source, * dest;
	char c, lastc = '\0';
	BOOL mode = DUMP;
	short nbuf = 0;
	short rstart = 0;
	
	source = *pSource;
	dest = *pDest;
	putSize = 0;
	buf[0] = lastc = c = GetByte();
	nbuf = 1; rowSize--;
	
	for (; rowSize; --rowSize)
	{
		buf[nbuf++] = c = GetByte();
		switch(mode)
		{
			case DUMP:
				/* If the buffer is full, write the length byte, then the data */
				if (nbuf > MaxDat)
				{
					OutDump(nbuf-1);
					buf[0] = c;
					nbuf = 1; rstart = 0;
					break;
				}
				
				if (c == lastc)
				{
					if (nbuf-rstart >= MinRun)
					{
						if (rstart > 0) OutDump(rstart);
						mode = RUN;
					}
					else if (rstart == 0)
					{
						mode = RUN;
					}
				}
				else
				{
					rstart = nbuf - 1;
				}
				break;
				
			case RUN:
				if ((c != lastc)||(nbuf - rstart > MaxRun))
				{
					OutRun(nbuf-1-rstart,lastc);
					buf[0] = c;
					nbuf = 1; rstart = 0;
					mode = DUMP;
				}
				break;
		}
		lastc = c;
	}
	
	switch(mode)
	{
		case DUMP:	OutDump(nbuf); break;
		case RUN:	OutRun(nbuf-rstart, lastc); break;
	}
	
	*pSource = source;
	*pDest = dest;
	return(putSize);
}