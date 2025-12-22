PROGRAM Jumper;
{Another fractal demonstration program, to demonstrate the features of
 THOR's windowlib.
 © 1997 THOR Software.}

{$I "Include:Utils/windowlib.i"}
	
VAR
	a,b,c	:	REAL;
	window	:	WindowPtr;	{the pointer to a window}
	

{this procedure iterates the fractal}
PROCEDURE Jumper(window : WindowPtr);
VAR
	x,y	:	REAL;		{position}
	tmp	:	REAL;
	i	:	INTEGER;
BEGIN
	
	x:=0;
	y:=0;

	{tell windowlib we want to get informed if the user wants to shut down}
	RequestStart(window,CLOSEWINDOW_f);
	REPEAT	
		Plot(window,x+400,32-y/2);	{plot the point}

						{the iteration procedure}
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
		{repeat until we know the user shuts down}
	UNTIL NextRequest(window)=CLOSEWINDOW_f;
	
END;
	
BEGIN
	InitGraphics;	{setup gfx system}
	
	{create a window on WB}
	window:=OpenScreenWindow(NIL,0,0,640,200,2+4+8,"Jumper");
	
	IF window<>NIL THEN BEGIN
		a:=-200.0;
		b:=0.1;
		c:=-80;
		
		Color(window,1);	{choose pen}
		
		Jumper(window);		{draw it!}
		
		CloseAWindow(window);	{close the window}
	END;


	ExitGraphics;			{cleanup gfx}
END.
