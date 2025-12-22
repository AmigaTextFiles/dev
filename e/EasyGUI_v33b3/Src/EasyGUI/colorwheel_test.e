MODULE 'tools/easygui', 'tools/exceptions',
       'gadgets/colorwheel',
       'plugins/colorwheel'

DEF rgb:colorwheelrgb, hsb:colorwheelhsb, title

PROC init(rgb:PTR TO colorwheelrgb)
  rgb.red:=-1;  rgb.blue:=0;  rgb.green:=0
ENDPROC

PROC main() HANDLE
  DEF c=NIL:PTR TO colorwheel
  init(rgb)
  NEW c.colorwheel(rgb,NIL,TRUE)
  easyguiA('BOOPSI in EasyGUI!',
    [ROWS,
      title:=[TEXT,'Colorwheel test (using RGB)...',NIL,TRUE,1],
      [COLS,
        [PLUGIN,{colorwheelaction},c],
        [EQROWS,
          [BUTTON,{reset},'Reset',c],
          [BUTTON,{swap},'RGB/HSB',c],
          [BUTTON,{toggle_enabled},'Toggle Enabled',c]
        ]
      ]
    ])
EXCEPT DO
  END c
  report_exception()
ENDPROC

PROC colorwheelaction(i,c:PTR TO colorwheel)
  IF c.rgb
    PrintF('RGB r=$\h, g=$\h, b=$\h\n',
           c.rgb.red, c.rgb.green, c.rgb.blue)
  ELSE
    PrintF('HSB h=$\h, s=$\h, b=$\h\n',
           c.hsb.hue, c.hsb.saturation, c.hsb.brightness)
  ENDIF
ENDPROC

PROC reset(c:PTR TO colorwheel,gh)
  init(rgb)
  c.setrgb(rgb)
  settext(gh,title,'Reset Colorwheel to RGB...')
ENDPROC

PROC swap(c:PTR TO colorwheel,gh)
  IF c.rgb
    settext(gh,title,'Now Colorwheel is HSB...')
    c.gethsb(hsb)
    c.sethsb(hsb)
  ELSE
    settext(gh,title,'Colorwheel using RGB...')
    c.getrgb(rgb)
    c.setrgb(rgb)
  ENDIF
ENDPROC

PROC toggle_enabled(c:PTR TO colorwheel,i)
  c.setdisabled(c.disabled=FALSE)
ENDPROC
