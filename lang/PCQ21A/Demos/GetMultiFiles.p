program asltest;

{$I "Include:PCQUtils/EasyAsl.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Utils/Stringlib.i"}
{$I "Include:PCQUtils/PCQList.i"}
{$I "Include:PCQUtils/FileUtils.i"}
{$I "Include:PCQUtils/PCQOpenLib.i"}

VAR

  pdummy   : array [0..108] of char;

  path     : string;
  fname    : string;
  dummy    : boolean;

  myfont   : PCQFontInfo;
  mylist   : ListPtr;
  mynode   : PCQNodePtr;
  i,temp   : integer;

begin
  PCQOpenLib(AslBase,"asl.library",37);

  path := @pdummy;
  CreateList(mylist);
  StrCpy(path,"sys:");
  dummy := GetMultiAsl("test of getmulti",path,mylist,nil,nil);
  If dummy then begin
      writeln("number of files picked ",NodesInList(mylist));
      PrintList(mylist);
      write("\nPress Return\n");
      readln;

      mynode := GetFirstNode(mylist);
      FOR temp := 1 TO NodesInList(mylist) DO BEGIN
         writeln(PathAndFile(path,GetNodeData(mynode)));
         mynode := GetNextNode(mynode);
      END;
  end else writeln("You didn't pick any files");
  DestroyList(mylist);
END.


