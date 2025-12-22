
{$I "Include:Exec/Lists.i"}
{$I "Include:Exec/Nodes.i"}
{$I "Include:Libraries/AslBaseVar.i"}

{
    A few highlevel functions for the asl.library.
    Check the Asldemos in the demos directory,
    (GetFontAsl.p and GetMultiFiles.p) for an example
    on how to use this.
}

TYPE

    PCQFontInfoPtr = ^PCQFontInfo;

    PCQFontInfo = RECORD
    nfi_Name       : array [0..40] of char;
    nfi_Size       : Word;
    nfi_Style      : Byte;
    nfi_Flags      : Byte;
    nfi_FrontPen   : Byte;
    nfi_BackPen    : Byte;
    nfi_DrawMode   : Byte;
    END;


FUNCTION GetFontAsl(title : string;VAR finfo : PCQFontInfo; win : address): Boolean;
EXTERNAL;

FUNCTION GetFileAsl(title : string; VAR path, fname : string;
                    thepatt : string;win : ADDRESS): Boolean;
EXTERNAL;

FUNCTION SaveFileAsl(title : string; VAR path, fname : string;
                                     win : ADDRESS): Boolean;
EXTERNAL;

FUNCTION GetPathAsl(title : string; VAR path : string; win : ADDRESS): Boolean;
EXTERNAL;

FUNCTION GetMultiAsl(title : string; VAR path : string;  VAR TheList : ListPtr;
                                     thepatt : string; win : ADDRESS): Boolean;
EXTERNAL;

