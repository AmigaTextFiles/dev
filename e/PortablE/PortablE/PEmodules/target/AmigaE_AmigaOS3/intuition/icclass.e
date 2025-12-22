/* $VER: icclass.h 38.1 (11.11.1991) */
OPT NATIVE
MODULE 'target/utility/tagitem'
{MODULE 'intuition/icclass'}

CONST ICM_DUMMY	= ($0401)	/* used for nothing		*/
NATIVE {ICM_SETLOOP}	CONST ICM_SETLOOP	= ($0402)	/* set/increment loop counter	*/
NATIVE {ICM_CLEARLOOP}	CONST ICM_CLEARLOOP	= ($0403)	/* clear/decrement loop counter	*/
NATIVE {ICM_CHECKLOOP}	CONST ICM_CHECKLOOP	= ($0404)	/* set/increment loop		*/

/* no parameters for ICM_SETLOOP, ICM_CLEARLOOP, ICM_CHECKLOOP	*/

/* interconnection attributes used by icclass, modelclass, and gadgetclass */
NATIVE {ICA_DUMMY}	CONST ICA_DUMMY	= (TAG_USER+$40000)
NATIVE {ICA_TARGET}	CONST ICA_TARGET	= (ICA_DUMMY + 1)
	/* interconnection target		*/
NATIVE {ICA_MAP}		CONST ICA_MAP		= (ICA_DUMMY + 2)
	/* interconnection map tagitem list	*/
NATIVE {ICSPECIAL_CODE}	CONST ICSPECIAL_CODE	= (ICA_DUMMY + 3)
	/* a "pseudo-attribute", see below.	*/

NATIVE {ICTARGET_IDCMP}	CONST ICTARGET_IDCMP	= (NOT 0)
