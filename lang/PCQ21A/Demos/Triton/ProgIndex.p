program ProgIndex;

(*
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Written by Stefan Zeiger in 1993-1995
 *
 *  (c) 1993-1995 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts
 *  of it for creating programs for AmigaOS which use the
 *  Triton GUI creation system. All other rights reserved.
 *
 *  progind.c - Progress indicator demo
 *
 *)


{$I "Include:EasyPCQ/Triton.i"}
{$I "Include:Macros/TritonMacros.i"}
{$I "Include:Support/Tritonsupport.i"}
{$I "Include:Dos/Dos.i"}

const
     ID_MAIN_GADGET_STOP = 1;
     ID_MAIN_PROGIND     = 2;

procedure do_main;
var
  close_me  : boolean;
  trmsg     : TR_MessagePtr;
  project   : TR_ProjectPtr;
  i,dummy   : Integer;

begin
    close_me := false;
    i := 0;

    ProjectStart;
    WindowID(1);
    WindowTitle("Progress Indicator Demo");
    WindowPosition(TRWP_CENTERDISPLAY);
    WindowFlags(TRWF_NOCLOSEGADGET OR TRWF_NOESCCLOSE);

    VertGroupA;
      Space;  CenteredText("Working...");
      Space;  HorizGroupA;
                Space; Progress(100,0,ID_MAIN_PROGIND); (* A per cent progress indicator *)
                Space; EndGroup;
      SpaceS;HorizGroupA;
                Space; HorizGroupSA; TextN("000%"); Space; TextN("050%"); Space; TextN("100%"); EndGroup;
                Space; EndGroup;
      Space; HorizGroupSA;
                Space; ButtonE("_Stop",ID_MAIN_GADGET_STOP);
                Space; EndGroup;
      Space; EndGroup;

    EndProject;

    project := TR_OpenProject(Triton_App,@tritontags);

    IF Project <> NIL THEN BEGIN
      WHILE NOT close_me DO BEGIN
        TR_SetAttribute(project,ID_MAIN_PROGIND,TRAT_Value,i);
        Delay(10);
        REPEAT
          trmsg := TR_GetMsg(Triton_App);
          IF trmsg <> NIL THEN BEGIN
            IF (trmsg^.trm_Project = Project) THEN BEGIN
               CASE trmsg^.trm_Class OF
                 TRMS_ERROR:        WriteLN(TR_GetErrorString(trmsg^.trm_Data));
                 TRMS_ACTION :
                 BEGIN
                 CASE trmsg^.trm_ID OF
                   ID_MAIN_GADGET_STOP : close_me := True;
                 END;
               END;
               ELSE
               END;
            END;
            TR_ReplyMsg(trmsg);
          END;
        UNTIL close_me OR (trmsg = NIL);
        inc(i);
        if i = 101 then close_me := true;
      END;
      TR_CloseProject(project);
    END ELSE WriteLN(TR_GetErrorString(TR_GetLastError(Triton_App)));
end;


(* /////////////////////////////////////////////////////////////////////////////////////////////////////// *)
(* ////////////////////////////////////////////////////////////////////////////////////// Main function // *)
(* /////////////////////////////////////////////////////////////////////////////////////////////////////// *)

begin
  if TR_OpenTriton(TRITON11VERSION,TRCA_Name,"trProgIndDemo",TRCA_Version,"1.0",TAG_END) then begin
    do_main;
    TR_CloseTriton;
    exit(0);
  end else begin
     writeln("Can't open triton.library v2+.");
     exit(20);
  end;
end.
