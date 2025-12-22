Program ToolManager3;
(*
 *  Triton - The object oriented GUI creation system for the Amiga
 *  Written by Stefan Zeiger in 1993-1995
 *
 *  (c) 1993-1995 by Stefan Zeiger
 *  You are hereby allowed to use this source or parts
 *  of it for creating programs for AmigaOS which use the
 *  Triton GUI creation system. All other rights reserved.
 *
 *  Toolmanager3.c - My own creation for a ToolManager GUI
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


  if TR_OpenTriton(TRITON11VERSION,TRCA_Name,"ToolManagerGUIDemo3",
      TRCA_LongName,"ToolManager GUI demo 3",TRCA_Info,
      "My own creation for a ToolManager GUI",TAG_END) then begin

      ProjectStart;
      WindowID(1); WindowPosition(TRWP_CENTERDISPLAY);
      WindowTitle("ToolManager GUI demo 3");

      VertGroupA;

        Space;

        HorizGroupAC;
          Space;
          TextID("_Object type",1);
          Space;
          CycleGadget(@cycle_entries,0,1);
          Space;
        EndGroup;

        Space;

        NamedSeparatorI("Object _list",2);

        Space;

        HorizGroupAC;
          Space;
            VertGroupAC;
              ListSS(LVList,2,0,0);
              HorizGroupEA;
                Button("_New...",8);
                Button("_Edit...",9);
              EndGroup;
              HorizGroupEA;
                Button("Co_py",10);
                Button("Remove",11);
              EndGroup;
            EndGroup;
          Space;
          Line(TROF_VERT);
          Space;
            SetTRTag(TRGR_Vert, TRGR_ALIGN OR TRGR_FIXHORIZ);
              Button("Top",3);
              Space;
              Button("Up",4);
              Space;
              Button("Down",5);
              Space;
              Button("Bottom",6);
              VertGroupS;Space;EndGroup;
              Button("So_rt",7);
            EndGroup;
          Space;
        EndGroup;

        Space;

        HorizSeparator;

        Space;

        HorizGroup;
          Space;
          HorizGroupS;
            Button("_Save",12);
            Space;
            Button("_Use",13);
            Space;
            Button("_Test",14);
            Space;
            Button("_Cancel",15);
          EndGroup;
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






