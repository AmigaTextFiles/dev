
 {      glyph.h -- structures for glyph libraries }

{$I "Include:Exec/Types.i"}
{$I "Include:Exec/Libraries.i"}
{$I "Include:Exec/Nodes.i"}


Type
{ A GlyphEngine must be acquired via OpenEngine and is read-only }
 GlyphEngine = Record
    gle_Library  : LibraryPtr; { engine library }
    gle_Name     : String;     { library basename: e.g. "bullet" }
    { private library data follows... }
 end;
 GlyphEnginePtr = ^GlyphEngine;

 FIXED = Integer;             { 32 bit signed w/ 16 bits of fraction }

 GlyphMap = Record
    glm_BMModulo,               { # of bytes in row: always multiple of 4 }
    glm_BMRows,                 { # of rows in bitmap }
    glm_BlackLeft,              { # of blank pixel columns at left }
    glm_BlackTop,               { # of blank rows at top }
    glm_BlackWidth,             { span of contiguous non-blank columns }
    glm_BlackHeight : WORD;     { span of contiguous non-blank rows }
    glm_XOrigin,                { distance from upper left corner of bitmap }
    glm_YOrigin     : FIXED;    {   to initial CP, in fractional pixels }
    glm_X0,                     { approximation of XOrigin in whole pixels }
    glm_Y0,                     { approximation of YOrigin in whole pixels }
    glm_X1,                     { approximation of XOrigin + Width }
    glm_Y1          : WORD;     { approximation of YOrigin + Width }
    glm_Width       : FIXED;    { character advance, as fraction of em width }
    glm_BitMap      : Address;  { actual glyph bitmap }
 end;
 GlyphMapPtr = ^GlyphMap;

 GlyphWidthEntry = Record
    gwe_Node  : MinNode;        { on list returned by OT_WidthList inquiry }
    gwe_Code  : WORD;           { entry's character code value }
    gwe_Width : FIXED;          { character advance, as fraction of em width }
 end;
 GlyphWidthEntryPtr = ^GlyphWidthEntry;


FUNCTION OpenEngine : GlyphEnginePtr;
    External;

PROCEDURE CloseEngine( GE : GlyphEnginePtr);
    External;

FUNCTION SetInfoA(GE : GlyphEnginePtr; TagList : Address) : Integer;
    External;

FUNCTION ObtainInfoA(GE : GlyphEnginePtr; TagList : Address) : Integer;
    External;

FUNCTION ReleaseInfoA(GE : GlyphEnginePtr; TagList : Address) : Integer;
    External;


