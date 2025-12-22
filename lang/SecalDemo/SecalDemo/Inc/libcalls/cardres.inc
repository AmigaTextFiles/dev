pattern OwnCard(_handle) is
	push a6;
	a1:=_handle;
	a6:=CardResource; jsr [a6-6];
	pop a6;
endp;															# OWNCARD

pattern ReleaseCard(_handle,_flags) is
	push a6;
	safe a1:=_handle; d0.l:=_flags;;
	a6:=CardResource; jsr [a6-12];
	pop a6;
endp;															# RELEASECARD

pattern GetCardMap is
	push a6;
	a6:=CardResource; jsr [a6-18];
	pop a6;
endp;															# GETCARDMAP

pattern BeginCardAccess(_handle) is
	push a6;
	a1:=_handle;
	a6:=CardResource; jsr [a6-24];
	pop a6;
endp;															# BEGINCARDACCESS

pattern EndCardAccess(_handle) is
	push a6;
	a1:=_handle;
	a6:=CardResource; jsr [a6-30];
	pop a6;
endp;															# ENDCARDACCESS

pattern ReadCardStatus is
	push a6;
	a6:=CardResource; jsr [a6-36];
	pop a6;
endp;															# READCARDSTATUS

pattern CardResetRemove(_handle,_flag) is
	push a6;
	safe a1:=_handle; d0.l:=_flag;;
	a6:=CardResource; jsr [a6-42];
	pop a6;
endp;															# CARDRESETREMOVE

pattern CardMiscControl(_handle,_control_bits) is
	push a6;
	safe a1:=_handle; d1.l:=_control_bits;;
	a6:=CardResource; jsr [a6-48];
	pop a6;
endp;															# CARDMISCCONTROL

pattern CardAccessSpeed(_handle,_nanoseconds) is
	push a6;
	safe a1:=_handle; d0.l:=_nanoseconds;;
	a6:=CardResource; jsr [a6-54];
	pop a6;
endp;															# CARDACCESSSPEED

pattern CardProgramVoltage(_handle,_voltage) is
	push a6;
	safe a1:=_handle; d0.l:=_voltage;;
	a6:=CardResource; jsr [a6-60];
	pop a6;
endp;															# CARDPROGRAMVOLTAGE

pattern CardResetCard(_handle) is
	push a6;
	a1:=_handle;
	a6:=CardResource; jsr [a6-66];
	pop a6;
endp;															# CARDRESETCARD

pattern CopyTuple(_handle,_buffer,_tuplecode,_size) is
	push a6;
	safe a1:=_handle; a0:=_buffer; d1.l:=_tuplecode; d0.l:=_size;;
	a6:=CardResource; jsr [a6-72];
	pop a6;
endp;															# COPYTUPLE

pattern DeviceTuple(_tuple_data,_storage) is
	push a6;
	safe a0:=_tuple_data; a1:=_storage;;
	a6:=CardResource; jsr [a6-78];
	pop a6;
endp;															# DEVICETUPLE

pattern IfAmigaXIP(_handle) is
	push a2\a6;
	a2:=_handle;
	a6:=CardResource; jsr [a6-84];
	pop a2\a6;
endp;															# IFAMIGAXIP

pattern CardForceChange is
	push a6;
	a6:=CardResource; jsr [a6-90];
	pop a6;
endp;															# CARDFORCECHANGE

pattern CardChangeCount is
	push a6;
	a6:=CardResource; jsr [a6-96];
	pop a6;
endp;															# CARDCHANGECOUNT

pattern CardInterface is
	push a6;
	a6:=CardResource; jsr [a6-102];
	pop a6;
endp;															# CARDINTERFACE

