OPT MODULE
OPT PREPROCESS


MODULE 'graphics/rastport', 'graphics/gfxmacros'

EXPORT ENUM DRAWSTYLE_line,         -> full line
            DRAWSTYLE_dot,
            DRAWSTYLE_smalldot,
            DRAWSTYLE_largedot,
            DRAWSTYLE_dot2,
            DRAWSTYLE_smalldot2,
            DRAWSTYLE_largedot2


/*
** Sets the drawstyle for an rastport.
*/
EXPORT PROC setDrawStyleRP(rp:PTR TO rastport, style=DRAWSTYLE_line)
DEF pattern=-1

  SELECT style
    CASE DRAWSTYLE_largedot   ; pattern := %1110111011101110
    CASE DRAWSTYLE_dot        ; pattern := %1100110011001100
    CASE DRAWSTYLE_smalldot   ; pattern := %1000100010001000
    CASE DRAWSTYLE_largedot2  ; pattern := %1111110011111100
    CASE DRAWSTYLE_dot2       ; pattern := %1111000011110000
    CASE DRAWSTYLE_smalldot2  ; pattern := %1100000011000000
  ENDSELECT

  IF rp THEN SetDrPt(rp,pattern)
ENDPROC

