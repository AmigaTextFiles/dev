PROGRAM Fractal;
{A fractal drawing demonstration program for THOR's windowlib
 © 1997 THOR Software}

{$I "include:utils/windowlib.i"}
	
CONST
	maxlevel	=	10;	{maximal level of iterations}
	
TYPE
	{an affine mapping: apply matrix plus shift}
	AffineMapping	=	RECORD
		LinearMapping	:	ARRAY[1..2,1..2] OF REAL;
		Movement	:	ARRAY[1..2] OF REAL;
	END;
	
	{a point in space}
	Point		=	RECORD
		x		:	REAL;
		y		:	REAL;
	END;
	
	
VAR
	maps			:	ARRAY[1..4] OF AffineMapping;
	level			:	INTEGER;
	window			:	WindowPtr;
	base			:	Point;
	
	
	
{apply mapping to a point}
PROCEDURE MapPoint(m : AffineMapping;VAR p : Point);
BEGIN
	p.x:=p.x*m.LinearMapping[1][1]+p.y*m.LinearMapping[1][2]+m.Movement[1];
	p.y:=p.x*m.LinearMapping[2][1]+p.y*m.LinearMapping[2][2]+m.Movement[2];
END;

{plot a point}
PROCEDURE PlotPoint(w : WindowPtr;p : Point);
BEGIN
	Color(w,1);				{choose pen}
	Plot(w,p.x*384+120,-p.y*192+180);	{scale & plot the point}
END;

{iterate down the tree}
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


{main program}
BEGIN
	InitGraphics;			{setup the gfx system}
	
	{setup the mapping}
	WITH maps[1] DO BEGIN
		LinearMapping[1][1]:=0.64987;
		LinearMapping[1][2]:=-0.013;
		LinearMapping[2][1]:=0.013;
		LinearMapping[2][2]:=0.64987;
		Movement[1]:=0.175;
		Movement[2]:=0.0;
	END;

	WITH maps[2] DO BEGIN
		LinearMapping[1][1]:=0.64948;
		LinearMapping[1][2]:=-0.026;
		LinearMapping[2][1]:=0.026;
		LinearMapping[2][2]:=0.64948;
		Movement[1]:=0.165;
		Movement[2]:=0.325;
	END;


	WITH maps[3] DO BEGIN
		LinearMapping[1][1]:=0.3182;
		LinearMapping[1][2]:=-0.3182;
		LinearMapping[2][1]:=0.3182;
		LinearMapping[2][2]:=0.3182;
		Movement[1]:=0.2;
		Movement[2]:=0.0;
	END;

	
	WITH maps[4] DO BEGIN
		LinearMapping[1][1]:=-0.3182;
		LinearMapping[1][2]:=0.3182;
		LinearMapping[2][1]:=0.3182;
		LinearMapping[2][2]:=0.3182;
		Movement[1]:=0.8;
		Movement[2]:=0.0;
	END;
	
	{open a window}
	window:=OpenScreenWindow(NIL,0,0,640,200,2+4+8,"Fractal Generator");
	IF window<>NIL THEN BEGIN
		Color(window,1);		{choose pen}
		base.x:=0.0;
		base.y:=0.0;
		level:=0;
		Iterate(base);			{draw the stuff}
		
		WaitForClose(window);		{wait until user closes}
		CloseAWindow(window);		{close the window}
	END;
	
	ExitGraphics;				{cleanup gfx system}
END.				
