OPT NATIVE, PREPROCESS
MODULE 'target/exec/ports', 'target/exec/types'
MODULE 'target/devices/inputevent', 'target/exec/nodes', 'target/exec/tasks'
{#include <libraries/commodities.h>}
NATIVE {LIBRARIES_COMMODITIES_H} CONST

NATIVE {CxObj} CONST
TYPE CXOBJ IS NATIVE {CxObj} VALUE
NATIVE {CxMsg} CONST
TYPE CXMSG IS NATIVE {CxMsg} VALUE

NATIVE {PFL} CONST

NATIVE {NewBroker} OBJECT newbroker
    {nb_Version}	version	:BYTE         /* see below */
    {nb_Pri }	reserve1	:BYTE	->hack to fix typed lists
    {nb_Name}	name	:CONST_STRPTR
    {nb_Title}	title	:CONST_STRPTR
    {nb_Descr}	descr	:CONST_STRPTR
    {nb_Unique}	unique	:INT          /* see below */
    {nb_Flags}	flags	:INT           /* see below */
    {nb_Pri}	pri	:BYTE
    {nb_ReservedChannel }	reserve2	:NATIVE {WORD} BYTE	->hack to fix typed lists
    {nb_Port}	port	:PTR TO mp
    {nb_ReservedChannel}	reservedchannel	:INT
ENDOBJECT

/* nb_Version */
NATIVE {NB_VERSION} CONST NB_VERSION = 5

/* nb_Unique */
NATIVE {NBU_DUPLICATE} CONST NBU_DUPLICATE = 0
NATIVE {NBU_UNIQUE}    CONST NBU_UNIQUE    = $1
NATIVE {NBU_NOTIFY}    CONST NBU_NOTIFY    = $2

/* nb_Flags */
NATIVE {COF_SHOW_HIDE} CONST COF_SHOW_HIDE = $4
NATIVE {COF_ACTIVE}    CONST COF_ACTIVE    = $2	/* Object is active - undocumented in AmigaOS */

NATIVE {CBD_NAMELEN}  CONST CBD_NAMELEN  = 24 /* length of nb_Name */
NATIVE {CBD_TITLELEN} CONST CBD_TITLELEN = 40 /* length of nb_Title */
NATIVE {CBD_DESCRLEN} CONST CBD_DESCRLEN = 40 /* length of nb_Descr */

/* return values of CxBroker() */
NATIVE {CBERR_OK}      CONST CBERR_OK      = 0
NATIVE {CBERR_SYSERR}  CONST CBERR_SYSERR  = 1
NATIVE {CBERR_DUP}     CONST CBERR_DUP     = 2
NATIVE {CBERR_VERSION} CONST CBERR_VERSION = 3

/* return values of CxObjError() */
NATIVE {COERR_ISNULL}     CONST COERR_ISNULL     = $1
NATIVE {COERR_NULLATTACH} CONST COERR_NULLATTACH = $2
NATIVE {COERR_BADFILTER}  CONST COERR_BADFILTER  = $4
NATIVE {COERR_BADTYPE}    CONST COERR_BADTYPE    = $8

NATIVE {CXM_IEVENT}  CONST CXM_IEVENT  = $20
NATIVE {CXM_COMMAND} CONST CXM_COMMAND = $40

NATIVE {CXCMD_DISABLE}   CONST CXCMD_DISABLE   = (15)
NATIVE {CXCMD_ENABLE}    CONST CXCMD_ENABLE    = (17)
NATIVE {CXCMD_APPEAR}    CONST CXCMD_APPEAR    = (19)
NATIVE {CXCMD_DISAPPEAR} CONST CXCMD_DISAPPEAR = (21)
NATIVE {CXCMD_KILL}      CONST CXCMD_KILL      = (23)
NATIVE {CXCMD_UNIQUE}    CONST CXCMD_UNIQUE    = (25)
NATIVE {CXCMD_LIST_CHG}  CONST CXCMD_LIST_CHG  = (27)

NATIVE {CX_INVALID}    CONST CX_INVALID    = 0
NATIVE {CX_FILTER}     CONST CX_FILTER     = 1
NATIVE {CX_TYPEFILTER} CONST CX_TYPEFILTER = 2
NATIVE {CX_SEND}       CONST CX_SEND       = 3
NATIVE {CX_SIGNAL}     CONST CX_SIGNAL     = 4
NATIVE {CX_TRANSLATE}  CONST CX_TRANSLATE  = 5
NATIVE {CX_BROKER}     CONST CX_BROKER     = 6
NATIVE {CX_DEBUG}      CONST CX_DEBUG      = 7
NATIVE {CX_CUSTOM}     CONST CX_CUSTOM     = 8
NATIVE {CX_ZERO}       CONST CX_ZERO       = 9

/* Macros */
NATIVE {CxFilter} PROC	->CxFilter(d)         CreateCxObj((LONG)CX_FILTER,    (IPTR)(d),      0L)
NATIVE {CxSender} PROC	->CxSender(port,id)   CreateCxObj((LONG)CX_SEND,      (IPTR)(port),   (LONG)(id))
NATIVE {CxSignal} PROC	->CxSignal(task,sig)  CreateCxObj((LONG)CX_SIGNAL,    (IPTR)(task),   (LONG)(sig))
NATIVE {CxTranslate} PROC	->CxTranslate(ie)     CreateCxObj((LONG)CX_TRANSLATE, (IPTR)(ie),     0L)
NATIVE {CxDebug} PROC	->CxDebug(id)         CreateCxObj((LONG)CX_DEBUG,     (IPTR)(id),     0L)
NATIVE {CxCustom} PROC	->CxCustom(action,id) CreateCxObj((LONG)CX_CUSTOM,    (IPTR)(action), (LONG)(id))

#define CxFilter(d)          CreateCxObj(CX_FILTER, (d), 0)
#define CxSender(port, id)   CreateCxObj(CX_SEND, (port), (id))
#define CxSignal(task, sig)  CreateCxObj(CX_SIGNAL, (task), (sig))
#define CxTranslate(ie)      CreateCxObj(CX_TRANSLATE, (ie), 0)
#define CxDebug(id)          CreateCxObj(CX_DEBUG, (id), 0)
#define CxCustom(action, id) CreateCxObj(CX_CUSTOM, (action), id)

NATIVE {InputXpression} OBJECT inputxpression
    {ix_Version}	version	:UBYTE   /* see below */
    {ix_Class}	class	:UBYTE
    {ix_Code}	code	:UINT
    {ix_CodeMask}	codemask	:UINT
    {ix_Qualifier}	qualifier	:UINT
    {ix_QualMask}	qualmask	:UINT  /* see below */
    {ix_QualSame}	qualsame	:UINT  /* see below */
ENDOBJECT
NATIVE {IX} CONST

/* ix_Version */
NATIVE {IX_VERSION} CONST IX_VERSION = 2

/* ix_QualMask */
NATIVE {IX_NORMALQUALS} CONST IX_NORMALQUALS = $7FFF

/* ix_QualSame */
NATIVE {IXSYM_SHIFT} CONST IXSYM_SHIFT = $1
NATIVE {IXSYM_CAPS}  CONST IXSYM_CAPS  = $2
NATIVE {IXSYM_ALT}   CONST IXSYM_ALT   = $4
NATIVE {IXSYM_SHIFTMASK} CONST IXSYM_SHIFTMASK = (IEQUALIFIER_LSHIFT OR IEQUALIFIER_RSHIFT)
NATIVE {IXSYM_CAPSMASK}  CONST IXSYM_CAPSMASK  = (IXSYM_SHIFTMASK    OR IEQUALIFIER_CAPSLOCK)
NATIVE {IXSYM_ALTMASK}   CONST IXSYM_ALTMASK   = (IEQUALIFIER_LALT   OR IEQUALIFIER_RALT)

NATIVE {NULL_IX} CONST	->NULL_IX(ix) ((ix)->ix_Class == IECLASS_NULL)
#define NULL_IX(ix) Null_ix(ix)
PROC Null_ix(ix:PTR TO inputxpression) IS ix.class=IECLASS_NULL

/* Nodes of the list got from CopyBrokerList(). This function is used by
 * Exchange to get the current brokers. This structure is the same as
 * in AmigaOS and MorphOS, but it is undocumented there. */
NATIVE {BrokerCopy} OBJECT brokercopy
    {bc_Node}	node	:ln
    {bc_Name}	name[CBD_NAMELEN]	:ARRAY OF CHAR
    {bc_Title}	title[CBD_TITLELEN]	:ARRAY OF CHAR
    {bc_Descr}	descr[CBD_DESCRLEN]	:ARRAY OF CHAR
    {bc_Task}	task	:PTR TO tc	/* Private, do not use this */
    {bc_Port}	port	:PTR TO mp	/* Private, do not use this */
    {bc_Dummy}	dummy	:UINT
    {bc_Flags}	flags	:ULONG
ENDOBJECT
