OPT NATIVE, PREPROCESS
MODULE 'target/exec/types', 'target/exec/ports'
MODULE 'target/devices/inputevent'
{#include <libraries/commodities.h>}
NATIVE {LIBRARIES_COMMODITIES_H} CONST

/* object creation macros */
NATIVE {CxFilter} PROC	->CxFilter(d)	    CreateCxObj((LONG) CX_FILTER,     (LONG) d,     0)
NATIVE {CxSender} PROC	->CxSender(port,id)   CreateCxObj((LONG) CX_SEND,       (LONG) port,  (LONG) id)
NATIVE {CxSignal} PROC	->CxSignal(task,sig)  CreateCxObj((LONG) CX_SIGNAL,     (LONG) task,  (LONG) sig)
NATIVE {CxTranslate} PROC	->CxTranslate(ie)     CreateCxObj((LONG) CX_TRANSLATE,  (LONG) ie,    0)
NATIVE {CxDebug} PROC	->CxDebug(id)	    CreateCxObj((LONG) CX_DEBUG,      (LONG) id,    0)
NATIVE {CxCustom} PROC	->CxCustom(action,id) CreateCxObj((LONG) CX_CUSTOM,     (LONG)action, (LONG)id)

#define CxFilter(d)          CreateCxObj(CX_FILTER, (d), 0)
#define CxSender(port, id)   CreateCxObj(CX_SEND, (port), (id))
#define CxSignal(task, sig)  CreateCxObj(CX_SIGNAL, (task), (sig))
#define CxTranslate(ie)      CreateCxObj(CX_TRANSLATE, (ie), 0)
#define CxDebug(id)          CreateCxObj(CX_DEBUG, (id), 0)
#define CxCustom(action, id) CreateCxObj(CX_CUSTOM, (action), id)


/*****************************************************************************/


NATIVE {NewBroker} OBJECT newbroker
    {nb_Version}	version	:BYTE   /* Must be set to NB_VERSION */
    {nb_Pri }	reserve1	:BYTE	->hack to fix typed lists
    {nb_Name}	name	:/*STRPTR*/ ARRAY OF CHAR
    {nb_Title}	title	:/*STRPTR*/ ARRAY OF CHAR
    {nb_Descr}	descr	:/*STRPTR*/ ARRAY OF CHAR
    {nb_Unique}	unique	:INT
    {nb_Flags}	flags	:INT
    {nb_Pri}	pri	:BYTE
    {nb_ReservedChannel }	reserve2	:NATIVE {WORD} BYTE	->hack to fix typed lists
    {nb_Port}	port	:PTR TO mp
    {nb_ReservedChannel}	reservedchannel	:INT
ENDOBJECT

/* constant for NewBroker.nb_Version */
NATIVE {NB_VERSION} CONST NB_VERSION = 5	    /* Version of NewBroker structure */

/* Sizes for various buffers */
NATIVE {CBD_NAMELEN}  CONST CBD_NAMELEN  = 24
NATIVE {CBD_TITLELEN} CONST CBD_TITLELEN = 40
NATIVE {CBD_DESCRLEN} CONST CBD_DESCRLEN = 40

/* Flags for NewBroker.nb_Unique */
NATIVE {NBU_DUPLICATE} CONST NBU_DUPLICATE = 0
NATIVE {NBU_UNIQUE}    CONST NBU_UNIQUE    = 1        /* will not allow duplicates	      */
NATIVE {NBU_NOTIFY}    CONST NBU_NOTIFY    = 2        /* sends CXM_UNIQUE to existing broker */

/* Flags for NewBroker.nb_Flags */
NATIVE {COF_SHOW_HIDE} CONST COF_SHOW_HIDE = 4


/*****************************************************************************/


/* Fake data types for system private objects */
NATIVE {CxObj} CONST
TYPE CXOBJ IS NATIVE {CxObj} VALUE
NATIVE {CxMsg} CONST
TYPE CXMSG IS NATIVE {CxMsg} VALUE

/* Pointer to a function returning a LONG */
NATIVE {PFL} CONST


/*****************************************************************************/


/* Commodities object types */
NATIVE {CX_INVALID}	CONST CX_INVALID	= 0     /* not a valid object (probably null) */
NATIVE {CX_FILTER}	CONST CX_FILTER	= 1     /* input event messages only	    */
NATIVE {CX_TYPEFILTER}	CONST CX_TYPEFILTER	= 2     /* obsolete, do not use		    */
NATIVE {CX_SEND}	CONST CX_SEND	= 3     /* sends a message		    */
NATIVE {CX_SIGNAL}	CONST CX_SIGNAL	= 4     /* sends a signal		    */
NATIVE {CX_TRANSLATE}	CONST CX_TRANSLATE	= 5     /* translates input event into chain  */
NATIVE {CX_BROKER}	CONST CX_BROKER	= 6     /* application representative	    */
NATIVE {CX_DEBUG}	CONST CX_DEBUG	= 7     /* dumps info to serial port	    */
NATIVE {CX_CUSTOM}	CONST CX_CUSTOM	= 8     /* application provides function	    */
NATIVE {CX_ZERO}	CONST CX_ZERO	= 9     /* system terminator node	    */


/*****************************************************************************/


/* Commodities message types */
NATIVE {CXM_IEVENT}  CONST CXM_IEVENT  = $20
NATIVE {CXM_COMMAND} CONST CXM_COMMAND = $40

/* Only CXM_IEVENT messages are passed through the input network. Other types
 * of messages are sent to an optional port in your broker. This means that
 * you must test the message type in your message handling, if input messages
 * and command messages come to the same port.
 *
 * CXM_IEVENT: Messages of this type rattle around the Commodities input
 *	       network. They are sent to you by a Sender object, and passed
 *	       to you as a synchronous function call by a Custom object.
 *
 *	       The message port or function entry point is stored in the
 *	       object, and the ID field of the message will be set to what
 *	       you arrange issuing object.
 *
 *	       The data section of the message will point to the input event
 *	       triggering the message.
 *
 * CXM_COMMAND: These messages are sent to a port attached to your Broker.
 *		They are sent to you when the controller program wants your
 *		program to do something. The ID value identifies the command.
 */

/* ID values associated with a message of type CXM_COMMAND */
NATIVE {CXCMD_DISABLE}	CONST CXCMD_DISABLE	= (15)  /* please disable yourself	 */
NATIVE {CXCMD_ENABLE}	CONST CXCMD_ENABLE	= (17)  /* please enable yourself	 */
NATIVE {CXCMD_APPEAR}	CONST CXCMD_APPEAR	= (19)  /* open your window, if you can	 */
NATIVE {CXCMD_DISAPPEAR} CONST CXCMD_DISAPPEAR = (21)  /* go dormant			 */
NATIVE {CXCMD_KILL}	CONST CXCMD_KILL	= (23)  /* go away for good		 */
NATIVE {CXCMD_LIST_CHG}	CONST CXCMD_LIST_CHG	= (27)  /* Someone changed the broker list */
NATIVE {CXCMD_UNIQUE}	CONST CXCMD_UNIQUE	= (25)  /* someone tried to create a broker
			       * with your name. Suggest you appear.
			       */


/*****************************************************************************/


NATIVE {InputXpression} OBJECT inputxpression
    {ix_Version}	version	:UBYTE	  /* must be set to IX_VERSION */
    {ix_Class}	class	:UBYTE	  /* class must match exactly  */

    {ix_Code}	code	:UINT	  /* Bits that we want */
    {ix_CodeMask}	codemask	:UINT	  /* Set bits here to indicate which bits in ix_Code
			   * are don't care bits.
			   */
    {ix_Qualifier}	qualifier	:UINT   /* Bits that we want */
    {ix_QualMask}	qualmask	:UINT	  /* Set bits here to indicate which bits in
			   * ix_Qualifier are don't care bits
			   */
    {ix_QualSame}	qualsame	:UINT	  /* synonyms in qualifier */
ENDOBJECT
NATIVE {IX} CONST

/* constant for InputXpression.ix_Version */
NATIVE {IX_VERSION} CONST IX_VERSION = 2

/* constants for InputXpression.ix_QualSame */
NATIVE {IXSYM_SHIFT} CONST IXSYM_SHIFT = 1	/* left- and right- shift are equivalent     */
NATIVE {IXSYM_CAPS}  CONST IXSYM_CAPS  = 2	/* either shift or caps lock are equivalent  */
NATIVE {IXSYM_ALT}   CONST IXSYM_ALT   = 4	/* left- and right- alt are equivalent	     */

NATIVE {IXSYM_SHIFTMASK} CONST IXSYM_SHIFTMASK = (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
NATIVE {IXSYM_CAPSMASK}	CONST IXSYM_CAPSMASK	= (IXSYM_SHIFTMASK OR IEQUALIFIER_CAPSLOCK)
NATIVE {IXSYM_ALTMASK}	CONST IXSYM_ALTMASK	= (IEQUALIFIER_LALT OR IEQUALIFIER_RALT)

/* constant for InputXpression.ix_QualMask */
NATIVE {IX_NORMALQUALS}	CONST IX_NORMALQUALS	= $7FFF	 /* avoid RELATIVEMOUSE */

/* matches nothing */
NATIVE {NULL_IX} CONST	->NULL_IX(ix)   ((ix)->ix_Class == IECLASS_NULL)
#define NULL_IX(ix) Null_ix(ix)
PROC Null_ix(ix:PTR TO inputxpression) IS ix.class=IECLASS_NULL


/*****************************************************************************/


/* Error returns from CxBroker() */
NATIVE {CBERR_OK}      CONST CBERR_OK      = 0  /* No error				   */
NATIVE {CBERR_SYSERR}  CONST CBERR_SYSERR  = 1  /* System error, no memory, etc	   */
NATIVE {CBERR_DUP}     CONST CBERR_DUP     = 2  /* uniqueness violation		   */
NATIVE {CBERR_VERSION} CONST CBERR_VERSION = 3  /* didn't understand NewBroker.nb_Version */


/*****************************************************************************/


/* Return values from CxObjError() */
NATIVE {COERR_ISNULL}	 CONST COERR_ISNULL	 = 1   /* you called CxObjError(NULL)	   */
NATIVE {COERR_NULLATTACH} CONST COERR_NULLATTACH = 2   /* someone attached NULL to my list   */
NATIVE {COERR_BADFILTER}  CONST COERR_BADFILTER  = 4   /* a bad filter description was given */
NATIVE {COERR_BADTYPE}	 CONST COERR_BADTYPE	 = 8   /* unmatched type-specific operation  */
