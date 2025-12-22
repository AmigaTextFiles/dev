MODULE frags;
(* 2.0 / 4.5.87 / ms *)
(* Copyright 1987 by Markus Schaub / AMSoft
 * Permission granted to have this program in the collection of demo programs
 * of M2Amiga and to use any part of it as example of coding with M2Amiga.
 * Again, also bad examples are examples :-)
 *)
FROM SYSTEM IMPORT
 ADDRESS,ADR;
FROM Exec IMPORT
 execBase,MemChunk,MemHeaderPtr,Forbid,Permit,RawDoFmt;
FROM Terminal IMPORT
 WriteLn,WriteString;

VAR
 mem: MemHeaderPtr;
 chunk: POINTER TO MemChunk;
 line: ARRAY [0..255] OF CHAR;
 stuffChar: ADDRESS;
 ld: RECORD
  adr: ADDRESS;
  size: LONGINT
 END;

BEGIN
 stuffChar:=16C04E75H;
 WriteString("frags, 2.0, 4.5.87, © AMSoft"); WriteLn;
 Forbid();
 mem:=ADDRESS(execBase^.memList.head);
 WHILE mem^.node.succ#NIL DO
  chunk:=ADDRESS(mem^.first);
  WHILE chunk#NIL DO
   ld.adr:=ADDRESS(chunk);
   ld.size:=chunk^.bytes;
   RawDoFmt(ADR("adr= %08lx size=%7ld"),ADR(ld),ADR(stuffChar),ADR(line));
   WriteString(line); WriteLn;
   chunk:=ADDRESS(chunk^.next);
  END;
  mem:=ADDRESS(mem^.node.succ);
 END;
 Permit();
END frags.
