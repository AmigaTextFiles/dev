PROGRAM CircleMaze;
{This program generates a maze consisting of cirular arcs, or a nice pattern
 if you wish. Another example what's possible with the windowlib.
 They are again based on a so called Truchet-Tiling.
 © 1997 THOR-Software}

{Include the windowlib and the random generator}

{$I "Include:utils/windowlib.i"}
{$I "Include:utils/random.i"}
	
	
CONST
	pi		=	3.14159326;
	radius		=	4;
	size		=	8;
	
	
VAR
	window		:	WindowPtr;
	x,y		:	INTEGER;
	
	
{draw a circulcar arc, giving center position and starting/ending angle}
PROCEDURE DrawArc(mx,my : INTEGER; from,last : INTEGER);
VAR
	i	:	INTEGER;
	arc	:	REAL;
	connect	:	BOOLEAN;
	x,y	:	INTEGER;
	
BEGIN

	connect:=FALSE;
	
	FOR i:=from*12 TO last*12 DO BEGIN
		arc:=i*pi/24;
		x:=2*radius*cos(arc)+mx+0.5;
		y:=-radius*sin(arc)+my+0.5;
		IF connect THEN
			DrawTo(window,x,y)	{draw line to last point}
		ELSE	Plot(window,x,y);	{or plot point at the beginning}
		connect:=TRUE;
	END;
	
END;

{draw one of two possible tiles consisting of arcs}
PROCEDURE DrawTruchet(x,y : INTEGER;which : BOOLEAN);
BEGIN
	IF which THEN BEGIN
		DrawArc(x,y-size,3,4);
		DrawArc(x+2*size,y,1,2);
	END ELSE BEGIN
		DrawArc(x,y,0,1);
		DrawArc(x+2*size,y-size,2,3);
	END;
END;

BEGIN

	InitGraphics;	{setup gfx system}
	SelfSeed;	{setup random generator}

	{open a window}	
	window:=OpenScreenWindow(NIL,0,0,640,200,2+4+8,"CircleMaze");
	
	IF window<>NIL THEN BEGIN
		Color(window,1);	{choose color}

		FOR y:=0 TO (200 DIV size) DO BEGIN
			FOR x:=0 TO (640 DIV (size*2)) DO BEGIN

				IF RangeRandom(1)=0 THEN
					DrawTruchet(x*size*2,y*size,FALSE)
				ELSE	DrawTruchet(x*size*2,y*size,TRUE);								
			END;
		END;
		
		WaitForClose(window);	{wait until user closes the window}
		CloseAWindow(window);	{close it}
	END;
	
	ExitGraphics;			{cleanup gfx system}
END.
