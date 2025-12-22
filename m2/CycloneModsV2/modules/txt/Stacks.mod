IMPLEMENTATION MODULE Stacks;

FROM SYSTEM IMPORT ADDRESS;

PROCEDURE TStack.Pop():LONGINT;
VAR n:TStack;
    r:LONGINT;
BEGIN
 n:=Self^.next;
 IF n#NIL THEN
   Self^.next:=n^.next; r:=n^.val;
   DISPOSE(n);
 ELSE
  r:=0;
 END;
 RETURN r;
END Pop;

PROCEDURE TStack.Push(x:LONGINT);
VAR n:ADDRESS;
BEGIN
 n:=Self^.next;
 NEW(Self^.next); 
 Self^.next^.next:=n; 
 Self^.next^.val:=x;
END Push;

END Stacks.
