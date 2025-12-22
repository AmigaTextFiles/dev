pattern ReadJoyPort(_port) is
	push a6;
	d0.l:=_port;
	a6:=LowLevelBase; jsr [a6-30];
	pop a6;
endp;															# READJOYPORT

pattern GetLanguageSelection is
	push a6;
	a6:=LowLevelBase; jsr [a6-36];
	pop a6;
endp;															# GETLANGUAGESELECTION

pattern lowlevelPrivate1 is
	push a6;
	a6:=LowLevelBase; jsr [a6-42];
	pop a6;
endp;															# LOWLEVELPRIVATE1

pattern GetKey is
	push a6;
	a6:=LowLevelBase; jsr [a6-48];
	pop a6;
endp;															# GETKEY

pattern QueryKeys(_queryArray,_arraySize) is
	push a6;
	safe a0:=_queryArray; d1.l:=_arraySize;;
	a6:=LowLevelBase; jsr [a6-54];
	pop a6;
endp;															# QUERYKEYS

pattern AddKBInt(_intRoutine,_intData) is
	push a6;
	safe a0:=_intRoutine; a1:=_intData;;
	a6:=LowLevelBase; jsr [a6-60];
	pop a6;
endp;															# ADDKBINT

pattern RemKBInt(_intHandle) is
	push a6;
	a1:=_intHandle;
	a6:=LowLevelBase; jsr [a6-66];
	pop a6;
endp;															# REMKBINT

pattern SystemControlA(_tagList) is
	push a6;
	a1:=_tagList;
	a6:=LowLevelBase; jsr [a6-72];
	pop a6;
endp;															# SYSTEMCONTROLA

pattern AddTimerInt(_intRoutine,_intData) is
	push a6;
	safe a0:=_intRoutine; a1:=_intData;;
	a6:=LowLevelBase; jsr [a6-78];
	pop a6;
endp;															# ADDTIMERINT

pattern RemTimerInt(_intHandle) is
	push a6;
	a1:=_intHandle;
	a6:=LowLevelBase; jsr [a6-84];
	pop a6;
endp;															# REMTIMERINT

pattern StopTimerInt(_intHandle) is
	push a6;
	a1:=_intHandle;
	a6:=LowLevelBase; jsr [a6-90];
	pop a6;
endp;															# STOPTIMERINT

pattern StartTimerInt(_intHandle,_timeInterval,_continuous) is
	push a6;
	safe a1:=_intHandle; d0.l:=_timeInterval; d1.l:=_continuous;;
	a6:=LowLevelBase; jsr [a6-96];
	pop a6;
endp;															# STARTTIMERINT

pattern ElapsedTime(_context) is
	push a6;
	a0:=_context;
	a6:=LowLevelBase; jsr [a6-102];
	pop a6;
endp;															# ELAPSEDTIME

pattern AddVBlankInt(_intRoutine,_intData) is
	push a6;
	safe a0:=_intRoutine; a1:=_intData;;
	a6:=LowLevelBase; jsr [a6-108];
	pop a6;
endp;															# ADDVBLANKINT

pattern RemVBlankInt(_intHandle) is
	push a6;
	a1:=_intHandle;
	a6:=LowLevelBase; jsr [a6-114];
	pop a6;
endp;															# REMVBLANKINT

pattern lowlevelPrivate2 is
	push a6;
	a6:=LowLevelBase; jsr [a6-120];
	pop a6;
endp;															# LOWLEVELPRIVATE2

pattern lowlevelPrivate3 is
	push a6;
	a6:=LowLevelBase; jsr [a6-126];
	pop a6;
endp;															# LOWLEVELPRIVATE3

pattern SetJoyPortAttrsA(_portNumber,_tagList) is
	push a6;
	safe d0.l:=_portNumber; a1:=_tagList;;
	a6:=LowLevelBase; jsr [a6-132];
	pop a6;
endp;															# SETJOYPORTATTRSA

pattern lowlevelPrivate4 is
	push a6;
	a6:=LowLevelBase; jsr [a6-138];
	pop a6;
endp;															# LOWLEVELPRIVATE4

pattern lowlevelPrivate5 is
	push a6;
	a6:=LowLevelBase; jsr [a6-144];
	pop a6;
endp;															# LOWLEVELPRIVATE5

pattern lowlevelPrivate6 is
	push a6;
	a6:=LowLevelBase; jsr [a6-150];
	pop a6;
endp;															# LOWLEVELPRIVATE6

pattern lowlevelPrivate7 is
	push a6;
	a6:=LowLevelBase; jsr [a6-156];
	pop a6;
endp;															# LOWLEVELPRIVATE7

pattern lowlevelPrivate8 is
	push a6;
	a6:=LowLevelBase; jsr [a6-162];
	pop a6;
endp;															# LOWLEVELPRIVATE8

