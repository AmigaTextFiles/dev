/* $Id: filesysres.h,v 1.10 2005/11/10 15:39:42 hjfrieden Exp $ */
OPT NATIVE, PREPROCESS
MODULE 'target/exec/nodes', 'target/exec/lists', 'target/dos/dos'
MODULE 'target/exec/types'
{#include <resources/filesysres.h>}
NATIVE {RESOURCES_FILESYSRES_H} CONST

NATIVE {FSRNAME} CONST
#define FSRNAME fsrname
STATIC fsrname = 'FileSystem.resource'

NATIVE {FileSysResource} OBJECT filesysresource
    {fsr_Node}	ln	:ln           /* on resource list */
    {fsr_Creator}	creator	:ARRAY OF CHAR /*STRPTR*/        /* name of creator of this resource */
    {fsr_FileSysEntries}	filesysentries	:lh /* list of FileSysEntry structs */
ENDOBJECT

NATIVE {FileSysEntry} OBJECT filesysentry
    {fse_Node}	ln	:ln       /* on fsr_FileSysEntries list */
                                /* ln_Name is of creator of this entry */
    {fse_DosType}	dostype	:ULONG    /* DosType of this FileSys */
    {fse_Version}	version	:ULONG    /* Version of this FileSys */
    {fse_PatchFlags}	patchflags	:ULONG /* bits set for those of the following that */
                                /*   need to be substituted into a standard */
                                /*   device node for this file system: e.g. */
                                /*   0x180 for substitute SegList & GlobalVec */
    {fse_Type}	type	:ULONG       /* device node type: zero */
    {fse_Task}	task	:CPTR       /* standard dos "task" field */
    {fse_Lock}	lock	:BPTR       /* not used for devices: zero */
    {fse_Handler}	handler	:BSTR    /* filename to loadseg (if SegList is null) */
    {fse_StackSize}	stacksize	:ULONG  /* stacksize to use when starting task */
    {fse_Priority}	priority	:VALUE   /* task priority when starting task */
    {fse_Startup}	startup	:BPTR    /* startup msg: FileSysStartupMsg for disks */
    {fse_SegList}	seglist	:BPTR    /* code to run to start new task */
    {fse_GlobalVec}	globalvec	:BPTR  /* BCPL global vector when starting task */
    /* no more entries need exist than those implied by fse_PatchFlags */
ENDOBJECT
