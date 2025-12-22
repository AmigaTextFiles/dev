/* Application created by MUIBuild */

address example

MUIA_Gauge_Max = 0x8042bcdb
MUIA_Gauge_Current = 0x8042f0dd
MUIA_Gauge_Horiz = 0x804232dd
TRUE = 1
MUIA_Timer = 0x80426435
MUIV_EveryTime = 0x49893131
MUIA_Scale_Horiz = 0x8042919a

window COMMAND """quit""" PORT example
 group HORIZ
  label "Volume:"
  image ID VUP SPEC "6:11"
  group
   gauge ID VGAUG ATTRS MUIA_Gauge_Horiz TRUE MUIA_Gauge_Max 200 MUIA_Gauge_Current 20 LABEL "Volume %ld"
   object CLASS "Scale.mui" ATTRS MUIA_Scale_Horiz TRUE
  endgroup
  image ID VDN SPEC "6:12"
 endgroup
endwindow
callhook ID VUP COMMAND """options results; address example; gauge ID VGAUG ATTRS "MUIA_Gauge_Current"; gauge ID VGAUG ATTRS "MUIA_Gauge_Current" result+5;""" PORT INLINE ATTRS MUIA_Timer MUIV_EveryTime
callhook ID VDN COMMAND """options results; address example; gauge ID VGAUG ATTRS "MUIA_Gauge_Current"; gauge ID VGAUG ATTRS "MUIA_Gauge_Current" result-5;""" PORT INLINE ATTRS MUIA_Timer MUIV_EveryTime
