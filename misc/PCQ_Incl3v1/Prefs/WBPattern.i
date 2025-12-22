   {   File format for wbpattern preferences  }


{$I "Include:Libraries/IffParse.i"}

const
 ID_PTRN = 1347703374;

Type
 WBPatternPrefs = Record
    wbp_Reserved    : Array[0..3] of Integer;
    wbp_Which,                     { Which pattern is it }
    wbp_Flags       : WORD;
    wbp_Revision,                  { Must be set to zero }
    wbp_Depth       : Byte;        { Depth of pattern }
    wbp_DataLength  : WORD;        { Length of following data }
 end;
 WBPatternPrefsPtr = ^WBPatternPrefs;

const
{ constants for WBPatternPrefs.wbp_Which }
 WBP_ROOT       = 0;
 WBP_DRAWER     = 1;
 WBP_SCREEN     = 2;

{ wbp_Flags values }
 WBPF_PATTERN   = $0001;
    { Data contains a pattern }

 WBPF_NOREMAP   = $0010;
    { Don't remap the pattern }

{***************************************************************************}

 MAXDEPTH       = 3;       {  Max depth supported (8 colors) }
 DEFPATDEPTH    = 2;       {  Depth of default patterns }

{  Pattern width & height: }
 PAT_WIDTH      = 16;
 PAT_HEIGHT     = 16;


