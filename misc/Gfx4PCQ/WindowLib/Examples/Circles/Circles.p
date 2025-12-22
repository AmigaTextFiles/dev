PROGRAM Circles;
{ A tiny demonstration program for THOR's windowlib.
  © 1997 THOR Software}

{$I "Include:utils/windowlib.i"}
{$I "Include:utils/random.i"}
	
	
CONST
	pi		=	3.14159326;
	radius		=	4;
	size		=	8;
	dist		=	(1+1.1415)*radius;
	
	
VAR
	window		:	WindowPtr;
	x,y		:	INTEGER;
	i,j		:	INTEGER;
	
	
BEGIN

	InitGraphics;	{ Setup gfx system }
	
	{ Open a window on the WB screen}
	window:=OpenScreenWindow(NIL,0,0,640,200,2+4+8,"Circles");
	
	IF window<>NIL THEN BEGIN
		Color(window,1);	{ Choose pen }

		x:=0;
		y:=0;
		
		FOR i:=0 TO 19 DO BEGIN
			IF ODD(i) THEN
				x:=0
			ELSE	x:=dist;
			
			FOR j:=0 TO 64 DO BEGIN
				{ Draw ellipse }
				Ellipse(window,x,y,radius,radius);
				x:=x+radius+dist
			END;
			y:=y+radius+dist
		END;
		
		WaitForClose(window);	{ Wait until user closes the window }
		CloseAWindow(window);	{ Close it }
	END;
	
	ExitGraphics;	{ Shut down graphics system }
END.