Program ToolManager3;

(*
 *  OpenTriton -- A free release of the triton.library source code
 *  Copyright (C) 1993-1998  Stefan Zeiger
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *  Toolmanager3.c - My own creation for a ToolManager GUI
 *
 *)


uses exec, triton, tritonmacros,utility, linklist, vartags;

{
   A demo in FPC Pascal using triton.library

   nils.sjoholm@mailbox.swipnet.se
}




const
     cycle_entries : array [0..7] of pchar = ('Exec','Image','Sound','Menu','Icon','Dock','Access',NIL);

     liststrings : array [0..8] of pchar = (
                     '2024view' ,
                     'Add to archive',
                     'Delete',
                     'Edit text',
                     'Env',
                     'Exchange',
                     'Global Help System',
                     'Multiview',
                     'Paint');

var
   i : Longint;
   LVList : pList;
   MyNode : pFPCNode;
   Triton_App : pTr_App;

procedure CleanUp(why : string; err : longint);
begin
     if assigned(Triton_App) then TR_DeleteApp(triton_App);
     if assigned(LVList) then DestroyList(LVList);
     if why <> '' then writeln(why);
     halt(err);
end;

begin
    CreateList(LVList);
    FOR i := 0 TO 8 DO BEGIN
        MyNode := AddNewNode(LVList,liststrings[i]);
    END;


    Triton_App := TR_CreateApp(TAGS(
                               TRCA_Name,longstr('ToolManagerGUIDemo3'),
                               TRCA_LongName,longstr('ToolManager GUI demo 3'),
                               TRCA_Info,longstr('My own creation for a ToolManager GUI'),
                               TAG_END));

    if Triton_App = nil then CleanUp('Can''t create application',20);

      ProjectStart;
      WindowID(1); WindowPosition(TRWP_CENTERDISPLAY);
      WindowTitle('ToolManager GUI demo 3');

      VertGroupA;

        Space;

        HorizGroupAC;
          Space;
          TextID('_Object type',1);
          Space;
          CycleGadget(@cycle_entries,0,1);
          Space;
        EndGroup;

        Space;

        NamedSeparatorI('Object _list',2);

        Space;

        HorizGroupAC;
          Space;
            VertGroupAC;
              ListSS(LVList,2,0,0);
              HorizGroupEA;
                Button('_New...',8);
                Button('_Edit...',9);
              EndGroup;
              HorizGroupEA;
                Button('Co_py',10);
                Button('Remove',11);
              EndGroup;
            EndGroup;
          Space;
          Line(TROF_VERT);
          Space;
            SetTRTag(TRGR_Vert, TRGR_ALIGN OR TRGR_FIXHORIZ);
              Button('Top',3);
              Space;
              Button('Up',4);
              Space;
              Button('Down',5);
              Space;
              Button('Bottom',6);
              VertGroupS;Space;EndGroup;
              Button('So_rt',7);
            EndGroup;
          Space;
        EndGroup;

        Space;

        HorizSeparator;

        Space;

        HorizGroup;
          Space;
          HorizGroupS;
            Button('_Save',12);
            Space;
            Button('_Use',13);
            Space;
            Button('_Test',14);
            Space;
            Button('_Cancel',15);
          EndGroup;
          Space;
        EndGroup;

        Space;

      EndGroup;

      EndProject;

    i := TR_AutoRequest(Triton_App,NIL,@tritontags);
  CleanUp('',0);
end.






