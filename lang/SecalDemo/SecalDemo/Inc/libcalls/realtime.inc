pattern LockRealTime(_lockType) is
	push a6;
	d0.l:=_lockType;
	a6:=RealTimeBase; jsr [a6-30];
	pop a6;
endp;															# LOCKREALTIME

pattern UnlockRealTime(_lock) is
	push a6;
	a0:=_lock;
	a6:=RealTimeBase; jsr [a6-36];
	pop a6;
endp;															# UNLOCKREALTIME

pattern CreatePlayerA(_tagList) is
	push a6;
	a0:=_tagList;
	a6:=RealTimeBase; jsr [a6-42];
	pop a6;
endp;															# CREATEPLAYERA

pattern DeletePlayer(_player) is
	push a6;
	a0:=_player;
	a6:=RealTimeBase; jsr [a6-48];
	pop a6;
endp;															# DELETEPLAYER

pattern SetPlayerAttrsA(_player,_tagList) is
	push a6;
	safe a0:=_player; a1:=_tagList;;
	a6:=RealTimeBase; jsr [a6-54];
	pop a6;
endp;															# SETPLAYERATTRSA

pattern SetConductorState(_player,_state,_time) is
	push a6;
	safe a0:=_player; d0.l:=_state; d1.l:=_time;;
	a6:=RealTimeBase; jsr [a6-60];
	pop a6;
endp;															# SETCONDUCTORSTATE

pattern ExternalSync(_player,_minTime,_maxTime) is
	push a6;
	safe a0:=_player; d0.l:=_minTime; d1.l:=_maxTime;;
	a6:=RealTimeBase; jsr [a6-66];
	pop a6;
endp;															# EXTERNALSYNC

pattern NextConductor(_previousConductor) is
	push a6;
	a0:=_previousConductor;
	a6:=RealTimeBase; jsr [a6-72];
	pop a6;
endp;															# NEXTCONDUCTOR

pattern FindConductor(_name) is
	push a6;
	a0:=_name;
	a6:=RealTimeBase; jsr [a6-78];
	pop a6;
endp;															# FINDCONDUCTOR

pattern GetPlayerAttrsA(_player,_tagList) is
	push a6;
	safe a0:=_player; a1:=_tagList;;
	a6:=RealTimeBase; jsr [a6-84];
	pop a6;
endp;															# GETPLAYERATTRSA

