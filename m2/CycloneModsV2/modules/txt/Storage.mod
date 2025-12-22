IMPLEMENTATION MODULE Storage;

(* (C) Copyright 1995 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ADDRESS,ADR,CAST;
IMPORT Heap,ml:ModulaLib;

CONST
  oom="You are out of memory!!";

PROCEDURE ALLOCATE(VAR Adr:ADDRESS; size:LONGINT);
BEGIN
  Heap.AllocMem(Adr,size,FALSE);
  ml.Assert(Adr#NIL,ADR(oom));
END ALLOCATE;

PROCEDURE DEALLOCATE(VAR Adr:ADDRESS; size:LONGINT);
(* size is a dummy to compatible *)
BEGIN
  Heap.Deallocate(Adr);
END DEALLOCATE;

END Storage.
