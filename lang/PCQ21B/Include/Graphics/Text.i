{
    Text.i for PCQ Pascal
}

{$I   "Include:Graphics/Gfx.i"}
{$I   "Include:Exec/Ports.i"}
{$I   "Include:Utility/TagItem.i"}

const

{------ Font Styles ------------------------------------------------}

    FS_NORMAL           = 0;    { normal text (no style bits set) }
    FSB_EXTENDED        = 3;    { extended face (wider than normal) }
    FSF_EXTENDED        = 8;
    FSB_ITALIC          = 2;    { italic (slanted 1:2 right) }
    FSF_ITALIC          = 4;
    FSB_BOLD            = 1;    { bold face text (ORed w/ shifted) }
    FSF_BOLD            = 2;
    FSB_UNDERLINED      = 0;    { underlined (under baseline) }
    FSF_UNDERLINED      = 1;

    FSB_COLORFONT       = 6;       { this uses ColorTextFont structure }
    FSF_COLORFONT       = $40;
    FSB_TAGGED          = 7;       { the TextAttr is really an TTextAttr, }
    FSF_TAGGED          = $80;


{------ Font Flags -------------------------------------------------}
    FPB_ROMFONT         = 0;    { font is in rom }
    FPF_ROMFONT         = 1;
    FPB_DISKFONT        = 1;    { font is from diskfont.library }
    FPF_DISKFONT        = 2;
    FPB_REVPATH         = 2;    { designed path is reversed (e.g. left) }
    FPF_REVPATH         = 4;
    FPB_TALLDOT         = 3;    { designed for hires non-interlaced }
    FPF_TALLDOT         = 8;
    FPB_WIDEDOT         = 4;    { designed for lores interlaced }
    FPF_WIDEDOT         = 16;
    FPB_PROPORTIONAL    = 5;    { character sizes can vary from nominal }
    FPF_PROPORTIONAL    = 32;
    FPB_DESIGNED        = 6;    { size is "designed", not constructed }
    FPF_DESIGNED        = 64;
    FPB_REMOVED         = 7;    { the font has been removed }
    FPF_REMOVED         = 128;

{***** TextAttr node, matches text attributes in RastPort *********}

type

    TextAttr = record
        ta_Name : String;       { name of the font }
        ta_YSize : Short;       { height of the font }
        ta_Style : Byte;        { intrinsic font style }
        ta_Flags : Byte;        { font preferences and flags }
    end;
    TextAttrPtr = ^TextAttr;

    TTextAttr = record
        tta_Name : String;       { name of the font }
        tta_YSize : Short;       { height of the font }
        tta_Style : Byte;        { intrinsic font style }
        tta_Flags : Byte;        { font preferences AND flags }
        tta_Tags  : Address;     { extended attributes }
    end;
    TTextAttrPtr = ^TTextAttr;

{***** Text Tags **************************************************}
CONST
  TA_DeviceDPI  =  (1+TAG_USER);    { Tag value is Point union: }
                                        { Hi word XDPI, Lo word YDPI }

  MAXFONTMATCHWEIGHT  =    32767;   { perfect match from WeighTAMatch }



{***** TextFonts node *********************************************}
Type
    TextFont = record
        tf_Message      : Message;      { reply message for font removal }
                                        { font name in LN \    used in this }
        tf_YSize        : Short;        { font height     |    order to best }
        tf_Style        : Byte;         { font style      |    match a font }
        tf_Flags        : Byte;         { preferences and flags /    request. }
        tf_XSize        : Short;        { nominal font width }
        tf_Baseline     : Short; { distance from the top of char to baseline }
        tf_BoldSmear    : Short;        { smear to affect a bold enhancement }

        tf_Accessors    : Short;        { access count }

        tf_LoChar       : Byte;         { the first character described here }
        tf_HiChar       : Byte;         { the last character described here }
        tf_CharData     : Address;      { the bit character data }

        tf_Modulo       : Short; { the row modulo for the strike font data }
        tf_CharLoc      : Address; { ptr to location data for the strike font }
                                        { 2 words: bit offset then size }
        tf_CharSpace    : Address; { ptr to words of proportional spacing data }
        tf_CharKern     : Address;      { ptr to words of kerning data }
    end;
    TextFontPtr = ^TextFont;


{----- tfe_Flags0 (partial definition) ----------------------------}
CONST
 TE0B_NOREMFONT = 0;       { disallow RemFont for this font }
 TE0F_NOREMFONT = $01;

Type
   TextFontExtension = Record              { this structure is read-only }
    tfe_MatchWord  : Short;                { a magic cookie for the extension }
    tfe_Flags0     : Byte;                 { (system private flags) }
    tfe_Flags1     : Byte;                 { (system private flags) }
    tfe_BackPtr    : TextFontPtr;          { validation of compilation }
    tfe_OrigReplyPort : MsgPortPtr;        { original value in tf_Extension }
    tfe_Tags       : Address;              { Text Tags for the font }
    tfe_OFontPatchS,                       { (system private use) }
    tfe_OFontPatchK : Address;             { (system private use) }
    { this space is reserved for future expansion }
   END;
   TextFontExtensionPtr = ^TextFontExtension;

{***** ColorTextFont node *****************************************}
{----- ctf_Flags --------------------------------------------------}
CONST
 CT_COLORMASK  =  $000F;  { mask to get to following color styles }
 CT_COLORFONT  =  $0001;  { color map contains designer's colors }
 CT_GREYFONT   =  $0002;  { color map describes even-stepped }
                                { brightnesses from low to high }
 CT_ANTIALIAS  =  $0004;  { zero background thru fully saturated char }

 CTB_MAPCOLOR  =  0;      { map ctf_FgColor to the rp_FgPen IF it's }
 CTF_MAPCOLOR  =  $0001;  { is a valid color within ctf_Low..ctf_High }

{----- ColorFontColors --------------------------------------------}
Type
   ColorFontColors = Record
    cfc_Reserved,                 { *must* be zero }
    cfc_Count   : Short;          { number of entries in cfc_ColorTable }
    cfc_ColorTable : Address;     { 4 bit per component color map packed xRGB }
   END;
   ColorFontColorsPtr = ^ColorFontColors;

{----- ColorTextFont ----------------------------------------------}
   ColorTextFont = Record
    ctf_TF      : TextFontPtr;
    ctf_Flags   : Short;          { extended flags }
    ctf_Depth,          { number of bit planes }
    ctf_FgColor,        { color that is remapped to FgPen }
    ctf_Low,            { lowest color represented here }
    ctf_High,           { highest color represented here }
    ctf_PlanePick,      { PlanePick ala Images }
    ctf_PlaneOnOff : Byte;     { PlaneOnOff ala Images }
    ctf_ColorFontColors : ColorFontColorsPtr; { colors for font }
    ctf_CharData : Array[0..7] of APTR;    {pointers to bit planes ala tf_CharData }
   END;
   ColorTextFontPtr = ^ColorTextFont;

{***** TextExtent node ********************************************}
   TextExtentStruct = Record
    te_Width,                   { same as TextLength }
    te_Height : Short;          { same as tf_YSize }
    te_Extent : Rectangle;      { relative to CP }
   END;
   TextExtentPtr = ^TextExtentStruct;


Procedure AddFont(textFont : TextFontPtr);
    External;

Procedure AskFont(rp : Address; textAttr : TextAttrPtr);
    External;   { rp is a RastPortPtr }

Function AskSoftStyle(rp : Address) : Integer;
    External;   { rp is a RastPortPtr }

Procedure ClearEOL(rp : Address);
    External;

Procedure ClearScreen(rp : Address);
    External;

Procedure CloseFont(font : TextFontPtr);
    External;

FUNCTION ExtendFont(F : TextFontPtr; TagList : Address) : Integer;
    External;

PROCEDURE FontExtent(F : TextFontPtr; TE : TextExtentPtr);
    External;

Function OpenFont(textAttr : TextAttrPtr) : TextFontPtr;
    External;

Procedure RemFont(textFont : TextFontPtr);
    External;

Procedure SetFont(rp : Address; font : TextFontPtr);
    External;   { rp is a RastPortPtr }

Function SetSoftStyle(rp : Address; style, enable : Integer) : Integer;
    External;

PROCEDURE StripFont(f : TextFontPtr);
    External;

Procedure GText(rp : Address; str : String; count : Short);
    External;

PROCEDURE TextExtent(RP : Address; str : String; count : Short; TE : TextExtentPtr);
    External;

FUNCTION TextFit(RP : Address; Str : String; StrLen : Short; TE , CET : TextExtentPtr;
                 Direction, BitWidth, BitHeight : Short) : Integer;
    External;

Function TextLength(rp : Address; str : String; count : Short) : Short;
    External;

FUNCTION WeighTAMatch(ReqTextAttr : TTextAttrPtr; targetTextAttr : TextAttrPtr; TagList : Address) : Short;
    External;


{
   This are varargs functions to use with PCQ Pascal vers. 2.0 and above
}
     


{$C+}
FUNCTION WeighTAMatchTags(reqtextattr :TTextAttrPtr; target : TextAttrPtr; ...): Short;
EXTERNAL;

FUNCTION ExtendFontTags(F : TextFontPtr; ...): Integer;
EXTERNAL;
{$C-}
                         

