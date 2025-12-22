**
** Copyright © 1996-1997 Kai Hofmann. All rights reserved.
** Registered MUI custom class!
**
** $VER: TimeString_mcc.i 12.5 (18.10.97)
**

 IFND MUI_TIMESTRING_I
MUI_TIMESTRING_I	SET 1

** In case user forgets that this .i includes data

	bra	end_of_timestring_i

** Attributes

MUIA_TimeString_TimeFormat	EQU $81ee008a

** Pointers for strings

MUIC_TimeString		dc.l MUIC_TimeString_s

** Strings

MUIC_TimeString_s	dc.b "TimeString.mcc",0,0

end_of_timestring_i

 ENDC ; MUI_TIMESTRING_I
