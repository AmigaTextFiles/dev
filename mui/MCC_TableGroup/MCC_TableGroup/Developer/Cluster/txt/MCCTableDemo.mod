|##########|
|#MAGIC   #|BIEIOJDC
|#PROJECT #|"MCCTableDemo"
|#PATHS   #|"StdProject"
|#LINK    #|""
|#GUIDE   #|""
|#STACK   #|"4096"
|#FLAGS   #|xx---x--xxx-xxx-----------------
|#USERSW  #|--------------------------------
|#USERMASK#|--------------------------------
|#SWITCHES#|xx---xxxxx-xx---
|##########|

(*
**   Cluster Source Code for the MCCTableGroup Demo Program
**   ------------------------------------------------------
**
**           written 1998 by Henning Thielemann
**
*)

MODULE MCCTableDemo;

FROM System        AS y   IMPORT SysStringPtr;
FROM MuiO                 IMPORT All;
FROM MuiOSimple           IMPORT All;
FROM Exec                 IMPORT TaskSigSet, Wait;
FROM MCCTableGroup AS tbl IMPORT All;
FROM T_Intuition          IMPORT WindowNotOpen;

PROCEDURE MakeButton (REF text : STRING; vw, hw : LONGCARD := 100) : AreaObject;
BEGIN
  RETURN MakeTextObject (ButtonFrame,
                         textContents : text.data'PTR,
                         textSetVMax  : false,
                         textPreParse : xC,
                         inputMode    : relVerify,
                         horizWeight  : hw,
                         vertWeight   : vw,
                         DONE);
END MakeButton;

PROCEDURE MakeSimpleImage (img : StandardImages; vw, hw : LONGCARD := 100) : AreaObject;
BEGIN
  RETURN MakeImageObject     (ButtonFrame,
                              imageSpec      : img,
                              inputMode      : relVerify,
                              imageFreeVert  : true,
                              imageFreeHoriz : true,
                              horizWeight    : hw,
                              vertWeight     : vw,
                              DONE);
END MakeSimpleImage;

VAR
  app     : ApplicationObject;
  win     : WindowObject;
  grp     : GroupObject;
  but     : AreaObject;

  signal  : TaskSigSet;

BEGIN
  grp := MakeTableGroupObject (
    frameTitle : "Table group",
    CAST (TableGroupTags, GroupFrame),
    tableColumns      : 8,
    tableColumn       : 4,
    tableColumnSpace  : 1,
    tableColumn       : 1,
    tableColumnWeight : 50,   | this can also be done within the following groupChild tags
    tableSkipColumns  : 1,
    tableColumnWeight : 50,
    tableColumn       : 0,
    tableColumnSpan   : 2,
    groupChild        : MakeButton ("Del"),
    tableColumnSpan   : 2,
    groupChild        : MakeButton ("Help"),
    groupChild        : MakeButton ("{"* ),
    groupChild        : MakeButton ("}"* ),
    groupChild        : MakeButton ("/"* ),
    groupChild        : MakeButton ("*"* ),
    tableNextColumn   : 4,
    groupChild        : MakeButton ("7"* ),
    groupChild        : MakeButton ("8"* ),
    groupChild        : MakeButton ("9"* ),
    groupChild        : MakeButton ("-"* ),
    tableNextColumn   : 1,
    tableColumnSpan   : 2,
    groupChild        : MakeSimpleImage (arrowUp),
    tableNextColumn   : 4,
    groupChild        : MakeButton ("4"* ),
    groupChild        : MakeButton ("5"* ),
    groupChild        : MakeButton ("6"* ),
    groupChild        : MakeButton ("+"* ),
    groupChild        : MakeSimpleImage (arrowLeft),
    tableColumnSpan   : 2,
    groupChild        : MakeSimpleImage (arrowDown),
    groupChild        : MakeSimpleImage (arrowRight),
    groupChild        : MakeButton ("1"* ),
    groupChild        : MakeButton ("2"* ),
    groupChild        : MakeButton ("3"* ),
    tableRowSpan      : 2,
    groupChild        : MakeButton ("E"+&10+"n"+&10+"t"+&10+"e"+&10+"r"),
    tableNextColumn   : 4,
    tableColumnSpan   : 2,
    groupChild        : MakeButton ("0"* ),
    groupChild        : MakeButton ("."* ),
  DONE);

  | in this way you can add child objects later
  SetTableAttrs (grp,
    tableRowSpace     : 1,
    groupChild        : MakeButton ("Alt"),
    tableColumnSpan   : 2,
    groupChild        : MakeButton ("Amiga"),
    tableColumnSpan   : 3,
    groupChild        : MakeButton (" "* ),
    groupChild        : MakeButton ("Amiga"),
    groupChild        : MakeButton ("Alt"),
  DONE);

  win :=
    MakeWindowObject (
      windowTitle      : "TableGroup.mcc demo",
      windowIDChar     : "Main".data,
      windowRootObject : grp,
    DONE);

  app :=
    MakeApplicationObject (
      applicationTitle         : "MCCTableGroup-Demo",
      applicationVersion       : "$VER: MCCTableGroup-Demo 1.0 (07.01.98)",
      applicationCopyright     : "Copyright ©1998, Henning Thielemann",
      applicationAuthor        : "Henning Thielemann",
      applicationDescription   : "Demonstrates the features of TableGroup.mcc",
      applicationBase          : "TABLEGROUPDEMO",

      applicationWindow        : win,
    DONE);

  AssertMuiError (app # NIL);

  win.Notify (MuiTags : windowCloseRequest : true, notifyApplication, LONGINT (mApplicationReturnID), applicationReturnIDQuit);
  win.Set (MuiTags : windowOpen : true);
  ASSERT (0 # win.GetA (MuiTags : windowOpen : true), WindowNotOpen);

  signal := {};
  WHILE app.NewInput (signal) NOT OF applicationReturnIDQuit DO
    IF signal NOT OF {} THEN signal := Wait(signal) END;
  END;

CLOSE
  IF app#NIL THEN DisposeObject (app) END;

END MCCTableDemo.
