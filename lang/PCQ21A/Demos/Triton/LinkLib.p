PROGRAM LinkLib;


{$I "Include:EasyPCQ/Triton.i"}
{$I "Include:Macros/Tritonmacros.i"}
{$I "Include:Support/tritonsupport.i"}
{$I "Include:PCQUtils/PCQList.i"}
{$I "Include:PCQUtils/EasyAsl.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Utils/Stringlib.i"}
{$I "Include:PCQUtils/FileUtils.i"}
{$I "Include:PCQUtils/CStrings.i"}

VAR
     Project  : TR_ProjectPtr;
     mylist   : ListPtr;
     pdummy   : ARRAY [0..108] OF Char;
     path     : STRING;

const

    LibListGadID   = 1;
    AddGadID       = 2;
    RemoveGadID    = 3;
    RemAllGadID    = 4;
    UpGadID        = 5;
    DownGadID      = 6;
    OkButton       = 7;
    CancelButton   = 8;

PROCEDURE CleanExit(errstring : STRING; rc : Integer);
BEGIN
    IF Project <> NIL THEN TR_CloseProject(Project);
    TR_CloseTriton;
    IF mylist <> NIL THEN DestroyList(mylist);
    IF errstring <> NIL THEN WriteLn(errstring);
    Exit(rc)
END;

PROCEDURE disablegads;
VAR
   dummy : INTEGER;
BEGIN
   IF NodesInList(mylist) > 0 THEN dummy := 0
      ELSE dummy := 1;

   TR_SetAttribute(Project,RemoveGadID,TRAT_Disabled,dummy);
   TR_SetAttribute(Project,RemAllGadID,TRAT_Disabled,dummy);
   TR_SetAttribute(Project,UpGadID,TRAT_Disabled,dummy);
   TR_SetAttribute(Project,DownGadID,TRAT_Disabled,dummy);
END;

PROCEDURE readinlist;
VAR
   dummy : BOOLEAN;
   temp : PCQNodePtr;
BEGIN
   dummy := FileToList("ram:pcqlistoffiles",mylist);
   IF dummy THEN BEGIN
      temp := GetFirstNode(mylist);
      IF temp <> NIL THEN StrCpy(path,PathOf(GetNodeData(temp)));
      temp := GetLastNode(mylist);
      IF StrLen(GetNodeData(temp)) = 0 THEN RemoveLastNode(mylist);
   END;
END;

PROCEDURE addfiles;

VAR
  dummy    : BOOLEAN;
  flist   : ListPtr;
  mynode,tempnode   : PCQNodePtr;
  i,temp  : INTEGER;

BEGIN
  CreateList(flist);
  AslBase := OpenLibrary("asl.library",37);
  IF AslBase <> NIL THEN BEGIN
     dummy := GetMultiAsl("Pick a file or two :)",path,flist,NIL,NIL);
     IF dummy THEN BEGIN
        mynode := GetFirstNode(flist);
        FOR temp := 1 TO NodesInList(flist) DO BEGIN
           tempnode := AddNewNode(mylist,(PathAndFile(path,GetNodeData(mynode))));
           mynode := GetNextNode(mynode);
        END;
        TR_UpdateListView(Project,LibListGadID,mylist);
        TR_SetValue(Project,LibListGadID,0);
        disablegads;
     END;
     CloseLibrary(AslBase);
  END;
  DestroyList(flist);
END;

PROCEDURE removelib;
VAR
   num : INTEGER;
   mynode : PCQNodePtr;
   strbuf : ARRAY [0..255] OF Char;
   buffer : STRING;
   dummy : INTEGER;
BEGIN
   buffer := @strbuf;
   num := TR_GetValue(Project,LibListGadID);
   mynode := GetNodeNumber(mylist,num);
   sprintf(buffer,"Sure you want to delete\n%s",GetNodeData(mynode));
   dummy := TR_EasyRequestTags(Triton_App,buffer,"_Remove|_Cancel",
                                    TREZ_LockProject,Project,TREZ_Title,"Delete this file?",TREZ_Activate,True,TAG_END);
   IF dummy = 1 THEN BEGIN
      DeleteNode(mynode);
      TR_UpdateListView(Project,LibListGadID,mylist);
      TR_SetValue(Project,LibListGadID,0);
      disablegads;
   END;
END;

PROCEDURE removeall;
VAR
   dummy : INTEGER;
BEGIN
   dummy := TR_EasyRequestTags(Triton_App,"Sure you want to remove all files?","_Remove|_Cancel",
                                    TREZ_LockProject,Project,TREZ_Title,"Delete all?",TREZ_Activate,True,TAG_END);
   IF dummy = 1 THEN BEGIN
      ClearList(mylist);
      TR_UpdateListView(Project,LibListGadID,mylist);
      disablegads;
   END;
END;

PROCEDURE savethelist;
VAR
   dummy : BOOLEAN;
BEGIN
   dummy := ListToFile("Ram:pcqlistoffiles",mylist);
END;

PROCEDURE movedown;
VAR
   num : INTEGER;
   mynode : PCQNodePtr;
BEGIN
   num := TR_GetValue(project,LibListGadID);
   IF num < (NodesInList(mylist)-1) THEN BEGIN
      mynode := GetNodeNumber(mylist,num);
      IF mynode <> NIL THEN BEGIN
          MoveNodeDown(mylist,mynode);
          TR_UpdateListView(Project,LibListGadID,mylist);
          TR_SetValue(Project,LibListGadID,num + 1);
      END;
   END;
END;

PROCEDURE moveup;
VAR
   num : INTEGER;
   mynode : PCQNodePtr;
BEGIN
   num := TR_GetValue(project,LibListGadID);
   IF num > 0 THEN BEGIN
      mynode := GetNodeNumber(mylist,num);
      IF mynode <> NIL THEN BEGIN
          MoveNodeUp(mylist,mynode);
          TR_UpdateListView(Project,LibListGadID,mylist);
          TR_SetValue(Project,LibListGadID,num-1);
      END;
   END;
END;

PROCEDURE do_demo;
VAR
    close_me : BOOLEAN;
    trmsg : TR_MessagePtr;
    dummy : INTEGER;

BEGIN
    ProjectStart;
               WindowID(1);
               WindowPosition(TRWP_CENTERDISPLAY);
               WindowTitle("TritonListViewDemo in PCQ Pascal");
                  HorizGroupAC;
                     Space;
                     VertGroupAC;
                     Space;
                     NamedSeparator("List of files");
                        Space;
                        ListSSM(mylist,LibListGadID,0,0,25);
                        Space;
                     EndGroup;
                     Space;
                     VertSeparator;
                     Space;
                     SetTRTag(TRGR_Vert, TRGR_ALIGN OR TRGR_FIXHORIZ);
                        Space;
                        Button("_Add...",AddGadID);
                        SpaceS;
                        Button("_Remove...",RemoveGadID);
                        SpaceS;
                        Button("Re_move All...",RemAllGadID);
                        SpaceS;
                        Button("_Up",UpGadID);
                        SpaceS;
                        Button("_Down",DownGadID);
                        VertGroupS;Space;EndGroup;
                        Button("_Ok",OkButton);
                        SpaceS;
                        Button("_Cancel",CancelButton);
                        Space;
                     EndGroup;
                     Space;
                  EndGroup;
               EndProject;

    Project := TR_OpenProject(Triton_App,@tritontags);
    IF Project <> NIL THEN BEGIN
      disablegads;
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(Triton_App,0);
        REPEAT
          trmsg := TR_GetMsg(Triton_App);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = Project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : close_me := True;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
                 TRMS_ACTION :
                 BEGIN
                 CASE trmsg^.trm_ID OF
                   AddGadID : addfiles;
                   UpGadID : moveup;
                   DownGadID : movedown;
                   RemoveGadID : removelib;
                   RemAllGadID : removeall;
                   OkButton : BEGIN savethelist; close_me := True; END;
                   CancelButton : close_me := True;
                 END;
               END;
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END
        UNTIL close_me OR (trmsg = NIL);
      END;
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(Triton_App)));
END;


BEGIN  { Main }
    if TR_OpenTriton(TRITON20VERSION,
                     TRCA_Name,"Triton ListView Demo",
                     TRCA_LongName,"Demo of ListView in Triton, made in PCQ Pascal",
                     TRCA_Version,"0.01",
                     TRCA_Info,"Uses tritonsupport",
                     TRCA_Release,"1",
                     TRCA_Date,"03-02-1998",
                     TAG_DONE) THEN BEGIN
        path := @pdummy;
        StrCpy(path,"sys:");
        CreateList(mylist);
        readinlist;
        do_demo;
        CleanExit(NIL,0);
     END ELSE CleanExit("Can't open triton.library v6+",20);
END.


                
                                         

