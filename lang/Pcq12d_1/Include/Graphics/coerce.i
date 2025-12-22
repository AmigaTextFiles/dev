 {      mode coercion definitions }

const
{  These flags are passed (in combination) to CoerceMode() to determine the
 * type of coercion required.
 }

{  Ensure that the mode coerced to can display just as many colours as the
 * ViewPort being coerced.
 }
    PRESERVE_COLORS = 1;

{  Ensure that the mode coerced to is not interlaced. }
    AVOID_FLICKER   = 2;

{  Coercion should ignore monitor compatibility issues. }
    IGNORE_MCOMPAT  = 4;


    BIDTAG_COERCE   = 1; {  Private }

{ --- functions in V39 or higher (Release 3) ---}

FUNCTION CoerceMode(VP : ViewPortPtr; MonitorID, Flags : Integer) : Integer;
    External;


