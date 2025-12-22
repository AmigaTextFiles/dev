MODULE scanList;
(* 3.11.87/ms
 * scan throu the lists of Exec showing the names of the nodes
 * Copyright © 1987, by Markus Schaub / AMSoft
 * The author hereby gives the permission to include this program into the
 * collection of demo programs of M2Amiga. Any part of this program can be
 * used as example of coding with M2Amiga (although it might be a bad example)
 *)
FROM SYSTEM IMPORT
 ADDRESS,ADR,INLINE;
FROM Exec IMPORT
 execBase,Node,NodePtr,List,ListPtr,Forbid,Permit,RawDoFmt;
FROM Terminal IMPORT
 Write,WriteLn,WriteString;

CONST
 format="%08lx %02x %s";
 null="no name"; (* or any other dummy string *)

TYPE
 MyNodePtr=POINTER TO Node;

VAR
 line: ARRAY [0..255] OF CHAR;
 lineData: RECORD
  adr: ADDRESS;
  t: INTEGER;
  str: ADDRESS
 END;

PROCEDURE StuffChar;
(* $E- no entry/exit code for this please, just these two 32 bit *)
BEGIN (* uses the hidden secrets of Exec's RawDoFmt, your OWN risk! *)
 INLINE(
  16C0H,(*  MOVE.B D0,(A3)+  *)
  4E75H (*  RTS  *)
 )
END StuffChar;

PROCEDURE ScanList(list: ListPtr);
VAR
 h: MyNodePtr;
BEGIN
 Forbid; (* just us fooling around with these lists *)
 h:=MyNodePtr(list^.head);
 WHILE h^.succ#NIL DO
  WITH h^ DO
   WITH lineData DO
    adr:=h;
    t:=ORD(type);
    IF name#NIL THEN
     str:=name
    ELSE
     str:=ADR(null)
    END
   END;
   h:=MyNodePtr(h^.succ);
  END;
  (* lineData is a pseudo stack for this routine, no check on length of line! *)
  RawDoFmt(ADR(format),ADR(lineData),ADR(StuffChar),ADR(line));
  WriteString(line); WriteLn
 END;
 Permit;
 WriteLn
END ScanList;

BEGIN
 WriteString("scanList, 1.0, 3.11.87, © AMSoft"); WriteLn;
 WITH execBase^ DO
  WriteString("Scanning memList"); WriteLn;
  ScanList(ADR(memList));
  WriteString("Scanning resourceList"); WriteLn;
  ScanList(ADR(resourceList));
  WriteString("Scanning deviceList"); WriteLn;
  ScanList(ADR(deviceList));
  WriteString("Scanning intrList"); WriteLn;
  ScanList(ADR(intrList));
  WriteString("Scanning libList"); WriteLn;
  ScanList(ADR(libList));
  WriteString("Scanning portList"); WriteLn;
  ScanList(ADR(portList));
  WriteString("Scanning taskReady"); WriteLn;
  ScanList(ADR(taskReady));
  WriteString("Scanning taskWait"); WriteLn;
  ScanList(ADR(taskWait));
  WriteString("Scanning semaphoreList"); WriteLn;
  ScanList(ADR(semaphoreList))
 END
END scanList.
