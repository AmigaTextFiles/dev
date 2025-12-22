PROGRAM CopperHammer;
{ A sample source for using user copper lists with PCQ and windowlib
  © 1997 THOR-Software }

{$I "Include:utils/windowlib.i"}
{$I "Include:utils/random.i"}
	
VAR
	screen		:	ScreenPtr;
	window		:	WindowPtr;
	cop		:	Array [0..255] of SHORT; { will contain our "copper list" }
	s		:	Integer;


{ draw a line in a given color, increments the position }
PROCEDURE lin(col : Integer;VAR x : Integer);
BEGIN
	Color(window,col);
	Line(window,x,0,x,255);
	x:=x+1;
END;

{ calculate the next color for a pipe }
FUNCTION sub(col,ad : Integer) : Integer;
VAR
	d		:	Integer;
BEGIN
	d:=15-ABS(ad-15);
	d:=d-col;
	IF d<0 THEN
		d:=0;
	sub:=d;
END;

{ draw a vertical pipe using HAM colors }
PROCEDURE Vertical2;
VAR
	co1,co2		:	Integer;
	c1,c2		:	Integer;
	f1,f2		:	Integer;
	x		:	Integer;
	i		:	Integer;
BEGIN
	REPEAT
		co1:=RangeRandom(2)*16+16;
		co2:=RangeRandom(2)*16+16;
	UNTIL co1<>co2;
	f1:=RangeRandom(7);
	f2:=RangeRandom(7);
	x:=RangeRandom(319);
	lin(5,x);
	IF s=1 THEN BEGIN
		FOR i:=0 TO 30 DO BEGIN
			c1:=sub(f1,i);
			c2:=sub(f2,i);
			IF c1+c2>0 THEN BEGIN
				lin(c1+co1,x);
				lin(c2+co2,x)
			END
		END
	END ELSE BEGIN
		FOR i:=0 TO 15 DO BEGIN
			c1:=sub(f1,i*2);
			c2:=sub(f2,i*2);
			IF c1+c2>0 THEN BEGIN
				lin(c1+co1,x);
				lin(c2+co2,x);
			END
		END
	END;
	lin(5,x);
END;

{ another pipe drawer, using only one color }
PROCEDURE Vertical;
VAR
	c,co		:	Integer;
	x		:	Integer;
	f1		:	Integer;
	i		:	Integer;
BEGIN	
	co:=RangeRandom(2)*16+16;
	x:=RangeRandom(319);
	f1:=RangeRandom(7);
	lin(5,x);
	IF s=1 THEN BEGIN
		FOR i:=0 TO 30 DO BEGIN
			c:=sub(f1,i);
			IF c>0 THEN
				lin(c+co,x)
		END
	END ELSE BEGIN
		FOR i:=0 TO 15 DO BEGIN
			c:=sub(f1,i*2);
			IF c>0 THEN
				lin(c+co,x)
		END
	END;
	lin(5,x)
END;

{ this does the main job: load the copperlist }
PROCEDURE CopperBuilder;
VAR
	j		:	Integer;
BEGIN
	{ the copper list is automatically created the first time you 
	  start a copper instruction. No need to initialize by hand,
	  this is done by windowlib }
	FOR j:=0 TO 255 DO BEGIN
		CopperWait(screen,0,j); 	{ wait for the correct position }
		CopperMove(screen,$180,cop[j])	{ move the color in the background color register }
	END;
	CopperDone(screen)	{ tell windowlib that we're done, load the copperlist }
END;

{ draw a horizontal pipe using the copper list }
PROCEDURE Horizontal;
VAR
	r,g,b		:	Integer;
	y,ym		:	Integer;
	i		:	Integer;
	c		:	Integer;
BEGIN
	Color(window,0);
	r:=RangeRandom(6);
	g:=RangeRandom(6);
	b:=RangeRandom(6);
	CASE s OF
		1:	ym:=RangeRandom(254-30);
		2:	ym:=RangeRandom(254-15);
		3:	ym:=RangeRandom(254-60);
	END;
	y:=ym;
	CASE s OF
		1:	BEGIN
				FOR i:=0 TO 30 DO BEGIN
					c:=sub(b,i);
					c:=c+16*sub(g,i);
					c:=c+256*sub(r,i);
					IF c>0 THEN BEGIN
						cop[ym]:=c;
						ym:=ym+1;
					END
				END
			END;
		2:	BEGIN
				FOR i:=0 TO 15 DO BEGIN
					c:=sub(b,i*2);
					c:=c+16*sub(g,i*2);
					c:=c+256*sub(r,i*2);
					IF c>0 THEN BEGIN
						cop[ym]:=c;
						ym:=ym+1;
					END
				END
			END;
		3:	BEGIN
				FOR i:=0 TO 60 DO BEGIN
					c:=sub(b,i DIV 2);
					c:=c+16*sub(g,i DIV 2);
					c:=c+256*sub(r,i DIV 2);
					IF c>0 THEN BEGIN
						cop[ym]:=c;
						ym:=ym+1;
					END
				END
			END;
	END;
	CopperBuilder; { build the copper list }
	PBox(window,0,y,319,ym-1); {make it visible by showing the background color }
END;

	
BEGIN

	InitGraphics;
	SelfSeed;

	screen:=OpenAScreen(0,0,320,256,6,MON_PAL OR MON_HAM,"CopperHammer");
	IF screen<>NIL THEN BEGIN
		SetColor(screen,0,0,0,0);
		SetColor(screen,5,0,0,0);
		window:=OpenScreenWindow(screen,0,0,320,256,$1900,NIL);
		IF window<>NIL THEN BEGIN
			BGColor(window,1);
			ClearWindow(window);
			BGColor(window,0);
			REPEAT
				s:=RangeRandom(1)+1;
				CASE RangeRandom(3) OF
					0:
						Horizontal;
					1:
						Vertical;
					2:
						Vertical2;
					3:	BEGIN
						s:=s+1;
						Horizontal;
						END;
				END
			UNTIL MouseButton(window);
			CloseAWindow(window)
		END;
		CloseAScreen(screen);
	END;

	ExitGraphics;
END.