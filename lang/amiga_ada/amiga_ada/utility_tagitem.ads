with System;
with Interfaces; use Interfaces;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with Unchecked_Conversion;

with incomplete_Type; use incomplete_Type;

package utility_tagitem is

type TagItem is record
   ti_Tag : Unsigned_32;
   ti_Data: Unsigned_32;
end record;
type TagItem_Array is array (Positive range <>) of TagItem;
type TagItem_Ptr is access TagItem_Array;

type TagListType is record
   TagList_Ptr : TagItem_Ptr;
   Tag_Address : System.Address;
   Size        : Natural;
end record;

generic
    type TagDataType is private;
    with function to_Unsigned_32(TagData : TagDataType) return Unsigned_32;

    procedure NewAddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in TagDataType );



function NewTagList return TagListType;
procedure ClearTagList( TagList : in out TagListType );
procedure DeleteTagList( TagList : in out TagListType );

procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Unsigned_32);
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Boolean);
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Character);
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Integer);
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Chars_Ptr);
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in System.Address);
procedure AddTag ( TagList : in out TagListType; TagID : in Unsigned_32; NewTag : in Unsigned_32_Ptr);

TAG_DONE : constant Unsigned_32 := 0;
TAG_END : constant Unsigned_32 := TAG_DONE;
TAG_IGNORE : constant Unsigned_32 := 1;
TAG_MORE : constant Unsigned_32 := 2;
TAG_SKIP : constant Unsigned_32 := 3;

TAG_USER : constant Unsigned_32 :=  2**32;

TAGFILTER_AND : constant Unsigned_32 := 0;
TAGFILTER_NOT : constant Unsigned_32 := 1;

function to_TagItem_Ptr is new Unchecked_Conversion(System.Address,TagItem_Ptr);

end utility_tagitem;
