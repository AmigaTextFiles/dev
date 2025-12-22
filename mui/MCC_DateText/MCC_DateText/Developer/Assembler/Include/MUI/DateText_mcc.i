**
** Copyright © 1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: DateText_mcc.i 12.0 (19.08.97)
**

 IFND MUI_DATETEXT_I
MUI_DATETEXT_I	SET 1

** In case user forgets that this .i includes data
	bra	end_of_datetext_i

** Attributes

MUIA_DateText_DateFormat	EQU $81ee0059

** Pointers for strings

MUIC_DateText		dc.l MUIC_DateText_s

** Strings

MUIC_DateText_s	dc.b "DateText.mcc",0,0

end_of_datetext_i

 ENDC ; MUI_DATETEXT_I
