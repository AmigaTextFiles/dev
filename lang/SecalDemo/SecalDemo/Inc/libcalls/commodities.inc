pattern CreateCxObj(_type,_arg1,_arg2) is
	push a6;
	safe d0.l:=_type; a0:=_arg1; a1:=_arg2;;
	a6:=CxBase; jsr [a6-30];
	pop a6;
endp;															# CREATECXOBJ

pattern CxBroker(_nb,_error) is
	push a6;
	safe a0:=_nb; d0.l:=_error;;
	a6:=CxBase; jsr [a6-36];
	pop a6;
endp;															# CXBROKER

pattern ActivateCxObj(_co,_true) is
	push a6;
	safe a0:=_co; d0.l:=_true;;
	a6:=CxBase; jsr [a6-42];
	pop a6;
endp;															# ACTIVATECXOBJ

pattern DeleteCxObj(_co) is
	push a6;
	a0:=_co;
	a6:=CxBase; jsr [a6-48];
	pop a6;
endp;															# DELETECXOBJ

pattern DeleteCxObjAll(_co) is
	push a6;
	a0:=_co;
	a6:=CxBase; jsr [a6-54];
	pop a6;
endp;															# DELETECXOBJALL

pattern CxObjType(_co) is
	push a6;
	a0:=_co;
	a6:=CxBase; jsr [a6-60];
	pop a6;
endp;															# CXOBJTYPE

pattern CxObjError(_co) is
	push a6;
	a0:=_co;
	a6:=CxBase; jsr [a6-66];
	pop a6;
endp;															# CXOBJERROR

pattern ClearCxObjError(_co) is
	push a6;
	a0:=_co;
	a6:=CxBase; jsr [a6-72];
	pop a6;
endp;															# CLEARCXOBJERROR

pattern SetCxObjPri(_co,_pri) is
	push a6;
	safe a0:=_co; d0.l:=_pri;;
	a6:=CxBase; jsr [a6-78];
	pop a6;
endp;															# SETCXOBJPRI

pattern AttachCxObj(_headObj,_co) is
	push a6;
	safe a0:=_headObj; a1:=_co;;
	a6:=CxBase; jsr [a6-84];
	pop a6;
endp;															# ATTACHCXOBJ

pattern EnqueueCxObj(_headObj,_co) is
	push a6;
	safe a0:=_headObj; a1:=_co;;
	a6:=CxBase; jsr [a6-90];
	pop a6;
endp;															# ENQUEUECXOBJ

pattern InsertCxObj(_headObj,_co,_pred) is
	push a2\a6;
	safe a0:=_headObj; a1:=_co; a2:=_pred;;
	a6:=CxBase; jsr [a6-96];
	pop a2\a6;
endp;															# INSERTCXOBJ

pattern RemoveCxObj(_co) is
	push a6;
	a0:=_co;
	a6:=CxBase; jsr [a6-102];
	pop a6;
endp;															# REMOVECXOBJ

pattern commoditiesPrivate1 is
	push a6;
	a6:=CxBase; jsr [a6-108];
	pop a6;
endp;															# COMMODITIESPRIVATE1

pattern SetTranslate(_translator,_events) is
	push a6;
	safe a0:=_translator; a1:=_events;;
	a6:=CxBase; jsr [a6-114];
	pop a6;
endp;															# SETTRANSLATE

pattern SetFilter(_filter,_text) is
	push a6;
	safe a0:=_filter; a1:=_text;;
	a6:=CxBase; jsr [a6-120];
	pop a6;
endp;															# SETFILTER

pattern SetFilterIX(_filter,_ix) is
	push a6;
	safe a0:=_filter; a1:=_ix;;
	a6:=CxBase; jsr [a6-126];
	pop a6;
endp;															# SETFILTERIX

pattern ParseIX(_description,_ix) is
	push a6;
	safe a0:=_description; a1:=_ix;;
	a6:=CxBase; jsr [a6-132];
	pop a6;
endp;															# PARSEIX

pattern CxMsgType(_cxm) is
	push a6;
	a0:=_cxm;
	a6:=CxBase; jsr [a6-138];
	pop a6;
endp;															# CXMSGTYPE

pattern CxMsgData(_cxm) is
	push a6;
	a0:=_cxm;
	a6:=CxBase; jsr [a6-144];
	pop a6;
endp;															# CXMSGDATA

pattern CxMsgID(_cxm) is
	push a6;
	a0:=_cxm;
	a6:=CxBase; jsr [a6-150];
	pop a6;
endp;															# CXMSGID

pattern DivertCxMsg(_cxm,_headObj,_returnObj) is
	push a2\a6;
	safe a0:=_cxm; a1:=_headObj; a2:=_returnObj;;
	a6:=CxBase; jsr [a6-156];
	pop a2\a6;
endp;															# DIVERTCXMSG

pattern RouteCxMsg(_cxm,_co) is
	push a6;
	safe a0:=_cxm; a1:=_co;;
	a6:=CxBase; jsr [a6-162];
	pop a6;
endp;															# ROUTECXMSG

pattern DisposeCxMsg(_cxm) is
	push a6;
	a0:=_cxm;
	a6:=CxBase; jsr [a6-168];
	pop a6;
endp;															# DISPOSECXMSG

pattern InvertKeyMap(_ansiCode,_event,_km) is
	push a6;
	safe d0.l:=_ansiCode; a0:=_event; a1:=_km;;
	a6:=CxBase; jsr [a6-174];
	pop a6;
endp;															# INVERTKEYMAP

pattern AddIEvents(_events) is
	push a6;
	a0:=_events;
	a6:=CxBase; jsr [a6-180];
	pop a6;
endp;															# ADDIEVENTS

pattern commoditiesPrivate2 is
	push a6;
	a6:=CxBase; jsr [a6-186];
	pop a6;
endp;															# COMMODITIESPRIVATE2

pattern commoditiesPrivate3 is
	push a6;
	a6:=CxBase; jsr [a6-192];
	pop a6;
endp;															# COMMODITIESPRIVATE3

pattern commoditiesPrivate4 is
	push a6;
	a6:=CxBase; jsr [a6-198];
	pop a6;
endp;															# COMMODITIESPRIVATE4

pattern MatchIX(_event,_ix) is
	push a6;
	safe a0:=_event; a1:=_ix;;
	a6:=CxBase; jsr [a6-204];
	pop a6;
endp;															# MATCHIX

pattern commoditiesPrivate5 is
	push a6;
	a6:=CxBase; jsr [a6-210];
	pop a6;
endp;															# COMMODITIESPRIVATE5

pattern commoditiesPrivate6 is
	push a6;
	a6:=CxBase; jsr [a6-216];
	pop a6;
endp;															# COMMODITIESPRIVATE6

pattern commoditiesPrivate7 is
	push a6;
	a6:=CxBase; jsr [a6-222];
	pop a6;
endp;															# COMMODITIESPRIVATE7

pattern commoditiesPrivate8 is
	push a6;
	a6:=CxBase; jsr [a6-228];
	pop a6;
endp;															# COMMODITIESPRIVATE8

pattern commoditiesPrivate9 is
	push a6;
	a6:=CxBase; jsr [a6-234];
	pop a6;
endp;															# COMMODITIESPRIVATE9

