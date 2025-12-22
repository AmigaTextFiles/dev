PROGRAM Jumper;
{Another fractal generator for THOR's windowlib.
 © 1997 THOR - Software}

{$I "Include:Utils/windowlib.i"}
	
VAR
	a,b,c	:	REAL;
	
	window	:	WindowPtr;

{The iterator}	
PROCEDURE Jumper(window : WindowPtr);
VAR
	x,y	:	REAL;
	tmp	:	REAL;
	i	:	INTEGER;
BEGIN
	
	x:=0;
	y:=0;

	{Tell the windowlib we want to hear close window events}
	RequestStart(window,CLOSEWINDOW_f);
	REPEAT	
		Plot(window,x*32+320,64-y*16);

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
		{repeat until user presses the close gadget}
	UNTIL NextRequest(window)=CLOSEWINDOW_f;
	
END;
	
BEGIN
	InitGraphics;		{setup the gfx system}
	
	{open a window on the WB screen}
	window:=OpenScreenWindow(NIL,0,0,640,200,2+4+8,"Jumper");
	
	IF window<>NIL THEN BEGIN
		a:=-3.14;
		b:=0.3;
		c:=0.3;
		
		Color(window,1);	{choose pen}
		
		Jumper(window);		{draw it}
		
		CloseAWindow(window);	{close the window}
	END;


	ExitGraphics;			{cleanup the gfx}
END.
