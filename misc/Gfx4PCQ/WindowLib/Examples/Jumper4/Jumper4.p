PROGRAM Jumper;
{Another fractal generator for the windowlib. Looks somehow like the
 windooze 95 logo (windoofs for germans :-)
 © 1997 THOR - Software}

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

	{tell windowlib we want to hear close window events}
	RequestStart(window,CLOSEWINDOW_f);
	REPEAT	
		Plot(window,x*8+320,100-y*4);	{plot a point}

		{the iteration procedure}
		tmp:=y-SIN(x);
		y:=a-x;
		x:=tmp;
		{repeat until a request arrives}
	UNTIL NextRequest(window)=CLOSEWINDOW_f;
	
END;
	
BEGIN
	InitGraphics;			{init the gfx system}
	
	{open a window on the WB}
	window:=OpenScreenWindow(NIL,0,0,640,200,2+4+8,"Jumper");
	
	IF window<>NIL THEN BEGIN
		a:=3.1415;
		
		Color(window,1);	{choose pen}		
		
		Jumper(window);		{draw it}
		
		CloseAWindow(window);	{close the window}
	END;


	ExitGraphics;			{cleanup the gfx system}
END.