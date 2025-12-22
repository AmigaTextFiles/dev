(*VMemory.library Module Translated from C Includes
  By Morten Bjergstrøm
  EMail: mbjergstroem@hotmail.com
*)

<* STANDARD- *>
MODULE VMemory;

IMPORT
  e:=Exec, Kernel;

CONST
  VMEMORYNAME="vmemory.library";
  VMEMORYVERSION=1;


TYPE
  VMemoryBase * = RECORD
    LibNode- :e.Library;
    SysLib*  :e.APTR;
    DosLib-  :e.APTR;
    TBase-   :e.APTR;
    TCount-  :e.ULONG;
    NEntry-  :e.APTR;
    NIndex-  :e.ULONG;
    OldIndex-:e.ULONG;
    PagePath-:e.APTR;
    RenPath- :e.APTR;
    PageName-:e.APTR;
    SegList* :e.APTR;
    Flags*   :e.UBYTE;
    Pad*     :e.UBYTE;
  END;

  VMemoryEntry * = RECORD
    Index*  :e.ULONG;
    Size*   :e.ULONG;
    Adresse*:e.APTR;
  END;

CONST
  vmemOk=0;
  vmemTableFull=-1;
  vmemNoPrefsFile=-2;
  vmemNoStartMemory=-3;
  vmemNoFileOpen=-4;
  vmemFailWrite=-5;
  vmemNoEmptyEntry=-6;
  vmemNoEntryFreed=-7;
  vmemFailRead=-8;
  vmemNoEntryFound=-9;
  vmemPageOccupied=-10;

VAR
  base-:e.LibraryPtr;


PROCEDURE AllocVMem* [base,-30]
  (MemBlock     [8] : e.APTR;
   MemBlockSize [0] : e.ULONG)
  : e.ULONG;

PROCEDURE FreeVMem* [base,-36]
  (IndexNum [0] : e.ULONG)
  : e.ULONG;

PROCEDURE ReadVMem* [base,-42]
  (IndexNum [0] : e.ULONG)
  : e.ULONG;

PROCEDURE WriteVMem* [base,-48]
  (IndexNum [0] : e.ULONG)
  : e.ULONG;

PROCEDURE RenamePage* [base,-54]
  (OldIndex [0] : e.ULONG;
   NewIndex [1] : e.ULONG)
  : e.ULONG;

PROCEDURE SwapVMem* [base,-60]
  (IndexNum [0] : e.ULONG)
  : e.ULONG;

PROCEDURE AvailVMem* [base,-66]
  ()
  : e.ULONG;

PROCEDURE LBinHex* [base,-72]
  (Space  [8] : e.APTR;
   Number [0] : e.ULONG);

PROCEDURE ReadPath* [base,-78]
  ();




PROCEDURE* [0] CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)
  IF base # NIL THEN e.CloseLibrary (base) END
END CloseLib;


BEGIN

  base := e.OpenLibrary (VMEMORYNAME, VMEMORYVERSION);

  IF base # NIL THEN Kernel.SetCleanup (CloseLib) END;

END VMemory.
