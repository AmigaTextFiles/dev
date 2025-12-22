{GE_AVL.i AVL trees routines}
{$I "Include:Utils/GE_Hooks.i"}
{$I "Include:Exec/Memory.i"}

Type

{AVL Node structure for AVL trees}
 AVLNode = Record
	an_key: Integer;
	an_parent: ^AVLNode;
	an_Left: ^AVLNode; {Smaller}
	an_Right: ^AVLNode; {Greater}
	an_Balance: Short;
	an_pad1: Short; {Reserved}
 end;

 AVLNodePtr = ^AVLNode;

Function GE_AVLMax(Tree:^AVLNodePtr):AVLNodePtr;
External;

Function GE_AVLMin(Tree:^AVLNodePtr):AVLNodePtr;
External;

Function GE_AVLFind(Tree:^AVLNodePtr; Key:Integer; SHook:Address):AVLNodePtr;
External;

Function GE_AVLRLeft(Parent,Child:AVLNodePtr):Short;
External;

Function GE_AVLRRight(Parent,Child:AVLNodePtr):Short;
External;


Function GE_AVLRLeftR(Parent,Child:AVLNodePtr):Short;
External;

Function GE_AVLRRightL(Parent,Child:AVLNodePtr):Short;
External;

Function GE_AVLInsert(Tree:^AVLNodePtr; Key:Integer; IHook:Address):AVLNodePtr;
External;

Function GE_AVLRemove(Tree:^AVLNodePtr; Key:Integer; RHook:Address):Boolean;
External;


{ Hook function (Hook structure MUST be created by task)}

Function GE_AVLTest(H:HookPtr;Obj:AVLNodePtr;Msg:^Integer):Integer;

Begin
 GE_AVLTest:= AVLNodePtr(Obj)^.an_Key-Msg^;
end;

