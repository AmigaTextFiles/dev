

{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Ports.i"}


Type

  DivMod32Rec = record
        Ddividend,
        Divisor,
        Quotient,
        Remainder       : Integer;
  end;
  DivMod32RecPtr = ^DivMod32Rec;


Type
 UtilityBaseRec = Record
    ub_LibNode : Library;
    ub_Language,
    ub_Reserved : Byte;
 end;

VAR UtilityBase : Address;


FUNCTION SDivMod32( DM32R : DivMod32RecPtr) : DivMod32RecPtr;
    External;

FUNCTION SMult32(Arg1, Arg2 : Integer) : Integer;
    External;

FUNCTION StriCmp(Str1, Str2 : String) : Integer;
    External;

FUNCTION StrniCmp(Str1, Str2 : String; len : Integer) : Integer;
    External;

FUNCTION ToLower(c : Char) : Char;
    External;

FUNCTION ToUpper(c : Char) : Char;
    External;

FUNCTION UDivMod32( DM32R : DivMod32RecPtr) : DivMod32RecPtr;
    External;

FUNCTION UMult32(Arg1, Arg2 : Integer) : Integer;
    External;

{ --- functions in V39 or higher (Release 3) --- }

{ More tag Item functions }

PROCEDURE ApplyTagChanges(TagList, ChangeList : Address);
    External;

{ 64 bit integer multiply functions. The results are 64 bit quantities }
{ returned in D0 and D1 }

FUNCTION SMult64(Arg1, Arg2 : Integer) : Integer;
    External;

FUNCTION UMult64(Arg1, Arg2 : Integer) : Integer;
    External;

{ Structure of Tag and Tag to Structure support routines }

FUNCTION PackStructureTags(pack, packTable, TagList : Address) : Integer;
    External;

FUNCTION UnpackStructureTags(pack, packTable, TagList : Address) : Integer;
    External;

{ New, object-oriented NameSpaces }

FUNCTION AddNamedObject(nameSpace, obj : NamedObjectPtr) : Boolean;
    External;

FUNCTION AllocNamedObjectA(name : String; TagList : Address) : NamedObjectPtr;
    External;

FUNCTION AttemptRemNamedObject(obj : NamedObjectPtr) : Integer;
    External;

FUNCTION FindNamedObject(nameSpace : NamedObjectPtr; name : String; 
                         lastobject: NamedObjectPtr) : NamedObjectPtr;
    External;

PROCEDURE FreeNamedObject(Obj : NamedObjectPtr);
    External;

FUNCTION NamedObjectName(Obj : NamedObjectPtr) : String;
    External;

PROCEDURE ReleaseNamedObject(Obj : NamedObjectPtr);
    External;

PROCEDURE RemNamedObject(Obj : NamedObjectPtr; Msg : MessagePtr);
    External;

{ Unique ID generator }

FUNCTION GetUniqueID : Integer;
    External;


