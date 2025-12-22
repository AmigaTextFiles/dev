;
; ** $VER: filesysres.h 36.4 (3.5.90)
; ** Includes Release 40.15
; **
; ** FileSystem.resource description
; **
; ** (C) Copyright 1988-1993 Commodore-Amiga, Inc.
; **     All Rights Reserved
;

IncludePath   "PureInclude:"
XIncludeFile "exec/nodes.pb"
XIncludeFile "exec/lists.pb"

;#FSRNAME = "FileSystem\resource"

Structure FileSysResource
    fsr_Node.Node  ;  on resource list
    *fsr_Creator.b  ;  name of creator of this resource
    fsr_FileSysEntries.List ;  list of FileSysEntry structs
EndStructure

Structure FileSysEntry
    fse_Node.Node ;  on fsr_FileSysEntries list
    ;  ln_Name is of creator of this entry
    fse_DosType.l ;  DosType of this FileSys
    fse_Version.l ;  Version of this FileSys
    fse_PatchFlags.l ;  bits set for those of the following that
    ;    need to be substituted into a standard
    ;    device node for this file system: e.g.
    ;    0x180 for substitute SegList & GlobalVec
    fse_Type.l  ;  device node type: zero
    *fse_Task.l  ;  standard dos "task" field
    *fse_Lock.l  ;  not used for devices: zero
    *fse_Handler.l ;  filename to loadseg (if SegList is null)
    fse_StackSize.l ;  stacksize to use when starting task
    fse_Priority.l ;  task priority when starting task
    *fse_Startup.l ;  startup msg: FileSysStartupMsg for disks
    *fse_SegList.l ;  code to run to start new task
    *fse_GlobalVec.l ;  BCPL global vector when starting task
    ;  no more entries need exist than those implied by fse_PatchFlags
EndStructure

