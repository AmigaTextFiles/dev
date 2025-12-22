PROGRAM Jumper;
{Another fractal generator for the windowlib
 © 1997 THOR-Software}

{$I "Include:Utils/windowlib.i"}
	
VAR
	a,b,c	:	REAL;
	
	window	:	WindowPtr;

{The iteration process}	
PROCEDURE Jumper(window : WindowPtr);
VAR
	x,y	:	REAL;
	tmp	:	REAL;
	i	:	INTEGER;
BEGIN
	
	x:=0;
	y:=0;

	{tell windowlib we want to hear if the user shuts down}
	RequestStart(window,CLOSEWINDOW_f);
	REPEAT	
		Plot(window,x*96+320,110-y*48);	{plot a point}

		{the iteration formula}
		tmp:=SQRT(ABS(b*x-c));
		IF x=0 THEN
			tmp:=y
		ELSE BEGIN
			IF x>0 THEN
				tmp:=y-tmp
			ELSE	tmp:=y+tmp
		END;
		y:=a-x;
		x:=tmp;
		{repeat until user shuts down}
	UNTIL NextRequest(window)=CLOSEWINDOW_f;
	
END;
	
BEGIN
	InitGraphics;		{setup gfx}
	
	{open window}
	window:=OpenScreenWindow(NIL,0,0,640,200,2+4+8,"Jumper");
	
	IF window<>NIL THEN BEGIN
		a:=0.4;
		b:=1.0;
		c:=0.0;
		
		Color(window,1);	{choose pen}
		
		Jumper(window);		{draw it}
		
		CloseAWindow(window);	{close window}
	END;


	ExitGraphics;			{cleanup gfx system}
END.
