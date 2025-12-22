PROGRAM test;

{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/Nodes.i"}
{$I "Include:Utils/StringLib.i"}
{$I "Include:PCQUtils/PCQList.i"}

    VAR

    Mylist   : ListPtr;
    MyNode   : PCQNodePtr;
    i        : INTEGER;
    dumm     : BOOLEAN;
    dummy    : PCQNodePtr;
    temp     : INTEGER;
    buffer   : STRING;
    bufsize  : INTEGER;
    templist : ListPtr;


BEGIN
    CreateList(Mylist);

    dummy := AddNewNode(Mylist,"Monday");
    dummy := AddNewNode(Mylist,"Tuesday");
    dummy := AddNewNode(Mylist,"Wednesday");
    dummy := AddNewNode(Mylist,"Thursday");
    dummy := AddNewNode(Mylist,"Friday");
    dummy := AddNewNode(Mylist,"Saterday");
    dummy := AddNewNode(Mylist,"Sunday");

    writeln;
    WriteLN("This is the list");
    PrintList(Mylist);

    writeln;
    WriteLN("Now we are going to remove the last node");
    WriteLN(">> Press return");
    readln;
    RemoveLastNode(Mylist);
    PrintList(Mylist);
    writeln;

    WriteLN(">> Press return to get the size of the list");
    writeln;
    readln;
    WriteLN("The size of allocated list is ", SizeOfList(Mylist));
    writeln;

    writeln("Now we are going to print all strings \nin the list with the internal commands");
    WriteLN(">> Press return");
    readln;

    i := NodesInList(Mylist);
    MyNode := GetFirstNode(Mylist);
    FOR temp := 1 TO i DO BEGIN
        WriteLN(MyNode^.ns_Node.ln_Name);
        MyNode := GetNextNode(MyNode);
    END;

    writeln;
    WriteLN("We will move the last node to the top");
    WriteLN(">> Press return");
    readln;
    MyNode := GetLastNode(Mylist);
    MoveNodeTop(Mylist,MyNode);
    PrintList(Mylist);
    writeln;

    WriteLN("We shall change the value in one node");
    WriteLN(">> Press return");
    readln;
    MyNode := GetFirstNode(Mylist);
    MyNode := GetNextNode(MyNode);
    dumm := UpDateNode(MyNode,"This is the new day");
    PrintList(Mylist);
    writeln;

    MyNode := GetNextNode(MyNode);
    WriteLN("Now we delete one node");
    WriteLN(">> Press return");
    readln;
    WriteLN("This node is going to be deleted ",GetNodeData(MyNode));
    DeleteNode(MyNode);
    PrintList(Mylist);

    writeln;
    WriteLN("Sort the list");
    WriteLN(">> Press return");
    readln;
    SortList(Mylist);
    PrintList(Mylist);

    writeln;
    writeln("Search for a node, in this case Friday");
    WriteLN(">> Press return");
    readln;
    MyNode := FindNodeData(Mylist,"Friday");
    IF MyNode <> NIL THEN BEGIN
        WriteLN("found the node ",MyNode^.ns_Node.ln_Name);
        { or writeln("found the node ",GetNodeData(MyNode));  }
    END ELSE BEGIN
        WriteLN("Node not found");
    END;

    writeln;
    WriteLN("And now copy the list to a stringbuffer\nand print it");
    WriteLN(">> Press return");
    readln;
    bufsize := SizeOfList(Mylist);
    buffer := AllocString(bufsize);
    ListToBuffer(Mylist,buffer);
    WriteLN(buffer);

    writeln;
    WriteLN("Now we try to copy the list to a new list");
    WriteLN(">> Press return");
    readln;
    templist := CopyList(Mylist);
    IF templist <> NIL THEN BEGIN
        WriteLN("That went well, the new list is here");
        PrintList(templist);
        DestroyList(templist);
    END ELSE BEGIN
        WriteLN("no copy of list");
    END;

    writeln;
    WriteLN("Press return to destroy the list");
    readln;
    DestroyList(Mylist);
    writeln;
    WriteLN("All done");
END.




