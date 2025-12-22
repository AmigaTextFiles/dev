with interfaces.C.Strings; use interfaces.C.Strings;
with Unchecked_Conversion;

with intuition_Classusr; use intuition_Classusr;
with utility_TagItem; use utility_TagItem;

package body mui is

function to_TagItem_Ptr is new Unchecked_Conversion(System.Address, TagItem_Ptr );

function MUI_NewObjectA (classname : Chars_Ptr;tags :TagListType) return Object_Ptr is
   function MUI_NewObjectA(classname : Chars_Ptr; tags : System.Address ) return Object_Ptr;
   pragma Import( C,  MUI_NewObjectA, "MUI_NewObjectA");

begin
   return MUI_NewObjectA(classname,tags.Tag_Address);
end MUI_NewObjectA;
pragma Inline(MUI_NewObjectA);

function MUI_AllocAslRequest (reqType  : Unsigned_32;tagList : TagListType) return Integer_Ptr is
   function MUI_AllocAslRequest (reqType  : Unsigned_32;tagList : System.Address) return Integer_Ptr;
   pragma Import( C, MUI_AllocAslRequest, "MUI_AllocAslRequest");
begin
   return MUI_AllocAslRequest( reqType, tagList.Tag_Address );
end MUI_AllocAslRequest;
pragma Inline(MUI_AllocAslRequest);

function MUI_AslRequest (requester : Requester_Ptr; tagList : TagListType) return Boolean is
   function MUI_AslRequest (requester : Requester_Ptr; tagList : System.Address) return Boolean;
   pragma Import( C, MUI_AslRequest, "MUI_AslRequest");
begin
   return MUI_AslRequest( requester, tagList.Tag_Address );
end MUI_AslRequest;
pragma Inline(MUI_AslRequest);

function MUI_MakeObjectA (Object_Type : Unsigned_32;params : Msg) return Object_Ptr is
   function MUI_MakeObjectA (Object_Type : Unsigned_32;params : System.Address) return Object_Ptr;
   pragma Import( C, MUI_MakeObjectA, "MUI_MakeObjectA");

   begin
      return MUI_MakeObjectA ( Object_Type, params.MsgAddress );
   end;
pragma Inline(MUI_MakeObjectA);

end mui;
