(*MemManager.library Module Translated from C Includes
  By Morten Bjergstrøm
  EMail: mbjergstroem@hotmail.com
*)

<*STANDARD-*>
MODULE MemManager;

IMPORT
  e:=Exec, Kernel;

VAR
  base* : e.LibraryPtr;

CONST
  memmanagerMinVersion*=3;
  memmanagerName*="memmanager.library";

  disposable*=2;
  paged*=4;



PROCEDURE CreateVMem* [base,-30]
  (memsize   [0] : LONGINT;
   memflags  [1] : LONGINT;
   initpri   [2] : LONGINT;
   vmemflags [3] : LONGINT)
  : e.APTR;

PROCEDURE RemoveVMem* [base,-36]
  (obj [9] : e.APTR);

PROCEDURE LockVMem* [base,-42]
  (obj [9] : e.APTR)
  : e.APTR;

PROCEDURE UnlockVMem* [base,-48]
  (obj [9] : e.APTR);

PROCEDURE ChangeVMemPri* [base,-54]
  (obj    [9] : e.APTR;
   mempri [0] : LONGINT);

PROCEDURE PurgeVMem* [base,-60]
  (memflags [1] : LONGINT)
  : LONGINT;

PROCEDURE ChangeVMemType* [base,-66]
  (obj       [9] : e.APTR;
   vmemflags [0] : LONGINT);

PROCEDURE DefineVMemHierachy* [base,-72]
  (hierachy [9] : e.APTR);

PROCEDURE ClearVMemHierachy* [base,-78]
  (hierachy [9] : e.APTR);

PROCEDURE Publish* [base,-84]
  (obj [9] : e.APTR);

PROCEDURE Protect* [base,-90]
  (obj [9] : e.APTR);




PROCEDURE* [0] CloseLib (VAR rc : LONGINT);

BEGIN (* CloseLib *)
  IF base # NIL THEN e.CloseLibrary (base) END
END CloseLib;


BEGIN

  base := e.OpenLibrary (memmanagerName, memmanagerMinVersion);

  IF base # NIL THEN Kernel.SetCleanup (CloseLib) END;

END MemManager.
