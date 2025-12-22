  { Only V39+ }

  {  Interface definitions for DataType text objects.  }

{$I "Include:Utility/TagItem.i"}
{$I "Include:DataTypes/DataTypesClass.i"}
{$I "Include:Libraries/IFfParse.i"}

const
{ ***************************************************************************}

   TEXTDTCLASS           =  "text.datatype";

{ ***************************************************************************}

{  Text attributes }
   TDTA_Buffer           =  (DTA_Dummy + 300);
   TDTA_BufferLen        =  (DTA_Dummy + 301);
   TDTA_LineList         =  (DTA_Dummy + 302);
   TDTA_WordSelect       =  (DTA_Dummy + 303);
   TDTA_WordDelim        =  (DTA_Dummy + 304);
   TDTA_WordWrap         =  (DTA_Dummy + 305);
     {  Boolean. Should the text be word wrapped.  Defaults to false. }

{ ***************************************************************************}

Type
{  There is one Line structure for every line of text in our document.  }
 Line = Record
    ln_Link              : MinNode;             {  to link the lines together }
    ln_Text              : String;              {  pointer to the text for this line }
    ln_TextLen           : Integer;             {  the character length of the text for this line }
    ln_XOffset,                                 {  where in the line the text starts }
    ln_YOffset,                                 {  line the text is on }
    ln_Width,                                   {  Width of line in pixels }
    ln_Height,                                  {  Height of line in pixels }
    ln_Flags             : WORD;                {  info on the line }
    ln_FgPen,                                   {  foreground pen }
    ln_BgPen             : Byte;                {  background pen }
    ln_Style             : Integer;             {  Font style }
    ln_Data              : Address;             {  Link data... }
 end;
 LinePtr = ^Line;

{ ***************************************************************************}

const
{  Line.ln_Flags }

{  Line Feed }
   LNF_LF        = 1;

{  Segment is a link }
   LNF_LINK      = 2;

{  ln_Data is a pointer to an DataTypes object }
   LNF_OBJECT    = 4;

{  Object is selected }
   LNF_SELECTED  = 8;

{ ***************************************************************************}

{  IFF types that may be text }
   ID_FTXT         = 1179932756;
   ID_CHRS         = 1128813139;

{ ***************************************************************************}

