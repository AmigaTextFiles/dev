IMPLEMENTATION MODULE Heap;

(* (C) Copyright 1994 Marcel Timmermans. All rights reserved. *)

FROM SYSTEM IMPORT ADDRESS,ADR,CAST;
IMPORT ml:ModulaLib,
       el:ExecL,
       ed:ExecD;

CONST
  oom="You are out of memory!!";

TYPE
    BlockPtr = POINTER TO Block;
    Block = RECORD
              blksize : LONGINT;
              next    : BlockPtr;
            END;

VAR
 First:BlockPtr;

PROCEDURE AllocMem(VAR Adr:ADDRESS; size:LONGINT; mrChip:BOOLEAN);
VAR blk:BlockPtr;
    mr:ed.MemReqSet;
BEGIN
 Adr:=NIL;
 IF size>0 THEN
  mr:=ed.MemReqSet{ed.memClear};
  IF mrChip THEN INCL(mr,ed.chip); ELSE INCL(mr,ed.public) END;
  INC(size,SIZE(Block)); (* reserve also memory for memhandler *)
  blk:=el.AllocMem(size,mr);
  IF blk#NIL THEN
    WITH blk^ DO
     blksize:=size;
     next:=First;
    END;
    First:=blk;
    Adr:=LONGINT(blk)+SIZE(Block);
  END;
 END;
END AllocMem;

PROCEDURE Allocate(VAR Adr:ADDRESS; size:LONGINT);
BEGIN
 AllocMem(Adr,size,FALSE);
END Allocate;

PROCEDURE Deallocate(VAR Adr:ADDRESS);
VAR prev,curr,act:BlockPtr;
BEGIN
  IF Adr=NIL THEN RETURN END;
  curr:=First; prev:=NIL;
  act:=CAST(BlockPtr,Adr-SIZE(Block));
  WHILE (curr#NIL) & (act#curr) DO
   prev:=curr;
   curr:=curr^.next;
  END;
  IF (prev=NIL) & (curr#NIL) THEN
    First:=curr^.next;
  ELSIF (curr#NIL) THEN 
    prev^.next:=curr^.next;
  END;
  IF curr#NIL THEN
    el.FreeMem(curr,curr^.blksize);
    Adr:=NIL;
  END;
END Deallocate;

PROCEDURE CleanHeap;
VAR prev,act:BlockPtr;
BEGIN
  act:=First;
  WHILE act#NIL DO
    prev:=act;
    act:=act^.next;
    el.FreeMem(prev,prev^.blksize);
  END;
  First:=NIL;
END CleanHeap;


BEGIN
 First:=NIL;
CLOSE
 CleanHeap;
END Heap.
