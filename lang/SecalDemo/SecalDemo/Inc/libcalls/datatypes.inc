pattern datatypesPrivate1 is
	push a6;
	a6:=DataTypesBase; jsr [a6-30];
	pop a6;
endp;															# DATATYPESPRIVATE1

pattern ObtainDataTypeA(_type,_handle,_attrs) is
	push a6;
	safe d0.l:=_type; a0:=_handle; a1:=_attrs;;
	a6:=DataTypesBase; jsr [a6-36];
	pop a6;
endp;															# OBTAINDATATYPEA

pattern ReleaseDataType(_dt) is
	push a6;
	a0:=_dt;
	a6:=DataTypesBase; jsr [a6-42];
	pop a6;
endp;															# RELEASEDATATYPE

pattern NewDTObjectA(_name,_attrs) is
	push a6;
	safe d0.l:=_name; a0:=_attrs;;
	a6:=DataTypesBase; jsr [a6-48];
	pop a6;
endp;															# NEWDTOBJECTA

pattern DisposeDTObject(_o) is
	push a6;
	a0:=_o;
	a6:=DataTypesBase; jsr [a6-54];
	pop a6;
endp;															# DISPOSEDTOBJECT

pattern SetDTAttrsA(_o,_win,_req,_attrs) is
	push a2\a3\a6;
	safe a0:=_o; a1:=_win; a2:=_req; a3:=_attrs;;
	a6:=DataTypesBase; jsr [a6-60];
	pop a2\a3\a6;
endp;															# SETDTATTRSA

pattern GetDTAttrsA(_o,_attrs) is
	push a2\a6;
	safe a0:=_o; a2:=_attrs;;
	a6:=DataTypesBase; jsr [a6-66];
	pop a2\a6;
endp;															# GETDTATTRSA

pattern AddDTObject(_win,_req,_o,_pos) is
	push a2\a6;
	safe a0:=_win; a1:=_req; a2:=_o; d0.l:=_pos;;
	a6:=DataTypesBase; jsr [a6-72];
	pop a2\a6;
endp;															# ADDDTOBJECT

pattern RefreshDTObjectA(_o,_win,_req,_attrs) is
	push a2\a3\a6;
	safe a0:=_o; a1:=_win; a2:=_req; a3:=_attrs;;
	a6:=DataTypesBase; jsr [a6-78];
	pop a2\a3\a6;
endp;															# REFRESHDTOBJECTA

pattern DoAsyncLayout(_o,_gpl) is
	push a6;
	safe a0:=_o; a1:=_gpl;;
	a6:=DataTypesBase; jsr [a6-84];
	pop a6;
endp;															# DOASYNCLAYOUT

pattern DoDTMethodA(_o,_win,_req,_msg) is
	push a2\a3\a6;
	safe a0:=_o; a1:=_win; a2:=_req; a3:=_msg;;
	a6:=DataTypesBase; jsr [a6-90];
	pop a2\a3\a6;
endp;															# DODTMETHODA

pattern RemoveDTObject(_win,_o) is
	push a6;
	safe a0:=_win; a1:=_o;;
	a6:=DataTypesBase; jsr [a6-96];
	pop a6;
endp;															# REMOVEDTOBJECT

pattern GetDTMethods(_object) is
	push a6;
	a0:=_object;
	a6:=DataTypesBase; jsr [a6-102];
	pop a6;
endp;															# GETDTMETHODS

pattern GetDTTriggerMethods(_object) is
	push a6;
	a0:=_object;
	a6:=DataTypesBase; jsr [a6-108];
	pop a6;
endp;															# GETDTTRIGGERMETHODS

pattern PrintDTObjectA(_o,_w,_r,_msg) is
	push a2\a3\a6;
	safe a0:=_o; a1:=_w; a2:=_r; a3:=_msg;;
	a6:=DataTypesBase; jsr [a6-114];
	pop a2\a3\a6;
endp;															# PRINTDTOBJECTA

pattern datatypesPrivate2 is
	push a6;
	a6:=DataTypesBase; jsr [a6-120];
	pop a6;
endp;															# DATATYPESPRIVATE2

pattern datatypesPrivate3 is
	push a6;
	a6:=DataTypesBase; jsr [a6-126];
	pop a6;
endp;															# DATATYPESPRIVATE3

pattern datatypesPrivate4 is
	push a6;
	a6:=DataTypesBase; jsr [a6-132];
	pop a6;
endp;															# DATATYPESPRIVATE4

pattern GetDTString(_id) is
	push a6;
	d0.l:=_id;
	a6:=DataTypesBase; jsr [a6-138];
	pop a6;
endp;															# GETDTSTRING

