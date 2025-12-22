#ifndef	PROTO_ARP_H
#define	PROTO_ARP_H	1

/*
 ************************************************************************
 *	The arp copies of the dos.library calls...			*
 ************************************************************************
 */

/* Only include these if you can use ARP.library without dos.library... */
#ifdef	DO_ARP_COPIES
#pragma	libcall	ArpBase	Open			001E	2102
#pragma	libcall	ArpBase	Close			0024	101
#pragma	libcall	ArpBase	Read			002A	32103
#pragma	libcall	ArpBase	Write			0030	32103
#pragma	libcall	ArpBase	Input			0036	00
#pragma	libcall	ArpBase	Output			003C	00
#pragma	libcall	ArpBase	Seek			0042	32103
#pragma	libcall	ArpBase	DeleteFile		0048	101
#pragma	libcall	ArpBase	Rename			004E	2102
#pragma	libcall	ArpBase	Lock			0054	2102
#pragma	libcall	ArpBase	UnLock			005A	101
#pragma	libcall	ArpBase	DupLock			0060	101
#pragma	libcall	ArpBase	Examine			0066	2102
#pragma	libcall	ArpBase	ExNext			006C	2102
#pragma	libcall	ArpBase	Info			0072	2102
#pragma	libcall	ArpBase	CreateDir		0078	101
#pragma	libcall	ArpBase	CurrentDir		007E	101
#pragma	libcall	ArpBase	IoErr			0084	00
#pragma	libcall	ArpBase	CreateProc		008A	432104
#pragma	libcall	ArpBase	Exit			0090	101
#pragma	libcall	ArpBase	LoadSeg			0096	101
#pragma	libcall	ArpBase	UnLoadSeg		009C	101
#pragma	libcall	ArpBase	DeviceProc		00AE	101
#pragma	libcall	ArpBase	SetComment		00B4	2102
#pragma	libcall	ArpBase	SetProtection		00BA	2102
#pragma	libcall	ArpBase	DateStamp		00C0	101
#pragma	libcall	ArpBase	Delay			00C6	101
#pragma	libcall	ArpBase	WaitForChar		00CC	2102
#pragma	libcall	ArpBase	ParentDir		00D2	101
#pragma	libcall	ArpBase	IsInteractive		00D8	101
#pragma	libcall	ArpBase	Execute			00DE	32103
#endif	DO_ARP_COPIES

/*
 ************************************************************************
 *	Stuff only in arp.library					*
 ************************************************************************
 */
/*	libcall	ArpBase	Printf			00E4	9802	This does not work without glue */
/*	libcall	ArpBase	FPrintf			00EA	98003	This does not work without glue */
#pragma	libcall	ArpBase	Puts			00F0	901
#pragma	libcall	ArpBase	ReadLine		00F6	801
#pragma	libcall	ArpBase	GADS			00FC	BA90805
#pragma	libcall	ArpBase	Atol			0102	801
#pragma	libcall	ArpBase	EscapeString		0108	801
#pragma	libcall	ArpBase	CheckAbort		010E	901
#pragma	libcall	ArpBase	CheckBreak		0114	9102
#pragma	libcall	ArpBase	Getenv			011A	09803
#pragma	libcall	ArpBase	Setenv			0120	9802
#pragma	libcall	ArpBase	FileRequest		0126	801
#pragma	libcall	ArpBase	CloseWindowSafely	012C	9802
#pragma	libcall	ArpBase	CreatePort		0132	0802
#pragma	libcall	ArpBase	DeletePort		0138	901
#pragma	libcall	ArpBase	SendPacket		013E	98003
#pragma	libcall	ArpBase	InitStdPacket		0144	A98004
#pragma	libcall	ArpBase	PathName		014A	18003
#pragma	libcall	ArpBase	Assign			0150	9802
#pragma	libcall	ArpBase	DosAllocMem		0156	001
#pragma	libcall	ArpBase	DosFreeMem		015C	901
#pragma	libcall	ArpBase	BtoCStr			0162	10803
#pragma	libcall	ArpBase	CtoBStr			0168	10803
#pragma	libcall	ArpBase	GetDevInfo		016E	A01
#pragma	libcall	ArpBase	FreeTaskResList		0174	00
#pragma	libcall	ArpBase	ArpExit			017A	2002
#pragma	libcall	ArpBase	ArpAlloc		0180	001
/*	libcall	ArpBase	ArpAllocMem		0186	1002	Secondary result - IoErr() */
/*	libcall	ArpBase	ArpOpen			018C	2102	Secondary result - IoErr() */
/*	libcall	ArpBase	ArpDupLock		0192	101	Secondary result - IoErr() */
/*	libcall	ArpBase	ArpLock			0198	2102	Secondary result - IoErr() */
/*	libcall	ArpBase	RListAlloc		019E	0802	Secondary result - IoErr() */
#pragma	libcall	ArpBase	FindCLI			01A4	001
#pragma	libcall	ArpBase	QSort			01AA	910804

#pragma	libcall	ArpBase	PatternMatch		01B0	9802
#pragma	libcall	ArpBase	FindFirst		01B6	8002
#pragma	libcall	ArpBase	FindNext		01BC	801
#pragma	libcall	ArpBase	FreeAnchorChain		01C2	801

#pragma	libcall	ArpBase	CompareLock		01C8	1002

#pragma	libcall	ArpBase	FindTaskResList		01CE	00
#pragma	libcall	ArpBase	CreateTaskResList	01D4	00
#pragma	libcall	ArpBase	FreeResList		01DA	00
#pragma	libcall	ArpBase	FreeTrackedItem		01E0	901
/*	libcall	ArpBase	GetTracker		01E6	90	Stores the ID in the tracker */

#pragma	libcall	ArpBase	GetAccess		01EC	901
#pragma	libcall	ArpBase	FreeAccess		01F2	901

#pragma	libcall	ArpBase	FreeDAList		01F8	901
#pragma	libcall	ArpBase	AddDANode		01FE	109804
#pragma	libcall	ArpBase	AddDADevs		0204	0802

#pragma	libcall	ArpBase	Strcmp			020A	9802
#pragma	libcall	ArpBase	Strncmp			0210	09803
#pragma	libcall	ArpBase	Toupper			0216	001
#pragma	libcall	ArpBase	SyncRun			021C	109804

/*
 ************************************************************************
 *	Added V32 of arp.library					*
 *	Note that SpawnShell is ASyncRun but was added at V39 of arp...	*
 ************************************************************************
 */
#pragma	libcall	ArpBase	ASyncRun		0222	A9803
#pragma	libcall	ArpBase	SpawnShell		0222	A9803
#pragma	libcall	ArpBase	LoadPrg			0228	101
#pragma	libcall	ArpBase	PreParse		022E	9802

/*
 ************************************************************************
 *	Added V33 of arp.library					*
 ************************************************************************
 */
#pragma	libcall	ArpBase	StamptoStr		0234	801
#pragma	libcall	ArpBase	StrtoStamp		023A	801

#pragma	libcall	ArpBase	ObtainResidentPrg	0240	801
#pragma	libcall	ArpBase	AddResidentPrg		0246	8102
#pragma	libcall	ArpBase	RemResidentPrg		024C	801
#pragma	libcall	ArpBase	UnLoadPrg		0252	101
#pragma	libcall	ArpBase	LMult			0258	1002
#pragma	libcall	ArpBase	LDiv			025E	1002
#pragma	libcall	ArpBase	LMod			0264	1002

#pragma	libcall	ArpBase	CheckSumPrg		026A	101
#pragma	libcall	ArpBase	TackOn			0270	9802
#pragma	libcall	ArpBase	BaseName		0276	801
#pragma	libcall	ArpBase	ReleaseResidentPrg	027C	101

/*
 ************************************************************************
 *	Added V36 of arp.library					*
 ************************************************************************
 */
/*	libcall	ArpBase	SPrintf			0282	98003	This does not work without glue */
#pragma	libcall	ArpBase	GetKeywordIndex		0288	9802
/*	libcall	ArpBase	ArpOpenLibrary		028E	0902	Secondary result - IoErr() */
#pragma	libcall	ArpBase	ArpAllocFreq		0294	00

#endif	PROTO_ARP_H
