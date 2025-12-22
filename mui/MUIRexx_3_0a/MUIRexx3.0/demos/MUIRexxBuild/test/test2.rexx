/* Application created by MUIBuild */

address TEST2

Numeric_Value = 0x8042ae3a
Gauge_Current = 0x8042f0dd
Gauge_Horiz = 0x804232dd
Weight = 0x80421d1f
Notify = 0x8042c9cb
EveryTime = 0x49893131
Set = 0x8042549a
TriggerValue = 0x49893131
ASLFR_DrawersOnly = 0x8008002F
TRUE = 1
ASLFR_TitleText = 0x80080001

window COMMAND """quit""" PORT TEST2 TITLE """A Test"""
 group FRAME HORIZ
  space HORIZ
  knob ID KNOB
  meter ID METR LABEL "meter"
  space HORIZ
 endgroup
 group FRAME
  slider COMMAND """gauge ID GAUG ATTRS 0x8042f0dd %s""" PORT TEST2 ATTRS Numeric_Value 50
  gauge ID GAUG ATTRS Gauge_Current 50 Gauge_Horiz 1 LABEL "Level %ld"
  object CLASS "Scale.mui"
 endgroup
 object CLASS "Busy.mcc" ATTRS Weight 0
 popasl SPEC "6:20" ATTRS ASLFR_DrawersOnly TRUE ASLFR_TitleText """Select Drawer"""
 poplist LABELS """entry 1,entry 2,entry 3"""
endwindow
method ID KNOB Notify Numeric_Value EveryTime @METR 3 Set Numeric_Value TriggerValue
