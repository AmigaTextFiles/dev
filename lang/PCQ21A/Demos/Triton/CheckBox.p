PROGRAM CheckBox;


{$I "Include:EasyPCQ/Triton.i"}
{$I "Include:Macros/Tritonmacros.i"}
{$I "Include:Support/tritonsupport.i"}

VAR
     Project  : TR_ProjectPtr;
     close_me : BOOLEAN;
     trmsg : TR_MessagePtr;
     dummy : INTEGER;

begin

    if TR_OpenTriton(TRITON20VERSION,
                     TRCA_Name,"Triton CheckBox",
                     TRCA_Release,"1",
                     TRCA_Date,"03-06-1998",
                     TAG_DONE) THEN BEGIN
     
      ProjectStart;
      WindowID(1);
      WindowTitle("CheckBox");
         VertGroupA;
            Space;
            HorizGroupAC;
               Space;
               TextID("_CheckBox",10);
               Space;
               CheckBox(10);
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
                                     if TR_GetCheckBox(Project,10) then writeln("CheckBox was on")
                                        else writeln("CheckBox was off");
                                     close_me := True;
                                    end;
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
                 TRMS_NEWVALUE    : begin
                                      IF trmsg^.trm_ID = 10 then begin
                                          if trmsg^.trm_Data = 0 then writeln("CheckBox off")
                                            else writeln("CheckBox on");
                                      end;
                                    end;
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


