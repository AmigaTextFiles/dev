pattern GetCopyNV(_appName,_itemName,_killRequesters) is
	push a6;
	safe a0:=_appName; a1:=_itemName; d1.l:=_killRequesters;;
	a6:=NVBase; jsr [a6-30];
	pop a6;
endp;															# GETCOPYNV

pattern FreeNVData(_data) is
	push a6;
	a0:=_data;
	a6:=NVBase; jsr [a6-36];
	pop a6;
endp;															# FREENVDATA

pattern StoreNV(_appName,_itemName,_data,_length,_killRequesters) is
	push a2\a6;
	safe a0:=_appName; a1:=_itemName; a2:=_data; d0.l:=_length; d1.l:=_killRequesters;;
	a6:=NVBase; jsr [a6-42];
	pop a2\a6;
endp;															# STORENV

pattern DeleteNV(_appName,_itemName,_killRequesters) is
	push a6;
	safe a0:=_appName; a1:=_itemName; d1.l:=_killRequesters;;
	a6:=NVBase; jsr [a6-48];
	pop a6;
endp;															# DELETENV

pattern GetNVInfo(_killRequesters) is
	push a6;
	d1.l:=_killRequesters;
	a6:=NVBase; jsr [a6-54];
	pop a6;
endp;															# GETNVINFO

pattern GetNVList(_appName,_killRequesters) is
	push a6;
	safe a0:=_appName; d1.l:=_killRequesters;;
	a6:=NVBase; jsr [a6-60];
	pop a6;
endp;															# GETNVLIST

pattern SetNVProtection(_appName,_itemName,_mask,_killRequesters) is
	push d2\a6;
	safe a0:=_appName; a1:=_itemName; d2.l:=_mask; d1.l:=_killRequesters;;
	a6:=NVBase; jsr [a6-66];
	pop d2\a6;
endp;															# SETNVPROTECTION

