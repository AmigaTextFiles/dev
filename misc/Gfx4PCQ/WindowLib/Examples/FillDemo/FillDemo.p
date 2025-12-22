Program FillDemo;

{ A sample program for PCQ, using fill patterns. © 1997 THOR-Software inc.}

{$I "Include:Utils/Windowlib.i"}

CONST
	fillarray	:	Array[0..1] of Short=
		($aaaa,$5555);
	{A monochrome fill pattern, a checkered style }

	multiarray	:	Array[0..3] of Short=
		($aaaa,$5555,$5555,$aaaa);
	{A colored fill pattern for a depth 2 screen, again checkered }
VAR
	w	:	WindowPtr;
	s	:	ScreenPtr;

BEGIN
	InitGraphics;

	s:=OpenAScreen(0,0,640,200,2,MON_HIRES,"FillDemo");
	IF s<>NIL THEN BEGIN
		w:=OpenScreenWindow(s,0,0,600,200,WINFLG_DRAGBAR+WINFLG_DEPTHGADGET+WINFLG_CLOSEGADGET,"FillTest");
		IF w<>NIL THEN BEGIN
			Color(w,1);		{select color}
			Boundary(w,TRUE);
			OlColor(w,2);		{enable boundary and set boundary color}
			SetFillPattern(w,@fillarray[0],1,1); {choose fill style. 
			Parameters are: Address of the first word in the array, the height as power of two
			and the depth. Only one or the screen depth (2 here) are allowed.} 
			PEllipse(w,300,100,160,80);	{draw filled ellipse}
			SetFillPattern(w,NIL,0,0);	{disable the pattern}
			Color(w,3);			{different color}
			PEllipse(w,100,100,50,25);	{again filled ellipse}
			SetFillPattern(w,@multiarray[0],1,2);	{this time a pattern of depth 2}
			PEllipse(w,500,100,50,25);	{another ellipse}	
			WaitForClose(w);		{we're done}
			CloseAWindow(w)
		END;
		CloseAScreen(s)
	END;

	ExitGraphics;
END.
