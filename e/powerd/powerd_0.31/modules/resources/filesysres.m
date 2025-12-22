MODULE 'exec/nodes'
MODULE 'exec/lists'
MODULE 'dos/dos'

#define FSRNAME 'FileSystem.resource'

OBJECT FileSysResource
 Node:Node,               /* on resource list */
 Creator:PTR TO UBYTE,    /* name of creator of this resource */
 FileSysEntries:List      /* list of FileSysEntry structs */

OBJECT FileSysEntry
 Node:Node,           /* on fsr_FileSysEntries list */
 DosType:ULONG,       /* DosType of this FileSys */
 Version:ULONG,       /* Version of this FileSys */
 PatchFlags:ULONG,    /* bits set for those of the following that */
 Type:ULONG,          /* device node type: zero */
 Task:CPTR,            /* standard dos "task" field */
 Lock:BPTR,            /* not used for devices: zero */
 Handler:PTR TO CHAR,        /* filename to loadseg (if SegList is null) */
 StackSize:ULONG,     /* stacksize to use when starting task */
 Priority:LONG,       /* task priority when starting task */
 Startup:BPTR,         /* startup msg: FileSysStartupMsg for disks */
 SegList:BPTR,         /* code to run to start new task */
 GlobalVec:BPTR        /* BCPL global vector when starting task */
