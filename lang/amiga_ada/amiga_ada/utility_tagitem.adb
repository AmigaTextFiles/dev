with System;
with interfaces; use interfaces;
with interfaces.C; use interfaces.C;
with interfaces.C.Strings; use interfaces.C.Strings;

with incomplete_type; use incomplete_type;

package body utility_tagitem is

procedure NewAddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in TagDataType ) is

begin
   AddTag( TagList, TagID, to_Unsigned_32(NewTag));
end NewAddTag;

function to_Unsigned_32 is new Unchecked_Conversion(Unsigned_32,Unsigned_32);
function to_Unsigned_32 is new Unchecked_Conversion(Chars_Ptr, Unsigned_32);
function to_Unsigned_32 is new Unchecked_Conversion(System.Address, Unsigned_32);
function to_Unsigned_32 is new Unchecked_Conversion(Unsigned_32_Ptr, Unsigned_32);
function to_Unsigned_32 is new Unchecked_Conversion(Integer, Unsigned_32);

function to_Unsigned_32( bool : Boolean ) return Unsigned_32 is
begin
   if bool then
      return Unsigned_32(1);
   else
      return Unsigned_32(0);
   end if;
end To_Unsigned_32;
pragma Inline(To_Unsigned_32);

procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Integer) is
begin
   AddTag( TagList, TagID, to_Unsigned_32(NewTag));
end AddTag;
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Character) is
begin
   AddTag( TagList, TagID, Unsigned_32(Character'POS(NewTag)));
end AddTag;
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Boolean) is
begin
   AddTag( TagList, TagID, to_Unsigned_32(NewTag));
end AddTag;
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Chars_Ptr) is
begin
   AddTag( TagList, TagID, to_Unsigned_32(NewTag));
end AddTag;
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in System.Address) is
begin
   AddTag( TagList, TagID, to_Unsigned_32(NewTag));
end AddTag;

procedure AddTag ( TagList : in out TagListType; TagID :in Unsigned_32; NewTag :in Unsigned_32_Ptr) is
begin
   AddTag( TagList, TagID, to_Unsigned_32(NewTag));
end AddTag;



procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Unsigned_32 ) is

i : Integer := 1;
temp_TagList_Ptr : TagItem_Ptr;

begin

while TagList.TagList_Ptr(i).ti_Tag /= 0 and i < TagList.size loop
    i := i+ 1;
end loop;

if i=TagList.size then
   temp_TagList_Ptr := new TagItem_Array(1..TagList.size * 2);
   for j in 1 .. TagList.size - 1 loop
      temp_TagList_Ptr(j) := TagList.TagList_Ptr(j);
   end loop;
   for j in TagList.size  .. TagList.size * 2 loop
      temp_TagList_Ptr(j).ti_Tag := 0;
      temp_TagList_Ptr(j).ti_Data := 0;
   end loop;

   TagList.size := TagList.size * 2;
   TagList.TagList_Ptr := temp_TagList_Ptr;
   TagList.Tag_Address := TagList.TagList_Ptr(1)'Address;
end if;
TagList.TagList_Ptr(i).ti_Tag := TagID;
TagList.TagList_Ptr(i).ti_Data := NewTag;

end AddTag;



function NewTagList return TagListType is

return_TL : TagListType;

begin

return_TL.TagList_Ptr := new TagItem_Array(1..10);
return_TL.Tag_Address := return_TL.TagList_Ptr(1)'Address;
return_TL.size := 10;
for i in 1 ..  10 loop
   return_TL.TagList_Ptr(i).ti_Tag := 0;
   return_TL.TagList_Ptr(i).ti_Data := 0;
end loop;

return return_TL;
end NewTagList;

procedure ClearTagList( TagList : in out TagListType ) is
begin
for i in 1 .. TagList.size loop
   TagList.TagList_Ptr(i).ti_Tag := 0;
   TagList.TagList_Ptr(i).ti_Data := 0;
end loop;
end ClearTagList;

procedure DeleteTagList( TagList : in out TagListType ) is
begin
NULL; -- maybe try unchecked deallocation ????
--   free(TagList.TagList_Ptr);
end;

end utility_tagitem;
