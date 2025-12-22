PROGRAM ListView;


{$I "Include:EasyPCQ/Triton.i"}
{$I "Include:Macros/Tritonmacros.i"}
{$I "Include:Support/tritonsupport.i"}
{$I "Include:PCQUtils/PCQList.i"}

const

     weekday : array [0..6] of string =  (
                "Monday",
                "Tuesday",
                "Wendsday",
                "Thursday",
                "Friday",
                "Saturday",
                "Sunday");

VAR
     Project  : TR_ProjectPtr;
     close_me : BOOLEAN;
     trmsg : TR_MessagePtr;
     dummy : INTEGER;
     mylist : ListPtr;
     mynode : PCQNodePtr;
     num : Integer;

begin

    if TR_OpenTriton(TRITON20VERSION,
                     TRCA_Name,"Triton ListView",
                     TRCA_Release,"1",
                     TRCA_Date,"03-08-1998",
                     TAG_DONE) THEN BEGIN

    CreateList(mylist);
    for dummy := 0 to 6 do begin
        mynode := AddNewNode(mylist,weekday[dummy]);
    end;
      ProjectStart;
      WindowID(1);
      WindowPosition(TRWP_CENTERDISPLAY);
      WindowTitle("Listview");
         HorizGroupA;
            Space;
            VertGroupA;
               Space;
               CenteredTextID("_List",7);
               Space;
               ListSS(mylist,7,0,2);
               Space;
            EndGroup;
            Space;
         EndGroup;
      EndProject;

  Project := TR_OpenProject(Triton_App,@tritontags);
    IF Project <> NIL THEN BEGIN
      close_me := FALSE;
      WHILE NOT close_me DO BEGIN
        dummy := TR_Wait(Triton_App,0);
        REPEAT
          trmsg := TR_GetMsg(Triton_App);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = Project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_CLOSEWINDOW : begin
                                       num := TR_GetValue(Project,7);
                                       mynode := GetNodeNumber(mylist,num);
                                       writeln("You picked number: ",num," and the text was: ",GetNodeData(mynode));
                                       close_me := True;
                                    end;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
                 TRMS_NEWVALUE    : IF trmsg^.trm_ID = 7 then writeln("You picked number: ",TR_GetValue(Project,7));
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
      END;
     TR_CloseProject(Project);
   end;
   TR_CloseTriton;
   END ELSE writeln("Cant open triton.library v6+",20);
end.


