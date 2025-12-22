(*
(*
**  Amiga Oberon Interface Module:
**  $VER: FileSysRes.mod 40.15 (28.12.93) Oberon 3.0
**
**   © 1993 by Fridtjof Siebert
**   updated for V40.15 by hartmut Goebel
*)
*)

MODULE FileSysRes;   (* $Implementation- *)

IMPORT e * := Exec,
       d * := Dos;

CONST
  fsrName * = "FileSystem.resource";

TYPE
  FileSysResourcePtr * = UNTRACED POINTER TO FileSysResource;
  FileSysResource * = STRUCT (node * : e.Node)   (* on resource list *)
    creator * : e.LSTRPTR;         (* name of creator of this resource *)
    fileSysEntries * : e.List;     (* list of FileSysEntry structs *)
  END;


  FileSysEntryPtr * = UNTRACED POINTER TO FileSysEntry;
  FileSysEntry * = STRUCT (node * : e.Node)
                                (* on fsr_FileSysEntries list *)
                                (* ln_Name is of creator of this entry *)
    dosType * : LONGINT;        (* DosType of this FileSys *)
    version * : LONGINT;        (* Version of this FileSys *)
    patchFlags * : LONGSET;     (* bits set for those of the following that *)
                                (*   need to be substituted into a standard *)
                                (*   device node for this file system: e.g. *)
                                (*   0x180 for substitute SegList & GlobalVec *)
    type * : LONGINT;           (* device node type: zero *)
    task * : e.TaskPtr;         (* standard dos "task" field *)
    lock * : d.FileLockPtr;     (* not used for devices: zero *)
    handler * : d.BSTR;         (* filename to loadseg (if SegList is null) *)
    stackSize * : LONGINT;      (* stacksize to use when starting task *)
    priority * : LONGINT;       (* task priority when starting task *)
    startup * : e.BPTR;         (* startup msg: FileSysStartupMsg for disks *)
    segList * : e.BPTR;         (* code to run to start new task *)
    globalVec * : e.BPTR;       (* BCPL global vector when starting task *)
    (* no more entries need exist than those implied by fse_PatchFlags *)
  END;

END FileSysRes.


