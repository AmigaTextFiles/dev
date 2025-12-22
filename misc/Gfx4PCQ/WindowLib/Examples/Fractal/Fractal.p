PROGRAM Fractal;
{A fractal drawing demonstration program for THOR's windowlib.
 © 1997 THOR-Software inc.}
{$I "include:utils/windowlib.i"}
	

CONST
	maxlevel	=	10;		{maximal level of iterations}
	
TYPE
	AffineMapping	=	RECORD		{a general affine mapping: matrix plus shift}
		LinearMapping	:	ARRAY[1..2,1..2] OF REAL;
		Movement	:	ARRAY[1..2] OF REAL;
	END;
	
	Point		=	RECORD		{a pair of coordinates}
		x		:	REAL;
		y		:	REAL;
	END;
	
	
VAR
	maps			:	ARRAY[1..4] OF AffineMapping;	
			{we need for maps for these}

	level			:	INTEGER;
	window			:	WindowPtr;	
			{where to display}

	base			:	Point;
	
	

{apply the affine mapping to the point}	
PROCEDURE MapPoint(m : AffineMapping;VAR p : Point);
BEGIN
	p.x:=p.x*m.LinearMapping[1][1]+p.y*m.LinearMapping[1][2]+m.Movement[1];
	p.y:=p.x*m.LinearMapping[2][1]+p.y*m.LinearMapping[2][2]+m.Movement[2];
END;

{draw a point. Scale it.}
PROCEDURE PlotPoint(w : WindowPtr;p : Point);
BEGIN
	Color(w,1);				{define color}
	Plot(w,p.x*24+320,-p.y*12+180);		{plot pixel}
END;

{iterate a point}
PROCEDURE Iterate(p : Point);
VAR
	psave		:	Point;
	
BEGIN
	level:=level+1;
	IF level>=maxlevel THEN
		PlotPoint(window,p)
	ELSE BEGIN
		psave:=p;
		MapPoint(maps[1],psave);
		Iterate(psave);
		
		psave:=p;
		MapPoint(maps[2],psave);
		Iterate(psave);
		
		psave:=p;
		MapPoint(maps[3],psave);
		Iterate(psave);
		
		psave:=p;
		MapPoint(maps[4],psave);
		Iterate(psave);
	END;
	
	level:=level-1;
END;


{the main program}
BEGIN
	InitGraphics;		{setup gfx system}
	
				{setup the maps}
	WITH maps[1] DO BEGIN
		LinearMapping[1][1]:=0.0;
		LinearMapping[1][2]:=0.0;
		LinearMapping[2][1]:=0.0;
		LinearMapping[2][2]:=0.17;
		Movement[1]:=0.0;
		Movement[2]:=0.0;
	END;

	WITH maps[2] DO BEGIN
		LinearMapping[1][1]:=0.84962;
		LinearMapping[1][2]:=0.0255;
		LinearMapping[2][1]:=-0.0255;
		LinearMapping[2][2]:=0.84962;
		Movement[1]:=0.0;
		Movement[2]:=3.0;
	END;


	WITH maps[3] DO BEGIN
		LinearMapping[1][1]:=-0.1554;
		LinearMapping[1][2]:=0.234;
		LinearMapping[2][1]:=0.19583;
		LinearMapping[2][2]:=0.18648;
		Movement[1]:=0.0;
		Movement[2]:=1.2;
	END;

	
	WITH maps[4] DO BEGIN
		LinearMapping[1][1]:=0.1554;
		LinearMapping[1][2]:=-0.235;
		LinearMapping[2][1]:=0.19583;
		LinearMapping[2][2]:=0.18648;
		Movement[1]:=0.0;
		Movement[2]:=3.0;
	END;

	{open a window on the workbench}	
	window:=OpenScreenWindow(NIL,0,0,640,200,2+4+8,"Fractal Generator");
	IF window<>NIL THEN BEGIN
		Color(window,1);	{choose color}
		base.x:=0.0;
		base.y:=0.0;
		level:=0;
		Iterate(base);
		
		WaitForClose(window);	{wait until user closes the window}
		CloseAWindow(window);	{shut down}
	END;
	
	ExitGraphics;			{cleanup gfx system}
END.				

