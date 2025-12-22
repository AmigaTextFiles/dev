with System; use System;
with Interfaces; use Interfaces;
with Interfaces.C.Strings; use Interfaces.C.Strings;
with Text_IO; use Text_IO;

with amiga; use amiga;
with amiga_lib; use amiga_lib;
with utility_TagItem; use utility_TagItem; 
with exec_exec; use exec_exec;
with intuition_classusr; use intuition_classusr;
with intuition_Intuition; use intuition_Intuition;
with Incomplete_Type; use Incomplete_Type;

with mui; use mui;

with Virtual_App; use Virtual_App;

procedure Virtual is
running : Boolean := True;

signals : Unsigned_32;
wait_mask : Unsigned_32;
Method_Result : Unsigned_32;
SetAttrs_Result : Integer;

temp_Msg : Msg := NewMsg;
temp_TagList : TagListType := NewTagList;

App : Object_Ptr;

begin

if NOT OpenIntuitionLibrary(0) then
   Put_Line("Failed to open Intuition.library");
   return;
end if;

if NOT OpenMUILibrary(0) then
   Put_Line("Failed to open MUIMaster.library");
   return;
end if;

App := Create_Virtual_App;
if App = NULL then
   Put_Line("Failed to create Application.");
   return;
end if;

ClearMsg(temp_Msg);
AddMsg(temp_Msg,MUIM_Notify);
AddMsg(temp_Msg,MUIA_Window_CloseRequest);
AddMsg(temp_Msg,True);
AddMsg(temp_Msg,App);
AddMsg(temp_Msg,Unsigned_32(2));
AddMsg(temp_Msg,MUIM_Application_ReturnID);
AddMsg(temp_Msg,MUIV_Application_ReturnID_Quit);

Method_Result := DoMethodA(WI_Virtual,temp_Msg);

ClearTagList(temp_TagList);
AddTag(temp_TagList, MUIA_Window_Open, True);

SetAttrs_Result := SetAttrsA(WI_Virtual,temp_TagList);

while running loop
        ClearMsg(temp_Msg);
        AddMsg(temp_Msg,MUIM_Application_Input);
        AddMsg(temp_Msg,signals'Address);

        Method_Result := DoMethodA(App,temp_Msg);
       case  Method_Result is
          when Unsigned_32(MUIV_Application_ReturnID_Quit) =>
              running := FALSE;
           when others =>
              Null;
        end case;

        if running and signals /= 0 then
           wait_mask := Wait(signals);
        end if;
end loop;

ClearTagList(temp_TagList);
AddTag(temp_TagList,MUIA_Window_Open, False );

SetAttrs_Result := SetAttrsA(WI_Virtual,temp_TagList);

Dispose_Virtual_App;

CloseIntuitionLibrary;
CloseMUILibrary;

return;
end Virtual;
