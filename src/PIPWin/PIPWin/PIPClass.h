#ifndef PIPCLASS_H
#define PIPCLASS_H
/*
**	PIPClass.h
**
**	Copyright (C) 1996,97 by Bernardo Innocenti
**
**	'Picture In Picture' class built on top of the "gadgetclass".
**
*/

#define PIPCLASS	"pipclass"
#define PIPVERS		1


Class	*MakePIPClass (void);
void	 FreePIPClass (Class *PIPClass);



/********************/
/* Class Attributes */
/********************/

#define PIP_Dummy			(TAG_USER | ('P'<<16) | ('I'<< 8))

#define PIPA_Screen			(PIP_Dummy+1)
	/* (IGS) Screen to capture data from
	 */

#define PIPA_BitMap			(PIP_Dummy+2)
	/* (IGS) BitMap to capture data from
	 */

#define PIPA_OffX			(PIP_Dummy+3)
#define PIPA_OffY			(PIP_Dummy+4)
	/* (IGSNU) Offsett of the PIP view
	 */

#define PIPA_Width			(PIP_Dummy+5)
#define PIPA_Height			(PIP_Dummy+6)
	/* (GN) Dimensions of the bitmap being captured.
	 */

#define PIPA_DisplayWidth		(PIP_Dummy+7)
#define PIPA_DisplayHeight		(PIP_Dummy+8)
	/* (GN) Dimensions of the PIP display.
	 */

#define PIPA_MoveUp			(PIP_Dummy+9)
#define PIPA_MoveDown		(PIP_Dummy+10)
#define PIPA_MoveLeft		(PIP_Dummy+11)
#define PIPA_MoveRight		(PIP_Dummy+12)
	/* (S) Scroll the display towads a direction
	 */


/*****************/
/* Class Methods */
/*****************/

#define PIPM_REFRESH		(PIP_Dummy+1)
/*
 * Tell the object to update its imagery to reflect any changes
 * in the attached Screen or BitMap.
 */

struct pippRefresh
{
	ULONG	MethodID;
	struct GadgetInfo	*pipp_GInfo;
};

#endif /* !PIPCLASS_H */
