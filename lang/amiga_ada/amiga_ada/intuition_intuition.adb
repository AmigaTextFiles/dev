package body intuition_intuition is

function NewObjectA (  class_Ptr : IClass_Ptr;classID : Chars_Ptr; tagList : TagListType) return Integer_Ptr is
   function NewObjectA (  class_Ptr : IClass_Ptr;classID : Chars_Ptr; tagList : System.Address) return Integer_Ptr;
   pragma IMPORT (C, NewObjectA, "NewObjectA");

   begin
      return NewObjectA(class_Ptr,classID,tagList.Tag_Address);
   end NewObjectA;
pragma Inline( NewObjectA);

function OpenScreenTagList (  newScreen : NewScreen_Ptr; tagList : TagListType) return  Screen_Ptr is
   function OpenScreenTagList (  newScreen : NewScreen_Ptr; tagList : System.Address) return  Screen_Ptr;
   pragma IMPORT (C, OpenScreenTagList, "OpenScreenTagList");

   begin
      return OpenScreenTagList(newScreen, tagList.Tag_Address );
   end OpenScreenTagList;
pragma Inline(OpenScreenTagList);

function OpenWindowTagList (  newWindow : NewWindow_Ptr; tagList : TagListType) return  Window_Ptr is
   function OpenWindowTagList (  newWindow : NewWindow_Ptr; tagList : System.Address) return  Window_Ptr;
   pragma IMPORT (C, OpenWindowTagList, "OpenWindowTagList");

   begin
      return OpenWindowTagList(newWindow, tagList.Tag_Address );
   end OpenWindowTagList;
pragma Inline( OpenWindowTagList);

function SetAttrsA ( object : Object_Ptr; tagList : TagListType) return Integer is
   function SetAttrsA ( object : Object_Ptr; tagList : System.Address) return Integer;
   pragma IMPORT (C, SetAttrsA, "SetAttrsA");

   begin
      return SetAttrsA ( object, tagList.Tag_Address );
   end SetAttrsA;
pragma Inline( SetAttrsA );

function SetGadgetAttrsA (  gadget : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr; tagList : TagListType) return Integer is
   function SetGadgetAttrsA (  gadget : Gadget_Ptr; window : Window_Ptr; requester : Requester_Ptr; tagList : System.Address) return Integer;
pragma IMPORT (C, SetGadgetAttrsA, "SetGadgetAttrsA");

   begin
      return SetGadgetAttrsA ( gadget, window, requester, tagList.Tag_Address );
   end SetGadgetAttrsA;
pragma Inline( SetGadgetAttrsA );


procedure SetWindowPointerA (  win : Window_Ptr; taglist : TagListType) is
--   procedure SetWindowPointerA (  win : Window_Ptr; taglist : System.Address);
--   pragma IMPORT (C, SetWindowPointerA, "SetWindowPointerA");

   begin
--      SetWindowPointerA ( win, taglist.Tag_Address );
   NULL;  -- not in libamiga.a ?????
   end SetWindowPointerA;
pragma Inline( SetWindowPointerA );

end intuition_intuition;