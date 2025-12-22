#ifndef PICTP_H
#define PICTP_H

#include "pict.h"

struct rect { uint16_t	top,left,bottom,right; };
typedef struct rect rect;
struct fixed { short i,f; };
typedef struct fixed fixed;

struct PICT {
	int 	w,h;
	int		hres,vres;
	int		mode;
	int		comp;
	int		csize;
	int		ncol;    
	uint8_t	*r,*g,*b;
	FILE	*fp;
	uint8_t	pixtype;
	int		rowbytes;
	uint8_t* buffer;
	int		ctrsz;
	int		pack;
};

struct HeaderOp { 
	short	code;	/*0C00*/
	int		unk1;	/*FFFE0000*/
	fixed	hres,vres;	/* ppp, normal:	00480000 = 72*/
	rect	bbox;
	int		unk2;
};
typedef struct HeaderOp HeaderOp;

struct ClipOp {
	short	code; /* 0001 */
	short	size; /* 000A */
	rect	frame;
};
typedef struct ClipOp ClipOp;

struct Header {
	short		size;
	rect		frame;
	int			version;/*001102FF*/
	HeaderOp	hop;
	ClipOp		clip;
};
typedef struct Header Header;

struct PxDrawInfo {                        
	rect	src,dst;
	short	mode;	/*0040 o 0000*/
};
typedef struct PxDrawInfo PxDrawInfo;

struct PxPackInfo {
	short	rowBytes;
	rect	bounds;
	short	version;  /*0000*/
	short	type;   /*	0000 raw
						0004 packBytes
						0003 packWords*/
	int		size;   /*00000000*/
	fixed	hres,vres;
	short	pixelType,  /*0010*/
			pixelSize,
			cmpCount,
			cmpSize;
	int		planeBytes, /*00000000*/
			pmTable,    /*00000000*/
			pmReserved; /*00000000*/
};
typedef struct PxPackInfo PxPackInfo;

struct Pixmap9AOp {                        
	short	opcode;   /*009A*/
	int		unk;     /*000000FF*/
	PxPackInfo pack;
	PxDrawInfo drawInfo;
};
typedef struct Pixmap9AOp Pixmap9AOp;

typedef struct {
	short	idx;    /* 0 .. 255 */
	short	r,g,b;
}	PxCTableEntry;

typedef struct {
    int		seed;     /*00000000*/
    short	flags;    /*0000*/
    short	size;     /*00ff*/
	/*
	NO SIEMPRE !!!!
    PxCTableEntry  data[256];
	*/
}	PxCTableInfo;

struct Pixmap98Op {
	short	opcode;   /*0098*/
	PxPackInfo		pack;
	PxCTableInfo	ctable;
	PxDrawInfo		drawInfo;
};
typedef struct Pixmap98Op Pixmap98Op;

#if 0
#define EOP 0x00FF

pict_ushort	pict_pack(pict_byte *src,pict_ushort size,pict_byte *dst);
void	pict_write_pixmap_info_98(PICT *pict);
void	pict_write_pixmap_info_9A(PICT *pict);
#endif

#endif /* PICTP_H */
