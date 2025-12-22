with System;

with utility_TagItem; use utility_TagItem;

package body dos_dos is
function AllocDosObject(  dos_type : Integer;tags : TagListType) return Unsigned_32_Ptr is
   function AllocDosObject(  dos_type : Integer;tags : System.Address) return Unsigned_32_Ptr;
   pragma Import(C,AllocDosObject,"AllocDosObject");

   begin
      return AllocDosObject(dos_type,tags.Tag_Address);
end AllocDosObject;

function CreateNewProc( tags : TagListType) return Process_Ptr is
   function CreateNewProc( tags : System.Address) return Process_Ptr;
   pragma Import(C,CreateNewProc,"CreateNewProc");

   begin
      return CreateNewProc(tags.Tag_Address);
end CreateNewProc;

function NewLoadSeg( file : Chars_Ptr;tags : TagListType) return Unsigned_32_Ptr is
   function NewLoadSeg( file : Chars_Ptr;tags : System.Address) return Unsigned_32_Ptr;
   pragma Import(C,NewLoadSeg,"NewLoadSeg");

   begin
      return NewLoadSeg(file,tags.Tag_Address);
end NewLoadSeg;

function SystemTagList( command : Chars_Ptr;tags : TagListType) return INTEGER is
   function SystemTagList( command : Chars_Ptr;tags : System.Address) return INTEGER ;
   pragma Import(C,SystemTagList,"SystemTagList");

   begin
      return SystemTagList(command,tags.Tag_Address);
end SystemTagList;

end dos_dos;
