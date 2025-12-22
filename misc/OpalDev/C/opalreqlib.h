#ifndef	OPAL_REQ_LIB_H
#define	OPAL_REQ_LIB_H

#ifndef	EXEC_LIBRARIES_H
#include <exec/libraries.h>
#endif

#ifndef	OPALLIB_H
#include <opal/opallib.h>
#endif


__asm long OpalRequester (register __a0 struct OpalReq *OpalReq);


#ifdef	AZTEC_C
#pragma amicall(OpalReqBase, 0x1e, OpalRequester(A0))
#else
#pragma libcall OpalReqBase OpalRequester 1e 801
#endif


struct OpalReqBase
	{ struct Library OR_Lib;
	  unsigned long	OR_SegList;
	};


struct OpalReq
	{ USHORT TopEdge;		/* Top Line of requester	*/
	  BYTE	 *Hail;			/* Hailing text			*/
	  BYTE	 *File;		 	/* Filename buffer (>=31 chars)	*/
	  BYTE	 *Dir;			/* Directory name.		*/
	  BYTE	 *Extension;		/* File extension to include	*/
	  struct Window	*Window; 	/* Window to display requester.	*/
	  struct OpalScreen *OScrn; 	/* OpalScreen to display req.	*/
	  USHORT *Pointer;		/* Sprite mouse pointer		*/
	  BOOL	 OKHit;			/* TRUE if OK gadget hit 	*/
	  BOOL	 NeedRefresh;		/* OpalScreen needs a refresh	*/
	  long 	 Flags;		 	/* See Below			*/
	  SHORT	 BackPen;		/* Pen # to use for BG rendering*/
	  SHORT	 PrimaryPen;		/* Pen # for primary rendering	*/
	  SHORT	 SecondaryPen;		/* Pen # for secondary rendering*/
        };

	/* Flags */
#define NO_INFO		0x1	/* Exclude files ending in .info  	*/
#define LASTPATH	0x2	/* Use Last selected path as current	*/


#define OR_ERR_OUTOFMEM	1
#define OR_ERR_INUSE	2

#define OPALREQ_HEIGHT	345		/* The height of the Requester	*/

#endif

