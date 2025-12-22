{AutoRunner is the creation of Jon Maxwell. It can be freely distributed,
 following the rules written in the main documentation}

PROGRAM AutoRunner (Input,output);
{Includes for PCQ Pascal, by Patrick Quaid}
{$I "Include:Intuition/Intuition.i"}
{$I "Include:Exec/Ports.i"}
{$I "Include:Exec/Lists.i"}
{$I "Include:Libraries/DOS.i"}
{$I "Include:Utils/StringLib.i"}  {Includes for PCQ Pascal, by Patrick Quaid}
{$I "Include:Utils/DOSUtils.i"}
{$I "Include:Exec/Devices.i"}
{$I "Include:Exec/IO.i"}
{$I "Include:Exec/Tasks.i"}
{$I "Include:Devices/Trackdisk.i"}
CONST
{Gadgets, obviously}
  Gad5:Gadget=( nil,25,0,180,10,GADGHNONE,0,WDRAGGING,nil,nil,nil,0,nil,-1,nil);
  Gad4Text:IntuiText=(1,0,JAM1,0,1,nil,"3",nil);
  Gad4:Gadget=( nil,230,0,10,10,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET,nil,nil,@Gad4Text,0,nil,3,nil);
  Gad3Text:IntuiText=(1,0,JAM1,0,1,nil,"2",nil);
  Gad3:Gadget=(@Gad4,220,0,10,10,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET,nil,nil,@Gad3Text,0,nil,2,nil);
  Gad2Text:IntuiText=(1,0,JAM1,0,1,nil,"1",nil);
  Gad2:Gadget=(@Gad3,210,0,10,10,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET,nil,nil,@Gad2Text,0,nil,1,nil);
  Gad1Text:IntuiText=(1,0,JAM1,0,1,nil,"0",nil);
  Gad1:Gadget=(@Gad2,200,0,10,10,GADGHCOMP,GADGIMMEDIATE,BOOLGADGET,nil,nil,@Gad1Text,0,nil,0,nil);
VAR
  TempAddr:Address;

  I:boolean;
  Loop:Integer;
  Wind:WindowPtr;
  DiskValue:Array [0..3] OF Integer;  {Stores Old Disk ID so they won't be researched automatically}
CONST
  Unit2Check:Array [0..3] OF Boolean=(TRUE,TRUE,FALSE,FALSE); {Which drives should be checked, default}
  OnlyOnce:Boolean=FALSE; {Check startup drives and then quit if True}
  CDFlag:Boolean=TRUE;   {CD to inserted disk?}
  StartCheck:Boolean=TRUE;{Check drives on startup?}
  MaxUnit=3; {Largest unit number}
  StdInName  : String = "CON:0/0/1/1/AutoRunnerCLI"; {1 Pixel CLI if no input/output}
  StdOutName : String = StdInName;
  AwakeStr="Auto Runner: Awake         ";
  Sleeping="Auto Runner: Sleeping      ";
  UnitNames:Array [0..3] Of String=("DF0:","DF1:","DF2:","DF3:");
{----------------------}
PROCEDURE MakeUnit2CheckList;
VAR {reads passed param for units and flags}
  Num,
  Loop:Integer;
BEGIN
  FOR Loop:=0 TO 3 DO Unit2Check[Loop]:=FALSE;
  FOR Loop:=0 TO strlen(CommandLine) DO BEGIN
   CommandLine[Loop]:=ToUpper(CommandLine[Loop]);
   Num:=ord(CommandLine[Loop])-ord('0');
   IF (Num>-1) AND (Num<(MaxUnit+1)) THEN Unit2Check[Num]:=TRUE;
   IF CommandLine[Loop]='C' THEN CDFlag:=FALSE;
   IF CommandLine[Loop]='S' THEN StartCheck:=FALSE;
   IF CommandLine[Loop]='O' THEN OnlyOnce:=TRUE;
  END;
END;
{----------------------}
PROCEDURE OpenTheWindow;
{Old OpenTheWindow used WITH .. BEGIN to assign values to a NwPtr, but
 that meant that the info must be in the program code anyway! This way,
 using a Constant, it saves program space (around 260 bytes) and saves
 time because everything is setup at compilation! }
CONST
  Nw:NewWindow=(0,10,300,10,1,0,MENUPICK_f+CLOSEWINDOW_f+GADGETDOWN_f+DISKINSERTED_f+ACTIVEWINDOW_f,WINDOWDEPTH+WINDOWCLOSE,nil,nil,AwakeStr,nil,nil,1,1,1023,1023,WBENCHSCREEN_f);
BEGIN
  Wind:=OpenWindow(@Nw);
  IF Wind=nil THEN Exit(0);
END;
{----------------------}
PROCEDURE LoadMenu (DriveNum:integer); {Loads and execute()'s the comments}
VAR
  I:Integer;
  FL:FileLock;
  OldDir:FileLock;  {In case you have CDFlag set, this stores the startup-dir}
  FIB:FileInfoBlockPtr;
  TempChar:Char;
  NotDirEnd:Boolean; {Last item in the dir?}
  OldCDFlag:Boolean; {Just stores default CD flag setting temporarily}
TYPE
  CommentBlock=RECORD {A Comment Block is New()ed when a comment is found--Dynamic allocation!}
    NextBlock:^CommentBlock;
    Comment:ARRAY [0..79] OF Char;
    Flags:Integer;
  END;
  CommentPtr=^CommentBlock;
VAR
  TempComment:CommentPtr; {These three keep track of the Comments found}
  Base:CommentPtr;
  CurComment:CommentPtr;
BEGIN
{This is a mess, but it works...}
{OUTLINE of this routine:
  I.  Get root dir file lock
  II. Look through all the Comments
    A. Examine()
    B. Autorunner Comment?
        1. Allocate New CommentBlock
        2. Fill in Current CommentBlock^.Next
  III. Execute() Comments!
}

  Base:=nil;
  new(FIB); NotDirEnd:=TRUE;
  FL:=Lock(UnitNames[DriveNum],SHARED_LOCK);
  IF FL=nil THEN BEGIN writeln("Can't get a (shared) lock on ",UnitNames[DriveNum],"!"); Return; END;
  IF NOT Examine(FL,FIB) THEN BEGIN unlock(FL); Dispose(FIB); Return; END;
  REPEAT
   IF (FIB^.fib_Comment[0]='¿') OR (FIB^.fib_Comment[0]='¡') THEN BEGIN
    TempComment:=CurComment;
    new(CurComment); IF Base=nil THEN Base:=CurComment;
    TempComment^.NextBlock:=CurComment;
    writeln(String(adr(FIB^.fib_Comment[1])));
    FOR I:=0 TO 79 DO CurComment^.Comment[I]:=FIB^.fib_Comment[I];
   END;
   NotDirEnd:=ExNext(FL,FIB);
  UNTIL NotDirEnd=FALSE;
  CurComment:=Base;
  IF CurComment<>nil THEN
   REPEAT
     OldCDFlag:=CDFlag;
     IF CurComment^.Comment[0]='¡' THEN BEGIN
      IF CurComment^.Comment[1]='C' THEN CDFlag:=TRUE;
      IF CurComment^.Comment[1]='c' THEN CDFlag:=FALSE;
     END;
     IF CDFlag THEN OldDir:=CurrentDir(FL);
     IF CurComment^.Comment[0]='¿' THEN IF Execute(String(@CurComment^.Comment[1]),FileHandle(nil),GetFileHandle(Output)) THEN;
     IF CurComment^.Comment[0]='¡' THEN IF Execute(String(@CurComment^.Comment[2]),FileHandle(nil),GetFileHandle(Output)) THEN;
     IF CDFlag=TRUE THEN FL:=CurrentDir(OldDir);
     CDFlag:=OldCDFlag;
     TempComment:=CurComment;
     CurComment:=CurComment^.NextBlock;
     dispose(TempComment);
   UNTIL CurComment=nil;
  CurComment:=nil; {PCQ Pascal will still try to Dispose() sometimes -> Guru}
  UnLock(FL);
  Dispose(FIB);
END;
{----------------------}
FUNCTION DiskInDrive (UnitNum:Integer):Boolean;
VAR
 io:IOStdReqPtr;
 MPort:MsgPortPtr; {for when trackdisk is done with the IO}
 Error:Integer;
BEGIN
  new(io);
  new(MPort);
  newlist(adr(MPort^.mp_MsgList));
  MPort^.mp_Flags:=PASignal;       { \               }
  MPort^.mp_SigTask:=FindTask(nil);  {  =Sets up Message port}
  MPort^.mp_SigBit:=1;           { /               }
  io^.io_Message.mn_ReplyPort:=MPort;      { \sets up IO_messsage}
  io^.io_Message.mn_Length:=sizeof(IOStdReq); { /structure with stuff}

  {Error is a placeholder after the opendevice check, becuase I don't test for errors after!}
  Error:=OpenDevice("trackdisk.device",UnitNum,io,0);
  IF Error<>0 THEN BEGIN writeln("Can't open unit: ",UnitNum); DiskInDrive:=FALSE; END;
  io^.io_Command:=TD_CHANGESTATE;
  Error:=DoIO(io);
  Error:=WaitIO(io); {DoIO should wait, but perhaps it might mess up... :) }
  Error:=io^.io_Actual; {Error now tells whether a disk is in the unit}
  CloseDevice(io);
  dispose(io);  { \releases memory-> less likely}
  dispose(MPort); { /to fragment memory}
  IF Error=0 THEN DiskInDrive:=TRUE;
  DiskInDrive:=FALSE;
END;
{----------------------}
FUNCTION VNode(FL:FileLock):integer;
{Returns an ID for the disk}
{ (I know that there is something in the system to do this reliably,}
{ but I don't know how to find it yet) }

{PROBLEM: Simply takes the hash of the first two filenames -- I couldn't
 figure out how to get the Disk ID, whereever or whatever that is, but
 this works well enough... The Disk ID doesn't play a vital role anyway}
VAR
  VolNode:integer;
  ID:InfoDataPtr;
  FIB:FileInfoBlockPtr;
BEGIN
  new(ID);
  new(FIB);
  IF Examine(FL,FIB) THEN BEGIN
    VolNode:=hash(string(adr(FIB^.fib_FileName[0])));
    IF ExNext(FL,FIB) THEN VolNode:=VolNode+hash(string(adr(FIB^.fib_FileName[0])));
    VNode:=VolNode;
    END
  ELSE
    VNode:=0;
  dispose(ID);
  dispose(FIB);
END;
{----------------------}
FUNCTION FindDiskInserted:Integer;
{uses Disk IDs for the disks to find out which drive a disk was inserted in}
VAR
  FLock:FileLock;
  Loop:Integer;
BEGIN
  FOR Loop:=0 TO MaxUnit DO
  BEGIN
   IF (Unit2Check[Loop]=TRUE) AND (DiskInDrive(Loop)) THEN BEGIN
    FLock:=Lock(UnitNames[Loop],Access_Read);
    IF FLock=nil THEN BEGIN Writeln("Bad Lock!"); FindDiskInserted:=-1; END;
    IF (VNode(FLock)<>DiskValue[Loop]) THEN {Makes sure disk isn't last one that was in the unit}
                      BEGIN
                        DiskValue[Loop]:=VNode(FLock);
                        UnLock(FLock);
                        FindDiskInserted:=Loop;
                      END;
    UnLock(FLock);
   END;
  END;
  FindDiskInserted:=-1; {-1 cancels further action}
END;
{----------------------}
PROCEDURE GetDoMsg;
{Monitors window IDCMP port for gadget & diskinserted messages, and calls
 appropriate routines}
VAR
  Code,
  Qualifier:Short;
  MsgClass:Integer;
  IM:IntuiMessagePtr;
  Gad:GadgetPtr;
BEGIN
  WHILE 2=2 DO BEGIN
   IM:=IntuiMessagePtr(WaitPort(Wind^.UserPort));
   IM:=IntuiMessagePtr(GetMsg (Wind^.UserPort));
   MsgClass:=IM^.Class;
   Code:=IM^.Code;
   Qualifier:=IM^.Qualifier;
   Gad:=GadgetPtr(IM^.IAddress);
   ReplyMsg(MessagePtr(IM));
   IF (MsgClass=GADGETDOWN_f) OR (MsgClass=GADGETUP_f) THEN BEGIN
    IF DiskInDrive(Gad^.GadgetID) THEN LoadMenu(Gad^.GadgetID);
   END;
   IF (MsgClass=ACTIVEWINDOW_f) THEN
    RefreshGadgets(@Gad1,Wind,nil);
   IF MsgClass=DISKINSERTED_f THEN BEGIN
    Code:=FindDiskInserted;
    IF Code>-1 THEN LoadMenu(Code);
   END;
   IF MsgClass=MENUPICK_f THEN BEGIN
    SetWindowTitles(Wind,Sleeping,Sleeping);
    RefreshGadgets(@Gad1,Wind,nil);
    REPEAT
      IM:=IntuiMessagePtr(WaitPort(Wind^.UserPort));
      IM:=IntuiMessagePtr(GetMsg(Wind^.UserPort));
      MsgClass:=IM^.Class;
      ReplyMsg(MessagePtr(IM));
    UNTIL MsgClass=MENUPICK_f;
    SetWindowTitles(Wind,AwakeStr,AwakeStr);
    RefreshGadgets(@Gad1,Wind,nil);
   END;
   IF MsgClass=CLOSEWINDOW_f THEN BEGIN
    CloseWindow(Wind);
    Exit(0);
   END;
  END;
END;
{----------------------}
BEGIN
  Unit2Check[0]:=TRUE;  { \           }
  Unit2Check[1]:=TRUE;  { \ default drives  }
  Unit2Check[2]:=FALSE; { /to be checked &  }
  Unit2Check[3]:=FALSE; { /not to be checked }
  IF strlen(CommandLine)>1 THEN {Checks for CLI Param}
   IF CommandLine[0]='?' THEN BEGIN {TRUE=Print Below Info}
                           writeln("AutoRunner is copyright (©) 1991 by Jonathan Maxwell");
                           writeln("----------------------------------------------------");
                           writeln("USAGE: AutoRunner ####sco, Where #### are the units  ");
                           writeln("       to check and sco are the flags, in any order.");
                           writeln("FLAGS: S=doesn't check drives when started");
                           writeln("       C=doesn't auto-cd to inserted disk");
                           writeln("       O=checks drives when started and then");
                           writeln("         quits immediately");
                           writeln("COMMENT SYNTAX:");
                           writeln("       ¿command OR ¡<flag>command");
                           writeln("       ¿=SHIFT ALT m (or ALT M)");
                           writeln("       ¡=ALT i");
                           writeln("       <flag>=C for forced CD (overrides command line)");
                           writeln("       <flag>=c for forced NO-CD mode");
                           Exit(0);
                          END
                        {FALSE=get units to check and flags}
                      ELSE MakeUnit2CheckList;
  IF OnlyOnce=FALSE THEN BEGIN
   OpenTheWindow;
   ClearMenuStrip(Wind); {Does this do anything here? I think not...}
   Loop:=AddGList(Wind,@Gad1,1,4,nil); {Add the 4 device re-check gadgets}
   Loop:=AddGadget(Wind,@Gad5,1);
   RefreshGadgets(@Gad1,Wind,nil);{Make the gadgets visable}
  END;
  IF StartCheck=TRUE THEN {Following checks all set units unless flag was turned off}
   FOR Loop:=0 TO MaxUnit DO BEGIN
    IF Unit2Check[Loop]=TRUE THEN BEGIN
      I:=DiskInDrive(Loop); {Makes sure a disk is in the drive (avoids "No disk in unit #" message) }
      IF I THEN LoadMenu(Loop);
    END;
   END;
  IF OnlyOnce=FALSE THEN GetDoMsg; {Main Control Center}
END.
