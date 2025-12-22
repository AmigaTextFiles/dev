Unit DLList;
(*
 * dllist.pas
 *
 * Lee Kindness
 * May 1995
 *
 * Double linked list ADT
 *
 *)

INTERFACE

{$IfDef Amiga}
Uses
	Exec;
{$EndIf}

Const
	DATANONE = '';

Type
	tListData = String[10];
	{ a double linked node }
	pDLNode = ^tDLNode;
	tDLNode = Record
		dln_Succ,             { next  node }
		dln_Pred : pDLNode;   { previous node }
		dln_Data : tListData; { data }
	End;
	{ record containing the dummy head and tail nodes }
	pDLList = ^tDLList;
	tDLList = Record          { dummy head dummy tail             }
		dll_Head,               {  dln_Succ                         }
		dll_Tail,               {  dln_Pred   dln_Succ - ALWAYS NIL }
		dll_TailPred : pDLNode; {             dln_Pred              }
	End;

{ Subroutines to handle the list/nodes }
Function  dl_AllocList : pDLList;
Procedure dl_FreeList (VAR list : pDLList);
Function  dl_AllocNode : pDLNode;
Procedure dl_FreeNode (VAR node : pDLNode);
Procedure dl_FreeAllNode (list : pDLList);
Procedure dl_Insert (VAR list : pDLList; VAR node : pDLNode;
										 pred : pDLNode);
Procedure dl_Remove (VAR node : pDLNode);
Procedure dl_AddTail (VAR list : pDLList; VAR node : pDLNode);
Function  dl_RemTail (VAR list : pDLList) : pDLNode;
Procedure dl_AddHead (VAR list : pDLList; VAR node : pDLNode);
Function  dl_RemHead (VAR list : pDLList) : pDLNode;
Procedure dl_AddOrder (VAR list : pDLList; VAR node : pDLNode);
Function  dl_Head (list : pDLList) : pDLNode;
Function  dl_Tail (list : pDLList) : pDLNode;
Function  dl_Previous (node : pDLNode) : pDLNode;
Function  dl_Next (node : pDLNode) : pDLNode;
Function  dl_Data (node : pDLNode) : tListData;
Procedure dl_SetData (VAR node : pDLNode; data : tListData);
Function  dl_NodeValid (node : pDLNode) : Boolean;
Function  dl_IsEmpty (list : pDLList) : Boolean;
Function  dl_Find (VAR list : pDLList; item : tListData) : pDLNode;
Function  dl_CopyList (list : pDLList) : pDLList;
Function  dl_Mem : LongInt;


IMPLEMENTATION

{ private variable to track memory allocation... }
Const
	mem : LongInt = 0;

{ Local Subroutines }

(***********************************************************)
{ Return number of bytes still allocated by dl_AllocMem }
Function dl_Mem;

Begin
	dl_mem := mem;
End;

(***********************************************************)
{ Internal memory allocation routine, NIL = failure }
Function dl_AllocMem(size : LongInt) : Pointer;

Var
	p : Pointer;

Begin
	{$IfDef Amiga}
	p := AllocMem(size, MEMF_CLEAR); { alloc mem. and init. }
	{$Else}
	GetMem(p, size); { alloc mem }
	FillChar(p^, size, 0); { init. }
	{$EndIf}
	{ track allocation }
	If p <> NIL Then
		inc(mem, size);
	dl_AllocMem := p;
End;

(***********************************************************)
{ Free mem allocated by dl_AllocMem }
Procedure dl_FreeMem(VAR p : Pointer; Size : LongInt);

Begin
	If p <> NIL Then Begin
		{$IfDef Amiga}
		FreeMem_(p, size);
		{$Else}
		FreeMem(p, size);
		{$EndIf}
		p := NIL;
		{ track deallocation }
		dec(mem, size);
	End;
End;

{ Global Subroutines }

(***********************************************************)
{ Alloc. and init. a list NIL = failure }
Function dl_AllocList;

Var
	p : pDLList;

Begin
	{ Alloc. mem. }
	p := dl_AllocMem(SizeOf(tDLList));
	If p <> NIL then Begin
		{ Initilise }
		With p^ Do Begin
			dll_Head := pDLNode(@dll_Tail);
			dll_Tail := NIL;
			dll_TailPred := pDLNode(@dll_Head)
		End;
	End;
	{ return }
	dl_AllocList := p;
End;

(***********************************************************)
{ Alloc. and init. a node, NIL = failure however other     }
{ routines will fail if node=NIL so checking is not needed }
Function dl_AllocNode : pDLNode;

Var
	p : pDLNode;

Begin
	dl_AllocNode := dl_AllocMem(SizeOf(tDLNode));
End;

(***********************************************************)
{ Return True if list is empty, list must be non-NIL }
Function dl_IsEmpty;

Begin
	dl_IsEmpty := (list^.dll_Head^.dln_Succ = NIL);
End;

(***********************************************************)
{ Add a node to the list, after pred         }
{ pred = NIL : add to head of list           }
{ pred = dl_Tail(list) : add to tail of list }
Procedure dl_Insert;

Var
	Succ : pDLNode;

Begin
	If Node <> NIL Then Begin
		If Pred = NIL Then
			Pred := pDLNode(list);
		Succ := pred^.dln_Succ;
		Pred^.dln_Succ := node;
		Succ^.dln_Pred := node;
		node^.dln_Pred := Pred;
		node^.dln_Succ := Succ;
	End;
End;

(***********************************************************)
{ Remove a node from the list }
Procedure dl_Remove;

Begin
	If node <> NIL Then Begin
		node^.dln_Pred^.dln_Succ := node^.dln_Succ;
		node^.dln_Succ^.dln_Pred := node^.dln_Pred;
	End;
End;

(***********************************************************)
{ Add a node to the head of the list }
Procedure dl_AddHead;

Begin
	dl_Insert(list, node, NIL);
End;

(***********************************************************)
{ add a node to the tail of the list }
Procedure dl_AddTail;

Begin
	dl_Insert(list, node, dl_Tail(list));
End;

(***********************************************************)
{ Remove all nodes from a list and free memory }
Procedure dl_FreeList;

Var
	node : pDLNode;
	
Begin
	If NOT dl_IsEmpty(list) Then Begin
		dl_FreeAllNode(list);
	End;
	dl_FreeMem(Pointer(list), SizeOf(tDLList));
End;

(***********************************************************)
{ Free all nodes in a list }
Procedure dl_FreeAllNode;

Var
	tmp, node : pDLNode;
	
Begin
	node := dl_Head(list);
	While dl_NodeValid(node) Do Begin
		tmp := dl_Next(node);
		dl_Remove(node);
		dl_FreeNode(node);
		node := tmp;
	End;
End;

(***********************************************************)
{ Free a node }
Procedure dl_FreeNode;

Begin
	dl_FreeMem(Pointer(node), SizeOf(tDLNode));
end;

(***********************************************************)
{ Remove and return the node at the head of the list }
Function dl_RemHead;

Var
	node : pDLNode;

Begin
	node := NIL;
	If NOT dl_IsEmpty(list) Then Begin
		node := dl_Head(list);
		dl_Remove(node);
	End;
	dl_RemHead := node;
End;

(***********************************************************)
{ Remove and return the node at the tail of the list }
Function dl_RemTail;

Var
	node : pDLNode;

Begin
	node := NIL;
	If NOT dl_IsEmpty(list) Then Begin
		node := dl_Tail(list);
		dl_Remove(node);
	End;
	dl_RemTail := node;
End;

(***********************************************************)
{ Find the FIRST matching node }
{ Use a sequential search      }
Function dl_Find;

Var
	node : pDLNode;
	notfound : Boolean;
	
Begin
	notfound := True;
	node := dl_Head(list);
	While (dl_NodeValid(node)) and (notfound) Do Begin
		notfound := dl_Data(node) <> item;
		node := dl_Next(node);
	End;
	{ if found then we have overshot our item by 1 node... }
	If NOT notfound Then
		node := dl_Previous(node)
	else
		node := NIL;
	dl_Find := node;
End;

(***********************************************************)
{ Return the next node }
Function dl_Next;

Begin
	dl_Next := NIL;
	If node <> NIL Then
		dl_Next := node^.dln_Succ;
End;

(***********************************************************)
{ Return the previous node }
Function dl_Previous;

Begin
	dl_Previous := NIL;
	If node <> NIL Then
		dl_Previous := node^.dln_Pred;
End;

(***********************************************************)
{ Return the data associated with the node }
Function dl_Data;

Begin
	If node <> NIL Then
		dl_Data := node^.dln_Data
	Else
		dl_Data := DATANONE;
End;

(***********************************************************)
{ Set dln_Data }
Procedure dl_SetData;

Begin
	If node <> NIL Then
		node^.dln_Data := data;
End;

(***********************************************************)
{ A valid node has non NIL pred/successors }
Function dl_NodeValid;

Begin
	dl_NodeValid := ((dl_Next(node) <> NIL) and 
	   (dl_Previous(node) <> NIL));
End;

(***********************************************************)
{ Return the head of the list }
Function dl_Head;

Begin
	dl_Head := list^.dll_Head;
End;

(***********************************************************)
{ Return the tail of the list }
Function dl_Tail;

Begin
	dl_Tail := list^.dll_TailPred;
End;

(***********************************************************)
{ Copy a list }
Function dl_CopyList;

Var
	list2 : pDLList;
	node, node2 : pDLNode;
	
Begin
	{ aloc8 }
	list2 := dl_AllocList;
	If list2 <> NIL Then Begin
		If NOT dl_IsEmpty(list) Then Begin
			{ copy the nodes... }
			node := dl_Head(list);
			While dl_NodeValid(node) Do Begin
				node2 := dl_AllocNode;
				If node2 <> NIL Then Begin
					node2^ := node^;
					{ add to tail of list }
					dl_AddTail(list2, node2);
				End;
				node := dl_Next(node);
			End;
		End;
	End;
	dl_CopyList := list2;
End;

(***********************************************************)
{ Add a node to the list in ascending order }
Procedure dl_AddOrder;

Var
	PosFound : Boolean;
	node2 : pDLNode;
	
Begin
	If Node <> NIL Then Begin
		If dl_IsEmpty(list) Then
			dl_AddHead(list, node)
		Else Begin
			PosFound := False;
			node2 := dl_Head(list);
			While ((dl_NodeValid(node2)) and (NOT PosFound)) Do Begin
				If dl_Data(node2) > dl_Data(node) Then
					PosFound := True
				Else
					node2 := dl_Next(node2);
			End;
			dl_Insert(list, node, dl_Previous(node2));
		End;
	End;
End;

(***********************************************************)

End { DLList }.