/* $VER: filesysres.h 36.4 (3.5.1990) */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/dos/dos'
MODULE 'target/exec/types'
{MODULE 'resources/filesysres'}

NATIVE {FSRNAME}	CONST
#define FSRNAME fsrname
STATIC fsrname	= 'FileSystem.resource'

NATIVE {filesysresource} OBJECT filesysresource
    {ln}	ln	:ln		/* on resource list */
    {creator}	creator	:ARRAY OF CHAR		/* name of creator of this resource */
    {filesysentries}	filesysentries	:lh	/* list of FileSysEntry structs */
ENDOBJECT

NATIVE {filesysentry} OBJECT filesysentry
    {ln}	ln	:ln	/* on fsr_FileSysEntries list */
				/* ln_Name is of creator of this entry */
    {dostype}	dostype	:ULONG	/* DosType of this FileSys */
    {version}	version	:ULONG	/* Version of this FileSys */
    {patchflags}	patchflags	:ULONG	/* bits set for those of the following that */
				/*   need to be substituted into a standard */
				/*   device node for this file system: e.g. */
				/*   0x180 for substitute SegList & GlobalVec */
    {type}	type	:ULONG		/* device node type: zero */
    {task}	task	:CPTR		/* standard dos "task" field */
    {lock}	lock	:BPTR		/* not used for devices: zero */
    {handler}	handler	:BSTR	/* filename to loadseg (if SegList is null) */
    {stacksize}	stacksize	:ULONG	/* stacksize to use when starting task */
    {priority}	priority	:VALUE	/* task priority when starting task */
    {startup}	startup	:BPTR	/* startup msg: FileSysStartupMsg for disks */
    {seglist}	seglist	:BPTR	/* code to run to start new task */
    {globalvec}	globalvec	:BPTR	/* BCPL global vector when starting task */
    /* no more entries need exist than those implied by fse_PatchFlags */
ENDOBJECT
