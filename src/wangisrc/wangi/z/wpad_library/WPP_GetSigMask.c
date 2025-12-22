/***************************************************************************
 * WPP_GetSigMask.c
 *
 * wpad.library, Copyright ©1995 Lee Kindness.
 *
 * WPP_GetSigMask()
 */

#include "wpad_global.h"


ULONG __regargs WPP_GetSigMask(struct Pad *pad, ULONG *pmpsig, ULONG *cxsig,
                               ULONG *winsig)
{
	ULONG sig;
	sig = 0;
	
	if( pad->pad_MsgPort )
	{
		*pmpsig = 1 << pad->pad_MsgPort->mp_SigBit;
		sig |= *pmpsig;
	}
	
	if( pad->pad_CxMsgPort )
	{
		*cxsig = 1 << pad->pad_CxMsgPort->mp_SigBit;
		sig |= *cxsig;
	}
	
	if( pad->pad_Window )
	{
		*winsig = 1 << pad->pad_Window->UserPort->mp_SigBit;
		sig |= *winsig;
	}
	return( sig );
}
