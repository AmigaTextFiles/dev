PROGRAM Liss;
{This program draws so called Lissajous figures you get if you superpose
 the movement of two independent pendulums. 
 The parameters of these pendulums can be setup by the sliders on the screen.
 Another fine demonstration program for THOR's windowlib.
 © 1997 THOR Software}

{Include windowlib, and strings.}
{$I "include:utils/windowlib.i"}	
{$I "include:utils/stringlib.i"}
	

VAR
	window		:	WindowPtr;
	gadn,gadm	:	GadgetPtr;
	gaddelta	:	GadgetPtr;
	msg		:	INTEGER;
	

{this program draws the figure, giving the two frequencies and the
 phase delta between them}
PROCEDURE DrawFigure(n,m : INTEGER; delta : REAL);
VAR	i	:	INTEGER;
VAR	x,y	:	REAL;
VAR	fac	:	REAL;
VAR	connect	:	BOOLEAN;

BEGIN
	connect:=FALSE;
	fac:=3.141592654/180;
	
	FOR i:=0 TO 360 DO BEGIN
		x:=200.0*cos(i*n*fac)+320.0;
		y:=100.0*sin((i+delta)*m*fac)+120.0;
		IF NOT connect THEN
			Plot(window,x,y)	{either plot the starting point}
		ELSE
			DrawTo(window,x,y);	{or draw a line to the last point}
		connect:=TRUE;
	END;
	
END;

{draw an integer value to the screen}
PROCEDURE PrintInt(w : WindowPtr;x,y : INTEGER;value : INTEGER);
VAR
	buf	:	ARRAY [0..15] OF CHAR;
	dummy	:	INTEGER;
	
BEGIN
	dummy:=IntToStr(@buf,value);	{convert the integer to a string}
	Position(window,x,y);		{setup position where to plot the text}
	DrawText(window,@buf);		{draw the ASCII version of the number}
END;

{the main program}
BEGIN
	InitGraphics;	{setup gfx system}
	
	{open a window on the WB screen}
	window:=OpenScreenWindow(NIL,0,0,640,240,2+4+8,"Lissajous figures");
	Color(window,1);	{choose color}

	{now create two sliders. The arguments are x and y position
 	 width and height and a flag beeing FALSE for horizontal freedom
	 or TRUE for vertical freedom.}
	gadn:=CreateSlider(window,4,10,100,8,FALSE);
	gadm:=CreateSlider(window,4,30,100,8,FALSE);
	gaddelta:=CreateSlider(window,4,50,100,8,FALSE);

	{Setup the values for the sliders. They are number of items in a list,
	 number of items visible at once (here one) and the actual position
	 in a list}
	SetSlider(gadn,10,1,0);
	SetSlider(gadm,10,1,0);
	SetSlider(gaddelta,180,1,0);
	
	{tell windowlib we want to receive if the user either want to
	 shut down or releases one of our sliders}
	RequestStart(window,CLOSEWINDOW_f OR GADGETUP_f);
	REPEAT
		ClearWindow(window);	{clear window}
		RefreshButton(gadn);	{redraw sliders}
		RefreshButton(gadm);
		RefreshButton(gaddelta);
		
		{reprint the position of the sliders}				
		PrintInt(window,110,16,FirstFromSlider(gadn)+1);
		PrintInt(window,110,36,FirstFromSlider(gadm)+1);
		PrintInt(window,110,56,FirstFromSlider(gaddelta));
	
		{draw the figure, reading the current position of the
		 sliders}
		DrawFigure(FirstFromSlider(gadn)+1,FirstFromSlider(gadm)+1,FirstFromSlider(gaddelta));

		{wait until the user does some action, either closing the
		 window or playing with the sliders}	
		msg:=WaitRequest(window);
	UNTIL msg=CLOSEWINDOW_f;		

	{we don't need any request now. Actually, there's no need to
	 tell this windowlib explicitly since we shut down anyways...
	 At least it is good style}
	RequestEnd(window,CLOSEWINDOW_f OR GADGETUP_f);

	{close the window}
	CloseAWindow(window);

	ExitGraphics;		{shutdown gfx system}
END.
