**
** Copyright © 1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: TimeText_mcc.i 12.0 (27.07.97)
**

 IFND MUI_TIMETEXT_I
MUI_TIMETEXT_I	SET 1

** In case user forgets that this .i includes data

	bra	end_of_timetext_i

** Attributes

MUIA_TimeText_TimeFormat	EQU $81ee0098

** Pointers for strings

MUIC_TimeText		dc.l MUIC_TimeText_s

** Strings

MUIC_TimeText_s	dc.b "TimeText.mcc",0,0

end_of_timetext_i

 ENDC ; MUI_TIMETEXT_I
