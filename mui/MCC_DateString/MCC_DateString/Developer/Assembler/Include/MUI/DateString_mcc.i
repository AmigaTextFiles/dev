**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: DateString_mcc.i 12.3 (04.04.97)
**

 IFND MUI_DATESTRING_I
MUI_DATESTRING_I	SET 1

** In case user forgets that this .i includes data
	bra	end_of_datestring_i

** Attributes

MUIA_DateString_DateFormat	EQU $81ee0047

** Pointers for strings

MUIC_DateString		dc.l MUIC_DateString_s

** Strings

MUIC_DateString_s	dc.b "DateString.mcc",0,0

end_of_datestring_i

 ENDC ; MUI_DATESTRING_I
