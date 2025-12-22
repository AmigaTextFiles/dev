pattern CreatePlayer( ...) is
	push a6;
	push.l ...;
	a0:=sp;
	a6:=RealTimeBase; jsr [a6-42];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# CREATEPLAYER

pattern GetPlayerAttrs(_player, ...) is
	push a6;
	push.l ...;
	safe a0:=_player; a1:=sp;;
	a6:=RealTimeBase; jsr [a6-84];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# GETPLAYERATTRS

pattern SetPlayerAttrs(_player, ...) is
	push a6;
	push.l ...;
	safe a0:=_player; a1:=sp;;
	a6:=RealTimeBase; jsr [a6-54];
	sp:=sp+countof(...)<<2;
	pop a6;
endp;															# SETPLAYERATTRS

