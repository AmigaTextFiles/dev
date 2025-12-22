with System;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with utility_TagItem; use utility_TagItem;

package body Locale is

function OpenCatalogA ( locale : Locale_Ptr; name : Chars_Ptr; tags : TagListType) return Catalog_Ptr is
   function OpenCatalogA ( locale : Locale_Ptr; name : Chars_Ptr; tags : System.Address) return Catalog_Ptr;
   pragma IMPORT (C, OpenCatalogA, "OpenCatalogA");

   begin
      return OpenCatalogA(locale, name, tags.Tag_Address);
end OpenCatalogA;
pragma Inline( OpenCatalogA);

end Locale;