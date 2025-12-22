with System; use System;
with Interfaces; use Interfaces;
with Interfaces.C.Strings; use Interfaces.C.Strings;

with dos_dos; use dos_dos;
with utility_TagItem; use utility_TagItem;
with utility_Hooks; use utility_Hooks;

with incomplete_type; use incomplete_type;

package Locale is

type Catalog;
type Catalog_Ptr is access Catalog;
type Catalog is record
   Null;
end record;
Null_Catalog : Catalog_Ptr := Null;

type Locale;
type Locale_Ptr is access Locale;
type Locale is record
   Null;
end record;
Null_Locale : Locale_Ptr := Null;

Locale_TagBase : constant Unsigned_32 := TAG_USER + 16#90000#;

OC_BuiltInLanguage : constant Unsigned_32 := 1 + Locale_TagBase;
OC_BuiltInCodeSet : constant Unsigned_32 := 2 + Locale_TagBase;
OC_Version : constant Unsigned_32 := 3 + Locale_TagBase;
OC_Language : constant Unsigned_32 := 4 + Locale_TagBase;

procedure  CloseCatalog ( catalog : Catalog_Ptr);
Pragma Import(C,CloseCatalog,"CloseCatalog");
procedure  CloseLocale ( locale : Locale_Ptr);
Pragma Import(C,CloseLocale,"CloseLocale");
function  ConvToLower ( locale : Locale_Ptr; character : Unsigned_32) return Unsigned_32;
Pragma Import(C,ConvToLower,"ConvToLower");
function  ConvToUpper ( locale : Locale_Ptr; character : Unsigned_32 ) return Unsigned_32;
Pragma Import(C,ConvToUpper,"ConvToUpper");
procedure  FormatDate (  locale : Locale_Ptr; fmtTemplate : Chars_Ptr; date : DateStamp_Ptr; putCharFunc : Hook_Ptr);
Pragma Import(C,FormatDate,"FormatDate");
function  FormatString (  locale : Locale_Ptr; fmtTemplate : Chars_Ptr; dataStream : Integer_Ptr; putCharFunc : Hook_Ptr) return Integer_Ptr;
Pragma Import(C,FormatString,"FormatString");
function  GetCatalogStr (  catalog : Catalog_Ptr; stringNum : Integer; defaultString : Chars_Ptr) return Chars_Ptr;
Pragma Import(C,GetCatalogStr,"GetCatalogStr");
function  GetLocaleStr (  locale : Locale_Ptr; stringNum : Unsigned_32) return Chars_Ptr;
Pragma Import(C,GetLocaleStr,"GetLocaleStr");
function  IsAlNum (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsAlNum,"IsAlNum");
function  IsAlpha (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsAlpha,"IsAlpha");
function  IsCntrl (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsCntrl,"IsCntrl");
function  IsDigit (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsDigit,"IsDigit");
function  IsGraph (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsGraph,"IsGraph");
function  IsLower (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsLower,"IsLower");
function  IsPrint (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsPrint,"IsPrint");
function  IsPunct (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsPunct,"IsPunct");
function  IsSpace (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsSpace,"IsSpace");
function  IsUpper (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsUpper,"IsUpper");
function  IsXDigit (  locale : Locale_Ptr; character : Unsigned_32) return Boolean;
Pragma Import(C,IsXDigit,"IsXDigit");
function  OpenLocale (  name : Chars_Ptr) return Locale_Ptr;
Pragma Import(C,OpenLocale,"OpenLocale");
function  ParseDate (  locale : Locale_Ptr; date : DateStamp_Ptr; fmtTemplate : Chars_Ptr; getCharFunc : Hook_Ptr) return Boolean;
pragma Import(C,ParseDate,"ParseDate");
function StrConvert (locale : Locale_Ptr; string : Chars_Ptr;buffer : Integer_Ptr; bufferSize : Unsigned_32; str_type : Unsigned_32) return Unsigned_32;
pragma Import(C,StrConvert,"StrConvert");
function StrnCmp ( locale : Locale_Ptr; string1 : Chars_Ptr; string2 : Chars_Ptr; length : Integer; str_type : Unsigned_32) return Integer;
pragma Import(C,StrnCmp,"StrnCmp");


function  OpenCatalogA (  locale : Locale_Ptr; name : Chars_Ptr; tags : TagListType) return Catalog_Ptr;
end Locale;
