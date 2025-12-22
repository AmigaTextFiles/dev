{

   This is PCQUtils/PCQList.i

   An easy way to use linked list with strings for pcq.

   This functions handles only the data in ns_Node. If you
   use any of the other fields in PCQNode you have to take
   care of them yourself.

   Check out the demos on how to use this functions.

   Author: nils.sjoholm@mailbox.swipnet.se  (Nils Sjoholm)
}


{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/Nodes.i"}

TYPE
    PCQNodePtr = ^PCQNode;
    PCQNode = RECORD
       ns_Node      : Node;       { Private don't touch    }
       ns_Name1     : STRING;     { If you use this fields }
       ns_Name2     : STRING;     { don't forget to free   }
       ns_UserFlag1 : BOOLEAN;    { any memory you have    }
       ns_UserFlag2 : BOOLEAN;    { allocated.             }
       ns_UserFlag3 : BOOLEAN;    { For an example check   }
       ns_User1     : INTEGER;    { DirDemo.p              }
       ns_User2     : INTEGER;
       ns_User3     : INTEGER;
       ns_User4     : INTEGER;
       ns_User5     : INTEGER;
    END;

{
    AddNewNode allocates memory for Str and copies Str to that
    memory. It sets the other fields to NIL, False and 0.
    The node is at the end of the list.
}
FUNCTION AddNewNode(VAR pcqlist : ListPtr; Str : STRING): PCQNodePtr;
EXTERNAL;

{
    Clears the list from all nodes, deallocating all memory.
    If you have used some of the ns_NameX you have to deallocate
    that memory first or that memory will be lost.
    The list is still valid.
}
PROCEDURE ClearList(VAR pcqlist : ListPtr);
EXTERNAL;

{
    Makes a copy of pcqlist. It will only copy the values in
    ns_Node. The rest is up to you.
}
FUNCTION CopyList(pcqlist : ListPtr): ListPtr;
EXTERNAL;

{
    Initialize and creates a list.
}
PROCEDURE CreateList(VAR pcqlist : ListPtr);
EXTERNAL;

{
    Deletes the node from the active list. You have to remove the ns_NameXs
    first if you have used them.
}
PROCEDURE DeleteNode(ANode : PCQNodePtr);
EXTERNAL;

{
    Deletes all nodes and deallocates the list. Remove ns_NameX first
    cause the list will be set to NIL. You can't use the list anymore.
    If you want to use it again you have to use CreateList again.
}
PROCEDURE DestroyList(VAR pcqlist : ListPtr);
EXTERNAL;

{
    Search the list for data, if found returns the node else the
    node is set to NIL.
}
FUNCTION FindNodeData(pcqlist : ListPtr; data : STRING): PCQNodePtr;
EXTERNAL;

{
    Gives you the first node in the list. If the list is empty the
    node is NIL.
}
FUNCTION GetFirstNode(pcqlist : ListPtr): PCQNodePtr;
EXTERNAL;

{
    Gives you the next node.:)
}
FUNCTION GetNextNode( ANode : PCQNodePtr): PCQNodePtr;
EXTERNAL;

FUNCTION GetPrevNode( ANode : PCQNodePtr): PCQNodePtr;
EXTERNAL;

{
    The last node in the list.
}
FUNCTION GetLastNode(pcqlist : ListPtr): PCQNodePtr;
EXTERNAL;

{
    Returns the data in Anode.
}
FUNCTION GetNodeData(Anode : PCQNodePtr): STRING;
EXTERNAL;

FUNCTION GetNodeNumber(pcqlist : ListPtr; num : Integer): PCQNodePtr;
EXTERNAL;

{
    Inserts data in the list after Anode, it will allocate all memory
    it needs.
}
FUNCTION InsertNewNode(VAR pcqlist : ListPtr; data : STRING; Anode : PCQNodePtr): BOOLEAN;
EXTERNAL;

{
    This one will copy all data to a stringbuffer. You have to allocate
    the memory for buf yourself. The datas will be separated with a semicolon.
    To check the memory you need use SizeOfList.
}
PROCEDURE ListToBuffer(pcqlist : ListPtr; VAR buf : STRING);
EXTERNAL;

{
    Merges two lists to a single one.
    The return list is created by this function.
}
FUNCTION MergeLists(firstlist , secondlist : ListPtr): ListPtr;
EXTERNAL;

PROCEDURE MoveNodeBottom(VAR pcqlist: ListPtr; ANode : PCQNodePtr);
EXTERNAL;

PROCEDURE MoveNodeDown(VAR pcqlist : ListPtr; ANode : PCQNodePtr);
EXTERNAL;

PROCEDURE MoveNodeTop(VAR pcqlist: ListPtr; ANode : PCQNodePtr);
EXTERNAL;

PROCEDURE MoveNodeUp(VAR pcqlist : ListPtr; ANode : PCQNodePtr);
EXTERNAL;

{
    Returns number of nodes in list.
}
FUNCTION NodesInList(pcqlist :  ListPtr): INTEGER;
EXTERNAL;

{
    Just writes the nodedata to stdout.
}
PROCEDURE PrintList(pcqlist : ListPtr);
EXTERNAL;

{
    Removes any duplicates in the list.
}
PROCEDURE RemoveDupNode(VAR pcqlist : ListPtr);
EXTERNAL;

PROCEDURE RemoveLastNode(VAR pcqlist : ListPtr);
EXTERNAL;

{
    Gives you the size needed to copy the nodedata to a
    stringbuffer.
}
FUNCTION SizeOfList(pcqlist : ListPtr): INTEGER;
EXTERNAL;

PROCEDURE SortList(VAR pcqlist: ListPtr);
EXTERNAL;

{
    Replace the data in Anode with data. It reallocate the
    memory if it has to.
}
FUNCTION UpDateNode(ANode : PCQNodePtr; data : STRING): BOOLEAN;
EXTERNAL;

{
    Saves a list to TheFile, if something goes wrong (no nodes
    in list) or it can't create thefile it returns false.
}
FUNCTION ListToFile(TheFile : STRING; PcqList : ListPtr): BOOLEAN;
EXTERNAL;

{
    Loads thefile into thelist, if anything goes wrong returns
    false. Uses a buffer of 500 chars to read the lines. Nothing
    bad will happen with longer lines but the line will be
    truncated. Removes the linefeed.

    If you need a larger buffer, increase the buffer and compile
    this source and link with it before pcq.lib.
}

(***

EXTERNAL;

{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/Nodes.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:Dos/Dos.i"}

TYPE
    PCQNodePtr = ^PCQNode;
    PCQNode = RECORD
       ns_Node  : Node;
       ns_Name1 : STRING;
       ns_Name2 : STRING;
       ns_UserFlag1 : BOOLEAN;
       ns_UserFlag2 : BOOLEAN;
       ns_UserFlag3 : BOOLEAN;
       ns_User1     : INTEGER;
       ns_User2     : INTEGER;
       ns_User3     : INTEGER;
       ns_User4     : INTEGER;
       ns_User5     : INTEGER;
    END;

FUNCTION AddNewNode(VAR pcqlist : ListPtr; Str : STRING): PCQNodePtr;
EXTERNAL;

FUNCTION FileToList(thefile : STRING;
                        VAR thelist : ListPtr): BOOLEAN;
VAR
   fh : FileHandle;
   tempnode : PCQNodePtr;
   buffer : STRING;

BEGIN
   buffer := AllocString(500);
   fh := DOSOpen(thefile,MODE_OLDFILE);
   IF fh <> NIL THEN BEGIN
      WHILE FGets(fh,buffer,500-1) <> NIL DO BEGIN
        buffer[StrLen(buffer)-1] := '\0';
        tempnode := AddNewNode(thelist,buffer);
      END;
      DOSCLose(fh);
      FileToList := True;
   END ELSE BEGIN
      FileToList := FALSE;
   END;
END;

***)

FUNCTION FileToList(thefile : STRING;
                        VAR thelist : ListPtr): BOOLEAN;
EXTERNAL;















