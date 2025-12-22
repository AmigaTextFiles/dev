IMPLEMENTATION MODULE Trees;

(* Copyright (C) 1996 by Marcel Timmermans *)

(* A example of a tree object *)

FROM SYSTEM IMPORT ADR,ADDRESS,BYTE,CAST;
IMPORT H:Heap;


PROCEDURE TTree.Compare(d:ADDRESS;node:NodePtr):INTEGER;
BEGIN
 RETURN 0;
END TTree.Compare;

PROCEDURE TTree.FindComp(d:ADDRESS;node:NodePtr):INTEGER;
BEGIN
 RETURN Compare(d,node);
END TTree.FindComp;

PROCEDURE TTree.DoProc(d:ADDRESS);
BEGIN
(*  Empty procedure *)
END TTree.DoProc;

PROCEDURE TTree.NewItem(d:ADDRESS):NodePtr;
VAR node:NodePtr;
BEGIN
(* io.WriteString('NewItem\n');*)
 H.Allocate(node,SIZE(Node));
 IF node#NIL THEN
  WITH node^ DO
   left:=NIL; right:=NIL; data:=d;
  END;
 END;
 RETURN node;
END TTree.NewItem;

PROCEDURE TTree.Remove(n:NodePtr):ADDRESS;
VAR d:ADDRESS;
BEGIN
 d:=NIL;
 IF n#NIL THEN
  d:=n^.data;
  H.Deallocate(n);
 END;
 RETURN d;
END TTree.Remove;

PROCEDURE TTree.Insert(n:NodePtr;d:ADDRESS):NodePtr;
BEGIN
(* io.WriteString('Insert\n');*)
 LOOP
  IF n=NIL THEN EXIT; END;
  IF (Compare(d,n)<0) THEN (* Element smaller *)
    IF n^.left=NIL THEN
       n^.left:=NewItem(d);
       EXIT;
    ELSE
      n:=n^.left;
    END;
  ELSE
    IF n^.right=NIL THEN
      n^.right:=NewItem(d);
      EXIT;
    ELSE
      n:=n^.right;
    END;
  END;
 END;
 RETURN n;
END TTree.Insert;

PROCEDURE TTree.Find(n:NodePtr;d:ADDRESS):NodePtr;
VAR s:INTEGER;
BEGIN
 s:=-1;
 WHILE (n#NIL) & (s#cmpEqual) DO
  s:=FindComp(d,n);
  IF s=cmpLess THEN n:=n^.left;
  ELSIF s=cmpMore THEN n:=n^.right;
  ELSE s:=cmpEqual; END;
 END;
 RETURN n;
END TTree.Find;

PROCEDURE TTree.Min(tree:NodePtr):NodePtr;
BEGIN
  WHILE (tree^.left#NIL) DO tree:=tree^.left; END;
  RETURN tree;
END TTree.Min;

PROCEDURE TTree.FindPred(head:NodePtr; d:ADDRESS; VAR Left:BOOLEAN):NodePtr;
BEGIN
 LOOP
  IF head=NIL THEN 
     EXIT; 
  ELSIF (head^.left#NIL) & (Compare(d,head^.left)=cmpEqual) THEN
     Left:=TRUE;
     EXIT;
  ELSIF (head^.right#NIL) & (Compare(d,head^.right)=cmpEqual) THEN
     Left:=FALSE;
     EXIT;
  ELSIF (Compare(d,head)=cmpLess) THEN
     head:=head^.left;
  ELSIF (Compare(d,head)=cmpMore) THEN
     head:=head^.right;
  END;    
 END;
 RETURN head;
END TTree.FindPred;

PROCEDURE TTree.Delete(n,del:NodePtr):NodePtr;
VAR 
 pred,new:NodePtr;
 Left:BOOLEAN;
 temp:POINTER TO NodePtr;
BEGIN
 IF (del#NIL) & (n#NIL) THEN
   pred:=FindPred(n,del^.data,Left);
   IF Left & (pred#NIL) THEN
     temp:=ADR(pred^.left);
   ELSIF (pred#NIL) THEN
     temp:=ADR(pred^.right);
   END;

   IF del^.left=NIL THEN
     IF (pred#NIL) THEN 
       temp^:=del^.right;
     ELSE
       n:=del^.right;
     END;
   ELSIF del^.right=NIL THEN
     IF (pred#NIL) THEN
       temp^:=del^.left;
     ELSE
       n:=del^.left;
     END;
   ELSE
     (*io.WriteString('New delete\n');*)
     new:=Min(del^.right);
     n:=Self^.Delete(n,new);
     IF (pred#NIL) THEN
       temp^:=new;
     ELSE
      n:=new;
     END;
     new^.left:=del^.left;
     new^.right:=del^.right;
   END;
 END;
 RETURN n;
END TTree.Delete;

PROCEDURE TTree.CountElements():LONGINT; 
  PROCEDURE CntElements(n:NodePtr):LONGINT;
  BEGIN
   IF n=NIL THEN 
     RETURN 0; 
   ELSE 
     RETURN CntElements(n^.left)+CntElements(n^.right)+1;
   END;
  END CntElements; 
BEGIN
 RETURN CntElements(root);
END TTree.CountElements;

PROCEDURE TTree.WalkTree(t:NodePtr);
 
  PROCEDURE WlkTree(n:NodePtr);
  BEGIN
   IF (n^.left#NIL) THEN WlkTree(n^.left); END;
   Self^.DoProc(n^.data);
   IF (n^.right#NIL) THEN WlkTree(n^.right); END;
  END WlkTree;

BEGIN
 IF t#NIL THEN WlkTree(t); END;
END TTree.WalkTree;

PROCEDURE TTree.FreeData(d:ADDRESS);
BEGIN
 (* emtpy method for freeing memory of the data *)
END TTree.FreeData;

PROCEDURE TTree.DestroyTree(VAR t:NodePtr);
VAR temp:NodePtr;
 
 PROCEDURE DelTree(n:NodePtr);
 BEGIN
  IF (n^.left#NIL) THEN DelTree(n^.left); END;
  Self^.FreeData(n^.data);
  temp:=n^.right;
  H.Deallocate(n);
  IF temp#NIL THEN DelTree(temp); END;
 END DelTree;

BEGIN
 IF t#NIL THEN DelTree(t); t:=NIL; END;
END TTree.DestroyTree;

BEGIN
END Trees.
