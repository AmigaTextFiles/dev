OPT     LARGE
OPT     OSVERSION = 37

MODULE  'newgui/newgui'
MODULE  'gadgets/colorwheel'
MODULE  'newgui/colorwheel'

DEF     rgb:colorwheelrgb,
        hsb:colorwheelhsb,
        title,
        c=NIL:PTR TO colorwheel

PROC main() HANDLE
 init(rgb)
      newguiA([
        NG_WINDOWTITLE, 'NewGUI-ColorwheelPlugin',     
        NG_BFPATTERN,   [$AAAA,$5555]:INT,                      /* Backfillpattern (Muster)             */
        NG_BFEXP,       1,                                      /* Exponent (-> graphics/gfxmacros/SetAfPt)     */
        NG_BFBACKPEN,   3,                                      /* Hintergrundstift für den Pattern     */
        NG_BFFRONTPEN,  2,                                      /* Zeichenstift für den Pattern         */
/*                                                              /* ARexx-Port hinzufügen!               */
        NG_REXXNAME,    'NEWGUI',                               /* Name für einen ARexx-Port            */
        NG_REXXPROC,    {rexxmsg},                              /* Prozedur die ARexx-Messages auswertet*/
*/                                                              /* Durch den Port wird das EXE nicht größer!    */
        NG_GUI,
        [ROWS,
                title:=[TEXT,'Colorwheel test (using RGB)...',NIL,TRUE,1],
        [COLS,
                [COLORWHEEL,{colorwheelaction},NEW c.colorwheel(rgb,NIL,TRUE)],
        [EQROWS,
                [BUTTON,{reset},'Reset',c],
                [BUTTON,{swap},'RGB/HSB',c],
                [BUTTON,{toggle_enabled},'Toggle Enabled',c]
        ]
        ]
        ],NIL,NIL])
EXCEPT DO
 END c
ENDPROC

PROC init(rgb:PTR TO colorwheelrgb)
 rgb.red:=-1
  rgb.blue:=0
 rgb.green:=0
ENDPROC

PROC colorwheelaction(i,c:PTR TO colorwheel)
  IF c.rgb
    WriteF('RGB r=$\h, g=$\h, b=$\h\n',
           c.rgb.red, c.rgb.green, c.rgb.blue)
  ELSE
    WriteF('HSB h=$\h, s=$\h, b=$\h\n',
           c.hsb.hue, c.hsb.saturation, c.hsb.brightness)
  ENDIF
ENDPROC

PROC reset(c:PTR TO colorwheel,gh)
 init(rgb)
  c.setrgb(rgb)
   ng_setattrsA([NG_GUI,gh,
        NG_CHANGEGAD,TEXT,NG_GADGET,title,NG_NEWDATA,'Reset Colorwheel to RGB...',NIL,NIL])
ENDPROC

PROC swap(c:PTR TO colorwheel,gh)
  IF c.rgb
   ng_setattrsA([NG_GUI,gh,
        NG_CHANGEGAD,TEXT,NG_GADGET,title,NG_NEWDATA,'Now Colorwheel is HSB...',NIL,NIL])
     c.gethsb(hsb)
    c.sethsb(hsb)
  ELSE
   ng_setattrsA([NG_GUI,gh,
        NG_CHANGEGAD,TEXT,NG_GADGET,title,NG_NEWDATA,'Colorwheel using RGB...',NIL,NIL])
     c.getrgb(rgb)
    c.setrgb(rgb)
  ENDIF
ENDPROC

PROC toggle_enabled(c:PTR TO colorwheel,i)
  c.setdisabled(c.disabled=FALSE)
ENDPROC
