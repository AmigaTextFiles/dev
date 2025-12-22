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
**		   exceeding $50.
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
**	lmptr = (LMMPtr) AllocMem(SizeOfLMMsg , 0L);
*/

#define	SizeOfLMMsg	sizeof(struct LowMemMsg)
#define	LMMPtr		struct LowMemMsg *
#define	LMSName		"asdg-low-mem.library"

/*
**	Meaning of Error Returns coming back from RegLowMemReq
*/

#define	LM_BADNAME	-1	/* duplication of port name */
#define	LM_NOMEM	-2	/* memory allocation failed */

