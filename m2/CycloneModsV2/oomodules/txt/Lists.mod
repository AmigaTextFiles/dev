IMPLEMENTATION MODULE Lists;

FROM SYSTEM IMPORT ADDRESS;
FROM Objects IMPORT TObject;
IMPORT H:Heap,io:InOut;


CONSTRUCTOR TList.Init;
BEGIN
 head:=NIL; tail:=NIL; elements:=0;
END TList.Init;

PROCEDURE TList.Add(d:ADDRESS);
VAR n:NodePtr;
BEGIN
 H.Allocate(n,SIZE(Node));
 WITH n^ DO 
  prev:=tail;
  next:=NIL;
  data:=d;
 END;
 IF n^.prev#NIL THEN n^.prev^.next:=n; ELSE head:=n; END;
 tail:=n;
 INC(elements);
END TList.Add;

PROCEDURE TList.DoProc(d:ADDRESS);
BEGIN
 (* Empty procedure *)
END TList.DoProc;

PROCEDURE TList.DoForward;
VAR n:NodePtr;
BEGIN
 n:=head;
 WHILE n#NIL DO
  DoProc(n^.data);
  n:=n^.next;
 END;
END TList.DoForward;

PROCEDURE TList.DoBackward;
VAR n:NodePtr;
BEGIN
 n:=tail;
 WHILE n#NIL DO
  DoProc(n^.data);
  n:=n^.prev;
 END;
END TList.DoBackward;

PROCEDURE TList.CountElements():LONGINT;
BEGIN
 RETURN elements;
END TList.CountElements;

PROCEDURE TList.Prev(n:NodePtr):NodePtr;
BEGIN
 IF n#NIL THEN RETURN n^.prev; ELSE RETURN NIL; END;
END TList.Prev;

PROCEDURE TList.Next(n:NodePtr):NodePtr;
BEGIN
 IF n#NIL THEN RETURN n^.next; ELSE RETURN NIL; END;
END TList.Next;

PROCEDURE TList.FreeData(d:ADDRESS);
BEGIN
END TList.FreeData;

PROCEDURE TList.Destroy;
VAR n,n2:NodePtr;
BEGIN
 n:=head;
 WHILE n#NIL DO
  n2:=n;
  n:=n^.next;
  FreeData(n2^.data);
  H.Deallocate(n2);
 END;
 elements:=0;
 head:=NIL; tail:=NIL;
END TList.Destroy;

END Lists.
