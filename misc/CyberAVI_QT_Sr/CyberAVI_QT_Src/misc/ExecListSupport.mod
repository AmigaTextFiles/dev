MODULE  ExecListSupport;

(* /// ------------------------------- "IMPORT" -------------------------------- *)
IMPORT  e:=Exec,
        es:=ExecSupport;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------------- "TYPE" --------------------------------- *)
TYPE    Stack * =e.MinList;
        Queue * =e.MinList;

        FlushFunc * =PROCEDURE (n: e.CommonNodePtr);
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE Enqueue()" ------------------------- *)
PROCEDURE Enqueue * (VAR q: Queue;
                     n: e.CommonNodePtr);
BEGIN
  e.AddTail(q,n);
END Enqueue;
(* \\\ ------------------------------------------------------------------------- *)

(* /// ------------------------- "PROCEDURE Dequeue()" ------------------------- *)
PROCEDURE Dequeue * (VAR q: Queue): e.CommonNodePtr;
BEGIN
  IF ~es.ListEmpty(q) THEN
    RETURN e.RemHead(q);
  ELSE
    RETURN NIL;
  END;
END Dequeue;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE First()" -------------------------- *)
PROCEDURE First * (VAR q: Queue): e.CommonNodePtr;
BEGIN
  IF ~es.ListEmpty(q) THEN
    RETURN q.head;
  ELSE
    RETURN NIL;
  END;
END First;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Last()" --------------------------- *)
PROCEDURE Last * (VAR q: Queue): e.CommonNodePtr;
BEGIN
  IF ~es.ListEmpty(q) THEN
    RETURN q.tailPred;
  ELSE
    RETURN NIL;
  END;
END Last;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Push()" --------------------------- *)
PROCEDURE Push * (VAR s: Stack;
                  n: e.CommonNodePtr);
BEGIN
  e.AddHead(s,n);
END Push;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------- "PROCEDURE Pop()" --------------------------- *)
PROCEDURE Pop * (VAR s: Stack): e.CommonNodePtr;
BEGIN
  IF ~es.ListEmpty(s) THEN
    RETURN e.RemHead(s);
  ELSE
    RETURN NIL;
  END;
END Pop;
(* \\\ ------------------------------------------------------------------------- *)

(* /// --------------------------- "PROCEDURE Top()" --------------------------- *)
PROCEDURE Top * (VAR s: Stack): e.CommonNodePtr;
BEGIN
  IF ~es.ListEmpty(s) THEN
    RETURN s.head;
  ELSE
    RETURN NIL;
  END;
END Top;
(* \\\ ------------------------------------------------------------------------- *)

(* /// -------------------------- "PROCEDURE Flush()" -------------------------- *)
PROCEDURE Flush * (VAR q: Queue;
                   flushFunc: FlushFunc);

VAR     n: e.CommonNodePtr;

BEGIN
  WHILE ~es.ListEmpty(q) DO
    n:=e.RemHead(q);
    flushFunc(n);
  END;
END Flush;
(* \\\ ------------------------------------------------------------------------- *)

END ExecListSupport.

