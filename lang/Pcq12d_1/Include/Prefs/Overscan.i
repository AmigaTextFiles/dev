   {   File format for overscan preferences  }

{$I "Include:Libraries/IffParse.i"}
{$I "Include:Graphics/Gfx.i"}


const
    ID_OSCN = 1330856782;
    OSCAN_MAGIC = $FEDCBA89;


Type
 OverscanPrefs = Record
    os_Reserved,
    os_Magic         : Integer;
    os_HStart,
    os_HStop,
    os_VStart,
    os_VStop         : WORD;
    os_DisplayID     : Integer;
    os_ViewPos,
    os_Text          : Point;
    os_Standard      : Rectangle;
 end;
 OverscanPrefsPtr = ^OverscanPrefs;

{ os_HStart, os_HStop, os_VStart, os_VStop can only be looked at if
 * os_Magic equals OSCAN_MAGIC. If os_Magic is set to any other value,
 * these four fields are undefined
 }


{***************************************************************************}


