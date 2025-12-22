OPT MODULE
OPT EXPORT

/**************************************************
 *
 *
 *              PPCCreateTask() Tags
 *
 *
 **************************************************/

CONST     TAG_UTENTE = 			$80000000
CONST	PPCTASKTAG_DUMMY	=TAG_UTENTE + $20000
CONST	PPCTASKTAG_ELFOBJECT	=PPCTASKTAG_DUMMY + $1

/* Name of the new Task. */
CONST	PPCTASKTAG_NAME		=PPCTASKTAG_DUMMY + $2

/* First Argument..gpr3 */
CONST	PPCTASKTAG_ARG1		=PPCTASKTAG_DUMMY + $3

/* First Argument..gpr4 */
CONST	PPCTASKTAG_ARG2		=PPCTASKTAG_DUMMY + $4

/* First Argument..gpr5 */
CONST	PPCTASKTAG_ARG3		=PPCTASKTAG_DUMMY + $5

/* First Argument..gpr6 */
CONST	PPCTASKTAG_ARG4		=PPCTASKTAG_DUMMY + $6

/* First Argument..gpr7 */
CONST	PPCTASKTAG_ARG5		=PPCTASKTAG_DUMMY + $7

/* First Argument..gpr8 */
CONST	PPCTASKTAG_ARG6		=PPCTASKTAG_DUMMY + $8

/* First Argument..gpr9 */
CONST	PPCTASKTAG_ARG7		=PPCTASKTAG_DUMMY + $9

/* First Argument..gpr10 */
CONST	PPCTASKTAG_ARG8		=PPCTASKTAG_DUMMY + $a

/* Default=TRUE means that the cacheflush is handled automaticly
 * You need cacheflushs when you use OS functions to share data.
 * If you know it better than the stupid cacheflush routine you
 * can handle that yourself and optimize your routines.
 */

CONST	PPCTASKTAG_CACHEFLUSH	=PPCTASKTAG_DUMMY + $b

/* Ptr to an ULONG Errorfield where a better error description
 * can be stored.
 */

CONST	PPCTASKTAG_ERROR	=PPCTASKTAG_DUMMY + $c

/* PPC Stacksize...Default 8192
 * Supported by PowerUP's PPCGetTaskAttr( (V45
 */
CONST	PPCTASKTAG_STACKSIZE	=PPCTASKTAG_DUMMY + $d

/* Task Priority..Default 0 */
CONST	PPCTASKTAG_PRIORITY	=PPCTASKTAG_DUMMY + $e

/* Input Handle..Default Open("Nil:"
 * The handle is closed when the PPC task completes
 */
CONST	PPCTASKTAG_INPUTHANDLE	=PPCTASKTAG_DUMMY + $f

/* Output Handle..Default Open("Nil:"
 * The handle is closed when the PPC task completes
 */
CONST	PPCTASKTAG_OUTPUTHANDLE	=PPCTASKTAG_DUMMY + $10

/* Error Handle..Default Open("Nil:"
 * The handle is closed when the PPC task completes
 */
CONST	PPCTASKTAG_ERRORHANDLE	=PPCTASKTAG_DUMMY + $11

/*
 * When you set this Tag the Task is stopped
 * before the first instruction is executed
 * Only useful for debuggers
 */
CONST	PPCTASKTAG_STOPTASK	=PPCTASKTAG_DUMMY + $12

/* ExceptionHook
 * The M68k Hook is called when a PPC TaskObject gets an
 * exception which can be processor or software(Kernel Msg
 * related.
 * That`s the way the ppc.library calls the Hook:
 *
 * BOOL CallHookPkt(hook,TaskObject,ExceptionMsg);
 *
 * The Hook Function is NOT allowed to call PPCLibBase
 * functions to avoid deadlocks.
 * And after the Hook function returns the ExceptionMsg
 * contents IS NOT valid anymore.
 * So you should copy the ExceptionMsg contents to a private
 * buffer and then signal your debugger control task about
 * the event.
 * The Hook return BOOL should tell the ppc.library if all
 * worked fine.
 */

CONST	PPCTASKTAG_EXCEPTIONHOOK	=PPCTASKTAG_DUMMY + $13


/* If you want that the PPCTask gets a MsgPort you can tell
 * PPCCreateTask by a TRUE that you want one.
 * I made this optional because it may cause an initial speed
 * loss if you only need a ppc task for a quick run job where
 * the init latency may be a serious issue.
 * Supported by PowerUP's PPCGetTaskAttr(
 */
CONST	PPCTASKTAG_MSGPORT		=PPCTASKTAG_DUMMY + $14

/* If you wanna provide the ppc a startup msg. This msg will
 * be replied by the ppc.library after the PPC Task ends so
 * you can use this to know that the PPCTask is gone so a
 * PPCUnloadObject( is save now.
 * Supported by PowerUP's PPCGetTaskAttr=
 */
CONST	PPCTASKTAG_STARTUP_MSG		=PPCTASKTAG_DUMMY + $15

/* The Data field for the PPCMessage
 * Supported by PowerUP's PPCGetTaskAttr(
 */
CONST	PPCTASKTAG_STARTUP_MSGDATA	=PPCTASKTAG_DUMMY + $16
/* The Length field for the PPCMessage
 * Supported by PowerUP's PPCGetTaskAttr(
 */
CONST	PPCTASKTAG_STARTUP_MSGLENGTH	=PPCTASKTAG_DUMMY + $17
/* The MsgID field for the PPCMessage
 * Supported by PowerUP's PPCGetTaskAttr(
 */
CONST	PPCTASKTAG_STARTUP_MSGID	=PPCTASKTAG_DUMMY + $18
/* The flag to activate the CTRL-CDEF gateway to
 * the PPC Task by PPCSendSignal(
 */
CONST	PPCTASKTAG_BREAKSIGNAL		=PPCTASKTAG_DUMMY + $19


/* The CPU number the task should start on.
 * This is only a hint and no gurantee.
 */
CONST	PPCTASKTAG_CPUHINT		=PPCTASKTAG_DUMMY + $1a

/* Ptr to ixemul UserData
 * ONLY supported by PowerUP's PPCGetTaskAttr(,PPCSetTaskAttr(
 */
CONST	PPCTASKTAG_EXTUSERDATA		=PPCTASKTAG_DUMMY + $1b



/* Run Task Synchron Flag which means that the PPCCreateTask
 * doesn`t return until the task completes and the return
 * value is not the TaskObject but the Task`s return value.
 * To check if the task runned correctly check out the
 * PPCTASKTAG_ERROR fieldptr.
 * With this Tag you can do the same what the old RunTaskObject
 * does which interface is a bit limited(compatibility to the
 * first ppc.library version
 */

CONST	PPCTASKTAG_WAITFINISH	=PPCTASKTAG_DUMMY + $31

/* 
 * PPCTASKTAG_ERROR types
 */

CONST	ERROR_OK	=	0
CONST	ERROR_MEMORY=		1
CONST	ERROR_NOPC=		2
CONST	ERROR_CREATEMSGINTASK=	3
CONST	ERROR_INPUTHANDLE=	4
CONST	ERROR_OUTPUTHANDLE=	5
CONST	ERROR_ERRORHANDLE=	6




/**************************************************
 *
 *
 * PPCGetTaskAttrs(, PPCSetTaskAttrs( Tags
 *
 *
 **************************************************/

/*
 * V45 adds the ti_Data data Set/Get passing if it`s possible
 */


CONST	PPCTASKINFOTAG_DUMMY		=TAG_UTENTE + $21000
/* (Get */
CONST	PPCTASKINFOTAG_NAME		=PPCTASKINFOTAG_DUMMY + $1
/* (Get/Set */
CONST	PPCTASKINFOTAG_PRIORITY		=PPCTASKINFOTAG_DUMMY + $2
/* (Get/Set */
CONST	PPCTASKINFOTAG_CACHEFLUSH	=PPCTASKINFOTAG_DUMMY + $3
/* (Get */
CONST	PPCTASKINFOTAG_STACKSIZE	=PPCTASKINFOTAG_DUMMY + $4
/* (Get */
CONST	PPCTASKINFOTAG_STATE		=PPCTASKINFOTAG_DUMMY + $5
/* (Get/Set */
CONST	PPCTASKINFOTAG_TASK		=PPCTASKINFOTAG_DUMMY + $6

/* This means the HOOK function is called for every Task */
CONST	PPCTASKINFOTAG_ALLTASK		=PPCTASKINFOTAG_DUMMY + $7

/* Hook function which is called for a task so you can ask special fields
 * you may want to use.
 * Msg Parameter is NULL for now.
 * Object Parameter is the TaskObject
 *
 *    HookFunc(Hook, TaskObject, NULL
 */
CONST	PPCTASKINFOTAG_HOOK		=PPCTASKINFOTAG_DUMMY + $8

/* (Get */
CONST	PPCTASKINFOTAG_SIGALLOC		=PPCTASKINFOTAG_DUMMY + $9
/* (Get */
CONST	PPCTASKINFOTAG_SIGWAIT		=PPCTASKINFOTAG_DUMMY + $a
/* (Get */
CONST	PPCTASKINFOTAG_SIGRECVD		=PPCTASKINFOTAG_DUMMY + $b
/* (Get */
CONST	PPCTASKINFOTAG_USEDSTACKSIZE	=PPCTASKINFOTAG_DUMMY + $c
/* (Get/Set */
CONST	PPCTASKINFOTAG_INPUTHANDLE	=PPCTASKINFOTAG_DUMMY + $d
/* (Get/Set */
CONST	PPCTASKINFOTAG_OUTPUTHANDLE	=PPCTASKINFOTAG_DUMMY + $e
/* (Get/Set */
CONST	PPCTASKINFOTAG_ERRORHANDLE	=PPCTASKINFOTAG_DUMMY + $f

/* Return the ElfObject of a Task
 * (Get
 * (V45
 */

CONST	PPCTASKINFOTAG_ELFOBJECT	=PPCTASKINFOTAG_DUMMY + $10

/* See equal PPCTASKTAG_EXCEPTIONHOOK
 * (V45
 * (Set
 */

CONST	PPCTASKINFOTAG_EXCEPTIONHOOK		=PPCTASKINFOTAG_DUMMY + $11

/* Tell the task to stop at the first instruction.
 * Only allowed to be used when you get a TaskHookMsg
 * with the MethodID PPCTASKHOOKMETHOD_CREATE.
 * It must not be called while a PPC Task runs.
 * (V45
 * (Set
 */
CONST	PPCTASKINFOTAG_STOPTASK			=PPCTASKINFOTAG_DUMMY + $12


/* See equal PPCTASKTAG_MSGPORT
 * (V45
 */
CONST	PPCTASKINFOTAG_MSGPORT			=PPCTASKINFOTAG_DUMMY + $13

/* See equal PPCTASKTAG_STARTUP_MSG
 * (V45
 */
CONST	PPCTASKINFOTAG_STARTUP_MSG		=PPCTASKINFOTAG_DUMMY + $14

/* See equal PPCTASKTAG_STARTUP_MSGDATA
 * (V45
 */
CONST	PPCTASKINFOTAG_STARTUP_MSGDATA		=PPCTASKINFOTAG_DUMMY + $15

/* See equal PPCTASKTAG_STARTUP_MSGLENGTH
 * (V45
 */
CONST	PPCTASKINFOTAG_STARTUP_MSGLENGTH	=PPCTASKINFOTAG_DUMMY + $16

/* See equal PPCTASKTAG_STARTUP_MSGID
 * (V45
 */
CONST	PPCTASKINFOTAG_STARTUP_MSGID		=PPCTASKINFOTAG_DUMMY + $17


/*
 * All Register Tags only accept Ptrs at ti_Data so I don`t have to
 * change the API when there`s a 64Bit PPC some time.
 */

/* SRR0=PC
 * Get/Set through ti_Data or PPCTASKINFOTAG_VALUEPTR
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_PC		=PPCTASKINFOTAG_DUMMY + $20

/* SRR1=MSR
 * Get/Set through ti_Data or PPCTASKINFOTAG_VALUEPTR
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_MSR		=PPCTASKINFOTAG_DUMMY + $21

/* 32bit value in function Result
 * Get/Set through ti_Data
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_CR		=PPCTASKINFOTAG_DUMMY + $22

/* 32bit value in function Result
 * Get/Set through ti_Data
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_XER		=PPCTASKINFOTAG_DUMMY + $23

/* Result by PPCTASKINFOTAG_VALUEPTR
 * Get/Set through ti_Data or PPCTASKINFOTAG_VALUEPTR
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_LR		=PPCTASKINFOTAG_DUMMY + $24

/* Result by PPCTASKINFOTAG_VALUEPTR
 * Get/Set through ti_Data or PPCTASKINFOTAG_VALUEPTR
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_CTR		=PPCTASKINFOTAG_DUMMY + $25

/* Result by PPCTASKINFOTAG_VALUEPTR
 * Get/Set through ti_Data or PPCTASKINFOTAG_VALUEPTR
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_FPSCR		=PPCTASKINFOTAG_DUMMY + $26

/* ti_Data=Register Number
 * Get/Set through PPCTASKINFOTAG_VALUEPTR
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_GPR		=PPCTASKINFOTAG_DUMMY + $30

/* ti_Data=Register Number
 * Get/Set through PPCTASKINFOTAG_VALUEPTR
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_FPR		=PPCTASKINFOTAG_DUMMY + $31

/* Address where to read/write the register value from.
 * I use a ptr to be size indepent with the registers
 * (Get/Set
 */
CONST	PPCTASKINFOTAG_VALUEPTR		=PPCTASKINFOTAG_DUMMY + $32


/* With PPCTASKINFOTAG_WAITFINISHTASK
 * it returns the parent process in which you created
 * a synchron PPC Task. Synchron PPC Task`s are created
 * with the PPCTASKTAG_WAITINFISH,TRUE or outdated a
 * PPCRunObject.
 * The reason for this function is to find the shell
 * task easily and check for a CTRL-C for example.
 * (Get
 * (V45
 */
CONST	PPCTASKINFOTAG_WAITFINISHTASK	=PPCTASKTAG_DUMMY + $33



/**************************************************
 *
 *
 *           TaskObject ExceptionHook
 *
 *
 **************************************************/


OBJECT	exceptionmsg
	version
	type
	gpr[32]:ARRAY OF LONG
	fpr[32]:ARRAY OF LONG		-> This was a DOUBLE !!
	sr[16]:ARRAY OF LONG
	cr
	fpscr
	xer
	lr
	ctr
	pvr
	ibat0u
	ibat0l
	ibat1u
	ibat1l
	ibat2u
	ibat2l
	ibat3u
	ibat3l
	dbat0u
	dbat0l
	dbat1u
	dbat1l
	dbat2u
	dbat2l
	dbat3u
	dbat3l
	sdr1
	asr
	dar
	dsisr
	srr0
	srr1
	sprg0
	sprg1
	sprg2
	sprg3
	tbl
	tbu
	dec
	dabr

	/* 603 special registers */

	dmiss
	dcmp
	hash1
	hash2
	imiss
	icmp
	rpa
	msr
ENDOBJECT

/* Current supported Version
 */

CONST	EXCEPTIONMSG_VERSION=	1

/*
 * Current supported Types
 */

/*
 * These are the processor exceptions
 */

CONST	EXCEPTION_UNKNOWN	=	0	/* Won`t happen */
CONST	EXCEPTION_RESET	=		1	/* Won`t happen */
CONST	EXCEPTION_MACHINECHECK	=	2	/* Won`t happen */
CONST	EXCEPTION_DATAACCESS=		3
CONST	EXCEPTION_INSTRUCTIONACCESS=	4
CONST	EXCEPTION_EXTERNALINTERRUPT=	5	/* Won`t happen */
CONST	EXCEPTION_ALIGNMENT	=	6
CONST	EXCEPTION_PROGRAM	=	7
CONST	EXCEPTION_FPUUNAVAILABLE=	8
CONST	EXCEPTION_DECREMENTER=		9
CONST	EXCEPTION_INTERFACEERROR	=10
CONST	EXCEPTION_RESERVED_B=		11
CONST	EXCEPTION_SYSTEMCALL=		12
CONST	EXCEPTION_TRACE=			13
CONST	EXCEPTION_FPUASSIST	=	14
CONST	EXCEPTION_RESERVED_F=		15
CONST	EXCEPTION_IMISS=			16
CONST	EXCEPTION_DLOADMISS	=	17
CONST	EXCEPTION_DSTOREMISS=		18
CONST	EXCEPTION_IADDRESSBREAK=		19
CONST	EXCEPTION_SYSTEMMANAGEMENTINT	=20


/*
 * These are the kernel exceptions
 * to signal certain events
 */

CONST	EXCEPTION_MSG		=	$80000000

/*
 * You receive this exception type
 * when the Kernel could stop a Task
 * successfully after a Stop or Trace
 * operation.
 * Look at PPCTASKTAG_STOPTASK for example
 */

CONST	EXCEPTION_STOPTASK		=EXCEPTION_MSG + $0

/*
 * You receive this exception type
 * when the task completes.
 * In this case the ONLY valid fields in the
 * ExceptionMsg are the Version field and the
 * the Message type.
 */

CONST	EXCEPTION_FINISHTASK		=EXCEPTION_MSG + $1


/**************************************************
 *
 *
 *              PPCStartTask( Tags
 *
 *
 **************************************************/

CONST	PPCTASKSTARTTAG_DUMMY		=TAG_UTENTE + $22000

/* Just run a Task again
 * ti_Data=BOOL
 */
CONST	PPCTASKSTARTTAG_RUN		=PPCTASKSTARTTAG_DUMMY + $0

/* Single Step the next instruction
 * ti_Data=BOOL
 */
CONST	PPCTASKSTARTTAG_TRACE		=PPCTASKSTARTTAG_DUMMY + $1

/* Branch until a Trace instruction
 * Processor dependent
 * ti_Data=BOOL
 * NOT SUPPORTED YET
 */
CONST	PPCTASKSTARTTAG_BRANCHTRACE	=PPCTASKSTARTTAG_DUMMY + $2

/* Run until Instruction hit
 * the Breakpoint Address
 * Processor dependent
 * ti_Data=BOOL
 * NOT SUPPORTED YET
 */
CONST	PPCTASKSTARTTAG_IBREAK		=PPCTASKSTARTTAG_DUMMY + $3

/* Run until DataAccess hit
 * the Breakpoint Address
 * Processor dependent
 * ti_Data=BOOL
 * NOT SUPPORTED YET
 */
CONST	PPCTASKSTARTTAG_DBREAK		=PPCTASKSTARTTAG_DUMMY + $4


