PROGRAM GetFontAsl;

{$I "Include:Exec/Libraries.i"}
{$I "Include:PCQUtils/EasyAsl.i"}
{$I "Include:Libraries/Asl.i"}

VAR
    myfont : PCQFontInfo;
    dummy  : BOOLEAN;

BEGIN
    if OpenAslLib(37) then begin

    dummy := GetFontAsl("Pick a font",myfont,NIL);
    IF dummy THEN BEGIN
       WriteLN("You picked as font   :",myfont.nfi_Name);
       WriteLN("The fontsize is      :",myfont.nfi_Size);
       WriteLN("The fontstyle is     :",myfont.nfi_Style);
       WriteLN("The flags are set to :",myfont.nfi_Flags);
       WriteLN("Frontpen is number   :",myfont.nfi_FrontPen);
       WriteLN("And as the backpen   :",myfont.nfi_BackPen);
       WriteLN("And finally drawmode :",myfont.nfi_DrawMode);
    END ELSE
       Writeln("You didn't pick a font");
       CloseAslLib;
    end else
       Writeln("No asl.lib");
END.

