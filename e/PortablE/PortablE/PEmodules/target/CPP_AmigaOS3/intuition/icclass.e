/* $VER: icclass.h 38.1 (11.11.1991) */
OPT NATIVE
MODULE 'target/utility/tagitem'
{#include <intuition/icclass.h>}
NATIVE {INTUITION_ICCLASS_H} CONST

NATIVE {ICM_Dummy}	CONST ICM_DUMMY	= ($0401)	/* used for nothing		*/
NATIVE {ICM_SETLOOP}	CONST ICM_SETLOOP	= ($0402)	/* set/increment loop counter	*/
NATIVE {ICM_CLEARLOOP}	CONST ICM_CLEARLOOP	= ($0403)	/* clear/decrement loop counter	*/
NATIVE {ICM_CHECKLOOP}	CONST ICM_CHECKLOOP	= ($0404)	/* set/increment loop		*/

/* no parameters for ICM_SETLOOP, ICM_CLEARLOOP, ICM_CHECKLOOP	*/

/* interconnection attributes used by icclass, modelclass, and gadgetclass */
NATIVE {ICA_Dummy}	CONST ICA_DUMMY	= (TAG_USER+$40000)
NATIVE {ICA_TARGET}	CONST ICA_TARGET	= (ICA_DUMMY + 1)
	/* interconnection target		*/
NATIVE {ICA_MAP}		CONST ICA_MAP		= (ICA_DUMMY + 2)
	/* interconnection map tagitem list	*/
NATIVE {ICSPECIAL_CODE}	CONST ICSPECIAL_CODE	= (ICA_DUMMY + 3)
	/* a "pseudo-attribute", see below.	*/

/* Normally, the value for ICA_TARGET is some object pointer,
 * but if you specify the special value ICTARGET_IDCMP, notification
 * will be send as an IDCMP_IDCMPUPDATE message to the appropriate window's
 * IDCMP port.	See the definition of IDCMP_IDCMPUPDATE.
 *
 * When you specify ICTARGET_IDCMP for ICA_TARGET, the map you
 * specify will be applied to derive the attribute list that is
 * sent with the IDCMP_IDCMPUPDATE message.  If you specify a map list
 * which results in the attribute tag id ICSPECIAL_CODE, the
 * lower sixteen bits of the corresponding ti_Data value will
 * be copied into the Code field of the IDCMP_IDCMPUPDATE IntuiMessage.
 */
NATIVE {ICTARGET_IDCMP}	CONST ICTARGET_IDCMP	= (NOT 0)
