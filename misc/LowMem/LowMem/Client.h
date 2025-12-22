Article 5402 of comp.sys.amiga:
Path: mcdsun!noao!hao!husc6!cmcl2!rutgers!sri-spam!mordor!lll-tis!ptsfa!lll-lcc!well!perry
From: perry@well.UUCP (Perry S. Kivolowitz)
Newsgroups: comp.sys.amiga
Subject: Low Memory Server From ASDG
Keywords: publicly redistributable shared library
Message-ID: <3286@well.UUCP>
Date: 11 Jun 87 20:57:55 GMT
Lines: 117

As part of the development of FacII - I have written a general purpose
low-memory ``server.'' That is,  an  agent  which will allow arbitrary
processes to register  with  it  their  desire to be notified when the
system is low on memory (actually - whenever an AllocMem fails).

The actual implementation is as a shared library (about 1K) which con-
tains two library calls. These are:

	RegLowMemReq - Register Low Memory Request

	res = RegLowMemReq(PortName , LowMemMsgPtr);
	d0                    a0           a1

	DeRegLowMemReq - Deregister Low Memory Request

	(void) DeRegLowMemReq(PortName);
				 a0

Below is the include file you would use to program with the low-memory
server.  It contains  the conditions under which we are releasing this
software for public redistribution (we retain all rights and allow re-
distribution for non-commercial  purposes  only - commercial redistri-
is granted by licensing agreement whcih says simply that you'll credit
us  somewhere  in  your  documentation and will send us a copy of your
product).

The low-memory server library  is  written completely in assembly lan-
guage and is  quite  small and efficient. It will properly expunge it-
self upon receiving its last closelibrary.

It will accomodate an arbitrarily large  number  of  clients  and will
perform consistency checks  before  actually sending a message to help
prevent the possibility of a message being sent to nowhere.

In the next  few days I will post the library itself, full programming
examples, and full programming documentation.

And by the way - FaccII is coming along VERY well. Many of the comments
made here on usenet have been incorporated into the product.

Cheers, 

Perry S. Kivolowitz - ASDG Incorporated - (201) 563-0529

-----cut here----

/*
**	:ts=8
**
**	low-mem.h
**
**	Copyright 1987 By ASDG Incorporated - All Rights Reserved
**	May  be  freely redistributed for non-commercial purposes 
**	provided this  message  retains intact. Available for use
**	in commercial  products for VERY minimal concession. Con-
**	tact ASDG Incorporated at  (201) 563-0529. Use in commer-
**	cial products without  authorization of ASDG Incorporated
**	shall be viewed as copyright infringement and piracy.
**
**	For commercial applications of the low-memory server ASDG
**	will grant perpetual use licenses provided that:
**		a) We are credited  somewhere  in your documenta-
**		   tion.
**		b) You send us a copy of the application.
**		c) You pay a  very small  administrative fee  not
**		   exceeding $50 if we find it necessary.
**
**	Author:	Perry S. Kivolowitz
*/

/*
**	To use the low-memory server you must allocate one of these
**	structures.  When a  low memory  condition exists, the low-
**	memory server will look for  the message port you specified
**	in the call to RegLowMemReq.  If the message port is found,
**	the low-memory  server will  examine the LoeMemMsg you sup-
**	plied a pointer to in the call to RegLowMemReq.
**
**	If the low-memory server finds something other than LM_CON-
**	DITION_ACKNOWLEDGED, it will not send you a message. There-
**	fore you should initialize this field with that value.
**
**	This scheme  is  used to  ensure that the low-memory server
**	does not reuse the same LowMemMsg (which you supply).  This
**	scheme allows the low-memory server to not wait for a Reply
**	which could be deadly if none was forthcoming from your ap-
**	plication.
*/

struct LowMemMsg {
	struct Message lm_msg;
	long lm_flag;
};


/*
**	values for lm_flag
*/

#define	LM_LOW_MEMORY_CONDITION		0x00000000
#define	LM_CONDITION_ACKNOWLEDGED	(('A'<<24)|('S'<<16)|('D'<<8)|'G')

/*
**	useful defines as in:
**
**	lmptr = (LMPtr) AllocMem(SizeOfLMMsg , 0L);
*/

#define	SizeOfLMMsg	sizeof(struct LowMemMsg)
#define	LMMPtr		struct LowMemMsg *

/*
**	Meaning of Error Returns coming back from RegLowMemReq
*/

#define	LM_BADNAME	-1	/* duplication of port name */
#define	LM_NOMEM	-2	/* memory allocation failed */


