pattern ResetBattClock is
	push a6;
	a6:=BattClockBase; jsr [a6-6];
	pop a6;
endp;															# RESETBATTCLOCK

pattern ReadBattClock is
	push a6;
	a6:=BattClockBase; jsr [a6-12];
	pop a6;
endp;															# READBATTCLOCK

pattern WriteBattClock(_time) is
	push a6;
	d0.l:=_time;
	a6:=BattClockBase; jsr [a6-18];
	pop a6;
endp;															# WRITEBATTCLOCK

pattern battclockPrivate1 is
	push a6;
	a6:=BattClockBase; jsr [a6-24];
	pop a6;
endp;															# BATTCLOCKPRIVATE1

pattern battclockPrivate2 is
	push a6;
	a6:=BattClockBase; jsr [a6-30];
	pop a6;
endp;															# BATTCLOCKPRIVATE2

