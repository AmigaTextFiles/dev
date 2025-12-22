Program ToolManager1;
(*
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Written by Stefan Zeiger in 1993-1995
 *
 *  (c) 1993-1995 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts
 *  of it for creating programs for AmigaOS which use the
 *  Triton GUI creation system. All other rights reserved.
 *
 *  Toolmanager1.c - Looks like the original ToolManager
 *
 *)

{$I "Include:EasyPCQ/Triton.i"}
{$I "Include:Macros/TritonMacros.i"}
{$I "Include:Support/Tritonsupport.i"}

const
     cycle_entries : array [0..7] of string = ("Exec","Image","Sound","Menu","Icon","Dock","Access",NIL);

     liststrings : array [0..8] of string = (
                     "2024view" ,
                     "Add to archive",
                     "Delete",
                     "Edit text",
                     "Env",
                     "Exchange",
                     "Global Help System",
                     "Multiview",
                     "Paint");

var
   i : Integer;
   LVList : ListPtr;
   MyNode : NodePtr;

begin

    New(LVList);
    NewList(LVList);
    FOR i := 0 TO 8 DO BEGIN
        New(MyNode);
        MyNode^.ln_Name := liststrings[i];
        AddTail(LVList,MyNode);
    END;


  if TR_OpenTriton(TRITON11VERSION,TRCA_Name,"ToolManagerGUIDemo1",
     TRCA_LongName,"ToolManager GUI demo 1",TRCA_Info,
     "Looks like the original ToolManager",TAG_END) then begin

      ProjectStart;
      WindowID(0); WindowPosition(TRWP_BELOWTITLEBAR);
      WindowTitle("ToolManager GUI demo 1"); WindowFlags(TRWF_NOSIZEGADGET OR TRWF_NODELZIP OR TRWF_NOZIPGADGET OR TRWF_NOESCCLOSE);
      WindowBackfillNone;

      VertGroupA;

        Space;

        HorizGroupAC;
          Space;
          TextID("_Object Type",1);
          Space;
          CycleGadget(@cycle_entries,0,1);
          Space;
        EndGroup;

        Space;

        HorizGroupAC;
          Space;
            VertGroupAC;
              CenteredTextID("Object List",2);
              Space;
              ListSSCN(LVList,2,0,0);
            EndGroup;
          Space;
            VertGroupA;
              TextN("");
              Space;
              Button("Top",3);
              Space;
              Button("Up",4);
              Space;
              Button("Down",5);
              Space;
              Button("Bottom",6);
              Space;
              Button("So_rt",7);
            EndGroup;
          Space;
        EndGroup;

        Space;

        HorizGroupEA;
          Space;
          Button("_New...",8);
          Space;
          Button("_Edit...",9);
          Space;
          Button("Co_py",10);
          Space;
          Button("Remove",11);
          Space;
        EndGroup;

        Space;

        HorizGroupEA;
          Space;
          Button("_Save",12);
          Space;
          Button("_Use",13);
          Space;
          Button("_Test",14);
          Space;
          Button("_Cancel",15);
          Space;
        EndGroup;

        Space;

      EndGroup;

      EndProject;

    i := TR_AutoRequest(Triton_App,NIL,@tritontags);
    TR_CloseTriton;
    exit(0);
  end else begin
    writeln("Can't open triton.library v2+.");
    exit(20);
  end;
end.



